class CreateGiros < ActiveRecord::Migration
  def self.up
    create_table :giros do |t|
      t.column :giro, :string
      t.column :codigo, :string
      t.column :subsector, :string
    end

    Giro.create(:giro => "Agricultura", :codigo=>"AGR", :subsector=>"2")

  end

  def self.down
    drop_table :giros
  end
end
