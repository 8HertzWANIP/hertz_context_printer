local script_author = "8 Hertz WAN IP"
local script_version = "1.0"
local mod_name = "hertz_debug_printer"

out(mod_name.." script version V" ..script_version.. " - Made by " ..script_author);

------------------------------------------------------------------------------------------------------------------
-- Checks the given unit lists and lists every unit type with the amount of units of that type into a table.
-- Unused in current version but quite a nice function on its own, which makes it easy to check any army for any unit type amount.
------------------------------------------------------------------------------------------------------------------
local function hertz_force_unit_counter(unit_list)
	local unit_type_list = {}
	local output_table = {
		["unit_type_list"] = {};
	}
	out("-----[[ FORCE UNIT COUNTER ]]-----");
	for i = 1, unit_list:num_items() - 1 do
		local target_unit_key = unit_list:item_at(i):unit_key()
		if not table:contains(unit_type_list, target_unit_key) then
			table.insert(unit_type_list, target_unit_key);
		end
		if output_table[target_unit_key] == nil then
			output_table[target_unit_key] = 1;
		else
			output_table[target_unit_key] = output_table[target_unit_key] + 1;
		end
	end
	for j = 1, #unit_type_list do
		out("["..unit_type_list[j].."] count = " ..output_table[unit_type_list[j]]);
	end
	output_table["unit_type_list"] = unit_type_list
	out("[unit_type_list] = " ..table.concat(output_table["unit_type_list"], " | "));
	out("-----[[       RETURN       ]]-----");
	return output_table;
end

local print_mil_force_unit_info = true;

local function army_context_logger(mil_force)
	local i;
	if mil_force:unit_list():num_items() > 1 then
		out("^^^^^===== ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ =====^^^^^")
		out("-----===== ARMY CQI ["..mil_force:command_queue_index().."] UNIT LIST INFO =====-----")
		local unit_list = mil_force:unit_list()
		out("		is_null_interface is------------------------["..tostring(unit_list:item_at(1):is_null_interface()).."]")
		out("		has_force_commander is 	--------------------["..tostring(unit_list:item_at(1):has_force_commander()).."]")
		out("		has_unit_commander is 	--------------------["..tostring(unit_list:item_at(1):has_unit_commander()).."]")
		for j = 0, unit_list:num_items() - 1 do
			if not unit_list:item_at(j):is_null_interface() then
				out("		command_queue_index is 	--------------------["..tostring(unit_list:item_at(j):command_queue_index()).."]")
				out("		unit_key is 	----------------------------["..tostring(unit_list:item_at(j):unit_key()).."]")
				out("		unit_category is 	------------------------["..tostring(unit_list:item_at(j):unit_category()).."]")
				out("		unit_class is 	----------------------------["..tostring(unit_list:item_at(j):unit_class()).."]")
				out("		percentage_proportion_of_full_strength is 	["..tostring(unit_list:item_at(j):percentage_proportion_of_full_strength()).."]")
				out("		has_banner_ancillary is --------------------["..tostring(unit_list:item_at(j):has_banner_ancillary()).."]")
				out("		----------------------------------------------------------------")
			end;
		end;
	end;
end;

out("###### ADDING HERTZ HERTZ DEBUG PRINTER LISTENERS ######")

core:add_listener(
	mod_name.."_CheckPanel",
	"PanelOpenedCampaign",
	true,
	function(context)
		out(context.string);
	end,
	true
);


