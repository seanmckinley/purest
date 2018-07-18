# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'purest'
  s.version     = '0.1.0'
  s.date        = '2018-06-29'
  s.summary     = "A ruby gem for interacting with PURE storage's REST API"
  s.authors     = ['Sean McKinley']
  s.email       = 'sean.mckinley@outlook.com'
  s.files       = `git ls-files lib README.md`.split("\n")
  s.license     = 'MIT'

  s.add_development_dependency 'cucumber', '~> 2.0'
  s.add_development_dependency 'pry', '~> 0.11.3'
  s.add_development_dependency 'rspec', '~> 3.7.0'
  s.add_development_dependency 'fakes-rspec', '~> 2.1'
  s.add_development_dependency 'rubocop', '~> 0.57.2'
  s.add_development_dependency 'webmock', '~> 3.4.0'

  s.add_runtime_dependency 'faraday', '~> 0.15.2'
  s.add_runtime_dependency 'faraday_middleware', '~> 0.12.2'
  s.add_runtime_dependency 'faraday-cookie_jar', '~> 0.0.6'
end
