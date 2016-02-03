# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'poly_delegate/call'
require 'poly_delegate/classic_access'
require 'poly_delegate/force_bind'

module PolyDelegate
  module Delegated
    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        intercepted = [base, Object, Kernel, BasicObject]
        intercepted = intercepted.map(&:instance_methods).reduce(&:-)

        intercepted.each do |name|
          PolyDelegate.create_delegated_method(base, name)
        end
      end
    end

    module ClassMethods
      include ClassicAttributeAccess

      def method_added(name)
        return if %i(method_missing initialize).include?(name)
        return if PolyDelegate.callers(2).include?(:redefine_method)

        PolyDelegate.create_delegated_method(self, name)
      end
    end
  end
end
