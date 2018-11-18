# THIS FILE IS CENTRALLY MANAGED BY sync_spec.rb!
# DO NOT EDIT IT HERE!

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-strings/tasks'
require 'puppet_blacksmith/rake_tasks'
require 'fileutils'
PuppetLint.configuration.send('disable_2sp_soft_tabs')
PuppetLint.configuration.send('disable_arrow_alignment')
PuppetLint.configuration.send('disable_variables_not_enclosed')
FileUtils::mkdir_p 'catalogs'

desc 'Generate the docs'
task :docs do
  require 'erb'
  require 'yaml'
  template = File.read('.README.erb')
  renderer = ERB.new(template, nil, '-')
  File.write('README.md', renderer.result())
end
