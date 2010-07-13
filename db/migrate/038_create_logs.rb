class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.column :operacion, :string
      t.column :fecha_hora, :datetime
      t.column :clase, :string
      #---- campo para historial -----
      t.column :st, :integer
    end
  end

  def self.down
    drop_table :logs
  end
end
