package fairygui.utils
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class PixelHitTestData extends Object
    {
        public var pixelWidth:int;
        public var scale:Number;
        public var pixels:Vector.<int>;

        public function PixelHitTestData()
        {
            return;
        }// end function

        public function load(param1:ByteArray) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            param1.readInt();
            pixelWidth = param1.readInt();
            scale = param1.readByte();
            var _loc_2:* = param1.readInt();
            pixels = new Vector.<int>(_loc_2);
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = param1.readByte();
                if (_loc_4 < 0)
                {
                    _loc_4 = _loc_4 + 256;
                }
                pixels[_loc_3] = _loc_4;
                _loc_3++;
            }
            return;
        }// end function

    }
}
