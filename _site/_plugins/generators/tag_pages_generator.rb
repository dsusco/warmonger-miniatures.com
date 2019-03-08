module Jekyll
  class TagPagesGenerator < Jekyll::Generator
    def generate(site)
      site.data['tags'] ||= {}
      dir = URL.new({ template: site.collections['posts'].url_template, placeholders: PLACEHOLDERS }).to_s.split('/').reject(&:empty?).join

      site.tags.each_key { |tag| site.pages << site.data['tags'][tag] = TagPage.new(site, site.source, File.join(dir, 'tags'), tag) }
    end
  end
end
