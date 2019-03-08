module Jekyll
  module Tags
    class PaginatorLinkTag < Liquid::Tag
      def render(context)
        params = @markup.split(',').map(&:strip)
        linked_page = context[params[0]]
        text = context[params[1]] || linked_page['title'] || linked_page['name']
        link_class = context[params[2]] || ''

        begin
          if !context.registers[:page]['url'].eql?(linked_page['url'])
            paginator_link = %Q`<a class="#{link_class}" href="#{linked_page['url']}" title="#{linked_page['title'] || linked_page['name']}">#{text}</a>`
          elsif (linked_page['paginator']['index'] + 1) == text
            link_class += ' current'
          end
        rescue
        ensure
          paginator_link ||= %Q`<a class="#{link_class}">#{text}</a>`
        end

        paginator_link
      end
    end
  end
end

Liquid::Template.register_tag('paginator_link', Jekyll::Tags::PaginatorLinkTag)