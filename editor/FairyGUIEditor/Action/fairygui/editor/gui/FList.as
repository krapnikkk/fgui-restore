package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.event.*;
    import fairygui.utils.*;

    public class FList extends FComponent
    {
        private var _layout:String;
        private var _selectionMode:String;
        private var _lineGap:int;
        private var _columnGap:int;
        private var _items:Vector.<ListItemData>;
        private var _defaultItem:String;
        private var _clipSharpness:Margin;
        private var _autoResizeItem1:Boolean;
        private var _autoResizeItem2:Boolean;
        private var _repeatX:int;
        private var _repeatY:int;
        private var _align:String;
        private var _verticalAlign:String;
        private var _lastSelectedIndex:int;
        private var _selectionController:FController;
        private var _selectionControllerFlag:Boolean;
        private var _treeView:_-BR;
        private var _treeViewEnabled:Boolean;
        private var _indent:int;
        public var clearOnPublish:Boolean;
        public var scrollItemToViewOnClick:Boolean;
        public var foldInvisibleItems:Boolean;
        public var clickToExpand:int;
        public static const SINGLE_COLUMN:String = "column";
        public static const SINGLE_ROW:String = "row";
        public static const FLOW_HZ:String = "flow_hz";
        public static const FLOW_VT:String = "flow_vt";
        public static const PAGINATION:String = "pagination";

        public function FList()
        {
            this._items = new Vector.<ListItemData>;
            this._layout = SINGLE_COLUMN;
            this._selectionMode = "single";
            this._autoResizeItem1 = true;
            this._autoResizeItem2 = false;
            this._align = "left";
            this._verticalAlign = "top";
            this._lastSelectedIndex = -1;
            _useSourceSize = false;
            this.scrollItemToViewOnClick = true;
            this.indent = 15;
            this._objectType = FObjectType.LIST;
            return;
        }// end function

        public function get layout() : String
        {
            return this._layout;
        }// end function

        public function set layout(param1:String) : void
        {
            if (this._layout != param1)
            {
                this._layout = param1;
                this.buildItems();
            }
            return;
        }// end function

        public function get selectionMode() : String
        {
            return this._selectionMode;
        }// end function

        public function set selectionMode(param1:String) : void
        {
            this._selectionMode = param1;
            return;
        }// end function

        public function get lineGap() : int
        {
            return this._lineGap;
        }// end function

        public function set lineGap(param1:int) : void
        {
            if (this._lineGap != param1)
            {
                this._lineGap = param1;
                setBoundsChangedFlag();
            }
            return;
        }// end function

        public function get columnGap() : int
        {
            return this._columnGap;
        }// end function

        public function set columnGap(param1:int) : void
        {
            if (this._columnGap != param1)
            {
                this._columnGap = param1;
                setBoundsChangedFlag();
            }
            return;
        }// end function

        public function get repeatX() : int
        {
            return this._repeatX;
        }// end function

        public function set repeatX(param1:int) : void
        {
            if (this._repeatX != param1)
            {
                if (this._autoResizeItem2 && (this._repeatX == 0 || param1 == 0))
                {
                    this._repeatX = param1;
                    this.buildItems();
                }
                else
                {
                    this._repeatX = param1;
                    setBoundsChangedFlag();
                }
            }
            return;
        }// end function

        public function get repeatY() : int
        {
            return this._repeatY;
        }// end function

        public function set repeatY(param1:int) : void
        {
            if (this._repeatY != param1)
            {
                if (this._autoResizeItem2 && (this._repeatY == 0 || param1 == 0))
                {
                    this._repeatY = param1;
                    this.buildItems();
                }
                else
                {
                    this._repeatY = param1;
                    setBoundsChangedFlag();
                }
            }
            return;
        }// end function

        public function get defaultItem() : String
        {
            return this._defaultItem;
        }// end function

        public function set defaultItem(param1:String) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = false;
            var _loc_4:* = null;
            if (param1)
            {
                _loc_2 = this._defaultItem;
                this._defaultItem = param1;
                _loc_3 = false;
                for each (_loc_4 in this._items)
                {
                    
                    if (_loc_4.url == _loc_2)
                    {
                        _loc_4.url = param1;
                        _loc_3 = true;
                    }
                }
                if (_loc_3)
                {
                    this.buildItems();
                }
            }
            else
            {
                this._defaultItem = param1;
            }
            return;
        }// end function

        public function get autoResizeItem() : Boolean
        {
            if (this._layout == SINGLE_COLUMN || this._layout == SINGLE_ROW)
            {
                return this._autoResizeItem1;
            }
            return this._autoResizeItem2;
        }// end function

        public function set autoResizeItem(param1:Boolean) : void
        {
            if (this._layout == SINGLE_COLUMN || this._layout == SINGLE_ROW)
            {
                if (this._autoResizeItem1 != param1)
                {
                    this._autoResizeItem1 = param1;
                    this.buildItems();
                }
            }
            else if (this._autoResizeItem2 != param1)
            {
                this._autoResizeItem2 = param1;
                this.buildItems();
            }
            return;
        }// end function

        public function get autoResizeItem1() : Boolean
        {
            return this._autoResizeItem1;
        }// end function

        public function set autoResizeItem1(param1:Boolean) : void
        {
            if (this._autoResizeItem1 != param1)
            {
                this._autoResizeItem1 = param1;
                this.buildItems();
            }
            return;
        }// end function

        public function get autoResizeItem2() : Boolean
        {
            return this._autoResizeItem2;
        }// end function

        public function set autoResizeItem2(param1:Boolean) : void
        {
            if (this._autoResizeItem2 != param1)
            {
                this._autoResizeItem2 = param1;
                this.buildItems();
            }
            return;
        }// end function

        public function get treeViewEnabled() : Boolean
        {
            return this._treeViewEnabled;
        }// end function

        public function set treeViewEnabled(param1:Boolean) : void
        {
            if (this._treeViewEnabled != param1)
            {
                this._treeViewEnabled = param1;
                this.buildItems();
            }
            return;
        }// end function

        public function get indent() : int
        {
            return this._indent;
        }// end function

        public function set indent(param1:int) : void
        {
            if (this._indent != param1)
            {
                this._indent = param1;
                if (this._treeView)
                {
                    this._treeView.indent = param1;
                }
            }
            return;
        }// end function

        public function get items() : Vector.<ListItemData>
        {
            return this._items;
        }// end function

        public function set items(param1:Vector.<ListItemData>) : void
        {
            this._items = param1;
            this.buildItems();
            _displayObject.handleSizeChanged();
            return;
        }// end function

        public function get align() : String
        {
            return this._align;
        }// end function

        public function set align(param1:String) : void
        {
            if (this._align != param1)
            {
                this._align = param1;
                this.setBoundsChangedFlag();
            }
            return;
        }// end function

        public function get verticalAlign() : String
        {
            return this._verticalAlign;
        }// end function

        public function set verticalAlign(param1:String) : void
        {
            if (this._verticalAlign != param1)
            {
                this._verticalAlign = param1;
                this.setBoundsChangedFlag();
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
                _loc_2 = _parent.getController(param1);
            }
            this._selectionController = _loc_2;
            return;
        }// end function

        public function get selectionControllerObj() : FController
        {
            return this._selectionController;
        }// end function

        public function get selectedIndex() : int
        {
            var _loc_1:* = 0;
            var _loc_3:* = null;
            var _loc_2:* = _children.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                _loc_3 = _children[_loc_1];
                if (_loc_3.getProp(ObjectPropID.Selected))
                {
                    return _loc_1;
                }
                _loc_1++;
            }
            return -1;
        }// end function

        public function set selectedIndex(param1:int) : void
        {
            if (param1 >= 0 && param1 < this.numChildren)
            {
                if (this._selectionMode != "single")
                {
                    this.clearSelection();
                }
                this.addSelection(param1);
            }
            else
            {
                this.clearSelection();
            }
            return;
        }// end function

        public function getSelection(param1:Vector.<int> = null) : Vector.<int>
        {
            var _loc_2:* = 0;
            var _loc_4:* = null;
            if (param1 == null)
            {
                param1 = new Vector.<int>;
            }
            var _loc_3:* = _children.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = _children[_loc_2];
                if (_loc_4.getProp(ObjectPropID.Selected))
                {
                    param1.push(_loc_2);
                }
                _loc_2++;
            }
            return param1;
        }// end function

        public function addSelection(param1:int, param2:Boolean = false) : void
        {
            if (this._selectionMode == "none")
            {
                return;
            }
            if (this._selectionMode == "single")
            {
                this.clearSelection();
            }
            if (param1 < 0 || param1 >= numChildren)
            {
                return;
            }
            this._lastSelectedIndex = param1;
            var _loc_3:* = getChildAt(param1);
            if (_scrollPane && param2)
            {
                _scrollPane.scrollToView(_loc_3);
            }
            if (!_loc_3.getProp(ObjectPropID.Selected))
            {
                _loc_3.setProp(ObjectPropID.Selected, true);
                this.updateSelectionController(param1);
            }
            return;
        }// end function

        public function removeSelection(param1:int) : void
        {
            if (this._selectionMode == "none")
            {
                return;
            }
            var _loc_2:* = getChildAt(param1);
            _loc_2.setProp(ObjectPropID.Selected, false);
            return;
        }// end function

        public function clearSelection() : void
        {
            var _loc_1:* = 0;
            var _loc_3:* = null;
            var _loc_2:* = _children.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                _loc_3 = _children[_loc_1];
                _loc_3.setProp(ObjectPropID.Selected, false);
                _loc_1++;
            }
            return;
        }// end function

        private function clearSelectionExcept(param1:FObject) : void
        {
            var _loc_2:* = 0;
            var _loc_4:* = null;
            var _loc_3:* = _children.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = _children[_loc_2];
                if (_loc_4 != param1)
                {
                    _loc_4.setProp(ObjectPropID.Selected, false);
                }
                _loc_2++;
            }
            return;
        }// end function

        override public function addChildAt(param1:FObject, param2:int) : FObject
        {
            var _loc_3:* = null;
            super.addChildAt(param1, param2);
            if (param1 is FComponent)
            {
                _loc_3 = FComponent(param1).extention as FButton;
                if (_loc_3 != null)
                {
                    _loc_3.changeStageOnClick = false;
                }
                param1.addEventListener(GTouchEvent.CLICK, this.__clickItem);
            }
            return param1;
        }// end function

        public function addItem(param1:String) : FObject
        {
            return this.addItemAt(param1, numChildren);
        }// end function

        public function addItemAt(param1:String, param2:int) : FObject
        {
            var _loc_3:* = null;
            var _loc_4:* = _pkg.project.getItemByURL(param1);
            if (_pkg.project.getItemByURL(param1) == null)
            {
                _loc_3 = FObjectFactory.createObject2(_pkg, "component", MissingInfo.create2(_pkg, param1), _flags);
            }
            else
            {
                _loc_3 = FObjectFactory.createObject(_loc_4, _flags & 255);
            }
            return this.addChildAt(_loc_3, param2);
        }// end function

        private function __clickItem(event:GTouchEvent) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = FObject(event.currentTarget);
            this.setSelectionOnEvent(_loc_2);
            if (_scrollPane != null)
            {
                _scrollPane.scrollToView(_loc_2, true);
            }
            if (this._treeViewEnabled && this.clickToExpand != 0)
            {
                _loc_3 = _loc_2._treeNode;
                if (_loc_3 && this._treeView._expandedStatusInEvt == _loc_3.expanded)
                {
                    if (this.clickToExpand == 2)
                    {
                        if (event.clickCount == 2)
                        {
                            _loc_3.expanded = !_loc_3.expanded;
                        }
                    }
                    else
                    {
                        _loc_3.expanded = !_loc_3.expanded;
                    }
                }
            }
            this.dispatchEvent(new FItemEvent(FItemEvent.CLICK, _loc_2));
            return;
        }// end function

        private function setSelectionOnEvent(param1:FObject) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = null;
            var _loc_10:* = null;
            if (!(param1 is FComponent) || !(FComponent(param1).extention is FButton) || this._selectionMode == "none")
            {
                return;
            }
            var _loc_2:* = false;
            var _loc_3:* = FComponent(param1).extention as FButton;
            var _loc_4:* = getChildIndex(param1);
            if (this._selectionMode == "single")
            {
                if (!_loc_3.selected)
                {
                    this.clearSelectionExcept(param1);
                    _loc_3.selected = true;
                }
            }
            else
            {
                _loc_5 = _pkg.project.editor.groot;
                if (_loc_5.shiftKeyDown)
                {
                    if (!_loc_3.selected)
                    {
                        if (this._lastSelectedIndex != -1)
                        {
                            _loc_6 = Math.min(this._lastSelectedIndex, _loc_4);
                            _loc_7 = Math.max(this._lastSelectedIndex, _loc_4);
                            _loc_7 = Math.min(_loc_7, (numChildren - 1));
                            _loc_8 = _loc_6;
                            while (_loc_8 <= _loc_7)
                            {
                                
                                _loc_9 = getChildAt(_loc_8) as FComponent;
                                if (_loc_9 == null)
                                {
                                }
                                else
                                {
                                    _loc_10 = _loc_9.extention as FButton;
                                    if (_loc_10 != null && !_loc_10.selected)
                                    {
                                        _loc_10.selected = true;
                                    }
                                }
                                _loc_8++;
                            }
                            _loc_2 = true;
                        }
                        else
                        {
                            _loc_3.selected = true;
                        }
                    }
                }
                else if (_loc_5.ctrlKeyDown || this._selectionMode == "multipleSingleClick")
                {
                    _loc_3.selected = !_loc_3.selected;
                }
                else if (!_loc_3.selected)
                {
                    this.clearSelectionExcept(param1);
                    _loc_3.selected = true;
                }
                else
                {
                    this.clearSelectionExcept(param1);
                }
            }
            if (!_loc_2)
            {
                this._lastSelectedIndex = _loc_4;
            }
            if (_loc_3.selected)
            {
                this.updateSelectionController(_loc_4);
            }
            return;
        }// end function

        public function resizeToFit(param1:int = 2147483647, param2:int = 0) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            ensureBoundsCorrect();
            var _loc_3:* = this.numChildren;
            if (param1 > _loc_3)
            {
                param1 = _loc_3;
            }
            if (param1 == 0)
            {
                if (this._layout == SINGLE_COLUMN || this._layout == FLOW_HZ)
                {
                    this.viewHeight = param2;
                }
                else
                {
                    this.viewWidth = param2;
                }
            }
            else
            {
                _loc_4 = param1 - 1;
                _loc_5 = null;
                while (_loc_4 >= 0)
                {
                    
                    _loc_5 = this.getChildAt(_loc_4);
                    if (_loc_5.visible)
                    {
                        break;
                    }
                    _loc_4 = _loc_4 - 1;
                }
                if (_loc_4 < 0)
                {
                    if (this._layout == SINGLE_COLUMN || this._layout == FLOW_HZ)
                    {
                        this.viewHeight = param2;
                    }
                    else
                    {
                        this.viewWidth = param2;
                    }
                }
                else if (this._layout == SINGLE_COLUMN || this._layout == FLOW_HZ)
                {
                    _loc_6 = _loc_5.y + _loc_5.height;
                    if (_loc_6 < param2)
                    {
                        _loc_6 = param2;
                    }
                    this.viewHeight = _loc_6;
                }
                else
                {
                    _loc_6 = _loc_5.x + _loc_5.width;
                    if (_loc_6 < param2)
                    {
                        _loc_6 = param2;
                    }
                    this.viewWidth = _loc_6;
                }
            }
            return;
        }// end function

        override public function handleSizeChanged() : void
        {
            super.handleSizeChanged();
            setBoundsChangedFlag();
            return;
        }// end function

        override public function handleControllerChanged(param1:FController) : void
        {
            super.handleControllerChanged(param1);
            if (this._selectionController == param1 && !this._selectionControllerFlag)
            {
                this._selectionControllerFlag = true;
                this.selectedIndex = this._selectionController.selectedIndex;
                this._selectionControllerFlag = false;
            }
            return;
        }// end function

        private function updateSelectionController(param1:int) : void
        {
            if (this._selectionController && !this._selectionControllerFlag && param1 < this._selectionController.pageCount)
            {
                this._selectionControllerFlag = true;
                this._selectionController.selectedIndex = param1;
                this._selectionControllerFlag = false;
            }
            return;
        }// end function

        private function buildItems() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            removeChildren(0, -1, true);
            var _loc_1:* = this._items.length;
            if (this._treeViewEnabled)
            {
                if (!this._treeView)
                {
                    this._treeView = new _-BR(this);
                }
                else
                {
                    this._treeView.removeChildren();
                }
                this._treeView.indent = this._indent;
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    _loc_3 = this._items[_loc_2];
                    _loc_6 = new FTreeNode(_loc_2 < (_loc_1 - 1) && this._items[(_loc_2 + 1)].level > _loc_3.level, _loc_3.url);
                    _loc_6.expanded = true;
                    if (_loc_2 == 0)
                    {
                        this._treeView.addChild(_loc_6);
                    }
                    else
                    {
                        _loc_7 = this._items[(_loc_2 - 1)].level;
                        if (_loc_3.level > _loc_7)
                        {
                            _loc_5.addChild(_loc_6);
                        }
                        else if (_loc_3.level < _loc_7)
                        {
                            _loc_8 = _loc_3.level;
                            while (_loc_8 <= _loc_7)
                            {
                                
                                _loc_5 = _loc_5.parent;
                                _loc_8++;
                            }
                            _loc_5.addChild(_loc_6);
                        }
                        else
                        {
                            _loc_5.addChild(_loc_6);
                        }
                    }
                    _loc_5 = _loc_6;
                    if (_loc_6.cell)
                    {
                        this.initItem(_loc_3, _loc_6.cell);
                    }
                    _loc_2++;
                }
            }
            else
            {
                if (this._treeView)
                {
                    this._treeView.removeChildren();
                }
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    _loc_3 = this._items[_loc_2];
                    _loc_4 = this.addItem(_loc_3.url);
                    if (_loc_4)
                    {
                        this.initItem(_loc_3, _loc_4 as FComponent);
                    }
                    _loc_2++;
                }
            }
            return;
        }// end function

        private function initItem(param1:ListItemData, param2:FComponent) : void
        {
            var _loc_5:* = null;
            if (!param2)
            {
                return;
            }
            if (param2.extention is FButton)
            {
                if (param1.title)
                {
                    FButton(param2.extention).title = param1.title;
                }
                if (param1.icon)
                {
                    FButton(param2.extention).icon = param1.icon;
                }
                if (param1.selectedIcon)
                {
                    FButton(param2.extention).selectedIcon = param1.selectedIcon;
                }
                if (param1.selectedTitle)
                {
                    FButton(param2.extention).selectedTitle = param1.selectedTitle;
                }
            }
            else if (FComponent(param2).extention is FLabel)
            {
                if (param1.title)
                {
                    FLabel(param2.extention).title = param1.title;
                }
                if (param1.icon)
                {
                    FLabel(param2.extention).icon = param1.icon;
                }
            }
            var _loc_3:* = param1.properties.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = param1.properties[_loc_4];
                if (param2.getCustomProperty(_loc_5.target, _loc_5.propertyId))
                {
                    param2.applyCustomProperty(_loc_5);
                }
                _loc_4++;
            }
            return;
        }// end function

        override public function validateChildren(param1:Boolean = false) : Boolean
        {
            var _loc_4:* = 0;
            var _loc_2:* = false;
            var _loc_3:* = _children.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (_children[_loc_4].validate(true))
                {
                    _loc_2 = true;
                }
                _loc_4++;
            }
            if (_loc_2 && !param1)
            {
                this.buildItems();
            }
            if (_scrollPane && _scrollPane.validate(param1))
            {
                _loc_2 = true;
            }
            return _loc_2;
        }// end function

        override protected function updateBounds() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_12:* = NaN;
            var _loc_14:* = NaN;
            var _loc_19:* = 0;
            var _loc_20:* = 0;
            var _loc_21:* = 0;
            var _loc_1:* = numChildren;
            var _loc_11:* = 0;
            var _loc_13:* = 1;
            var _loc_15:* = this.viewWidth;
            var _loc_16:* = this.viewHeight;
            if (this._layout == SINGLE_COLUMN)
            {
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    _loc_4 = getChildAt(_loc_2);
                    if (_loc_2 != 0)
                    {
                        _loc_6 = _loc_6 + this._lineGap;
                    }
                    _loc_4.setXY(0, _loc_6);
                    if (this._autoResizeItem1)
                    {
                        _loc_4.setSize(_loc_15, _loc_4.height, true);
                    }
                    _loc_6 = _loc_6 + Math.ceil(_loc_4.height);
                    if (_loc_4.width > _loc_9)
                    {
                        _loc_9 = _loc_4.width;
                    }
                    _loc_2++;
                }
                _loc_8 = _loc_6;
                if (_loc_8 <= _loc_16 && this._autoResizeItem1 && _scrollPane && _scrollPane._displayInDemand && _scrollPane.vtScrollBar)
                {
                    _loc_15 = _loc_15 + _scrollPane.vtScrollBar.owner.width;
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1)
                    {
                        
                        _loc_4 = getChildAt(_loc_2);
                        if (this.foldInvisibleItems && !_loc_4.visible)
                        {
                        }
                        else
                        {
                            _loc_4.setSize(_loc_15, _loc_4.height, true);
                            if (_loc_4.width > _loc_9)
                            {
                                _loc_9 = _loc_4.width;
                            }
                        }
                        _loc_2++;
                    }
                }
                _loc_7 = Math.ceil(_loc_9);
            }
            else if (this._layout == SINGLE_ROW)
            {
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    _loc_4 = getChildAt(_loc_2);
                    if (_loc_2 != 0)
                    {
                        _loc_5 = _loc_5 + this._columnGap;
                    }
                    _loc_4.setXY(_loc_5, 0);
                    if (this._autoResizeItem1)
                    {
                        _loc_4.setSize(_loc_4.width, _loc_16, true);
                    }
                    _loc_5 = _loc_5 + Math.ceil(_loc_4.width);
                    if (_loc_4.height > _loc_10)
                    {
                        _loc_10 = _loc_4.height;
                    }
                    _loc_2++;
                }
                _loc_7 = _loc_5;
                if (_loc_7 <= _loc_15 && this._autoResizeItem1 && _scrollPane && _scrollPane._displayInDemand && _scrollPane.hzScrollBar)
                {
                    _loc_16 = _loc_16 + _scrollPane.hzScrollBar.owner.height;
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1)
                    {
                        
                        _loc_4 = getChildAt(_loc_2);
                        if (this.foldInvisibleItems && !_loc_4.visible)
                        {
                        }
                        else
                        {
                            _loc_4.setSize(_loc_4.width, _loc_16, true);
                            if (_loc_4.height > _loc_10)
                            {
                                _loc_10 = _loc_4.height;
                            }
                        }
                        _loc_2++;
                    }
                }
                _loc_8 = Math.ceil(_loc_10);
            }
            else if (this._layout == FLOW_HZ)
            {
                _loc_3 = 0;
                if (this._autoResizeItem2 && this._repeatX > 0)
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1)
                    {
                        
                        _loc_4 = getChildAt(_loc_2);
                        _loc_11 = _loc_11 + _loc_4.sourceWidth;
                        _loc_3++;
                        if (_loc_3 == this._repeatX || _loc_2 == (_loc_1 - 1))
                        {
                            _loc_5 = 0;
                            _loc_12 = _loc_15 - (_loc_3 - 1) * this._columnGap;
                            _loc_13 = 1;
                            _loc_3 = _loc_2 - _loc_3 + 1;
                            while (_loc_3 <= _loc_2)
                            {
                                
                                _loc_4 = getChildAt(_loc_3);
                                _loc_4.setXY(_loc_5, _loc_6);
                                _loc_14 = _loc_4.sourceWidth / _loc_11;
                                _loc_4.setSize(Math.round(_loc_14 / _loc_13 * _loc_12), _loc_4.height, true);
                                _loc_12 = _loc_12 - _loc_4.width;
                                _loc_13 = _loc_13 - _loc_14;
                                _loc_5 = _loc_5 + (_loc_4.width + this._columnGap);
                                if (_loc_4.height > _loc_10)
                                {
                                    _loc_10 = _loc_4.height;
                                }
                                _loc_3++;
                            }
                            _loc_6 = _loc_6 + (Math.ceil(_loc_10) + this._lineGap);
                            _loc_10 = 0;
                            _loc_3 = 0;
                            _loc_11 = 0;
                        }
                        _loc_2++;
                    }
                    _loc_8 = _loc_6 + Math.ceil(_loc_10);
                    _loc_7 = _loc_15;
                }
                else
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1)
                    {
                        
                        _loc_4 = getChildAt(_loc_2);
                        if (_loc_5 != 0)
                        {
                            _loc_5 = _loc_5 + this._columnGap;
                        }
                        if (this._repeatX != 0 && _loc_3 >= this._repeatX || this._repeatX == 0 && _loc_5 + _loc_4.width > _loc_15 && _loc_10 != 0)
                        {
                            _loc_5 = 0;
                            _loc_6 = _loc_6 + (Math.ceil(_loc_10) + this._lineGap);
                            _loc_10 = 0;
                            _loc_3 = 0;
                        }
                        _loc_4.setXY(_loc_5, _loc_6);
                        _loc_5 = _loc_5 + Math.ceil(_loc_4.width);
                        if (_loc_5 > _loc_9)
                        {
                            _loc_9 = _loc_5;
                        }
                        if (_loc_4.height > _loc_10)
                        {
                            _loc_10 = _loc_4.height;
                        }
                        _loc_3++;
                        _loc_2++;
                    }
                    _loc_8 = _loc_6 + Math.ceil(_loc_10);
                    _loc_7 = Math.ceil(_loc_9);
                }
            }
            else if (this._layout == FLOW_VT)
            {
                _loc_3 = 0;
                if (this._autoResizeItem2 && this._repeatY > 0)
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1)
                    {
                        
                        _loc_4 = getChildAt(_loc_2);
                        _loc_11 = _loc_11 + _loc_4.sourceHeight;
                        _loc_3++;
                        if (_loc_3 == this._repeatY || _loc_2 == (_loc_1 - 1))
                        {
                            _loc_6 = 0;
                            _loc_12 = _loc_16 - (_loc_3 - 1) * this._lineGap;
                            _loc_13 = 1;
                            _loc_3 = _loc_2 - _loc_3 + 1;
                            while (_loc_3 <= _loc_2)
                            {
                                
                                _loc_4 = getChildAt(_loc_3);
                                _loc_4.setXY(_loc_5, _loc_6);
                                _loc_14 = _loc_4.sourceHeight / _loc_11;
                                _loc_4.setSize(_loc_4.width, Math.round(_loc_14 / _loc_13 * _loc_12), true);
                                _loc_12 = _loc_12 - _loc_4.height;
                                _loc_13 = _loc_13 - _loc_14;
                                _loc_6 = _loc_6 + (_loc_4.height + this._lineGap);
                                if (_loc_4.width > _loc_9)
                                {
                                    _loc_9 = _loc_4.width;
                                }
                                _loc_3++;
                            }
                            _loc_5 = _loc_5 + (Math.ceil(_loc_9) + this._columnGap);
                            _loc_9 = 0;
                            _loc_3 = 0;
                            _loc_11 = 0;
                        }
                        _loc_2++;
                    }
                    _loc_7 = _loc_5 + Math.ceil(_loc_9);
                    _loc_8 = _loc_16;
                }
                else
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1)
                    {
                        
                        _loc_4 = getChildAt(_loc_2);
                        if (_loc_6 != 0)
                        {
                            _loc_6 = _loc_6 + this._lineGap;
                        }
                        if (this._repeatY != 0 && _loc_3 >= this._repeatY || this._repeatY == 0 && _loc_6 + _loc_4.height > _loc_16 && _loc_9 != 0)
                        {
                            _loc_6 = 0;
                            _loc_5 = _loc_5 + (Math.ceil(_loc_9) + this._columnGap);
                            _loc_9 = 0;
                            _loc_3 = 0;
                        }
                        _loc_4.setXY(_loc_5, _loc_6);
                        _loc_6 = _loc_6 + _loc_4.height;
                        if (_loc_6 > _loc_10)
                        {
                            _loc_10 = _loc_6;
                        }
                        if (_loc_4.width > _loc_9)
                        {
                            _loc_9 = _loc_4.width;
                        }
                        _loc_3++;
                        _loc_2++;
                    }
                    _loc_7 = _loc_5 + Math.ceil(_loc_9);
                    _loc_8 = Math.ceil(_loc_10);
                }
            }
            else
            {
                _loc_3 = 0;
                _loc_19 = 0;
                _loc_20 = 0;
                if (this._autoResizeItem2 && this._repeatY > 0)
                {
                    _loc_21 = (_loc_16 - (this._repeatY - 1) * this._lineGap) / this._repeatY;
                }
                if (this._autoResizeItem2 && this._repeatX > 0)
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1)
                    {
                        
                        _loc_4 = getChildAt(_loc_2);
                        if (_loc_3 == 0 && (this._repeatY != 0 && _loc_19 >= this._repeatY || this._repeatY == 0 && _loc_6 + (this._repeatY > 0 ? (_loc_21) : (_loc_4.height)) > _loc_16))
                        {
                            _loc_20++;
                            _loc_6 = 0;
                            _loc_19 = 0;
                        }
                        _loc_11 = _loc_11 + _loc_4.sourceWidth;
                        _loc_3++;
                        if (_loc_3 == this._repeatX || _loc_2 == (_loc_1 - 1))
                        {
                            _loc_5 = 0;
                            _loc_12 = _loc_15 - (_loc_3 - 1) * this._columnGap;
                            _loc_13 = 1;
                            _loc_3 = _loc_2 - _loc_3 + 1;
                            while (_loc_3 <= _loc_2)
                            {
                                
                                _loc_4 = getChildAt(_loc_3);
                                _loc_4.setXY(_loc_20 * _loc_15 + _loc_5, _loc_6);
                                _loc_14 = _loc_4.sourceWidth / _loc_11;
                                _loc_4.setSize(Math.round(_loc_14 / _loc_13 * _loc_12), this._repeatY > 0 ? (_loc_21) : (_loc_4.height), true);
                                _loc_12 = _loc_12 - _loc_4.width;
                                _loc_13 = _loc_13 - _loc_14;
                                _loc_5 = _loc_5 + (_loc_4.width + this._columnGap);
                                if (_loc_4.height > _loc_10)
                                {
                                    _loc_10 = _loc_4.height;
                                }
                                _loc_3++;
                            }
                            _loc_6 = _loc_6 + (Math.ceil(_loc_10) + this._lineGap);
                            _loc_10 = 0;
                            _loc_3 = 0;
                            _loc_11 = 0;
                            _loc_19++;
                        }
                        _loc_2++;
                    }
                }
                else
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1)
                    {
                        
                        _loc_4 = getChildAt(_loc_2);
                        if (_loc_3 != 0)
                        {
                            _loc_5 = _loc_5 + this._columnGap;
                        }
                        if (this._repeatX != 0 && _loc_3 >= this._repeatX || this._repeatX == 0 && _loc_5 + _loc_4.width > _loc_15 && _loc_10 != 0)
                        {
                            _loc_5 = 0;
                            _loc_6 = _loc_6 + (Math.ceil(_loc_10) + this._lineGap);
                            _loc_10 = 0;
                            _loc_3 = 0;
                            _loc_19++;
                            if (this._repeatY != 0 && _loc_19 >= this._repeatY || this._repeatY == 0 && _loc_6 + _loc_4.height > _loc_16 && _loc_9 != 0)
                            {
                                _loc_20++;
                                _loc_6 = 0;
                                _loc_19 = 0;
                            }
                        }
                        _loc_4.setXY(_loc_20 * _loc_15 + _loc_5, _loc_6);
                        _loc_5 = _loc_5 + Math.ceil(_loc_4.width);
                        if (_loc_5 > _loc_9)
                        {
                            _loc_9 = _loc_5;
                        }
                        if (_loc_4.height > _loc_10)
                        {
                            _loc_10 = _loc_4.height;
                        }
                        _loc_3++;
                        _loc_2++;
                    }
                }
                _loc_8 = _loc_20 > 0 ? (_loc_16) : (_loc_6 + Math.ceil(_loc_10));
                _loc_7 = (_loc_20 + 1) * _loc_15;
            }
            setBounds(0, 0, _loc_7, _loc_8);
            var _loc_17:* = _alignOffset.x;
            var _loc_18:* = _alignOffset.y;
            _alignOffset.x = 0;
            _alignOffset.y = 0;
            if (_loc_8 < _loc_16)
            {
                if (this._verticalAlign == "middle")
                {
                    _alignOffset.y = int((_loc_16 - _loc_8) / 2);
                }
                else if (this._verticalAlign == "bottom")
                {
                    _alignOffset.y = _loc_16 - _loc_8;
                }
            }
            if (_loc_7 < _loc_15)
            {
                if (this._align == "center")
                {
                    _alignOffset.x = int((_loc_15 - _loc_7) / 2);
                }
                else if (this._align == "right")
                {
                    _alignOffset.x = _loc_15 - _loc_7;
                }
            }
            if (_alignOffset.x != _loc_17 || _alignOffset.y != _loc_18)
            {
                updateOverflow();
            }
            return;
        }// end function

        override public function read_beforeAdd(param1:XData, param2:Object) : void
        {
            var _loc_3:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = undefined;
            var _loc_11:* = null;
            var _loc_12:* = 0;
            var _loc_13:* = null;
            var _loc_14:* = null;
            super.read_beforeAdd(param1, param2);
            this._layout = param1.getAttribute("layout", SINGLE_COLUMN);
            this._selectionMode = param1.getAttribute("selectionMode", "single");
            _loc_3 = param1.getAttribute("margin");
            if (_loc_3)
            {
                _margin.parse(_loc_3);
            }
            _loc_3 = param1.getAttribute("clipSoftness");
            if (_loc_3)
            {
                _loc_11 = _loc_3.split(",");
                _clipSoftnessX = int(_loc_11[0]);
                _clipSoftnessY = int(_loc_11[1]);
            }
            _overflow = param1.getAttribute("overflow", OverflowConst.VISIBLE);
            _scroll = param1.getAttribute("scroll", ScrollConst.VERTICAL);
            _scrollBarFlags = param1.getAttributeInt("scrollBarFlags");
            _scrollBarDisplay = param1.getAttribute("scrollBar", ScrollBarDisplayConst.DEFAULT);
            _loc_3 = param1.getAttribute("scrollBarMargin");
            if (_loc_3)
            {
                _scrollBarMargin.parse(_loc_3);
            }
            _loc_3 = param1.getAttribute("scrollBarRes");
            if (_loc_3)
            {
                _loc_11 = _loc_3.split(",");
                _vtScrollBarRes = _loc_11[0];
                _hzScrollBarRes = _loc_11[1];
            }
            _loc_3 = param1.getAttribute("ptrRes");
            if (_loc_3)
            {
                _loc_11 = _loc_3.split(",");
                _headerRes = _loc_11[0];
                _footerRes = _loc_11[1];
            }
            this._lineGap = param1.getAttributeInt("lineGap");
            this._columnGap = param1.getAttributeInt("colGap");
            var _loc_15:* = 0;
            this._repeatY = 0;
            this._repeatX = _loc_15;
            _loc_3 = param1.getAttribute("lineItemCount");
            if (_loc_3)
            {
                if (this._layout == FLOW_HZ || this._layout == PAGINATION)
                {
                    this._repeatX = parseInt(_loc_3);
                }
                else if (this._layout == FLOW_VT)
                {
                    this._repeatY = parseInt(_loc_3);
                }
            }
            this._repeatY = param1.getAttributeInt("lineItemCount2", this._repeatY);
            this._defaultItem = param1.getAttribute("defaultItem");
            if (this._layout == SINGLE_ROW || this._layout == SINGLE_COLUMN)
            {
                this._autoResizeItem1 = param1.getAttributeBool("autoItemSize", true);
            }
            else
            {
                this._autoResizeItem2 = param1.getAttributeBool("autoItemSize", false);
            }
            this._align = param1.getAttribute("align", "left");
            this._verticalAlign = param1.getAttribute("vAlign", "top");
            updateOverflow();
            _childrenRenderOrder = param1.getAttribute("renderOrder", "ascent");
            if (_childrenRenderOrder == "arch")
            {
                _apexIndex = param1.getAttributeInt("apex");
            }
            this.clearOnPublish = param1.getAttributeBool("autoClearItems");
            this.scrollItemToViewOnClick = param1.getAttributeBool("scrollItemToViewOnClick", true);
            this.foldInvisibleItems = param1.getAttributeBool("foldInvisibleItems");
            this._treeViewEnabled = param1.getAttributeBool("treeView");
            this._indent = param1.getAttributeInt("indent", 15);
            this.clickToExpand = param1.getAttributeInt("clickToExpand");
            var _loc_4:* = param1.getEnumerator("item");
            this._items.length = 0;
            var _loc_5:* = 0;
            while (_loc_4.moveNext())
            {
                
                _loc_6 = _loc_4.current;
                _loc_7 = _loc_6.getAttribute("url");
                if (!_loc_7)
                {
                    _loc_7 = this._defaultItem;
                }
                _loc_8 = new ListItemData();
                _loc_8.url = _loc_7;
                _loc_8.title = _loc_6.getAttribute("title", "");
                _loc_8.icon = _loc_6.getAttribute("icon", "");
                _loc_8.name = _loc_6.getAttribute("name", "");
                _loc_8.selectedIcon = _loc_6.getAttribute("selectedIcon", "");
                _loc_8.selectedTitle = _loc_6.getAttribute("selectedTitle", "");
                if (param2)
                {
                    _loc_10 = param2[_id + "-" + _loc_5];
                    if (_loc_10 != undefined)
                    {
                        _loc_8.title = _loc_10;
                    }
                    _loc_10 = param2[_id + "-" + _loc_5 + "-0"];
                    if (_loc_10 != undefined)
                    {
                        _loc_8.selectedTitle = _loc_10;
                    }
                }
                if (this._treeViewEnabled)
                {
                    _loc_8.level = _loc_6.getAttributeInt("level", 0);
                }
                _loc_3 = _loc_6.getAttribute("controllers");
                if (_loc_3)
                {
                    _loc_11 = _loc_3.split(",");
                    _loc_12 = _loc_11.length;
                    _loc_5 = 0;
                    while (_loc_5 < _loc_12)
                    {
                        
                        _loc_8.properties.push(new ComProperty(_loc_11[_loc_5], -1, null, _loc_11[(_loc_5 + 1)]));
                        _loc_5 = _loc_5 + 2;
                    }
                }
                _loc_9 = _loc_6.getEnumerator("property");
                while (_loc_9.moveNext())
                {
                    
                    _loc_13 = _loc_9.current;
                    _loc_14 = new ComProperty(_loc_13.getAttribute("target"), _loc_13.getAttributeInt("propertyId"), null, _loc_13.getAttribute("value"));
                    if (param2 && _loc_14.propertyId == 0)
                    {
                        _loc_10 = param2[_id + "-" + _loc_5 + "-" + _loc_14.target];
                        if (_loc_10 != undefined)
                        {
                            _loc_14.value = _loc_10;
                        }
                    }
                    _loc_8.properties.push(_loc_14);
                }
                this.items.push(_loc_8);
                _loc_5++;
            }
            this.buildItems();
            return;
        }// end function

        override public function read_afterAdd(param1:XData, param2:Object) : void
        {
            super.read_afterAdd(param1, param2);
            var _loc_3:* = param1.getAttribute("selectionController");
            if (_loc_3)
            {
                this._selectionController = _parent.getController(_loc_3);
            }
            else
            {
                this._selectionController = null;
            }
            return;
        }// end function

        override public function write() : XData
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_1:* = super.write();
            if (this._layout != SINGLE_COLUMN)
            {
                _loc_1.setAttribute("layout", this._layout);
            }
            if (this._selectionMode != "single")
            {
                _loc_1.setAttribute("selectionMode", this._selectionMode);
            }
            if (_overflow != OverflowConst.VISIBLE)
            {
                _loc_1.setAttribute("overflow", _overflow);
            }
            if (_scroll != ScrollConst.VERTICAL)
            {
                _loc_1.setAttribute("scroll", _scroll);
            }
            if (_overflow == OverflowConst.SCROLL)
            {
                if (_scrollBarFlags)
                {
                    _loc_1.setAttribute("scrollBarFlags", _scrollBarFlags);
                }
                if (_scrollBarDisplay != ScrollBarDisplayConst.DEFAULT)
                {
                    _loc_1.setAttribute("scrollBar", _scrollBarDisplay);
                }
            }
            if (!_margin.empty)
            {
                _loc_1.setAttribute("margin", _margin);
            }
            if (!_scrollBarMargin.empty)
            {
                _loc_1.setAttribute("scrollBarMargin", _scrollBarMargin.toString());
            }
            if (_vtScrollBarRes || _hzScrollBarRes)
            {
                _loc_1.setAttribute("scrollBarRes", (_vtScrollBarRes ? (_vtScrollBarRes) : ("")) + "," + (_hzScrollBarRes ? (_hzScrollBarRes) : ("")));
            }
            if (_headerRes || _footerRes)
            {
                _loc_1.setAttribute("ptrRes", (_headerRes ? (_headerRes) : ("")) + "," + (_footerRes ? (_footerRes) : ("")));
            }
            if (_clipSoftnessX != 0 || _clipSoftnessY != 0)
            {
                _loc_1.setAttribute("clipSoftness", _clipSoftnessX + "," + _clipSoftnessY);
            }
            if (this._lineGap != 0)
            {
                _loc_1.setAttribute("lineGap", this._lineGap);
            }
            if (this._columnGap != 0)
            {
                _loc_1.setAttribute("colGap", this._columnGap);
            }
            if (this._layout == FLOW_HZ)
            {
                if (this._repeatX != 0)
                {
                    _loc_1.setAttribute("lineItemCount", this._repeatX);
                }
            }
            else if (this._layout == FLOW_VT)
            {
                if (this._repeatY != 0)
                {
                    _loc_1.setAttribute("lineItemCount", this._repeatY);
                }
            }
            else if (this._layout == PAGINATION)
            {
                if (this._repeatX != 0)
                {
                    _loc_1.setAttribute("lineItemCount", this._repeatX);
                }
                if (this._repeatY != 0)
                {
                    _loc_1.setAttribute("lineItemCount2", this._repeatY);
                }
            }
            if (this._defaultItem)
            {
                _loc_1.setAttribute("defaultItem", this._defaultItem);
            }
            if (this._layout == SINGLE_ROW || this._layout == SINGLE_COLUMN)
            {
                if (!this._autoResizeItem1)
                {
                    _loc_1.setAttribute("autoItemSize", false);
                }
            }
            else if (this._autoResizeItem2)
            {
                _loc_1.setAttribute("autoItemSize", true);
            }
            if (this._align != "left")
            {
                _loc_1.setAttribute("align", this._align);
            }
            if (this._verticalAlign != "top")
            {
                _loc_1.setAttribute("vAlign", this._verticalAlign);
            }
            if (_childrenRenderOrder != "ascent")
            {
                _loc_1.setAttribute("renderOrder", _childrenRenderOrder);
                if (_childrenRenderOrder == "arch" && _apexIndex != 0)
                {
                    _loc_1.setAttribute("apex", _apexIndex);
                }
            }
            if (this._selectionController && this._selectionController.parent)
            {
                _loc_1.setAttribute("selectionController", this._selectionController.name);
            }
            if (this.clearOnPublish)
            {
                _loc_1.setAttribute("autoClearItems", this.clearOnPublish);
            }
            if (!this.scrollItemToViewOnClick)
            {
                _loc_1.setAttribute("scrollItemToViewOnClick", this.scrollItemToViewOnClick);
            }
            if (this.foldInvisibleItems)
            {
                _loc_1.setAttribute("foldInvisibleItems", this.foldInvisibleItems);
            }
            if (this._treeViewEnabled)
            {
                _loc_1.setAttribute("treeView", this._treeViewEnabled);
                _loc_1.setAttribute("indent", this._indent);
                _loc_1.setAttribute("clickToExpand", this.clickToExpand);
            }
            if (this._items.length)
            {
                for each (_loc_2 in this._items)
                {
                    
                    _loc_3 = XData.create("item");
                    if (_loc_2.url && _loc_2.url != this._defaultItem)
                    {
                        _loc_3.setAttribute("url", _loc_2.url);
                    }
                    if (_loc_2.title)
                    {
                        _loc_3.setAttribute("title", _loc_2.title);
                    }
                    if (_loc_2.icon)
                    {
                        _loc_3.setAttribute("icon", _loc_2.icon);
                    }
                    if (_loc_2.name)
                    {
                        _loc_3.setAttribute("name", _loc_2.name);
                    }
                    if (_loc_2.selectedIcon)
                    {
                        _loc_3.setAttribute("selectedIcon", _loc_2.selectedIcon);
                    }
                    if (_loc_2.selectedTitle)
                    {
                        _loc_3.setAttribute("selectedTitle", _loc_2.selectedTitle);
                    }
                    _loc_4 = _loc_2.properties;
                    if (_loc_4.length)
                    {
                        _loc_5 = null;
                        for each (_loc_6 in _loc_4)
                        {
                            
                            if (_loc_6.value == undefined)
                            {
                                continue;
                            }
                            if (_loc_6.propertyId == -1)
                            {
                                if (_loc_5 == null)
                                {
                                    _loc_5 = "";
                                }
                                else
                                {
                                    _loc_5 = _loc_5 + ",";
                                }
                                _loc_5 = _loc_5 + (_loc_6.target + "," + _loc_6.value);
                                continue;
                            }
                            _loc_7 = XData.create("property");
                            _loc_7.setAttribute("target", _loc_6.target);
                            _loc_7.setAttribute("propertyId", _loc_6.propertyId);
                            _loc_7.setAttribute("value", _loc_6.value);
                            _loc_3.appendChild(_loc_7);
                        }
                        if (_loc_5 != null)
                        {
                            _loc_3.setAttribute("controllers", _loc_5);
                        }
                    }
                    if (this._treeViewEnabled)
                    {
                        _loc_3.setAttribute("level", _loc_2.level);
                    }
                    _loc_1.appendChild(_loc_3);
                }
            }
            return _loc_1;
        }// end function

    }
}
