require 'heroku_asset_packager/railtie'

class HerokuAssetPackager
  @@regex_pattern = /\/\w+\/(.*)_packaged.*/i
  CONTENT_TYPES = {'.js' => 'text/javascript', '.css' => 'text/css'}

  def initialize_asset_packager
    override_asset_packager
    # Make dirs
    unless File.directory? heroku_file_location
      Dir.mkdir(heroku_file_location)
    end
    
    # Set asset base path
    # TODO: Check to see if this is a globally used thing?
    $mega_asset_base_path = heroku_file_location
    Synthesis::AssetPackage.build_all
    
  end
  
  def enabled?
    Synthesis::AssetPackage.merge_environments.include?(Rails.env)
  end
  
  def initialize(app)
    @app = app
    initialize_asset_packager if enabled?
  end
  
  def call(env)
    @env = env
    if enabled?
      return render_css if env['PATH_INFO'] =~ %r[^/stylesheets/.*_packaged.css$]i
      return render_js if env['PATH_INFO'] =~ %r[^/javascripts/.*_packaged.js$]i
    end
    
    @app.call(env)
  end
  
  def render_js
    file_name = @@regex_pattern.match(@env['PATH_INFO'])[1]
    file = "#{heroku_file_location}/#{file_name}_packaged.js"
    [
      200,
      headers_for(file),
      File.read(file)
    ]
  end
  
  def render_css
    file_name = @@regex_pattern.match(@env['PATH_INFO'])[1]
    file = "#{heroku_file_location}/#{file_name}_packaged.css"
    [
      200,
      headers_for(file),
      File.read(file)
    ]
  end

  def headers_for(file)
    {
      'Cache-Control'  => 'public, max-age=31536000',
      'Expires' => CGI.rfc1123_date(Time.now + 1.year),
      'Last-Modified' => CGI.rfc1123_date(File.mtime(file)),
      'Content-Length' => File.size(file).to_s,
      'Content-Type'   => CONTENT_TYPES[File.extname(file)]
    }
  end

  def heroku_file_location
    "#{::Rails.root}/tmp/asset_packager"
  end
end