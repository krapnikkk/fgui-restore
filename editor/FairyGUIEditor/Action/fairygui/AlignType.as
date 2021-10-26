package fairygui
{

    public class AlignType extends Object
    {
        public static const Left:int = 0;
        public static const Center:int = 1;
        public static const Right:int = 2;

        public function AlignType()
        {
            return;
        }// end function

        public static function parse(param1:String) : int
        {
            var _loc_2:* = param1;
            while (_loc_2 === "left")
            {
                
                return 0;
                
                return 1;
                
                return 2;
                
                return 0;
            }
            if ("center" === _loc_2) goto 12;
            if ("right" === _loc_2) goto 16;
            ;
        }// end function

        public static function toString(param1:int) : String
        {
            return param1 == 0 ? ("left") : (param1 == 1 ? ("center") : ("right"));
        }// end function

    }
}
