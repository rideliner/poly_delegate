# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'poly_delegate/method'

module PolyDelegate
  def self.distinguish_delegator(obj, *args)
    delegator =
      if args.empty? || !args.first.is_a?(Delegator)
        obj
      else
        args.shift
      end

    [delegator, args]
  end

  def self.delegate_call(obj, method, *args, &block)
    delegator, args = distinguish_delegator(obj, *args)
    bound = force_bind(delegator, method)
    bound.call(*args, &block)
  end

  def self.create_delegated_method(klass, name)
    method = klass.instance_method(name)

    redefine_method(klass, name) do |*args, &block|
      PolyDelegate.delegate_call(self, method, *args, &block)
    end
  end
end
