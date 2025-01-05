require "tty-logger"
require "pathname"
require_relative "../debug_bar/current"
require_relative "../debug_bar/instance"
require_relative "../../sequel/extensions/debug_bar"
require_relative "../../sequel/plugins/debug_bar"
require 'rouge'

require 'json'

class Roda
  module RodaPlugins
    module DebugBar

      DEFAULTS = {
        db: nil,
        log_time: false,
        trace_missed: true,
        ##### PUT TRACE ALL TO TRUE AGAIN
        trace_all: false,
        # trace_all: true,
        filtered_params: %w[password password_confirmation _csrf],
        handlers: [:console]
      }.freeze

      def self.load_dependencies(app, opts = {})
        app.plugin :render

        # just to display sessions
        # app.plugin :sessions, secret: 'very-secret'*20

        app.plugin :hooks
        app.plugin :match_hook
      end

      def self.configure(app, opts = {})
        # app.opts[:debug_bar] = opts

        options = DEFAULTS.merge(opts)

        logger = TTY::Logger.new { |config|
          config.handlers = options[:handlers]
          config.output = options.fetch(:output) { File.open('/dev/null', 'w') }
          config.metadata.push(:time, :date) if options[:log_time]
          config.filters.data = options[:filtered_params]
          config.filters.mask = "<FILTERED>"
        }

        root = Pathname(app.opts[:root] || Dir.pwd)

        db = options[:db] || (defined?(DB) && DB)
        db&.extension :debug_bar

        ::Sequel::Model.plugin :debug_bar

        app.match_hook do
          callee = caller_locations.find { |location|
            location.path.start_with?(root.to_s)
          }

          @_debug_bar_instance.add_match(callee)
        end

        app.before do
          @_debug_bar_instance = Roda::DebugBar::Instance.new(logger, env, object_id, root, options[:filter])

          @assets = false

          if request.path == '/debug_bar/ruby.png'
            @assets = true
            response.status = 200
            response['content-type'] = 'image/png'
            response.write(File.open(File.join(__dir__, '../../../public/ruby.png')).read)
            request.halt
          end

          if request.path == '/debug_bar/out.css'
            @assets = true
            response.status = 200
            response['content-type'] = 'text/css'
            response.write(File.open(File.join(__dir__, '../../../public/out.css')).read)
            request.halt
          end

        end

        app.after do |res|

          break if @assets

          status, _ = res
          @_debug_bar_instance.add(
            status,
            request,
            (options[:trace_missed] && status == 404) || options[:trace_all]
          )

          # This @data is available to views
          @data = @_debug_bar_instance.debug_data


          imports = <<-HTML
  <script src="https://unpkg.com/alpinejs@3.14.8/dist/cdn.min.js" defer></script>
  <!-- <script src="https://raw.githubusercontent.com/caldwell/renderjson/refs/heads/master/renderjson.js"></script>
  <script src="https://cdn.jsdelivr.net/gh/caldwell/renderjson@master/renderjson.js"></script>
  <script defer src="https://unpkg.com/pretty-json-custom-element/index.js"></script>
  <script src="https://unpkg.com/@alenaksu/json-viewer@2.1.0/dist/json-viewer.bundle.js"></script> -->
HTML

          res[2] = res[2].map do |body_part|
            if body_part.include?("<head>")
              body_part.sub("<head>", "<head>#{imports}")
            else
              "#{imports}#{body_part}"
            end
          end

          debug_bar = relative_render('debug_bar')

          res[2] = res[2].map do |body_part|
            if body_part.include?("</body>")
              body_part.sub("</body>", "#{debug_bar}</body>")
            else
              "#{body_part}#{debug_bar}"
            end
          end

          res[1]["Content-Length"] = res[2].reduce(0) { |memo, chunk| memo + chunk.bytesize }.to_s

          # if request.path == '/baz'
          #   puts 'hi hi hi'
          # end

          @_debug_bar_instance.drain
          @_debug_bar_instance.reset
        end
      end

      #########

      module InstanceMethods

        def render(path, opts = {})
          unless opts[:ignore]
            # puts "rendering #{path}"
            Roda::DebugBar::Current.add_view(path)
          end
          super
        end

        def view(path, opts = {})
          unless opts[:ignore]
            # puts "view #{path}"
            Roda::DebugBar::Current.add_view(path)
          end
          super
        end

        # def grid_component(opts)
        # end

        def relative_render view
          render('', path: File.join(__dir__, "../debug_bar/views/#{view}.erb"), ignore: true)
        end

        def sql_highlight query
          formatter = Rouge::Formatters::HTML.new
          lexer = Rouge::Lexers::SQL.new
          sql = formatter.format(lexer.lex(query))
          sql.gsub('`', '&#96;')
        end

        def highlight_ruby_hash query
          formatter = Rouge::Formatters::HTML.new
          lexer = Rouge::Lexers::Ruby.new
          formatter.format(lexer.lex(query))
        end

      #   # def _roda_run_main_route
      #   def call
      #     status, headers, content = super

      #     debug_bar = relative_render('debug-bar')

      #     content = content.map do |body_part|
      #       if body_part.include?("</body>")
      #         body_part.sub("</body>", "#{debug_bar}</body>")
      #       else
      #         "#{body_part}#{debug_bar}"
      #       end
      #     end

      #     headers["Content-Length"] = content.reduce(0) { |memo, chunk| memo + chunk.bytesize }.to_s

      #     [status, headers, content]
      #   end

      end

    end

  register_plugin(:debug_bar, RodaPlugins::DebugBar)
  end
end
