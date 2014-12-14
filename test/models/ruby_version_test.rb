# == Schema Information
#
# Table name: ruby_versions
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  implementation :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class RubyVersionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
