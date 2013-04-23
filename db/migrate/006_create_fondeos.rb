class CreateFondeos < ActiveRecord::Migration
  def self.up
    create_table :fondeos do |t|
      t.column :acronimo, :string
      t.column :fuente, :string
      t.column :domicilio, :string
      t.column :telefono, :string
    end

    Fondeo.create(:fuente => "Fondo de Microfinanciamiento a Mujeres Rurales".upcase, :acronimo => "FOMMUR")


  end

  def self.down
    drop_table :fondeos
  end
end
