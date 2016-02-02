# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = ['test/test_helper.rb']
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

namespace :test do
  desc 'Generate a test coverage report'
  task :coverage do
    ENV['COVERAGE'] = 'true'
    task(:test).invoke
  end
end

CLOBBER.include 'coverage'
