package fairygui.tween
{

    public class TweenValue extends Object
    {
        public var x:Number;
        public var y:Number;
        public var z:Number;
        public var w:Number;

        public function TweenValue()
        {
            w = 0;
            z = 0;
            y = 0;
            x = 0;
            return;
        }// end function

        public function get color() : uint
        {
            return (w << 24) + (x << 16) + (y << 8) + z;
        }// end function

        public function set color(param1:uint) : void
        {
            x = (param1 & 16711680) >> 16;
            y = (param1 & 65280) >> 8;
            z = param1 & 255;
            w = (param1 & 4278190080) >> 24;
            return;
        }// end function

        public function getField(param1:int) : Number
        {
            switch(param1) branch count is:<3>[17, 21, 25, 29] default offset is:<33>;
            return x;
            return y;
            return z;
            return w;
            throw new Error("Index out of bounds: " + param1);
        }// end function

        public function setField(param1:int, param2:Number) : void
        {
            switch(param1) branch count is:<3>[17, 29, 41, 53] default offset is:<65>;
            x = param2;
            ;
            y = param2;
            ;
            z = param2;
            ;
            w = param2;
            ;
            throw new Error("Index out of bounds: " + param1);
            return;
        }// end function

        public function setZero() : void
        {
            w = 0;
            z = 0;
            y = 0;
            x = 0;
            return;
        }// end function

    }
}
