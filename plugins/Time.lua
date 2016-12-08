local api_key  = nil
local base_api = "https://maps.googleapis.com/maps/api"
local dateFormat = "%A %d %B \nØ³Ø§Ø¹Øª: %H:%M:%S"

local function utctime()
	return os.time(os.date("!*t"))
end

function get_latlong(area)
	local api = base_api.."/geocode/json?"
	local parameters = "address="..(URL.escape(area) or "")
	if api_key ~= nil then
		parameters = parameters.."&key="..api_key
	end
	local res, code = https.request(api..parameters)
	if code ~=200 then return nil  end
		local data = json:decode(res) 
	if (data.status == "ZERO_RESULTS") then
		return nil
	end
	if (data.status == "OK") then
		lat  = data.results[1].geometry.location.lat
		lng  = data.results[1].geometry.location.lng
		acc  = data.results[1].geometry.location_type
		types= data.results[1].types
	return lat,lng,acc,types
	end
end

local function get_time(lat,lng)
	local api  = base_api .. "/timezone/json?"
	local timestamp = utctime()
	local parameters = "location=" ..
		URL.escape(lat) .. "," ..
		URL.escape(lng) .. 
		"&timestamp="..URL.escape(timestamp)
	if api_key ~=nil then
		parameters = parameters .. "&key="..api_key
	end
	local res,code = https.request(api..parameters)
	if code ~= 200 then return nil end
		local data = json:decode(res)
	if (data.status == "ZERO_RESULTS") then
		return nil
	end
	if (data.status == "OK") then
		local localTime = timestamp + data.rawOffset + data.dstOffset
		return localTime, data.timeZoneId
	end
	return localTime
end

local function getformattedLocalTime(area)
	if area == nil then
		return "Ø¯Ø± Ø§ÙŠÙ† Ù…Ù†Ø·Ù‚Ù‡ Ø²Ù…Ø§Ù† ÙˆØ¬ÙˆØ¯ Ù†Ø¯Ø§Ø±Ø¯"
	end
	lat,lng,acc = get_latlong(area)
	if lat == nil and lng == nil then
		return 'Ø¯Ø± Ø§ÙŠÙ† Ù…Ù†Ø·Ù‚Ù‡ Ø²Ù…Ø§Ù† ÙˆØ¬ÙˆØ¯ Ù†Ø¯Ø§Ø±Ø¯'
	end
	local localTime, timeZoneId = get_time(lat,lng)
	return "Ù…Ù†Ø·Ù‚Ù‡: "..timeZoneId.."\nØªØ§Ø±ÙŠØ®: ".. os.date(dateFormat,localTime) 
end

local function run(msg, matches)
	return getformattedLocalTime(matches[1])
end

return {
	description = "Get Time Give by Local Name", 
	usagehtm = '<tr><td align="center">time Ù†Ø§Ù… Ø´Ù‡Ø± ÛŒØ§ Ú©Ø´ÙˆØ±</td><td align="right">Ø¨Ø§ Ø§ÛŒÙ† Ù‚Ø§Ø¨Ù„ÛŒØª Ù…ÛŒØªÙˆØ§Ù†ÛŒØ¯ ØªØ§Ø±ÛŒØ® Ùˆ Ø³Ø§Ø¹Øª Ù¾Ø§ÛŒØªØ®Øª Ù‡Ø± Ú©Ø´ÙˆØ± Ø±Ø§ Ø¨ÛŒØ§Ø¨ÛŒØ¯. Ø¯Ù‚Øª Ú©Ù†ÛŒØ¯ Ú©Ù‡ Ø§Ú¯Ø± Ù†Ø§Ù… Ú©Ø´ÙˆØ± ÙˆØ§Ø±Ø¯ Ø´ÙˆØ¯ØŒ Ø±Ø¨Ø§Øª Ø¨Ù‡ ØµÙˆØ±Øª Ù‡ÙˆØ´Ù…Ù†Ø¯ Ù¾Ø§ÛŒØªØ®Øª Ø¢Ù† Ø±Ø§ ÛŒØ§ÙØªÙ‡ Ùˆ Ø§Ø±Ø§Ø¦Ù‡ Ù…ÛŒÚ©Ù†Ø¯ Ùˆ Ø§Ú¯Ø± Ø´Ù‡Ø± Ø¯ÛŒÚ¯Ø± Ø§Ø² ÛŒÚ© Ú©Ø´ÙˆØ± Ø±Ø§ Ù†ÛŒØ² ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯ Ø¨Ù‡ Ù‡Ù…ÛŒÙ† ØªØ±ØªÛŒØ¨ Ø§Ø³Øª. Ù…Ø«Ù„Ø§ Ø§Ú¯Ø± ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯ <br>time shiraz<br> Ø±Ø¨Ø§Øª ØªØ´Ø®ÛŒØµ Ù…ÛŒØ¯Ù‡Ø¯ Ú©Ù‡ Ø´ÛŒØ±Ø§Ø² Ø¯Ø± Ø§ÛŒØ±Ø§Ù† Ø§Ø³Øª Ùˆ Ø¨Ø¹Ø¯ Ø²Ù…Ø§Ù† Ù¾Ø§ÛŒØªØ®Øª Ø§ÛŒØ±Ø§Ù† Ø±Ø§ Ø¯Ø± Ø§Ø®ØªÛŒØ§Ø±ØªØ§Ù† Ù‚Ø±Ø§Ø± Ù…ÛŒØ¯Ù‡Ø¯. Ù†Ø§Ù… Ú©Ø´ÙˆØ± ÛŒØ§ Ø´Ù‡Ø± Ø±Ø§ Ø¨Ù‡ Ø²Ø¨Ø§Ù† ÙØ§Ø±Ø³ÛŒ Ùˆ Ø§Ù†Ú¯Ù„ÛŒØ³ÛŒ Ù…ÛŒØªÙˆØ§Ù†ÛŒØ¯ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯</td></tr>',
	usage = "time (country) : Ø³Ø§Ø¹Øª Ú©Ø´ÙˆØ±Ù‡Ø§",
	patterns = {"^[Tt]ime (.*)$"}, 
	run = run
}
