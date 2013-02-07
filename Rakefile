require 'rake'
require 'rspec/core/rake_task'

task :default => ['spec', 'lint']

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

task :lint do
  sh "puppet-lint manifests --with-filename --error-level error"
end
