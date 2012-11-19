class AddIndexToParticipantsPhoneNumber < ActiveRecord::Migration
  def change
    add_index :participants, :phone, unique: true
  end
end
