# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'poly_delegate/classic_access'
require 'poly_delegate/force_bind'
require 'poly_delegate/method'

module PolyDelegate
  module Delegated
    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        intercepted = [base, Object, Kernel, BasicObject]
        intercepted = intercepted.map(&:instance_methods).reduce(&:-)

        intercepted.each do |name|
          __create_delegated_method__(name)
        end
      end
    end

    module ClassMethods
      include ClassicAttributeAccess

      def __create_delegated_method__(name)
        method = instance_method(name)

        PolyDelegate.redefine_method(self, name) do |*args, &block|
          __delegated_call__(method, *args, &block)
        end
      end

      def __delegated_call__(method, *args, &block)
        delegator =
          if args.empty? || !args.first.is_a?(Delegator)
            self
          else
            args.shift
          end

        bound = PolyDelegate.force_bind(delegator, method)
        bound.call(*args, &block)
      end

      def method_added(name)
        return if %i(method_missing initialize).include?(name)
        return if PolyDelegate.callers(2).include?(:redefine_method)

        __create_delegated_method__(name)
      end
    end
  end
end
