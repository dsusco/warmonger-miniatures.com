module Jekyll
  module Tags
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

    Liquid::Template.register_tag('heading', Jekyll::Tags::HeadingTag)
  end
end