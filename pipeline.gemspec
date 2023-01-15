# frozen_string_literal: true
require_relative 'lib/pipeline/version'

Gem::Specification.new do |spec|
  spec.name = 'pipeline'
  spec.summary = ''
  spec.version = Pipeline::VERSION
  spec.required_ruby_version = '~> 3.2'
  
  spec.author = 'ParadoxV5'
  spec.license = ''
  
  github = 'https://github.com/ParadoxV5/ruby-pipeline'
  spec.metadata['source_code_uri'] = github
  spec.metadata['changelog_uri'] = "#{github}/commits"
  spec.metadata['bug_tracker_uri'] = "#{github}/issues"
  spec.metadata['documentation_uri'] =
    spec.metadata['homepage_uri'] =
    spec.homepage = 'https://ParadoxV5.github.io/ruby-pipeline/'
  
  spec.files = Dir['**/*']
  spec.require_paths = ['lib']
  
  spec.add_development_dependency 'rbs', '~> 2.8.0'
  spec.add_development_dependency 'steep', '~> 1.3.0'
  spec.add_development_dependency 'yard', '~> 0.9.0'
  spec.add_development_dependency 'commonmarker', '~> 0.23.0'
  spec.add_development_dependency 'rspec', '~> 3.12.0'
end
