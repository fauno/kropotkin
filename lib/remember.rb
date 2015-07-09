require 'gdbm'

# Recuerda quién estuvo en qué canal usando una base de datos de
# llave-valor muy muy simple
class Remember
  include Cinch::Plugin

  listen_to :join

  attr_reader :dbm

  def listen(m)
    return if m.user.nick == m.bot.config.nick

    # Inicia la base de datos para este servidor
    @dbm ||= GDBM.new("#{m.bot.config.server}.db", 0600, GDBM::SYNC)

    if channels(m.user.nick).include? m.channel.name
      m.reply ['o/','\o','ea'].sample, true
    else
      seen_in_channel(m.user.nick, m.channel.name)

      m.reply ['qué tal?', ':)', 'hola', 'hola!', 'o/'].sample, true
    end
  end

  # Guarda la lista de canales en las que vimos un nick
  # #test,#test2,#etc
  def seen_in_channel(nick, chan)
    if @dbm.key? nick
      @dbm[nick] += ",#{chan}"
    else
      @dbm[nick] = chan
    end
  end

  # Devuelve todos los canales de un nick en un array
  # [ '#test', '#test2', '#etc' ]
  def channels(nick)
    return [] unless @dbm.key? nick || @dbm[nick].nil?

    @dbm[nick].split(',')
  end
end
