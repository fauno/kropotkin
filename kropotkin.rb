# encoding: utf-8
require 'cinch'
require './lib/humanize'
require './lib/url_title'
require './lib/empathy'
require './lib/invite'
require './lib/adhocracia'

NICK = 'kropotkin'

# Array de redes e instancias del bot
$networks = [
  { server: 'irc.hackcoop.com.ar',
    bot: nil,
    port: 6697,
    ssl: true,
    channels: [ '#lab' ] },
  { server: 'irc.pirateirc.net',
    bot: nil,
    port: 6697,
    ssl: true,
    channels: [ '#ppar' ] }
]

instances = []

# Por cada red generar una instancia del cyborg
$networks.each do |n|
  n[:bot] = Cinch::Bot.new do
    configure do |c|
      c.nick = NICK
      c.server = n[:server]
      c.port = n[:port]
      c.channels = n[:channels]
      c.ssl.use = n[:ssl] if not n[:ssl].nil?
      c.plugins.plugins = [ Empathy, UrlTitle, AcceptInvite, Adhocracia ]
    end

    on :message, /\bbugs?\b/i do |m|
      m.reply 'patches welcome', true
    end

    # Corregir
    on :message, /open ?source/i do |m|
      m.reply 'no querrás decir software libre?', true
    end

    on :message, /^[!,]\w+/ do |m|
      m.reply ['a quién le habla?', 'hay un bot por acá? :O', '¬¬'].sample
    end
  end

  # Correr cada instancia en un thread nuevo
  instances << Thread.new { n[:bot].start }
end

# Esperar que terminen!
instances.each { |i| i.join }
