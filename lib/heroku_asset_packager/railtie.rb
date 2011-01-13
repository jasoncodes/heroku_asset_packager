require 'rails'

module HerokuAssetPackagerRails
  class Railtie < Rails::Railtie
    initializer :after_initialize do
      require 'synthesis'
      require 'asset_packager_overrides'
      require 'heroku_asset_packager/action_view'
      Rails.application.config.middleware.use HerokuAssetPackager
    end
  end
end
