class ProfilesController < ApplicationController
  def user_setting
    @user = current_user.find
  end

  def profile_management
    @user = current_user
  end

  def update_user
    flash[:error] = []
    puts (User.all.where("email":update_params[:email]).present?)
    if current_user.update(update_params)
        flash[:edit_success] = "You have successfully edited your profile"
    else
      if update_params[:name].size > 20 || update_params[:name].size < 3
        flash[:error] << "Your Username has to be in between 3 and 20 characters."
      end
      if update_params[:about].size > 200
        flash[:error] << "The About can have a maximum of 200 characters"
      end
      #User.find.where("email":update_params[:email]).present?
      if User.all.where("email":update_params[:email]).present?
        flash[:error] << "The Email is already in use"
      end
    end
      redirect_to '/profile_management'  
  end

  private
  def update_params
      params.require(:user).permit(:name, :email, :profile_picture, :about)
  end
end
