module Nostalgia
  class Slabs
    def initialize
      @slabs = Hash.new
    end

    #def {}(index)
    #  @slabs[index]
    #end
    
    def [](index)
      @slabs[index]
    end

    #def =(item)
    #  @slabs=item
    #end
  end
end
