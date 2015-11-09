Gem::Specification.new do |s|
  s.name = 'komenda'
  s.version = '0.0.3'
  s.summary = 'Convenience wrapper around `Open3` to run shell commands in Ruby.'
  s.description = 'Convenience wrapper around `Open3` to run shell commands in Ruby.'
  s.authors = ['Cargo Media', 'njam']
  s.email = 'hello@cargomedia.ch'
  s.files = Dir['LICENSE*', 'README*', '{bin,lib}/**/*']
  s.homepage = 'https://github.com/cargomedia/komenda'
  s.license = 'MIT'

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake', '~> 10.1'
  s.add_development_dependency 'rspec', '~> 2.0'
  s.add_development_dependency 'event_emitter', '~> 0.2'
end
