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

    def self.parse(source, start_open: true)
      instance = new
      instance.parse(source, start_open: start_open)
    end

    def parse(source, start_open: true)
      # Don't apply highlighting if it's a string
      return source if source.is_a? String

      html = parse_value(source)
      open_states = [false] * @index
      open_states[0] = true if start_open # open to first level
      "<div x-data='{state: #{open_states}}' class='#{SCOPE} w-96'>#{html}</div>"
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
      return '{}' if hash.empty?
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
      return '[]' if array.empty?
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
        "<span class='#{CONSTANT}'>#{true}</span>"
      in FalseClass
        "<span class='#{CONSTANT}'>#{false}</span>"
      in NilClass
        "<span class='#{CONSTANT}'>#{nil}</span>"
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
