module Jekyll
  class ProductIndexPagesGenerator < Jekyll::Generator
    def generate(site)
      create_collection_index_pages(
        site,
        'products',
        URL.new({ template: site.collections['products'].url_template, placeholders: PLACEHOLDERS }).to_s.split('/').reject(&:empty?).join
      )
    end
  end
end
