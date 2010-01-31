class CreateMoves < ActiveRecord::Migration
  def self.up
    create_table :moves do |t|
      t.integer :x
      t.integer :y
      t.boolean :by_player
      t.integer :round_id

      t.timestamps
    end
  end

  def self.down
    drop_table :moves
  end
end
