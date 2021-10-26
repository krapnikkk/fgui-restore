package fairygui.editor.gui
{
    import *.*;
    import fairygui.*;
    import fairygui.utils.*;
    import flash.events.*;

    public class FComboBox extends ComExtention
    {
        private var _title:String;
        private var _icon:String;
        private var _titleColor:uint;
        private var _titleColorSet:Boolean;
        private var _originColor:uint;
        private var _dropdown:String;
        private var _items:Array;
        private var _visibleItemCount:int;
        private var _direction:String;
        private var _selectionController:FController;
        private var _buttonController:FController;
        private var _titleObject:FObject;
        private var _iconObject:FObject;
        private var _dropdownObject:FComponent;
        private var _list:FList;
        private var _itemsUpdated:Boolean;
        private var _controllerFlag:Boolean;
        private var _down:Boolean;
        private var _over:Boolean;
        public var clearOnPublish:Boolean;

        public function FComboBox()
        {
            this._title = "";
            this._items = [];
            this._itemsUpdated = true;
            this._visibleItemCount = 10;
            this._direction = "auto";
            return;
        }// end function

        override public function get title() : String
        {
            return this._title;
        }// end function

        override public function set title(param1:String) : void
        {
            this._title = param1;
            if (this._titleObject)
            {
                this._titleObject.text = this._title;
            }
            _owner.updateGear(6);
            return;
        }// end function

        override public function get icon() : String
        {
            return this._icon;
        }// end function

        override public function set icon(param1:String) : void
        {
            this._icon = param1;
            if (this._iconObject)
            {
                this._iconObject.icon = param1;
            }
            _owner.updateGear(7);
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

        public function get dropdown() : String
        {
            return this._dropdown;
        }// end function

        public function set dropdown(param1:String) : void
        {
            this._dropdown = param1;
            return;
        }// end function

        public function get visibleItemCount() : int
        {
            return this._visibleItemCount;
        }// end function

        public function set visibleItemCount(param1:int) : void
        {
            this._visibleItemCount = param1;
            this._itemsUpdated = true;
            return;
        }// end function

        public function get direction() : String
        {
            return this._direction;
        }// end function

        public function set direction(param1:String) : void
        {
            this._direction = param1;
            return;
        }// end function

        public function get items() : Array
        {
            return this._items;
        }// end function

        public function set items(param1:Array) : void
        {
            this._items = param1;
            this._itemsUpdated = true;
            return;
        }// end function

        public function set selectedIndex(param1:int) : void
        {
            if (param1 < this._items.length)
            {
                this.title = this._items[param1][0];
                this.icon = this._items[param1][2];
            }
            return;
        }// end function

        private function setState(param1:String) : void
        {
            if (this._buttonController)
            {
                this._buttonController.selectedPage = param1;
            }
            return;
        }// end function

        public function get selectionController() : String
        {
            if (this._selectionController && this._selectionController.parent)
            {
                return this._selectionController.name;
            }
            return null;
        }// end function

        public function set selectionController(param1:String) : void
        {
            var _loc_2:* = null;
            if (param1)
            {
                _loc_2 = owner._parent.getController(param1);
            }
            this._selectionController = _loc_2;
            return;
        }// end function

        public function get selectionControllerObj() : FController
        {
            return this._selectionController;
        }// end function

        override public function handleControllerChanged(param1:FController) : void
        {
            super.handleControllerChanged(param1);
            if (this._selectionController == param1 && !this._controllerFlag)
            {
                this._controllerFlag = true;
                this.selectedIndex = param1.selectedIndex;
                this._controllerFlag = false;
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
                    _loc_2 = this.getTextField();
                    if (_loc_2)
                    {
                        return _loc_2.fontSize;
                    }
                    return 0;
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
                    _loc_3 = this.getTextField();
                    if (_loc_3)
                    {
                        _loc_3.fontSize = param2;
                    }
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

        override public function create() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            if ((_owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                _owner.displayObject.addEventListener(MouseEvent.ROLL_OVER, this.__rollover);
                _owner.displayObject.addEventListener(MouseEvent.ROLL_OUT, this.__rollout);
                _owner.displayObject.addEventListener(MouseEvent.MOUSE_DOWN, this.__mousedown);
            }
            this._buttonController = _owner.getController("button");
            this._titleObject = owner.getChild("title");
            this._iconObject = owner.getChild("icon");
            if (this._titleObject)
            {
                if (this._titleObject is FTextField)
                {
                    this._originColor = FTextField(this._titleObject).color;
                }
                else if (this._titleObject is FComponent)
                {
                    if (FComponent(this._titleObject).extentionId == "Label")
                    {
                        this._originColor = FLabel(FComponent(this._titleObject).extention).titleColor;
                    }
                    else if (FComponent(this._titleObject).extentionId == "Button")
                    {
                        this._originColor = FButton(FComponent(this._titleObject).extention).titleColor;
                    }
                }
            }
            this._list = null;
            if (this._dropdown && (_owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                _loc_1 = this.owner._pkg.project.getItemByURL(this._dropdown);
                if (_loc_1 != null)
                {
                    _loc_2 = FObjectFactory.createObject(_loc_1, _owner._flags & 255);
                    if (_loc_2 is FComponent)
                    {
                        this._dropdownObject = FComponent(_loc_2);
                        this._list = FList(this._dropdownObject.getChild("list"));
                        if (this._list != null)
                        {
                            this._list.addEventListener(FItemEvent.CLICK, this.__clickItem);
                            this._list.relations.addItem2(this._dropdownObject, "width-width");
                            this._dropdownObject.relations.addItem2(this._list, "height-height");
                            this._dropdownObject.displayObject.addEventListener(Event.REMOVED_FROM_STAGE, this.__popupWinClosed);
                        }
                    }
                    else
                    {
                        _loc_2.dispose();
                    }
                }
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
            }
            return;
        }// end function

        override public function read_editMode(param1:XData) : void
        {
            this._dropdown = param1.getAttribute("dropdown");
            return;
        }// end function

        override public function write_editMode() : XData
        {
            var _loc_1:* = XData.create("ComboBox");
            if (this._dropdown)
            {
                _loc_1.setAttribute("dropdown", this._dropdown);
            }
            return _loc_1;
        }// end function

        override public function read(param1:XData, param2:Object) : void
        {
            var _loc_3:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = undefined;
            _loc_3 = param1.getAttribute("titleColor");
            if (_loc_3)
            {
                this.titleColor = UtilsStr.convertFromHtmlColor(_loc_3);
                this._titleColorSet = true;
            }
            this._visibleItemCount = param1.getAttributeInt("visibleItemCount", 10);
            this._direction = param1.getAttribute("direction", "auto");
            var _loc_4:* = param1.getEnumerator("item");
            var _loc_5:* = [];
            var _loc_6:* = 0;
            while (_loc_4.moveNext())
            {
                
                _loc_7 = _loc_4.current;
                _loc_8 = [_loc_7.getAttribute("title", ""), _loc_7.getAttribute("value", ""), _loc_7.getAttribute("icon", "")];
                _loc_5.push(_loc_8);
                if (param2)
                {
                    _loc_9 = param2[_owner.id + "-" + _loc_6];
                    if (_loc_9 != undefined)
                    {
                        _loc_8[0] = _loc_9;
                    }
                }
                _loc_6++;
            }
            this.items = _loc_5;
            _loc_3 = param1.getAttribute("title");
            if (param2)
            {
                _loc_9 = param2[_owner.id];
                if (_loc_9 != undefined)
                {
                    _loc_3 = _loc_9;
                }
            }
            if ((_owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                if (_loc_3)
                {
                    this.title = _loc_3;
                }
                else if (_loc_5.length > 0)
                {
                    this.title = _loc_5[0][0];
                }
            }
            else if (_loc_3)
            {
                this.title = _loc_3;
            }
            _loc_3 = param1.getAttribute("icon");
            if ((_owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                if (_loc_3)
                {
                    this.icon = _loc_3;
                }
                else if (_loc_5.length > 0)
                {
                    this.icon = _loc_5[0][2];
                }
            }
            else if (_loc_3)
            {
                this.icon = _loc_3;
            }
            _loc_3 = param1.getAttribute("selectionController");
            if (_loc_3)
            {
                this._selectionController = owner._parent.getController(_loc_3);
            }
            else
            {
                this._selectionController = null;
            }
            this.clearOnPublish = param1.getAttributeBool("autoClearItems");
            return;
        }// end function

        override public function write() : XData
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = XData.create("ComboBox");
            if (this._title)
            {
                _loc_1.setAttribute("title", this._title);
            }
            if (this._icon)
            {
                _loc_1.setAttribute("icon", this._icon);
            }
            if (this._titleColorSet)
            {
                _loc_1.setAttribute("titleColor", UtilsStr.convertToHtmlColor(this._titleColor));
            }
            if (this._visibleItemCount)
            {
                _loc_1.setAttribute("visibleItemCount", this._visibleItemCount);
            }
            if (this._direction != "auto")
            {
                _loc_1.setAttribute("direction", this._direction);
            }
            if (this._selectionController && this._selectionController.parent)
            {
                _loc_1.setAttribute("selectionController", this._selectionController.name);
            }
            if (this.clearOnPublish)
            {
                _loc_1.setAttribute("autoClearItems", this.clearOnPublish);
            }
            if (this._items.length)
            {
                for each (_loc_2 in this._items)
                {
                    
                    _loc_3 = XData.create("item");
                    if (_loc_2[0])
                    {
                        _loc_3.setAttribute("title", _loc_2[0]);
                    }
                    if (_loc_2[1])
                    {
                        _loc_3.setAttribute("value", _loc_2[1]);
                    }
                    if (_loc_2[2])
                    {
                        _loc_3.setAttribute("icon", _loc_2[2]);
                    }
                    _loc_1.appendChild(_loc_3);
                }
            }
            if (_loc_1.hasAttributes() || _loc_5.length > 0)
            {
                return _loc_1;
            }
            return null;
        }// end function

        private function __rollover(event:Event) : void
        {
            this._over = true;
            if (this._down || this._dropdownObject && this._dropdownObject.displayObject.parent)
            {
                return;
            }
            this.setState(FButton.OVER);
            return;
        }// end function

        private function __rollout(event:Event) : void
        {
            this._over = false;
            if (this._down || this._dropdownObject && this._dropdownObject.displayObject.parent)
            {
                return;
            }
            this.setState(FButton.UP);
            return;
        }// end function

        private function __mousedown(event:MouseEvent) : void
        {
            this._down = true;
            _owner.displayObject.stage.addEventListener(MouseEvent.MOUSE_UP, this.__mouseup);
            this.setState(FButton.DOWN);
            if (this._dropdownObject)
            {
                this.showDropdown();
            }
            return;
        }// end function

        private function __mouseup(event:MouseEvent) : void
        {
            if (this._dropdownObject && !this._dropdownObject.displayObject.parent)
            {
                owner.editor.groot.nativeStage.removeEventListener(MouseEvent.MOUSE_UP, this.__mouseup);
                this._down = false;
                if (this._over)
                {
                    this.setState(FButton.OVER);
                }
                else
                {
                    this.setState(FButton.UP);
                }
            }
            return;
        }// end function

        protected function showDropdown() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = null;
            if (this._itemsUpdated)
            {
                this._itemsUpdated = false;
                this._list.removeChildren();
                _loc_1 = this._items.length;
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    _loc_3 = this._list.addItem(this._list.defaultItem);
                    if (_loc_3 is FComponent && FComponent(_loc_3).extention is FButton)
                    {
                        FButton(FComponent(_loc_3).extention).title = this._items[_loc_2][0];
                        FButton(FComponent(_loc_3).extention).icon = this._items[_loc_2][2];
                    }
                    _loc_2++;
                }
                this._list.resizeToFit(this._visibleItemCount, 10);
            }
            this._list.clearSelection();
            this._dropdownObject.width = this.owner.width;
            this._list.ensureBoundsCorrect();
            this.setState(GButton.DOWN);
            _owner.editor.testView.togglePopup(this._dropdownObject, this.owner, this._direction);
            return;
        }// end function

        private function __popupWinClosed(event:Event) : void
        {
            if (this._over)
            {
                this.setState(GButton.OVER);
            }
            else
            {
                this.setState(GButton.UP);
            }
            return;
        }// end function

        private function __clickItem(event:FItemEvent) : void
        {
            _owner.editor.testView.hidePopup();
            var _loc_2:* = this._list.getChildIndex(event.itemObject);
            this.selectedIndex = _loc_2;
            if (this._selectionController && _loc_2 < this._selectionController.pageCount && !this._controllerFlag)
            {
                this._controllerFlag = true;
                this._selectionController.selectedIndex = _loc_2;
                this._controllerFlag = false;
            }
            return;
        }// end function

    }
}
