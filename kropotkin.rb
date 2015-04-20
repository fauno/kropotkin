# encoding: utf-8
require 'cinch'
require './lib/humanize'
require './lib/url_title'
require './lib/empathy'
require './lib/invite.rb'
require './lib/adhocracia.rb'

kropotkin = Cinch::Bot.new do
  configure do |c|
    c.nick = "kropotkin"
    c.server = "irc.hackcoop.com.ar"
    c.port = 6697
    c.ssl.use = true
    c.channels = [ "#test", "#lab" ]
    c.plugins.plugins = [ Empathy, UrlTitle, AcceptInvite, Adhocracia ]
  end

  on :message, /bug/i do |m|
    m.reply "patches welcome", true
  end

  # Corregir
  on :message, /open ?source/i do |m|
    m.reply "no querrás decir software libre?", true
  end
end

kropotkin.start
