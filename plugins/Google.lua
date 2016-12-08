local function googlethat(query)
  local api = "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&"
  local parameters = "q=".. (URL.escape(query) or "")
  local res, code = https.request(api..parameters)
  if code ~=200 then return nil  end
  local data = json:decode(res)
  local results = {}
  for key,result in ipairs(data.responseData.results) do
    table.insert(results, {
        result.titleNoFormatting,
        result.unescapedUrl or result.url
      })
  end
  return results
end

local function stringlinks(results)
  local stringresults="Ù†ØªØ§ÙŠØ¬ Ø¬Ø³ØªØ¬ÙˆÙŠ Ú¯ÙˆÚ¯Ù„:\n______________________________\n"
  for key,val in ipairs(results) do
    stringresults=stringresults..val[1].." - "..val[2].."\n"
  end
  return stringresults
end

local function run(msg, matches)
  local results = googlethat(matches[1])
  return stringlinks(results)
end

return {
  description = "Searche in Google",
  usagehtm = '<tr><td align="center">src Ù…ÙˆØ±Ø¯</td><td align="right">Ø¬Ø³Øª Ùˆ Ø¬ÙˆÛŒ ÛŒÚ© Ù„ØºØª ÛŒØ§ Ø¬Ù…Ù„Ù‡ Ø¯Ø± Ú¯ÙˆÚ¯Ù„ Ùˆ Ø¯Ø±ÛŒØ§ÙØª Ù„ÛŒÙ†Ú© 3Ø¬Ø³ØªØ¬ÙˆÛŒ Ø¨Ø±ØªØ±</td></tr>',
  usage = "src (item) : Ø¬Ø³ØªØ¬ÙˆÙŠ Ú¯ÙˆÚ¯Ù„",
  patterns = {
    "^[Ss]rc (.*)$",
    "^%.[s|S]rc (.*)$"
  },
  run = run
}
