package fairygui
{

    public class ButtonMode extends Object
    {
        public static const Common:int = 0;
        public static const Check:int = 1;
        public static const Radio:int = 2;

        public function ButtonMode()
        {
            return;
        }// end function

        public static function parse(param1:String) : int
        {
            var _loc_2:* = param1;
            while (_loc_2 === "Common")
            {
                
                return 0;
                
                return 1;
                
                return 2;
                
                return 0;
            }
            if ("Check" === _loc_2) goto 12;
            if ("Radio" === _loc_2) goto 16;
            ;
        }// end function

    }
}
