package fairygui
{

    public class AutoSizeType extends Object
    {
        public static const None:int = 0;
        public static const Both:int = 1;
        public static const Height:int = 2;
        public static const Shrink:int = 3;

        public function AutoSizeType()
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
                
                return 3;
                
                return 0;
            }
            if ("both" === _loc_2) goto 12;
            if ("height" === _loc_2) goto 16;
            if ("shrink" === _loc_2) goto 20;
            ;
        }// end function

    }
}
