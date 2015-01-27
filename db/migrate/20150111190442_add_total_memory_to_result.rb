class AddTotalMemoryToResult < ActiveRecord::Migration
  def change
    add_column :results, :total_memory, :decimal, :precision => 14, :scale => 4
  end
end
