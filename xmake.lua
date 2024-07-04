includes("toolchain/*.lua")

add_rules("mode.debug", "mode.release")


target("ys3ds-dlang")
	set_kind("object")
	set_plat("3ds")

	set_arch("arm")
	add_rules("3ds")
	set_toolchains("devkitarm")
	set_languages("c11")

	-- TODO: this does not belong here. it NEEDS to go. xmake won't play without it.
	add_ldflags("-specs=3dsx.specs", "-g", "-march=armv6k", "-mtune=mpcore", "-mtp=soft", "-mfloat-abi=hard", {force = true})

	add_files("ys3ds/**.d")

	-- fix imports
	add_dcflags("-Isrc", {force = true})

	set_strip("debug")
