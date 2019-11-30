class ProfilesController < ApplicationController
  def user_setting
    @user = current_user.find
  end

  def profile_management
    @user = current_user
  end

  def update_user
    flash[:error] = []
    puts (params)
    if current_user.update(update_params)
        flash[:edit_success] = "You have successfully edited your profile"
    else
      #### TODO: show errors ###
      flash[:error] << "Something went wrong"
    end
      redirect_to '/profile_management'  
  end 

  private
  def update_params
      params.require(:user).permit(:name, :email, :profile_picture)
  end
end
