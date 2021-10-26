package fairygui.utils
{
    import *.*;
    import __AS3__.vec.*;
    import flash.display.*;

    public class PixelHitTest extends Object
    {
        private var _data:PixelHitTestData;
        public var offsetX:int;
        public var offsetY:int;
        private var _shape:Shape;

        public function PixelHitTest(param1:PixelHitTestData, param2:int = 0, param3:int = 0)
        {
            _data = param1;
            this.offsetX = param2;
            this.offsetY = param3;
            return;
        }// end function

        public function createHitAreaSprite() : Sprite
        {
            var _loc_3:* = null;
            var _loc_1:* = undefined;
            var _loc_5:* = 0;
            var _loc_4:* = 0;
            var _loc_7:* = 0;
            var _loc_9:* = 0;
            var _loc_8:* = 0;
            var _loc_2:* = 0;
            if (_shape == null)
            {
                _shape = new Shape();
                _loc_3 = _shape.graphics;
                _loc_3.beginFill(0, 0);
                _loc_3.lineStyle(0, 0, 0);
                _loc_1 = _data.pixels;
                _loc_5 = _loc_1.length;
                _loc_4 = _data.pixelWidth;
                _loc_7 = 0;
                while (_loc_7 < _loc_5)
                {
                    
                    _loc_9 = _loc_1[_loc_7];
                    _loc_8 = 0;
                    while (_loc_8 < 8)
                    {
                        
                        if ((_loc_9 >> _loc_8 & 1) == 1)
                        {
                            _loc_2 = _loc_7 * 8 + _loc_8;
                            _loc_3.drawRect(_loc_2 % _loc_4, _loc_2 / _loc_4, 1, 1);
                        }
                        _loc_8++;
                    }
                    _loc_7++;
                }
                _loc_3.endFill();
            }
            var _loc_6:* = new Sprite();
            _loc_6.mouseEnabled = false;
            _loc_6.x = offsetX;
            _loc_6.y = offsetY;
            _loc_6.graphics.copyFrom(_shape.graphics);
            var _loc_10:* = _data.scale;
            _loc_6.scaleY = _data.scale;
            _loc_6.scaleX = _loc_10;
            return _loc_6;
        }// end function

    }
}
