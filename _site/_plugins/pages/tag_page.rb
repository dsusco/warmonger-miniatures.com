module Jekyll
  class TagPage < Jekyll::Page
    require 'active_support/inflector'
    require 'active_support/core_ext/hash/keys.rb'

    def initialize(site, base, dir, tag, pages = [])
      @site = site
      @base = base
      @dir = dir
      @name = "#{tag.downcase.dasherize}.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'posts_index.html')

      self.data = site.frontmatter_defaults.all(self.relative_path, self.type)
      self.data['tag'] ||= tag

      self.data['breadcrumb'] ||= (self.data['breadcrumb_template'] % self.data.deep_symbolize_keys).strip rescue nil
      self.data['description'] ||= (self.data['description_template'] % self.data.deep_symbolize_keys).strip rescue nil
      self.data['heading'] ||= (self.data['heading_template'] % self.data.deep_symbolize_keys).strip rescue nil
      self.data['title'] ||= (self.data['title_template'] % self.data.deep_symbolize_keys).strip rescue tag.titleize

      self.data['breadcrumb'].gsub!(/ +/, ' ') rescue nil
      self.data['description'].gsub!(/ +/, ' ') rescue nil
      self.data['heading'].gsub!(/ +/, ' ') rescue nil
      self.data['title'].gsub!(/ +/, ' ')

      if self.data['paginate']
        @dir = File.join(@dir, tag.downcase.dasherize)
        @name = pages.length > 0 ? "page-#{pages.length + 1}.html" : 'index.html'
        self.process(@name)

        self.data['paginator'] = {
          'index' => pages.length,
          'pages' => pages,
          'docs' => site.tags[tag][self.data['paginate']*pages.length, self.data['paginate']],
          'total_docs' => site.tags[tag].length
        }

        if pages.length > 0
          self.data['paginator']['previous_page'] = pages.last
          self.data['breadcrumb'] = "Page #{pages.length + 1}"
          (self.data['heading'] += " #{self.data['breadcrumb']}") rescue nil
          self.data['title'] += " #{self.data['breadcrumb']}"
        end

        pages.push(self)

        if self.data['paginate']*pages.length < site.tags[tag].length
          site.pages << self.data['paginator']['next_page'] = TagPage.new(site, base, dir, tag, pages)
        end
      end

      Jekyll::Hooks.trigger :pages, :post_init, self
    end
  end
end
