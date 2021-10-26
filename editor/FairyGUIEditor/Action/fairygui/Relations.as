package fairygui
{
    import *.*;
    import __AS3__.vec.*;

    public class Relations extends Object
    {
        private var _owner:GObject;
        private var _items:Vector.<RelationItem>;
        public var handling:GObject;
        var sizeDirty:Boolean;
        private static const RELATION_NAMES:Array = ["left-left", "left-center", "left-right", "center-center", "right-left", "right-center", "right-right", "top-top", "top-middle", "top-bottom", "middle-middle", "bottom-top", "bottom-middle", "bottom-bottom", "width-width", "height-height", "leftext-left", "leftext-right", "rightext-left", "rightext-right", "topext-top", "topext-bottom", "bottomext-top", "bottomext-bottom"];

        public function Relations(param1:GObject)
        {
            _owner = param1;
            _items = new Vector.<RelationItem>;
            return;
        }// end function

        public function add(param1:GObject, param2:int, param3:Boolean = false) : void
        {
            for each (_loc_4 in _items)
            {
                
                if ((_loc_4).target == param1)
                {
                    _loc_4.add(param2, param3);
                    return;
                }
            }
            var _loc_5:* = new RelationItem(_owner);
            _loc_5.target = param1;
            _loc_5.add(param2, param3);
            _loc_6.push(_loc_5);
            return;
        }// end function

        private function addItems(param1:GObject, param2:String) : void
        {
            var _loc_4:* = null;
            var _loc_6:* = false;
            var _loc_7:* = 0;
            var _loc_9:* = 0;
            var _loc_8:* = 0;
            var _loc_3:* = param2.split(",");
            var _loc_5:* = new RelationItem(_owner);
            _loc_5.target = param1;
            _loc_7 = 0;
            while (_loc_7 < 2)
            {
                
                _loc_4 = _loc_3[_loc_7];
                if (_loc_4)
                {
                    if (_loc_4.charAt((_loc_4.length - 1)) == "%")
                    {
                        _loc_4 = _loc_4.substr(0, (_loc_4.length - 1));
                        _loc_6 = true;
                    }
                    else
                    {
                        _loc_6 = false;
                    }
                    _loc_8 = _loc_4.indexOf("-");
                    if (_loc_8 == -1)
                    {
                        _loc_4 = _loc_4 + "-" + _loc_4;
                    }
                    _loc_9 = RELATION_NAMES.indexOf(_loc_4);
                    if (_loc_9 == -1)
                    {
                        throw new Error("invalid relation type");
                    }
                    _loc_5.internalAdd(_loc_9, _loc_6);
                }
                _loc_7++;
            }
            _items.push(_loc_5);
            return;
        }// end function

        public function remove(param1:GObject, param2:int) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = _items.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_3 = _items[_loc_5];
                if (_loc_3.target == param1)
                {
                    _loc_3.remove(param2);
                    if (_loc_3.isEmpty)
                    {
                        _loc_3.dispose();
                        _items.splice(_loc_5, 1);
                        _loc_4--;
                    }
                    else
                    {
                        _loc_5++;
                    }
                    continue;
                }
                _loc_5++;
            }
            return;
        }// end function

        public function contains(param1:GObject) : Boolean
        {
            for each (_loc_2 in _items)
            {
                
                if (_loc_2.target == param1)
                {
                    return true;
                }
            }
            return false;
        }// end function

        public function clearFor(param1:GObject) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = _items.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = _items[_loc_4];
                if (_loc_2.target == param1)
                {
                    _loc_2.dispose();
                    _items.splice(_loc_4, 1);
                    _loc_3--;
                    continue;
                }
                _loc_4++;
            }
            return;
        }// end function

        public function clearAll() : void
        {
            for each (_loc_1 in _items)
            {
                
                _loc_1.dispose();
            }
            _loc_2.length = 0;
            return;
        }// end function

        public function copyFrom(param1:Relations) : void
        {
            var _loc_3:* = null;
            clearAll();
            var _loc_2:* = param1._items;
            for each (_loc_4 in _loc_2)
            {
                
                _loc_3 = new RelationItem(_owner);
                _loc_3.copyFrom(_loc_4);
                _items.push(_loc_3);
            }
            return;
        }// end function

        public function dispose() : void
        {
            clearAll();
            return;
        }// end function

        public function onOwnerSizeChanged(param1:Number, param2:Number, param3:Boolean) : void
        {
            if (_items.length == 0)
            {
                return;
            }
            for each (_loc_4 in _items)
            {
                
                (_loc_4).applyOnSelfResized(param1, param2, param3);
            }
            return;
        }// end function

        public function ensureRelationsSizeCorrect() : void
        {
            if (_items.length == 0)
            {
                return;
            }
            sizeDirty = false;
            for each (_loc_1 in _items)
            {
                
                _loc_1.target.ensureSizeCorrect();
            }
            return;
        }// end function

        final public function get empty() : Boolean
        {
            return _items.length == 0;
        }// end function

        public function setup(param1:XML) : void
        {
            var _loc_3:* = null;
            var _loc_5:* = null;
            var _loc_2:* = param1.relation;
            for each (_loc_4 in _loc_2)
            {
                
                _loc_3 = (_loc_4).@target;
                if (_owner.parent)
                {
                    if (_loc_3)
                    {
                        _loc_5 = _owner.parent.getChildById(_loc_3);
                    }
                    else
                    {
                        _loc_5 = _owner.parent;
                    }
                }
                else
                {
                    _loc_5 = this.GComponent(_owner).getChildById(_loc_3);
                }
                if (_loc_5)
                {
                    addItems(_loc_5, _loc_4.@sidePair);
                }
            }
            return;
        }// end function

    }
}
