require "range_ppoi_string/version"

module RangePpoiString
  class NoNextError < StandardError; end
  class ParseError < StandardError; end

  HAVE_NEXT = -> (o) { o.respond_to?(:next) }

  INTEGER = /\A-?\d+\z/
  ENDPOINT = /(?:-?\d+|[^-]+)/
  SINGLE_VALUE = /\A#{ENDPOINT}\z/
  RANGE_SEGMENT = /\A(#{ENDPOINT})-(#{ENDPOINT})\z/

  module_function

  def dump(array)
    unless array.all?(&HAVE_NEXT)
      raise NoNextError.new("No next method: #{array.reject(&HAVE_NEXT).inspect}")
    end

    array.uniq.sort.each_with_object([[]]) { |o, res|
      res.push([]) if res.empty?

      if res.last.empty? || res.last.last.next == o
        res.last.push(o)
      else
        res.push([o])
      end
    }.map { |a|
      case a.size
      when 0, 1
        a[0]
      else
        "#{a[0]}-#{a[-1]}"
      end
    }.join(",")
  end

  def parse(string)
    return [] if string.empty?

    string.split(",", -1).flat_map { |s|
      raise ParseError.new("Empty segment in: #{string.inspect}") if s.empty?

      if s =~ RANGE_SEGMENT
        a, b = $1, $2
        range = a =~ INTEGER && b =~ INTEGER ? (a.to_i..b.to_i).map(&:to_s) : [*a..b]
        raise ParseError.new("Reversed range in segment: #{s.inspect}") if range.empty? && a != b
        range
      elsif s =~ SINGLE_VALUE
        s
      else
        raise ParseError.new("Dangling dash in segment: #{s.inspect}")
      end
    }
  end

  refine Array do
    def to_s
      RangePpoiString.dump(self)
    end
  end

  refine String do
    def to_a
      RangePpoiString.parse(self)
    end
  end
end
