require 'test/unit'
require 'rubygems'
require 'test/spec'

require File.dirname(__FILE__) + '/../lib/timecode'


context "Timecode.new should" do
  
  specify "instantiate from int" do
    tc = Timecode.new(10)
    tc.should.be.kind_of Timecode
    tc.total.should.equal 10
  end
  
  specify "always coerce FPS to float" do
    Timecode.new(10, 24).fps.should.be.kind_of(Float)
    Timecode.new(10, 25.0).fps.should.be.kind_of(Float)
  end
  
  specify "create a zero TC with no arguments" do
    Timecode.new(nil).should.be.zero?
  end
  
  specify "accept full string SMPTE timecode as well" do
    Timecode.new("00:25:30:10", 25).should.equal Timecode.parse("00:25:30:10")
  end
  
end

context "Timecode.validate_atoms! should" do 
  
  specify "disallow more than 99 hrs" do
    lambda{ Timecode.validate_atoms!(99,0,0,0, 25) }.should.not.raise
    lambda{ Timecode.validate_atoms!(100,0,0,0, 25) }.should.raise(Timecode::RangeError)
  end
  
  specify "disallow more than 59 minutes" do
    lambda{ Timecode.validate_atoms!(1,60,0,0, 25) }.should.raise(Timecode::RangeError)
  end

  specify "disallow more than 59 seconds" do
    lambda{ Timecode.validate_atoms!(1,0,60,0, 25) }.should.raise(Timecode::RangeError)
  end
  
  specify "disallow more frames than what the framerate permits" do
    lambda{ Timecode.validate_atoms!(1,0,45,25, 25) }.should.raise(Timecode::RangeError)
    lambda{ Timecode.validate_atoms!(1,0,45,32, 30) }.should.raise(Timecode::RangeError)
  end
  
  specify "pass validation with usable values" do
    lambda{ Timecode.validate_atoms!(20, 20, 10, 5, 25)}.should.not.raise
  end
end

context "Timecode.at should" do 
  
  specify "disallow more than 99 hrs" do
    lambda{ Timecode.at(99,0,0,0) }.should.not.raise
    lambda{ Timecode.at(100,0,0,0) }.should.raise(Timecode::RangeError)
  end
  
  specify "disallow more than 59 minutes" do
    lambda{ Timecode.at(1,60,0,0) }.should.raise(Timecode::RangeError)
  end

  specify "disallow more than 59 seconds" do
    lambda{ Timecode.at(1,0,60,0) }.should.raise(Timecode::RangeError)
  end
  
  specify "disallow more frames than what the framerate permits" do
    lambda{ Timecode.at(1,0,60,25, 25) }.should.raise(Timecode::RangeError)
    lambda{ Timecode.at(1,0,60,32, 30) }.should.raise(Timecode::RangeError)
  end
  
  specify "propery accept usable values" do
    Timecode.at(20, 20, 10, 5).to_s.should.equal "20:20:10:05"
  end
end

context "A new Timecode object should" do
  specify "be frozen" do
    Timecode.new(10).should.be.frozen
  end
end

context "An existing Timecode should" do
  
  before do
    @five_seconds = Timecode.new(5*25, 25)
    @one_and_a_half_film = (90 * 60) * 24
    @film_tc = Timecode.new(@one_and_a_half_film, 24)
  end
  
  specify "report that the framerates are in delta" do
    tc = Timecode.new(1)
    tc.framerate_in_delta(25.0000000000000001, 25.0000000000000003).should.equal(true)
  end
 
  specify "validate equality based on delta" do
    t1, t2 = Timecode.new(10, 25.0000000000000000000000000001), Timecode.new(10, 25.0000000000000000000000000002)
    t1.should.equal(t2)
  end
  
  specify "report total as it's to_i" do
    Timecode.new(10).to_i.should.equal(10)
  end
  
  specify "support hours" do
    @five_seconds.should.respond_to :hours
    @five_seconds.hours.should.equal 0
    @film_tc.hours.should.equal 1
  end

  specify "support minutes" do
    @five_seconds.should.respond_to :minutes
    @five_seconds.minutes.should.equal 0
    @film_tc.minutes.should.equal 30
  end

  specify "support seconds" do
    @five_seconds.should.respond_to :seconds
    @five_seconds.seconds.should.equal 5
    @film_tc.seconds.should.equal 0
  end
  
  specify "support frames" do
    @film_tc.frames.should.equal 0
  end
  
  specify "report frame_interval as a float" do
    tc = Timecode.new(10)
    tc.should.respond_to :frame_interval
    
    tc.frame_interval.should.be.close 0.04, 0.0001
    tc = Timecode.new(10, 30)
    tc.frame_interval.should.be.close 0.03333, 0.0001
  end
  
  specify "be comparable" do
    (Timecode.new(10) < Timecode.new(9)).should.equal false
    (Timecode.new(9) < Timecode.new(10)).should.equal true
    Timecode.new(9).should.equal Timecode.new(9)
  end
  
  specify "raise on comparison of incompatible timecodes" do
    lambda { Timecode.new(10, 10) < Timecode.new(10, 20)}.should.raise(Timecode::WrongFramerate)
  end
