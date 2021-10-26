package fairygui
{

    public class Margin extends Object
    {
        public var left:int;
        public var right:int;
        public var top:int;
        public var bottom:int;

        public function Margin()
        {
            return;
        }// end function

        public function parse(param1:String) : void
        {
            var _loc_3:* = 0;
            var _loc_2:* = param1.split(",");
            if (_loc_2.length == 1)
            {
                _loc_3 = _loc_2[0];
                top = _loc_3;
                bottom = _loc_3;
                left = _loc_3;
                right = _loc_3;
            }
            else
            {
                top = _loc_2[0];
                bottom = _loc_2[1];
                left = _loc_2[2];
                right = _loc_2[3];
            }
            return;
        }// end function

        public function copy(param1:Margin) : void
        {
            top = param1.top;
            bottom = param1.bottom;
            left = param1.left;
            right = param1.right;
            return;
        }// end function

    }
}
