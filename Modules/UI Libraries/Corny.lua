--!strict
--[[
	CornyMenu v6
]]
--#region CornyMenuTypes (CornyMenu's public types, source: lib/cornymenu_types.luau)
-- The shapes scripts pass to CornyMenu and the objects it hands back. The module
-- (lib/cornymenu.lua) and the loader region (lib/cornymenu_loader.lua) both carry this
-- block, so a script that downloads the module still type-checks in strict mode.
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

local CornyMenu = (function()
	local VERSION = 6

	-- ============ Services ============
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local ContextActionService = game:GetService("ContextActionService")
	local GuiService = game:GetService("GuiService")
	local HttpService = game:GetService("HttpService")

	-- ============ Config ============
	type Accent = { name: string, color: Color3 }
	type Range = { min: number, max: number, step: number }

	local Config = table.freeze({
		GENV_KEY = "CornyMenu",
		RENDERER_KEY = "CornyMenuRenderer", -- getgenv override: "immediate" or "retained"
		SAVE_FOLDER = "Corny",
		SAVE_PATH = "Corny/cornymenu.json",
		SAVE_DELAY = 1, -- seconds from the first change of a burst to the write
		NAV_ACTION = "CornyMenuNavigate",
		CAPTURE_ACTION = "CornyMenuCapture",
		NAV_PRIORITY = 3500, -- above placement sessions (3000): the open menu owns its keys
		CAPTURE_PRIORITY = 4000, -- a keybind waiting for a key beats everything
		PAINT_LAYER = 8, -- DrawingImmediate paint signal
		PAINT_WATCHDOG = 3, -- seconds DrawingImmediate may go without painting a new frame,
		PAINT_WATCHDOG_FRAMES = 30, -- and frames (a paused or minimized game is not a failure)
		OBJECT_Z = 10000, -- ZIndex base of retained Drawing objects
		DRAWING_RETRY = 5, -- seconds before a failed Drawing.new of a class is tried again
		GUI_ORDER = 100000, -- DisplayOrder of the invisible input ScreenGui
		OFFSCREEN = -10000, -- where the hidden text box sits (its caret can never show)
		VIEWPORT_FALLBACK = Vector2.new(1280, 720), -- used until there is a camera
		INSET_FALLBACK = 36, -- top bar height when GuiService cannot tell
		MAX_FRAME_TIME = 0.1, -- longest step an animation takes (a hitch does not skip it)
		REPEAT_FAST_AFTER = 12, -- repeats before a held key goes twice as fast
		HOLD_BOOST_AFTER = 16, -- repeats before a held slider key moves HOLD_BOOST times as far
		HOLD_BOOST = 4,
		CAPTURE_GRACE = 0.2, -- seconds the key that ended a capture cannot toggle the menu
		CONFIRM_TIME = 3, -- seconds a confirm button stays armed
		FLASH_TIME = 0.45,
		TOAST_TIME = 4,
		TOAST_MAX = 5,
		TASK_LINGER = 6, -- seconds a finished task stays on screen
		DESCRIPTION_LINES = 4,
		LABEL_LINES = 12,
		TOAST_LINES = 3,
		PROMPT_LINES = 4,
		AUTO_SEARCH = 10, -- lists with more items than this get a search row
		INPUT_LENGTH = 200, -- default maxLength of an input
		SEARCH_LENGTH = 60,
		NUMBER_LENGTH = 24, -- typing a slider value
		CANVAS_MIN = 8, -- lowest canvas row, in pixels at 100% size
		MEASURE_CACHE = 4000,
		MEASURE_MISSES = 25, -- TextBounds misses before widths are estimated
		NARROW_CHARS = "il.,:;'|!I()[]1`", -- width estimate: thin and wide glyphs
		WIDE_CHARS = "mwMW@%",
		MIN_OPACITY = 0.004, -- anything fainter is not drawn
		FADE_RATE = 14, -- exponential approach rates, per second
		SLIDE_RATE = 18,
		SCROLLER_RATE = 24,
		SETTLE_FADE = 0.002, -- how close an animation gets before it snaps to its target
		SETTLE_FILL = 0.01,
		SETTLE_PIXELS = 0.25,
		BLINK_PERIOD = 0.8, -- a key capture blinks: shown for BLINK_ON of every period
		BLINK_ON = 0.5,
		CARET_PERIOD = 1,
		CARET_ON = 0.6,
		BLINK_TICK = 0.1, -- redraw interval while something blinks
		BUSY_SPEED = 0.8, -- sweeps per second of a task bar with no total
		BUSY_FPS = 30,
		CLEANUP_METHODS = table.freeze({ "Disconnect", "Destroy", "Remove" } :: { string }),
		KEY_SLOTS = 2, -- keys per action
		-- sizes at 100% scale, in pixels
		WIDTH = 330,
		MARGIN = 14,
		GAP = 8,
		PAD = 12,
		ROW = 24,
		HEADER = 46, -- title and subtitle, the page path under them
		SECTION = 24,
		SEPARATOR = 9,
		FOOTER = 24,
		TEXT = 15,
		SMALL = 13,
		TITLE = 17,
		LINE = 17,
		ACCENT_BAR = 3,
		KEYCAP = 5, -- padding inside a key chip
		CHECK = 12,
		SLIDER = 92,
		FIELD = 140,
		CHEVRON = 4,
		SCROLLBAR = 3,
		NUDGE = 4,
		-- settings: defaults, and the ranges both the save file and the sliders keep to
		DEFAULTS = table.freeze({
			accent = "Cyan",
			opacity = 88,
			scale = 100,
			font = "Plex",
			rows = 12,
			animations = true,
			keys = table.freeze({}), -- filled per action from ACTIONS (defaultKeys)
			watermark = true,
			toasts = true,
			offsetX = 0,
			offsetY = 0,
			wrap = true,
			repeatDelay = 350,
			repeatRate = 16,
			fastSteps = 10,
			mouseBack = true,
			mouseWheel = true,
			hoverSelect = true,
		} :: Settings),
		RANGES = table.freeze({
			opacity = table.freeze({ min = 40, max = 100, step = 5 } :: Range),
			scale = table.freeze({ min = 70, max = 160, step = 5 } :: Range),
			rows = table.freeze({ min = 5, max = 24, step = 1 } :: Range),
			offsetX = table.freeze({ min = 0, max = 1200, step = 10 } :: Range),
			offsetY = table.freeze({ min = 0, max = 800, step = 10 } :: Range),
			repeatDelay = table.freeze({ min = 150, max = 800, step = 25 } :: Range), -- ms
			repeatRate = table.freeze({ min = 5, max = 40, step = 1 } :: Range), -- per second
			fastSteps = table.freeze({ min = 2, max = 50, step = 1 } :: Range),
		}),
		ACCENTS = table.freeze({
			{ name = "Cyan", color = Color3.fromRGB(0, 190, 255) },
			{ name = "Corn", color = Color3.fromRGB(255, 200, 45) },
			{ name = "Red", color = Color3.fromRGB(235, 60, 60) },
			{ name = "Green", color = Color3.fromRGB(70, 215, 110) },
			{ name = "Orange", color = Color3.fromRGB(255, 140, 30) },
			{ name = "Purple", color = Color3.fromRGB(165, 95, 255) },
			{ name = "Pink", color = Color3.fromRGB(255, 90, 180) },
			{ name = "White", color = Color3.fromRGB(235, 235, 240) },
		} :: { Accent }),
		FONTS = table.freeze({ "Plex", "UI", "System", "Monospace" } :: { string }),
		FONT_IDS = table.freeze(
			{ UI = 0, System = 1, Plex = 2, Monospace = 3 } :: { [string]: number }
		),
		KEY_LABELS = table.freeze({
			RightShift = "RShift",
			LeftShift = "LShift",
			RightControl = "RCtrl",
			LeftControl = "LCtrl",
			RightAlt = "RAlt",
			LeftAlt = "LAlt",
			Return = "Enter",
			KeypadEnter = "Num Enter",
			Backspace = "Bksp",
			Delete = "Del",
			Escape = "Esc",
			PageUp = "PgUp",
			PageDown = "PgDn",
			Insert = "Ins",
		} :: { [string]: string }),
		-- Everything the menu does from the keyboard or a gamepad. Each action takes up to
		-- KEY_SLOTS bindings, written as text: a KeyCode name with optional modifiers ("Up",
		-- "Ctrl+M"). context: "always" works open or closed, "open" only while the menu is
		-- open (the game does not see those keys then), "held" is read while another key acts,
		-- "modal" is for typing and waiting for a key.
		ACTIONS = table.freeze({
			{
				id = "toggle",
				label = "Open / close menu",
				keys = { "RightShift" },
				context = "always",
				repeats = false,
				description = "Works while the menu is closed too. No key: click the watermark.",
			},
			{
				id = "up",
				label = "Move up",
				keys = { "Up" },
				context = "open",
				repeats = true,
				description = "Moves the highlight up. Hold it to repeat.",
			},
			{
				id = "down",
				label = "Move down",
				keys = { "Down" },
				context = "open",
				repeats = true,
				description = "Moves the highlight down. Hold it to repeat.",
			},
			{
				id = "left",
				label = "Decrease / back",
				keys = { "Left" },
				context = "open",
				repeats = true,
				description = "Turns a value down. On other rows it goes back a page.",
			},
			{
				id = "right",
				label = "Increase / open",
				keys = { "Right" },
				context = "open",
				repeats = true,
				description = "Turns a value up. Opens submenus and lists.",
			},
			{
				id = "select",
				label = "Select",
				keys = { "Return", "KeypadEnter" },
				context = "open",
				repeats = false,
				description = "Presses, flips, starts typing or rebinding, opens pages.",
			},
			{
				id = "back",
				label = "Back",
				keys = { "Backspace" },
				context = "open",
				repeats = false,
				description = "Goes back a page. On the main menu it closes the menu.",
			},
			{
				id = "pageUp",
				label = "Page up",
				keys = { "PageUp" },
				context = "open",
				repeats = true,
				description = "Jumps a screen of rows up.",
			},
			{
				id = "pageDown",
				label = "Page down",
				keys = { "PageDown" },
				context = "open",
				repeats = true,
				description = "Jumps a screen of rows down.",
			},
			{
				id = "first",
				label = "First option",
				keys = { "Home" },
				context = "open",
				repeats = false,
				description = "Jumps to the first option of the page.",
			},
			{
				id = "last",
				label = "Last option",
				keys = { "End" },
				context = "open",
				repeats = false,
				description = "Jumps to the last option of the page.",
			},
			{
				id = "fast",
				label = "Fast steps (hold)",
				keys = { "LeftShift" },
				context = "held",
				repeats = false,
				description = "Hold it while changing a slider to move several steps at once.",
			},
			{
				id = "clear",
				label = "Clear a key",
				keys = { "Delete" },
				context = "open",
				repeats = false,
				description = "On a key row: removes the key.",
			},
			{
				id = "cancel",
				label = "Cancel",
				keys = { "Escape" },
				context = "modal",
				repeats = false,
				description = "Stops typing or waiting for a key without saving.",
			},
		} :: { ActionDef }),
		-- keys that count as Ctrl / Shift / Alt in a combination
		MODIFIER_KEYS = table.freeze({
			LeftControl = "ctrl",
			RightControl = "ctrl",
			LeftShift = "shift",
			RightShift = "shift",
			LeftAlt = "alt",
			RightAlt = "alt",
		} :: { [string]: string }),
		SELECTABLE = table.freeze({
			button = true,
			toggle = true,
			cycle = true,
			slider = true,
			input = true,
			keybind = true,
			binding = true,
			list = true,
			submenu = true,
			choice = true,
		} :: { [string]: boolean }),
		-- footer hints per row kind, shown with the keys bound right now
		HINTS = table.freeze({
			button = {
				{ actions = { "select" }, verb = "Select" },
			},
			toggle = {
				{ actions = { "select" }, verb = "Toggle" },
			},
			cycle = {
				{ actions = { "left", "right" }, verb = "Change" },
			},
			slider = {
				{ actions = { "left", "right" }, verb = "Adjust" },
				{ actions = { "select" }, verb = "Type" },
			},
			input = {
				{ actions = { "select" }, verb = "Edit" },
			},
			keybind = {
				{ actions = { "select" }, verb = "Rebind" },
				{ actions = { "clear" }, verb = "Clear" },
			},
			binding = {
				{ actions = { "select" }, verb = "Rebind" },
				{ actions = { "clear" }, verb = "Clear" },
			},
			list = {
				{ actions = { "select" }, verb = "Open" },
			},
			submenu = {
				{ actions = { "select" }, verb = "Open" },
			},
			choice = {
				{ actions = { "select" }, verb = "Pick" },
			},
		} :: { [string]: { Hint } }),
	})

	-- CornyMenu.actions hands out the action tables: freeze them all the way down
	-- (any: it walks tables of any shape, and leaves everything else alone)
	local function freezeAll(value: any): ()
		if type(value) ~= "table" then
			return
		end
		for _, child in value do
			freezeAll(child)
		end
		if not table.isfrozen(value) then
			table.freeze(value)
		end
	end
	freezeAll(Config.ACTIONS)
	freezeAll(Config.HINTS)

	local Palette: CornyMenuPalette = table.freeze({
		background = Color3.fromRGB(9, 9, 12),
		header = Color3.fromRGB(19, 19, 24),
		field = Color3.fromRGB(30, 30, 37),
		border = Color3.fromRGB(58, 58, 70),
		text = Color3.fromRGB(236, 236, 240),
		subtext = Color3.fromRGB(160, 162, 172),
		dim = Color3.fromRGB(98, 100, 110),
		good = Color3.fromRGB(90, 210, 120),
		bad = Color3.fromRGB(235, 85, 85),
		warn = Color3.fromRGB(240, 185, 60),
		white = Color3.new(1, 1, 1),
	})

	-- ============ Classes (declared first so the types below can refer to them) ============
	local Janitor = {}
	Janitor.__index = Janitor
	local Canvas = {}
	Canvas.__index = Canvas
	local TextMeasure = {}
	TextMeasure.__index = TextMeasure
	local Option = {}
	Option.__index = Option
	local Page = {}
	Page.__index = Page
	local Task = {}
	Task.__index = Task
	local Layer = {}
	Layer.__index = Layer
	local Menu = {}
	Menu.__index = Menu

	-- ============ Types ============
	type Janitor = typeof(setmetatable({} :: { _tasks: { () -> () } }, Janitor))

	type Settings = {
		accent: string,
		opacity: number, -- background, percent
		scale: number, -- percent
		font: string,
		rows: number, -- visible rows before the list scrolls
		animations: boolean,
		keys: { [string]: { string } }, -- action id -> bindings as text, at most KEY_SLOTS
		watermark: boolean,
		toasts: boolean,
		offsetX: number,
		offsetY: number,
		wrap: boolean, -- moving past the last option goes to the first
		repeatDelay: number, -- ms before a held key repeats
		repeatRate: number, -- repeats per second
		fastSteps: number, -- slider steps per press while the fast key is held
		mouseBack: boolean, -- right click goes back
		mouseWheel: boolean, -- the wheel moves the highlight
		hoverSelect: boolean, -- the row under the mouse gets the highlight
	}

	type ActionDef = CornyMenuAction
	type Hint = { actions: { string }, verb: string }
	-- A key, and the modifiers that must be held with it
	type Binding = { key: Enum.KeyCode, ctrl: boolean, shift: boolean, alt: boolean }
	type KeyEntry = { action: string, binding: Binding, modifiers: number }

	type Metrics = {
		scale: number,
		width: number,
		margin: number,
		gap: number,
		pad: number,
		row: number,
		header: number,
		section: number,
		separator: number,
		footer: number,
		text: number,
		small: number,
		title: number,
		line: number,
		accentBar: number,
		check: number,
		slider: number,
		field: number,
		chevron: number,
		scrollbar: number,
		nudge: number,
		keycap: number,
	}

	type CommandKind = "rect" | "outline" | "line" | "triangle" | "text"

	type Command = {
		kind: CommandKind,
		a: Vector2, -- rect / outline: top left; line / triangle: point 1; text: position
		b: Vector2, -- rect / outline: size; line / triangle: point 2
		c: Vector2, -- triangle: point 3
		color: Color3,
		opacity: number,
		thickness: number,
		text: string,
		size: number,
		font: number,
		outlined: boolean,
		outlineColor: Color3,
		outlineOpacity: number,
	}

	type Canvas = typeof(setmetatable(
		{} :: {
			commands: { Command },
			count: number,
			alpha: number, -- multiplies every opacity pushed while it is set
			font: number,
		},
		Canvas
	))

	-- Draws a finished Canvas: DrawingImmediate (per-frame paint) or pooled Drawing objects
	type Renderer = {
		name: string,
		present: (canvas: Canvas) -> (),
		healthy: (watching: boolean) -> boolean, -- watching: the game window has focus
		destroy: () -> (),
	}

	type TextMeasureFields = {
		_probe: DrawingText?,
		_widths: { [string]: number },
		_strings: { [string]: string },
		_wraps: { [string]: { string } },
		_entries: number,
		_misses: number,
		_estimate: boolean,
	}

	type TextMeasure = typeof(setmetatable({} :: TextMeasureFields, TextMeasure))

	type OptionKind =
		"header"
		| "label"
		| "separator"
		| "button"
		| "toggle"
		| "cycle"
		| "slider"
		| "input"
		| "keybind"
		| "binding"
		| "list"
		| "submenu"
		| "canvas"
		| "choice"

	type Choice = {
		text: string,
		value: any, -- any: cycle values are whatever the host passes (strings, numbers, booleans)
	}

	type ListItem = CornyMenuItem
	type OptionOptions = CornyMenuOpts

	type ToggleState = { on: boolean, fill: number }
	type CycleState = { choices: { Choice }, index: number }
	type SliderState = {
		min: number,
		max: number,
		step: number,
		value: number,
		format: (value: number) -> string,
		barX: number, -- where the bar was last drawn (mouse drag)
		barWidth: number,
	}
	type InputState = {
		value: string,
		placeholder: string,
		numeric: boolean,
		min: number,
		max: number,
		integer: boolean,
		maxLength: number,
		search: boolean, -- the search row of a list page
	}
	type KeybindState = { key: Enum.KeyCode? }
	type ListState = {
		items: { ListItem },
		selected: string?,
		-- nil: a search row appears once there are more than AUTO_SEARCH items
		searchable: boolean?,
		stay: boolean,
		placeholder: string,
		emptyText: string,
		query: string,
		search: Option?,
		onHighlight: ((key: string?, item: ListItem?) -> ())?,
	}
	type CanvasState = {
		height: number,
		painter: CornyMenuPainter,
		animate: boolean,
		onMouse: ((event: CornyMenuMouse, x: number, y: number, delta: number) -> ())?,
		rect: Rect?, -- where it was last drawn (mouse events use local coordinates)
	}
	type ChoiceState = { item: ListItem, owner: Option }
	-- a Controls row: the action it edits and which of its keys is picked
	type BindingState = { action: string, slot: number }

	type OptionFields = {
		kind: OptionKind,
		page: Page,
		text: string,
		description: string?,
		visible: boolean,
		enabled: boolean,
		color: Color3?,
		badge: string?,
		confirm: string?,
		armedUntil: number,
		flashUntil: number,
		flashColor: Color3,
		destroyed: boolean,
		callback: ((...any) -> ())?, -- any: the arguments depend on the kind (see the API list)
		target: Page?,
		toggle: ToggleState?,
		cycle: CycleState?,
		slider: SliderState?,
		input: InputState?,
		keybind: KeybindState?,
		list: ListState?,
		canvas: CanvasState?,
		choice: ChoiceState?,
		binding: BindingState?,
	}

	type Option = typeof(setmetatable({} :: OptionFields, Option))

	type PageFields = {
		menu: Menu,
		name: string,
		title: string,
		parent: Page?,
		entry: Option?, -- the option on the parent page that opens this page
		owner: Option?, -- list pages: the list option they belong to
		options: { Option },
		children: { Page },
		selected: Option?,
		restore: number?, -- selectable position to highlight once the selection went away
		scroll: number, -- first visible row
		janitor: Janitor,
		destroyed: boolean,
	}

	type Page = typeof(setmetatable({} :: PageFields, Page))

	type TaskOptions = CornyMenuTaskOptions
	type TaskUpdate = CornyMenuTaskUpdate

	type TaskFields = {
		menu: Menu,
		title: string,
		phase: string,
		detail: string,
		done: number,
		total: number,
		started: number,
		ended: number?,
		ok: boolean,
		onStop: (() -> ())?,
		owner: Page?, -- page:task(): removed with this page
		stopped: boolean,
		removed: boolean,
		closing: boolean,
		fade: number,
	}

	type Task = typeof(setmetatable({} :: TaskFields, Task))

	type LayerFields = {
		menu: Menu,
		label: string,
		painter: CornyMenuPainter,
		visible: boolean,
		animate: boolean,
		destroyed: boolean,
	}

	type Layer = typeof(setmetatable({} :: LayerFields, Layer))

	-- Where painters draw right now (the one CornyMenuDraw table is reused for every call)
	type DrawTarget = {
		originX: number,
		originY: number,
		clip: Rect?,
	}

	type NotifyOptions = CornyMenuNotify
	type Toast = {
		title: string?,
		text: string,
		color: Color3?,
		born: number,
		duration: number,
		fade: number,
		closing: boolean,
	}

	type PromptKey = CornyMenuKey
	type PromptSpec = CornyMenuPrompt
	-- owner: the page that set it last (page:prompt / page:status), removed with it
	type PromptEntry = { id: string, spec: PromptSpec, owner: Page? }
	type StatusEntry = { id: string, text: string, color: Color3?, owner: Page? }

	type RegionKind =
		"menu"
		| "row"
		| "cycleLeft"
		| "cycleRight"
		| "slider"
		| "back"
		| "watermark"
		| "toast"
		| "taskStop"
		| "promptKey"
		| "canvas"
		| "bindingSlot"

	type Region = {
		kind: RegionKind,
		x: number,
		y: number,
		w: number,
		h: number,
		option: Option?,
		toast: Toast?,
		task: Task?,
		key: PromptKey?,
		slot: number?, -- bindingSlot: which key of the row
	}

	type Rect = { x: number, y: number, w: number, h: number }
	type RowLayout = { option: Option, height: number }
	type Chip = { x: number, y: number, w: number, keyWidth: number, key: PromptKey }

	type EditMode = "input" | "slider" | "search"
	type EditState = {
		id: number,
		option: Option,
		mode: EditMode,
		text: string,
		original: string,
		cursor: number,
	}
	type HeldKey = { key: Enum.KeyCode, action: string, nextAt: number, count: number }
	type GuiBridge = {
		screen: ScreenGui,
		input: TextBox,
		shields: { TextButton },
		shieldKeys: { string },
	}

	type MenuOptions = CornyMenuOptions

	type MenuFields = {
		title: string,
		subtitle: string,
		settings: Settings,
		metrics: Metrics,
		accent: Color3,
		font: number,
		bindings: { [string]: { Binding } }, -- parsed settings.keys
		keyLookup: { [Enum.KeyCode]: { KeyEntry } },
		navSignature: string?, -- the keys the navigation binding took, as text
		watermarkOption: Option?,
		syncControls: (() -> ())?, -- sets every settings control from the settings
		rendererLabel: Option?,
		janitor: Janitor,
		canvas: Canvas,
		measure: TextMeasure,
		renderer: Renderer,
		gui: GuiBridge?,
		root: Page,
		pages: { [string]: Page },
		emptyLabel: Option?,
		stack: { Page },
		opened: boolean,
		openFade: number,
		pageFade: number,
		pageDirection: number,
		scrollerY: number,
		scrollerHeight: number,
		scrollerTarget: number,
		scrollerTargetHeight: number,
		snapScroller: boolean,
		columnTop: number,
		columnTarget: number,
		snapColumn: boolean,
		dirty: boolean,
		animating: boolean,
		frameDt: number,
		fillsMoving: boolean,
		rows: { RowLayout },
		regions: { Region },
		regionCount: number,
		shields: { Rect },
		shieldCount: number,
		layers: { Layer },
		draw: CornyMenuDraw,
		drawTarget: DrawTarget,
		menuRect: Rect?,
		dragging: Option?,
		dragX: number, -- slider bar position when the drag started
		dragWidth: number,
		canvasDrag: Option?,
		armed: Option?, -- the confirm button waiting for its second press
		-- the list whose onHighlight heard last, and the key it heard (nil: no item)
		highlightOwner: Option?,
		highlightKey: string?,
		editing: EditState?,
		editCounter: number,
		focusId: number,
		capturing: Option?,
		capturePending: Enum.KeyCode?, -- a modifier held while rebinding (may start a chord)
		capturedAt: number,
		frame: number, -- frames stepped (a press and its echoes share one)
		navKey: Enum.KeyCode?, -- the last key the navigation binding acted on, and its frame
		navFrame: number,
		held: HeldKey?,
		deferred: { () -> () },
		toasts: { Toast },
		tasks: { Task },
		prompts: { PromptEntry },
		statuses: { StatusEntry },
		viewport: Vector2,
		viewportDirty: boolean,
		windowFocused: boolean, -- the game window has focus (the paint watchdog counts then)
		cameraConnection: RBXScriptConnection?,
		inset: number,
		now: number,
		wakeAt: number,
		bound: boolean,
		saveQueued: boolean,
		saveThread: thread?,
		warned: { [string]: boolean },
		destroyed: boolean,
	}

	type Menu = typeof(setmetatable({} :: MenuFields, Menu))

	-- ============ Janitor ============
	-- pcall with a fixed (ok, error) shape, also for functions that return nothing
	local function try(fn: (...any) -> ...any, ...: any): (boolean, any)
		return pcall(fn, ...)
	end

	local function newJanitor(): Janitor
		return setmetatable({ _tasks = {} }, Janitor)
	end

	-- The name of the cleanup method an object has (Volt connections, Drawing objects,
	-- CornyMenu Tasks and Layers...). Reading a member executor userdata does not have
	-- can throw, hence the pcall.
	local function cleanupMethod(object: any): string?
		for _, name in Config.CLEANUP_METHODS do
			local ok, method = pcall(function(): any
				return object[name]
			end)
			if ok and type(method) == "function" then
				return name
			end
		end
		return nil
	end

	-- Owns `item` until destroy(): a Roblox or Volt connection, an Instance, a Drawing
	-- object, a thread, a cleanup function or any object with Disconnect / Destroy / Remove.
	function Janitor.give(self: Janitor, item: unknown): ()
		local cleanup: () -> ()
		if typeof(item) == "RBXScriptConnection" then
			cleanup = function()
				item:Disconnect()
			end
		elseif typeof(item) == "Instance" then
			cleanup = function()
				item:Destroy()
			end
		elseif type(item) == "thread" then
			cleanup = function()
				task.cancel(item)
			end
		elseif type(item) == "function" then
			cleanup = item :: () -> ()
		else
			-- any: executor userdata and tables are only known by their methods
			local object: any = item
			local method = cleanupMethod(object)
			if method == nil then
				warn(
					`[CornyMenu] cannot clean up a {typeof(item)}: no Disconnect, Destroy or Remove`
				)
				return
			end
			cleanup = function()
				object[method](object)
			end
		end
		table.insert(self._tasks, cleanup)
	end

	-- Runs every cleanup, newest first; one failing cleanup never stops the rest.
	function Janitor.destroy(self: Janitor): ()
		local tasks = self._tasks
		self._tasks = {}
		for index = #tasks, 1, -1 do
			local ok, err = try(tasks[index])
			if not ok then
				warn(`[CornyMenu] cleanup failed: {err}`)
			end
		end
	end

	-- ============ Helpers ============
	local keysByName: { [string]: Enum.KeyCode } = {}
	local keysByLowerName: { [string]: Enum.KeyCode } = {} -- "rightshift" works in setKeys too
	for _, item in Enum.KeyCode:GetEnumItems() do
		keysByName[item.Name] = item
		keysByLowerName[string.lower(item.Name)] = item
	end
	table.freeze(keysByName)
	table.freeze(keysByLowerName)

	-- gamepad buttons are read with IsGamepadButtonDown, not IsKeyDown
	local gamepadKeys: { [Enum.KeyCode]: boolean } = {}
	for _, item in Enum.KeyCode:GetEnumItems() do
		local name = item.Name
		if string.sub(name, 1, 6) == "Button" or string.sub(name, 1, 4) == "DPad" then
			gamepadKeys[item] = true
		end
	end
	table.freeze(gamepadKeys)

	local actionById: { [string]: ActionDef } = {}
	for _, def in Config.ACTIONS do
		actionById[def.id] = def
	end
	table.freeze(actionById)

	local function keyLabel(key: Enum.KeyCode?): string
		if key == nil then
			return "None"
		end
		return Config.KEY_LABELS[key.Name] or key.Name
	end

	local function isKeyDown(key: Enum.KeyCode): boolean
		if gamepadKeys[key] then
			return UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, key)
		end
		return UserInputService:IsKeyDown(key)
	end

	-- Which of Ctrl, Shift and Alt are held (either side)
	local function modifiersHeld(): (boolean, boolean, boolean)
		return isKeyDown(Enum.KeyCode.LeftControl) or isKeyDown(Enum.KeyCode.RightControl),
			isKeyDown(Enum.KeyCode.LeftShift) or isKeyDown(Enum.KeyCode.RightShift),
			isKeyDown(Enum.KeyCode.LeftAlt) or isKeyDown(Enum.KeyCode.RightAlt)
	end

	-- A modifier key never needs itself held too ("Shift+LeftShift" is just "LeftShift")
	local function newBinding(
		key: Enum.KeyCode,
		ctrl: boolean,
		shift: boolean,
		alt: boolean
	): Binding
		local own = Config.MODIFIER_KEYS[key.Name]
		return {
			key = key,
			ctrl = ctrl and own ~= "ctrl",
			shift = shift and own ~= "shift",
			alt = alt and own ~= "alt",
		}
	end

	local function modifierCount(binding: Binding): number
		return (if binding.ctrl then 1 else 0)
			+ (if binding.shift then 1 else 0)
			+ (if binding.alt then 1 else 0)
	end

	local function joinBinding(binding: Binding, key: string): string
		local parts: { string } = {}
		if binding.ctrl then
			table.insert(parts, "Ctrl")
		end
		if binding.shift then
			table.insert(parts, "Shift")
		end
		if binding.alt then
			table.insert(parts, "Alt")
		end
		table.insert(parts, key)
		return table.concat(parts, "+")
	end

	-- The saved form: "Ctrl+Shift+M" (modifiers in this order, then the KeyCode name)
	local function bindingText(binding: Binding): string
		return joinBinding(binding, binding.key.Name)
	end

	-- The shown form: short key names ("Ctrl+RShift")
	local function bindingLabel(binding: Binding): string
		return joinBinding(binding, keyLabel(binding.key))
	end

	-- "Ctrl+M" -> binding, nil for anything that is not a key
	local function parseBinding(text: string): Binding?
		local parts = string.split(text, "+")
		local name = parts[#parts]
		local key = keysByName[name] or keysByLowerName[string.lower(name)]
		if key == nil or key.Name == "Unknown" then
			return nil
		end
		local ctrl, shift, alt = false, false, false
		for index = 1, #parts - 1 do
			local modifier = string.lower(parts[index])
			if modifier == "ctrl" then
				ctrl = true
			elseif modifier == "shift" then
				shift = true
			elseif modifier == "alt" then
				alt = true
			else
				return nil
			end
		end
		return newBinding(key, ctrl, shift, alt)
	end

	local function defaultKeys(): { [string]: { string } }
		local keys: { [string]: { string } } = {}
		for _, def in Config.ACTIONS do
			keys[def.id] = table.clone(def.keys)
		end
		return keys
	end

	local function isFinite(value: number): boolean
		return value == value and value ~= math.huge and value ~= -math.huge
	end

	-- Frame-rate independent exponential approach
	local function approach(
		current: number,
		target: number,
		rate: number,
		dt: number,
		epsilon: number
	): number
		local value = target + (current - target) * math.exp(-rate * dt)
		if math.abs(target - value) <= epsilon then
			return target
		end
		return value
	end

	local function ease(t: number): number
		local inverse = 1 - math.clamp(t, 0, 1)
		return 1 - inverse * inverse * inverse
	end

	local function formatNumber(value: number): string
		if value == math.floor(value) and math.abs(value) < 1e15 then
			return string.format("%d", value)
		end
		local text = string.format("%.3f", value)
		text = string.gsub(text, "0+$", "")
		text = string.gsub(text, "%.$", "")
		return text
	end

	local function percent(value: number): string
		return `{formatNumber(value)}%`
	end

	local function pixels(value: number): string
		return `{formatNumber(value)} px`
	end

	local function milliseconds(value: number): string
		return `{formatNumber(value)} ms`
	end

	local function perSecond(value: number): string
		return `{formatNumber(value)} / s`
	end

	local function times(value: number): string
		return `x{formatNumber(value)}`
	end

	local function rendererText(name: string): string
		return `CornyMenu v{VERSION} - {name} renderer`
	end

	local function clock(seconds: number): string
		local whole = math.max(0, math.floor(seconds + 0.5))
		return string.format("%d:%02d", whole // 60, whole % 60)
	end

	local function accentColor(name: string): Color3
		for _, accent in Config.ACCENTS do
			if accent.name == name then
				return accent.color
			end
		end
		return Config.ACCENTS[1].color
	end

	local function setIdentity(): ()
		if setthreadidentity then
			-- best effort: if it fails, the GUI writes after it fail and warn on their own
			pcall(setthreadidentity, 8)
		end
	end

	local function traceback(message: any): string
		return debug.traceback(tostring(message), 2)
	end

	-- Runs a host callback on its own thread once the menu has finished what it is doing
	-- (task.defer), so script code never runs in the middle of a page change or a frame;
	-- an error is warned, never thrown into the menu.
	local function spawnCallback(label: string, callback: ((...any) -> ())?, ...: any): ()
		if callback == nil then
			return
		end
		local fn = callback
		task.defer(function(...: any)
			-- the engine starts this thread, and such threads can lack executor capability
			-- (LEARNINGS.md, thread identity): callbacks may touch the script's own GUI
			setIdentity()
			local result = table.pack(xpcall(fn, traceback, ...))
			if not result[1] then
				warn(`[CornyMenu] {label}: {result[2]}`)
			end
		end, ...)
	end

	local function contains(rect: Rect, point: Vector2): boolean
		return point.X >= rect.x
			and point.X < rect.x + rect.w
			and point.Y >= rect.y
			and point.Y < rect.y + rect.h
	end

	local function makeMetrics(scale: number): Metrics
		local function size(value: number): number
			return math.max(1, math.floor(value * scale + 0.5))
		end
		return {
			scale = scale,
			width = size(Config.WIDTH),
			margin = size(Config.MARGIN),
			gap = size(Config.GAP),
			pad = size(Config.PAD),
			row = size(Config.ROW),
			header = size(Config.HEADER),
			section = size(Config.SECTION),
			separator = size(Config.SEPARATOR),
			footer = size(Config.FOOTER),
			text = size(Config.TEXT),
			small = size(Config.SMALL),
			title = size(Config.TITLE),
			line = size(Config.LINE),
			accentBar = math.max(2, size(Config.ACCENT_BAR)),
			check = size(Config.CHECK),
			slider = size(Config.SLIDER),
			field = size(Config.FIELD),
			chevron = math.max(3, size(Config.CHEVRON)),
			scrollbar = math.max(2, size(Config.SCROLLBAR)),
			nudge = size(Config.NUDGE),
			keycap = size(Config.KEYCAP),
		}
	end

	-- ============ Settings ============
	local Store = {}

	-- `default`'s type is the only type accepted from the file (NaN rejected)
	local function readSetting(data: { [string]: any }, key: string, default: any): any
		local value = data[key]
		if value ~= nil and type(value) == type(default) and value == value then
			return value
		end
		return default
	end

	-- The saved keys: at most KEY_SLOTS valid bindings per action, defaults for actions the
	-- file does not have. A binding saved for two actions stays with the first one, and a
	-- default already used by a saved binding is left out, so no key means two things.
	local function readKeys(data: { [string]: any }): { [string]: { string } }
		local saved = data.keys
		if type(saved) ~= "table" then
			-- saves from v3 and before only had the open key: it keeps that job, and any
			-- other action that has it by default lets it go
			local keys = defaultKeys()
			local legacy = data.key
			local binding = if type(legacy) == "string" then parseBinding(legacy) else nil
			if legacy == "None" then
				keys.toggle = {}
			elseif binding then
				local text = bindingText(binding)
				for _, list in keys do
					local index = table.find(list, text)
					if index then
						table.remove(list, index)
					end
				end
				keys.toggle = { text }
			end
			return keys
		end
		local keys: { [string]: { string } } = {}
		local used: { [string]: boolean } = {}
		local missing: { ActionDef } = {}
		for _, def in Config.ACTIONS do
			local list = saved[def.id]
			if type(list) ~= "table" then
				table.insert(missing, def)
				continue
			end
			local kept: { string } = {}
			for _, text in list do
				local binding = if type(text) == "string" then parseBinding(text) else nil
				if binding and #kept < Config.KEY_SLOTS then
					local canonical = bindingText(binding)
					if not used[canonical] then
						used[canonical] = true
						table.insert(kept, canonical)
					end
				end
			end
			keys[def.id] = kept
		end
		for _, def in missing do
			local kept: { string } = {}
			for _, text in def.keys do
				if not used[text] then
					used[text] = true
					table.insert(kept, text)
				end
			end
			keys[def.id] = kept
		end
		return keys
	end

	function Store.reset(settings: Settings): ()
		local defaults = Config.DEFAULTS
		settings.accent = defaults.accent
		settings.opacity = defaults.opacity
		settings.scale = defaults.scale
		settings.font = defaults.font
		settings.rows = defaults.rows
		settings.animations = defaults.animations
		settings.keys = defaultKeys()
		settings.watermark = defaults.watermark
		settings.toasts = defaults.toasts
		settings.offsetX = defaults.offsetX
		settings.offsetY = defaults.offsetY
		settings.wrap = defaults.wrap
		settings.repeatDelay = defaults.repeatDelay
		settings.repeatRate = defaults.repeatRate
		settings.fastSteps = defaults.fastSteps
		settings.mouseBack = defaults.mouseBack
		settings.mouseWheel = defaults.mouseWheel
		settings.hoverSelect = defaults.hoverSelect
	end

	-- Only the key and mouse behavior (the Controls page's "Reset controls")
	function Store.resetControls(settings: Settings): ()
		local defaults = Config.DEFAULTS
		settings.keys = defaultKeys()
		settings.wrap = defaults.wrap
		settings.repeatDelay = defaults.repeatDelay
		settings.repeatRate = defaults.repeatRate
		settings.fastSteps = defaults.fastSteps
		settings.mouseBack = defaults.mouseBack
		settings.mouseWheel = defaults.mouseWheel
		settings.hoverSelect = defaults.hoverSelect
	end

	-- Returns the saved settings (defaults for anything missing or invalid) and
	-- whether a save file existed.
	function Store.load(): (Settings, boolean)
		local defaults = Config.DEFAULTS
		local settings = table.clone(defaults)
		settings.keys = defaultKeys()
		local ok, data = pcall(function()
			return HttpService:JSONDecode(readfile(Config.SAVE_PATH))
		end)
		local found = ok and type(data) == "table"
		if found then
			settings.accent = readSetting(data, "accent", defaults.accent)
			settings.opacity = readSetting(data, "opacity", defaults.opacity)
			settings.scale = readSetting(data, "scale", defaults.scale)
			settings.font = readSetting(data, "font", defaults.font)
			settings.rows = readSetting(data, "rows", defaults.rows)
			settings.animations = readSetting(data, "animations", defaults.animations)
			settings.keys = readKeys(data)
			settings.watermark = readSetting(data, "watermark", defaults.watermark)
			settings.toasts = readSetting(data, "toasts", defaults.toasts)
			settings.offsetX = readSetting(data, "offsetX", defaults.offsetX)
			settings.offsetY = readSetting(data, "offsetY", defaults.offsetY)
			settings.wrap = readSetting(data, "wrap", defaults.wrap)
			settings.repeatDelay = readSetting(data, "repeatDelay", defaults.repeatDelay)
			settings.repeatRate = readSetting(data, "repeatRate", defaults.repeatRate)
			settings.fastSteps = readSetting(data, "fastSteps", defaults.fastSteps)
			settings.mouseBack = readSetting(data, "mouseBack", defaults.mouseBack)
			settings.mouseWheel = readSetting(data, "mouseWheel", defaults.mouseWheel)
			settings.hoverSelect = readSetting(data, "hoverSelect", defaults.hoverSelect)
		end
		local ranges = Config.RANGES
		settings.opacity = math.clamp(settings.opacity, ranges.opacity.min, ranges.opacity.max)
		settings.scale = math.clamp(settings.scale, ranges.scale.min, ranges.scale.max)
		settings.rows = math.clamp(math.floor(settings.rows), ranges.rows.min, ranges.rows.max)
		settings.offsetX = math.clamp(settings.offsetX, ranges.offsetX.min, ranges.offsetX.max)
		settings.offsetY = math.clamp(settings.offsetY, ranges.offsetY.min, ranges.offsetY.max)
		settings.repeatDelay =
			math.clamp(settings.repeatDelay, ranges.repeatDelay.min, ranges.repeatDelay.max)
		settings.repeatRate =
			math.clamp(settings.repeatRate, ranges.repeatRate.min, ranges.repeatRate.max)
		settings.fastSteps =
			math.clamp(settings.fastSteps, ranges.fastSteps.min, ranges.fastSteps.max)
		if not table.find(Config.FONTS, settings.font) then
			settings.font = defaults.font
		end
		if accentColor(settings.accent) == Config.ACCENTS[1].color then
			settings.accent = Config.ACCENTS[1].name
		end
		if #settings.keys.toggle == 0 then
			settings.watermark = true -- never start with no way to open the menu
		end
		return settings, found
	end

	function Store.save(settings: Settings): ()
		local ok, err = try(function()
			if not isfolder(Config.SAVE_FOLDER) then
				makefolder(Config.SAVE_FOLDER)
			end
			writefile(Config.SAVE_PATH, HttpService:JSONEncode(settings))
		end)
		if not ok then
			warn(`[CornyMenu] could not save settings: {err}`)
		end
	end

	-- ============ Canvas ============
	-- A display list rebuilt only when something changed; renderers replay it.
	local function newCanvas(): Canvas
		return setmetatable({ commands = {}, count = 0, alpha = 1, font = 0 }, Canvas)
	end

	local function round(value: number): number
		return math.floor(value + 0.5)
	end

	function Canvas.clear(self: Canvas): ()
		self.count = 0
		self.alpha = 1
	end

	function Canvas._push(self: Canvas, kind: CommandKind, color: Color3, opacity: number): Command
		local count = self.count + 1
		self.count = count
		local command = self.commands[count]
		if command == nil then
			command = {
				kind = kind,
				a = Vector2.zero,
				b = Vector2.zero,
				c = Vector2.zero,
				color = color,
				opacity = 1,
				thickness = 1,
				text = "",
				size = 14,
				font = 0,
				outlined = false,
				outlineColor = color,
				outlineOpacity = 0,
			}
			self.commands[count] = command
		end
		command.kind = kind
		command.color = color
		command.opacity = math.clamp(opacity * self.alpha, 0, 1)
		return command
	end

	function Canvas.rect(
		self: Canvas,
		x: number,
		y: number,
		w: number,
		h: number,
		color: Color3,
		opacity: number
	): ()
		local left, top = round(x), round(y)
		local width, height = round(x + w) - left, round(y + h) - top
		if width <= 0 or height <= 0 or opacity * self.alpha <= Config.MIN_OPACITY then
			return
		end
		local command = self:_push("rect", color, opacity)
		command.a = Vector2.new(left, top)
		command.b = Vector2.new(width, height)
	end

	function Canvas.outline(
		self: Canvas,
		x: number,
		y: number,
		w: number,
		h: number,
		color: Color3,
		opacity: number,
		thickness: number
	): ()
		local left, top = round(x), round(y)
		local width, height = round(x + w) - left, round(y + h) - top
		if width <= 0 or height <= 0 or opacity * self.alpha <= Config.MIN_OPACITY then
			return
		end
		local command = self:_push("outline", color, opacity)
		command.a = Vector2.new(left, top)
		command.b = Vector2.new(width, height)
		command.thickness = thickness
	end

	function Canvas.line(
		self: Canvas,
		x1: number,
		y1: number,
		x2: number,
		y2: number,
		color: Color3,
		opacity: number,
		thickness: number
	): ()
		if opacity * self.alpha <= Config.MIN_OPACITY or thickness <= 0 then
			return
		end
		local command = self:_push("line", color, opacity)
		command.a = Vector2.new(x1, y1)
		command.b = Vector2.new(x2, y2)
		command.thickness = thickness
	end

	function Canvas.triangle(
		self: Canvas,
		x1: number,
		y1: number,
		x2: number,
		y2: number,
		x3: number,
		y3: number,
		color: Color3,
		opacity: number
	): ()
		if opacity * self.alpha <= Config.MIN_OPACITY then
			return
		end
		local command = self:_push("triangle", color, opacity)
		command.a = Vector2.new(round(x1), round(y1))
		command.b = Vector2.new(round(x2), round(y2))
		command.c = Vector2.new(round(x3), round(y3))
	end

	function Canvas.text(
		self: Canvas,
		x: number,
		y: number,
		text: string,
		size: number,
		color: Color3,
		opacity: number,
		outlineColor: Color3?,
		outlineOpacity: number?
	): ()
		if text == "" or opacity * self.alpha <= Config.MIN_OPACITY then
			return
		end
		local command = self:_push("text", color, opacity)
		command.a = Vector2.new(round(x), round(y))
		command.text = text
		command.size = size
		command.font = self.font
		command.outlined = outlineColor ~= nil
		command.outlineColor = outlineColor or color
		command.outlineOpacity = math.clamp((outlineOpacity or 1) * self.alpha, 0, 1)
	end

	-- ============ Renderers ============
	local function paintImmediate(canvas: Canvas): ()
		local draw = DrawingImmediate
		local commands = canvas.commands
		for index = 1, canvas.count do
			local command = commands[index]
			local kind = command.kind
			if kind == "rect" then
				draw.FilledRectangle(command.a, command.b, command.color, command.opacity, 0)
			elseif kind == "outline" then
				draw.Rectangle(
					command.a,
					command.b,
					command.color,
					command.opacity,
					0,
					command.thickness
				)
			elseif kind == "line" then
				draw.Line(command.a, command.b, command.color, command.opacity, command.thickness)
			elseif kind == "triangle" then
				draw.FilledTriangle(command.a, command.b, command.c, command.color, command.opacity)
			elseif command.outlined then
				draw.OutlinedText(
					command.a,
					command.font,
					command.size,
					command.color,
					command.opacity,
					command.outlineColor,
					command.outlineOpacity,
					command.text,
					false
				)
			else
				draw.Text(
					command.a,
					command.font,
					command.size,
					command.color,
					command.opacity,
					command.text,
					false
				)
			end
		end
	end

	-- Volt's per-frame paint signal: nothing persists, so nothing can leak.
	local function newImmediateRenderer(): Renderer?
		if DrawingImmediate == nil then
			return nil
		end
		local current: Canvas? = nil
		local failed = false
		local destroyed = false
		-- a frame was handed over and no paint has run since: when, and frames checked
		local waitingSince: number? = nil
		local waitingFrames = 0
		local function onPaint(): ()
			waitingSince = nil
			waitingFrames = 0
			local canvas = current
			if canvas == nil or failed then
				return
			end
			local painted, err = try(paintImmediate, canvas)
			if not painted then
				failed = true
				warn(`[CornyMenu] DrawingImmediate failed: {err}`)
			end
		end
		local ok, connection = pcall(function(): VoltConnection
			return DrawingImmediate.GetPaint(Config.PAINT_LAYER):Connect(onPaint)
		end)
		if not ok then
			return nil
		end
		return {
			name = "immediate",
			present = function(canvas: Canvas)
				if destroyed then
					return
				end
				current = canvas
				if waitingSince == nil then
					waitingSince = os.clock()
				end
			end,
			-- Called once per frame. False once painting failed, or when the paint signal
			-- has not fired for a while after a frame was handed over (it never fires on
			-- this executor): the menu then switches to the retained renderer. Only counts
			-- while the game window has focus, as paint may pause in the background.
			healthy = function(watching: boolean): boolean
				local since = waitingSince
				if failed then
					return false
				end
				if since == nil then
					return true
				end
				if not watching then
					waitingSince = os.clock()
					waitingFrames = 0
					return true
				end
				waitingFrames += 1
				return waitingFrames < Config.PAINT_WATCHDOG_FRAMES
					or os.clock() - since < Config.PAINT_WATCHDOG
			end,
			destroy = function()
				destroyed = true
				current = nil
				connection:Disconnect()
			end,
		}
	end

	-- Pooled Drawing.new objects; a property is only written when it changed. A property
	-- the executor rejects is warned about once and skipped from then on; a failed
	-- Drawing.new is warned once and tried again after DRAWING_RETRY seconds, while the
	-- objects that already exist keep drawing.
	local function newRetainedRenderer(): Renderer
		local creators: { [string]: () -> any } = {
			Square = function(): any
				return Drawing.new("Square")
			end,
			Line = function(): any
				return Drawing.new("Line")
			end,
			Triangle = function(): any
				return Drawing.new("Triangle")
			end,
			Text = function(): any
				return Drawing.new("Text")
			end,
		}
		local classOf: { [string]: string } = {
			rect = "Square",
			outline = "Square",
			line = "Line",
			triangle = "Triangle",
			text = "Text",
		}
		local pools: { [string]: { any } } = { Square = {}, Line = {}, Triangle = {}, Text = {} }
		local caches: { [any]: { [string]: any } } = {}
		local retryAt: { [string]: number } = {} -- class -> when Drawing.new may be tried again
		local warned: { [string]: boolean } = {}
		local destroyed = false

		local function warnOnce(key: string, message: string): ()
			if not warned[key] then
				warned[key] = true
				warn(`[CornyMenu] retained renderer: {message}`)
			end
		end

		-- any: Drawing objects are executor userdata; properties are written by name
		local function writeProperty(
			object: any,
			cache: { [string]: any },
			key: string,
			value: any
		): ()
			if cache[key] == value then
				return
			end
			cache[key] = value -- kept even when the write fails, so it is not retried every frame
			local ok, err = try(function()
				object[key] = value
			end)
			if not ok then
				warnOnce(key, `could not set {key}: {err}`)
			end
		end

		local function present(canvas: Canvas): ()
			if destroyed then
				return
			end
			local used: { [string]: number } = { Square = 0, Line = 0, Triangle = 0, Text = 0 }
			local commands = canvas.commands
			for index = 1, canvas.count do
				local command = commands[index]
				local class = classOf[command.kind]
				local slot = used[class] + 1
				local pool = pools[class]
				local object = pool[slot]
				if object == nil then
					if os.clock() < (retryAt[class] or 0) then
						continue
					end
					local ok, created = try(creators[class])
					if not ok or created == nil then
						retryAt[class] = os.clock() + Config.DRAWING_RETRY
						warnOnce(
							class,
							`Drawing.new("{class}") failed, skipping new ones for now: {created}`
						)
						continue
					end
					object = created
					pool[slot] = object
					caches[object] = {}
					writeProperty(object, caches[object], "Visible", false)
				end
				used[class] = slot
				local cache = caches[object]
				writeProperty(object, cache, "ZIndex", Config.OBJECT_Z + index)
				writeProperty(object, cache, "Color", command.color)
				writeProperty(object, cache, "Transparency", command.opacity)
				local kind = command.kind
				if kind == "rect" or kind == "outline" then
					writeProperty(object, cache, "Filled", kind == "rect")
					writeProperty(object, cache, "Thickness", command.thickness)
					writeProperty(object, cache, "Position", command.a)
					writeProperty(object, cache, "Size", command.b)
				elseif kind == "line" then
					writeProperty(object, cache, "From", command.a)
					writeProperty(object, cache, "To", command.b)
					writeProperty(object, cache, "Thickness", command.thickness)
				elseif kind == "triangle" then
					writeProperty(object, cache, "Filled", true)
					writeProperty(object, cache, "PointA", command.a)
					writeProperty(object, cache, "PointB", command.b)
					writeProperty(object, cache, "PointC", command.c)
				else
					writeProperty(object, cache, "Text", command.text)
					writeProperty(object, cache, "Size", command.size)
					writeProperty(object, cache, "Font", command.font)
					writeProperty(object, cache, "Position", command.a)
					writeProperty(object, cache, "Center", false)
					writeProperty(object, cache, "Outline", command.outlined)
					if command.outlined then
						writeProperty(object, cache, "OutlineColor", command.outlineColor)
						writeProperty(object, cache, "OutlineOpacity", command.outlineOpacity)
					end
				end
				writeProperty(object, cache, "Visible", true)
			end
			for class, pool in pools do
				for slot = used[class] + 1, #pool do
					local object = pool[slot]
					writeProperty(object, caches[object], "Visible", false)
				end
			end
		end

		return {
			name = "retained",
			present = present,
			healthy = function(_watching: boolean): boolean
				return true
			end,
			destroy = function()
				destroyed = true
				for _, pool in pools do
					for _, object in pool do
						-- an object the executor already removed may throw; it is gone either way
						pcall(function()
							object:Remove()
						end)
					end
					table.clear(pool)
				end
				table.clear(caches)
			end,
		}
	end

	local function pickRenderer(): Renderer
		local wanted = getgenv()[Config.RENDERER_KEY]
		if wanted ~= "retained" then
			local immediate = newImmediateRenderer()
			if immediate then
				return immediate
			end
		end
		return newRetainedRenderer()
	end

	-- ============ Text measuring ============
	local narrowBytes: { [number]: boolean } = {}
	for _, byte in { string.byte(Config.NARROW_CHARS, 1, -1) } do
		narrowBytes[byte] = true
	end
	table.freeze(narrowBytes)
	local wideBytes: { [number]: boolean } = {}
	for _, byte in { string.byte(Config.WIDE_CHARS, 1, -1) } do
		wideBytes[byte] = true
	end
	table.freeze(wideBytes)

	-- Used when Drawing TextBounds is not available
	local function estimateWidth(text: string, size: number): number
		local units = 0
		for index = 1, #text do
			local byte = string.byte(text, index)
			-- a little wide on purpose: wrapping early beats running past the panel
			if byte == 32 or narrowBytes[byte] then
				units += 0.32
			elseif wideBytes[byte] then
				units += 0.86
			elseif byte >= 65 and byte <= 90 then
				units += 0.68
			else
				units += 0.56
			end
		end
		return units * size
	end

	-- UTF-8: whether byte `index` of `text` continues a character (10xxxxxx)
	local function continues(text: string, index: number): boolean
		local byte = string.byte(text, index)
		return byte ~= nil and byte >= 0x80 and byte < 0xC0
	end

	-- The longest prefix length <= `length` that ends on a whole character
	local function wholePrefix(text: string, length: number): number
		while length > 0 and continues(text, length + 1) do
			length -= 1
		end
		return length
	end

	-- The longest suffix length <= `length` that starts on a whole character
	local function wholeSuffix(text: string, length: number): number
		while length > 0 and continues(text, #text - length + 1) do
			length -= 1
		end
		return length
	end

	local function newTextMeasure(): TextMeasure
		local self = setmetatable({} :: TextMeasureFields, TextMeasure)
		self._widths = {}
		self._strings = {}
		self._wraps = {}
		self._entries = 0
		self._misses = 0
		self._estimate = false
		local ok, probe = pcall(function(): DrawingText
			local text = Drawing.new("Text")
			text.Visible = false
			return text
		end)
		if ok then
			self._probe = probe
		else
			self._estimate = true
		end
		return self
	end

	function TextMeasure._count(self: TextMeasure): ()
		self._entries += 1
		if self._entries > Config.MEASURE_CACHE then
			self._entries = 0
			table.clear(self._widths)
			table.clear(self._strings)
			table.clear(self._wraps)
		end
	end

	function TextMeasure.width(self: TextMeasure, text: string, size: number, font: number): number
		if text == "" then
			return 0
		end
		local key = `{font}|{size}|{text}`
		local cached = self._widths[key]
		if cached then
			return cached
		end
		local measured: number? = nil
		local probe = self._probe
		if probe and not self._estimate then
			local ok, bounds = pcall(function(): Vector2
				probe.Font = font
				probe.Size = size
				probe.Text = text
				return probe.TextBounds
			end)
			if ok and typeof(bounds) == "Vector2" and bounds.X > 0 then
				measured = bounds.X
				self._misses = 0
			else
				self._misses += 1
				if self._misses >= Config.MEASURE_MISSES then
					self._estimate = true
					warn(
						"[CornyMenu] Drawing TextBounds is unavailable - text widths are estimated"
					)
				end
			end
		end
		local width = measured or estimateWidth(text, size)
		self:_count()
		self._widths[key] = width
		return width
	end

	-- Longest prefix length of `text` that fits in maxWidth (at least 1)
	function TextMeasure._prefix(
		self: TextMeasure,
		text: string,
		maxWidth: number,
		size: number,
		font: number
	): number
		local low, high = 1, #text
		while low < high do
			local middle = (low + high + 1) // 2
			if self:width(string.sub(text, 1, middle), size, font) <= maxWidth then
				low = middle
			else
				high = middle - 1
			end
		end
		local whole = wholePrefix(text, low)
		if whole > 0 then
			return whole
		end
		-- not even one character fits: take the first one whole anyway
		local stop = low
		while continues(text, stop + 1) do
			stop += 1
		end
		return stop
	end

	-- `text` cut to maxWidth with "..." at the end
	function TextMeasure.fit(
		self: TextMeasure,
		text: string,
		maxWidth: number,
		size: number,
		font: number
	): string
		if self:width(text, size, font) <= maxWidth then
			return text
		end
		if maxWidth <= 0 then
			return ""
		end
		local key = `fit|{font}|{size}|{math.floor(maxWidth)}|{text}`
		local cached = self._strings[key]
		if cached then
			return cached
		end
		local low, high = 0, #text
		while low < high do
			local middle = (low + high + 1) // 2
			if self:width(string.sub(text, 1, middle) .. "...", size, font) <= maxWidth then
				low = middle
			else
				high = middle - 1
			end
		end
		low = wholePrefix(text, low)
		local head = string.gsub(string.sub(text, 1, low), "%s+$", "")
		local result = if low > 0 then head .. "..." else ""
		self:_count()
		self._strings[key] = result
		return result
	end

	-- `text` cut to maxWidth from the left: "...end of the text"
	function TextMeasure.fitStart(
		self: TextMeasure,
		text: string,
		maxWidth: number,
		size: number,
		font: number
	): string
		if self:width(text, size, font) <= maxWidth then
			return text
		end
		local key = `start|{font}|{size}|{math.floor(maxWidth)}|{text}`
		local cached = self._strings[key]
		if cached then
			return cached
		end
		local length = #text
		local low, high = 0, length
		while low < high do
			local middle = (low + high + 1) // 2
			if
				self:width("..." .. string.sub(text, length - middle + 1), size, font) <= maxWidth
			then
				low = middle
			else
				high = middle - 1
			end
		end
		low = wholeSuffix(text, low)
		local result = if low > 0 then "..." .. string.sub(text, length - low + 1) else ""
		self:_count()
		self._strings[key] = result
		return result
	end

	-- The end of `text` that fits (no dots): the visible part of a field being typed in
	function TextMeasure.tail(
		self: TextMeasure,
		text: string,
		maxWidth: number,
		size: number,
		font: number
	): string
		if self:width(text, size, font) <= maxWidth then
			return text
		end
		local length = #text
		local low, high = 0, length
		while low < high do
			local middle = (low + high + 1) // 2
			if self:width(string.sub(text, length - middle + 1), size, font) <= maxWidth then
				low = middle
			else
				high = middle - 1
			end
		end
		return string.sub(text, length - wholeSuffix(text, low) + 1)
	end

	-- Word-wrapped lines (at most maxLines; cut text ends in "...")
	function TextMeasure.wrap(
		self: TextMeasure,
		text: string,
		maxWidth: number,
		size: number,
		font: number,
		maxLines: number
	): { string }
		local key = `{font}|{size}|{math.floor(maxWidth)}|{maxLines}|{text}`
		local cached = self._wraps[key]
		if cached then
			return cached
		end
		local lines: { string } = {}
		local overflow = false
		local function push(line: string): boolean
			if #lines >= maxLines then
				overflow = true
				return false
			end
			table.insert(lines, line)
			return true
		end
		for paragraph in string.gmatch(text .. "\n", "(.-)\n") do
			if overflow then
				break
			end
			if self:width(paragraph, size, font) <= maxWidth then
				push(paragraph)
				continue
			end
			local line = ""
			for word in string.gmatch(paragraph, "%S+") do
				local candidate = if line == "" then word else `{line} {word}`
				if self:width(candidate, size, font) <= maxWidth then
					line = candidate
					continue
				end
				if line ~= "" and not push(line) then
					break
				end
				while #word > 1 and self:width(word, size, font) > maxWidth do
					local cut = self:_prefix(word, maxWidth, size, font)
					if not push(string.sub(word, 1, cut)) then
						break
					end
					word = string.sub(word, cut + 1)
				end
				if overflow then
					break
				end
				line = word
			end
			if not overflow and line ~= "" then
				push(line)
			end
		end
		if overflow and #lines > 0 then
			lines[#lines] = self:fit(lines[#lines] .. " ...", maxWidth, size, font)
		end
		self:_count()
		self._wraps[key] = lines
		return lines
	end

	function TextMeasure.Destroy(self: TextMeasure): ()
		local probe = self._probe
		self._probe = nil
		if probe then
			-- an object the executor already removed may throw; it is gone either way
			pcall(function()
				probe:Remove()
			end)
		end
	end

	-- ============ Painters (canvas rows and overlays) ============
	local function inside(clip: Rect, x: number, y: number): boolean
		return x >= clip.x and x <= clip.x + clip.w and y >= clip.y and y <= clip.y + clip.h
	end

	local function clipRect(
		x: number,
		y: number,
		w: number,
		h: number,
		clip: Rect?
	): (boolean, number, number, number, number)
		if clip == nil then
			return w > 0 and h > 0, x, y, w, h
		end
		local left = math.max(x, clip.x)
		local top = math.max(y, clip.y)
		local right = math.min(x + w, clip.x + clip.w)
		local bottom = math.min(y + h, clip.y + clip.h)
		return right > left and bottom > top, left, top, right - left, bottom - top
	end

	-- Liang-Barsky: narrows the kept part (t0..t1) of a line to one clip edge
	local function clipEdge(p: number, q: number, t0: number, t1: number): (boolean, number, number)
		if p == 0 then
			return q >= 0, t0, t1
		end
		local t = q / p
		if p < 0 then
			t0 = math.max(t0, t)
		else
			t1 = math.min(t1, t)
		end
		return t0 <= t1, t0, t1
	end

	local function clipLine(
		x1: number,
		y1: number,
		x2: number,
		y2: number,
		clip: Rect?
	): (boolean, number, number, number, number)
		if clip == nil then
			return true, x1, y1, x2, y2
		end
		local dx, dy = x2 - x1, y2 - y1
		local ok, t0, t1 = clipEdge(-dx, x1 - clip.x, 0, 1)
		if ok then
			ok, t0, t1 = clipEdge(dx, clip.x + clip.w - x1, t0, t1)
		end
		if ok then
			ok, t0, t1 = clipEdge(-dy, y1 - clip.y, t0, t1)
		end
		if ok then
			ok, t0, t1 = clipEdge(dy, clip.y + clip.h - y1, t0, t1)
		end
		if not ok then
			return false, 0, 0, 0, 0
		end
		return true, x1 + t0 * dx, y1 + t0 * dy, x1 + t1 * dx, y1 + t1 * dy
	end

	-- The draw table handed to painters. One per menu, re-aimed before every call
	-- (Menu._paint): coordinates are local to menu.drawTarget and clipped to its rect.
	local function newDraw(menu: Menu): CornyMenuDraw
		local target = menu.drawTarget
		local draw: CornyMenuDraw = {
			width = 0,
			height = 0,
			time = 0,
			scale = 1,
			accent = Palette.white,
			rect = function(
				_: CornyMenuDraw,
				x: number,
				y: number,
				w: number,
				h: number,
				color: Color3,
				opacity: number?
			): ()
				local ok, left, top, width, height =
					clipRect(target.originX + x, target.originY + y, w, h, target.clip)
				if ok then
					menu.canvas:rect(left, top, width, height, color, opacity or 1)
				end
			end,
			outline = function(
				self: CornyMenuDraw,
				x: number,
				y: number,
				w: number,
				h: number,
				color: Color3,
				opacity: number?,
				thickness: number?
			): ()
				local px = thickness or 1
				local screenX, screenY = target.originX + x, target.originY + y
				local clip = target.clip
				if
					clip == nil
					or (inside(clip, screenX, screenY) and inside(clip, screenX + w, screenY + h))
				then
					menu.canvas:outline(screenX, screenY, w, h, color, opacity or 1, px)
					return
				end
				-- partly outside: four clipped bars
				self:rect(x, y, w, px, color, opacity)
				self:rect(x, y + h - px, w, px, color, opacity)
				self:rect(x, y, px, h, color, opacity)
				self:rect(x + w - px, y, px, h, color, opacity)
			end,
			line = function(
				_: CornyMenuDraw,
				x1: number,
				y1: number,
				x2: number,
				y2: number,
				color: Color3,
				opacity: number?,
				thickness: number?
			): ()
				local ox, oy = target.originX, target.originY
				local ok, ax, ay, bx, by = clipLine(ox + x1, oy + y1, ox + x2, oy + y2, target.clip)
				if ok then
					menu.canvas:line(ax, ay, bx, by, color, opacity or 1, thickness or 1)
				end
			end,
			triangle = function(
				_: CornyMenuDraw,
				x1: number,
				y1: number,
				x2: number,
				y2: number,
				x3: number,
				y3: number,
				color: Color3,
				opacity: number?
			): ()
				local ox, oy = target.originX, target.originY
				local clip = target.clip
				if
					clip
					and not (
						inside(clip, ox + x1, oy + y1)
						and inside(clip, ox + x2, oy + y2)
						and inside(clip, ox + x3, oy + y3)
					)
				then
					return -- inside a canvas only whole triangles are drawn
				end
				menu.canvas:triangle(
					ox + x1,
					oy + y1,
					ox + x2,
					oy + y2,
					ox + x3,
					oy + y3,
					color,
					opacity or 1
				)
			end,
			text = function(
				_: CornyMenuDraw,
				x: number,
				y: number,
				text: string,
				size: number?,
				color: Color3?,
				opacity: number?
			): number
				local textSize = size or menu.metrics.small
				local width = menu.measure:width(text, textSize, menu.font)
				local screenX, screenY = target.originX + x, target.originY + y
				local clip = target.clip
				if
					clip == nil
					or (
						inside(clip, screenX, screenY)
						and inside(clip, screenX + width, screenY + textSize)
					)
				then
					menu.canvas:text(
						screenX,
						screenY,
						text,
						textSize,
						color or Palette.text,
						opacity or 1
					)
				end
				return width
			end,
			measure = function(_: CornyMenuDraw, text: string, size: number?): number
				return menu.measure:width(text, size or menu.metrics.small, menu.font)
			end,
		}
		return draw
	end

	-- ============ Option ============
	local function toChoices(choices: { any }): { Choice }
		local result: { Choice } = {}
		for _, entry in choices do
			if type(entry) == "table" then
				local text = entry.text or entry[1]
				local value = entry.value
				if value == nil then
					value = entry[2]
				end
				if value == nil then
					value = text
				end
				table.insert(result, { text = tostring(text), value = value })
			else
				table.insert(result, { text = tostring(entry), value = entry })
			end
		end
		return result
	end

	-- Index of the choice whose value (or else text) equals `wanted`
	local function findChoice(choices: { Choice }, wanted: any): number?
		for index, choice in choices do
			if choice.value == wanted then
				return index
			end
		end
		for index, choice in choices do
			if choice.text == wanted then
				return index
			end
		end
		return nil
	end

	local function snapSlider(slider: SliderState, value: number): number
		if not isFinite(value) then
			return slider.value
		end
		local steps = math.floor((value - slider.min) / slider.step + 0.5)
		local snapped = slider.min + steps * slider.step
		snapped = math.floor(snapped * 1e6 + 0.5) / 1e6
		return math.clamp(snapped, slider.min, slider.max)
	end

	local function newOption(
		page: Page,
		kind: OptionKind,
		text: string,
		opts: OptionOptions?
	): Option
		local self = setmetatable({} :: OptionFields, Option)
		self.kind = kind
		self.page = page
		self.text = text
		self.description = opts and opts.description
		self.visible = not (opts and opts.visible == false)
		self.enabled = not (opts and opts.enabled == false)
		self.color = opts and opts.color
		self.armedUntil = 0
		self.flashUntil = 0
		self.flashColor = Palette.bad
		self.destroyed = false
		return self
	end

	local function isSelectable(option: Option): boolean
		return option.visible and not option.destroyed and Config.SELECTABLE[option.kind] == true
	end

	-- Position of `option` among its page's selectable options (0 when it is not one),
	-- and how many selectable options the page has
	local function selectablePosition(page: Page, option: Option?): (number, number)
		local position, count = 0, 0
		for _, candidate in page.options do
			if isSelectable(candidate) then
				count += 1
				if rawequal(candidate, option) then
					position = count
				end
			end
		end
		return position, count
	end

	-- The page's highlight is going away: the option that takes its place gets it next
	-- (not the top of the page)
	local function rememberSelection(page: Page, option: Option): ()
		if page.restore == nil and rawequal(page.selected, option) then
			local position = selectablePosition(page, option)
			if position > 0 then
				page.restore = position
			end
		end
	end

	-- The highlight was moved on purpose (keys, mouse, a list opening): a remembered
	-- position no longer applies
	local function selectOption(page: Page, option: Option?): ()
		page.selected = option
		page.restore = nil
	end

	-- The page's highlight: a visible, selectable option of the page, or nil when it has
	-- none. When the highlighted option went away, the option now at its position takes
	-- over; while fewer options exist the last one stands in and the position is kept,
	-- so options added over several frames still get the highlight there. Used by the
	-- drawing and by every key that acts on the highlight.
	local function ensureSelection(page: Page): Option?
		local current = page.selected
		local wanted = page.restore
		if wanted == nil and current and rawequal(current.page, page) and isSelectable(current) then
			return current
		end
		local target = wanted or 1
		local position = 0
		local chosen: Option? = nil
		for _, option in page.options do
			if isSelectable(option) then
				position += 1
				chosen = option
				if position >= target then
					break
				end
			end
		end
		page.selected = chosen
		if chosen and position >= target then
			page.restore = nil
		end
		return chosen
	end

	function Option._changed(self: Option): ()
		self.page.menu:_markDirty()
	end

	function Option.setText(self: Option, text: string): ()
		self.text = tostring(text)
		self:_changed()
	end

	function Option.getText(self: Option): string
		return self.text
	end

	function Option.setDescription(self: Option, text: string?): ()
		self.description = text
		self:_changed()
	end

	function Option.setVisible(self: Option, visible: boolean): ()
		local shown = visible == true
		if self.visible and not shown then
			rememberSelection(self.page, self)
			self.page.menu:_releaseOption(self)
		end
		self.visible = shown
		self:_changed()
	end

	function Option.setEnabled(self: Option, enabled: boolean): ()
		self.enabled = enabled == true
		if not self.enabled then
			self.page.menu:_releaseOption(self)
		end
		self:_changed()
	end

	function Option.setColor(self: Option, color: Color3?): ()
		self.color = color
		self:_changed()
	end

	function Option.setBadge(self: Option, text: string?): ()
		self.badge = text
		self:_changed()
	end

	-- Briefly tints the option's text (default: red for "that did not work")
	function Option.flash(self: Option, color: Color3?): ()
		self.flashUntil = os.clock() + Config.FLASH_TIME
		self.flashColor = color or Palette.bad
		self:_changed()
	end

	-- any: the value type depends on the kind (see the API list at the top)
	function Option.get(self: Option): any
		local toggle = self.toggle
		if toggle then
			return toggle.on
		end
		local cycle = self.cycle
		if cycle then
			local choice = cycle.choices[cycle.index]
			return if choice then choice.value else nil
		end
		local slider = self.slider
		if slider then
			return slider.value
		end
		local input = self.input
		if input then
			if input.numeric then
				return tonumber(input.value)
			end
			return input.value
		end
		local keybind = self.keybind
		if keybind then
			return keybind.key
		end
		local list = self.list
		if list then
			return list.selected
		end
		return self.text
	end

	-- Sets the value without firing the callback. Labels: set(text, color?).
	function Option.set(self: Option, value: any, color: Color3?): ()
		local kind = self.kind
		if kind == "label" or kind == "header" or kind == "button" then
			self.text = tostring(value)
			if color then
				self.color = color
			end
		elseif self.toggle then
			self.toggle.on = value == true
		elseif self.cycle then
			local index = findChoice(self.cycle.choices, value)
			if index then
				self.cycle.index = index
			end
		elseif self.slider then
			local number = tonumber(value)
			if number then
				self.slider.value = snapSlider(self.slider, number)
			end
		elseif self.input then
			self.input.value = if type(value) == "number"
				then formatNumber(value)
				else tostring(value or "")
		elseif self.keybind then
			if value == nil then
				self.keybind.key = nil
			elseif typeof(value) == "EnumItem" then
				local key = keysByName[value.Name]
				if key == value then
					self.keybind.key = key
				end
			end
		elseif self.list then
			self.list.selected = if value == nil then nil else tostring(value)
		end
		self:_changed()
	end

	-- Cycle: replace the choices, keeping the current value when it still exists
	function Option.setChoices(self: Option, choices: { any }): ()
		local cycle = self.cycle
		assert(cycle, "CornyMenu: setChoices is for cycle options")
		local list = toChoices(choices)
		assert(#list > 0, "CornyMenu: a cycle needs at least one choice")
		local current = cycle.choices[cycle.index]
		cycle.choices = list
		cycle.index = (current and findChoice(list, current.value)) or 1
		self:_changed()
	end

	function Option.setRange(self: Option, min: number, max: number, step: number?): ()
		local slider = self.slider
		assert(slider, "CornyMenu: setRange is for slider options")
		assert(max > min, "CornyMenu: slider max must be above min")
		slider.min = min
		slider.max = max
		slider.step = if step and step > 0 then step else slider.step
		slider.value = snapSlider(slider, slider.value)
		self:_changed()
	end

	-- List: replace the items; the selection is kept only if its key still exists
	function Option.setItems(self: Option, items: { ListItem }): ()
		local list = self.list
		assert(list, "CornyMenu: setItems is for list options")
		local copy: { ListItem } = {}
		local keep = false
		for _, item in items do
			assert(
				type(item.key) == "string" and type(item.text) == "string",
				"CornyMenu: list items need a key and text"
			)
			table.insert(copy, item)
			if item.key == list.selected then
				keep = true
			end
		end
		list.items = copy
		if not keep then
			list.selected = nil
		end
		self.page.menu:_listChanged(self)
	end

	function Option.select(self: Option, key: string?): ()
		local list = self.list
		assert(list, "CornyMenu: select is for list options")
		list.selected = key
		self:_changed()
	end

	-- Replaces the option's callback (same arguments as the constructor's callback)
	function Option.onChange(self: Option, callback: ((...any) -> ())?): ()
		self.callback = callback
	end

	-- Canvas rows: run the painter again on the next frame
	function Option.redraw(self: Option): ()
		self:_changed()
	end

	-- Canvas rows: run the painter every frame while the row is on screen
	function Option.setAnimated(self: Option, animate: boolean): ()
		local canvas = self.canvas
		assert(canvas, "CornyMenu: setAnimated is for canvas rows")
		canvas.animate = animate == true
		self:_changed()
	end

	-- Submenus and lists: show the page they open
	function Option.open(self: Option): ()
		local target = self.target
		if target then
			target:open()
		end
	end

	function Option.Destroy(self: Option): ()
		if self.destroyed then
			return
		end
		self.page:_removeOption(self)
	end

	-- ============ Page ============
	local function newPage(menu: Menu, name: string, parent: Page?): Page
		local self = setmetatable({} :: PageFields, Page)
		self.menu = menu
		self.name = name
		self.title = name
		self.parent = parent
		self.options = {}
		self.children = {}
		self.scroll = 1
		self.janitor = newJanitor()
		self.destroyed = false
		return self
	end

	function Page._add(self: Page, kind: OptionKind, text: string, opts: OptionOptions?): Option
		assert(not self.destroyed, "CornyMenu: this page was destroyed")
		local option = newOption(self, kind, text, opts)
		table.insert(self.options, option)
		self.menu:_markDirty()
		return option
	end

	function Page._removeOption(self: Page, option: Option): ()
		local menu = self.menu
		rememberSelection(self, option)
		menu:_releaseOption(option) -- while it is still alive, so a canvas gets its "up"
		local index = table.find(self.options, option)
		if index then
			table.remove(self.options, index)
		end
		if rawequal(self.selected, option) then
			self.selected = nil
		end
		option.destroyed = true
		local target = option.target
		if target and not target.destroyed then
			target:Destroy()
		end
		menu:_markDirty()
	end

	function Page.header(self: Page, text: string): Option
		return self:_add("header", text, nil)
	end

	function Page.label(self: Page, text: string, opts: OptionOptions?): Option
		return self:_add("label", text, opts)
	end

	function Page.separator(self: Page): Option
		return self:_add("separator", "", nil)
	end

	function Page.button(
		self: Page,
		text: string,
		callback: (() -> ())?,
		opts: OptionOptions?
	): Option
		local option = self:_add("button", text, opts)
		option.callback = callback
		local confirm = opts and opts.confirm
		if confirm then
			option.confirm = if type(confirm) == "string" then confirm else "Press again to confirm"
		end
		return option
	end

	function Page.toggle(
		self: Page,
		text: string,
		default: boolean?,
		callback: ((on: boolean) -> ())?,
		opts: OptionOptions?
	): Option
		local option = self:_add("toggle", text, opts)
		local on = default == true
		option.toggle = { on = on, fill = if on then 1 else 0 }
		option.callback = callback
		return option
	end

	function Page.cycle(
		self: Page,
		text: string,
		choices: { any },
		default: any,
		callback: ((value: any, text: string) -> ())?,
		opts: OptionOptions?
	): Option
		local list = toChoices(choices)
		assert(#list > 0, "CornyMenu: a cycle needs at least one choice")
		local option = self:_add("cycle", text, opts)
		option.cycle = { choices = list, index = findChoice(list, default) or 1 }
		option.callback = callback
		return option
	end

	function Page.slider(
		self: Page,
		text: string,
		default: number,
		callback: ((value: number) -> ())?,
		opts: OptionOptions
	): Option
		local min, max = opts.min, opts.max
		assert(min and max and max > min, "CornyMenu: a slider needs opts.min < opts.max")
		local step = opts.step or 1
		assert(step > 0, "CornyMenu: slider step must be above 0")
		local option = self:_add("slider", text, opts)
		local slider: SliderState = {
			min = min,
			max = max,
			step = step,
			value = min,
			format = opts.format or formatNumber,
			barX = 0,
			barWidth = 1,
		}
		slider.value = snapSlider(slider, default)
		option.slider = slider
		option.callback = callback
		return option
	end

	function Page.input(
		self: Page,
		text: string,
		default: (string | number)?,
		callback: ((value: any) -> ())?,
		opts: OptionOptions?
	): Option
		local option = self:_add("input", text, opts)
		local numeric = opts ~= nil and opts.numeric == true
		local placeholder = (opts and opts.placeholder) or (if numeric then "0" else "Type here")
		option.input = {
			value = if default == nil
				then ""
				elseif type(default) == "number" then formatNumber(default)
				else default,
			placeholder = placeholder,
			numeric = numeric,
			min = (opts and opts.min) or -math.huge,
			max = (opts and opts.max) or math.huge,
			integer = opts ~= nil and opts.integer == true,
			maxLength = (opts and opts.maxLength) or Config.INPUT_LENGTH,
			search = false,
		}
		option.callback = callback
		return option
	end

	function Page.keybind(
		self: Page,
		text: string,
		default: Enum.KeyCode?,
		callback: ((key: Enum.KeyCode?) -> ())?,
		opts: OptionOptions?
	): Option
		local option = self:_add("keybind", text, opts)
		option.keybind = { key = default }
		option.callback = callback
		return option
	end

	-- `items` is required (pass {} to fill it later with setItems): the strict checker
	-- cannot type a literal with mixed-shape items through an optional parameter
	function Page.list(
		self: Page,
		text: string,
		items: { ListItem },
		callback: ((key: string, item: ListItem) -> ())?,
		opts: OptionOptions?
	): Option
		local option = self:_add("list", text, opts)
		local listPage = newPage(self.menu, text, self)
		listPage.owner = option
		listPage.entry = option
		table.insert(self.children, listPage)
		option.target = listPage
		option.list = {
			items = {},
			selected = nil,
			searchable = opts and opts.searchable,
			stay = opts ~= nil and opts.stay == true,
			placeholder = (opts and opts.placeholder) or "None",
			emptyText = (opts and opts.emptyText) or "Nothing here",
			query = "",
			search = nil,
			onHighlight = opts and opts.onHighlight,
		}
		option.callback = callback
		if items then
			option:setItems(items)
		end
		return option
	end

	function Page.submenu(self: Page, text: string, opts: OptionOptions?): Page
		local child = newPage(self.menu, text, self)
		local entry = self:_add("submenu", text, opts)
		entry.target = child
		child.entry = entry
		table.insert(self.children, child)
		return child
	end

	-- A row `height` pixels tall (at 100% size) that the script draws into with a
	-- painter (a preview, a graph...). The painter runs whenever the menu redraws
	-- while the row is on screen, every frame with opts.animate; opts.onMouse gets
	-- "down" / "move" / "up" / "wheel" with row-local coordinates.
	function Page.canvas(
		self: Page,
		height: number,
		painter: CornyMenuPainter,
		opts: OptionOptions?
	): Option
		local option = self:_add("canvas", "", opts)
		option.canvas = {
			height = math.max(Config.CANVAS_MIN, height),
			painter = painter,
			animate = opts ~= nil and opts.animate == true,
			onMouse = opts and opts.onMouse,
			rect = nil,
		}
		return option
	end

	-- A painter for the whole screen, drawn under the menu (a selection box,
	-- markers...). Screen coordinates, no clipping. Removed with the page.
	function Page.overlay(self: Page, painter: CornyMenuPainter, opts: OptionOptions?): Layer
		assert(not self.destroyed, "CornyMenu: this page was destroyed")
		local menu = self.menu
		local layer = setmetatable({} :: LayerFields, Layer)
		layer.menu = menu
		layer.label = `{self.name} overlay`
		layer.painter = painter
		layer.visible = not (opts and opts.visible == false)
		layer.animate = opts ~= nil and opts.animate == true
		layer.destroyed = false
		table.insert(menu.layers, layer)
		self.janitor:give(function()
			layer:Destroy()
		end)
		menu:_markDirty()
		return layer
	end

	-- HUD owned by the page: the same as menu:task / prompt / hidePrompt / status, but
	-- removed when the page is destroyed. On a page that is already gone (an old copy of
	-- a re-run script) they do nothing visible, so they cannot touch the new copy's HUD.
	function Page.task(self: Page, title: string, opts: TaskOptions?): Task
		return self.menu:_task(title, opts, self)
	end

	function Page.prompt(self: Page, id: string, spec: PromptSpec): ()
		if self.destroyed then
			return
		end
		local shown: PromptSpec? = spec -- nil from a non-strict script hides it
		if shown == nil then
			self:hidePrompt(id)
			return
		end
		self.menu:_setPrompt(id, shown, self)
	end

	-- Hides the prompt `id` if this page set it
	function Page.hidePrompt(self: Page, id: string): ()
		self.menu:_removePrompt(id, self)
	end

	-- A watermark segment; nil text removes it if this page set it
	function Page.status(self: Page, id: string, text: string?, color: Color3?): ()
		if not self.destroyed then
			self.menu:_setStatus(id, text, color, self)
		end
	end

	function Page.onDestroy(self: Page, callback: () -> ()): ()
		self:track(callback)
	end

	-- `item` is cleaned up with the page; on a page that is already gone, right away
	-- (a script still running after its page was replaced must not leak)
	function Page.track(self: Page, item: unknown): ()
		self.janitor:give(item)
		if self.destroyed then
			self.janitor:destroy()
		end
	end

	function Page.open(self: Page): ()
		self.menu:_showPage(self)
	end

	function Page.isShowing(self: Page): boolean
		local menu = self.menu
		return menu.opened and rawequal(menu.stack[#menu.stack], self)
	end

	function Page.setTitle(self: Page, title: string): ()
		self.title = title
		self.menu:_markDirty()
	end

	function Page.setBadge(self: Page, text: string?): ()
		local entry = self.entry
		if entry then
			entry:setBadge(text)
		end
	end

	-- Removes every option. Options added next take the highlight at the same position,
	-- so "clear and add again" refreshes a page without the highlight jumping to the top.
	function Page.clear(self: Page): ()
		local selected = self.selected
		if selected then
			rememberSelection(self, selected)
		end
		for _, option in table.clone(self.options) do
			option:Destroy()
		end
	end

	function Page.Destroy(self: Page): ()
		if self.destroyed then
			return
		end
		self.destroyed = true
		local menu = self.menu
		for _, child in table.clone(self.children) do
			child:Destroy()
		end
		table.clear(self.children)
		self.janitor:destroy()
		for _, option in self.options do
			option.destroyed = true
		end
		local parent = self.parent
		if parent and not parent.destroyed then
			local index = table.find(parent.children, self)
			if index then
				table.remove(parent.children, index)
			end
			local entry = self.entry
			if entry and self.owner == nil then
				parent:_removeOption(entry)
			end
		end
		menu:_pageDestroyed(self)
	end

	-- ============ Task (progress card) ============
	local function newTask(menu: Menu, title: string, opts: TaskOptions?): Task
		local self = setmetatable({} :: TaskFields, Task)
		self.menu = menu
		self.title = title
		self.phase = "Starting..."
		self.detail = ""
		self.done = 0
		self.total = (opts and opts.total) or 0
		self.started = os.clock()
		self.ok = true
		self.onStop = opts and opts.onStop
		self.stopped = false
		self.removed = false
		self.closing = false
		self.fade = if menu.settings.animations then 0 else 1
		return self
	end

	function Task.set(self: Task, update: TaskUpdate): ()
		if update.title then
			self.title = update.title
		end
		if update.phase then
			self.phase = update.phase
		end
		if update.detail then
			self.detail = update.detail
		end
		if update.done then
			self.done = update.done
		end
		if update.total then
			self.total = update.total
		end
		self.menu:_markDirty()
	end

	function Task.step(self: Task, amount: number?): ()
		self.done += amount or 1
		self.menu:_markDirty()
	end

	function Task.finish(self: Task, message: string?, ok: boolean?): ()
		if self.ended then
			return
		end
		self.ended = os.clock()
		self.ok = ok ~= false
		self.phase = message or (if self.ok then "Done" else "Failed")
		self.menu:_markDirty()
	end

	function Task.isStopped(self: Task): boolean
		return self.stopped
	end

	function Task.Destroy(self: Task): ()
		self.removed = true
		self.menu:_markDirty()
	end

	function Task._requestStop(self: Task): ()
		if self.stopped or self.ended or self.removed then
			return
		end
		self.stopped = true
		self.phase = "Stopping after the current step..."
		spawnCallback(`task {self.title}`, self.onStop)
		self.menu:_markDirty()
	end

	-- ============ Layer (screen-wide painter) ============
	function Layer.redraw(self: Layer): ()
		self.menu:_markDirty()
	end

	function Layer.setVisible(self: Layer, visible: boolean): ()
		self.visible = visible == true
		self.menu:_markDirty()
	end

	function Layer.setAnimated(self: Layer, animate: boolean): ()
		self.animate = animate == true
		self.menu:_markDirty()
	end

	function Layer.Destroy(self: Layer): ()
		if self.destroyed then
			return
		end
		self.destroyed = true
		local layers = self.menu.layers
		for index, layer in layers do
			if rawequal(layer, self) then
				table.remove(layers, index)
				break
			end
		end
		self.menu:_markDirty()
	end

	-- ============ Menu: state ============
	-- The only GUI the menu makes: input catchers that are never visible. GUI shows up
	-- in stream capture and the Drawing layer does not, so nothing here may render:
	-- no background, border, text, caret or gamepad selection frame.
	local function makeInvisible(object: GuiObject): ()
		object.BackgroundTransparency = 1
		object.BorderSizePixel = 0
		object.Selectable = false
	end

	local function newGuiBridge(menu: Menu): GuiBridge?
		local ok, result = pcall(function(): GuiBridge
			local screen = Instance.new("ScreenGui")
			screen.Name = "CornyMenu"
			screen.ResetOnSpawn = false
			screen.IgnoreGuiInset = true -- same coordinates as the mouse and the Drawing layer
			screen.DisplayOrder = Config.GUI_ORDER
			screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			-- typing goes through a text box parked off screen: transparent, and even
			-- its caret and selection highlight fall outside the window
			local input = Instance.new("TextBox")
			input.Name = "Input"
			makeInvisible(input)
			input.TextTransparency = 1
			input.TextStrokeTransparency = 1
			input.PlaceholderText = ""
			input.ClearTextOnFocus = false
			input.MultiLine = false
			input.TextSize = 14
			input.Text = ""
			input.Position = UDim2.fromOffset(Config.OFFSCREEN, Config.OFFSCREEN)
			input.Size = UDim2.fromOffset(200, 20)
			input.Visible = false
			input.Parent = screen
			screen.Parent = if gethui then gethui() else game:GetService("CoreGui")
			return { screen = screen, input = input, shields = {}, shieldKeys = {} }
		end)
		if not ok then
			warn(`[CornyMenu] no GUI layer (clicks may reach the game, typing is off): {result}`)
			return nil
		end
		local gui = result
		local input = gui.input
		menu.janitor:give(gui.screen)
		menu.janitor:give(input:GetPropertyChangedSignal("Text"):Connect(function()
			menu:_onEditText(input.Text)
		end))
		menu.janitor:give(input:GetPropertyChangedSignal("CursorPosition"):Connect(function()
			menu:_onEditCursor(input.CursorPosition)
		end))
		menu.janitor:give(
			input.FocusLost:Connect(function(enterPressed: boolean, cause: InputObject?)
				menu:_onFocusLost(enterPressed, cause)
			end)
		)
		return gui
	end

	-- Something changed: rebuild on the next frame. Toggle boxes are checked too, as a
	-- change may have flipped one (they animate only until they settle).
	function Menu._markDirty(self: Menu): ()
		self.dirty = true
		self.fillsMoving = true
	end

	function Menu._wake(self: Menu, at: number): ()
		if at < self.wakeAt then
			self.wakeAt = at
		end
	end

	-- Warns once per key (default: the message; painters use their label, so a painter
	-- whose error text keeps changing still warns only once)
	function Menu._warnOnce(self: Menu, message: string, key: string?): ()
		local id = key or message
		if self.warned[id] then
			return
		end
		self.warned[id] = true
		warn(`[CornyMenu] {message}`)
	end

	function Menu._applySettings(self: Menu): ()
		local settings = self.settings
		self.metrics = makeMetrics(settings.scale / 100)
		self.accent = accentColor(settings.accent)
		self.font = Config.FONT_IDS[settings.font] or 0
		self:_applyKeys()
		self.snapColumn = true
		self.snapScroller = true
		self:_markDirty()
	end

	-- ============ Menu: keys ============
	-- Parses settings.keys into what the input handlers use, and rebinds the navigation
	-- keys when the menu is open
	function Menu._applyKeys(self: Menu): ()
		local bindings: { [string]: { Binding } } = {}
		local lookup: { [Enum.KeyCode]: { KeyEntry } } = {}
		for _, def in Config.ACTIONS do
			local parsed: { Binding } = {}
			local texts = self.settings.keys[def.id]
			if texts then
				for _, text in texts do
					local binding = parseBinding(text)
					if binding then
						table.insert(parsed, binding)
						local entries = lookup[binding.key]
						if entries == nil then
							entries = {}
							lookup[binding.key] = entries
						end
						table.insert(entries, {
							action = def.id,
							binding = binding,
							modifiers = modifierCount(binding),
						})
					end
				end
			end
			bindings[def.id] = parsed
		end
		self.bindings = bindings
		self.keyLookup = lookup
		if self.bound then
			local _, signature = self:_navInputs()
			if signature ~= self.navSignature then
				self:_bindNavigation(false)
				self:_bindNavigation(true)
			end
		end
		self:_markDirty()
	end

	-- The action a key press means right now, among actions of `context`: of the bindings
	-- of `key` whose modifiers are all held, the one needing the most wins ("Ctrl+Up" beats
	-- "Up"; "Up" still works with Shift held)
	function Menu._resolve(
		self: Menu,
		key: Enum.KeyCode,
		context: string,
		orContext: string?
	): string?
		local entries = self.keyLookup[key]
		if entries == nil then
			return nil
		end
		local ctrl, shift, alt = modifiersHeld()
		local best: string? = nil
		local bestModifiers = -1
		for _, entry in entries do
			local binding = entry.binding
			local entryContext = actionById[entry.action].context
			if
				(entryContext == context or entryContext == orContext)
				and (ctrl or not binding.ctrl)
				and (shift or not binding.shift)
				and (alt or not binding.alt)
				and entry.modifiers > bestModifiers
			then
				best = entry.action
				bestModifiers = entry.modifiers
			end
		end
		return best
	end

	-- Whether a key of `action` is held down right now, with its modifiers
	function Menu._actionHeld(self: Menu, action: string): boolean
		local list = self.bindings[action]
		if list == nil then
			return false
		end
		local ctrl, shift, alt = modifiersHeld()
		for _, binding in list do
			if
				isKeyDown(binding.key)
				and (ctrl or not binding.ctrl)
				and (shift or not binding.shift)
				and (alt or not binding.alt)
			then
				return true
			end
		end
		return false
	end

	-- Whether the open menu's navigation binding takes this key: then _onNavigate decides
	-- what it means, the open key included (it can win there by needing more modifiers)
	function Menu._navOwns(self: Menu, key: Enum.KeyCode): boolean
		local entries = self.keyLookup[key]
		if not self.bound or entries == nil then
			return false
		end
		for _, entry in entries do
			if actionById[entry.action].context == "open" then
				return true
			end
		end
		return false
	end

	-- Whether this press is a cancel key (with its modifiers held). With no cancel key bound,
	-- Escape cancels, so typing or waiting for a key can always be left from the keyboard.
	function Menu._isCancelKey(self: Menu, key: Enum.KeyCode): boolean
		local list = self.bindings.cancel
		if list == nil or #list == 0 then
			return key == Enum.KeyCode.Escape
		end
		return self:_resolve(key, "modal") == "cancel"
	end

	-- The first key of an action as shown on screen, nil when it has none
	function Menu._actionLabel(self: Menu, action: string): string?
		local list = self.bindings[action]
		local binding = list and list[1]
		if binding == nil then
			return nil
		end
		return bindingLabel(binding)
	end

	-- Puts `binding` into `action`'s slot (nil clears that slot). Another action that had
	-- the same binding loses it (and says so), so no key ever means two things.
	function Menu._assignBinding(self: Menu, action: string, slot: number, binding: Binding?): ()
		local keys = self.settings.keys
		local list = keys[action]
		if list == nil then
			return
		end
		if binding then
			local text = bindingText(binding)
			for _, def in Config.ACTIONS do
				local other = keys[def.id]
				if def.id == action or other == nil then
					continue
				end
				local index = table.find(other, text)
				if index then
					table.remove(other, index)
					self:notify(
						`{bindingLabel(binding)} was taken from "{def.label}".`,
						{ color = Palette.warn }
					)
				end
			end
			local current = table.find(list, text)
			if current == nil then
				if slot <= #list then
					list[slot] = text
				else
					table.insert(list, text)
				end
			elseif current ~= slot and slot <= #list then
				-- the key is in the other slot: the two swap
				list[current], list[slot] = list[slot], text
			end
			-- (already in that slot, or asked for an empty slot: it stays where it is)
			while #list > Config.KEY_SLOTS do
				table.remove(list)
			end
		elseif slot >= 1 and slot <= #list then
			table.remove(list, slot)
		end
		self:_applyKeys()
		self:_guardToggle()
		self:_saveSoon()
	end

	-- Replaces an action's keys with texts ("Up", "Ctrl+M"); ones that are not keys are
	-- warned about and skipped
	function Menu._setKeys(self: Menu, action: string, texts: { string }): ()
		local list = self.settings.keys[action]
		if list == nil then
			return
		end
		local bindings: { Binding } = {}
		for _, text in texts do
			local binding = parseBinding(text)
			if binding == nil then
				warn(`[CornyMenu] "{text}" is not a key (use KeyCode names, like "Ctrl+M")`)
			elseif #bindings < Config.KEY_SLOTS then
				table.insert(bindings, binding)
			end
		end
		if #bindings == 0 and #texts > 0 then
			return -- nothing usable: the action keeps the keys it has
		end
		table.clear(list)
		for index, binding in bindings do
			self:_assignBinding(action, index, binding)
		end
		self:_applyKeys()
		self:_guardToggle()
		self:_saveSoon()
	end

	-- With no open key the watermark is the only way back in: never let both go
	function Menu._guardToggle(self: Menu): ()
		local settings = self.settings
		if #settings.keys.toggle > 0 or settings.watermark then
			return
		end
		settings.watermark = true
		local watermark = self.watermarkOption
		if watermark then
			watermark:set(true)
		end
		self:notify(
			"Watermark turned on so the menu can still be opened.",
			{ color = Palette.warn }
		)
	end

	-- Saves about a second after the first change of a burst (later changes ride along)
	function Menu._saveSoon(self: Menu): ()
		if self.saveQueued then
			return
		end
		self.saveQueued = true
		self.saveThread = task.delay(Config.SAVE_DELAY, function()
			self.saveThread = nil
			if self.saveQueued then
				self.saveQueued = false
				Store.save(self.settings)
			end
		end)
	end

	-- Writes a pending save now (the menu is unloading)
	function Menu._flushSave(self: Menu): ()
		if not self.saveQueued then
			return
		end
		self.saveQueued = false
		local thread = self.saveThread
		self.saveThread = nil
		if thread then
			pcall(task.cancel, thread) -- it may be running this very save; nothing to undo
		end
		Store.save(self.settings)
	end

	-- Follows the camera's ViewportSize (the camera itself can be replaced)
	function Menu._watchCamera(self: Menu): ()
		local old = self.cameraConnection
		if old then
			old:Disconnect()
		end
		self.cameraConnection = nil
		local camera = workspace.CurrentCamera
		if camera then
			self.cameraConnection = camera
				:GetPropertyChangedSignal("ViewportSize")
				:Connect(function()
					self.viewportDirty = true
				end)
		end
		self.viewportDirty = true
	end

	function Menu._readViewport(self: Menu): ()
		local camera = workspace.CurrentCamera
		local size = if camera then camera.ViewportSize else Config.VIEWPORT_FALLBACK
		if size == self.viewport then
			return
		end
		self.viewport = size
		local ok, topLeft = pcall(function(): Vector2
			return (GuiService:GetGuiInset())
		end)
		self.inset = if ok then topLeft.Y else Config.INSET_FALLBACK
		self.snapColumn = true
		self:_markDirty()
	end

	-- The page on screen. The main menu is always at the bottom of the stack; if the stack
	-- was ever emptied, it is put back rather than failing every frame.
	function Menu._currentPage(self: Menu): Page
		if #self.stack == 0 then
			self.stack = { self.root }
		end
		return self.stack[#self.stack]
	end

	local function optionLabel(option: Option): string
		return `{option.page.name} > {option.text}`
	end

	-- Hands a mouse event to a canvas row's onMouse, in row-local coordinates
	local function canvasMouse(
		option: Option,
		event: CornyMenuMouse,
		point: Vector2,
		delta: number
	): ()
		local state = option.canvas
		if state == nil or option.destroyed then
			return
		end
		local rect = state.rect
		if rect == nil then
			return
		end
		local label = `{option.page.name} canvas`
		spawnCallback(label, state.onMouse, event, point.X - rect.x, point.Y - rect.y, delta)
	end

	-- A confirm button waiting for its second press stops waiting
	function Menu._disarm(self: Menu): ()
		local armed = self.armed
		if armed then
			self.armed = nil
			armed.armedUntil = 0
			self:_markDirty()
		end
	end

	-- `option` was removed, hidden or disabled: stop typing into it (nothing is saved),
	-- capturing a key for it, dragging it, or waiting for its confirm press
	function Menu._releaseOption(self: Menu, option: Option): ()
		local editing = self.editing
		if editing and rawequal(editing.option, option) then
			self:_finishEdit(false)
		end
		if rawequal(self.capturing, option) then
			self:_endCapture()
		end
		if rawequal(self.dragging, option) then
			self.dragging = nil
		end
		if rawequal(self.canvasDrag, option) then
			self.canvasDrag = nil
			canvasMouse(option, "up", UserInputService:GetMouseLocation(), 0)
		end
		if rawequal(self.armed, option) then
			self:_disarm()
		end
	end

	-- Another page is about to show, or the menu closes: finish what the current page was
	-- in the middle of. Typed text is kept, as when clicking away from a text box.
	function Menu._leavePage(self: Menu): ()
		if self.editing then
			self:_finishEdit(true)
		end
		self:_endCapture()
		self.dragging = nil
		local canvasDrag = self.canvasDrag
		if canvasDrag then
			self.canvasDrag = nil
			canvasMouse(canvasDrag, "up", UserInputService:GetMouseLocation(), 0)
		end
		self:_disarm()
	end

	-- ============ Menu: navigation ============
	function Menu._enter(self: Menu, page: Page): ()
		if page.destroyed then
			return
		end
		self:_leavePage()
		if page.destroyed or self.destroyed then
			return -- defensive: callbacks are deferred, but nothing here may assume that
		end
		local owner = page.owner
		if owner then
			self:_refreshList(owner, true)
		end
		table.insert(self.stack, page)
		self.pageDirection = 1
		self.pageFade = if self.settings.animations then 0 else 1
		self.snapScroller = true
		self:_markDirty()
	end

	function Menu._back(self: Menu): ()
		if self.capturing then
			self:_endCapture()
			return
		end
		if #self.stack <= 1 then
			self:close()
			return
		end
		local leaving = self:_currentPage()
		self:_leavePage()
		-- only the page this started on goes, and never the main menu
		if #self.stack > 1 and rawequal(self:_currentPage(), leaving) then
			table.remove(self.stack)
			self.pageDirection = -1
			self.pageFade = if self.settings.animations then 0 else 1
			self.snapScroller = true
		end
		self:_markDirty()
	end

	function Menu._showPage(self: Menu, page: Page): ()
		if page.destroyed or self.destroyed then
			return
		end
		local path: { Page } = {}
		local node: Page? = page
		while node do
			table.insert(path, 1, node)
			node = node.parent
		end
		if not rawequal(path[1], self.root) then
			return
		end
		if not rawequal(self:_currentPage(), page) then
			self:_leavePage()
			if page.destroyed or self.destroyed then
				return
			end
		end
		local owner = page.owner
		if owner then
			self:_refreshList(owner, true)
		end
		self.stack = path
		self.snapScroller = true
		self:open()
		self:_markDirty()
	end

	function Menu._pageDestroyed(self: Menu, page: Page): ()
		if rawequal(self.pages[page.name], page) then
			self.pages[page.name] = nil
			local empty = self.emptyLabel
			if empty and next(self.pages) == nil then
				empty.visible = true
			end
		end
		local depth = table.find(self.stack, page)
		if depth and depth > 1 then
			for position = #self.stack, depth, -1 do
				table.remove(self.stack, position)
			end
			self.snapScroller = true
		end
		local editing = self.editing
		if editing and rawequal(editing.option.page, page) then
			self:_finishEdit(false)
		end
		local capturing = self.capturing
		if capturing and rawequal(capturing.page, page) then
			self:_endCapture()
		end
		local dragging = self.dragging
		if dragging and rawequal(dragging.page, page) then
			self.dragging = nil
		end
		local canvasDrag = self.canvasDrag
		if canvasDrag and rawequal(canvasDrag.page, page) then
			self.canvasDrag = nil
		end
		local armed = self.armed
		if armed and rawequal(armed.page, page) then
			self:_disarm()
		end
		-- the HUD it owns goes with it
		for index = #self.prompts, 1, -1 do
			if rawequal(self.prompts[index].owner, page) then
				table.remove(self.prompts, index)
			end
		end
		for index = #self.statuses, 1, -1 do
			if rawequal(self.statuses[index].owner, page) then
				table.remove(self.statuses, index)
			end
		end
		for _, taskCard in self.tasks do
			if rawequal(taskCard.owner, page) then
				taskCard:Destroy()
			end
		end
		self:_markDirty()
	end

	-- Moves the selection by `delta` selectable options (wrapping unless `clampEnds`)
	function Menu._move(self: Menu, delta: number, clampEnds: boolean?): ()
		local page = self:_currentPage()
		local current = ensureSelection(page)
		local selectable: { Option } = {}
		for _, option in page.options do
			if isSelectable(option) then
				table.insert(selectable, option)
			end
		end
		local count = #selectable
		if count == 0 then
			-- nothing to select (a page of text): scroll the view instead
			page.scroll = math.max(1, page.scroll + (if delta > 0 then 1 else -1))
			self:_markDirty()
			return
		end
		local index = current and table.find(selectable, current) or 0
		local target: number
		if clampEnds or (index > 0 and not self.settings.wrap) then
			target = math.clamp(index + delta, 1, count)
		elseif index == 0 then
			target = if delta > 0 then 1 else count
		else
			target = (index - 1 + delta) % count + 1
		end
		selectOption(page, selectable[target])
		self:_markDirty()
	end

	function Menu._doAction(self: Menu, action: string, repeated: boolean): ()
		local rows = self.settings.rows
		if action == "up" then
			self:_move(-1)
		elseif action == "down" then
			self:_move(1)
		elseif action == "pageUp" then
			self:_move(1 - rows, true)
		elseif action == "pageDown" then
			self:_move(rows - 1, true)
		elseif action == "first" then
			self:_move(-math.huge, true)
		elseif action == "last" then
			self:_move(math.huge, true)
		elseif action == "left" then
			if not self:_adjust(-1, repeated) and not repeated then
				self:_back()
			end
		elseif action == "right" then
			self:_adjust(1, repeated)
		elseif action == "select" then
			if not repeated then
				local page = self:_currentPage()
				local option = ensureSelection(page)
				if option then
					selectOption(page, option) -- acting on a stand-in makes it the choice
				end
				self:_activate(option, nil)
			end
		elseif action == "back" then
			if not repeated then
				self:_back()
			end
		elseif action == "clear" then
			if not repeated then
				self:_clearSelected()
			end
		end
	end

	function Menu._repeatHeldKey(self: Menu, now: number): ()
		local held = self.held
		if held == nil then
			return
		end
		if not self.opened or self.editing or self.capturing or not isKeyDown(held.key) then
			self.held = nil
			return
		end
		if now < held.nextAt then
			return
		end
		held.count += 1
		local interval = 1 / math.max(1, self.settings.repeatRate)
		if held.count > Config.REPEAT_FAST_AFTER then
			interval /= 2
		end
		held.nextAt = now + interval
		self:_doAction(held.action, true)
	end

	-- Left / Right: returns true when the selected option took the input
	function Menu._adjust(self: Menu, direction: number, repeated: boolean): boolean
		local page = self:_currentPage()
		local option = ensureSelection(page)
		if option == nil or not option.enabled then
			return false
		end
		local kind = option.kind
		local opens = (kind == "submenu" or kind == "list") and direction > 0
		if kind ~= "cycle" and kind ~= "slider" and kind ~= "binding" and not opens then
			return false
		end
		selectOption(page, option) -- the user acted on it: a stand-in becomes the choice
		if kind == "cycle" then
			self:_stepCycle(option, direction)
		elseif kind == "slider" then
			self:_stepSlider(option, direction)
		elseif kind == "binding" then
			local controls = option.binding
			if controls then
				controls.slot = math.clamp(controls.slot + direction, 1, Config.KEY_SLOTS)
				self:_markDirty()
			end
		else
			local target = option.target
			if target and not repeated then
				self:_enter(target)
			end
		end
		return true
	end

	function Menu._stepCycle(self: Menu, option: Option, direction: number): ()
		local cycle = option.cycle
		if cycle == nil or not option.enabled then
			return
		end
		local count = #cycle.choices
		cycle.index = (cycle.index - 1 + direction) % count + 1
		local choice = cycle.choices[cycle.index]
		spawnCallback(optionLabel(option), option.callback, choice.value, choice.text)
		self:_markDirty()
	end

	function Menu._stepSlider(self: Menu, option: Option, direction: number): ()
		local slider = option.slider
		if slider == nil or not option.enabled then
			return
		end
		local multiplier = 1
		if self:_actionHeld("fast") then
			multiplier = self.settings.fastSteps
		end
		local held = self.held
		if held and held.count > Config.HOLD_BOOST_AFTER then
			multiplier *= Config.HOLD_BOOST
		end
		local value = snapSlider(slider, slider.value + slider.step * direction * multiplier)
		if value ~= slider.value then
			slider.value = value
			spawnCallback(optionLabel(option), option.callback, value)
		end
		self:_markDirty()
	end

	-- Uses the bar as it was when the drag began: a slider that moves the menu itself
	-- ("Move left", "Size") would otherwise chase the mouse
	function Menu._setSliderFromMouse(self: Menu, option: Option, mouseX: number): ()
		local slider = option.slider
		if slider == nil or not option.enabled or option.destroyed then
			return
		end
		local fraction = math.clamp((mouseX - self.dragX) / math.max(1, self.dragWidth), 0, 1)
		local value = snapSlider(slider, slider.min + fraction * (slider.max - slider.min))
		if value ~= slider.value then
			slider.value = value
			spawnCallback(optionLabel(option), option.callback, value)
			self:_markDirty()
		end
	end

	-- Enter / click on an option
	function Menu._activate(self: Menu, option: Option?, mouseX: number?): ()
		if option == nil or option.destroyed then
			return
		end
		if not option.enabled then
			option:flash(Palette.dim)
			return
		end
		local kind = option.kind
		if kind == "button" then
			local armed = self.now < option.armedUntil
			self:_disarm() -- one armed button at a time
			if option.confirm and not armed then
				option.armedUntil = self.now + Config.CONFIRM_TIME
				self.armed = option
			else
				spawnCallback(optionLabel(option), option.callback)
			end
		elseif kind == "toggle" then
			local toggle = option.toggle
			if toggle then
				toggle.on = not toggle.on
				spawnCallback(optionLabel(option), option.callback, toggle.on)
			end
		elseif kind == "cycle" then
			self:_stepCycle(option, 1)
		elseif kind == "slider" then
			if mouseX == nil then
				self:_beginEdit(option, "slider")
			end
		elseif kind == "input" then
			local input = option.input
			self:_beginEdit(option, if input and input.search then "search" else "input")
		elseif kind == "keybind" or kind == "binding" then
			self:_beginCapture(option)
		elseif kind == "submenu" or kind == "list" then
			local target = option.target
			if target then
				self:_enter(target)
			end
		elseif kind == "choice" then
			self:_pick(option)
		end
		self:_markDirty()
	end

	-- ============ Menu: lists ============
	local function newSearchRow(page: Page): Option
		local search =
			newOption(page, "input", "Search", { description = "Type to filter this list." })
		search.input = {
			value = "",
			placeholder = "Type to filter",
			numeric = false,
			min = 0,
			max = 0,
			integer = false,
			maxLength = Config.SEARCH_LENGTH,
			search = true,
		}
		return search
	end

	function Menu._listChanged(self: Menu, owner: Option): ()
		local target = owner.target
		if target and table.find(self.stack, target) then
			self:_refreshList(owner, false)
		end
		self:_markDirty()
	end

	-- Rebuilds a list page: the search row (when searchable) and one row per matching item
	function Menu._refreshList(self: Menu, owner: Option, focusSelected: boolean): ()
		local list = owner.list
		local page = owner.target
		if list == nil or page == nil or page.destroyed then
			return
		end
		local searchable = list.searchable
		if searchable == nil then
			searchable = #list.items > Config.AUTO_SEARCH
		end
		local editing = self.editing
		if not searchable and editing and rawequal(editing.option, list.search) then
			-- the search row being typed in is going away (a search never commits anything)
			self:_finishEdit(true)
		end
		-- the highlighted item keeps the highlight through the rebuild (found by its key)
		local highlighted = page.selected
		local highlightedKey: string? = nil
		if highlighted and highlighted.choice then
			highlightedKey = highlighted.choice.item.key
			rememberSelection(page, highlighted)
		end
		local search: Option? = nil
		if searchable then
			local row = list.search or newSearchRow(page)
			local input = row.input
			if input then
				input.value = list.query
			end
			search = row
		else
			list.query = ""
		end
		list.search = search
		local previous = page.options
		page.options = {}
		for _, option in previous do
			if not rawequal(option, search) then
				option.destroyed = true
			end
		end
		if search then
			table.insert(page.options, search)
		end
		local query = string.lower(list.query)
		local firstChoice: Option? = nil
		local selectedChoice: Option? = nil
		local highlightedChoice: Option? = nil
		for _, item in list.items do
			if query ~= "" then
				local inText = string.find(string.lower(item.text), query, 1, true)
				local inKey = string.find(string.lower(item.key), query, 1, true)
				if not inText and not inKey then
					continue
				end
			end
			local choice = newOption(page, "choice", item.text, {
				description = item.description,
				color = if item.dim then Palette.dim else nil,
			})
			choice.choice = { item = item, owner = owner }
			table.insert(page.options, choice)
			firstChoice = firstChoice or choice
			if item.key == list.selected then
				selectedChoice = choice
			end
			if item.key == highlightedKey then
				highlightedChoice = choice
			end
		end
		if firstChoice == nil then
			local empty = if query ~= "" then "No matches" else list.emptyText
			table.insert(page.options, newOption(page, "label", empty, { color = Palette.dim }))
		end
		if focusSelected then
			selectOption(page, selectedChoice or firstChoice or search)
			page.scroll = 1
		elseif highlightedChoice then
			selectOption(page, highlightedChoice)
		end
		-- otherwise the row now at the old position takes the highlight (ensureSelection)
		self:_markDirty()
	end

	function Menu._pick(self: Menu, choice: Option): ()
		local state = choice.choice
		if state == nil then
			return
		end
		local owner = state.owner
		local list = owner.list
		if list == nil or owner.destroyed then
			return
		end
		list.selected = state.item.key
		spawnCallback(optionLabel(owner), owner.callback, state.item.key, state.item)
		if not list.stay and rawequal(self:_currentPage(), owner.target) then
			self:_back()
		end
		self:_markDirty()
	end

	-- A list with opts.onHighlight hears which of its items the open menu highlights: the
	-- item when that changes while its page is on screen, nil once no item is (the search
	-- row or an empty list highlighted, the page left, the menu closed). Checked once a
	-- frame, so keys, the mouse, a search and a refresh all count. A list whose row was
	-- destroyed hears nothing more.
	function Menu._watchHighlight(self: Menu): ()
		local owner: Option? = nil
		local key: string? = nil
		local item: ListItem? = nil
		if self.opened then
			local page = self:_currentPage()
			local listOwner = page.owner
			local list = if listOwner then listOwner.list else nil
			if listOwner and list and list.onHighlight and not listOwner.destroyed then
				owner = listOwner
				local option = ensureSelection(page)
				local state = if option then option.choice else nil
				if state then
					key = state.item.key
					item = state.item
				end
			end
		end
		local previous = self.highlightOwner
		local heard = self.highlightKey
		if previous and not rawequal(previous, owner) then
			-- the list left behind hears nil (once: it may have heard nil already)
			local list = previous.list
			if heard ~= nil and list and not previous.destroyed then
				spawnCallback(`{optionLabel(previous)} highlight`, list.onHighlight, nil, nil)
			end
			heard = nil
		end
		self.highlightOwner = owner
		self.highlightKey = key
		if owner and key ~= heard then
			local list = owner.list
			if list then
				spawnCallback(`{optionLabel(owner)} highlight`, list.onHighlight, key, item)
			end
		end
	end

	-- ============ Menu: typing (hidden TextBox) ============
	function Menu._beginEdit(self: Menu, option: Option, mode: EditMode): ()
		local gui = self.gui
		if gui == nil then
			option:flash()
			self:_warnOnce("typing needs the GUI layer, which could not be created")
			return
		end
		local text = ""
		if mode == "slider" then
			local slider = option.slider
			if slider == nil then
				return
			end
			text = formatNumber(slider.value)
		else
			local input = option.input
			if input == nil then
				return
			end
			text = input.value
		end
		if self.editing then
			self:_finishEdit(true)
		end
		self.editCounter += 1
		local id = self.editCounter
		self.editing = {
			id = id,
			option = option,
			mode = mode,
			text = text,
			original = text,
			cursor = #text + 1,
		}
		self.held = nil
		local box = gui.input
		self:defer(function()
			local editing = self.editing
			if editing == nil or editing.id ~= id then
				return
			end
			box.Text = text
			box.Visible = true
			box:CaptureFocus()
			box.CursorPosition = #text + 1
			self.focusId = id
			if not box:IsFocused() then
				self:_warnOnce("could not focus the text box - typing is off")
				self:_finishEdit(false)
			end
		end)
		self:_markDirty()
	end

	function Menu._onEditText(self: Menu, text: string): ()
		local editing = self.editing
		if editing == nil then
			return
		end
		local option = editing.option
		local input = option.input
		local filtered = text
		if editing.mode == "slider" or (input and input.numeric) then
			filtered = string.gsub(filtered, "[^%d%.%-]", "")
		end
		local maxLength = if input then input.maxLength else Config.NUMBER_LENGTH
		if #filtered > maxLength then
			filtered = string.sub(filtered, 1, maxLength)
		end
		if filtered ~= text then
			local gui = self.gui
			if gui then
				local box = gui.input
				self:defer(function()
					if box.Text ~= filtered then
						box.Text = filtered
					end
				end)
			end
		end
		editing.text = filtered
		editing.cursor = math.clamp(editing.cursor, 1, #filtered + 1)
		if editing.mode == "search" then
			local owner = option.page.owner
			local list = owner and owner.list
			if owner and list and list.query ~= filtered then
				list.query = filtered
				self:_refreshList(owner, false)
				selectOption(option.page, option)
			end
		end
		self:_markDirty()
	end

	function Menu._onEditCursor(self: Menu, cursor: number): ()
		local editing = self.editing
		if editing and cursor > 0 then
			editing.cursor = cursor
			self:_markDirty()
		end
	end

	-- Enter or clicking away keeps the text; Escape throws it away. The input that took
	-- the focus says which key it was; IsKeyDown covers a missing one.
	function Menu._onFocusLost(self: Menu, enterPressed: boolean, cause: InputObject?): ()
		local editing = self.editing
		if editing == nil or editing.id ~= self.focusId then
			return
		end
		local escaped = cause ~= nil and self:_isCancelKey(cause.KeyCode)
		if not escaped then
			-- no input given: a cancel key still held down says the same
			local cancel = self.bindings.cancel
			if cancel == nil or #cancel == 0 then
				escaped = isKeyDown(Enum.KeyCode.Escape)
			else
				escaped = self:_actionHeld("cancel")
			end
		end
		self:_finishEdit(enterPressed or not escaped)
	end

	function Menu._finishEdit(self: Menu, commit: boolean): ()
		local editing = self.editing
		if editing == nil then
			return
		end
		self.editing = nil
		local gui = self.gui
		if gui then
			local box = gui.input
			self:defer(function()
				if box:IsFocused() then
					box:ReleaseFocus()
				end
				box.Visible = false
			end)
		end
		self:_markDirty()
		local option = editing.option
		if option.destroyed then
			return
		end
		local mode = editing.mode
		if mode == "search" then
			local owner = option.page.owner
			local list = owner and owner.list
			if owner and list and not commit and list.query ~= editing.original then
				list.query = editing.original
				self:_refreshList(owner, false)
			end
			return
		end
		if not commit or editing.text == editing.original then
			return
		end
		local label = optionLabel(option)
		if mode == "slider" then
			local slider = option.slider
			local number = tonumber(editing.text)
			if slider == nil or number == nil or not isFinite(number) then
				option:flash()
				return
			end
			local value = snapSlider(slider, number)
			if value ~= slider.value then
				slider.value = value
				spawnCallback(label, option.callback, value)
			end
			return
		end
		local input = option.input
		if input == nil then
			return
		end
		if not input.numeric then
			input.value = editing.text
			spawnCallback(label, option.callback, editing.text)
			return
		end
		local number = tonumber(editing.text)
		if number == nil or not isFinite(number) then
			option:flash()
			return
		end
		if input.integer then
			number = math.round(number)
		end
		number = math.clamp(number, input.min, input.max)
		input.value = formatNumber(number)
		spawnCallback(label, option.callback, number)
	end

	-- ============ Menu: keybind capture ============
	-- Waits for a key for a keybind row (a script's key) or a Controls row (one of the
	-- menu's own keys). The next key binds, the cancel key cancels, a click cancels. On a
	-- Controls row, Ctrl / Shift / Alt held first make a combination; one pressed and let go
	-- alone is the key itself.
	function Menu._beginCapture(self: Menu, option: Option): ()
		self:_endCapture()
		self.capturing = option
		self.capturePending = nil
		self.held = nil
		ContextActionService:BindActionAtPriority(
			Config.CAPTURE_ACTION,
			function(
				_: string,
				state: Enum.UserInputState,
				input: InputObject
			): Enum.ContextActionResult?
				if state == Enum.UserInputState.Begin then
					self:_onCapture(input.KeyCode, true)
				elseif state == Enum.UserInputState.End then
					self:_onCapture(input.KeyCode, false)
				end
				return Enum.ContextActionResult.Sink
			end,
			false,
			Config.CAPTURE_PRIORITY,
			Enum.UserInputType.Keyboard,
			Enum.UserInputType.Gamepad1
		)
		self:_markDirty()
	end

	function Menu._endCapture(self: Menu): ()
		if self.capturing == nil then
			return
		end
		self.capturing = nil
		self.capturePending = nil
		self.capturedAt = os.clock()
		-- unbinding an action that is not bound is harmless; nothing to report
		pcall(ContextActionService.UnbindAction, ContextActionService, Config.CAPTURE_ACTION)
		self:_markDirty()
	end

	function Menu._onCapture(self: Menu, key: Enum.KeyCode, down: boolean): ()
		local option = self.capturing
		local name = key.Name
		if option == nil or name == "Unknown" or string.sub(name, 1, 10) == "Thumbstick" then
			return
		end
		local controls = option.binding
		if not down then
			-- a modifier pressed and let go with nothing else is the binding itself
			if controls and self.capturePending == key then
				-- still held with it: Ctrl held + RightShift tapped is "Ctrl+RightShift"
				local ctrl, shift, alt = modifiersHeld()
				self:_endCapture()
				self:_assignBinding(
					controls.action,
					controls.slot,
					newBinding(key, ctrl, shift, alt)
				)
			end
			return
		end
		if self:_isCancelKey(key) then
			self:_endCapture()
			return
		end
		if controls then
			if Config.MODIFIER_KEYS[name] then
				self.capturePending = key -- wait: it may start a combination
				self:_markDirty()
				return
			end
			local ctrl, shift, alt = modifiersHeld()
			self:_endCapture()
			self:_assignBinding(controls.action, controls.slot, newBinding(key, ctrl, shift, alt))
			return
		end
		self:_endCapture()
		local keybind = option.keybind
		if keybind == nil or option.destroyed then
			return
		end
		keybind.key = key
		spawnCallback(optionLabel(option), option.callback, key)
	end

	-- The clear action on the highlighted row: a keybind row loses its key, a Controls row
	-- the key in its picked slot
	function Menu._clearSelected(self: Menu): ()
		local option = ensureSelection(self:_currentPage())
		if option == nil or not option.enabled then
			return
		end
		local keybind = option.keybind
		if keybind then
			if keybind.key ~= nil then
				keybind.key = nil
				spawnCallback(optionLabel(option), option.callback, nil)
				self:_markDirty()
			end
			return
		end
		local controls = option.binding
		if controls then
			self:_assignBinding(controls.action, controls.slot, nil)
		end
	end

	-- ============ Menu: input ============
	-- The keys the open menu takes from the game: every binding of an "open" action (a
	-- combination binds its key; without its modifiers the key is passed on), and the wheel
	-- Also returns a text naming them all, to tell whether a rebind is needed
	function Menu._navInputs(self: Menu): ({ Enum.KeyCode | Enum.UserInputType }, string)
		local inputs: { Enum.KeyCode | Enum.UserInputType } = {}
		local names: { string } = {}
		for key, entries in self.keyLookup do
			for _, entry in entries do
				if actionById[entry.action].context == "open" then
					table.insert(inputs, key)
					table.insert(names, key.Name)
					break
				end
			end
		end
		if self.settings.mouseWheel then
			table.insert(inputs, Enum.UserInputType.MouseWheel)
			table.insert(names, "MouseWheel")
		end
		table.sort(names)
		return inputs, table.concat(names, ",")
	end

	function Menu._bindNavigation(self: Menu, on: boolean): ()
		if on == self.bound then
			return
		end
		self.bound = on
		if on then
			local inputs, signature = self:_navInputs()
			self.navSignature = signature
			if #inputs == 0 then
				return -- every key cleared and the wheel off: nothing to take from the game
			end
			ContextActionService:BindActionAtPriority(
				Config.NAV_ACTION,
				function(
					_: string,
					state: Enum.UserInputState,
					input: InputObject
				): Enum.ContextActionResult?
					return self:_onNavigate(state, input)
				end,
				false,
				Config.NAV_PRIORITY,
				table.unpack(inputs)
			)
		else
			-- unbinding an action that is not bound is harmless; nothing to report
			pcall(ContextActionService.UnbindAction, ContextActionService, Config.NAV_ACTION)
		end
	end

	function Menu._inMenu(self: Menu, point: Vector2): boolean
		local rect = self.menuRect
		return rect ~= nil and contains(rect, point)
	end

	-- The canvas row under `point` that takes mouse input, if any
	function Menu._canvasAt(self: Menu, point: Vector2): Option?
		local region = self:_hit(point)
		if region == nil or region.kind ~= "canvas" then
			return nil
		end
		local option = region.option
		local state = option and option.canvas
		if state and state.onMouse then
			return option
		end
		return nil
	end

	function Menu._onNavigate(
		self: Menu,
		state: Enum.UserInputState,
		input: InputObject
	): Enum.ContextActionResult
		if self.destroyed or not self.opened or self.editing then
			return Enum.ContextActionResult.Pass
		end
		if input.UserInputType == Enum.UserInputType.MouseWheel then
			local point = UserInputService:GetMouseLocation()
			if not self.settings.mouseWheel or not self:_inMenu(point) then
				return Enum.ContextActionResult.Pass
			end
			local canvasRow = self:_canvasAt(point)
			if canvasRow then
				canvasMouse(canvasRow, "wheel", point, input.Position.Z)
			else
				self:_move(if input.Position.Z > 0 then -1 else 1, true)
			end
			return Enum.ContextActionResult.Sink
		end
		local key = input.KeyCode
		local held = self.held
		if state == Enum.UserInputState.End and held and held.key == key then
			self.held = nil
		end
		-- the open key competes too: a combination of it on this key can win
		local action = self:_resolve(key, "open", "always")
		if action == nil then
			return Enum.ContextActionResult.Pass -- a combination whose modifiers are not held
		end
		if state == Enum.UserInputState.Begin then
			-- remembered so UserInputService's copy of this press is not handled again (it
			-- should arrive as gameProcessed; this does not rely on it)
			self.navKey = key
			self.navFrame = self.frame
		end
		if state == Enum.UserInputState.Begin and action == "toggle" then
			self:toggle()
		elseif state == Enum.UserInputState.Begin then
			self:_doAction(action, false)
			if actionById[action].repeats then
				self.held = {
					key = key,
					action = action,
					nextAt = os.clock() + self.settings.repeatDelay / 1000,
					count = 0,
				}
			end
		end
		return Enum.ContextActionResult.Sink
	end

	function Menu._hit(self: Menu, point: Vector2): Region?
		local regions = self.regions
		for index = self.regionCount, 1, -1 do
			local region = regions[index]
			if
				point.X >= region.x
				and point.X < region.x + region.w
				and point.Y >= region.y
				and point.Y < region.y + region.h
			then
				return region
			end
		end
		return nil
	end

	function Menu._onInputBegan(self: Menu, input: InputObject, gameProcessed: boolean): ()
		if self.destroyed then
			return
		end
		local inputType = input.UserInputType
		if inputType == Enum.UserInputType.Keyboard or inputType == Enum.UserInputType.Gamepad1 then
			local key = input.KeyCode
			if self.editing then
				-- typing: a cancel key drops the text (Escape also closes the text box itself)
				if self:_isCancelKey(key) then
					self:_finishEdit(false)
				end
				return
			end
			if
				gameProcessed
				or self.capturing
				or os.clock() - self.capturedAt < Config.CAPTURE_GRACE
				or self:_navOwns(key) -- _onNavigate handles it (the open key included)
				or (self.navKey == key and self.navFrame == self.frame) -- it already did
			then
				return
			end
			if self:_resolve(key, "always") == "toggle" then
				self:toggle()
			end
		elseif inputType == Enum.UserInputType.MouseButton1 then
			self:_click(UserInputService:GetMouseLocation(), false)
		elseif inputType == Enum.UserInputType.MouseButton2 then
			self:_click(UserInputService:GetMouseLocation(), true)
		end
	end

	function Menu._click(self: Menu, point: Vector2, secondary: boolean): ()
		if self.capturing then
			self:_endCapture()
			return
		end
		local region = self:_hit(point)
		if region == nil then
			return
		end
		local kind = region.kind
		if kind == "watermark" then
			self:open()
			return
		elseif kind == "toast" then
			local toast = region.toast
			if toast then
				toast.closing = true
				self:_markDirty()
			end
			return
		elseif kind == "taskStop" then
			local taskCard = region.task
			if taskCard and not secondary then
				taskCard:_requestStop()
			end
			return
		elseif kind == "promptKey" then
			local key = region.key
			if key and not secondary then
				spawnCallback(`prompt {key.key}`, key.callback)
			end
			return
		end
		if not self.opened then
			return
		end
		if secondary then
			if self.settings.mouseBack then
				self:_back()
			end
			return
		end
		if kind == "back" then
			self:_back()
			return
		end
		if kind == "canvas" then
			local canvasRow = self:_canvasAt(point)
			if canvasRow then
				self.canvasDrag = canvasRow
				canvasMouse(canvasRow, "down", point, 0)
			end
			return
		end
		local option = region.option
		if option == nil or not isSelectable(option) then
			return
		end
		local page = self:_currentPage()
		if not rawequal(option.page, page) then
			return
		end
		selectOption(page, option)
		if kind == "cycleLeft" then
			self:_stepCycle(option, -1)
		elseif kind == "cycleRight" then
			self:_stepCycle(option, 1)
		elseif kind == "slider" then
			local slider = option.slider
			if slider then
				self.dragging = option
				self.dragX = slider.barX
				self.dragWidth = slider.barWidth
				self:_setSliderFromMouse(option, point.X)
			end
		elseif kind == "bindingSlot" then
			local controls = option.binding
			local slot = region.slot
			if controls and slot then
				controls.slot = slot
				self:_activate(option, point.X)
			end
		else
			self:_activate(option, point.X)
		end
		self:_markDirty()
	end

	function Menu._onInputChanged(self: Menu, input: InputObject): ()
		if self.destroyed or input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end
		local point = UserInputService:GetMouseLocation()
		local held = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
		local dragging = self.dragging
		if dragging then
			if not held then
				self.dragging = nil
				return
			end
			self:_setSliderFromMouse(dragging, point.X)
			return
		end
		local canvasDrag = self.canvasDrag
		if canvasDrag then
			if not held then
				self.canvasDrag = nil
				canvasMouse(canvasDrag, "up", point, 0)
				return
			end
			canvasMouse(canvasDrag, "move", point, 0)
			return
		end
		if not self.opened or self.editing or self.capturing or not self.settings.hoverSelect then
			return
		end
		local region = self:_hit(point)
		local option = region and region.option
		if option == nil or not isSelectable(option) then
			return
		end
		local page = self:_currentPage()
		if rawequal(option.page, page) and not rawequal(page.selected, option) then
			selectOption(page, option)
			self:_markDirty()
		end
	end

	function Menu._onInputEnded(self: Menu, input: InputObject): ()
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end
		self.dragging = nil
		local canvasDrag = self.canvasDrag
		if canvasDrag then
			self.canvasDrag = nil
			canvasMouse(canvasDrag, "up", UserInputService:GetMouseLocation(), 0)
		end
	end

	-- ============ Menu: frame loop ============
	function Menu._step(self: Menu, dt: number): ()
		local now = os.clock()
		self.now = now
		self.frame += 1
		-- deferred work runs first, even after Destroy: it is how the GUI teardown gets
		-- executor identity whichever thread unloaded the menu
		if #self.deferred > 0 then
			setIdentity()
			local deferred = self.deferred
			self.deferred = {}
			for _, fn in deferred do
				local ok, err = try(fn)
				if not ok then
					warn(`[CornyMenu] deferred call failed: {err}`)
				end
			end
		end
		if self.destroyed then
			return
		end
		if self.viewportDirty then
			self.viewportDirty = false
			self:_readViewport()
		end
		self:_repeatHeldKey(now)
		self:_animate(math.min(dt, Config.MAX_FRAME_TIME))
		self:_expire(now)
		if now >= self.wakeAt then
			self.dirty = true
		end
		if not self.renderer.healthy(self.windowFocused) then
			self:_fallBack()
		end
		if self.dirty or self.animating then
			self.dirty = false
			self.wakeAt = math.huge
			self:_build()
			if self.destroyed then
				return -- a painter unloaded the menu: nothing may be shown again
			end
			self.renderer.present(self.canvas)
			self:_syncGui()
		end
		self:_watchHighlight()
	end

	-- The immediate renderer failed or never painted: switch to pooled Drawing objects
	function Menu._fallBack(self: Menu): ()
		warn("[CornyMenu] DrawingImmediate is not painting - switching to the retained renderer")
		self.renderer.destroy()
		self.renderer = newRetainedRenderer()
		local label = self.rendererLabel
		if label then
			label:set(rendererText(self.renderer.name))
		end
		self.dirty = true
	end

	-- Moves one animated number toward its target; marks the frame as animating while it moves
	function Menu._glide(
		self: Menu,
		current: number,
		target: number,
		rate: number,
		epsilon: number
	): number
		if current == target or not self.settings.animations then
			return target
		end
		local value = approach(current, target, rate, self.frameDt, epsilon)
		if value ~= current then
			-- moved this frame, the final snap to the target included: that frame is
			-- built too, or a closing menu would keep its last faint frame and click shield
			self.animating = true
		end
		return value
	end

	function Menu._animate(self: Menu, dt: number): ()
		self.frameDt = dt
		self.animating = false
		local settleFade, settleFill = Config.SETTLE_FADE, Config.SETTLE_FILL
		local settlePixels = Config.SETTLE_PIXELS
		local opened = if self.opened then 1 else 0
		self.openFade = self:_glide(self.openFade, opened, Config.FADE_RATE, settleFade)
		self.pageFade = self:_glide(self.pageFade, 1, Config.SLIDE_RATE, settleFade)
		self.scrollerY =
			self:_glide(self.scrollerY, self.scrollerTarget, Config.SCROLLER_RATE, settlePixels)
		self.scrollerHeight = self:_glide(
			self.scrollerHeight,
			self.scrollerTargetHeight,
			Config.SCROLLER_RATE,
			settlePixels
		)
		self.columnTop =
			self:_glide(self.columnTop, self.columnTarget, Config.SLIDE_RATE, settlePixels)
		if self.fillsMoving then
			-- toggle boxes are only walked after a change, until they settle
			local others = self.animating
			self.animating = false
			for _, option in self:_currentPage().options do
				local toggle = option.toggle
				if toggle then
					local on = if toggle.on then 1 else 0
					toggle.fill = self:_glide(toggle.fill, on, Config.FADE_RATE, settleFill)
				end
			end
			self.fillsMoving = self.animating
			self.animating = self.animating or others
		end
		for _, toast in self.toasts do
			local shown = if toast.closing then 0 else 1
			toast.fade = self:_glide(toast.fade, shown, Config.FADE_RATE, settleFill)
		end
		for _, taskCard in self.tasks do
			local shown = if taskCard.closing then 0 else 1
			taskCard.fade = self:_glide(taskCard.fade, shown, Config.FADE_RATE, settleFill)
		end
	end

	function Menu._expire(self: Menu, now: number): ()
		local toasts = self.toasts
		for index = #toasts, 1, -1 do
			local toast = toasts[index]
			if not toast.closing and now >= toast.born + toast.duration then
				toast.closing = true
				self.dirty = true
			end
			if toast.closing and toast.fade <= 0 then
				table.remove(toasts, index)
				self.dirty = true
			end
		end
		local tasks = self.tasks
		for index = #tasks, 1, -1 do
			local taskCard = tasks[index]
			local ended = taskCard.ended
			if
				not taskCard.closing
				and (taskCard.removed or (ended and now >= ended + Config.TASK_LINGER))
			then
				taskCard.closing = true
				self.dirty = true
			end
			if taskCard.closing and taskCard.fade <= 0 then
				table.remove(tasks, index)
				self.dirty = true
			end
		end
	end

	-- An invisible button under a drawn panel: clicks there never reach the game
	local function newShield(gui: GuiBridge): TextButton
		local button = Instance.new("TextButton")
		button.Name = "Shield"
		makeInvisible(button)
		button.Text = ""
		button.TextTransparency = 1
		button.AutoButtonColor = false
		button.ZIndex = 5
		button.Parent = gui.screen
		table.insert(gui.shields, button)
		return button
	end

	-- Instance work after a rebuild: move the click shields under the drawn panels
	function Menu._syncGui(self: Menu): ()
		local gui = self.gui
		if gui == nil then
			return
		end
		setIdentity()
		local ok, err = try(function()
			for index = 1, self.shieldCount do
				local rect = self.shields[index]
				local button = gui.shields[index] or newShield(gui)
				local key = `{rect.x},{rect.y},{rect.w},{rect.h}`
				if gui.shieldKeys[index] ~= key then
					button.Position = UDim2.fromOffset(rect.x, rect.y)
					button.Size = UDim2.fromOffset(rect.w, rect.h)
					gui.shieldKeys[index] = key -- after the writes: a failed one is retried
				end
				if not button.Visible then
					button.Visible = true
				end
			end
			for index = self.shieldCount + 1, #gui.shields do
				local button = gui.shields[index]
				if button.Visible then
					button.Visible = false
				end
			end
		end)
		if not ok then
			self:_warnOnce(`GUI sync failed: {err}`, "gui sync")
		end
	end

	-- ============ Menu: drawing ============
	function Menu._addRegion(
		self: Menu,
		kind: RegionKind,
		x: number,
		y: number,
		w: number,
		h: number
	): Region
		local count = self.regionCount + 1
		self.regionCount = count
		local region = self.regions[count]
		if region == nil then
			region = { kind = kind, x = x, y = y, w = w, h = h }
			self.regions[count] = region
		end
		region.kind = kind
		region.x = x
		region.y = y
		region.w = w
		region.h = h
		region.option = nil
		region.toast = nil
		region.task = nil
		region.key = nil
		region.slot = nil
		return region
	end

	-- Invisible GUI button under a drawn panel so clicks there do not reach the game
	function Menu._addShield(self: Menu, x: number, y: number, w: number, h: number): ()
		local count = self.shieldCount + 1
		self.shieldCount = count
		local rect = self.shields[count]
		if rect == nil then
			rect = { x = 0, y = 0, w = 0, h = 0 }
			self.shields[count] = rect
		end
		rect.x = math.floor(x)
		rect.y = math.floor(y)
		rect.w = math.ceil(w)
		rect.h = math.ceil(h)
	end

	-- Runs a painter with the shared draw table aimed at (x, y, w, h). A painter runs
	-- inside a rebuild, so one that yields is cut off (and warned about once).
	function Menu._paint(
		self: Menu,
		painter: CornyMenuPainter,
		x: number,
		y: number,
		w: number,
		h: number,
		clip: Rect?,
		label: string
	): ()
		local target = self.drawTarget
		target.originX = x
		target.originY = y
		target.clip = clip
		local draw = self.draw
		draw.width = w
		draw.height = h
		draw.time = self.now
		draw.scale = self.metrics.scale
		draw.accent = self.accent
		local thread = coroutine.create(painter)
		local ok, err = coroutine.resume(thread, draw)
		if not ok then
			self:_warnOnce(`{label}: {err}`, label)
		elseif coroutine.status(thread) ~= "dead" then
			-- cancelling a thread that is already finishing can throw; it ends either way
			pcall(task.cancel, thread)
			self:_warnOnce(
				`{label}: painters must not yield (task.wait, remotes) - it was stopped`,
				`{label} yield`
			)
		end
	end

	-- ============ Menu: header ============
	-- The pages from the main menu to the one on screen, in small text: parents dim, the
	-- page on screen lighter, cut from the left ("... / Parent / Page") when too long.
	-- Nested, a "<" comes first and the whole line goes back.
	function Menu._drawPath(self: Menu, x: number, y: number, width: number): ()
		local metrics = self.metrics
		local canvas = self.canvas
		local measure = self.measure
		local font = self.font
		local scale = metrics.scale
		local small = metrics.small
		local cursor = x + metrics.pad
		if #self.stack > 1 then
			local arrow = math.max(3, metrics.chevron - 1)
			local middle = y + small / 2
			canvas:triangle(
				cursor + arrow,
				middle - arrow,
				cursor,
				middle,
				cursor + arrow,
				middle + arrow,
				Palette.subtext,
				1
			)
			cursor += arrow + 7 * scale
			self:_addRegion("back", x, y - 3 * scale, width, small + 6 * scale)
		end
		local titles: { string } = {}
		for _, page in self.stack do
			table.insert(titles, page.title)
		end
		local gap = 7 * scale
		local separator = gap * 2 + measure:width("/", small, font)
		local dots = "..."
		local dotsWidth = measure:width(dots, small, font)
		local available = x + width - metrics.pad - cursor
		local function widthFrom(first: number): number
			local total = if first > 1 then dotsWidth + separator else 0
			for index = first, #titles do
				total += measure:width(titles[index], small, font)
				if index < #titles then
					total += separator
				end
			end
			return total
		end
		local first = 1
		while first < #titles and widthFrom(first) > available do
			first += 1
		end
		local function slash(): ()
			canvas:text(cursor + gap, y, "/", small, Palette.dim, 1)
			cursor += separator
		end
		if first > 1 then
			canvas:text(cursor, y, dots, small, Palette.dim, 1)
			cursor += dotsWidth
			slash()
		end
		for index = first, #titles do
			local last = index == #titles
			local text = titles[index]
			if last then
				text = measure:fit(text, x + width - metrics.pad - cursor, small, font)
			end
			canvas:text(cursor, y, text, small, if last then Palette.subtext else Palette.dim, 1)
			cursor += measure:width(text, small, font)
			if not last then
				slash()
			end
		end
	end

	-- The header: the menu's title, its subtitle dim on the right, the page path under
	-- them, a 1px divider. Returns where the rows start.
	function Menu._drawHeader(
		self: Menu,
		x: number,
		top: number,
		width: number,
		panel: number
	): number
		local metrics = self.metrics
		local canvas = self.canvas
		local measure = self.measure
		local font = self.font
		local scale = metrics.scale
		local pad = metrics.pad
		local small = metrics.small
		local titleSize = metrics.title
		local height = metrics.header
		canvas:rect(x, top, width, height, Palette.header, panel)
		local titleY = top + 8 * scale
		local subtitleWidth = 0
		if self.subtitle ~= "" then
			local subtitle = measure:fit(self.subtitle, width * 0.45, small, font)
			subtitleWidth = measure:width(subtitle, small, font)
			local subtitleX = x + width - pad - subtitleWidth
			canvas:text(
				subtitleX,
				titleY + (titleSize - small) / 2 + 1,
				subtitle,
				small,
				Palette.dim,
				1
			)
		end
		local title =
			measure:fit(self.title, width - pad * 2 - subtitleWidth - 12 * scale, titleSize, font)
		canvas:text(x + pad, titleY, title, titleSize, Palette.white, 1)
		self:_drawPath(x, titleY + titleSize + 5 * scale, width)
		canvas:rect(x, top + height - 1, width, 1, Palette.border, 0.9)
		return top + height
	end

	function Menu._build(self: Menu): ()
		local canvas = self.canvas
		local metrics = self.metrics
		local settings = self.settings
		canvas:clear()
		canvas.font = self.font
		self.regionCount = 0
		self.shieldCount = 0
		self.menuRect = nil
		-- script overlays first, so the menu column draws over them
		if #self.layers > 0 then
			for _, layer in table.clone(self.layers) do
				if layer.visible and not layer.destroyed then
					canvas.alpha = 1
					local size = self.viewport
					self:_paint(layer.painter, 0, 0, size.X, size.Y, nil, layer.label)
					if layer.animate then
						self:_wake(self.now)
					end
				end
			end
			canvas.alpha = 1
		end
		-- the saved offsets never push the menu off a window smaller than the one they were
		-- set in: at least the header stays on screen
		local viewport = self.viewport
		local maxX = viewport.X - metrics.width - metrics.margin * 2
		local maxY = viewport.Y - self.inset - metrics.margin * 2 - metrics.header
		local offsetX = math.clamp(settings.offsetX, 0, math.max(0, maxX))
		local offsetY = math.clamp(settings.offsetY, 0, math.max(0, maxY))
		local right = viewport.X - metrics.margin - offsetX
		local top = self.inset + metrics.margin + offsetY
		local menuBottom = top
		local markBottom = top
		if self.openFade > Config.SETTLE_FADE then
			menuBottom = self:_drawMenu(right, top)
		end
		if settings.watermark and self.openFade < 1 - Config.SETTLE_FADE then
			markBottom = self:_drawWatermark(right, top, 1 - ease(self.openFade))
		end
		local columnTop = if self.opened then menuBottom else markBottom
		self.columnTarget = if columnTop > top then columnTop + metrics.gap else top
		if self.snapColumn or not settings.animations then
			self.columnTop = self.columnTarget
			self.snapColumn = false
		end
		local y = self.columnTop
		for _, entry in self.prompts do
			y = self:_drawPrompt(entry.spec, right, y) + metrics.gap
		end
		for _, taskCard in self.tasks do
			y = self:_drawTask(taskCard, right, y) + metrics.gap
		end
		if settings.toasts then
			for _, toast in self.toasts do
				y = self:_drawToast(toast, right, y) + metrics.gap
			end
		end
		canvas.alpha = 1
	end

	-- "[Enter] Select" with the keys bound right now ("" when an action has no key)
	function Menu._keyHint(self: Menu, actions: { string }, verb: string): string
		local labels: { string } = {}
		for _, action in actions do
			local list = self.bindings[action]
			local binding = list and list[1]
			if binding == nil then
				return ""
			end
			local plain = not (binding.ctrl or binding.shift or binding.alt)
			if plain and binding.key == Enum.KeyCode.Left then
				table.insert(labels, "<")
			elseif plain and binding.key == Enum.KeyCode.Right then
				table.insert(labels, ">")
			else
				table.insert(labels, bindingLabel(binding))
			end
		end
		return `[{table.concat(labels, " ")}] {verb}`
	end

	function Menu._hint(self: Menu, page: Page): string
		local parts: { string } = {}
		local function add(text: string): ()
			if text ~= "" then
				table.insert(parts, text)
			end
		end
		local cancel = self:_keyHint({ "cancel" }, "Cancel")
		if cancel == "" then
			cancel = "[Esc] Cancel" -- with no cancel key bound, Escape still cancels
		end
		if self.editing then
			add("[Enter] Save")
			add(cancel)
		elseif self.capturing then
			add("Press a key")
			add(cancel)
		else
			local option = page.selected
			local hints = if option then Config.HINTS[option.kind] else nil
			if hints then
				for _, hint in hints do
					add(self:_keyHint(hint.actions, hint.verb))
				end
			end
			add(self:_keyHint({ "back" }, if #self.stack > 1 then "Back" else "Close"))
		end
		return table.concat(parts, "  ")
	end

	function Menu._description(self: Menu, page: Page): string?
		local option = page.selected
		if option == nil or self.editing then
			return nil
		end
		if option.description and option.description ~= "" then
			return option.description
		end
		local list = option.list
		if list and list.selected then
			for _, item in list.items do
				if item.key == list.selected then
					return item.description
				end
			end
		end
		return nil
	end

	function Menu._drawMenu(self: Menu, right: number, top: number): number
		local metrics = self.metrics
		local canvas = self.canvas
		local measure = self.measure
		local font = self.font
		local accent = self.accent
		local page = self:_currentPage()
		local fade = ease(self.openFade)
		local width = metrics.width
		local x = right - width + (1 - fade) * 36 * metrics.scale
		local panel = math.min(1, self.settings.opacity / 100 + 0.08)
		canvas.alpha = fade
		local menuRegion = self:_addRegion("menu", x, top, width, 0)

		local listTop = self:_drawHeader(x, top, width, panel)

		-- rows
		local listHeight = self:_drawRows(page, x, listTop, width, fade)
		local y = listTop + listHeight

		-- footer: position and key hints
		canvas.alpha = fade
		canvas:rect(x, y, width, metrics.footer, Palette.header, panel)
		canvas:rect(x, y, width, 1, Palette.border, 0.9)
		local position, count = selectablePosition(page, page.selected)
		local counter = if count > 0 then `{position}/{count}` else "-"
		local textY = y + (metrics.footer - metrics.small) / 2 - 1
		canvas:text(x + metrics.pad, textY, counter, metrics.small, Palette.subtext, 1)
		local counterWidth = measure:width(counter, metrics.small, font)
		local hint = measure:fit(
			self:_hint(page),
			width - metrics.pad * 3 - counterWidth,
			metrics.small,
			font
		)
		local hintWidth = measure:width(hint, metrics.small, font)
		canvas:text(x + width - metrics.pad - hintWidth, textY, hint, metrics.small, Palette.dim, 1)
		y += metrics.footer
		canvas:outline(x, top, width, y - top, Palette.border, 0.9, 1)

		-- description of the selected option
		local description = self:_description(page)
		if description then
			y += 4 * metrics.scale
			local innerWidth = width - metrics.pad * 2 - metrics.accentBar
			local lines =
				measure:wrap(description, innerWidth, metrics.small, font, Config.DESCRIPTION_LINES)
			local lineHeight = metrics.small + 4 * metrics.scale
			local boxHeight = #lines * lineHeight + 10 * metrics.scale
			canvas:rect(x, y, width, boxHeight, Palette.background, panel)
			canvas:rect(x, y, metrics.accentBar, boxHeight, accent, 0.8)
			canvas:outline(x, y, width, boxHeight, Palette.border, 0.8, 1)
			for index, line in lines do
				local lineY = y + 5 * metrics.scale + (index - 1) * lineHeight
				canvas:text(
					x + metrics.accentBar + metrics.pad,
					lineY,
					line,
					metrics.small,
					Palette.subtext,
					1
				)
			end
			y += boxHeight
		end

		menuRegion.h = y - top
		self.menuRect = { x = x, y = top, w = width, h = y - top }
		self:_addShield(x, top, width, y - top)
		canvas.alpha = 1
		return y
	end

	function Menu._optionHeight(
		self: Menu,
		option: Option,
		width: number,
		maxHeight: number
	): number
		local metrics = self.metrics
		local kind = option.kind
		if kind == "header" then
			return metrics.section
		elseif kind == "separator" then
			return metrics.separator
		elseif kind == "label" then
			local lines = self.measure:wrap(
				option.text,
				width - metrics.pad * 2,
				metrics.small,
				self.font,
				Config.LABEL_LINES
			)
			return math.min(maxHeight, math.max(1, #lines) * metrics.line + 6 * metrics.scale)
		elseif kind == "canvas" then
			local state = option.canvas
			if state then
				return math.min(maxHeight, math.floor(state.height * metrics.scale + 0.5))
			end
		end
		return metrics.row
	end

	function Menu._layoutRows(
		self: Menu,
		page: Page,
		width: number,
		maxHeight: number
	): { RowLayout }
		local rows = self.rows
		local count = 0
		for _, option in page.options do
			if not option.visible or option.destroyed then
				continue
			end
			count += 1
			local row = rows[count]
			if row == nil then
				row = { option = option, height = 0 }
				rows[count] = row
			end
			row.option = option
			row.height = self:_optionHeight(option, width, maxHeight)
		end
		for index = #rows, count + 1, -1 do
			rows[index] = nil
		end
		return rows
	end

	-- Scrolls just enough to keep the selection in view
	local function fitScroll(page: Page, rows: { RowLayout }, maxHeight: number): ()
		local count = #rows
		if count == 0 then
			page.scroll = 1
			return
		end
		local maxScroll = count
		local sum = 0
		for index = count, 1, -1 do
			sum += rows[index].height
			if sum > maxHeight then
				break
			end
			maxScroll = index
		end
		local scroll = math.clamp(page.scroll, 1, maxScroll)
		local selectedIndex: number? = nil
		local firstSelectable, lastSelectable = 0, 0
		for index, row in rows do
			if isSelectable(row.option) then
				if firstSelectable == 0 then
					firstSelectable = index
				end
				lastSelectable = index
			end
			if rawequal(row.option, page.selected) then
				selectedIndex = index
			end
		end
		if selectedIndex then
			-- at the first / last option, also show the rows above / below it
			if selectedIndex == firstSelectable then
				local above = 0
				for index = 1, selectedIndex do
					above += rows[index].height
				end
				if above <= maxHeight then
					scroll = 1
				end
			elseif selectedIndex == lastSelectable and maxScroll <= selectedIndex then
				scroll = maxScroll
			end
			if selectedIndex < scroll then
				scroll = selectedIndex
				if scroll > 1 and rows[scroll - 1].option.kind == "header" then
					scroll -= 1 -- keep the section title above the selection in view
				end
			else
				local height = 0
				for index = scroll, selectedIndex do
					height += rows[index].height
				end
				while height > maxHeight and scroll < selectedIndex do
					height -= rows[scroll].height
					scroll += 1
				end
			end
		end
		page.scroll = math.clamp(scroll, 1, maxScroll)
	end

	function Menu._drawRows(
		self: Menu,
		page: Page,
		x: number,
		top: number,
		width: number,
		fade: number
	): number
		local metrics = self.metrics
		local canvas = self.canvas
		local accent = self.accent
		local background = self.settings.opacity / 100
		local maxHeight = self.settings.rows * metrics.row
		local rows = self:_layoutRows(page, width, maxHeight)
		local count = #rows
		local total = 0
		for index = 1, count do
			total += rows[index].height
		end
		local viewHeight = math.max(metrics.row, math.min(total, maxHeight))
		ensureSelection(page)
		fitScroll(page, rows, maxHeight)

		-- rows that fit in the view, from the scroll position down
		local first = page.scroll
		local last = first - 1
		local used = 0
		for index = first, count do
			local height = rows[index].height
			if used + height > viewHeight + 0.5 then
				break
			end
			used += height
			last = index
		end

		canvas.alpha = fade
		canvas:rect(x, top, width, viewHeight, Palette.background, background)

		-- scroller behind the selected row
		local enter = ease(self.pageFade)
		local slide = (1 - enter) * 24 * metrics.scale * self.pageDirection
		local y = top
		for index = first, last do
			local row = rows[index]
			if rawequal(row.option, page.selected) then
				self.scrollerTarget = y - top
				self.scrollerTargetHeight = row.height
				if self.snapScroller or not self.settings.animations then
					self.scrollerY = self.scrollerTarget
					self.scrollerHeight = row.height
					self.snapScroller = false
				end
				canvas.alpha = fade * enter
				canvas:rect(x, top + self.scrollerY, width, self.scrollerHeight, accent, 0.18)
				canvas:rect(
					x,
					top + self.scrollerY,
					metrics.accentBar,
					self.scrollerHeight,
					accent,
					1
				)
				break
			end
			y += row.height
		end

		-- rows
		canvas.alpha = fade * enter
		y = top
		for index = first, last do
			local row = rows[index]
			local option = row.option
			local selected = rawequal(option, page.selected)
			local nudge = 0
			if selected then
				local distance = math.abs(self.scrollerY - (y - top))
				nudge = metrics.nudge * math.clamp(1 - distance / metrics.row, 0, 1)
			end
			if option.kind == "canvas" then
				local region = self:_addRegion("canvas", x, y, width, row.height)
				region.option = option
			elseif Config.SELECTABLE[option.kind] then
				local region = self:_addRegion("row", x, y, width, row.height)
				region.option = option
			end
			self:_drawOption(option, x + slide, y, width, row.height, selected, nudge)
			y += row.height
		end
		if count == 0 then
			canvas:text(
				x + metrics.pad,
				top + (metrics.row - metrics.small) / 2 - 1,
				"Nothing here yet",
				metrics.small,
				Palette.dim,
				1
			)
		end

		-- scrollbar
		if total > viewHeight + 0.5 then
			canvas.alpha = fade
			local trackX = x + width - metrics.scrollbar - 2
			local trackHeight = viewHeight - 4
			canvas:rect(trackX, top + 2, metrics.scrollbar, trackHeight, Palette.border, 0.5)
			local before = 0
			for index = 1, first - 1 do
				before += rows[index].height
			end
			local thumbHeight = math.max(12 * metrics.scale, trackHeight * viewHeight / total)
			local fraction = math.clamp(before / math.max(1, total - viewHeight), 0, 1)
			canvas:rect(
				trackX,
				top + 2 + (trackHeight - thumbHeight) * fraction,
				metrics.scrollbar,
				thumbHeight,
				accent,
				0.9
			)
		end
		canvas.alpha = fade
		return viewHeight
	end

	function Menu._drawOption(
		self: Menu,
		option: Option,
		x: number,
		y: number,
		width: number,
		height: number,
		selected: boolean,
		nudge: number
	): ()
		local metrics = self.metrics
		local canvas = self.canvas
		local measure = self.measure
		local font = self.font
		local kind = option.kind
		local right = x + width - metrics.pad

		if kind == "header" then
			local label = string.upper(option.text)
			canvas:text(
				x + metrics.pad,
				y + (height - metrics.small) / 2 - 1,
				label,
				metrics.small,
				self.accent,
				1
			)
			local lineX = x
				+ metrics.pad
				+ measure:width(label, metrics.small, font)
				+ 8 * metrics.scale
			if lineX < right then
				canvas:rect(lineX, y + height / 2, right - lineX, 1, Palette.border, 0.8)
			end
			return
		elseif kind == "separator" then
			canvas:rect(
				x + metrics.pad,
				y + height / 2,
				width - metrics.pad * 2,
				1,
				Palette.border,
				0.8
			)
			return
		elseif kind == "label" then
			local lines = measure:wrap(
				option.text,
				width - metrics.pad * 2,
				metrics.small,
				font,
				Config.LABEL_LINES
			)
			local color = option.color or Palette.subtext
			-- the row may be shorter than the text when few rows are visible
			local fits = math.max(1, math.floor((height - 3 * metrics.scale) / metrics.line))
			for index = 1, math.min(#lines, fits) do
				local lineY = y + 3 * metrics.scale + (index - 1) * metrics.line
				canvas:text(x + metrics.pad, lineY, lines[index], metrics.small, color, 1)
			end
			return
		elseif kind == "canvas" then
			local state = option.canvas
			if state then
				canvas:outline(x, y, width, height, Palette.border, 0.9, 1)
				local area = { x = x + 1, y = y + 1, w = width - 2, h = height - 2 }
				state.rect = area
				local label = `{option.page.name} canvas`
				self:_paint(state.painter, area.x, area.y, area.w, area.h, area, label)
				if state.animate then
					self:_wake(self.now)
				end
			end
			return
		end

		-- interactive rows: the value sits on the right, the text on the left
		local valueLeft = self:_drawValue(option, y, width, height, selected, right)
		local color = if not option.enabled
			then Palette.dim
			elseif selected then Palette.white
			else Palette.text
		if option.enabled and option.color then
			color = option.color
		end
		if self.now < option.flashUntil then
			color = option.flashColor
			self:_wake(option.flashUntil)
		end
		local left = x + metrics.pad + nudge
		local text =
			measure:fit(option.text, valueLeft - left - 8 * metrics.scale, metrics.text, font)
		canvas:text(
			left,
			y + (height - metrics.text) / 2 - 1,
			text,
			metrics.text,
			color,
			if selected then 1 else 0.86
		)
	end

	-- Draws the right-hand side of a row and returns where it starts
	function Menu._drawValue(
		self: Menu,
		option: Option,
		y: number,
		width: number,
		height: number,
		selected: boolean,
		right: number
	): number
		local metrics = self.metrics
		local canvas = self.canvas
		local measure = self.measure
		local font = self.font
		local accent = self.accent
		local middle = y + height / 2
		local valueColor = if not option.enabled
			then Palette.dim
			elseif selected then accent
			else Palette.subtext
		local smallY = middle - metrics.small / 2 - 1
		local textY = middle - metrics.text / 2 - 1
		local kind = option.kind

		if kind == "toggle" then
			local toggle = option.toggle
			local on = toggle ~= nil and toggle.on
			local size = metrics.check
			local boxX = right - size
			local boxY = middle - size / 2
			canvas:rect(boxX, boxY, size, size, Palette.field, 1)
			canvas:outline(
				boxX,
				boxY,
				size,
				size,
				if selected then accent else Palette.border,
				1,
				1
			)
			local fill = if toggle then toggle.fill else 0
			if fill > 0.01 then
				local inset = math.max(2, 3 * metrics.scale)
				canvas:rect(
					boxX + inset,
					boxY + inset,
					size - inset * 2,
					size - inset * 2,
					accent,
					fill
				)
			end
			local state = if on then "ON" else "OFF"
			local stateWidth = measure:width(state, metrics.small, font)
			local stateX = boxX - 7 * metrics.scale - stateWidth
			canvas:text(
				stateX,
				smallY,
				state,
				metrics.small,
				if on and option.enabled then accent else Palette.dim,
				1
			)
			return stateX
		elseif kind == "cycle" then
			local cycle = option.cycle
			local choice = cycle and cycle.choices[cycle.index]
			local arrow = metrics.chevron
			local gap = 7 * metrics.scale
			local text =
				measure:fit(if choice then choice.text else "", width * 0.5, metrics.text, font)
			local textWidth = measure:width(text, metrics.text, font)
			if not selected then
				canvas:text(right - textWidth, textY, text, metrics.text, valueColor, 1)
				return right - textWidth
			end
			local textX = right - arrow - gap - textWidth
			local leftArrow = textX - gap - arrow
			canvas:text(textX, textY, text, metrics.text, valueColor, 1)
			canvas:triangle(
				leftArrow + arrow,
				middle - arrow,
				leftArrow,
				middle,
				leftArrow + arrow,
				middle + arrow,
				accent,
				1
			)
			canvas:triangle(
				right - arrow,
				middle - arrow,
				right,
				middle,
				right - arrow,
				middle + arrow,
				accent,
				1
			)
			local split = textX + textWidth / 2
			local leftRegion =
				self:_addRegion("cycleLeft", leftArrow - gap, y, split - leftArrow + gap, height)
			leftRegion.option = option
			local rightRegion =
				self:_addRegion("cycleRight", split, y, right + metrics.pad - split, height)
			rightRegion.option = option
			return leftArrow
		elseif kind == "slider" then
			local slider = option.slider
			if slider == nil then
				return right
			end
			local barWidth = metrics.slider
			local barHeight = math.max(3, 4 * metrics.scale)
			local barX = right - barWidth
			local fraction = (slider.value - slider.min) / (slider.max - slider.min)
			slider.barX = barX
			slider.barWidth = barWidth
			canvas:rect(barX, middle - barHeight / 2, barWidth, barHeight, Palette.border, 1)
			canvas:rect(barX, middle - barHeight / 2, barWidth * fraction, barHeight, valueColor, 1)
			local knobWidth = math.max(3, 4 * metrics.scale)
			local knobHeight = 10 * metrics.scale
			local knobColor = if selected then Palette.white else Palette.subtext
			canvas:rect(
				barX + barWidth * fraction - knobWidth / 2,
				middle - knobHeight / 2,
				knobWidth,
				knobHeight,
				knobColor,
				1
			)
			local region = self:_addRegion(
				"slider",
				barX - 6 * metrics.scale,
				y,
				barWidth + 6 * metrics.scale + metrics.pad,
				height
			)
			region.option = option
			local editing = self.editing
			if editing and rawequal(editing.option, option) then
				local fieldWidth = math.min(metrics.field * 0.6, width * 0.3)
				local fieldX = barX - 8 * metrics.scale - fieldWidth
				self:_drawField(
					option,
					fieldX,
					y + 3 * metrics.scale,
					fieldWidth,
					height - 6 * metrics.scale,
					"",
					"",
					selected
				)
				return fieldX
			end
			local text = slider.format(slider.value)
			local textWidth = measure:width(text, metrics.small, font)
			local textX = barX - 8 * metrics.scale - textWidth
			canvas:text(textX, smallY, text, metrics.small, valueColor, 1)
			return textX
		elseif kind == "input" then
			local input = option.input
			if input == nil then
				return right
			end
			local fieldWidth = math.min(metrics.field, width * 0.5)
			local fieldX = right - fieldWidth
			self:_drawField(
				option,
				fieldX,
				y + 3 * metrics.scale,
				fieldWidth,
				height - 6 * metrics.scale,
				input.value,
				input.placeholder,
				selected
			)
			return fieldX
		elseif kind == "keybind" then
			local keybind = option.keybind
			local listening = rawequal(self.capturing, option)
			local text = if listening then "[ ... ]" else `[{keyLabel(keybind and keybind.key)}]`
			local color = valueColor
			if listening then
				local blink = self.now % Config.BLINK_PERIOD < Config.BLINK_ON
				color = if blink then accent else Palette.dim
				self:_wake(self.now + Config.BLINK_TICK)
			end
			local textWidth = measure:width(text, metrics.text, font)
			canvas:text(right - textWidth, textY, text, metrics.text, color, 1)
			return right - textWidth
		elseif kind == "binding" then
			local controls = option.binding
			if controls == nil then
				return right
			end
			local list = self.bindings[controls.action]
			local waitingHere = rawequal(self.capturing, option)
			local chipHeight = height - 8 * metrics.scale
			local chipTop = middle - chipHeight / 2
			local maxText = 84 * metrics.scale
			local cursor = right
			for slot = Config.KEY_SLOTS, 1, -1 do
				local binding = if list then list[slot] else nil
				local waiting = waitingHere and controls.slot == slot
				local text = "-"
				local color = Palette.dim
				if waiting then
					local pending = self.capturePending
					text = if pending then `{keyLabel(pending)}+...` else "..."
					local blink = self.now % Config.BLINK_PERIOD < Config.BLINK_ON
					color = if blink then accent else Palette.dim
					self:_wake(self.now + Config.BLINK_TICK)
				elseif binding then
					text = measure:fit(bindingLabel(binding), maxText, metrics.small, font)
					color = if option.enabled then Palette.text else Palette.dim
				end
				local textWidth = measure:width(text, metrics.small, font)
				local chipWidth = math.max(textWidth + metrics.keycap * 2, 30 * metrics.scale)
				local chipX = cursor - chipWidth
				local focused = (selected and controls.slot == slot) or waiting
				canvas:rect(chipX, chipTop, chipWidth, chipHeight, Palette.field, 1)
				canvas:outline(
					chipX,
					chipTop,
					chipWidth,
					chipHeight,
					if focused then accent else Palette.border,
					1,
					1
				)
				canvas:text(
					chipX + (chipWidth - textWidth) / 2,
					smallY,
					text,
					metrics.small,
					color,
					1
				)
				local region = self:_addRegion("bindingSlot", chipX, chipTop, chipWidth, chipHeight)
				region.option = option
				region.slot = slot
				cursor = chipX - 6 * metrics.scale
			end
			return cursor + 6 * metrics.scale
		elseif kind == "list" or kind == "submenu" then
			local arrow = metrics.chevron
			canvas:triangle(
				right - arrow,
				middle - arrow,
				right,
				middle,
				right - arrow,
				middle + arrow,
				if selected then accent else Palette.subtext,
				1
			)
			local valueRight = right - arrow - 8 * metrics.scale
			local text = option.badge or ""
			local list = option.list
			if list then
				text = list.placeholder
				for _, item in list.items do
					if item.key == list.selected then
						text = item.text
						break
					end
				end
			end
			if text == "" then
				return valueRight
			end
			text = measure:fit(text, width * 0.45, metrics.small, font)
			local textWidth = measure:width(text, metrics.small, font)
			canvas:text(valueRight - textWidth, smallY, text, metrics.small, valueColor, 1)
			return valueRight - textWidth
		elseif kind == "choice" then
			local state = option.choice
			local list = state and state.owner.list
			if state and list and list.selected == state.item.key then
				local size = math.max(4, 6 * metrics.scale)
				canvas:rect(right - size, middle - size / 2, size, size, accent, 1)
				return right - size
			end
			return right
		elseif kind == "button" then
			if self.now < option.armedUntil then
				self:_wake(option.armedUntil)
				local text =
					measure:fit(option.confirm or "Confirm?", width * 0.5, metrics.small, font)
				local textWidth = measure:width(text, metrics.small, font)
				canvas:text(right - textWidth, smallY, text, metrics.small, Palette.warn, 1)
				return right - textWidth
			end
			local badge = option.badge
			if badge then
				local textWidth = measure:width(badge, metrics.small, font)
				canvas:text(right - textWidth, smallY, badge, metrics.small, valueColor, 1)
				return right - textWidth
			end
		end
		return right
	end

	-- A text field; while it is being typed in it shows the typed text and a caret
	function Menu._drawField(
		self: Menu,
		option: Option,
		x: number,
		y: number,
		w: number,
		h: number,
		value: string,
		placeholder: string,
		selected: boolean
	): ()
		local metrics = self.metrics
		local canvas = self.canvas
		local measure = self.measure
		local font = self.font
		local editing = self.editing
		local active = editing ~= nil and rawequal(editing.option, option)
		canvas:rect(x, y, w, h, Palette.field, 1)
		local border = if active
			then self.accent
			elseif selected then Palette.subtext
			else Palette.border
		canvas:outline(x, y, w, h, border, 1, 1)
		local innerX = x + 6 * metrics.scale
		local innerWidth = w - 12 * metrics.scale
		local textY = y + (h - metrics.small) / 2 - 1
		if editing and active then
			local before = string.sub(editing.text, 1, editing.cursor - 1)
			local shown = measure:tail(before, innerWidth - 2, metrics.small, font)
			local caretX = innerX + measure:width(shown, metrics.small, font)
			local after = string.sub(editing.text, editing.cursor)
			local rest = measure:fit(after, innerWidth - (caretX - innerX) - 2, metrics.small, font)
			canvas:text(innerX, textY, shown .. rest, metrics.small, Palette.white, 1)
			if self.now % Config.CARET_PERIOD < Config.CARET_ON then
				canvas:rect(caretX, y + 4 * metrics.scale, 1, h - 8 * metrics.scale, self.accent, 1)
			end
			self:_wake(self.now + Config.BLINK_TICK)
			return
		end
		local empty = value == ""
		local text =
			measure:fit(if empty then placeholder else value, innerWidth, metrics.small, font)
		local color = if empty then Palette.dim elseif selected then Palette.white else Palette.text
		canvas:text(innerX, textY, text, metrics.small, color, 1)
	end

	-- The tag in the corner while the menu is closed: the title, status segments, the open key
	function Menu._drawWatermark(self: Menu, right: number, top: number, alpha: number): number
		local metrics = self.metrics
		local canvas = self.canvas
		local measure = self.measure
		local font = self.font
		local scale = metrics.scale
		local small = metrics.small
		local height = metrics.row + 4 * scale
		local titleSize = metrics.text
		local spacing = 9 * scale
		local dot = math.max(4, 6 * scale)
		local statusTexts: { string } = {}
		local width = metrics.pad + measure:width(self.title, titleSize, font)
		for index, status in self.statuses do
			local text = measure:fit(status.text, metrics.width * 0.55, small, font)
			statusTexts[index] = text
			width += spacing * 2 + 1 + measure:width(text, small, font)
			if status.color then
				width += dot + 5 * scale
			end
		end
		local hint = self:_actionLabel("toggle")
		if hint then
			width += spacing * 2 + 1 + measure:width(hint, small, font)
		end
		width += metrics.pad
		local x = right - width
		local middle = top + height / 2
		canvas.alpha = alpha
		canvas:rect(x, top, width, height, Palette.background, self.settings.opacity / 100)
		canvas:outline(x, top, width, height, Palette.border, 0.9, 1)
		local cursor = x + metrics.pad
		canvas:text(cursor, middle - titleSize / 2 - 1, self.title, titleSize, Palette.white, 1)
		cursor += measure:width(self.title, titleSize, font)
		local smallY = middle - small / 2 - 1
		local function divider(): ()
			cursor += spacing
			canvas:rect(cursor, top + 7 * scale, 1, height - 14 * scale, Palette.border, 1)
			cursor += 1 + spacing
		end
		for index, status in self.statuses do
			divider()
			if status.color then
				canvas:rect(cursor, middle - dot / 2, dot, dot, status.color, 1)
				cursor += dot + 5 * scale
			end
			canvas:text(cursor, smallY, statusTexts[index], small, Palette.subtext, 1)
			cursor += measure:width(statusTexts[index], small, font)
		end
		if hint then
			divider()
			canvas:text(cursor, smallY, hint, small, Palette.dim, 1)
		end
		self:_addRegion("watermark", x, top, width, height)
		self:_addShield(x, top, width, height)
		canvas.alpha = 1
		return top + height
	end

	function Menu._drawPrompt(self: Menu, spec: PromptSpec, right: number, top: number): number
		local metrics = self.metrics
		local canvas = self.canvas
		local measure = self.measure
		local font = self.font
		local accent = self.accent
		local width = metrics.width
		local x = right - width
		local innerX = x + metrics.accentBar + metrics.pad
		local innerWidth = width - metrics.accentBar - metrics.pad * 2
		local lineHeight = metrics.small + 4 * metrics.scale
		local title = if spec.title then string.upper(spec.title) else nil
		local lines: { string } = {}
		local specLines = spec.lines
		if specLines then
			for _, line in specLines do
				local wrapped =
					measure:wrap(line, innerWidth, metrics.small, font, Config.PROMPT_LINES)
				table.move(wrapped, 1, #wrapped, #lines + 1, lines)
			end
		end
		local chips: { Chip } = {}
		local chipHeight = metrics.small + 8 * metrics.scale
		local chipX, chipY = 0, 0
		local keys = spec.keys
		if keys then
			for _, key in keys do
				local keyWidth = measure:width(key.key, metrics.small, font) + 10 * metrics.scale
				local chipWidth = keyWidth
					+ 6 * metrics.scale
					+ measure:width(key.text, metrics.small, font)
				if chipX > 0 and chipX + chipWidth > innerWidth then
					chipX = 0
					chipY += chipHeight + 5 * metrics.scale
				end
				table.insert(
					chips,
					{ x = chipX, y = chipY, w = chipWidth, keyWidth = keyWidth, key = key }
				)
				chipX += chipWidth + 12 * metrics.scale
			end
		end
		local height = 16 * metrics.scale
		if title then
			height += metrics.small + 6 * metrics.scale
		end
		height += #lines * lineHeight
		if #chips > 0 then
			height += chipY + chipHeight + (if title or #lines > 0 then 4 * metrics.scale else 0)
		end
		canvas.alpha = 1
		canvas:rect(x, top, width, height, Palette.background, self.settings.opacity / 100)
		canvas:rect(x, top, metrics.accentBar, height, accent, 1)
		canvas:outline(x, top, width, height, accent, 0.3, 1)
		local y = top + 8 * metrics.scale
		if title then
			canvas:text(
				innerX,
				y,
				measure:fit(title, innerWidth, metrics.small, font),
				metrics.small,
				accent,
				1
			)
			y += metrics.small + 6 * metrics.scale
		end
		for _, line in lines do
			canvas:text(innerX, y, line, metrics.small, Palette.text, 1)
			y += lineHeight
		end
		if #chips > 0 then
			if title or #lines > 0 then
				y += 4 * metrics.scale
			end
			for _, chip in chips do
				local left = innerX + chip.x
				local chipTop = y + chip.y
				local textY = chipTop + (chipHeight - metrics.small) / 2 - 1
				canvas:rect(left, chipTop, chip.keyWidth, chipHeight, Palette.field, 1)
				canvas:outline(left, chipTop, chip.keyWidth, chipHeight, accent, 0.9, 1)
				canvas:text(
					left + 5 * metrics.scale,
					textY,
					chip.key.key,
					metrics.small,
					Palette.white,
					1
				)
				canvas:text(
					left + chip.keyWidth + 6 * metrics.scale,
					textY,
					chip.key.text,
					metrics.small,
					Palette.subtext,
					1
				)
				if chip.key.callback then
					local region = self:_addRegion("promptKey", left, chipTop, chip.w, chipHeight)
					region.key = chip.key
				end
			end
		end
		self:_addShield(x, top, width, height)
		return top + height
	end

	function Menu._drawTask(self: Menu, taskCard: Task, right: number, top: number): number
		local metrics = self.metrics
		local canvas = self.canvas
		local measure = self.measure
		local font = self.font
		local fade = ease(taskCard.fade)
		local width = metrics.width
		local x = right - width + (1 - fade) * 30 * metrics.scale
		local innerX = x + metrics.accentBar + metrics.pad
		local innerWidth = width - metrics.accentBar - metrics.pad * 2
		local now = self.now
		local ended = taskCard.ended
		local color = self.accent
		if ended then
			color = if taskCard.ok then Palette.good else Palette.bad
		elseif taskCard.stopped then
			color = Palette.warn
		end
		local elapsed = (ended or now) - taskCard.started
		local canStop = taskCard.onStop ~= nil
			and ended == nil
			and not taskCard.stopped
			and not taskCard.removed
		local stopText = "[Stop]"
		local stopWidth = if canStop
			then measure:width(stopText, metrics.small, font) + 8 * metrics.scale
			else 0
		local barHeight = math.max(4, 6 * metrics.scale)
		local lineHeight = metrics.small + 5 * metrics.scale
		local hasDetail = taskCard.detail ~= ""
		local height = 16 * metrics.scale
			+ metrics.text
			+ 5 * metrics.scale
			+ lineHeight
			+ barHeight
			+ 6 * metrics.scale
			+ lineHeight
		if hasDetail then
			height += lineHeight
		end

		canvas.alpha = fade
		canvas:rect(x, top, width, height, Palette.background, self.settings.opacity / 100)
		canvas:rect(x, top, metrics.accentBar, height, color, 1)
		canvas:outline(x, top, width, height, color, 0.3, 1)
		local y = top + 8 * metrics.scale
		local title = measure:fit(taskCard.title, innerWidth - stopWidth, metrics.text, font)
		canvas:text(innerX, y, title, metrics.text, Palette.white, 1)
		if canStop then
			local stopX = x + width - metrics.pad - (stopWidth - 8 * metrics.scale)
			canvas:text(stopX, y + 1, stopText, metrics.small, Palette.bad, 1)
			local region = self:_addRegion(
				"taskStop",
				stopX - 6 * metrics.scale,
				top,
				width - (stopX - x) + 6 * metrics.scale,
				metrics.text + 16 * metrics.scale
			)
			region.task = taskCard
		end
		y += metrics.text + 5 * metrics.scale
		canvas:text(
			innerX,
			y,
			measure:fit(taskCard.phase, innerWidth, metrics.small, font),
			metrics.small,
			Palette.subtext,
			1
		)
		y += lineHeight
		canvas:rect(innerX, y, innerWidth, barHeight, Palette.border, 1)
		if taskCard.total > 0 then
			local fraction = math.clamp(taskCard.done / taskCard.total, 0, 1)
			canvas:rect(innerX, y, innerWidth * fraction, barHeight, color, 1)
		elseif ended then
			canvas:rect(innerX, y, innerWidth, barHeight, color, 1)
		else
			-- unknown total: a sliding segment
			local segment = innerWidth * 0.3
			local phase = (now * Config.BUSY_SPEED) % 1
			local segmentX = innerX
				+ (innerWidth - segment) * (0.5 - 0.5 * math.cos(phase * math.pi * 2))
			canvas:rect(segmentX, y, segment, barHeight, color, 1)
			self:_wake(now + 1 / Config.BUSY_FPS)
		end
		y += barHeight + 6 * metrics.scale
		local stats = clock(elapsed)
		if taskCard.total > 0 then
			local left = math.max(0, taskCard.total - taskCard.done)
			stats = `{taskCard.done} / {taskCard.total}   {stats}`
			if ended == nil and taskCard.done > 0 and left > 0 then
				stats ..= `   ~{clock(elapsed / taskCard.done * left)} left`
			end
		end
		canvas:text(
			innerX,
			y,
			measure:fit(stats, innerWidth, metrics.small, font),
			metrics.small,
			Palette.dim,
			1
		)
		if hasDetail then
			y += lineHeight
			canvas:text(
				innerX,
				y,
				measure:fit(taskCard.detail, innerWidth, metrics.small, font),
				metrics.small,
				Palette.dim,
				1
			)
		end
		if ended == nil then
			self:_wake(now + 1 - (elapsed % 1))
		end
		self:_addShield(x, top, width, height)
		canvas.alpha = 1
		return top + height
	end

	function Menu._drawToast(self: Menu, toast: Toast, right: number, top: number): number
		local metrics = self.metrics
		local canvas = self.canvas
		local measure = self.measure
		local font = self.font
		local fade = ease(toast.fade)
		local width = metrics.width
		local x = right - width + (1 - fade) * 40 * metrics.scale
		local innerX = x + metrics.accentBar + metrics.pad
		local innerWidth = width - metrics.accentBar - metrics.pad * 2
		local lineHeight = metrics.small + 4 * metrics.scale
		local lines = measure:wrap(toast.text, innerWidth, metrics.small, font, Config.TOAST_LINES)
		local color = toast.color or self.accent
		local height = 14 * metrics.scale + #lines * lineHeight
		if toast.title then
			height += metrics.text + 4 * metrics.scale
		end
		canvas.alpha = fade
		canvas:rect(x, top, width, height, Palette.background, self.settings.opacity / 100)
		canvas:rect(x, top, metrics.accentBar, height, color, 1)
		canvas:outline(x, top, width, height, color, 0.3, 1)
		local y = top + 7 * metrics.scale
		if toast.title then
			canvas:text(
				innerX,
				y,
				measure:fit(toast.title, innerWidth, metrics.text, font),
				metrics.text,
				color,
				1
			)
			y += metrics.text + 4 * metrics.scale
		end
		for _, line in lines do
			canvas:text(innerX, y, line, metrics.small, Palette.text, 1)
			y += lineHeight
		end
		local region = self:_addRegion("toast", x, top, width, height)
		region.toast = toast
		self:_addShield(x, top, width, height)
		if not toast.closing then
			self:_wake(toast.born + toast.duration)
		end
		canvas.alpha = 1
		return top + height
	end

	-- ============ Menu: built-in pages ============
	function Menu._buildRoot(self: Menu): ()
		local root = self.root
		self.emptyLabel =
			root:label("No pages yet - run a Corny script to add one.", { color = Palette.dim })
		root:separator()
	end

	function Menu._buildSettings(self: Menu): ()
		local settings = self.settings
		local page = self.root:submenu("Menu Settings", {
			description = "Colors, size, layout and keys. Saved to Corny/cornymenu.json.",
		})
		local controls: { [string]: Option } = {}
		local function changed(): ()
			self:_applySettings()
			self:_saveSoon()
		end
		local accentNames: { string } = {}
		for _, accent in Config.ACCENTS do
			table.insert(accentNames, accent.name)
		end
		local ranges = Config.RANGES

		page:header("Appearance")
		controls.accent = page:cycle(
			"Accent color",
			accentNames,
			settings.accent,
			function(name: any)
				settings.accent = tostring(name)
				changed()
			end,
			{ description = "Color of the scroller, the titles and the highlights." }
		)
		controls.opacity = page:slider("Background", settings.opacity, function(value: number)
			settings.opacity = value
			changed()
		end, {
			min = ranges.opacity.min,
			max = ranges.opacity.max,
			step = ranges.opacity.step,
			format = percent,
			description = "How solid the panels are.",
		})
		controls.scale = page:slider("Size", settings.scale, function(value: number)
			settings.scale = value
			changed()
		end, {
			min = ranges.scale.min,
			max = ranges.scale.max,
			step = ranges.scale.step,
			format = percent,
			description = "Scales the whole menu.",
		})
		controls.font = page:cycle("Font", Config.FONTS, settings.font, function(name: any)
			settings.font = tostring(name)
			changed()
		end)
		controls.rows = page:slider("Visible rows", settings.rows, function(value: number)
			settings.rows = value
			changed()
		end, {
			min = ranges.rows.min,
			max = ranges.rows.max,
			step = ranges.rows.step,
			description = "Rows shown before a page scrolls.",
		})
		controls.animations = page:toggle("Animations", settings.animations, function(on: boolean)
			settings.animations = on
			changed()
		end)

		page:header("Screen")
		controls.offsetX = page:slider("Move left", settings.offsetX, function(value: number)
			settings.offsetX = value
			changed()
		end, {
			min = ranges.offsetX.min,
			max = ranges.offsetX.max,
			step = ranges.offsetX.step,
			format = pixels,
			description = "A smaller window keeps the menu on screen anyway.",
		})
		controls.offsetY = page:slider("Move down", settings.offsetY, function(value: number)
			settings.offsetY = value
			changed()
		end, {
			min = ranges.offsetY.min,
			max = ranges.offsetY.max,
			step = ranges.offsetY.step,
			format = pixels,
		})
		controls.watermark = page:toggle("Watermark", settings.watermark, function(on: boolean)
			if not on and #settings.keys.toggle == 0 then
				controls.watermark:set(true)
				self:notify(
					"Set an open key first - the watermark is the only way back in.",
					{ color = Palette.warn }
				)
				return
			end
			settings.watermark = on
			changed()
		end, {
			description = "The tag in the corner while the menu is closed. Click it to open.",
		})
		self.watermarkOption = controls.watermark
		controls.toasts = page:toggle("Notifications", settings.toasts, function(on: boolean)
			settings.toasts = on
			changed()
		end, { description = "Messages that pop up under the menu." })

		page:header("Controls")
		local controlsPage = page:submenu("Controls", {
			description = "Every key the menu uses (two each, combinations too), key repeat "
				.. "and mouse behavior.",
		})
		self:_buildControls(controlsPage, controls, changed)

		-- puts every control back in line with the settings (after a reset)
		local function sync(): ()
			for name, option in controls do
				-- any: the controls are keyed by the name of the setting they edit
				local value = (settings :: any)[name]
				if value ~= nil then
					option:set(value)
				end
			end
		end
		page:header("Session")
		page:button("Reset settings", function()
			Store.reset(settings)
			sync()
			changed()
			self:_guardToggle()
		end, {
			confirm = true,
			description = "Everything on these pages back to its default, keys included.",
		})
		self.syncControls = sync
		page:button("Unload menu", function()
			self:Destroy()
		end, {
			confirm = true,
			color = Palette.bad,
			description = "Closes the menu and stops every page (their cleanup runs).",
		})
		self.rendererLabel = page:label(rendererText(self.renderer.name), { color = Palette.dim })
	end

	-- The Controls page: two keys for every action, key repeat, mouse behavior
	function Menu._buildControls(
		self: Menu,
		page: Page,
		controls: { [string]: Option },
		changed: () -> ()
	): ()
		local settings = self.settings
		local ranges = Config.RANGES
		page:label(
			"Two keys each: pick one with Decrease / Increase. Hold Ctrl, Shift or Alt "
				.. "first for a combination.",
			{ color = Palette.subtext }
		)
		page:header("Keys")
		for _, def in Config.ACTIONS do
			local row = page:_add("binding", def.label, { description = def.description })
			row.binding = { action = def.id, slot = 1 }
		end

		page:header("Keyboard")
		controls.wrap = page:toggle("Wrap around", settings.wrap, function(on: boolean)
			settings.wrap = on
			changed()
		end, { description = "Moving past the last option comes back at the first." })
		controls.repeatDelay = page:slider(
			"Repeat delay",
			settings.repeatDelay,
			function(value: number)
				settings.repeatDelay = value
				changed()
			end,
			{
				min = ranges.repeatDelay.min,
				max = ranges.repeatDelay.max,
				step = ranges.repeatDelay.step,
				format = milliseconds,
				description = "How long a held key waits before it repeats.",
			}
		)
		controls.repeatRate = page:slider(
			"Repeat speed",
			settings.repeatRate,
			function(value: number)
				settings.repeatRate = value
				changed()
			end,
			{
				min = ranges.repeatRate.min,
				max = ranges.repeatRate.max,
				step = ranges.repeatRate.step,
				format = perSecond,
				description = "Repeats per second while a key is held (twice as fast later on).",
			}
		)
		controls.fastSteps = page:slider(
			"Fast step size",
			settings.fastSteps,
			function(value: number)
				settings.fastSteps = value
				changed()
			end,
			{
				min = ranges.fastSteps.min,
				max = ranges.fastSteps.max,
				step = ranges.fastSteps.step,
				format = times,
				description = "Slider steps per press while the fast key is held.",
			}
		)

		page:header("Mouse")
		controls.mouseBack = page:toggle(
			"Right click goes back",
			settings.mouseBack,
			function(on: boolean)
				settings.mouseBack = on
				changed()
			end
		)
		controls.mouseWheel = page:toggle(
			"Wheel moves the highlight",
			settings.mouseWheel,
			function(on: boolean)
				settings.mouseWheel = on
				changed() -- rebinds the wheel too
			end,
			{ description = "Off: the wheel zooms the camera even over the menu." }
		)
		controls.hoverSelect = page:toggle(
			"Hover highlights rows",
			settings.hoverSelect,
			function(on: boolean)
				settings.hoverSelect = on
				changed()
			end,
			{ description = "Off: only a click moves the highlight." }
		)

		page:header("Reset")
		page:button("Reset controls", function()
			Store.resetControls(settings)
			local sync = self.syncControls
			if sync then
				sync()
			end
			changed()
			self:_guardToggle()
		end, {
			confirm = true,
			description = "Every key, repeat and mouse setting back to its default.",
		})
	end

	-- ============ Menu: public API ============
	-- A top-level page in the main menu. A page with the same name is destroyed
	-- (its cleanup runs) and replaced in the same spot.
	function Menu.page(self: Menu, name: string, opts: OptionOptions?): Page
		assert(type(name) == "string" and name ~= "", "CornyMenu: a page needs a name")
		assert(not self.destroyed, "CornyMenu: the menu was unloaded")
		local root = self.root
		local slot: number? = nil
		local old = self.pages[name]
		local wasShowing = false
		if old then
			local oldEntry = old.entry
			slot = if oldEntry then table.find(root.options, oldEntry) else nil
			wasShowing = table.find(self.stack, old) ~= nil
			old:Destroy()
		end
		local page = newPage(self, name, root)
		local entry = newOption(root, "submenu", name, opts)
		entry.target = page
		page.entry = entry
		table.insert(root.children, page)
		local empty = self.emptyLabel
		local index = slot
			or (if empty then table.find(root.options, empty) else nil)
			or (#root.options + 1)
		table.insert(root.options, math.clamp(index, 1, #root.options + 1), entry)
		self.pages[name] = page
		if empty then
			empty.visible = false
		end
		if wasShowing and self.opened then
			self:_showPage(page)
		end
		self:_markDirty()
		return page
	end

	function Menu.getPage(self: Menu, name: string): Page?
		return self.pages[name]
	end

	function Menu.open(self: Menu): ()
		if self.destroyed or self.opened then
			return
		end
		self.opened = true
		self.snapScroller = true
		self:_bindNavigation(true)
		self:_markDirty()
	end

	function Menu.close(self: Menu): ()
		if not self.opened then
			return
		end
		self:_leavePage() -- first, while the menu is still fully open
		self.opened = false
		self.held = nil
		self:_bindNavigation(false)
		self:_markDirty()
	end

	function Menu.toggle(self: Menu): ()
		if self.opened then
			self:close()
		else
			self:open()
		end
	end

	function Menu.isOpen(self: Menu): boolean
		return self.opened
	end

	-- Rebinds the open key (nil = none). With no key the watermark is the only way back
	-- in, so it is turned on.
	function Menu.setToggleKey(self: Menu, key: Enum.KeyCode?): ()
		self:_setKeys("toggle", if key then { key.Name } else {})
	end

	-- Replaces the keys of an action (ids in CornyMenu.actions): up to two, as text ("Up",
	-- "Ctrl+M", KeyCode names with Ctrl / Shift / Alt) or KeyCodes. A key another action
	-- had moves here. Saved like a change in Menu Settings.
	function Menu.setKeys(self: Menu, action: string, keys: { string | Enum.KeyCode }): ()
		assert(actionById[action], `CornyMenu: unknown action "{action}"`)
		local texts: { string } = {}
		for _, key in keys do
			table.insert(texts, if type(key) == "string" then key else key.Name)
		end
		self:_setKeys(action, texts)
	end

	-- The keys of an action, as text
	function Menu.getKeys(self: Menu, action: string): { string }
		assert(actionById[action], `CornyMenu: unknown action "{action}"`)
		local list = self.settings.keys[action]
		return if list then table.clone(list) else {}
	end

	-- Puts one action's keys (or all of them, with no action) back to the defaults
	function Menu.resetKeys(self: Menu, action: string?): ()
		if action then
			local def = actionById[action]
			assert(def, `CornyMenu: unknown action "{action}"`)
			self:_setKeys(action, def.keys)
			return
		end
		self.settings.keys = defaultKeys()
		self:_applyKeys()
		self:_guardToggle()
		self:_saveSoon()
	end

	function Menu.notify(self: Menu, text: string, opts: NotifyOptions?): ()
		if self.destroyed or not self.settings.toasts then
			return
		end
		table.insert(self.toasts, {
			title = opts and opts.title,
			text = tostring(text),
			color = opts and opts.color,
			born = os.clock(),
			duration = (opts and opts.duration) or Config.TOAST_TIME,
			fade = if self.settings.animations then 0 else 1,
			closing = false,
		})
		while #self.toasts > Config.TOAST_MAX do
			table.remove(self.toasts, 1)
		end
		self:_markDirty()
	end

	-- A progress card. `owner` (page:task) removes it with that page; on a page that is
	-- already gone the card is returned but never shown.
	function Menu._task(self: Menu, title: string, opts: TaskOptions?, owner: Page?): Task
		local taskCard = newTask(self, title, opts)
		taskCard.owner = owner
		if owner and owner.destroyed then
			taskCard.removed = true
			return taskCard
		end
		table.insert(self.tasks, taskCard)
		self:_markDirty()
		return taskCard
	end

	function Menu.task(self: Menu, title: string, opts: TaskOptions?): Task
		return self:_task(title, opts, nil)
	end

	-- Shows or updates the key-hint panel `id`; whoever set it last owns it
	function Menu._setPrompt(self: Menu, id: string, spec: PromptSpec, owner: Page?): ()
		for _, entry in self.prompts do
			if entry.id == id then
				entry.spec = spec
				entry.owner = owner
				self:_markDirty()
				return
			end
		end
		table.insert(self.prompts, { id = id, spec = spec, owner = owner })
		self:_markDirty()
	end

	-- Hides the prompt `id`: any prompt for the menu (owner nil), only its own for a page
	function Menu._removePrompt(self: Menu, id: string, owner: Page?): ()
		for index, entry in self.prompts do
			if entry.id == id then
				if owner == nil or rawequal(entry.owner, owner) then
					table.remove(self.prompts, index)
					self:_markDirty()
				end
				return
			end
		end
	end

	-- Sets a watermark segment; nil text removes it (for a page, only one it set)
	function Menu._setStatus(
		self: Menu,
		id: string,
		text: string?,
		color: Color3?,
		owner: Page?
	): ()
		for index, entry in self.statuses do
			if entry.id == id then
				if text then
					entry.text = text
					entry.color = color
					entry.owner = owner
				elseif owner == nil or rawequal(entry.owner, owner) then
					table.remove(self.statuses, index)
				end
				self:_markDirty()
				return
			end
		end
		if text then
			table.insert(self.statuses, { id = id, text = text, color = color, owner = owner })
			self:_markDirty()
		end
	end

	-- Shows (or replaces) the key-hint panel `id`. Call again to update it.
	function Menu.prompt(self: Menu, id: string, spec: PromptSpec): ()
		local shown: PromptSpec? = spec -- nil from a non-strict script hides it
		if shown == nil then
			self:hidePrompt(id)
			return
		end
		self:_setPrompt(id, shown, nil)
	end

	function Menu.hidePrompt(self: Menu, id: string): ()
		self:_removePrompt(id, nil)
	end

	-- Sets (or removes, with nil) a segment of the watermark
	function Menu.status(self: Menu, id: string, text: string?, color: Color3?): ()
		self:_setStatus(id, text, color, nil)
	end

	-- Runs `fn` on the menu's frame loop, a connection made while loading, with
	-- executor identity. For GUI Instance work from threads that may have lost it.
	function Menu.defer(self: Menu, fn: () -> ()): ()
		table.insert(self.deferred, fn)
	end

	-- Unload. Page cleanups run right away, on the caller's thread like any script code,
	-- and drawing stops at once. The GUI teardown and the frame loop's own disconnect run
	-- on the frame loop, which has executor identity whichever thread called this.
	function Menu.Destroy(self: Menu): ()
		if self.destroyed then
			return
		end
		self:close()
		self.destroyed = true -- first: a cleanup must not add pages to a dying menu
		self.root:Destroy()
		self:_flushSave()
		self.renderer.destroy()
		self.measure:Destroy()
		table.clear(self.layers)
		local genv = getgenv()
		local shared = genv[Config.GENV_KEY]
		if type(shared) == "table" and rawequal(shared.menu, self) then
			genv[Config.GENV_KEY] = nil
		end
		local janitor = self.janitor
		self:defer(function()
			janitor:destroy()
		end)
	end

	-- ============ Construction ============
	local function newMenu(options: MenuOptions?): Menu
		-- the loader's download yields, and a thread that yielded can lose executor
		-- identity (LEARNINGS.md, thread identity); the GUI layer below lives in gethui
		setIdentity()
		local settings, hadSave = Store.load()
		local self = setmetatable({} :: MenuFields, Menu)
		self.title = (options and options.title) or "Corny"
		self.subtitle = (options and options.subtitle) or ""
		self.settings = settings
		self.janitor = newJanitor()
		self.canvas = newCanvas()
		self.measure = newTextMeasure()
		self.renderer = pickRenderer()
		self.pages = {}
		self.stack = {}
		self.opened = false
		self.openFade = 0
		self.pageFade = 1
		self.pageDirection = 1
		self.scrollerY = 0
		self.scrollerHeight = 0
		self.scrollerTarget = 0
		self.scrollerTargetHeight = 0
		self.snapScroller = true
		self.columnTop = 0
		self.columnTarget = 0
		self.snapColumn = true
		self.dirty = true
		self.animating = false
		self.frameDt = 0
		self.fillsMoving = true
		self.dragX = 0
		self.dragWidth = 1
		self.rows = {}
		self.regions = {}
		self.regionCount = 0
		self.shields = {}
		self.shieldCount = 0
		self.layers = {}
		self.drawTarget = { originX = 0, originY = 0, clip = nil }
		self.draw = newDraw(self)
		self.highlightOwner = nil
		self.highlightKey = nil
		self.editCounter = 0
		self.focusId = 0
		self.capturedAt = 0
		self.frame = 0
		self.navFrame = -1
		self.deferred = {}
		self.toasts = {}
		self.tasks = {}
		self.prompts = {}
		self.statuses = {}
		self.viewport = Vector2.zero
		self.viewportDirty = true
		self.windowFocused = true
		local focusKnown, active = pcall(function(): boolean
			return iswindowactive()
		end)
		if focusKnown and type(active) == "boolean" then
			self.windowFocused = active -- a script may start while the game is in the background
		end
		self.inset = Config.INSET_FALLBACK
		self.now = os.clock()
		self.wakeAt = math.huge
		self.bound = false
		self.bindings = {}
		self.keyLookup = {}
		self.saveQueued = false
		self.warned = {}
		self.destroyed = false
		self:_applySettings()
		self.gui = newGuiBridge(self)
		self.root = newPage(self, "Main Menu", nil)
		self.stack = { self.root }
		self:_buildRoot()
		self:_buildSettings()
		self:_readViewport()

		-- Connections made here, while the script loads, keep executor identity. The
		-- frame loop stays connected for that reason; when nothing changes it only
		-- runs a few comparisons.
		self.janitor:give(RunService.RenderStepped:Connect(function(dt: number)
			local ok, err = try(self._step, self, dt)
			if not ok then
				self:_warnOnce(`frame failed: {err}`, "frame")
			end
		end))
		self:_watchCamera()
		self.janitor:give(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			self:_watchCamera()
		end))
		self.janitor:give(function()
			local connection = self.cameraConnection
			if connection then
				connection:Disconnect()
			end
		end)
		self.janitor:give(
			UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
				self:_onInputBegan(input, gameProcessed)
			end)
		)
		self.janitor:give(UserInputService.InputChanged:Connect(function(input: InputObject)
			self:_onInputChanged(input)
		end))
		self.janitor:give(UserInputService.InputEnded:Connect(function(input: InputObject)
			self:_onInputEnded(input)
		end))
		self.janitor:give(UserInputService.WindowFocused:Connect(function()
			self.windowFocused = true
		end))
		self.janitor:give(UserInputService.WindowFocusReleased:Connect(function()
			self.windowFocused = false
		end))
		self.janitor:give(function()
			self:_bindNavigation(false)
			self:_endCapture()
		end)

		local key = self:_actionLabel("toggle")
		local how = if key then `{key} opens the menu` else "click the watermark to open it"
		print(`[CornyMenu] v{VERSION} loaded ({self.renderer.name} renderer) - {how}`)
		if not hadSave then
			local text = if key
				then `Press {key} to open the menu.`
				else "Click the watermark to open the menu."
			self:notify(text, { title = self.title })
		end
		return self
	end

	-- The shared menu: reused when a live menu of this version (or newer) exists,
	-- so every script adds its page to the same menu.
	local function getMenu(options: MenuOptions?): Menu
		local genv = getgenv()
		local shared = genv[Config.GENV_KEY]
		if type(shared) == "table" then
			local existing = shared.menu
			if
				type(shared.version) == "number"
				and shared.version >= VERSION
				and existing
				and not existing.destroyed
			then
				return existing
			end
			if existing and not existing.destroyed then
				warn(
					"[CornyMenu] Replacing an older menu - re-run other scripts to add their pages"
				)
				local ok, err = try(function()
					existing:Destroy()
				end)
				if not ok then
					warn(`[CornyMenu] could not unload the older menu (two may draw): {err}`)
				end
			end
		end
		local menu = newMenu(options)
		-- a new table for every new menu: loader blocks already shipped inside scripts keep
		-- a download only when this entry changed during its get, so keep it this way
		genv[Config.GENV_KEY] = { version = VERSION, menu = menu }
		return menu
	end

	return table.freeze({
		VERSION = VERSION,
		get = getMenu,
		newJanitor = newJanitor,
		palette = Palette,
		actions = Config.ACTIONS,
	})
end)()

-- The classes are metatables, which the checker cannot match against the structural
-- types above (their fields are invariant), so the module is cast to CornyMenuModule;
-- lib/tools/cornymenu_test.luau checks at run time that every method those types
-- name exists, and that every public method is in them.
return (CornyMenu :: any) :: CornyMenuModule
