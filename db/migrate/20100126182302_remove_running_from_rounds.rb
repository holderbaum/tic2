class RemoveRunningFromRounds < ActiveRecord::Migration
  def self.up
    remove_column :rounds, :running
  end

  def self.down
    add_column :rounds, :running, :boolean
  end
end
