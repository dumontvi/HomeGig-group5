class Notification < ApplicationRecord
    belongs_to :from_user, class_name: "User"
    belongs_to :to_user, class_name: "User"
    belongs_to :notification_category
    belongs_to :post, optional: true
    belongs_to :spost, optional: true

    after_save :send_email_notification

    private
    def send_email_notification
        user = User.find(to_user_id)
        NotificationsMailer.with(email: user.email, description: description).notification.deliver_now
    end
end
