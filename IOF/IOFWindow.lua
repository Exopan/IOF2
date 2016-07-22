-- IOFWindow.lua
-- Writen by Almagnus1 edited by Exopan
-- Defines the IOF UI element

import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Almagnus1.IOF.UTF";

IOFWindow = class( Turbine.UI.Window );

function IOFWindow:Constructor( settingManager )
	Turbine.UI.Window.Constructor( self );
	self.Emotes = emoteManager;
	_settingManager = settingManager;
	self.SettingManager = settingManager;
	
	-- attributes needed for event handlers
	_dragging = false;
	_mouse = {}
	_mouse.x = -1;
	_mouse.y = -1;
	_clicking = false;
	
	-- load saved settings
	self:SetVisible( _settingManager.Settings.Visible );
	self:SetPosition( _settingManager.Settings.Location.X, _settingManager.Settings.Location.Y );
	
	-- construct the GUI
	self:SetMouseVisible( true );
	self:SetSize( 122, 45 );
	self:SetBackground( "Almagnus1/IOF/Resources/background.tga" );
	
	_txtRiddle = Turbine.UI.Lotro.TextBox();
	_txtRiddle:SetParent( self );
	_txtRiddle:SetPosition( 3, 10 );
	_txtRiddle:SetSize( 35, 32 );
	_txtRiddle:SetMultiline( false );
	_txtRiddle:SetWantsUpdates( false );
	_txtRiddle:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	_txtRiddle.Text = "";
	
	_quickSlot = Turbine.UI.Lotro.Quickslot();
	_quickSlot.Alias = "";
	_quickSlot:SetParent( self );
	_quickSlot:SetPosition( 38, 7 );
	
	_cmdClose = Turbine.UI.Button();
	_cmdClose:SetParent( self );
	_cmdClose:SetPosition( 115, 0 );
	_cmdClose:SetSize( 7, 7 );
	_cmdClose:SetMouseVisible( true );
	_cmdClose:SetBackground( "Almagnus1/IOF/Resources/up.tga" );
	
	_lblSlot = Turbine.UI.Label();
	_lblSlot:SetParent( self );
	_lblSlot:SetPosition( 41, 10 );
	_lblSlot:SetSize( 32, 32 );
	_lblSlot:SetMouseVisible( false );

	_Crypt = Turbine.UI.Button();
	_Crypt:SetParent( self );
	_Crypt:SetPosition( 79, 10 );
	_Crypt:SetSize( 34, 32 );
	_Crypt:SetMouseVisible( true );
	_Crypt:SetText( "Crypt" );
	
	-- custom methods
	_lblSlot.GreenLight = function()
		_lblSlot:SetBackground( "Almagnus1/IOF/Resources/greenlight.tga" );
	end
	
	_lblSlot.RedLight = function()
		_quickSlot.Alias = "";
		_quickSlot:SetShortcut( Turbine.UI.Lotro.Shortcut() );
		_lblSlot:SetBackground( "Almagnus1/IOF/Resources/redlight.tga" );
	end
	
	-- set initial quickslot condition
	_lblSlot:RedLight();
	
	-- IOFWindow event handlers
	self.MouseDown = function( sender, args )
		if( args.Button == 1 ) then
			_dragging = true;
			_mouse.x = args.X;
			_mouse.y = args.Y;
		end
	end
	
	self.MouseUp = function( sender, args )
		if(args.Button == 1) then
			if( _dragging ) then
				_settingManager.Settings.Location.X = self:GetLeft();
				_settingManager.Settings.Location.Y = self:GetTop();
				_settingManager:Save();
			end
			_dragging = false;
		end
	end
	
	self.MouseMove = function( sender, args )
		if( _dragging ) then
			self:SetPosition( self:GetLeft() + args.X - _mouse.x, self:GetTop() + args.Y - _mouse.y );
		end
	end
	
	-- txtRiddle event handlers
	-- see http://forums.lotro.com/showthread.php?396735-Turbine.UI.Lotro.TextBox.KeyUp-event-not-working-correctly
	-- for more info about a workaround for KeyUp
	_txtRiddle.FocusGained = function()
		_txtRiddle:SetWantsUpdates( true );
	end
	
	_txtRiddle.FocusLost = function()
		_txtRiddle:SetWantsUpdates( false );
	end
	
	_txtRiddle.Update = function()
		local text = _txtRiddle:GetText();
		if (_txtRiddle.Text ~= text ) then
			-- if there's more than two chars, prune it.
			if( string.len(text) > 2 ) then
				text = string.sub( text, 0, 2 );
				_txtRiddle:SetText( text );
			end
			
			_txtRiddle.Text = text;
			
			if ( tonumber(text) ~= nil ) then
				local riddleNum = tonumber(text);
				if
					( ( math.floor(riddleNum) == riddleNum ) and
					( ( 1 <= riddleNum ) and ( riddleNum <= 83 ) ) )
				then
					local _emote = EmoteManager( riddleNum );
					if (_emote == "" ) then
						_lblSlot:RedLight();
					else
						_emote = FromUTF8(_emote);
						_emote = "/" .. _emote;
						_quickSlot.Alias = _emote;
						_quickSlot:SetShortcut(
							Turbine.UI.Lotro.Shortcut(
								Turbine.UI.Lotro.ShortcutType.Alias,
								_quickSlot.Alias
							));
						
						_lblSlot:GreenLight();
					end
				else
					_lblSlot:RedLight();
				end
			else
				_lblSlot:RedLight();
			end
		end
	end
	
	-- quickSlot event handlers
	_quickSlot.ShortcutChanged = function( sender, args )
	end
	
	-- lblSlot Event Handlers
	
	-- cmdClose Event Handlers
	_cmdClose.MouseClick = function( sender, args )
		self:SetVisibility( false );
	end

	_Crypt.MouseClick = function( sender, args )
		cryptCommand:Execute( "crypt", "toggle" );
	end

end

function IOFWindow:SetVisibility( visibility )
	self:SetVisible( visibility );
	_settingManager.Settings.Visible = visibility;
	_settingManager:Save();
end
