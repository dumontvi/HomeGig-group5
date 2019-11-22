class StripeController < ApplicationController
  before_action :authenticate_user!

  def register
  end

  def pay
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

  def create_checkout_session
    session = Stripe::Checkout::Session.create({
      customer_email: current_user.email,
      payment_method_types: ['card'],
      line_items: [{
        name: "Cucumber from Roger's Farm",
        amount: 200,
        currency: 'cad',
        quantity: 10,
      }],
      payment_intent_data: {
        application_fee_amount: 2,
        transfer_data: {
          destination: 'acct_1FfgnaG0y6BjsyVD',
        },
      },
      success_url: 'http://localhost:3000/stripe/success?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: 'http://localhost:3000/about',
    })
    render json: session
  end

  def success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    payment_intent = Stripe::PaymentIntent.retrieve(session['payment_intent'])
    create_payment_notification(session, payment_intent)
  end


  private

  def create_payment_notification(session, payment_intent)
      post_name = session['display_items'][0]['custom']['name']
      amount = payment_intent['amount']
      fee = payment_intent['application_fee_amount']
      destination = payment_intent['transfer_data']['destination']
      discounted_amount = amount/100.0 - fee/100.0

      users = User.where(["stripe_user_id = ?", destination])
      if users.size == 1
        Notification.create(from_user: current_user,
                            to_user: users[0],
                            description: "#{current_user.email} has deposited you #{discounted_amount} CAD for your gig #{post_name}",
                            checked: false)
      end
  end
end