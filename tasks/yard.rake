# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'yard'
require 'yard/rake/yardoc_task'

YARD::Rake::YardocTask.new(:yard)

CLEAN.include '.yardoc'
CLOBBER.include '_yardoc'