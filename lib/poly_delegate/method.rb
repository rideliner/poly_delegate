# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module PolyDelegate
  # Get the name of the calling method
  # @api public
  # @return [String]
  # @example
  #   def foo
  #     PolyDelegate.caller
  #   end
  #
  #   def bar
  #     foo
  #   end
  #
  #   def baz
  #     bar
  #   end
  #
  #   baz #=> 'bar'
  def self.caller
    callers(2).last
  end

  # Get a list of calling methods traced back
  # @api public
  # @param num [Integer] number of calling methods to retrieve
  # @return [Array<String>]
  # @example
  #   def foo
  #     PolyDelegate.callers(2)
  #   end
  #
  #   def bar
  #     foo
  #   end
  #
  #   def baz
  #     bar
  #   end
  #
  #   baz #=> ['bar', 'baz']
  def self.callers(num)
    caller_locations(2, num).map(&:label).map(&:to_sym)
  end

  # Get the visibility of a method
  # @api public
  # @param mod [Module]
  # @param method [Symbol] method name
  # @return [:public, :private, :protected] visibility level of a method
  # @example
  #   class Foo
  #     def bar; end
  #     private :bar
  #   end
  #
  #   PolyDelegate.method_visibility(Foo, :bar) #=> :private
  def self.method_visibility(mod, method)
    if mod.public_method_defined? method
      :public
    elsif mod.private_method_defined? method
      :private
    elsif mod.protected_method_defined? method
      :protected
    end
  end

  # Change the visibility of a method dynamically
  # @api public
  # @param mod [Module]
  # @param method [Symbol] method name
  # @param visibility [:public, :private, :protected]
  # @return [void]
  # @example
  #   class Foo
  #     def bar; end
  #   end
  #
  #   PolyDelegate.method_visibility(Foo, :bar) #=> :public
  #
  #   PolyDelegate.set_method_visibility(Foo, :bar, :private)
  #
  #   PolyDelegate.method_visibility(Foo, :bar) #=> :private
  def self.set_method_visibility(mod, method, visibility)
    mod.__send__ visibility, method
  end

  # Redefine a method with a new implementation
  # @api public
  # @note Keeps the same level of visibility.
  # @param mod [Module] object for the method to be redefined on
  # @param name [Symbol] name of method to redefine
  # @param block [Proc] new implementation of the method
  # @return [void]
  # @example
  #   class Foo
  #     def bar(name)
  #       "Hello, #{name}!"
  #     end
  #   end
  #
  #   f = Foo.new
  #   f.bar('World') #=> 'Hello, World!
  #
  #   PolyDelegate.redefine_method(Foo, :bar) do |name|
  #     "Goodbye, #{name}!"
  #   end
  #
  #   f.bar('World') #=> 'Goodbye, World!'
  def self.redefine_method(mod, name, &block)
    visibility = method_visibility(mod, name)
    mod.__send__(:undef_method, name)
    mod.__send__(:define_method, name, &block)
    set_method_visibility(mod, name, visibility)
  end
end
