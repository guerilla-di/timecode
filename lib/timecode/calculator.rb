require File.dirname(__FILE__) + '/../timecode'
require File.dirname(__FILE__) + '/calc/calc'

# A simple timecode calculator. Beware that an integer is subject to strict rule checking.
class Timecode::Calculator < Juliks::Calc
  class TCAtom < Juliks::Calc::Atom
    def value; @value; end
    def initialize(v); @value = v; end
  end
  
  # Timecode can't be negative
  PREFIXES = Hash.new
  
  # Parse the timecode calculation.
  #
  #  Timecode::Calculator.new.parse("10m + 10f") #=> 00:10:00:10
  def parse(io, fps = Timecode::DEFAULT_FPS)
    @fps = fps
    super(io)
  end
  
  def create_subexpr_with(io) #:nodoc
    @stack << self.class.new.parse(io, @fps)
  end
  
  def valid_atom?(atom) #:nodoc
    Timecode.parse(atom, @fps) rescue false
  end
  
  def put_atom(txt) #:nodoc
    @stack << TCAtom.new(Timecode.parse(txt, @fps))
  end
end
