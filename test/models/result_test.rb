# == Schema Information
#
# Table name: results
#
#  id                :integer          not null, primary key
#  ruby_version_id   :integer
#  ruby_benchmark_id :integer
#  run_at            :datetime
#  time              :integer
#  created_at        :datetime
#  updated_at        :datetime
#

require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
