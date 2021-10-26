package fairygui.utils
{
    import *.*;
    import __AS3__.vec.*;
    import flash.geom.*;

    public class PointList extends Object
    {
        private var _list:Vector.<Number>;

        public function PointList()
        {
            _list = new Vector.<Number>;
            return;
        }// end function

        public function get rawList() : Vector.<Number>
        {
            return _list;
        }// end function

        public function set rawList(param1:Vector.<Number>) : void
        {
            _list = param1;
            return;
        }// end function

        public function push(param1:Number, param2:Number) : void
        {
            _list.push(param1);
            _list.push(param2);
            return;
        }// end function

        public function push2(param1:Point) : void
        {
            _list.push(param1.x);
            _list.push(param1.y);
            return;
        }// end function

        public function push3(param1:PointList, param2:int) : void
        {
            _list.push(param1._list[param2 * 2]);
            _list.push(param1._list[param2 * 2 + 1]);
            return;
        }// end function

        public function addRange(param1:PointList) : void
        {
            var _loc_3:* = 0;
            var _loc_2:* = param1._list.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _list.push(param1._list[_loc_3]);
                _loc_3++;
            }
            return;
        }// end function

        public function insert(param1:int, param2:Number, param3:Number) : void
        {
            _list.splice(param1 * 2, 0, param2, param3);
            return;
        }// end function

        public function insert2(param1:int, param2:Point) : void
        {
            _list.splice(param1 * 2, 0, param2.x, param2.y);
            return;
        }// end function

        public function insert3(param1:int, param2:PointList, param3:int) : void
        {
            _list.splice(param1 * 2, 0, param2._list[param3 * 2], param2._list[param3 * 2 + 1]);
            return;
        }// end function

        public function remove(param1:int) : void
        {
            _list.splice(param1 * 2, 2);
            return;
        }// end function

        public function get_x(param1:int) : Number
        {
            return _list[param1 * 2];
        }// end function

        public function get_y(param1:int) : Number
        {
            return _list[param1 * 2 + 1];
        }// end function

        public function set(param1:int, param2:Number, param3:Number) : void
        {
            _list[param1 * 2] = param2;
            _list[param1 * 2 + 1] = param3;
            return;
        }// end function

        public function setBy(param1:int, param2:Number, param3:Number) : void
        {
            var _loc_4:* = param1 * 2;
            var _loc_5:* = _list[_loc_4] + param2;
            _list[_loc_4] = _loc_5;
            _loc_5 = param1 * 2 + 1;
            _loc_4 = _list[_loc_5] + param3;
            _list[_loc_5] = _loc_4;
            return;
        }// end function

        public function get length() : int
        {
            return _list.length / 2;
        }// end function

        public function set length(param1:int) : void
        {
            _list.length = param1 * 2;
            return;
        }// end function

        public function join(param1:String) : String
        {
            return _list.join(param1);
        }// end function

        public function clone() : PointList
        {
            var _loc_1:* = new PointList();
            _loc_1.rawList = this.rawList.concat();
            return _loc_1;
        }// end function

    }
}
