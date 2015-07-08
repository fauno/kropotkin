# encoding: utf-8
require 'cinch/timer'
# Agregar un temporizador para que las respuestas no sean inmediatas y
# parezca más humano
module HumanMessage
  def reply(text, prefix = false)
    Thread.new do
      sleep rand(10)
      super
    end
  end
end

module Cinch
  class Message
    prepend HumanMessage
  end
end
