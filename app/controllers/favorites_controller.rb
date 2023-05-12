class FavoritesController < ApplicationController
  def create
    @favorite      = Favorite.new(favorite_params)

    @favorite.port = Port.find(params[:port_id])
    @favorite.user = current_user

    @favorite.save
    redirect_to port_path(@favorite.port), notice: "Ajouté aux favoris"
  end

  private

  def favorite_params
    params.require(:favorite).permit(:height)
  end
end
