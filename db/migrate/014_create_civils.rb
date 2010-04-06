class CreateCivils < ActiveRecord::Migration
  def self.up
    create_table :civils do |t|
      t.column :civil, :string
    end

    Civil.create(:civil => "SOLTERO")
    Civil.create(:civil => "CASADO")
    Civil.create(:civil => "VIUDO")
    Civil.create(:civil => "DIVORCIADO")

  end

  def self.down
    drop_table :civils
  end
end
