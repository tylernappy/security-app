class AddCompanyToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :company, :string
  end
end
