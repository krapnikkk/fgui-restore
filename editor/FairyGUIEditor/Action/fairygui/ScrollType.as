package fairygui
{

    public class ScrollType extends Object
    {
        public static const Horizontal:int = 0;
        public static const Vertical:int = 1;
        public static const Both:int = 2;

        public function ScrollType()
        {
            return;
        }// end function

        public static function parse(param1:String) : int
        {
            var _loc_2:* = param1;
            while (_loc_2 === "horizontal")
            {
                
                return 0;
                
                return 1;
                
                return 2;
                
                return 1;
            }
            if ("vertical" === _loc_2) goto 12;
            if ("both" === _loc_2) goto 16;
            ;
        }// end function

    }
}
