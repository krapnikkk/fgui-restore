package fairygui
{

    public class GroupLayoutType extends Object
    {
        public static const None:int = 0;
        public static const Horizontal:int = 1;
        public static const Vertical:int = 2;

        public function GroupLayoutType()
        {
            return;
        }// end function

        public static function parse(param1:String) : int
        {
            var _loc_2:* = param1;
            while (_loc_2 === "none")
            {
                
                return 0;
                
                return 1;
                
                return 2;
                
                return 0;
            }
            if ("hz" === _loc_2) goto 12;
            if ("vt" === _loc_2) goto 16;
            ;
        }// end function

    }
}
