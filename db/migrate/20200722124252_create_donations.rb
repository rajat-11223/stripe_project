class CreateDonations < ActiveRecord::Migration[6.0]
  def change
    create_table :donations do |t|
      t.references :user, foreign_key: true
      t.string :charge_id 
      t.float :amount
      t.timestamps
    end
  end
end
