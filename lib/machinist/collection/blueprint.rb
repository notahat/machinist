require 'machinist/blueprint'

class Machinist::Collection
  class Blueprint < Machinist::Blueprint
    
    def lathe_class
      Machinist::Collection::Lathe
    end

  end
end
