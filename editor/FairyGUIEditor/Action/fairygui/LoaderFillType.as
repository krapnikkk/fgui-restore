package fairygui
{

    public class LoaderFillType extends Object
    {
        public static const None:int = 0;
        public static const Scale:int = 1;
        public static const ScaleMatchHeight:int = 2;
        public static const ScaleMatchWidth:int = 3;
        public static const ScaleFree:int = 4;
        public static const ScaleNoBorder:int = 5;

        public function LoaderFillType()
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
                
                return 4;
                
                return 5;
                
                return 0;
            }
            if ("scale" === _loc_2) goto 12;
            if ("scaleMatchHeight" === _loc_2) goto 16;
            if ("scaleMatchWidth" === _loc_2) goto 20;
            if ("scaleFree" === _loc_2) goto 24;
            if ("scaleNoBorder" === _loc_2) goto 28;
            ;
        }// end function

    }
}
