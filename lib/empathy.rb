# encoding: utf-8
class Empathy
  include Cinch::Plugin

  match /!!/, use_prefix: false, method: :surprise
  def surprise(m)
    m.reply ":O"
  end

  match /:[c\(]$/, use_prefix: false, method: :hug
  def hug(m)
    # TODO humanizar las actions
    Timer(rand(10), shots: 1) { m.channel.action "abraza a #{m.user.nick} :)" }
  end

  match /\\o\//i, use_prefix: false, method: :cheer
  def cheer(m)
    m.reply '\o/'
  end

  match /(\A|\s)o\//i, use_prefix: false, method: :greet
  match /\\o(\Z|\s)/i, use_prefix: false, method: :greet
  # Saludar
  def greet(m)
    m.reply ['o/', '\o', 'ea'].sample, true
  end

  match /gat(it)?[oa]s?/i, use_prefix: false, method: :gatitos
  def gatitos(m)
    if /\bmacri/i =~ m.text
      m.reply 'dónde está santiago maldonado?'
    else
      m.reply 'LOS GATITOS SON LO MEJOR'
    end
  end
end
