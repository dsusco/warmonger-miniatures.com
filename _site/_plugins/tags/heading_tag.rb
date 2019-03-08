module Jekyll
  module Tags
    class HeadingTag < Liquid::Tag
      def render(context)
        object = context[@markup] || context.registers[:page]
        object['heading'] || object['title'] || object['name']
      end
    end
  end
end

Liquid::Template.register_tag('heading', Jekyll::Tags::HeadingTag)