end

context "A Timecode of zero should" do
  specify "properly respond to zero?" do
    Timecode.new(0).should.respond_to :zero?
    Timecode.new(0).should.be.zero
    Timecode.new(1).should.not.be.zero
  end
end

context "Timecode#to_seconds should" do
  specify "return a float" do
    Timecode.new(0).to_seconds.should.be.kind_of Float
  end
  
  specify "return the value in seconds" do
    fps = 24
    secs = 126.3
    Timecode.new(fps * secs, fps).to_seconds.should.be.close 126.3, 0.1
  end
  
  specify "properly roundtrip a value via Timecode.from_seconds" do
    secs_in = 19.76
    from_secs = Timecode.from_seconds(19.76, 25.0)
    from_secs.total.should.equal 494
    from_secs.to_seconds.should.be.close(secs_in, 0.001)
  end
end

context "An existing Timecode on inspection should" do
  specify "properly present himself via inspect" do
    Timecode.new(10, 25).inspect.should.equal "#<Timecode:00:00:00:10 (10F@25.00)>"
    Timecode.new(10, 12).inspect.should.equal "#<Timecode:00:00:00:10 (10F@12.00)>"
  end
  
  specify "properly print itself" do
    Timecode.new(5, 25).to_s.should.equal "00:00:00:05"
  end
end

context "An existing Timecode used within ranges should" do
  specify "properly provide successive value that is one frame up" do
    Timecode.new(10).succ.total.should.equal 11
    Timecode.new(22, 45).succ.should.equal Timecode.new(23, 45) 
  end
  
  specify "work as a range member" do
    r = Timecode.new(10)...Timecode.new(20)
    r.to_a.length.should.equal 10
    r.to_a[4].should.equal Timecode.new(14)
  end
  
end

context "A Timecode on conversion should" do
  specify "copy itself with a different framerate" do
    tc = Timecode.new(40,25)
    at24 = tc.convert(24)
    at24.total.should.equal 40
  end
end

context "A Timecode on calculations should" do
  
  specify "support addition" do
    a, b = Timecode.new(24, 25.000000000000001), Timecode.new(22, 25.000000000000002)
    (a + b).should.equal Timecode.new(24 + 22, 25.000000000000001)
  end
  
  specify "should raise on addition if framerates do not match" do
    lambda{ Timecode.new(10, 25) + Timecode.new(10, 30) }.should.raise(Timecode::WrongFramerate)
  end
  
  specify "when added with an integer instead calculate on total" do
    (Timecode.new(5) + 5).should.equal(Timecode.new(10))
  end
  
  specify "support subtraction" do
    a, b = Timecode.new(10), Timecode.new(4)
    (a - b).should.equal Timecode.new(6)
  end

  specify "on subtraction of an integer instead calculate on total" do
    (Timecode.new(15) - 5).should.equal Timecode.new(10)
  end
  
  specify "raise when subtracting a Timecode with a different framerate" do
    lambda { Timecode.new(10, 25) - Timecode.new(10, 30) }.should.raise(Timecode::WrongFramerate)
  end
  
  specify "support multiplication" do
    (Timecode.new(10) * 10).should.equal(Timecode.new(100))
  end
  
  specify "raise when the resultig Timecode is negative" do
    lambda { Timecode.new(10) * -200 }.should.raise(Timecode::RangeError)
  end
  
  specify "return a Timecode when divided by an Integer" do
    v = Timecode.new(200) / 20
    v.should.be.kind_of(Timecode)
    v.should.equal Timecode.new(10)
  end
  
  specify "return a number when divided by another Timecode" do
    v = Timecode.new(200) / Timecode.new(20)
    v.should.be.kind_of(Numeric)
    v.should.equal 10
  end
end

context "A Timecode used with fractional number of seconds" do
  
  specify "should properly return fractional seconds" do
    tc = Timecode.new(100 -1, fps = 25)
    tc.frames.should.equal 24
    
    tc.with_frames_as_fraction.should.equal "00:00:03.96"
    tc.with_fractional_seconds.should.equal "00:00:03.96"
  end

  specify "properly translate to frames when instantiated from fractional seconds" do
    fraction = 7.1
    tc = Timecode.from_seconds(fraction, 10)
    tc.to_s.should.equal "00:00:07:01"

    fraction = 7.5
    tc = Timecode.from_seconds(fraction, 10)
    tc.to_s.should.equal "00:00:07:05"

    fraction = 7.16
    tc = Timecode.from_seconds(fraction, 12.5)
    tc.to_s.should.equal "00:00:07:01"
  end

end

