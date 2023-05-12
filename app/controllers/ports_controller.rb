class PortsController < ApplicationController
  def index
    if params[:query].present?
      @ports = Port.search_by_name(params[:query])
    else
      @ports = Port.all
    end

    @favorites = current_user.favorites.order(id: :asc) if user_signed_in?

    respond_to do |format|
      format.html
      format.text { render @ports, formats: [:html] }
    end
  end

  def show
    @port     = Port.find(params[:id])
    @tides    = TideScraperService.new(@port.slug).call

    @favorite = Favorite.find_by(port: @port, user: current_user)

    if @favorite.present?
      @latest_departure = TideCalculatorService.new(@tides, @favorite.height, current_user).call
    end

    if params[:height].present?
      @latest_departure = TideCalculatorService.new(@tides, params[:height].to_f, current_user).call
    end

    if params[:height].present? || @favorite.present?
      @tides = [@tides, @latest_departure].flatten.sort_by { |tide| tide.hour }
    end

  end
end
