# encoding: utf-8

# Detecta construcciones comunes galponeras como "hay que hacer..." y
# recomienda un curso de acción adhocrático
class Adhocracia
  include Cinch::Plugin

  def initialize(*args)
    super
  end

  match /ha(y|bria|bría) que/, use_prefix: false, method: :adhocracia

  def adhocracia(m)
    m.reply 'che qué buena idea, por qué no la hacés?', true
  end
end
