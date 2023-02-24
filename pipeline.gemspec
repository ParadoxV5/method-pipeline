# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'pipeline'
  spec.summary = 'Pure-Ruby solution to method pipelines'
  spec.version = '1.0.1'
  spec.required_ruby_version = '~> 3.2'
  
  spec.author = 'ParadoxV5'
  spec.license = 'UPL-1.0'
  
  github = 
    spec.homepage =
    spec.metadata['homepage_uri'] =
    spec.metadata['source_code_uri'] = 'https://github.com/ParadoxV5/ruby-pipeline'
  spec.metadata['changelog_uri'] = "#{github}/commits"
  spec.metadata['bug_tracker_uri'] = "#{github}/issues"
  spec.metadata['documentation_uri'] = 'https://ParadoxV5.github.io/ruby-pipeline/'
  
  spec.files = Dir['**/*']
  spec.require_paths = ['lib']
end
