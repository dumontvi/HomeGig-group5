class StripeController < ApplicationController

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
          destination: 'acct_1FfGhOLBEbUcxKUE',
        },
      },
      success_url: 'http://localhost:3000',
      cancel_url: 'http://localhost:3000/about',
    })
    render json: session
  end

end