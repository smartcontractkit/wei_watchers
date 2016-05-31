class WeiAmountsAsDecimal < ActiveRecord::Migration
  def up
    change_column :accounts, :balance, :decimal, precision: 24, scale: 0
  end

  def down
    change_column :accounts, :balance, :bigint
  end
end
