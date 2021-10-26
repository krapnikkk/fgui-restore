package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.display.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class GList extends GComponent
    {
        public var itemRenderer:Function;
        public var itemProvider:Function;
        public var scrollItemToViewOnClick:Boolean;
        public var foldInvisibleItems:Boolean;
        private var _layout:int;
        private var _lineCount:int;
        private var _columnCount:int;
        private var _lineGap:int;
        private var _columnGap:int;
        private var _defaultItem:String;
        private var _autoResizeItem:Boolean;
        private var _selectionMode:int;
        private var _align:int;
        private var _verticalAlign:int;
        private var _selectionController:Controller;
        private var _lastSelectedIndex:int;
        private var _pool:GObjectPool;
        private var _virtual:Boolean;
        private var _loop:Boolean;
        private var _numItems:int;
        private var _realNumItems:int;
        private var _firstIndex:int;
        private var _curLineItemCount:int;
        private var _curLineItemCount2:int;
        private var _itemSize:Point;
        private var _virtualListChanged:int;
        private var _eventLocked:Boolean;
        private var _virtualItems:Vector.<ItemInfo>;
        private var itemInfoVer:uint = 0;
        private static var pos_param:Number;

        public function GList()
        {
            _trackBounds = true;
            _pool = new GObjectPool();
            _layout = 0;
            _autoResizeItem = true;
            _lastSelectedIndex = -1;
            this.opaque = true;
            scrollItemToViewOnClick = true;
            _align = 0;
            _verticalAlign = 0;
            _container = new Sprite();
            _rootContainer.addChild(_container);
            return;
        }// end function

        override public function dispose() : void
        {
            _pool.clear();
            scrollItemToViewOnClick = false;
            super.dispose();
            return;
        }// end function

        final public function get layout() : int
        {
            return _layout;
        }// end function

        final public function set layout(param1:int) : void
        {
            if (_layout != param1)
            {
                _layout = param1;
                setBoundsChangedFlag();
                if (_virtual)
                {
                    setVirtualListChangedFlag(true);
                }
            }
            return;
        }// end function

        final public function get lineCount() : int
        {
            return _lineCount;
        }// end function

        final public function set lineCount(param1:int) : void
        {
            if (_lineCount != param1)
            {
                _lineCount = param1;
                if (_layout == 3 || _layout == 4)
                {
                    setBoundsChangedFlag();
                    if (_virtual)
                    {
                        setVirtualListChangedFlag(true);
                    }
                }
            }
            return;
        }// end function

        final public function get columnCount() : int
        {
            return _columnCount;
        }// end function

        final public function set columnCount(param1:int) : void
        {
            if (_columnCount != param1)
            {
                _columnCount = param1;
                if (_layout == 2 || _layout == 4)
                {
                    setBoundsChangedFlag();
                    if (_virtual)
                    {
                        setVirtualListChangedFlag(true);
                    }
                }
            }
            return;
        }// end function

        final public function get lineGap() : int
        {
            return _lineGap;
        }// end function

        final public function set lineGap(param1:int) : void
        {
            if (_lineGap != param1)
            {
                _lineGap = param1;
                setBoundsChangedFlag();
                if (_virtual)
                {
                    setVirtualListChangedFlag(true);
                }
            }
            return;
        }// end function

        final public function get columnGap() : int
        {
            return _columnGap;
        }// end function

        final public function set columnGap(param1:int) : void
        {
            if (_columnGap != param1)
            {
                _columnGap = param1;
                setBoundsChangedFlag();
                if (_virtual)
                {
                    setVirtualListChangedFlag(true);
                }
            }
            return;
        }// end function

        public function get align() : int
        {
            return _align;
        }// end function

        public function set align(param1:int) : void
        {
            if (_align != param1)
            {
                _align = param1;
                setBoundsChangedFlag();
                if (_virtual)
                {
                    setVirtualListChangedFlag(true);
                }
            }
            return;
        }// end function

        final public function get verticalAlign() : int
        {
            return _verticalAlign;
        }// end function

        public function set verticalAlign(param1:int) : void
        {
            if (_verticalAlign != param1)
            {
                _verticalAlign = param1;
                setBoundsChangedFlag();
                if (_virtual)
                {
                    setVirtualListChangedFlag(true);
                }
            }
            return;
        }// end function

        final public function get virtualItemSize() : Point
        {
            return _itemSize;
        }// end function

        final public function set virtualItemSize(param1:Point) : void
        {
            if (_virtual)
            {
                if (_itemSize == null)
                {
                    _itemSize = new Point();
                }
                _itemSize.copyFrom(param1);
                setVirtualListChangedFlag(true);
            }
            return;
        }// end function

        final public function get defaultItem() : String
        {
            return _defaultItem;
        }// end function

        final public function set defaultItem(param1:String) : void
        {
            _defaultItem = param1;
            return;
        }// end function

        final public function get autoResizeItem() : Boolean
        {
            return _autoResizeItem;
        }// end function

        final public function set autoResizeItem(param1:Boolean) : void
        {
            if (_autoResizeItem != param1)
            {
                _autoResizeItem = param1;
                setBoundsChangedFlag();
                if (_virtual)
                {
                    setVirtualListChangedFlag(true);
                }
            }
            return;
        }// end function

        final public function get selectionMode() : int
        {
            return _selectionMode;
        }// end function

        final public function set selectionMode(param1:int) : void
        {
            _selectionMode = param1;
            return;
        }// end function

        final public function get selectionController() : Controller
        {
            return _selectionController;
        }// end function

        final public function set selectionController(param1:Controller) : void
        {
            _selectionController = param1;
            return;
        }// end function

        public function get itemPool() : GObjectPool
        {
            return _pool;
        }// end function

        public function getFromPool(param1:String = null) : GObject
        {
            if (!param1)
            {
                param1 = _defaultItem;
            }
            var _loc_2:* = _pool.getObject(param1);
            if (_loc_2 != null)
            {
                _loc_2.visible = true;
            }
            return _loc_2;
        }// end function

        public function returnToPool(param1:GObject) : void
        {
            _pool.returnObject(param1);
            return;
        }// end function

        override public function addChildAt(param1:GObject, param2:int) : GObject
        {
            var _loc_3:* = null;
            super.addChildAt(param1, param2);
            if (param1 is GButton && _selectionMode != 3)
            {
                _loc_3 = this.GButton(param1);
                _loc_3.selected = false;
                _loc_3.changeStateOnClick = false;
                _loc_3.useHandCursor = false;
            }
            param1.addEventListener("clickGTouch", __clickItem);
            param1.addEventListener("rightClick", __rightClickItem);
            return param1;
        }// end function

        public function addItem(param1:String = null) : GObject
        {
            if (!param1)
            {
                param1 = _defaultItem;
            }
            return addChild(UIPackage.createObjectFromURL(param1));
        }// end function

        public function addItemFromPool(param1:String = null) : GObject
        {
            return addChild(getFromPool(param1));
        }// end function

        override public function removeChildAt(param1:int, param2:Boolean = false) : GObject
        {
            var _loc_3:* = super.removeChildAt(param1, param2);
            _loc_3.removeEventListener("clickGTouch", __clickItem);
            _loc_3.removeEventListener("rightClick", __rightClickItem);
            return _loc_3;
        }// end function

        public function removeChildToPoolAt(param1:int) : void
        {
            var _loc_2:* = super.removeChildAt(param1);
            returnToPool(_loc_2);
            return;
        }// end function

        public function removeChildToPool(param1:GObject) : void
        {
            super.removeChild(param1);
            returnToPool(param1);
            return;
        }// end function

        public function removeChildrenToPool(param1:int = 0, param2:int = -1) : void
        {
            var _loc_3:* = 0;
            if (param2 < 0 || param2 >= _children.length)
            {
                param2 = _children.length - 1;
            }
            _loc_3 = param1;
            while (_loc_3 <= param2)
            {
                
                removeChildToPoolAt(param1);
                _loc_3++;
            }
            return;
        }// end function

        public function get selectedIndex() : int
        {
            var _loc_4:* = 0;
            var _loc_1:* = null;
            var _loc_3:* = 0;
            var _loc_2:* = null;
            if (_virtual)
            {
                _loc_4 = 0;
                while (_loc_4 < _realNumItems)
                {
                    
                    _loc_1 = _virtualItems[_loc_4];
                    if (_loc_1.obj is GButton && this.GButton(_loc_1.obj).selected || _loc_1.obj == null && _loc_1.selected)
                    {
                        if (_loop)
                        {
                            return _loc_4 % _numItems;
                        }
                        return _loc_4;
                    }
                    _loc_4++;
                }
            }
            else
            {
                _loc_3 = _children.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_2 = _children[_loc_4].asButton;
                    if (_loc_2 != null && _loc_2.selected)
                    {
                        return _loc_4;
                    }
                    _loc_4++;
                }
            }
            return -1;
        }// end function

        public function set selectedIndex(param1:int) : void
        {
            if (param1 >= 0 && param1 < this.numItems)
            {
                if (_selectionMode != 0)
                {
                    clearSelection();
                }
                addSelection(param1);
            }
            else
            {
                clearSelection();
            }
            return;
        }// end function

        public function getSelection(param1:Vector.<int> = null) : Vector.<int>
        {
            var _loc_5:* = 0;
            var _loc_2:* = null;
            var _loc_6:* = 0;
            var _loc_4:* = 0;
            var _loc_3:* = null;
            if (param1 == null)
            {
                param1 = new Vector.<int>;
            }
            if (_virtual)
            {
                _loc_5 = 0;
                while (_loc_5 < _realNumItems)
                {
                    
                    _loc_2 = _virtualItems[_loc_5];
                    if (_loc_2.obj is GButton && this.GButton(_loc_2.obj).selected || _loc_2.obj == null && _loc_2.selected)
                    {
                        if (_loop)
                        {
                            _loc_6 = _loc_5 % _numItems;
                        }
                        param1.push(_loc_5);
                    }
                    _loc_5++;
                }
            }
            else
            {
                _loc_4 = _children.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_3 = _children[_loc_5].asButton;
                    if (_loc_3 != null && _loc_3.selected)
                    {
                        param1.push(_loc_5);
                    }
                    _loc_5++;
                }
            }
            return param1;
        }// end function

        public function addSelection(param1:int, param2:Boolean = false) : void
        {
            var _loc_3:* = null;
            if (_selectionMode == 3)
            {
                return;
            }
            checkVirtualList();
            if (_selectionMode == 0)
            {
                clearSelection();
            }
            if (param2)
            {
                scrollToView(param1);
            }
            _lastSelectedIndex = param1;
            var _loc_4:* = null;
            if (_virtual)
            {
                _loc_3 = _virtualItems[param1];
                if (_loc_3.obj != null)
                {
                    _loc_4 = _loc_3.obj.asButton;
                }
                _loc_3.selected = true;
            }
            else
            {
                _loc_4 = getChildAt(param1).asButton;
            }
            if (_loc_4 != null && !_loc_4.selected)
            {
                _loc_4.selected = true;
                updateSelectionController(param1);
            }
            return;
        }// end function

        public function removeSelection(param1:int) : void
        {
            var _loc_2:* = null;
            if (_selectionMode == 3)
            {
                return;
            }
            var _loc_3:* = null;
            if (_virtual)
            {
                _loc_2 = _virtualItems[param1];
                if (_loc_2.obj != null)
                {
                    _loc_3 = _loc_2.obj.asButton;
                }
                _loc_2.selected = false;
            }
            else
            {
                _loc_3 = getChildAt(param1).asButton;
            }
            if (_loc_3 != null)
            {
                _loc_3.selected = false;
            }
            return;
        }// end function

        public function clearSelection() : void
        {
            var _loc_4:* = 0;
            var _loc_1:* = null;
            var _loc_3:* = 0;
            var _loc_2:* = null;
            if (_virtual)
            {
                _loc_4 = 0;
                while (_loc_4 < _realNumItems)
                {
                    
                    _loc_1 = _virtualItems[_loc_4];
                    if (_loc_1.obj is GButton)
                    {
                        this.GButton(_loc_1.obj).selected = false;
                    }
                    _loc_1.selected = false;
                    _loc_4++;
                }
            }
            else
            {
                _loc_3 = _children.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_2 = _children[_loc_4].asButton;
                    if (_loc_2 != null)
                    {
                        _loc_2.selected = false;
                    }
                    _loc_4++;
                }
            }
            return;
        }// end function

        private function clearSelectionExcept(param1:GObject) : void
        {
            var _loc_5:* = 0;
            var _loc_2:* = null;
            var _loc_4:* = 0;
            var _loc_3:* = null;
            if (_virtual)
            {
                _loc_5 = 0;
                while (_loc_5 < _realNumItems)
                {
                    
                    _loc_2 = _virtualItems[_loc_5];
                    if (_loc_2.obj != param1)
                    {
                        if (_loc_2.obj is GButton)
                        {
                            this.GButton(_loc_2.obj).selected = false;
                        }
                        _loc_2.selected = false;
                    }
                    _loc_5++;
                }
            }
            else
            {
                _loc_4 = _children.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_3 = _children[_loc_5].asButton;
                    if (_loc_3 != null && _loc_3 != param1)
                    {
                        _loc_3.selected = false;
                    }
                    _loc_5++;
                }
            }
            return;
        }// end function

        public function selectAll() : void
        {
            var _loc_5:* = 0;
            var _loc_1:* = null;
            var _loc_4:* = 0;
            var _loc_3:* = null;
            checkVirtualList();
            var _loc_2:* = -1;
            if (_virtual)
            {
                _loc_5 = 0;
                while (_loc_5 < _realNumItems)
                {
                    
                    _loc_1 = _virtualItems[_loc_5];
                    if (_loc_1.obj is GButton && !this.GButton(_loc_1.obj).selected)
                    {
                        this.GButton(_loc_1.obj).selected = true;
                        _loc_2 = _loc_5;
                    }
                    _loc_1.selected = true;
                    _loc_5++;
                }
            }
            else
            {
                _loc_4 = _children.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_3 = _children[_loc_5].asButton;
                    if (_loc_3 != null && !_loc_3.selected)
                    {
                        _loc_3.selected = true;
                        _loc_2 = _loc_5;
                    }
                    _loc_5++;
                }
            }
            if (_loc_2 != -1)
            {
                updateSelectionController(_loc_2);
            }
            return;
        }// end function

        public function selectNone() : void
        {
            clearSelection();
            return;
        }// end function

        public function selectReverse() : void
        {
            var _loc_5:* = 0;
            var _loc_1:* = null;
            var _loc_4:* = 0;
            var _loc_3:* = null;
            checkVirtualList();
            var _loc_2:* = -1;
            if (_virtual)
            {
                _loc_5 = 0;
                while (_loc_5 < _realNumItems)
                {
                    
                    _loc_1 = _virtualItems[_loc_5];
                    if (_loc_1.obj is GButton)
                    {
                        this.GButton(_loc_1.obj).selected = !this.GButton(_loc_1.obj).selected;
                        if (this.GButton(_loc_1.obj).selected)
                        {
                            _loc_2 = _loc_5;
                        }
                    }
                    _loc_1.selected = !_loc_1.selected;
                    _loc_5++;
                }
            }
            else
            {
                _loc_4 = _children.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_3 = _children[_loc_5].asButton;
                    if (_loc_3 != null)
                    {
                        _loc_3.selected = !_loc_3.selected;
                        if (_loc_3.selected)
                        {
                            _loc_2 = _loc_5;
                        }
                    }
                    _loc_5++;
                }
            }
            if (_loc_2 != -1)
            {
                updateSelectionController(_loc_2);
            }
            return;
        }// end function

        public function handleArrowKey(param1:int) : void
        {
            var _loc_2:* = null;
            var _loc_7:* = 0;
            var _loc_6:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = this.selectedIndex;
            if (this.selectedIndex == -1)
            {
                return;
            }
            switch((param1 - 1)) branch count is:<6>[26, 898, 240, 898, 464, 898, 689] default offset is:<898>;
            if (_layout == 0 || _layout == 3)
            {
                _loc_5--;
                if (_loc_5 >= 0)
                {
                    clearSelection();
                    addSelection(_loc_5, true);
                }
            }
            else if (_layout == 2 || _layout == 4)
            {
                _loc_2 = _children[_loc_5];
                _loc_7 = 0;
                _loc_6 = _loc_5 - 1;
                while (_loc_6 >= 0)
                {
                    
                    _loc_3 = _children[_loc_6];
                    if (_loc_3.y != _loc_2.y)
                    {
                        _loc_2 = _loc_3;
                        break;
                    }
                    _loc_7++;
                    _loc_6--;
                }
                while (_loc_6 >= 0)
                {
                    
                    _loc_3 = _children[_loc_6];
                    if (_loc_3.y != _loc_2.y)
                    {
                        clearSelection();
                        addSelection(_loc_6 + _loc_7 + 1, true);
                        break;
                    }
                    _loc_6--;
                }
            }
            ;
            if (_layout == 1 || _layout == 2 || _layout == 4)
            {
                _loc_5++;
                if (_loc_5 < this.numItems)
                {
                    clearSelection();
                    addSelection(_loc_5, true);
                }
            }
            else if (_layout == 3)
            {
                _loc_2 = _children[_loc_5];
                _loc_7 = 0;
                _loc_4 = _children.length;
                _loc_6 = _loc_5 + 1;
                while (_loc_6 < _loc_4)
                {
                    
                    _loc_3 = _children[_loc_6];
                    if (_loc_3.x != _loc_2.x)
                    {
                        _loc_2 = _loc_3;
                        break;
                    }
                    _loc_7++;
                    _loc_6++;
                }
                while (_loc_6 < _loc_4)
                {
                    
                    _loc_3 = _children[_loc_6];
                    if (_loc_3.x != _loc_2.x)
                    {
                        clearSelection();
                        addSelection(_loc_6 - _loc_7 - 1, true);
                        break;
                    }
                    _loc_6++;
                }
            }
            ;
            if (_layout == 0 || _layout == 3)
            {
                _loc_5++;
                if (_loc_5 < this.numItems)
                {
                    clearSelection();
                    addSelection(_loc_5, true);
                }
            }
            else if (_layout == 2 || _layout == 4)
            {
                _loc_2 = _children[_loc_5];
                _loc_7 = 0;
                _loc_4 = _children.length;
                _loc_6 = _loc_5 + 1;
                while (_loc_6 < _loc_4)
                {
                    
                    _loc_3 = _children[_loc_6];
                    if (_loc_3.y != _loc_2.y)
                    {
                        _loc_2 = _loc_3;
                        break;
                    }
                    _loc_7++;
                    _loc_6++;
                }
                while (_loc_6 < _loc_4)
                {
                    
                    _loc_3 = _children[_loc_6];
                    if (_loc_3.y != _loc_2.y)
                    {
                        clearSelection();
                        addSelection(_loc_6 - _loc_7 - 1, true);
                        break;
                    }
                    _loc_6++;
                }
            }
            ;
            if (_layout == 1 || _layout == 2 || _layout == 4)
            {
                _loc_5--;
                if (_loc_5 >= 0)
                {
                    clearSelection();
                    addSelection(_loc_5, true);
                }
            }
            else if (_layout == 3)
            {
                _loc_2 = _children[_loc_5];
                _loc_7 = 0;
                _loc_6 = _loc_5 - 1;
                while (_loc_6 >= 0)
                {
                    
                    _loc_3 = _children[_loc_6];
                    if (_loc_3.x != _loc_2.x)
                    {
                        _loc_2 = _loc_3;
                        break;
                    }
                    _loc_7++;
                    _loc_6--;
                }
                while (_loc_6 >= 0)
                {
                    
                    _loc_3 = _children[_loc_6];
                    if (_loc_3.x != _loc_2.x)
                    {
                        clearSelection();
                        addSelection(_loc_6 + _loc_7 + 1, true);
                        break;
                    }
                    _loc_6--;
                }
            }
            return;
        }// end function

        public function getItemNear(param1:Number, param2:Number) : GObject
        {
            var _loc_3:* = null;
            ensureBoundsCorrect();
            var _loc_5:* = root.nativeStage.getObjectsUnderPoint(new Point(param1, param2));
            if (!root.nativeStage.getObjectsUnderPoint(new Point(param1, param2)) || _loc_5.length == 0)
            {
                return null;
            }
            for each (_loc_4 in _loc_5)
            {
                
                while (_loc_4 != null && !(_loc_4 is Stage))
                {
                    
                    if (_loc_4 is UIDisplayObject)
                    {
                        _loc_3 = this.UIDisplayObject(_loc_4).owner;
                        while (_loc_3 != null && _loc_3.parent != this)
                        {
                            
                            _loc_3 = _loc_3.parent;
                        }
                        if (_loc_3 != null)
                        {
                            return _loc_3;
                        }
                    }
                    _loc_4 = _loc_4.parent;
                }
            }
            return null;
        }// end function

        private function __clickItem(event:GTouchEvent) : void
        {
            if (this._scrollPane != null && this._scrollPane.isDragged)
            {
                return;
            }
            var _loc_2:* = this.GObject(event.currentTarget);
            setSelectionOnEvent(_loc_2);
            if (_scrollPane != null && scrollItemToViewOnClick)
            {
                _scrollPane.scrollToView(_loc_2, true);
            }
            var _loc_3:* = new ItemEvent("itemClick", _loc_2);
            _loc_3.stageX = event.stageX;
            _loc_3.stageY = event.stageY;
            _loc_3.clickCount = event.clickCount;
            dispatchItemEvent(_loc_3);
            return;
        }// end function

        protected function dispatchItemEvent(event:ItemEvent) : void
        {
            this.dispatchEvent(event);
            return;
        }// end function

        private function __rightClickItem(event:MouseEvent) : void
        {
            var _loc_2:* = this.GObject(event.currentTarget);
            if (_loc_2 is GButton && !this.GButton(_loc_2).selected)
            {
                setSelectionOnEvent(_loc_2);
            }
            if (_scrollPane != null && scrollItemToViewOnClick)
            {
                _scrollPane.scrollToView(_loc_2, true);
            }
            var _loc_3:* = new ItemEvent("itemClick", _loc_2);
            _loc_3.stageX = event.stageX;
            _loc_3.stageY = event.stageY;
            _loc_3.rightButton = true;
            dispatchItemEvent(_loc_3);
            return;
        }// end function

        private function setSelectionOnEvent(param1:GObject) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_10:* = 0;
            var _loc_3:* = null;
            var _loc_8:* = null;
            if (!(param1 is GButton) || _selectionMode == 3)
            {
                return;
            }
            var _loc_7:* = false;
            var _loc_2:* = this.GButton(param1);
            var _loc_9:* = childIndexToItemIndex(getChildIndex(param1));
            if (_selectionMode == 0)
            {
                if (!_loc_2.selected)
                {
                    clearSelectionExcept(_loc_2);
                    _loc_2.selected = true;
                }
            }
            else
            {
                _loc_4 = this.root;
                if (_loc_4.shiftKeyDown)
                {
                    if (!_loc_2.selected)
                    {
                        if (_lastSelectedIndex != -1)
                        {
                            _loc_5 = Math.min(_lastSelectedIndex, _loc_9);
                            _loc_6 = Math.max(_lastSelectedIndex, _loc_9);
                            _loc_6 = Math.min(_loc_6, (this.numItems - 1));
                            if (_virtual)
                            {
                                _loc_10 = _loc_5;
                                while (_loc_10 <= _loc_6)
                                {
                                    
                                    _loc_3 = _virtualItems[_loc_10];
                                    if (_loc_3.obj is GButton)
                                    {
                                        this.GButton(_loc_3.obj).selected = true;
                                    }
                                    _loc_3.selected = true;
                                    _loc_10++;
                                }
                            }
                            else
                            {
                                _loc_10 = _loc_5;
                                while (_loc_10 <= _loc_6)
                                {
                                    
                                    _loc_8 = getChildAt(_loc_10).asButton;
                                    if (_loc_8 != null)
                                    {
                                        _loc_8.selected = true;
                                    }
                                    _loc_10++;
                                }
                            }
                            _loc_7 = true;
                        }
                        else
                        {
                            _loc_2.selected = true;
                        }
                    }
                }
                else if (_loc_4.ctrlKeyDown || _selectionMode == 2)
                {
                    _loc_2.selected = !_loc_2.selected;
                }
                else if (!_loc_2.selected)
                {
                    clearSelectionExcept(_loc_2);
                    _loc_2.selected = true;
                }
                else
                {
                    clearSelectionExcept(_loc_2);
                }
            }
            if (!_loc_7)
            {
                _lastSelectedIndex = _loc_9;
            }
            if (_loc_2.selected)
            {
                updateSelectionController(_loc_9);
            }
            return;
        }// end function

        public function resizeToFit(param1:int = 2147483647, param2:int = 0) : void
        {
            var _loc_7:* = 0;
            var _loc_6:* = 0;
            var _loc_5:* = null;
            var _loc_3:* = 0;
            ensureBoundsCorrect();
            var _loc_4:* = this.numItems;
            if (param1 > _loc_4)
            {
                param1 = _loc_4;
            }
            if (_virtual)
            {
                _loc_7 = Math.ceil(param1 / _curLineItemCount);
                if (_layout == 0 || _layout == 2)
                {
                    this.viewHeight = _loc_7 * _itemSize.y + Math.max(0, (_loc_7 - 1)) * _lineGap;
                }
                else
                {
                    this.viewWidth = _loc_7 * _itemSize.x + Math.max(0, (_loc_7 - 1)) * _columnGap;
                }
            }
            else if (param1 == 0)
            {
                if (_layout == 0 || _layout == 2)
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
                _loc_6 = param1 - 1;
                _loc_5 = null;
                while (_loc_6 >= 0)
                {
                    
                    _loc_5 = this.getChildAt(_loc_6);
                    if (!(!foldInvisibleItems || _loc_5.visible))
                    {
                        _loc_6--;
                    }
                }
                if (_loc_6 < 0)
                {
                    if (_layout == 0 || _layout == 2)
                    {
                        this.viewHeight = param2;
                    }
                    else
                    {
                        this.viewWidth = param2;
                    }
                }
                else if (_layout == 0 || _layout == 2)
                {
                    _loc_3 = _loc_5.y + _loc_5.height;
                    if (_loc_3 < param2)
                    {
                        _loc_3 = param2;
                    }
                    this.viewHeight = _loc_3;
                }
                else
                {
                    _loc_3 = _loc_5.x + _loc_5.width;
                    if (_loc_3 < param2)
                    {
                        _loc_3 = param2;
                    }
                    this.viewWidth = _loc_3;
                }
            }
            return;
        }// end function

        public function getMaxItemWidth() : int
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = _children.length;
            var _loc_1:* = 0;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = getChildAt(_loc_3);
                if (_loc_4.width > _loc_1)
                {
                    _loc_1 = _loc_4.width;
                }
                _loc_3++;
            }
            return _loc_1;
        }// end function

        override protected function handleSizeChanged() : void
        {
            super.handleSizeChanged();
            setBoundsChangedFlag();
            if (_virtual)
            {
                setVirtualListChangedFlag(true);
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

        private function updateSelectionController(param1:int) : void
        {
            var _loc_2:* = null;
            if (_selectionController != null && !_selectionController.changing && param1 < _selectionController.pageCount)
            {
                _loc_2 = _selectionController;
                _selectionController = null;
                _loc_2.selectedIndex = param1;
                _selectionController = _loc_2;
            }
            return;
        }// end function

        override public function getSnappingPosition(param1:Number, param2:Number, param3:Point = null) : Point
        {
            var _loc_4:* = NaN;
            var _loc_5:* = 0;
            if (_virtual)
            {
                if (!param3)
                {
                    param3 = new Point();
                }
                if (_layout == 0 || _layout == 2)
                {
                    _loc_4 = param2;
                    GList.pos_param = param2;
                    _loc_5 = getIndexOnPos1(false);
                    param2 = GList.pos_param;
                    if (_loc_5 < _virtualItems.length && _loc_4 - param2 > _virtualItems[_loc_5].height / 2 && _loc_5 < _realNumItems)
                    {
                        param2 = param2 + (_virtualItems[_loc_5].height + _lineGap);
                    }
                }
                else if (_layout == 1 || _layout == 3)
                {
                    _loc_4 = param1;
                    GList.pos_param = param1;
                    _loc_5 = getIndexOnPos2(false);
                    param1 = GList.pos_param;
                    if (_loc_5 < _virtualItems.length && _loc_4 - param1 > _virtualItems[_loc_5].width / 2 && _loc_5 < _realNumItems)
                    {
                        param1 = param1 + (_virtualItems[_loc_5].width + _columnGap);
                    }
                }
                else
                {
                    _loc_4 = param1;
                    GList.pos_param = param1;
                    _loc_5 = getIndexOnPos3(false);
                    param1 = GList.pos_param;
                    if (_loc_5 < _virtualItems.length && _loc_4 - param1 > _virtualItems[_loc_5].width / 2 && _loc_5 < _realNumItems)
                    {
                        param1 = param1 + (_virtualItems[_loc_5].width + _columnGap);
                    }
                }
                param3.x = param1;
                param3.y = param2;
                return param3;
            }
            return super.getSnappingPosition(param1, param2, param3);
        }// end function

        public function scrollToView(param1:int, param2:Boolean = false, param3:Boolean = false) : void
        {
            var _loc_5:* = null;
            var _loc_4:* = null;
            var _loc_6:* = NaN;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_7:* = null;
            if (_virtual)
            {
                if (_numItems == 0)
                {
                    return;
                }
                checkVirtualList();
                if (param1 >= _virtualItems.length)
                {
                    throw new Error("Invalid child index: " + param1 + ">" + _virtualItems.length);
                }
                if (_loop)
                {
                    param1 = Math.floor(_firstIndex / _numItems) * _numItems + param1;
                }
                _loc_4 = _virtualItems[param1];
                _loc_6 = 0;
                if (_layout == 0 || _layout == 2)
                {
                    _loc_8 = _curLineItemCount - 1;
                    while (_loc_8 < param1)
                    {
                        
                        _loc_6 = _loc_6 + (_virtualItems[_loc_8].height + _lineGap);
                        _loc_8 = _loc_8 + _curLineItemCount;
                    }
                    _loc_5 = new Rectangle(0, _loc_6, _itemSize.x, _loc_4.height);
                }
                else if (_layout == 1 || _layout == 3)
                {
                    _loc_8 = _curLineItemCount - 1;
                    while (_loc_8 < param1)
                    {
                        
                        _loc_6 = _loc_6 + (_virtualItems[_loc_8].width + _columnGap);
                        _loc_8 = _loc_8 + _curLineItemCount;
                    }
                    _loc_5 = new Rectangle(_loc_6, 0, _loc_4.width, _itemSize.y);
                }
                else
                {
                    _loc_9 = param1 / (_curLineItemCount * _curLineItemCount2);
                    _loc_5 = new Rectangle(_loc_9 * viewWidth + param1 % _curLineItemCount * (_loc_4.width + _columnGap), param1 / _curLineItemCount % _curLineItemCount2 * (_loc_4.height + _lineGap), _loc_4.width, _loc_4.height);
                }
                if (this.itemProvider != null)
                {
                    param3 = true;
                }
                if (_scrollPane != null)
                {
                    _scrollPane.scrollToView(_loc_5, param2, param3);
                }
            }
            else
            {
                _loc_7 = getChildAt(param1);
                if (_scrollPane != null)
                {
                    _scrollPane.scrollToView(_loc_7, param2, param3);
                }
                else if (parent != null && parent.scrollPane != null)
                {
                    parent.scrollPane.scrollToView(_loc_7, param2, param3);
                }
            }
            return;
        }// end function

        override public function getFirstChildInView() : int
        {
            return childIndexToItemIndex(super.getFirstChildInView());
        }// end function

        public function childIndexToItemIndex(param1:int) : int
        {
            var _loc_2:* = 0;
            if (!_virtual)
            {
                return param1;
            }
            if (_layout == 4)
            {
                _loc_2 = _firstIndex;
                while (_loc_2 < _realNumItems)
                {
                    
                    if (_virtualItems[_loc_2].obj != null)
                    {
                        param1--;
                        if (param1 < 0)
                        {
                            return _loc_2;
                        }
                    }
                    _loc_2++;
                }
                return param1;
            }
            param1 = param1 + _firstIndex;
            if (_loop && _numItems > 0)
            {
                param1 = param1 % _numItems;
            }
            return param1;
        }// end function

        public function itemIndexToChildIndex(param1:int) : int
        {
            var _loc_2:* = 0;
            if (!_virtual)
            {
                return param1;
            }
            if (_layout == 4)
            {
                return getChildIndex(_virtualItems[param1].obj);
            }
            if (_loop && _numItems > 0)
            {
                _loc_2 = _firstIndex % _numItems;
                if (param1 >= _loc_2)
                {
                    param1 = param1 - _loc_2;
                }
                else
                {
                    param1 = _numItems - _loc_2 + param1;
                }
            }
            else
            {
                param1 = param1 - _firstIndex;
            }
            return param1;
        }// end function

        public function setVirtual() : void
        {
            _setVirtual(false);
            return;
        }// end function

        public function setVirtualAndLoop() : void
        {
            _setVirtual(true);
            return;
        }// end function

        private function _setVirtual(param1:Boolean) : void
        {
            var _loc_2:* = null;
            if (!_virtual)
            {
                if (_scrollPane == null)
                {
                    throw new Error("FairyGUI: Virtual list must be scrollable!");
                }
                if (param1)
                {
                    if (_layout == 2 || _layout == 3)
                    {
                        throw new Error("FairyGUI: Loop list is not supported for FlowHorizontal or FlowVertical layout!");
                    }
                    _scrollPane.bouncebackEffect = false;
                }
                _virtual = true;
                _loop = param1;
                _virtualItems = new Vector.<ItemInfo>;
                removeChildrenToPool();
                if (_itemSize == null)
                {
                    _itemSize = new Point();
                    _loc_2 = getFromPool(null);
                    if (_loc_2 == null)
                    {
                        throw new Error("FairyGUI: Virtual List must have a default list item resource.");
                        _itemSize.x = 100;
                        _itemSize.y = 100;
                    }
                    else
                    {
                        _itemSize.x = _loc_2.width;
                        _itemSize.y = _loc_2.height;
                        returnToPool(_loc_2);
                    }
                }
                if (_layout == 0 || _layout == 2)
                {
                    _scrollPane.scrollStep = _itemSize.y;
                    if (_loop)
                    {
                        this._scrollPane._loop = 2;
                    }
                }
                else
                {
                    _scrollPane.scrollStep = _itemSize.x;
                    if (_loop)
                    {
                        this._scrollPane._loop = 1;
                    }
                }
                _scrollPane.addEventListener("scroll", __scrolled);
                setVirtualListChangedFlag(true);
            }
            return;
        }// end function

        public function get numItems() : int
        {
            if (_virtual)
            {
                return _numItems;
            }
            return _children.length;
        }// end function

        public function set numItems(param1:int) : void
        {
            var _loc_5:* = 0;
            var _loc_3:* = 0;
            var _loc_2:* = null;
            var _loc_4:* = 0;
            if (_virtual)
            {
                if (itemRenderer == null)
                {
                    throw new Error("FairyGUI: Set itemRenderer first!");
                }
                _numItems = param1;
                if (_loop)
                {
                    _realNumItems = _numItems * 6;
                }
                else
                {
                    _realNumItems = _numItems;
                }
                _loc_3 = _virtualItems.length;
                if (_realNumItems > _loc_3)
                {
                    _loc_5 = _loc_3;
                    while (_loc_5 < _realNumItems)
                    {
                        
                        _loc_2 = new ItemInfo();
                        _loc_2.width = _itemSize.x;
                        _loc_2.height = _itemSize.y;
                        _virtualItems.push(_loc_2);
                        _loc_5++;
                    }
                }
                else
                {
                    _loc_5 = _realNumItems;
                    while (_loc_5 < _loc_3)
                    {
                        
                        _virtualItems[_loc_5].selected = false;
                        _loc_5++;
                    }
                }
                if (this._virtualListChanged != 0)
                {
                    GTimers.inst.remove(_refreshVirtualList);
                }
                _refreshVirtualList();
            }
            else
            {
                _loc_4 = _children.length;
                if (param1 > _loc_4)
                {
                    _loc_5 = _loc_4;
                    while (_loc_5 < param1)
                    {
                        
                        if (itemProvider == null)
                        {
                            addItemFromPool();
                        }
                        else
                        {
                            addItemFromPool(this.itemProvider(_loc_5));
                        }
                        _loc_5++;
                    }
                }
                else
                {
                    removeChildrenToPool(param1, _loc_4);
                }
                if (itemRenderer != null)
                {
                    _loc_5 = 0;
                    while (_loc_5 < param1)
                    {
                        
                        this.itemRenderer(_loc_5, getChildAt(_loc_5));
                        _loc_5++;
                    }
                }
            }
            return;
        }// end function

        public function refreshVirtualList() : void
        {
            setVirtualListChangedFlag(false);
            return;
        }// end function

        private function checkVirtualList() : void
        {
            if (this._virtualListChanged != 0)
            {
                this._refreshVirtualList();
                GTimers.inst.remove(_refreshVirtualList);
            }
            return;
        }// end function

        private function setVirtualListChangedFlag(param1:Boolean = false) : void
        {
            if (param1)
            {
                _virtualListChanged = 2;
            }
            else if (_virtualListChanged == 0)
            {
                _virtualListChanged = 1;
            }
            GTimers.inst.callLater(_refreshVirtualList);
            return;
        }// end function

        private function _refreshVirtualList() : void
        {
            var _loc_6:* = 0;
            var _loc_4:* = 0;
            var _loc_7:* = 0;
            var _loc_1:* = 0;
            var _loc_2:* = _virtualListChanged == 2;
            _virtualListChanged = 0;
            _eventLocked = true;
            if (_loc_2)
            {
                if (_layout == 0 || _layout == 1)
                {
                    _curLineItemCount = 1;
                }
                else if (_layout == 2)
                {
                    if (_columnCount > 0)
                    {
                        _curLineItemCount = _columnCount;
                    }
                    else
                    {
                        _curLineItemCount = Math.floor((_scrollPane.viewWidth + _columnGap) / (_itemSize.x + _columnGap));
                        if (_curLineItemCount <= 0)
                        {
                            _curLineItemCount = 1;
                        }
                    }
                }
                else if (_layout == 3)
                {
                    if (_lineCount > 0)
                    {
                        _curLineItemCount = _lineCount;
                    }
                    else
                    {
                        _curLineItemCount = Math.floor((_scrollPane.viewHeight + _lineGap) / (_itemSize.y + _lineGap));
                        if (_curLineItemCount <= 0)
                        {
                            _curLineItemCount = 1;
                        }
                    }
                }
                else
                {
                    if (_columnCount > 0)
                    {
                        _curLineItemCount = _columnCount;
                    }
                    else
                    {
                        _curLineItemCount = Math.floor((_scrollPane.viewWidth + _columnGap) / (_itemSize.x + _columnGap));
                        if (_curLineItemCount <= 0)
                        {
                            _curLineItemCount = 1;
                        }
                    }
                    if (_lineCount > 0)
                    {
                        _curLineItemCount2 = _lineCount;
                    }
                    else
                    {
                        _curLineItemCount2 = Math.floor((_scrollPane.viewHeight + _lineGap) / (_itemSize.y + _lineGap));
                        if (_curLineItemCount2 <= 0)
                        {
                            _curLineItemCount2 = 1;
                        }
                    }
                }
            }
            var _loc_5:* = 0;
            var _loc_3:* = 0;
            if (_realNumItems > 0)
            {
                _loc_4 = Math.ceil(_realNumItems / _curLineItemCount) * _curLineItemCount;
                _loc_7 = Math.min(_curLineItemCount, _realNumItems);
                if (_layout == 0 || _layout == 2)
                {
                    _loc_6 = 0;
                    while (_loc_6 < _loc_4)
                    {
                        
                        _loc_5 = _loc_5 + (_virtualItems[_loc_6].height + _lineGap);
                        _loc_6 = _loc_6 + _curLineItemCount;
                    }
                    if (_loc_5 > 0)
                    {
                        _loc_5 = _loc_5 - _lineGap;
                    }
                    if (_autoResizeItem)
                    {
                        _loc_3 = _scrollPane.viewWidth;
                    }
                    else
                    {
                        _loc_6 = 0;
                        while (_loc_6 < _loc_7)
                        {
                            
                            _loc_3 = _loc_3 + (_virtualItems[_loc_6].width + _columnGap);
                            _loc_6++;
                        }
                        if (_loc_3 > 0)
                        {
                            _loc_3 = _loc_3 - _columnGap;
                        }
                    }
                }
                else if (_layout == 1 || _layout == 3)
                {
                    _loc_6 = 0;
                    while (_loc_6 < _loc_4)
                    {
                        
                        _loc_3 = _loc_3 + (_virtualItems[_loc_6].width + _columnGap);
                        _loc_6 = _loc_6 + _curLineItemCount;
                    }
                    if (_loc_3 > 0)
                    {
                        _loc_3 = _loc_3 - _columnGap;
                    }
                    if (_autoResizeItem)
                    {
                        _loc_5 = _scrollPane.viewHeight;
                    }
                    else
                    {
                        _loc_6 = 0;
                        while (_loc_6 < _loc_7)
                        {
                            
                            _loc_5 = _loc_5 + (_virtualItems[_loc_6].height + _lineGap);
                            _loc_6++;
                        }
                        if (_loc_5 > 0)
                        {
                            _loc_5 = _loc_5 - _lineGap;
                        }
                    }
                }
                else
                {
                    _loc_1 = Math.ceil(_loc_4 / (_curLineItemCount * _curLineItemCount2));
                    _loc_3 = _loc_1 * viewWidth;
                    _loc_5 = viewHeight;
                }
            }
            handleAlign(_loc_3, _loc_5);
            _scrollPane.setContentSize(_loc_3, _loc_5);
            _eventLocked = false;
            handleScroll(true);
            return;
        }// end function

        private function __scrolled(event:Event) : void
        {
            handleScroll(false);
            return;
        }// end function

        private function getIndexOnPos1(param1:Boolean) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            if (_realNumItems < _curLineItemCount)
            {
                pos_param = 0;
                return 0;
            }
            if (numChildren > 0 && !param1)
            {
                _loc_3 = this.getChildAt(0).y;
                if (_loc_3 > pos_param)
                {
                    _loc_2 = _firstIndex - _curLineItemCount;
                    while (_loc_2 >= 0)
                    {
                        
                        _loc_3 = _loc_3 - (_virtualItems[_loc_2].height + _lineGap);
                        if (_loc_3 <= pos_param)
                        {
                            pos_param = _loc_3;
                            return _loc_2;
                        }
                        _loc_2 = _loc_2 - _curLineItemCount;
                    }
                    pos_param = 0;
                    return 0;
                }
                _loc_2 = _firstIndex;
                while (_loc_2 < _realNumItems)
                {
                    
                    _loc_4 = _loc_3 + _virtualItems[_loc_2].height + _lineGap;
                    if (_loc_4 > pos_param)
                    {
                        pos_param = _loc_3;
                        return _loc_2;
                    }
                    _loc_3 = _loc_4;
                    _loc_2 = _loc_2 + _curLineItemCount;
                }
                pos_param = _loc_3;
                return _realNumItems - _curLineItemCount;
            }
            _loc_3 = 0;
            _loc_2 = 0;
            while (_loc_2 < _realNumItems)
            {
                
                _loc_4 = _loc_3 + _virtualItems[_loc_2].height + _lineGap;
                if (_loc_4 > pos_param)
                {
                    pos_param = _loc_3;
                    return _loc_2;
                }
                _loc_3 = _loc_4;
                _loc_2 = _loc_2 + _curLineItemCount;
            }
            pos_param = _loc_3;
            return _realNumItems - _curLineItemCount;
        }// end function

        private function getIndexOnPos2(param1:Boolean) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            if (_realNumItems < _curLineItemCount)
            {
                pos_param = 0;
                return 0;
            }
            if (numChildren > 0 && !param1)
            {
                _loc_3 = this.getChildAt(0).x;
                if (_loc_3 > pos_param)
                {
                    _loc_2 = _firstIndex - _curLineItemCount;
                    while (_loc_2 >= 0)
                    {
                        
                        _loc_3 = _loc_3 - (_virtualItems[_loc_2].width + _columnGap);
                        if (_loc_3 <= pos_param)
                        {
                            pos_param = _loc_3;
                            return _loc_2;
                        }
                        _loc_2 = _loc_2 - _curLineItemCount;
                    }
                    pos_param = 0;
                    return 0;
                }
                _loc_2 = _firstIndex;
                while (_loc_2 < _realNumItems)
                {
                    
                    _loc_4 = _loc_3 + _virtualItems[_loc_2].width + _columnGap;
                    if (_loc_4 > pos_param)
                    {
                        pos_param = _loc_3;
                        return _loc_2;
                    }
                    _loc_3 = _loc_4;
                    _loc_2 = _loc_2 + _curLineItemCount;
                }
                pos_param = _loc_3;
                return _realNumItems - _curLineItemCount;
            }
            _loc_3 = 0;
            _loc_2 = 0;
            while (_loc_2 < _realNumItems)
            {
                
                _loc_4 = _loc_3 + _virtualItems[_loc_2].width + _columnGap;
                if (_loc_4 > pos_param)
                {
                    pos_param = _loc_3;
                    return _loc_2;
                }
                _loc_3 = _loc_4;
                _loc_2 = _loc_2 + _curLineItemCount;
            }
            pos_param = _loc_3;
            return _realNumItems - _curLineItemCount;
        }// end function

        private function getIndexOnPos3(param1:Boolean) : int
        {
            var _loc_4:* = 0;
            var _loc_7:* = NaN;
            if (_realNumItems < _curLineItemCount)
            {
                pos_param = 0;
                return 0;
            }
            var _loc_3:* = this.viewWidth;
            var _loc_6:* = Math.floor(pos_param / _loc_3);
            var _loc_2:* = Math.floor(pos_param / _loc_3) * (_curLineItemCount * _curLineItemCount2);
            var _loc_5:* = _loc_6 * _loc_3;
            _loc_4 = 0;
            while (_loc_4 < _curLineItemCount)
            {
                
                _loc_7 = _loc_5 + _virtualItems[_loc_2 + _loc_4].width + _columnGap;
                if (_loc_7 > pos_param)
                {
                    pos_param = _loc_5;
                    return _loc_2 + _loc_4;
                }
                _loc_5 = _loc_7;
                _loc_4++;
            }
            pos_param = _loc_5;
            return _loc_2 + _curLineItemCount - 1;
        }// end function

        private function handleScroll(param1:Boolean) : void
        {
            var _loc_2:* = 0;
            if (_eventLocked)
            {
                return;
            }
            if (_layout == 0 || _layout == 2)
            {
                _loc_2 = 0;
                while (handleScroll1(param1))
                {
                    
                    _loc_2++;
                    param1 = false;
                    if (_loc_2 > 20)
                    {
                        this.trace("FairyGUI: list will never be filled as the item renderer function always returns a different size.");
                        break;
                    }
                }
                handleArchOrder1();
            }
            else if (_layout == 1 || _layout == 3)
            {
                _loc_2 = 0;
                while (handleScroll2(param1))
                {
                    
                    _loc_2++;
                    param1 = false;
                    if (_loc_2 > 20)
                    {
                        this.trace("FairyGUI: list will never be filled as the item renderer function always returns a different size.");
                        break;
                    }
                }
                handleArchOrder2();
            }
            else
            {
                handleScroll3(param1);
            }
            _boundsChanged = false;
            return;
        }// end function

        private function handleScroll1(param1:Boolean) : Boolean
        {
            var _loc_7:* = false;
            var _loc_13:* = null;
            var _loc_2:* = null;
            var _loc_10:* = 0;
            var _loc_8:* = 0;
            var _loc_17:* = null;
            var _loc_15:* = _scrollPane.scrollingPosY;
            var _loc_3:* = _scrollPane.scrollingPosY + _scrollPane.viewHeight;
            var _loc_20:* = _loc_3 == _scrollPane.contentHeight;
            GList.pos_param = _loc_15;
            var _loc_18:* = getIndexOnPos1(param1);
            _loc_15 = GList.pos_param;
            if (_loc_18 == _firstIndex && !param1)
            {
                return false;
            }
            var _loc_12:* = _firstIndex;
            _firstIndex = _loc_18;
            var _loc_23:* = _loc_18;
            var _loc_5:* = _loc_12 > _loc_18;
            var _loc_9:* = this.numChildren;
            var _loc_22:* = _loc_12 + _loc_9 - 1;
            var _loc_4:* = _loc_5 ? (_loc_22) : (_loc_12);
            var _loc_16:* = 0;
            var _loc_19:* = _loc_15;
            var _loc_21:* = 0;
            var _loc_14:* = 0;
            var _loc_11:* = defaultItem;
            var _loc_6:* = (_scrollPane.viewWidth - _columnGap * (_curLineItemCount - 1)) / _curLineItemCount;
            (itemInfoVer + 1);
            while (_loc_23 < _realNumItems && (_loc_20 || _loc_19 < _loc_3))
            {
                
                _loc_2 = _virtualItems[_loc_23];
                if (_loc_2.obj == null || param1)
                {
                    if (itemProvider != null)
                    {
                        _loc_11 = this.itemProvider(_loc_23 % _numItems);
                        if (_loc_11 == null)
                        {
                            _loc_11 = _defaultItem;
                        }
                        _loc_11 = UIPackage.normalizeURL(_loc_11);
                    }
                    if (_loc_2.obj != null && _loc_2.obj.resourceURL != _loc_11)
                    {
                        if (_loc_2.obj is GButton)
                        {
                            _loc_2.selected = this.GButton(_loc_2.obj).selected;
                        }
                        removeChildToPool(_loc_2.obj);
                        _loc_2.obj = null;
                    }
                }
                if (_loc_2.obj == null)
                {
                    if (_loc_5)
                    {
                        _loc_10 = _loc_4;
                        while (_loc_10 >= _loc_12)
                        {
                            
                            _loc_13 = _virtualItems[_loc_10];
                            if (_loc_13.obj != null && _loc_13.updateFlag != itemInfoVer && _loc_13.obj.resourceURL == _loc_11)
                            {
                                if (_loc_13.obj is GButton)
                                {
                                    _loc_13.selected = this.GButton(_loc_13.obj).selected;
                                }
                                _loc_2.obj = _loc_13.obj;
                                _loc_13.obj = null;
                                if (_loc_10 == _loc_4)
                                {
                                    _loc_4--;
                                }
                                break;
                            }
                            _loc_10--;
                        }
                    }
                    else
                    {
                        _loc_10 = _loc_4;
                        while (_loc_10 <= _loc_22)
                        {
                            
                            _loc_13 = _virtualItems[_loc_10];
                            if (_loc_13.obj != null && _loc_13.updateFlag != itemInfoVer && _loc_13.obj.resourceURL == _loc_11)
                            {
                                if (_loc_13.obj is GButton)
                                {
                                    _loc_13.selected = this.GButton(_loc_13.obj).selected;
                                }
                                _loc_2.obj = _loc_13.obj;
                                _loc_13.obj = null;
                                if (_loc_10 == _loc_4)
                                {
                                    _loc_4++;
                                }
                                break;
                            }
                            _loc_10++;
                        }
                    }
                    if (_loc_2.obj != null)
                    {
                        setChildIndex(_loc_2.obj, _loc_5 ? (_loc_23 - _loc_18) : (numChildren));
                    }
                    else
                    {
                        _loc_2.obj = _pool.getObject(_loc_11);
                        if (_loc_5)
                        {
                            this.addChildAt(_loc_2.obj, _loc_23 - _loc_18);
                        }
                        else
                        {
                            this.addChild(_loc_2.obj);
                        }
                    }
                    if (_loc_2.obj is GButton)
                    {
                        this.GButton(_loc_2.obj).selected = _loc_2.selected;
                    }
                    _loc_7 = true;
                }
                else
                {
                    _loc_7 = param1;
                }
                if (_loc_7)
                {
                    if (_autoResizeItem && (_layout == 0 || _columnCount > 0))
                    {
                        _loc_2.obj.setSize(_loc_6, _loc_2.obj.height, true);
                    }
                    this.itemRenderer(_loc_23 % _numItems, _loc_2.obj);
                    if (_loc_23 % _curLineItemCount == 0)
                    {
                        _loc_21 = _loc_21 + (Math.ceil(_loc_2.obj.height) - _loc_2.height);
                        if (_loc_23 == _loc_18 && _loc_12 > _loc_18)
                        {
                            _loc_14 = Math.ceil(_loc_2.obj.height) - _loc_2.height;
                        }
                    }
                    _loc_2.width = Math.ceil(_loc_2.obj.width);
                    _loc_2.height = Math.ceil(_loc_2.obj.height);
                }
                _loc_2.updateFlag = itemInfoVer;
                _loc_2.obj.setXY(_loc_16, _loc_19);
                if (_loc_23 == _loc_18)
                {
                    _loc_3 = _loc_3 + _loc_2.height;
                }
                _loc_16 = _loc_16 + (_loc_2.width + _columnGap);
                if (_loc_23 % _curLineItemCount == (_curLineItemCount - 1))
                {
                    _loc_16 = 0;
                    _loc_19 = _loc_19 + (_loc_2.height + _lineGap);
                }
                _loc_23++;
            }
            _loc_8 = 0;
            while (_loc_8 < _loc_9)
            {
                
                _loc_2 = _virtualItems[_loc_12 + _loc_8];
                if (_loc_2.updateFlag != itemInfoVer && _loc_2.obj != null)
                {
                    if (_loc_2.obj is GButton)
                    {
                        _loc_2.selected = this.GButton(_loc_2.obj).selected;
                    }
                    removeChildToPool(_loc_2.obj);
                    _loc_2.obj = null;
                }
                _loc_8++;
            }
            _loc_9 = _children.length;
            _loc_8 = 0;
            while (_loc_8 < _loc_9)
            {
                
                _loc_17 = _virtualItems[_loc_18 + _loc_8].obj;
                if (_children[_loc_8] != _loc_17)
                {
                    setChildIndex(_loc_17, _loc_8);
                }
                _loc_8++;
            }
            if (_loc_21 != 0 || _loc_14 != 0)
            {
                _scrollPane.changeContentSizeOnScrolling(0, _loc_21, 0, _loc_14);
            }
            if (_loc_23 > 0 && this.numChildren > 0 && _container.y <= 0 && getChildAt(0).y > -_container.y)
            {
                return true;
            }
            return false;
        }// end function

        private function handleScroll2(param1:Boolean) : Boolean
        {
            var _loc_7:* = false;
            var _loc_13:* = null;
            var _loc_2:* = null;
            var _loc_10:* = 0;
            var _loc_8:* = 0;
            var _loc_17:* = null;
            var _loc_15:* = _scrollPane.scrollingPosX;
            var _loc_3:* = _scrollPane.scrollingPosX + _scrollPane.viewWidth;
            var _loc_20:* = _loc_15 == _scrollPane.contentWidth;
            GList.pos_param = _loc_15;
            var _loc_18:* = getIndexOnPos2(param1);
            _loc_15 = GList.pos_param;
            if (_loc_18 == _firstIndex && !param1)
            {
                return false;
            }
            var _loc_12:* = _firstIndex;
            _firstIndex = _loc_18;
            var _loc_23:* = _loc_18;
            var _loc_5:* = _loc_12 > _loc_18;
            var _loc_9:* = this.numChildren;
            var _loc_22:* = _loc_12 + _loc_9 - 1;
            var _loc_4:* = _loc_5 ? (_loc_22) : (_loc_12);
            var _loc_16:* = _loc_15;
            var _loc_19:* = 0;
            var _loc_21:* = 0;
            var _loc_14:* = 0;
            var _loc_11:* = defaultItem;
            var _loc_6:* = (_scrollPane.viewHeight - _lineGap * (_curLineItemCount - 1)) / _curLineItemCount;
            (itemInfoVer + 1);
            while (_loc_23 < _realNumItems && (_loc_20 || _loc_16 < _loc_3))
            {
                
                _loc_2 = _virtualItems[_loc_23];
                if (_loc_2.obj == null || param1)
                {
                    if (itemProvider != null)
                    {
                        _loc_11 = this.itemProvider(_loc_23 % _numItems);
                        if (_loc_11 == null)
                        {
                            _loc_11 = _defaultItem;
                        }
                        _loc_11 = UIPackage.normalizeURL(_loc_11);
                    }
                    if (_loc_2.obj != null && _loc_2.obj.resourceURL != _loc_11)
                    {
                        if (_loc_2.obj is GButton)
                        {
                            _loc_2.selected = this.GButton(_loc_2.obj).selected;
                        }
                        removeChildToPool(_loc_2.obj);
                        _loc_2.obj = null;
                    }
                }
                if (_loc_2.obj == null)
                {
                    if (_loc_5)
                    {
                        _loc_10 = _loc_4;
                        while (_loc_10 >= _loc_12)
                        {
                            
                            _loc_13 = _virtualItems[_loc_10];
                            if (_loc_13.obj != null && _loc_13.updateFlag != itemInfoVer && _loc_13.obj.resourceURL == _loc_11)
                            {
                                if (_loc_13.obj is GButton)
                                {
                                    _loc_13.selected = this.GButton(_loc_13.obj).selected;
                                }
                                _loc_2.obj = _loc_13.obj;
                                _loc_13.obj = null;
                                if (_loc_10 == _loc_4)
                                {
                                    _loc_4--;
                                }
                                break;
                            }
                            _loc_10--;
                        }
                    }
                    else
                    {
                        _loc_10 = _loc_4;
                        while (_loc_10 <= _loc_22)
                        {
                            
                            _loc_13 = _virtualItems[_loc_10];
                            if (_loc_13.obj != null && _loc_13.updateFlag != itemInfoVer && _loc_13.obj.resourceURL == _loc_11)
                            {
                                if (_loc_13.obj is GButton)
                                {
                                    _loc_13.selected = this.GButton(_loc_13.obj).selected;
                                }
                                _loc_2.obj = _loc_13.obj;
                                _loc_13.obj = null;
                                if (_loc_10 == _loc_4)
                                {
                                    _loc_4++;
                                }
                                break;
                            }
                            _loc_10++;
                        }
                    }
                    if (_loc_2.obj != null)
                    {
                        setChildIndex(_loc_2.obj, _loc_5 ? (_loc_23 - _loc_18) : (numChildren));
                    }
                    else
                    {
                        _loc_2.obj = _pool.getObject(_loc_11);
                        if (_loc_5)
                        {
                            this.addChildAt(_loc_2.obj, _loc_23 - _loc_18);
                        }
                        else
                        {
                            this.addChild(_loc_2.obj);
                        }
                    }
                    if (_loc_2.obj is GButton)
                    {
                        this.GButton(_loc_2.obj).selected = _loc_2.selected;
                    }
                    _loc_7 = true;
                }
                else
                {
                    _loc_7 = param1;
                }
                if (_loc_7)
                {
                    if (_autoResizeItem && (_layout == 1 || _lineCount > 0))
                    {
                        _loc_2.obj.setSize(_loc_2.obj.width, _loc_6, true);
                    }
                    this.itemRenderer(_loc_23 % _numItems, _loc_2.obj);
                    if (_loc_23 % _curLineItemCount == 0)
                    {
                        _loc_21 = _loc_21 + (Math.ceil(_loc_2.obj.width) - _loc_2.width);
                        if (_loc_23 == _loc_18 && _loc_12 > _loc_18)
                        {
                            _loc_14 = Math.ceil(_loc_2.obj.width) - _loc_2.width;
                        }
                    }
                    _loc_2.width = Math.ceil(_loc_2.obj.width);
                    _loc_2.height = Math.ceil(_loc_2.obj.height);
                }
                _loc_2.updateFlag = itemInfoVer;
                _loc_2.obj.setXY(_loc_16, _loc_19);
                if (_loc_23 == _loc_18)
                {
                    _loc_3 = _loc_3 + _loc_2.width;
                }
                _loc_19 = _loc_19 + (_loc_2.height + _lineGap);
                if (_loc_23 % _curLineItemCount == (_curLineItemCount - 1))
                {
                    _loc_19 = 0;
                    _loc_16 = _loc_16 + (_loc_2.width + _columnGap);
                }
                _loc_23++;
            }
            _loc_8 = 0;
            while (_loc_8 < _loc_9)
            {
                
                _loc_2 = _virtualItems[_loc_12 + _loc_8];
                if (_loc_2.updateFlag != itemInfoVer && _loc_2.obj != null)
                {
                    if (_loc_2.obj is GButton)
                    {
                        _loc_2.selected = this.GButton(_loc_2.obj).selected;
                    }
                    removeChildToPool(_loc_2.obj);
                    _loc_2.obj = null;
                }
                _loc_8++;
            }
            _loc_9 = _children.length;
            _loc_8 = 0;
            while (_loc_8 < _loc_9)
            {
                
                _loc_17 = _virtualItems[_loc_18 + _loc_8].obj;
                if (_children[_loc_8] != _loc_17)
                {
                    setChildIndex(_loc_17, _loc_8);
                }
                _loc_8++;
            }
            if (_loc_21 != 0 || _loc_14 != 0)
            {
                _scrollPane.changeContentSizeOnScrolling(_loc_21, 0, _loc_14, 0);
            }
            if (_loc_23 > 0 && this.numChildren > 0 && _container.x <= 0 && getChildAt(0).x > -_container.x)
            {
                return true;
            }
            return false;
        }// end function

        private function handleScroll3(param1:Boolean) : void
        {
            var _loc_6:* = false;
            var _loc_18:* = 0;
            var _loc_10:* = null;
            var _loc_13:* = null;
            var _loc_3:* = 0;
            var _loc_11:* = _scrollPane.scrollingPosX;
            GList.pos_param = _loc_11;
            var _loc_22:* = getIndexOnPos3(param1);
            _loc_11 = GList.pos_param;
            if (_loc_22 == _firstIndex && !param1)
            {
                return;
            }
            var _loc_9:* = _firstIndex;
            _firstIndex = _loc_22;
            var _loc_15:* = _loc_9;
            var _loc_5:* = _virtualItems.length;
            var _loc_7:* = _curLineItemCount * _curLineItemCount2;
            var _loc_4:* = _loc_22 % _curLineItemCount;
            var _loc_17:* = this.viewWidth;
            var _loc_25:* = _loc_22 / _loc_7;
            var _loc_8:* = _loc_22 / _loc_7 * _loc_7;
            var _loc_12:* = _loc_22 / _loc_7 * _loc_7 + _loc_7 * 2;
            var _loc_19:* = _defaultItem;
            var _loc_16:* = (_scrollPane.viewWidth - _columnGap * (_curLineItemCount - 1)) / _curLineItemCount;
            var _loc_26:* = (_scrollPane.viewHeight - _lineGap * (_curLineItemCount2 - 1)) / _curLineItemCount2;
            (itemInfoVer + 1);
            _loc_18 = _loc_8;
            while (_loc_18 < _loc_12)
            {
                
                if (_loc_18 < _realNumItems)
                {
                    _loc_3 = _loc_18 % _curLineItemCount;
                    if (_loc_18 - _loc_8 < _loc_7)
                    {
                    }
                    else
                    {
                    }
                    _loc_13 = _virtualItems[_loc_18];
                    _loc_13.updateFlag = itemInfoVer;
                }
                _loc_18++;
            }
            var _loc_21:* = null;
            var _loc_23:* = 0;
            _loc_18 = _loc_8;
            while (_loc_18 < _loc_12)
            {
                
                if (_loc_18 < _realNumItems)
                {
                    _loc_13 = _virtualItems[_loc_18];
                    if (_loc_13.updateFlag == itemInfoVer)
                    {
                        if (_loc_13.obj == null)
                        {
                            while (_loc_15 < _loc_5)
                            {
                                
                                _loc_10 = _virtualItems[_loc_15];
                                if (_loc_10.obj != null && _loc_10.updateFlag != itemInfoVer)
                                {
                                    if (_loc_10.obj is GButton)
                                    {
                                        _loc_10.selected = this.GButton(_loc_10.obj).selected;
                                    }
                                    _loc_13.obj = _loc_10.obj;
                                    _loc_10.obj = null;
                                    break;
                                }
                                _loc_15++;
                            }
                            if (_loc_23 == -1)
                            {
                                _loc_23 = getChildIndex(_loc_21) + 1;
                            }
                            if (_loc_13.obj == null)
                            {
                                if (itemProvider != null)
                                {
                                    _loc_19 = this.itemProvider(_loc_18 % _numItems);
                                    if (_loc_19 == null)
                                    {
                                        _loc_19 = _defaultItem;
                                    }
                                    _loc_19 = UIPackage.normalizeURL(_loc_19);
                                }
                                _loc_13.obj = _pool.getObject(_loc_19);
                                this.addChildAt(_loc_13.obj, _loc_23);
                            }
                            else
                            {
                                _loc_23 = setChildIndexBefore(_loc_13.obj, _loc_23);
                            }
                            _loc_23++;
                            if (_loc_13.obj is GButton)
                            {
                                this.GButton(_loc_13.obj).selected = _loc_13.selected;
                            }
                            _loc_6 = true;
                        }
                        else
                        {
                            _loc_6 = param1;
                            _loc_23 = -1;
                            _loc_21 = _loc_13.obj;
                        }
                        if (_loc_6)
                        {
                            if (_autoResizeItem)
                            {
                                if (_curLineItemCount == _columnCount && _curLineItemCount2 == _lineCount)
                                {
                                    _loc_21.setSize(_loc_16, _loc_26, true);
                                }
                                else if (_curLineItemCount == _columnCount)
                                {
                                    _loc_21.setSize(_loc_16, _loc_21.height, true);
                                }
                                else if (_curLineItemCount2 == _lineCount)
                                {
                                    _loc_21.setSize(_loc_21.width, _loc_26, true);
                                }
                            }
                            this.itemRenderer(_loc_18 % _numItems, _loc_13.obj);
                            _loc_13.width = Math.ceil(_loc_21.width);
                            _loc_13.height = Math.ceil(_loc_21.height);
                        }
                    }
                }
                _loc_18++;
            }
            var _loc_20:* = _loc_8 / _loc_7 * _loc_17;
            var _loc_2:* = _loc_8 / _loc_7 * _loc_17;
            var _loc_14:* = 0;
            var _loc_24:* = 0;
            _loc_18 = _loc_8;
            while (_loc_18 < _loc_12)
            {
                
                if (_loc_18 < _realNumItems)
                {
                    _loc_13 = _virtualItems[_loc_18];
                    if (_loc_13.updateFlag == itemInfoVer)
                    {
                        _loc_21.setXY(_loc_2, _loc_14);
                    }
                    if (_loc_13.height > _loc_24)
                    {
                        _loc_24 = _loc_13.height;
                    }
                    if (_loc_18 % _curLineItemCount == (_curLineItemCount - 1))
                    {
                        _loc_2 = _loc_20;
                        _loc_14 = _loc_14 + (_loc_24 + _lineGap);
                        _loc_24 = 0;
                        if (_loc_18 == _loc_8 + _loc_7 - 1)
                        {
                            _loc_20 = _loc_20 + _loc_17;
                            _loc_2 = _loc_20;
                            _loc_14 = 0;
                        }
                    }
                    else
                    {
                        _loc_2 = _loc_2 + (_loc_13.width + _columnGap);
                    }
                }
                _loc_18++;
            }
            _loc_18 = _loc_15;
            while (_loc_18 < _loc_5)
            {
                
                _loc_13 = _virtualItems[_loc_18];
                if (_loc_13.updateFlag != itemInfoVer && _loc_13.obj != null)
                {
                    if (_loc_13.obj is GButton)
                    {
                        _loc_13.selected = this.GButton(_loc_13.obj).selected;
                    }
                    removeChildToPool(_loc_13.obj);
                    _loc_13.obj = null;
                }
                _loc_18++;
            }
            return;
        }// end function

        private function handleArchOrder1() : void
        {
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_7:* = NaN;
            var _loc_1:* = 0;
            var _loc_3:* = 0;
            var _loc_6:* = 0;
            var _loc_2:* = null;
            if (this.childrenRenderOrder == 2)
            {
                _loc_4 = _scrollPane.posY + this.viewHeight / 2;
                _loc_7 = 2147483647;
                _loc_1 = 0;
                _loc_3 = this.numChildren;
                _loc_6 = 0;
                while (_loc_6 < _loc_3)
                {
                    
                    _loc_2 = getChildAt(_loc_6);
                    if (!foldInvisibleItems || _loc_2.visible)
                    {
                        _loc_5 = Math.abs(_loc_4 - _loc_2.y - _loc_2.height / 2);
                        if (_loc_5 < _loc_7)
                        {
                            _loc_7 = _loc_5;
                            _loc_1 = _loc_6;
                        }
                    }
                    _loc_6++;
                }
                this.apexIndex = _loc_1;
            }
            return;
        }// end function

        private function handleArchOrder2() : void
        {
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_7:* = NaN;
            var _loc_1:* = 0;
            var _loc_3:* = 0;
            var _loc_6:* = 0;
            var _loc_2:* = null;
            if (this.childrenRenderOrder == 2)
            {
                _loc_4 = _scrollPane.posX + this.viewWidth / 2;
                _loc_7 = 2147483647;
                _loc_1 = 0;
                _loc_3 = this.numChildren;
                _loc_6 = 0;
                while (_loc_6 < _loc_3)
                {
                    
                    _loc_2 = getChildAt(_loc_6);
                    if (!foldInvisibleItems || _loc_2.visible)
                    {
                        _loc_5 = Math.abs(_loc_4 - _loc_2.x - _loc_2.width / 2);
                        if (_loc_5 < _loc_7)
                        {
                            _loc_7 = _loc_5;
                            _loc_1 = _loc_6;
                        }
                    }
                    _loc_6++;
                }
                this.apexIndex = _loc_1;
            }
            return;
        }// end function

        private function handleAlign(param1:Number, param2:Number) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            if (param2 < viewHeight)
            {
                if (_verticalAlign == 1)
                {
                    _loc_4 = (viewHeight - param2) / 2;
                }
                else if (_verticalAlign == 2)
                {
                    _loc_4 = viewHeight - param2;
                }
            }
            if (param1 < this.viewWidth)
            {
                if (_align == 1)
                {
                    _loc_3 = (viewWidth - param1) / 2;
                }
                else if (_align == 2)
                {
                    _loc_3 = viewWidth - param1;
                }
            }
            if (_loc_3 != _alignOffset.x || _loc_4 != _alignOffset.y)
            {
                _alignOffset.setTo(_loc_3, _loc_4);
                if (_scrollPane != null)
                {
                    _scrollPane.adjustMaskContainer();
                }
                else
                {
                    _container.x = _margin.left + _alignOffset.x;
                    _container.y = _margin.top + _alignOffset.y;
                }
            }
            return;
        }// end function

        override protected function updateBounds() : void
        {
            var _loc_5:* = 0;
            var _loc_16:* = null;
            var _loc_13:* = 0;
            var _loc_14:* = 0;
            var _loc_17:* = 0;
            var _loc_12:* = 0;
            var _loc_1:* = 0;
            var _loc_11:* = 0;
            var _loc_18:* = NaN;
            var _loc_7:* = 0;
            if (_virtual)
            {
                return;
            }
            var _loc_8:* = 0;
            var _loc_15:* = 0;
            var _loc_9:* = 0;
            var _loc_4:* = _children.length;
            var _loc_2:* = this.viewWidth;
            var _loc_6:* = this.viewHeight;
            var _loc_10:* = 0;
            var _loc_3:* = 0;
            if (_layout == 0)
            {
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_16 = getChildAt(_loc_5);
                    if (!(foldInvisibleItems && !_loc_16.visible))
                    {
                        if (_loc_14 != 0)
                        {
                            _loc_14 = _loc_14 + _lineGap;
                        }
                        _loc_16.y = _loc_14;
                        if (_autoResizeItem)
                        {
                            _loc_16.setSize(_loc_2, _loc_16.height, true);
                        }
                        _loc_14 = _loc_14 + Math.ceil(_loc_16.height);
                        if (_loc_16.width > _loc_17)
                        {
                            _loc_17 = _loc_16.width;
                        }
                    }
                    _loc_5++;
                }
                _loc_1 = _loc_14;
                if (_loc_1 <= _loc_6 && _autoResizeItem && _scrollPane && _scrollPane._displayInDemand && _scrollPane.vtScrollBar)
                {
                    _loc_2 = _loc_2 + _scrollPane.vtScrollBar.width;
                    _loc_5 = 0;
                    while (_loc_5 < _loc_4)
                    {
                        
                        _loc_16 = getChildAt(_loc_5);
                        if (!(foldInvisibleItems && !_loc_16.visible))
                        {
                            _loc_16.setSize(_loc_2, _loc_16.height, true);
                            if (_loc_16.width > _loc_17)
                            {
                                _loc_17 = _loc_16.width;
                            }
                        }
                        _loc_5++;
                    }
                }
                _loc_11 = Math.ceil(_loc_17);
            }
            else if (_layout == 1)
            {
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_16 = getChildAt(_loc_5);
                    if (!(foldInvisibleItems && !_loc_16.visible))
                    {
                        if (_loc_13 != 0)
                        {
                            _loc_13 = _loc_13 + _columnGap;
                        }
                        _loc_16.x = _loc_13;
                        if (_autoResizeItem)
                        {
                            _loc_16.setSize(_loc_16.width, _loc_6, true);
                        }
                        _loc_13 = _loc_13 + Math.ceil(_loc_16.width);
                        if (_loc_16.height > _loc_12)
                        {
                            _loc_12 = _loc_16.height;
                        }
                    }
                    _loc_5++;
                }
                _loc_11 = _loc_13;
                if (_loc_11 <= _loc_2 && _autoResizeItem && _scrollPane && _scrollPane._displayInDemand && _scrollPane.hzScrollBar)
                {
                    _loc_6 = _loc_6 + _scrollPane.hzScrollBar.height;
                    _loc_5 = 0;
                    while (_loc_5 < _loc_4)
                    {
                        
                        _loc_16 = getChildAt(_loc_5);
                        if (!(foldInvisibleItems && !_loc_16.visible))
                        {
                            _loc_16.setSize(_loc_16.width, _loc_6, true);
                            if (_loc_16.height > _loc_12)
                            {
                                _loc_12 = _loc_16.height;
                            }
                        }
                        _loc_5++;
                    }
                }
                _loc_1 = Math.ceil(_loc_12);
            }
            else if (_layout == 2)
            {
                if (_autoResizeItem && _columnCount > 0)
                {
                    _loc_5 = 0;
                    while (_loc_5 < _loc_4)
                    {
                        
                        _loc_16 = getChildAt(_loc_5);
                        if (!(foldInvisibleItems && !_loc_16.visible))
                        {
                            _loc_10 = _loc_10 + _loc_16.sourceWidth;
                            _loc_8++;
                            if (_loc_8 == _columnCount || _loc_5 == (_loc_4 - 1))
                            {
                                _loc_18 = (_loc_2 - _loc_10 - (_loc_8 - 1) * _columnGap) / _loc_10;
                                _loc_13 = 0;
                                _loc_8 = _loc_3;
                                while (_loc_8 <= _loc_5)
                                {
                                    
                                    _loc_16 = getChildAt(_loc_8);
                                    if (!(foldInvisibleItems && !_loc_16.visible))
                                    {
                                        _loc_16.setXY(_loc_13, _loc_14);
                                        if (_loc_8 < _loc_5)
                                        {
                                            _loc_16.setSize(_loc_16.sourceWidth + Math.round(_loc_16.sourceWidth * _loc_18), _loc_16.height, true);
                                            _loc_13 = _loc_13 + (Math.ceil(_loc_16.width) + _columnGap);
                                        }
                                        else
                                        {
                                            _loc_16.setSize(_loc_2 - _loc_13, _loc_16.height, true);
                                        }
                                        if (_loc_16.height > _loc_12)
                                        {
                                            _loc_12 = _loc_16.height;
                                        }
                                    }
                                    _loc_8++;
                                }
                                _loc_14 = _loc_14 + (Math.ceil(_loc_12) + _lineGap);
                                _loc_12 = 0;
                                _loc_8 = 0;
                                _loc_3 = _loc_5 + 1;
                                _loc_10 = 0;
                            }
                        }
                        _loc_5++;
                    }
                    _loc_1 = _loc_14 + Math.ceil(_loc_12);
                    _loc_11 = _loc_2;
                }
                else
                {
                    _loc_5 = 0;
                    while (_loc_5 < _loc_4)
                    {
                        
                        _loc_16 = getChildAt(_loc_5);
                        if (!(foldInvisibleItems && !_loc_16.visible))
                        {
                            if (_loc_13 != 0)
                            {
                                _loc_13 = _loc_13 + _columnGap;
                            }
                            if (_columnCount != 0 && _loc_8 >= _columnCount || _columnCount == 0 && _loc_13 + _loc_16.width > _loc_2 && _loc_12 != 0)
                            {
                                _loc_13 = 0;
                                _loc_14 = _loc_14 + (Math.ceil(_loc_12) + _lineGap);
                                _loc_12 = 0;
                                _loc_8 = 0;
                            }
                            _loc_16.setXY(_loc_13, _loc_14);
                            _loc_13 = _loc_13 + Math.ceil(_loc_16.width);
                            if (_loc_13 > _loc_17)
                            {
                                _loc_17 = _loc_13;
                            }
                            if (_loc_16.height > _loc_12)
                            {
                                _loc_12 = _loc_16.height;
                            }
                            _loc_8++;
                        }
                        _loc_5++;
                    }
                    _loc_1 = _loc_14 + Math.ceil(_loc_12);
                    _loc_11 = Math.ceil(_loc_17);
                }
            }
            else if (_layout == 3)
            {
                if (_autoResizeItem && _lineCount > 0)
                {
                    _loc_5 = 0;
                    while (_loc_5 < _loc_4)
                    {
                        
                        _loc_16 = getChildAt(_loc_5);
                        if (!(foldInvisibleItems && !_loc_16.visible))
                        {
                            _loc_10 = _loc_10 + _loc_16.sourceHeight;
                            _loc_8++;
                            if (_loc_8 == _lineCount || _loc_5 == (_loc_4 - 1))
                            {
                                _loc_18 = (_loc_6 - _loc_10 - (_loc_8 - 1) * _lineGap) / _loc_10;
                                _loc_14 = 0;
                                _loc_8 = _loc_3;
                                while (_loc_8 <= _loc_5)
                                {
                                    
                                    _loc_16 = getChildAt(_loc_8);
                                    if (!(foldInvisibleItems && !_loc_16.visible))
                                    {
                                        _loc_16.setXY(_loc_13, _loc_14);
                                        if (_loc_8 < _loc_5)
                                        {
                                            _loc_16.setSize(_loc_16.width, _loc_16.sourceHeight + Math.round(_loc_16.sourceHeight * _loc_18), true);
                                            _loc_14 = _loc_14 + (Math.ceil(_loc_16.height) + _lineGap);
                                        }
                                        else
                                        {
                                            _loc_16.setSize(_loc_16.width, _loc_6 - _loc_14, true);
                                        }
                                        if (_loc_16.width > _loc_17)
                                        {
                                            _loc_17 = _loc_16.width;
                                        }
                                    }
                                    _loc_8++;
                                }
                                _loc_13 = _loc_13 + (Math.ceil(_loc_17) + _columnGap);
                                _loc_17 = 0;
                                _loc_8 = 0;
                                _loc_3 = _loc_5 + 1;
                                _loc_10 = 0;
                            }
                        }
                        _loc_5++;
                    }
                    _loc_11 = _loc_13 + Math.ceil(_loc_17);
                    _loc_1 = _loc_6;
                }
                else
                {
                    _loc_5 = 0;
                    while (_loc_5 < _loc_4)
                    {
                        
                        _loc_16 = getChildAt(_loc_5);
                        if (!(foldInvisibleItems && !_loc_16.visible))
                        {
                            if (_loc_14 != 0)
                            {
                                _loc_14 = _loc_14 + _lineGap;
                            }
                            if (_lineCount != 0 && _loc_8 >= _lineCount || _lineCount == 0 && _loc_14 + _loc_16.height > _loc_6 && _loc_17 != 0)
                            {
                                _loc_14 = 0;
                                _loc_13 = _loc_13 + (Math.ceil(_loc_17) + _columnGap);
                                _loc_17 = 0;
                                _loc_8 = 0;
                            }
                            _loc_16.setXY(_loc_13, _loc_14);
                            _loc_14 = _loc_14 + Math.ceil(_loc_16.height);
                            if (_loc_14 > _loc_12)
                            {
                                _loc_12 = _loc_14;
                            }
                            if (_loc_16.width > _loc_17)
                            {
                                _loc_17 = _loc_16.width;
                            }
                            _loc_8++;
                        }
                        _loc_5++;
                    }
                    _loc_11 = _loc_13 + Math.ceil(_loc_17);
                    _loc_1 = Math.ceil(_loc_12);
                }
            }
            else
            {
                if (_autoResizeItem && _lineCount > 0)
                {
                    _loc_7 = Math.floor((_loc_6 - (_lineCount - 1) * _lineGap) / _lineCount);
                }
                if (_autoResizeItem && _columnCount > 0)
                {
                    _loc_5 = 0;
                    while (_loc_5 < _loc_4)
                    {
                        
                        _loc_16 = getChildAt(_loc_5);
                        if (!(foldInvisibleItems && !_loc_16.visible))
                        {
                            if (_loc_8 == 0 && (_lineCount != 0 && _loc_9 >= _lineCount || _lineCount == 0 && _loc_14 + _loc_16.height > _loc_6))
                            {
                                _loc_15++;
                                _loc_14 = 0;
                                _loc_9 = 0;
                            }
                            _loc_10 = _loc_10 + _loc_16.sourceWidth;
                            _loc_8++;
                            if (_loc_8 == _columnCount || _loc_5 == (_loc_4 - 1))
                            {
                                _loc_18 = (_loc_2 - _loc_10 - (_loc_8 - 1) * _columnGap) / _loc_10;
                                _loc_13 = 0;
                                _loc_8 = _loc_3;
                                while (_loc_8 <= _loc_5)
                                {
                                    
                                    _loc_16 = getChildAt(_loc_8);
                                    if (!(foldInvisibleItems && !_loc_16.visible))
                                    {
                                        _loc_16.setXY(_loc_15 * _loc_2 + _loc_13, _loc_14);
                                        if (_loc_8 < _loc_5)
                                        {
                                            _loc_16.setSize(_loc_16.sourceWidth + Math.round(_loc_16.sourceWidth * _loc_18), _lineCount > 0 ? (_loc_7) : (_loc_16.height), true);
                                            _loc_13 = _loc_13 + (Math.ceil(_loc_16.width) + _columnGap);
                                        }
                                        else
                                        {
                                            _loc_16.setSize(_loc_2 - _loc_13, _lineCount > 0 ? (_loc_7) : (_loc_16.height), true);
                                        }
                                        if (_loc_16.height > _loc_12)
                                        {
                                            _loc_12 = _loc_16.height;
                                        }
                                    }
                                    _loc_8++;
                                }
                                _loc_14 = _loc_14 + (Math.ceil(_loc_12) + _lineGap);
                                _loc_12 = 0;
                                _loc_8 = 0;
                                _loc_3 = _loc_5 + 1;
                                _loc_10 = 0;
                                _loc_9++;
                            }
                        }
                        _loc_5++;
                    }
                }
                else
                {
                    _loc_5 = 0;
                    while (_loc_5 < _loc_4)
                    {
                        
                        _loc_16 = getChildAt(_loc_5);
                        if (!(foldInvisibleItems && !_loc_16.visible))
                        {
                            if (_loc_13 != 0)
                            {
                                _loc_13 = _loc_13 + _columnGap;
                            }
                            if (_autoResizeItem && _lineCount > 0)
                            {
                                _loc_16.setSize(_loc_16.width, _loc_7, true);
                            }
                            if (_columnCount != 0 && _loc_8 >= _columnCount || _columnCount == 0 && _loc_13 + _loc_16.width > _loc_2 && _loc_12 != 0)
                            {
                                _loc_13 = 0;
                                _loc_14 = _loc_14 + (Math.ceil(_loc_12) + _lineGap);
                                _loc_12 = 0;
                                _loc_8 = 0;
                                _loc_9++;
                                if (_lineCount != 0 && _loc_9 >= _lineCount || _lineCount == 0 && _loc_14 + _loc_16.height > _loc_6 && _loc_17 != 0)
                                {
                                    _loc_15++;
                                    _loc_14 = 0;
                                    _loc_9 = 0;
                                }
                            }
                            _loc_16.setXY(_loc_15 * _loc_2 + _loc_13, _loc_14);
                            _loc_13 = _loc_13 + Math.ceil(_loc_16.width);
                            if (_loc_13 > _loc_17)
                            {
                                _loc_17 = _loc_13;
                            }
                            if (_loc_16.height > _loc_12)
                            {
                                _loc_12 = _loc_16.height;
                            }
                            _loc_8++;
                        }
                        _loc_5++;
                    }
                }
                _loc_1 = _loc_15 > 0 ? (_loc_6) : (_loc_14 + Math.ceil(_loc_12));
                _loc_11 = (_loc_15 + 1) * _loc_2;
            }
            handleAlign(_loc_11, _loc_1);
            setBounds(0, 0, _loc_11, _loc_1);
            return;
        }// end function

        override public function setup_beforeAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_4:* = 0;
            var _loc_7:* = 0;
            var _loc_11:* = 0;
            var _loc_9:* = 0;
            var _loc_12:* = null;
            var _loc_6:* = null;
            var _loc_10:* = null;
            var _loc_3:* = null;
            var _loc_8:* = null;
            var _loc_5:* = null;
            super.setup_beforeAdd(param1);
            _loc_2 = param1.@layout;
            if (_loc_2)
            {
                _layout = ListLayoutType.parse(_loc_2);
            }
            _loc_2 = param1.@overflow;
            if (_loc_2)
            {
                _loc_4 = OverflowType.parse(_loc_2);
            }
            else
            {
                _loc_4 = 0;
            }
            _loc_2 = param1.@margin;
            if (_loc_2)
            {
                _margin.parse(_loc_2);
            }
            _loc_2 = param1.@align;
            if (_loc_2)
            {
                _align = AlignType.parse(_loc_2);
            }
            _loc_2 = param1.@vAlign;
            if (_loc_2)
            {
                _verticalAlign = VertAlignType.parse(_loc_2);
            }
            if (_loc_4 == 2)
            {
                _loc_2 = param1.@scroll;
                if (_loc_2)
                {
                    _loc_7 = ScrollType.parse(_loc_2);
                }
                else
                {
                    _loc_7 = 1;
                }
                _loc_2 = param1.@scrollBar;
                if (_loc_2)
                {
                    _loc_11 = ScrollBarDisplayType.parse(_loc_2);
                }
                else
                {
                    _loc_11 = 0;
                }
                _loc_9 = this.parseInt(param1.@scrollBarFlags);
                _loc_12 = new Margin();
                _loc_2 = param1.@scrollBarMargin;
                if (_loc_2)
                {
                    _loc_12.parse(_loc_2);
                }
                _loc_2 = param1.@scrollBarRes;
                if (_loc_2)
                {
                    _loc_3 = _loc_2.split(",");
                    _loc_6 = _loc_3[0];
                    _loc_10 = _loc_3[1];
                }
                _loc_2 = param1.@ptrRes;
                if (_loc_2)
                {
                    _loc_3 = _loc_2.split(",");
                    _loc_8 = _loc_3[0];
                    _loc_5 = _loc_3[1];
                }
                setupScroll(_loc_12, _loc_7, _loc_11, _loc_9, _loc_6, _loc_10, _loc_8, _loc_5);
            }
            else
            {
                setupOverflow(_loc_4);
            }
            _loc_2 = param1.@lineGap;
            if (_loc_2)
            {
                _lineGap = this.parseInt(_loc_2);
            }
            _loc_2 = param1.@colGap;
            if (_loc_2)
            {
                _columnGap = this.parseInt(_loc_2);
            }
            _loc_2 = param1.@lineItemCount;
            if (_loc_2)
            {
                if (_layout == 2 || _layout == 4)
                {
                    _columnCount = this.parseInt(_loc_2);
                }
                else if (_layout == 3)
                {
                    _lineCount = this.parseInt(_loc_2);
                }
            }
            _loc_2 = param1.@lineItemCount2;
            if (_loc_2)
            {
                _lineCount = this.parseInt(_loc_2);
            }
            _loc_2 = param1.@selectionMode;
            if (_loc_2)
            {
                _selectionMode = ListSelectionMode.parse(_loc_2);
            }
            _loc_2 = param1.@defaultItem;
            if (_loc_2)
            {
                _defaultItem = _loc_2;
            }
            _loc_2 = param1.@autoItemSize;
            if (_layout == 1 || _layout == 0)
            {
                _autoResizeItem = _loc_2 != "false";
            }
            else
            {
                _autoResizeItem = _loc_2 == "true";
            }
            _loc_2 = param1.@renderOrder;
            if (_loc_2)
            {
                _childrenRenderOrder = ChildrenRenderOrder.parse(_loc_2);
                if (_childrenRenderOrder == 2)
                {
                    _loc_2 = param1.@apex;
                    if (_loc_2)
                    {
                        _apexIndex = this.parseInt(_loc_2);
                    }
                }
            }
            _loc_2 = param1.@scrollItemToViewOnClick;
            if (_loc_2)
            {
                scrollItemToViewOnClick = _loc_2 == "true";
            }
            _loc_2 = param1.@foldInvisibleItems;
            if (_loc_2)
            {
                foldInvisibleItems = _loc_2 == "true";
            }
            readItems(param1);
            return;
        }// end function

        protected function readItems(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_6:* = null;
            var _loc_4:* = null;
            var _loc_3:* = param1.item;
            for each (_loc_5 in _loc_3)
            {
                
                _loc_6 = (_loc_5).@url;
                if (!_loc_6)
                {
                    _loc_6 = _defaultItem;
                }
                if (_loc_6)
                {
                    _loc_4 = getFromPool(_loc_6);
                    if (_loc_4 != null)
                    {
                        addChild(_loc_4);
                        setupItem(_loc_5, _loc_4);
                    }
                }
            }
            return;
        }// end function

        protected function setupItem(param1:XML, param2:GObject) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_8:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_12:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_7:* = null;
            _loc_3 = param1.@title;
            if (_loc_3)
            {
                param2.text = _loc_3;
            }
            _loc_3 = param1.@icon;
            if (_loc_3)
            {
                param2.icon = _loc_3;
            }
            _loc_3 = param1.@name;
            if (_loc_3)
            {
                param2.name = _loc_3;
            }
            _loc_3 = param1.@selectedIcon;
            if (_loc_3 && param2 is GButton)
            {
                this.GButton(param2).selectedIcon = _loc_3;
            }
            _loc_3 = param1.@selectedTitle;
            if (_loc_3 && param2 is GButton)
            {
                this.GButton(param2).selectedTitle = _loc_3;
            }
            if (param2 is GComponent)
            {
                _loc_3 = param1.@controllers;
                if (_loc_3)
                {
                    _loc_4 = _loc_3.split(",");
                    _loc_8 = 0;
                    while (_loc_8 < _loc_4.length)
                    {
                        
                        _loc_5 = this.GComponent(param2).getController(_loc_4[_loc_8]);
                        if (_loc_5 != null)
                        {
                            _loc_5.selectedPageId = _loc_4[(_loc_8 + 1)];
                        }
                        _loc_8 = _loc_8 + 2;
                    }
                }
                _loc_6 = param1.property;
                for each (_loc_9 in _loc_6)
                {
                    
                    _loc_12 = (_loc_9).@target;
                    _loc_10 = this.parseInt(_loc_9.@propertyId);
                    _loc_11 = _loc_9.@value;
                    _loc_7 = this.GComponent(param2).getChildByPath(_loc_12);
                    if (_loc_7)
                    {
                        _loc_7.setProp(_loc_10, _loc_11);
                    }
                }
            }
            return;
        }// end function

        override public function setup_afterAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            super.setup_afterAdd(param1);
            _loc_2 = param1.@selectionController;
            if (_loc_2)
            {
                _selectionController = parent.getController(_loc_2);
            }
            return;
        }// end function

    }
}

import *.*;

import __AS3__.vec.*;

import fairygui.display.*;

import fairygui.event.*;

import fairygui.utils.*;

import flash.display.*;

import flash.events.*;

import flash.geom.*;

class ItemInfo extends Object
{
    public var width:Number = 0;
    public var height:Number = 0;
    public var obj:GObject;
    public var updateFlag:uint;
    public var selected:Boolean;

    function ItemInfo() : void
    {
        return;
    }// end function

}

