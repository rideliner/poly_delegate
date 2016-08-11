# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'poly_delegate/method'
require 'poly_delegate/force_bind'

module PolyDelegate
  # @api private
  # Distinguish the delegator from the arguments before calling a method
  # @overload distinguish_delegator(obj, args...)
  #   Treats `obj` as the delegator.
  #   @param obj [Delegated] delegated object
  #   @param args... [Array<Object>] arguments to the original method
  #   @return [Array<obj, Object...>]
  # @overload distinguish_delegator(obj, delegator, args...)
  #   @param obj [Delegated] delegated object
  #   @param delegator [Delegator]
  #   @param args... [Array<Object>] arguments to the original method
  # @return [Array<Delegator, Object...>]
  def self.distinguish_delegator(obj, *args)
    delegator =
      if args.empty? || !args.first.is_a?(Delegator)
        obj
      else
        args.shift
      end

    [delegator, args]
  end

  # @api private
  # Call a method in the context of the delegator
  # @overload delegate_call(obj, method, args..., &block)
  #   @param obj [Delegated] delegated object
  #   @param method [UnboundMethod#force_bind] method to call on the delegator
  #   @param args... [Array<Object>] arguments to be passed to `method`
  #   @yield block to be passed to `method`
  # @return result of the method call
  def self.delegate_call(obj, method, *args, &block)
    delegator, args = distinguish_delegator(obj, *args)
    bound = method.force_bind(delegator)
    bound.call(*args, &block)
  end

  # @api private
  # Redefine a method to make a delegated call on an object
  # @param klass [Class]
  # @param name [Symbol, String] method name
  # @return [void]
  def self.create_delegated_method(klass, name)
    method = klass.instance_method(name)

    redefine_method(klass, name) do |*args, &block|
      PolyDelegate.delegate_call(self, method, *args, &block)
    end
  end
end
