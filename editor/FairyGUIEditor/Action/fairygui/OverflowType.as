package fairygui
{

    public class OverflowType extends Object
    {
        public static const Visible:int = 0;
        public static const Hidden:int = 1;
        public static const Scroll:int = 2;
        public static const Scale:int = 3;
        public static const ScaleFree:int = 4;

        public function OverflowType()
        {
            return;
        }// end function

        public static function parse(param1:String) : int
        {
            var _loc_2:* = param1;
            while (_loc_2 === "visible")
            {
                
                return 0;
                
                return 1;
                
                return 2;
                
                return 3;
                
                return 4;
                
                return 0;
            }
            if ("hidden" === _loc_2) goto 12;
            if ("scroll" === _loc_2) goto 16;
            if ("scale" === _loc_2) goto 20;
            if ("scaleFree" === _loc_2) goto 24;
            ;
        }// end function

    }
}
