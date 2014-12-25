class ChangePrecisionOfResult < ActiveRecord::Migration
  def change
    change_column :results, :time, :decimal, :precision => 14, :scale => 4
  end
end
