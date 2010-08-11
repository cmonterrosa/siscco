class CreateClientes < ActiveRecord::Migration
  def self.up
    create_table :clientes do |t|
      t.column :paterno, :string
      t.column :materno, :string
      t.column :nombre , :string
      t.column :fecha_nac, :date
      t.column :rfc , :string, :limit => 13
      t.column :curp , :string , :limit => 18
      t.column :clave_ife, :string
      t.column :sexo, :string, :limit => 1
      t.column :tipo_propiedad, :string
      t.column :tipo_persona, :string
      t.column :direccion, :string
      t.column :codigo_postal , :string
      t.column :telefono, :string, :limit => 10
      t.column :email, :string
      #--- Relaciones con otras tablas ---
      t.column :civil_id, :integer
      t.column :escolaridad_id, :integer
      t.column :vivienda_id, :integer
      t.column :colonia_id, :integer
      t.column :nacionalidad_id, :integer
      
      #---- campo para historial -----
      t.column :st, :integer
    end


       # generate the join table
    create_table :clientes_grupos  do |t|
      t.column :cliente_id, :integer
      t.column :grupo_id, :integer
      t.column :activo, :integer
      t.column :fecha_inicio, :datetime
      t.column :fecha_fin, :datetime
     end

     add_index "clientes_grupos", "cliente_id"
     add_index "clientes_grupos", "grupo_id"

  end
  

  def self.down
    drop_table :clientes
    drop_table :clientes_grupos
  end
end
