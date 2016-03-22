# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'poly_delegate/call'
require 'poly_delegate/classic_access'

module PolyDelegate
  # A class that includes {Delegated} has all current and future methods
  # redefined to allow for an extra {Delegator} parameter. If that {Delegator}
  # argument is provided, the method call is redirected to that parameter in the
  # same manner that inheritance will first go to a method definition in a child
  # class.
  module Delegated
    # @api private
    # Define some class methods on anyone that includes this module.
    # Also, make all methods already existing on the class self-delegating.
    # @return [void]
    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        # Don't make methods in the Ruby standard self-delegating.
        intercepted = [base, Object, Kernel, BasicObject]
        intercepted = intercepted.map(&:instance_methods).reduce(&:-)

        intercepted.each do |name|
          PolyDelegate.create_delegated_method(base, name)
        end
      end
    end

    # @api private
    # Class level methods that are needed on implementors of {Delegated}.
    module ClassMethods
      include ClassicAttributeAccess

      # Redefine methods to be self-delegating.
      # @return [void]
      def method_added(name)
        return if %i(method_missing initialize).include?(name)

        # The nature of method_added getting called when a method is defined
        # means that we have to prevent the redefinition made in
        # create_delegated_method from getting any further here.
        return if PolyDelegate.callers(2).include?(:redefine_method)

        PolyDelegate.create_delegated_method(self, name)
      end
    end
  end
end
