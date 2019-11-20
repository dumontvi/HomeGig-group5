class RegistrationsController < Devise::RegistrationsController
    
    private
    
    def sign_up_params
        params.require(:user).permit( :name, 
                                      :email, 
                                      :password, 
                                      :password_confirmation,
                                      :profile_picture)
    end
    
    def account_update_params
        params.require(:user).permit( :name, 
                                      :email, 
                                      :password, 
                                      :password_confirmation, 
                                      :profile_picture,
                                      :current_password)
    end
end