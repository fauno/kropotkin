# encoding: utf-8
require 'net/https'
require 'opengraph'
require 'htmlentities'

class UrlTitle
  include Cinch::Plugin

  def initialize(*args)
    super
  end

  match /https?:\/\/[^'"]+/, use_prefix: false, method: :fetch_title

  def fetch_title(m)
    m.message.scan(/https?:\/\/[^'" #]+/).each do |url|
      url = URI.encode(url)
      uri = URI(url)

      # icecast devuelve text/html para los los streams..
      if uri.path.end_with?('ogg', 'mp3', 'ogv', 'webm', 'mp4')
        info 'es un archivo de medios'
        m.reply 'no puedo leer eso', false, true
        next
      end

      # Ignorar lo que no sea html
      Net::HTTP.start uri.host, uri.port,
                      use_ssl: uri.scheme == 'https' do |http|
        info 'averiguando si es un html'
        unless http.head(uri.path)['content-type'] =~ /\Atext\/html\Z/
          info 'no lo es'
          next
        end
      end

      info 'opengraph'
      resource = OpenGraph.fetch(url)

      if resource
        title = anti_blockflare(HTMLEntities.new.decode(resource.title))

        m.reply(title, false, true) unless resource.title.empty?
        m.reply(resource.description[0..140], false,
                true) unless resource.description.empty?
      else
        title = Net::HTTP.get(uri).tr("\n", ' ').squeeze(' ').scan(
          /<title>(.*?)<\/title>/i
        )[0][0]
        title = HTMLEntities.new.decode(title)
        title = anti_blockflare(title)
        m.reply(title, false, true) unless title.empty?
      end
    end
  end

  def anti_blockflare(title)
    if title =~ /cloudflare/i
      title.gsub! /cloudflare/i, 'BlockFlare'
      title = title + " - (ノಠ益ಠ)ノ彡┻━┻ "
    end
    title
  end
end
