class Admin::HomeController < Admin::BaseController
  def index
    @nav = {
      "Rails Admin" => "/admin/data",
      "Newsletters" => admin_newsletters_path,
      "Flipper" => "/admin/flipper",
      "Mission Control Jobs" => "/admin/jobs",
      "Litestream" => "/admin/litestream"
    }
  end
end
