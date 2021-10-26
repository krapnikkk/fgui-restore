package fairygui.utils
{
    import *.*;

    public class SimpleDispatcher extends Object
    {
        private var _elements:Array;
        private var _dispatching:int;

        public function SimpleDispatcher() : void
        {
            _elements = [];
            return;
        }// end function

        public function addListener(param1:int, param2:Function) : void
        {
            var _loc_3:* = _elements[param1];
            if (!_loc_3)
            {
                _loc_3 = [];
                _elements[param1] = _loc_3;
                _loc_3.push(param2);
            }
            else if (_loc_3.indexOf(param2) == -1)
            {
                _loc_3.push(param2);
            }
            return;
        }// end function

        public function removeListener(param1:int, param2:Function) : void
        {
            var _loc_4:* = 0;
            var _loc_3:* = _elements[param1];
            if (_loc_3)
            {
                _loc_4 = _loc_3.indexOf(param2);
                if (_loc_4 != -1)
                {
                    _loc_3[_loc_4] = null;
                }
            }
            return;
        }// end function

        public function hasListener(param1:int) : Boolean
        {
            var _loc_2:* = _elements[param1];
            if (_loc_2 && _loc_2.length > 0)
            {
                return true;
            }
            return false;
        }// end function

        public function dispatch(param1:Object, param2:int) : void
        {
            var _loc_4:* = false;
            var _loc_5:* = null;
            var _loc_3:* = _elements[param2];
            if (!_loc_3 || _loc_3.length == 0)
            {
                return;
            }
            var _loc_6:* = 0;
            (_dispatching + 1);
            while (_loc_6 < _loc_3.length)
            {
                
                _loc_5 = _loc_3[_loc_6];
                if (_loc_5 != null)
                {
                    if (_loc_5.length == 1)
                    {
                        this._loc_5(param1);
                    }
                    else
                    {
                        this._loc_5();
                    }
                }
                else
                {
                    _loc_4 = true;
                }
                _loc_6++;
            }
            (_dispatching - 1);
            if (_loc_4 && _dispatching == 0)
            {
                _loc_6 = 0;
                while (_loc_6 < _loc_3.length)
                {
                    
                    _loc_5 = _loc_3[_loc_6];
                    if (_loc_5 == null)
                    {
                        _loc_3.splice(_loc_6, 1);
                        continue;
                    }
                    _loc_6++;
                }
            }
            return;
        }// end function

        public function clear() : void
        {
            _elements.length = 0;
            return;
        }// end function

    }
}
