spec = Gem::Specification.new do |s|
  s.name = 'heroku_asset_packager'
  s.version = '0.0.1'
  s.summary = "Heroku Asset Packager"
  s.description = %q[A plugin to duck-punch asset packager and provide middleware to work on Heroku with a ROFS.]
  s.author = ''

  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb']
  s.require_path = 'lib'
  s.add_dependency 'asset_packager', '~>0.3.0'
end
