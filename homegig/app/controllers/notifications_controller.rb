class NotificationsController < ApplicationController
    before_action :authenticate_user!

    def notify_interest
        post = Post.find(params[:id])
        if post
            Notification.create(from_user: current_user,
                                to_user: post.user,
                                description: "#{current_user.email} is interested in your post",
                                checked: false)
        end

    end
 
end