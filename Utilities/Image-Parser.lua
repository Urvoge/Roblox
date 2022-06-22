-- Idk who created, credits to them <3

local PNG = {}
PNG.__index = PNG

local chunks = {};
local function IDAT(file, chunk)
	local crc = chunk.CRC
	local hash = file.Hash or 0
	
	local data = chunk.Data
	local buffer = data.Buffer
	
	file.Hash = bit32.bxor(hash, crc)
	file.ZlibStream = file.ZlibStream .. buffer
end

chunks['IDAT'] = IDAT;

local function IEND(file)
	file.Reading = nil
end
chunks['IEND'] = IEND;

local function IHDR(file, chunk)
	local data = chunk.Data
	
	file.Width = data:ReadInt32();
	file.Height = data:ReadInt32();
	
	file.BitDepth = data:ReadByte();
	file.ColorType = data:ReadByte();
	
	file.Methods =
	{
		Compression = data:ReadByte();
		Filtering   = data:ReadByte();
		Interlace   = data:ReadByte();
	}
end


chunks['IHDR'] = IHDR;

local function PLTE(file, chunk)
	if not file.Palette then
		file.Palette = {}
	end
	
	local data = chunk.Data
	local palette = data:ReadAllBytes()
	
	if #palette % 3 ~= 0 then
		error("[ERROR]: Invalid PLTE chunk.")
	end
	
	for i = 1, #palette, 3 do
		local r = palette[i]
		local g = palette[i + 1]
		local b = palette[i + 2]
		
		local color = Color3.fromRGB(r, g, b)
		local index = #file.Palette + 1
		
		file.Palette[index] = color
	end
end


chunks['PLTE'] = PLTE;

local function bKGD(file, chunk)
	local data = chunk.Data
	
	local bitDepth = file.BitDepth
	local colorType = file.ColorType
	
	bitDepth = (2 ^ bitDepth) - 1
	
	if colorType == 3 then
		local index = data:ReadByte()
		file.BackgroundColor = file.Palette[index]
	elseif colorType == 0 or colorType == 4 then
		local gray = data:ReadUInt16() / bitDepth
		file.BackgroundColor = Color3.fromHSV(0, 0, gray)
	elseif colorType == 2 or colorType == 6 then
		local r = data:ReadUInt16() / bitDepth
		local g = data:ReadUInt16() / bitDepth
		local b = data:ReadUInt16() / bitDepth
		file.BackgroundColor = Color3.new(r, g, b)
	end
end

chunks['bKGD'] = bKGD;

local colors = {"White", "Red", "Green", "Blue"}

local function cHRM(file, chunk)
	local chrome = {}
	local data = chunk.Data
	
	for i = 1, 4 do
		local color = colors[i]
		
		chrome[color] =
		{
			[1] = data:ReadUInt32() / 10e4;
			[2] = data:ReadUInt32() / 10e4;
		}
	end
	
	file.Chromaticity = chrome
end

chunks['cHRM'] = cHRM;

local function gAMA(file, chunk)
	local data = chunk.Data
	local value = data:ReadUInt32()
	file.Gamma = value / 10e4
end

chunks['gAMA'] = gAMA;

local function sRGB(file, chunk)
	local data = chunk.Data
	file.RenderIntent = data:ReadByte()
end

chunks['sRGB'] = sRGB;

local function tEXt(file, chunk)
	local data = chunk.Data
	local key, value = "", ""
	
	for byte in data:IterateBytes() do
		local char = string.char(byte)
		
		if char == '\0' then
			key = value
			value = ""
		else
			value = value .. char
		end
	end
	
	file.Metadata[key] = value
end

chunks['tEXt'] = tEXt;

local function tIME(file, chunk)
	local data = chunk.Data
	
	local timeStamp = 
	{
		Year  = data:ReadUInt16();
		Month = data:ReadByte();
		Day   = data:ReadByte();
		
		Hour   = data:ReadByte();
		Minute = data:ReadByte();
		Second = data:ReadByte();
	}
	
	file.TimeStamp = timeStamp
end

chunks['tIME'] = tIME;

