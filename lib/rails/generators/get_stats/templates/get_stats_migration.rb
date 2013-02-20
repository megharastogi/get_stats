class CreateStatsTables < ActiveRecord::Migration
  def self.up
    
    create_table :stats, :force => true do |t|
      t.string :stat_name
      t.date :stat_date
      t.integer :count
      t.timestamps
    end
    add_index :stats, [:stat_date, :stat_name], :unique => true 
  end

  def self.down
    drop_table :stats
  end
end
