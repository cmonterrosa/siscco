class CreateSectors < ActiveRecord::Migration
  def self.up
    create_table :sectors do |t|
      t.column :sector, :string
      #---- columnas de auditoria ---
      t.column :user_id, :integer
      t.column :fecha, :date
    end
  end

  def self.down
    drop_table :sectors
  end
end
