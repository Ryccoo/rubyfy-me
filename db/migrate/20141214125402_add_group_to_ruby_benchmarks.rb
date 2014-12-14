class AddGroupToRubyBenchmarks < ActiveRecord::Migration
  def change
    add_column :ruby_benchmarks, :benchmark_collection, :string
  end
end
