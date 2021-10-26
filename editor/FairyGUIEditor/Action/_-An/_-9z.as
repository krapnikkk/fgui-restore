package _-An
{
    import *.*;
    import fairygui.editor.api.*;

    public class _-9z extends Object
    {
        private var _type:int;
        private var _elements:Array;
        private var _index:int;
        private var _color:uint;
        private var _shape:int;

        public function _-9z(param1:int, param2:int, param3:int = 0)
        {
            this._type = param1;
            this._color = param2;
            this._shape = param3;
            this._elements = [];
            return;
        }// end function

        public function _-8R() : void
        {
            this._index = 0;
            return;
        }// end function

        public function _-7T(param1:IDocument) : _-Jy
        {
            var _loc_2:* = this._elements[this._index];
            if (!_loc_2)
            {
                _loc_2 = new _-Jy(this._type, this._color, this._shape);
                this._elements[this._index] = _loc_2;
                param1.editor.cursorManager.setCursorForObject(_loc_2, CursorType.FINGER);
            }
            var _loc_3:* = this;
            var _loc_4:* = this._index + 1;
            _loc_3._index = _loc_4;
            return _loc_2;
        }// end function

        public function _-K7() : void
        {
            var _loc_2:* = null;
            var _loc_1:* = this._index;
            while (_loc_1 < this._elements.length)
            {
                
                _loc_2 = this._elements[_loc_1];
                if (_loc_2.parent)
                {
                    _loc_2.selected = false;
                    _loc_2.parent.removeChild(_loc_2);
                }
                _loc_1++;
            }
            this._index = 0;
            return;
        }// end function

    }
}
