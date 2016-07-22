-- Main.lua
-- Written by Almagnus1 edited by Exopan

-- IOF Changelog:
-- 2016/06/20  1.2.0 - Combined Crypt Command and iof command
-- 2011/07/10  1.1.1 - Fixed a bug where IOF GUI wouldn't update correctly
-- 2011/06/11  1.1.0 - Added Crypt Window
-- 2011/06/01  1.0.0 - Final Release - GUI added
-- 2011/05/23  B.1.0 - Beta release - Added various components needed to support the UI
-- 2011/05/23  B.0.0 - Beta release - internal reorganization, completed emote table
-- 2011/05/18  A.0.0 - Alpha release.

import "Almagnus1.IOF";
import "Almagnus1.IOF.UTF";

-- initialize managers

_settings = SettingManager();
_settings:Load();

-- intialize GUI
_iofGUI = IOFWindow( _settings );

-- initialize command parser
iofCommand = Turbine.ShellCommand();

function iofCommand:Execute( command, argument )
	local arguments = string.lower( argument );
	if (arguments == "") then
		arguments = "help";
	end
	if ( arguments == "help" ) then
		Turbine.Shell.WriteLine( "To show the IOF GUI, type: /iof show" );
		Turbine.Shell.WriteLine( "To hide the IOF GUI, close the window, or type: /iof hide" );
		Turbine.Shell.WriteLine(
			"To hide the IOF GUI if visible, or show the IOF GUI if hidden, type: /iof toggle");
		Turbine.Shell.WriteLine( "Target the door in IOF, then type: /iof <riddle number>" );
		Turbine.Shell.WriteLine( "Expected riddle numbers are between 1 and 83 inclusive." );
		Turbine.Shell.WriteLine( "Ex: /iof 42" );
	--[[
	elseif (arguments == "debug" ) then
		for x = 1, 83, 1 do
			Turbine.Shell.WriteLine( x .. " = \"" .. _emotes:GetEmote( x ) .. "\"");
		end
	--]]	
	elseif ( arguments == "toggle" ) then
		_iofGUI:SetVisibility( not _iofGUI:IsVisible() );
	elseif ( arguments == "show" ) then
		_iofGUI:SetVisibility( true );
	elseif ( arguments == "hide" ) then
		_iofGUI:SetVisibility( false );
	elseif ( tonumber(arguments) ~= nil ) then
		local riddleNum = tonumber(arguments);
		if
			( ( math.floor(riddleNum) == riddleNum ) and
			( ( 1 <= riddleNum ) and ( riddleNum <= 83 ) ) )
		then
			local emote = EmoteManager( riddleNum );
			if (emote == "" ) then
				Turbine.Shell.WriteLine( "The answer to riddle #" .. riddleNum .. " is not known");
			else
				Turbine.Shell.WriteLine( "Answer to riddle #" .. riddleNum.. ": /" .. emote );
			end
		else
			Turbine.Shell.WriteLine(
				"The riddle number must be an integer between 1 and 83 inclusive." );
		end
	elseif (arguments == "crypt") then
		_cryptGUI:SetVisibility( not _cryptGUI:IsVisible() );

	else
		Turbine.Shell.WriteLine(
			"IOF does not recoginze the command \"" ..
			arguments .. 
			"\".  Type \"/iof help\" for more information" );
	end
end

Turbine.Shell.AddCommand( "iof", iofCommand );

-- initialize CryptWindow and it's parser
_cryptGUI = CryptWindow( _settings );
cryptCommand = Turbine.ShellCommand();

function cryptCommand:Execute( command, argument )
	local arguments = string.lower( argument );
	if ( arguments == "help" ) then
		Turbine.Shell.WriteLine( "To show the Crypt Map, type: /crypt show" );
		Turbine.Shell.WriteLine( "To hide the Crypt Map, close the window, or type: /crypt hide" );
		Turbine.Shell.WriteLine(
			"To hide the Crypt Map if visible, or show the Crypt Map if hidden, type: /Crypt toggle");
	elseif ( arguments == "toggle" ) then
		_cryptGUI:SetVisibility( not _cryptGUI:IsVisible() );
	elseif ( arguments == "show" ) then
		_cryptGUI:SetVisibility( true );
	elseif ( arguments == "hide" ) then
		_cryptGUI:SetVisibility( false );
	else
		Turbine.Shell.WriteLine(
			"Crypt Window does not recoginze the command \"" ..
			arguments .. 
			"\".  Type \"/crypt help\" for more information" );
	end
end

Turbine.Shell.AddCommand( "crypt", cryptCommand );

Turbine.Shell.WriteLine( "IOF v1.1.1 by Almagnus1" );
