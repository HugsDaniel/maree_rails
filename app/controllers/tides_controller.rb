class TidesController < ApplicationController
  def show
    @port             = Port.find(params[:id])
    @tides            = TideScraperService.new(@port.name).call
    @latest_departure = TideCalculatorService.new(@tides, @port, current_user).call
  end
end
