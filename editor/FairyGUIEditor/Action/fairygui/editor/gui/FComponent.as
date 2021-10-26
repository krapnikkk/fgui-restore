package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.*;
    import fairygui.editor.settings.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.geom.*;

    public class FComponent extends FObject
    {
        public var customExtentionId:String;
        public var initName:String;
        public var designImage:String;
        public var designImageOffsetX:int;
        public var designImageOffsetY:int;
        public var designImageAlpha:int;
        public var designImageLayer:int;
        public var designImageForTest:Boolean;
        public var bgColor:uint;
        public var bgColorEnabled:Boolean;
        public var hitTestSource:FObject;
        public var mask:FObject;
        public var reversedMask:Boolean;
        public var remark:String;
        protected var _children:Vector.<FObject>;
        protected var _controllers:Vector.<FController>;
        protected var _transitions:FTransitions;
        protected var _instNextId:uint;
        protected var _dislayListChanged:Boolean;
        protected var _bounds:Rectangle;
        protected var _boundsChanged:Boolean;
        protected var _applyingController:FController;
        protected var _extentionId:String;
        protected var _extention:ComExtention;
        protected var _overflow:String;
        protected var _scroll:String;
        protected var _opaque:Boolean;
        protected var _margin:FMargin;
        protected var _clipSoftnessX:int;
        protected var _clipSoftnessY:int;
        protected var _scrollBarDisplay:String;
        protected var _scrollBarFlags:int;
        protected var _scrollBarMargin:FMargin;
        protected var _hzScrollBarRes:String;
        protected var _vtScrollBarRes:String;
        protected var _headerRes:String;
        protected var _footerRes:String;
        protected var _childrenRenderOrder:String;
        protected var _apexIndex:int;
        protected var _pageController:FController;
        protected var _scrollPane:FScrollPane;
        protected var _customProperties:Vector.<ComProperty>;
        public var _alignOffset:Point;
        public var _buildingDisplayList:Boolean;

        public function FComponent() : void
        {
            this._objectType = FObjectType.COMPONENT;
            this._children = new Vector.<FObject>;
            this._controllers = new Vector.<FController>;
            this._overflow = OverflowConst.VISIBLE;
            this._scroll = ScrollConst.VERTICAL;
            this._scrollBarDisplay = ScrollBarDisplayConst.DEFAULT;
            this._bounds = new Rectangle();
            this._margin = new FMargin();
            this._scrollBarMargin = new FMargin();
            this.initName = "";
            this.designImage = "";
            this.designImageAlpha = 50;
            this.bgColor = 16777215;
            this._opaque = true;
            this._transitions = new FTransitions(this);
            this._alignOffset = new Point();
            this._childrenRenderOrder = "ascent";
            this._customProperties = new Vector.<ComProperty>;
            return;
        }// end function

        public function addChild(param1:FObject) : FObject
        {
            this.addChildAt(param1, this._children.length);
            return param1;
        }// end function

        public function addChildAt(param1:FObject, param2:int) : FObject
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            var _loc_3:* = this._children.length;
            if (!param1._id)
            {
                param1._id = this.getNextId();
            }
            if (!param1.name && (param1._flags & FObjectFlags.INSPECTING) != 0)
            {
                if (Preferences.meaningfullChildName)
                {
                    _loc_4 = FObjectType.NAME_PREFIX[param1._objectType];
                    if (!_loc_4)
                    {
                        param1.name = UtilsStr.getNameFromId(param1._id);
                    }
                    else
                    {
                        if (param1 is FComponent && FComponent(param1).extentionId)
                        {
                            _loc_8 = FObjectType.NAME_PREFIX[FComponent(param1).extentionId];
                            if (_loc_8)
                            {
                                _loc_4 = _loc_8;
                            }
                        }
                        _loc_5 = _loc_4.length;
                        _loc_6 = 0;
                        _loc_7 = 0;
                        while (_loc_7 < _loc_3)
                        {
                            
                            _loc_9 = this._children[_loc_7];
                            if (UtilsStr.startsWith(_loc_9.name, _loc_4))
                            {
                                _loc_10 = parseInt(_loc_9.name.substr(_loc_5));
                                if (_loc_10 >= _loc_6)
                                {
                                    _loc_6 = _loc_10 + 1;
                                }
                            }
                            _loc_7++;
                        }
                        param1.name = _loc_4 + _loc_6;
                    }
                }
                else
                {
                    param1.name = UtilsStr.getNameFromId(param1._id);
                }
            }
            if (param2 >= 0 && param2 <= _loc_3)
            {
                param1.removeFromParent();
                param1._parent = this;
                if (param2 == _loc_3)
                {
                    this._children.push(param1);
                }
                else
                {
                    this._children.splice(param2, 0, param1);
                }
                if (param1.internalVisible)
                {
                    this.updateDisplayList();
                }
                if (param1._group)
                {
                    param1._group._childrenDirty = true;
                    param1._group.refresh();
                }
                this.setBoundsChangedFlag();
                return param1;
            }
            else
            {
            }
            throw new RangeError("Invalid child index");
        }// end function

        public function removeChild(param1:FObject, param2:Boolean = false) : FObject
        {
            var _loc_3:* = this.getChildIndex(param1);
            if (_loc_3 != -1)
            {
                this.removeChildAt(_loc_3, param2);
            }
            return param1;
        }// end function

        public function removeChildAt(param1:int, param2:Boolean = false) : FObject
        {
            var _loc_3:* = null;
            if (param1 >= 0 && param1 < this.numChildren)
            {
                _loc_3 = this._children[param1];
                _loc_3._parent = null;
                _loc_3.dispatcher.emit(_loc_3, REMOVED);
                this._children.splice(param1, 1);
                if (_loc_3.displayObject.parent)
                {
                    _displayObject.container.removeChild(_loc_3.displayObject);
                    if (this._childrenRenderOrder == "arch")
                    {
                        this.updateDisplayList();
                    }
                }
                if (_loc_3._group)
                {
                    _loc_3._group._childrenDirty = true;
                    _loc_3._group.refresh();
                }
                if (_loc_3 is FGroup)
                {
                    FGroup(_loc_3).freeChildrenArray();
                }
                this.setBoundsChangedFlag();
                if (param2)
                {
                    _loc_3.dispose();
                }
                return _loc_3;
            }
            else
            {
            }
            throw new RangeError("Invalid child index");
        }// end function

        public function removeChildren(param1:int = 0, param2:int = -1, param3:Boolean = false) : void
        {
            if (param2 < 0 || param2 >= this.numChildren)
            {
                param2 = this.numChildren - 1;
            }
            var _loc_4:* = param1;
            while (_loc_4 <= param2)
            {
                
                this.removeChildAt(param1, param3);
                _loc_4++;
            }
            return;
        }// end function

        public function getChildAt(param1:int) : FObject
        {
            if (param1 >= 0 && param1 < this.numChildren)
            {
                return this._children[param1];
            }
            throw new RangeError("Invalid child index");
        }// end function

        public function getChild(param1:String) : FObject
        {
            var _loc_2:* = this._children.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._children[_loc_3].name == param1)
                {
                    return this._children[_loc_3];
                }
                _loc_3++;
            }
            return null;
        }// end function

        public function getChildByPath(param1:String) : FObject
        {
            var _loc_5:* = null;
            var _loc_2:* = param1.split(".");
            var _loc_3:* = _loc_2.length;
            var _loc_4:* = this;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_3)
            {
                
                _loc_5 = _loc_4.getChild(_loc_2[_loc_6]);
                if (!_loc_5)
                {
                    break;
                }
                if (_loc_6 != (_loc_3 - 1))
                {
                    _loc_4 = _loc_5 as FComponent;
                    if (!_loc_4)
                    {
                        _loc_5 = null;
                        break;
                    }
                }
                _loc_6++;
            }
            return _loc_5;
        }// end function

        public function getChildById(param1:String) : FObject
        {
            var _loc_2:* = this._children.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._children[_loc_3]._id == param1)
                {
                    return this._children[_loc_3];
                }
                _loc_3++;
            }
            return null;
        }// end function

        public function getChildIndex(param1:FObject) : int
        {
            return this._children.indexOf(param1);
        }// end function

        public function setChildIndex(param1:FObject, param2:int) : void
        {
            var _loc_3:* = this.getChildIndex(param1);
            if (_loc_3 == -1)
            {
                throw new ArgumentError("Not a child of this container");
            }
            this._children.splice(_loc_3, 1);
            this._children.splice(param2, 0, param1);
            if (param1._group)
            {
                param1._group._childrenDirty = true;
            }
            this.updateDisplayList();
            this.setBoundsChangedFlag();
            return;
        }// end function

        public function swapChildren(param1:FObject, param2:FObject) : void
        {
            var _loc_3:* = this._children.indexOf(param1);
            var _loc_4:* = this._children.indexOf(param2);
            if (_loc_3 == -1 || _loc_4 == -1)
            {
                throw new ArgumentError("Not a child of this container");
            }
            this.swapChildrenAt(_loc_3, _loc_4);
            return;
        }// end function

        public function swapChildrenAt(param1:int, param2:int) : void
        {
            var _loc_3:* = this._children[param1];
            var _loc_4:* = this._children[param2];
            this._children[param1] = _loc_4;
            this._children[param2] = _loc_3;
            if (_loc_3._group)
            {
                _loc_3._group._childrenDirty = true;
            }
            if (_loc_4._group)
            {
                _loc_4._group._childrenDirty = true;
            }
            this.updateDisplayList();
            return;
        }// end function

        public function get numChildren() : int
        {
            return this._children.length;
        }// end function

        public function get children() : Vector.<FObject>
        {
            return this._children;
        }// end function

        public function addController(param1:FController, param2:Boolean = true) : void
        {
            this._controllers.push(param1);
            param1.parent = this;
            if (param2)
            {
                this.applyController(param1);
            }
            return;
        }// end function

        public function getController(param1:String) : FController
        {
            var _loc_2:* = this._controllers.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._controllers[_loc_3].name == param1)
                {
                    return this._controllers[_loc_3];
                }
                _loc_3++;
            }
            return null;
        }// end function

        public function removeController(param1:FController) : void
        {
            var _loc_2:* = this._controllers.indexOf(param1);
            if (_loc_2 == -1)
            {
                throw new Error("controller not found");
            }
            param1.parent = null;
            this._controllers.splice(_loc_2, 1);
            var _loc_3:* = this._children.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                this._children[_loc_4].handleControllerChanged(param1);
                _loc_4++;
            }
            return;
        }// end function

        public function get controllers() : Vector.<FController>
        {
            return this._controllers;
        }// end function

        public function updateChildrenVisible() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_1:* = this._children.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._children[_loc_2];
                _loc_3.handleVisibleChanged();
                _loc_2++;
            }
            return;
        }// end function

        public function updateDisplayList(param1:Boolean = false) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_7:* = 0;
            if (!param1)
            {
                if (!this._dislayListChanged)
                {
                    this._dislayListChanged = true;
                    GTimers.inst.callLater(this.delayUpdate);
                }
                return;
            }
            this._dislayListChanged = false;
            var _loc_2:* = false;
            if (docElement)
            {
                _loc_2 = docElement.owner.getVar("showAllInvisibles");
            }
            var _loc_3:* = this._children.length;
            var _loc_6:* = _displayObject.container;
            switch(this._childrenRenderOrder)
            {
                case "ascent":
                {
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3)
                    {
                        
                        _loc_5 = this._children[_loc_4];
                        if (_loc_2 || _loc_5.internalVisible)
                        {
                            _loc_6.addChild(_loc_5.displayObject);
                        }
                        else if (_loc_5.displayObject.parent)
                        {
                            _loc_5.displayObject.parent.removeChild(_loc_5.displayObject);
                        }
                        _loc_4++;
                    }
                    break;
                }
                case "descent":
                {
                    _loc_4 = _loc_3 - 1;
                    while (_loc_4 >= 0)
                    {
                        
                        _loc_5 = this._children[_loc_4];
                        if (_loc_2 || _loc_5.internalVisible)
                        {
                            _loc_6.addChild(_loc_5.displayObject);
                        }
                        else if (_loc_5.displayObject.parent)
                        {
                            _loc_5.displayObject.parent.removeChild(_loc_5.displayObject);
                        }
                        _loc_4 = _loc_4 - 1;
                    }
                    break;
                }
                case "arch":
                {
                    _loc_7 = ToolSet.clamp(this._apexIndex, 0, _loc_3);
                    _loc_4 = 0;
                    while (_loc_4 < _loc_7)
                    {
                        
                        _loc_5 = this._children[_loc_4];
                        if (_loc_2 || _loc_5.internalVisible)
                        {
                            _loc_6.addChild(_loc_5.displayObject);
                        }
                        else if (_loc_5.displayObject.parent)
                        {
                            _loc_5.displayObject.parent.removeChild(_loc_5.displayObject);
                        }
                        _loc_4++;
                    }
                    _loc_4 = _loc_3 - 1;
                    while (_loc_4 >= _loc_7)
                    {
                        
                        _loc_5 = this._children[_loc_4];
                        if (_loc_2 || _loc_5.internalVisible)
                        {
                            _loc_6.addChild(_loc_5.displayObject);
                        }
                        else if (_loc_5.displayObject.parent)
                        {
                            _loc_5.displayObject.parent.removeChild(_loc_5.displayObject);
                        }
                        _loc_4 = _loc_4 - 1;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (FObjectFlags.isDocRoot(_flags))
            {
                this.renderOpenedChildren();
            }
            return;
        }// end function

        private function renderOpenedChildren() : void
        {
            var _loc_1:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_2:* = 0;
            var _loc_5:* = this._children.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_5)
            {
                
                _loc_4 = this._children[_loc_3];
                if (_loc_4._group == null && _loc_4._opened)
                {
                    _loc_1 = _loc_4;
                }
                _loc_4._renderDepth = 0;
                _loc_3++;
            }
            if (_loc_1)
            {
                if (_loc_1 is FGroup)
                {
                    _loc_2 = this.updateGroupChildrenDepth(FGroup(_loc_1), 1);
                }
                else
                {
                    var _loc_10:* = 1;
                    _loc_2 = 1;
                    _loc_1._renderDepth = _loc_10;
                }
            }
            var _loc_6:* = _displayObject.container;
            _loc_5 = _loc_6.numChildren;
            _loc_3 = 0;
            while (_loc_3 < _loc_5)
            {
                
                _loc_8 = _loc_6.getChildAt(_loc_3) as FSprite;
                if (!_loc_8)
                {
                }
                else
                {
                    _loc_8.alpha = _loc_8.owner._renderDepth < _loc_2 ? (0.3) : (1);
                }
                _loc_3++;
            }
            var _loc_7:* = 1;
            while (_loc_7 <= _loc_2)
            {
                
                _loc_3 = 0;
                _loc_9 = _loc_5;
                while (_loc_3 < _loc_9)
                {
                    
                    _loc_8 = _loc_6.getChildAt(_loc_3) as FSprite;
                    if (_loc_8 && _loc_8.owner._renderDepth == _loc_7)
                    {
                        _loc_6.addChild(_loc_8);
                        _loc_9 = _loc_9 - 1;
                        continue;
                    }
                    _loc_3++;
                }
                _loc_7++;
            }
            return;
        }// end function

        private function updateGroupChildrenDepth(param1:FGroup, param2:int) : int
        {
            var _loc_5:* = null;
            var _loc_7:* = null;
            var _loc_3:* = param1.children;
            var _loc_4:* = _loc_3.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_4)
            {
                
                _loc_7 = _loc_3[_loc_6];
                _loc_7._renderDepth = param2;
                if (_loc_7._opened)
                {
                    _loc_5 = _loc_7;
                }
                else if (_loc_7 is FGroup)
                {
                    this.updateGroupChildrenDepth(FGroup(_loc_7), param2);
                }
                _loc_6++;
            }
            if (_loc_5)
            {
                param2++;
                if (_loc_5 is FGroup)
                {
                    param2 = this.updateGroupChildrenDepth(FGroup(_loc_5), param2);
                }
                else
                {
                    _loc_5._renderDepth = param2;
                }
            }
            return param2;
        }// end function

        private function delayUpdate() : void
        {
            if (_disposed)
            {
                return;
            }
            if (this._dislayListChanged)
            {
                this.updateDisplayList(true);
            }
            if (this._boundsChanged)
            {
                this.updateBounds();
            }
            return;
        }// end function

        public function getSnappingPosition(param1:Number, param2:Number, param3:Point = null) : Point
        {
            if (!param3)
            {
                param3 = new Point();
            }
            var _loc_4:* = this._children.length;
            if (this._children.length == 0)
            {
                param3.x = param1;
                param3.y = param2;
                return param3;
            }
            this.ensureBoundsCorrect();
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            if (param2 != 0)
            {
                while (_loc_7 < _loc_4)
                {
                    
                    _loc_5 = this._children[_loc_7];
                    if (param2 < _loc_5.y)
                    {
                        if (_loc_7 == 0)
                        {
                            param2 = 0;
                            break;
                        }
                        else
                        {
                            _loc_6 = this._children[(_loc_7 - 1)];
                            if (param2 < _loc_6.y + _loc_6.height / 2)
                            {
                                param2 = _loc_6.y;
                            }
                            else
                            {
                                param2 = _loc_5.y;
                            }
                            break;
                        }
                    }
                    _loc_7++;
                }
                if (_loc_7 == _loc_4)
                {
                    param2 = _loc_5.y;
                }
            }
            if (param1 != 0)
            {
                if (_loc_7 > 0)
                {
                    _loc_7 = _loc_7 - 1;
                }
                while (_loc_7 < _loc_4)
                {
                    
                    _loc_5 = this._children[_loc_7];
                    if (param1 < _loc_5.x)
                    {
                        if (_loc_7 == 0)
                        {
                            param1 = 0;
                            break;
                        }
                        else
                        {
                            _loc_6 = this._children[(_loc_7 - 1)];
                            if (param1 < _loc_6.x + _loc_6.width / 2)
                            {
                                param1 = _loc_6.x;
                            }
                            else
                            {
                                param1 = _loc_5.x;
                            }
                            break;
                        }
                    }
                    _loc_7++;
                }
                if (_loc_7 == _loc_4)
                {
                    param1 = _loc_5.x;
                }
            }
            param3.x = param1;
            param3.y = param2;
            return param3;
        }// end function

        public function ensureBoundsCorrect() : void
        {
            if (this._boundsChanged)
            {
                this.updateBounds();
            }
            return;
        }// end function

        public function get bounds() : Rectangle
        {
            return this._bounds;
        }// end function

        function setBoundsChangedFlag() : void
        {
            if (!this._boundsChanged)
            {
                this._boundsChanged = true;
                GTimers.inst.callLater(this.delayUpdate);
            }
            return;
        }// end function

        protected function updateBounds() : void
        {
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_1:* = this._children.length;
            if (_loc_1 == 0)
            {
                this.setBounds(0, 0, 0, 0);
                return;
            }
            var _loc_2:* = int.MAX_VALUE;
            var _loc_3:* = int.MAX_VALUE;
            var _loc_4:* = int.MIN_VALUE;
            var _loc_5:* = int.MIN_VALUE;
            _loc_7 = 0;
            while (_loc_7 < _loc_1)
            {
                
                _loc_8 = this._children[_loc_7];
                _loc_6 = _loc_8.x;
                if (_loc_6 < _loc_2)
                {
                    _loc_2 = _loc_6;
                }
                _loc_6 = _loc_8.y;
                if (_loc_6 < _loc_3)
                {
                    _loc_3 = _loc_6;
                }
                _loc_6 = _loc_8.x + _loc_8.actualWidth;
                if (_loc_6 > _loc_4)
                {
                    _loc_4 = _loc_6;
                }
                _loc_6 = _loc_8.y + _loc_8.actualHeight;
                if (_loc_6 > _loc_5)
                {
                    _loc_5 = _loc_6;
                }
                _loc_7++;
            }
            this.setBounds(_loc_2, _loc_3, _loc_4 - _loc_2, _loc_5 - _loc_3);
            return;
        }// end function

        public function getBounds() : Rectangle
        {
            if (this._boundsChanged)
            {
                this.updateBounds();
            }
            return this._bounds.clone();
        }// end function

        public function setBounds(param1:int, param2:int, param3:int, param4:int) : void
        {
            this._boundsChanged = false;
            this._bounds.x = param1;
            this._bounds.y = param2;
            this._bounds.width = param3;
            this._bounds.height = param4;
            if (this._scrollPane)
            {
                this._scrollPane.setContentSize(this._bounds.x + this._bounds.width, this._bounds.y + this._bounds.height);
            }
            return;
        }// end function

        public function applyController(param1:FController) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            this._applyingController = param1;
            var _loc_2:* = this._children.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._children[_loc_3];
                _loc_4.handleControllerChanged(param1);
                _loc_3++;
            }
            param1.runActions();
            this._applyingController = null;
            if (this._dislayListChanged)
            {
                this.updateDisplayList(true);
            }
            return;
        }// end function

        public function applyAllControllers() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this._controllers.length;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._controllers[_loc_2];
                this.applyController(_loc_3);
                _loc_2++;
            }
            return;
        }// end function

        public function adjustRadioGroupDepth(param1:FObject, param2:FController) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_3:* = this._children.length;
            var _loc_6:* = -1;
            var _loc_7:* = -1;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = this._children[_loc_4];
                if (_loc_5 == param1)
                {
                    _loc_6 = _loc_4;
                }
                else if (_loc_5 is FComponent && FComponent(_loc_5)._extention is FButton && FButton(FComponent(_loc_5)._extention).controllerObj == param2)
                {
                    if (_loc_4 > _loc_7)
                    {
                        _loc_7 = _loc_4;
                    }
                }
                _loc_4++;
            }
            if (_loc_6 < _loc_7)
            {
                if (this._applyingController != null)
                {
                    this._children[_loc_7].handleControllerChanged(this._applyingController);
                }
                this.swapChildrenAt(_loc_6, _loc_7);
            }
            return;
        }// end function

        override public function handleSizeChanged() : void
        {
            super.handleSizeChanged();
            if (_displayObject.container.scrollRect)
            {
                this.updateClipRect();
            }
            if (this._scrollPane && this._scrollPane.installed)
            {
                this._scrollPane.OnOwnerSizeChanged();
            }
            return;
        }// end function

        override public function handleControllerChanged(param1:FController) : void
        {
            super.handleControllerChanged(param1);
            if (this._extention)
            {
                this._extention.handleControllerChanged(param1);
            }
            if (this._pageController == param1 && this._scrollPane && this._scrollPane.installed)
            {
                this._scrollPane.handleControllerChanged(param1);
            }
            return;
        }// end function

        override public function handleGrayedChanged() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            if (this._extention is FButton)
            {
                if (FButton(this._extention).handleGrayChanged())
                {
                    return;
                }
            }
            var _loc_1:* = this.getController("grayed");
            if (_loc_1 != null)
            {
                _loc_2 = this._children.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = this._children[_loc_3];
                    if (!_loc_4.checkGearController(3, _loc_1))
                    {
                        _loc_4.grayed = false;
                    }
                    _loc_3++;
                }
                _loc_1.selectedIndex = this.grayed ? (1) : (0);
                return;
            }
            _loc_2 = this._children.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4.grayed = this.grayed;
                _loc_3++;
            }
            return;
        }// end function

        public function get extention() : ComExtention
        {
            return this._extention;
        }// end function

        public function get extentionId() : String
        {
            return this._extentionId;
        }// end function

        public function set extentionId(param1:String) : void
        {
            if (this._extentionId != param1)
            {
                if (this._extention)
                {
                    this._extention.dispose();
                }
                if (param1 == "")
                {
                    param1 = null;
                }
                this._extentionId = param1;
                if (this._extentionId)
                {
                    this._extention = FObjectFactory.newExtention(_pkg, this._extentionId);
                    if (this._extention)
                    {
                        this._extention.owner = this;
                        this._extention.create();
                    }
                }
                else
                {
                    this._extention = null;
                }
            }
            return;
        }// end function

        public function get scrollPane() : FScrollPane
        {
            return this._scrollPane;
        }// end function

        public function get overflow() : String
        {
            return this._overflow;
        }// end function

        public function set overflow(param1:String) : void
        {
            if (this._overflow != param1)
            {
                this._overflow = param1;
                this.updateOverflow();
            }
            return;
        }// end function

        public function get overflow2() : String
        {
            if (this._overflow == "scroll")
            {
                return "scroll-" + this.scroll;
            }
            return this._overflow;
        }// end function

        public function set overflow2(param1:String) : void
        {
            if (UtilsStr.startsWith(param1, "scroll-"))
            {
                this._scroll = param1.substr(7);
                this._overflow = "scroll";
                this.updateOverflow();
            }
            else
            {
                this.overflow = param1;
            }
            return;
        }// end function

        public function get scroll() : String
        {
            return this._scroll;
        }// end function

        public function set scroll(param1:String) : void
        {
            if (this._scroll != param1)
            {
                this._scroll = param1;
                this.updateOverflow();
            }
            return;
        }// end function

        public function get scrollBarFlags() : int
        {
            return this._scrollBarFlags;
        }// end function

        public function set scrollBarFlags(param1:int) : void
        {
            if (this._scrollBarFlags != param1)
            {
                this._scrollBarFlags = param1;
                this.onScrollFlagsChanged();
            }
            return;
        }// end function

        public function get scrollBarDisplay() : String
        {
            return this._scrollBarDisplay;
        }// end function

        public function set scrollBarDisplay(param1:String) : void
        {
            if (this._scrollBarDisplay != param1)
            {
                this._scrollBarDisplay = param1;
                this.updateOverflow();
            }
            return;
        }// end function

        public function get margin() : FMargin
        {
            return this._margin;
        }// end function

        public function get marginStr() : String
        {
            return this._margin.toString();
        }// end function

        public function set marginStr(param1:String) : void
        {
            this._margin.parse(param1);
            this.updateOverflow();
            this.setBoundsChangedFlag();
            this.handleSizeChanged();
            return;
        }// end function

        public function get scrollBarMargin() : FMargin
        {
            return this._scrollBarMargin;
        }// end function

        public function get scrollBarMarginStr() : String
        {
            return this._scrollBarMargin.toString();
        }// end function

        public function set scrollBarMarginStr(param1:String) : void
        {
            this._scrollBarMargin.parse(param1);
            this.onScrollFlagsChanged();
            return;
        }// end function

        public function get hzScrollBarRes() : String
        {
            return this._hzScrollBarRes;
        }// end function

        public function set hzScrollBarRes(param1:String) : void
        {
            this._hzScrollBarRes = param1;
            if (this._scrollPane)
            {
                this._scrollPane.onFlagsChanged(true);
            }
            return;
        }// end function

        public function get vtScrollBarRes() : String
        {
            return this._vtScrollBarRes;
        }// end function

        public function set vtScrollBarRes(param1:String) : void
        {
            this._vtScrollBarRes = param1;
            this.onScrollFlagsChanged();
            return;
        }// end function

        public function get headerRes() : String
        {
            return this._headerRes;
        }// end function

        public function set headerRes(param1:String) : void
        {
            this._headerRes = param1;
            return;
        }// end function

        public function get footerRes() : String
        {
            return this._footerRes;
        }// end function

        public function set footerRes(param1:String) : void
        {
            this._footerRes = param1;
            return;
        }// end function

        public function get clipSoftnessX() : int
        {
            return this._clipSoftnessX;
        }// end function

        public function get clipSoftnessY() : int
        {
            return this._clipSoftnessY;
        }// end function

        public function set clipSoftnessX(param1:int) : void
        {
            this._clipSoftnessX = param1;
            return;
        }// end function

        public function set clipSoftnessY(param1:int) : void
        {
            this._clipSoftnessY = param1;
            return;
        }// end function

        public function get viewWidth() : Number
        {
            if (this._scrollPane && this._scrollPane.installed)
            {
                return this._scrollPane.viewWidth;
            }
            return this.width - this._margin.left - this._margin.right;
        }// end function

        public function get viewHeight() : Number
        {
            if (this._scrollPane && this._scrollPane.installed)
            {
                return this._scrollPane.viewHeight;
            }
            return this.height - this._margin.top - this._margin.bottom;
        }// end function

        public function set viewWidth(param1:Number) : void
        {
            if (this._scrollPane && this._scrollPane.installed)
            {
                this._scrollPane.viewWidth = param1;
            }
            else
            {
                this.width = param1 + this._margin.left + this._margin.right;
            }
            return;
        }// end function

        public function set viewHeight(param1:Number) : void
        {
            if (this._scrollPane && this._scrollPane.installed)
            {
                this._scrollPane.viewHeight = param1;
            }
            else
            {
                this.height = param1 + this._margin.top + this._margin.bottom;
            }
            return;
        }// end function

        public function get transitions() : FTransitions
        {
            return this._transitions;
        }// end function

        public function get opaque() : Boolean
        {
            return this._opaque;
        }// end function

        public function set opaque(param1:Boolean) : void
        {
            if (this._opaque != param1)
            {
                this._opaque = param1;
                this.handleSizeChanged();
            }
            return;
        }// end function

        final override public function get text() : String
        {
            if (this._extention != null)
            {
                return this._extention.title;
            }
            return "";
        }// end function

        override public function set text(param1:String) : void
        {
            if (this._extention != null)
            {
                this._extention.title = param1;
            }
            return;
        }// end function

        final override public function get icon() : String
        {
            if (this._extention != null)
            {
                return this._extention.icon;
            }
            return "";
        }// end function

        override public function set icon(param1:String) : void
        {
            if (this._extention != null)
            {
                this._extention.icon = param1;
            }
            return;
        }// end function

        override public function getProp(param1:int)
        {
            var _loc_2:* = undefined;
            if (this._extention)
            {
                _loc_2 = this._extention.getProp(param1);
                if (_loc_2 != undefined)
                {
                    return _loc_2;
                }
            }
            return super.getProp(param1);
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            if (this._extention)
            {
                this._extention.setProp(param1, param2);
            }
            else
            {
                super.setProp(param1, param2);
            }
            return;
        }// end function

        public function get childrenRenderOrder() : String
        {
            return this._childrenRenderOrder;
        }// end function

        public function set childrenRenderOrder(param1:String) : void
        {
            if (this._childrenRenderOrder != param1)
            {
                this._childrenRenderOrder = param1;
                this.updateDisplayList();
            }
            return;
        }// end function

        public function get apexIndex() : int
        {
            return this._apexIndex;
        }// end function

        public function set apexIndex(param1:int) : void
        {
            if (this._apexIndex != param1)
            {
                this._apexIndex = param1;
                if (this._childrenRenderOrder == "arch")
                {
                    this.updateDisplayList();
                }
            }
            return;
        }// end function

        public function get pageController() : String
        {
            if (this._pageController && this._pageController.parent)
            {
                return this._pageController.name;
            }
            return null;
        }// end function

        public function set pageController(param1:String) : void
        {
            var _loc_2:* = null;
            if (param1)
            {
                _loc_2 = _parent.getController(param1);
            }
            this._pageController = _loc_2;
            return;
        }// end function

        public function get customProperties() : Vector.<ComProperty>
        {
            return this._customProperties;
        }// end function

        public function set customProperties(param1:Vector.<ComProperty>) : void
        {
            this._customProperties = param1;
            return;
        }// end function

        public function getCustomProperty(param1:String, param2:int) : ComProperty
        {
            var _loc_5:* = null;
            var _loc_3:* = this._customProperties.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = this._customProperties[_loc_4];
                if (_loc_5.target == param1 && _loc_5.propertyId == param2)
                {
                    return _loc_5;
                }
                _loc_4++;
            }
            return null;
        }// end function

        public function applyCustomProperty(param1:ComProperty) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (param1.value == undefined)
            {
                return;
            }
            if (param1.propertyId == -1)
            {
                _loc_2 = this.getController(param1.target);
                if (_loc_2 != null)
                {
                    _loc_2.selectedPageId = param1.value;
                }
            }
            else
            {
                _loc_3 = this.getChildByPath(param1.target);
                if (_loc_3)
                {
                    _loc_3.setProp(param1.propertyId, param1.value);
                }
            }
            return;
        }// end function

        public function get pageControllerObj() : FController
        {
            return this._pageController;
        }// end function

        private function updateClipRect() : void
        {
            var _loc_1:* = _displayObject.container.scrollRect;
            var _loc_2:* = this.width - (this._margin.left + this._margin.right);
            var _loc_3:* = this.height - (this._margin.top + this._margin.bottom);
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
            _displayObject.container.scrollRect = _loc_1;
            return;
        }// end function

        protected function onScrollFlagsChanged() : void
        {
            if (this._scrollPane && this._scrollPane.installed)
            {
                this._scrollPane.onFlagsChanged();
                this.handleSizeChanged();
            }
            return;
        }// end function

        public function updateOverflow() : void
        {
            if (FObjectFlags.isDocRoot(_flags))
            {
                return;
            }
            if (this._overflow == OverflowConst.HIDDEN)
            {
                if (this._scrollPane)
                {
                    this._scrollPane.uninstall();
                }
                _displayObject.container.scrollRect = new Rectangle();
                this.updateClipRect();
                _displayObject.container.x = this._margin.left + this._alignOffset.x;
                _displayObject.container.y = this._margin.top + this._alignOffset.y;
            }
            else if (this._overflow == OverflowConst.SCROLL)
            {
                if (!this._scrollPane)
                {
                    this._scrollPane = new FScrollPane(this);
                }
                else if (this._scrollPane.installed)
                {
                    this.onScrollFlagsChanged();
                }
                else
                {
                    this._scrollPane.install();
                    this.handleSizeChanged();
                }
            }
            else
            {
                _displayObject.container.scrollRect = null;
                if (this._scrollPane)
                {
                    this._scrollPane.uninstall();
                }
                _displayObject.container.x = this._margin.left + this._alignOffset.x;
                _displayObject.container.y = this._margin.top + this._alignOffset.y;
            }
            return;
        }// end function

        override protected function handleCreate() : void
        {
            var strings:Object;
            var str:String;
            var arr:Array;
            var maskId:String;
            var hitTestId:String;
            var it:XDataEnumerator;
            var controller:FController;
            var child:FObject;
            var displayList:Vector.<FDisplayListItem>;
            var childCount:int;
            var i:int;
            var di:FDisplayListItem;
            var intId:int;
            var ni:int;
            var extNode:XData;
            var cxml:XData;
            var cp:ComProperty;
            this._children.length = 0;
            _displayObject.container.removeChildren();
            this._controllers.length = 0;
            if (!_res || _res.isMissing)
            {
                if (!(this is FList))
                {
                    this.errorStatus = true;
                }
                return;
            }
            var pi:* = _res.displayItem;
            if (pi.getVar("creatingObject"))
            {
                _pkg.project.editor.alert(UtilsStr.formatString(Consts.strings.text344, pi.name));
                setSize(pi.width, pi.height);
                this.errorStatus = true;
                return;
            }
            var comData:* = pi.getComponentData();
            if (!comData || !comData.xml)
            {
                setSize(pi.width, pi.height);
                this.errorStatus = true;
                return;
            }
            var xml:* = comData.xml;
            this.errorStatus = false;
            _underConstruct = true;
            pi.setVar("creatingObject", true);
            this._customProperties.length = 0;
            try
            {
                if (_flags & FObjectFlags.IN_TEST)
                {
                    strings = _pkg.strings;
                    if (strings)
                    {
                        strings = strings[pi.id];
                    }
                }
                str = xml.getAttribute("size", "");
                arr = str.split(",");
                sourceWidth = int(arr[0]);
                sourceHeight = int(arr[1]);
                this._overflow = xml.getAttribute("overflow", "visible");
                this._opaque = xml.getAttributeBool("opaque", true);
                str = xml.getAttribute("margin");
                if (str)
                {
                    this._margin.parse(str);
                }
                str = xml.getAttribute("clipSoftness");
                if (str)
                {
                    arr = str.split(",");
                    this._clipSoftnessX = int(arr[0]);
                    this._clipSoftnessY = int(arr[1]);
                }
                this._scroll = xml.getAttribute("scroll", ScrollConst.VERTICAL);
                this._scrollBarFlags = xml.getAttributeInt("scrollBarFlags");
                this._scrollBarDisplay = xml.getAttribute("scrollBar", ScrollBarDisplayConst.DEFAULT);
                str = xml.getAttribute("scrollBarMargin");
                if (str)
                {
                    this._scrollBarMargin.parse(str);
                }
                str = xml.getAttribute("scrollBarRes");
                if (str)
                {
                    arr = str.split(",");
                    this._vtScrollBarRes = arr[0];
                    this._hzScrollBarRes = arr[1];
                }
                str = xml.getAttribute("ptrRes");
                if (str)
                {
                    arr = str.split(",");
                    this._headerRes = arr[0];
                    this._footerRes = arr[1];
                }
                this.remark = xml.getAttribute("remark");
                this._instNextId = 0;
                setSize(sourceWidth, sourceHeight);
                aspectLocked = true;
                this.updateOverflow();
                str = xml.getAttribute("pivot");
                if (str)
                {
                    _anchor = xml.getAttributeBool("anchor");
                    arr = str.split(",");
                    _pivotX = parseFloat(arr[0]);
                    _pivotY = parseFloat(arr[1]);
                    _pivotFromSource = true;
                }
                str = xml.getAttribute("restrictSize");
                if (str)
                {
                    arr = str.split(",");
                    _minWidth = int(arr[0]);
                    _maxWidth = int(arr[1]);
                    _minHeight = int(arr[2]);
                    _maxHeight = int(arr[3]);
                    _restrictSizeFromSource = true;
                }
                maskId;
                hitTestId;
                maskId = xml.getAttribute("mask");
                hitTestId = xml.getAttribute("hitTest");
                this.reversedMask = xml.getAttributeBool("reversedMask");
                this._buildingDisplayList = true;
                it = xml.getEnumerator("controller");
                while (it.moveNext())
                {
                    
                    controller = new FController();
                    this._controllers.push(controller);
                    controller.parent = this;
                    controller.read(it.current);
                    if (controller.exported && !FObjectFlags.isDocRoot(_flags))
                    {
                        this._customProperties.push(new ComProperty(controller.name, -1, controller.alias));
                    }
                }
                displayList = comData.displayList;
                childCount = displayList.length;
                i;
                while (i < childCount)
                {
                    
                    di = displayList[i];
                    child = di.existingInstance;
                    if (!child)
                    {
                        child = FObjectFactory.createObject3(di, _flags & 255 | (FObjectFlags.isDocRoot(_flags) ? (FObjectFlags.INSPECTING) : (0)));
                    }
                    child._underConstruct = true;
                    child.read_beforeAdd(di.desc, strings);
                    if ((child._flags & FObjectFlags.INSPECTING) != 0)
                    {
                        if (child._id.charCodeAt(0) == 110)
                        {
                            ni = child._id.indexOf("_");
                            if (ni != -1)
                            {
                                intId = parseInt(child._id.substring(1, ni));
                            }
                            else
                            {
                                intId = parseInt(child._id.substring(1));
                            }
                            if (intId >= this._instNextId)
                            {
                                this._instNextId = intId + 1;
                            }
                        }
                    }
                    this.addChild(child);
                    i = (i + 1);
                }
                _relations.read(xml, true);
                i;
                while (i < childCount)
                {
                    
                    child = this._children[i];
                    child.relations.read(displayList[i].desc, false);
                    i = (i + 1);
                }
                i;
                while (i < childCount)
                {
                    
                    child = this._children[i];
                    child.read_afterAdd(displayList[i].desc, strings);
                    child._underConstruct = false;
                    i = (i + 1);
                }
                if (maskId != null)
                {
                    this.mask = this.getChildById(maskId);
                }
                if (hitTestId != null)
                {
                    this.hitTestSource = this.getChildById(hitTestId);
                }
                this._extentionId = null;
                this.customExtentionId = null;
                if (this._extention)
                {
                    this._extention.dispose();
                    this._extention = null;
                }
                if ((_flags & FObjectFlags.IN_PREVIEW) == 0 || (_flags & FObjectFlags.ROOT) == 0)
                {
                    str = xml.getAttribute("extention");
                    if (str)
                    {
                        this._extention = FObjectFactory.newExtention(_pkg, str);
                        if (this._extention)
                        {
                            this._extentionId = str;
                            extNode = xml.getChild(str);
                            if (!extNode)
                            {
                                extNode = XData.create(str);
                            }
                            this._extention.owner = this;
                            this._extention.read_editMode(extNode);
                            this._extention.create();
                        }
                    }
                    this.customExtentionId = xml.getAttribute("customExtention");
                }
                this.initName = xml.getAttribute("initName", "");
                if ((_flags & FObjectFlags.ROOT) != 0 && ((_flags & FObjectFlags.IN_DOC) != 0 || (_flags & FObjectFlags.IN_TEST) != 0))
                {
                    this.designImage = xml.getAttribute("designImage", "");
                    this.designImageOffsetX = xml.getAttributeInt("designImageOffsetX");
                    this.designImageOffsetY = xml.getAttributeInt("designImageOffsetY");
                    this.designImageAlpha = xml.getAttributeInt("designImageAlpha", 50);
                    this.designImageLayer = xml.getAttributeInt("designImageLayer");
                    this.designImageForTest = xml.getAttributeBool("designImageForTest");
                    this.bgColorEnabled = xml.getAttributeBool("bgColorEnabled");
                    this.bgColor = xml.getAttributeColor("bgColor", false, 16777215);
                }
                if ((_flags & FObjectFlags.IN_PREVIEW) == 0)
                {
                    this._transitions.read(xml);
                }
                it = xml.getEnumerator("customProperty");
                while (it.moveNext())
                {
                    
                    cxml = it.current;
                    cp = new ComProperty(cxml.getAttribute("target"), cxml.getAttributeInt("propertyId"), cxml.getAttribute("label"));
                    this._customProperties.push(cp);
                }
                this.applyAllControllers();
            }
            catch (e:Error)
            {
                throw null;
            }
            finally
            {
                this._buildingDisplayList = false;
                _underConstruct = false;
                pi.setVar("creatingObject", undefined);
            }
            this.updateDisplayList();
            this.setBoundsChangedFlag();
            if (!FObjectFlags.isDocRoot(_flags))
            {
                if (this.mask)
                {
                    displayObject.setMask(this.mask);
                }
                if (this.hitTestSource && (_flags & FObjectFlags.IN_PREVIEW) == 0)
                {
                    displayObject.setHitArea(this.hitTestSource);
                }
            }
            return;
        }// end function

        public function write_editMode() : XData
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_6:* = null;
            var _loc_8:* = null;
            var _loc_1:* = XData.create("component");
            _loc_1.setAttribute("size", int(_width) + "," + int(_height));
            if (_minWidth != 0 || _maxWidth != 0 || _minHeight != 0 || _maxHeight != 0)
            {
                _loc_1.setAttribute("restrictSize", _minWidth + "," + _maxWidth + "," + _minHeight + "," + _maxHeight);
            }
            if (_pivotX != 0 || _pivotY != 0)
            {
                _loc_1.setAttribute("pivot", UtilsStr.toFixed(_pivotX) + "," + UtilsStr.toFixed(_pivotY));
            }
            if (_anchor)
            {
                _loc_1.setAttribute("anchor", true);
            }
            if (this._overflow != OverflowConst.VISIBLE)
            {
                _loc_1.setAttribute("overflow", this._overflow);
            }
            if (!this._opaque)
            {
                _loc_1.setAttribute("opaque", this._opaque);
            }
            if (this._scroll != ScrollConst.VERTICAL)
            {
                _loc_1.setAttribute("scroll", this._scroll);
            }
            if (this._overflow == OverflowConst.SCROLL)
            {
                if (this._scrollBarFlags)
                {
                    _loc_1.setAttribute("scrollBarFlags", this._scrollBarFlags);
                }
                if (this._scrollBarDisplay != ScrollBarDisplayConst.DEFAULT)
                {
                    _loc_1.setAttribute("scrollBar", this._scrollBarDisplay);
                }
            }
            if (!this._margin.empty)
            {
                _loc_1.setAttribute("margin", this._margin.toString());
            }
            if (!this._scrollBarMargin.empty)
            {
                _loc_1.setAttribute("scrollBarMargin", this._scrollBarMargin.toString());
            }
            if (this._vtScrollBarRes || this._hzScrollBarRes)
            {
                _loc_1.setAttribute("scrollBarRes", (this._vtScrollBarRes ? (this._vtScrollBarRes) : ("")) + "," + (this._hzScrollBarRes ? (this._hzScrollBarRes) : ("")));
            }
            if (this._headerRes || this._footerRes)
            {
                _loc_1.setAttribute("ptrRes", (this._headerRes ? (this._headerRes) : ("")) + "," + (this._footerRes ? (this._footerRes) : ("")));
            }
            if (this._clipSoftnessX != 0 || this._clipSoftnessY != 0)
            {
                _loc_1.setAttribute("clipSoftness", this._clipSoftnessX + "," + this._clipSoftnessY);
            }
            var _loc_5:* = this._controllers.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_5)
            {
                
                _loc_3 = this._controllers[_loc_4].write();
                if (_loc_3)
                {
                    _loc_1.appendChild(_loc_3);
                }
                _loc_4++;
            }
            _loc_5 = this._children.length;
            var _loc_7:* = XData.create("displayList");
            _loc_1.appendChild(_loc_7);
            _loc_4 = 0;
            while (_loc_4 < _loc_5)
            {
                
                _loc_2 = this._children[_loc_4];
                if (_loc_2 is FGroup && FGroup(_loc_2).empty)
                {
                }
                else
                {
                    _loc_3 = _loc_2.write();
                    _loc_7.appendChild(_loc_3);
                }
                _loc_4++;
            }
            if (this._extention)
            {
                _loc_1.setAttribute("extention", this._extentionId);
                _loc_3 = this._extention.write_editMode();
                if (_loc_3)
                {
                    _loc_1.appendChild(_loc_3);
                }
            }
            if (this.customExtentionId)
            {
                _loc_1.setAttribute("customExtention", this.customExtentionId);
            }
            if (this.mask != null && this.mask._parent)
            {
                _loc_1.setAttribute("mask", this.mask._id);
                if (this.reversedMask)
                {
                    _loc_1.setAttribute("reversedMask", this.reversedMask);
                }
            }
            if (this.hitTestSource != null && this.hitTestSource._parent)
            {
                _loc_1.setAttribute("hitTest", this.hitTestSource._id);
            }
            if (this.initName)
            {
                _loc_1.setAttribute("initName", this.initName);
            }
            if (this.designImage)
            {
                _loc_1.setAttribute("designImage", this.designImage);
            }
            if (this.designImageOffsetX)
            {
                _loc_1.setAttribute("designImageOffsetX", this.designImageOffsetX);
            }
            if (this.designImageOffsetY)
            {
                _loc_1.setAttribute("designImageOffsetY", this.designImageOffsetY);
            }
            if (this.designImageAlpha != 50)
            {
                _loc_1.setAttribute("designImageAlpha", this.designImageAlpha);
            }
            if (this.designImageLayer != 0)
            {
                _loc_1.setAttribute("designImageLayer", this.designImageLayer);
            }
            if (this.designImageForTest)
            {
                _loc_1.setAttribute("designImageForTest", this.designImageForTest);
            }
            if (this.bgColorEnabled)
            {
                _loc_1.setAttribute("bgColorEnabled", this.bgColorEnabled);
            }
            if (this.bgColor != 16777215)
            {
                _loc_1.setAttribute("bgColor", UtilsStr.convertToHtmlColor(this.bgColor));
            }
            if (this.remark)
            {
                _loc_1.setAttribute("remark", this.remark);
            }
            if (!_relations.isEmpty)
            {
                _relations.write(_loc_1);
            }
            if (!this._transitions.isEmpty)
            {
                this._transitions.write(_loc_1);
            }
            if (this._customProperties.length)
            {
                for each (_loc_8 in this._customProperties)
                {
                    
                    if (_loc_8.propertyId < 0)
                    {
                        continue;
                    }
                    _loc_7 = XData.create("customProperty");
                    _loc_7.setAttribute("target", _loc_8.target);
                    _loc_7.setAttribute("propertyId", _loc_8.propertyId);
                    if (_loc_8.label)
                    {
                        _loc_7.setAttribute("label", _loc_8.label);
                    }
                    _loc_1.appendChild(_loc_7);
                }
            }
            return _loc_1;
        }// end function

        override public function read_afterAdd(param1:XData, param2:Object) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = undefined;
            super.read_afterAdd(param1, param2);
            if (this._extention)
            {
                _loc_3 = param1.getChild(this._extentionId);
                if (!_loc_3)
                {
                    _loc_3 = XData.create("Extention");
                }
                this._extention.read(_loc_3, param2);
            }
            _loc_4 = param1.getAttribute("pageController");
            if (_loc_4)
            {
                this._pageController = _parent.getController(_loc_4);
            }
            else
            {
                this._pageController = null;
            }
            _loc_4 = param1.getAttribute("controller");
            if (_loc_4)
            {
                _loc_6 = _loc_4.split(",");
                _loc_7 = 0;
                while (_loc_7 < _loc_6.length)
                {
                    
                    _loc_8 = this.getCustomProperty(_loc_6[_loc_7], -1);
                    if (_loc_8)
                    {
                        _loc_8.value = _loc_6[(_loc_7 + 1)];
                        this.applyCustomProperty(_loc_8);
                    }
                    _loc_7 = _loc_7 + 2;
                }
            }
            var _loc_5:* = this._customProperties.length;
            if (this._customProperties.length > 0)
            {
                _loc_9 = param1.getEnumerator("property");
                while (_loc_9.moveNext())
                {
                    
                    _loc_10 = _loc_9.current.getAttribute("target");
                    _loc_11 = _loc_9.current.getAttributeInt("propertyId");
                    _loc_8 = this.getCustomProperty(_loc_10, _loc_11);
                    if (_loc_8)
                    {
                        _loc_8.value = _loc_9.current.getAttribute("value");
                        if (param2)
                        {
                            _loc_12 = param2[_id + "-cp-" + _loc_8.target];
                            if (_loc_12 != undefined)
                            {
                                _loc_8.value = _loc_12;
                            }
                        }
                        this.applyCustomProperty(_loc_8);
                    }
                }
            }
            return;
        }// end function

        override public function write() : XData
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_1:* = super.write();
            if (this._extention)
            {
                _loc_3 = this._extention.write();
                if (_loc_3)
                {
                    _loc_1.appendChild(_loc_3);
                }
            }
            if (this._pageController && this._pageController.parent)
            {
                _loc_1.setAttribute("pageController", this._pageController.name);
            }
            var _loc_2:* = this._customProperties.length;
            if (_loc_2 > 0)
            {
                _loc_4 = null;
                _loc_5 = 0;
                while (_loc_5 < _loc_2)
                {
                    
                    _loc_6 = this._customProperties[_loc_5];
                    if (_loc_6.value != undefined)
                    {
                        if (_loc_6.propertyId == -1)
                        {
                            if (_loc_4 == null)
                            {
                                _loc_4 = "";
                            }
                            else
                            {
                                _loc_4 = _loc_4 + ",";
                            }
                            _loc_4 = _loc_4 + (_loc_6.target + "," + _loc_6.value);
                        }
                        else
                        {
                            _loc_3 = XData.create("property");
                            _loc_3.setAttribute("target", _loc_6.target);
                            _loc_3.setAttribute("propertyId", _loc_6.propertyId);
                            _loc_3.setAttribute("value", String(_loc_6.value));
                            _loc_1.appendChild(_loc_3);
                        }
                    }
                    _loc_5++;
                }
                if (_loc_4 != null)
                {
                    _loc_1.setAttribute("controller", _loc_4);
                }
            }
            return _loc_1;
        }// end function

        public function validateChildren(param1:Boolean = false) : Boolean
        {
            var _loc_4:* = 0;
            var _loc_2:* = false;
            var _loc_3:* = this._children.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (this._children[_loc_4].validate(param1))
                {
                    _loc_2 = true;
                }
                _loc_4++;
            }
            if (this._scrollPane && this._scrollPane.validate(param1))
            {
                _loc_2 = true;
            }
            return _loc_2;
        }// end function

        public function createChild(param1:XData) : FObject
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_2:* = param1.getAttribute("pkg");
            if (_loc_2 && _loc_2 != _pkg.id)
            {
                _loc_3 = _pkg.project.getPackage(_loc_2) as FPackage;
            }
            else
            {
                _loc_3 = _pkg;
            }
            if (_loc_3 != null)
            {
                _loc_5 = param1.getAttribute("src");
                if (_loc_5)
                {
                    _loc_4 = _loc_3.getItem(_loc_5);
                    if (_loc_4 && _loc_3 != _pkg && !_loc_4.exported)
                    {
                        _loc_4 = null;
                    }
                }
            }
            else
            {
                _loc_3 = _pkg;
            }
            if (_loc_4 != null)
            {
                return FObjectFactory.createObject(_loc_4, FObjectFlags.IN_DOC | FObjectFlags.INSPECTING);
            }
            return FObjectFactory.createObject2(_loc_3, param1.getName(), null, FObjectFlags.IN_DOC | FObjectFlags.INSPECTING);
        }// end function

        public function getChildrenInfo() : String
        {
            var _loc_3:* = null;
            var _loc_5:* = null;
            var _loc_1:* = "==============\n";
            var _loc_2:* = this._children.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3 = this._children[_loc_4];
                _loc_1 = _loc_1 + (_loc_3.toString() + "\n");
                _loc_4++;
            }
            _loc_1 = _loc_1 + "----------\n";
            _loc_2 = _displayObject.container.numChildren;
            _loc_4 = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_5 = _displayObject.container.getChildAt(_loc_4);
                if (_loc_5 is FSprite)
                {
                    _loc_1 = _loc_1 + (FSprite(_loc_5).owner.toString() + "\n");
                }
                _loc_4++;
            }
            return _loc_1;
        }// end function

        public function getNextId() : String
        {
            var _loc_1:* = this;
            _loc_1._instNextId = this._instNextId + 1;
            return "n" + this._instNextId++ + "_" + _pkg.project.serialNumberSeed;
        }// end function

        public function isIdInUse(param1:String) : Boolean
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = this._children.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._children[_loc_3];
                if (_loc_4._id == param1)
                {
                    return true;
                }
                _loc_3++;
            }
            return false;
        }// end function

        public function containsComponent(param1:FPackageItem) : Boolean
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = this._children.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._children[_loc_3] as FComponent;
                if (_loc_4)
                {
                    if (_loc_4._res && (_loc_4._res.packageItem == param1 || _loc_4._res.displayItem == param1))
                    {
                        return true;
                    }
                    if (_loc_4.containsComponent(param1))
                    {
                        return true;
                    }
                }
                _loc_3++;
            }
            return false;
        }// end function

        override protected function handleDispose() : void
        {
            var _loc_1:* = 0;
            var _loc_3:* = null;
            if (this._scrollPane)
            {
                this._scrollPane.dispose();
            }
            this._transitions.dispose();
            var _loc_2:* = this._children.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                _loc_3 = this._children[_loc_1];
                _loc_3.dispose();
                _loc_1++;
            }
            return;
        }// end function

        public function handleTextBitmapMode(param1:Boolean) : void
        {
            var _loc_3:* = 0;
            var _loc_5:* = null;
            var _loc_2:* = param1 || _displayObject._deformation;
            var _loc_4:* = this._children.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_5 = this._children[_loc_3];
                if (_loc_5 is FTextField)
                {
                    FTextField(_loc_5).bitmapMode = _loc_2 || _loc_5.displayObject._deformation;
                }
                else if (_loc_5 is FComponent)
                {
                    FComponent(_loc_5).handleTextBitmapMode(_loc_2);
                }
                _loc_3++;
            }
            return;
        }// end function

        public function notifyChildReplaced(param1:FObject, param2:FObject) : void
        {
            var _loc_3:* = this._children.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                this._children[_loc_4].relations.replaceTarget(param1, param2);
                _loc_4++;
            }
            relations.replaceTarget(param1, param2);
            if (this.mask == param1)
            {
                this.mask = param2;
            }
            if (this.hitTestSource == param1)
            {
                this.hitTestSource = param2;
            }
            return;
        }// end function

        public function collectLoadingImages(param1:Vector.<FPackageItem>) : void
        {
            var _loc_2:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_3:* = this._children.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = this._children[_loc_2];
                if (_loc_4 is FComponent)
                {
                    FComponent(_loc_4).collectLoadingImages(param1);
                }
                else if (_loc_4._res)
                {
                    _loc_5 = _loc_4._res.displayItem;
                    if (_loc_5 && _loc_5.type == FPackageItemType.IMAGE && _loc_5.loading)
                    {
                        param1.push(_loc_5);
                    }
                }
                _loc_2++;
            }
            return;
        }// end function

        public function playAutoPlayTransitions() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            for each (_loc_1 in this._transitions.items)
            {
                
                if (_loc_1.autoPlay && !_loc_1.playing)
                {
                    _loc_1.play(null, null, _loc_1.autoPlayRepeat, _loc_1.autoPlayDelay);
                }
            }
            _loc_2 = this._children.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._children[_loc_3];
                if (_loc_4 is FComponent)
                {
                    FComponent(_loc_4).playAutoPlayTransitions();
                }
                _loc_3++;
            }
            return;
        }// end function

    }
}
