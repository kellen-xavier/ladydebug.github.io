#!/usr/bin/env ruby
# frozen_string_literal: true

# Reproduce CI's Bundler vendor/bundle directory and use the workflow's Go flags.
# Run with: bundle exec ruby scripts/test_go_modules.rb
require 'fileutils'
require 'open3'
require 'tmpdir'
require 'yaml'

root = File.expand_path('..', __dir__)
workflow = YAML.safe_load(File.read(File.join(root, '.github/workflows/multilingual.yaml')))
flags = workflow.dig('jobs', 'multilingual', 'env', 'GOFLAGS') || ''

Dir.mktmpdir('ladydebug-go-modules-') do |directory|
  %w[go.mod go.sum].each { |name| FileUtils.cp(File.join(root, name), directory) }
  FileUtils.mkdir_p(File.join(directory, 'vendor/bundle'))

  output, status = Open3.capture2e(
    { 'GOFLAGS' => flags }, 'go', 'list', '-m', '-json', 'all', chdir: directory
  )
  abort("FAIL Go module discovery with Bundler's vendor directory:\n#{output}") unless status.success?
  abort('FAIL Hextra module was not resolved') unless output.include?('github.com/imfing/hextra')
  abort('FAIL Module files were unexpectedly rewritten') unless %w[go.mod go.sum].all? do |name|
    FileUtils.compare_file(File.join(root, name), File.join(directory, name))
  end

  puts "PASS Go resolves Hextra with vendor/bundle present, without changing module files"
end
