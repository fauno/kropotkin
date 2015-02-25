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

# Tomamos la extensión, si la tiene nos fijamos si está permitida
      ext = url.scan(/\.([a-z0-9]+)([?#].*)?$/)

      return if not ext.nil? and not ext.empty? and not [ '.htm', '.php', '.asp', '.html' ].include? ext.first.first

      # Ignorar lo que no sea html
      Net::HTTP.start uri.host, uri.port, :use_ssl => uri.scheme == 'https' do |http|
        if not http.head(uri.path)['content-type'] =~ /text\/html/
          return
        end
      end

      resource = OpenGraph.fetch(url)

      if resource
        m.reply HTMLEntities.new.decode(resource.title) unless resource.title.empty?
        m.reply resource.description[0..140] unless resource.description.empty?
      else
        title = Net::HTTP.get(uri).gsub(/\n/, ' ').squeeze(' ').scan(/<title>(.*?)<\/title>/i)[0][0]
        m.reply HTMLEntities.new.decode(title) unless title.empty?
      end
    end
  end

end
