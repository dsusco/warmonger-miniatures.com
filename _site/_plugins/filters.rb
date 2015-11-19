module Jekyll
  module Filters
    # insert the width portion into a picasa URL
    def picasa_width(img_url, width)
      String.new(img_url).insert(img_url.rindex('/'), '/s' + width.to_s)
    end
  end
end

Liquid::Template.register_filter(Jekyll::Filters)