core:add_listener(
"_DEBUGCharacterSelected",
"CharacterSelected",
true,
function(context)

	if not context:character():is_null_interface() then
		cm:replenish_action_points(cm:char_lookup_str(context:character():command_queue_index()))
		out("-----===== CHARACTER ["..context:character():command_queue_index().."] INFO =====-----")
		out("is_null_interface is 	--------["..tostring(context:character():is_null_interface()).."]")
		out("has_garrison_residence is 	----["..tostring(context:character():has_garrison_residence()).."]")
		out("has_region is 	----------------["..tostring(context:character():has_region()).."]")
		if context:character():has_region() then
			out("	region name is ["..tostring(context:character():region():name()).."]")
		end;
		out("	region name is ["..tostring(context:character():region():province_name()).."]")
		out("has_military_force is 	--------["..tostring(context:character():has_military_force()).."]")
		out("in_settlement is 	------------["..tostring(context:character():in_settlement()).."]")
		out("in_port is --------------------["..tostring(context:character():in_port()).."]")
		out("character_type_key is 	--------["..tostring(context:character():character_type_key()).."]")
		out("character_subtype_key is 	----["..tostring(context:character():character_subtype_key()).."]")
		out("battles_fought is 	------------["..tostring(context:character():battles_fought()).."]")
		out("turns_at_sea is 	------------["..tostring(context:character():turns_at_sea()).."]")
		out("logical_position_x is 	--------["..tostring(context:character():logical_position_x()).."]")
		out("logical_position_y is 	--------["..tostring(context:character():logical_position_y()).."]")
		out("is_at_sea is 	----------------["..tostring(context:character():is_at_sea()).."]")

		if print_mil_force_unit_info and context:character():has_military_force() then
			army_context_logger(context:character():military_force())
		end
	end;
end,
true
);
core:add_listener(
"_DEBUG2SettlementSelected",
"SettlementSelected",
true,
function(context)
	out("region_name = ["..context:garrison_residence():region():name().."]")
	out("province_name = ["..context:garrison_residence():region():province_name().."]")
	out(" ");
	out("-----===== GARRISON RESIDENCE =====-----")
	out("is_null_interface  -------------["..tostring(context:garrison_residence():is_null_interface()).."]")
	out("command_queue_index is	--------["..tostring(context:garrison_residence():command_queue_index()).."]")
	out("has_army 	 	----------------["..tostring(context:garrison_residence():has_army()).."]")
	out("has_navy 	 	----------------["..tostring(context:garrison_residence():has_navy()).."]")
	out("unit_count is 	----------------["..tostring(context:garrison_residence():unit_count()).."]")

	if print_mil_force_unit_info and context:garrison_residence():has_army() then
		army_context_logger(context:garrison_residence():army())
	end
	local garrison_force = context:garrison_residence():army()
	out(" ");
	out("-----===== MILITARY_FORCE =====-----")
	out("is_null_interface is 			["..tostring(garrison_force:is_null_interface()).."]")
	if not garrison_force:is_null_interface() then
		out("		command_queue_index is 			["..tostring(garrison_force:command_queue_index()).."]")
		out("		has_general 	----------------["..tostring(garrison_force:has_general()).."]")
		out("		is_army 	--------------------["..tostring(garrison_force:is_army()).."]")
		out("		is_navy 	--------------------["..tostring(garrison_force:is_navy()).."]")
		out("		has_garrison_residence 			["..tostring(garrison_force:has_garrison_residence()).."]")
		out("		contains_mercenaries------------["..tostring(garrison_force:contains_mercenaries()).."]")
		out("		upkeep is 	--------------------["..tostring(garrison_force:upkeep()).."]")
		out("		active_stance is 	------------["..tostring(garrison_force:active_stance()).."]")
		out("		morale is 	--------------------["..tostring(garrison_force:morale()).."]")
		out("		is_armed_citizenry -------------["..tostring(garrison_force:is_armed_citizenry()).."]")
		out("		strength 	--------------------["..tostring(garrison_force:strength()).."]")
		out("		has_general 	----------------["..tostring(garrison_force:has_general()).."]")
		out("		force type key is 	------------["..tostring(garrison_force:force_type():key()).."]")

		if print_mil_force_unit_info then
			army_context_logger(garrison_force)
		end
	end;
	local target_settlement = context:garrison_residence():settlement_interface()
	out(" ")
	out("-----===== SETTTLEMENT =====-----")
	out("is_null_interface  -------------["..tostring(target_settlement:is_null_interface()).."]")
	out("cqi is -------------------------["..tostring(target_settlement:cqi()).."]")
	out("logical_position_x is 	--------["..tostring(target_settlement:logical_position_x()).."]")
	out("logical_position_y is 	--------["..tostring(target_settlement:logical_position_y()).."]")
	out("is_port  	--------------------["..tostring(target_settlement:is_port()).."]")
	out("get_climate  	----------------["..tostring(target_settlement:get_climate()).."]")
	out("Commander is_null_interface ----["..tostring(target_settlement:commander():is_null_interface()).."]")
	local target_region = context:garrison_residence():region()
	out(" ")
	out("-----===== REGION =====-----")
	out("Region is_null_interface					 ["..tostring(target_region:is_null_interface()).."]")
	out("Region cqi			 						 ["..tostring(target_region:cqi()).."]")
	out("Region owning_faction						 ["..tostring(target_region:owning_faction():name()).."]")
	out("Region name			 					 ["..tostring(target_region:name()).."]")
	out("Region province_name						 ["..tostring(target_region:province_name()).."]")
	out("Region public_order						 ["..tostring(target_region:public_order()).."]")
	out("Region num_buildings						 ["..tostring(target_region:num_buildings()).."]")
	out("Region any_resource_available				 ["..tostring(target_region:any_resource_available()).."]")
	out("Region is_abandoned						 ["..tostring(target_region:is_abandoned()).."]")
	out("Region faction_province_growth			 	 ["..tostring(target_region:faction_province_growth()).."]")
	out("Region faction_province_growth_per_turn	 ["..tostring(target_region:faction_province_growth_per_turn()).."]")
	out("Region is_province_capital					 ["..tostring(target_region:is_province_capital()).."]")
	out("Region has_development_points_to_upgrade 	 ["..tostring(target_region:has_development_points_to_upgrade()).."]")
	out("Region num_faction_province_slaves			 ["..tostring(target_region:num_faction_province_slaves()).."]")
	out("Region max_faction_province_slaves			 ["..tostring(target_region:max_faction_province_slaves()).."]")
	out("Region percentage_faction_province_slaves	 ["..tostring(target_region:percentage_faction_province_slaves()).."]")
	out("Region has_active_storm					 ["..tostring(target_region:has_active_storm()).."]")
end,
true
);
-- local function hertz_debug_printer_listeners()

