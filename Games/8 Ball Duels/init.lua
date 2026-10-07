--!strict

type CornyMenuItem = { key: string, text: string, dim: boolean?, description: string? }
type CornyMenuKey = { key: string, text: string, callback: (() -> ())? }
-- keys is required (pass {} for none): the strict checker cannot type a list literal of
-- mixed-shape keys through an optional field
type CornyMenuPrompt = { title: string?, lines: { string }?, keys: { CornyMenuKey } }
type CornyMenuMouse = "down" | "move" | "up" | "wheel"
type CornyMenuDraw = {
	width: number,
	height: number,
	time: number,
	scale: number,
	accent: Color3,
	rect: (
		self: CornyMenuDraw,
		x: number,
		y: number,
		w: number,
		h: number,
		color: Color3,
		opacity: number?
	) -> (),
	outline: (
		self: CornyMenuDraw,
		x: number,
		y: number,
		w: number,
		h: number,
		color: Color3,
		opacity: number?,
		thickness: number?
	) -> (),
	line: (
		self: CornyMenuDraw,
		x1: number,
		y1: number,
		x2: number,
		y2: number,
		color: Color3,
		opacity: number?,
		thickness: number?
	) -> (),
	triangle: (
		self: CornyMenuDraw,
		x1: number,
		y1: number,
		x2: number,
		y2: number,
		x3: number,
		y3: number,
		color: Color3,
		opacity: number?
	) -> (),
	text: (
		self: CornyMenuDraw,
		x: number,
		y: number,
		text: string,
		size: number?,
		color: Color3?,
		opacity: number?
	) -> number,
	measure: (self: CornyMenuDraw, text: string, size: number?) -> number,
}
type CornyMenuPainter = (draw: CornyMenuDraw) -> ()
type CornyMenuOpts = {
	description: string?,
	enabled: boolean?,
	visible: boolean?,
	color: Color3?,
	confirm: (boolean | string)?,
	min: number?,
	max: number?,
	step: number?,
	format: ((value: number) -> string)?,
	placeholder: string?,
	numeric: boolean?,
	integer: boolean?,
	maxLength: number?,
	searchable: boolean?,
	emptyText: string?,
	stay: boolean?,
	animate: boolean?,
	onMouse: ((event: CornyMenuMouse, x: number, y: number, delta: number) -> ())?,
	-- lists, v6 (a v5 module ignores it): the highlighted item, nil once none is
	onHighlight: ((key: string?, item: CornyMenuItem?) -> ())?,
}
type CornyMenuOptions = { title: string?, subtitle: string? }
type CornyMenuNotify = { title: string?, color: Color3?, duration: number? }
type CornyMenuTaskOptions = { total: number?, onStop: (() -> ())? }
type CornyMenuTaskUpdate = {
	title: string?,
	phase: string?,
	detail: string?,
	done: number?,
	total: number?,
}
-- One of the menu's key actions (CornyMenu.actions); keys are the defaults
type CornyMenuAction = {
	id: string,
	label: string,
	keys: { string },
	context: string, -- "always", "open", "held" or "modal"
	repeats: boolean,
	description: string,
}
type CornyMenuPalette = {
	background: Color3,
	header: Color3,
	field: Color3,
	border: Color3,
	text: Color3,
	subtext: Color3,
	dim: Color3,
	good: Color3,
	bad: Color3,
	warn: Color3,
	white: Color3,
}

type CornyMenuJanitor = {
	give: (self: CornyMenuJanitor, item: unknown) -> (),
	destroy: (self: CornyMenuJanitor) -> (),
}
type CornyMenuTask = {
	set: (self: CornyMenuTask, update: CornyMenuTaskUpdate) -> (),
	step: (self: CornyMenuTask, amount: number?) -> (),
	finish: (self: CornyMenuTask, message: string?, ok: boolean?) -> (),
	isStopped: (self: CornyMenuTask) -> boolean,
	Destroy: (self: CornyMenuTask) -> (),
}
type CornyMenuLayer = {
	redraw: (self: CornyMenuLayer) -> (),
	setVisible: (self: CornyMenuLayer, visible: boolean) -> (),
	setAnimated: (self: CornyMenuLayer, animate: boolean) -> (),
	Destroy: (self: CornyMenuLayer) -> (),
}
type CornyMenuOption = {
	get: (self: CornyMenuOption) -> any,
	set: (self: CornyMenuOption, value: any, color: Color3?) -> (),
	onChange: (self: CornyMenuOption, callback: ((...any) -> ())?) -> (),
	setText: (self: CornyMenuOption, text: string) -> (),
	getText: (self: CornyMenuOption) -> string,
	setDescription: (self: CornyMenuOption, text: string?) -> (),
	setVisible: (self: CornyMenuOption, visible: boolean) -> (),
	setEnabled: (self: CornyMenuOption, enabled: boolean) -> (),
	setColor: (self: CornyMenuOption, color: Color3?) -> (),
	setBadge: (self: CornyMenuOption, text: string?) -> (),
	flash: (self: CornyMenuOption, color: Color3?) -> (),
	setChoices: (self: CornyMenuOption, choices: { any }) -> (),
	setRange: (self: CornyMenuOption, min: number, max: number, step: number?) -> (),
	setItems: (self: CornyMenuOption, items: { CornyMenuItem }) -> (),
	select: (self: CornyMenuOption, key: string?) -> (),
	open: (self: CornyMenuOption) -> (),
	redraw: (self: CornyMenuOption) -> (),
	setAnimated: (self: CornyMenuOption, animate: boolean) -> (),
	Destroy: (self: CornyMenuOption) -> (),
}
type CornyMenuPage = {
	header: (self: CornyMenuPage, text: string) -> CornyMenuOption,
	label: (self: CornyMenuPage, text: string, opts: CornyMenuOpts?) -> CornyMenuOption,
	separator: (self: CornyMenuPage) -> CornyMenuOption,
	button: (
		self: CornyMenuPage,
		text: string,
		callback: (() -> ())?,
		opts: CornyMenuOpts?
	) -> CornyMenuOption,
	toggle: (
		self: CornyMenuPage,
		text: string,
		default: boolean?,
		callback: ((on: boolean) -> ())?,
		opts: CornyMenuOpts?
	) -> CornyMenuOption,
	cycle: (
		self: CornyMenuPage,
		text: string,
		choices: { any },
		default: any,
		callback: ((value: any, text: string) -> ())?,
		opts: CornyMenuOpts?
	) -> CornyMenuOption,
	slider: (
		self: CornyMenuPage,
		text: string,
		default: number,
		callback: ((value: number) -> ())?,
		opts: CornyMenuOpts
	) -> CornyMenuOption,
	input: (
		self: CornyMenuPage,
		text: string,
		default: (string | number)?,
		callback: ((value: any) -> ())?,
		opts: CornyMenuOpts?
	) -> CornyMenuOption,
	keybind: (
		self: CornyMenuPage,
		text: string,
		default: Enum.KeyCode?,
		callback: ((key: Enum.KeyCode?) -> ())?,
		opts: CornyMenuOpts?
	) -> CornyMenuOption,
	list: (
		self: CornyMenuPage,
		text: string,
		items: { CornyMenuItem },
		callback: ((key: string, item: CornyMenuItem) -> ())?,
		opts: CornyMenuOpts?
	) -> CornyMenuOption,
	submenu: (self: CornyMenuPage, text: string, opts: CornyMenuOpts?) -> CornyMenuPage,
	canvas: (
		self: CornyMenuPage,
		height: number,
		painter: CornyMenuPainter,
		opts: CornyMenuOpts?
	) -> CornyMenuOption,
	overlay: (
		self: CornyMenuPage,
		painter: CornyMenuPainter,
		opts: CornyMenuOpts?
	) -> CornyMenuLayer,
	onDestroy: (self: CornyMenuPage, callback: () -> ()) -> (),
	track: (self: CornyMenuPage, item: unknown) -> (),
	open: (self: CornyMenuPage) -> (),
	isShowing: (self: CornyMenuPage) -> boolean,
	setTitle: (self: CornyMenuPage, title: string) -> (),
	setBadge: (self: CornyMenuPage, text: string?) -> (),
	clear: (self: CornyMenuPage) -> (),
	Destroy: (self: CornyMenuPage) -> (),
	task: (self: CornyMenuPage, title: string, opts: CornyMenuTaskOptions?) -> CornyMenuTask,
	prompt: (self: CornyMenuPage, id: string, spec: CornyMenuPrompt) -> (),
	hidePrompt: (self: CornyMenuPage, id: string) -> (),
	status: (self: CornyMenuPage, id: string, text: string?, color: Color3?) -> (),
}
type CornyMenuObject = {
	page: (self: CornyMenuObject, name: string, opts: CornyMenuOpts?) -> CornyMenuPage,
	getPage: (self: CornyMenuObject, name: string) -> CornyMenuPage?,
	open: (self: CornyMenuObject) -> (),
	close: (self: CornyMenuObject) -> (),
	toggle: (self: CornyMenuObject) -> (),
	isOpen: (self: CornyMenuObject) -> boolean,
	setToggleKey: (self: CornyMenuObject, key: Enum.KeyCode?) -> (),
	setKeys: (self: CornyMenuObject, action: string, keys: { string | Enum.KeyCode }) -> (),
	getKeys: (self: CornyMenuObject, action: string) -> { string },
	resetKeys: (self: CornyMenuObject, action: string?) -> (),
	notify: (self: CornyMenuObject, text: string, opts: CornyMenuNotify?) -> (),
	task: (self: CornyMenuObject, title: string, opts: CornyMenuTaskOptions?) -> CornyMenuTask,
	prompt: (self: CornyMenuObject, id: string, spec: CornyMenuPrompt) -> (),
	hidePrompt: (self: CornyMenuObject, id: string) -> (),
	status: (self: CornyMenuObject, id: string, text: string?, color: Color3?) -> (),
	defer: (self: CornyMenuObject, fn: () -> ()) -> (),
	Destroy: (self: CornyMenuObject) -> (),
}
type CornyMenuModule = {
	VERSION: number,
	get: (options: CornyMenuOptions?) -> CornyMenuObject,
	newJanitor: () -> CornyMenuJanitor,
	palette: CornyMenuPalette,
	actions: { CornyMenuAction },
}
--#endregion CornyMenuTypes
local CornyMenu: CornyMenuModule = (function(): CornyMenuModule
	-- where lib/cornymenu.lua is hosted (raw file, returns the Lua source as plain text)
	local URL =
		"https://raw.githubusercontent.com/Urvoge/Roblox/refs/heads/main/Modules/UI%20Libraries/Corny.lua"
	local CACHE_FOLDER = "Corny"
	local CACHE = "Corny/cornymenu.lua" -- the last good download from URL
	local NEED = 5 -- the oldest module version the types above describe

	-- Compiles and runs one copy (running it only defines the library): the library, or
	-- nil and what is wrong with the copy
	local function open(source: string, from: string): (CornyMenuModule?, string)
		if string.sub(source, 1, 3) == "\239\187\191" then
			source = string.sub(source, 4) -- a UTF-8 byte order mark does not compile
		end
		local fn, compileError = loadstring(source, "=CornyMenu")
		if fn == nil then
			return nil, `{from} does not compile: {compileError}`
		end
		local ok, result = pcall(fn)
		if not ok then
			return nil, `{from} failed to run: {result}`
		end
		if
			type(result) ~= "table"
			or type(result.VERSION) ~= "number"
			or result.VERSION % 1 ~= 0 -- a whole number (not NaN or inf either)
			or type(result.get) ~= "function"
			or type(result.newJanitor) ~= "function"
			or type(result.palette) ~= "table"
			or type(result.actions) ~= "table"
		then
			return nil, `{from} is not the CornyMenu module`
		end
		if result.VERSION < NEED then
			return nil, `{from} is v{result.VERSION}, this script needs v{NEED} or newer`
		end
		return result, ""
	end

	-- Keeps a download from URL in the workspace (written only when it changed)
	local function keep(text: string): ()
		local ok, err = pcall(function()
			if not isfolder(CACHE_FOLDER) then
				makefolder(CACHE_FOLDER)
			end
			if not (isfile(CACHE) and readfile(CACHE) == text) then
				writefile(CACHE, text)
			end
		end)
		if not ok then
			warn(`[CornyMenu] could not save {CACHE}: {err}`)
		end
	end

	-- The download is kept once it has made the running menu: a build that loads but
	-- fails in CornyMenu.get, or that only found another copy's menu running, never
	-- replaces the last good copy
	local function keepAfterGet(module: CornyMenuModule, text: string): CornyMenuModule
		local wrapper: CornyMenuModule = {
			VERSION = module.VERSION,
			get = function(options: CornyMenuOptions?): CornyMenuObject
				local running = getgenv().CornyMenu -- the running menu's { version, menu }
				local menu = module.get(options)
				if getgenv().CornyMenu ~= running then -- this copy made the menu
					keep(text)
				end
				return menu
			end,
			newJanitor = module.newJanitor,
			palette = module.palette,
			actions = module.actions,
		}
		-- fields a newer module adds still reach the script (the metatable hides the type
		-- from the checker, so it is cast back; `wrapper` itself is checked above)
		return table.freeze(setmetatable(wrapper, { __index = module })) :: any
	end

	local override = getgenv().CornyMenuSource
	if override ~= nil and type(override) ~= "string" then
		warn("[CornyMenu] getgenv().CornyMenuSource is not a string (a URL or a file); using URL")
	end
	local from = if type(override) == "string" and override ~= "" then override else URL
	local scheme = string.match(string.lower(from), "^(https?)://")
	local problems: { string } = {}
	local source: string? = nil
	if from == "" then
		table.insert(problems, "no URL set (URL in the CornyMenuLoader block)")
	elseif scheme ~= nil then
		if scheme == "http" then
			warn(`[CornyMenu] {from} is plain http, so the network can change the code: use https`)
		end
		local ok, result = pcall(function(): string
			return game:HttpGet(from, true)
		end)
		-- the download yields, and a thread that yielded can lose executor identity
		-- (LEARNINGS.md, thread identity): the rest of the script gets it back
		if setthreadidentity then
			pcall(setthreadidentity, 8)
		end
		if ok and type(result) == "string" then
			source = result
		else
			local why = if ok then `got a {type(result)}` else tostring(result)
			table.insert(problems, `{from} did not download: {why}`)
		end
	else
		local ok, result = pcall(readfile, from)
		if ok and type(result) == "string" then
			source = result
		else
			local why = if ok then `got a {type(result)}` else tostring(result)
			table.insert(problems, `{from} could not be read: {why}`)
		end
	end

	if source ~= nil then
		local text: string = source
		local module, problem = open(text, from)
		if module ~= nil then
			if from == URL then
				return keepAfterGet(module, text)
			end
			print(`[CornyMenu] v{module.VERSION} loaded from {from}`)
			return module
		end
		table.insert(problems, problem)
	end

	local found, cached = pcall(readfile, CACHE)
	if found and type(cached) == "string" then
		local module, problem = open(cached, CACHE)
		if module ~= nil then
			local why = table.concat(problems, "; ")
			warn(`[CornyMenu] {why}; using the saved copy {CACHE} (v{module.VERSION})`)
			return module
		end
		table.insert(problems, problem)
	else
		table.insert(problems, `no saved copy at {CACHE}`)
	end
	error(`[CornyMenu] could not load: {table.concat(problems, "; ")}`, 0)
end)()
--#endregion CornyMenuLoader

--#region Shared.Core (keep identical in every feature file, source: shared/Core.luau)
-- Core: the services and basics every feature and shared component uses: pcall wrappers with a
-- fixed shape, console lines, event waits (awaitEvent / awaitSignal / awaitGone; waitUntil only
-- for states no event reports), the character's root part, a RemoteEvent send that never breaks
-- a loop, and fail-loud lookups for game objects.
-- Needs: nothing

-- ============ Services ============
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- ============ Core config ============
local CoreConfig = table.freeze({
	LOG_PREFIX = "[Corny]", -- console lines of the shared components (features use their own)
	PATH_TIMEOUT = 10, -- findChild: WaitForChild timeout before it errors
})

-- ============ Core types ============
type StopToken = { stopped: boolean }

-- ============ Library: basics ============
-- pcall with a fixed (ok, result) shape, also for functions that return nothing
local function try(fn: (...any) -> ...any, ...: any): (boolean, any)
	return pcall(fn, ...)
end

-- xpcall with a fixed (ok, result) shape and a traceback on error
local function tryTraced(fn: (...any) -> ...any, ...: any): (boolean, any)
	return xpcall(fn, debug.traceback, ...)
end

type Logger = { info: (message: string) -> (), warn: (message: string) -> () }

-- Console lines for one feature: newLogger("[Paint]").info("...")
local function newLogger(prefix: string): Logger
	return {
		info = function(message: string): ()
			print(`{prefix} {message}`)
		end,
		warn = function(message: string): ()
			warn(`{prefix} {message}`)
		end,
	}
end

local function log(message: string): ()
	print(`{CoreConfig.LOG_PREFIX} {message}`)
end

local function logWarn(message: string): ()
	warn(`{CoreConfig.LOG_PREFIX} {message}`)
end

local warnedKeys: { [string]: boolean } = {}

local function warnOnce(key: string, message: string): ()
	if warnedKeys[key] then
		return
	end
	warnedKeys[key] = true
	logWarn(message)
end

local function format1(value: number): string
	return string.format("%.1f", value)
end

local function format2(value: number): string
	return string.format("%.2f", value)
end

local function plural(count: number, word: string): string
	if count == 1 then
		return `{count} {word}`
	end
	return `{count} {word}s`
end

-- Waits until predicate() is true (checked every frame), `timeout` runs out or
-- `stop` is set. Only for states no event reports (ownership, speeds, sizes).
local function waitUntil(timeout: number, predicate: () -> boolean, stop: StopToken?): boolean
	local deadline = os.clock() + timeout
	while os.clock() < deadline do
		if stop and stop.stopped then
			return false
		end
		if predicate() then
			return true
		end
		RunService.Heartbeat:Wait()
	end
	return false
end

-- Sleeps `seconds` unless `stop` is set first
local function pause(seconds: number, stop: StopToken?): ()
	waitUntil(seconds, function(): boolean
		return false
	end, stop)
end

--[[ Yields until an event comes, `timeout` runs out or `stop` is set; true when
	 the event came. `connect` hooks the `done` callback up to the event and
	 returns what unhooks it. Nothing is polled but the timeout and Stop. ]]
local function awaitEvent(
	connect: (done: () -> ()) -> () -> (),
	timeout: number,
	stop: StopToken?
): boolean
	local thread = coroutine.running()
	local finished = false
	local came = false
	local waiting = false
	local unhook: (() -> ())? = nil
	local beat: RBXScriptConnection? = nil
	local deadline = os.clock() + timeout
	local function finish(value: boolean): ()
		if finished then
			return
		end
		finished = true
		came = value
		if unhook then
			unhook()
		end
		if beat then
			beat:Disconnect()
		end
		if waiting and coroutine.status(thread) == "suspended" then
			task.spawn(thread)
		end
	end
	local release = connect(function()
		finish(true)
	end)
	unhook = release
	if finished then
		release() -- it came while hooking up
		return came
	end
	beat = RunService.Heartbeat:Connect(function()
		if os.clock() >= deadline or (stop ~= nil and stop.stopped) then
			finish(false)
		end
	end)
	waiting = true
	coroutine.yield()
	return came
end

-- awaitEvent for a Roblox event: true once `signal` fires (and `accept`, if given, says yes)
local function awaitSignal(
	signal: RBXScriptSignal,
	timeout: number,
	stop: StopToken?,
	accept: (() -> boolean)?
): boolean
	return awaitEvent(function(done: () -> ()): () -> ()
		local connection = signal:Connect(function()
			if accept == nil or accept() then
				done()
			end
		end)
		return function()
			connection:Disconnect()
		end
	end, timeout, stop)
end

-- Yields until `model` has left `container` (AncestryChanged), `timeout` or Stop
local function awaitGone(
	model: Instance,
	container: Instance,
	timeout: number,
	stop: StopToken?
): boolean
	if model.Parent ~= container then
		return true
	end
	return awaitSignal(model.AncestryChanged, timeout, stop, function(): boolean
		return model.Parent ~= container
	end)
end

local function rootPart(): BasePart?
	local character = LocalPlayer.Character
	if character == nil then
		return nil
	end
	local root = character:FindFirstChild("HumanoidRootPart")
	if root and root:IsA("BasePart") then
		return root
	end
	return nil
end

-- A RemoteEvent send that can never take a loop down
local function fire(remote: RemoteEvent, ...: any): ()
	local ok, err = try(remote.FireServer, remote, ...)
	if not ok then
		warnOnce(remote.Name, `{remote.Name} failed: {err}`)
	end
end

-- ============ Library: game object lookups ============
local function findChild(parent: Instance, name: string): Instance
	local child = parent:FindFirstChild(name) or parent:WaitForChild(name, CoreConfig.PATH_TIMEOUT)
	if child == nil then
		error(`{parent:GetFullName()}.{name} not found - run locate.lua and send locations.txt`, 0)
	end
	return child
end

local function findRemoteEvent(parent: Instance, name: string): RemoteEvent
	local child = findChild(parent, name)
	if child:IsA("RemoteEvent") then
		return child
	end
	error(`{child:GetFullName()} is a {child.ClassName}, not a RemoteEvent`, 0)
end
--#endregion Shared.Core

--#region Shared.Files (keep identical in every feature file, source: shared/Files.luau)
-- Files: THE ONLY code that touches Volt's workspace files (readfile, writefile, appendfile,
-- isfile, isfolder, makefolder, listfiles; check.sh refuses them anywhere else). Everything Corny
-- writes lives in the workspace folder Corny/, and every game keeps its files in its own folder
-- below it, Corny/<KEY>/ (Corny/LT2/ for Lumber Tycoon 2), so two games never read or overwrite
-- each other's files (docs/WORKSPACE_FILES.md). A Files object is one game's folder, made by the
-- game's Shared.Game (Game.files): the names given to it are relative to that folder, may hold
-- subfolders ("debug/paint.txt") and can never leave it (no "." or ".." part, no "\", ":" or other
-- character Windows refuses, no leading "/"). Folders are made, top first, on the first write.
-- Every call is pcall-guarded: a read gives nil and why, a write false and why; nothing errors.
-- A game whose files lived straight in Corny/ before game folders existed (LT2 only) can adopt
-- them: copied into its folder while it has none of that name, never moved or deleted (older
-- scripts still use them).
-- Needs: Core

local FilesConfig = table.freeze({
	ROOT = "Corny", -- the one workspace folder every Corny script writes in
	MISSING = "no such file", -- the reason read() gives when the file is not there
	MAX_NAME = 150, -- characters in one name below a game folder (Windows' paths stay short)
})

type FilesFields = {
	game: string, -- the game's key: "LT2"
	folder: string, -- the game's folder in the workspace: "Corny/LT2"
	oldFiles: boolean, -- the game's files lived in Corny/ before game folders (LT2)
}

local Files = {}
Files.__index = Files

type Files = typeof(setmetatable({} :: FilesFields, Files))

-- One game's folder, Corny/<key>. Touches no file (a game's Shared.Game makes it while the script
-- loads). `key` is the game's key, letters and digits with a capital first ("LT2", the same as
-- its games/<key>/ folder in the project); `oldFiles` is true only for a game whose files lived
-- in Corny/ before game folders existed.
local function newFiles(key: string, oldFiles: boolean?): Files
	if string.match(key, "^%u%w*$") == nil then
		error(`Files: "{key}" is not a game key (letters and digits, a capital first: LT2)`, 2)
	end
	local self = setmetatable({} :: FilesFields, Files)
	self.game = key
	self.folder = `{FilesConfig.ROOT}/{key}`
	self.oldFiles = oldFiles == true
	return self
end

-- Why `name` cannot be used below a game folder, or nil when it can
function Files.problem(name: string): string?
	if name == "" or #name > FilesConfig.MAX_NAME then
		return `"{name}" is empty or longer than {FilesConfig.MAX_NAME} characters`
	end
	if string.find(name, '[%c<>:"\\|%?%*]') then
		return `"{name}" holds a character a file name cannot have`
	end
	if
		string.sub(name, 1, 1) == "/"
		or string.sub(name, -1) == "/"
		or string.find(name, "//", 1, true)
	then
		return `"{name}" starts or ends with / or has an empty folder name`
	end
	for part in string.gmatch(name, "[^/]+") do
		if part == "." or part == ".." then
			return `"{name}" would leave the game's folder`
		end
	end
	return nil
end

-- The workspace path of a name in the game's folder ("Corny/LT2/paint.json"): what to show
function Files.path(self: Files, name: string): string
	return `{self.folder}/{name}`
end

-- The workspace path the name had before game folders ("Corny/paint.json")
function Files.oldPath(self: Files, name: string): string
	return `{FilesConfig.ROOT}/{name}`
end

-- Makes `folder` (a workspace path, "Corny/LT2/debug") and every folder above it, top first
function Files._makeFolders(folder: string): ()
	local path = ""
	for part in string.gmatch(folder, "[^/]+") do
		path = if path == "" then part else `{path}/{part}`
		if not isfolder(path) then
			makefolder(path)
		end
	end
end

-- The text of a workspace path: the text, or nil and why (MISSING when there is no such file)
function Files._readPath(path: string): (string?, string?)
	local ok, result = try(function(): any
		if not isfile(path) then
			return nil
		end
		return readfile(path)
	end)
	if not ok then
		return nil, `{path}: {result}`
	end
	if result == nil then
		return nil, FilesConfig.MISSING
	end
	if type(result) ~= "string" then
		return nil, `{path}: got a {type(result)}`
	end
	return result, nil
end

-- The names (not paths) of what a workspace folder holds, sorted without case; {} when it is
-- not there
function Files._listPath(path: string): { string }
	local names: { string } = {}
	local ok, list = try(function(): any
		if not isfolder(path) then
			return {}
		end
		return listfiles(path)
	end)
	if not ok or type(list) ~= "table" then
		return names
	end
	for _, entry in list do
		if type(entry) ~= "string" then
			continue
		end
		local name = string.match(entry, "[^/\\]+$")
		if name then
			table.insert(names, name)
		end
	end
	table.sort(names, function(a: string, b: string): boolean
		return string.lower(a) < string.lower(b)
	end)
	return names
end

-- JSON text decoded: the value, or nil and why
function Files._decode(text: string, path: string): (any, string?)
	local ok, decoded = try(function(): any
		return HttpService:JSONDecode(text)
	end)
	if not ok then
		return nil, `{path} is not JSON: {decoded}`
	end
	return decoded, nil
end

-- A file in the game's folder: its text, or nil and why (FilesConfig.MISSING when it is not there)
function Files.read(self: Files, name: string): (string?, string?)
	local problem = Files.problem(name)
	if problem then
		return nil, problem
	end
	return Files._readPath(self:path(name))
end

-- Whether the game's folder holds a file of that name
function Files.exists(self: Files, name: string): boolean
	if Files.problem(name) then
		return false
	end
	local ok, found = try(isfile, self:path(name))
	return ok and found == true
end

-- Writes a file in the game's folder (making its folders): true, or false and why
function Files.write(self: Files, name: string, text: string): (boolean, string?)
	local problem = Files.problem(name)
	if problem then
		return false, problem
	end
	local path = self:path(name)
	local folder = string.match(path, "^(.*)/[^/]*$") or self.folder
	local ok, err = try(function(): ()
		Files._makeFolders(folder)
		writefile(path, text)
	end)
	if not ok then
		return false, `{path}: {err}`
	end
	return true, nil
end

-- Adds text to the end of a file in the game's folder (making it and its folders): true, or false
-- and why
function Files.append(self: Files, name: string, text: string): (boolean, string?)
	local problem = Files.problem(name)
	if problem then
		return false, problem
	end
	local path = self:path(name)
	local folder = string.match(path, "^(.*)/[^/]*$") or self.folder
	local ok, err = try(function(): ()
		Files._makeFolders(folder)
		appendfile(path, text)
	end)
	if not ok then
		return false, `{path}: {err}`
	end
	return true, nil
end

-- The names (not paths) of what a folder in the game's folder holds (nil or "": the game folder
-- itself), files and folders, sorted without case; {} when the folder is not there
function Files.list(self: Files, folder: string?): { string }
	if folder == nil or folder == "" then
		return Files._listPath(self.folder)
	end
	if Files.problem(folder) then
		return {}
	end
	return Files._listPath(self:path(folder))
end

-- A JSON file in the game's folder, decoded: the value, or nil and why
function Files.readJson(self: Files, name: string): (any, string?)
	local text, why = self:read(name)
	if text == nil then
		return nil, why
	end
	return Files._decode(text, self:path(name))
end

-- Writes a value as a JSON file in the game's folder: true, or false and why
function Files.writeJson(self: Files, name: string, value: any): (boolean, string?)
	local ok, text = try(function(): any
		return HttpService:JSONEncode(value)
	end)
	if not ok or type(text) ~= "string" then
		return false, `{self:path(name)}: could not make JSON: {text}`
	end
	return self:write(name, text)
end

-- The file of that name from before game folders (Corny/<name>): its text, or nil and why. Only
-- for a game made with oldFiles; it never writes there.
function Files.readOld(self: Files, name: string): (string?, string?)
	if not self.oldFiles then
		return nil, `{self.game} has no files from before game folders`
	end
	local problem = Files.problem(name)
	if problem then
		return nil, problem
	end
	return Files._readPath(self:oldPath(name))
end

-- readOld, decoded as JSON: the value, or nil and why
function Files.readOldJson(self: Files, name: string): (any, string?)
	local text, why = self:readOld(name)
	if text == nil then
		return nil, why
	end
	return Files._decode(text, self:oldPath(name))
end

-- Copies Corny/<name> into the game's folder when the game's folder has no such file yet; after
-- that the game's own copy is the one used. The old file stays (older scripts may still use it).
-- True when it copied.
function Files.adopt(self: Files, name: string): boolean
	if not self.oldFiles or self:exists(name) then
		return false
	end
	local text = self:readOld(name)
	if text == nil then
		return false
	end
	local ok = self:write(name, text)
	return ok
end

-- Copies every file of Corny/<folder> into the game's <folder>, only while the game's folder
-- has no such folder (the first time, or after it was deleted). The old folder stays. Returns
-- how many files it copied.
function Files.adoptFolder(self: Files, folder: string): number
	if not self.oldFiles or Files.problem(folder) then
		return 0
	end
	local found, there = try(isfolder, self:path(folder))
	if not found or there == true then
		return 0
	end
	local old = self:oldPath(folder)
	local copied = 0
	for _, name in Files._listPath(old) do
		local text = Files._readPath(`{old}/{name}`) -- nil for a folder (isfile is false)
		if text ~= nil and self:write(`{folder}/{name}`, text) then
			copied += 1
		end
	end
	return copied
end
--#endregion Shared.Files

--#region Shared.Game (keep identical in every feature file, source: games/EightBall/shared/Game.luau)
-- Game: which game this is, 8 Ball Duels (its key EightBall, name and place), and its folder in Volt's
-- workspace (Game.files: Corny/EightBall, Shared.Files); then the game objects every feature uses,
-- resolved on the first Game.get() and checked against games/EightBall/research/locations.txt
-- (Core's findChild fails loud when one is missing). Every EightBall feature embeds it.
-- Needs: Core, Files

local GameConfig = table.freeze({
	KEY = "EightBall", -- the game's key: games/EightBall in the project, Corny/EightBall in Volt's workspace
	NAME = "8 Ball Duels", -- the menu's subtitle
	PLACE_ID = 116921506811323, -- the game's place (game.PlaceId)
	OLD_FILES = false, -- no files from before game folders (only LT2 had them)
	-- the full script (games/EightBall/init.lua), where the user hosts it: run again after a teleport
	SCRIPT_URL = "https://raw.githubusercontent.com/Urvoge/Roblox/refs/heads/main/Games/8%20Ball%20Duels/init.lua",
	READY_GUI = "PoolGameUI", -- PlayerGui child the game makes once it is ready (2026-10-05 dump)
})

-- The game objects features use. Add each one when the first feature needs it, with its path
-- from locations.txt (a RemoteEvent, a folder in workspace, a module to require once).
-- The pool modules are the game's own untyped tables (decompiled in research/2026-10-05_20-58-58/
-- scripts/ReplicatedStorage/Libraries/GameSpecific/Pool/), so they are `any`.
type GameRefs = {
	-- always there
	physics: any, -- PoolPhysics: the table's physics (PredictShot, Shoot, Step, newSimulation)
	aim: any, -- PoolAimOverlay: the aim guide on screen (Update, IsAimShown)
	stepper: any, -- PoolStepper: the physics step (FixedDelta, MaxSettleSeconds)
	constants: any, -- PoolConstants: table sizes, ball numbers and colours, Input.MinimumPower
	-- nil when the game has none (Game.optional): check before use
	rules: any, -- PoolRules: groups per seat, legal first contact, BeginShot / ResolveShot
	matchClient: any, -- PoolMatchClient: an online match on this client (Seat, Rules)
	input: any, -- PoolInputController: your cue (SetState; its objects hold Direction, Power, Hud)
	hud: any, -- PoolHudRenderer: the HUD (SetPower, SetSpin; a HUD object's PowerTrack is the meter)
	geometry: any, -- PoolGeometry: the table (GetPockets, GetCushions)
	ai: any, -- PoolAI: the game's bot (Plan, PlaceCueBallOptions; offline it plays seat 2 with your cue)
	view: any, -- PoolViewController: the table on screen (SetBall)
	venueMenu: any, -- PoolVenueMenu: the venue picker (Choose = tapping a venue)
	table2d: any, -- PoolTableRenderer2D: the table frame (PixelToTable: a screen point on the table)
	gameUi: Instance?, -- PlayerGui.PoolGameUI: the match screen (attributes MatchActive, MatchMode); read it with Game.ui
}

local Game = {
	refs = nil :: GameRefs?, -- resolved on the first Game.get()
	files = newFiles(GameConfig.KEY, GameConfig.OLD_FILES), -- Corny/EightBall in Volt's workspace
}

-- Every one of the game's own tables in the GC (Volt's filtergc) that has every one of `keys`
-- (several when the game made several, like one trickshot editor per visit). Empty when none.
function Game.liveTables(keys: { string }): { any }
	local list: { any } = {}
	local finder: any = filtergc -- Volt's GC search (declared without table types)
	if type(finder) ~= "function" then
		return list
	end
	local ok, found = try(finder, "table", { Keys = keys }, false)
	if not ok or type(found) ~= "table" then
		return list
	end
	for _, candidate in found do
		if type(candidate) ~= "table" then
			continue
		end
		local complete = true
		for _, key in keys do
			if rawget(candidate, key) == nil then
				complete = false
				break
			end
		end
		if complete then
			table.insert(list, candidate)
		end
	end
	return list
