class AddTimeZoneToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :time_zone, :string, :default => "PST"
  end
end
