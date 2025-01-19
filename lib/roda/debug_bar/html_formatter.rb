module HTMLFormatter
  class RubyHash

    SCOPE = 'highlight ruby hash'

    PUNCTUATION = 'p'
    WHITESPACE = 'w'
    INTEGER = 'mi'
    FLOAT = 'mf'
    STRING = 's2' # double-quoted
    CONSTANT = 'kc'
    SYMBOL = 'ss'


    def initialize
      @index = 0
    end

    def self.parse(source)
      instance = new
      instance.parse(source)
    end

    def parse(source)
      html = parse_value(source)
      "<div x-data='{state: #{[0]*@index}}' class='#{SCOPE} w-96'>#{html}</div>"
    end

    def parse_value(value)
      case value
      in Hash
        parse_hash(value)
      in Array
        parse_array(value)
      in _
        parse_terminal(value)
      end
    end

    def parse_hash(hash)
      i = @index
      @index += 1
      html = "<button @click='state[#{i}] = !state[#{i}]' x-text=\"state[#{i}]? 'hash:#{hash.size} {▼': 'hash:#{hash.size} {▶}'\" class='focus:outline-none'></button>"
      # html += "<dl x-show='state[#{i}]' class='grid grid-cols-2 ml-4'>"
      html += "<dl x-show='state[#{i}]' class='ml-4'>"
      hash.each do |key, value|
        html += "<span class='flex'>"
        html += "<dt class='#{SYMBOL}'>#{key}:&nbsp</dt>"
        # html += "<span class='#{PUNCTUATION}'>=>&nbsp</span>"
        html += "<dd>#{parse_value(value)}</dd>"
        html += "</span>"
      end
      html += "</dl>"
      html += "<p x-show='state[#{i}]'>}</p>"
      html
    end

    def parse_array(array)
      i = @index
      @index += 1
      html = "<button @click='state[#{i}] = !state[#{i}]' x-text=\"state[#{i}]? 'array:#{array.size} [▼': 'array:#{array.size} [▶]'\" class='focus:outline-none'></button>"
      html += "<ul x-show='state[#{i}]' class='ml-4'>"
      array.each do |value|
        html += "<li>#{parse_value(value)}</li>"
      end
      html += "</ul>"
      html += "<p x-show='state[#{i}]'>]</p>"
      html
    end

    def parse_terminal(value)
      case value
      in String
        "<span class='#{STRING}'>\"#{value}\"</span>"
      in Integer
        "<span class='#{INTEGER}'>#{value}</span>"
      in Float
        "<span class='#{FLOAT}'>#{value}</span>"
      in TrueClass
        "<span class='#{CONSTANT}'>#{value}</span>"
      in FalseClass
        "<span class='#{CONSTANT}'>#{value}</span>"
      in NilClass
        "<span class='#{CONSTANT}'>#{value}</span>"
      in _
        "<span class='unknown'>#{value}</span>"
      end
    end

  end
end







# hash = {
#   "foo" => "bar",
#   "baz" => [1,2,3,4],
#   "nested" => {
#     "boo": 1,
#     "bop": "ha"
#   }
# }

# puts HTMLFormatter::RubyHash.parse(hash)
# HTMLFormatter::SQL.parse
