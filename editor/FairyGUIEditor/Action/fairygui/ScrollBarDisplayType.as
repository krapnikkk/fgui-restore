package fairygui
{

    public class ScrollBarDisplayType extends Object
    {
        public static const Default:int = 0;
        public static const Visible:int = 1;
        public static const Auto:int = 2;
        public static const Hidden:int = 3;

        public function ScrollBarDisplayType()
        {
            return;
        }// end function

        public static function parse(param1:String) : int
        {
            var _loc_2:* = param1;
            while (_loc_2 === "default")
            {
                
                return 0;
                
                return 1;
                
                return 2;
                
                return 3;
                
                return 0;
            }
            if ("visible" === _loc_2) goto 12;
            if ("auto" === _loc_2) goto 16;
            if ("hidden" === _loc_2) goto 20;
            ;
        }// end function

    }
}
