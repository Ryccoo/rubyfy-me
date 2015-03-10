class AddOutIoToResult < ActiveRecord::Migration
  def change
    add_column :results, :stdout, :text
    add_column :results, :stderr, :text
  end
end
