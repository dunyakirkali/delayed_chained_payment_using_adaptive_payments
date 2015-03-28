require 'paypal-sdk-adaptivepayments'
require 'pry'
require 'launchy'
require 'colorize'
def run
  pry.binding
  setup_payment
  redirect_to_paypal
  retrieve_payment_data
  make_payment_to_secondary
end

# Set Up the Payment
def setup_payment
  PayPal::SDK.load('paypal.yml', 'development')
  api = PayPal::SDK::AdaptivePayments::API.new
  receiver = {
    email: 'tr-personal@gmail.com'
  }
  pay = api.build_pay(payment_options(receiver))
  response = api.pay(pay)
  if response.success? && response.payment_exec_status != 'ERROR'
    puts 'success'.green
  else
    puts 'error'.red
  end
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

run
