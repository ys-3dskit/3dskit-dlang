includes("3dskit.lua")

add_rules("mode.debug", "mode.release")

-- dub does not support cross compiling, even though LDC does, so xmake cannot support dub dependencies for arm.
-- we use a submodule and include ysbase into libys3ds-dlang instead.
--add_requires("dub::ysbase 0.2.0-beta", {alias = "ysbase"})

target("ys3ds-dlang")
	set_kind("static")

	add_rules("3ds")
	set_toolchains("devkitarm")

	add_files("ys3ds/**.d")
	add_files("btl/**.d")
	add_files("ysbase/source/ysbase/**.d")
	add_files("3ds-d-runtime/druntime/src/**.d")
	add_files("3ds-d-runtime/druntime/src/**.c")
	add_files("3ds-d-runtime/druntime/src/**.S")
	--add_files("3ds-d-runtime/phobos/phobos/**.d")
	--add_files("3ds-d-runtime/phobos/std/**.d")

	-- fix imports
	add_includedirs(".", "ysbase/source", "3ds-d-runtime/druntime/src", "3ds-d-runtime/phobos")

	set_strip("debug")
