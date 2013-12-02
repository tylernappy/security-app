class AddPhoneToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :phone, :string
  end
end
