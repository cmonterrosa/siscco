class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.column :operacion, :string
      t.column :fecha_hora, :datetime
      t.column :clase, :string
      #---- Vinculacion con otras tablas -----
      t.column :objeto_id, :integer
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :logs
  end
end
