# encoding: utf-8
class Empathy
  include Cinch::Plugin

  match /!!/, use_prefix: false, method: :surprise
  def surprise(m)
    m.reply ":O"
  end

  match /:[c\(]/, use_prefix: false, method: :hug
  def hug(m)
    Timer(rand(10), shots: 1) { m.channel.action "abraza a #{m.user.nick} :)" }
  end

  match /(^|\s)\\o\//i, use_prefix: false, method: :cheer
  def cheer(m)
    m.reply '\o/'
  end

  match /(\s|^)(\\o|o\/)/i, use_prefix: false, method: :greet
  # Saludar
  def greet(m)
    m.reply ["o/", '\o'].sample
  end
end
