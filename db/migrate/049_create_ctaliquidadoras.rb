class CreateCtaliquidadoras < ActiveRecord::Migration
  def self.up
    create_table :ctaliquidadoras do |t|
      t.column :num_cta, :string
      t.column :cta_contable, :string
      t.column :sucbancaria_id, :integer
    end
  end

  def self.down
    drop_table :ctaliquidadoras
  end
end
