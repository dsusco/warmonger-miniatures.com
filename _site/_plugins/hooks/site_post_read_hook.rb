Jekyll::Hooks.register :site, :post_read do |site|
  site.collections.each do |label, collection|
    site.data[label] =
      collection.docs.reduce({}) do |hash, doc|
        hash.dig_assignment(*doc.url.split('/')[1..-2].push('docs'), [doc])
        hash
      end
  end
end