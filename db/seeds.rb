# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

versions = RubyVersion.create([{name: :mri1}, {name: :mri2}, {name: :mri3}])
benchmarks = RubyBenchmark.create([{name: :fake_bench1}, {name: :fake_bench2}, {name: :fake_bench3}])

versions.each do |v|
  benchmarks.each do |b|
    Result.create(
      ruby_version: v,
      ruby_benchmark: b,
      time: Random.rand(50)
    )
  end
end

source = <<-SOURCE
# The Computer Language Benchmarks Game
# http://shootout.alioth.debian.org/
#
# contributed by Serhiy Boiko


#require 'thread'
THREAD_NUM = 503
number = ARGV.first.to_i

threads = []
for i in 1..THREAD_NUM
   threads << Thread.new(i) do |thr_num|
      while true
         Thread.stop
         if number > 0
            number -= 1
         else
            puts thr_num
            exit 0
         end
      end
   end
end

prev_thread = threads.last
while true
   for thread in threads
      Thread.pass until prev_thread.stop?
      if thread.alive?
        thread.run
      else
        exit
      end
      prev_thread = thread
   end
end
SOURCE

RubyBenchmark.first.update_attribute(:source, source)