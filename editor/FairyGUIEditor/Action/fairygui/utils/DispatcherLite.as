package fairygui.utils
{
    import *.*;

    public class DispatcherLite extends Object
    {
        private var iElements:Array;
        private var iEnumI:int;
        private var iDispatchingType:int;

        public function DispatcherLite() : void
        {
            this.iElements = [];
            this.iDispatchingType = -1;
            return;
        }// end function

        public function on(param1:int, param2:Function) : void
        {
            var _loc_3:* = this.iElements[param1];
            if (!_loc_3)
            {
                _loc_3 = [];
                this.iElements[param1] = _loc_3;
                _loc_3.push(param2);
            }
            else if (_loc_3.indexOf(param2) == -1)
            {
                _loc_3.push(param2);
            }
            return;
        }// end function

        public function off(param1:int, param2:Function) : void
        {
            var _loc_4:* = 0;
            var _loc_3:* = this.iElements[param1];
            if (_loc_3)
            {
                _loc_4 = _loc_3.indexOf(param2);
                if (_loc_4 != -1)
                {
                    _loc_3.splice(_loc_4, 1);
                    if (param1 == this.iDispatchingType && _loc_4 <= this.iEnumI)
                    {
                        var _loc_5:* = this;
                        var _loc_6:* = this.iEnumI - 1;
                        _loc_5.iEnumI = _loc_6;
                    }
                }
            }
            return;
        }// end function

        public function emit(param1:Object, param2:int) : void
        {
            var _loc_4:* = null;
            var _loc_3:* = this.iElements[param2];
            if (!_loc_3 || _loc_3.length == 0 || this.iDispatchingType == param2)
            {
                return;
            }
            this.iEnumI = 0;
            this.iDispatchingType = param2;
            while (this.iEnumI < _loc_3.length)
            {
                
                _loc_4 = _loc_3[this.iEnumI];
                if (_loc_4.length == 1)
                {
                    this._loc_4(param1);
                }
                else
                {
                    this._loc_4();
                }
                var _loc_5:* = this;
                var _loc_6:* = this.iEnumI + 1;
                _loc_5.iEnumI = _loc_6;
            }
            this.iDispatchingType = -1;
            return;
        }// end function

        public function offAll() : void
        {
            this.iElements.length = 0;
            return;
        }// end function

    }
}
