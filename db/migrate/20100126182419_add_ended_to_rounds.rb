class AddEndedToRounds < ActiveRecord::Migration
  def self.up
    add_column :rounds, :ended, :boolean
  end

  def self.down
    remove_column :rounds, :ended
  end
end
