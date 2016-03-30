# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'yard'
require 'yard/rake/yardoc_task'

require 'yardstick/rake/measurement'
require 'yardstick/rake/verify'

YARD::Rake::YardocTask.new(:yard)

Yardstick::Rake::Measurement.new('yard:measure') do |measurement|
  measurement.output = '/dev/stdout'
end

Yardstick::Rake::Verify.new('yard:verify') do |verify|
end

CLEAN.include '.yardoc'
CLOBBER.include '_yardoc'
