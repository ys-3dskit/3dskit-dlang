-- ys-3dskit toolchain definition 2025-01-07-2

local DEVKITPRO = os.getenv("DEVKITPRO")
if not DEVKITPRO then
	DEVKITPRO = "/opt/devkitpro"
	return
end

local DKP_TOOLS = path.join(DEVKITPRO, "/tools/bin")

toolchain("devkitarm")
	set_kind("standalone")

	set_toolset("cc", DEVKITPRO .. "/devkitARM/bin/" .. "arm-none-eabi-gcc")
	set_toolset("cxx", DEVKITPRO .. "/devkitARM/bin/" .. "arm-none-eabi-g++")
	set_toolset("ld", DEVKITPRO .. "/devkitARM/bin/" .. "arm-none-eabi-g++")
	set_toolset("sh", DEVKITPRO .. "/devkitARM/bin/" .. "arm-none-eabi-g++")
	set_toolset("ar", DEVKITPRO .. "/devkitARM/bin/" .. "arm-none-eabi-ar")
	set_toolset("strip", DEVKITPRO .. "/devkitARM/bin/" .. "arm-none-eabi-strip")
	set_toolset("objcopy", DEVKITPRO .. "/devkitARM/bin/" .. "arm-none-eabi-objcopy")
	set_toolset("ranlib", DEVKITPRO .. "/devkitARM/bin/" .. "arm-none-eabi-ranlib")
	set_toolset("as", DEVKITPRO .. "/devkitARM/bin/" .. "arm-none-eabi-gcc")

	set_toolset("dc", "ldc2")
	set_toolset("dcld", DEVKITPRO .. "/devkitARM/bin/" .. "arm-none-eabi-g++")

	add_defines("__3DS__", "HAVE_LIBCTRU")

	local arch = { "-march=armv6k", "-mtune=mpcore", "-mtp=soft", "-mfloat-abi=hard" }

	local c_flags = table.join(arch, { "-g", "-Wall", "-mword-relocations", "-ffunction-sections"})

	add_cxflags(c_flags)
	add_asflags(c_flags)
	add_cxxflags({ "-frtti", "-std=gnu++11", "-fexceptions" })

	add_dcflags("-d-version=Horizon,N3DS", "-mtriple=arm-freestanding-eabihf", "-float-abi=hard", "-mcpu=mpcore", "-mattr=armv6k", "--conf=")

	-- for some reason (xmake bug?) this does not work here
	-- so we do it in rule("3ds") instead.
	--add_ldflags("-specs=3dsx.specs", "-g", arch, {force = true})

	--on_check("check")

	-- handled by xmake package manager, not needed.
	--add_linkdirs(path.join(DEVKITPRO, "/libctru/lib") --[[, path.join(DEVKITPRO, "/portlibs/3ds/lib")]])
	--add_includedirs(path.join(DEVKITPRO, "/libctru/include") --[[, path.join(DEVKITPRO, "/portlibs/3ds/include")]])

	add_links("m")

rule("3ds")
	on_load(function(target)
		if not target:is_plat("3ds") then
			raise("Please make sure you have run `xmake f -y -p 3ds -m release -a arm --toolchain=devkitarm` to configure the project before building.")
		end

		if not target:kind() == "binary" then
			raise('rule("3ds") only works with binary targets')
		end

		-- sadly does not apply to dependencies without running the appropriate `xmake f` first.
		target:set("toolchains", "devkitarm")

		target:add("ldflags", "-specs=3dsx.specs", "-g", "-march=armv6k", "-mtune=mpcore", "-mtp=soft", "-mfloat-abi=hard", {force = true})
	end)

	after_build(function(target)
		local _3dsxtool = path.join(DKP_TOOLS, "3dsxtool")

		local smdhtool = path.join(DKP_TOOLS, "smdhtool")

		local name = target:values("3ds.name")
		name = name or io.popen("pwd"):read() --"a"

		local author = target:values("3ds.author")
		author = author or "Unspecified Author"

		local description = target:values("3ds.description")
		description = description or "Built with devkitARM & libctru"

		local icon = target:values("3ds.icon")
		icon = icon or path.join(DEVKITPRO, "/libctru/default_icon.png")

		local romfsdir = target:values("3ds.romfs")

		cprint("${color.build.target}Generating smdh metadata")

		local smdhfile = path.absolute(path.join(target:targetdir(), name .. ".smdh"))

		local smdh_args = { "--create", name, description, author, icon, smdhfile }

		vprint(smdhtool, table.unpack(smdh_args))
		local outdata, errdata = os.iorunv(smdhtool, smdh_args)
		vprint(outdata)
		assert(errdata, errdata)

		local target_file = target:targetfile()
		local file_3dsx = target_file .. ".3dsx"

		cprint("${color.build.target}Generating 3dsx file")

		local _3dsxtool_args = { target_file, file_3dsx, "--smdh=".. smdhfile }

		if romfsdir ~= nil and romfsdir ~= "" then
			table.insert(_3dsxtool_args, "--romfs=" .. romfsdir)
		end

		vprint(_3dsxtool, table.unpack(_3dsxtool_args))
		outdata, errdata = os.iorunv(_3dsxtool, _3dsxtool_args)
		vprint(outdata)
		assert(errdata, errdata)

	end)

	on_run(function(target)
		if not target:kind() == "binary" then
			return
		end

		import("core.base.option")
		import("core.project.config")

		local emu
		try
		{
			function ()
				os.iorun("citra --version")
				emu = "citra"
			end,

			catch
			{
				function()
					cprint("${color.build.target}Please install Citra first")
				end
			}
		}

		if not emu then
			return
		end

		local target_file = target:targetfile()
		local executable = target_file .. ".3dsx"

		os.runv(emu, {executable})
	end)
