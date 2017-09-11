# encoding: utf-8
require 'yaml'
require 'cinch'
require_relative 'lib/humanize'
require_relative 'lib/url_title'
require_relative 'lib/empathy'
require_relative 'lib/invite'
require_relative 'lib/adhocracia'
require_relative 'lib/remember'
require_relative 'lib/events'

# Carga de la configuracion
config = YAML.load_file('config.yml')

instances = []

# Por cada red generar una instancia del cyborg
config['networks'].each do |n|
  n[:bot] = Cinch::Bot.new do
    configure do |c|
      c.nick = config['nick']
      c.user = config['nick']
      c.password = n['password'] if n['password']
      c.server = n['server']
      c.port = n['port']
      c.channels = n['channels'].map { |c| c['channel'] }
      c.ssl.use = n['ssl'] unless n['ssl'].nil?
      c.plugins.plugins = [Empathy, AcceptInvite, Adhocracia, Remember, Events]
      c.plugins.options[Events] = n['channels']
    end

    on :message, /\bbugs?\b/i do |m|
      m.reply 'patches welcome', true
    end

    # Corregir
    on :message, /open ?source/i do |m|
      m.reply 'no querrás decir software libre?', true
    end

    on :message, /^[!,]\w+/ do |m|
      m.reply ['a quién le habla?', 'hay un bot por acá? :O', '¬¬', 'qué estás haciendo, dave?'].sample
    end

    on :message, /\bbot\b/i do |m|
      m.reply ['a quién le habla?', 'hay un bot por acá? :O', '¬¬', 'qué estás haciendo, dave?'].sample
    end
  end

  # Correr cada instancia en un thread nuevo
  instances << Thread.new { n[:bot].start }
end

# Esperar que terminen!
instances.each(&:join)
