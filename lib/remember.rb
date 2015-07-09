require 'gdbm'

class Remember
  include Cinch::Plugin

  listen_to :join

  attr_reader :dbm

  def listen(m)
    @dbm ||= GDBM.new("#{m.bot.config.server}.db", 0600, GDBM::SYNC)

    unless @dbm.key?(m.user.nick)
      @dbm[m.user.nick] ||= Time.now.to_s
      m.reply ['qué tal?', ':)', 'hola', 'hola!', 'o/'].sample, true
    else
      m.reply ['o/','\o','ea'].sample, true
    end
  end
end
