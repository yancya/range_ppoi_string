require "range_ppoi_string/version"

module RangePpoiString
  class NoNextError < StandardError; end
  class ParseError < StandardError; end

  HAVE_NEXT = -> (o) { o.respond_to?(:next) }

  refine Array do
    def to_s
      unless self.all?(&HAVE_NEXT)
        raise NoNextError.new("No next method: #{self.reject(&HAVE_NEXT).inspect}")
      end

      self.uniq.sort.each_with_object([[]]) { |o, res|
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
  end

  INTEGER = /\A-?\d+\z/
  ENDPOINT = /(?:-?\d+|[^-]+)/
  SINGLE_VALUE = /\A#{ENDPOINT}\z/
  RANGE_SEGMENT = /\A(#{ENDPOINT})-(#{ENDPOINT})\z/

  refine String do
    def to_a
      return [] if self.empty?

      self.split(",", -1).flat_map { |s|
        raise ParseError.new("Empty segment in: #{self.inspect}") if s.empty?

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
  end
end
