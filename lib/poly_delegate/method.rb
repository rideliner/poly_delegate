# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module PolyDelegate
  # @return [String] name of the calling method
  def self.caller
    callers(2).last
  end

  # @param num [Integer] number of calling methods to retrieve
  # @return [Array<String>] list of calling methods traced back
  def self.callers(num)
    caller_locations(2, num).map(&:label).map(&:to_sym)
  end

  # @param method [Symbol] method name
  # @return [:public, :private, :protected] visibility level of a method
  def self.method_visibility(obj, method)
    if obj.public_method_defined? method
      :public
    elsif obj.private_method_defined? method
      :private
    elsif obj.protected_method_defined? method
      :protected
    end
  end

  # Change the visibility of a method dynamically.
  # @param method [Symbol] method name
  # @param visibility [:public, :private, :protected]
  # @return [void]
  def self.set_method_visibility(obj, method, visibility)
    obj.__send__ visibility, method
  end

  # Redefine a method with a new implementation.
  # @note Keeps the same level of visibility.
  # @param obj [Object] object for the method to be redefined on
  # @param name [Symbol] name of method to redefine
  # @param block [Proc] new implementation of the method
  # @return [void]
  def self.redefine_method(obj, name, &block)
    visibility = method_visibility(obj, name)
    obj.__send__(:undef_method, name)
    obj.__send__(:define_method, name, &block)
    set_method_visibility(obj, name, visibility)
  end
end
