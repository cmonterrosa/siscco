class CreateSubsectors < ActiveRecord::Migration
  def self.up
    create_table :subsectors do |t|
      t.column :subsector, :string
      t.column :sector_id, :integer
      #---- campo para historial -----
      t.column :st, :integer
    end
  end

  def self.down
    drop_table :subsectors
  end
end
