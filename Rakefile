require "puppetlabs_spec_helper/rake_tasks"
require "puppet-strings/tasks"
require "puppet_blacksmith/rake_tasks"
require "fileutils"
require "json"
require "tmpdir"

begin
  require "puppet_litmus/rake_tasks"
rescue LoadError
  # Litmus is only installed for the acceptance bundle.
end

PuppetLint.configuration.send("disable_2sp_soft_tabs")
PuppetLint.configuration.send("disable_arrow_alignment")
PuppetLint.configuration.send("disable_variables_not_enclosed")

FileUtils.mkdir_p "catalogs"

UPSTREAM_FIREWALL_REPO = "https://github.com/puppetlabs/puppetlabs-firewall.git".freeze
UPSTREAM_FIREWALL_DIR = ENV.fetch("PUPPETLABS_FIREWALL_DIR", "../puppetlabs-firewall")

def metadata_from(path)
  JSON.parse(File.read(File.join(path, "metadata.json")))
end

def firewall_dependency_version(metadata)
  dependency = metadata.fetch("dependencies").find do |candidate|
    candidate.fetch("name") == "puppetlabs/firewall"
  end

  dependency.fetch("version_requirement").split.last
end

def latest_version_matrix_entry
  lines = File.readlines("README.md", chomp: true)
  start = lines.index("## Version compatibility")
  raise "README.md is missing the Version compatibility section" unless start

  rows = lines[(start + 1)..].take_while { |line| !line.start_with?("## ") }
  rows = rows.select do |line|
    line.include?("|") && !line.match?(/\A-+\|/) && line != "firewall_multi|firewall"
  end

  rows.last.split("|", 2)
end

desc "Generate the docs"
task :docs do
  require "erb"
  template = File.read(".README.erb")
  renderer = ERB.new(template, trim_mode: "-")
  File.write("README.md", renderer.result)
end

desc "Run yamllint"
task :yamllint do
  sh "yamllint ."
end

desc "Run ShellCheck"
task :shellcheck do
  sh "shellcheck gen_params.sh"
end

task lint: [:shellcheck, :yamllint, :rubocop]

namespace :docs do
  desc "Check generated docs are up to date"
  task :check do
    Rake::Task[:docs].invoke
    sh "git diff --exit-code README.md"
  end
end

namespace :security do
  desc "Check dependencies for known vulnerabilities"
  task :bundle_audit do
    sh "bundle exec bundle-audit check --update"
  end
end

namespace :module do
  desc "Build and install the module package"
  task install_check: [:build] do
    package = Dir["pkg/*.tar.gz"].max
    modulepath = "/tmp/firewall_multi_modulepath"

    raise "No package found in pkg/" unless package

    FileUtils.rm_rf(modulepath)
    FileUtils.mkdir_p(modulepath)

    temp_parent = Dir.exist?("/private/tmp") ? "/private/tmp" : Dir.tmpdir
    Dir.mktmpdir("firewall_multi_home", temp_parent) do |home|
      sh(
        {"HOME" => home},
        "bundle exec puppet module install #{package} --modulepath #{modulepath} --ignore-dependencies"
      )
    end
  end
end

namespace :upstream do
  desc "Fetch puppetlabs-firewall for compatibility checks"
  task :clone do
    next if Dir.exist?(UPSTREAM_FIREWALL_DIR)

    sh "git clone --depth 1 #{UPSTREAM_FIREWALL_REPO} #{UPSTREAM_FIREWALL_DIR}"
  end
end

namespace :generated_manifest do
  desc "Check generated manifest is up to date"
  task check: "upstream:clone" do
    generated = "/tmp/firewall_multi_init.pp"

    sh "bash gen_params.sh > #{generated}"
    sh "diff -u manifests/init.pp #{generated}"
  end
end

namespace :release do
  desc "Check metadata version matches the latest git tag"
  task :tag_matches_metadata do
    metadata = metadata_from(".")
    version = metadata.fetch("version")
    latest_tag = `git tag --sort=-creatordate | head -1`.chomp

    raise "metadata.json version #{version} does not match latest tag #{latest_tag}" unless latest_tag == version
  end

  desc "Check README version matrix matches metadata"
  task :version_matrix do
    metadata = metadata_from(".")
    version = metadata.fetch("version")
    expected_module_version, expected_firewall_version = latest_version_matrix_entry

    unless version == expected_module_version
      raise(
        "metadata.json version #{version} does not match README version matrix #{expected_module_version}"
      )
    end

    unless firewall_dependency_version(metadata) == expected_firewall_version.split.last
      raise "metadata.json firewall dependency does not match README version matrix #{expected_firewall_version}"
    end
  end

  desc "Check CHANGELOG mentions the current module version"
  task :changelog do
    metadata = metadata_from(".")
    version = metadata.fetch("version")
    first_line = File.readlines("CHANGELOG", chomp: true).first

    raise "CHANGELOG does not mention version #{version} on the first line" unless first_line.include?(version)
  end

  desc "Check generated README mentions the current module version"
  task :readme_version do
    metadata = metadata_from(".")
    version = metadata.fetch("version")
    escaped_version = Regexp.escape(version)

    found_version = File.readlines("README.md").any? do |line|
      line.match?(/\A#{escaped_version}\|\d+\.\d+\.\d+/)
    end

    raise "README.md version matrix does not mention version #{version}" unless found_version
  end

  desc "Check upstream operating system support is mirrored"
  task os_support: "upstream:clone" do
    metadata = metadata_from(".")
    upstream_metadata = metadata_from(UPSTREAM_FIREWALL_DIR)

    unless metadata.fetch("operatingsystem_support") == upstream_metadata.fetch("operatingsystem_support")
      raise "metadata.json operatingsystem_support does not match upstream puppetlabs-firewall"
    end
  end

  desc "Run release consistency checks"
  task check: [:tag_matches_metadata, :version_matrix, :changelog, :readme_version, "docs:check", :os_support]
end

namespace :ci do
  desc "Run CI build checks"
  task build: [
    :validate,
    :lint,
    :spec,
    "docs:check",
    "security:bundle_audit",
    "module:install_check",
    "generated_manifest:check"
  ]

  desc "Run Litmus acceptance checks"
  task :acceptance do
    Rake::Task[:spec_prep].invoke
    Rake::Task["litmus:provision_list"].invoke("default")
    Rake::Task["litmus:install_agent"].invoke("puppet8")
    Rake::Task["litmus:install_module"].invoke
    Rake::Task["litmus:acceptance:parallel"].invoke
  end

  desc "Tear down Litmus acceptance targets"
  task :acceptance_teardown do
    Rake::Task["litmus:tear_down"].invoke
  end
end
