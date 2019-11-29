class NotificationsController < ApplicationController
    before_action :authenticate_user!
    helper_method :notifications

    def notifications
        @notifications = Notification.where(["to_user_id = ? and checked = false", "#{current_user.id}"]).order(created_at: :desc)
    end

    def notify_offering_interest
        post = Post.find(params[:id])
        category = NotificationCategory.find_by(name: 'Interest')
        if post and category and post.user.id != current_user.id
            Notification.create(from_user: current_user,
                                to_user: post.user,
                                description: "#{current_user.email} is interested in your gig #{post.title}",
                                post: post,
                                notification_category: category,
                                checked: false)
        end
    end

    def notify_seeking_interest
        spost = Spost.find(params[:id])
        category = NotificationCategory.find_by(name: 'Interest')
        if spost and category and spost.user.id != current_user.id
            if current_user.stripe_user_id
                Notification.create(from_user: current_user,
                                    to_user: spost.user,
                                    description: "#{current_user.email} is interested in your gig #{spost.title}",
                                    spost: spost,
                                    notification_category: category,
                                    checked: false)
                flash[:notice] = "You have sent a request to the gig's owner"
            else
                flash[:notice] = "You need to register to Stripe in order to receive payments"
                redirect_to seeking_path(spost)
            end
        end
    end

    def approve
        notification = Notification.find(params[:id])
        category = NotificationCategory.find_by(name: 'Approval')
        if notification and category
            if current_user.stripe_user_id
                # Mark current as read
                notification.update(checked: true)

                # Send approval for payment to person interested in gig
                Notification.create(from_user: current_user,
                                    to_user: notification.from_user,
                                    description: "#{current_user.email} has approved your request for gig #{notification.post.title}",
                                    post: notification.post,
                                    notification_category: category,
                                    checked: false)
                flash[:notice] = "You have approved payment for this gig"
            else
                flash[:notice] = "You need to register to Stripe in order to receive payments"
            end
        end
        redirect_to notifications_path 
    end

    def acknowledge_all
        notifications = Notification.where(to_user: current_user)   
        if notifications
            notifications.update(checked: true)
        end
        redirect_to notifications_path     
    end
 
end