class CreateCtaconcentradoras < ActiveRecord::Migration
  def self.up
    create_table :ctaconcentradoras do |t|
      t.column :num_cta, :string
      t.column :cta_contable, :string
      t.column :sucbancaria_id, :integer
    end
  end

  def self.down
    drop_table :ctaconcentradoras
  end
end
