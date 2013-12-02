class AddEventIdToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :event_id, :integer
  end
end
