module Jekyll
  class ProductImagesGenerator < Jekyll::Generator
    require 'cloudinary'

    Cloudinary.config({
      cloud_name: 'warmonger-miniatures',
      api_key: '983812993163396',
      api_secret: 'VzasF_MEiKGVcxmQ4_2N4QN1xFk',
      enhance_image_tag: true,
      static_file_support: true
    })

    def generate(site)
      sample = {
        'secure_url' => 'http://res.cloudinary.com/warmonger-miniatures/image/upload/v1548863296/sample.jpg',
        'context' => {
          'custom' => {
            'alt' => :alt,
            'caption' => :caption
          }
        }
      }

      site.collections.reduce(site.pages) { |docs, (k, v)| docs + v.docs } .each do |doc|
        if !Jekyll.env.eql?('production')
          doc.data['images'].map! { sample } rescue doc.data['images'] = [sample, sample, sample]
          doc.data['shared_images'] = [sample, sample, sample]
        elsif doc.data['product_code']
          doc.data['images'] = Cloudinary::Api.resources_by_tag(doc.data['product_code'], { context: true, max_results: 500, resource_type: :image })['resources'].sort{ |x, y| x['public_id'] <=> y['public_id'] }
          doc.data['shared_images'] = Cloudinary::Api.resources_by_tag(doc.data['product_code'] + '-shared', { context: true, max_results: 500, resource_type: :image })['resources']
        elsif doc.data['images']
          doc.data['images'] = Cloudinary::Api.resources_by_ids(doc.data['images'], { context: true })['resources']
        end
      end
    end
  end
end
