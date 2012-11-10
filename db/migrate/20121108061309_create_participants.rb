class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :email
      t.integer :age
      t.string :zip_code
      t.boolean :is_male
      t.integer :phone

      t.timestamps
    end
  end
end
