module Jekyll
  class Generator
    PLACEHOLDERS = Hash[%i(year month i_month day i_day y_day short_year hour minute second title slug categories date pretty ordinal none collection path name title output_ext).map { |k| [k, ''] }]

    private
      def create_collection_index_pages(site, collection, label, hash = site.data[collection], dir = label)
        hash = hash[label]
        site.pages << hash['index'] = CollectionIndexPage.new(site, site.source, dir, label, collection)

        hash.each_key { |key| create_collection_index_pages(site, collection, key, hash, File.join(dir, key)) if hash[key].is_a?(Hash) }
      end
  end
end