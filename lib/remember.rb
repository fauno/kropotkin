require 'gdbm'

class Remember
  include Cinch::Plugin

  listen_to :join

  attr_reader :dbm

  def initialize(*args)
    @dbm ||= GDBM.new('remember.db', 0600, GDBM::SYNC)
  end

  def listen(m)
    unless @dbm.key?(m.user.nick)
      @dbm[m.user.nick] ||= Time.now
      m.reply ['qué tal?', ':)', 'hola', 'hola!', 'o/'].sample, true
    else
      m.reply ['o/','\o','ea'].sample, true
    end
  end
end
