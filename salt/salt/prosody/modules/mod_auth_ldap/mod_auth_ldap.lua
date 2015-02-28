-- mod_auth_ldap

local new_sasl = require "util.sasl".new;
local lualdap = require "lualdap";
local function ldap_filter_escape(s) return (s:gsub("[*()\\%z]", function(c) return ("\\%02x"):format(c:byte()) end)); end

-- Config options
local ldap_server = module:get_option_string("ldap_server", "localhost");
local ldap_rootdn = module:get_option_string("ldap_rootdn", "");
local ldap_password = module:get_option_string("ldap_password", "");
local ldap_tls = module:get_option_boolean("ldap_tls");
local ldap_scope = module:get_option_string("ldap_scope", "onelevel");
local ldap_filter = module:get_option_string("ldap_filter", "(uid=$user)"):gsub("%%s", "$user", 1);
local ldap_base = assert(module:get_option_string("ldap_base"), "ldap_base is a required option for ldap");
local ldap_mode = module:get_option_string("ldap_mode", "bind");
local host = ldap_filter_escape(module:get_option_string("realm", module.host));

-- Initiate connection
local ld = assert(lualdap.open_simple(ldap_server, ldap_rootdn, ldap_password, ldap_tls));
module.unload = function() ld:close(); end

local function get_user(username)
	module:log("debug", "get_user(%q)", username);
	for dn, attr in ld:search({
		base = ldap_base;
		scope = ldap_scope;
		sizelimit = 1;
		filter = ldap_filter:gsub("%$(%a+)", {
			user = ldap_filter_escape(username);
			host = host;
		});
	}) do return dn, attr; end
end

local provider = {};

function provider.create_user(username, password)
	return nil, "Account creation not available with LDAP.";
end

function provider.user_exists(username)
	return not not get_user(username);
end

function provider.set_password(username, password)
	local dn, attr = get_user(username);
	if not dn then return nil, attr end
	if attr.userPassword == password then return true end
	return ld:modify(dn, { '=', userPassword = password })();
end

if ldap_mode == "getpasswd" then
	function provider.get_password(username)
		local dn, attr = get_user(username);
		if dn and attr then
			return attr.userPassword;
		end
	end

	function provider.test_password(username, password)
		return provider.get_password(username) == password;
	end

	function provider.get_sasl_handler()
		return new_sasl(module.host, {
			plain = function(sasl, username)
				local password = provider.get_password(username);
				if not password then return "", nil; end
				return password, true;
			end
		});
	end
elseif ldap_mode == "bind" then
	local function test_password(userdn, password)
		return not not lualdap.open_simple(ldap_server, userdn, password, ldap_tls);
	end

	function provider.test_password(username, password)
		local dn = get_user(username);
		if not dn then return end
		return test_password(dn, password)
	end

	function provider.get_sasl_handler()
		return new_sasl(module.host, {
			plain_test = function(sasl, username, password)
				return provider.test_password(username, password), true;
			end
		});
	end
else
	module:log("error", "Unsupported ldap_mode %s", tostring(ldap_mode));
end

module:provides("auth", provider);
