class CreateSectors < ActiveRecord::Migration
  def self.up
    create_table :sectors do |t|
      t.column :sector, :string
      #---- campo para historial -----
      t.column :st, :integer
    end
  end

  def self.down
    drop_table :sectors
  end
end
