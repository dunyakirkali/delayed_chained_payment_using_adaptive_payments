require 'pry'
require 'launchy'

def run
  pry.binding
  setup_payment
  redirect_to_paypal
  retrieve_payment_data
  make_payment_to_secondary
end

# Set Up the Payment
def setup_payment

end

# Redirect the Customer to PayPal for Authorization
def redirect_to_paypal(url)
  Launchy.open(url)
end

# Retrieve Data about the Payment (Optional)
def retrieve_payment_data

end

# Make a Payment to One or More Secondary Receivers
def make_payment_to_secondary

end

run