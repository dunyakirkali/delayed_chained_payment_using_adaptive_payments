# Adaptive Payments

    ruby delayed_payments.rb
    payment = setup_payment
    response = redirect_to_paypal(payment)
    result = make_payment_to_secondary(payment)