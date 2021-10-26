package _-Gs
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.geom.*;

    public class _-2b extends GComponent
    {
        public var uid:String;
        var _hResizePiority:int;
        var _vResizePiority:int;
        private var _editor:IEditor;
        private var _group:GGroup;
        private var _-KS:Boolean;
        private static const _-Gt:int = 0;
        private static const _-2A:int = 6;
        private static const _-Na:int = 100;

        public function _-2b(param1:IEditor, param2:int)
        {
            this._editor = param1;
            this.uid = UtilsStr.generateUID();
            this.setSize(400, 400);
            this._group = new GGroup();
            this._group.layout = param2;
            this._group.excludeInvisibles = true;
            this._group.autoSizeDisabled = true;
            var _loc_3:* = _-Gt;
            this._group.lineGap = _-Gt;
            this._group.columnGap = _loc_3;
            this._group.mainGridMinSize = _-Na;
            this._group.setSize(this.width, this.height);
            this._group.addRelation(this, RelationType.Size);
            addChild(this._group);
            return;
        }// end function

        public function get layout() : int
        {
            return this._group.layout;
        }// end function

        public function _-NZ(param1:GObject) : void
        {
            this._-3l(param1, this._-9X);
            return;
        }// end function

        public function _-3l(param1:GObject, param2:int) : void
        {
            if (param1.parent == this)
            {
                this._-KS = true;
                this._-3v(param1);
                this._-KS = false;
            }
            var _loc_3:* = this.numChildren;
            if (_loc_3 == 1)
            {
                this.initWidth = param1.initWidth;
                this.initHeight = param1.initHeight;
            }
            if (param2 != 0)
            {
                param2 = param2 * 2 - 1;
            }
            if (param2 >= _loc_3)
            {
                param2 = _loc_3 - 1;
            }
            if (param2 == 0)
            {
                this.addChildAt(param1, param2);
                param2++;
                if (_loc_3 > 1)
                {
                    this.addSeperator(param2);
                }
            }
            else
            {
                if (_loc_3 > 1)
                {
                    this.addSeperator(param2);
                    param2++;
                }
                this.addChildAt(param1, param2);
            }
            param1.group = this._group;
            if (this._group.layout == GroupLayoutType.Horizontal)
            {
                param1.y = 0;
                param1.height = this.height;
            }
            else
            {
                param1.x = 0;
                param1.width = this.width;
            }
            this._-2w();
            return;
        }// end function

        public function _-Hc() : void
        {
            var _loc_2:* = null;
            var _loc_1:* = this.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_1)
            {
                
                _loc_2 = getChildAt(_loc_3);
                if (this._group.layout == GroupLayoutType.Horizontal)
                {
                    _loc_2.setSize(_loc_2.initWidth, this.height);
                }
                else
                {
                    _loc_2.setSize(this.width, _loc_2.initHeight);
                }
                _loc_3 = _loc_3 + 2;
            }
            return;
        }// end function

        private function addSeperator(param1:int) : void
        {
            var _loc_2:* = new GGraph();
            _loc_2.drawRect(0, 0, 0, 0, 0);
            if (this._group.layout == GroupLayoutType.Horizontal)
            {
                _loc_2.setSize(_-2A, this.height);
                _loc_2.maxWidth = _-2A;
                this._editor.cursorManager.setCursorForObject(_loc_2.displayObject, CursorType.H_RESIZE);
            }
            else
            {
                _loc_2.setSize(this.width, _-2A);
                _loc_2.maxHeight = _-2A;
                this._editor.cursorManager.setCursorForObject(_loc_2.displayObject, CursorType.V_RESIZE);
            }
            _loc_2.draggable = true;
            _loc_2.dragBounds = new Rectangle();
            _loc_2.addEventListener(DragEvent.DRAG_START, this._-6b);
            _loc_2.addEventListener(DragEvent.DRAG_MOVING, this._-1g);
            this.addChildAt(_loc_2, param1);
            _loc_2.group = this._group;
            return;
        }// end function

        public function _-3v(param1:GObject, param2:Boolean = false) : void
        {
            var _loc_3:* = this.getChildIndex(param1);
            if (_loc_3 == -1)
            {
                throw new Error("Not a child");
            }
            if (_loc_3 != 0)
            {
                this.removeChild(this.getChildAt((_loc_3 - 1)), true);
            }
            else if (_loc_3 != this.numChildren - 2)
            {
                this.removeChild(this.getChildAt((_loc_3 + 1)), true);
            }
            this.removeChild(param1, param2);
            this._-2w();
            return;
        }// end function

        public function _-Kh(param1:GObject, param2:GObject) : void
        {
            var _loc_3:* = this.getChildIndex(param1);
            if (_loc_3 == -1)
            {
                throw new Error("Not a child");
            }
            this.addChildAt(param2, _loc_3);
            this.removeChild(param1);
            param2.group = this._group;
            param2.setXY(param1.x, param1.y);
            param2.setSize(param1.width, param1.height);
            this._-2w();
            return;
        }// end function

        public function _-1d(param1:_-2b, param2:int) : void
        {
            var _loc_4:* = null;
            this._-KS = true;
            var _loc_3:* = param1.getChildren();
            for each (_loc_4 in _loc_3)
            {
                
                if (_loc_4 is ViewGrid || _loc_4 is _-2b)
                {
                    this._-3l(_loc_4, param2++);
                }
            }
            this._-KS = false;
            this._-2w();
            if (param1.numChildren > 1)
            {
                param1.removeChildren(0, param1.numChildren - 2, true);
            }
            return;
        }// end function

        public function _-Bb(param1:int) : GObject
        {
            return this.getChildAt(param1 * 2);
        }// end function

        public function _-Oh(param1:GObject) : int
        {
            var _loc_2:* = this.getChildIndex(param1);
            return _loc_2 / 2;
        }// end function

        public function get _-9X() : int
        {
            return this.numChildren / 2;
        }// end function

        private function _-2w() : void
        {
            var _loc_9:* = null;
            if (this._-KS)
            {
                return;
            }
            var _loc_1:* = this.numChildren;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = -1;
            var _loc_7:* = -1;
            var _loc_8:* = 0;
            while (_loc_8 < _loc_1)
            {
                
                _loc_9 = getChildAt(_loc_8);
                if (_loc_9 is ViewGrid)
                {
                    _loc_2 = ViewGrid(_loc_9)._hResizePiority;
                    _loc_3 = ViewGrid(_loc_9)._vResizePiority;
                }
                else if (_loc_9 is _-2b)
                {
                    _loc_2 = _-2b(_loc_9)._hResizePiority;
                    _loc_3 = _-2b(_loc_9)._vResizePiority;
                }
                if (_loc_2 > _loc_4)
                {
                    _loc_4 = _loc_2;
                    _loc_6 = _loc_8;
                }
                if (_loc_3 > _loc_5)
                {
                    _loc_5 = _loc_3;
                    _loc_7 = _loc_8;
                }
                _loc_8 = _loc_8 + 2;
            }
            this._hResizePiority = _loc_4;
            this._vResizePiority = _loc_5;
            if (this._group.layout == GroupLayoutType.Horizontal)
            {
                this._group.mainGridIndex = _loc_6;
            }
            else
            {
                this._group.mainGridIndex = _loc_7;
            }
            return;
        }// end function

        private function _-6b(event:Event) : void
        {
            var _loc_2:* = GGraph(event.currentTarget);
            var _loc_3:* = _loc_2.dragBounds;
            var _loc_4:* = this.getChildIndex(_loc_2);
            var _loc_5:* = this.getChildAt((_loc_4 - 1));
            var _loc_6:* = this.getChildAt((_loc_4 + 1));
            if (this._group.layout == GroupLayoutType.Horizontal)
            {
                _loc_3.x = _loc_5.x + Math.min(_-Na, _loc_5.width);
                _loc_3.right = _loc_6.x + _loc_6.width - Math.min(_-Na, _loc_6.width) - _-2A;
                var _loc_7:* = 0;
                _loc_3.height = 0;
                _loc_3.y = _loc_7;
            }
            else
            {
                _loc_3.y = _loc_5.y + Math.min(_-Na, _loc_5.height);
                _loc_3.bottom = _loc_6.y + _loc_6.height - Math.min(_-Na, _loc_6.height) - _-2A;
                var _loc_7:* = 0;
                _loc_3.width = 0;
                _loc_3.x = _loc_7;
            }
            _loc_2.dragBounds = this.localToGlobalRect(_loc_3.x, _loc_3.y, _loc_3.width, _loc_3.height, _loc_3);
            return;
        }// end function

        private function _-1g(event:Event) : void
        {
            var _loc_6:* = NaN;
            var _loc_2:* = GGraph(event.currentTarget);
            var _loc_3:* = this.getChildIndex(_loc_2);
            var _loc_4:* = this.getChildAt((_loc_3 - 1));
            var _loc_5:* = this.getChildAt((_loc_3 + 1));
            if (this._group.layout == GroupLayoutType.Horizontal)
            {
                _loc_4.width = _loc_2.x - _loc_4.x - _-Gt;
                _loc_6 = _loc_2.x + _loc_2.width + _-Gt;
                _loc_5.width = _loc_5.width + (_loc_5.x - _loc_6);
                _loc_5.x = _loc_6;
            }
            else
            {
                _loc_4.height = _loc_2.y - _loc_4.y - _-Gt;
                _loc_6 = _loc_2.y + _loc_2.height + _-Gt;
                _loc_5.height = _loc_5.height + (_loc_5.y - _loc_6);
                _loc_5.y = _loc_6;
            }
            return;
        }// end function

        public function _-4p(param1:GComponent, param2:Boolean = true) : ViewGrid
        {
            var view:* = param1;
            var recursive:* = param2;
            return _-9u(this, recursive, function (param1:ViewGrid) : Boolean
            {
                if (param1._-2V(view) != -1)
                {
                    return true;
                }
                return false;
            }// end function
            );
        }// end function

        public function _-8q(param1:String, param2:Boolean = true) : ViewGrid
        {
            var id:* = param1;
            var recursive:* = param2;
            return _-9u(this, recursive, function (param1:ViewGrid) : Boolean
            {
                if (param1.uid == id || param1._-OI(id) != -1)
                {
                    return true;
                }
                return false;
            }// end function
            );
        }// end function

        public function _-AX(param1:Array, param2:Boolean = true) : ViewGrid
        {
            var ids:* = param1;
            var recursive:* = param2;
            return _-9u(this, recursive, function (param1:ViewGrid) : Boolean
            {
                if (ids.indexOf(param1.uid) != -1 || param1._-Pr(ids))
                {
                    return true;
                }
                return false;
            }// end function
            );
        }// end function

        public function _-BT(param1:String) : _-2b
        {
            var _loc_4:* = null;
            var _loc_2:* = this._-9X;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._-Bb(_loc_3) as _-2b;
                if (_loc_4)
                {
                    if (_loc_4.uid == param1)
                    {
                        return _loc_4;
                    }
                    _loc_4 = _loc_4._-BT(param1);
                    if (_loc_4)
                    {
                        return _loc_4;
                    }
                }
                _loc_3++;
            }
            return null;
        }// end function

        override public function dispose() : void
        {
            _-9u(this, true, function (param1:ViewGrid) : void
            {
                param1.clear();
                return;
            }// end function
            );
            super.dispose();
            return;
        }// end function

        public static function _-9u(param1:_-2b, param2:Boolean, param3:Function) : ViewGrid
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_4:* = param1._-9X;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = param1._-Bb(_loc_5);
                if (_loc_6 is ViewGrid)
                {
                    if (_-2b.param3(ViewGrid(_loc_6)))
                    {
                        return ViewGrid(_loc_6);
                    }
                }
                else if (param2)
                {
                    _loc_7 = _-9u(_-2b._-2b(_loc_6), param2, param3);
                    if (_loc_7)
                    {
                        return _loc_7;
                    }
                }
                _loc_5++;
            }
            return null;
        }// end function

    }
}
