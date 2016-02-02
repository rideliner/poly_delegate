# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require './lib/poly_delegate/version'

Gem::Specification.new do |spec|
  spec.name          = 'poly_delegate'
  spec.version       = PolyDelegate::VERSION
  spec.authors       = ['Nathan Currier']
  spec.email         = ['nathan.currier@gmail.com']
  spec.license       = 'MPL-2.0'

  spec.description   = ''
  spec.summary       = ''
  spec.homepage      = 'https://github.com/rideliner/poly_delegate'
  spec.has_rdoc      = 'yard'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler', '>= 1.11.2'
end
