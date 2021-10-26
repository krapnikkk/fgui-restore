package fairygui
{
    import *.*;
    import __AS3__.vec.*;

    public class GObjectPool extends Object
    {
        private var _pool:Object;
        private var _count:int;
        private var _initCallback:Function;

        public function GObjectPool()
        {
            _pool = {};
            return;
        }// end function

        public function get initCallback() : Function
        {
            return _initCallback;
        }// end function

        public function set initCallback(param1:Function) : void
        {
            _initCallback = param1;
            return;
        }// end function

        public function clear() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            for each (_loc_1 in _pool)
            {
                
                _loc_2 = _loc_1.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_1[_loc_3].dispose();
                    _loc_3++;
                }
            }
            _pool = {};
            _count = 0;
            return;
        }// end function

        public function get count() : int
        {
            return _count;
        }// end function

        public function getObject(param1:String) : GObject
        {
            param1 = UIPackage.normalizeURL(param1);
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = _pool[param1];
            if (_loc_2 != null && _loc_2.length)
            {
                (_count - 1);
                return _loc_2.shift();
            }
            var _loc_3:* = UIPackage.createObjectFromURL(param1);
            if (_loc_3)
            {
                if (_initCallback != null)
                {
                    this._initCallback(_loc_3);
                }
            }
            return _loc_3;
        }// end function

        public function returnObject(param1:GObject) : void
        {
            var _loc_3:* = param1.resourceURL;
            if (!_loc_3)
            {
                return;
            }
            var _loc_2:* = _pool[_loc_3];
            if (_loc_2 == null)
            {
                _loc_2 = new Vector.<GObject>;
                _pool[_loc_3] = _loc_2;
            }
            (_count + 1);
            _loc_2.push(param1);
            return;
        }// end function

    }
}
