module BranchUrlHelper
  def branch_url(url)
    "#{ENV['BRANCH_DOMAIN']}?deeplink_path=#{url_encode url}"
  end
end
