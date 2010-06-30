class CreateSubsectors < ActiveRecord::Migration
  def self.up
    create_table :subsectors do |t|
      t.column :subsector, :string
      t.column :sector_id, :integer
      #---- columnas de auditoria ---
      t.column :user_id, :integer
      t.column :fecha, :date
    end
  end

  def self.down
    drop_table :subsectors
  end
end
