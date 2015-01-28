require 'net/http'

# == Schema Information
#
# Table name: ruby_benchmarks
#
#  id                   :integer          not null, primary key
#  author               :string(255)
#  email                :string(255)
#  name                 :string(255)
#  source               :text
#  source_file          :string(255)
#  display_source       :text
#  created_at           :datetime
#  updated_at           :datetime
#  benchmark_collection :string(255)
#  executable           :string(255)
#

class RubyBenchmark < ActiveRecord::Base
  default_scope { where("benchmark_collection <> 'special'") }

  def to_param
    self.name
  end

  has_many :ruby_versions, through: :results
  has_many :results, dependent: :destroy

  validates_uniqueness_of :executable

  def executable=(str)
    if str && res = str.match(/\A(.*)\/(.*)\.rb\Z/)
      self.benchmark_collection = res[1]
      self.name = res[2]
    end
    super
  end

  def get_source
    if executable
      uri = URI.parse "https://raw.githubusercontent.com/Ryccoo/docker-ruby-benchmark/master/benchmarks/#{executable}"
      begin
        res = Net::HTTP.get(uri)
      rescue
        res = nil
      ensure
        self.source = res
      end
    end
  end

end
