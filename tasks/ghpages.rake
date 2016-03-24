# encoding: utf-8
# Copyright (c) 2016 Nathan Currier

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

if ENV['TRAVIS'] && ENV['DOCS']
  namespace :yard do
    if ENV['TRAVIS_PULL_REQUEST'] == 'false'
      require 'ghpages_deploy/rake_task'

      desc 'Deploy documentation to Github Pages'
      GithubPages::DeployTask.new(deploy: [:yard]) do |t|
        t.remote = 'origin'
        t.source = '_yardoc'

        tag = ENV['TRAVIS_TAG']
        branch = ENV['TRAVIS_BRANCH']

        if !tag.empty?
          t.register "tag/#{tag}"
        elsif !branch.empty?
          t.register "branch/#{branch}"
        end

        t.init_jekyll
        t.json_sitemap(['./_yardoc'])
      end
    else
      task :deploy do
        puts 'Documentation not generated for pull requests.'
      end
    end
  end
end
