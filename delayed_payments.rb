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
  PayPal::SDK.load('paypal.yml',  ENV['RACK_ENV'] || 'development')
  api ||= PayPal::SDK::AdaptivePayments::API.new
  pay = api.build_pay(payment_options)
  response = api.pay(pay)
  response.success? && response.payment_exec_status != 'ERROR'
end

# Redirect the Customer to PayPal for Authorization
def redirect_to_paypal(url)
  Launchy.open(url)
end

# Retrieve Data about the Payment (Optional)
def retrieve_payment_data

end

# Make a Payment to One or More Secondary Receivers
def make_payment_to_secondary(pay_key)

end

def payment_options
  {
    actionType: PAY_PRIMARY
    currencyCode: USD
    feesPayer: EACHRECEIVER
    receiverList: {
      receiver: [
        {
          amount:    25.00,
          email:     'onurkucukkece-buyer@gmail.com',
          primary:   false
        },
        {
          amount:    25.00 * 0.01,
          email:     'dunyakirkali-buyer@yahoo.fr',
          primary:   true
        }
      ]
    }
    requestEnvelope: errorLanguage=en_US
    returnUrl: 'http://www.yourdomain.com/success.html'
    cancelUrl: 'http://www.yourdomain.com/cancel.html'
  }
end

run
