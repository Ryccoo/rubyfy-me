class Result < ActiveRecord::Base
  belongs_to :ruby_version
  belongs_to :ruby_benchmark
end
