require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'metric_fu'
require 'rspec/core/rake_task'

namespace :spec do
  RSpec::Core::RakeTask.new("rcov") do |t|
    t.pattern = "spec/**/*_spec.rb"
    t.rcov = true
    t.rcov_opts = ["--exclude", "\/Library\/Ruby"]
  end
end

MetricFu::Configuration.run do |config|
  config.rcov[:test_files] = ["spec/**/*_spec.rb"]  
  config.rcov[:rcov_opts] << "-Ispec" # Needed to find spec_helper

  config.metrics  = [:flog, :flay, :rcov, :rails_best_practices, :reek, :stats, :churn]
  config.graphs   = [:flog, :flay, :rcov, :rails_best_practices, :reek, :stats,]
  config.metrics -= [:reek, :flay, :flog]
end

PassengerOverflow2::Application.load_tasks
