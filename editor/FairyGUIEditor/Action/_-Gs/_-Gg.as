package _-Gs
{
    import *.*;
    import fairygui.*;
    import flash.events.*;

    public class _-Gg extends Object
    {
        public var _-Pt:Function;
        public var _-K9:Function;
        public var _-Mm:Function;
        private var _list:GList;
        private var _-Ge:String;
        private var _-Kw:Object;

        public function _-Gg(param1:GList, param2:String = null) : void
        {
            this._list = param1;
            this._-Ge = param2;
            return;
        }// end function

        public function add(event:Event = null) : void
        {
            var _loc_2:* = this._list.numChildren;
            var _loc_3:* = this._list.addItemFromPool().asCom;
            this._list.selectedIndex = _loc_2;
            this._list.scrollToView(_loc_2);
            this._-1B(_loc_2);
            if (this._-Pt != null)
            {
                this._-Pt(_loc_2, _loc_3);
            }
            return;
        }// end function

        public function insert(event:Event = null) : void
        {
            var _loc_2:* = this._list.selectedIndex;
            if (_loc_2 == -1)
            {
                _loc_2 = this._list.numChildren;
            }
            var _loc_3:* = this._list.getFromPool().asCom;
            this._list.addChildAt(_loc_3, _loc_2);
            this._list.selectedIndex = _loc_2;
            this._list.scrollToView(_loc_2);
            this._-1B(_loc_2);
            if (this._-Pt != null)
            {
                this._-Pt(_loc_2, _loc_3);
            }
            return;
        }// end function

        public function remove(event:Event = null) : void
        {
            var _loc_2:* = this._list.selectedIndex;
            if (_loc_2 == -1)
            {
                return;
            }
            this._list.removeChildToPoolAt(_loc_2);
            var _loc_3:* = _loc_2;
            if (_loc_3 >= this._list.numChildren)
            {
                _loc_3 = this._list.numChildren - 1;
            }
            if (_loc_3 >= 0)
            {
                this._-1B(_loc_3);
                this._list.selectedIndex = _loc_3;
            }
            if (this._-K9 != null)
            {
                this._-K9(_loc_2);
            }
            return;
        }// end function

        public function moveUp(event:Event = null) : void
        {
            var _loc_2:* = this._list.selectedIndex;
            if (_loc_2 > 0)
            {
                this._-LP(_loc_2, (_loc_2 - 1));
            }
            return;
        }// end function

        public function moveDown(event:Event = null) : void
        {
            var _loc_2:* = this._list.selectedIndex;
            if (_loc_2 < (this._list.numChildren - 1))
            {
                this._-LP(_loc_2, (_loc_2 + 1));
            }
            return;
        }// end function

        private function _-LP(param1:int, param2:int) : void
        {
            this._list.swapChildrenAt(param1, param2);
            this._list.selectedIndex = param2;
            this._-1B(Math.min(param1, param2), Math.max(param1, param2));
            if (this._-Mm != null)
            {
                this._-Mm(param1, param2);
            }
            return;
        }// end function

        private function _-1B(param1:int, param2:int = -1) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            if (!this._-Ge)
            {
                return;
            }
            var _loc_3:* = param2 == -1 ? ((this._list.numChildren - 1)) : (param2);
            _loc_4 = param1;
            while (_loc_4 <= _loc_3)
            {
                
                _loc_5 = this._list.getChildAt(_loc_4).asCom;
                _loc_5.getChild(this._-Ge).text = "" + _loc_4;
                _loc_4++;
            }
            return;
        }// end function

    }
}
