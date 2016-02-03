# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module PolyDelegate
  # rubocop:disable Lint/DuplicateMethods
  case RUBY_ENGINE
  when 'rbx'
    def self.force_bind(bound_obj, method)
      method_args = [method.defined_in, method.executable, method.name]

      Method.new(bound_obj, *method_args)
    end
  when 'ruby'
    require 'force_bind'

    def self.force_bind(bound_obj, method)
      if bound_obj.class == method.owner
        method.bind(bound_obj)
      else
        method.force_bind(bound_obj)
      end
    end
  else
    fail "force binding is not supported on #{RUBY_ENGINE}"
  end
  # rubocop:enable Lint/DuplicateMethods
end