end

-- One of the game's own tables (a module, or an object a game script made, like a menu): the
-- first table in the GC that has every one of `keys` (Game.liveTables). nil when there is none.
function Game.liveTable(keys: { string }): any?
	return Game.liveTables(keys)[1]
end

-- A game module's table, the one the game's own scripts hold: Game.liveTable, else required (a
-- module runs once, so require hands back the same table). Errors when neither works. Logs once
-- how it was found (a require could in theory hand back a copy the game's scripts do not use).
function Game.module(folder: Instance, name: string, keys: { string }): any
	local live = Game.liveTable(keys)
	if live ~= nil then
		log(`{name}: the game's live table`)
		return live
	end
	local module = findChild(folder, name)
	local ok, result = try(require, module)
	if ok and type(result) == "table" then
		log(`{name}: required (the game's live table was not found)`)
		return result
	end
	error(`{module:GetFullName()} could not be loaded: {result}`, 0)
end

-- Game.module for a module only some features need: nil, with a warning, when the game has none
function Game.optional(folder: Instance, name: string, keys: { string }): any
	local ok, result = try(Game.module, folder, name, keys)
	if ok then
		return result
	end
	warnOnce(
		`game.module.{name}`,
		`{name} not found: the pages that need it will say so ({result})`
	)
	return nil
end

-- Finds the game objects (only from Game.get). Paths: the research dump of 2026-10-05
-- (research/2026-10-05_20-58-58/tree.txt), ReplicatedStorage.Libraries.GameSpecific.Pool.
function Game.resolve(): GameRefs
	local libraries = findChild(ReplicatedStorage, "Libraries")
	local pool = findChild(findChild(libraries, "GameSpecific"), "Pool")
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local gameUi = if playerGui ~= nil then playerGui:FindFirstChild(GameConfig.READY_GUI) else nil
	return {
		physics = Game.module(
			pool,
			"PoolPhysics",
			{ "PredictShot", "CastCueBall", "Shoot", "Step" }
		),
		aim = Game.module(pool, "PoolAimOverlay", { "Update", "IsAimShown", "ShowHeldBall" }),
		stepper = Game.module(
			pool,
			"PoolStepper",
			{ "FixedDelta", "MaxSettleSeconds", "RunToSettle" }
		),
		constants = Game.module(
			pool,
			"PoolConstants",
			{ "BallColours", "FrameWidth", "FrameHeight", "BallRadius", "CueBallNumber" }
		),
		rules = Game.optional(
			pool,
			"PoolRules",
			{ "IsLegalFirstContact", "CountRemaining", "ResolveShot" }
		),
		matchClient = Game.optional(pool, "PoolMatchClient", { "GetSeat", "SetCovered", "Update" }),
		input = Game.optional(
			pool,
			"PoolInputController",
			{ "SetState", "SetAimDirection", "TakeAim" }
		),
		hud = Game.optional(
			pool,
			"PoolHudRenderer",
			{ "SetPower", "SetSpin", "PowerFromPosition" }
		),
		geometry = Game.optional(
			pool,
			"PoolGeometry",
			{ "GetPockets", "GetCushions", "BuildRack" }
		),
		ai = Game.optional(pool, "PoolAI", { "Plan", "PlaceCueBallOptions", "SweepAim" }),
		view = Game.optional(pool, "PoolViewController", { "SetBall", "SetCueStick", "ToWorld" }),
		venueMenu = Game.optional(pool, "PoolVenueMenu", { "Choose", "SetProgress", "GetVenue" }),
		table2d = Game.optional(
			pool,
			"PoolTableRenderer2D",
			{ "PixelToTable", "GetScreenRect", "TableToScale" }
		),
		gameUi = gameUi,
	}
end

-- PlayerGui.PoolGameUI, the match screen (attributes MatchActive, MatchMode): looked up again
-- whenever it is missing or gone (a script run before the game made it). nil while there is none
function Game.ui(refs: GameRefs): Instance?
	local gameUi = refs.gameUi
	if gameUi ~= nil and gameUi.Parent ~= nil then
		return gameUi
	end
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local found = if playerGui ~= nil then playerGui:FindFirstChild(GameConfig.READY_GUI) else nil
	refs.gameUi = found
	return found
end

-- The game objects, resolved on the first call (make it from buildPage, while the script loads)
function Game.get(): GameRefs
	local refs = Game.refs
	if refs == nil then
		if game.PlaceId ~= GameConfig.PLACE_ID then
			warnOnce(
				"game.place",
				`this is the {GameConfig.NAME} script, but this game is place {game.PlaceId}`
			)
		end
		local fresh = Game.resolve()
		Game.refs = fresh
		return fresh
	end
	return refs
end
--#endregion Shared.Game

--#region Shared.Settings (keep identical in every feature file, source: shared/Settings.luau)
-- Settings: one feature's settings in a JSON file in its game's folder in Volt's workspace
-- (Corny/<KEY>/<name>.json, through Shared.Files), the proven corny.lua / boxsorter.lua pattern:
-- load() reads the file inside pcall and hands it to the feature's validate function, which
-- copies a key into the data only when it has the right type, is not NaN and is in range (a bad or
-- old file never breaks the feature); save() writes once, SAVE_DELAY after the first change of a
-- burst; flush() writes a pending save now (onDestroy). For a game whose files lived in Corny/
-- before game folders (LT2), load() first copies the old file in when the game's folder has
-- none of that name (Files.adopt).
-- Needs: Core, Files

local SettingsConfig = table.freeze({
	SAVE_DELAY = 1, -- write once, this long after the first change of a burst (corny.lua)
})

-- Copies the keys of a decoded file that pass the feature's checks into `data`
type SettingsValidate = (decoded: { [any]: any }, data: any) -> ()

type SettingsFields = {
	path: string, -- where the file is in the workspace ("Corny/LT2/autobuy.json"), for messages
	data: any, -- the feature's own table (typed by the feature), written as JSON
	_files: Files, -- the game's folder (Game.files)
	_name: string, -- the file's name in it ("autobuy.json")
	_validate: SettingsValidate,
	_log: Logger,
	_saveThread: thread?,
}

local Settings = {}
Settings.__index = Settings

type Settings = typeof(setmetatable({} :: SettingsFields, Settings))

-- `files` is the game's folder (Game.files) and `name` the file's name in it. `data` holds the
-- defaults and is filled in place by load(), so the feature keeps its own typed reference to it
local function newSettings(
	files: Files,
	name: string,
	data: any,
	validate: SettingsValidate,
	logger: Logger
): Settings
	local self = setmetatable({} :: SettingsFields, Settings)
	self.path = files:path(name)
	self.data = data
	self._files = files
	self._name = name
	self._validate = validate
	self._log = logger
	self._saveThread = nil
	return self
end

function Settings.load(self: Settings): ()
	self._files:adopt(self._name) -- the file from before game folders, when this one is missing (LT2)
	local decoded = self._files:readJson(self._name)
	if type(decoded) ~= "table" then
		return -- first run, or the file is unreadable: keep the defaults
	end
	local checked, err = try(self._validate, decoded, self.data)
	if not checked then
		self._log.warn(`{self.path}: {err} - the other settings kept their defaults`)
	end
end

function Settings.write(self: Settings): ()
	local ok, err = self._files:writeJson(self._name, self.data)
	if not ok then
		self._log.warn(`could not save settings: {err}`)
	end
end

-- Saves a moment later, so a burst of changes writes the file once
function Settings.save(self: Settings): ()
	if self._saveThread then
		return
	end
	self._saveThread = task.delay(SettingsConfig.SAVE_DELAY, function()
		self._saveThread = nil
		self:write()
	end)
end

-- Writes a pending save right away (teardown)
function Settings.flush(self: Settings): ()
	local pending = self._saveThread
	if pending == nil then
		return
	end
	self._saveThread = nil
	try(task.cancel, pending)
	self:write()
end
--#endregion Shared.Settings

--#region Shared.Shots (keep identical in every feature file, source: games/EightBall/shared/Shots.luau)
-- Shots: the game's pool table and aim for every EightBall feature that reads or plays shots.
-- Hooks the game's own functions once per server (getgenv().CornyShotsHooks; a re-run only
-- swaps the recorder): PoolPhysics.PredictShot and PoolAimOverlay.Update (the aim guide: the
-- table, direction, power, spin and the frame it is drawn on), PoolPhysics.Shoot (a shot being
-- played), PoolRules.IsLegalFirstContact (which rules go with which table),
-- PoolMatchClient.Update (an online match: your seat), PoolInputController.Update (your cue,
-- every frame), PoolAI.Plan (the offline bot's turn) and PoolMatchClient.Destroy. Each hook
-- calls the game's function unchanged; features add listeners. Plays a shot on a copy of the
-- table with the game's own PoolPhysics.Shoot and Step at PoolStepper.FixedDelta, the way the
-- server plays it (PoolMatchSession performShot), and judges it with the game's own referee
-- (PoolRules.BeginShot / ResolveShot on a copy of the rules). The method ran in game as
-- research/shot_paths_test.lua (2026-10-05). It never sends anything.
-- Needs: Core, Game

local ShotsConfig = table.freeze({
	HOOKS_KEY = "CornyShotsHooks", -- getgenv: the hooks and what they saw, once per server
	HOOKS_VERSION = 1,
	-- older test builds' hook keys (2026-10-05): their hooks still run until a rejoin
	OLD_KEYS = table.freeze({ "CornyShotPathsHooks", "CornyShotPathsTest" }) :: { string },
	TURN_COS = 0.9995, -- a heading change sharper than this (cosine) without a hit adds a corner
	MIN_GAP = 1e-3, -- path points closer than this (table inches) are merged
	MIN_POWER = 0.03, -- PoolConstants.Input.MinimumPower (2026-10-05 dump), if the game has none
	EIGHT = 8, -- PoolConstants.EightBallNumber (2026-10-05 dump), if the game has none
	QUICK_EVERY = 6, -- quick play: steps between checks whether anything else can still happen
	PACE_EVERY = 24, -- steps between calls of a play's pace callback (a search's frame budget)
	REACH_MARGIN = 1.15, -- quick play: a rolling ball's reach (PoolPhysics.RollDistance) times this
	REACH_EXTRA = 0.05, -- quick play: inches added to every reach (crawling balls)
	-- hooks every page needs; the others are optional (whose balls, your cue, the bot)
	REQUIRED = table.freeze({ PredictShot = true, AimUpdate = true, Shoot = true }) :: { [string]: boolean },
	WHITE = Color3.new(1, 1, 1), -- a ball the game's colour list does not have
})

-- One shot as the game predicts it. `sim` is the game's table simulation (PoolPhysics
-- newSimulation: Balls, Order, Events, Settled, Elapsed, IsBreakShot), an untyped game table
type ShotsAim = {
	sim: any,
	direction: Vector2,
	power: number,
	spin: Vector2,
	overlay: any?, -- the guide it was drawn on (a PoolAimOverlay object, untyped game table)
}

-- Whose turn and balls: known = the rules of the table are known
type ShotsOwner = {
	known: boolean,
	group: string?, -- your group, "Solid" or "Stripe"; nil on an open table
	opponent: boolean, -- the aim is your opponent's
	seat: number?,
	onEight: boolean, -- your group was cleared before this shot: the 8 is yours
	phase: string?, -- the match phase ("Break", "Open", "Assigned", ...)
}

-- One ball's path (recorded plays only)
type ShotsPath = {
	number: number,
	colour: Color3,
	points: { Vector2 },
	moved: boolean,
	pocketed: boolean,
	final: Vector2,
}

