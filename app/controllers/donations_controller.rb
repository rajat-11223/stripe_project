class DonationsController < ApplicationController
  
  before_action :authenticate_user!, except: [:index]
  before_action :set_donation, only: [:show, :edit, :update, :destroy]
  
  # GET /donations
  # GET /donations.json
  def index  #User.includes(:designation).where.not(id: users_absent)
    if current_user.present?
    @donations = Donation.includes(:user).where(user_id: current_user.id)
  else
    @donations = Donation.all
  end
   # @donations = Donation.where(user_id: current_user.id)
  end

  # GET /donations/1
  # GET /donations/1.json
  def show
  end

  # GET /donations/new
  def new
   #byebug
    @donation = Donation.new
  end

  # GET /donations/1/edit
  def edit
  end

def proceed_donation

if params[:amount].present?
  @donation = Donation.new
  @amount = (params[:amount].to_i.round(2) * 100.to_i)

# @intent = Stripe::PaymentIntent.create(
            
#             :amount      => @amount.to_i,
#             :description => 'One-time Donation',
#             :currency    => 'usd'
#             ) 

#byebug

respond_to do |format|
   format.js 
end


end 
end  


def cretae


 end 

  # POST /donations
  # POST /donations.json
  def submit_donation

  if params[:payment_id].present? &&  params[:amount].present? && params[:payment_method].present?
   amount = (params[:amount].to_i.round(2) / 100.to_i)
     
  customer = Stripe::Customer.create(email: current_user.email )
  Stripe::PaymentIntent.update(params[:payment_id],customer: customer.id,)
  @intent = Stripe::PaymentMethod.retrieve(params[:payment_method]) 
  puts @intent

# if @intent.status == "requires_confirmation"

#     Stripe::PaymentIntent.confirm(@intent.id,{payment_method: @intent.payment_method})
# end 
   #byebug  
    @donation = Donation.new(user_id: current_user.id,amount: amount,charge_id: params[:payment_id])
    
    respond_to do |format|
           if @donation.save
           ChargeCard.create(user_id: current_user.id, card_id: @intent.id,last_4: @intent[:card].last4, exp_month: @intent[:card].exp_month, exp_year: @intent[:card].exp_year, card_type: @intent[:card].brand)

             format.html { redirect_to root_url, notice: 'Donation was successfully created.' }
             format.json { render :show, status: :created, location: @donation }
           else
             format.html { new_donation_path }
             format.json { render json: @donation.errors, status: :unprocessable_entity }
           end
    end


  else
  respond_to do |format|
  #byebug
  format.html { redirect_to new_donation_path}
  format.json { render json: @donation.errors, status: :unprocessable_entity }

  end

end

# rescue Stripe::CardError => e
#     flash[:error] = e.message
#     redirect_to new_donation_path

  end

  # PATCH/PUT /donations/1
  # PATCH/PUT /donations/1.json
  def update
    respond_to do |format|
      if @donation.update(donation_params)
        format.html { redirect_to @donation, notice: 'Donation was successfully updated.' }
        format.json { render :show, status: :ok, location: @donation }
      else
        format.html { render :edit }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  def refund_popup

  
    if params[:id].present?
      @refund_donation = Donation.find(params[:id])
    respond_to do |format|
   
      format.js 

    end
    end 

  end  

  def refund_donation
#byebug
   if params[:amount].present? && params[:charge_id].present?
begin
  @refund = Stripe::Refund.create({
    amount: params[:amount].to_i.round(2) * 100.to_i,
    payment_intent: params[:charge_id]
  })

rescue Stripe::CardError => e 
   if  e.message.present?
   
     respond_to do |format|
      @messge = e.message
        format.js   { render 'alert.js.erb' }
     end
    
    else 
    respond_to do |format|
     @messge = "amount has been refunded "
        format.js   { render 'alert.js.erb' }  
    
    end 
  end
end
end

  end  

  # DELETE /donations/1
  # DELETE /donations/1.json
  def destroy
    @donation.destroy
    respond_to do |format|
      format.html { redirect_to donations_url, notice: 'Donation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation
      @donation = Donation.find(params[:id])
    end
def card_params
    params.require(:donation).permit(:number, :month, :year, :cvc)
  end
    # Only allow a list of trusted parameters through.
    def donation_params
      params.fetch(:donation, {})
    end
end
