class CreateRubyBenchmarks < ActiveRecord::Migration
  def change
    create_table :ruby_benchmarks do |t|
      t.string :author
      t.string :email
      t.string :name
      t.text :source
      t.string :source_file
      t.text :display_source

      t.timestamps
    end
  end
end
