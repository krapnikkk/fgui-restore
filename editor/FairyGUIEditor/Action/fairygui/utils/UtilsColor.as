package fairygui.utils
{

    public class UtilsColor extends Object
    {

        public function UtilsColor()
        {
            return;
        }// end function

        public static function RGBtoHSB(param1:int, param2:int, param3:int) : Object
        {
            var _loc_4:* = new Object();
            var _loc_5:* = Math.max(param1, param2, param3);
            var _loc_6:* = Math.min(param1, param2, param3);
            _loc_4.s = _loc_5 != 0 ? ((_loc_5 - _loc_6) / _loc_5 * 100) : (0);
            _loc_4.b = _loc_5 / 255 * 100;
            if (_loc_4.s == 0)
            {
                _loc_4.h = 0;
            }
            else
            {
                switch(_loc_5)
                {
                    case param1:
                    {
                        _loc_4.h = (param2 - param3) / (_loc_5 - _loc_6) * 60 + 0;
                        break;
                    }
                    case param2:
                    {
                        _loc_4.h = (param3 - param1) / (_loc_5 - _loc_6) * 60 + 120;
                        break;
                    }
                    case param3:
                    {
                        _loc_4.h = (param1 - param2) / (_loc_5 - _loc_6) * 60 + 240;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            _loc_4.h = Math.min(360, Math.max(0, _loc_4.h));
            _loc_4.s = Math.min(100, Math.max(0, _loc_4.s));
            _loc_4.b = Math.min(100, Math.max(0, _loc_4.b));
            return _loc_4;
        }// end function

        public static function HSBtoRGB(param1:int, param2:int, param3:int) : Object
        {
            var _loc_7:* = NaN;
            var _loc_4:* = new Object();
            var _loc_5:* = param3 * 0.01 * 255;
            var _loc_6:* = param3 * 0.01 * 255 * (1 - param2 * 0.01);
            if (param1 == 360)
            {
                param1 = 0;
            }
            if (param2 == 0)
            {
                var _loc_8:* = param3 * (255 * 0.01);
                _loc_4.b = param3 * (255 * 0.01);
                _loc_4.g = _loc_8;
                _loc_4.r = _loc_8;
            }
            else
            {
                _loc_7 = Math.floor(param1 / 60);
                switch(_loc_7)
                {
                    case 0:
                    {
                        _loc_4.r = _loc_5;
                        _loc_4.g = _loc_6 + param1 * (_loc_5 - _loc_6) / 60;
                        _loc_4.b = _loc_6;
                        break;
                    }
                    case 1:
                    {
                        _loc_4.r = _loc_5 - (param1 - 60) * (_loc_5 - _loc_6) / 60;
                        _loc_4.g = _loc_5;
                        _loc_4.b = _loc_6;
                        break;
                    }
                    case 2:
                    {
                        _loc_4.r = _loc_6;
                        _loc_4.g = _loc_5;
                        _loc_4.b = _loc_6 + (param1 - 120) * (_loc_5 - _loc_6) / 60;
                        break;
                    }
                    case 3:
                    {
                        _loc_4.r = _loc_6;
                        _loc_4.g = _loc_5 - (param1 - 180) * (_loc_5 - _loc_6) / 60;
                        _loc_4.b = _loc_5;
                        break;
                    }
                    case 4:
                    {
                        _loc_4.r = _loc_6 + (param1 - 240) * (_loc_5 - _loc_6) / 60;
                        _loc_4.g = _loc_6;
                        _loc_4.b = _loc_5;
                        break;
                    }
                    case 5:
                    {
                        _loc_4.r = _loc_5;
                        _loc_4.g = _loc_6;
                        _loc_4.b = _loc_5 - (param1 - 300) * (_loc_5 - _loc_6) / 60;
                        break;
                    }
                    case 6:
                    {
                        _loc_4.r = _loc_5;
                        _loc_4.g = _loc_6 + param1 * (_loc_5 - _loc_6) / 60;
                        _loc_4.b = _loc_6;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_4.r = Math.min(255, Math.max(0, _loc_4.r));
                _loc_4.g = Math.min(255, Math.max(0, _loc_4.g));
                _loc_4.b = Math.min(255, Math.max(0, _loc_4.b));
            }
            return _loc_4;
        }// end function

    }
}
