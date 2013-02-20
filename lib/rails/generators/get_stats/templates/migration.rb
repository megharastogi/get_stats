class CreateCheeseTables < ActiveRecord::Migration
  def self.up
    SCHEMA_AUTO_INSERTED_HERE
  end

  def self.down
    drop_table :stats
  end
end
