class Donation < ApplicationRecord

#after_create_commit :save_card_details
belongs_to :user
 validates :amount, presence: true
# def find_customer
#   if self.stripe_token
#     retrieve_customer(user.stripe_token)
#   else
#     create_customer
#   end
#   end

def save_card_details(source, customer,user_id)
    
@carddetails = Stripe::Customer.retrieve_source(customer, source)
@savecard = ChargeCard.create(user_id: user_id, card_id: source,last_4: @carddetails.last4, exp_month: @carddetails.exp_month,exp_year: @carddetails.exp_year,card_type: @carddetails.brand)

  end

end
