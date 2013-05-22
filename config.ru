# touch /webapps/rack_example/tmp/restart.txt

require File.dirname(__FILE__) + "/haiku"
require "haml"

class Avery

	def haml(template_name, locals)
		template = File.open("views/#{template_name}.haml").read
		engine = Haml::Engine.new(template)
		engine.render(Object.new, locals)
	end

	def call(env)

		poem = Haiku.new.random
		out = haml("index", :poem => poem)
		["200", {"Content-Type" => "text/html"}, out]
	end
end

run Avery.new
