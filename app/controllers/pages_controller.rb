class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:intro, :discover]

  def profile
  end

  def mynanas
    @users = User.all
    @friends = current_user.friends
    @friends_requested = current_user.requested_friends
  end

  def accept_friend
    current_user.accept_request(User.find(params[:id]))
    redirect_to mynanas_path
  end

  def reject_friend
    current_user.decline_request(User.find(params[:id]))
    redirect_to mynanas_path
  end

  def nana_friend
    @favorite = Favorite.new
    @favorite.user_id = current_user.id
    @favorite.nana_id = User.find(params[:id])
    @favorite.save

     respond_to do |format|
        format.html { redirect_to mynanas_path }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
  end

  def nana_unfriend
    @favorite = Favorite.find_by(nana_id: params[:id])
    @favorite.destroy
  end

  def intro
  end

  def onboarding
  end

  def discover
  end

end
