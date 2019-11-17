Rails.configuration.stripe = {
    :publishable_key => Rails.application.credentials.stripe[:development][:publishable_key],
    :secret_key      => Rails.application.credentials.stripe[:development][:secret_key],
    :client_id       => Rails.application.credentials.stripe[:development][:client_id]
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]