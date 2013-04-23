class CreateStatus < ActiveRecord::Migration
  def self.up
    create_table :status do |t|
      t.column :statu, :string
    end
    Statu.create(:statu => 'ACTIVA')
    Statu.create(:statu => 'SUSPENDIDA')
    Statu.create(:statu => 'CANCELADA')

  end

  def self.down
    drop_table :status
  end
end
