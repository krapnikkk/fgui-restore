package fairygui.utils
{
    import *.*;
    import flash.utils.*;

    public class RuntimeErrorUtil extends Object
    {
        private static var m_errors:Dictionary = new Dictionary();
        private static var m_loaded:Boolean;
        private static var ERROR_DATA:Class = RuntimeErrorUtil_ERROR_DATA;

        public function RuntimeErrorUtil()
        {
            return;
        }// end function

        public static function loadFromXML(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            RuntimeErrorUtil.m_loaded = true;
            for each (_loc_2 in param1.error)
            {
                
                _loc_3 = int(_loc_2.@id);
                _loc_4 = unescape(_loc_2.toString());
                RuntimeErrorUtil.m_errors[_loc_3] = _loc_4;
            }
            return;
        }// end function

        public static function toString(param1:Error) : String
        {
            if (param1.errorID)
            {
                return RuntimeErrorUtil.toStringFromID(param1.errorID);
            }
            return param1.message;
        }// end function

        public static function toStringFromID(param1:int) : String
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (!RuntimeErrorUtil.m_loaded)
            {
                _loc_3 = new ERROR_DATA();
                _loc_4 = _loc_3.readUTFBytes(_loc_3.length);
                _loc_3.clear();
                RuntimeErrorUtil.loadFromXML(new XML(_loc_4));
            }
            var _loc_2:* = RuntimeErrorUtil.m_errors[param1];
            _loc_2 = _loc_2 != null ? (_loc_2) : ("Error #" + param1);
            return _loc_2;
        }// end function

    }
}
