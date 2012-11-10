class AddIndexToParticipantsEmail < ActiveRecord::Migration
  def change
    add_index :participants, :email, unique: true
  end
end
