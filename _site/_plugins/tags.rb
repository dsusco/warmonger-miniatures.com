module Jekyll
  module Tags
    class BreadcrumbsTag < Liquid::Tag
      def initialize(tag_name, markup, parse_context)
        markup.strip!.gsub!(/\\([{}])/, '\1')
        super
      end

      def render(context)
        page = current_page = context.registers[:site].data['pages'][context.registers[:page]['url']]
        breadcrumbs = []

        while page
          breadcrumbs.unshift(page)
          page = page.data['parent']
        end

        breadcrumbs.reduce('') do |html, breadcrumb|
          html += Liquid::Template.parse(@markup).render({
            'breadcrumb'=> breadcrumb,
            'page'=> current_page
          }) + "\n"
        end
      end
    end

    class HeadingTag < Liquid::Tag
      def initialize(tag_name, markup, parse_context)
        markup.strip!
        super
      end

      def render(context)
        page = context[@markup]
        page['heading'] || page['title'] || page['name']
      end
    end

    class LocalNavTag < Liquid::Tag
      def initialize(tag_name, markup, parse_context)
        markup.strip!.gsub!(/\\([{}])/, '\1')
        super
      end

      def render(context)
        site = context.registers[:site]
        local_nav = site.data['local_nav']
        page = site.data['pages'][context.registers[:page]['url']]
        directories = (page.data['local_nav'] || File.dirname(page.url)).split(/\//)

        directories.push('') if directories.empty?

        directories.each do |token|
          token += '/'
          local_nav = local_nav[token]
        end

        render_local_nav(local_nav, page) unless local_nav.nil?
      end

      private

        def render_local_nav(links, page)
          sort_local_nav(links).reduce('') do |html, link|
            if link.is_a?(Hash)
              unless link['index.html'].data['hide_local_nav']
                html += Liquid::Template.parse(@markup).render({
                  'link'=> link['index.html'],
                  'page'=> page,
                  'section'=> render_local_nav(link, page)
                }) + "\n"
              else
                html
              end
            elsif link.is_a?(Jekyll::Document) or not link.index?
              unless link.data['hide_local_nav']
                html += Liquid::Template.parse(@markup).render({
                  'link'=> link,
                  'page'=> page
                }) + "\n"
              else
                html
              end
            else
              html
            end
          end
        end

        def sort_local_nav(links)
          links.values
            .sort { |a, b|
              a = a['index.html'] if a.is_a?(Hash)
              b = b['index.html'] if b.is_a?(Hash)

              begin
                if a.data['local_nav_weight'].to_i < b.data['local_nav_weight'].to_i
                  -1
                elsif a.data['local_nav_weight'].to_i > b.data['local_nav_weight'].to_i
                  1
                else
                  0
                end
              rescue
                0
              end
            }
        end
    end

    class ShortTitleTag < Liquid::Tag
      def initialize(tag_name, markup, parse_context)
        markup.strip!
        super
      end

      def render(context)
        page = context[@markup]
        page['short_title'] || page['title'] || page['name']
      end
    end

    Liquid::Template.register_tag('breadcrumbs', Jekyll::Tags::BreadcrumbsTag)
    Liquid::Template.register_tag('heading', Jekyll::Tags::HeadingTag)
    Liquid::Template.register_tag('local_nav', Jekyll::Tags::LocalNavTag)
    Liquid::Template.register_tag('short_title', Jekyll::Tags::ShortTitleTag)
  end
end