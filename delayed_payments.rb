require 'paypal-sdk-adaptivepayments'
require 'pry'
require 'launchy'
require 'colorize'

def run
  pry.binding
end

# Setup the Payment and return pay object
def setup_payment
  receiver = { email: 'tr-personal@gmail.com' }
  api.build_pay(payment_options(receiver))
end

# Redirect the Customer to PayPal for Authorization and return response
def redirect_to_paypal(pay)
  response = api.pay(pay)
  if response.success? && response.payment_exec_status != 'ERROR'
    puts 'success'.green
  else
    puts response.error[0].message.red
  end
  response
end

# Retrieve Data about the Payment (Optional)
def retrieve_payment_data
end

# Make a Payment to One or More Secondary Receivers
def make_payment_to_secondary(pay_key)
  # api.build_pay(payment_options(receiver))
end

def payment_options(receiver)
  {
    actionType: 'PAY_PRIMARY',
    currencyCode: 'USD',
    feesPayer: 'EACHRECEIVER',
    receiverList: {
      receiver: [
        {
          amount:    25.00,
          email:     receiver[:email],
          primary:   false
        },
        {
          amount:    25.00 * 0.01,
          email:     'opotto@gmail.com',
          primary:   true
        }
      ]
    },
    returnUrl: 'http://www.yourdomain.com/success.html',
    cancelUrl: 'http://www.yourdomain.com/cancel.html'
  }
end

def api
  PayPal::SDK.load('paypal.yml', 'development')
  PayPal::SDK::AdaptivePayments::API.new
end

run
