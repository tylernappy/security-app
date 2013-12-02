class AddRoomToEvents < ActiveRecord::Migration
  def change
    add_column :events, :room, :string
  end
end
