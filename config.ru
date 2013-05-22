# touch /webapps/rack_example/tmp/restart.txt

require File.dirname(__FILE__) + "/haiku"
require "haml"

class Avery

  def initialize
    @response = ""
  end
  def get(template, locals)
    @response = haml(template, locals)
  end
	def haml(template_name, locals)
		template = File.open("views/#{template_name}.haml").read
		engine = Haml::Engine.new(template)
		engine.render(Object.new, locals)
	end

	def call(env)
		["200", {"Content-Type" => "text/html"}, @response]
	end
end

class HaikuFilter
  def initialize(app = nil)
    @app = app
  end

  def call(env)
    response = ""
    if (@app)
      response = @app.call(env)[2]
    end
    response+= "<p>#{Haiku.new.random}</p>"
    ["200", {"Content-Type" => "text/html"}, response]
  end
end

class Massive
  def initialize(app = nil)
    @app = app
  end

  def call(env)
    response = ""
    if (@app)
      response = @app.call(env)[2]
    end
    response= "<div style='font-size:5.0em'>#{response}</div>"
    ["200", {"Content-Type" => "text/html"}, response]
  end
end

class MyApp < Avery
    def initialize
      get("index", :poem => "Hello World")
    end
end

use HaikuFilter
use Massive
run MyApp.new
