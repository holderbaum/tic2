class RemoveWonAndEndedFromRounds < ActiveRecord::Migration
  def self.up
    remove_column :rounds, :won
    remove_column :rounds, :ended
  end

  def self.down
    add_column :rounds, :won, :boolean
    add_column :rounds, :running, :boolean
  end
end
