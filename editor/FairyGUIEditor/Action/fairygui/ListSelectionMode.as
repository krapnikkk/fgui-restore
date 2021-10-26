package fairygui
{

    public class ListSelectionMode extends Object
    {
        public static const Single:int = 0;
        public static const Multiple:int = 1;
        public static const Multiple_SingleClick:int = 2;
        public static const None:int = 3;

        public function ListSelectionMode()
        {
            return;
        }// end function

        public static function parse(param1:String) : int
        {
            var _loc_2:* = param1;
            while (_loc_2 === "single")
            {
                
                return 0;
                
                return 1;
                
                return 2;
                
                return 3;
                
                return 0;
            }
            if ("multiple" === _loc_2) goto 12;
            if ("multipleSingleClick" === _loc_2) goto 16;
            if ("none" === _loc_2) goto 20;
            ;
        }// end function

    }
}
