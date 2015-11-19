module Jekyll
  require 'less'

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
end