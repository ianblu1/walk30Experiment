class AddFlagToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :flag, :integer
  end
end
