package fairygui.editor.gui
{
    import *.*;
    import fairygui.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;

    public class FButton extends ComExtention
    {
        private var _mode:String;
        private var _selected:Boolean;
        private var _title:String;
        private var _selectedTitle:String;
        private var _titleColor:uint;
        private var _titleColorSet:Boolean;
        private var _originColor:uint;
        private var _titleFontSize:int;
        private var _titleFontSizeSet:Boolean;
        private var _originFontSize:int;
        private var _icon:String;
        private var _selectedIcon:String;
        private var _buttonController:FController;
        private var _titleObject:FObject;
        private var _iconObject:FObject;
        private var _controller:FController;
        private var _page:String;
        private var _sound:String;
        private var _volume:int;
        private var _soundSet:Boolean;
        private var _soundVolumeSet:Boolean;
        private var _downEffect:String;
        private var _downEffectValue:Number;
        private var _controllerFlag:Boolean;
        private var _downScaled:Boolean;
        private var _down:Boolean;
        private var _over:Boolean;
        public var changeStageOnClick:Boolean;
        public static const COMMON:String = "Common";
        public static const CHECK:String = "Check";
        public static const RADIO:String = "Radio";
        public static const UP:String = "up";
        public static const DOWN:String = "down";
        public static const OVER:String = "over";
        public static const SELECTED_OVER:String = "selectedOver";
        public static const DISABLED:String = "disabled";
        public static const SELECTED_DISABLED:String = "selectedDisabled";

        public function FButton()
        {
            this._mode = COMMON;
            this._title = "";
            this._icon = "";
            this._selectedTitle = "";
            this._selectedIcon = "";
            this._volume = 100;
            this.changeStageOnClick = true;
            this._downEffect = "none";
            this._downEffectValue = 0.8;
            return;
        }// end function

        override public function get icon() : String
        {
            return this._icon;
        }// end function

        override public function set icon(param1:String) : void
        {
            var _loc_2:* = null;
            this._icon = param1;
            if (this._iconObject)
            {
                _loc_2 = this._selected && this._selectedIcon ? (this._selectedIcon) : (this._icon);
                this._iconObject.icon = _loc_2;
            }
            _owner.updateGear(7);
            return;
        }// end function

        public function get selectedIcon() : String
        {
            return this._selectedIcon;
        }// end function

        public function set selectedIcon(param1:String) : void
        {
            var _loc_2:* = null;
            this._selectedIcon = param1;
            if (this._iconObject)
            {
                _loc_2 = this._selected && this._selectedIcon ? (this._selectedIcon) : (this._icon);
                this._iconObject.icon = _loc_2;
            }
            return;
        }// end function

        override public function get title() : String
        {
            return this._title;
        }// end function

        override public function set title(param1:String) : void
        {
            var _loc_2:* = null;
            this._title = param1;
            if (this._titleObject)
            {
                _loc_2 = this._selected && this._selectedTitle ? (this._selectedTitle) : (this._title);
                this._titleObject.text = _loc_2;
            }
            _owner.updateGear(6);
            return;
        }// end function

        public function get selectedTitle() : String
        {
            return this._selectedTitle;
        }// end function

        public function set selectedTitle(param1:String) : void
        {
            var _loc_2:* = null;
            this._selectedTitle = param1;
            if (this._titleObject)
            {
                _loc_2 = this._selected && this._selectedTitle ? (this._selectedTitle) : (this._title);
                this._titleObject.text = _loc_2;
            }
            return;
        }// end function

        public function get titleColor() : uint
        {
            return this._titleColor;
        }// end function

        public function set titleColor(param1:uint) : void
        {
            if (this._titleColor != param1)
            {
                this._titleColor = param1;
                if (this._titleObject)
                {
                    if (this._titleObject is FTextField)
                    {
                        FTextField(this._titleObject).color = this._titleColor;
                    }
                    else if (this._titleObject is FComponent)
                    {
                        if (FComponent(this._titleObject).extentionId == "Label")
                        {
                            FLabel(FComponent(this._titleObject).extention).titleColor = this._titleColor;
                        }
                        else if (FComponent(this._titleObject).extentionId == "Button")
                        {
                            FButton(FComponent(this._titleObject).extention).titleColor = this._titleColor;
                        }
                    }
                }
                _owner.updateGear(4);
            }
            return;
        }// end function

        public function get titleColorSet() : Boolean
        {
            return this._titleColorSet;
        }// end function

        public function set titleColorSet(param1:Boolean) : void
        {
            var _loc_2:* = 0;
            this._titleColorSet = param1;
            if (!this._titleColorSet)
            {
                _loc_2 = this._originColor;
            }
            else
            {
                _loc_2 = this._titleColor;
            }
            if (this._titleObject)
            {
                if (this._titleObject is FTextField)
                {
                    FTextField(this._titleObject).color = _loc_2;
                }
                else if (this._titleObject is FComponent)
                {
                    if (FComponent(this._titleObject).extentionId == "Label")
                    {
                        FLabel(FComponent(this._titleObject).extention).titleColor = _loc_2;
                    }
                    else if (FComponent(this._titleObject).extentionId == "Button")
                    {
                        FButton(FComponent(this._titleObject).extention).titleColor = _loc_2;
                    }
                }
            }
            return;
        }// end function

        public function get titleFontSize() : int
        {
            return this._titleFontSize;
        }// end function

        public function set titleFontSize(param1:int) : void
        {
            if (this._titleFontSize != param1)
            {
                this._titleFontSize = param1;
                if (this._titleObject)
                {
                    if (this._titleObject is FTextField)
                    {
                        FTextField(this._titleObject).fontSize = this._titleFontSize;
                    }
                    else if (this._titleObject is FComponent)
                    {
                        if (FComponent(this._titleObject).extentionId == "Label")
                        {
                            FLabel(FComponent(this._titleObject).extention).titleFontSize = this._titleFontSize;
                        }
                        else if (FComponent(this._titleObject).extentionId == "Button")
                        {
                            FButton(FComponent(this._titleObject).extention).titleFontSize = this._titleFontSize;
                        }
                    }
                }
                _owner.updateGear(9);
            }
            return;
        }// end function

        public function get titleFontSizeSet() : Boolean
        {
            return this._titleFontSizeSet;
        }// end function

        public function set titleFontSizeSet(param1:Boolean) : void
        {
            var _loc_2:* = 0;
            this._titleFontSizeSet = param1;
            if (!this._titleFontSizeSet)
            {
                _loc_2 = this._originFontSize;
            }
            else
            {
                _loc_2 = this._titleFontSize;
            }
            if (this._titleObject)
            {
                if (this._titleObject is FTextField)
                {
                    FTextField(this._titleObject).fontSize = _loc_2;
                }
                else if (this._titleObject is FComponent)
                {
                    if (FComponent(this._titleObject).extentionId == "Label")
                    {
                        FLabel(FComponent(this._titleObject).extention).titleFontSize = _loc_2;
                    }
                    else if (FComponent(this._titleObject).extentionId == "Button")
                    {
                        FButton(FComponent(this._titleObject).extention).titleFontSize = _loc_2;
                    }
                }
            }
            return;
        }// end function

        public function getTextField() : FTextField
        {
            if (this._titleObject is FTextField)
            {
                return FTextField(this._titleObject);
            }
            if (this._titleObject is FLabel)
            {
                return FLabel(this._titleObject).getTextField();
            }
            if (this._titleObject is FButton)
            {
                return FButton(this._titleObject).getTextField();
            }
            return null;
        }// end function

        public function get sound() : String
        {
            return this._sound;
        }// end function

        public function set sound(param1:String) : void
        {
            this._sound = param1;
            return;
        }// end function

        public function get volume() : int
        {
            return this._volume;
        }// end function

        public function set volume(param1:int) : void
        {
            this._volume = param1;
            return;
        }// end function

        public function get soundSet() : Boolean
        {
            return this._soundSet;
        }// end function

        public function set soundSet(param1:Boolean) : void
        {
            this._soundSet = param1;
            return;
        }// end function

        public function get soundVolumeSet() : Boolean
        {
            return this._soundVolumeSet;
        }// end function

        public function set soundVolumeSet(param1:Boolean) : void
        {
            this._soundVolumeSet = param1;
            return;
        }// end function

        public function get downEffect() : String
        {
            return this._downEffect;
        }// end function

        public function set downEffect(param1:String) : void
        {
            this._downEffect = param1;
            return;
        }// end function

        public function get downEffectValue() : Number
        {
            return this._downEffectValue;
        }// end function

        public function set downEffectValue(param1:Number) : void
        {
            this._downEffectValue = param1;
            return;
        }// end function

        public function set selected(param1:Boolean) : void
        {
            var _loc_2:* = null;
            if (this._mode == COMMON)
            {
                return;
            }
            if (this._selected != param1)
            {
                this._selected = param1;
                this.setCurrentState();
                if (this._selectedTitle)
                {
                    if (this._titleObject)
                    {
                        _loc_2 = this._selected ? (this._selectedTitle) : (this._title);
                        this._titleObject.text = _loc_2;
                    }
                }
                if (this._selectedIcon)
                {
                    if (this._iconObject)
                    {
                        _loc_2 = this._selected ? (this._selectedIcon) : (this._icon);
                        this._iconObject.icon = _loc_2;
                    }
                }
                if (this._controller && _owner._parent && (_owner._flags & FObjectFlags.INSPECTING) == 0 && !_owner._parent._buildingDisplayList)
                {
                    if (this._selected)
                    {
                        if (!this._controllerFlag)
                        {
                            this._controllerFlag = true;
                            this._controller.selectedPageId = this._page;
                            this._controllerFlag = false;
                        }
                        if (this._controller.autoRadioGroupDepth)
                        {
                            _owner._parent.adjustRadioGroupDepth(_owner, this._controller);
                        }
                    }
                    else if (this._mode == CHECK && this._controller.selectedPageId == this._page)
                    {
                        if (!this._controllerFlag)
                        {
                            this._controllerFlag = true;
                            this._controller.oppositePageId = this._page;
                            this._controllerFlag = false;
                        }
                    }
                }
            }
            return;
        }// end function

        public function get selected() : Boolean
        {
            return this._selected;
        }// end function

        public function get mode() : String
        {
            return this._mode;
        }// end function

        public function set mode(param1:String) : void
        {
            if (this._mode != param1)
            {
                if (param1 == COMMON)
                {
                    this._selected = false;
                }
                this._mode = param1;
            }
            return;
        }// end function

        public function get controller() : String
        {
            if (this._controller && this._controller.parent)
            {
                return this._controller.name;
            }
            return null;
        }// end function

        public function set controller(param1:String) : void
        {
            if (param1)
            {
                this._controller = _owner._parent.getController(param1);
            }
            else
            {
                this._controller = null;
            }
            return;
        }// end function

        public function get controllerObj() : FController
        {
            return this._controller;
        }// end function

        public function get page() : String
        {
            return this._page;
        }// end function

        public function set page(param1:String) : void
        {
            this._page = param1;
            return;
        }// end function

        private function setState(param1:String) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            if (this._buttonController)
            {
                this._buttonController.selectedPage = param1;
            }
            if ((_owner._flags & FObjectFlags.INSPECTING) == 0)
            {
                if (this._downEffect == "scale")
                {
                    if (param1 == DOWN || param1 == SELECTED_OVER || param1 == SELECTED_DISABLED)
                    {
                        if (!this._downScaled)
                        {
                            _owner.setScale(_owner.scaleX * this._downEffectValue, _owner.scaleY * this._downEffectValue);
                            this._downScaled = true;
                        }
                    }
                    else if (this._downScaled)
                    {
                        _owner.setScale(_owner.scaleX / this._downEffectValue, _owner.scaleY / this._downEffectValue);
                        this._downScaled = false;
                    }
                }
                else if (this._downEffect == "dark")
                {
                    _loc_2 = _owner.numChildren;
                    if (param1 == DOWN || param1 == SELECTED_OVER || param1 == SELECTED_DISABLED)
                    {
                        _loc_3 = this._downEffectValue * 255;
                        _loc_4 = (_loc_3 << 16) + (_loc_3 << 8) + _loc_3;
                        _loc_5 = 0;
                        while (_loc_5 < _loc_2)
                        {
                            
                            _loc_6 = _owner.getChildAt(_loc_5);
                            if (!(_loc_6 is FTextField))
                            {
                                _loc_6.setProp(ObjectPropID.Color, _loc_4);
                            }
                            _loc_5++;
                        }
                    }
                    else
                    {
                        _loc_5 = 0;
                        while (_loc_5 < _loc_2)
                        {
                            
                            _loc_6 = _owner.getChildAt(_loc_5);
                            if (!(_loc_6 is FTextField))
                            {
                                _loc_6.setProp(ObjectPropID.Color, 16777215);
                            }
                            _loc_5++;
                        }
                    }
                }
            }
            return;
        }// end function

        public function handleGrayChanged() : Boolean
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            if (this._buttonController && this._buttonController.hasPageName(DISABLED))
            {
                _loc_1 = _owner.numChildren;
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    _owner.getChildAt(_loc_2).grayed = false;
                    _loc_2++;
                }
                if (_owner.grayed)
                {
                    if (this._selected && this._buttonController.hasPageName(SELECTED_DISABLED))
                    {
                        this.setState(SELECTED_DISABLED);
                    }
                    else
                    {
                        this.setState(DISABLED);
                    }
                }
                else if (this._selected)
                {
                    this.setState(DOWN);
                }
                else
                {
                    this.setState(UP);
                }
                return true;
            }
            else
            {
                return false;
            }
        }// end function

        protected function setCurrentState() : void
        {
            if (_owner.grayed && this._buttonController && this._buttonController.hasPageName(DISABLED))
            {
                if (this._selected)
                {
                    this.setState(SELECTED_DISABLED);
                }
                else
                {
                    this.setState(DISABLED);
                }
            }
            else if (this._selected)
            {
                this.setState(this._over ? (SELECTED_OVER) : (DOWN));
            }
            else
            {
                this.setState(this._over ? (OVER) : (UP));
            }
            return;
        }// end function

        override public function handleControllerChanged(param1:FController) : void
        {
            super.handleControllerChanged(param1);
            if (this._controller == param1 && !this._controllerFlag)
            {
                this._controllerFlag = true;
                this.selected = this._page == param1.selectedPageId;
                this._controllerFlag = false;
            }
            return;
        }// end function

        override public function create() : void
        {
            if ((_owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                _owner.displayObject.addEventListener(MouseEvent.ROLL_OVER, this.__rollover);
                _owner.displayObject.addEventListener(MouseEvent.ROLL_OUT, this.__rollout);
                _owner.displayObject.addEventListener(MouseEvent.MOUSE_DOWN, this.__mousedown);
                _owner.addEventListener(GTouchEvent.CLICK, this.__click);
            }
            this._buttonController = _owner.getController("button");
            this._titleObject = owner.getChild("title");
            this._iconObject = owner.getChild("icon");
            if (this._titleObject)
            {
                if (this._titleObject is FTextField)
                {
                    this._originColor = FTextField(this._titleObject).color;
                    this._originFontSize = FTextField(this._titleObject).fontSize;
                }
                else if (this._titleObject is FComponent)
                {
                    if (FComponent(this._titleObject).extentionId == "Label")
                    {
                        this._originColor = FLabel(FComponent(this._titleObject).extention).titleColor;
                        this._originFontSize = FLabel(FComponent(this._titleObject).extention).titleFontSize;
                    }
                    else if (FComponent(this._titleObject).extentionId == "Button")
                    {
                        this._originColor = FButton(FComponent(this._titleObject).extention).titleColor;
                        this._originFontSize = FButton(FComponent(this._titleObject).extention).titleFontSize;
                    }
                }
            }
            if (!this._titleColorSet)
            {
                this._titleColor = this._originColor;
            }
            if (!this._titleFontSizeSet)
            {
                this._titleFontSize = this._originFontSize;
            }
            this.setState(UP);
            if (_owner.grayed)
            {
                _owner.handleGrayedChanged();
            }
            return;
        }// end function

        override public function dispose() : void
        {
            if ((_owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                _owner.displayObject.removeEventListener(MouseEvent.ROLL_OVER, this.__rollover);
                _owner.displayObject.removeEventListener(MouseEvent.ROLL_OUT, this.__rollout);
                _owner.displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, this.__mousedown);
                _owner.removeEventListener(GTouchEvent.CLICK, this.__click);
            }
            return;
        }// end function

        override public function getProp(param1:int)
        {
            var _loc_2:* = null;
            switch(param1)
            {
                case ObjectPropID.Color:
                {
                    return this.titleColor;
                }
                case ObjectPropID.OutlineColor:
                {
                    _loc_2 = this.getTextField();
                    if (_loc_2)
                    {
                        return _loc_2.strokeColor;
                    }
                    return 0;
                }
                case ObjectPropID.FontSize:
                {
                    return this.titleFontSize;
                }
                case ObjectPropID.Selected:
                {
                    return this.selected;
                }
                default:
                {
                    return super.getProp(param1);
                    break;
                }
            }
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            var _loc_3:* = null;
            switch(param1)
            {
                case ObjectPropID.Color:
                {
                    this.titleColor = param2;
                    break;
                }
                case ObjectPropID.OutlineColor:
                {
                    _loc_3 = this.getTextField();
                    if (_loc_3)
                    {
                        _loc_3.strokeColor = param2;
                    }
                    break;
                }
                case ObjectPropID.FontSize:
                {
                    this.titleFontSize = param2;
                    break;
                }
                case ObjectPropID.Selected:
                {
                    this.selected = param2;
                    break;
                }
                default:
                {
                    super.setProp(param1, param2);
                    break;
                    break;
                }
            }
            return;
        }// end function

        override public function read_editMode(param1:XData) : void
        {
            var _loc_2:* = null;
            this._mode = param1.getAttribute("mode", COMMON);
            this._sound = param1.getAttribute("sound");
            this._volume = param1.getAttributeInt("volume", 100);
            this._downEffect = param1.getAttribute("downEffect", "none");
            if (this._downEffect == "scale" && _owner.pivotX == 0 && _owner.pivotY == 0)
            {
                _owner.setPivot(0.5, 0.5, _owner.anchor);
            }
            this._downEffectValue = param1.getAttributeFloat("downEffectValue", 0.8);
            return;
        }// end function

        override public function write_editMode() : XData
        {
            var _loc_1:* = XData.create("Button");
            if (this._mode != COMMON)
            {
                _loc_1.setAttribute("mode", this._mode);
            }
            if (this._sound)
            {
                _loc_1.setAttribute("sound", this._sound);
            }
            if (this._volume != 0 && this._volume != 100)
            {
                _loc_1.setAttribute("volume", this._volume);
            }
            if (this._downEffect && this._downEffect != "none")
            {
                _loc_1.setAttribute("downEffect", this._downEffect);
                _loc_1.setAttribute("downEffectValue", this._downEffectValue.toFixed(2));
            }
            return _loc_1;
        }// end function

        override public function read(param1:XData, param2:Object) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = undefined;
            this.selected = param1.getAttributeBool("checked");
            _loc_3 = param1.getAttribute("title");
            if (param2)
            {
                _loc_4 = param2[_owner.id];
                if (_loc_4 != undefined)
                {
                    _loc_3 = _loc_4;
                }
            }
            if (_loc_3)
            {
                this.title = _loc_3;
            }
            _loc_3 = param1.getAttribute("icon");
            if (_loc_3)
            {
                this.icon = _loc_3;
            }
            _loc_3 = param1.getAttribute("selectedTitle");
            if (param2)
            {
                _loc_4 = param2[_owner.id + "-0"];
                if (_loc_4 != undefined)
                {
                    _loc_3 = _loc_4;
                }
            }
            if (_loc_3)
            {
                this.selectedTitle = _loc_3;
            }
            _loc_3 = param1.getAttribute("selectedIcon");
            if (_loc_3)
            {
                this.selectedIcon = _loc_3;
            }
            _loc_3 = param1.getAttribute("titleColor");
            if (_loc_3)
            {
                this.titleColor = UtilsStr.convertFromHtmlColor(_loc_3);
                this._titleColorSet = true;
            }
            _loc_3 = param1.getAttribute("titleFontSize");
            if (_loc_3)
            {
                this.titleFontSize = parseInt(_loc_3);
                this._titleFontSizeSet = true;
            }
            _loc_3 = param1.getAttribute("controller");
            if (_loc_3)
            {
                this._controller = _owner._parent.getController(_loc_3);
            }
            else
            {
                this._controller = null;
            }
            this._page = param1.getAttribute("page");
            _loc_3 = param1.getAttribute("sound");
            if (_loc_3 != null)
            {
                this._sound = _loc_3;
                this._soundSet = true;
            }
            else
            {
                this._soundSet = false;
            }
            _loc_3 = param1.getAttribute("volume");
            if (_loc_3)
            {
                this._volume = parseInt(_loc_3);
                this._soundVolumeSet = true;
            }
            else
            {
                this._soundVolumeSet = false;
            }
            return;
        }// end function

        override public function write() : XData
        {
            var _loc_1:* = XData.create("Button");
            if (this._selected)
            {
                _loc_1.setAttribute("checked", true);
            }
            if (this._title)
            {
                _loc_1.setAttribute("title", this._title);
            }
            if (this._titleColorSet)
            {
                _loc_1.setAttribute("titleColor", UtilsStr.convertToHtmlColor(this._titleColor));
            }
            if (this._titleFontSizeSet)
            {
                _loc_1.setAttribute("titleFontSize", this._titleFontSize);
            }
            if (this._icon)
            {
                _loc_1.setAttribute("icon", this._icon);
            }
            if (this._selectedTitle)
            {
                _loc_1.setAttribute("selectedTitle", this._selectedTitle);
            }
            if (this._selectedIcon)
            {
                _loc_1.setAttribute("selectedIcon", this._selectedIcon);
            }
            if (this._soundSet)
            {
                _loc_1.setAttribute("sound", this._sound);
            }
            if (this._soundVolumeSet)
            {
                _loc_1.setAttribute("volume", this._volume);
            }
            var _loc_2:* = this._controller && this._controller.parent ? (this._controller.name) : (null);
            if (_loc_2)
            {
                _loc_1.setAttribute("controller", _loc_2);
                if (this._page)
                {
                    _loc_1.setAttribute("page", this._page);
                }
            }
            if (_loc_1.hasAttributes())
            {
                return _loc_1;
            }
            return null;
        }// end function

        private function __rollover(event:Event) : void
        {
            if (!this._buttonController || !this._buttonController.hasPageName(OVER))
            {
                return;
            }
            this._over = true;
            if (this._down || _owner.grayed && this._buttonController.hasPageName(DISABLED))
            {
                return;
            }
            this.setState(this._selected ? (SELECTED_OVER) : (OVER));
            return;
        }// end function

        private function __rollout(event:Event) : void
        {
            if (!this._buttonController || !this._buttonController.hasPageName(OVER))
            {
                return;
            }
            this._over = false;
            if (this._down || _owner.grayed && this._buttonController.hasPageName(DISABLED))
            {
                return;
            }
            this.setState(this._selected ? (DOWN) : (UP));
            return;
        }// end function

        private function __mousedown(event:MouseEvent) : void
        {
            this._down = true;
            _owner.displayObject.stage.addEventListener(MouseEvent.MOUSE_UP, this.__mouseup);
            if (this._mode == COMMON)
            {
                if (_owner.grayed && this._buttonController && this._buttonController.hasPageName(DISABLED))
                {
                    this.setState(SELECTED_DISABLED);
                }
                else
                {
                    this.setState(DOWN);
                }
            }
            return;
        }// end function

        private function __mouseup(event:MouseEvent) : void
        {
            if (this._down)
            {
                event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, this.__mouseup);
                this._down = false;
                if (this._mode == COMMON)
                {
                    if (_owner.grayed && this._buttonController && this._buttonController.hasPageName(DISABLED))
                    {
                        this.setState(DISABLED);
                    }
                    else if (this._over)
                    {
                        this.setState(OVER);
                    }
                    else
                    {
                        this.setState(UP);
                    }
                    if (this._controller)
                    {
                        this._controller.selectedPageId = this._page;
                    }
                }
                else if (!this._over && this._buttonController && (this._buttonController.selectedPage == OVER || this._buttonController.selectedPage == SELECTED_OVER))
                {
                    this.setCurrentState();
                }
            }
            return;
        }// end function

        private function __click(event:GTouchEvent) : void
        {
            var _loc_2:* = null;
            if ((_owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                _loc_2 = this._sound;
                if (!_loc_2)
                {
                    _loc_2 = _owner._pkg.project.getSetting("common", "buttonClickSound");
                }
                if (_loc_2)
                {
                    _owner._pkg.project.playSound(_loc_2, this._volume / 100);
                }
            }
            if (this._mode == COMMON)
            {
                if (this._controller)
                {
                    this._controller.selectedPageId = this._page;
                }
            }
            else if (this._mode == CHECK)
            {
                if (this.changeStageOnClick)
                {
                    this.selected = !this._selected;
                }
            }
            else if (this.changeStageOnClick && !this._selected)
            {
                this.selected = true;
            }
            return;
        }// end function

    }
}
