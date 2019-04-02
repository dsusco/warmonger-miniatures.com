module Jekyll
  class CollectionIndexPage < Jekyll::Page
    def initialize(site, base, dir, name, collection, pages = [])
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      hash = site.data[collection].dig(*dir.split('/'))

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), "#{collection}_index.html")

      self.data = site.frontmatter_defaults.all(self.relative_path, self.type)
      self.data['dirs'] = hash.reject { |k| %w(docs index).include?(k) }
      self.data['docs'] = hash['docs']

      if collection.eql?('posts')
        self.data['date'] = name
        self.data['full_date'] = dir.split('/')[1..-1].join('-')
      end

      self.data['breadcrumb'] ||= (self.data['breadcrumb_template'] % self.data.deep_symbolize_keys).strip rescue nil
      self.data['description'] ||= (self.data['description_template'] % self.data.deep_symbolize_keys).strip rescue nil
      self.data['heading'] ||= (self.data['heading_template'] % self.data.deep_symbolize_keys).strip rescue nil
      self.data['title'] ||= (self.data['title_template'] % self.data.deep_symbolize_keys).strip rescue ActiveSupport::Inflector.titleize(name)
      self.data['id'] ||= ActiveSupport::Inflector.parameterize(self.data['title'], { separator: '_' })

      self.data['breadcrumb'].gsub!(/ +/, ' ') rescue nil
      self.data['description'].gsub!(/ +/, ' ') rescue nil
      self.data['heading'].gsub!(/ +/, ' ') rescue nil
      self.data['title'].gsub!(/ +/, ' ')

      if self.data['paginate']
        docs = hash.deep_reference('docs').sort { |a, b| b.data['date'] <=> a.data['date'] }
        @name = pages.length > 0 ? "page-#{pages.length + 1}.html" : 'index.html'
        self.process(@name)

        self.data['paginator'] = {
          'index' => pages.length,
          'pages' => pages,
          'docs' => docs[self.data['paginate']*pages.length, self.data['paginate']],
          'total_docs' => docs.length
        }

        if pages.length > 0
          self.data['paginator']['previous_page'] = pages.last
          self.data['breadcrumb'] = "Page #{pages.length + 1}"
          (self.data['heading'] += " #{self.data['breadcrumb']}") rescue nil
          self.data['title'] += " #{self.data['breadcrumb']}"
        end

        pages.push(self)

        if self.data['paginate']*pages.length < docs.length
          site.pages << self.data['paginator']['next_page'] = CollectionIndexPage.new(site, base, dir, name, collection, pages)
        end
      end

      Jekyll::Hooks.trigger :pages, :post_init, self
    end
  end
end
