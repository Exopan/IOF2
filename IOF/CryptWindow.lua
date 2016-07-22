-- IOFWindow.lua
-- Writen by Almagnus1
-- Defines the IOF UI element

import "Turbine.UI";
import "Turbine.UI.Lotro";

CryptWindow = class( Turbine.UI.Window );

function CryptWindow:Constructor( settingManager )
	Turbine.UI.Window.Constructor( self );
	_settingManager = settingManager;
	self.SettingManager = settingManager;
	
	-- attributes needed for event handlers
	_dragging = false;
	_mouse = {}
	_mouse.x = -1;
	_mouse.y = -1;
	_clicking = false;
	
	-- load saved settings
	self:SetVisible( _settingManager.Settings.Crypt.Visible );
	self:SetPosition( _settingManager.Settings.Crypt.X, _settingManager.Settings.Crypt.Y );
	
	-- construct the GUI
	self:SetMouseVisible( true );
	self:SetSize( 365, 465 );
	self:SetBackground( "Almagnus1/IOF/Resources/cryptwindow.tga" );
	
	_cmdClose = Turbine.UI.Button();
	_cmdClose:SetParent( self );
	_cmdClose:SetPosition( 358, 0 );
	_cmdClose:SetSize( 7, 7 );
	_cmdClose:SetMouseVisible( true );
	_cmdClose:SetBackground( "Almagnus1/IOF/Resources/up.tga" );
	
	-- IOFWindow event handlers
	self.MouseDown = function( sender, args )
		if( ( args.Button == 1 ) and ( args.Y < 7 ) ) then
			_dragging = true;
			_mouse.x = args.X;
			_mouse.y = args.Y;
		end
	end
	
	self.MouseUp = function( sender, args )
		if(args.Button == 1) then
			if( _dragging ) then
				_settingManager.Settings.Crypt.X = self:GetLeft();
				_settingManager.Settings.Crypt.Y = self:GetTop();
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
	
	-- cmdClose Event Handlers
	_cmdClose.MouseClick = function( sender, args )
		self:SetVisibility( false );
	end
end

function CryptWindow:SetVisibility( visibility )
	self:SetVisible( visibility );
	_settingManager.Settings.Crypt.Visible = visibility;
	_settingManager:Save();
end
