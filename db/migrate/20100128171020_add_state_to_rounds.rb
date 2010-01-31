class AddStateToRounds < ActiveRecord::Migration
  def self.up
    add_column :rounds, :state, :integer
  end

  def self.down
    remove_column :rounds, :state
  end
end
