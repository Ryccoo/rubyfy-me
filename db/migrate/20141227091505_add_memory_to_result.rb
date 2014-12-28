class AddMemoryToResult < ActiveRecord::Migration
  def change
    add_column :results, :memory, :decimal, :precision => 14, :scale => 4
  end
end
