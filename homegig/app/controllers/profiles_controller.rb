class ProfilesController < ApplicationController
  def user_setting
    @user = current_user.find
  end

  def profile_management
    @user = current_user
  end
end