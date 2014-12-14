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

class Result < ActiveRecord::Base
  belongs_to :ruby_version
  belongs_to :ruby_benchmark

  validates_presence_of :ruby_version, :ruby_benchmark, :run_at, :time
end
