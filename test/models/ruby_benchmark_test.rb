# == Schema Information
#
# Table name: ruby_benchmarks
#
#  id             :integer          not null, primary key
#  author         :string(255)
#  email          :string(255)
#  name           :string(255)
#  source         :text
#  source_file    :string(255)
#  display_source :text
#  created_at     :datetime
#  updated_at     :datetime
#  group          :string(255)
#

require 'test_helper'

class RubyBenchmarkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
