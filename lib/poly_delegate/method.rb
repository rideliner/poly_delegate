# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module PolyDelegate
  def self.caller
    callers(2).last
  end

  def self.callers(num)
    caller_locations(2, num).map(&:label).map(&:to_sym)
  end

  def self.method_visibility(obj, method)
    if obj.public_method_defined? method
      :public
    elsif obj.private_method_defined? method
      :private
    elsif obj.protected_method_defined? method
      :protected
    end
  end

  def self.set_method_visibility(obj, method, visibility)
    obj.__send__ visibility, method
  end

  def self.redefine_method(obj, name, &block)
    visibility = method_visibility(obj, name)
    obj.__send__(:undef_method, name)
    obj.__send__(:define_method, name, &block)
    set_method_visibility(obj, name, visibility)
  end
end
