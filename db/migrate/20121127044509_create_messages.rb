class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :participant_id
      t.string :subject
      t.string :content
      t.integer :medium
      t.integer :status
      t.datetime :scheduled_at
      t.datetime :sent_at

      t.timestamps
    end
    
    add_index :messages, [:participant_id, :sent_at, :scheduled_at]

    add_column :participants, :status, :integer
    add_column :participants, :experiment_begun_at, :datetime
    add_column :participants, :experiment_ended_at, :datetime
    
    Participant.all.each do |participant|
      particpant.update_attributes!(:status => 0)
      particpant.update_attributes!(:experiment_begun_at => nil)
      particpant.update_attributes!(:experiment_ended_at => nil)
    end
    
  end
end
