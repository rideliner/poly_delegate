# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module PolyDelegate
  # Provide overloads of `attr_reader`, `attr_writer`, and `attr_accessor`.
  #
  # These overloads give access to the state of the instance
  # using `instance_variable_get` and `instance_variable_set`.
  #
  # `instance_variable_get` and `instance_variable_set` can be overloaded
  # on a class or instance level to provide additional functionality
  # when accessing attributes.
  #
  # If you do choose to overload `instance_variable_get` and
  # `instance_variable_set`, keep in mind that `__instance_variable_get__`
  # and `__instance_variable_set__` will still maintain the original
  # functionality of these methods.
  module ClassicAttributeAccess
    private

    # @!scope class
    # @overload attr_reader(method_name, ...)
    #   @param method_name [Symbol, String] A readable attribute
    #   @param ... [Symbol, String] More readable attributes
    #   @return [void]
    def attr_reader(*args)
      args.each do |method|
        define_method(method) do
          instance_variable_get(:"@#{method}")
        end
      end
    end

    # @!scope class
    # @overload attr_writer(method_name, ...)
    #   @param method_name [Symbol, String] A writable attribute
    #   @param ... [Symbol, String] More writable attributes
    #   @return [void]
    def attr_writer(*args)
      args.each do |method|
        define_method("#{method}=") do |value|
          instance_variable_set(:"@#{method}", value)
        end
      end
    end

    # @!scope class
    # @overload attr_accessor(method_name, ...)
    #   @param method_name [Symbol, String] An accessible attribute
    #   @param ... [Symbol, String] More accessible attributes
    #   @return [void]
    def attr_accessor(*args)
      attr_reader(*args)
      attr_writer(*args)
    end
  end
end
