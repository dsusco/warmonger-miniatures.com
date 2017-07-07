module Jekyll
  module Filters
    # insert the width portion into a picasa URL
    def picasa_width(img_url, width)
      if !!/googleusercontent/ =~ img_url
        String.new(img_url).insert(img_url.rindex('/'), '/s' + width.to_s)
      else
        img_url
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Filters)