class AddExecutableNameToBenchMark < ActiveRecord::Migration
  def change
    add_column :ruby_benchmarks, :executable, :string
  end
end
