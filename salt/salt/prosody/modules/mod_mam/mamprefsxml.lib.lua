-- XEP-0313: Message Archive Management for Prosody
-- Copyright (C) 2011-2013 Kim Alvefur
--
-- This file is MIT/X11 licensed.

local st = require"util.stanza";
local xmlns_mam = "urn:xmpp:mam:0";

local global_default_policy = module:get_option("default_archive_policy", false);

local default_attrs = {
	always = true, [true] = "always",
	never = false, [false] = "never",
	roster = "roster",
}

local function tostanza(prefs)
	local default = prefs[false];
	default = default ~= nil and default_attrs[default] or global_default_policy;
	local prefstanza = st.stanza("prefs", { xmlns = xmlns_mam, default = default });
	local always = st.stanza("always");
	local never = st.stanza("never");
	for jid, choice in pairs(prefs) do
		if jid then
			(choice and always or never):tag("jid"):text(jid):up();
		end
	end
	prefstanza:add_child(always):add_child(never);
	return prefstanza;
end
local function fromstanza(prefstanza)
	local prefs = {};
	local default = prefstanza.attr.default;
	if default then
		prefs[false] = default_attrs[default];
	end

	local always = prefstanza:get_child("always");
	if always then
		for rule in always:childtags("jid") do
			local jid = rule:get_text();
			prefs[jid] = true;
		end
	end

	local never = prefstanza:get_child("never");
	if never then
		for rule in never:childtags("jid") do
			local jid = rule:get_text();
			prefs[jid] = false;
		end
	end

	return prefs;
end

return {
	tostanza = tostanza;
	fromstanza = fromstanza;
}
