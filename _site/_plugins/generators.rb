module Jekyll
  require './_site/_helpers/hash'
  require 'less'
  require 'uglifier'

  class JavascriptGenerator < Generator
    safe true
    priority :high

    def generate(site)
      uglifier_options = (site.config['uglifier'] or {}).symbolize_keys

      site.pages.each do |page|
        if page.ext.eql?('.js')
          includes = page.data['include'].reduce('') { |js, f| js += File.read(f) } rescue ''

          page.content = Uglifier.compile(includes + page.content, uglifier_options)
          page.data['layout'] = nil
        end
      end
    end
  end

  class LessGenerator < Generator
    safe true
    priority :high

    def generate(site)
      css_options = site.config['css'] or {}
      parser_options = site.config['less'] or {}

      site.pages.each do |page|
        if page.ext.eql?('.less')
          parser = Less::Parser.new(parser_options)

          page.content = parser.parse(page.content).to_css(css_options)
          page.data['layout'] = nil
          page.ext = '.css'
        end
      end
    end
  end

  class PagesHashGenerator < Generator
    safe true
    priority :high

    def generate(site)
      site.data['pages'] = {}

      site.each_site_file do |f|
        site.data['pages'][f.url] = f if f.is_a?(Jekyll::Document) or f.html?
      end
    end
  end
end