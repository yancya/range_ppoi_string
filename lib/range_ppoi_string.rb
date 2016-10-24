require "range_ppoi_string/version"
require "set"

module RangePpoiString
  class NoNextError < StandardError; end

  HAVE_NEXT = -> (o) { o.respond_to?(:next) }

  refine Array do
    def to_s
      unless self.all?(&HAVE_NEXT)
        raise NoNextError.new("No next method: #{self.reject(&HAVE_NEXT)}")
      end

      SortedSet[*self].each_with_object([[]]) { |o, res|
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

  refine String do
    def to_a
      self.split(",").flat_map { |s|
        a, b = s.split("-")
        b.nil? ? a : [*a..b]
      }
    end
  end
end
