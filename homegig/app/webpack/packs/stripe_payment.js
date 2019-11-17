/* Handle any errors returns from Checkout  */
var handleResult = function(result) {
  if (result.error) {
    var displayError = document.getElementById("error-message");
    displayError.textContent = result.error.message;
  }
};

// Create a Checkout Session with the selected quantity
var createCheckoutSession = async function(stripe) {
  const result = await fetch("/stripe/create_checkout_session");
  return result.json();
};

/* Get your Stripe publishable key to initialize Stripe.js */
fetch("/stripe/public_key")
  .then(function(result) {
    return result.json();
  })
  .then(function(json) {
    window.config = json;
    var stripe = Stripe(config.public_key);
    // Setup event handler to create a Checkout Session on submit
    document.querySelector("#submit").addEventListener("click", function(evt) {
      createCheckoutSession().then(function(session) {
        stripe
          .redirectToCheckout({
            sessionId: session.id
          })
          .then(handleResult);
      });
    });
  });