-- much simpler than the homebrew app ver since this is just for compiling libraries

rule("3ds")
	on_config(function(target)
		target:set("toolchains", "devkitarm")
	end)
