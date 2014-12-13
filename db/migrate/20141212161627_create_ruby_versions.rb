class CreateRubyVersions < ActiveRecord::Migration
  def change
    create_table :ruby_versions do |t|
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
