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

require 'coderay'

class RubyBenchmark < ActiveRecord::Base
  def to_param
    self.name
  end

  has_many :ruby_versions, through: :results
  has_many :results

  validates :name, uniqueness: true
end
