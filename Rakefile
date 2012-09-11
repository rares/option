#!/usr/bin/env rake
require "bundler/gem_tasks"

require "rake/testtask"

Rake::TestTask.new(:spec) do |test|
  test.libs << "lib" << "spec"
  test.pattern = "spec/**/*_spec.rb"
end
