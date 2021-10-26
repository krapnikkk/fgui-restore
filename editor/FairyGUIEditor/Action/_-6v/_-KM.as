package _-6v
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import flash.display.*;
    import flash.geom.*;

    public class _-KM extends GGraph
    {
        private var _container:Sprite;
        private var _-8w:Vector.<Bitmap>;
        private static var image:BitmapData;
        private static const _-IQ:int = 6;
        private static const _-87:int = 10;
        private static const _-2M:int = 19;
        private static const _-AP:int = 1200;

        public function _-KM()
        {
            this._container = new Sprite();
            this._container.mouseEnabled = false;
            this._container.mouseChildren = false;
            this._-8w = new Vector.<Bitmap>;
            setNativeObject(this._container);
            if (!image)
            {
                _-Cd();
            }
            return;
        }// end function

        public function update(param1:int) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            this.width = param1 * _-87;
            var _loc_2:* = Math.ceil(this.width / _-AP);
            if (_loc_2 > this._-8w.length)
            {
                this._-8w.length = _loc_2;
            }
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._-8w[_loc_3];
                if (!_loc_4)
                {
                    _loc_4 = new Bitmap(image);
                    _loc_4.x = _loc_3 * _loc_4.width;
                    this._-8w[_loc_3] = _loc_4;
                }
                if (!_loc_4.parent)
                {
                    this._container.addChild(_loc_4);
                }
                _loc_3++;
            }
            while (_loc_3 < this._-8w.length)
            {
                
                _loc_4 = this._-8w[_loc_3];
                if (_loc_4.parent)
                {
                    this._container.removeChild(_loc_4);
                }
                _loc_3++;
            }
            return;
        }// end function

        private static function _-Cd() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = new Matrix();
            var _loc_3:* = new BitmapData((_-87 + 1), _-2M, false, 4802889);
            _loc_1 = 0;
            while (_loc_1 < _loc_3.height)
            {
                
                _loc_3.setPixel(0, _loc_1, 5592405);
                _loc_3.setPixel(_-87, _loc_1, 5592405);
                _loc_1++;
            }
            var _loc_4:* = new BitmapData((_-87 + 1), _-2M, false, 4539717);
            _loc_1 = 0;
            while (_loc_1 < _loc_4.height)
            {
                
                _loc_4.setPixel(0, _loc_1, 5592405);
                _loc_4.setPixel(_-87, _loc_1, 5592405);
                _loc_1++;
            }
            image = new BitmapData(_-AP, _-2M, true, 0);
            var _loc_5:* = _-AP / _-87;
            _loc_1 = 0;
            while (_loc_1 < _loc_5)
            {
                
                _loc_2.identity();
                _loc_2.translate(_loc_1 * _-87 - 1, 0);
                if (_loc_1 % _-IQ == 0)
                {
                    image.draw(_loc_4, _loc_2);
                }
                else
                {
                    image.draw(_loc_3, _loc_2);
                }
                _loc_1++;
            }
            _loc_3.dispose();
            _loc_4.dispose();
            return;
        }// end function

    }
}
