class FixMessageStrategyTable < ActiveRecord::Migration
  def up
    remove_column :message_strategies, :message_id
    add_column :message_strategies, :project_message_id, :integer
  end

  def down
    remove_column :message_strategies, :project_message_id
    add_column :message_strategies, :message_id, :integer
  end
end
