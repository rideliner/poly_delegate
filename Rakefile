# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'rubygems'
require 'bundler'

Bundler.setup(:default, :development)

require 'bundler/gem_tasks'

Dir.glob('tasks/*.rake').each { |task| import task }

task default: %i(rubocop test)
task ci: 'test:coverage'
