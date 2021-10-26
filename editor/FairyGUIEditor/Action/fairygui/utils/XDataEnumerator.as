package fairygui.utils
{
    import *.*;

    public class XDataEnumerator extends Object
    {
        private var _owner:XData;
        private var _selector:String;
        private var _index:int;
        private var _total:int;
        private var _current:XData;

        public function XDataEnumerator(param1:XData, param2:String)
        {
            this._owner = param1;
            this._selector = param2;
            this._index = -1;
            this._total = this._owner.getChildren().length;
            return;
        }// end function

        public function get current() : XData
        {
            return this._current;
        }// end function

        public function get index() : int
        {
            return this._index;
        }// end function

        public function moveNext() : Boolean
        {
            do
            {
                
                this._current = this._owner.getChildren()[this._index];
                if (this._selector == null || this._current.getName() == this._selector)
                {
                    return true;
                }
                var _loc_1:* = this;
                this._index = (this._index + 1);
                _loc_1._index = this._index + 1;
            }while (this._index < this._total)
            this._current = null;
            return false;
        }// end function

        public function erase() : void
        {
            if (this._current)
            {
                this._owner.removeChildAt(this._index);
                var _loc_1:* = this;
                var _loc_2:* = this._index - 1;
                _loc_1._index = _loc_2;
                var _loc_1:* = this;
                var _loc_2:* = this._total - 1;
                _loc_1._total = _loc_2;
                this._current = null;
            }
            return;
        }// end function

        public function reset() : void
        {
            this._index = -1;
            return;
        }// end function

    }
}
