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

  def self.not_custom
    self.includes(:ruby_benchmark).where.not(ruby_benchmarks: {benchmark_collection: 'custom'})
  end

  belongs_to :ruby_version
  belongs_to :ruby_benchmark

  validates_presence_of :ruby_version, :ruby_benchmark, :run_at, :gcc

  validates_presence_of :time, :memory, :total_memory,
                        if: Proc.new { !self.from_custom_collection? }

  validates_presence_of :stdout,
                        if: Proc.new { self.from_custom_collection? && self.stderr.blank? }

  validates_presence_of :stderr,
                        if: Proc.new { self.from_custom_collection? && self.stdout.blank? }

  validates :time,  uniqueness: { scope: [:run_at, :ruby_version_id, :ruby_benchmark_id,:gcc]},
            numericality: { greater_than: 0 },
            if: Proc.new { !self.from_custom_collection? }

  validates :stdout,  uniqueness: { scope: [:run_at, :ruby_version_id, :ruby_benchmark_id,:gcc]},
            if: Proc.new { self.from_custom_collection? && !self.stdout.blank? }

  validates :stderr,  uniqueness: { scope: [:run_at, :ruby_version_id, :ruby_benchmark_id,:gcc],
                                    allow_blank: true },
            if: Proc.new { self.from_custom_collection? && !self.stderr.blank? }

  validates :memory,  numericality: { greater_than: 0 },
                      if: Proc.new { !self.from_custom_collection? }

  validates :total_memory,  numericality: { greater_than: 0 },
                            if: Proc.new { !self.from_custom_collection? }

  COMPILERS = ['GCC', 'Clang']


  def from_custom_collection?
    self.ruby_benchmark.try(:benchmark_collection) == 'custom'
  end

end
