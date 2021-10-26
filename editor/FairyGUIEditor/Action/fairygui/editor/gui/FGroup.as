package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.utils.*;

    public class FGroup extends FObject
    {
        private var _advanced:Boolean;
        private var _layout:String;
        private var _lineGap:int;
        private var _columnGap:int;
        private var _boundsChanged:Boolean;
        private var _percentReady:Boolean;
        private var _excludeInvisibles:Boolean;
        private var _autoSizeDisabled:Boolean;
        private var _mainGridIndex:int;
        private var _mainGridMinSize:Number;
        private var _hasMainGrid:Boolean;
        private var _collapsed:Boolean;
        private var _children:Vector.<FObject>;
        private var _gapInited:Boolean;
        private var _mainChildIndex:int;
        private var _totalSize:Number;
        private var _numChildren:int;
        public var _updating:int;
        public var _childrenDirty:Boolean;
        public static const HORIZONTAL:String = "hz";
        public static const VERTICAL:String = "vt";

        public function FGroup()
        {
            this._objectType = FObjectType.GROUP;
            _useSourceSize = false;
            this._layout = "none";
            this._excludeInvisibles = true;
            this._autoSizeDisabled = false;
            this._mainGridMinSize = 10;
            this._hasMainGrid = false;
            this._mainGridIndex = 0;
            this._childrenDirty = true;
            this._children = new Vector.<FObject>;
            return;
        }// end function

        override protected function handleDispose() : void
        {
            super.handleDispose();
            GTimers.inst.remove(this.updateImmdediately);
            return;
        }// end function

        public function get advanced() : Boolean
        {
            return this._advanced;
        }// end function

        public function set advanced(param1:Boolean) : void
        {
            if (this._advanced != param1)
            {
                this._advanced = param1;
                this._percentReady = false;
                this.updateImmdediately();
                if (!this._advanced)
                {
                    _internalVisible = true;
                    if (_parent)
                    {
                        _parent.updateDisplayList();
                    }
                }
                else
                {
                    checkGearDisplay();
                }
            }
            return;
        }// end function

        public function get excludeInvisibles() : Boolean
        {
            return this._excludeInvisibles;
        }// end function

        public function set excludeInvisibles(param1:Boolean) : void
        {
            if (this._excludeInvisibles != param1)
            {
                this._excludeInvisibles = param1;
                this._percentReady = false;
                this.updateImmdediately();
            }
            return;
        }// end function

        public function get autoSizeDisabled() : Boolean
        {
            return this._autoSizeDisabled;
        }// end function

        public function set autoSizeDisabled(param1:Boolean) : void
        {
            if (this._autoSizeDisabled != param1)
            {
                this._autoSizeDisabled = param1;
            }
            return;
        }// end function

        public function get mainGridMinSize() : Number
        {
            return this._mainGridMinSize;
        }// end function

        public function set mainGridMinSize(param1:Number) : void
        {
            if (this._mainGridMinSize != param1)
            {
                this._mainGridMinSize = param1;
                this.refresh();
            }
            return;
        }// end function

        public function get mainGridIndex() : int
        {
            return this._mainGridIndex;
        }// end function

        public function set mainGridIndex(param1:int) : void
        {
            if (this._mainGridIndex != param1)
            {
                this._mainGridIndex = param1;
                this.refresh();
            }
            return;
        }// end function

        public function get hasMainGrid() : Boolean
        {
            return this._hasMainGrid;
        }// end function

        public function set hasMainGrid(param1:Boolean) : void
        {
            if (this._hasMainGrid != param1)
            {
                this._hasMainGrid = param1;
                this.refresh();
            }
            return;
        }// end function

        public function get collapsed() : Boolean
        {
            return this._collapsed;
        }// end function

        public function set collapsed(param1:Boolean) : void
        {
            this._collapsed = param1;
            return;
        }// end function

        public function get layout() : String
        {
            return this._layout;
        }// end function

        public function set layout(param1:String) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = false;
            if (this._layout != param1)
            {
                this._layout = param1;
                this._percentReady = false;
                this.ensureChildren();
                if (!this._gapInited && (this._layout == "hz" || this._layout == "vt"))
                {
                    this._gapInited = true;
                    _loc_6 = this._excludeInvisibles && (_flags & FObjectFlags.INSPECTING) == 0;
                    _loc_2 = this._children.length;
                    _loc_3 = 0;
                    while (_loc_3 < _loc_2)
                    {
                        
                        _loc_4 = this._children[_loc_3];
                        if (_loc_6 && !_loc_4.internalVisible3)
                        {
                        }
                        else if (!_loc_5)
                        {
                            _loc_5 = _loc_4;
                        }
                        else
                        {
                            this._columnGap = int(_loc_4.x - _loc_5.x - _loc_5.width);
                            break;
                        }
                        _loc_3++;
                    }
                    _loc_3 = 0;
                    while (_loc_3 < _loc_2)
                    {
                        
                        _loc_4 = this._children[_loc_3];
                        if (_loc_6 && !_loc_4.internalVisible3)
                        {
                        }
                        else if (!_loc_5)
                        {
                            _loc_5 = _loc_4;
                        }
                        else
                        {
                            this._lineGap = int(_loc_4.y - _loc_5.y - _loc_5.height);
                            break;
                        }
                        _loc_3++;
                    }
                    if (this._columnGap < 0)
                    {
                        this._columnGap = 0;
                    }
                    if (this._lineGap < 0)
                    {
                        this._lineGap = 0;
                    }
                }
                this.updateImmdediately();
            }
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
                this.refresh();
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
                this.refresh();
            }
            return;
        }// end function

        public function get boundsChanged() : Boolean
        {
            return this._boundsChanged;
        }// end function

        public function refresh(param1:Boolean = false) : void
        {
            if (this._updating != 0 || !_parent || !this._advanced && FObjectFactory.constructingDepth != 0 || this._advanced && _underConstruct && (_flags & FObjectFlags.INSPECTING) != 0)
            {
                return;
            }
            if (!param1)
            {
                this._percentReady = false;
            }
            if (!this._boundsChanged)
            {
                this._boundsChanged = true;
                if (!_opened)
                {
                    GTimers.inst.callLater(this.updateImmdediately);
                }
            }
            return;
        }// end function

        public function get children() : Vector.<FObject>
        {
            this.ensureChildren();
            return this._children;
        }// end function

        public function freeChildrenArray() : void
        {
            this._children.length = 0;
            this._childrenDirty = true;
            return;
        }// end function

        private function ensureChildren() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            if (!this._childrenDirty)
            {
                return;
            }
            this._childrenDirty = false;
            this._children.length = 0;
            var _loc_1:* = _parent.numChildren;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = _parent.getChildAt(_loc_2);
                if (_loc_3._group == this)
                {
                    this._children.push(_loc_3);
                }
                _loc_2++;
            }
            return;
        }// end function

        public function getStartIndex() : int
        {
            this.ensureChildren();
            if (this._children.length == 0)
            {
                return -1;
            }
            var _loc_1:* = this._children[0];
            if (_loc_1 is FGroup)
            {
                return FGroup(_loc_1).getStartIndex();
            }
            return _parent.getChildIndex(_loc_1);
        }// end function

        public function updateImmdediately() : void
        {
            this._boundsChanged = false;
            if (_parent == null)
            {
                return;
            }
            this.ensureChildren();
            if (this._advanced)
            {
                if (this._layout != "none")
                {
                    if (this._autoSizeDisabled)
                    {
                        this.resizeChildren(0, 0);
                    }
                    else
                    {
                        this.handleLayout();
                        this.updateBounds();
                    }
                }
                else
                {
                    this.updateBounds();
                }
            }
            else
            {
                this.updateBounds();
            }
            return;
        }// end function

        private function updateBounds() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_8:* = 0;
            var _loc_1:* = this._children.length;
            var _loc_4:* = int.MAX_VALUE;
            var _loc_5:* = int.MAX_VALUE;
            var _loc_6:* = int.MIN_VALUE;
            var _loc_7:* = int.MIN_VALUE;
            var _loc_9:* = true;
            var _loc_10:* = this._layout != "none" && this._excludeInvisibles;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._children[_loc_2];
                if (_loc_10 && !_loc_3.internalVisible3)
                {
                }
                else
                {
                    _loc_8 = _loc_3.xMin;
                    if (_loc_8 < _loc_4)
                    {
                        _loc_4 = _loc_8;
                    }
                    _loc_8 = _loc_3.yMin;
                    if (_loc_8 < _loc_5)
                    {
                        _loc_5 = _loc_8;
                    }
                    _loc_8 = _loc_3.xMax;
                    if (_loc_8 > _loc_6)
                    {
                        _loc_6 = _loc_8;
                    }
                    _loc_8 = _loc_3.yMax;
                    if (_loc_8 > _loc_7)
                    {
                        _loc_7 = _loc_8;
                    }
                    _loc_9 = false;
                }
                _loc_2++;
            }
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            if (!_loc_9)
            {
                this._updating = this._updating | 1;
                setXY(_loc_4, _loc_5);
                this._updating = this._updating & 2;
                _loc_11 = _loc_6 - _loc_4;
                _loc_12 = _loc_7 - _loc_5;
            }
            if ((this._updating & 2) == 0)
            {
                this._updating = this._updating | 2;
                setSize(_loc_11, _loc_12);
                this._updating = this._updating & 1;
            }
            else
            {
                this._updating = this._updating & 1;
                this.resizeChildren(_width - _loc_11, _height - _loc_12);
            }
            return;
        }// end function

        private function handleLayout() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_1:* = this._children.length;
            if (_loc_1 == 0)
            {
                return;
            }
            var _loc_4:* = this._excludeInvisibles;
            this._updating = this._updating | 1;
            if (this._layout == "hz")
            {
                _loc_5 = this.x;
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    _loc_3 = this._children[_loc_2];
                    if (_loc_4 && !_loc_3.internalVisible3)
                    {
                    }
                    else
                    {
                        _loc_3.xMin = _loc_5;
                        if (_loc_3.width != 0)
                        {
                            _loc_5 = _loc_5 + (_loc_3.width + this._columnGap);
                        }
                    }
                    _loc_2++;
                }
            }
            else if (this._layout == "vt")
            {
                _loc_6 = this.y;
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    _loc_3 = this._children[_loc_2];
                    if (_loc_4 && !_loc_3.internalVisible3)
                    {
                    }
                    else
                    {
                        _loc_3.yMin = _loc_6;
                        if (_loc_3.height != 0)
                        {
                            _loc_6 = _loc_6 + (_loc_3.height + this._lineGap);
                        }
                    }
                    _loc_2++;
                }
            }
            this._updating = this._updating & 2;
            return;
        }// end function

        public function moveChildren(param1:Number, param2:Number) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            if ((this._updating & 1) != 0 || !_parent)
            {
                return;
            }
            this.ensureChildren();
            var _loc_3:* = this._children.length;
            if (_loc_3 == 0)
            {
                return;
            }
            this._updating = this._updating | 1;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = this._children[_loc_4];
                _loc_5.setXY(_loc_5.x + param1, _loc_5.y + param2);
                _loc_4++;
            }
            this._updating = this._updating & 2;
            return;
        }// end function

        public function resizeChildren(param1:Number, param2:Number) : void
        {
            var _loc_3:* = 0;
            var _loc_5:* = null;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            if (this._layout == "none" && (_flags & FObjectFlags.INSPECTING) == 0)
            {
                return;
            }
            if ((this._updating & 2) != 0 || !_parent)
            {
                return;
            }
            this.ensureChildren();
            this._updating = this._updating | 2;
            if (this._boundsChanged)
            {
                this._boundsChanged = false;
                if (!this._autoSizeDisabled)
                {
                    this.updateBounds();
                    return;
                }
            }
            var _loc_4:* = this._children.length;
            var _loc_6:* = 0;
            var _loc_7:* = 1;
            var _loc_8:* = false;
            var _loc_9:* = this._excludeInvisibles;
            if (this._layout != "none" && !this._percentReady)
            {
                this._percentReady = true;
                this._numChildren = 0;
                this._totalSize = 0;
                this._mainChildIndex = -1;
                _loc_3 = 0;
                while (_loc_3 < _loc_4)
                {
                    
                    _loc_5 = this._children[_loc_3];
                    if (!_loc_9 || _loc_5.internalVisible3)
                    {
                        if (this._hasMainGrid && _loc_3 == this._mainGridIndex)
                        {
                            this._mainChildIndex = _loc_3;
                        }
                        var _loc_12:* = this;
                        var _loc_13:* = this._numChildren + 1;
                        _loc_12._numChildren = _loc_13;
                        if (this._layout == "hz")
                        {
                            this._totalSize = this._totalSize + _loc_5.width;
                        }
                        else
                        {
                            this._totalSize = this._totalSize + _loc_5.height;
                        }
                    }
                    _loc_3++;
                }
                if (this._mainChildIndex != -1)
                {
                    if (this._layout == "hz")
                    {
                        _loc_5 = this._children[this._mainChildIndex];
                        this._totalSize = this._totalSize + (this._mainGridMinSize - _loc_5.width);
                        _loc_5._sizePercentInGroup = this._mainGridMinSize / this._totalSize;
                    }
                    else
                    {
                        _loc_5 = this._children[this._mainChildIndex];
                        this._totalSize = this._totalSize + (this._mainGridMinSize - _loc_5.height);
                        _loc_5._sizePercentInGroup = this._mainGridMinSize / this._totalSize;
                    }
                }
                _loc_3 = 0;
                while (_loc_3 < _loc_4)
                {
                    
                    _loc_5 = this._children[_loc_3];
                    if (_loc_3 == this._mainChildIndex)
                    {
                    }
                    else if (this._totalSize > 0)
                    {
                        _loc_5._sizePercentInGroup = (this._layout == "hz" ? (_loc_5.width) : (_loc_5.height)) / this._totalSize;
                    }
                    else
                    {
                        _loc_5._sizePercentInGroup = 0;
                    }
                    _loc_3++;
                }
            }
            if (this._layout == "hz")
            {
                _loc_6 = this.width - (this._numChildren - 1) * this._columnGap;
                if (this._mainChildIndex != -1 && _loc_6 >= this._totalSize)
                {
                    _loc_5 = this._children[this._mainChildIndex];
                    _loc_5.setSize(_loc_6 - (this._totalSize - this._mainGridMinSize), _loc_5._rawHeight + param2, true);
                    _loc_6 = _loc_6 - _loc_5.width;
                    _loc_7 = _loc_7 - _loc_5._sizePercentInGroup;
                    _loc_8 = true;
                }
                _loc_10 = this.x;
                _loc_3 = 0;
                while (_loc_3 < _loc_4)
                {
                    
                    _loc_5 = this._children[_loc_3];
                    if (_loc_9 && !_loc_5.internalVisible3)
                    {
                        _loc_5.setSize(_loc_5._rawWidth, _loc_5._rawHeight + param2, true);
                    }
                    else
                    {
                        if (!_loc_8 || _loc_3 != this._mainChildIndex)
                        {
                            _loc_5.setSize(Math.round(_loc_5._sizePercentInGroup / _loc_7 * _loc_6), _loc_5._rawHeight + param2, true);
                            _loc_7 = _loc_7 - _loc_5._sizePercentInGroup;
                            _loc_6 = _loc_6 - _loc_5.width;
                        }
                        _loc_5.xMin = _loc_10;
                        if (_loc_5.width != 0)
                        {
                            _loc_10 = _loc_10 + (_loc_5.width + this._columnGap);
                        }
                    }
                    _loc_3++;
                }
            }
            else if (this._layout == "vt")
            {
                _loc_6 = this.height - (this._numChildren - 1) * this._lineGap;
                if (this._mainChildIndex != -1 && _loc_6 >= this._totalSize)
                {
                    _loc_5 = this._children[this._mainChildIndex];
                    _loc_5.setSize(_loc_5._rawWidth + param1, _loc_6 - (this._totalSize - this._mainGridMinSize), true);
                    _loc_6 = _loc_6 - _loc_5.height;
                    _loc_7 = _loc_7 - _loc_5._sizePercentInGroup;
                    _loc_8 = true;
                }
                _loc_11 = this.y;
                _loc_3 = 0;
                while (_loc_3 < _loc_4)
                {
                    
                    _loc_5 = this._children[_loc_3];
                    if (_loc_9 && !_loc_5.internalVisible3)
                    {
                        _loc_5.setSize(_loc_5._rawWidth + param1, _loc_5._rawHeight, true);
                    }
                    else
                    {
                        if (!_loc_8 || _loc_3 != this._mainChildIndex)
                        {
                            _loc_5.setSize(_loc_5._rawWidth + param1, Math.round(_loc_5._sizePercentInGroup / _loc_7 * _loc_6), true);
                            _loc_7 = _loc_7 - _loc_5._sizePercentInGroup;
                            _loc_6 = _loc_6 - _loc_5.height;
                        }
                        _loc_5.yMin = _loc_11;
                        if (_loc_5.height != 0)
                        {
                            _loc_11 = _loc_11 + (_loc_5.height + this._lineGap);
                        }
                    }
                    _loc_3++;
                }
            }
            else
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_4)
                {
                    
                    _loc_5 = this._children[_loc_3];
                    _loc_5.setSize(_loc_5._rawWidth + param1, _loc_5._rawHeight + param2, true);
                    _loc_3++;
                }
            }
            this._updating = this._updating & 1;
            return;
        }// end function

        public function get empty() : Boolean
        {
            return this.children.length == 0;
        }// end function

        override public function handleAlphaChanged() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            super.handleAlphaChanged();
            if (this._underConstruct)
            {
                return;
            }
            this.ensureChildren();
            var _loc_1:* = this._children.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._children[_loc_2];
                _loc_3.alpha = this.alpha;
                _loc_2++;
            }
            return;
        }// end function

        override public function handleControllerChanged(param1:FController) : void
        {
            if (this._advanced)
            {
                super.handleControllerChanged(param1);
            }
            return;
        }// end function

        override public function handleVisibleChanged() : void
        {
            var _loc_3:* = null;
            if (!_parent)
            {
                return;
            }
            this.ensureChildren();
            var _loc_1:* = this._children.length;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._children[_loc_2];
                _loc_3.handleVisibleChanged();
                _loc_2++;
            }
            return;
        }// end function

        override protected function handleCreate() : void
        {
            this.touchDisabled = true;
            return;
        }// end function

        override public function read_beforeAdd(param1:XData, param2:Object) : void
        {
            super.read_beforeAdd(param1, param2);
            this._advanced = param1.getAttributeBool("advanced");
            if (this._advanced)
            {
                this._layout = param1.getAttribute("layout", "none");
                this._lineGap = param1.getAttributeInt("lineGap");
                this._columnGap = param1.getAttributeInt("colGap");
                this._excludeInvisibles = param1.getAttributeBool("excludeInvisibles");
                this._autoSizeDisabled = param1.getAttributeBool("autoSizeDisabled");
                this._mainGridIndex = param1.getAttributeInt("mainGridIndex", -1);
                if (this._mainGridIndex == -1)
                {
                    this._hasMainGrid = false;
                    this._mainGridIndex = 0;
                }
                else
                {
                    this._hasMainGrid = true;
                }
            }
            return;
        }// end function

        override public function read_afterAdd(param1:XData, param2:Object) : void
        {
            super.read_afterAdd(param1, param2);
            if (!_visible)
            {
                this.handleVisibleChanged();
            }
            return;
        }// end function

        override public function write() : XData
        {
            var _loc_1:* = super.write();
            if (this._advanced)
            {
                _loc_1.setAttribute("advanced", true);
            }
            if (this._advanced && this._layout != "none")
            {
                _loc_1.setAttribute("layout", this._layout);
                if (this._lineGap != 0)
                {
                    _loc_1.setAttribute("lineGap", this._lineGap);
                }
                if (this._columnGap != 0)
                {
                    _loc_1.setAttribute("colGap", this._columnGap);
                }
                if (this._excludeInvisibles)
                {
                    _loc_1.setAttribute("excludeInvisibles", this._excludeInvisibles);
                }
                if (this._autoSizeDisabled)
                {
                    _loc_1.setAttribute("autoSizeDisabled", this._autoSizeDisabled);
                }
                if (this._hasMainGrid)
                {
                    _loc_1.setAttribute("mainGridIndex", this._mainGridIndex);
                }
            }
            return _loc_1;
        }// end function

    }
}
