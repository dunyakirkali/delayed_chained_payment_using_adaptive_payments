require 'pp-adaptive'
require 'pry'
require 'launchy'
require 'colorize'
require 'yaml'

def run
  pry.binding
end

# Setup the Payment and return pay object
def setup_payment
  receiver = { email: 'tr-personal@gmail.com' }
  api.execute :Pay, payment_options(receiver)
end

# Redirect the Customer to PayPal for Authorization and return response
def redirect_to_paypal(response)
  if response.success?
    p "Pay key: #{response.pay_key}".green
    Launchy.open(api.payment_url(response))
  else
    p "#{response.ack_code}: #{response.error_message}".red
  end
end

# Retrieve Data about the Payment (Optional)
def retrieve_payment_data(pay_key)
  api.execute(:PaymentDetails, pay_key: pay_key) do |response|
    if response.success?
      p "Payment status: #{response.payment_exec_status}".green
    else
      p "#{response.ack_code}: #{response.error_message}".red
    end
    return response
  end
end

# Make a Payment to One or More Secondary Receivers
def make_payment_to_secondary(pay_key)
  api.pay pay_key
end

def payment_options(receiver)
  {
    action_type:    "PAY_PRIMARY",
    currency_code:  "USD",
    cancel_url:     "https://your-site.com/cancel",
    return_url:     "https://your-site.com/return",
    receivers:      [
      { email: "opotto@gmail.com", amount: 100, primary: true },
      { email: receiver[:email], amount: 90 }
    ]
  }
end

def api
  AdaptivePayments::Client.new(
    sandbox: true,
    app_id: 'APP-80W284485P519543T',
    user_id: 'opotto_api1.gmail.com',
    password: '5X4XVKF7XUV3TG9J',
    signature: 'AH6d1xBXrGOpE-RZEFdL.zYTFUW0ANeJL59zIFyiDm3ijpwFopvxNwW9'
  )
end

run
