module Approximately
  VERSION = "1.1.0"
  DEFAULT_DELTA = 0.01

  # This object can be used for float comparisons. When it is instantiaded
  # with a float and a delta it will respond to <=>(another_float) and
  # will return equality if the float it's being compared to is within the
  # delta
  class DeltaFloat < Struct.new(:float, :delta)
    include Comparable

    def to_f
      float.to_f
    end

    def <=>(another)
      d = (to_f - another.to_f).abs
      return 0 if d < delta
      float <=> another.to_f
    end

    def inspect
      "~%0.8f" % to_f
    end

    def to_s
      inspect
    end

  end

  # Returns the passed Float into a DeltaFloat object. The optional
  # second argument is the delta that will be considered sufficient for
  # the comparison to evaluate to true
  def approx(float, delta = DEFAULT_DELTA)
    DeltaFloat.new(float, delta)
  end

  module_function :approx
end