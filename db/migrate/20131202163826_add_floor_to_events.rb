class AddFloorToEvents < ActiveRecord::Migration
  def change
    add_column :events, :floor, :string
  end
end
