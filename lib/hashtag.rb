# encoding: utf-8

class Hashtag
  include Cinch::Plugin

  attr_reader :dbm

  match /#\w+/, use_prefix: false, method: :handle_hashtag
  def handle_hashtag(m)
    @dbm ||= GDBM.new("#{m.bot.config.server}_hashtags.db", 0600, GDBM::SYNC)

    matches = m.message.scan /#\w+/
    nick = parse_nick(m)

    # olvidamos un hashtag
    delete = m.message.include? 'olvidame'

    matches.each do |match|
      mensajes = [ "están hablando de #{match}!", 'ping']

      if @dbm.key? match
        if delete
          # FIXME: pasamos a array para borrar un substring?
          @dbm[match] = (@dbm[match].split(',').map(&:strip) - ["@#{nick}"]).join(', ')
        else
          @dbm[match] += ", @#{nick}" unless @dbm[match].include? nick
        end
      else
        @dbm[match] = "@#{nick}" unless delete
      end

      m.reply "#{@dbm[match]} #{mensajes.sample}" if @dbm[match].split(',').count > 1
    end
  end

  def parse_nick(m)
    # si viene de Emma hay que sacar los colores
    if m.user.nick == 'EmmaGoldman'
      Unformat(m.message).scan(/\<\w+\>/).first.gsub('<', '').gsub('>', '')
    else
      m.user.nick
    end
  end
 end
