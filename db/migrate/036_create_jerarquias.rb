class CreateJerarquias < ActiveRecord::Migration
  def self.up
    create_table :jerarquias do |t|
      t.column :jerarquia, :string
    end

    Jerarquia.create(:jerarquia=>"presidente")
    Jerarquia.create(:jerarquia=>"secretario")
    Jerarquia.create(:jerarquia=>"tesorero")
    Jerarquia.create(:jerarquia=>"miembro")
  end

  def self.down
    drop_table :jerarquias
  end
end
