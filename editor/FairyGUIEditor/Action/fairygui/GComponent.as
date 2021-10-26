package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.display.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class GComponent extends GObject
    {
        private var _sortingChildCount:int;
        private var _opaque:Boolean;
        private var _applyingController:Controller;
        protected var _margin:Margin;
        protected var _trackBounds:Boolean;
        protected var _boundsChanged:Boolean;
        protected var _childrenRenderOrder:int;
        protected var _apexIndex:int;
        var _buildingDisplayList:Boolean;
        var _children:Vector.<GObject>;
        var _controllers:Vector.<Controller>;
        var _transitions:Vector.<Transition>;
        var _rootContainer:Sprite;
        var _container:Sprite;
        var _scrollPane:ScrollPane;
        var _alignOffset:Point;

        public function GComponent() : void
        {
            _children = new Vector.<GObject>;
            _controllers = new Vector.<Controller>;
            _transitions = new Vector.<Transition>;
            _margin = new Margin();
            _alignOffset = new Point();
            return;
        }// end function

        override protected function createDisplayObject() : void
        {
            _rootContainer = new UISprite(this);
            _rootContainer.mouseEnabled = false;
            setDisplayObject(_rootContainer);
            _container = _rootContainer;
            return;
        }// end function

        override public function dispose() : void
        {
            var _loc_3:* = 0;
            var _loc_2:* = 0;
            var _loc_4:* = null;
            var _loc_1:* = null;
            _loc_2 = _transitions.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = _transitions[_loc_3];
                _loc_4.dispose();
                _loc_3++;
            }
            if (_scrollPane)
            {
                _scrollPane.dispose();
            }
            _loc_2 = _children.length;
            _loc_3 = _loc_2 - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_1 = _children[_loc_3];
                _loc_1.parent = null;
                _loc_1.dispose();
                _loc_3--;
            }
            _boundsChanged = false;
            super.dispose();
            return;
        }// end function

        final public function get displayListContainer() : DisplayObjectContainer
        {
            return _container;
        }// end function

        public function addChild(param1:GObject) : GObject
        {
            addChildAt(param1, _children.length);
            return param1;
        }// end function

        public function addChildAt(param1:GObject, param2:int) : GObject
        {
            var _loc_3:* = 0;
            if (!param1)
            {
                throw new Error("child is null");
            }
            if (param2 >= 0 && param2 <= _children.length)
            {
                if (param1.parent == this)
                {
                    setChildIndex(param1, param2);
                }
                else
                {
                    param1.removeFromParent();
                    param1.parent = this;
                    _loc_3 = _children.length;
                    if (param1.sortingOrder != 0)
                    {
                        (_sortingChildCount + 1);
                        param2 = getInsertPosForSortingChild(param1);
                    }
                    else if (_sortingChildCount > 0)
                    {
                        if (param2 > _loc_3 - _sortingChildCount)
                        {
                            param2 = _loc_3 - _sortingChildCount;
                        }
                    }
                    if (param2 == _loc_3)
                    {
                        _children.push(param1);
                    }
                    else
                    {
                        _children.splice(param2, 0, param1);
                    }
                    childStateChanged(param1);
                    if (param1.group)
                    {
                        param1.group.setBoundsChangedFlag();
                    }
                    setBoundsChangedFlag();
                }
                return param1;
            }
            throw new RangeError("Invalid child index");
        }// end function

        private function getInsertPosForSortingChild(param1:GObject) : int
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = _children.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = _children[_loc_3];
                if (_loc_4 != param1)
                {
                }
                _loc_3++;
            }
            return _loc_3;
        }// end function

        public function removeChild(param1:GObject, param2:Boolean = false) : GObject
        {
            var _loc_3:* = _children.indexOf(param1);
            if (_loc_3 != -1)
            {
                removeChildAt(_loc_3, param2);
            }
            return param1;
        }// end function

        public function removeChildAt(param1:int, param2:Boolean = false) : GObject
        {
            var _loc_3:* = null;
            if (param1 >= 0 && param1 < numChildren)
            {
                _loc_3 = _children[param1];
                _loc_3.parent = null;
                if (_loc_3.sortingOrder != 0)
                {
                    (_sortingChildCount - 1);
                }
                _children.splice(param1, 1);
                if (_loc_3.inContainer)
                {
                    _container.removeChild(_loc_3.displayObject);
                    if (_childrenRenderOrder == 2)
                    {
                        GTimers.inst.callLater(buildNativeDisplayList);
                    }
                }
                if (_loc_3.group)
                {
                    _loc_3.group.setBoundsChangedFlag();
                    _loc_3.group = null;
                }
                if (param2)
                {
                    _loc_3.dispose();
                }
                setBoundsChangedFlag();
                return _loc_3;
            }
            throw new RangeError("Invalid child index");
        }// end function

        public function removeChildren(param1:int = 0, param2:int = -1, param3:Boolean = false) : void
        {
            var _loc_4:* = 0;
            if (param2 < 0 || param2 >= numChildren)
            {
                param2 = numChildren - 1;
            }
            _loc_4 = param1;
            while (_loc_4 <= param2)
            {
                
                removeChildAt(param1, param3);
                _loc_4++;
            }
            return;
        }// end function

        public function getChildAt(param1:int) : GObject
        {
            if (param1 >= 0 && param1 < numChildren)
            {
                return _children[param1];
            }
            throw new RangeError("Invalid child index");
        }// end function

        public function getChild(param1:String) : GObject
        {
            var _loc_3:* = 0;
            var _loc_2:* = _children.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (_children[_loc_3].name == param1)
                {
                    return _children[_loc_3];
                }
                _loc_3++;
            }
            return null;
        }// end function

        public function getChildByPath(param1:String) : GObject
        {
            var _loc_3:* = null;
            var _loc_5:* = 0;
            var _loc_2:* = param1.split(".");
            var _loc_4:* = _loc_2.length;
            var _loc_6:* = this;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_3 = _loc_6.getChild(_loc_2[_loc_5]);
                if (_loc_3)
                {
                    if (_loc_5 != (_loc_4 - 1))
                    {
                        _loc_6 = _loc_3 as GComponent;
                        if (!_loc_6)
                        {
                            _loc_3 = null;
                            break;
                        }
                    }
                    _loc_5++;
                }
            }
            return _loc_3;
        }// end function

        public function getChildren() : Vector.<GObject>
        {
            return _children.concat();
        }// end function

        public function getVisibleChild(param1:String) : GObject
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = _children.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = _children[_loc_3];
                if (_loc_4.internalVisible && _loc_4.internalVisible2 && _loc_4.name == param1)
                {
                    return _loc_4;
                }
                _loc_3++;
            }
            return null;
        }// end function

        public function getChildInGroup(param1:String, param2:GGroup) : GObject
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_3:* = _children.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = _children[_loc_4];
                if (_loc_5.group == param2 && _loc_5.name == param1)
                {
                    return _loc_5;
                }
                _loc_4++;
            }
            return null;
        }// end function

        public function getChildById(param1:String) : GObject
        {
            var _loc_3:* = 0;
            var _loc_2:* = _children.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (_children[_loc_3]._id == param1)
                {
                    return _children[_loc_3];
                }
                _loc_3++;
            }
            return null;
        }// end function

        public function getChildIndex(param1:GObject) : int
        {
            return _children.indexOf(param1);
        }// end function

        public function setChildIndex(param1:GObject, param2:int) : void
        {
            var _loc_4:* = _children.indexOf(param1);
            if (_children.indexOf(param1) == -1)
            {
                throw new ArgumentError("Not a child of this container");
            }
            if (param1.sortingOrder != 0)
            {
                return;
            }
            var _loc_3:* = _children.length;
            if (_sortingChildCount > 0)
            {
                if (param2 > _loc_3 - _sortingChildCount - 1)
                {
                    param2 = _loc_3 - _sortingChildCount - 1;
                }
            }
            _setChildIndex(param1, _loc_4, param2);
            return;
        }// end function

        public function setChildIndexBefore(param1:GObject, param2:int) : int
        {
            var _loc_4:* = _children.indexOf(param1);
            if (_children.indexOf(param1) == -1)
            {
                throw new ArgumentError("Not a child of this container");
            }
            if (param1.sortingOrder != 0)
            {
                return _loc_4;
            }
            var _loc_3:* = _children.length;
            if (_sortingChildCount > 0)
            {
                if (param2 > _loc_3 - _sortingChildCount - 1)
                {
                    param2 = _loc_3 - _sortingChildCount - 1;
                }
            }
            if (_loc_4 < param2)
            {
                return _setChildIndex(param1, _loc_4, (param2 - 1));
            }
            return _setChildIndex(param1, _loc_4, param2);
        }// end function

        private function _setChildIndex(param1:GObject, param2:int, param3:int) : int
        {
            var _loc_7:* = 0;
            var _loc_4:* = null;
            var _loc_6:* = 0;
            var _loc_5:* = _children.length;
            if (param3 > _loc_5)
            {
                param3 = _loc_5;
            }
            if (param2 == param3)
            {
                return param3;
            }
            _children.splice(param2, 1);
            _children.splice(param3, 0, param1);
            if (param1.inContainer)
            {
                if (_childrenRenderOrder == 0)
                {
                    _loc_6 = 0;
                    while (_loc_6 < param3)
                    {
                        
                        _loc_4 = _children[_loc_6];
                        if (_loc_4.inContainer)
                        {
                            _loc_7++;
                        }
                        _loc_6++;
                    }
                    if (_loc_7 == _container.numChildren)
                    {
                        _loc_7--;
                    }
                    _container.setChildIndex(param1.displayObject, _loc_7);
                }
                else if (_childrenRenderOrder == 1)
                {
                    _loc_6 = _loc_5 - 1;
                    while (_loc_6 > param3)
                    {
                        
                        _loc_4 = _children[_loc_6];
                        if (_loc_4.inContainer)
                        {
                            _loc_7++;
                        }
                        _loc_6--;
                    }
                    if (_loc_7 == _container.numChildren)
                    {
                        _loc_7--;
                    }
                    _container.setChildIndex(param1.displayObject, _loc_7);
                }
                else
                {
                    GTimers.inst.callLater(buildNativeDisplayList);
                }
                setBoundsChangedFlag();
            }
            return param3;
        }// end function

        public function swapChildren(param1:GObject, param2:GObject) : void
        {
            var _loc_3:* = _children.indexOf(param1);
            var _loc_4:* = _children.indexOf(param2);
            if (_loc_3 == -1 || _loc_4 == -1)
            {
                throw new ArgumentError("Not a child of this container");
            }
            swapChildrenAt(_loc_3, _loc_4);
            return;
        }// end function

        public function swapChildrenAt(param1:int, param2:int) : void
        {
            var _loc_4:* = _children[param1];
            var _loc_3:* = _children[param2];
            setChildIndex(_loc_4, param2);
            setChildIndex(_loc_3, param1);
            return;
        }// end function

        public function sortChildren(param1:Function) : void
        {
            _children.sort(param1);
            buildNativeDisplayList();
            setBoundsChangedFlag();
            return;
        }// end function

        final public function get numChildren() : int
        {
            return _children.length;
        }// end function

        public function isAncestorOf(param1:GObject) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            var _loc_2:* = param1.parent;
            while (_loc_2)
            {
                
                if (_loc_2 == this)
                {
                    return true;
                }
                _loc_2 = _loc_2.parent;
            }
            return false;
        }// end function

        public function addController(param1:Controller) : void
        {
            _controllers.push(param1);
            param1._parent = this;
            applyController(param1);
            return;
        }// end function

        public function getControllerAt(param1:int) : Controller
        {
            return _controllers[param1];
        }// end function

        public function getController(param1:String) : Controller
        {
            var _loc_4:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = _controllers.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = _controllers[_loc_4];
                if (_loc_2.name == param1)
                {
                    return _loc_2;
                }
                _loc_4++;
            }
            return null;
        }// end function

        public function removeController(param1:Controller) : void
        {
            var _loc_2:* = _controllers.indexOf(param1);
            if (_loc_2 == -1)
            {
                throw new Error("controller not exists");
            }
            param1._parent = null;
            _controllers.splice(_loc_2, 1);
            for each (_loc_3 in _children)
            {
                
                _loc_3.handleControllerChanged(param1);
            }
            return;
        }// end function

        final public function get controllers() : Vector.<Controller>
        {
            return _controllers;
        }// end function

        function childStateChanged(param1:GObject) : void
        {
            var _loc_2:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            if (_buildingDisplayList)
            {
                return;
            }
            var _loc_3:* = _children.length;
            if (param1 is GGroup)
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_2 = _children[_loc_4];
                    if (_loc_2.group == param1)
                    {
                        childStateChanged(_loc_2);
                    }
                    _loc_4++;
                }
                return;
            }
            if (!param1.displayObject)
            {
                return;
            }
            if (param1.internalVisible)
            {
                if (!param1.displayObject.parent)
                {
                    if (_childrenRenderOrder == 0)
                    {
                        _loc_4 = 0;
                        while (_loc_4 < _loc_3)
                        {
                            
                            _loc_2 = _children[_loc_4];
                            if (_loc_2 != param1)
                            {
                                if (_loc_2.displayObject != null && _loc_2.displayObject.parent != null)
                                {
                                    _loc_5++;
                                }
                                _loc_4++;
                            }
                        }
                        _container.addChildAt(param1.displayObject, _loc_5);
                    }
                    else if (_childrenRenderOrder == 1)
                    {
                        _loc_4 = _loc_3 - 1;
                        while (_loc_4 >= 0)
                        {
                            
                            _loc_2 = _children[_loc_4];
                            if (_loc_2 != param1)
                            {
                                if (_loc_2.displayObject != null && _loc_2.displayObject.parent != null)
                                {
                                    _loc_5++;
                                }
                                _loc_4--;
                            }
                        }
                        _container.addChildAt(param1.displayObject, _loc_5);
                    }
                    else
                    {
                        _container.addChild(param1.displayObject);
                        GTimers.inst.callLater(buildNativeDisplayList);
                    }
                }
            }
            else if (param1.displayObject.parent)
            {
                _container.removeChild(param1.displayObject);
                if (_childrenRenderOrder == 2)
                {
                    GTimers.inst.callLater(buildNativeDisplayList);
                }
            }
            return;
        }// end function

        private function buildNativeDisplayList() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_1:* = _children.length;
            if (_loc_1 == 0)
            {
                return;
            }
            switch(_childrenRenderOrder) branch count is:<2>[14, 78, 144] default offset is:<283>;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = _children[_loc_2];
                if (_loc_3.displayObject != null && _loc_3.internalVisible)
                {
                    _container.addChild(_loc_3.displayObject);
                }
                _loc_2++;
            }
            ;
            _loc_2 = _loc_1 - 1;
            while (_loc_2 >= 0)
            {
                
                _loc_3 = _children[_loc_2];
                if (_loc_3.displayObject != null && _loc_3.internalVisible)
                {
                    _container.addChild(_loc_3.displayObject);
                }
                _loc_2--;
            }
            ;
            _loc_4 = ToolSet.clamp(_apexIndex, 0, _loc_1);
            _loc_2 = 0;
            while (_loc_2 < _loc_4)
            {
                
                _loc_3 = _children[_loc_2];
                if (_loc_3.displayObject != null && _loc_3.internalVisible)
                {
                    _container.addChild(_loc_3.displayObject);
                }
                _loc_2++;
            }
            _loc_2 = _loc_1 - 1;
            while (_loc_2 >= _loc_4)
            {
                
                _loc_3 = _children[_loc_2];
                if (_loc_3.displayObject != null && _loc_3.internalVisible)
                {
                    _container.addChild(_loc_3.displayObject);
                }
                _loc_2--;
            }
            return;
        }// end function

        function applyController(param1:Controller) : void
        {
            _applyingController = param1;
            for each (_loc_2 in _children)
            {
                
                _loc_2.handleControllerChanged(param1);
            }
            _applyingController = null;
            param1.runActions();
            return;
        }// end function

        function applyAllControllers() : void
        {
            var _loc_2:* = 0;
            var _loc_1:* = _controllers.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                applyController(_controllers[_loc_2]);
                _loc_2++;
            }
            return;
        }// end function

        function adjustRadioGroupDepth(param1:GObject, param2:Controller) : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_4:* = _children.length;
            var _loc_7:* = -1;
            var _loc_3:* = -1;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = _children[_loc_5];
                if (_loc_6 == param1)
                {
                    _loc_7 = _loc_5;
                }
                else if (_loc_6 is GButton && this.GButton(_loc_6).relatedController == param2)
                {
                    if (_loc_5 > _loc_3)
                    {
                        _loc_3 = _loc_5;
                    }
                }
                _loc_5++;
            }
            if (_loc_7 < _loc_3)
            {
                if (_applyingController != null)
                {
                    _children[_loc_3].handleControllerChanged(_applyingController);
                }
                this.swapChildrenAt(_loc_7, _loc_3);
            }
            return;
        }// end function

        public function getTransitionAt(param1:int) : Transition
        {
            return _transitions[param1];
        }// end function

        public function getTransition(param1:String) : Transition
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = _transitions.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = _transitions[_loc_3];
                if (_loc_4.name == param1)
                {
                    return _loc_4;
                }
                _loc_3++;
            }
            return null;
        }// end function

        final public function get scrollPane() : ScrollPane
        {
            return _scrollPane;
        }// end function

        public function isChildInView(param1:GObject) : Boolean
        {
            if (_scrollPane != null)
            {
                return _scrollPane.isChildInView(param1);
            }
            if (_container.scrollRect != null)
            {
                return param1.x + param1.width >= 0 && param1.x <= this.width && param1.y + param1.height >= 0 && param1.y <= this.height;
            }
            return true;
        }// end function

        public function getFirstChildInView() : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_1:* = _children.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = _children[_loc_2];
                if (isChildInView(_loc_3))
                {
                    return _loc_2;
                }
                _loc_2++;
            }
            return -1;
        }// end function

        final public function get opaque() : Boolean
        {
            return _opaque;
        }// end function

        public function set opaque(param1:Boolean) : void
        {
            if (_opaque != param1)
            {
                _opaque = param1;
                if (_opaque)
                {
                    updateOpaque();
                }
                else
                {
                    _rootContainer.graphics.clear();
                }
                _rootContainer.mouseEnabled = this.touchable && (_opaque || _rootContainer.hitArea != null);
            }
            return;
        }// end function

        final public function get hitArea() : Sprite
        {
            return _rootContainer.hitArea;
        }// end function

        public function set hitArea(param1:Sprite) : void
        {
            if (_rootContainer.hitArea != null)
            {
                _rootContainer.removeChild(_rootContainer.hitArea);
            }
            if (param1 != null)
            {
                _rootContainer.hitArea = param1;
                _rootContainer.addChild(_rootContainer.hitArea);
                _rootContainer.mouseChildren = false;
            }
            else
            {
                _rootContainer.hitArea = null;
                _rootContainer.mouseChildren = this.touchable;
            }
            _rootContainer.mouseEnabled = this.touchable && (_opaque || param1 != null);
            return;
        }// end function

        function handleTouchable(param1:Boolean) : void
        {
            _rootContainer.mouseEnabled = param1 && (_opaque || _rootContainer.hitArea != null);
            _rootContainer.mouseChildren = param1 && _rootContainer.hitArea == null;
            return;
        }// end function

        public function get margin() : Margin
        {
            return _margin;
        }// end function

        public function set margin(param1:Margin) : void
        {
            _margin.copy(param1);
            if (_container.scrollRect != null)
            {
                _container.x = _margin.left + _alignOffset.x;
                _container.y = _margin.top + _alignOffset.y;
            }
            handleSizeChanged();
            return;
        }// end function

        public function get childrenRenderOrder() : int
        {
            return _childrenRenderOrder;
        }// end function

        public function set childrenRenderOrder(param1:int) : void
        {
            if (_childrenRenderOrder != param1)
            {
                _childrenRenderOrder = param1;
                buildNativeDisplayList();
            }
            return;
        }// end function

        public function get apexIndex() : int
        {
            return _apexIndex;
        }// end function

        public function set apexIndex(param1:int) : void
        {
            if (_apexIndex != param1)
            {
                _apexIndex = param1;
                if (_childrenRenderOrder == 2)
                {
                    buildNativeDisplayList();
                }
            }
            return;
        }// end function

        public function get mask() : DisplayObject
        {
            return _container.mask;
        }// end function

        public function set mask(param1:DisplayObject) : void
        {
            _container.mask = param1;
            return;
        }// end function

        protected function updateOpaque() : void
        {
            var _loc_1:* = this.width;
            var _loc_3:* = this.height;
            if (_loc_1 == 0)
            {
                _loc_1 = 1;
            }
            if (_loc_3 == 0)
            {
                _loc_3 = 1;
            }
            var _loc_2:* = _rootContainer.graphics;
            _loc_2.clear();
            _loc_2.lineStyle(0, 0, 0);
            _loc_2.beginFill(0, 0);
            _loc_2.drawRect(0, 0, _loc_1, _loc_3);
            _loc_2.endFill();
            return;
        }// end function

        protected function updateClipRect() : void
        {
            var _loc_1:* = _container.scrollRect;
            var _loc_2:* = this.width - (_margin.left + _margin.right);
            var _loc_3:* = this.height - (_margin.top + _margin.bottom);
            if (_loc_2 <= 0)
            {
                _loc_2 = 0;
            }
            if (_loc_3 <= 0)
            {
                _loc_3 = 0;
            }
            _loc_1.width = _loc_2;
            _loc_1.height = _loc_3;
            _container.scrollRect = _loc_1;
            return;
        }// end function

        protected function setupScroll(param1:Margin, param2:int, param3:int, param4:int, param5:String, param6:String, param7:String, param8:String) : void
        {
            if (_rootContainer == _container)
            {
                _container = new Sprite();
                _rootContainer.addChild(_container);
            }
            _scrollPane = new ScrollPane(this, param2, param1, param3, param4, param5, param6, param7, param8);
            return;
        }// end function

        protected function setupOverflow(param1:int) : void
        {
            if (param1 == 1)
            {
                if (_rootContainer == _container)
                {
                    _container = new Sprite();
                    _rootContainer.addChild(_container);
                }
                _container.scrollRect = new Rectangle();
                updateClipRect();
                _container.x = _margin.left;
                _container.y = _margin.top;
            }
            else if (_margin.left != 0 || _margin.top != 0)
            {
                if (_rootContainer == _container)
                {
                    _container = new Sprite();
                    _rootContainer.addChild(_container);
                }
                _container.x = _margin.left;
                _container.y = _margin.top;
            }
            return;
        }// end function

        override protected function handleSizeChanged() : void
        {
            if (_scrollPane)
            {
                _scrollPane.onOwnerSizeChanged();
            }
            if (_container.scrollRect)
            {
                updateClipRect();
            }
            if (_opaque)
            {
                updateOpaque();
            }
            return;
        }// end function

        override protected function handleGrayedChanged() : void
        {
            var _loc_4:* = 0;
            var _loc_1:* = getController("grayed");
            if (_loc_1 != null)
            {
                _loc_1.selectedIndex = this.grayed ? (1) : (0);
                return;
            }
            var _loc_2:* = this.grayed;
            var _loc_3:* = _children.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _children[_loc_4].grayed = _loc_2;
                _loc_4++;
            }
            return;
        }// end function

        override public function handleControllerChanged(param1:Controller) : void
        {
            super.handleControllerChanged(param1);
            if (_scrollPane != null)
            {
                _scrollPane.handleControllerChanged(param1);
            }
            return;
        }// end function

        public function setBoundsChangedFlag() : void
        {
            if (!_scrollPane && !_trackBounds)
            {
                return;
            }
            if (!_boundsChanged)
            {
                _boundsChanged = true;
                GTimers.inst.add(0, 1, __render);
            }
            return;
        }// end function

        private function __render() : void
        {
            if (_boundsChanged)
            {
                for each (_loc_1 in _children)
                {
                    
                    _loc_1.ensureSizeCorrect();
                }
                updateBounds();
            }
            return;
        }// end function

        public function ensureBoundsCorrect() : void
        {
            for each (_loc_1 in _children)
            {
                
                _loc_1.ensureSizeCorrect();
            }
            if (_boundsChanged)
            {
                updateBounds();
            }
            return;
        }// end function

        protected function updateBounds() : void
        {
            var _loc_7:* = 0;
            var _loc_3:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_2:* = 0;
            var _loc_4:* = 0;
            if (_children.length > 0)
            {
                _loc_6 = 2147483647;
                _loc_7 = 2147483647;
                _loc_2 = -2147483648;
                var _loc_1:* = -2147483648;
                for each (_loc_8 in _children)
                {
                    
                    _loc_4 = (_loc_8).x;
                    if (_loc_4 < _loc_6)
                    {
                        _loc_6 = _loc_4;
                    }
                    _loc_4 = _loc_8.y;
                    if (_loc_4 < _loc_7)
                    {
                        _loc_7 = _loc_4;
                    }
                    _loc_4 = _loc_8.x + _loc_8.actualWidth;
                    if (_loc_4 > _loc_2)
                    {
                        _loc_2 = _loc_4;
                    }
                    _loc_4 = _loc_8.y + _loc_8.actualHeight;
                    if (_loc_4 > _loc_1)
                    {
                        _loc_1 = _loc_4;
                    }
                }
                _loc_3 = _loc_2 - _loc_6;
                _loc_5 = _loc_1 - _loc_7;
            }
            else
            {
                _loc_6 = 0;
                _loc_7 = 0;
                _loc_3 = 0;
                _loc_5 = 0;
            }
            setBounds(_loc_6, _loc_7, _loc_3, _loc_5);
            return;
        }// end function

        protected function setBounds(param1:int, param2:int, param3:int, param4:int) : void
        {
            _boundsChanged = false;
            if (_scrollPane)
            {
                _scrollPane.setContentSize(Math.round(param1 + param3), Math.round(param2 + param4));
            }
            return;
        }// end function

        public function get viewWidth() : int
        {
            if (_scrollPane != null)
            {
                return _scrollPane.viewWidth;
            }
            return this.width - _margin.left - _margin.right;
        }// end function

        public function set viewWidth(param1:int) : void
        {
            if (_scrollPane != null)
            {
                _scrollPane.viewWidth = param1;
            }
            else
            {
                this.width = param1 + _margin.left + _margin.right;
            }
            return;
        }// end function

        public function get viewHeight() : int
        {
            if (_scrollPane != null)
            {
                return _scrollPane.viewHeight;
            }
            return this.height - _margin.top - _margin.bottom;
        }// end function

        public function set viewHeight(param1:int) : void
        {
            if (_scrollPane != null)
            {
                _scrollPane.viewHeight = param1;
            }
            else
            {
                this.height = param1 + _margin.top + _margin.bottom;
            }
            return;
        }// end function

        public function getSnappingPosition(param1:Number, param2:Number, param3:Point = null) : Point
        {
            var _loc_5:* = null;
            if (!param3)
            {
                param3 = new Point();
            }
            var _loc_6:* = _children.length;
            if (_children.length == 0)
            {
                param3.x = param1;
                param3.y = param2;
                return param3;
            }
            ensureBoundsCorrect();
            var _loc_4:* = null;
            var _loc_7:* = 0;
            if (param2 != 0)
            {
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_4 = _children[_loc_7];
                    if (param2 < _loc_4.y)
                    {
                        if (_loc_7 == 0)
                        {
                            param2 = 0;
                            break;
                        }
                        _loc_5 = _children[(_loc_7 - 1)];
                        if (param2 < _loc_5.y + _loc_5.height / 2)
                        {
                            param2 = _loc_5.y;
                        }
                        else
                        {
                            param2 = _loc_4.y;
                        }
                        break;
                    }
                    _loc_7++;
                }
                if (_loc_7 == _loc_6)
                {
                    param2 = _loc_4.y;
                }
            }
            if (param1 != 0)
            {
                if (_loc_7 > 0)
                {
                    _loc_7--;
                }
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_4 = _children[_loc_7];
                    if (param1 < _loc_4.x)
                    {
                        if (_loc_7 == 0)
                        {
                            param1 = 0;
                            break;
                        }
                        _loc_5 = _children[(_loc_7 - 1)];
                        if (param1 < _loc_5.x + _loc_5.width / 2)
                        {
                            param1 = _loc_5.x;
                        }
                        else
                        {
                            param1 = _loc_4.x;
                        }
                        break;
                    }
                    _loc_7++;
                }
                if (_loc_7 == _loc_6)
                {
                    param1 = _loc_4.x;
                }
            }
            param3.x = param1;
            param3.y = param2;
            return param3;
        }// end function

        function childSortingOrderChanged(param1:GObject, param2:int, param3:int) : void
        {
            var _loc_5:* = 0;
            var _loc_4:* = 0;
            if (param3 == 0)
            {
                (_sortingChildCount - 1);
                setChildIndex(param1, _children.length);
            }
            else
            {
                if (param2 == 0)
                {
                    (_sortingChildCount + 1);
                }
                _loc_5 = _children.indexOf(param1);
                _loc_4 = getInsertPosForSortingChild(param1);
                if (_loc_5 < _loc_4)
                {
                    _setChildIndex(param1, _loc_5, (_loc_4 - 1));
                }
                else
                {
                    _setChildIndex(param1, _loc_5, _loc_4);
                }
            }
            return;
        }// end function

        override public function constructFromResource() : void
        {
            constructFromResource2(null, 0);
            return;
        }// end function

        function constructFromResource2(param1:Vector.<GObject>, param2:int) : void
        {
            var _loc_20:* = null;
            var _loc_11:* = null;
            var _loc_7:* = 0;
            var _loc_14:* = 0;
            var _loc_23:* = 0;
            var _loc_18:* = 0;
            var _loc_6:* = null;
            var _loc_9:* = null;
            var _loc_19:* = null;
            var _loc_10:* = null;
            var _loc_21:* = null;
            var _loc_12:* = null;
            var _loc_24:* = null;
            var _loc_15:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_25:* = null;
            var _loc_13:* = packageItem.getBranch();
            var _loc_8:* = _loc_13.owner.getComponentData(_loc_13);
            _underConstruct = true;
            _loc_20 = _loc_8.@size;
            _loc_11 = _loc_20.split(",");
            sourceWidth = _loc_11[0];
            sourceHeight = _loc_11[1];
            initWidth = sourceWidth;
            initHeight = sourceHeight;
            setSize(sourceWidth, sourceHeight);
            _loc_20 = _loc_8.@pivot;
            if (_loc_20)
            {
                _loc_11 = _loc_20.split(",");
                _loc_20 = _loc_8.@anchor;
                internalSetPivot(this.parseFloat(_loc_11[0]), this.parseFloat(_loc_11[1]), _loc_20 == "true");
            }
            _loc_20 = _loc_8.@restrictSize;
            if (_loc_20)
            {
                _loc_11 = _loc_20.split(",");
                minWidth = this.parseInt(_loc_11[0]);
                maxWidth = this.parseInt(_loc_11[1]);
                minHeight = this.parseInt(_loc_11[2]);
                maxHeight = this.parseInt(_loc_11[3]);
            }
            _loc_20 = _loc_8.@opaque;
            if (_loc_20 != "false")
            {
                this.opaque = true;
            }
            _loc_20 = _loc_8.@overflow;
            if (_loc_20)
            {
                _loc_7 = OverflowType.parse(_loc_20);
            }
            else
            {
                _loc_7 = 0;
            }
            _loc_20 = _loc_8.@margin;
            if (_loc_20)
            {
                _margin.parse(_loc_20);
            }
            if (_loc_7 == 2)
            {
                _loc_20 = _loc_8.@scroll;
                if (_loc_20)
                {
                    _loc_14 = ScrollType.parse(_loc_20);
                }
                else
                {
                    _loc_14 = 1;
                }
                _loc_20 = _loc_8.@scrollBar;
                if (_loc_20)
                {
                    _loc_23 = ScrollBarDisplayType.parse(_loc_20);
                }
                else
                {
                    _loc_23 = 0;
                }
                _loc_18 = this.parseInt(_loc_8.@scrollBarFlags);
                _loc_6 = new Margin();
                _loc_20 = _loc_8.@scrollBarMargin;
                if (_loc_20)
                {
                    _loc_6.parse(_loc_20);
                }
                _loc_20 = _loc_8.@scrollBarRes;
                if (_loc_20)
                {
                    _loc_11 = _loc_20.split(",");
                    _loc_9 = _loc_11[0];
                    _loc_19 = _loc_11[1];
                }
                _loc_20 = _loc_8.@ptrRes;
                if (_loc_20)
                {
                    _loc_11 = _loc_20.split(",");
                    _loc_10 = _loc_11[0];
                    _loc_21 = _loc_11[1];
                }
                setupScroll(_loc_6, _loc_14, _loc_23, _loc_18, _loc_9, _loc_19, _loc_10, _loc_21);
            }
            else
            {
                setupOverflow(_loc_7);
            }
            _buildingDisplayList = true;
            var _loc_3:* = _loc_8.controller;
            for each (_loc_22 in _loc_3)
            {
                
                _loc_12 = new Controller();
                _controllers.push(_loc_12);
                _loc_12._parent = this;
                _loc_12.setup(_loc_22);
            }
            var _loc_17:* = _loc_13.displayList;
            var _loc_16:* = _loc_17.length;
            _loc_15 = 0;
            while (_loc_15 < _loc_16)
            {
                
                _loc_4 = _loc_17[_loc_15];
                if (param1 != null)
                {
                    _loc_24 = param1[param2 + _loc_15];
                }
                else if (_loc_4.packageItem)
                {
                    _loc_24 = UIObjectFactory.newObject(_loc_4.packageItem);
                    _loc_24.packageItem = _loc_4.packageItem;
                    _loc_24.constructFromResource();
                }
                else
                {
                    _loc_24 = UIObjectFactory.newObject2(_loc_4.type);
                }
                _loc_24._underConstruct = true;
                _loc_24.setup_beforeAdd(_loc_4.desc);
                _loc_24.parent = this;
                _children.push(_loc_24);
                _loc_15++;
            }
            this.relations.setup(_loc_8);
            _loc_15 = 0;
            while (_loc_15 < _loc_16)
            {
                
                _children[_loc_15].relations.setup(_loc_4.desc);
                _loc_15++;
            }
            _loc_15 = 0;
            while (_loc_15 < _loc_16)
            {
                
                _loc_24 = _children[_loc_15];
                _loc_24.setup_afterAdd(_loc_4.desc);
                _loc_24._underConstruct = false;
                _loc_15++;
            }
            _loc_20 = _loc_8.@mask;
            if (_loc_20)
            {
                this.mask = getChildById(_loc_20).displayObject;
            }
            _loc_20 = _loc_8.@hitTest;
            if (_loc_20)
            {
                _loc_11 = _loc_20.split(",");
                if (_loc_11.length == 1)
                {
                    _loc_24 = getChildById(_loc_20);
                    if (_loc_24)
                    {
                        this.hitArea = this.Sprite(_loc_24.displayObject);
                    }
                }
                else
                {
                    _loc_5 = _loc_13.owner.getPixelHitTestData(_loc_11[0]);
                    if (_loc_5 != null)
                    {
                        this.hitArea = new PixelHitTest(_loc_5, this.parseInt(_loc_11[1]), this.parseInt(_loc_11[2])).createHitAreaSprite();
                    }
                }
            }
            _loc_3 = _loc_8.transition;
            for each (_loc_22 in _loc_3)
            {
                
                _loc_25 = new Transition(this);
                _transitions.push(_loc_25);
                _loc_25.setup(_loc_22);
            }
            if (_transitions.length > 0)
            {
                this.addEventListener("addedToStage", __addedToStage);
                this.addEventListener("removedFromStage", __removedFromStage);
            }
            applyAllControllers();
            _buildingDisplayList = false;
            _underConstruct = false;
            buildNativeDisplayList();
            setBoundsChangedFlag();
            constructFromXML(_loc_8);
            return;
        }// end function

        protected function constructFromXML(param1:XML) : void
        {
            return;
        }// end function

        override public function setup_afterAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_7:* = 0;
            var _loc_4:* = null;
            var _loc_11:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_6:* = null;
            super.setup_afterAdd(param1);
            if (scrollPane)
            {
                _loc_2 = param1.@pageController;
                if (_loc_2)
                {
                    scrollPane.pageController = parent.getController(_loc_2);
                }
            }
            _loc_2 = param1.@controller;
            if (_loc_2)
            {
                _loc_3 = _loc_2.split(",");
                _loc_7 = 0;
                while (_loc_7 < _loc_3.length)
                {
                    
                    _loc_4 = getController(_loc_3[_loc_7]);
                    if (_loc_4)
                    {
                        _loc_4.selectedPageId = _loc_3[(_loc_7 + 1)];
                    }
                    _loc_7 = _loc_7 + 2;
                }
            }
            var _loc_5:* = param1.property;
            for each (_loc_8 in _loc_5)
            {
                
                _loc_11 = (_loc_8).@target;
                _loc_9 = this.parseInt(_loc_8.@propertyId);
                _loc_10 = _loc_8.@value;
                _loc_6 = getChildByPath(_loc_11);
                if (_loc_6)
                {
                    _loc_6.setProp(_loc_9, _loc_10);
                }
            }
            return;
        }// end function

        private function __addedToStage(event:Event) : void
        {
            var _loc_3:* = 0;
            var _loc_2:* = _transitions.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _transitions[_loc_3].onOwnerAddedToStage();
                _loc_3++;
            }
            return;
        }// end function

        private function __removedFromStage(event:Event) : void
        {
            var _loc_3:* = 0;
            var _loc_2:* = _transitions.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _transitions[_loc_3].onOwnerRemovedFromStage();
                _loc_3++;
            }
            return;
        }// end function

    }
}
