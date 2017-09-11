# encoding: utf-8
require 'cinch/timer'
# Agregar un temporizador para que las respuestas no sean inmediatas y
# parezca más humano
module HumanMessage
  def reply(text, prefix = false, now = false, always = false)
    if now
      super(text, prefix)
    else
      # no hace falta hablar todo el tiempo
      return unless always || [ true, false, false ].sample

      Thread.new do
        sleep rand(10)
        super(text, prefix)
      end
    end
  end

  # TODO terminar!
  # Encuentra el nick real si estamos usando un bridge como teleirc
  def find_nick
    clean_msg = Formatting.unformat(message)
    if /\A<[^>]+>/ =~ clean_msg
    end
  end
end

module Cinch
  class Message
    prepend HumanMessage
  end
end
