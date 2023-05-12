class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    if params[:query].present?
      @ports = Port.search_by_name(params[:query])
    else
      @ports = Port.all
    end

    @favorites = current_user.ports if user_signed_in?
  end
end