context "A custom Timecode descendant should" do
  class CustomTC < Timecode; end
  
  specify "properly classify on parse" do
    CustomTC.parse("001").should.be.kind_of CustomTC
  end

  specify "properly classify on at" do
    CustomTC.at(10,10,10,10).should.be.kind_of CustomTC
  end

  specify "properly  classify on calculations" do
    computed = CustomTC.parse("10h") + Timecode.new(10)
    computed.should.be.kind_of CustomTC

    computed = CustomTC.parse("10h") - Timecode.new(10)
    computed.should.be.kind_of CustomTC

    computed = CustomTC.parse("10h") * 5
    computed.should.be.kind_of CustomTC

    computed = CustomTC.parse("10h") / 5
    computed.should.be.kind_of CustomTC
  end

end

context "Timecode.parse should" do
  
  specify "handle complete SMPTE timecode" do
    simple_tc = "00:10:34:10"
    Timecode.parse(simple_tc).to_s.should.equal(simple_tc)
  end
  
  specify "handle timecode with fractional seconds" do
    tc = Timecode.parse("10:10:10.2", 25)
    tc.to_s.should.equal "10:10:10:05"
  end
  
  specify "parse a row of numbers as parts of a timecode starting from the right" do
    Timecode.parse("10").should.equal Timecode.new(10)
    Timecode.parse("210").should.equal Timecode.new(60)
    Timecode.parse("10101010").to_s.should.equal "10:10:10:10"
  end
  
  specify "parse a number with f suffix as frames" do
    Timecode.parse("60f").should.equal Timecode.new(60)
  end
  
  specify "parse a number with s suffix as seconds" do
    Timecode.parse("2s", 25).should.equal Timecode.new(50, 25)    
    Timecode.parse("2s", 30).should.equal Timecode.new(60, 30)
  end

  specify "parse a number with m suffix as minutes" do
    Timecode.parse("3m").should.equal Timecode.new(25 * 60 * 3)
  end
  
  specify "parse a number with h suffix as hours" do
    Timecode.parse("3h").should.equal Timecode.new(25 * 60 * 60 * 3)
  end
  
  specify "parse different suffixes as a sum of elements" do
    Timecode.parse("1h 4f").to_s.should.equal '01:00:00:04'
    Timecode.parse("4f 1h").to_s.should.equal '01:00:00:04'
    Timecode.parse("29f 1h").to_s.should.equal '01:00:01:04'
    Timecode.parse("29f \n\n\n\n\n\    1h").to_s.should.equal '01:00:01:04'
  end
  
  specify "parse a number of digits as timecode" do
    Timecode.parse("00000001").to_s.should.equal "00:00:00:01"
    Timecode.parse("1").to_s.should.equal "00:00:00:01"
    Timecode.parse("10").to_s.should.equal "00:00:00:10"
  end
  
  specify "truncate a large number to the parseable length" do
    Timecode.parse("1000000000000000001").to_s.should.equal "10:00:00:00"
  end

  specify "left-pad a large number to give proper TC" do
    Timecode.parse("123456", 57).to_s.should.equal "00:12:34:56"
  end
  
  specify "parse timecode with fractional second instead of frames" do
    fraction = "00:00:07.1"
    tc = Timecode.parse_with_fractional_seconds(fraction, 10)
    tc.to_s.should.equal "00:00:07:01"

    fraction = "00:00:07.5"
    tc = Timecode.parse_with_fractional_seconds(fraction, 10)
    tc.to_s.should.equal "00:00:07:05"
    
    fraction = "00:00:07.04"
    tc = Timecode.parse_with_fractional_seconds(fraction, 12.5)
    tc.to_s.should.equal "00:00:07:00"
    
    fraction = "00:00:07.16"
    tc = Timecode.parse_with_fractional_seconds(fraction, 12.5)
    tc.to_s.should.equal "00:00:07:02"
  end
  
  specify "raise when trying to parse DF timecode" do
    df_tc = "00:00:00;01"
    lambda { Timecode.parse(df_tc)}.should.raise(Timecode::Error)
  end
  
  specify "raise on improper format" do
    lambda { Timecode.parse("Meaningless nonsense", 25) }.should.raise Timecode::CannotParse
    lambda { Timecode.parse("", 25) }.should.raise Timecode::CannotParse
  end
  
  specify "raise on empty argument" do
    lambda { Timecode.parse("   \n\n  ", 25) }.should.raise Timecode::CannotParse
  end
  
  specify "properly handle 09 and 08 as part of complete TC pattern" do
    Timecode.parse( "09:08:09:08", 25).total.should.equal 822233
  end
end

context "Timecode.soft_parse should" do
  specify "parse the timecode" do
    Timecode.soft_parse('200').to_s.should.equal "00:00:02:00"
  end
  
  specify "not raise on improper format and return zero TC instead" do
    lambda do
      tc = Timecode.soft_parse("Meaningless nonsense", 25)
      tc.should.be.zero?
    end.should.not.raise
  end
end

context "Timecode with unsigned integer conversions should" do
  
  specify "parse from a 4x4bits packed 32bit unsigned int" do
    uint, tc = 87310853, Timecode.at(5,34,42,5)
    Timecode.from_uint(uint).should.equal tc
  end
  
  specify "properly convert itself back to 4x4 bits 32bit unsigned int" do
    uint, tc = 87310853, Timecode.at(5,34,42,5)
    tc.to_uint.should.equal uint
  end
end