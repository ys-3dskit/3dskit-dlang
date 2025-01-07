includes("toolchain/*.lua")

add_rules("mode.debug", "mode.release")

-- dub does not support cross compiling, even though LDC does, so xmake cannot support dub dependencies for arm.
-- we use a submodule and include ysbase into libys3ds-dlang instead.
--add_requires("dub::ysbase 0.2.0-beta", {alias = "ysbase"})

target("ys3ds-dlang")
	set_kind("static")
	set_plat("3ds")

	set_arch("arm")
	add_rules("3ds")
	set_toolchains("devkitarm")
	set_languages("c11")

	-- TODO: this does not belong here. it NEEDS to go. xmake won't play without it.
	add_ldflags("-specs=3dsx.specs", "-g", "-march=armv6k", "-mtune=mpcore", "-mtp=soft", "-mfloat-abi=hard", {force = true})

	add_files("ys3ds/**.d")
  add_files("btl/**.d")
  add_files("ysbase/source/ysbase/**.d")
  add_files("3ds-d-runtime/druntime/src/**.d")
  add_files("3ds-d-runtime/druntime/src/**.c")
  add_files("3ds-d-runtime/druntime/src/**.S")
  --add_files("3ds-d-runtime/phobos/phobos/**.d")
  --add_files("3ds-d-runtime/phobos/std/**.d")

  -- remove default runtime
  add_dcflags("--conf=", {force=true})

	-- fix imports
	add_dcflags("-g", "-I.", "-Iysbase/source", "-I3ds-d-runtime/druntime/src", "-I3ds-d-runtime/phobos", {force = true})

	set_strip("debug")
