# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

begin
  case RUBY_ENGINE
  when 'ruby'
    require 'force_bind'
  when 'rbx'
    require 'force_bind_rbx'
  end
# ensure because we could run into a LoadError and need to give more info
ensure
  unless UnboundMethod.method_defined?(:force_bind)
    raise NotImplementedError, <<-EOF
      UnboundMethod#force_bind is not defined.

      Implement UnboundMethod#force_bind or install a gem that implements it
      before continuing. Known implementations are in the 'force_bind' and
      'force_bind_rbx' gems for MRI and Rubinius respectively.
    EOF
  end
end
