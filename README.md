#About

Rubyfy.Me is an open-source project focused on benchmarking various Ruby implementations in different versions.

It measures:
* benchmark execution time,
* memory needed to execute selected code,
* total memory(of both executing code and virtual machine) at the end of its execution.

It takes the time required to boot a virtual machine e.g. Rubinius, JRuby into account as well. Currently the benchmarking suite uses official Ruby benchmarks, however it is possible to add custom code to be benchmarked.

#Background

On 11. Dec 2013 [Sam Saffron](https://github.com/SamSaffron) published a [call for official long running Ruby benchmark](http://samsaffron.com/archive/2013/12/11/call-to-action-long-running-ruby-benchmark). He started official repository at github but due to lack of time the project died in September 2014. I managed to carry on his idea and started programming extendable benchmark suite for Ruby as a part of my thesis. Once I already decided to make Ruby benchmarking suite testing various versions, [Guo Xiang Tan](https://github.com/tgxworld) started doing his own benchmarking suite that would test individual commits in official Ruby repository acting more like performance CI (Continuos Integration) solution. He decided to add support for benchmarking various MRI versions later. After a while with Sam's help, he published it as official rubybench project hosted at [rubybench.org](http://www.rubybench.org). At that point I decided to carry on with my project and added support for other Ruby implementations. This was the official start of Rubyfy.Me project.

#Under the hood

Rubyfy.Me consists of two components:
* [Rubyfy.Me docker suite](https://github.com/Ryccoo/rubyfy-me-docker-suite) - using Docker images for 20 Ruby versions and 3 Ruby implementations using various C-language compilers. It tests performance and memory consumption for provided Ruby benchmarks. Separation into own docker images ensures that no shared libraries can affect the results.

* [Rubyfy.Me web](https://github.com/Ryccoo/rubyfy-me) - accepts results from the benchmarking suite using universal api described at [apidoc](http://rubybench-rycco.rhcloud.com/apidoc). It uses highcharts library to dynamically display all stored results and provides overviews.

#Requirements

* **Ruby 2.0.0** or above is needed to launch the benchmark suite.
* Docker executable is needed as benchmarking is done in docker containers. Benchmark suite was developed and tested on **Docker version 1.0.1, build 990021a**

#Installation

* Web
  1. Pull [rubyfy-me-web repository](https://github.com/Ryccoo/rubyfy-me).
  2. Run `bundle install` to install all required gems.
  3. Default database config requires `mysql` with user `ruby` identified by `ruby`
  4. Run `rails server` to start the server.


* Benchmarking suite
  1. Pull [rubyfy-me-benchmark-suite repository](https://github.com/Ryccoo/rubyfy-me-docker-suite).
  2. Run `bundle install` to install all required gems.
  3. Use `./rubyfy.rb -h` to display help or read below.

#Benchmarks

All suite benchmarks are located inside **benchmarks** folder, however, they must be located exactly in one
subfolder, specifying their group.

There is a special group of benchmarks called **custom**, which don't use the default benchmarking pattern (time, memory) as others. All benchmarks within this subfolder are benchmarked without any changes to its code and **stdout** is only being stored.


#Usage of benchmark suite
``` blank
Usage: rubyfy.rb [options]
    -d, --pull                       Pull all docker images
    -t, --test                       Test docker images
    -c, --clear                      Clear all unused docker containers
    -p, --publish                    Publish all collected results
    -r, --run                        Run benchmarks
    -h, --help                       Prints this help
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENVIRONMENT SETTINGS
  This benchmark suite uses ENV gem that allows you to store all your environment settings into file.
  This file is located in root of this application (where the file rubyfy.rb is located) and needs to be named ".env".

  Environment settings for benchmarking

    BENCH_REPEATS=x                  Repeat each benchmark x times. Default value is 10.

    BENCH_FILE=name                  Runs only selected benchmark. Use full path from benchmarks folder.
                                      Example: BENCH_FILE="ruby-official/bm_vm3_gc.rb" ./rubyfy.rb --run will
                                      run benchmark suite only for benchmark bm_vm3_gc.rb located in benchmarks/ruby-official
                                      folder.

    BENCH_SKIP_STARTUP_TEST=true     Skip docker images test on suite start. Default value is false.

    VERBOSE=true                     Verbose mode. Default is false.

  RubyFy.Me options for publishing to rails app
    BENCH_SECRET=String              Secret token used to authorize results on publishing. Same value key and value need
                                     to be set at RubyFy.Me rails app.

    BENCH_SITE=site                  URL (WITHOUT PORT) of rails app displaying stored results.
                                      Examples: BENCH_SITE="localhost" BENCH_PORT=3000 ./rubyfy.rb --publish
                                                BENCH_SITE="http://rubyfy.me" ./rubyfy.rb --publish

    BENCH_PORT=x                    Port of rails app displaying stored results.
                                      Example: BENCH_SITE=localhost BENCH_PORT=3000 ./rubyfy.rb --publish will
                                      push results to localhost on port 3000.
                                      IMPORTANT: USE THIS ONLY WHEN PORT IS DIFFERENT THAN 80

```

#Roadmap
See milestones at [https://github.com/Ryccoo/rubyfy-me/milestones](https://github.com/Ryccoo/rubyfy-me/milestones)
