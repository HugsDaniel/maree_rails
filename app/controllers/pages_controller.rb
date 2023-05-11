class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    if params[:query].present?
      @ports = Port.search_by_name(params[:query])
    else
      @ports = Port.all
    end
  end
end
