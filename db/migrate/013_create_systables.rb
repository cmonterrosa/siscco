class CreateSystables < ActiveRecord::Migration
  def self.up
    create_table :systables do |t|
      t.column :controller, :string
      t.column :rol_id, :integer
    end

    #--- Por defecto le creamos los permisos al administrador ---

    Systable.create(:controller => "home", :rol_id => 5)
    Systable.create(:controller => "catalogos", :rol_id => 5)

  end

  def self.down
    drop_table :systables
  end
end
