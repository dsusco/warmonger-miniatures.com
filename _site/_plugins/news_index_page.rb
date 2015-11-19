module Jekyll
  class NewsIndexPage < Page
    def initialize(site, dir, data_hash)
      @site = site
      @base = site.source
      @dir  = dir
      @name = 'index.html'

      process(name)
      read_yaml(File.join(@base, '_layouts'), 'news_index.html')

      data.default_proc = proc do |hash, key|
        site.frontmatter_defaults.find(File.join(dir, name), type, key)
      end

      data
        .merge!(site.frontmatter_defaults.all(File.join(dir, name), type))
        .merge!(data_hash.stringify_keys)

      data['heading'] = "#{site.config['title']} #{data['title']}"
      data['local_nav_weight'] = data['short_title'].to_i * -1

      Jekyll::Hooks.trigger :pages, :post_init, self
    end
  end
end