# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://mercedes177.ru"

SitemapGenerator::Sitemap.create do
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  add about_info_path, priority: 0.7, changefreq: 'weekly'
  add about_contacts_path, priority: 0.7, changefreq: 'weekly'
  add about_policy_path, priority: 0.7, changefreq: 'weekly'
  add '/catalog/static', priority: 0.8, changefreq: 'daily'
end