local function tRNS(file, chunk)
	local data = chunk.Data
	
	local bitDepth = file.BitDepth
	local colorType = file.ColorType
	
	bitDepth = (2 ^ bitDepth) - 1
	
	if colorType == 3 then
		local palette = file.Palette
		local alphaMap = {}
		
		for i = 1, #palette do
			local alpha = data:ReadByte()
			
			if not alpha then
				alpha = 255
			end
			
			alphaMap[i] = alpha
		end
		
		file.AlphaData = alphaMap
	elseif colorType == 0 then
		local grayAlpha = data:ReadUInt16()
		file.Alpha = grayAlpha / bitDepth
	elseif colorType == 2 then
		-- TODO: This seems incorrect...
		local r = data:ReadUInt16() / bitDepth
		local g = data:ReadUInt16() / bitDepth
		local b = data:ReadUInt16() / bitDepth
		file.Alpha = Color3.new(r, g, b)
	else
		error("[ERROR]: Invalid tRNS chunk.")
	end	
end


chunks['tRNS'] = tRNS;

local Deflate = {}

local band = bit32.band
local lshift = bit32.lshift
local rshift = bit32.rshift

local BTYPE_NO_COMPRESSION = 0
local BTYPE_FIXED_HUFFMAN = 1
local BTYPE_DYNAMIC_HUFFMAN = 2

local lens = -- Size base for length codes 257..285
{
	[0] = 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31,
	35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258
}

local lext = -- Extra bits for length codes 257..285
{
	[0] = 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2,
	3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0
}

local dists = -- Offset base for distance codes 0..29
{
	[0] = 1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193,
	257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145,
	8193, 12289, 16385, 24577
}

local dext = -- Extra bits for distance codes 0..29
{
	[0] = 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6,
	7, 7, 8, 8, 9, 9, 10, 10, 11, 11,
	12, 12, 13, 13
}

local order = -- Permutation of code length codes
{
	16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 
	11, 4, 12, 3, 13, 2, 14, 1, 15
}

-- Fixed literal table for BTYPE_FIXED_HUFFMAN
local fixedLit = {0, 8, 144, 9, 256, 7, 280, 8, 288}

 -- Fixed distance table for BTYPE_FIXED_HUFFMAN
local fixedDist = {0, 5, 32}

local function createState(bitStream)
	local state = 
	{
		Output = bitStream;
		Window = {};
		Pos = 1;
	}
	
	return state
end

local function write(state, byte)
	local pos = state.Pos
	state.Output(byte)
	state.Window[pos] = byte
	state.Pos = pos % 32768 + 1  -- 32K
end

local function memoize(fn)
	local meta = {}
	local memoizer = setmetatable({}, meta)
	
	function meta:__index(k)
		local v = fn(k)
		memoizer[k] = v
		
		return v
	end
	
	return memoizer
end

-- small optimization (lookup table for powers of 2)
local pow2 = memoize(function (n) 
	return 2 ^ n 
end)

-- weak metatable marking objects as bitstream type
local isBitStream = setmetatable({}, { __mode = 'k' })

local function createBitStream(reader)
	local buffer = 0
	local bitsLeft = 0
	
	local stream = {}
	isBitStream[stream] = true
	
	function stream:GetBitsLeft()
		return bitsLeft
	end
	
	function stream:Read(count)
		count = count or 1
		
		while bitsLeft < count do
			local byte = reader:ReadByte()
			
			if not byte then 
				return 
			end
			
			buffer = buffer + lshift(byte, bitsLeft)
			bitsLeft = bitsLeft + 8
		end
		
		local bits
		
		if count == 0 then
			bits = 0
		elseif count == 32 then
			bits = buffer
			buffer = 0
		else
			bits = band(buffer, rshift(2^32 - 1, 32 - count))
			buffer = rshift(buffer, count)
		end
		
		bitsLeft = bitsLeft - count
		return bits
	end
	
	return stream
end

local function getBitStream(obj)
	if isBitStream[obj] then
		return obj
	end
	
	return createBitStream(obj)
end

local function sortHuffman(a, b)
	return a.NumBits == b.NumBits and a.Value < b.Value or a.NumBits < b.NumBits
end

local function msb(bits, numBits)
	local res = 0
		
	for i = 1, numBits do
		res = lshift(res, 1) + band(bits, 1)
		bits = rshift(bits, 1)
	end
		
	return res
end

