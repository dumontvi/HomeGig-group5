class ApplicationController < ActionController::Base
    helper_method :number_of_unread_notifications

    def number_of_unread_notifications
        Notification.where(["to_user_id = ? and checked = false", "#{current_user.id}"]).order(created_at: :desc).size
    end
end