-- end;


function hertz_print_faction_army_list(faction_key)
	local target_faction = cm:get_faction(faction_key);
	local mil_force_list = target_faction:military_force_list();

	out("-----===== Faction ["..faction_key.."] Unit List Info =====-----")
	for i = 0, mil_force_list:num_items() - 1 do
		out("is_null_interface 				["..tostring(mil_force_list:item_at(i):is_null_interface()).."]")
		if not mil_force_list:item_at(i):is_null_interface() then
			out("-----===== Army CQI ["..mil_force_list:item_at(i):command_queue_index().."] Military Force Info =====-----")
			out("command_queue_index is ---------["..tostring(mil_force_list:item_at(i):command_queue_index()).."]")
			out("is_army is ---------------------["..tostring(mil_force_list:item_at(i):is_army()).."]")
			out("is_navy is ---------------------["..tostring(mil_force_list:item_at(i):is_navy()).."]")
			out("is_null_interface is ---------["..tostring(mil_force_list:item_at(i):general_character():is_null_interface()).."]")
			out("has_garrison_residence is 	----["..tostring(mil_force_list:item_at(i):has_garrison_residence()).."]")
			out("has_general --------------------["..tostring(mil_force_list:item_at(i):has_general()).."]")
			if not mil_force_list:item_at(i):general_character():is_null_interface() then
				out("-----===== CHARACTER ["..mil_force_list:item_at(i):general_character():command_queue_index().."] INFO =====-----")
				out("		is_null_interface is 	--------["..tostring(mil_force_list:item_at(i):general_character():is_null_interface()).."]")
				out("		has_garrison_residence is 	----["..tostring(mil_force_list:item_at(i):general_character():has_garrison_residence()).."]")
				out("		has_region is 	----------------["..tostring(mil_force_list:item_at(i):general_character():has_region()).."]")
				if mil_force_list:item_at(i):general_character():has_region() then
					out("			region name is ["..tostring(mil_force_list:item_at(i):general_character():region():name()).."]")
				end;
				out("		has_military_force is 	--------["..tostring(mil_force_list:item_at(i):general_character():has_military_force()).."]")
				out("		in_settlement is 	------------["..tostring(mil_force_list:item_at(i):general_character():in_settlement()).."]")
				out("		in_port is ---------------------["..tostring(mil_force_list:item_at(i):general_character():in_port()).."]")
				out("		forename is --------------------["..tostring(mil_force_list:item_at(i):general_character():get_forename()).."]")
				out("		surname is ---------------------["..tostring(mil_force_list:item_at(i):general_character():get_surname()).."]")
				out("		character_type_key is 	--------["..tostring(mil_force_list:item_at(i):general_character():character_type_key()).."]")
				out("		character_subtype_key is 	----["..tostring(mil_force_list:item_at(i):general_character():character_subtype_key()).."]")
				out("		battles_fought is 	------------["..tostring(mil_force_list:item_at(i):general_character():battles_fought()).."]")
				out("		turns_at_sea is 	------------["..tostring(mil_force_list:item_at(i):general_character():turns_at_sea()).."]")
				out("		logical_position_x is 	--------["..tostring(mil_force_list:item_at(i):general_character():logical_position_x()).."]")
				out("		logical_position_y is 	--------["..tostring(mil_force_list:item_at(i):general_character():logical_position_y()).."]")
				out("		is_at_sea is 	----------------["..tostring(mil_force_list:item_at(i):general_character():is_at_sea()).."]")
			end;
			out("contains_mercenaries is --------["..tostring(mil_force_list:item_at(i):contains_mercenaries()).."]")
			out("upkeep is 	----------------["..tostring(mil_force_list:item_at(i):upkeep()).."]")
			out("unit_list count is ----------------["..tostring(mil_force_list:item_at(i):unit_list():num_items()).."]")
			out("active_stance is 	------------["..tostring(mil_force_list:item_at(i):active_stance()).."]")
			out("morale is 	--------------------["..tostring(mil_force_list:item_at(i):morale()).."]")
			out("is_armed_citizenry is 	--------["..tostring(mil_force_list:item_at(i):is_armed_citizenry()).."]")
			out("strength is --------------------["..tostring(mil_force_list:item_at(i):strength()).."]")
			out("force type key is 				["..tostring(mil_force_list:item_at(i):force_type():key()).."]")
			if mil_force_list:item_at(i):unit_list():num_items() > 0 then
				out("^^^^^===== ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ =====^^^^^")
				out("-----===== ARMY CQI ["..mil_force_list:item_at(i):command_queue_index().."] UNIT LIST INFO =====-----")
				local unit_list = mil_force_list:item_at(i):unit_list()
				for j = 0, unit_list:num_items() - 1 do
					out("		is_null_interface is------------------------["..tostring(unit_list:item_at(j):is_null_interface()).."]")
					if not unit_list:item_at(j):is_null_interface() then
						out("		command_queue_index is 	--------------------["..tostring(unit_list:item_at(j):command_queue_index()).."]")
						out("		has_force_commander is 	--------------------["..tostring(unit_list:item_at(j):has_force_commander()).."]")
						out("		has_unit_commander is 	--------------------["..tostring(unit_list:item_at(j):has_unit_commander()).."]")
						out("		command_queue_index is 	--------------------["..tostring(unit_list:item_at(j):force_commander():command_queue_index()).."]")
						out("		unit_key is 	----------------------------["..tostring(unit_list:item_at(j):unit_key()).."]")
						out("		unit_category is 	------------------------["..tostring(unit_list:item_at(j):unit_category()).."]")
						out("		unit_class is 	----------------------------["..tostring(unit_list:item_at(j):unit_class()).."]")
						out("		percentage_proportion_of_full_strength is 	["..tostring(unit_list:item_at(j):percentage_proportion_of_full_strength()).."]")
						out("		has_banner_ancillary is --------------------["..tostring(unit_list:item_at(j):has_banner_ancillary()).."]")
					end;
				end;
			end;
		end;
	end;
end;

function hertz_debug_list_sea_regions()
	local sea_region_list = cm:model():world():sea_region_data()
	out("[[## SEA REGION DATA LIST ##]]")	
	for i = 0, sea_region_list:num_items() - 1 do
		local sea_region = sea_region_list:item_at(i);
		local sea_region_key = sea_region:key();
		local box_x, box_y, box_width, box_height = target_region:get_bounds();
		out("Sea region key: ["..sea_region_key.."]")
		out("bounds box x: ["..box_x.."]")
		out("bounds box y: ["..box_y.."]")
		out("bounds box width: ["..box_width.."]")
		out("bounds box height: ["..box_height.."]")
		out("--------------------------------------")
	end;
end;


-- cm:add_first_tick_callback(function() hertz_debug_printer_listeners() end);