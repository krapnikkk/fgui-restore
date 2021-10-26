package fairygui.editor.gui
{

    public class FMargin extends Object
    {
        public var left:int;
        public var right:int;
        public var top:int;
        public var bottom:int;

        public function FMargin()
        {
            return;
        }// end function

        public function parse(param1:String) : void
        {
            var _loc_3:* = 0;
            var _loc_2:* = param1.split(",");
            if (_loc_2.length == 1)
            {
                _loc_3 = int(_loc_2[0]);
                this.top = _loc_3;
                this.bottom = _loc_3;
                this.left = _loc_3;
                this.right = _loc_3;
            }
            else
            {
                this.top = int(_loc_2[0]);
                this.bottom = int(_loc_2[1]);
                this.left = int(_loc_2[2]);
                this.right = int(_loc_2[3]);
            }
            return;
        }// end function

        public function get empty() : Boolean
        {
            return this.left == 0 && this.right == 0 && this.top == 0 && this.bottom == 0;
        }// end function

        public function reset() : void
        {
            var _loc_1:* = 0;
            this.bottom = 0;
            this.top = _loc_1;
            this.right = _loc_1;
            this.left = _loc_1;
            return;
        }// end function

        public function copy(param1:FMargin) : void
        {
            this.left = param1.left;
            this.right = param1.right;
            this.top = param1.top;
            this.bottom = param1.bottom;
            return;
        }// end function

        public function toString() : String
        {
            return this.top + "," + this.bottom + "," + this.left + "," + this.right;
        }// end function

    }
}
