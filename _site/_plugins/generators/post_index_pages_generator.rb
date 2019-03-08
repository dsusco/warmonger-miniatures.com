module Jekyll
  class PostIndexPagesGenerator < Jekyll::Generator
    def generate(site)
      create_collection_index_pages(
        site,
        'posts',
        URL.new({ template: site.collections['posts'].url_template, placeholders: PLACEHOLDERS }).to_s.split('/').reject(&:empty?).join
      )
    end
  end
end
