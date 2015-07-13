# encoding: utf-8
require 'cinch/timer'
# Agregar un temporizador para que las respuestas no sean inmediatas y
# parezca más humano
module HumanMessage
  def reply(text, prefix = false, now = false)
    if now
      super(text, prefix)
    else
      Thread.new do
        sleep rand(10)
        super(text, prefix)
      end
    end
  end
end

module Cinch
  class Message
    prepend HumanMessage
  end
end
