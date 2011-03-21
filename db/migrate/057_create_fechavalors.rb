class CreateFechavalors < ActiveRecord::Migration
  def self.up
    create_table :fechavalors do |t|
      t.column :fecha, :date
      t.column :sucursal, :string, :limit => 20
      t.column :autorizacion, :string, :limit => 20
      t.column :codigo, :string, :limit => 20
      t.column :subcodigo, :string, :limit => 20
      t.column :ref_alfa, :string, :limit => 20
      t.column :importe, :string, :limit => 20
      t.column :st, :string, :limit  => 2
      #----- Auditoria -----
      t.column :fecha_hora, :datetime
      #---- Relaciones con otras tablas -----
      t.column :datafile_id, :integer
      t.column :credito_id, :integer
    end
  end

  def self.down
    drop_table :fechavalors
  end
end