type ShotsResult = {
	paths: { ShotsPath }, -- empty unless the play was recorded
	potted: { number }, -- the balls that went in (the cue ball too), in the order they dropped
	pockets: { [number]: string }, -- the pocket each ball went into (PoolGeometry pocket Id)
	firstHit: number?, -- the first ball the cue ball touched
	railsAfterContact: number, -- cushion or jaw hits after the first contact (the referee's count)
	cueRest: Vector2?, -- where the cue ball stopped (quick play: where it was when play stopped)
	after: any, -- the played copy of the table (untyped game table), for the referee
	steps: number,
	settled: boolean, -- every ball stopped, or (quick play) nothing else could change the result
	ms: number,
}

-- What the game's referee says about a played shot (PoolRules.ResolveShot)
type ShotsVerdict = {
	legal: boolean, -- no foul
	fouls: { string }, -- "Scratch", "NoRailAfterContact", "WrongBallFirst", "NoContact", ...
	winner: number?, -- the seat that wins, when the shot ends the game
	shooter: number, -- the seat that shot
	continues: boolean, -- the shooter plays again
	rerack: boolean, -- the 8 on the break: the table is racked again
	groupAssigned: string?, -- the shooter's group, when this shot decided it
	group: string?, -- the shooter's group after the shot
}

-- A path being recorded: the copy's ball (untyped game table) and where the step began
type ShotsTrack = {
	path: ShotsPath,
	ball: any,
	from: Vector2,
	velocity: Vector2,
	hit: boolean,
}

-- What the hooks saw (shared by every feature, the test files and the full script)
type ShotsLive = {
	pending: ShotsAim?, -- the last PredictShot call
	aim: ShotsAim?, -- the guide on screen: a PredictShot call and the overlay it was drawn on
	controller: any?, -- your cue: the PoolInputController object (untyped game table)
	seenSims: { [any]: boolean }, -- tables the game predicts on (weak keys)
	rulesBySim: { [any]: any }, -- the PoolRules match of each table (weak keys)
	clientByRules: { [any]: any }, -- the online match client of each rules table (weak keys)
	botSeatByRules: { [any]: number }, -- the offline bot's seat in each rules table (weak keys)
	cueOwner: string?, -- the feature playing a shot with your cue right now (Shared.Cue): one at a time
}

-- The hooks in getgenv, once per server: impl (the recorder) is swapped by each run, original
-- holds the game's functions as they were, listeners[event][feature] are the features' calls
type ShotsHooks = {
	version: number,
	impl: { [string]: any },
	original: { [string]: any },
	live: ShotsLive,
	listeners: { [string]: { [string]: any } },
}

-- The table's frame on screen: table inches to pixels
type ShotsScreen = { centreX: number, centreY: number, scaleX: number, scaleY: number }

local Shots = {
	guiService = game:GetService("GuiService"),
}

-- ============ Hooks ============

-- A weak-keyed table
function Shots.weak(): { [any]: any }
	return setmetatable({}, { __mode = "k" }) :: any
end

-- The hooks, installed once per server (a re-run reuses them, installs any that are missing and
-- puts in this run's recorder). nil and the reason ("old", or what failed) when they cannot be
-- used. Call it from buildPage.
function Shots.install(refs: GameRefs): (ShotsHooks?, string?)
	local env = getgenv()
	for _, key in ShotsConfig.OLD_KEYS do
		if env[key] ~= nil then
			warnOnce(
				`shots.old.{key}`,
				`an older test build hooked the game this session ({key}): rejoin for clean results`
			)
		end
	end
	local existing: any = env[ShotsConfig.HOOKS_KEY]
	local hooks: ShotsHooks
	if existing == nil then
		hooks = {
			version = ShotsConfig.HOOKS_VERSION,
			impl = {},
			original = {},
			live = {
				pending = nil,
				aim = nil,
				controller = nil,
				seenSims = Shots.weak(),
				rulesBySim = Shots.weak(),
				clientByRules = Shots.weak(),
				botSeatByRules = Shots.weak(),
				cueOwner = nil,
			},
			listeners = {},
		}
		env[ShotsConfig.HOOKS_KEY] = hooks
	elseif type(existing) == "table" and existing.version == ShotsConfig.HOOKS_VERSION then
		hooks = existing
		-- a table an older build of this version made: fill in what it lacks
		local live: any = hooks.live
		for _, field in { "seenSims", "rulesBySim", "clientByRules", "botSeatByRules" } do
			if type(live[field]) ~= "table" then
				live[field] = Shots.weak()
			end
		end
		if type(hooks.listeners) ~= "table" then
			hooks.listeners = {}
		end
	else
		return nil, "old"
	end
	local hookFunction: any = hookfunction
	if type(hookFunction) ~= "function" then
		return nil, "this executor has no hookfunction"
	end
	hooks.impl = Shots.recorder(hooks)
	local function field(module: any, name: string): any
		return if type(module) == "table" then module[name] else nil
	end
	local targets: { [string]: any } = {
		PredictShot = field(refs.physics, "PredictShot"),
		AimUpdate = field(refs.aim, "Update"),
		Shoot = field(refs.physics, "Shoot"),
		InputUpdate = field(refs.input, "Update"),
		LegalFirstContact = field(refs.rules, "IsLegalFirstContact"),
		MatchUpdate = field(refs.matchClient, "Update"),
		MatchDestroy = field(refs.matchClient, "Destroy"),
		BotPlan = field(refs.ai, "Plan"),
	}
	for name, target in targets do
		if hooks.original[name] ~= nil then
			continue
		end
		local required = ShotsConfig.REQUIRED[name] == true
		if type(target) ~= "function" then
			if required then
				return nil, `the game has no {name} function`
			end
			warnOnce(
				`shots.missing.{name}`,
				`the game has no {name}: the pages that need it will say so`
			)
			continue
		end
		local original: any = nil
		local function dispatch(...: any): ...any
			local impl = hooks.impl[name]
			if impl ~= nil then
				local ok, err = pcall(impl, ...)
				if not ok then
					warnOnce(`shots.hook.{name}`, `while the game ran {name}: {err}`)
				end
			end
			return original(...)
		end
		local hooked, result = try(hookFunction, target, dispatch)
		if not hooked then
			if required then
				return nil, `could not hook {name}: {result}`
			end
			warnOnce(`shots.hook.{name}`, `could not hook {name}: {result}`)
			continue
		end
		original = result
		hooks.original[name] = result
	end
	return hooks, nil
end

-- Calls each feature's listener for `event`. They run on the game's thread: plain table work and
-- the game's own calls; CornyMenu calls are safe there too (v5), your own GUI work is not
function Shots.notify(hooks: ShotsHooks, event: string, ...: any): ()
	local listeners = hooks.listeners[event]
	if listeners == nil then
		return
	end
	for owner, callback in listeners do
		local ok, err = pcall(callback, ...)
		if not ok then
			warnOnce(`shots.listener.{event}.{owner}`, `{owner} ({event}): {err}`)
		end
	end
end

-- A feature's listener for a hook ("Shoot": sim, direction, power, spin, before the shot is
-- played; "InputUpdate": your cue object, before the game updates it this frame)
function Shots.listen(hooks: ShotsHooks, event: string, owner: string, callback: any): ()
	local listeners = hooks.listeners[event]
	if listeners == nil then
		listeners = {}
		hooks.listeners[event] = listeners
	end
	listeners[owner] = callback
end

-- Removes a listener, only if it is still this one (a newer run may have replaced it)
function Shots.unlisten(hooks: ShotsHooks, event: string, owner: string, callback: any): ()
	local listeners = hooks.listeners[event]
	if listeners ~= nil and listeners[owner] == callback then
		listeners[owner] = nil
	end
end

-- What the hooks record (they run on the game's threads: only plain tables here)
function Shots.recorder(hooks: ShotsHooks): { [string]: any }
	local live = hooks.live
	local impl: { [string]: any } = {}

	impl.PredictShot = function(sim: any, direction: any, power: any, spin: any): ()
		if type(sim) ~= "table" or typeof(direction) ~= "Vector2" then
			return
		end
		live.seenSims[sim] = true
		live.pending = {
			sim = sim,
			direction = direction,
			power = if type(power) == "number" then power else 0,
			spin = if typeof(spin) == "Vector2" then spin else Vector2.zero,
			overlay = nil,
		}
	end

	-- the game draws its guide right after predicting it, with the same direction
	impl.AimUpdate = function(overlay: any, _cuePosition: any, direction: any): ()
		local pending = live.pending
		if pending ~= nil and type(overlay) == "table" and pending.direction == direction then
			pending.overlay = overlay
			live.aim = pending
		end
	end

	impl.Shoot = function(...: any): ()
		Shots.notify(hooks, "Shoot", ...)
	end

	impl.LegalFirstContact = function(rules: any, sim: any): ()
		if type(rules) == "table" and type(sim) == "table" then
			live.rulesBySim[sim] = rules
		end
	end

	-- an online match: its rules go with its table (which is the offline one too)
	impl.MatchUpdate = function(client: any): ()
		if type(client) == "table" and type(client.Rules) == "table" then
			live.clientByRules[client.Rules] = client
			if type(client.Simulation) == "table" then
				live.rulesBySim[client.Simulation] = client.Rules
			end
		end
	end

	-- an online match ended: forget its rules, so the offline ones are asked for again
	impl.MatchDestroy = function(client: any): ()
		if type(client) ~= "table" or type(client.Rules) ~= "table" then
			return
		end
		live.clientByRules[client.Rules] = nil
		local sim = client.Simulation
		if type(sim) == "table" and live.rulesBySim[sim] == client.Rules then
			live.rulesBySim[sim] = nil
		end
	end

	-- the offline bot plans its turn: PoolAI.Plan(bot, sim, rules, seat)
	impl.BotPlan = function(_bot: any, sim: any, rules: any, seat: any): ()
		if type(rules) == "table" and type(seat) == "number" then
			live.botSeatByRules[rules] = seat
			if type(sim) == "table" then
				live.rulesBySim[sim] = rules
			end
		end
	end

	impl.InputUpdate = function(controller: any, ...: any): ()
		if type(controller) ~= "table" then
			return
		end
		live.controller = controller
		Shots.notify(hooks, "InputUpdate", controller, ...)
	end

	return impl
end

-- ============ The table and its rules ============

function Shots.cueNumber(refs: GameRefs): number
	local number = refs.constants.CueBallNumber
	return if type(number) == "number" then number else 0
end

function Shots.eightNumber(refs: GameRefs): number
	local number = refs.constants.EightBallNumber
	return if type(number) == "number" then number else ShotsConfig.EIGHT
end

-- Power and spin as the server takes them (PoolMatchSession Shoot clamps both)
function Shots.clamp(refs: GameRefs, power: number, spin: Vector2): (number, Vector2)
	local input = refs.constants.Input
	local minimum: number = if type(input) == "table"
			and type(input.MinimumPower) == "number"
		then input.MinimumPower
		else ShotsConfig.MIN_POWER
	return math.clamp(power, minimum, 1),
		Vector2.new(math.clamp(spin.X, -1, 1), math.clamp(spin.Y, -1, 1))
end

-- Every ball's place on the table, as text (a table changed when this changed)
function Shots.tableKey(sim: any): string
	local parts: { string } = { tostring(sim.IsBreakShot) }
	for _, number in sim.Order do
		local ball = sim.Balls[number]
		if ball ~= nil then
			local position = ball.Position
			local flag = if ball.Pocketed then "p" else "-"
			table.insert(
				parts,
				string.format("%d:%.5f,%.5f%s", number, position.X, position.Y, flag)
			)
		end
	end
	return table.concat(parts, "|")
end

-- Asks your cue which balls are legal, so the rules its table uses right now are known (the
-- game's own IsLegalTarget, which reaches the LegalFirstContact hook). Every call: a new match
-- has new rules on the same table
function Shots.primeRules(hooks: ShotsHooks, refs: GameRefs, sim: any): ()
	local controller = hooks.live.controller
	if type(controller) ~= "table" or controller.Simulation ~= sim then
		return
	end
	local isLegal = controller.IsLegalTarget
	if type(isLegal) == "function" then
		try(isLegal, Shots.eightNumber(refs))
	end
end

-- The rules the game uses for a table now (nil when unknown)
function Shots.rulesOf(hooks: ShotsHooks, refs: GameRefs, sim: any): any?
	Shots.primeRules(hooks, refs, sim)
	local rules = hooks.live.rulesBySim[sim]
	return if type(rules) == "table" then rules else nil
end

-- Whose aim and balls, from the rules the game uses for that table (PoolRules: Groups[seat] =
-- "Solid" / "Stripe"). Your seat: online the match's Seat; offline against the bot the seat the
-- bot does not play (PoolGameUIHandler: the bot is seat 2, you seat 1); offline practice the
-- turn being aimed.
function Shots.ownerOf(hooks: ShotsHooks, refs: GameRefs, sim: any): ShotsOwner
	local live = hooks.live
	local rules = Shots.rulesOf(hooks, refs, sim)
	local unknown: ShotsOwner =
		{ known = false, group = nil, opponent = false, seat = nil, onEight = false, phase = nil }
	if rules == nil then
		return unknown
	end
	local turn = rules.Turn
	local client = live.clientByRules[rules]
	local botSeat = live.botSeatByRules[rules]
	local seat: any = turn
	if client ~= nil then
		seat = client.Seat
	elseif botSeat ~= nil then
		seat = if botSeat == 1 then 2 else 1
	end
	if type(seat) ~= "number" or seat <= 0 then
		return unknown -- watching a match
	end
	local groups = rules.Groups
	local listed: any = if type(groups) == "table" then groups[seat] else nil
	local group: string? = if type(listed) == "string" then listed else nil
	local onEight = false
	if group ~= nil and refs.rules ~= nil then
		local ok, remaining = try(refs.rules.CountRemaining, sim, group)
		onEight = ok and remaining == 0
	end
	local phase: any = rules.Phase
	return {
		known = true,
		group = group,
		opponent = turn ~= seat,
		seat = seat,
		onEight = onEight,
		phase = if type(phase) == "string" then phase else nil,
	}
end

-- Whether the cue ball's first hit is legal for the player whose turn it is on that table
-- (the game's IsLegalFirstContact, unhooked); nil while the rules are unknown
function Shots.isLegalFirst(hooks: ShotsHooks, sim: any, number: number?): boolean?
	if number == nil then
		return false -- touched no ball
	end
	local rules = hooks.live.rulesBySim[sim]
	local legal = hooks.original.LegalFirstContact
	if type(rules) ~= "table" or legal == nil then
		return nil
	end
	local ok, result = pcall(legal, rules, sim, number)
	if not ok then
		return nil
	end
	return result == true
end

-- A ball that goes in, for you: "yours" (one of yours; the 8 once your group is cleared and the
-- cue ball stays up; any ball but the 8 on an open table when you shoot) or "not" (the
-- opponent's, the 8 too early, the cue ball; on your opponent's aim an open-table pot and the 8
-- are theirs); nil while the rules are unknown
function Shots.verdictOf(refs: GameRefs, owner: ShotsOwner, number: number, cueIn: boolean): string?
	local eight = Shots.eightNumber(refs)
	if number == Shots.cueNumber(refs) then
		return "not"
	elseif not owner.known then
		return nil
	elseif number == eight then
		return if owner.onEight and not cueIn and not owner.opponent then "yours" else "not"
	elseif owner.group == nil then
		return if owner.opponent then "not" else "yours"
	end
	local ballGroup = if number < eight then "Solid" else "Stripe"
	return if ballGroup == owner.group then "yours" else "not"
end

-- The game's own referee on a played shot (PoolRules.BeginShot on the table before,
-- ResolveShot on the played copy), with a copy of the rules so the real match is untouched.
-- nil when the rules are unknown or the referee failed
function Shots.judge(refs: GameRefs, rules: any?, before: any, result: ShotsResult): ShotsVerdict?
	local poolRules = refs.rules
	if rules == nil or poolRules == nil or result.after == nil then
		return nil
	end
	local copy: any = table.clone(rules)
	copy.Groups = if type(rules.Groups) == "table" then table.clone(rules.Groups) else {}
	local shooter = copy.Turn
	local began, begin = try(poolRules.BeginShot, copy, before)
	if not began then
		return nil
	end
	local resolved, verdict = try(poolRules.ResolveShot, copy, result.after, begin)
	if not resolved or type(verdict) ~= "table" then
		return nil
	end
	local fouls: { string } = {}
	if type(verdict.Fouls) == "table" then
		for _, foul in verdict.Fouls do
			table.insert(fouls, tostring(foul))
		end
	end
	local group: any = copy.Groups[shooter]
	return {
		legal = verdict.Legal == true,
		fouls = fouls,
		winner = if type(verdict.Winner) == "number" then verdict.Winner else nil,
		shooter = if type(shooter) == "number" then shooter else 0,
		continues = verdict.Continues == true,
		rerack = verdict.Rerack == true,
		groupAssigned = if type(verdict.GroupAssigned) == "string"
			then verdict.GroupAssigned
			else nil,
		group = if type(group) == "string" then group else nil,
	}
end

-- ============ Playing a shot on a copy of the table ============

function Shots.addPoint(path: ShotsPath, point: Vector2): ()
	local points = path.points
	if (point - points[#points]).Magnitude > ShotsConfig.MIN_GAP then
		table.insert(points, point)
	end
end

-- The exact point of a ball's first hit in a step: it rolled straight from where the step began
function Shots.markHit(track: ShotsTrack?, elapsed: number): ()
	if track == nil or track.hit then
		return
	end
	track.hit = true
	Shots.addPoint(track.path, track.from + track.velocity * elapsed)
end

-- Quick play: true once nothing can change the result any more. Each rolling ball's reach
-- (PoolPhysics.RollDistance times a margin, plus one step and a little) must be shorter than its
-- way to every pocket and to every other ball's reach, and, while the referee still needs a rail
-- after the first contact, to the nearest cushion. A spinning ball can still turn at a cushion:
-- never out of play.
function Shots.outOfPlay(refs: GameRefs, copy: any, pockets: { any }, needRail: boolean): boolean
	local constants = refs.constants
	local defaultRadius: number = constants.BallRadius
	local halfWidth: number = constants.PlayWidth / 2
	local halfHeight: number = constants.PlayHeight / 2
	local step: number = refs.stepper.FixedDelta
	local rollDistance = refs.physics.RollDistance
	local balls: { any } = {}
	local reaches: { number } = {}
	local radii: { number } = {}
	for _, number in copy.Order do
		local ball = copy.Balls[number]
		if ball == nil or ball.Pocketed or ball.Sinking then
			continue
		end
		local speed = ball.Velocity.Magnitude
		local reach = 0
		if speed > 0 then
			if ball.Spin.Magnitude > 0.01 then
				return false
			end
			reach = rollDistance(speed) * ShotsConfig.REACH_MARGIN
				+ speed * step
				+ ShotsConfig.REACH_EXTRA
		end
		table.insert(balls, ball)
		table.insert(reaches, reach)
		-- the game's physics: a ball's own Radius, else the table's (trickshot scenes resize balls)
		table.insert(radii, if type(ball.Radius) == "number" then ball.Radius else defaultRadius)
	end
	for index, ball in balls do
		local reach = reaches[index]
		if reach <= 0 then
			continue
		end
		local radius = radii[index]
		local position: Vector2 = ball.Position
		for _, pocket in pockets do
			if
				(position - pocket.MouthCentre).Magnitude - pocket.Mouth / 2 - radius * 2 <= reach
			then
				return false
			end
		end
		for other, otherBall in balls do
			if
				other ~= index
				and (position - otherBall.Position).Magnitude - radius - radii[other]
					<= reach + reaches[other]
			then
				return false
			end
		end
		if needRail then
			local toRail = math.min(
				halfWidth - math.abs(position.X),
				halfHeight - math.abs(position.Y)
			) - radius
			if toRail <= reach then
				return false
			end
		end
	end
	return true
end

-- Plays one shot on a copy of `sim` with the game's own physics. `record`: keep every ball's
-- path (its start, every hit and its end: between hits a ball rolls straight). `quick`: stop
-- once nothing can change the result (searches; where balls stop is then approximate).
-- `pace` (optional, a search's): called every PACE_EVERY steps; it may yield (the copy is the
-- play's own) and returns false to cancel the play. nil when the game refuses the shot (no cue
-- ball) or the play was cancelled.
function Shots.play(
	hooks: ShotsHooks,
	refs: GameRefs,
	sim: any,
	direction: Vector2,
	power: number,
	spin: Vector2,
	record: boolean,
	quick: boolean,
	pace: (() -> boolean)?
): ShotsResult?
	local started = os.clock()
	local paused = 0 -- seconds spent in pace (yielded frames), left out of ms
	local shoot = hooks.original.Shoot -- the game's Shoot, without the hook
	if shoot == nil then
		return nil
	end
	local stepper = refs.stepper
	local step: number = stepper.FixedDelta
	local maxSteps = math.ceil(stepper.MaxSettleSeconds / step)
	local cue = Shots.cueNumber(refs)
	local colours = refs.constants.BallColours

	local copy: any = table.clone(sim) -- the game's untyped table, copied
	local balls: { [any]: any } = {}
	for number, ball in sim.Balls do
		balls[number] = table.clone(ball)
	end
	copy.Balls = balls
	copy.Order = table.clone(sim.Order)
	copy.Events = {}
	if not shoot(copy, direction, power, spin) then
		return nil
	end

	local tracks: { ShotsTrack } = {}
	local byNumber: { [any]: ShotsTrack } = {}
	if record then
		for _, listedNumber in copy.Order do
			local number = tonumber(listedNumber)
			local ball = if number ~= nil then balls[number] else nil
			if number == nil or ball == nil or ball.Pocketed then
				continue
			end
			local listed: any = if type(colours) == "table" then colours[number] else nil
			local track: ShotsTrack = {
				path = {
					number = number,
					colour = if typeof(listed) == "Color3" then listed else ShotsConfig.WHITE,
					points = { ball.Position },
					moved = false,
					pocketed = false,
					final = ball.Position,
				},
				ball = ball,
				from = ball.Position,
				velocity = ball.Velocity,
				hit = false,
			}
			table.insert(tracks, track)
			byNumber[number] = track
		end
	end

	local quickOn = quick and refs.geometry ~= nil
	local pockets: { any } = if quickOn then refs.geometry.GetPockets() else {}
	local physicsStep = refs.physics.Step
	local steps = 0
	local seen = 0
	local firstHit: number? = nil
	local firstHitTime = math.huge
	local railsAfterContact = 0
	local objectIn = false
	local stoppedEarly = false
	while not copy.Settled and steps < maxSteps do
		local stepStart: number = copy.Elapsed
		for _, track in tracks do
			track.from = track.ball.Position
			track.velocity = track.ball.Velocity
			track.hit = false
		end
		physicsStep(copy, step)
		steps += 1
		local events = copy.Events
		for index = seen + 1, #events do
			local event = events[index]
			local kind = event.Kind
			if kind == "BallHit" and event.Ball == cue and firstHit == nil then
				firstHit = tonumber(event.Other)
				firstHitTime = if type(event.Time) == "number" then event.Time else stepStart
			elseif kind == "BallHit" and event.Other == cue and firstHit == nil then
				firstHit = tonumber(event.Ball)
				firstHitTime = if type(event.Time) == "number" then event.Time else stepStart
			elseif kind == "CushionHit" or kind == "TipHit" then
				if type(event.Time) == "number" and event.Time >= firstHitTime then
					railsAfterContact += 1
				end
			elseif kind == "Pocketed" and event.Ball ~= cue then
				objectIn = true
			end
			if record and kind ~= "Pocketed" and type(event.Time) == "number" then
				Shots.markHit(byNumber[event.Ball], event.Time - stepStart)
				if event.Other ~= nil then
					Shots.markHit(byNumber[event.Other], event.Time - stepStart)
				end
			end
		end
		seen = #events
		for _, track in tracks do
			local ball = track.ball
			if ball.Position ~= track.from then
				track.path.moved = true
			end
			-- a turn without a hit (dropping into a pocket): a corner where the step ended
			local before = track.velocity
			local after: Vector2 = ball.Velocity
			if
				not track.hit
				and before.Magnitude > 1e-6
				and after.Magnitude > 1e-6
				and before.Unit:Dot(after.Unit) < ShotsConfig.TURN_COS
			then
				Shots.addPoint(track.path, ball.Position)
			end
		end
		if quickOn and steps % ShotsConfig.QUICK_EVERY == 0 then
			-- the referee wants a rail after the first contact unless a ball goes in
			local needRail = firstHit ~= nil and railsAfterContact == 0 and not objectIn
			if Shots.outOfPlay(refs, copy, pockets, needRail) then
				stoppedEarly = true
				break
			end
		end
		if pace ~= nil and steps % ShotsConfig.PACE_EVERY == 0 then
			local before = os.clock()
			local going = pace()
			paused += os.clock() - before
			if not going then
				return nil
			end
		end
	end

	-- what went in: dropped (Pocketed events), or on its way down (Sinking) when play stopped
	local potted: { number } = {}
	local pocketOf: { [number]: string } = {}
	local counted: { [number]: boolean } = {}
	for _, event in copy.Events do
		local number = tonumber(event.Ball)
		if event.Kind == "Pocketed" and number ~= nil and not counted[number] then
			counted[number] = true
			table.insert(potted, number)
			pocketOf[number] = tostring(event.PocketId)
		end
	end
	for _, listedNumber in copy.Order do
		local number = tonumber(listedNumber)
		local ball = if number ~= nil then balls[number] else nil
		if number ~= nil and ball ~= nil and ball.Sinking == true and not counted[number] then
			counted[number] = true
			table.insert(potted, number)
			pocketOf[number] = tostring(ball.PocketId)
			-- the referee reads Pocketed events: a sinking ball always lands
			table.insert(
				copy.Events,
				{ Kind = "Pocketed", Time = copy.Elapsed, Ball = number, PocketId = ball.PocketId }
			)
		end
	end

	local paths: { ShotsPath } = {}
	for _, track in tracks do
		local path = track.path
		path.pocketed = counted[path.number] == true
		path.final = track.ball.Position
		if path.moved then
			Shots.addPoint(path, path.final)
		end
		table.insert(paths, path)
	end
	local cueBall = balls[cue]
	return {
		paths = paths,
		potted = potted,
		pockets = pocketOf,
		firstHit = firstHit,
		railsAfterContact = railsAfterContact,
		cueRest = if cueBall ~= nil and not counted[cue] then cueBall.Position else nil,
		after = copy,
		steps = steps,
		settled = copy.Settled == true or stoppedEarly,
		ms = (os.clock() - started - paused) * 1000,
	}
end

-- ============ Screen ============

-- The guide's frame (it covers the table) on screen: the game's own mapping
-- (PoolTableRenderer2D.PixelToTable, inverted); the 3D view lines its camera up with it
function Shots.screenOf(refs: GameRefs, root: any): ShotsScreen?
	if typeof(root) ~= "Instance" or not root:IsA("GuiObject") then
		return nil
	end
	local size: Vector2 = root.AbsoluteSize
	if size.X <= 0 or size.Y <= 0 then
		return nil
	end
	local origin: Vector2 = root.AbsolutePosition + Shots.guiService:GetGuiInset()
	local constants = refs.constants
	return {
		centreX = origin.X + size.X / 2,
		centreY = origin.Y + size.Y / 2,
		scaleX = size.X / constants.FrameWidth,
		scaleY = size.Y / constants.FrameHeight,
	}
end

-- Whether one of the game's GUI objects is on screen (it and every parent visible, its ScreenGui
-- enabled), like PoolAimOverlay.IsAimShown
function Shots.isOnScreen(gui: any): boolean
	local current: any = gui
	while typeof(current) == "Instance" do
		if current:IsA("LayerCollector") then
			return current.Enabled == true
		end
		if current:IsA("GuiObject") and not current.Visible then
			return false
		end
		current = current.Parent
	end
	return false
end
--#endregion Shared.Shots

--#region Shared.Cue (keep identical in every feature file, source: games/EightBall/shared/Cue.luau)
-- Cue: plays the best shot with your cue the way a player would, on your turn only. The search
-- (anytime, inside options.thinkSeconds, a few ms per frame): straight pots, combos, banks, kicks,
-- safeties and, when nothing better turned up, an open search, each line played on copies of the
-- table (Shots.play) and judged by the game's own referee (Shots.judge: fouls, the 8, the break,
-- whether you play again); the best few tried a little either side (aimed at the middle of what
-- works), then replayed in full with draw, follow and side spin and scored on the next shot they
-- leave (a safety on the shots it leaves the opponent). In the trickshot mode the goal is the
-- puzzle's targets in their pockets. The shot: your cue is steered the way the game's keyboard
-- nudge does (PoolInputController nudgeAim: Direction set and NudgeAnchor held at the mouse) from
-- the Shots InputUpdate listener, in an eased sweep that sometimes overshoots and settles back, a
-- pause, the charge shown on the meter (PoolInputController.SetPower, as the game's offline bot
-- charges your cue), timings from PoolConstants.Bots; then released the way the game does on
-- mouse release (onDeactivated: power 0, CanPlaceCueBall false, state Simulating, the cue's
-- ShotBindable fired), so the game's own handler plays it offline or sends it online. Ball in
-- hand (options.place): placed the way a release while dragging does on the best of the game's
-- own straight-in spots (PoolAI.PlaceCueBallOptions). A safe miss (options.missChance): the best
-- line a little off, kept only when the referee says legal and nothing goes in; never on a
-- winning 8, the break, or when the opponent is on the 8.
-- Needs: Core, Game, Shots

local CueConfig = table.freeze({
	BUDGET = 0.010, -- seconds of search per frame before the game gets the frame back
	THINK_DEFAULT = 6, -- seconds a search may take when the page gives none
	RESERVE = 0.3, -- share of the thinking time kept for the final checks (window, spin)
	-- when the lines have pot nothing by FIRST_SHARE of the time, the open search runs until
	-- OPEN_SHARE; the window check stops at REFINE_SHARE, the full replays and the miss at the end
	-- (shares of the time left after placing the ball in hand)
	FIRST_SHARE = 0.45,
	OPEN_SHARE = 0.6,
	REFINE_SHARE = 0.85,
	POWERS = table.freeze({ 0.3, 0.5, 0.7, 0.95 }) :: { number }, -- each line is tried at these
	PROBE_POWER = 0.7, -- banks, kicks and the open search: the power the window is probed at
	PROBE_DEGREES = table.freeze({ 0, -0.25, 0.25, -0.5, 0.5 }) :: { number }, -- around a solved line
	MIN_CUT = 0.08, -- a straight line needs this cut quality (PoolAI.Plan's 0.08)
	COMBO_CUT = 0.35, -- each ball of a combo needs at least this cut quality
	BANK_CUT = 0.2, -- a bank's or kick's contact needs at least this cut quality
	MAX_COMBOS = 40, -- combo lines tried, best cuts first
	COMBOS_FIRST = 12, -- the best combos go before banks and kicks; the rest after them
	SAME_DEGREES = 0.05, -- lines closer than this are tried once
	BLOCK = 0.95, -- a line passing closer than this many ball widths to a ball is blocked (PoolAI 0.9)
	BOUNCE_SAMPLES = 48, -- points along a cushion where a bank's or kick's bounce is looked for
	JAW_MARGIN = 1.5, -- ball widths around a pocket's mouth where no bounce is used
	OPEN_DEGREES = 1, -- the open search: one line per degree
	REFINE = 6, -- the best shots tried a little either side
	REFINE_SPAN = 0.48, -- degrees either side
	REFINE_STEP = 0.08, -- degrees
	FINAL = 6, -- the best shots replayed in full with each spin
	SPINS = table.freeze({
		Vector2.zero,
		Vector2.new(0, 0.6), -- follow
		Vector2.new(0, -0.6), -- draw
		Vector2.new(0.5, 0), -- side
		Vector2.new(-0.5, 0),
	}) :: { Vector2 },
	CLEAR_CUT = 0.3, -- a ball counts as an open next shot with this cut quality and a clear line
	-- ball in hand: the game's best straight-in spots (PoolAI.PlaceCueBallOptions), each searched
	-- quickly (straight lines and combos) within this share of the thinking time
	PLACE_SPOTS = 3,
	PLACE_POWERS = table.freeze({ 0.45, 0.75 }) :: { number },
	PLACE_SHARE = 0.35,
	PLACE_MIN = 0.4, -- seconds after placing the ball before the cue turns
	PLACE_MAX = 0.9,
	-- a safe miss: the best line turned by these (degrees), the first the referee calls safe
	MISS_DEGREES = table.freeze({ 0.7, -0.7, 1.1, -1.1, 1.6, -1.6, 2.3, -2.3 }) :: { number },
	-- scores
	WIN = 10000, -- the game is won (the 8 legally, or the trickshot solved)
	LOSS = -10000, -- the game is lost
	RERACK = -3000, -- the 8 on the break: racked again for the opponent
	FOUL = -1000, -- the opponent gets ball in hand
	POT = 100, -- per ball of yours (a target in the trickshot mode) that goes in
	OPPONENT_POT = -30, -- per ball of the opponent's that goes in
	NEXT = 40, -- times 0..1: open next shots the cue ball leaves you
	SAFETY = 30, -- times 0..1: few open shots left for the opponent (a safety)
	POWER = -5, -- times the power: softer is calmer
	ROBUST = 50, -- times 0..1: how wide the window that still works is (up to REFINE_SPAN)
	UNCHECKED = -60, -- a shot not replayed in full ranks this much lower (its outcome still counts)
	STYLE = table.freeze({
		straight = 0,
		combo = -5,
		bank = -10,
		kick = -15,
		trick = -20,
		safety = 0,
	}) :: { [string]: number },
	-- the glide, from PoolConstants.Bots (2026-10-05 dump): Carry (Seconds 0.75-1.6, Jitter 0.15,
	-- OvershootChance 0.45) and Theatre (OverAimDegrees 2.5-7, MinSettleSeconds 0.9,
	-- ChargeHoldSeconds 0.5-0.65); the pause and the charge are shorter than the bot's
	GLIDE_MIN = 0.5, -- seconds
	GLIDE_MAX = 1.4,
	GLIDE_PER_DEGREE = 0.008, -- seconds per degree turned
	JITTER = 0.15, -- +-15% on the glide and the pause
	OVERSHOOT_CHANCE = 0.45,
	OVERSHOOT_MIN = 2.5, -- degrees
	OVERSHOOT_MAX = 7,
	SETTLE_MIN = 0.25, -- seconds back from an overshoot
	SETTLE_MAX = 0.4,
	PAUSE_MIN = 0.5, -- seconds on the line before the charge
	PAUSE_MAX = 1,
	CHARGE_MIN = 0.25, -- seconds to pull the power up
	CHARGE_MAX = 0.45,
	HOLD_MIN = 0.5, -- seconds held at full charge (Theatre.ChargeHoldSeconds)
	HOLD_MAX = 0.65,
	MOUSE_RELEASE = 24, -- pixels the mouse may move before you take the aim back (the game's nudge)
	FIRE_GUARD = 0.5, -- seconds the cue waits for the shot to start (PoolInputController ReadyAt)
	WATCHDOG = 0.6, -- seconds without the game updating your cue: the turn has passed
	WATCHDOG_FRAMES = 20, -- ... and at least this many frames (one long frame is not a lost turn)
	-- the trickshot editor object (PoolTrickshotEditor.new, 2026-10-05 dump): keys only it has
	TRICK_KEYS = table.freeze({ "Scene", "solvedEvent", "messageEvent" }) :: { string },
	-- how a shot turns out, worst to best
	RANK = table.freeze({
		loss = 0,
		foul = 1,
		safe = 2,
		partial = 3,
		pot = 4,
		solve = 5,
		win = 6,
	}) :: { [string]: number },
})

-- How a shot turns out, worst to best (CueConfig scores follow it)
type CueOutcome = string -- "loss" | "foul" | "safe" | "partial" | "pot" | "solve" | "win"

-- One shot it could play
type CueShot = {
	direction: Vector2,
	power: number,
	spin: Vector2,
	score: number,
	outcome: CueOutcome,
	yours: { number }, -- your balls (the puzzle's targets) that go in
	theirs: number, -- how many of the opponent's go in
	fouls: { string }, -- the referee's fouls ("Scratch", "WrongBallFirst", ...)
	style: string, -- "straight" | "combo" | "bank" | "kick" | "trick" | "safety"
	line: string, -- the line it plays ("3>FootTop", "1>9>SideTop", "bank 3>FootTop>top"): one shot per line
	robust: number, -- degrees of the window that still works (0: not checked)
	full: boolean, -- judged in a full play (exact), not a quick one
	missed: boolean, -- a safe miss on purpose
}

type CueCandidate = { direction: Vector2, line: string, style: string, probe: boolean }

type CueBall = { number: number, position: Vector2 }

type CueRail = {
	name: string,
	vertical: boolean,
	at: number,
	normal: Vector2,
	low: number,
	high: number,
}

-- What the shot is for: a match (the rules) or the trickshot mode (its targets)
type CueGoal = { kind: string, targets: { { number: number, pocket: string? } } }

-- The search on one table, spread over frames
type CueJob = {
	controller: any, -- your cue (a PoolInputController object, untyped game table)
	sim: any, -- the live table (untyped game table)
	planSim: any, -- the table it plans on: a copy with the cue ball moved when it is in hand
	rules: any?, -- the PoolRules match of the table (untyped game table)
	goal: CueGoal,
	tableKey: string,
	owner: ShotsOwner,
	spin: Vector2,
	place: boolean, -- the ball is in hand: place it first
	placeAt: Vector2?, -- where it goes
	missChance: number,
	started: number,
	deadline: number,
	shots: { CueShot },
	lines: number,
	done: boolean,
	problem: string?,
	cancelled: boolean,
	progress: number,
	tries: number,
	ms: number,
	missed: boolean,
	stage: string, -- what the search is doing (Test tools)
	pace: (() -> boolean)?, -- the search's frame budget, handed to Shots.play (yields, false: stop)
}

-- Playing one shot: planning, placing, then the glide, settle, pause and charge
type CueSession = {
	controller: any, -- your cue (a PoolInputController object, untyped game table)
	job: CueJob,
	test: boolean, -- plan only, never aim or shoot
	phase: string, -- "planning" | "placed" | "glide" | "settle" | "pause" | "charge"
	index: number, -- which of job.shots
	shot: CueShot?,
	phaseStart: number,
	phaseEnd: number,
	fromAngle: number,
	overAngle: number,
	targetAngle: number,
	settleSeconds: number,
	pauseSeconds: number,
	chargeSeconds: number,
	holdSeconds: number,
	mouseStart: Vector2,
	progressShown: number,
	lastSeen: number, -- os.clock() the game last updated your cue
	unseenFrames: number, -- frames since the game last updated your cue
	spinBefore: Vector2?, -- the HUD's spin before it set its own
}

type CueOptions = {
	owner: string, -- the feature playing (one at a time across features: Shots live.cueOwner)
	place: boolean, -- with the ball in hand, place the cue ball itself (else it asks you to)
	mouseRelease: boolean, -- moving the mouse takes the aim back
	showIndex: boolean, -- say "Shot 2 of 5" (a page with a next-shot key)
	missChance: () -> number, -- 0..1, read when a shot is planned
	thinkSeconds: () -> number, -- how long a search may take
	onPrompt: (lines: { string }, withKeys: boolean) -> (), -- show what it does (key hints or not)
	onEnd: (text: string?, ok: boolean, shot: CueShot?, test: boolean) -> (), -- the shot ended
}

type CueFields = {
	lastJob: CueJob?, -- the last search (Test tools)
	_hooks: ShotsHooks,
	_refs: GameRefs,
	_options: CueOptions,
	_session: CueSession?,
	_listener: any,
	_watch: RBXScriptConnection?,
	_random: Random,
	_destroyed: boolean,
}

local Cue = {}
Cue.__index = Cue

type Cue = typeof(setmetatable({} :: CueFields, Cue))

-- Your cue for one feature: listens to the game's cue updates (Shots InputUpdate) under
-- options.owner and watches that the turn is still yours. Make it in buildPage; Destroy it in
-- onDestroy.
local function newCue(hooks: ShotsHooks, refs: GameRefs, options: CueOptions): Cue
	local self = setmetatable({} :: CueFields, Cue)
	self.lastJob = nil
	self._hooks = hooks
	self._refs = refs
	self._options = options
	self._session = nil
	self._random = Random.new()
	self._destroyed = false
	self._listener = function(controller: any): ()
		self:_steer(controller)
	end
	Shots.listen(hooks, "InputUpdate", options.owner, self._listener)
	self._watch = RunService.Heartbeat:Connect(function(): ()
		self:_watchTurn()
	end)
	return self
end

-- ============ Angles and timing ============

function Cue.angleOf(direction: Vector2): number
	return math.atan2(direction.Y, direction.X)
end

function Cue.rotate(direction: Vector2, degrees: number): Vector2
	local angle = math.atan2(direction.Y, direction.X) + math.rad(degrees)
	return Vector2.new(math.cos(angle), math.sin(angle))
end

-- The shortest turn from `from` to `to`, in radians (-pi..pi)
function Cue.turn(from: number, to: number): number
	return ((to - from + math.pi) % (2 * math.pi)) - math.pi
end

-- PoolAI.Ease: smoothstep
function Cue.ease(t: number): number
	local x = math.clamp(t, 0, 1)
	return x * x * (3 - 2 * x)
end

function Cue.between(random: Random, low: number, high: number): number
	return low + (high - low) * random:NextNumber()
end

-- ============ Text ============

function Cue.joinNumbers(numbers: { number }): string
	local names: { string } = {}
	for _, number in numbers do
		table.insert(names, tostring(number))
	end
	if #names <= 1 then
		return names[1] or ""
	end
	return `{table.concat(names, ", ", 1, #names - 1)} and {names[#names]}`
end

-- What a shot does, for players
function Cue.describeShot(shot: CueShot): string
	local strength = `{math.round(shot.power * 100)}%`
	local outcome = shot.outcome
	if outcome == "win" then
		return `Wins the game at {strength}`
	elseif outcome == "solve" then
		return `Solves the trickshot at {strength}`
	elseif outcome == "loss" then
		return `Loses the game at {strength}`
	elseif outcome == "foul" then
		if table.find(shot.fouls, "Scratch") then
			return `The cue ball goes in (a foul) at {strength}`
		end
		return `No legal shot - fouls at {strength}`
	elseif outcome == "safe" or shot.missed then
		return `Nothing goes in - plays safe at {strength}`
	end
	local styles: { [string]: string } = {
		combo = "Combo: ",
		bank = "Bank: ",
		kick = "Kick: ",
		trick = "Trick shot: ",
	}
	local prefix = styles[shot.style] or ""
	if outcome == "partial" then
		-- the trickshot mode: its targets have the game's ids (100 and up), not ball numbers
		local count = #shot.yours
		local what = if count == 1 then "1 target" else `{count} targets`
		return `{prefix}{if prefix == "" then "Pots" else "pots"} {what} at {strength}`
	end
	return `{prefix}{if prefix == "" then "Pots" else "pots"} {Cue.joinNumbers(shot.yours)} at {strength}`
end

-- A search as console / file lines (Test tools)
function Cue.describeJob(job: CueJob?): { string }
	local lines: { string } = {}
	if job == nil then
		table.insert(lines, "no plan yet")
		return lines
	end
	local owner = job.owner
	table.insert(
		lines,
		`goal: {job.goal.kind}, rules known: {owner.known}, your group: {owner.group or "none"},`
			.. ` on the 8: {owner.onEight}, phase: {owner.phase or "?"}, ball in hand: {job.place},`
			.. ` missed on purpose: {job.missed}`
	)
	if job.placeAt ~= nil then
		table.insert(
			lines,
			string.format("cue ball placed at (%.2f, %.2f)", job.placeAt.X, job.placeAt.Y)
		)
	end
	table.insert(
		lines,
		string.format(
			"%d lines, %d tries, %.0f ms playing shots, %.1f s searching, last stage %s, %s",
			job.lines,
			job.tries,
			job.ms,
			os.clock() - job.started,
			job.stage,
			job.problem or "ok"
		)
	)
	for index = 1, math.min(#job.shots, 10) do
		local shot = job.shots[index]
		table.insert(
			lines,
			string.format(
				"%d. %s | %s | line %s | spin (%.1f, %.1f) | score %.1f | window %.2f deg%s%s",
				index,
				Cue.describeShot(shot),
				shot.outcome,
				shot.line,
				shot.spin.X,
				shot.spin.Y,
				shot.score,
				shot.robust,
				if shot.full then "" else " | quick",
				if shot.missed then " | a miss on purpose" else ""
			)
		)
	end
	return lines
end

-- ============ The table ============

-- The trickshot mode's puzzle on this table, when there is one being played. Looked up on every
-- call (only a start makes it): the game reuses one table for every editor and an old editor
-- keeps its puzzle, so the one being played is the editor in "Play" whose targets are all on
-- the table, not in a pocket. Nothing is kept between shots.
function Cue._trickGoal(self: Cue, controller: any): CueGoal?
	local gameUi = Game.ui(self._refs)
	if gameUi == nil or gameUi:GetAttribute("MatchMode") ~= "Trickshot" then
		return nil
	end
	local sim = controller.Simulation
	if type(sim) ~= "table" or type(sim.Balls) ~= "table" then
		return nil
	end
	for _, editor in Game.liveTables(CueConfig.TRICK_KEYS) do
		if type(editor) ~= "table" or editor.Mode ~= "Play" then
			continue
		end
		local scene = editor.Scene
		if type(scene) ~= "table" or type(scene.Balls) ~= "table" then
			continue
		end
		local targets: { { number: number, pocket: string? } } = {}
		local onTable = true
		for _, entry in scene.Balls do
			if type(entry) == "table" and entry.T and type(entry.I) == "number" then
				local ball = sim.Balls[entry.I]
				if type(ball) ~= "table" or ball.Pocketed then
					onTable = false
					break
				end
				table.insert(targets, {
					number = entry.I,
					pocket = if type(entry.P) == "string" then entry.P else nil,
				})
			end
		end
		if onTable and #targets > 0 then
			return { kind = "trick", targets = targets }
		end
	end
	return nil
end

-- The four cushions, as the lines a ball's centre bounces on
function Cue._rails(self: Cue): { CueRail }
	local constants = self._refs.constants
	local radius: number = constants.BallRadius
	local halfWidth = constants.PlayWidth / 2 - radius
	local halfHeight = constants.PlayHeight / 2 - radius
	return {
		{
			name = "foot",
			vertical = true,
			at = halfWidth,
			normal = Vector2.new(-1, 0),
			low = -halfHeight,
			high = halfHeight,
		},
		{
			name = "head",
			vertical = true,
			at = -halfWidth,
			normal = Vector2.new(1, 0),
			low = -halfHeight,
			high = halfHeight,
		},
		{
			name = "top",
			vertical = false,
			at = halfHeight,
			normal = Vector2.new(0, -1),
			low = -halfWidth,
			high = halfWidth,
		},
		{
			name = "bottom",
			vertical = false,
			at = -halfHeight,
			normal = Vector2.new(0, 1),
			low = -halfWidth,
			high = halfWidth,
		},
	}
end

-- Where on `rail` a ball rolling from `from` must bounce to leave toward `to`, with the game's
-- cushion response (PoolPhysics resolveNormalBounce: along the cushion times 1 - CushionFriction,
-- off it times CushionRestitution). nil when there is no such point away from the pockets
function Cue._bounce(
	self: Cue,
	from: Vector2,
	to: Vector2,
	rail: CueRail,
	pockets: { any }
): Vector2?
	local constants = self._refs.constants
	local physics: any = constants.Physics
	local friction: number = if type(physics) == "table"
			and type(physics.CushionFriction) == "number"
		then physics.CushionFriction
		else 0.2
	local restitution: number = if type(physics) == "table"
			and type(physics.CushionRestitution) == "number"
		then physics.CushionRestitution
		else 0.72
	local normal = rail.normal
	local function pointAt(s: number): Vector2
		return if rail.vertical then Vector2.new(rail.at, s) else Vector2.new(s, rail.at)
	end
	local origin = pointAt(0)
	if (from - origin):Dot(normal) <= 0 or (to - origin):Dot(normal) <= 0 then
		return nil -- not both on the table side of this cushion
	end
	local function miss(s: number): (number, boolean)
		local bounce = pointAt(s)
		local incoming = bounce - from
		if incoming.Magnitude < 1e-6 then
			return 0, false
		end
		local unit = incoming.Unit
		local into = unit:Dot(normal)
		if into >= 0 then
			return 0, false
		end
		local along = unit - normal * into
		local out = along * (1 - friction) - normal * (into * restitution)
		local toward = to - bounce
		return out.X * toward.Y - out.Y * toward.X, out:Dot(toward) > 0
	end
	local diameter = constants.BallRadius * 2
	local samples = CueConfig.BOUNCE_SAMPLES
	local lastS = rail.low
	local lastValue, lastOk = miss(lastS)
	for index = 1, samples do
		local s = rail.low + (rail.high - rail.low) * index / samples
		local value, ok = miss(s)
		if ok and lastOk and ((value <= 0 and lastValue > 0) or (value >= 0 and lastValue < 0)) then
			local low = lastS
			local high = s
			local lowValue = lastValue
			for _ = 1, 24 do
				local middle = (low + high) / 2
				local middleValue = miss(middle)
				if (middleValue <= 0) == (lowValue <= 0) then
					low = middle
					lowValue = middleValue
				else
					high = middle
				end
			end
			local bounce = pointAt((low + high) / 2)
			local nearJaw = false
			for _, pocket in pockets do
				if
					(bounce - pocket.MouthCentre).Magnitude
					< pocket.Mouth / 2 + diameter * CueConfig.JAW_MARGIN
				then
					nearJaw = true
					break
				end
			end
			if not nearJaw then
				return bounce
			end
		end
		lastS = s
		lastValue = value
		lastOk = ok
	end
	return nil
end

-- Whether a ball sits on the straight path from `from` to `to` (PoolAI pathBlocked)
function Cue._blocked(
	self: Cue,
	sim: any,
	from: Vector2,
	to: Vector2,
	skipA: number?,
	skipB: number?
): boolean
	local limit = self._refs.constants.BallRadius * 2 * CueConfig.BLOCK
	local segment = to - from
	local length = segment.Magnitude
	if length < 1e-4 then
		return false
	end
	local unit = segment / length
	for number, ball in sim.Balls do
		if ball.Pocketed or number == skipA or number == skipB then
			continue
		end
		local offset: Vector2 = ball.Position - from
		local along = offset:Dot(unit)
		if
			along > 0
			and along < length
			and math.abs(offset.X * unit.Y - offset.Y * unit.X) < limit
		then
			return true
		end
	end
	return false
end

-- The balls of the planned table: the ones the cue ball may hit first, the ones worth potting
function Cue._ballsOf(self: Cue, job: CueJob): ({ CueBall }, { CueBall }, { [number]: boolean })
	local refs = self._refs
	local sim = job.planSim
	local cue = Shots.cueNumber(refs)
	local firsts: { CueBall } = {}
	local wanted: { CueBall } = {}
	local wantedSet: { [number]: boolean } = {}
	local targetSet: { [number]: boolean } = {}
	for _, target in job.goal.targets do
		targetSet[target.number] = true
	end
	for _, listed in sim.Order do
		local number = tonumber(listed)
		local ball = if number ~= nil then sim.Balls[number] else nil
		if
			number == nil
			or ball == nil
			or ball.Pocketed
			or number == cue
			or ball.Static == true
		then
			continue
		end
		local entry: CueBall = { number = number, position = ball.Position }
		if job.goal.kind == "trick" then
			table.insert(firsts, entry)
			if targetSet[number] then
				table.insert(wanted, entry)
				wantedSet[number] = true
			end
		else
			if Shots.isLegalFirst(self._hooks, job.sim, number) ~= false then
				table.insert(firsts, entry)
			end
			if Shots.verdictOf(refs, job.owner, number, false) ~= "not" then
				table.insert(wanted, entry)
				wantedSet[number] = true
			end
		end
	end
	return firsts, wanted, wantedSet
end

-- The pockets a target may go into (the trickshot mode can ask for one)
function Cue._pocketsFor(self: Cue, job: CueJob, number: number, pockets: { any }): { any }
	if job.goal.kind ~= "trick" then
		return pockets
	end
	for _, target in job.goal.targets do
		if target.number == number and target.pocket ~= nil then
			local only: { any } = {}
			for _, pocket in pockets do
				if tostring(pocket.Id) == target.pocket then
					table.insert(only, pocket)
				end
			end
			return only
		end
	end
	return pockets
end

-- The lines worth trying, most promising kinds first (straight, plain hits, the best
-- COMBOS_FIRST combos, banks, kicks, then the other combos); `quick`: straight lines, plain hits
-- and combos only (choosing where to put the ball in hand)
function Cue._candidates(self: Cue, job: CueJob, quick: boolean): { CueCandidate }
	local refs = self._refs
	local sim = job.planSim
	local cue = Shots.cueNumber(refs)
	local diameter: number = refs.constants.BallRadius * 2
	local cuePosition: Vector2 = sim.Balls[cue].Position
	local pockets: { any } = refs.geometry.GetPockets()
	local firsts, wanted, wantedSet = Cue._ballsOf(self, job)

	local list: { CueCandidate } = {}
	local same = math.cos(math.rad(CueConfig.SAME_DEGREES))
	local function add(direction: Vector2, line: string, style: string, probe: boolean): ()
		for _, other in list do
			if other.direction:Dot(direction) > same then
				return
			end
		end
		table.insert(list, { direction = direction, line = line, style = style, probe = probe })
	end

	-- straight: a ball you may hit first and want in, into a pocket
	for _, ball in firsts do
		if not wantedSet[ball.number] then
			continue
		end
		for _, pocket in Cue._pocketsFor(self, job, ball.number, pockets) do
			local toPocket: Vector2 = pocket.MouthCentre - ball.position
			if toPocket.Magnitude < 1e-4 then
				continue
			end
			local ghost = ball.position - toPocket.Unit * diameter
			local aim = ghost - cuePosition
			if
				aim.Magnitude > diameter * 0.5
				and aim.Unit:Dot(toPocket.Unit) > CueConfig.MIN_CUT
				and not Cue._blocked(self, sim, cuePosition, ghost, cue, ball.number)
				and not Cue._blocked(self, sim, ball.position, pocket.MouthCentre, ball.number, nil)
			then
				add(aim.Unit, `{ball.number}>{pocket.Id}`, "straight", false)
			end
		end
	end

	-- plain hits: the middle of every ball you may hit first (safeties, a legal hit)
	local directHit = false
	for _, ball in firsts do
		if not Cue._blocked(self, sim, cuePosition, ball.position, cue, ball.number) then
			directHit = true
			local aim = ball.position - cuePosition
			if aim.Magnitude > 1e-4 then
				add(aim.Unit, `hit {ball.number}`, "safety", false)
			end
		end
	end

	-- combos: a ball you may hit first into one you want into a pocket
	type Combo = { direction: Vector2, line: string, quality: number }
	local combos: { Combo } = {}
	for _, first in firsts do
		for _, second in wanted do
			if second.number == first.number then
				continue
			end
			for _, pocket in Cue._pocketsFor(self, job, second.number, pockets) do
				local toPocket: Vector2 = pocket.MouthCentre - second.position
				if toPocket.Magnitude < 1e-4 then
					continue
				end
				local ghostSecond = second.position - toPocket.Unit * diameter
				local firstToSecond = ghostSecond - first.position
				if firstToSecond.Magnitude <= diameter * 0.5 then
					continue
				end
				local secondCut = firstToSecond.Unit:Dot(toPocket.Unit)
				if secondCut <= CueConfig.COMBO_CUT then
					continue
				end
				local ghostFirst = first.position - firstToSecond.Unit * diameter
				local aim = ghostFirst - cuePosition
				if aim.Magnitude <= diameter * 0.5 then
					continue
				end
				local firstCut = aim.Unit:Dot(firstToSecond.Unit)
				if
					firstCut > CueConfig.COMBO_CUT
					and not Cue._blocked(self, sim, cuePosition, ghostFirst, cue, first.number)
					and not Cue._blocked(
						self,
						sim,
						first.position,
						ghostSecond,
						first.number,
						second.number
					)
					and not Cue._blocked(
						self,
						sim,
						second.position,
						pocket.MouthCentre,
						second.number,
						nil
					)
				then
					table.insert(combos, {
						direction = aim.Unit,
						line = `{first.number}>{second.number}>{pocket.Id}`,
						quality = firstCut * secondCut,
					})
				end
			end
		end
	end
	table.sort(combos, function(a: Combo, b: Combo): boolean
		return a.quality > b.quality
	end)
	local comboCount = math.min(#combos, CueConfig.MAX_COMBOS)
	local firstCombos = if quick then comboCount else math.min(comboCount, CueConfig.COMBOS_FIRST)
	for index = 1, firstCombos do
		add(combos[index].direction, combos[index].line, "combo", false)
	end
	if quick then
		return list
	end

	local rails = Cue._rails(self)
	-- banks: a ball you may hit first and want in, off a cushion into a pocket
	for _, ball in firsts do
		if not wantedSet[ball.number] then
			continue
		end
		for _, pocket in Cue._pocketsFor(self, job, ball.number, pockets) do
			for _, rail in rails do
				local bounce = Cue._bounce(self, ball.position, pocket.MouthCentre, rail, pockets)
				if bounce == nil then
					continue
				end
				local outgoing = (bounce - ball.position).Unit
				local ghost = ball.position - outgoing * diameter
				local aim = ghost - cuePosition
				if
					aim.Magnitude > diameter * 0.5
					and aim.Unit:Dot(outgoing) > CueConfig.BANK_CUT
					and not Cue._blocked(self, sim, cuePosition, ghost, cue, ball.number)
					and not Cue._blocked(self, sim, ball.position, bounce, ball.number, nil)
					and not Cue._blocked(self, sim, bounce, pocket.MouthCentre, ball.number, nil)
				then
					add(aim.Unit, `bank {ball.number}>{pocket.Id}>{rail.name}`, "bank", true)
				end
			end
		end
	end

	-- kicks: the cue ball off a cushion into a pot (and, when no ball can be hit straight, off a
	-- cushion into the middle of a ball you may hit: escaping a snooker)
	for _, ball in firsts do
		local targets: { { point: Vector2, toPocket: Vector2?, pocketId: string? } } = {}
		if wantedSet[ball.number] then
			for _, pocket in Cue._pocketsFor(self, job, ball.number, pockets) do
				local toPocket: Vector2 = pocket.MouthCentre - ball.position
				if
					toPocket.Magnitude > 1e-4
					and not Cue._blocked(
						self,
						sim,
						ball.position,
						pocket.MouthCentre,
						ball.number,
						nil
					)
				then
					table.insert(targets, {
						point = ball.position - toPocket.Unit * diameter,
						toPocket = toPocket.Unit,
						pocketId = tostring(pocket.Id),
					})
				end
			end
		end
		if not directHit then
			table.insert(targets, { point = ball.position, toPocket = nil, pocketId = nil })
		end
		for _, target in targets do
			for _, rail in rails do
				local bounce = Cue._bounce(self, cuePosition, target.point, rail, pockets)
				if bounce == nil then
					continue
				end
				local arriving = (target.point - bounce).Unit
				local toPocket = target.toPocket
				if toPocket ~= nil and arriving:Dot(toPocket) <= CueConfig.BANK_CUT then
					continue
				end
				if
					not Cue._blocked(self, sim, cuePosition, bounce, cue, nil)
					and not Cue._blocked(self, sim, bounce, target.point, cue, ball.number)
				then
					local line = if target.pocketId ~= nil
						then `kick {ball.number}>{target.pocketId}>{rail.name}`
						else `kick hit {ball.number}>{rail.name}`
					add(
						(bounce - cuePosition).Unit,
						line,
						if target.pocketId ~= nil then "kick" else "safety",
						true
					)
				end
			end
		end
	end

	-- the other combos, after the banks and kicks
	for index = firstCombos + 1, comboCount do
		add(combos[index].direction, combos[index].line, "combo", false)
	end
	return list
end

-- ============ Judging a shot ============

-- Open straight pots from `from` on the played table for the balls in `numbers`
function Cue._openShots(
	self: Cue,
	after: any,
	from: Vector2,
	numbers: { [number]: boolean }
): number
	local refs = self._refs
	local cue = Shots.cueNumber(refs)
	local diameter: number = refs.constants.BallRadius * 2
	local pockets: { any } = refs.geometry.GetPockets()
	local open = 0
	for number in numbers do
		local ball = after.Balls[number]
		if ball == nil or ball.Pocketed then
			continue
		end
		local position: Vector2 = ball.Position
		for _, pocket in pockets do
			local toPocket: Vector2 = pocket.MouthCentre - position
			if toPocket.Magnitude < 1e-4 then
				continue
			end
			local ghost = position - toPocket.Unit * diameter
			local aim = ghost - from
			if
				aim.Magnitude > diameter * 0.5
				and aim.Unit:Dot(toPocket.Unit) > CueConfig.CLEAR_CUT
				and not Cue._blocked(self, after, from, ghost, cue, number)
				and not Cue._blocked(self, after, position, pocket.MouthCentre, number, nil)
			then
				open += 1
				break
			end
		end
	end
	return open
end

-- The balls of a group still on the played table (and the 8 once the group is cleared)
function Cue._groupBalls(self: Cue, after: any, group: string?): { [number]: boolean }
	local refs = self._refs
	local cue = Shots.cueNumber(refs)
	local eight = Shots.eightNumber(refs)
	local set: { [number]: boolean } = {}
	local any = false
	for number, ball in after.Balls do
		local n = tonumber(number)
		if n == nil or n == cue or n == eight or ball.Pocketed then
			continue
		end
		local ballGroup = if n < eight then "Solid" else "Stripe"
		if group == nil or ballGroup == group then
			set[n] = true
			any = true
		end
	end
	if not any then
		set[eight] = true
	end
	return set
end

-- Scores a played shot. Full plays also look at what it leaves: the next shot (when you play
-- again) or the opponent's (a safety)
function Cue._score(
	self: Cue,
	job: CueJob,
	result: ShotsResult,
	direction: Vector2,
	power: number,
	spin: Vector2,
	line: string,
	style: string,
	full: boolean
): CueShot
	local refs = self._refs
	local cue = Shots.cueNumber(refs)
	local eight = Shots.eightNumber(refs)
	local cueIn = table.find(result.potted, cue) ~= nil
	local outcome: CueOutcome = "safe"
	local score = 0
	local yours: { number } = {}
	local theirs = 0
	local fouls: { string } = {}

	if job.goal.kind == "trick" then
		local solved = 0
		for _, target in job.goal.targets do
			local pocket = result.pockets[target.number]
			if pocket ~= nil and (target.pocket == nil or pocket == target.pocket) then
				solved += 1
				table.insert(yours, target.number)
			end
		end
		-- the game checks the solve before anything else (PoolTrickshotEditor OnSettled)
		if solved == #job.goal.targets then
			outcome = "solve"
			score = CueConfig.WIN
		elseif cueIn then
			outcome = "foul"
			score = CueConfig.FOUL
			table.insert(fouls, "Scratch")
		elseif solved > 0 then
			outcome = "partial"
			score = solved * CueConfig.POT
		end
	else
		local verdict = Shots.judge(refs, job.rules, job.planSim, result)
		local group = if verdict ~= nil then verdict.group else job.owner.group
		for _, number in result.potted do
			if number == cue or number == eight then
				continue
			end
			local ballGroup = if number < eight then "Solid" else "Stripe"
			if group == nil or ballGroup == group then
				table.insert(yours, number)
			else
				theirs += 1
			end
		end
		if verdict == nil then
			-- the referee did not answer: judged by the balls (never "safe" by default)
			warnOnce(
				"cue.referee",
				"the game's referee did not answer: shots are judged by the balls alone"
			)
			outcome, score, fouls = Cue._byBalls(self, job, result, cueIn, #yours, theirs)
			if outcome == "win" then
				yours = { eight }
			end
		elseif verdict.winner ~= nil then
			outcome = if verdict.winner == verdict.shooter then "win" else "loss"
			score = if outcome == "win" then CueConfig.WIN else CueConfig.LOSS
			if outcome == "win" then
				yours = { eight }
			end
		elseif verdict.rerack then
			outcome = "loss"
			score = CueConfig.RERACK
		elseif not verdict.legal then
			outcome = "foul"
			score = CueConfig.FOUL
			fouls = verdict.fouls
		elseif verdict.continues then
			outcome = "pot"
			score = #yours * CueConfig.POT + theirs * CueConfig.OPPONENT_POT
			if full and result.cueRest ~= nil and refs.geometry ~= nil then
				local open = Cue._openShots(
					self,
					result.after,
					result.cueRest,
					Cue._groupBalls(self, result.after, group)
				)
				score += CueConfig.NEXT * math.min(open, 3) / 3
			end
		else
			outcome = "safe"
			score = theirs * CueConfig.OPPONENT_POT
			if full and result.cueRest ~= nil and refs.geometry ~= nil then
				local opponentGroup = if group == "Solid"
					then "Stripe"
					elseif group == "Stripe" then "Solid"
					else nil
				local open = Cue._openShots(
					self,
					result.after,
					result.cueRest,
					Cue._groupBalls(self, result.after, opponentGroup)
				)
				score += CueConfig.SAFETY * (1 - math.min(open, 3) / 3)
			end
		end
	end
	table.sort(yours)
	score += CueConfig.POWER * power + (CueConfig.STYLE[style] or 0)
	return {
		direction = direction,
		power = power,
		spin = spin,
		score = score,
		outcome = outcome,
		yours = yours,
		theirs = theirs,
		fouls = fouls,
		style = style,
		line = line,
		robust = 0,
		full = full,
		missed = false,
	}
end

-- A shot judged by its balls alone, when the referee does not answer: the 8 (a win once your
-- group is cleared, else a loss), the cue ball in, no first hit, a wrong first hit and no rail
-- after the contact with nothing in (fouls), else a pot or a safe shot
function Cue._byBalls(
	self: Cue,
	job: CueJob,
	result: ShotsResult,
	cueIn: boolean,
	yours: number,
	theirs: number
): (CueOutcome, number, { string })
	local refs = self._refs
	local eight = Shots.eightNumber(refs)
	local legalFirst = Shots.isLegalFirst(self._hooks, job.planSim, result.firstHit)
	if table.find(result.potted, eight) ~= nil then
		if job.owner.onEight and not cueIn and legalFirst ~= false then
			return "win", CueConfig.WIN, {}
		end
		return "loss", CueConfig.LOSS, {}
	end
	if cueIn then
		return "foul", CueConfig.FOUL, { "Scratch" }
	end
	if result.firstHit == nil then
		return "foul", CueConfig.FOUL, { "NoContact" }
	end
	if legalFirst == false then
		return "foul", CueConfig.FOUL, { "WrongBallFirst" }
	end
	if #result.potted == 0 and result.railsAfterContact == 0 then
		return "foul", CueConfig.FOUL, { "NoRailAfterContact" }
	end
	if yours > 0 then
		return "pot", yours * CueConfig.POT + theirs * CueConfig.OPPONENT_POT, {}
	end
	return "safe", theirs * CueConfig.OPPONENT_POT, {}
end

-- Plays one line at one power and spin on the planned table and scores it (inside a search, the
-- play yields the frame and stops with it: job.pace)
function Cue._try(
	self: Cue,
	job: CueJob,
	direction: Vector2,
	power: number,
	spin: Vector2,
	line: string,
	style: string,
	full: boolean
): CueShot?
	local refs = self._refs
	local clampedPower, clampedSpin = Shots.clamp(refs, power, spin)
	local result = Shots.play(
		self._hooks,
		refs,
		job.planSim,
		direction,
		clampedPower,
		clampedSpin,
		false,
		not full,
		job.pace
	)
	job.tries += 1
	if result == nil then
		return nil
	end
	job.ms += result.ms
	return Cue._score(self, job, result, direction, clampedPower, clampedSpin, line, style, full)
end

-- Whether `other` does at least what `shot` does (the same or a better outcome, as many balls)
function Cue.stillWorks(shot: CueShot, other: CueShot?): boolean
	if other == nil then
		return false
	end
	local rank = CueConfig.RANK[shot.outcome] or 0
	local otherRank = CueConfig.RANK[other.outcome] or 0
	return otherRank > rank or (otherRank == rank and #other.yours >= #shot.yours)
end

-- How a shot ranks against the others: its score, lower when it was not replayed in full
function Cue.rankOf(shot: CueShot): number
	return shot.score + (if shot.full then 0 else CueConfig.UNCHECKED)
end

-- Best first
function Cue.sortShots(shots: { CueShot }): ()
	table.sort(shots, function(a: CueShot, b: CueShot): boolean
		return Cue.rankOf(a) > Cue.rankOf(b)
	end)
end

-- The best shot per line as a list, best first
function Cue.listShots(best: { [string]: CueShot }): { CueShot }
	local shots: { CueShot } = {}
	for _, shot in best do
		table.insert(shots, shot)
	end
	Cue.sortShots(shots)
	return shots
end

-- ============ The search ============

-- A copy of `sim` with the cue ball at `spot`
function Cue._movedCue(self: Cue, sim: any, spot: Vector2): any
	local cue = Shots.cueNumber(self._refs)
	local copy: any = table.clone(sim) -- the game's untyped table, copied
	local balls: { [any]: any } = {}
	for number, ball in sim.Balls do
		balls[number] = table.clone(ball)
	end
	local cueBall = balls[cue]
	if cueBall ~= nil then
		cueBall.Position = spot
		cueBall.Pocketed = false
		cueBall.Velocity = Vector2.zero
	end
	copy.Balls = balls
	copy.Order = table.clone(sim.Order)
	copy.Events = {}
	return copy
end

-- Where the cue ball may go near `spot`: the game's own placement (PoolInputController
-- resolvePlacement: the rules' clamp, pushed out of other balls, six rounds)
function Cue._placement(self: Cue, controller: any, sim: any, spot: Vector2): Vector2
	local refs = self._refs
	local cue = Shots.cueNumber(refs)
	local diameter: number = refs.constants.BallRadius * 2
	local function clamp(point: Vector2): Vector2
		local clampPlacement = controller.ClampPlacement
		local ok: boolean
		local result: any
		if type(clampPlacement) == "function" then
			ok, result = try(clampPlacement, point)
		else
			ok, result = try(refs.geometry.ClampToPlayArea, point)
		end
		return if ok and typeof(result) == "Vector2" then result else point
	end
	-- the balls in the game's order (PoolPhysics.GetActiveBalls), as resolvePlacement walks them
	local active: { any } = {}
	local getActive: any = refs.physics.GetActiveBalls
	local listed: boolean = false
	local list: any = nil -- the game's list of ball tables
	if type(getActive) == "function" then
		listed, list = try(getActive, sim)
	end
	if listed and type(list) == "table" then
		active = list
	else
		for _, number in sim.Order do
			local ball = sim.Balls[number]
			if type(ball) == "table" and not ball.Pocketed then
				table.insert(active, ball)
			end
		end
	end
	local cueBall = sim.Balls[cue]
	local position = clamp(spot)
	for _ = 1, 6 do
		local moved = false
		for _, ball in active do
			if ball == cueBall or ball.Number == cue or ball.Pocketed then
				continue
			end
			local away: Vector2 = position - ball.Position
			local distance = away.Magnitude
			if distance < diameter then
				local unit = if distance > 0.001 then away.Unit else Vector2.new(1, 0)
				position += unit * (diameter - distance + 0.01)
				moved = true
			end
		end
		position = clamp(position)
		if not moved then
			break
		end
	end
	return position
end

-- Ball in hand: the game's own straight-in spots (PoolAI.PlaceCueBallOptions), where the rules
-- let the ball go; the last one is where it is now (placed properly)
function Cue._placeSpots(self: Cue, job: CueJob): { Vector2 }
	local refs = self._refs
	local spots: { Vector2 } = {}
	if job.rules ~= nil and refs.ai ~= nil then
		local ok, found =
			try(refs.ai.PlaceCueBallOptions, nil, job.sim, job.rules, CueConfig.PLACE_SPOTS)
		if ok and type(found) == "table" then
			for _, spot in found do
				if typeof(spot) == "Vector2" then
					local placed = Cue._placement(self, job.controller, job.sim, spot)
					if (placed - spot).Magnitude < 0.1 then
						table.insert(spots, placed)
					end
				end
			end
		end
	end
	local cueBall = job.sim.Balls[Shots.cueNumber(refs)]
	if cueBall ~= nil then
		table.insert(spots, Cue._placement(self, job.controller, job.sim, cueBall.Position))
	end
	return spots
end

-- Tries the candidates from index `first` on (at every power; banks, kicks and the open search's
-- lines first probed a little either side), keeping the best shot per line in `best`, until
-- `untilTime`. Returns the index of the first candidate it did not finish (past the end: all
-- done), or nil when the search was stopped
function Cue._search(
	self: Cue,
	job: CueJob,
	candidates: { CueCandidate },
	first: number,
	powers: { number },
	alive: () -> boolean,
	untilTime: number,
	best: { [string]: CueShot }
): number?
	local function keep(shot: CueShot?): ()
		if shot ~= nil then
			local current = best[shot.line]
			if current == nil or Cue.rankOf(shot) > Cue.rankOf(current) then
				best[shot.line] = shot
			end
		end
	end
	local zero = job.spin
	for index = first, #candidates do
		if os.clock() > untilTime then
			return index
		end
		local candidate = candidates[index]
		local direction = candidate.direction
		if candidate.probe then
			local probeBest: CueShot? = nil
			for _, degrees in CueConfig.PROBE_DEGREES do
				local shot = Cue._try(
					self,
					job,
					Cue.rotate(candidate.direction, degrees),
					CueConfig.PROBE_POWER,
					zero,
					candidate.line,
					candidate.style,
					false
				)
				keep(shot)
				if shot ~= nil and (probeBest == nil or shot.score > probeBest.score) then
					probeBest = shot
				end
				if not alive() then
					return nil
				end
				if os.clock() > untilTime then
					return index
				end
			end
			-- a pot line must pot near its solved direction; an escape must at least be legal
			local needed = if candidate.style == "safety"
				then CueConfig.RANK.safe
				else CueConfig.RANK.partial
			if probeBest == nil or (CueConfig.RANK[probeBest.outcome] or 0) < needed then
				continue
			end
			direction = probeBest.direction
		end
		for _, power in powers do
			if candidate.probe and power == CueConfig.PROBE_POWER then
				continue
			end
			keep(
				Cue._try(self, job, direction, power, zero, candidate.line, candidate.style, false)
			)
			if not alive() then
				return nil
			end
			if os.clock() > untilTime then
				return index
			end
		end
	end
	return #candidates + 1
end

-- The open search: one line per degree all round, at the probe power, until `untilTime`. Every
-- legal shot it plays goes into `best` (an escape when nothing else is legal); the lines that pot
-- come back to be searched like any other line. nil when the search was stopped
function Cue._openSearch(
	self: Cue,
	job: CueJob,
	alive: () -> boolean,
	untilTime: number,
	best: { [string]: CueShot }
): { CueCandidate }?
	local found: { CueCandidate } = {}
	local steps = math.floor(360 / CueConfig.OPEN_DEGREES)
	for index = 0, steps - 1 do
		if os.clock() > untilTime then
			break
		end
		local angle = math.rad(index * CueConfig.OPEN_DEGREES)
		local direction = Vector2.new(math.cos(angle), math.sin(angle))
		local shot = Cue._try(
			self,
			job,
			direction,
			CueConfig.PROBE_POWER,
			job.spin,
			`open {index}`,
			"trick",
			false
		)
		if shot ~= nil then
			local rank = CueConfig.RANK[shot.outcome] or 0
			if rank >= CueConfig.RANK.partial then
				table.insert(
					found,
					{ direction = direction, line = `trick {index}`, style = "trick", probe = true }
				)
			end
			if rank >= CueConfig.RANK.safe then
				if rank == CueConfig.RANK.safe then
					-- a legal shot that pots nothing: a safety, not a trick shot
					shot.score += (CueConfig.STYLE.safety or 0) - (CueConfig.STYLE.trick or 0)
					shot.style = "safety"
				end
				best[shot.line] = shot
			end
		end
		if not alive() then
			return nil
		end
	end
	return found
end

-- The best few, tried a little either side at their power until `untilTime`: aimed at the middle
-- of the widest window that still works, which scores higher the wider it is. A shot whose window
-- was not finished in time stays as it was. false when the search was stopped
function Cue._refine(
	self: Cue,
	job: CueJob,
	shots: { CueShot },
	alive: () -> boolean,
	untilTime: number
): boolean
	local done = 0
	for _, shot in shots do
		if done >= CueConfig.REFINE or os.clock() > untilTime then
			break
		end
		if (CueConfig.RANK[shot.outcome] or 0) < CueConfig.RANK.partial then
			continue
		end
		done += 1
		local works: { boolean } = {}
		local offsets: { number } = {}
		local count = math.floor(CueConfig.REFINE_SPAN / CueConfig.REFINE_STEP + 0.5)
		for index = -count, count do
			local degrees = index * CueConfig.REFINE_STEP
			table.insert(offsets, degrees)
			if index == 0 then
				table.insert(works, true)
			else
				local tried = Cue._try(
					self,
					job,
					Cue.rotate(shot.direction, degrees),
					shot.power,
					shot.spin,
					shot.line,
					shot.style,
					false
				)
				table.insert(works, Cue.stillWorks(shot, tried))
				if not alive() then
					return false
				end
				if os.clock() > untilTime then
					return true
				end
			end
		end
		-- the run of working offsets around the middle (index count + 1 is the shot itself)
		local centre = count + 1
		local low = centre
		local high = centre
		while low > 1 and works[low - 1] do
			low -= 1
		end
		while high < #works and works[high + 1] do
			high += 1
		end
		local middle = (offsets[low] + offsets[high]) / 2
		shot.direction = Cue.rotate(shot.direction, middle)
		shot.robust = offsets[high] - offsets[low]
		shot.score += CueConfig.ROBUST * math.min(shot.robust, CueConfig.REFINE_SPAN) / CueConfig.REFINE_SPAN
	end
	return true
end

-- The best few replayed in full (exact), each with its own spin and then the other spins, scored
-- on what they leave. The top shot is always replayed (at its own spin); the rest only until
-- `untilTime`. false when the search was stopped
function Cue._finalise(
	self: Cue,
	job: CueJob,
	shots: { CueShot },
	alive: () -> boolean,
	untilTime: number
): boolean
	local final: { CueShot } = {}
	local count = 0
	for _, shot in shots do
		if count >= CueConfig.FINAL or (count > 0 and os.clock() > untilTime) then
			break
		end
		count += 1
		local spins: { Vector2 } = { shot.spin }
		if job.planSim.IsBreakShot ~= true then
			for _, spin in CueConfig.SPINS do
				if (spin - shot.spin).Magnitude > 1e-3 then
					table.insert(spins, spin)
				end
			end
		end
		local best: CueShot? = nil
		for spinIndex, spin in spins do
			if spinIndex > 1 and os.clock() > untilTime then
				break
			end
			local tried =
				Cue._try(self, job, shot.direction, shot.power, spin, shot.line, shot.style, true)
			if tried ~= nil then
				tried.robust = shot.robust
				tried.score += CueConfig.ROBUST * math.min(shot.robust, CueConfig.REFINE_SPAN) / CueConfig.REFINE_SPAN
				if best == nil or tried.score > best.score then
					best = tried
				end
			end
			if not alive() then
				return false
			end
		end
		if best ~= nil then
			table.insert(final, best)
		end
	end
	-- the replayed ones replace their quick versions
	for index = math.min(count, #shots), 1, -1 do
		table.remove(shots, index)
	end
	for _, shot in final do
		table.insert(shots, shot)
	end
	Cue.sortShots(shots)
	return true
end

-- Whether the opponent's group is cleared (they are on the 8)
function Cue._opponentOnEight(self: Cue, job: CueJob): boolean
	local group = job.owner.group
	if group == nil or self._refs.rules == nil then
		return false
	end
	local other = if group == "Solid" then "Stripe" else "Solid"
	local ok, remaining = try(self._refs.rules.CountRemaining, job.sim, other)
	return ok and remaining == 0
end

-- Now and then (job.missChance) a safe miss goes first: the best line a little off, kept only
-- when the referee calls it legal and nothing goes in (judged in full), tried until `untilTime`
function Cue._addMiss(
	self: Cue,
	job: CueJob,
	shots: { CueShot },
	alive: () -> boolean,
	untilTime: number
): ()
	local best = shots[1]
	if job.missChance <= 0 or best == nil or self._random:NextNumber() >= job.missChance then
		return
	end
	if
		best.outcome ~= "pot"
		or job.goal.kind ~= "match"
		or job.owner.phase == "Break"
		or job.planSim.IsBreakShot == true
		or Cue._opponentOnEight(self, job)
	then
		return
	end
	for _, degrees in CueConfig.MISS_DEGREES do
		if os.clock() > untilTime then
			return
		end
		local variant = Cue._try(
			self,
			job,
			Cue.rotate(best.direction, degrees),
			best.power,
			best.spin,
			best.line,
			best.style,
			true
		)
		if
			variant ~= nil
			and variant.outcome == "safe"
			and #variant.yours == 0
			and variant.theirs == 0
		then
			variant.missed = true
			table.insert(shots, 1, variant)
			job.missed = true
			return
		end
		if not alive() then
			return
		end
	end
end

-- The game's own last resort (the nearest ball you may hit, PoolAI.FallbackShot), played in full
function Cue._fallback(self: Cue, job: CueJob): CueShot?
	if self._refs.ai == nil or job.rules == nil then
		return nil
	end
	local fallback: any = self._refs.ai.FallbackShot -- returns the direction and the power
	local ok, direction, power = pcall(fallback, job.planSim, job.rules)
	if ok and typeof(direction) == "Vector2" and type(power) == "number" then
		return Cue._try(self, job, direction, power, job.spin, "fallback", "safety", true)
	end
	return nil
end

-- The whole search (its own thread; a few ms per frame, plays included; inside the thinking
-- time). Fills job.shots, best first, and never leaves it empty while any shot can be played
function Cue._plan(self: Cue, job: CueJob): ()
	local sliceStart = os.clock()
	local function alive(): boolean
		if os.clock() - sliceStart > CueConfig.BUDGET then
			task.wait()
			sliceStart = os.clock()
		end
		job.progress = math.clamp(
			(os.clock() - job.started) / math.max(job.deadline - job.started, 0.1),
			0,
			0.99
		)
		return not (job.cancelled or self._destroyed)
	end
	job.pace = alive
	local think = job.deadline - job.started

	if job.place then
		job.stage = "placing"
		local bestSpot: Vector2? = nil
		local bestScore = -math.huge
		local spots = Cue._placeSpots(self, job)
		local placeUntil = job.started + think * CueConfig.PLACE_SHARE
		for _, spot in spots do
			job.planSim = Cue._movedCue(self, job.sim, spot)
			local spotBest: { [string]: CueShot } = {}
			local reached = Cue._search(
				self,
				job,
				Cue._candidates(self, job, true),
				1,
				CueConfig.PLACE_POWERS,
				alive,
				placeUntil,
				spotBest
			)
			if reached == nil then
				return
			end
			local top = Cue.listShots(spotBest)[1]
			local score = if top ~= nil then Cue.rankOf(top) else -math.huge
			if bestSpot == nil or score > bestScore then
				bestScore = score
				bestSpot = spot
			end
		end
		job.placeAt = bestSpot
		job.planSim = if bestSpot ~= nil then Cue._movedCue(self, job.sim, bestSpot) else job.sim
	end

	-- the stages share the time that is left
	local base = os.clock()
	local left = math.max(job.deadline - base, 0)
	local function at(share: number): number
		return base + left * share
	end
	local searchUntil = at(1 - CueConfig.RESERVE)
	local best: { [string]: CueShot } = {}

	job.stage = "lines"
	local candidates = Cue._candidates(self, job, false)
	job.lines = #candidates
	local nextLine = Cue._search(
		self,
		job,
		candidates,
		1,
		CueConfig.POWERS,
		alive,
		at(CueConfig.FIRST_SHARE),
		best
	)
	if nextLine == nil then
		return
	end
	local top = Cue.listShots(best)[1]
	if top == nil or (CueConfig.RANK[top.outcome] or 0) < CueConfig.RANK.partial then
		-- nothing pots yet: every direction, then what it found, before the other lines
		job.stage = "open search"
		local found = Cue._openSearch(self, job, alive, at(CueConfig.OPEN_SHARE), best)
		if found == nil then
			return
		end
		job.lines += #found
		if #found > 0 then
			job.stage = "open lines"
			if
				Cue._search(self, job, found, 1, CueConfig.POWERS, alive, searchUntil, best) == nil
			then
				return
			end
		end
	end
	if nextLine <= #candidates then
		job.stage = "lines"
		if
			Cue._search(self, job, candidates, nextLine, CueConfig.POWERS, alive, searchUntil, best)
			== nil
		then
			return
		end
	end

	local shots = Cue.listShots(best)
	job.stage = "checking"
	-- no window on the break: its plays are long and the rack spreads anyway
	if job.planSim.IsBreakShot ~= true then
		if not Cue._refine(self, job, shots, alive, at(CueConfig.REFINE_SHARE)) then
			return
		end
		Cue.sortShots(shots)
	end
	if not Cue._finalise(self, job, shots, alive, job.deadline) then
		return
	end
	Cue._addMiss(self, job, shots, alive, job.deadline)

	-- never a losing shot while another exists
	local playable: { CueShot } = {}
	for _, shot in shots do
		if shot.outcome ~= "loss" then
			table.insert(playable, shot)
		end
	end
	-- every shot loses (or there is none): the game's own fallback, played if it does not
	if #playable == 0 then
		local fallback = Cue._fallback(self, job)
		if fallback ~= nil and fallback.outcome ~= "loss" then
			playable = { fallback }
		else
			playable = shots
			if fallback ~= nil then
				table.insert(playable, fallback)
			end
		end
	end
	if job.cancelled or self._destroyed then
		return
	end
	job.shots = playable
	if #playable == 0 then
		job.problem = "no line"
	end
	job.stage = "done"
	job.done = true
end

-- ============ Playing the shot ============

function Cue.isBusy(self: Cue): boolean
	return self._session ~= nil
end

-- Still searching (not yet aiming)
function Cue.isPlanning(self: Cue): boolean
	local session = self._session
	return session ~= nil and session.phase == "planning"
end

-- Whether the ball is in hand for you now: after a scratch (BallInHand) or after any other foul
-- (the game lets you place it: CanPlaceCueBall, with the rules' BallInHand)
function Cue._inHand(self: Cue, controller: any, rules: any?): boolean
	if controller.State == "BallInHand" or controller.BallHeld == true then
		return true
	end
	return controller.CanPlaceCueBall == true
		and type(rules) == "table"
		and rules.BallInHand == true
end

-- Why it cannot play now (for players), or nil with your cue, whose balls are whose and the goal
function Cue.whyNot(self: Cue): (string?, any, ShotsOwner?, CueGoal?)
	local hooks = self._hooks
	local refs = self._refs
	if refs.input == nil or refs.geometry == nil or hooks.original.InputUpdate == nil then
		return "This does not work with this version of the game", nil, nil, nil
	end
	local controller = hooks.live.controller
	if type(controller) ~= "table" then
		return "Wait for your turn", nil, nil, nil
	end
	if controller.Muted or controller.AimLocked or controller.ChargeLocked then
		return "Wait for your turn", nil, nil, nil
	end
	local gameUi = Game.ui(refs)
	if
		controller.ReleasePower ~= nil
		or (gameUi ~= nil and gameUi:GetAttribute("MatchMode") == "Tutorial")
	then
		return "Not during the tutorial", nil, nil, nil
	end
	local sim = controller.Simulation
	local cue = Shots.cueNumber(refs)
	if type(sim) ~= "table" or sim.Balls[cue] == nil or sim.Balls[cue].Pocketed then
		return "Wait for your turn", nil, nil, nil
	end
	local trick = Cue._trickGoal(self, controller)
	local rules = if trick == nil then Shots.rulesOf(hooks, refs, sim) else nil
	if Cue._inHand(self, controller, rules) and controller.State ~= "Aiming" then
		if not self._options.place then
			return "Place the cue ball first", nil, nil, nil
		end
	elseif controller.State ~= "Aiming" then
		return "Wait for your turn", nil, nil, nil
	else
		local shown = false
		if type(controller.Overlay) == "table" then
			local ok, result = try(refs.aim.IsAimShown, controller.Overlay)
			shown = ok and result == true
		end
		if not shown then
			return "Wait for your turn", nil, nil, nil
		end
	end
	local owner = Shots.ownerOf(hooks, refs, sim)
	if trick ~= nil then
		return nil, controller, owner, trick
	end
	if not owner.known or rules == nil then
		return "Aim at a ball once, then try again", nil, nil, nil
	end
	if owner.opponent then
		return "Wait for your turn", nil, nil, nil
	end
	return nil, controller, owner, { kind = "match", targets = {} }
end

-- Starts a shot: searches, then aims and shoots (or, `test`, only searches). Returns why it
-- cannot (for players), or nil
function Cue.start(self: Cue, test: boolean): string?
	if self._destroyed then
		return "This page was replaced - use the new one"
	end
	if self._session ~= nil then
		return "Still working on this shot"
	end
	local live = self._hooks.live
	local owner = self._options.owner
	if live.cueOwner ~= nil and live.cueOwner ~= owner then
		return `{live.cueOwner} is playing this shot`
	end
	local problem, controller, shotOwner, goal = Cue.whyNot(self)
	if problem ~= nil or shotOwner == nil or goal == nil then
		return problem or "Wait for your turn"
	end
	local sim = controller.Simulation
	local rules = if goal.kind == "match" then live.rulesBySim[sim] else nil
	local inHand = goal.kind == "match" and Cue._inHand(self, controller, rules)
	if inHand and not test then
		controller.Dragging = false -- the ball stops following the mouse while it searches
	end
	local hud = controller.Hud
	local spin: any = if type(hud) == "table" then hud.Spin else nil
	local now = os.clock()
	local think = math.clamp(self._options.thinkSeconds(), 1, 30)
	local job: CueJob = {
		controller = controller,
		sim = sim,
		planSim = sim,
		rules = rules,
		goal = goal,
		tableKey = Shots.tableKey(sim),
		owner = shotOwner,
		spin = if typeof(spin) == "Vector2" then spin else Vector2.zero,
		place = inHand and self._options.place,
		placeAt = nil,
		missChance = if test then 0 else math.clamp(self._options.missChance(), 0, 1),
		started = now,
		deadline = now + think,
		shots = {},
		lines = 0,
		done = false,
		problem = nil,
		cancelled = false,
		progress = 0,
		tries = 0,
		ms = 0,
		missed = false,
		stage = "starting",
	}
	self._session = {
		controller = controller,
		job = job,
		test = test,
		phase = "planning",
		index = 0,
		shot = nil,
		phaseStart = now,
		phaseEnd = now,
		fromAngle = 0,
		overAngle = 0,
		targetAngle = 0,
		settleSeconds = 0,
		pauseSeconds = 0,
		chargeSeconds = 0,
		holdSeconds = 0,
		mouseStart = UserInputService:GetMouseLocation(),
		progressShown = -1,
		lastSeen = now,
		unseenFrames = 0,
		spinBefore = nil,
	}
	if not test then
		live.cueOwner = owner
	end
	self._options.onPrompt({ "Finding the best shot..." }, false)
	task.spawn(function(): ()
		local ok, err = tryTraced(Cue._plan, self, job)
		if not ok then
			job.problem = "failed"
			job.done = true
			logWarn(`{owner}: the search failed: {err}`)
		end
	end)
	return nil
end

-- While it aims: the next best shot (never a losing one)
function Cue.next(self: Cue): ()
	local session = self._session
	if session == nil or session.test then
		return
	end
	local phase = session.phase
	if phase == "glide" or phase == "settle" or phase == "pause" then
		local count = #session.job.shots
		local index = session.index
		for _ = 1, count do
			index = index % count + 1
			if session.job.shots[index].outcome ~= "loss" then
				break
			end
		end
		Cue._aimAt(self, session, session.controller, index)
	end
end

-- Ends the shot: gives the cue back (no power, its spin as it was, the mouse aims again) and
-- says why
function Cue.stop(self: Cue, text: string?, ok: boolean): ()
	local session = self._session
	if session == nil then
		return
	end
	self._session = nil
	session.job.cancelled = true
	local live = self._hooks.live
	if live.cueOwner == self._options.owner then
		live.cueOwner = nil
	end
	local controller = session.controller
	if session.phase ~= "planning" and type(controller) == "table" then
		-- the meter it charged goes back to 0, whatever the cue's state, unless you are charging
		if session.phase == "charge" and controller.State ~= "Charging" then
			try(self._refs.input.SetPower, controller, 0)
		end
		local spinBefore = session.spinBefore
		if spinBefore ~= nil and self._refs.hud ~= nil and type(controller.Hud) == "table" then
			try(self._refs.hud.SetSpin, controller.Hud, spinBefore)
		end
		controller.NudgeAnchor = nil
	end
	self._options.onEnd(text, ok, nil, session.test)
end

-- The watchdog (every frame): the game updates your cue every frame of your turn, so when it
-- stops for WATCHDOG_FRAMES frames and WATCHDOG seconds, the turn has passed (the clock ran out,
-- the match ended). A test search ends here once done (your turn may have passed meanwhile)
function Cue._watchTurn(self: Cue): ()
	local session = self._session
	if session == nil then
		return
	end
	if session.test then
		if session.job.done then
			-- what Cue._planned does for a test: the plan is kept, the session ends
			self.lastJob = session.job
			self._session = nil
			self._options.onEnd(nil, true, nil, true)
		end
		return
	end
	session.unseenFrames += 1
	if
		session.unseenFrames >= CueConfig.WATCHDOG_FRAMES
		and os.clock() - session.lastSeen > CueConfig.WATCHDOG
	then
		Cue.stop(self, "Your turn ended", false)
	end
end

-- Turns the cue toward shot `index`: an eased sweep, sometimes past the line and back. Its spin
-- goes on the HUD's spin dot
function Cue._aimAt(self: Cue, session: CueSession, controller: any, index: number): ()
	local shot = session.job.shots[index]
	local random = self._random
	local now = os.clock()
	local from = Cue.angleOf(controller.Direction)
	local target = Cue.angleOf(shot.direction)
	local turn = Cue.turn(from, target)
	local degrees = math.abs(math.deg(turn))
	local jitter = 1 + (random:NextNumber() * 2 - 1) * CueConfig.JITTER
	local seconds = math.clamp(
		CueConfig.GLIDE_MIN + degrees * CueConfig.GLIDE_PER_DEGREE,
		CueConfig.GLIDE_MIN,
		CueConfig.GLIDE_MAX
	) * jitter
	local over = target
	if degrees > 3 and random:NextNumber() < CueConfig.OVERSHOOT_CHANCE then
		local extra = math.rad(
			math.min(
				Cue.between(random, CueConfig.OVERSHOOT_MIN, CueConfig.OVERSHOOT_MAX),
				degrees / 2
			)
		)
		over = target + (if turn >= 0 then extra else -extra)
	end
	session.index = index
	session.shot = shot
	session.phase = "glide"
	session.phaseStart = now
	session.phaseEnd = now + seconds
	session.fromAngle = from
	session.overAngle = from + Cue.turn(from, over)
	session.targetAngle = target
	session.settleSeconds = Cue.between(random, CueConfig.SETTLE_MIN, CueConfig.SETTLE_MAX)
	session.pauseSeconds = Cue.between(random, CueConfig.PAUSE_MIN, CueConfig.PAUSE_MAX) * jitter
	session.chargeSeconds = Cue.between(random, CueConfig.CHARGE_MIN, CueConfig.CHARGE_MAX)
	session.holdSeconds = Cue.between(random, CueConfig.HOLD_MIN, CueConfig.HOLD_MAX)
	session.mouseStart = UserInputService:GetMouseLocation()
	local hud = controller.Hud
	if self._refs.hud ~= nil and type(hud) == "table" then
		if session.spinBefore == nil and typeof(hud.Spin) == "Vector2" then
			session.spinBefore = hud.Spin
		end
		try(self._refs.hud.SetSpin, hud, shot.spin)
	end
	local lines = { Cue.describeShot(shot) }
	if self._options.showIndex and #session.job.shots > 1 then
		table.insert(lines, `Shot {index} of {#session.job.shots}`)
	end
	self._options.onPrompt(lines, true)
end

-- Releases the shot the way the game does on mouse release (PoolInputController onDeactivated)
function Cue._fire(self: Cue, session: CueSession, controller: any): ()
	local shot = session.shot
	if shot == nil then
		Cue.stop(self, "No shot found", false)
		return
	end
	if Shots.tableKey(controller.Simulation) ~= session.job.tableKey then
		Cue.stop(self, "The table changed - try again", false)
		return
	end
	local input = self._refs.input
	-- NEEDS INFO(AutoAim-1): a shot released here (from the hook, before the game's Update) is sent
	-- online exactly like a mouse release; default: yes (the same calls onDeactivated makes)
	-- NEEDS INFO(AutoAim-2): the game's shot handler runs within FIRE_GUARD (0.5 s) of the Fire, so
	-- the cue does not flip back to Aiming first; default: yes (deferred events run next frame)
	input.SetPower(controller, 0)
	controller.CanPlaceCueBall = false
	controller.ReadyAt = os.clock() + CueConfig.FIRE_GUARD
	input.SetState(controller, "Simulating")
	controller.ShotBindable:Fire(shot.direction, shot.power, shot.spin)
	-- the cue is the game's again; only the session ends
	self._session = nil
	local live = self._hooks.live
	if live.cueOwner == self._options.owner then
		live.cueOwner = nil
	end
	self._options.onEnd(`Shot: {Cue.describeShot(shot)}`, true, shot, false)
end

-- Places the cue ball the way a release while dragging does (onDeactivated: Dragging off, the
-- ball set, state Aiming)
function Cue._place(self: Cue, controller: any, spot: Vector2): ()
	local refs = self._refs
	local cue = Shots.cueNumber(refs)
	controller.Dragging = false
	local cueBall = controller.Simulation.Balls[cue]
	cueBall.Position = spot
	if refs.view ~= nil then
		refs.view.SetBall(controller.View, cue, spot)
	end
	if controller.State ~= "Aiming" then
		refs.input.SetState(controller, "Aiming")
	end
end

-- The search finished: place the ball if it is in hand, then aim at the best shot (or, in a
-- test, report)
function Cue._planned(self: Cue, session: CueSession, controller: any): ()
	local job = session.job
	self.lastJob = job
	if session.test then
		self._session = nil
		self._options.onEnd(nil, true, nil, true)
		return
	end
	if job.problem ~= nil or #job.shots == 0 then
		Cue.stop(
			self,
			if job.problem == "failed" then "Could not work it out - see F9" else "No shot found",
			false
		)
		return
	end
	if Shots.tableKey(controller.Simulation) ~= job.tableKey then
		Cue.stop(self, "The table changed - try again", false)
		return
	end
	if controller.Muted or controller.AimLocked then
		Cue.stop(self, "Your turn ended", false)
		return
	end
	if job.place then
		local spot = job.placeAt
		if spot ~= nil then
			Cue._place(self, controller, spot)
		elseif controller.State ~= "Aiming" then
			controller.Dragging = false
			self._refs.input.SetState(controller, "Aiming")
		end
		job.tableKey = Shots.tableKey(controller.Simulation)
		local now = os.clock()
		session.phase = "placed"
		session.phaseStart = now
		session.phaseEnd = now + Cue.between(self._random, CueConfig.PLACE_MIN, CueConfig.PLACE_MAX)
		session.mouseStart = UserInputService:GetMouseLocation()
		return
	end
	if controller.State ~= "Aiming" then
		Cue.stop(self, "Your turn ended", false)
		return
	end
	Cue._aimAt(self, session, controller, 1)
end

-- You clicked while it aimed: the cue points at your mouse (the game froze it when the charge
-- began) and the shot is yours
function Cue._handOver(self: Cue, controller: any): ()
	local refs = self._refs
	local table2d = refs.table2d
	local view = controller.View
	if table2d == nil or type(view) ~= "table" then
		return
	end
	local ok, point =
		try(table2d.PixelToTable, view.Renderer2D, UserInputService:GetMouseLocation())
	local cueBall = controller.Simulation.Balls[Shots.cueNumber(refs)]
	if ok and typeof(point) == "Vector2" and cueBall ~= nil then
		local toward: Vector2 = point - cueBall.Position
		if toward.Magnitude > refs.constants.BallRadius then
			controller.Direction = toward.Unit
		end
	end
end

-- The InputUpdate listener: runs on the game's thread every frame of your turn, before the game
-- updates your cue. Moves the cue along the session (plain table work and the game's own calls)
function Cue._steer(self: Cue, controller: any): ()
	local session = self._session
	if session == nil or self._destroyed or controller ~= session.controller then
		return
	end
	local now = os.clock()
	session.lastSeen = now
	session.unseenFrames = 0
	if session.phase == "planning" then
		local job = session.job
		if not session.test then
			local inHand = controller.State == "BallInHand" and job.place
			if
				controller.Muted
				or controller.AimLocked
				or not (controller.State == "Aiming" or inHand)
			then
				Cue.stop(
					self,
					if controller.State == "Charging"
						then "You took the shot"
						else "Your turn ended",
					true
				)
				return
			end
		end
		if job.done then
			Cue._planned(self, session, controller)
		elseif not session.test then
			local shown = math.floor(job.progress * 10)
			if shown ~= session.progressShown then
				session.progressShown = shown
				self._options.onPrompt({ `Finding the best shot... {shown * 10}%` }, false)
			end
		end
		return
	end
	if controller.State == "Charging" then
		-- a click while it aimed: the shot is yours; dragged on the table, toward your mouse (a
		-- charge on the meter keeps the aim: the mouse is on the meter, not the table)
		if controller.ChargeMode == "Drag" then
			Cue._handOver(self, controller)
		end
		Cue.stop(self, "You took the shot", true)
		return
	end
	if controller.State ~= "Aiming" or controller.Muted or controller.AimLocked then
		Cue.stop(self, "Your turn ended", false)
		return
	end
	local mouse = UserInputService:GetMouseLocation()
	if
		self._options.mouseRelease
		and (mouse - session.mouseStart).Magnitude > CueConfig.MOUSE_RELEASE
	then
		Cue.stop(self, "You took the aim back", true)
		return
	end
	if session.phase == "placed" then
		if now >= session.phaseEnd then
			Cue._aimAt(self, session, controller, 1)
		end
		controller.NudgeAnchor = mouse
		return
	end
	local shot = session.shot
	if shot == nil then
		Cue.stop(self, "No shot found", false)
		return
	end
	local duration = math.max(session.phaseEnd - session.phaseStart, 1e-3)
	local t = (now - session.phaseStart) / duration
	local direction = shot.direction
	if session.phase == "glide" then
		local angle = session.fromAngle + (session.overAngle - session.fromAngle) * Cue.ease(t)
		direction = Vector2.new(math.cos(angle), math.sin(angle))
		if t >= 1 then
			local back = math.abs(Cue.turn(session.overAngle, session.targetAngle)) > 1e-6
			session.phase = if back then "settle" else "pause"
			session.phaseStart = now
			session.phaseEnd = now + (if back then session.settleSeconds else session.pauseSeconds)
			session.fromAngle = session.overAngle
			direction = if back then direction else shot.direction
		end
	elseif session.phase == "settle" then
		local angle = session.fromAngle
			+ Cue.turn(session.fromAngle, session.targetAngle) * Cue.ease(t)
		direction = Vector2.new(math.cos(angle), math.sin(angle))
		if t >= 1 then
			session.phase = "pause"
			session.phaseStart = now
			session.phaseEnd = now + session.pauseSeconds
			direction = shot.direction
		end
	elseif session.phase == "pause" then
		if t >= 1 then
			session.phase = "charge"
			session.phaseStart = now
			session.phaseEnd = now + session.chargeSeconds + session.holdSeconds
		end
	elseif session.phase == "charge" then
		local fill = Cue.ease((now - session.phaseStart) / math.max(session.chargeSeconds, 1e-3))
		self._refs.input.SetPower(controller, shot.power * fill)
		if now >= session.phaseEnd then
			controller.Direction = shot.direction
			Cue._fire(self, session, controller)
			return
		end
	end
	controller.Direction = direction
	controller.NudgeAnchor = mouse
	controller.DragAngle = nil
end

function Cue.Destroy(self: Cue): ()
	Cue.stop(self, nil, true)
	self._destroyed = true
	local watch = self._watch
	self._watch = nil
	if watch ~= nil then
		watch:Disconnect()
	end
	Shots.unlisten(self._hooks, "InputUpdate", self._options.owner, self._listener)
end
--#endregion Shared.Cue

--#region Shared.AntiIdle (keep identical in every feature file, source: shared/AntiIdle.luau)
-- AntiIdle: keeps Roblox from kicking you for being idle (20 minutes without input) while a
-- feature plays for you. LocalPlayer.Idled fires after about 2 minutes idle: while it is on, the
-- game's own Idled listeners are disabled and each Idled is answered with a VirtualUser click,
-- which resets the idle timer (devtools/vscode_bridge.lua, LT2 Player MV8). stop() turns the
-- game's listeners back on. It never touches anything else.
-- Needs: Core

type AntiIdleFields = {
	kicksStopped: number, -- idle kicks it answered
	_idled: { any }, -- the game's Idled connections it disabled (Volt connection objects)
	_connection: RBXScriptConnection?,
	_handler: () -> (),
}

local AntiIdle = {}
AntiIdle.__index = AntiIdle

type AntiIdle = typeof(setmetatable({} :: AntiIdleFields, AntiIdle))

local function newAntiIdle(): AntiIdle
	local self = setmetatable({} :: AntiIdleFields, AntiIdle)
	self.kicksStopped = 0
	self._idled = {}
	self._connection = nil
	self._handler = function(): ()
		self:_onIdled()
	end
	return self
end

-- Disables the game's Idled listeners (not ours, not ones already disabled)
function AntiIdle._disableIdled(self: AntiIdle): ()
	local connectionsOf: any = getconnections -- Volt: the connections of a signal
	local ok, list = pcall(connectionsOf, LocalPlayer.Idled)
	if not ok or type(list) ~= "table" then
		return
	end
	for _, connection in list do
		local read, enabled, fn = pcall(function(): (any, any)
			return (connection :: any).Enabled, (connection :: any).Function
		end)
		if
			read
			and enabled ~= false
			and fn ~= self._handler
			and not table.find(self._idled, connection)
		then
			if pcall(function(): ()
				(connection :: any):Disable()
			end) then
				table.insert(self._idled, connection)
			end
		end
	end
end

-- An Idled (about 2 minutes without input): the game's listeners off again, and a click that
-- resets the idle timer
function AntiIdle._onIdled(self: AntiIdle): ()
	self:_disableIdled()
	pcall(function(): ()
		local virtual = game:GetService("VirtualUser")
		virtual:CaptureController()
		virtual:ClickButton2(Vector2.zero)
	end)
	self.kicksStopped += 1
end

function AntiIdle.isOn(self: AntiIdle): boolean
	return self._connection ~= nil
end

function AntiIdle.start(self: AntiIdle): ()
	if self._connection ~= nil then
		return
	end
	-- connected to our own handler, so _disableIdled knows it is ours and skips it
	self._connection = LocalPlayer.Idled:Connect(self._handler)
	self:_disableIdled()
end

-- Turns the game's Idled listeners back on
function AntiIdle.stop(self: AntiIdle): ()
	local connection = self._connection
	self._connection = nil
	if connection ~= nil then
		connection:Disconnect()
	end
	for _, disabled in self._idled do
		pcall(function(): ()
			(disabled :: any):Enable()
		end)
	end
	table.clear(self._idled)
end

function AntiIdle.Destroy(self: AntiIdle): ()
	self:stop()
end
--#endregion Shared.AntiIdle

--#region Shared.Relaunch (keep identical in every feature file, source: shared/Relaunch.luau)
-- Relaunch: runs the game's Corny script again after the game moves you to another server or
-- place (a teleport, like matchmaking sending you to a match's server), and lets a page carry on
-- where it was (AutoFarm keeps farming). Once per server (getgenv().CornyRelaunch, a re-run
-- swaps the connection): when LocalPlayer.OnTeleport says a teleport started, it queues, once,
-- code that waits for the new server's game to be ready (game.Loaded, then PlayerGui's ready GUI)
-- and runs the script from its URL again (Volt's queueonteleport, game:HttpGet, loadstring; the
-- way docs/VOLT_API.md shows); at that moment it also writes what each page asked to carry on
-- (Relaunch.carry) to FILE in the game's folder (Shared.Files). After the teleport the new run's
-- pages take their part (Relaunch.take), only when the file was written on another server less
-- than FRESH seconds ago; the file is then emptied, so a later run of your own starts clean. It
-- never teleports you, never clears other scripts' queued code and runs nothing but the given URL.
-- Needs: Core, Files

local RelaunchConfig = table.freeze({
	KEY = "CornyRelaunch", -- getgenv: the teleport listener and the pages' carry calls, per server
	VERSION = 1,
	DONE_KEY = "CornyRelaunched", -- getgenv on the new server: the queued code ran (it runs once)
	FILE = "relaunch.json", -- what the pages carry over a teleport (the game's folder)
	FRESH = 300, -- seconds after the teleport began that the file still counts
	READY_WAIT = 60, -- seconds the queued code waits for the ready GUI before it runs anyway
	LOG_PREFIX = "[Corny]", -- the queued code's warning (Core's log adds it to the other lines)
})

-- The listener and the pages' carry calls, kept in getgenv for the whole server
type RelaunchState = {
	version: number,
	connection: RBXScriptConnection?,
	url: string,
	readyGui: string,
	files: Files, -- the latest run's
	queued: boolean, -- the script is queued for the next server
	teleporting: boolean, -- a teleport started and has not failed
	carry: { [string]: () -> any }, -- each page's: what it carries over (nil: nothing)
}

local Relaunch = {
	arrived = nil :: { [string]: any }?, -- this run's carried parts, read on the first take
}

-- The state for this server, or nil before the first install
function Relaunch._state(): RelaunchState?
	local state = getgenv()[RelaunchConfig.KEY]
	if type(state) == "table" and state.version == RelaunchConfig.VERSION then
		return state
	end
	return nil
end

-- The code queued for the next server: waits for its game, then runs the script once
function Relaunch._code(url: string, readyGui: string): string
	return string.format(
		[[
local genv = getgenv()
if genv[%q] then return end
genv[%q] = true
if not game:IsLoaded() then game.Loaded:Wait() end
local players = game:GetService("Players")
local player = players.LocalPlayer
while player == nil do
	players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	player = players.LocalPlayer
end
player:WaitForChild("PlayerGui"):WaitForChild(%q, %d)
local ok, err = pcall(function()
	local source = game:HttpGet(%q) -- allow-web: the user's own full script (2026-10-06)
	local run, problem = loadstring(source) -- allow-web: runs it, as the user asked (2026-10-06)
	if run == nil then error(problem, 0) end
	run()
end)
if not ok then warn(%q .. tostring(err)) end
]],
		RelaunchConfig.DONE_KEY,
		RelaunchConfig.DONE_KEY,
		readyGui,
		RelaunchConfig.READY_WAIT,
		url,
		`{RelaunchConfig.LOG_PREFIX} could not run again after the teleport: `
	)
end

-- A teleport started: what the pages carry goes to the file (every time: the latest), and the
-- script is queued for the next server (once)
function Relaunch._onStart(state: RelaunchState): ()
	state.teleporting = true
	local carried: { [string]: any } = {}
	for owner, carry in state.carry do
		local ok, value = try(carry)
		if ok and value ~= nil then
			carried[owner] = value
		end
	end
	local wrote, err = state.files:writeJson(RelaunchConfig.FILE, {
		time = os.time(),
		job = game.JobId,
		carry = carried,
	})
	if not wrote then
		logWarn(`could not save what to carry on after the teleport: {err}`)
	end
	if state.queued then
		return
	end
	local queue: any = queueonteleport -- Volt: code to run once the next server loads
	if type(queue) ~= "function" then
		warnOnce("relaunch.queue", `this executor cannot run Corny again after a teleport`)
		return
	end
	local queuedOk, problem = try(queue, Relaunch._code(state.url, state.readyGui))
	if queuedOk then
		state.queued = true
		log(`moving to another server: Corny runs again once it loads`)
	else
		logWarn(`could not queue Corny for the next server: {problem}`)
	end
end

-- Listens for teleports on this server (a re-run swaps the listener and the URL; what is queued
-- stays queued). `url`: the game's full script; `readyGui`: the PlayerGui child the game makes
-- once it is ready
function Relaunch.install(files: Files, url: string, readyGui: string): ()
	local genv = getgenv()
	local state = Relaunch._state()
	if state == nil then
		local fresh: RelaunchState = {
			version = RelaunchConfig.VERSION,
			connection = nil,
			url = url,
			readyGui = readyGui,
			files = files,
			queued = false,
			teleporting = false,
			carry = {},
		}
		genv[RelaunchConfig.KEY] = fresh
		state = fresh
	end
	assert(state ~= nil)
	local live: RelaunchState = state
	live.url = url
	live.readyGui = readyGui
	live.files = files
	local old = live.connection
	if old ~= nil then
		old:Disconnect()
	end
	-- NEEDS INFO(AutoFarm-1): the game moving you to another server (its matchmaking) fires
	-- LocalPlayer.OnTeleport on your client, and Volt runs the queued code there; default: yes (a
	-- teleport of your player, whoever starts it, goes through your client's TeleportState)
	live.connection = LocalPlayer.OnTeleport:Connect(function(teleportState: Enum.TeleportState): ()
		if
			teleportState == Enum.TeleportState.Started
			or teleportState == Enum.TeleportState.InProgress
		then
			local ok, err = tryTraced(Relaunch._onStart, live)
			if not ok then
				logWarn(`getting ready for the teleport failed: {err}`)
			end
		elseif teleportState == Enum.TeleportState.Failed then
			live.teleporting = false
		end
	end)
end

-- What page `owner` carries over a teleport: `carry` returns it (a table of plain values, or nil
-- for nothing) at the moment the teleport starts; nil stops carrying (the page's onDestroy)
function Relaunch.carry(owner: string, carry: (() -> any)?): ()
	local state = Relaunch._state()
	if state == nil then
		return
	end
	if carry == nil then
		state.carry[owner] = nil
	else
		state.carry[owner] = carry
	end
end

-- Whether a teleport started on this server and has not failed (the page should wait)
function Relaunch.isTeleporting(): boolean
	local state = Relaunch._state()
	return state ~= nil and state.teleporting
end

-- What page `owner` carried here over a teleport, once; nil when it carried nothing, the file is
-- old, or this run did not come from a teleport
function Relaunch.take(files: Files, owner: string): any
	local arrived = Relaunch.arrived
	if arrived == nil then
		local fresh: { [string]: any } = {}
		Relaunch.arrived = fresh
		arrived = fresh
		local saved = files:readJson(RelaunchConfig.FILE)
		if type(saved) == "table" and type(saved.carry) == "table" then
			local age = if type(saved.time) == "number" then os.time() - saved.time else math.huge
			if age >= 0 and age <= RelaunchConfig.FRESH and saved.job ~= game.JobId then
				for key, value in saved.carry do
					if type(key) == "string" then
						fresh[key] = value
					end
				end
			end
			-- read once: a later run of your own starts clean
			files:writeJson(RelaunchConfig.FILE, {})
		end
	end
	assert(arrived ~= nil)
	local value = arrived[owner]
	arrived[owner] = nil
	return value
end
--#endregion Shared.Relaunch

--#region Feature.ShotPaths (the full Corny script copies this region unchanged)
--[[ ShotPaths (CornyMenu page "Shot Paths"): the user, 2026-10-05: "hook into the line generator
	 (line that shows where ball is going, and target ball), and make it show the complete path of
	 where all balls will go", then "make it easier to identify which balls are ours" (they picked
	 coloured pocket dots).

	 How it works (each step first ran in game as research/shot_paths_test.lua; the user,
	 2026-10-05: "Works great!"):
	   1. Shared.Shots hooks the game's aim guide (PoolPhysics.PredictShot, PoolAimOverlay.Update)
	      once per server and keeps the guide on screen: the table, direction, power, spin and its
	      frame.
	   2. While the guide shows (PoolAimOverlay.IsAimShown) and the shot or a ball changed:
	      Shots.play plays the shot on a copy of the table with the game's own physics until every
	      ball stops (power and spin clamped like the server's Shoot), recording every ball's path.
	   3. The page's overlay draws the paths over the guide's frame (Shots.screenOf): a ring where a
	      ball stops, a dot in the pocket a ball drops into. A pocket dot is green when the ball is
	      one of yours, red when it is your opponent's, the 8 too early, or the cue ball
	      (Shots.ownerOf, Shots.verdictOf).
	 Game rules it relies on:
	   - The server plays a shot with the same PoolPhysics code [dump], and the paths match where
	     the balls stop [in-game, the research test, 2026-10-05].
	 Read only: it sends nothing and changes nothing in the game. ]]
local ShotPathsConfig = table.freeze({
	PAGE = "Shot Paths", -- page name
	STATUS_ID = "shotpaths", -- watermark segment id (not used: nothing runs in the background)
	LOG_PREFIX = "[ShotPaths]",
	-- files go in this game's folder of Volt's workspace, Corny/<KEY>/ (Game.files, Shared.Files;
	-- docs/WORKSPACE_FILES.md), never anywhere else
	SAVE_FILE = "shotpaths.json", -- the page's options
	DEBUG_FILE = "debug/shotpaths.txt", -- the Test submenu's dump of the shown prediction
	OPACITY = 0.9, -- lines, rings and dots (the research test's value)
	THICKNESS_DEFAULT = 2, -- path line thickness in pixels (the research test's value)
	THICKNESS_MIN = 1,
	THICKNESS_MAX = 4,
	RING_SIDES = 16, -- segments of the ring where a ball stops
	DOT_SIDES = 12, -- triangles of a pocket dot
	POCKET_DOT = 0.6, -- a pocket dot's radius, as a share of a ball's (the research test's value)
	CHECK_GAP = 0.01, -- Test check: a shot matches when every ball stopped this close (inches)
	YOURS = Color3.fromRGB(90, 220, 110), -- pocket dot: one of your balls goes in
	NOT_YOURS = Color3.fromRGB(235, 75, 65), -- pocket dot: opponent's ball, an early 8, the cue ball
	IDLE_TEXT = "Aim a shot to see where every ball goes",
	OFF_TEXT = "Paths are off",
})

-- The page's options, saved in SAVE_FILE
type ShotPathsSaved = {
	enabled: boolean, -- draw the paths
	opponent: boolean, -- also while the opponent aims
	pocketColours: boolean, -- green / red pocket dots
	thickness: number, -- path line thickness in pixels
}

-- Test: a shot being played, with what was predicted for it
type ShotPathsCheck = { sim: any, result: ShotsResult, moving: boolean }

type ShotPathsState = {
	destroyed: boolean, -- the page was replaced (a re-run) or the menu unloaded
	refs: GameRefs,
	hooks: ShotsHooks,
	saved: ShotPathsSaved,
	layer: CornyMenuLayer?,
	label: CornyMenuOption?,
	labelText: string,
	labelColour: Color3?,
	owner: ShotsOwner,
	key: string?, -- what the shown prediction was made from
	result: ShotsResult?,
	verdicts: { [number]: string }, -- "yours" / "not" per ball that goes in
	summary: string, -- the status line for the shown prediction
	summaryColour: Color3?,
	root: any?, -- the guide's frame (one of the game's GuiObjects), for the screen mapping
	visible: boolean,
	checking: boolean, -- Test: check each shot in F9
	check: ShotPathsCheck?,
	checkListener: any?, -- the Shoot listener while checking
	failed: boolean, -- the shown aim could not be worked out (the error is in F9)
	warned: { [string]: boolean },
}

local ShotPaths = {
	log = newLogger(ShotPathsConfig.LOG_PREFIX),
	state = nil :: ShotPathsState?, -- the live page's state (the Test submenu reads it)
}

function ShotPaths.warnOnce(state: ShotPathsState, message: string): ()
	if state.warned[message] then
		return
	end
	state.warned[message] = true
	ShotPaths.log.warn(message)
end

-- ============ Prediction ============

-- The status line for a prediction: which balls go in, green when only yours do, red when any
-- other does
function ShotPaths.describe(state: ShotPathsState, result: ShotsResult): (string, Color3)
	local palette = CornyMenu.palette
	local cue = Shots.cueNumber(state.refs)
	local numbers: { number } = {}
	local cueIn = false
	local anyYours = false
	local anyNot = false
	for _, number in result.potted do
		if number == cue then
			cueIn = true
		else
			table.insert(numbers, number)
		end
		local verdict = state.verdicts[number]
		if verdict == "yours" then
			anyYours = true
		elseif verdict == "not" then
			anyNot = true
		end
	end
	table.sort(numbers)
	local text: string
	if #numbers == 0 then
		text = if cueIn then "The cue ball goes in" else "No ball goes in"
	else
		local names: { string } = {}
		for _, number in numbers do
			table.insert(names, tostring(number))
		end
		local list = names[1]
		if #names > 1 then
			list = `{table.concat(names, ", ", 1, #names - 1)} and {names[#names]}`
		end
		text = `Pots {list}`
		if cueIn then
			text ..= " (the cue ball goes in too)"
		end
	end
	local colour = if anyNot then palette.bad elseif anyYours then palette.good else palette.subtext
	return text, colour
end

-- Everything a prediction depends on: the shot, every ball, and whose balls are whose
function ShotPaths.keyOf(aim: ShotsAim, owner: ShotsOwner): string
	return string.format(
		"%.6f,%.6f,%.6f,%.6f,%.6f,%s,%s,%s|%s",
		aim.direction.X,
		aim.direction.Y,
		aim.power,
		aim.spin.X,
		aim.spin.Y,
		tostring(owner.known),
		tostring(owner.group),
		tostring(owner.onEight),
		Shots.tableKey(aim.sim)
	)
end

-- Predicts the shown aim and judges every ball that goes in
function ShotPaths.predict(state: ShotPathsState, aim: ShotsAim, owner: ShotsOwner): ()
	local refs = state.refs
	local power, spin = Shots.clamp(refs, aim.power, aim.spin)
	local ok, result =
		try(Shots.play, state.hooks, refs, aim.sim, aim.direction, power, spin, true, false)
	if not ok then
		ShotPaths.warnOnce(state, `could not predict the shot: {result}`)
		state.result = nil
		state.failed = true
		return
	end
	state.failed = false
	state.result = result
	table.clear(state.verdicts)
	if result == nil then
		return
	end
	local cue = Shots.cueNumber(refs)
	local cueIn = table.find(result.potted, cue) ~= nil
	for _, number in result.potted do
		local verdict = Shots.verdictOf(refs, owner, number, cueIn)
		if verdict ~= nil then
			state.verdicts[number] = verdict
		end
	end
	local text, colour = ShotPaths.describe(state, result)
	state.summary = text
	state.summaryColour = colour
end

-- ============ Every frame ============

function ShotPaths.say(state: ShotPathsState, text: string, colour: Color3?): ()
	if text == state.labelText and colour == state.labelColour then
		return
	end
	state.labelText = text
	state.labelColour = colour
	local label = state.label
	if label ~= nil then
		label:set(text, colour or CornyMenu.palette.subtext)
	end
end

-- Test check: once a checked shot has been played and every ball stopped, compare
function ShotPaths.watchCheck(state: ShotPathsState): ()
	local check = state.check
	if check == nil then
		return
	end
	if not check.sim.Settled then
		check.moving = true
		return
	end
	if not check.moving then
		return
	end
	state.check = nil
	ShotPaths.reportCheck(state, check)
end

-- Follows the guide: predicts when the shot or a ball changed, shows or hides the paths
function ShotPaths.update(state: ShotPathsState): ()
	if state.destroyed then
		return
	end
	ShotPaths.watchCheck(state)
	local saved = state.saved
	local aim = state.hooks.live.aim
	local showing = false
	local aimShown = false
	if saved.enabled and aim ~= nil and aim.overlay ~= nil then
		local refs = state.refs
		local ok, shown = try(refs.aim.IsAimShown, aim.overlay)
		local owner = Shots.ownerOf(state.hooks, refs, aim.sim)
		state.owner = owner
		if ok and shown == true and (saved.opponent or not owner.opponent) then
			aimShown = true
			local key = ShotPaths.keyOf(aim, owner)
			if key ~= state.key then
				state.key = key
				ShotPaths.predict(state, aim, owner)
			end
			local root = aim.overlay.Root
			if state.result ~= nil and typeof(root) == "Instance" and root:IsA("GuiObject") then
				state.root = root
				showing = true
			end
		end
	end
	if showing ~= state.visible then
		state.visible = showing
		local layer = state.layer
		if layer ~= nil then
			layer:setVisible(showing)
			layer:setAnimated(showing)
		end
	end
	if showing then
		ShotPaths.say(state, state.summary, state.summaryColour)
	elseif aimShown and state.failed then
		ShotPaths.say(state, "Could not work out this shot - see F9", CornyMenu.palette.bad)
	elseif saved.enabled then
		ShotPaths.say(state, ShotPathsConfig.IDLE_TEXT, nil)
	else
		ShotPaths.say(state, ShotPathsConfig.OFF_TEXT, nil)
	end
end

-- ============ Drawing ============

function ShotPaths.drawRing(
	draw: CornyMenuDraw,
	x: number,
	y: number,
	radius: number,
	colour: Color3,
	thickness: number
): ()
	local sides = ShotPathsConfig.RING_SIDES
	local lastX = x + radius
	local lastY = y
	for index = 1, sides do
		local angle = index * 2 * math.pi / sides
		local nextX = x + radius * math.cos(angle)
		local nextY = y + radius * math.sin(angle)
		draw:line(lastX, lastY, nextX, nextY, colour, ShotPathsConfig.OPACITY, thickness)
		lastX = nextX
		lastY = nextY
	end
end

function ShotPaths.drawDot(
	draw: CornyMenuDraw,
	x: number,
	y: number,
	radius: number,
	colour: Color3
): ()
	local sides = ShotPathsConfig.DOT_SIDES
	local lastX = x + radius
	local lastY = y
	for index = 1, sides do
		local angle = index * 2 * math.pi / sides
		local nextX = x + radius * math.cos(angle)
		local nextY = y + radius * math.sin(angle)
		draw:triangle(x, y, lastX, lastY, nextX, nextY, colour, ShotPathsConfig.OPACITY)
		lastX = nextX
		lastY = nextY
	end
end

-- The overlay painter (runs on the menu's frame loop; must not yield)
function ShotPaths.paint(state: ShotPathsState, draw: CornyMenuDraw): ()
	local result = state.result
	if not state.visible or result == nil then
		return
	end
	local screen = Shots.screenOf(state.refs, state.root)
	if screen == nil then
		return
	end
	local centreX = screen.centreX
	local centreY = screen.centreY
	local scaleX = screen.scaleX
	local scaleY = screen.scaleY
	local radius = state.refs.constants.BallRadius * scaleX
	local saved = state.saved
	local thickness = saved.thickness
	for _, path in result.paths do
		if not path.moved then
			continue
		end
		local points = path.points
		local first = points[1]
		local lastX = centreX + first.X * scaleX
		local lastY = centreY - first.Y * scaleY
		for index = 2, #points do
			local point = points[index]
			local x = centreX + point.X * scaleX
			local y = centreY - point.Y * scaleY
			draw:line(lastX, lastY, x, y, path.colour, ShotPathsConfig.OPACITY, thickness)
			lastX = x
			lastY = y
		end
		if path.pocketed then
			local colour = path.colour
			local verdict = state.verdicts[path.number]
			if saved.pocketColours and verdict ~= nil then
				colour = if verdict == "yours"
					then ShotPathsConfig.YOURS
					else ShotPathsConfig.NOT_YOURS
			end
			ShotPaths.drawDot(draw, lastX, lastY, radius * ShotPathsConfig.POCKET_DOT, colour)
		else
			ShotPaths.drawRing(
				draw,
				lastX,
				lastY,
				radius,
				path.colour,
				math.max(1, thickness * 0.75)
			)
		end
	end
end

-- ============ Test helpers ============

-- The shown prediction as console / file lines
function ShotPaths.describeState(state: ShotPathsState): { string }
	local lines: { string } = {}
	local hooked: { string } = {}
	for name in state.hooks.original do
		table.insert(hooked, name)
	end
	table.sort(hooked)
	table.insert(lines, `hooks: {table.concat(hooked, ", ")} (version {state.hooks.version})`)
	local owner = state.owner
	table.insert(
		lines,
		`rules known: {owner.known}, your group: {owner.group or "none"}, seat: {owner.seat or "?"},`
			.. ` on the 8: {owner.onEight}, opponent's aim: {owner.opponent}`
	)
	local aim = state.hooks.live.aim
	if aim == nil then
		table.insert(lines, "no aim seen yet")
		return lines
	end
	table.insert(
		lines,
		string.format(
			"aim: direction (%.4f, %.4f), power %.3f, spin (%.2f, %.2f), shown: %s",
			aim.direction.X,
			aim.direction.Y,
			aim.power,
			aim.spin.X,
			aim.spin.Y,
			tostring(state.visible)
		)
	)
	local result = state.result
	if result == nil then
		table.insert(lines, "no prediction")
		return lines
	end
	table.insert(
		lines,
		string.format(
			"prediction: %d steps, %.1f ms%s, first hit: %s",
			result.steps,
			result.ms,
			if result.settled then "" else ", did not settle",
			tostring(result.firstHit)
		)
	)
	for _, path in result.paths do
		if not path.moved then
			continue
		end
		local ending = if path.pocketed
			then `goes in ({state.verdicts[path.number] or "unknown"})`
			else string.format("stops at (%.2f, %.2f)", path.final.X, path.final.Y)
		table.insert(lines, `ball {path.number}: {#path.points} points, {ending}`)
	end
	return lines
end

-- Test check: the prediction made when the shot was played against where the balls stopped
function ShotPaths.reportCheck(state: ShotPathsState, done: ShotPathsCheck): ()
	local sim = done.sim
	local predicted = done.result
	local realPots: { [any]: boolean } = {}
	for _, event in sim.Events do
		if event.Kind == "Pocketed" and event.Ball ~= nil then
			realPots[event.Ball] = true
		end
	end
	local predictedList: { number } = {}
	local realList: { number } = {}
	local worst = 0
	local worstBall: number? = nil
	for _, path in predicted.paths do
		local number = path.number
		local real = sim.Balls[number]
		local realPotted = realPots[number] == true or (real ~= nil and real.Pocketed == true)
		if path.pocketed then
			table.insert(predictedList, number)
		end
		if realPotted then
			table.insert(realList, number)
		end
		if real ~= nil and not path.pocketed and not realPotted then
			local gap = (real.Position - path.final).Magnitude
			if gap > worst then
				worst = gap
				worstBall = number
			end
		end
	end
	table.sort(predictedList)
	table.sort(realList)
	local predictedText = table.concat(predictedList, ", ")
	local realText = table.concat(realList, ", ")
	local verdict = if predictedText == realText and worst <= ShotPathsConfig.CHECK_GAP
		then "MATCH"
		else "DIFFERENT"
	local worstText = if worstBall ~= nil then ` (ball {worstBall})` else ""
	ShotPaths.log.info(
		string.format(
			"shot check: %s | in predicted {%s} real {%s} | largest gap %.4f in%s | %d steps, %.1f ms",
			verdict,
			predictedText,
			realText,
			worst,
			worstText,
			predicted.steps,
			predicted.ms
		)
	)
end

-- Test check on or off: predicts each shot on a table the game aims on before it is played
function ShotPaths.setChecking(state: ShotPathsState, on: boolean): ()
	state.checking = on
	state.check = nil
	local hooks = state.hooks
	if state.checkListener ~= nil then
		Shots.unlisten(hooks, "Shoot", "ShotPaths", state.checkListener)
		state.checkListener = nil
	end
	if not on then
		return
	end
	local listener = function(sim: any, direction: any, power: any, spin: any): ()
		if state.destroyed or not hooks.live.seenSims[sim] or typeof(direction) ~= "Vector2" then
			return
		end
		local spinValue = if typeof(spin) == "Vector2" then spin else Vector2.zero
		local powerValue = if type(power) == "number" then power else 0
		local result =
			Shots.play(hooks, state.refs, sim, direction, powerValue, spinValue, true, false)
		state.check = if result ~= nil then { sim = sim, result = result, moving = false } else nil
	end
	state.checkListener = listener
	Shots.listen(hooks, "Shoot", "ShotPaths", listener)
end

-- ============ Page ============

-- Copies the saved options that are valid into `data` (Shared.Settings)
function ShotPaths.validate(decoded: { [any]: any }, data: any): ()
	for _, key in { "enabled", "opponent", "pocketColours" } do
		if type(decoded[key]) == "boolean" then
			data[key] = decoded[key]
		end
	end
	local thickness = decoded.thickness
	if type(thickness) == "number" and thickness == thickness then
		data.thickness = math.clamp(
			math.round(thickness),
			ShotPathsConfig.THICKNESS_MIN,
			ShotPathsConfig.THICKNESS_MAX
		)
	end
end

-- The page. Rows only change options; the work is in update / paint above.
function ShotPaths.buildPage(menu: CornyMenuObject): CornyMenuPage
	local palette = CornyMenu.palette
	-- an older Shot Paths page is torn down in here (its onDestroy runs)
	local page = menu:page(ShotPathsConfig.PAGE, {
		description = "Shows where every ball goes for the shot you are lining up.",
	})
	ShotPaths.state = nil

	local saved: ShotPathsSaved = {
		enabled = true,
		opponent = true,
		pocketColours = true,
		thickness = ShotPathsConfig.THICKNESS_DEFAULT,
	}
	local settings =
		newSettings(Game.files, ShotPathsConfig.SAVE_FILE, saved, ShotPaths.validate, ShotPaths.log)
	settings:load()
	page:onDestroy(function(): ()
		settings:flush()
	end)

	page:header("Paths")
	page:toggle("Show shot paths", saved.enabled, function(on: boolean): ()
		saved.enabled = on
		settings:save()
	end, {
		description = "Draws where every ball goes for the shot you are lining up: its path, a "
			.. "ring where it stops and a dot in the pocket it drops into.",
	})
	page:toggle("On your opponent's aim", saved.opponent, function(on: boolean): ()
		saved.opponent = on
		settings:save()
	end, {
		description = "Also draws the paths while your opponent lines up a shot.",
	})
	page:toggle("Colour the pocket dots", saved.pocketColours, function(on: boolean): ()
		saved.pocketColours = on
		settings:save()
	end, {
		description = "A pocket dot is green when one of your balls goes in, and red for your "
			.. "opponent's ball, the 8 too early or the cue ball.",
	})
	page:slider("Line thickness", saved.thickness, function(value: number): ()
		saved.thickness = value
		settings:save()
	end, {
		min = ShotPathsConfig.THICKNESS_MIN,
		max = ShotPathsConfig.THICKNESS_MAX,
		step = 1,
		description = "How thick the path lines are.",
	})
	local label = page:label(ShotPathsConfig.IDLE_TEXT)

	local found, refs = try(Game.get)
	if not found then
		ShotPaths.log.warn(`the pool table was not found: {refs}`)
		label:set("Could not find the pool table - rejoin, then run this again", palette.bad)
		return page
	end
	local hooks, problem = Shots.install(refs)
	if hooks == nil then
		if problem == "old" then
			ShotPaths.log.warn("an older build hooked the game this session: rejoin first")
			label:set("Rejoin the game, then run this again", palette.bad)
		else
			ShotPaths.log.warn(`could not hook the aim guide: {problem}`)
			label:set("Shot paths do not work here - see F9", palette.bad)
		end
		return page
	end

	local state: ShotPathsState = {
		destroyed = false,
		refs = refs,
		hooks = hooks,
		saved = saved,
		layer = nil,
		label = label,
		labelText = ShotPathsConfig.IDLE_TEXT,
		labelColour = nil,
		owner = {
			known = false,
			group = nil,
			opponent = false,
			seat = nil,
			onEight = false,
			phase = nil,
		},
		key = nil,
		result = nil,
		verdicts = {},
		summary = ShotPathsConfig.IDLE_TEXT,
		summaryColour = nil,
		root = nil,
		visible = false,
		checking = false,
		check = nil,
		checkListener = nil,
		failed = false,
		warned = {},
	}
	ShotPaths.state = state
	state.layer = page:overlay(function(draw: CornyMenuDraw): ()
		ShotPaths.paint(state, draw)
	end, { visible = false })
	page:track(RunService.RenderStepped:Connect(function(): ()
		local ok, err = tryTraced(ShotPaths.update, state)
		if not ok then
			ShotPaths.warnOnce(state, `could not follow the aim: {err}`)
		end
	end))
	page:onDestroy(function(): ()
		state.destroyed = true
		ShotPaths.setChecking(state, false)
		if ShotPaths.state == state then
			ShotPaths.state = nil
		end
	end)
	return page
end

-- Test tools in a "Test" submenu: the standalone test build always adds it, the full Corny
-- script only when getgenv().CornyDev is true
function ShotPaths.buildTests(page: CornyMenuPage): ()
	local tests = page:submenu("Test", {
		description = "Tools for testing this feature in game.",
	})
	tests:toggle("Check each shot in F9", false, function(on: boolean): ()
		local state = ShotPaths.state
		if state ~= nil then
			ShotPaths.setChecking(state, on)
		end
	end, {
		description = "After every shot, prints whether the balls stopped where the paths said.",
	})
	tests:button("Print the shown prediction to F9", function(): ()
		local state = ShotPaths.state
		if state == nil then
			ShotPaths.log.info("the page has no hooks (see the lines above)")
			return
		end
		for _, line in ShotPaths.describeState(state) do
			ShotPaths.log.info(line)
		end
	end, { description = "Prints the aim, whose balls are whose and every path to the console." })
	tests:button("Dump the shown prediction to a file", function(): ()
		local state = ShotPaths.state
		if state == nil then
			ShotPaths.log.info("the page has no hooks (see the lines above)")
			return
		end
		local text = table.concat(ShotPaths.describeState(state), "\n") .. "\n"
		local ok, err = Game.files:write(ShotPathsConfig.DEBUG_FILE, text)
		if ok then
			ShotPaths.log.info(
				`wrote {Game.files:path(ShotPathsConfig.DEBUG_FILE)} in Volt's workspace`
			)
		else
			ShotPaths.log.warn(`could not write {err}`)
		end
	end, {
		description = `Writes the same to {Game.files:path(ShotPathsConfig.DEBUG_FILE)} in Volt's `
			.. "workspace folder.",
	})
end
--#endregion Feature.ShotPaths

--#region Feature.ShotHelper (the full Corny script copies this region unchanged)
--[[ ShotHelper (CornyMenu page "Shot Helper"): the user, 2026-10-05: "will tell you if your
	 currently aimed shot will hit a ball into a pocket, and at what strength". They picked a band
	 on the power meter as the display.

	 How it works:
	   1. Shared.Shots keeps the aim guide on screen (direction, spin, the table) and the rules.
	   2. Once your aim holds still for a frame (a new aim, spin or ball position), it plays the
	      aimed shot on a copy of the table at every 2.5% of power (Shots.play, quick mode), then
	      narrows every change of result to 1% (the meter shows whole percents). Each try is
	      judged by the game's own referee (Shots.judge): good when you play again (one of yours
	      in, or the 8 legally: a win); bad when it is a foul (the cue ball, a wrong first hit, no
	      rail) or loses; none when the turn simply passes. The work is spread over frames (a few
	      ms each) and dropped as soon as the aim it was for is gone.
	   3. The page's overlay draws a green band beside the game's power meter over the good
	      strengths and a red one over the bad, while your aim guide or your charge shows. The
	      band follows the meter's cue picture (the HUD's PowerCue): the game slides it down by
	      power x (1 - its height share) of the meter (PoolHudRenderer.SetPower: half the meter,
	      so 100% puts its tip at the middle), so a strength is marked where the cue's tip sits
	      when you charge to it. Without that picture: power is how far down the whole meter
	      (PoolHudRenderer.PowerFromPosition, where a press on the meter sets it).
	 Game rules it relies on:
	   - The power the meter shows is the power the shot is played with; the server clamps it to
	     Input.MinimumPower..1 [dump].
	 Read only: it sends nothing and changes nothing in the game. ]]
local ShotHelperConfig = table.freeze({
	PAGE = "Shot Helper", -- page name
	STATUS_ID = "shothelper", -- watermark segment id (not used: nothing runs in the background)
	LOG_PREFIX = "[ShotHelper]",
	-- files go in this game's folder of Volt's workspace, Corny/<KEY>/ (Game.files, Shared.Files;
	-- docs/WORKSPACE_FILES.md), never anywhere else
	SAVE_FILE = "shothelper.json", -- the page's options
	DEBUG_FILE = "debug/shothelper.txt", -- the Test submenu's dump of the last strengths
	COARSE_STEP = 0.025, -- first pass: a try every 2.5% of power
	FINE_STEP = 0.01, -- every change of result narrowed to 1% (the meter shows whole percents)
	BUDGET = 0.006, -- seconds of tries per frame before the game gets the frame back
	BAND_GAP = 3, -- pixels between the power meter and the band
	BAND_WIDTH = 6, -- pixels
	BAND_OPACITY = 0.85,
	GOOD = Color3.fromRGB(90, 220, 110), -- one of your balls goes in
	BAD = Color3.fromRGB(235, 75, 65), -- a foul or a loss
	IDLE_TEXT = "Aim a shot to see which strengths pot a ball",
	WORKING_TEXT = "Working out the strengths...",
	OFF_TEXT = "The power meter marks are off",
})

-- The page's options, saved in SAVE_FILE
type ShotHelperSaved = {
	enabled: boolean, -- mark the strengths that pot one of your balls
	markBad: boolean, -- also mark the bad ones
}

-- One try: a power and what it does ("good" | "bad" | "none") with your balls that go in
type ShotHelperSample = { power: number, class: string, balls: { number } }

-- A stretch of the meter with one result
type ShotHelperSegment = { from: number, to: number, class: string, balls: { number } }

-- The strengths of one aim, worked out over a few frames
type ShotHelperJob = {
	key: string,
	sim: any, -- the game's table (untyped game table)
	rules: any?, -- its PoolRules match (untyped game table)
	direction: Vector2,
	spin: Vector2,
	owner: ShotsOwner,
	samples: { ShotHelperSample },
	segments: { ShotHelperSegment },
	done: boolean,
	running: boolean, -- its worker is still going (a worker stops when its aim goes away)
	ms: number, -- time spent playing shots
	tries: number,
}

type ShotHelperState = {
	destroyed: boolean, -- the page was replaced (a re-run) or the menu unloaded
	refs: GameRefs,
	hooks: ShotsHooks,
	saved: ShotHelperSaved,
	layer: CornyMenuLayer?,
	label: CornyMenuOption?,
	labelText: string,
	labelColour: Color3?,
	job: ShotHelperJob?, -- the aim being worked out, or the last one done
	shownKey: string?, -- the aim on screen now (nil when none): work for any other aim stops
	lastKey: string?, -- the aim seen the frame before (work starts once it holds still)
	track: any?, -- the power meter (the HUD's PowerTrack, one of the game's GuiObjects)
	cue: any?, -- the meter's cue picture (the HUD's PowerCue, a Frame holding its Icon)
	visible: boolean,
	warned: { [string]: boolean },
}

local ShotHelper = {
	log = newLogger(ShotHelperConfig.LOG_PREFIX),
	state = nil :: ShotHelperState?, -- the live page's state (the Test submenu reads it)
}

function ShotHelper.warnOnce(state: ShotHelperState, message: string): ()
	if state.warned[message] then
		return
	end
	state.warned[message] = true
	ShotHelper.log.warn(message)
end

-- ============ Strengths ============

-- What one try does for you, with your balls that go in: the game's referee when the rules are
-- known, else your balls, the cue ball and the first hit
function ShotHelper.classify(
	state: ShotHelperState,
	job: ShotHelperJob,
	result: ShotsResult
): (string, { number })
	local refs = state.refs
	local cue = Shots.cueNumber(refs)
	local eight = Shots.eightNumber(refs)
	local verdict = Shots.judge(refs, job.rules, job.sim, result)
	if verdict ~= nil then
		if verdict.winner ~= nil then
			return if verdict.winner == verdict.shooter then "good" else "bad", { eight }
		end
		if verdict.rerack or not verdict.legal then
			return "bad", {}
		end
		if not verdict.continues then
			return "none", {}
		end
		local balls: { number } = {}
		for _, number in result.potted do
			if number == cue or number == eight then
				continue
			end
			local ballGroup = if number < eight then "Solid" else "Stripe"
			if verdict.group == nil or ballGroup == verdict.group then
				table.insert(balls, number)
			end
		end
		table.sort(balls)
		return "good", balls
	end
	local cueIn = table.find(result.potted, cue) ~= nil
	if cueIn or Shots.isLegalFirst(state.hooks, job.sim, result.firstHit) == false then
		return "bad", {}
	end
	local balls: { number } = {}
	for _, number in result.potted do
		local verdictOf = Shots.verdictOf(refs, job.owner, number, cueIn)
		local isYours = verdictOf == "yours"
		local isNotYours = verdictOf == "not"
		if number == eight and not isYours then
			return "bad", {} -- the 8 too early loses the game
		end
		if not isNotYours then
			table.insert(balls, number)
		end
	end
	if #balls > 0 then
		table.sort(balls)
		return "good", balls
	end
	return "none", {}
end

-- One try at `power`
function ShotHelper.try(state: ShotHelperState, job: ShotHelperJob, power: number): ShotHelperSample
	local refs = state.refs
	local clampedPower, spin = Shots.clamp(refs, power, job.spin)
	local result =
		Shots.play(state.hooks, refs, job.sim, job.direction, clampedPower, spin, false, true)
	job.tries += 1
	if result == nil then
		return { power = power, class = "none", balls = {} }
	end
	job.ms += result.ms
	local class, balls = ShotHelper.classify(state, job, result)
	return { power = power, class = class, balls = balls }
end

-- Stretches of the meter from the tries (each change of result sits between two tries)
function ShotHelper.segmentsOf(samples: { ShotHelperSample }): { ShotHelperSegment }
	local segments: { ShotHelperSegment } = {}
	for index, sample in samples do
		local from = if index == 1 then 0 else (samples[index - 1].power + sample.power) / 2
		local to = if index == #samples then 1 else (sample.power + samples[index + 1].power) / 2
		local last = segments[#segments]
		if last ~= nil and last.class == sample.class then
			last.to = to
			for _, number in sample.balls do
				if table.find(last.balls, number) == nil then
					table.insert(last.balls, number)
				end
			end
		else
			table.insert(
				segments,
				{ from = from, to = to, class = sample.class, balls = table.clone(sample.balls) }
			)
		end
	end
	return segments
end

-- Works out one aim's strengths, a few ms per frame; stops when the aim it is for is gone
function ShotHelper.work(state: ShotHelperState, job: ShotHelperJob): ()
	local sliceStart = os.clock()
	local function still(): boolean
		if os.clock() - sliceStart > ShotHelperConfig.BUDGET then
			task.wait()
			sliceStart = os.clock()
		end
		return not state.destroyed and state.job == job and state.shownKey == job.key
	end

	local samples: { ShotHelperSample } = {}
	local power = 0
	while power < 1 - 1e-6 do
		power = math.min(1, power + ShotHelperConfig.COARSE_STEP)
		table.insert(samples, ShotHelper.try(state, job, power))
		if not still() then
			return
		end
	end
	-- narrow every change of result down to FINE_STEP
	local index = 1
	while index < #samples do
		local low = samples[index]
		local high = samples[index + 1]
		if
			low.class ~= high.class
			and high.power - low.power > ShotHelperConfig.FINE_STEP + 1e-6
		then
			local middle = math.round((low.power + high.power) / 2 / ShotHelperConfig.FINE_STEP)
				* ShotHelperConfig.FINE_STEP
			if middle <= low.power + 1e-6 or middle >= high.power - 1e-6 then
				index += 1
				continue
			end
			table.insert(samples, index + 1, ShotHelper.try(state, job, middle))
			if not still() then
				return
			end
		else
			index += 1
		end
	end
	job.samples = samples
	job.segments = ShotHelper.segmentsOf(samples)
	job.done = true
end

-- "35-60%" for a segment
function ShotHelper.range(segment: ShotHelperSegment): string
	local from = math.clamp(math.round(segment.from * 100), 0, 100)
	local to = math.clamp(math.round(segment.to * 100), 0, 100)
	return if from == to then `{from}%` else `{from}-{to}%`
end

function ShotHelper.joinWithAnd(words: { string }): string
	if #words <= 1 then
		return words[1] or ""
	end
	return `{table.concat(words, ", ", 1, #words - 1)} and {words[#words]}`
end

-- The status line for one aim's strengths: each good stretch with what goes in there
function ShotHelper.describe(job: ShotHelperJob): (string, Color3)
	local palette = CornyMenu.palette
	local parts: { string } = {}
	local anyNone = false
	for _, segment in job.segments do
		if segment.class == "good" then
			table.sort(segment.balls)
			local names: { string } = {}
			for _, number in segment.balls do
				table.insert(names, tostring(number))
			end
			local what = if #names > 0 then ShotHelper.joinWithAnd(names) else "it"
			local verb = if #names == 1 or #names == 0 then "goes" else "go"
			if #parts == 0 then
				table.insert(parts, `{what} {verb} in at {ShotHelper.range(segment)}`)
			else
				table.insert(parts, `{what} at {ShotHelper.range(segment)}`)
			end
		elseif segment.class == "none" then
			anyNone = true
		end
	end
	if #parts > 0 then
		return table.concat(parts, ", "), palette.good
	end
	if not anyNone then
		return "Every strength is a foul or loses the game", palette.bad
	end
	return "Nothing of yours goes in at any strength", palette.subtext
end

-- ============ Every frame ============

function ShotHelper.say(state: ShotHelperState, text: string, colour: Color3?): ()
	if text == state.labelText and colour == state.labelColour then
		return
	end
	state.labelText = text
	state.labelColour = colour
	local label = state.label
	if label ~= nil then
		label:set(text, colour or CornyMenu.palette.subtext)
	end
end

-- Follows your aim: starts working out an aim's strengths once it holds still, shows or hides
-- the band
function ShotHelper.update(state: ShotHelperState): ()
	if state.destroyed then
		return
	end
	local hooks = state.hooks
	local refs = state.refs
	local aim = hooks.live.aim
	local controller = hooks.live.controller
	local showing = false
	local shownJob: ShotHelperJob? = nil
	local shownKey: string? = nil
	if
		state.saved.enabled
		and aim ~= nil
		and aim.overlay ~= nil
		and type(controller) == "table"
	then
		local ok, shown = try(refs.aim.IsAimShown, aim.overlay)
		local hud = controller.Hud
		local track = if type(hud) == "table" then hud.PowerTrack else nil
		if
			ok
			and shown == true
			and controller.Simulation == aim.sim
			and not controller.Muted
			and Shots.isOnScreen(track)
		then
			local owner = Shots.ownerOf(hooks, refs, aim.sim)
			if not owner.opponent then
				local key = string.format(
					"%.6f,%.6f,%.6f,%.6f,%s,%s,%s,%s|%s",
					aim.direction.X,
					aim.direction.Y,
					aim.spin.X,
					aim.spin.Y,
					tostring(owner.known),
					tostring(owner.group),
					tostring(owner.onEight),
					tostring(owner.phase),
					Shots.tableKey(aim.sim)
				)
				shownKey = key
				state.track = track
				state.cue = hud.PowerCue
				local current = state.job
				if current ~= nil and current.key == key and (current.done or current.running) then
					shownJob = current
					showing = current.done
				elseif state.lastKey == key then
					-- (an aim that went away and came back: its worker stopped, so it starts again)
					-- the aim held still for a frame: work it out
					local fresh: ShotHelperJob = {
						key = key,
						sim = aim.sim,
						rules = Shots.rulesOf(hooks, refs, aim.sim),
						direction = aim.direction,
						spin = aim.spin,
						owner = owner,
						samples = {},
						segments = {},
						done = false,
						running = true,
						ms = 0,
						tries = 0,
					}
					state.job = fresh
					state.shownKey = key
					task.spawn(function(): ()
						local worked, err = tryTraced(ShotHelper.work, state, fresh)
						fresh.running = false
						if not worked then
							ShotHelper.warnOnce(state, `could not work out the strengths: {err}`)
						end
					end)
					shownJob = fresh
				end
			end
		end
	end
	state.shownKey = shownKey
	state.lastKey = shownKey
	if showing ~= state.visible then
		state.visible = showing
		local layer = state.layer
		if layer ~= nil then
			layer:setVisible(showing)
			layer:setAnimated(showing)
		end
	end
	if not state.saved.enabled then
		ShotHelper.say(state, ShotHelperConfig.OFF_TEXT, nil)
	elseif shownKey == nil then
		ShotHelper.say(state, ShotHelperConfig.IDLE_TEXT, nil)
	elseif shownJob == nil or not shownJob.done then
		ShotHelper.say(state, ShotHelperConfig.WORKING_TEXT, nil)
	else
		local text, colour = ShotHelper.describe(shownJob)
		ShotHelper.say(state, text, colour)
	end
end

-- Where power 0 sits on screen and how many pixels down 100% is: the tip of the meter's cue
-- picture, as PoolHudRenderer.SetPower moves it (its frame's top at power x (1 - its height
-- share) of the meter); the whole meter when the picture is not there
function ShotHelper.meterScale(
	state: ShotHelperState,
	origin: Vector2,
	size: Vector2
): (number, number)
	local cue: any = state.cue
	if typeof(cue) ~= "Instance" or not cue:IsA("GuiObject") or cue.Parent ~= state.track then
		return origin.Y, size.Y
	end
	local share = cue.Size.Y.Scale
	if share < 0 or share >= 1 then
		return origin.Y, size.Y
	end
	local icon = cue:FindFirstChild("Icon")
	local picture: any = if icon ~= nil and icon:IsA("GuiObject") then icon else cue
	-- the frame's top at power 0 is the meter's top; the picture's tip sits this far below it
	local tip = picture.AbsolutePosition.Y - cue.AbsolutePosition.Y
	return origin.Y + tip, (1 - share) * size.Y
end

-- The overlay painter (runs on the menu's frame loop; must not yield): the band beside the meter
function ShotHelper.paint(state: ShotHelperState, draw: CornyMenuDraw): ()
	local job = state.job
	local track: any = state.track -- the game's PowerTrack frame
	if not state.visible or job == nil or not job.done or not Shots.isOnScreen(track) then
		return
	end
	local size: Vector2 = track.AbsoluteSize
	if size.Y <= 0 then
		return
	end
	local origin: Vector2 = track.AbsolutePosition + Shots.guiService:GetGuiInset()
	local x = origin.X + size.X + ShotHelperConfig.BAND_GAP
	local zero, travel = ShotHelper.meterScale(state, origin, size)
	local bottom = origin.Y + size.Y
	for _, segment in job.segments do
		local colour: Color3? = nil
		if segment.class == "good" then
			colour = ShotHelperConfig.GOOD
		elseif segment.class == "bad" and state.saved.markBad then
			colour = ShotHelperConfig.BAD
		end
		if colour ~= nil then
			local top = math.clamp(zero + segment.from * travel, origin.Y, bottom)
			local height = math.max(2, math.min(bottom, zero + segment.to * travel) - top)
			draw:rect(
				x,
				top,
				ShotHelperConfig.BAND_WIDTH,
				height,
				colour,
				ShotHelperConfig.BAND_OPACITY
			)
		end
	end
end

-- ============ Test helpers ============

function ShotHelper.describeState(state: ShotHelperState): { string }
	local lines: { string } = {}
	local job = state.job
	if job == nil then
		table.insert(lines, "no aim worked out yet")
		return lines
	end
	local owner = job.owner
	table.insert(
		lines,
		`rules known: {job.rules ~= nil}, your group: {owner.group or "none"}, on the 8: {owner.onEight},`
			.. ` done: {job.done}`
	)
	table.insert(
		lines,
		string.format(
			"aim (%.4f, %.4f), spin (%.2f, %.2f): %d tries, %.1f ms playing",
			job.direction.X,
			job.direction.Y,
			job.spin.X,
			job.spin.Y,
			job.tries,
			job.ms
		)
	)
	local track: any = state.track
	if Shots.isOnScreen(track) then
		local origin: Vector2 = track.AbsolutePosition + Shots.guiService:GetGuiInset()
		local size: Vector2 = track.AbsoluteSize
		local zero, travel = ShotHelper.meterScale(state, origin, size)
		table.insert(
			lines,
			string.format(
				"meter: top %.0f px, %.0f px tall; 0%% at %.0f px, 100%% at %.0f px (cue picture: %s)",
				origin.Y,
				size.Y,
				zero,
				zero + travel,
				tostring(state.cue ~= nil and travel ~= size.Y)
			)
		)
	end
	for _, sample in job.samples do
		local balls = if #sample.balls > 0 then ` ({table.concat(sample.balls, ", ")})` else ""
		table.insert(
			lines,
			string.format("%3d%%: %s%s", math.round(sample.power * 100), sample.class, balls)
		)
	end
	if job.done then
		local text = ShotHelper.describe(job)
		table.insert(lines, `shown: {text}`)
	end
	return lines
end

-- ============ Page ============

-- Copies the saved options that are valid into `data` (Shared.Settings)
function ShotHelper.validate(decoded: { [any]: any }, data: any): ()
	for _, key in { "enabled", "markBad" } do
		if type(decoded[key]) == "boolean" then
			data[key] = decoded[key]
		end
	end
end

-- The page. Rows only change options; the work is in update / work / paint above.
function ShotHelper.buildPage(menu: CornyMenuObject): CornyMenuPage
	local palette = CornyMenu.palette
	-- an older Shot Helper page is torn down in here (its onDestroy runs)
	local page = menu:page(ShotHelperConfig.PAGE, {
		description = "Shows on the power meter which strengths pot one of your balls.",
	})
	ShotHelper.state = nil

	local saved: ShotHelperSaved = { enabled = true, markBad = true }
	local settings = newSettings(
		Game.files,
		ShotHelperConfig.SAVE_FILE,
		saved,
		ShotHelper.validate,
		ShotHelper.log
	)
	settings:load()
	page:onDestroy(function(): ()
		settings:flush()
	end)

	page:header("Power meter")
	page:toggle("Mark strengths that pot a ball", saved.enabled, function(on: boolean): ()
		saved.enabled = on
		settings:save()
	end, {
		description = "Puts a green band beside the power meter over every strength that pots one "
			.. "of your balls with the shot you are aiming.",
	})
	page:toggle("Mark bad strengths", saved.markBad, function(on: boolean): ()
		saved.markBad = on
		settings:save()
	end, {
		description = "Adds a red band where the shot would be a foul (the cue ball goes in, the "
			.. "wrong ball first, no cushion) or would lose the game.",
	})
	local label = page:label(ShotHelperConfig.IDLE_TEXT)

	local found, refs = try(Game.get)
	if not found then
		ShotHelper.log.warn(`the pool table was not found: {refs}`)
		label:set("Could not find the pool table - rejoin, then run this again", palette.bad)
		return page
	end
	if refs.geometry == nil then
		label:set("The shot helper does not work with this version of the game", palette.bad)
		return page
	end
	local hooks, problem = Shots.install(refs)
	if hooks == nil then
		if problem == "old" then
			ShotHelper.log.warn("an older build hooked the game this session: rejoin first")
			label:set("Rejoin the game, then run this again", palette.bad)
		else
			ShotHelper.log.warn(`could not hook the aim guide: {problem}`)
			label:set("The shot helper does not work here - see F9", palette.bad)
		end
		return page
	end

	local state: ShotHelperState = {
		destroyed = false,
		refs = refs,
		hooks = hooks,
		saved = saved,
		layer = nil,
		label = label,
		labelText = ShotHelperConfig.IDLE_TEXT,
		labelColour = nil,
		job = nil,
		shownKey = nil,
		lastKey = nil,
		track = nil,
		cue = nil,
		visible = false,
		warned = {},
	}
	ShotHelper.state = state
	state.layer = page:overlay(function(draw: CornyMenuDraw): ()
		ShotHelper.paint(state, draw)
	end, { visible = false })
	page:track(RunService.RenderStepped:Connect(function(): ()
		local ok, err = tryTraced(ShotHelper.update, state)
		if not ok then
			ShotHelper.warnOnce(state, `could not follow the aim: {err}`)
		end
	end))
	page:onDestroy(function(): ()
		state.destroyed = true
		state.job = nil
		if ShotHelper.state == state then
			ShotHelper.state = nil
		end
	end)
	return page
end

-- Test tools in a "Test" submenu: the standalone test build always adds it, the full Corny
-- script only when getgenv().CornyDev is true
function ShotHelper.buildTests(page: CornyMenuPage): ()
	local tests = page:submenu("Test", {
		description = "Tools for testing this feature in game.",
	})
	tests:button("Print the strengths to F9", function(): ()
		local state = ShotHelper.state
		if state == nil then
			ShotHelper.log.info("the page has no hooks (see the lines above)")
			return
		end
		for _, line in ShotHelper.describeState(state) do
			ShotHelper.log.info(line)
		end
	end, { description = "Prints every strength tried for the shown aim and what it does." })
	tests:button("Dump the strengths to a file", function(): ()
		local state = ShotHelper.state
		if state == nil then
			ShotHelper.log.info("the page has no hooks (see the lines above)")
			return
		end
		local text = table.concat(ShotHelper.describeState(state), "\n") .. "\n"
		local ok, err = Game.files:write(ShotHelperConfig.DEBUG_FILE, text)
		if ok then
			ShotHelper.log.info(
				`wrote {Game.files:path(ShotHelperConfig.DEBUG_FILE)} in Volt's workspace`
			)
		else
			ShotHelper.log.warn(`could not write {err}`)
		end
	end, {
		description = `Writes the same to {Game.files:path(ShotHelperConfig.DEBUG_FILE)} in Volt's `
			.. "workspace folder.",
	})
end
--#endregion Feature.ShotHelper

--#region Feature.AutoAim (the full Corny script copies this region unchanged)
--[[ AutoAim (CornyMenu page "Auto-Aim"): the user, 2026-10-05: "a realistic autoaim that aims
	 for the best shot (combos are allowed; try to pocket most balls possible)". They picked: it
	 shoots by itself, with a human-like glide, when they press its key. 2026-10-06: "Make AutoAim
	 more advanced; I want it to be able to use banks, hit trickshots, etc." (Shared.Cue's
	 search: banks, kicks, the open search, spin, the trickshot mode's targets).

	 How a shot works: Shared.Cue (searched and played the way its notes say: every kind of line
	 tried on copies of the table and judged by the game's own referee, the best one aimed with an
	 eased sweep like the game's bot, charged and released the way the game does on mouse
	 release). This page only starts it: the key (or the button) on your turn; the key again while
	 it aims picks the next best shot; the cancel key or moving the mouse more than 24 px stops it
	 before it shoots, a click hands you the shot. With the ball in hand after a scratch it asks
	 you to place the cue ball first. "Thinking time" bounds the search.
	 Game rules it relies on:
	   - The server plays the shot with the same physics from the same table [dump].
	   - Offline against the bot you are seat 1; the bot aims with your cue [dump]. ]]
local AutoAimConfig = table.freeze({
	PAGE = "Auto-Aim", -- page name, also its Shared.Cue owner name
	STATUS_ID = "autoaim", -- watermark segment id while it plays a shot
	PROMPT_ID = "autoaim", -- key hints while it plays a shot
	LOG_PREFIX = "[AutoAim]",
	-- files go in this game's folder of Volt's workspace, Corny/<KEY>/ (Game.files, Shared.Files;
	-- docs/WORKSPACE_FILES.md), never anywhere else
	SAVE_FILE = "autoaim.json", -- the keys and the thinking time
	DEBUG_FILE = "debug/autoaim.txt", -- the Test submenu's dump of the last plan
	-- free keys: the game binds Space, Q, E, R, T, W, S, digits, arrows, Shift, Ctrl, Tab and
	-- Enter (2026-10-05 dump)
	SHOOT_KEY = "F",
	CANCEL_KEY = "X",
	THINK_DEFAULT = 6, -- seconds it may think about a shot (the page's "Thinking time")
	THINK_MIN = 2,
	THINK_MAX = 15,
})

-- The page's options, saved in SAVE_FILE: the keys, as KeyCode names ("" = none), and the
-- thinking time in seconds
type AutoAimSaved = { shootKey: string, cancelKey: string, think: number }

type AutoAimState = {
	destroyed: boolean, -- the page was replaced (a re-run) or the menu unloaded
	saved: AutoAimSaved,
	cue: Cue,
}

local AutoAim = {
	log = newLogger(AutoAimConfig.LOG_PREFIX),
	state = nil :: AutoAimState?, -- the live page's state (the Test submenu reads it)
}

-- A KeyCode from its saved name; nil for none or a name the game does not have
function AutoAim.keyCode(name: string): Enum.KeyCode?
	if name == "" then
		return nil
	end
	local ok, key = pcall(function(): any
		return (Enum.KeyCode :: any)[name]
	end)
	if ok and typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
		return (key :: any) :: Enum.KeyCode
	end
	return nil
end

function AutoAim.keyText(name: string): string
	return if name == "" then "?" else name
end

-- What the page says while nothing is going on
function AutoAim.idleText(saved: AutoAimSaved): string
	if saved.shootKey == "" then
		return "Press Take the best shot on your turn"
	end
	return `Press {saved.shootKey} on your turn to take the best shot`
end

-- Copies the saved options that are valid into `data` (Shared.Settings)
function AutoAim.validate(decoded: { [any]: any }, data: any): ()
	for _, key in { "shootKey", "cancelKey" } do
		local name = decoded[key]
		if type(name) == "string" and (name == "" or AutoAim.keyCode(name) ~= nil) then
			data[key] = name
		end
	end
	local think = decoded.think
	if type(think) == "number" and think == think then
		data.think = math.clamp(math.round(think), AutoAimConfig.THINK_MIN, AutoAimConfig.THINK_MAX)
	end
end

-- The key (or the button): starts a shot, or picks the next best while it aims
function AutoAim.press(state: AutoAimState, menu: CornyMenuObject, label: CornyMenuOption): ()
	if state.destroyed then
		return
	end
	local cue = state.cue
	if cue:isPlanning() then
		label:set("Still finding the best shot", CornyMenu.palette.subtext)
		return
	end
	if cue:isBusy() then
		Cue.next(cue)
		return
	end
	local problem = Cue.start(cue, false)
	if problem ~= nil then
		label:set(problem, CornyMenu.palette.bad)
		menu:notify(problem, { title = AutoAimConfig.PAGE })
	end
end

-- The page. Rows only start, stop or change options; the work is in Shared.Cue.
function AutoAim.buildPage(menu: CornyMenuObject): CornyMenuPage
	local palette = CornyMenu.palette
	-- an older Auto-Aim page is torn down in here (its onDestroy runs)
	local page = menu:page(AutoAimConfig.PAGE, {
		description = "Finds the best shot on your turn, aims at it like a player and shoots it.",
	})
	AutoAim.state = nil

	local saved: AutoAimSaved = {
		shootKey = AutoAimConfig.SHOOT_KEY,
		cancelKey = AutoAimConfig.CANCEL_KEY,
		think = AutoAimConfig.THINK_DEFAULT,
	}
	local settings =
		newSettings(Game.files, AutoAimConfig.SAVE_FILE, saved, AutoAim.validate, AutoAim.log)
	settings:load()
	page:onDestroy(function(): ()
		settings:flush()
	end)

	page:header("Auto-Aim")
	local takeButton = page:button("Take the best shot", nil, {
		color = palette.good,
		description = "Finds the best shot on the table (straight pots, combos, banks, kicks and "
			.. "trick shots, as many of your balls as it can, with spin for the next shot), aims at "
			.. "it like a player and shoots. Your turn only. In trickshot puzzles it goes for the targets.",
	})
	page:keybind(
		"Take the best shot",
		AutoAim.keyCode(saved.shootKey),
		function(key: Enum.KeyCode?): ()
			saved.shootKey = if key ~= nil then key.Name else ""
			settings:save()
		end,
		{
			description = "Press it on your turn to take the best shot. Press it again while it aims "
				.. "for the next best shot.",
		}
	)
	page:keybind("Cancel", AutoAim.keyCode(saved.cancelKey), function(key: Enum.KeyCode?): ()
		saved.cancelKey = if key ~= nil then key.Name else ""
		settings:save()
	end, {
		description = "Stops it before it shoots. Moving the mouse does too; a click hands you the shot.",
	})
	page:slider("Thinking time", saved.think, function(value: number): ()
		saved.think = value
		settings:save()
	end, {
		min = AutoAimConfig.THINK_MIN,
		max = AutoAimConfig.THINK_MAX,
		step = 1,
		format = function(value: number): string
			return `{value} s`
		end,
		description = "How long it may look for the best shot. Longer finds harder shots like "
			.. "banks and kicks.",
	})
	local label = page:label(AutoAim.idleText(saved))

	local found, refs = try(Game.get)
	if not found then
		AutoAim.log.warn(`the pool table was not found: {refs}`)
		label:set("Could not find the pool table - rejoin, then run this again", palette.bad)
		takeButton:setEnabled(false)
		return page
	end
	local hooks, problem = Shots.install(refs)
	if hooks == nil then
		if problem == "old" then
			AutoAim.log.warn("an older build hooked the game this session: rejoin first")
			label:set("Rejoin the game, then run this again", palette.bad)
		else
			AutoAim.log.warn(`could not hook the cue: {problem}`)
			label:set("Auto-Aim does not work here - see F9", palette.bad)
		end
		takeButton:setEnabled(false)
		return page
	end

	local cue = newCue(hooks, refs, {
		owner = AutoAimConfig.PAGE,
		place = false,
		mouseRelease = true,
		showIndex = true,
		missChance = function(): number
			return 0
		end,
		thinkSeconds = function(): number
			return saved.think
		end,
		onPrompt = function(lines: { string }, withKeys: boolean): ()
			local keys: { CornyMenuKey } = {}
			if withKeys then
				table.insert(
					keys,
					{ key = AutoAim.keyText(saved.shootKey), text = "Next best shot" }
				)
				table.insert(keys, { key = AutoAim.keyText(saved.cancelKey), text = "Cancel" })
			end
			page:prompt(
				AutoAimConfig.PROMPT_ID,
				{ title = AutoAimConfig.PAGE, lines = lines, keys = keys }
			)
			page:status(AutoAimConfig.STATUS_ID, AutoAimConfig.PAGE, palette.good)
			local first = lines[1] or ""
			label:set(if withKeys then `Aiming: {first}` else first, palette.subtext)
		end,
		onEnd = function(text: string?, ok: boolean, shot: CueShot?, test: boolean): ()
			page:hidePrompt(AutoAimConfig.PROMPT_ID)
			page:status(AutoAimConfig.STATUS_ID, nil)
			local state = AutoAim.state
			if test then
				if state ~= nil then
					for _, line in Cue.describeJob(state.cue.lastJob) do
						AutoAim.log.info(line)
					end
				end
				label:set(AutoAim.idleText(saved), palette.subtext)
				return
			end
			if shot ~= nil then
				AutoAim.log.info(
					string.format(
						"played %s: line %s, power %.3f, spin (%.1f, %.1f), score %.1f, window %.2f deg",
						Cue.describeShot(shot),
						shot.line,
						shot.power,
						shot.spin.X,
						shot.spin.Y,
						shot.score,
						shot.robust
					)
				)
			end
			if text ~= nil then
				local colour = if ok then palette.good else palette.bad
				label:set(text, colour)
				-- a pop-up only when it did not shoot (you see the shot itself)
				if shot == nil then
					menu:notify(text, { title = AutoAimConfig.PAGE, color = colour })
				end
			end
		end,
	})
	local state: AutoAimState = { destroyed = false, saved = saved, cue = cue }
	AutoAim.state = state

	takeButton:onChange(function(): ()
		AutoAim.press(state, menu, label)
	end)
	page:track(
		UserInputService.InputBegan:Connect(function(input: InputObject, processed: boolean): ()
			if processed or state.destroyed then
				return
			end
			local keyCode = input.KeyCode
			if keyCode == AutoAim.keyCode(saved.shootKey) then
				AutoAim.press(state, menu, label)
			elseif keyCode == AutoAim.keyCode(saved.cancelKey) and cue:isBusy() then
				cue:stop("Cancelled", true)
			end
		end)
	)
	page:onDestroy(function(): ()
		state.destroyed = true
		cue:Destroy()
		if AutoAim.state == state then
			AutoAim.state = nil
		end
	end)
	return page
end

-- Test tools in a "Test" submenu: the standalone test build always adds it, the full Corny
-- script only when getgenv().CornyDev is true
function AutoAim.buildTests(page: CornyMenuPage): ()
	local tests = page:submenu("Test", {
		description = "Tools for testing this feature in game.",
	})
	tests:button("Find the best shot (no shooting)", function(): ()
		local state = AutoAim.state
		if state == nil then
			AutoAim.log.info("the page has no hooks (see the lines above)")
			return
		end
		local problem = Cue.start(state.cue, true)
		if problem ~= nil then
			AutoAim.log.info(problem)
		end
	end, { description = "Works out the shots for this table and prints the best ones to F9." })
	tests:button("Print the last plan to F9", function(): ()
		local state = AutoAim.state
		if state == nil then
			AutoAim.log.info("the page has no hooks (see the lines above)")
			return
		end
		for _, line in Cue.describeJob(state.cue.lastJob) do
			AutoAim.log.info(line)
		end
	end, { description = "Prints the shots of the last search, best first, and how long it took." })
	tests:button("Dump the last plan to a file", function(): ()
		local state = AutoAim.state
		if state == nil then
			AutoAim.log.info("the page has no hooks (see the lines above)")
			return
		end
		local text = table.concat(Cue.describeJob(state.cue.lastJob), "\n") .. "\n"
		local ok, err = Game.files:write(AutoAimConfig.DEBUG_FILE, text)
		if ok then
			AutoAim.log.info(
				`wrote {Game.files:path(AutoAimConfig.DEBUG_FILE)} in Volt's workspace`
			)
		else
			AutoAim.log.warn(`could not write {err}`)
		end
	end, {
		description = `Writes the same to {Game.files:path(AutoAimConfig.DEBUG_FILE)} in Volt's `
			.. "workspace folder.",
	})
end
--#endregion Feature.AutoAim

--#region Feature.AutoFarm (the full Corny script copies this region unchanged)
--[[ AutoFarm (CornyMenu page "Auto-Farm"): the user, 2026-10-05: "make an autofarm. It auto joins
	 rounds (highest match player can join), plays with best shots, missing sometimes but not
	 often, and repeats. Should win at least 90% of the time." 2026-10-06: "Fix all issues that
	 would prevent me from production use."

	 How a run works (until you press Stop), each step after a pause like a player's:
	   1. In the menu, once the game shows its venue list (from the home screen it opens the list
	      with the 1v1 card, the way a tap does; while neither shows, the game is still loading,
	      say after a server move, or between two screens, and it waits: a missing menu never
	      stops the run): the venue (the "Venue" choice: the highest one unlocked and affordable on
	      the game's venue picker, PoolVenueMenu Cards[i].Unlocked / Affordable, or the highest of
	      the ones that also fill with computer players, or one you pick) is picked the way tapping
	      it does (PoolVenueMenu.Choose, which fires the picker's Chosen event: the game checks
	      your coins and queues you, PoolMenuUIHandler ~1774). Joining is checked: the search
	      screen or a match must show within JOIN_WAIT; three failed tries in a row stop the run.
	      A friend challenge waiting on the picker stops it (the tap would challenge your friend).
	   2. While the game searches (its search screen shows) it waits; a match has begun when
	      PoolGameUI's MatchActive attribute is on.
	   3. In the match, on every turn of yours (Shared.Cue.whyNot): Shared.Cue searches the best
	      shot within the thinking time (judged by the game's own referee; a shot is always
	      played, so the game's AFK bot never takes your seat), places the cue ball itself with the
	      ball in hand, aims like a player and shoots. Now and then (the "misses" setting) it
	      misses on purpose, safely. A shot still going when the match ends is dropped.
	   4. When the result screen shows, it counts the win or loss (the screen's ViewerWon) and
	      presses the screen's leave button (its Activated event, as a click: the game declines a
	      rematch and goes back to the menu), then starts again at 1.
	 While it runs, Shared.AntiIdle keeps Roblox's idle kick away (no real input for 20 minutes).
	 When the game moves you to another server (a teleport), it waits; Shared.Relaunch runs the
	 full script again on the new server (the user, 2026-10-06: "make it so we reexecute Corny
	 upon arrival to new server. Especially for AutoFarm") and the farm carries on there with its
	 count (Relaunch.carry / take). It waits for the game's match screen (PoolGameUI) before it
	 picks anything, and only plays the game's matches (not the trickshot mode or the tutorial).
	 Stop ends it at once and gives you the cue back; a search going on is cancelled the way the
	 search screen's Cancel does (its CancelBindable), also when it shows just after Stop. A shot
	 already released finishes. When the result screen does not close after LEAVE_TRIES presses
	 of its leave button, the run stops and says so.
	 Game rules it relies on:
	   - The server covers a player with an AFK bot only after a whole turn with no shot (aims
	     only count with real input: PoolActivity) (PoolMatchSession IdleTurns, AfkTurnsBeforeCover
	     1): it shoots every turn [dump].
	   - After the game moves you to a match's server it shows its search screen as "Joining your
	     match" until the match starts, or the home screen after 25 s (PoolMenuUIHandler
	     showArrival); the venue list's cards are locked until your progress loads (the first
	     venue is always unlocked once it has: PoolVenueMenu.SetProgress) [dump].
	   - Venues unlock with 5 wins in the venue before (PoolConstants.VenueUnlockWins); Germany
	     matches only real players (Matchmaking "RealOnline"), the others fill with computer
	     players up to level 20 [dump]. ]]
local AutoFarmConfig = table.freeze({
	PAGE = "Auto-Farm", -- page name, also its Shared.Cue owner name
	STATUS_ID = "autofarm", -- watermark segment id while it runs
	PROMPT_ID = "autofarm", -- the shot it is playing
	LOG_PREFIX = "[AutoFarm]",
	-- files go in this game's folder of Volt's workspace, Corny/<KEY>/ (Game.files, Shared.Files;
	-- docs/WORKSPACE_FILES.md), never anywhere else
	SAVE_FILE = "autofarm.json", -- the page's options
	DEBUG_FILE = "debug/autofarm.txt", -- the Test submenu's dump
	MISS_DEFAULT = 8, -- percent of shots it misses on purpose (safely); the user: "not often"
	MISS_MAX = 25,
	THINK_DEFAULT = 6, -- seconds it may think about a shot (turns last 40 s: Rules.DefaultTurnTime)
	THINK_MIN = 2,
	THINK_MAX = 12,
	VENUE_DEFAULT = "best", -- "best", "quick" or a venue's Id
	-- pauses like a player's (seconds)
	MENU_MIN = 1.5, -- before it picks a venue
	MENU_MAX = 3.5,
	TURN_MIN = 0.4, -- before it starts on a shot (the search adds its own time)
	TURN_MAX = 1.2,
	RESULT_MIN = 2.5, -- looking at the result before it leaves
	RESULT_MAX = 4.5,
	AFTER_LEAVE = 1.5, -- for the menu to come back after leaving
	JOIN_WAIT = 6, -- seconds for the search screen (or a match) to show after picking a venue
	JOIN_TRIES = 3, -- failed picks in a row before the run stops
	MISS_RECHECK = 2, -- seconds before it looks for a game object it did not find again
	LEAVE_TRIES = 5, -- presses of the result screen's leave button before the run stops
	PRESS_WAIT = 1, -- seconds after pressing a menu card, or between looks at unloaded venues
	-- the game's objects (Game.liveTable): keys only each one has (2026-10-05 dump)
	VENUE_KEYS = table.freeze({ "ChosenBindable", "Cards", "PassBindable" }) :: { string }, -- PoolVenueMenu.new
	SEARCH_KEYS = table.freeze({ "CancelBindable", "Cancelled", "Root" }) :: { string }, -- PoolSearchMenu.new
	RESULT_KEYS = table.freeze({ "RematchButton", "ExitButton", "OutcomeSounds" }) :: { string }, -- PoolResultScreen.new
	HOME_KEYS = table.freeze({ "OneOnOne", "WithFriends", "Carousel" }) :: { string }, -- PoolHomeMenu.new
	IDLE_TEXT = "Press Start to join matches and play them for you",
})

-- The page's options, saved in SAVE_FILE
type AutoFarmSaved = { missPercent: number, think: number, venue: string }

type AutoFarmState = {
	destroyed: boolean, -- the page was replaced (a re-run) or the menu unloaded
	refs: GameRefs,
	saved: AutoFarmSaved,
	page: CornyMenuPage,
	label: CornyMenuOption,
	cue: Cue,
	antiIdle: AntiIdle,
	refresh: () -> (), -- the Start / Stop buttons
	running: boolean,
	task: CornyMenuTask?, -- the progress card while it runs
	phase: string, -- "" | "loading" | "waiting" | "home" | "menu" | "joining" | "queued" | "match" | "result" | "moving"
	waitUntil: number, -- the pause before its next step
	turnReadyAt: number?, -- your turn began: the pause before it starts on the shot
	joinedAt: number,
	joinFailures: number,
	leaveTries: number, -- presses of the leave button on this result screen
	cancelUntil: number, -- after a Stop while joining: cancel the search screen if it shows by then
	recorded: boolean, -- the shown result is counted
	started: number,
	wins: number,
	losses: number,
	shots: number,
	misses: number,
	venue: string?, -- the venue it joined last
	random: Random,
	objects: { [string]: any }, -- the game's menu objects (untyped game tables), found once
	missedAt: { [string]: number }, -- when an object was last looked for and not found
	warned: { [string]: boolean },
}

local AutoFarm = {
	log = newLogger(AutoFarmConfig.LOG_PREFIX),
	state = nil :: AutoFarmState?, -- the live page's state (the Test submenu reads it)
}

function AutoFarm.warnOnce(state: AutoFarmState, message: string): ()
	if state.warned[message] then
		return
	end
	state.warned[message] = true
	AutoFarm.log.warn(message)
end

function AutoFarm.between(state: AutoFarmState, low: number, high: number): number
	return low + (high - low) * state.random:NextNumber()
end

-- "UNITED KINGDOM" -> "United Kingdom"; short words stay as they are ("USA")
function AutoFarm.titleCase(name: string): string
	local words: { string } = {}
	for word in string.gmatch(name, "%S+") do
		if #word <= 3 then
			table.insert(words, word)
		else
			table.insert(
				words,
				string.upper(string.sub(word, 1, 1)) .. string.lower(string.sub(word, 2))
			)
		end
	end
	return table.concat(words, " ")
end

-- "1h 02m", "12m 05s"
function AutoFarm.duration(seconds: number): string
	local total = math.floor(seconds)
	local hours = total // 3600
	local minutes = (total % 3600) // 60
	if hours > 0 then
		return string.format("%dh %02dm", hours, minutes)
	end
	return string.format("%dm %02ds", minutes, total % 60)
end

-- "25,000"
function AutoFarm.thousands(value: number): string
	local text = tostring(math.floor(value))
	local formatted = text
	repeat
		local count: number
		formatted, count = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
	until count == 0
	return formatted
end

-- One of the game's menu objects, found once and found again when the game made a new one; a
-- miss is not looked for again for MISS_RECHECK seconds (the search goes through the whole GC)
function AutoFarm.object(state: AutoFarmState, field: string, keys: { string }): any?
	local current = state.objects[field]
	if
		type(current) == "table"
		and typeof(current.Root) == "Instance"
		and current.Root.Parent ~= nil
	then
		return current
	end
	local now = os.clock()
	local missed = state.missedAt[field]
	if missed ~= nil and now - missed < AutoFarmConfig.MISS_RECHECK then
		return nil
	end
	local found = Game.liveTable(keys)
	state.objects[field] = found
	if found == nil then
		state.missedAt[field] = now
		AutoFarm.warnOnce(state, `the game's {field} was not found`)
	else
		state.missedAt[field] = nil
	end
	return found
end

-- The venue to join (its card index and name), or why there is none (for players)
function AutoFarm.pickVenue(menuObject: any?, choice: string): (number?, string?, string?)
	if type(menuObject) ~= "table" or type(menuObject.Cards) ~= "table" then
		return nil, nil, "The venue list is not there - open the game's menu once"
	end
	local cards = menuObject.Cards
	if choice == "best" or choice == "quick" then
		for index = #cards, 1, -1 do
			local card = cards[index]
			local venue = if type(card) == "table" then card.Venue else nil
			if type(venue) ~= "table" then
				continue
			end
			if choice == "quick" and venue.Matchmaking == "RealOnline" then
				continue
			end
			if card.Unlocked == true and card.Affordable ~= false then
				return index, AutoFarm.titleCase(tostring(venue.Name)), nil
			end
		end
		return nil, nil, "No venue to join right now"
	end
	for index, card in cards do
		local venue = if type(card) == "table" then card.Venue else nil
		if type(venue) == "table" and venue.Id == choice then
			local name = AutoFarm.titleCase(tostring(venue.Name))
			if card.Unlocked ~= true then
				return nil, nil, `{name} is locked - pick another venue`
			end
			if card.Affordable == false then
				return nil, nil, `You cannot afford {name} right now`
			end
			return index, name, nil
		end
	end
	return nil, nil, "That venue is not in the game any more - pick another one"
end

-- "Won 9 of 10 (90%)"
function AutoFarm.record(state: AutoFarmState): string
	local played = state.wins + state.losses
	if played == 0 then
		return "No match finished yet"
	end
	return `Won {state.wins} of {played} ({math.round(state.wins / played * 100)}%)`
end

-- The progress card, the status and the page line
function AutoFarm.show(state: AutoFarmState, phase: string): ()
	local detail = AutoFarm.record(state)
	local venue = state.venue
	if venue ~= nil and string.find(phase, venue, 1, true) == nil then
		detail = `{detail} - {venue}`
	end
	local job = state.task
	if job ~= nil then
		job:set({ phase = phase, detail = detail })
	end
	state.page:status(
		AutoFarmConfig.STATUS_ID,
		`Auto-Farm: {state.wins}-{state.losses}`,
		CornyMenu.palette.good
	)
	state.label:set(`{phase}. {detail}`, CornyMenu.palette.subtext)
end

-- Moves to a new step; leaving a match drops a shot that is still going
function AutoFarm.enter(state: AutoFarmState, phase: string): ()
	if state.phase == "match" and phase ~= "match" then
		state.cue:stop(nil, true)
	end
	state.phase = phase
end

-- Presses the result screen's leave button (its Activated event, as a click)
function AutoFarm.leave(state: AutoFarmState, screen: any): ()
	AutoFarm.press(state, screen.ExitButton, "the result screen's leave button")
end

-- Presses one of the game's buttons the way a click does (its Activated event): Volt's
-- firesignal, else each of its connections. `what` names it for F9
function AutoFarm.press(state: AutoFarmState, button: any, what: string): ()
	local isButton = typeof(button) == "Instance"
	if not isButton then
		AutoFarm.warnOnce(state, `{what} is not there`)
		return
	end
	local fire: any = firesignal -- Volt: fires the Luau connections of a signal
	if type(fire) == "function" and try(fire, button.Activated) then
		return
	end
	local connectionsOf: any = getconnections -- Volt: the connections of a signal
	if type(connectionsOf) == "function" then
		local ok, connections = try(connectionsOf, button.Activated)
		if ok and type(connections) == "table" then
			for _, connection in connections do
				try(connection.Fire, connection)
			end
			return
		end
	end
	AutoFarm.warnOnce(state, `could not press {what}`)
end

-- Whether the venue list's cards are filled in: the game marks them once your progress and
-- coins load (the first venue is then unlocked and, free to enter, affordable)
function AutoFarm.venuesLoaded(menuObject: any): boolean
	if type(menuObject) ~= "table" or type(menuObject.Cards) ~= "table" then
		return false
	end
	for _, card in menuObject.Cards do
		if type(card) == "table" and card.Unlocked == true and card.Affordable == true then
			return true
		end
	end
	return false
end

-- Cancels the search for an opponent the way its Cancel does (the search screen's
-- CancelBindable). true when the search screen was there
function AutoFarm.cancelSearch(state: AutoFarmState): boolean
	local search = AutoFarm.object(state, "searchMenu", AutoFarmConfig.SEARCH_KEYS)
	if type(search) ~= "table" or not Shots.isOnScreen(search.Root) then
		return false
	end
	local cancel: any = search.CancelBindable -- the search screen's BindableEvent
	local isEvent = typeof(cancel) == "Instance"
	if isEvent then
		try(cancel.Fire, cancel)
	end
	return true
end

-- One step of the run (every frame while it runs; each step waits its pause first)
function AutoFarm.tick(state: AutoFarmState): ()
	if not state.running or state.destroyed then
		return
	end
	local now = os.clock()
	if now < state.waitUntil then
		return
	end
	local refs = state.refs

	-- the game is moving you to another server: Shared.Relaunch carries the farm over
	if Relaunch.isTeleporting() then
		if state.phase ~= "moving" then
			AutoFarm.enter(state, "moving")
			AutoFarm.show(state, "Moving to another server")
		end
		return
	end

	-- the game's match screen tells whether a match is on: nothing happens before it is there
	local gameUi = Game.ui(refs)
	if gameUi == nil then
		if state.phase ~= "loading" then
			AutoFarm.enter(state, "loading")
			AutoFarm.show(state, "Waiting for the game to load")
		end
		return
	end

	-- the result screen: count it, then leave
	local screen = AutoFarm.object(state, "resultScreen", AutoFarmConfig.RESULT_KEYS)
	if screen ~= nil and Shots.isOnScreen(screen.Root) then
		if state.phase ~= "result" then
			AutoFarm.enter(state, "result")
			state.leaveTries = 0
			state.recorded = false
			state.waitUntil = now
				+ AutoFarm.between(state, AutoFarmConfig.RESULT_MIN, AutoFarmConfig.RESULT_MAX)
			AutoFarm.show(state, "Match over")
			return
		end
		if not state.recorded then
			state.recorded = true
			local won = screen.ViewerWon == true
			if won then
				state.wins += 1
			else
				state.losses += 1
			end
			AutoFarm.log.info(
				`{if won then "won" else "lost"} - {AutoFarm.record(state)}, {state.misses} misses on purpose`
			)
			AutoFarm.show(state, if won then "Won" else "Lost")
		end
		if state.leaveTries >= AutoFarmConfig.LEAVE_TRIES then
			AutoFarm.log.warn(
				`the result screen stayed after {state.leaveTries} presses of its leave button`
			)
			AutoFarm.stop(state, "Could not leave the result screen - see F9", false)
			return
		end
		state.leaveTries += 1
		AutoFarm.leave(state, screen)
		state.waitUntil = now + AutoFarmConfig.AFTER_LEAVE
		return
	end

	-- a match: play every turn of yours
	if gameUi:GetAttribute("MatchActive") == true then
		local mode = gameUi:GetAttribute("MatchMode")
		if mode == "Trickshot" or mode == "Tutorial" then
			AutoFarm.stop(
				state,
				if mode == "Trickshot"
					then "Auto-Farm plays matches - leave the trickshot mode first"
					else "Auto-Farm plays matches - finish the tutorial first",
				false
			)
			return
		end
		if state.phase ~= "match" then
			AutoFarm.enter(state, "match")
			state.turnReadyAt = nil
			state.joinFailures = 0
			AutoFarm.show(state, "Playing")
		end
		local cue = state.cue
		if cue:isBusy() then
			return
		end
		if cue:whyNot() ~= nil then
			state.turnReadyAt = nil
			return
		end
		local readyAt = state.turnReadyAt
		if readyAt == nil then
			state.turnReadyAt = now
				+ AutoFarm.between(state, AutoFarmConfig.TURN_MIN, AutoFarmConfig.TURN_MAX)
			return
		end
		if now < readyAt then
			return
		end
		state.turnReadyAt = nil
		local refused = cue:start(false)
		if refused ~= nil then
			AutoFarm.warnOnce(state, `could not start a shot: {refused}`)
		end
		return
	end

	-- searching for an opponent
	local search = AutoFarm.object(state, "searchMenu", AutoFarmConfig.SEARCH_KEYS)
	if search ~= nil and Shots.isOnScreen(search.Root) then
		if state.phase ~= "queued" then
			AutoFarm.enter(state, "queued")
			state.joinFailures = 0
			AutoFarm.show(state, "Looking for an opponent")
		end
		return
	end

	-- a venue was picked: the search screen should show soon
	if state.phase == "joining" then
		if now - state.joinedAt < AutoFarmConfig.JOIN_WAIT then
			return
		end
		state.joinFailures += 1
		AutoFarm.log.warn(
			`joining {state.venue or "the venue"} did not start a search (try {state.joinFailures})`
		)
		if state.joinFailures >= AutoFarmConfig.JOIN_TRIES then
			AutoFarm.stop(state, "Could not join a match - see F9", false)
			return
		end
	end

	-- the menu: the venue list on screen, or the home screen (its 1v1 card opens the list);
	-- anything else (the game still loading, say after a server move, or a screen between two
	-- others) is waited out, never a reason to stop
	local menuObject = AutoFarm.object(state, "venueMenu", AutoFarmConfig.VENUE_KEYS)
	if menuObject == nil or not Shots.isOnScreen(menuObject.Root) then
		local home = AutoFarm.object(state, "homeMenu", AutoFarmConfig.HOME_KEYS)
		if home ~= nil and Shots.isOnScreen(home.Root) then
			if state.phase ~= "home" then
				AutoFarm.enter(state, "home")
				state.waitUntil = now
					+ AutoFarm.between(state, AutoFarmConfig.MENU_MIN, AutoFarmConfig.MENU_MAX)
				AutoFarm.show(state, "Opening the venues")
				return
			end
			-- like a tap on the 1v1 card (a first tap may only bring the card to the middle)
			AutoFarm.press(state, home.OneOnOne, "the home screen's 1v1 card")
			state.waitUntil = now + AutoFarmConfig.PRESS_WAIT
			return
		end
		if state.phase ~= "waiting" then
			AutoFarm.enter(state, "waiting")
			AutoFarm.show(state, "Waiting for the game")
		end
		return
	end

	-- the venue list: pick the venue, after a pause
	if state.phase ~= "menu" then
		AutoFarm.enter(state, "menu")
		state.waitUntil = now
			+ AutoFarm.between(state, AutoFarmConfig.MENU_MIN, AutoFarmConfig.MENU_MAX)
		AutoFarm.show(state, "Choosing a match")
		return
	end
	local title: any = menuObject.TitleLabel
	local isLabel = typeof(title) == "Instance"
	if isLabel and string.find(string.upper(tostring(title.Text)), "CHALLENGE", 1, true) == 1 then
		AutoFarm.stop(state, "A friend challenge is waiting - close it, then press Start", false)
		return
	end
	if not AutoFarm.venuesLoaded(menuObject) then
		-- your progress and coins are still loading: the cards are all locked until then
		AutoFarm.show(state, "Waiting for your venues")
		state.waitUntil = now + AutoFarmConfig.PRESS_WAIT
		return
	end
	local index, name, problem = AutoFarm.pickVenue(menuObject, state.saved.venue)
	if index == nil then
		AutoFarm.stop(state, problem or "No venue to join right now", false)
		return
	end
	local venueMenu = refs.venueMenu
	if venueMenu == nil then
		AutoFarm.stop(state, "Auto-Farm does not work with this version of the game", false)
		return
	end
	local chosen, err = try(venueMenu.Choose, menuObject, index)
	if not chosen then
		AutoFarm.log.warn(`picking {name} failed: {err}`)
		AutoFarm.stop(state, "Could not join a match - see F9", false)
		return
	end
	AutoFarm.log.info(`joining {name}`)
	state.venue = name
	AutoFarm.enter(state, "joining")
	state.joinedAt = now
	AutoFarm.show(state, `Joining {name}`)
end

-- A count carried over a teleport (Relaunch.take): a whole number, else 0
function AutoFarm.count(value: any): number
	return if type(value) == "number"
			and value == value
			and value >= 0
		then math.floor(value)
		else 0
end

-- Starts a run; `carried` (Relaunch.take, after the game moved you to another server) carries
-- the last run's count on
function AutoFarm.start(state: AutoFarmState, carried: any?): string?
	if state.destroyed then
		return "This page was replaced - use the new one"
	end
	if state.running then
		return "Already running - press Stop first"
	end
	local resumed = type(carried) == "table"
	local from: any = if resumed then carried else {}
	state.running = true
	state.phase = ""
	state.waitUntil = 0
	state.turnReadyAt = nil
	state.joinedAt = 0
	state.joinFailures = 0
	state.leaveTries = 0
	state.cancelUntil = 0
	state.started = os.clock() - AutoFarm.count(from.ran)
	state.wins = AutoFarm.count(from.wins)
	state.losses = AutoFarm.count(from.losses)
	state.shots = AutoFarm.count(from.shots)
	state.misses = AutoFarm.count(from.misses)
	state.venue = if type(from.venue) == "string" then from.venue else nil
	if resumed then
		AutoFarm.log.info(`carrying on after the server change: {AutoFarm.record(state)}`)
	end
	state.antiIdle:start()
	state.task = state.page:task(AutoFarmConfig.PAGE, {
		total = 0,
		onStop = function(): ()
			AutoFarm.stop(state, nil, true)
		end,
	})
	AutoFarm.show(state, if resumed then "Carrying on" else "Starting")
	state.refresh()
	return nil
end

-- What the run carries over a teleport (Relaunch.carry): its count, or nil when it is not running
function AutoFarm.carried(state: AutoFarmState): any
	if not state.running then
		return nil
	end
	return {
		wins = state.wins,
		losses = state.losses,
		shots = state.shots,
		misses = state.misses,
		ran = os.clock() - state.started,
		venue = state.venue,
	}
end

-- Ends the run at once: the cue is yours again, a search going on is cancelled the way its
-- Cancel does, the idle kick is the game's again
function AutoFarm.stop(state: AutoFarmState, text: string?, ok: boolean): ()
	if not state.running then
		return
	end
	state.running = false
	state.cue:stop(nil, true)
	state.antiIdle:stop()
	if not AutoFarm.cancelSearch(state) and state.phase == "joining" then
		-- a venue was just picked: its search screen may still come up; cancel it when it does
		state.cancelUntil = os.clock() + AutoFarmConfig.JOIN_WAIT
	end
	local ran = AutoFarm.duration(os.clock() - state.started)
	local summary = text or `Stopped after {ran}. {AutoFarm.record(state)}`
	local job = state.task
	state.task = nil
	if job ~= nil then
		job:finish(summary, ok)
	end
	state.page:status(AutoFarmConfig.STATUS_ID, nil)
	state.page:hidePrompt(AutoFarmConfig.PROMPT_ID)
	state.label:set(summary, if ok then CornyMenu.palette.subtext else CornyMenu.palette.bad)
	AutoFarm.log.info(
		`stopped after {ran}: {summary} ({state.shots} shots, {state.misses} misses on purpose,`
			.. ` {state.antiIdle.kicksStopped} idle kicks stopped)`
	)
	state.refresh()
end

-- Copies the saved options that are valid into `data` (Shared.Settings)
function AutoFarm.validate(decoded: { [any]: any }, data: any): ()
	local miss = decoded.missPercent
	if type(miss) == "number" and miss == miss then
		data.missPercent = math.clamp(math.round(miss), 0, AutoFarmConfig.MISS_MAX)
	end
	local think = decoded.think
	if type(think) == "number" and think == think then
		data.think =
			math.clamp(math.round(think), AutoFarmConfig.THINK_MIN, AutoFarmConfig.THINK_MAX)
	end
	if type(decoded.venue) == "string" and decoded.venue ~= "" then
		data.venue = decoded.venue
	end
end

-- The venue choices: the best you can play, the best that also fills with computer players,
-- then every venue (PoolConstants.Venues)
function AutoFarm.venueItems(refs: GameRefs): { CornyMenuItem }
	local items: { CornyMenuItem } = {
		{
			key = "best",
			text = "Best I can play",
			description = "The highest venue you have unlocked and can afford.",
		},
		{
			key = "quick",
			text = "Best with quick matches",
			description = "The highest venue you can play that also fills with computer players, "
				.. "so matches start fast.",
		},
	}
	local venues = refs.constants.Venues
	if type(venues) == "table" then
		for _, venue in venues do
			if type(venue) ~= "table" or type(venue.Id) ~= "string" then
				continue
			end
			local prize = if type(venue.Prize) == "number"
				then AutoFarm.thousands(venue.Prize)
				else "?"
			local who = if venue.Matchmaking == "RealOnline" then " Real players only." else ""
			table.insert(items, {
				key = venue.Id,
				text = AutoFarm.titleCase(tostring(venue.Name)),
				description = `Prize {prize}.{who}`,
			})
		end
	end
	return items
end

-- The page. Rows only start, stop or change options; the work is in tick and Shared.Cue.
function AutoFarm.buildPage(menu: CornyMenuObject): CornyMenuPage
	local palette = CornyMenu.palette
	-- an older Auto-Farm page is torn down in here (its onDestroy runs)
	local page = menu:page(AutoFarmConfig.PAGE, {
		description = "Joins matches, plays them with the best shots and starts again.",
	})
	AutoFarm.state = nil

	local saved: AutoFarmSaved = {
		missPercent = AutoFarmConfig.MISS_DEFAULT,
		think = AutoFarmConfig.THINK_DEFAULT,
		venue = AutoFarmConfig.VENUE_DEFAULT,
	}
	local settings =
		newSettings(Game.files, AutoFarmConfig.SAVE_FILE, saved, AutoFarm.validate, AutoFarm.log)
	settings:load()
	page:onDestroy(function(): ()
		settings:flush()
	end)

	page:header("Auto-Farm")
	local startButton = page:button("Start", nil, {
		color = palette.good,
		description = "Joins a match, plays it for you with the best shots and starts the next one. "
			.. "Keeps going until you press Stop.",
	})
	local stopButton = page:button("Stop", nil, {
		color = palette.bad,
		enabled = false,
		description = "Stops at once and gives you the cue back. A search for an opponent is cancelled.",
	})
	local venueList = page:list("Venue", {}, function(key: string): ()
		saved.venue = key
		settings:save()
	end, {
		description = "Where it plays. Higher venues pay more; the best with quick matches skips "
			.. "venues that only match you with real players.",
	})
	page:slider("Misses now and then", saved.missPercent, function(value: number): ()
		saved.missPercent = value
		settings:save()
	end, {
		min = 0,
		max = AutoFarmConfig.MISS_MAX,
		step = 1,
		format = function(value: number): string
			return `{value}%`
		end,
		description = "How often it misses on purpose, so it plays like a person. A miss is always "
			.. "safe: no foul and nothing goes in, and never when the game is at stake.",
	})
	page:slider("Thinking time", saved.think, function(value: number): ()
		saved.think = value
		settings:save()
	end, {
		min = AutoFarmConfig.THINK_MIN,
		max = AutoFarmConfig.THINK_MAX,
		step = 1,
		format = function(value: number): string
			return `{value} s`
		end,
		description = "How long it may look for the best shot each turn. Longer finds harder shots.",
	})
	local label = page:label(AutoFarmConfig.IDLE_TEXT)

	local found, refs = try(Game.get)
	if not found then
		AutoFarm.log.warn(`the pool table was not found: {refs}`)
		label:set("Could not find the pool table - rejoin, then run this again", palette.bad)
		startButton:setEnabled(false)
		return page
	end
	venueList:setItems(AutoFarm.venueItems(refs))
	venueList:select(saved.venue)
	local hooks, problem = Shots.install(refs)
	if hooks == nil then
		if problem == "old" then
			AutoFarm.log.warn("an older build hooked the game this session: rejoin first")
			label:set("Rejoin the game, then run this again", palette.bad)
		else
			AutoFarm.log.warn(`could not hook the cue: {problem}`)
			label:set("Auto-Farm does not work here - see F9", palette.bad)
		end
		startButton:setEnabled(false)
		return page
	end

	local state: AutoFarmState
	local cue = newCue(hooks, refs, {
		owner = AutoFarmConfig.PAGE,
		place = true,
		mouseRelease = false,
		showIndex = false,
		missChance = function(): number
			return saved.missPercent / 100
		end,
		thinkSeconds = function(): number
			return saved.think
		end,
		onPrompt = function(lines: { string }, _withKeys: boolean): ()
			page:prompt(
				AutoFarmConfig.PROMPT_ID,
				{ title = AutoFarmConfig.PAGE, lines = lines, keys = {} }
			)
		end,
		onEnd = function(text: string?, ok: boolean, shot: CueShot?, _test: boolean): ()
			page:hidePrompt(AutoFarmConfig.PROMPT_ID)
			if shot ~= nil then
				state.shots += 1
				if shot.missed then
					state.misses += 1
				end
				AutoFarm.log.info(
					string.format(
						"shot %d: %s%s (line %s, window %.2f deg)",
						state.shots,
						Cue.describeShot(shot),
						if shot.missed then ", a miss on purpose" else "",
						shot.line,
						shot.robust
					)
				)
			elseif text ~= nil and not ok then
				AutoFarm.log.warn(`a shot stopped: {text}`)
			end
		end,
	})
	state = {
		destroyed = false,
		refs = refs,
		saved = saved,
		page = page,
		label = label,
		cue = cue,
		antiIdle = newAntiIdle(),
		refresh = function(): ()
			startButton:setEnabled(not state.running)
			stopButton:setEnabled(state.running)
		end,
		running = false,
		task = nil,
		phase = "",
		waitUntil = 0,
		turnReadyAt = nil,
		joinedAt = 0,
		joinFailures = 0,
		leaveTries = 0,
		cancelUntil = 0,
		recorded = false,
		started = os.clock(),
		wins = 0,
		losses = 0,
		shots = 0,
		misses = 0,
		venue = nil,
		random = Random.new(),
		objects = {},
		missedAt = {},
		warned = {},
	}
	AutoFarm.state = state

	startButton:onChange(function(): ()
		local refused = AutoFarm.start(state)
		if refused ~= nil then
			startButton:flash()
			label:set(refused, palette.bad)
		end
	end)
	stopButton:onChange(function(): ()
		AutoFarm.stop(state, nil, true)
	end)
	page:track(RunService.RenderStepped:Connect(function(): ()
		if not state.running then
			-- stopped while joining: the search screen that comes up is cancelled
			if state.cancelUntil > 0 then
				if os.clock() > state.cancelUntil or AutoFarm.cancelSearch(state) then
					state.cancelUntil = 0
				end
			end
			return
		end
		local ok, err = tryTraced(AutoFarm.tick, state)
		if not ok then
			AutoFarm.warnOnce(state, `a step failed: {err}`)
		end
	end))
	-- after a teleport the full script runs again (Shared.Relaunch) and the farm carries on
	Relaunch.install(Game.files, GameConfig.SCRIPT_URL, GameConfig.READY_GUI)
	Relaunch.carry(AutoFarmConfig.PAGE, function(): any
		return AutoFarm.carried(state)
	end)
	page:onDestroy(function(): ()
		Relaunch.carry(AutoFarmConfig.PAGE, nil)
		AutoFarm.stop(state, nil, true)
		state.destroyed = true
		cue:Destroy()
		state.antiIdle:Destroy()
		if AutoFarm.state == state then
			AutoFarm.state = nil
		end
	end)
	state.refresh()
	local carried = Relaunch.take(Game.files, AutoFarmConfig.PAGE)
	if type(carried) == "table" then
		-- the game moved you here while it farmed: it carries on once the menu is up
		task.defer(function(): ()
			if not state.destroyed and not state.running then
				AutoFarm.start(state, carried)
			end
		end)
	end
	return page
end

-- Test tools in a "Test" submenu: the standalone test build always adds it, the full Corny
-- script only when getgenv().CornyDev is true
function AutoFarm.describeState(state: AutoFarmState): { string }
	local lines: { string } = {}
	table.insert(
		lines,
		`running: {state.running}, step: {state.phase}, {AutoFarm.record(state)}, shots {state.shots},`
			.. ` misses on purpose {state.misses}, venue {state.venue or "none"}, join failures {state.joinFailures},`
			.. ` idle kicks stopped {state.antiIdle.kicksStopped}`
	)
	local refs = state.refs
	local gameUi = Game.ui(refs)
	local matchOn = gameUi ~= nil and gameUi:GetAttribute("MatchActive") == true
	local mode = if gameUi ~= nil then tostring(gameUi:GetAttribute("MatchMode")) else "?"
	table.insert(lines, `match screen found: {gameUi ~= nil}, match on: {matchOn}, mode: {mode}`)
	table.insert(lines, `moving to another server: {Relaunch.isTeleporting()}`)
	table.insert(lines, `runs again after a teleport from: {GameConfig.SCRIPT_URL}`)
	local menuObject = AutoFarm.object(state, "venueMenu", AutoFarmConfig.VENUE_KEYS)
	local home = AutoFarm.object(state, "homeMenu", AutoFarmConfig.HOME_KEYS)
	local pickerShown = menuObject ~= nil and Shots.isOnScreen(menuObject.Root)
	local homeShown = home ~= nil and Shots.isOnScreen(home.Root)
	local loaded = AutoFarm.venuesLoaded(menuObject)
	table.insert(
		lines,
		`venue picker found: {menuObject ~= nil}, on screen: {pickerShown}, cards loaded: {loaded}`
	)
	table.insert(lines, `home screen found: {home ~= nil}, on screen: {homeShown}`)
	if menuObject ~= nil and type(menuObject.Cards) == "table" then
		for index, card in menuObject.Cards do
			local venue = if type(card) == "table" then card.Venue else nil
			if type(venue) == "table" then
				table.insert(
					lines,
					`  {index}. {AutoFarm.titleCase(tostring(venue.Name))}: unlocked {tostring(
						card.Unlocked
					)},`
						.. ` affordable {tostring(card.Affordable)}, prize {tostring(venue.Prize)},`
						.. ` matchmaking {tostring(venue.Matchmaking)}`
				)
			end
		end
	end
	local index, name, problem = AutoFarm.pickVenue(menuObject, state.saved.venue)
	table.insert(lines, `it would join: {name or "nothing"} ({tostring(index)}) {problem or ""}`)
	table.insert(
		lines,
		`search screen found: {AutoFarm.object(state, "searchMenu", AutoFarmConfig.SEARCH_KEYS) ~= nil},`
			.. ` result screen found: {AutoFarm.object(
				state,
				"resultScreen",
				AutoFarmConfig.RESULT_KEYS
			) ~= nil}`
	)
	for _, line in Cue.describeJob(state.cue.lastJob) do
		table.insert(lines, line)
	end
	return lines
end

function AutoFarm.buildTests(page: CornyMenuPage): ()
	local tests = page:submenu("Test", {
		description = "Tools for testing this feature in game.",
	})
	tests:button("Print the farm state to F9", function(): ()
		local state = AutoFarm.state
		if state == nil then
			AutoFarm.log.info("the page has no hooks (see the lines above)")
			return
		end
		for _, line in AutoFarm.describeState(state) do
			AutoFarm.log.info(line)
		end
	end, { description = "Prints the step, the record, the venues it sees and its last plan." })
	tests:button("Dump the farm state to a file", function(): ()
		local state = AutoFarm.state
		if state == nil then
			AutoFarm.log.info("the page has no hooks (see the lines above)")
			return
		end
		local text = table.concat(AutoFarm.describeState(state), "\n") .. "\n"
		local ok, err = Game.files:write(AutoFarmConfig.DEBUG_FILE, text)
		if ok then
			AutoFarm.log.info(
				`wrote {Game.files:path(AutoFarmConfig.DEBUG_FILE)} in Volt's workspace`
			)
		else
			AutoFarm.log.warn(`could not write {err}`)
		end
	end, {
		description = `Writes the same to {Game.files:path(AutoFarmConfig.DEBUG_FILE)} in Volt's `
			.. "workspace folder.",
	})
end
--#endregion Feature.AutoFarm

--#region Bootstrap (written by tools/featuretool.py assemble)
-- One page per feature, each built in its own tryTraced, so a page that fails to load never
-- keeps the others from loading. Pages can sit in folders (the game's menu.json, which assemble
-- reads): a folder is a main-menu row that opens its pages. Running the script again replaces
-- every folder and page (CornyMenu replaces a main-menu page by name, a folder takes its pages
-- with it, and each page's onDestroy stops its work).
-- CornyMenu finds pages by name only on the main menu, so a page in a folder also gets a hidden
-- main-menu row of its own name, tied to it both ways: a test build of that page replaces the
-- hidden row, which takes the folder's copy with it (one copy runs, never two), and the test page
-- shows on the main menu instead. Set getgenv().CornyDev = true before running to also get each
-- page's Test submenu.
do
	type CornyFeatureBuilder = {
		name: string,
		folder: string?,
		buildPage: (menu: CornyMenuObject) -> CornyMenuPage,
		buildTests: ((page: CornyMenuPage) -> ())?,
	}
	-- each folder's description (shown when its row is highlighted)
	local folders: { [string]: string } = {
	}
	local builders: { CornyFeatureBuilder } = {
		{ name = "ShotPaths", buildPage = ShotPaths.buildPage, buildTests = ShotPaths.buildTests },
		{ name = "ShotHelper", buildPage = ShotHelper.buildPage, buildTests = ShotHelper.buildTests },
		{ name = "AutoAim", buildPage = AutoAim.buildPage, buildTests = AutoAim.buildTests },
		{ name = "AutoFarm", buildPage = AutoFarm.buildPage, buildTests = AutoFarm.buildTests },
	}
	local genv = getgenv()
	-- the older one-file scripts this one replaces keep loops and hooks running: stop them first
	-- (LT2's games/LT2/reference/corny.lua keeps its sentinel in CornyScript, Cornyv2.lua in
	-- CornyV2; both have destroy; in any other game neither key is set and this does nothing)
	for _, key in { "CornyScript", "CornyV2" } do
		local previous = genv[key]
		if type(previous) == "table" and type(previous.destroy) == "function" then
			local ok, err = try(previous.destroy)
			if not ok then
				logWarn(`{key} did not unload cleanly: {err}`)
			end
		end
	end
	local dev = genv.CornyDev == true
	local menu = CornyMenu.get({ title = "Corny", subtitle = GameConfig.NAME })
	-- The menu a feature in a folder gets: its page goes into the folder, with the hidden
	-- main-menu row of the same name; everything else is the shared menu's own
	local function folderMenu(folder: CornyMenuPage): CornyMenuObject
		local made: { [string]: CornyMenuPage } = {}
		local inFolder: CornyMenuObject = {
			page = function(_: CornyMenuObject, name: string, opts: CornyMenuOpts?): CornyMenuPage
				local row = menu:page(name, { visible = false })
				local page = folder:submenu(name, opts)
				made[name] = page
				row:onDestroy(function()
					page:Destroy()
				end)
				page:onDestroy(function()
					if rawequal(made[name], page) then
						made[name] = nil
					end
					row:Destroy()
				end)
				return page
			end,
			getPage = function(_: CornyMenuObject, name: string): CornyMenuPage?
				return made[name] or menu:getPage(name)
			end,
			open = function(_: CornyMenuObject): ()
				menu:open()
			end,
			close = function(_: CornyMenuObject): ()
				menu:close()
			end,
			toggle = function(_: CornyMenuObject): ()
				menu:toggle()
			end,
			isOpen = function(_: CornyMenuObject): boolean
				return menu:isOpen()
			end,
			setToggleKey = function(_: CornyMenuObject, key: Enum.KeyCode?): ()
				menu:setToggleKey(key)
			end,
			setKeys = function(_: CornyMenuObject, action: string, keys: { string | Enum.KeyCode }): ()
				menu:setKeys(action, keys)
			end,
			getKeys = function(_: CornyMenuObject, action: string): { string }
				return menu:getKeys(action)
			end,
			resetKeys = function(_: CornyMenuObject, action: string?): ()
				menu:resetKeys(action)
			end,
			notify = function(_: CornyMenuObject, text: string, opts: CornyMenuNotify?): ()
				menu:notify(text, opts)
			end,
			task = function(
				_: CornyMenuObject,
				title: string,
				opts: CornyMenuTaskOptions?
			): CornyMenuTask
				return menu:task(title, opts)
			end,
			prompt = function(_: CornyMenuObject, id: string, spec: CornyMenuPrompt): ()
				menu:prompt(id, spec)
			end,
			hidePrompt = function(_: CornyMenuObject, id: string): ()
				menu:hidePrompt(id)
			end,
			status = function(_: CornyMenuObject, id: string, text: string?, color: Color3?): ()
				menu:status(id, text, color)
			end,
			defer = function(_: CornyMenuObject, fn: () -> ()): ()
				menu:defer(fn)
			end,
			Destroy = function(_: CornyMenuObject): ()
				menu:Destroy()
			end,
		}
		return inFolder
	end
	-- folders are made when their first page is built, so the main menu keeps menu.json's order
	local inFolders: { [string]: CornyMenuObject } = {}
	local loaded = 0
	for _, builder in builders do
		local ok, result = tryTraced(function(): CornyMenuPage
			local target: CornyMenuObject = menu
			local folderName = builder.folder
			if folderName then
				local given = inFolders[folderName]
				if given == nil then
					local folder = menu:page(folderName, { description = folders[folderName] })
					given = folderMenu(folder)
					inFolders[folderName] = given
				end
				target = given
			end
			local page = builder.buildPage(target)
			local buildTests = builder.buildTests
			if dev and buildTests then
				buildTests(page)
			end
			return page
		end)
		if ok then
			loaded += 1
		else
			logWarn(`the {builder.name} page did not load: {result}`)
		end
	end
	local keys = menu:getKeys("toggle")
	local openWith = if #keys > 0 then table.concat(keys, " or ") else "a click on the watermark"
	log(`loaded {loaded}/{#builders} pages - open the menu with {openWith}`)
end
--#endregion Bootstrap
