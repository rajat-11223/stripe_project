class CreateChargeCards < ActiveRecord::Migration[6.0]
  def change
    create_table :charge_cards do |t|
      t.references :user
      t.string :card_id
      t.string :last_4
      t.string :card_type
      t.string :exp_month
      t.string :exp_year
      t.timestamps
    end
  end
end
