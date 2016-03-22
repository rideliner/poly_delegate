# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'poly_delegate/delegated'

module PolyDelegate
  # {Delegator}, in conjunction with {Delegated}, plays the role of the sub-type
  # in an inheritance structure. Any methods defined on a class inheriting from
  # {Delegator} will act as overrides to their respective methods found in the
  # {Delegated} object held by the {Delegator}.
  #
  # @note `super` can be called from {Delegator}'s methods to refer to the
  #   matching method in the {Delegated} object.
  class Delegator
    # @param obj [Delegated] delegated object
    def initialize(obj)
      @__delegated_object__ = obj
    end

    # Relay methods to `@__delegated_object__` if they exist
    def method_missing(name, *args, &block)
      super unless @__delegated_object__.respond_to?(name)
      # Send self as the delegator
      @__delegated_object__.__send__(name, self, *args, &block)
    end

    # Get an instance variable through the delegated object.
    def instance_variable_get(sym)
      @__delegated_object__.instance_variable_get(sym)
    end

    # Set an instance variable through the delegated object.
    # @return [void]
    def instance_variable_set(sym, value)
      @__delegated_object__.instance_variable_set(sym, value)
    end

    # Get an instance variable without going through the delegated object.
    def __undelegated_get__(sym)
      __instance_variable_get__(sym)
    end

    # Set an instance variable without going through the delegated object.
    # @return [void]
    def __undelegated_set__(sym, value)
      __instance_variable_set__(sym, value)
    end
  end
end
