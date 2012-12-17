class AddTypeToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :type, :string
  end
end
