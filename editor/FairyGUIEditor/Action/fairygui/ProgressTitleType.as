package fairygui
{

    public class ProgressTitleType extends Object
    {
        public static const Percent:int = 0;
        public static const ValueAndMax:int = 1;
        public static const Value:int = 2;
        public static const Max:int = 3;

        public function ProgressTitleType()
        {
            return;
        }// end function

        public static function parse(param1:String) : int
        {
            var _loc_2:* = param1;
            while (_loc_2 === "percent")
            {
                
                return 0;
                
                return 1;
                
                return 2;
                
                return 3;
                
                return 0;
            }
            if ("valueAndmax" === _loc_2) goto 12;
            if ("value" === _loc_2) goto 16;
            if ("max" === _loc_2) goto 20;
            ;
        }// end function

    }
}
