# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

require 'rubygems'
require 'rubygems/command'
require 'rubygems/dependency_installer'

begin
  Gem::Command.build_args = ARGV
rescue NoMethodError
end

installer = Gem::DependencyInstaller.new

case RUBY_ENGINE
when 'rbx'
  installer.install 'force_bind_rbx'
when 'ruby'
  installer.install 'force_bind'
end

File.open(File.join(File.dirname(__FILE__), 'Rakefile'), 'w') do |f|
  f.write('task :default')
end
