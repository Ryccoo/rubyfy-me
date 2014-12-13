class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.references :ruby_version, index: true
      t.references :ruby_benchmark, index: true
      t.datetime :run_at, scale: 12, precision: 6
      t.decimal :time

      t.timestamps
    end
  end
end
