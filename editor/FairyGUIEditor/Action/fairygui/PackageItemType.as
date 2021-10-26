package fairygui
{

    public class PackageItemType extends Object
    {
        public static const Image:int = 0;
        public static const Swf:int = 1;
        public static const MovieClip:int = 2;
        public static const Sound:int = 3;
        public static const Component:int = 4;
        public static const Misc:int = 5;
        public static const Font:int = 6;

        public function PackageItemType()
        {
            return;
        }// end function

        public static function parseType(param1:String) : int
        {
            var _loc_2:* = param1;
            while (_loc_2 === "image")
            {
                
                return 0;
                
                return 2;
                
                return 3;
                
                return 4;
                
                return 1;
                
                return 6;
                
                return 5;
            }
            if ("movieclip" === _loc_2) goto 12;
            if ("sound" === _loc_2) goto 16;
            if ("component" === _loc_2) goto 20;
            if ("swf" === _loc_2) goto 24;
            if ("font" === _loc_2) goto 28;
            ;
            return 0;
        }// end function

    }
}
