class NotificationsMailer < ApplicationMailer
    default from: 'notifications@homegig.com'

    def notification
        email = params[:email]
        @description = params[:description]
        mail(to: email, subject: "HomeGig Notification")
    end

end
