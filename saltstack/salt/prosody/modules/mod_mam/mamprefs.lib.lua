-- XEP-0313: Message Archive Management for Prosody
-- Copyright (C) 2011-2013 Kim Alvefur
--
-- This file is MIT/X11 licensed.

local global_default_policy = module:get_option("default_archive_policy", false);

do
	local prefs_format = {
		[false] = "roster",
		-- default ::= true | false | "roster"
		-- true = always, false = never, nil = global default
		["romeo@montague.net"] = true, -- always
		["montague@montague.net"] = false, -- newer
	};
end

local sessions = hosts[module.host].sessions;
local prefs = module:open_store("archive2_prefs");

local function get_prefs(user)
	local user_sessions = sessions[user];
	local user_prefs = user_sessions and user_sessions.archive_prefs
	if not user_prefs and user_sessions then
		user_prefs = prefs:get(user);
		user_sessions.archive_prefs = user_prefs;
	end
	return user_prefs or { [false] = global_default_policy };
end
local function set_prefs(user, user_prefs)
	local user_sessions = sessions[user];
	if user_sessions then
		user_sessions.archive_prefs = user_prefs;
	end
	return prefs:set(user, user_prefs);
end

return {
	get = get_prefs,
	set = set_prefs,
}
