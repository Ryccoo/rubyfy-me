class AddGccToResult < ActiveRecord::Migration
  def change
    add_column :results, :gcc, :string
  end
end
