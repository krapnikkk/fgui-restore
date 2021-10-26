package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.utils.*;

    public class FRelations extends Object
    {
        private var _owner:FObject;
        private var _items:Vector.<FRelationItem>;
        private var _widthLocked:Boolean;
        private var _heightLocked:Boolean;
        public var handling:FObject;

        public function FRelations(param1:FObject)
        {
            this._owner = param1;
            this._items = new Vector.<FRelationItem>;
            return;
        }// end function

        public function get widthLocked() : Boolean
        {
            return this._widthLocked;
        }// end function

        public function get heightLocked() : Boolean
        {
            return this._heightLocked;
        }// end function

        public function addItem(param1:FObject, param2:int, param3:Boolean = false) : FRelationItem
        {
            var _loc_4:* = this.getItem(param1);
            if (!this.getItem(param1))
            {
                _loc_4 = new FRelationItem(this._owner);
                _loc_4.target = param1;
                if (param2 != -1)
                {
                    _loc_4.addDef(param2, param3, false);
                }
                this._items.push(_loc_4);
                return _loc_4;
            }
            else
            {
                if (param2 != -1)
                {
                    _loc_4.addDef(param2, param3);
                }
                return _loc_4;
            }
        }// end function

        public function addItem2(param1:FObject, param2:String) : FRelationItem
        {
            var _loc_3:* = this.getItem(param1);
            if (!_loc_3)
            {
                _loc_3 = new FRelationItem(this._owner);
                _loc_3.target = param1;
                this._items.push(_loc_3);
            }
            _loc_3.addDefs(param2);
            return _loc_3;
        }// end function

        public function removeItem(param1:FRelationItem) : void
        {
            var _loc_2:* = this._items.indexOf(param1);
            param1.dispose();
            this._items.splice(_loc_2, 1);
            return;
        }// end function

        public function replaceItem(param1:int, param2:FObject, param3:String) : void
        {
            var _loc_4:* = this._items[param1];
            _loc_4.set(param2, param3, false);
            return;
        }// end function

        public function get items() : Vector.<FRelationItem>
        {
            return this._items;
        }// end function

        public function getItem(param1:FObject) : FRelationItem
        {
            var _loc_2:* = this._items.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._items[_loc_3].target == param1)
                {
                    return this._items[_loc_3];
                }
                _loc_3++;
            }
            return null;
        }// end function

        public function hasTarget(param1:FObject) : Boolean
        {
            var _loc_2:* = this._items.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._items[_loc_3].target == param1)
                {
                    return true;
                }
                _loc_3++;
            }
            return false;
        }// end function

        public function removeTarget(param1:FObject) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = this._items.length;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._items[_loc_3];
                if (_loc_4.target == param1)
                {
                    _loc_4.dispose();
                    this._items.splice(_loc_3, 1);
                    _loc_2 = _loc_2 - 1;
                    continue;
                }
                _loc_3++;
            }
            return;
        }// end function

        public function replaceTarget(param1:FObject, param2:FObject) : void
        {
            var _loc_3:* = this._items.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (this._items[_loc_4].target == param1)
                {
                    this._items[_loc_4].target = param2;
                }
                _loc_4++;
            }
            return;
        }// end function

        public function onOwnerSizeChanged(param1:Number, param2:Number, param3:Boolean) : void
        {
            var _loc_4:* = null;
            if (this._items.length == 0)
            {
                return;
            }
            for each (_loc_4 in this._items)
            {
                
                _loc_4.applySelfSizeChanged(param1, param2, param3);
            }
            return;
        }// end function

        public function reset() : void
        {
            var _loc_1:* = this._items.length;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                this._items[_loc_2].dispose();
                _loc_2++;
            }
            this._items.length = 0;
            this._widthLocked = false;
            this._heightLocked = false;
            return;
        }// end function

        public function get isEmpty() : Boolean
        {
            return this._items.length == 0;
        }// end function

        public function read(param1:XData, param2:Boolean = false) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = false;
            var _loc_11:* = null;
            if (param2)
            {
                this.reset();
            }
            else
            {
                _loc_6 = this._items.length;
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_8 = this._items[_loc_7];
                    if (!_loc_8.readOnly)
                    {
                        _loc_8.dispose();
                        this._items.splice(_loc_7, 1);
                        _loc_6 = _loc_6 - 1;
                        continue;
                    }
                    _loc_7++;
                }
            }
            var _loc_3:* = param1.getEnumerator("relation");
            if (param2)
            {
                this._widthLocked = false;
                this._heightLocked = false;
            }
            while (_loc_3.moveNext())
            {
                
                _loc_9 = _loc_3.current;
                _loc_4 = _loc_9.getAttribute("target");
                if (param2)
                {
                    _loc_5 = FComponent(this._owner).getChildById(_loc_4);
                }
                else if (this._owner._parent)
                {
                    if (_loc_4)
                    {
                        _loc_5 = this._owner._parent.getChildById(_loc_4);
                    }
                    else
                    {
                        _loc_5 = this._owner._parent;
                    }
                }
                if (_loc_5)
                {
                    _loc_10 = param2 && !FObjectFlags.isDocRoot(this._owner._flags);
                    _loc_11 = _loc_9.getAttribute("sidePair");
                    _loc_8 = this.getItem(_loc_5);
                    if (!_loc_8)
                    {
                        _loc_8 = new FRelationItem(this._owner);
                        _loc_8.set(_loc_5, _loc_11, _loc_10);
                        this._items.push(_loc_8);
                    }
                    else
                    {
                        _loc_8.addDefs(_loc_11, false);
                    }
                    if (_loc_10)
                    {
                        this._widthLocked = _loc_8.containsWidthRelated;
                        this._heightLocked = _loc_8.containsHeightRelated;
                    }
                }
            }
            return;
        }// end function

        public function write(param1:XData = null) : XData
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (!param1)
            {
                param1 = XData.create("relations");
            }
            var _loc_4:* = this._items.length;
            var _loc_5:* = FObjectFlags.isDocRoot(this._owner._flags);
            var _loc_6:* = 0;
            while (_loc_6 < _loc_4)
            {
                
                _loc_2 = this._items[_loc_6];
                if (!_loc_5 && _loc_2.readOnly)
                {
                }
                else
                {
                    _loc_3 = XData.create("relation");
                    if (_loc_2.target == this._owner._parent)
                    {
                        _loc_3.setAttribute("target", "");
                    }
                    else
                    {
                        _loc_3.setAttribute("target", _loc_2.target._id);
                    }
                    _loc_3.setAttribute("sidePair", _loc_2.desc);
                    param1.appendChild(_loc_3);
                }
                _loc_6++;
            }
            return param1;
        }// end function

    }
}
