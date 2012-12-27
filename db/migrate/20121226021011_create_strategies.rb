class CreateStrategies < ActiveRecord::Migration
  def change
    create_table :strategies do |t|
      t.boolean :morning
      t.string :time

      t.timestamps
    end
  end
end
