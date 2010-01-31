class CreateRounds < ActiveRecord::Migration
  def self.up
    create_table :rounds do |t|
      t.string :player
      t.boolean :running
      t.boolean :won

      t.timestamps
    end
  end

  def self.down
    drop_table :rounds
  end
end
