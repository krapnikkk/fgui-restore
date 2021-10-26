package fairygui
{
    import *.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.text.*;

    public class GComboBox extends GComponent
    {
        public var dropdown:GComponent;
        protected var _titleObject:GObject;
        protected var _iconObject:GObject;
        protected var _list:GList;
        protected var _items:Array;
        protected var _icons:Array;
        protected var _values:Array;
        protected var _popupDownward:Object;
        private var _visibleItemCount:int;
        private var _itemsUpdated:Boolean;
        private var _selectedIndex:int;
        private var _buttonController:Controller;
        private var _over:Boolean;
        private var _selectionController:Controller;

        public function GComboBox()
        {
            _visibleItemCount = UIConfig.defaultComboBoxVisibleItemCount;
            _itemsUpdated = true;
            _selectedIndex = -1;
            _items = [];
            _values = [];
            _popupDownward = null;
            return;
        }// end function

        final override public function get text() : String
        {
            if (_titleObject)
            {
                return _titleObject.text;
            }
            return null;
        }// end function

        override public function set text(param1:String) : void
        {
            if (_titleObject)
            {
                _titleObject.text = param1;
            }
            updateGear(6);
            return;
        }// end function

        final public function get titleColor() : uint
        {
            if (_titleObject is GTextField)
            {
                return this.GTextField(_titleObject).color;
            }
            if (_titleObject is GLabel)
            {
                return this.GLabel(_titleObject).titleColor;
            }
            if (_titleObject is GButton)
            {
                return this.GButton(_titleObject).titleColor;
            }
            return 0;
        }// end function

        public function set titleColor(param1:uint) : void
        {
            if (_titleObject is GTextField)
            {
                this.GTextField(_titleObject).color = param1;
            }
            else if (_titleObject is GLabel)
            {
                this.GLabel(_titleObject).titleColor = param1;
            }
            else if (_titleObject is GButton)
            {
                this.GButton(_titleObject).titleColor = param1;
            }
            return;
        }// end function

        final override public function get icon() : String
        {
            if (_iconObject)
            {
                return _iconObject.icon;
            }
            return null;
        }// end function

        override public function set icon(param1:String) : void
        {
            if (_iconObject)
            {
                _iconObject.icon = param1;
            }
            updateGear(7);
            return;
        }// end function

        final public function get visibleItemCount() : int
        {
            return _visibleItemCount;
        }// end function

        public function set visibleItemCount(param1:int) : void
        {
            _visibleItemCount = param1;
            return;
        }// end function

        public function get popupDownward() : Object
        {
            return _popupDownward;
        }// end function

        public function set popupDownward(param1:Object) : void
        {
            _popupDownward = param1;
            return;
        }// end function

        final public function get items() : Array
        {
            return _items;
        }// end function

        public function set items(param1:Array) : void
        {
            if (!param1)
            {
                _items.length = 0;
            }
            else
            {
                _items = param1.concat();
            }
            if (_items.length > 0)
            {
                if (_selectedIndex >= _items.length)
                {
                    _selectedIndex = _items.length - 1;
                }
                else if (_selectedIndex == -1)
                {
                    _selectedIndex = 0;
                }
                this.text = _items[_selectedIndex];
                if (_icons != null && _selectedIndex < _icons.length)
                {
                    this.icon = _icons[_selectedIndex];
                }
            }
            else
            {
                this.text = "";
                if (_icons != null)
                {
                    this.icon = null;
                }
                _selectedIndex = -1;
            }
            _itemsUpdated = true;
            return;
        }// end function

        final public function get icons() : Array
        {
            return _icons;
        }// end function

        public function set icons(param1:Array) : void
        {
            _icons = param1;
            if (_icons != null && _selectedIndex != -1 && _selectedIndex < _icons.length)
            {
                this.icon = _icons[_selectedIndex];
            }
            return;
        }// end function

        final public function get values() : Array
        {
            return _values;
        }// end function

        public function set values(param1:Array) : void
        {
            if (!param1)
            {
                _values.length = 0;
            }
            else
            {
                _values = param1.concat();
            }
            return;
        }// end function

        final public function get selectedIndex() : int
        {
            return _selectedIndex;
        }// end function

        public function set selectedIndex(param1:int) : void
        {
            if (_selectedIndex == param1)
            {
                return;
            }
            _selectedIndex = param1;
            if (_selectedIndex >= 0 && _selectedIndex < _items.length)
            {
                this.text = _items[_selectedIndex];
                if (_icons != null && _selectedIndex < _icons.length)
                {
                    this.icon = _icons[_selectedIndex];
                }
            }
            else
            {
                this.text = "";
                if (_icons != null)
                {
                    this.icon = null;
                }
            }
            updateSelectionController();
            return;
        }// end function

        public function get value() : String
        {
            return _values[_selectedIndex];
        }// end function

        public function set value(param1:String) : void
        {
            var _loc_2:* = _values.indexOf(param1);
            if (_loc_2 == -1 && param1 == null)
            {
                _loc_2 = _values.indexOf("");
            }
            if (_loc_2 == -1)
            {
                _loc_2 = 0;
            }
            this.selectedIndex = _loc_2;
            return;
        }// end function

        public function get selectionController() : Controller
        {
            return _selectionController;
        }// end function

        public function set selectionController(param1:Controller) : void
        {
            _selectionController = param1;
            return;
        }// end function

        protected function setState(param1:String) : void
        {
            if (_buttonController)
            {
                _buttonController.selectedPage = param1;
            }
            return;
        }// end function

        protected function setCurrentState() : void
        {
            if (this.grayed && _buttonController && _buttonController.hasPage("disabled"))
            {
                setState("disabled");
            }
            else
            {
                setState(_over ? ("over") : ("up"));
            }
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

        override protected function handleGrayedChanged() : void
        {
            if (_buttonController && _buttonController.hasPage("disabled"))
            {
                if (this.grayed)
                {
                    setState("disabled");
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

        override public function handleControllerChanged(param1:Controller) : void
        {
            super.handleControllerChanged(param1);
            if (_selectionController == param1)
            {
                this.selectedIndex = param1.selectedIndex;
            }
            return;
        }// end function

        private function updateSelectionController() : void
        {
            var _loc_1:* = null;
            if (_selectionController != null && !_selectionController.changing && _selectedIndex < _selectionController.pageCount)
            {
                _loc_1 = _selectionController;
                _selectionController = null;
                _loc_1.selectedIndex = _selectedIndex;
                _selectionController = _loc_1;
            }
            return;
        }// end function

        override public function dispose() : void
        {
            if (dropdown)
            {
                dropdown.dispose();
                dropdown = null;
            }
            super.dispose();
            return;
        }// end function

        override public function getProp(param1:int)
        {
            var _loc_2:* = null;
            switch(param1 - 2) branch count is:<6>[26, 31, 79, 79, 79, 79, 55] default offset is:<79>;
            return this.titleColor;
            _loc_2 = getTextField();
            if (_loc_2)
            {
                return _loc_2.strokeColor;
            }
            return 0;
            _loc_2 = getTextField();
            if (_loc_2)
            {
                return _loc_2.fontSize;
            }
            return 0;
            return super.getProp(param1);
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            var _loc_3:* = null;
            switch(param1 - 2) branch count is:<6>[26, 35, 85, 85, 85, 85, 60] default offset is:<85>;
            this.titleColor = param2;
            ;
            _loc_3 = getTextField();
            if (_loc_3)
            {
                _loc_3.strokeColor = param2;
            }
            ;
            _loc_3 = getTextField();
            if (_loc_3)
            {
                _loc_3.fontSize = param2;
            }
            ;
            super.setProp(param1, param2);
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            var _loc_2:* = null;
            super.constructFromXML(param1);
            param1 = param1.ComboBox[0];
            _buttonController = getController("button");
            _titleObject = getChild("title");
            _iconObject = getChild("icon");
            _loc_2 = param1.@dropdown;
            if (_loc_2)
            {
                dropdown = UIPackage.createObjectFromURL(_loc_2) as GComponent;
                if (!dropdown)
                {
                    return;
                }
                _list = dropdown.getChild("list").asList;
                if (_list == null)
                {
                    return;
                }
                _list.addEventListener("itemClick", __clickItem);
                _list.addRelation(dropdown, 14);
                _list.removeRelation(dropdown, 15);
                dropdown.addRelation(_list, 15);
                dropdown.removeRelation(_list, 14);
                dropdown.displayObject.addEventListener("removedFromStage", __popupWinClosed);
            }
            this.opaque = true;
            if (!GRoot.touchScreen)
            {
                displayObject.addEventListener("rollOver", __rollover);
                displayObject.addEventListener("rollOut", __rollout);
            }
            this.addEventListener("beginGTouch", __mousedown);
            this.addEventListener("endGTouch", __mouseup);
            return;
        }// end function

        override public function setup_afterAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            super.setup_afterAdd(param1);
            param1 = param1.ComboBox[0];
            if (param1)
            {
                _loc_2 = param1.@titleColor;
                if (_loc_2)
                {
                    this.titleColor = ToolSet.convertFromHtmlColor(_loc_2);
                }
                _loc_2 = param1.@visibleItemCount;
                if (_loc_2)
                {
                    _visibleItemCount = this.parseInt(_loc_2);
                }
                _loc_3 = param1.item;
                _loc_4 = 0;
                for each (_loc_5 in _loc_3)
                {
                    
                    _items.push(_loc_5.@title);
                    _values.push(_loc_5.@value);
                    _loc_2 = _loc_5.@icon;
                    if (_loc_2)
                    {
                        if (!_icons)
                        {
                            _icons = new Array(_loc_3.length());
                        }
                        _icons[_loc_4] = _loc_2;
                    }
                    _loc_4++;
                }
                _loc_2 = param1.@title;
                if (_loc_2)
                {
                    this.text = _loc_2;
                    _selectedIndex = _items.indexOf(_loc_2);
                }
                else if (_items.length > 0)
                {
                    _selectedIndex = 0;
                    this.text = _items[0];
                }
                else
                {
                    _selectedIndex = -1;
                }
                _loc_2 = param1.@icon;
                if (_loc_2)
                {
                    this.icon = _loc_2;
                }
                _loc_2 = param1.@direction;
                if (_loc_2)
                {
                    if (_loc_2 == "up")
                    {
                        _popupDownward = false;
                    }
                    else if (_loc_2 == "down")
                    {
                        _popupDownward = true;
                    }
                }
                _loc_2 = param1.@selectionController;
                if (_loc_2)
                {
                    _selectionController = parent.getController(_loc_2);
                }
            }
            return;
        }// end function

        protected function showDropdown() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_1:* = null;
            if (_itemsUpdated)
            {
                _itemsUpdated = false;
                _list.removeChildrenToPool();
                _loc_2 = _items.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_1 = _list.addItemFromPool();
                    _loc_1.name = _loc_3 < _values.length ? (_values[_loc_3]) : ("");
                    _loc_1.text = _items[_loc_3];
                    _loc_1.icon = _icons != null && _loc_3 < _icons.length ? (_icons[_loc_3]) : (null);
                    _loc_3++;
                }
                _list.resizeToFit(_visibleItemCount);
            }
            _list.selectedIndex = -1;
            dropdown.width = this.width;
            _list.ensureBoundsCorrect();
            this.root.togglePopup(dropdown, this, _popupDownward);
            if (dropdown.parent)
            {
                setState("down");
            }
            return;
        }// end function

        private function __popupWinClosed(event:Event) : void
        {
            setCurrentState();
            return;
        }// end function

        private function __clickItem(event:ItemEvent) : void
        {
            if (dropdown.parent is GRoot)
            {
                this.GRoot(dropdown.parent).hidePopup(dropdown);
            }
            _selectedIndex = -2147483648;
            this.selectedIndex = _list.getChildIndex(event.itemObject);
            dispatchEvent(new StateChangeEvent("stateChanged"));
            return;
        }// end function

        private function __rollover(event:Event) : void
        {
            _over = true;
            if (this.isDown || dropdown && dropdown.parent)
            {
                return;
            }
            setCurrentState();
            return;
        }// end function

        private function __rollout(event:Event) : void
        {
            _over = false;
            if (this.isDown || dropdown && dropdown.parent)
            {
                return;
            }
            setCurrentState();
            return;
        }// end function

        private function __mousedown(event:GTouchEvent) : void
        {
            if (event.realTarget is TextField && this.TextField(event.realTarget).type == "input")
            {
                return;
            }
            if (dropdown)
            {
                showDropdown();
            }
            return;
        }// end function

        private function __mouseup(event:Event) : void
        {
            if (dropdown && !dropdown.parent)
            {
                setCurrentState();
            }
            return;
        }// end function

    }
}
