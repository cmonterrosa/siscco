class CreateJerarquias < ActiveRecord::Migration
  def self.up
    create_table :jerarquias do |t|
      t.column :jerarquia, :string
    end

    Jerarquia.new(:jerarquia=>"presidente")
    Jerarquia.new(:jerarquia=>"secretario")
    Jerarquia.new(:jerarquia=>"tesorero")
    Jerarquia.new(:jerarquia=>"miembro")
  end

  def self.down
    drop_table :jerarquias
  end
end
