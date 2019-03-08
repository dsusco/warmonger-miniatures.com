module Jekyll
  module Tags
    class BreadcrumbTag < Liquid::Tag
      def render(context)
        page = context.registers[:page]
        breadcrumb = context[@markup]

        begin
          text = breadcrumb['breadcrumb'] || breadcrumb['title'] || breadcrumb['name']
          page['url'].eql?(breadcrumb['url']) ? "<a>#{text}</a>" : %Q`<a href="#{breadcrumb['url']}">#{text}</a>`
        rescue
          ''
        end
      end
    end
  end
end

Liquid::Template.register_tag('breadcrumb', Jekyll::Tags::BreadcrumbTag)