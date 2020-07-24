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
    @donation = Donation.new
  end

  # GET /donations/1/edit
  def edit
  end

  # POST /donations
  # POST /donations.json
  def create

  if params[:stripeToken].present? &&  params[:donation][:amount].present?
   @amount = (params[:donation][:amount].to_i.round(2) * 100.to_i)
   
    customer = Stripe::Customer.create(
      email: current_user.email,
      source: params[:stripeToken]
    )


    @intent = Stripe::PaymentIntent.create(
            :customer    => customer.id,
            :amount      => @amount.to_i,
            :payment_method_types => ['card'],
            :description => 'One-time Donation',
            :currency    => 'usd',
            :confirmation_method => 'manual', 
            :confirm => true
            ) 
    @donation = Donation.new(user_id: current_user.id,amount: params[:donation][:amount],charge_id: @intent.id)
    #@donation.save_card_details()
    respond_to do |format|
           if @donation.save
            @donation.save_card_details(@intent.source, @intent.customer,current_user.id)
             format.html { redirect_to root_url, notice: 'Donation was successfully created.' }
             format.json { render :show, status: :created, location: @donation }
           else
             format.html { render :new }
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

rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_donation_path

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
