Gem::Specification.new do |gem|
  gem.name        = 'macros'
  gem.version     = '0.1'
  gem.authors     = [ 'Arne Brasseur' ]
  gem.email       = [ 'arne@arnebrasseur.net' ]
  gem.description = 'Macros for Ruby'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/plexus/macros'
  gem.license     = 'MPL'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split $/
  gem.test_files       = gem.files.grep(/^spec/)
  gem.extra_rdoc_files = %w[README.md]

  gem.add_runtime_dependency 'parser', '> 0'
  gem.add_runtime_dependency 'unparser', '> 0'

  gem.add_development_dependency 'rspec', '~> 3.0'
end
