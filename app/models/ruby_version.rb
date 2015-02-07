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

class RubyVersion < ActiveRecord::Base
  has_many :results, dependent: :destroy
  has_many :ruby_benchmarks, through: :results

  attr_writer :full_name

  IMPLEMENTATIONS = {
    'ruby' => 'MRI',
    'jruby' => 'JRuby',
    'rubinius' => 'Rubinius'
  }

  validates_presence_of :name, :implementation
  validates_format_of :name, :with => /\A\d/
  validates :name, uniqueness: { scope: :implementation }

  def display_name
    "#{implementation} #{name}"
  end

  def full_name= (str)
    if str && res = str.match(/\A(.*)-([\d\.a-zA-Z]+)\Z/)
      self.implementation = IMPLEMENTATIONS[res[1]]
      self.name = res[2]
    end
  end

  def self.version_color(version)
    if res = version.match(/\A([a-zA-Z]*) ([\d\.a-zA-Z]+)\Z/)
      implementation = res[1]
      return IMPLEMENTATIONS.values.index(implementation)
    else
      return 0
    end
  end

end
