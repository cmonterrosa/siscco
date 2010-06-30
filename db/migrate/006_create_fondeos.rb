class CreateFondeos < ActiveRecord::Migration
  def self.up
    create_table :fondeos do |t|
      t.column :fuente, :string
      t.column :user_id, :integer
      t.column :fecha_hora, :datetime
    end
  end

  def self.down
    drop_table :fondeos
  end
end
