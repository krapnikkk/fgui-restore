package _-6v
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;

    public class _-1C extends GGraph
    {
        private var _container:Sprite;
        private var _-8w:Vector.<Bitmap>;
        private var _-OE:Vector.<TextField>;
        private static var image:BitmapData;
        private static const _-IQ:int = 6;
        private static const _-87:int = 10;
        private static const _-2M:int = 18;
        private static const _-AP:int = 1200;
        private static const textFormat:TextFormat = new TextFormat("Tahoma,Arial", 10, 12105912, null, null, null, null, null, "center");

        public function _-1C()
        {
            this._container = new Sprite();
            this._container.mouseEnabled = false;
            this._container.mouseChildren = false;
            this._-8w = new Vector.<Bitmap>;
            this._-OE = new Vector.<TextField>;
            setNativeObject(this._container);
            if (!image)
            {
                _-Cd();
            }
            return;
        }// end function

        public function update(param1:int, param2:int = 24) : void
        {
            var _loc_4:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = 0;
            this.width = param1 * _-87;
            var _loc_3:* = Math.ceil(this.width / _-AP);
            if (_loc_3 > this._-8w.length)
            {
                this._-8w.length = _loc_3;
            }
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_6 = this._-8w[_loc_4];
                if (!_loc_6)
                {
                    _loc_6 = new Bitmap(image);
                    _loc_6.x = _loc_4 * _loc_6.width;
                    _loc_6.y = 2;
                    this._-8w[_loc_4] = _loc_6;
                }
                if (!_loc_6.parent)
                {
                    this._container.addChild(_loc_6);
                }
                _loc_4++;
            }
            while (_loc_4 < this._-8w.length)
            {
                
                _loc_6 = this._-8w[_loc_4];
                if (_loc_6.parent)
                {
                    this._container.removeChild(_loc_6);
                }
                _loc_4++;
            }
            _loc_3 = Math.ceil(param1 / _-IQ) + 1;
            if (_loc_3 > this._-OE.length)
            {
                this._-OE.length = _loc_3;
            }
            var _loc_5:* = 100 / (param2 / _-IQ);
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_7 = this._-OE[_loc_4];
                if (!_loc_7)
                {
                    _loc_7 = new TextField();
                    _loc_7.defaultTextFormat = textFormat;
                    _loc_7.width = 40;
                    this._-OE[_loc_4] = _loc_7;
                }
                _loc_7.x = _loc_4 * _-IQ * _-87 + 5 - _loc_7.width / 2;
                _loc_8 = _loc_4 * _loc_5;
                if (_loc_8 % 100 == 0)
                {
                    _loc_7.text = "" + int(_loc_8 / 100);
                }
                else
                {
                    _loc_7.text = "" + int(_loc_8 / 100) + "." + _loc_8 % 100;
                }
                if (!_loc_7.parent)
                {
                    this._container.addChild(_loc_7);
                }
                _loc_4++;
            }
            while (_loc_4 < this._-OE.length)
            {
                
                _loc_7 = this._-OE[_loc_4];
                if (_loc_7.parent)
                {
                    this._container.removeChild(_loc_7);
                }
                _loc_4++;
            }
            return;
        }// end function

        private static function _-Cd() : void
        {
            var _loc_1:* = new BitmapData(1, 3, false, 0);
            _loc_1.setPixel(0, 0, 8421248);
            _loc_1.setPixel(0, 1, 8421248);
            _loc_1.setPixel(0, 2, 8421248);
            image = new BitmapData(_-AP, _-2M, true, 0);
            var _loc_2:* = Math.ceil(_-AP / _-87);
            var _loc_3:* = new Matrix();
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3.identity();
                _loc_3.translate(_loc_4 * _-87 - 1, _-2M - 3);
                image.draw(_loc_1, _loc_3);
                _loc_4++;
            }
            _loc_1.dispose();
            return;
        }// end function

    }
}
