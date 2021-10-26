package fairygui.tween
{

    public class GPathPoint extends Object
    {
        public var x:Number;
        public var y:Number;
        public var control1_x:Number;
        public var control1_y:Number;
        public var control2_x:Number;
        public var control2_y:Number;
        public var curveType:int;
        public var smooth:Boolean;

        public function GPathPoint()
        {
            x = 0;
            y = 0;
            control1_x = 0;
            control1_y = 0;
            control2_x = 0;
            control2_y = 0;
            curveType = 0;
            smooth = true;
            return;
        }// end function

        public function clone() : GPathPoint
        {
            var _loc_1:* = new GPathPoint();
            _loc_1.x = x;
            _loc_1.y = y;
            _loc_1.control1_x = control1_x;
            _loc_1.control1_y = control1_y;
            _loc_1.control2_x = control2_x;
            _loc_1.control2_y = control2_y;
            _loc_1.curveType = curveType;
            return _loc_1;
        }// end function

        public function toString() : String
        {
            switch((curveType - 1)) branch count is:<1>[11, 43] default offset is:<108>;
            return curveType + "," + x + "," + y + "," + control1_x + "," + control1_y;
            return curveType + "," + x + "," + y + "," + control1_x + "," + control1_y + "," + control2_x + "," + control2_y + "," + (smooth ? (1) : (0));
            return curveType + "," + x + "," + y;
        }// end function

        public static function newPoint(param1:Number = 0, param2:Number = 0, param3:int = 0) : GPathPoint
        {
            var _loc_4:* = new GPathPoint;
            _loc_4.x = param1;
            _loc_4.y = param2;
            _loc_4.control1_x = 0;
            _loc_4.control1_y = 0;
            _loc_4.control2_x = 0;
            _loc_4.control2_y = 0;
            _loc_4.curveType = param3;
            return _loc_4;
        }// end function

        public static function newBezierPoint(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0) : GPathPoint
        {
            var _loc_5:* = new GPathPoint;
            _loc_5.x = param1;
            _loc_5.y = param2;
            _loc_5.control1_x = param3;
            _loc_5.control1_y = param4;
            _loc_5.control2_x = 0;
            _loc_5.control2_y = 0;
            _loc_5.curveType = 1;
            return _loc_5;
        }// end function

        public static function newCubicBezierPoint(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0) : GPathPoint
        {
            var _loc_7:* = new GPathPoint;
            _loc_7.x = param1;
            _loc_7.y = param2;
            _loc_7.control1_x = param3;
            _loc_7.control1_y = param4;
            _loc_7.control2_x = param5;
            _loc_7.control2_y = param6;
            _loc_7.curveType = 2;
            return _loc_7;
        }// end function

    }
}
