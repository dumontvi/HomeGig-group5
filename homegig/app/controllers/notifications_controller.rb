class NotificationsController < ApplicationController
    before_action :authenticate_user!

    def notifications
        @notifications = Notification.where(["to_user_id = ? and checked = false", "#{current_user.id}"]).order(created_at: :desc)
    end

    def notify_interest
        post = Post.find(params[:id])
        if post
            Notification.create(from_user: current_user,
                                to_user: post.user,
                                description: "#{current_user.email} is interested in your gig #{post.title}",
                                checked: false)
        end
    end
 
end