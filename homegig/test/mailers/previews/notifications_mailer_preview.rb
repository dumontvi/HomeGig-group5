# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class NotificationsMailerPreview < ActionMailer::Preview
    def notification
        NotificationsMailer.with(email: 'mytest@test.com', description: 'Test email').notification
    end
end
