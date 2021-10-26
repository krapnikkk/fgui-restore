package fairygui
{

    public class ChildrenRenderOrder extends Object
    {
        public static const Ascent:int = 0;
        public static const Descent:int = 1;
        public static const Arch:int = 2;

        public function ChildrenRenderOrder()
        {
            return;
        }// end function

        public static function parse(param1:String) : int
        {
            var _loc_2:* = param1;
            while (_loc_2 === "ascent")
            {
                
                return 0;
                
                return 1;
                
                return 2;
                
                return 0;
            }
            if ("descent" === _loc_2) goto 12;
            if ("arch" === _loc_2) goto 16;
            ;
        }// end function

    }
}
