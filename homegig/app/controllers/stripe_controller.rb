class StripeController < ApplicationController
  before_action :authenticate_user!

  def register
  end

  def error
  end

  def connect
    response = HTTParty.post("https://connect.stripe.com/oauth/token",
      query: {
        client_secret: Stripe.api_key,
        code: params[:code],
        grant_type: "authorization_code"
      }
    )

    if response.parsed_response.key?("error")
      redirect_to stripe_register_path,
        notice: response.parsed_response["error_description"]
    else
      stripe_user_id = response.parsed_response["stripe_user_id"]
      current_user.update_attribute(:stripe_user_id, stripe_user_id)

      redirect_to stripe_register_path,
        notice: 'User successfully connected with Stripe!'
    end
  end

  def public_key
    render json: {public_key: Rails.configuration.stripe[:publishable_key]}
  end

  def success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    payment_intent = Stripe::PaymentIntent.retrieve(session['payment_intent'])
    @receipt_url = payment_intent['charges']['data'][0]['receipt_url']
    create_payment_notification(session, payment_intent)
    hide_current_user_payment_notification(params[:notification_id])
  end

  def checkout_session
    notification = Notification.find(params[:notificationId])
    if notification 
      if notification.post
        post = Post.find(notification.post.id)
      else
        post = Spost.find(notification.spost.id)
      end
      session = create_checkout_session(post, notification)
      render json: session
    end  
  end

  private

  def create_checkout_session(post, notification)
    session = Stripe::Checkout::Session.create({
      customer_email: current_user.email,
      payment_method_types: ['card'],
      line_items: [{
        name: post.title,
        amount: (post.price * 100).round,
        currency: 'cad',
        quantity: 1,
      }],
      payment_intent_data: {
        application_fee_amount: 5,
        transfer_data: {
          destination: notification.from_user.stripe_user_id,
        },
        receipt_email: current_user.email,
      },
      success_url: "#{stripe_success_url}?session_id={CHECKOUT_SESSION_ID}&notification_id=#{notification.id}",
      cancel_url: "#{stripe_error_url}",
    })
  end

  def create_payment_notification(session, payment_intent)
    post_name = session['display_items'][0]['custom']['name']
    amount = payment_intent['amount']
    fee = payment_intent['application_fee_amount']
    destination = payment_intent['transfer_data']['destination']
    discounted_amount = amount/100.0 - fee/100.0

    user = User.find_by(stripe_user_id: destination)
    category = NotificationCategory.find_by(name: 'Payment')
    if user and category
      Notification.create(from_user: current_user,
                          to_user: user,
                          description: "#{current_user.email} has deposited you #{discounted_amount} CAD for your gig #{post_name}",
                          notification_category: category,
                          checked: false)
    end
  end

  def hide_current_user_payment_notification(notificationId)
    notification = Notification.find(notificationId)
    if notification
      notification.update(checked: true)
    end
  end

end