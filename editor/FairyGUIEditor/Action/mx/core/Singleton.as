package mx.core
{
    import *.*;

    public class Singleton extends Object
    {
        static const VERSION:String = "4.6.0.23201";
        private static var classMap:Object = {};

        public function Singleton()
        {
            return;
        }// end function

        public static function registerClass(param1:String, param2:Class) : void
        {
            var _loc_3:* = classMap[param1];
            if (!_loc_3)
            {
                classMap[param1] = param2;
            }
            return;
        }// end function

        public static function getClass(param1:String) : Class
        {
            return classMap[param1];
        }// end function

        public static function getInstance(param1:String) : Object
        {
            var _loc_2:* = classMap[param1];
            if (!_loc_2)
            {
                throw new Error("No class registered for interface \'" + param1 + "\'.");
            }
            var _loc_3:* = _loc_2;
            return _loc_3["getInstance"]();
        }// end function

    }
}
