class ReplaceIntPhoneWithBigInt < ActiveRecord::Migration
  def up
    remove_column :participants, :phone
    add_column :participants, :phone, :int, limit:8
  end

  def down
    remove_column :participants, :phone
    add_column :participants, :phone, :int
  end
end
