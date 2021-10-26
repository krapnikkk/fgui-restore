package fairygui
{
    import *.*;
    import fairygui.utils.*;

    public class GGroup extends GObject
    {
        private var _layout:int;
        private var _lineGap:int;
        private var _columnGap:int;
        private var _excludeInvisibles:Boolean;
        private var _autoSizeDisabled:Boolean;
        private var _mainGridIndex:int;
        private var _mainGridMinSize:Number;
        private var _boundsChanged:Boolean;
        private var _percentReady:Boolean;
        private var _mainChildIndex:int;
        private var _totalSize:Number;
        private var _numChildren:int;
        var _updating:int;

        public function GGroup()
        {
            _mainGridIndex = -1;
            _mainGridMinSize = 50;
            _totalSize = 0;
            _numChildren = 0;
            return;
        }// end function

        override public function dispose() : void
        {
            _boundsChanged = false;
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
                setBoundsChangedFlag(true);
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
                setBoundsChangedFlag(true);
            }
            return;
        }// end function

        public function get excludeInvisibles() : Boolean
        {
            return _excludeInvisibles;
        }// end function

        public function set excludeInvisibles(param1:Boolean) : void
        {
            if (_excludeInvisibles != param1)
            {
                _excludeInvisibles = param1;
                setBoundsChangedFlag();
            }
            return;
        }// end function

        public function get autoSizeDisabled() : Boolean
        {
            return _autoSizeDisabled;
        }// end function

        public function set autoSizeDisabled(param1:Boolean) : void
        {
            _autoSizeDisabled = param1;
            return;
        }// end function

        public function get mainGridMinSize() : Number
        {
            return _mainGridMinSize;
        }// end function

        public function set mainGridMinSize(param1:Number) : void
        {
            if (_mainGridMinSize != param1)
            {
                _mainGridMinSize = param1;
                setBoundsChangedFlag();
            }
            return;
        }// end function

        public function get mainGridIndex() : int
        {
            return _mainGridIndex;
        }// end function

        public function set mainGridIndex(param1:int) : void
        {
            if (_mainGridIndex != param1)
            {
                _mainGridIndex = param1;
                setBoundsChangedFlag();
            }
            return;
        }// end function

        public function setBoundsChangedFlag(param1:Boolean = false) : void
        {
            if (_updating == 0 && parent != null)
            {
                if (!param1)
                {
                    _percentReady = false;
                }
                if (!_boundsChanged)
                {
                    _boundsChanged = true;
                    if (_layout != 0)
                    {
                        GTimers.inst.callLater(ensureBoundsCorrect);
                    }
                }
            }
            return;
        }// end function

        override public function ensureSizeCorrect() : void
        {
            if (parent == null || !_boundsChanged || _layout == 0)
            {
                return;
            }
            _boundsChanged = false;
            if (_autoSizeDisabled)
            {
                resizeChildren(0, 0);
            }
            else
            {
                handleLayout();
                updateBounds();
            }
            return;
        }// end function

        public function ensureBoundsCorrect() : void
        {
            if (parent == null || !_boundsChanged)
            {
                return;
            }
            _boundsChanged = false;
            if (_layout == 0)
            {
                updateBounds();
            }
            else if (_autoSizeDisabled)
            {
                resizeChildren(0, 0);
            }
            else
            {
                handleLayout();
                updateBounds();
            }
            return;
        }// end function

        private function updateBounds() : void
        {
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_3:* = 0;
            var _loc_6:* = _parent.numChildren;
            var _loc_4:* = 2147483647;
            var _loc_7:* = 2147483647;
            var _loc_2:* = -2147483648;
            var _loc_1:* = -2147483648;
            var _loc_8:* = 0;
            _loc_10 = 0;
            while (_loc_10 < _loc_6)
            {
                
                _loc_11 = _parent.getChildAt(_loc_10);
                if (!(_loc_11.group != this || _excludeInvisibles && !_loc_11.internalVisible3))
                {
                    _loc_8++;
                    _loc_3 = _loc_11.xMin;
                    if (_loc_3 < _loc_4)
                    {
                        _loc_4 = _loc_3;
                    }
                    _loc_3 = _loc_11.yMin;
                    if (_loc_3 < _loc_7)
                    {
                        _loc_7 = _loc_3;
                    }
                    _loc_3 = _loc_11.xMin + _loc_11.width;
                    if (_loc_3 > _loc_2)
                    {
                        _loc_2 = _loc_3;
                    }
                    _loc_3 = _loc_11.yMin + _loc_11.height;
                    if (_loc_3 > _loc_1)
                    {
                        _loc_1 = _loc_3;
                    }
                }
                _loc_10++;
            }
            var _loc_5:* = 0;
            var _loc_9:* = 0;
            if (_loc_8 > 0)
            {
                _updating = _updating | 1;
                setXY(_loc_4, _loc_7);
                _updating = _updating & 2;
                _loc_5 = _loc_2 - _loc_4;
                _loc_9 = _loc_1 - _loc_7;
            }
            if ((_updating & 2) == 0)
            {
                _updating = _updating | 2;
                setSize(_loc_5, _loc_9);
                _updating = _updating & 1;
            }
            else
            {
                _updating = _updating & 1;
                this.resizeChildren(_width - _loc_5, _height - _loc_9);
            }
            return;
        }// end function

        private function handleLayout() : void
        {
            var _loc_5:* = null;
            var _loc_4:* = 0;
            var _loc_3:* = 0;
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            _updating = _updating | 1;
            if (_layout == 1)
            {
                _loc_1 = this.x;
                _loc_3 = parent.numChildren;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_5 = parent.getChildAt(_loc_4);
                    if (_loc_5.group == this)
                    {
                        if (!(_excludeInvisibles && !_loc_5.internalVisible3))
                        {
                            _loc_5.xMin = _loc_1;
                            if (_loc_5.width != 0)
                            {
                                _loc_1 = _loc_1 + (_loc_5.width + _columnGap);
                            }
                        }
                    }
                    _loc_4++;
                }
            }
            else if (_layout == 2)
            {
                _loc_2 = this.y;
                _loc_3 = parent.numChildren;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_5 = parent.getChildAt(_loc_4);
                    if (_loc_5.group == this)
                    {
                        if (!(_excludeInvisibles && !_loc_5.internalVisible3))
                        {
                            _loc_5.yMin = _loc_2;
                            if (_loc_5.height != 0)
                            {
                                _loc_2 = _loc_2 + (_loc_5.height + _lineGap);
                            }
                        }
                    }
                    _loc_4++;
                }
            }
            _updating = _updating & 2;
            return;
        }// end function

        function moveChildren(param1:Number, param2:Number) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            if ((_updating & 1) != 0 || parent == null)
            {
                return;
            }
            _updating = _updating | 1;
            var _loc_3:* = parent.numChildren;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = parent.getChildAt(_loc_4);
                if (_loc_5.group == this)
                {
                    _loc_5.setXY(_loc_5.x + param1, _loc_5.y + param2);
                }
                _loc_4++;
            }
            _updating = _updating & 2;
            return;
        }// end function

        function resizeChildren(param1:Number, param2:Number) : void
        {
            var _loc_7:* = 0;
            var _loc_10:* = null;
            var _loc_8:* = 0;
            var _loc_3:* = NaN;
            var _loc_5:* = NaN;
            if (_layout == 0 || (_updating & 2) != 0 || parent == null)
            {
                return;
            }
            _updating = _updating | 2;
            if (_boundsChanged)
            {
                _boundsChanged = false;
                if (!_autoSizeDisabled)
                {
                    updateBounds();
                    return;
                }
            }
            var _loc_6:* = parent.numChildren;
            if (!_percentReady)
            {
                _percentReady = true;
                _numChildren = 0;
                _totalSize = 0;
                _mainChildIndex = -1;
                _loc_8 = 0;
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_10 = _parent.getChildAt(_loc_7);
                    if (_loc_10.group == this)
                    {
                        if (!_excludeInvisibles || _loc_10.internalVisible3)
                        {
                            if (_loc_8 == _mainGridIndex)
                            {
                                _mainChildIndex = _loc_7;
                            }
                            (_numChildren + 1);
                            if (_layout == 1)
                            {
                                _totalSize = _totalSize + _loc_10.width;
                            }
                            else
                            {
                                _totalSize = _totalSize + _loc_10.height;
                            }
                        }
                        _loc_8++;
                    }
                    _loc_7++;
                }
                if (_mainChildIndex != -1)
                {
                    if (_layout == 1)
                    {
                        _loc_10 = parent.getChildAt(_mainChildIndex);
                        _totalSize = _totalSize + (_mainGridMinSize - _loc_10.width);
                        _loc_10._sizePercentInGroup = _mainGridMinSize / _totalSize;
                    }
                    else
                    {
                        _loc_10 = parent.getChildAt(_mainChildIndex);
                        _totalSize = _totalSize + (_mainGridMinSize - _loc_10.height);
                        _loc_10._sizePercentInGroup = _mainGridMinSize / _totalSize;
                    }
                }
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_10 = parent.getChildAt(_loc_7);
                    if (_loc_10.group == this)
                    {
                        if (_loc_7 != _mainChildIndex)
                        {
                            if (_totalSize > 0)
                            {
                                _loc_10._sizePercentInGroup = (_layout == 1 ? (_loc_10.width) : (_loc_10.height)) / _totalSize;
                            }
                            else
                            {
                                _loc_10._sizePercentInGroup = 0;
                            }
                        }
                    }
                    _loc_7++;
                }
            }
            var _loc_9:* = 0;
            var _loc_11:* = 1;
            var _loc_4:* = false;
            if (_layout == 1)
            {
                _loc_9 = this.width - (_numChildren - 1) * _columnGap;
                if (_mainChildIndex != -1 && _loc_9 >= _totalSize)
                {
                    _loc_10 = parent.getChildAt(_mainChildIndex);
                    _loc_10.setSize(_loc_9 - (_totalSize - _mainGridMinSize), _loc_10._rawHeight + param2, true);
                    _loc_9 = _loc_9 - _loc_10.width;
                    _loc_11 = _loc_11 - _loc_10._sizePercentInGroup;
                    _loc_4 = true;
                }
                _loc_3 = this.x;
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_10 = parent.getChildAt(_loc_7);
                    if (_loc_10.group == this)
                    {
                        if (_excludeInvisibles && !_loc_10.internalVisible3)
                        {
                            _loc_10.setSize(_loc_10._rawWidth, _loc_10._rawHeight + param2, true);
                        }
                        else
                        {
                            if (!_loc_4 || _loc_7 != _mainChildIndex)
                            {
                                _loc_10.setSize(Math.round(_loc_10._sizePercentInGroup / _loc_11 * _loc_9), _loc_10._rawHeight + param2, true);
                                _loc_11 = _loc_11 - _loc_10._sizePercentInGroup;
                                _loc_9 = _loc_9 - _loc_10.width;
                            }
                            _loc_10.xMin = _loc_3;
                            if (_loc_10.width != 0)
                            {
                                _loc_3 = _loc_3 + (_loc_10.width + _columnGap);
                            }
                        }
                    }
                    _loc_7++;
                }
            }
            else
            {
                _loc_9 = this.height - (_numChildren - 1) * _lineGap;
                if (_mainChildIndex != -1 && _loc_9 >= _totalSize)
                {
                    _loc_10 = parent.getChildAt(_mainChildIndex);
                    _loc_10.setSize(_loc_10._rawWidth + param1, _loc_9 - (_totalSize - _mainGridMinSize), true);
                    _loc_9 = _loc_9 - _loc_10.height;
                    _loc_11 = _loc_11 - _loc_10._sizePercentInGroup;
                    _loc_4 = true;
                }
                _loc_5 = this.y;
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_10 = parent.getChildAt(_loc_7);
                    if (_loc_10.group == this)
                    {
                        if (_excludeInvisibles && !_loc_10.internalVisible3)
                        {
                            _loc_10.setSize(_loc_10._rawWidth + param1, _loc_10._rawHeight, true);
                        }
                        else
                        {
                            if (!_loc_4 || _loc_7 != _mainChildIndex)
                            {
                                _loc_10.setSize(_loc_10._rawWidth + param1, Math.round(_loc_10._sizePercentInGroup / _loc_11 * _loc_9), true);
                                _loc_11 = _loc_11 - _loc_10._sizePercentInGroup;
                                _loc_9 = _loc_9 - _loc_10.height;
                            }
                            _loc_10.yMin = _loc_5;
                            if (_loc_10.height != 0)
                            {
                                _loc_5 = _loc_5 + (_loc_10.height + _lineGap);
                            }
                        }
                    }
                    _loc_7++;
                }
            }
            _updating = _updating & 1;
            return;
        }// end function

        override protected function handleAlphaChanged() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            if (this._underConstruct)
            {
                return;
            }
            var _loc_1:* = _parent.numChildren;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = _parent.getChildAt(_loc_2);
                if (_loc_3.group == this)
                {
                    _loc_3.alpha = this.alpha;
                }
                _loc_2++;
            }
            return;
        }// end function

        public function handleVisibleChanged() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            if (!this._parent)
            {
                return;
            }
            var _loc_1:* = _parent.numChildren;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = _parent.getChildAt(_loc_2);
                if (_loc_3.group == this)
                {
                    _loc_3.handleVisibleChanged();
                }
                _loc_2++;
            }
            return;
        }// end function

        override public function setup_beforeAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            super.setup_beforeAdd(param1);
            _loc_2 = param1.@layout;
            if (_loc_2 != null)
            {
                _layout = GroupLayoutType.parse(_loc_2);
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
                _excludeInvisibles = param1.@excludeInvisibles == "true";
                _autoSizeDisabled = param1.@autoSizeDisabled == "true";
                _loc_2 = param1.@mainGridIndex;
                if (_loc_2)
                {
                    _mainGridIndex = this.parseInt(_loc_2);
                }
            }
            return;
        }// end function

        override public function setup_afterAdd(param1:XML) : void
        {
            super.setup_afterAdd(param1);
            if (!this.visible)
            {
                handleVisibleChanged();
            }
            return;
        }// end function

    }
}