local function createHuffmanTable(init, isFull)
	local hTable = {}
	
	if isFull then
		for val, numBits in pairs(init) do
			if numBits ~= 0 then
				hTable[#hTable + 1] = 
				{
					Value = val;
					NumBits = numBits;
				}
			end
		end
	else
		for i = 1, #init - 2, 2 do
			local firstVal = init[i]
			
			local numBits = init[i + 1]
			local nextVal = init[i + 2]
			
			if numBits ~= 0 then
				for val = firstVal, nextVal - 1 do
					hTable[#hTable + 1] = 
					{
						Value = val;
						NumBits = numBits;
					}
				end
			end
		end
	end
	
	table.sort(hTable, sortHuffman)
	
	local code = 1
	local numBits = 0
	
	for i, slide in ipairs(hTable) do
		if slide.NumBits ~= numBits then
			code = code * pow2[slide.NumBits - numBits]
			numBits = slide.NumBits
		end
		
		slide.Code = code
		code = code + 1
	end
	
	local minBits = math.huge
	local look = {}
	
	for i, slide in ipairs(hTable) do
		minBits = math.min(minBits, slide.NumBits)
		look[slide.Code] = slide.Value
	end

	local firstCode = memoize(function (bits) 
		return pow2[minBits] + msb(bits, minBits) 
	end)
	
	function hTable:Read(bitStream)
		local code = 1 -- leading 1 marker
		local numBits = 0
		
		while true do
			if numBits == 0 then  -- small optimization (optional)
				local index = bitStream:Read(minBits)
				numBits = numBits + minBits
				code = firstCode[index]
			else
				local bit = bitStream:Read()
				numBits = numBits + 1
				code = code * 2 + bit -- MSB first
			end
			
			local val = look[code]
			
			if val then
				return val
			end
		end
	end
	
	return hTable
end

local function parseZlibHeader(bitStream)
	-- Compression Method
	local cm = bitStream:Read(4)
	
	-- Compression info
	local cinfo = bitStream:Read(4)  
	
	-- FLaGs: FCHECK (check bits for CMF and FLG)   
	local fcheck = bitStream:Read(5)
	
	-- FLaGs: FDICT (present dictionary)
	local fdict = bitStream:Read(1)
	
	-- FLaGs: FLEVEL (compression level)
	local flevel = bitStream:Read(2)
	
	-- CMF (Compresion Method and flags)
	local cmf = cinfo * 16  + cm
	
	-- FLaGs
	local flg = fcheck + fdict * 32 + flevel * 64 
	
	if cm ~= 8 then -- not "deflate"
		error("[ERROR]: Unrecognized image Compression Method: " .. tostring(cm))
	end
	
	if cinfo > 7 then
		error("[ERROR]: Invalid image Window Size: cinfo -> " .. tostring(cinfo))
	end
	
	local windowSize = 2 ^ (cinfo + 8)
	
	if (cmf * 256 + flg) % 31 ~= 0 then
		error("[ERROR]: Invalid image header (bad fcheck sum)")
	end
	
	if fdict == 1 then
		error("[TODO]: - FDICT not currently implemented")
	end
	
	return windowSize
end

local function parseHuffmanTables(bitStream)
	local numLits  = bitStream:Read(5) -- # of literal/length codes - 257
	local numDists = bitStream:Read(5) -- # of distance codes - 1
	local numCodes = bitStream:Read(4) -- # of code length codes - 4
	
	local codeLens = {}
	
	for i = 1, numCodes + 4 do
		local index = order[i]
		codeLens[index] = bitStream:Read(3)
	end
	
	codeLens = createHuffmanTable(codeLens, true)

	local function decode(numCodes)
		local init = {}
		local numBits
		local val = 0
		
		while val < numCodes do
			local codeLen = codeLens:Read(bitStream)
			local numRepeats
			
			if codeLen <= 15 then
				numRepeats = 1
				numBits = codeLen
			elseif codeLen == 16 then
				numRepeats = 3 + bitStream:Read(2)
			elseif codeLen == 17 then
				numRepeats = 3 + bitStream:Read(3)
				numBits = 0
			elseif codeLen == 18 then
				numRepeats = 11 + bitStream:Read(7)
				numBits = 0
			end
			
			for i = 1, numRepeats do
				init[val] = numBits
				val = val + 1
			end
		end
		
		return createHuffmanTable(init, true)
	end

	local numLitCodes = numLits + 257
	local numDistCodes = numDists + 1
	
	local litTable = decode(numLitCodes)
	local distTable = decode(numDistCodes)
	
	return litTable, distTable
end

local function parseCompressedItem(bitStream, state, litTable, distTable)
	local val = litTable:Read(bitStream)
	
	if val < 256 then -- literal
		write(state, val)
	elseif val == 256 then -- end of block
		return true
	else
		local lenBase = lens[val - 257]
		local numExtraBits = lext[val - 257]
		
		local extraBits = bitStream:Read(numExtraBits)
		local len = lenBase + extraBits
		
		local distVal = distTable:Read(bitStream)
		local distBase = dists[distVal]
		
		local distNumExtraBits = dext[distVal]
		local distExtraBits = bitStream:Read(distNumExtraBits)
		
		local dist = distBase + distExtraBits
		
		for i = 1, len do
			local pos = (state.Pos - 1 - dist) % 32768 + 1
			local byte = assert(state.Window[pos], "invalid distance")
			write(state, byte)
		end
	end
	
	return false
end

local function parseBlock(bitStream, state)
	local bFinal = bitStream:Read(1)
	local bType = bitStream:Read(2)
	
	if bType == BTYPE_NO_COMPRESSION then
		local left = bitStream:GetBitsLeft()
		bitStream:Read(left)
		
		local len = bitStream:Read(16)
		local nlen = bitStream:Read(16)

		for i = 1, len do
			local byte = bitStream:Read(8)
			write(state, byte)
		end
	elseif bType == BTYPE_FIXED_HUFFMAN or bType == BTYPE_DYNAMIC_HUFFMAN then
		local litTable, distTable

		if bType == BTYPE_DYNAMIC_HUFFMAN then
			litTable, distTable = parseHuffmanTables(bitStream)
		else
			litTable = createHuffmanTable(fixedLit)
			distTable = createHuffmanTable(fixedDist)
		end
		
		repeat until parseCompressedItem(bitStream, state, litTable, distTable)
	else
		error("[ERROR]: Unrecognized compression type.")
	end

	return bFinal ~= 0
end

function Deflate:Inflate(io)
	local state = createState(io.Output)
	local bitStream = getBitStream(io.Input)
	
	repeat until parseBlock(bitStream, state)
end

function Deflate:InflateZlib(io)
	local bitStream = getBitStream(io.Input)
	local windowSize = parseZlibHeader(bitStream)
	
	self:Inflate
	{
		Input = bitStream;
		Output = io.Output;
	}
	
	local bitsLeft = bitStream:GetBitsLeft()
	bitStream:Read(bitsLeft)
end

local Unfilter = {}

function Unfilter:None(scanline, pixels, bpp, row)
	for i = 1, #scanline do
		pixels[row][i] = scanline[i]
	end
end

function Unfilter:Sub(scanline, pixels, bpp, row)
	for i = 1, bpp do
		pixels[row][i] = scanline[i]
	end
	
	for i = bpp + 1, #scanline do
		local x = scanline[i]
		local a = pixels[row][i - bpp]
		pixels[row][i] = bit32.band(x + a, 0xFF)
	end
end

function Unfilter:Up(scanline, pixels, bpp, row)
	if row > 1 then
		local upperRow = pixels[row - 1]
		
		for i = 1, #scanline do
			local x = scanline[i]
			local b = upperRow[i]
			pixels[row][i] = bit32.band(x + b, 0xFF)
		end
	else
		self:None(scanline, pixels, bpp, row)
	end
end

function Unfilter:Average(scanline, pixels, bpp, row)
	if row > 1 then
		for i = 1, bpp do
			local x = scanline[i]
			local b = pixels[row - 1][i]
			
			b = bit32.rshift(b, 1)
			pixels[row][i] = bit32.band(x + b, 0xFF)
		end
		
		for i = bpp + 1, #scanline do
			local x = scanline[i]
			local b = pixels[row - 1][i]
			
			local a = pixels[row][i - bpp]
			local ab = bit32.rshift(a + b, 1)
			
			pixels[row][i] = bit32.band(x + ab, 0xFF)
		end
	else
		for i = 1, bpp do
			pixels[row][i] = scanline[i]
		end
	
		for i = bpp + 1, #scanline do
			local x = scanline[i]
			local b = pixels[row - 1][i]
			
			b = bit32.rshift(b, 1)
			pixels[row][i] = bit32.band(x + b, 0xFF)
		end
	end
end

function Unfilter:Paeth(scanline, pixels, bpp, row)
	if row > 1 then
		local pr
		
		for i = 1, bpp do
			local x = scanline[i]
			local b = pixels[row - 1][i]
			pixels[row][i] = bit32.band(x + b, 0xFF)
		end
		
		for i = bpp + 1, #scanline do
			local a = pixels[row][i - bpp]
			local b = pixels[row - 1][i]
			local c = pixels[row - 1][i - bpp]
			
			local x = scanline[i]
			local p = a + b - c
			
			local pa = math.abs(p - a)
			local pb = math.abs(p - b)
			local pc = math.abs(p - c)
			
			if pa <= pb and pa <= pc then
				pr = a
			elseif pb <= pc then
				pr = b
			else
				pr = c
			end
			
			pixels[row][i] = bit32.band(x + pr, 0xFF)
		end
	else
		self:Sub(scanline, pixels, bpp, row)
	end
end


local BinaryReader = {}
BinaryReader.__index = BinaryReader

function BinaryReader.new(buffer)
	local reader = 
	{
		Position = 1;
		Buffer = buffer;
		Length = #buffer;
	}
	
	return setmetatable(reader, BinaryReader)
end

function BinaryReader:ReadByte()
	local buffer = self.Buffer
	local pos = self.Position
	
	if pos <= self.Length then
		local result = buffer:sub(pos, pos)
		self.Position = pos + 1
		
		return result:byte()
	end
end

function BinaryReader:ReadBytes(count, asArray)
	local values = {}
	
	for i = 1, count do
		values[i] = self:ReadByte()
	end
	
	if asArray then
		return values
	end
	
	return unpack(values)
end

function BinaryReader:ReadAllBytes()
	return self:ReadBytes(self.Length, true)
end

function BinaryReader:IterateBytes()
	return function ()
		return self:ReadByte()
	end
end

function BinaryReader:TwosComplementOf(value, numBits)
	if value >= (2 ^ (numBits - 1)) then
		value = value - (2 ^ numBits)
	end
	
	return value
end

function BinaryReader:ReadUInt16()
	local upper, lower = self:ReadBytes(2)
	return (upper * 256) + lower
end

function BinaryReader:ReadInt16()
	local unsigned = self:ReadUInt16()
	return self:TwosComplementOf(unsigned, 16)
end

function BinaryReader:ReadUInt32()
	local upper = self:ReadUInt16()
	local lower = self:ReadUInt16()
	
	return (upper * 65536) + lower
end

function BinaryReader:ReadInt32()
	local unsigned = self:ReadUInt32()
	return self:TwosComplementOf(unsigned, 32)
end

function BinaryReader:ReadString(length)
    if length == nil then
        length = self:ReadByte()
    end
    
    local pos = self.Position
    local nextPos = math.min(self.Length, pos + length)
    
    local result = self.Buffer:sub(pos, nextPos - 1)
    self.Position = nextPos
    
    return result
end

function BinaryReader:ForkReader(length)
	local chunk = self:ReadString(length)
	return BinaryReader.new(chunk)
end


local function getBytesPerPixel(colorType)
	if colorType == 0 or colorType == 3 then
		return 1
	elseif colorType == 4 then
		return 2
	elseif colorType == 2 then
		return 3
	elseif colorType == 6 then
		return 4
	else
		return 0
	end
end

local function clampInt(value, min, max)
	local num = tonumber(value) or 0
	num = math.floor(num + .5)
	
	return math.clamp(num, min, max)
end

local function indexBitmap(file, x, y)
	local width = file.Width
	local height = file.Height
	
	local x = clampInt(x, 1, width) 
	local y = clampInt(y, 1, height)
	
	local bitmap = file.Bitmap
	local bpp = file.BytesPerPixel
	
	local i0 = ((x - 1) * bpp) + 1
	local i1 = i0 + bpp
	
	return bitmap[y], i0, i1
end

function PNG:GetPixel(t,x, y)
	local row, i0, i1 = indexBitmap(t, x, y)
	local colorType = t.ColorType
	self = t;
	
	local color, alpha do
		if colorType == 0 then
			local gray = unpack(row, i0, i1)
			color = Color3.fromHSV(0, 0, gray)
			alpha = 255
		elseif colorType == 2 then
			local r, g, b = unpack(row, i0, i1)
			color = Color3.fromRGB(r, g, b)
			alpha = 255
		elseif colorType == 3 then
			local palette = self.Palette
			local alphaData = self.AlphaData
			
			local index = unpack(row, i0, i1)
			index = index + 1
			
			if palette then
				color = palette[index]
			end
			
			if alphaData then
				alpha = alphaData[index]
			end
		elseif colorType == 4 then
			local gray, a = unpack(row, i0, i1)
			color = Color3.fromHSV(0, 0, gray)
			alpha = a
		elseif colorType == 6 then
			local r, g, b, a = unpack(row, i0, i1)
			color = Color3.fromRGB(r, g, b, a)
			alpha = a
		end
	end
	
	if not color then
		color = Color3.new()
	end
	
	if not alpha then
		alpha = 255
	end
	
	return color, alpha
end

function PNG.new(buffer)
	-- Create the reader.
	local reader = BinaryReader.new(buffer)
	
	-- Create the file object.
	local file =
	{
		Chunks = {};
		Metadata = {};
		
		Reading = true;
		ZlibStream = "";
	}
	
	-- Verify the file header.
	local header = reader:ReadString(8)
	
	if header ~= "\137PNG\r\n\26\n" then
		error("[ERROR]: Input data is not a PNG file.")
	end
	
	while file.Reading do
		local length = reader:ReadInt32()
		local chunkType = reader:ReadString(4)
		
		local data, crc
		
		if length > 0 then
			data = reader:ForkReader(length)
			crc = reader:ReadUInt32()
		end
		
		local chunk = 
		{
			Length = length;
			Type = chunkType;
			
			Data = data;
			CRC = crc;
		}
		
		local handler = chunks[chunkType];
		
		if handler then
			handler(file, chunk)
		end
		
		table.insert(file.Chunks, chunk)
	end
	
	-- Decompress the zlib stream.
	local success, response = pcall(function ()
		local result = {}
		local index = 0
		
		Deflate:InflateZlib
		{
			Input = BinaryReader.new(file.ZlibStream);
			
			Output = function (byte)
				index = index + 1
				result[index] = string.char(byte)
			end
		}
		
		return table.concat(result)
	end)
	
	if not success then
		error("[ERROR]: Unable to unpack PNG data. Response: " .. tostring(response))
	end
	
	-- Grab expected info from the file.
	
	local width = file.Width
	local height = file.Height
	
	local bitDepth = file.BitDepth
	local colorType = file.ColorType
	
	local buffer = BinaryReader.new(response)
	file.ZlibStream = nil
	
	local bitmap = {}
	file.Bitmap = bitmap
	
	local channels = getBytesPerPixel(colorType)
	file.NumChannels = channels
	
	local bpp = math.max(1, channels * (bitDepth / 8))
	file.BytesPerPixel = bpp
	
	-- Unfilter the buffer and 
	-- load it into the bitmap.
	
	for row = 1, height do	
		local filterType = buffer:ReadByte()
		local scanline = buffer:ReadBytes(width * bpp, true)
		
		bitmap[row] = {}
		
		if filterType == 0 then
			-- None
			Unfilter:None(scanline, bitmap, bpp, row)
		elseif filterType == 1 then
			-- Sub
			Unfilter:Sub(scanline, bitmap, bpp, row)
		elseif filterType == 2 then
			-- Up
			Unfilter:Up(scanline, bitmap, bpp, row)
		elseif filterType == 3 then
			-- Average
			Unfilter:Average(scanline, bitmap, bpp, row)
		elseif filterType == 4 then
			-- Paeth
			Unfilter:Paeth(scanline, bitmap, bpp, row)
		end
	end

	function file:GetPixel(X, Y)
		return PNG:GetPixel(file, X, Y)
	end
	
	return setmetatable(file, PNG)
end

return PNG
