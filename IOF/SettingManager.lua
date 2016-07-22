-- SettingManager.lua
-- Written by Almagnus1
-- Serializes/Deserializes settings for IOF's UI

import "Turbine";
import "Turbine.UI";

SettingManager = class( Turbine.Object );

function SettingManager:Constructor()
	-- create setting datastructure with default values
	local width = Turbine.UI.Display:GetWidth();
	local height = Turbine.UI.Display:GetHeight();
	self.Settings = {};
	self.Settings.Crypt = {}
	self.Settings.Crypt.X = width / 2;
	self.Settings.Crypt.Y = height /3;
	self.Settings.Crypt.Visible = false;
	self.Settings.Location = {};
	-- defaults to the middle of the screen
	self.Settings.Location.X = 3* width / 4;
	self.Settings.Location.Y = height / 3;
	self.Settings.Version = "1.1.0"; -- current version
	self.Settings.Visible = true;
end

function SettingManager:Load()
	local settings = Turbine.PluginData.Load( Turbine.DataScope.Character, "IOFSettings" );
	local width = Turbine.UI.Display:GetWidth();
	local height = Turbine.UI.Display:GetHeight();
	
	if ( ( type( settings ) == "table" )
		and ( type( settings.Location ) == "table" )
		and ( type( settings.Location.X ) == "number" )
		and ( type( settings.Location.Y ) == "number" )
		and ( ( 76 + settings.Location.X ) <= ( width + 1 ) )
		and ( ( 45 + settings.Location.Y ) <= ( height + 1 ) )
		and ( type( settings.Version ) == "string" )
		and ( type( settings.Visible ) == "boolean" ) )
	then
		self.Settings.Location.X = settings.Location.X;
		self.Settings.Location.Y = settings.Location.Y;
		self.Settings.Visible = settings.Visible;
		
		-- optional load for the crypt stuff
		if( ( type( settings.Crypt ) == "table" )
			and ( type ( settings.Crypt.X ) == "number" )
			and ( ( 365 + settings.Crypt.X ) < (width + 1 ) )
			and ( ( 465 + settings.Crypt.Y ) < (height + 1 ) )
			and ( type ( settings.Crypt.Y ) == "number" )
			and ( type ( settings.Crypt.Visible ) == "boolean" ) )
		then
			self.Settings.Crypt.X = settings.Crypt.X
			self.Settings.Crypt.Y = settings.Crypt.Y
			self.Settings.Crypt.Visible = settings.Crypt.Visible
		end
	end
end

function SettingManager:Save()
	Turbine.PluginData.Save( Turbine.DataScope.Character, "IOFSettings", self.Settings );
end
