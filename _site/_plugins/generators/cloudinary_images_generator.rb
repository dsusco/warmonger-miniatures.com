module Jekyll
  class CloudinaryImagesGenerator < Jekyll::Generator
    require 'cloudinary'
    require 'yaml'

    priority :lowest

    Cloudinary.config(YAML.load(File.read('_cloudinary.yml')))

    def generate(site)
      site.collections.reduce(site.pages) { |docs, (k, v)| docs + v.docs } .each do |doc|
        if !Jekyll.env.eql?('production')
          sample = {
            'secure_url' => 'http://res.cloudinary.com/warmonger-miniatures/image/upload/v1548863296/sample.jpg',
            'context' => {
              'custom' => {
                'alt' => :alt,
                'caption' => :caption
              }
            }
          }

          doc.data['image'] = sample
          doc.data['images'].map! { sample } rescue doc.data['images'] = [sample, sample, sample]
          doc.data['shared_images'] = [sample, sample, sample]
        elsif doc.data['product_code']
          doc.data['images'] = Cloudinary::Api.resources_by_tag(doc.data['product_code'], { context: true, max_results: 500, resource_type: :image })['resources'].sort{ |x, y| x['public_id'] <=> y['public_id'] }
          doc.data['shared_images'] = Cloudinary::Api.resources_by_tag(doc.data['product_code'] + '-shared', { context: true, max_results: 500, resource_type: :image })['resources']
        else
          doc.data['images'] = Cloudinary::Api.resources_by_ids(doc.data['images'], { context: true })['resources'] if doc.data['images']
          doc.data['image'] = Cloudinary::Api.resources_by_ids(doc.data['image'], { context: true })['resources'][0] if doc.data['image']
        end
      end
    end
  end
end
