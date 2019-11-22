Rails.configuration.stripe = {
    :publishable_key => Rails.application.credentials.stripe[Rails.env.to_sym][:publishable_key],
    :secret_key      => Rails.application.credentials.stripe[Rails.env.to_sym][:secret_key],
    :client_id       => Rails.application.credentials.stripe[Rails.env.to_sym][:client_id]
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]