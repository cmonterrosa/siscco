class CreateFondeos < ActiveRecord::Migration
  def self.up
    create_table :fondeos do |t|
      t.column :fuente, :string
    end

    Fondeo.create(:fuente => "FOMMUR")
    Fondeo.create(:fuente => "PROPIO")

  end

  def self.down
    drop_table :fondeos
  end
end
