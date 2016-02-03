# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'poly_delegate/delegated'

module PolyDelegate
  class Delegator
    def initialize(obj)
      @__delegated_object__ = obj
    end

    def method_missing(name, *args, &block)
      super unless @__delegated_object__.respond_to?(name)
      @__delegated_object__.__send__(name, self, *args, &block)
    end

    def instance_variable_get(sym)
      @__delegated_object__.instance_variable_get(sym)
    end

    def instance_variable_set(sym, value)
      @__delegated_object__.instance_variable_set(sym, value)
    end

    def __undelegated_get__(sym)
      __instance_variable_get__(sym)
    end

    def __undelegated_set__(sym, value)
      __instance_variable_set__(sym, value)
    end
  end
end
