class CreateMessageStrategies < ActiveRecord::Migration
  def change
    create_table :message_strategies do |t|
      t.integer :message_id
      t.integer :strategy_id

      t.timestamps
    end
  end
end
