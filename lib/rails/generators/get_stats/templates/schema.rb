ActiveRecord::Schema.define(:version => 0) do
    create_table :stats, :force => true do |t|
      t.string :stat_name
      t.date :stat_date
      t.integer :count
      t.timestamps
    end
    add_index :stats, [:stat_date, :stat_name], :unique => true 
end