# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'method-pipeline'
  spec.summary = 'Pure-Ruby solution to method pipelines'
  spec.version = '1.0.3'
  spec.author = 'ParadoxV5'
  spec.license = 'UPL-1.0'
  

  github_account = spec.author
  github = File.join 'https://github.com', github_account, spec.name
  spec.homepage = github
  spec.metadata = {
    'homepage_uri'      => spec.homepage,
    'source_code_uri'   => github,
    'changelog_uri'     => File.join(github, 'releases'),
    'bug_tracker_uri'   => File.join(github, 'issues'),
    'documentation_uri' => File.join('https://rubydoc.info/gems', spec.name)
  }
  
  spec.files = Dir['**/*']
  spec.required_ruby_version = '~> 3.2'
end
