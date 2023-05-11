class TidesController < ApplicationController
  def show
    @port             = Port.find(params[:id])
    @tides            = TideScraperService.new(@port.slug).call

    if params[:height].present?
      @latest_departure = TideCalculatorService.new(@tides, params[:height].to_f, current_user).call
      @tides = [@tides, @latest_departure].flatten.sort_by { |tide| tide.hour }
    end

  end
end
