package fairygui
{

    public class ListLayoutType extends Object
    {
        public static const SingleColumn:int = 0;
        public static const SingleRow:int = 1;
        public static const FlowHorizontal:int = 2;
        public static const FlowVertical:int = 3;
        public static const Pagination:int = 4;

        public function ListLayoutType()
        {
            return;
        }// end function

        public static function parse(param1:String) : int
        {
            var _loc_2:* = param1;
            while (_loc_2 === "column")
            {
                
                return 0;
                
                return 1;
                
                return 2;
                
                return 3;
                
                return 4;
                
                return 0;
            }
            if ("row" === _loc_2) goto 12;
            if ("flow_hz" === _loc_2) goto 16;
            if ("flow_vt" === _loc_2) goto 20;
            if ("pagination" === _loc_2) goto 24;
            ;
        }// end function

    }
}
