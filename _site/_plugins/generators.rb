module Jekyll
  require './_site/_helpers/hash'
  require 'less'
  require 'rss'
  require 'uglifier'

  class DocumentLocalNavWeightGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      site.documents.each do |document|
        document.data['local_nav_weight'] = document.data['date'].to_i * -1
      end
    end
  end

  class JavascriptGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      uglifier_options = (site.config['uglifier'] or {}).symbolize_keys

      site.pages.each do |page|
        if page.ext.eql?('.js')
          includes = page.data['include'].reduce('') { |js, f| js += File.read(f) } rescue ''

          page.content = Uglifier.compile(includes + page.content, uglifier_options)
          page.data['layout'] = nil
        end
      end
    end
  end

  class LessGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      css_options = site.config['css'] or {}
      parser_options = site.config['less'] or {}

      site.pages.each do |page|
        if page.ext.eql?('.less')
          parser = Less::Parser.new(parser_options)

          page.content = parser.parse(page.content).to_css(css_options)
          page.data['layout'] = nil
          page.ext = '.css'
        end
      end
    end
  end

  class NewsIndexPageGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      index_pages = {}

      site.documents.each do |document|
        dir = '/'
        title = nil

        File.dirname(document.url).split(/\//).slice(1..-1).each do |token|
          dir += token + '/'

          if index_pages["#{dir}index.html"]
            index_pages["#{dir}index.html"].data['documents'].unshift(document)
          else
            short_title = token.split.map(&:capitalize).join(' ') or token.capitalize

            if (title =~ /\d$/) and (short_title =~ /^\d+$/)
              title = title + '-' + short_title rescue short_title
            else
              title = title + ' ' + short_title rescue short_title
            end

            index = NewsIndexPage.new(
              site,
              dir,
              { description: "#{site.config['title']} #{title.downcase.gsub(/(news)(.*)/, '\2 \1').strip} listing: keep up to date on the latest #{site.config['title']} news.",
                short_title: short_title,
                title: title
              }
            )

            index_pages[index.url] = index
            index_pages[index.url].data['documents'] = [document]
          end
        end
      end

      site.pages += index_pages.values
    end
  end

  class ProductImagesGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      site.pages.each do |page|
        if page.html? and page.data['layout'].eql?('product')
          open(page.data['rss']) do |rss|
            page.data['images'] = []

            RSS::Parser.parse(rss).channel.items.each do |item|
              page.data['images'] << { 'title' => item.title, 'url' => item.enclosure.url }
            end
          end
        end
      end
    end
  end

  class TagsIndexPageGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      site.data['tags'] = []
      index_pages = {}

      site.tags.each do |tag, documents|
        index = NewsIndexPage.new(
          site,
          site.config['tag_index_permalink'].gsub(/:tag/, tag),
          { description: "#{tag} news listing: keep up to date on the latest #{site.config['title']} news.",
            short_title: tag,
            title: site.config['tag_index_title'].gsub(/:tag/, tag)
          }
        )

        index_pages[index.url] = index
        index_pages[index.url].data['documents'] = documents
        site.data['tags'] << index
      end

      site.pages += index_pages.values
    end
  end

  class LocalNavGenerator < Generator
    safe true
    priority :high

    def generate(site)
      site.data['local_nav'] = {}

      (site.pages + site.documents).each do |file|
        if file.is_a?(Jekyll::Document) or file.html?
          local_nav = site.data['local_nav']

          file.url.split(/\//).each do |token|
            if token.end_with?('.html')
              local_nav[token] = file
            else
              token += '/'

              local_nav[token] = {} unless local_nav.key?(token)

              local_nav = local_nav[token]
            end
          end
        end
      end
    end
  end

  class PagesHashGenerator < Generator
    safe true
    priority :high

    def generate(site)
      site.data['pages'] = {}

      (site.pages + site.documents).each do |file|
        site.data['pages'][file.url] = file if file.is_a?(Jekyll::Document) or file.html?
      end
    end
  end

  class BreadcrumbsGenerator < Generator
    safe true
    priority :normal

    def generate(site)
      (site.pages + site.documents).each do |file|
        if file.is_a?(Jekyll::Document) or file.html? and not file.url.eql?('/index.html')
          if file.is_a?(Jekyll::Document) or not file.index?
            parent_url = file.url.gsub(/\/[^\/]+\.html\z/, '/index.html')
          else
            parent_url = file.url.gsub(/\/[^\/]+\/index\.html\z/, '/index.html')
          end

          file.data['parent'] = site.data['pages'][parent_url] unless parent_url.empty?
        end
      end
    end
  end

  class StoreCategoryGenerator < Generator
    safe true
    priority :low

    def generate(site)
      site.pages.each do |page|
        if page.html? and page.data['layout'].eql?('product')
          category = page.data['parent']
          category.data['products'] = [] if category.data['products'].nil?
          category.data['products'] << page
        end
      end
    end
  end
end