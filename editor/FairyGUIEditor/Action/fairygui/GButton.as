package fairygui
{
    import *.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;

    public class GButton extends GComponent
    {
        protected var _titleObject:GObject;
        protected var _iconObject:GObject;
        protected var _relatedController:Controller;
        private var _mode:int;
        private var _selected:Boolean;
        private var _title:String;
        private var _selectedTitle:String;
        private var _icon:String;
        private var _selectedIcon:String;
        private var _sound:String;
        private var _soundVolumeScale:Number;
        private var _pageOption:PageOption;
        private var _buttonController:Controller;
        private var _changeStateOnClick:Boolean;
        private var _linkedPopup:GObject;
        private var _hasDisabledPage:Boolean;
        private var _downEffect:int;
        private var _downEffectValue:Number;
        private var _useHandCursor:Boolean;
        private var _downScaled:Boolean;
        private var _over:Boolean;
        public static const UP:String = "up";
        public static const DOWN:String = "down";
        public static const OVER:String = "over";
        public static const SELECTED_OVER:String = "selectedOver";
        public static const DISABLED:String = "disabled";
        public static const SELECTED_DISABLED:String = "selectedDisabled";

        public function GButton()
        {
            _mode = 0;
            _title = "";
            _icon = "";
            _sound = UIConfig.buttonSound;
            _soundVolumeScale = UIConfig.buttonSoundVolumeScale;
            _pageOption = new PageOption();
            _changeStateOnClick = true;
            _downEffectValue = 0.8;
            _useHandCursor = UIConfig.buttonUseHandCursor;
            if (_useHandCursor)
            {
                this.Sprite(this.displayObject).buttonMode = true;
                this.Sprite(this.displayObject).useHandCursor = true;
            }
            return;
        }// end function

        override public function get icon() : String
        {
            return _icon;
        }// end function

        override public function set icon(param1:String) : void
        {
            _icon = param1;
            param1 = _selected && _selectedIcon ? (_selectedIcon) : (_icon);
            if (_iconObject != null)
            {
                _iconObject.icon = param1;
            }
            updateGear(7);
            return;
        }// end function

        final public function get selectedIcon() : String
        {
            return _selectedIcon;
        }// end function

        public function set selectedIcon(param1:String) : void
        {
            _selectedIcon = param1;
            param1 = _selected && _selectedIcon ? (_selectedIcon) : (_icon);
            if (_iconObject != null)
            {
                _iconObject.icon = param1;
            }
            return;
        }// end function

        final public function get title() : String
        {
            return _title;
        }// end function

        public function set title(param1:String) : void
        {
            _title = param1;
            if (_titleObject)
            {
                _titleObject.text = _selected && _selectedTitle ? (_selectedTitle) : (_title);
            }
            updateGear(6);
            return;
        }// end function

        final override public function get text() : String
        {
            return this.title;
        }// end function

        override public function set text(param1:String) : void
        {
            this.title = param1;
            return;
        }// end function

        final public function get selectedTitle() : String
        {
            return _selectedTitle;
        }// end function

        public function set selectedTitle(param1:String) : void
        {
            _selectedTitle = param1;
            if (_titleObject)
            {
                _titleObject.text = _selected && _selectedTitle ? (_selectedTitle) : (_title);
            }
            return;
        }// end function

        final public function get titleColor() : uint
        {
            var _loc_1:* = getTextField();
            if (_loc_1)
            {
                return _loc_1.color;
            }
            return 0;
        }// end function

        public function set titleColor(param1:uint) : void
        {
            var _loc_2:* = getTextField();
            if (_loc_2)
            {
                _loc_2.color = param1;
            }
            updateGear(4);
            return;
        }// end function

        final public function get titleFontSize() : int
        {
            var _loc_1:* = getTextField();
            if (_loc_1)
            {
                return _loc_1.fontSize;
            }
            return 0;
        }// end function

        public function set titleFontSize(param1:int) : void
        {
            var _loc_2:* = getTextField();
            if (_loc_2)
            {
                _loc_2.fontSize = param1;
            }
            return;
        }// end function

        final public function get sound() : String
        {
            return _sound;
        }// end function

        public function set sound(param1:String) : void
        {
            _sound = param1;
            return;
        }// end function

        public function get soundVolumeScale() : Number
        {
            return _soundVolumeScale;
        }// end function

        public function set soundVolumeScale(param1:Number) : void
        {
            _soundVolumeScale = param1;
            return;
        }// end function

        public function set selected(param1:Boolean) : void
        {
            var _loc_2:* = null;
            if (_mode == 0)
            {
                return;
            }
            if (_selected != param1)
            {
                _selected = param1;
                setCurrentState();
                if (_selectedTitle && _titleObject)
                {
                    _titleObject.text = _selected ? (_selectedTitle) : (_title);
                }
                if (_selectedIcon)
                {
                    _loc_2 = _selected ? (_selectedIcon) : (_icon);
                    if (_iconObject != null)
                    {
                        _iconObject.icon = _loc_2;
                    }
                }
                if (_relatedController && _parent && !_parent._buildingDisplayList)
                {
                    if (_selected)
                    {
                        _relatedController.selectedPageId = _pageOption.id;
                        if (_relatedController._autoRadioGroupDepth)
                        {
                            _parent.adjustRadioGroupDepth(this, _relatedController);
                        }
                    }
                    else if (_mode == 1 && _relatedController.selectedPageId == _pageOption.id)
                    {
                        _relatedController.oppositePageId = _pageOption.id;
                    }
                }
            }
            return;
        }// end function

        final public function get selected() : Boolean
        {
            return _selected;
        }// end function

        final public function get mode() : int
        {
            return _mode;
        }// end function

        public function set mode(param1:int) : void
        {
            if (_mode != param1)
            {
                if (param1 == 0)
                {
                    this.selected = false;
                }
                _mode = param1;
            }
            return;
        }// end function

        final public function get useHandCursor() : Boolean
        {
            return _useHandCursor;
        }// end function

        public function set useHandCursor(param1:Boolean) : void
        {
            _useHandCursor = param1;
            this.Sprite(this.displayObject).buttonMode = _useHandCursor;
            this.Sprite(this.displayObject).useHandCursor = _useHandCursor;
            return;
        }// end function

        final public function get relatedController() : Controller
        {
            return _relatedController;
        }// end function

        public function set relatedController(param1:Controller) : void
        {
            if (param1 != _relatedController)
            {
                _relatedController = param1;
                _pageOption.controller = param1;
                _pageOption.clear();
            }
            return;
        }// end function

        final public function get pageOption() : PageOption
        {
            return _pageOption;
        }// end function

        final public function get changeStateOnClick() : Boolean
        {
            return _changeStateOnClick;
        }// end function

        final public function set changeStateOnClick(param1:Boolean) : void
        {
            _changeStateOnClick = param1;
            return;
        }// end function

        final public function get linkedPopup() : GObject
        {
            return _linkedPopup;
        }// end function

        final public function set linkedPopup(param1:GObject) : void
        {
            _linkedPopup = param1;
            return;
        }// end function

        public function addStateListener(param1:Function) : void
        {
            addEventListener("stateChanged", param1);
            return;
        }// end function

        public function removeStateListener(param1:Function) : void
        {
            removeEventListener("stateChanged", param1);
            return;
        }// end function

        public function fireClick(param1:Boolean = true) : void
        {
            downEffect = param1;
            if (downEffect && _mode == 0)
            {
                setState("over");
                GTimers.inst.add(100, 1, function () : void
            {
                setState("down");
                return;
            }// end function
            );
                GTimers.inst.add(200, 1, function () : void
            {
                setState("up");
                return;
            }// end function
            );
            }
            __click(null);
            return;
        }// end function

        public function getTextField() : GTextField
        {
            if (_titleObject is GTextField)
            {
                return this.GTextField(_titleObject);
            }
            if (_titleObject is GLabel)
            {
                return this.GLabel(_titleObject).getTextField();
            }
            if (_titleObject is GButton)
            {
                return this.GButton(_titleObject).getTextField();
            }
            return null;
        }// end function

        protected function setState(param1:String) : void
        {
            var _loc_5:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_6:* = 0;
            var _loc_4:* = null;
            if (_buttonController)
            {
                _buttonController.selectedPage = param1;
            }
            if (_downEffect == 1)
            {
                _loc_5 = this.numChildren;
                if (param1 == "down" || param1 == "selectedOver" || param1 == "selectedDisabled")
                {
                    _loc_2 = _downEffectValue * 255;
                    _loc_3 = (_loc_2 << 16) + (_loc_2 << 8) + _loc_2;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_5)
                    {
                        
                        _loc_4 = this.getChildAt(_loc_6);
                        if (!(_loc_4 is GTextField))
                        {
                            _loc_4.setProp(2, _loc_3);
                        }
                        _loc_6++;
                    }
                }
                else
                {
                    _loc_6 = 0;
                    while (_loc_6 < _loc_5)
                    {
                        
                        _loc_4 = this.getChildAt(_loc_6);
                        if (!(_loc_4 is GTextField))
                        {
                            _loc_4.setProp(2, 16777215);
                        }
                        _loc_6++;
                    }
                }
            }
            else if (_downEffect == 2)
            {
                if (param1 == "down" || param1 == "selectedOver" || param1 == "selectedDisabled")
                {
                    if (!_downScaled)
                    {
                        setScale(this.scaleX * _downEffectValue, this.scaleY * _downEffectValue);
                        _downScaled = true;
                    }
                }
                else if (_downScaled)
                {
                    setScale(this.scaleX / _downEffectValue, this.scaleY / _downEffectValue);
                    _downScaled = false;
                }
            }
            return;
        }// end function

        protected function setCurrentState() : void
        {
            if (this.grayed && _buttonController && _buttonController.hasPage("disabled"))
            {
                if (_selected)
                {
                    setState("selectedDisabled");
                }
                else
                {
                    setState("disabled");
                }
            }
            else if (_selected)
            {
                setState(_over ? ("selectedOver") : ("down"));
            }
            else
            {
                setState(_over ? ("over") : ("up"));
            }
            return;
        }// end function

        override public function handleControllerChanged(param1:Controller) : void
        {
            super.handleControllerChanged(param1);
            if (_relatedController == param1)
            {
                this.selected = _pageOption.id == param1.selectedPageId;
            }
            return;
        }// end function

        override protected function handleGrayedChanged() : void
        {
            if (_buttonController && _buttonController.hasPage("disabled"))
            {
                if (this.grayed)
                {
                    if (_selected)
                    {
                        setState("selectedDisabled");
                    }
                    else
                    {
                        setState("disabled");
                    }
                }
                else if (_selected)
                {
                    setState("down");
                }
                else
                {
                    setState("up");
                }
            }
            else
            {
                super.handleGrayedChanged();
            }
            return;
        }// end function

        override public function getProp(param1:int)
        {
            var _loc_2:* = null;
            switch(param1 - 2) branch count is:<7>[29, 34, 68, 68, 68, 68, 58, 63] default offset is:<68>;
            return this.titleColor;
            _loc_2 = getTextField();
            if (_loc_2)
            {
                return _loc_2.strokeColor;
            }
            return 0;
            return this.titleFontSize;
            return this.selected;
            return super.getProp(param1);
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            var _loc_3:* = null;
            switch(param1 - 2) branch count is:<7>[29, 38, 81, 81, 81, 81, 63, 72] default offset is:<81>;
            this.titleColor = param2;
            ;
            _loc_3 = getTextField();
            if (_loc_3)
            {
                _loc_3.strokeColor = param2;
            }
            ;
            this.titleFontSize = param2;
            ;
            this.selected = param2;
            ;
            super.setProp(param1, param2);
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            var _loc_2:* = null;
            super.constructFromXML(param1);
            param1 = param1.Button[0];
            _loc_2 = param1.@mode;
            if (_loc_2)
            {
                _mode = ButtonMode.parse(_loc_2);
            }
            _loc_2 = param1.@sound;
            if (_loc_2)
            {
                _sound = _loc_2;
            }
            _loc_2 = param1.@volume;
            if (_loc_2)
            {
                _soundVolumeScale = this.parseInt(_loc_2) / 100;
            }
            _loc_2 = param1.@downEffect;
            if (_loc_2)
            {
                _downEffect = _loc_2 == "dark" ? (1) : (_loc_2 == "scale" ? (2) : (0));
                _loc_2 = param1.@downEffectValue;
                _downEffectValue = this.parseFloat(_loc_2);
                if (_downEffect == 2)
                {
                    this.setPivot(0.5, 0.5);
                }
            }
            _buttonController = getController("button");
            _titleObject = getChild("title");
            _iconObject = getChild("icon");
            if (_titleObject != null)
            {
                _title = _titleObject.text;
            }
            if (_iconObject != null)
            {
                _icon = _iconObject.icon;
            }
            if (_mode == 0)
            {
                setState("up");
            }
            this.opaque = true;
            if (!GRoot.touchScreen)
            {
                displayObject.addEventListener("rollOver", __rollover);
                displayObject.addEventListener("rollOut", __rollout);
            }
            this.addEventListener("beginGTouch", __mousedown);
            this.addEventListener("endGTouch", __mouseup);
            this.addEventListener("clickGTouch", __click, false, 1000);
            return;
        }// end function

        override public function setup_afterAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            super.setup_afterAdd(param1);
            param1 = param1.Button[0];
            if (param1)
            {
                _loc_2 = param1.@title;
                if (_loc_2)
                {
                    this.title = _loc_2;
                }
                _loc_2 = param1.@icon;
                if (_loc_2)
                {
                    this.icon = _loc_2;
                }
                _loc_2 = param1.@selectedTitle;
                if (_loc_2)
                {
                    this.selectedTitle = _loc_2;
                }
                _loc_2 = param1.@selectedIcon;
                if (_loc_2)
                {
                    this.selectedIcon = _loc_2;
                }
                _loc_2 = param1.@titleColor;
                if (_loc_2)
                {
                    this.titleColor = ToolSet.convertFromHtmlColor(_loc_2);
                }
                _loc_2 = param1.@titleFontSize;
                if (_loc_2)
                {
                    this.titleFontSize = this.parseInt(_loc_2);
                }
                if (param1.@sound.length() != 0)
                {
                    _sound = param1.@sound;
                }
                _loc_2 = param1.@volume;
                if (_loc_2)
                {
                    _soundVolumeScale = this.parseInt(_loc_2) / 100;
                }
                _loc_2 = param1.@controller;
                if (_loc_2)
                {
                    _relatedController = _parent.getController(param1.@controller);
                }
                else
                {
                    _relatedController = null;
                }
                _pageOption.id = param1.@page;
                this.selected = param1.@checked == "true";
            }
            return;
        }// end function

        private function __rollover(event:Event) : void
        {
            if (!_buttonController || !_buttonController.hasPage("over"))
            {
                return;
            }
            _over = true;
            if (this.isDown)
            {
                return;
            }
            if (this.grayed && _buttonController.hasPage("disabled"))
            {
                return;
            }
            setState(_selected ? ("selectedOver") : ("over"));
            return;
        }// end function

        private function __rollout(event:Event) : void
        {
            if (!_buttonController || !_buttonController.hasPage("over"))
            {
                return;
            }
            _over = false;
            if (this.isDown)
            {
                return;
            }
            if (this.grayed && _buttonController.hasPage("disabled"))
            {
                return;
            }
            setState(_selected ? ("down") : ("up"));
            return;
        }// end function

        private function __mousedown(event:Event) : void
        {
            if (_mode == 0)
            {
                if (this.grayed && _buttonController && _buttonController.hasPage("disabled"))
                {
                    setState("selectedDisabled");
                }
                else
                {
                    setState("down");
                }
            }
            if (_linkedPopup != null)
            {
                if (_linkedPopup is Window)
                {
                    this.Window(_linkedPopup).toggleStatus();
                }
                else
                {
                    this.root.togglePopup(_linkedPopup, this);
                }
            }
            return;
        }// end function

        private function __mouseup(event:Event) : void
        {
            if (_mode == 0)
            {
                if (this.grayed && _buttonController && _buttonController.hasPage("disabled"))
                {
                    setState("disabled");
                }
                else if (_over)
                {
                    setState("over");
                }
                else
                {
                    setState("up");
                }
            }
            else if (!_over && _buttonController && (_buttonController.selectedPage == "over" || _buttonController.selectedPage == "selectedOver"))
            {
                setCurrentState();
            }
            return;
        }// end function

        private function __click(event:Event) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = null;
            if (_sound)
            {
                _loc_3 = UIPackage.getItemByURL(_sound);
                if (_loc_3)
                {
                    _loc_2 = _loc_3.owner.getSound(_loc_3);
                    if (_loc_2)
                    {
                        GRoot.inst.playOneShotSound(_loc_2, _soundVolumeScale);
                    }
                }
            }
            if (_mode == 1)
            {
                if (_changeStateOnClick)
                {
                    this.selected = !_selected;
                    dispatchEvent(new StateChangeEvent("stateChanged"));
                }
            }
            else if (_mode == 2)
            {
                if (_changeStateOnClick && !_selected)
                {
                    this.selected = true;
                    dispatchEvent(new StateChangeEvent("stateChanged"));
                }
            }
            else if (_relatedController)
            {
                _relatedController.selectedPageId = _pageOption.id;
            }
            return;
        }// end function

    }
}
