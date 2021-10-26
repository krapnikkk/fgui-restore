package fairygui.utils
{
    import *.*;
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class Utils extends Object
    {
        public static const RAD_TO_DEG:Number = 57.2958;
        public static const DEG_TO_RAD:Number = 0.0174533;
        private static var sHelperByteArray:ByteArray = new ByteArray();
        private static var tileIndice:Array = [-1, 0, -1, 2, 4, 3, -1, 1, -1];
        private static var helperNumberArray:Vector.<Number> = new Vector.<Number>(4);

        public function Utils()
        {
            return;
        }// end function

        public static function equalText(param1, param2) : Boolean
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (param1 is Array || param2 is Array)
            {
                return false;
            }
            if (param1 != null)
            {
                _loc_3 = param1.toString();
            }
            else
            {
                _loc_3 = "";
            }
            if (param2 != null)
            {
                _loc_4 = param2.toString();
            }
            else
            {
                _loc_4 = "";
            }
            return _loc_3 == _loc_4;
        }// end function

        public static function drawDashedRect(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:int) : void
        {
            drawDashedLine(param1, param2 + 0.5, param3 + 0.5, param2 + param4 - 0.5, param3 + 0.5, param6);
            drawDashedLine(param1, param2 + param4 - 0.5, param3 + 0.5, param2 + param4 - 0.5, param3 + param5 - 0.5, param6);
            drawDashedLine(param1, param2 + 0.5, param3 + 0.5, param2 + 0.5, param3 + param5 - 0.5, param6);
            drawDashedLine(param1, param2 + 0.5, param3 + param5 - 0.5, param2 + param4 - 0.5, param3 + param5 - 0.5, param6);
            return;
        }// end function

        public static function drawDashedLine(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:int) : void
        {
            var _loc_14:* = NaN;
            var _loc_15:* = NaN;
            var _loc_16:* = NaN;
            var _loc_17:* = NaN;
            var _loc_7:* = param4 - param2;
            var _loc_8:* = param5 - param3;
            var _loc_9:* = Math.sqrt(_loc_7 * _loc_7 + _loc_8 * _loc_8);
            var _loc_10:* = Math.round((_loc_9 / param6 + 1) / 2);
            var _loc_11:* = _loc_7 / (2 * _loc_10 - 1);
            var _loc_12:* = _loc_8 / (2 * _loc_10 - 1);
            var _loc_13:* = 0;
            while (_loc_13 < _loc_10)
            {
                
                _loc_14 = param2 + 2 * _loc_13 * _loc_11;
                _loc_15 = param3 + 2 * _loc_13 * _loc_12;
                _loc_16 = _loc_14 + _loc_11;
                _loc_17 = _loc_15 + _loc_12;
                param1.moveTo(_loc_14, _loc_15);
                param1.lineTo(_loc_16, _loc_17);
                _loc_13 = _loc_13 + 1;
            }
            return;
        }// end function

        public static function getStringSortKey(param1:String) : String
        {
            var _loc_5:* = 0;
            param1 = param1.toLowerCase();
            sHelperByteArray.length = 0;
            sHelperByteArray.writeMultiByte(param1, "gb2312");
            var _loc_2:* = sHelperByteArray.length;
            sHelperByteArray.position = 0;
            var _loc_3:* = "";
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_5 = sHelperByteArray[_loc_4];
                _loc_3 = _loc_3 + String.fromCharCode(_loc_5);
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public static function scaleBitmapWith9Grid(param1:BitmapData, param2:Rectangle, param3:int, param4:int, param5:Boolean = false, param6:int = 0) : BitmapData
        {
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_16:* = NaN;
            var _loc_17:* = 0;
            var _loc_18:* = 0;
            var _loc_19:* = null;
            if (param3 == 0 || param4 == 0)
            {
                return new BitmapData(1, 1, param1.transparent, 0);
            }
            var _loc_7:* = new BitmapData(param3, param4, param1.transparent, 0);
            var _loc_8:* = [0, param2.top, param2.bottom, param1.height];
            var _loc_9:* = [0, param2.left, param2.right, param1.width];
            if (param4 >= param1.height - param2.height)
            {
                _loc_10 = [0, param2.top, param4 - (param1.height - param2.bottom), param4];
            }
            else
            {
                _loc_16 = param2.top / (param1.height - param2.bottom);
                _loc_16 = param4 * _loc_16 / (1 + _loc_16);
                _loc_10 = [0, _loc_16, _loc_16, param4];
            }
            if (param3 >= param1.width - param2.width)
            {
                _loc_11 = [0, param2.left, param3 - (param1.width - param2.right), param3];
            }
            else
            {
                _loc_16 = param2.left / (param1.width - param2.right);
                _loc_16 = param3 * _loc_16 / (1 + _loc_16);
                _loc_11 = [0, _loc_16, _loc_16, param3];
            }
            var _loc_14:* = new Matrix();
            var _loc_15:* = 0;
            while (_loc_15 < 3)
            {
                
                _loc_17 = 0;
                while (_loc_17 < 3)
                {
                    
                    _loc_12 = new Rectangle(_loc_9[_loc_15], _loc_8[_loc_17], _loc_9[(_loc_15 + 1)] - _loc_9[_loc_15], _loc_8[(_loc_17 + 1)] - _loc_8[_loc_17]);
                    _loc_13 = new Rectangle(_loc_11[_loc_15], _loc_10[_loc_17], _loc_11[(_loc_15 + 1)] - _loc_11[_loc_15], _loc_10[(_loc_17 + 1)] - _loc_10[_loc_17]);
                    _loc_18 = tileIndice[_loc_17 * 3 + _loc_15];
                    if (_loc_18 != -1 && (param6 & 1 << _loc_18) != 0)
                    {
                        _loc_19 = Utils.tileBitmap(param1, _loc_12, _loc_13.width, _loc_13.height, param5);
                        _loc_7.copyPixels(_loc_19, _loc_19.rect, _loc_13.topLeft);
                        _loc_19.dispose();
                    }
                    else
                    {
                        _loc_14.identity();
                        _loc_14.a = _loc_13.width / _loc_12.width;
                        _loc_14.d = _loc_13.height / _loc_12.height;
                        _loc_14.tx = _loc_13.x - _loc_12.x * _loc_14.a;
                        _loc_14.ty = _loc_13.y - _loc_12.y * _loc_14.d;
                        _loc_7.draw(param1, _loc_14, null, null, _loc_13, param5);
                    }
                    _loc_17++;
                }
                _loc_15++;
            }
            return _loc_7;
        }// end function

        public static function tileBitmap(param1:BitmapData, param2:Rectangle, param3:int, param4:int, param5:Boolean = false) : BitmapData
        {
            var _loc_11:* = 0;
            if (param3 == 0 || param4 == 0)
            {
                return new BitmapData(1, 1, param1.transparent, 0);
            }
            var _loc_6:* = new BitmapData(param3, param4, param1.transparent, 0);
            var _loc_7:* = Math.ceil(param3 / param2.width);
            var _loc_8:* = Math.ceil(param4 / param2.height);
            var _loc_9:* = new Point();
            var _loc_10:* = 0;
            while (_loc_10 < _loc_7)
            {
                
                _loc_11 = 0;
                while (_loc_11 < _loc_8)
                {
                    
                    _loc_9.x = _loc_10 * param2.width;
                    _loc_9.y = _loc_11 * param2.height;
                    _loc_6.copyPixels(param1, param2, _loc_9);
                    _loc_11++;
                }
                _loc_10++;
            }
            return _loc_6;
        }// end function

        public static function skew(param1:Matrix, param2:Number, param3:Number) : void
        {
            param2 = param2 * DEG_TO_RAD;
            param3 = param3 * DEG_TO_RAD;
            var _loc_4:* = Math.sin(param2);
            var _loc_5:* = Math.cos(param2);
            var _loc_6:* = Math.sin(param3);
            var _loc_7:* = Math.cos(param3);
            param1.setTo(param1.a * _loc_7 - param1.b * _loc_4, param1.a * _loc_6 + param1.b * _loc_5, param1.c * _loc_7 - param1.d * _loc_4, param1.c * _loc_6 + param1.d * _loc_5, param1.tx * _loc_7 - param1.ty * _loc_4, param1.tx * _loc_6 + param1.ty * _loc_5);
            return;
        }// end function

        public static function prependSkew(param1:Matrix, param2:Number, param3:Number) : void
        {
            param2 = param2 * DEG_TO_RAD;
            param3 = param3 * DEG_TO_RAD;
            var _loc_4:* = Math.sin(param2);
            var _loc_5:* = Math.cos(param2);
            var _loc_6:* = Math.sin(param3);
            var _loc_7:* = Math.cos(param3);
            param1.setTo(param1.a * _loc_7 + param1.c * _loc_6, param1.b * _loc_7 + param1.d * _loc_6, param1.c * _loc_5 - param1.a * _loc_4, param1.d * _loc_5 - param1.b * _loc_4, param1.tx, param1.ty);
            return;
        }// end function

        public static function genDevCode() : String
        {
            var _loc_3:* = 0;
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            while (_loc_2 < 4)
            {
                
                _loc_3 = Math.random() * 26;
                _loc_1 = _loc_1 + Math.pow(26, _loc_2) * (_loc_3 + 10);
                _loc_2++;
            }
            _loc_1 = _loc_1 + (int(Math.random() * 1000000) + int(Math.random() * 222640));
            return _loc_1.toString(36);
        }// end function

        public static function getBoundsRect(param1:Vector.<Point>, param2:Rectangle) : Rectangle
        {
            if (!param2)
            {
                param2 = new Rectangle();
            }
            var _loc_4:* = int.MAX_VALUE;
            helperNumberArray[2] = int.MAX_VALUE;
            helperNumberArray[0] = _loc_4;
            var _loc_4:* = int.MIN_VALUE;
            helperNumberArray[3] = int.MIN_VALUE;
            helperNumberArray[1] = _loc_4;
            var _loc_3:* = 0;
            while (_loc_3 < param1.length)
            {
                
                _getBoundsRect(param1[_loc_3]);
                _loc_3++;
            }
            param2.setTo(helperNumberArray[0], helperNumberArray[2], helperNumberArray[1] - helperNumberArray[0], helperNumberArray[3] - helperNumberArray[2]);
            return param2;
        }// end function

        private static function _getBoundsRect(param1:Point) : void
        {
            if (param1.x < helperNumberArray[0])
            {
                helperNumberArray[0] = param1.x;
            }
            if (param1.x > helperNumberArray[1])
            {
                helperNumberArray[1] = param1.x;
            }
            if (param1.y < helperNumberArray[2])
            {
                helperNumberArray[2] = param1.y;
            }
            if (param1.y > helperNumberArray[3])
            {
                helperNumberArray[3] = param1.y;
            }
            return;
        }// end function

        public static function clamp(param1:Number, param2:Number, param3:Number) : Number
        {
            if (param1 < param2)
            {
                param1 = param2;
            }
            else if (param1 > param3)
            {
                param1 = param3;
            }
            return param1;
        }// end function

        public static function clamp01(param1:Number) : Number
        {
            if (param1 > 1)
            {
                param1 = 1;
            }
            else if (param1 < 0)
            {
                param1 = 0;
            }
            return param1;
        }// end function

        public static function getNextPowerOfTwo(param1:Number) : int
        {
            var _loc_2:* = 0;
            if (param1 is int && param1 > 0 && (param1 & (param1 - 1)) == 0)
            {
                return param1;
            }
            _loc_2 = 1;
            param1 = param1 - 1e-009;
            while (_loc_2 < param1)
            {
                
                _loc_2 = _loc_2 << 1;
            }
            return _loc_2;
        }// end function

        public static function transformColor(param1:uint, param2:Number, param3:Number, param4:Number) : uint
        {
            return (int(((param1 & 16711680) >> 16) * param2) << 16) + (int(((param1 & 65280) >> 8) * param3) << 8) + int((param1 & 255) * param4);
        }// end function

    }
}
