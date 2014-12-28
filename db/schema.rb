# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141227091505) do

  create_table "results", force: true do |t|
    t.integer  "ruby_version_id"
    t.integer  "ruby_benchmark_id"
    t.datetime "run_at"
    t.decimal  "time",              precision: 14, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gcc"
    t.decimal  "memory",            precision: 14, scale: 4
  end

  add_index "results", ["ruby_benchmark_id"], name: "index_results_on_ruby_benchmark_id", using: :btree
  add_index "results", ["ruby_version_id"], name: "index_results_on_ruby_version_id", using: :btree

  create_table "ruby_benchmarks", force: true do |t|
    t.string   "author"
    t.string   "email"
    t.string   "name"
    t.text     "source"
    t.string   "source_file"
    t.text     "display_source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "benchmark_collection"
    t.string   "executable"
  end

  create_table "ruby_versions", force: true do |t|
    t.string   "name"
    t.string   "implementation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
