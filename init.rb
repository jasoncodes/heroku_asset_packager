require 'asset_packager_overrides'
require 'heroku_asset_packager/action_view'
Rails.application.config.middleware.use HerokuAssetPackager
