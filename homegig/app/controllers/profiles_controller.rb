class ProfilesController < ApplicationController
  def user_setting
    @user = current_user.find
  end

  def profile_management
  end
end
