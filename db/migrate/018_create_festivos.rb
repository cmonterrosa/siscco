class CreateFestivos < ActiveRecord::Migration
  def self.up
    create_table :festivos do |t|
      t.column :fecha, :date
      t.column :descripcion, :string
      #---- columnas de auditoria ---
      t.column :user_id, :integer
      t.column :fecha_hora, :datetime
    end

    Festivo.create(:fecha => "2010-05-01", :descripcion=> "dia del trabajo")

  end

  def self.down
    drop_table :festivos
  end
end
