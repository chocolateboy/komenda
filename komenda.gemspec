Gem::Specification.new do |s|
  s.name = 'komenda'
  s.version = '0.1.2'
  s.summary = 'Convenience wrapper around `Open3` to run shell commands in Ruby.'
  s.description = 'Convenience wrapper around `Open3` to run shell commands in Ruby.'
  s.authors = ['Cargo Media', 'njam']
  s.email = 'hello@cargomedia.ch'
  s.files = Dir['LICENSE*', 'README*', '{bin,lib}/**/*']
  s.homepage = 'https://github.com/cargomedia/komenda'
  s.license = 'MIT'

  s.add_runtime_dependency 'events', '~> 0.9.8'

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake', '~> 10.1'
  s.add_development_dependency 'rspec', '~> 2.0'
  s.add_development_dependency 'rspec-wait', '~> 0.0.8'
  s.add_development_dependency 'rubocop', '~> 0.35.0'
end
