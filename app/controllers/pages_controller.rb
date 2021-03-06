class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:intro]

  def profile
  end

  def your_profile
    @user = User.find(params[:id])

    my_coordinates = current_user.address
    nana_coordinates = @user.address

    @distance = Geocoder::Calculations.distance_between(my_coordinates, nana_coordinates).round(0)

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

  def accept_friend_profile
    current_user.accept_request(User.find(params[:id]))
    redirect_to your_profile_path(User.find(params[:id]))
  end

  def reject_friend_profile
    current_user.decline_request(User.find(params[:id]))
    redirect_to your_profile_path(User.find(params[:id]))
  end

  def unfriend
    current_user.remove_friend(User.find(params[:id]))
    redirect_to your_profile_path(User.find(params[:id]))
  end

  def request_friend
    current_user.friend_request(User.find(params[:id]))
    redirect_to your_profile_path(User.find(params[:id]))
  end

  def cancel_friend_request
    potential_friend = User.find(params[:id])
    friend_request = potential_friend.friendships.find_by(friend_id: current_user.id)
    friend_request.destroy
    friend_request = current_user.friendships.find_by(friend_id: potential_friend.id)
    friend_request.destroy
    redirect_to your_profile_path(potential_friend)
  end

  def nana_friend
    @favorite = Favorite.new
    @favorite.user = current_user
    @favorite.nana = User.find(params[:id].to_i)
    if @favorite.save
     respond_to do |format|
        format.html { redirect_to mynanas_path }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    end
  end

  def nana_unfriend
    @favorite = Favorite.find_by(nana_id: params[:id])
    @favorite.destroy
    respond_to do |format|
        format.html { redirect_to mynanas_path }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
    end

  end

  def intro
  end

  def onboarding
  end

  def discover
  end

  def show_nanas_nearby
    friends_ids = current_user.friends.pluck(:id)
    friends_ids.push(current_user.id)
    @users_nearby = User.near(current_user.address, 20).where.not(id: friends_ids).sample(5)
    @users_nearby.each { |user| user.distance_from_you = Geocoder::Calculations.distance_between([current_user.latitude, current_user.longitude], [user.latitude, user.longitude]).round(0)}
    respond_to do |format|
        format.js  # <-- will render `app/views/reviews/create.js.erb`
    end
  end

end
