require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

Rake::Task[:lint].clear
PuppetLint.configuration.relative = true
PuppetLint::RakeTask.new(:lint) do |config|
  config.fail_on_warnings = true
  config.disable_checks = [
    'class_inherits_from_params_class',
    'class_parameter_defaults',
    'documentation',
    'single_quote_string_with_variables',
  ]
  config.ignore_paths = ["tests/**/*.pp", "vendor/**/*.pp","examples/**/*.pp", "spec/**/*.pp", "pkg/**/*.pp"]
end
