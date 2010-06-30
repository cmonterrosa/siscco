class CreateJerarquias < ActiveRecord::Migration
  def self.up
    create_table :jerarquias do |t|
      t.column :jerarquia, :string
    end

    Jerarquia.new(:jerarquia=>"PRESIDENTE")
    Jerarquia.new(:jerarquia=>"SECRETARIO")
    Jerarquia.new(:jerarquia=>"TESORERO")
    Jerarquia.new(:jerarquia=>"VOCAL")
    Jerarquia.new(:jerarquia=>"MIEMBRO")
  end

  def self.down
    drop_table :jerarquias
  end
end
