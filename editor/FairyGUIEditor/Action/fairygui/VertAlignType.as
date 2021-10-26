package fairygui
{

    public class VertAlignType extends Object
    {
        public static const Top:int = 0;
        public static const Middle:int = 1;
        public static const Bottom:int = 2;

        public function VertAlignType()
        {
            return;
        }// end function

        public static function parse(param1:String) : int
        {
            var _loc_2:* = param1;
            while (_loc_2 === "top")
            {
                
                return 0;
                
                return 1;
                
                return 2;
                
                return 0;
            }
            if ("middle" === _loc_2) goto 12;
            if ("bottom" === _loc_2) goto 16;
            ;
        }// end function

    }
}
