# Add cache busting for js and css
# try the original path ("public/") and if not found, try "tmp/asset_packager"

require 'action_view/helpers/asset_tag_helper'

module ActionView::Helpers::AssetTagHelper
  private
  def rails_asset_id_with_tmp_assets_path(source)
    asset_id = rails_asset_id_without_tmp_assets_path source
    if asset_id.blank?
      org_dir = config.assets_dir
      begin
        config.assets_dir = $mega_asset_base_path || "#{::Rails.root}/tmp/asset_packager"
        asset_id = rails_asset_id_without_tmp_assets_path source.split('/').last
      ensure
        config.assets_dir = org_dir
      end
    end
    asset_id
  end
  alias_method_chain :rails_asset_id, :tmp_assets_path
end
