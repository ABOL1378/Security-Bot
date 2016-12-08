local function run(msg, matches)
 local data = load_data(_config.moderation.data)
 local lock_link = data[tostring(msg.to.id)]['settings']['lock_link']
 
 if matches[1]:lower() == "+" and matches[2] == "link" and is_momod(msg) then
  data[tostring(msg.to.id)]['settings']['lock_link'] = 'yes'
  save_data(_config.moderation.data, data)
  return 'Ø§Ø±Ø³Ø§Ù„ Ù„ÛŒÙ†Ú© ØºÛŒØ± Ù…Ø¬Ø§Ø²'
 elseif matches[1]:lower() == "-" and matches[2] == "link" and is_momod(msg) then
  data[tostring(msg.to.id)]['settings']['lock_link'] = 'no'
  save_data(_config.moderation.data, data)
  return 'Ø§Ø±Ø³Ø§Ù„ Ù„ÛŒÙ†Ú© Ù…Ø¬Ø§Ø²'
 end
 
 if not lock_link then
  data[tostring(msg.to.id)]['settings']['lock_link'] = 'yes'
  save_data(_config.moderation.data, data)
  if not is_chat_msg(msg) then
   return nil
  end
  if is_sudo(msg) then
   return nil
  elseif is_admin(msg) then
   return nil
  elseif is_momod(msg) then
   return nil
  else
   send_large_msg('chat#id'..msg.to.id, "ØªØ¨Ù„ÛŒØº Ù…Ù…Ù†ÙˆØ¹")
   chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
  end
 elseif lock_link == 'yes' then
  if not is_chat_msg(msg) then
   return nil
  end
  if is_sudo(msg) then
   return nil
  elseif is_admin(msg) then
   return nil
  elseif is_momod(msg) then
   return nil
  else
   send_large_msg('chat#id'..msg.to.id, "ØªØ¨Ù„ÛŒØº Ù…Ù…Ù†ÙˆØ¹")
   chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
  end
 end
end

return {
 description = "Anti Link",
 --usagehtm = '<tr><td align="center">(Anti Link)</td><td align="right">Ø§ÛŒÙ† Ø§ÙØ²ÙˆÙ†Ù‡ Ø¬Ù‡Øª Ú©ÛŒÚ© Ú©Ø±Ø¯Ù† Ø§ÙØ±Ø§Ø¯ÛŒ Ø§Ø³Øª Ú©Ù‡ Ø¯Ø± Ú¯Ø±ÙˆÙ‡ ØªØ¨Ù„ÛŒØº Ù…ÛŒÚ©Ù†Ù†Ø¯. Ø­Ø³Ø§Ø³ÛŒØª Ø§ÛŒÙ† Ø§ÙØ²ÙˆÙ†Ù‡ ÙÙ‚Ø· Ø¨Ù‡ Ù„ÛŒÙ†Ú© Ú¯Ø±ÙˆÙ‡ Ù‡Ø§ Ùˆ Ú©Ø§Ù†Ø§Ù„Ù‡Ø§ Ù…ÛŒØ¨Ø§Ø´Ø¯. Ù…Ø¯ÛŒØ±Ø§Ù† Ú¯Ø±ÙˆÙ‡ Ù…Ø¬Ø§Ø² Ø¨Ù‡ Ø§Ø±Ø³Ø§Ù„ Ù‡Ø±Ú¯ÙˆÙ†Ù‡ Ù„ÛŒÙ†Ú© Ù…ÛŒØ¨Ø§Ø´Ù†Ø¯</td></tr>',
 patterns = {
  "[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]",
  "^[Gg]p (+) (link)$",
  "^[Gg]p (-) (link)$",
 },
 run = run,
}
