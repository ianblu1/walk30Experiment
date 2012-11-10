class ReplaceIntPhoneWithString < ActiveRecord::Migration
  def up
    remove_column :participants, :phone
    add_column :participants, :phone, :string
  end

  def down
    remove_column :participants, :phone
    add_column :participants, :phone, :int, limit:8
  end
end
