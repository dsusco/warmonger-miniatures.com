module Jekyll
  module CloudinaryFilters
    def cloudinary_transformation(url, transformation)
      String.new(url).insert(url.index('warmonger-miniatures/image/upload/') + 34, transformation + '/') rescue nil
    end
  end
end

Liquid::Template.register_filter(Jekyll::CloudinaryFilters)
