package fairygui.tween
{
    import *.*;

    public class EaseManager extends Object
    {
        private static const _PiOver2:Number = 1.5708;
        private static const _TwoPi:Number = 6.28319;

        public function EaseManager()
        {
            return;
        }// end function

        public static function evaluate(param1:int, param2:Number, param3:Number, param4:Number, param5:Number) : Number
        {
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_6:* = NaN;
            var _loc_9:* = param1;
            while (_loc_9 === 0)
            {
                
                return param2 / param3;
                
                return -Math.cos(param2 / param3 * 1.5708) + 1;
                
                return Math.sin(param2 / param3 * 1.5708);
                
                return -0.5 * (Math.cos(3.14159 * param2 / param3) - 1);
                
                param2 = param2 / param3;
                return param2 / param3 * param2;
                
                param2 = param2 / param3;
                return (-param2 / param3) * (param2 - 2);
                
                param2 = param2 / (param3 * 0.5);
                if (param2 / (param3 * 0.5) < 1)
                {
                    return 0.5 * param2 * param2;
                }
                param2--;
                return -0.5 * (param2 * (param2 - 2) - 1);
                
                param2 = param2 / param3;
                return param2 / param3 * param2 * param2;
                
                param2 = param2 / param3 - 1;
                return (param2 / param3 - 1) * param2 * param2 + 1;
                
                param2 = param2 / (param3 * 0.5);
                if (param2 / (param3 * 0.5) < 1)
                {
                    return 0.5 * param2 * param2 * param2;
                }
                param2 = param2 - 2;
                return 0.5 * ((param2 - 2) * param2 * param2 + 2);
                
                param2 = param2 / param3;
                return param2 / param3 * param2 * param2 * param2;
                
                param2 = param2 / param3 - 1;
                return -((param2 / param3 - 1) * param2 * param2 * param2 - 1);
                
                param2 = param2 / (param3 * 0.5);
                if (param2 / (param3 * 0.5) < 1)
                {
                    return 0.5 * param2 * param2 * param2 * param2;
                }
                param2 = param2 - 2;
                return -0.5 * ((param2 - 2) * param2 * param2 * param2 - 2);
                
                param2 = param2 / param3;
                return param2 / param3 * param2 * param2 * param2 * param2;
                
                param2 = param2 / param3 - 1;
                return (param2 / param3 - 1) * param2 * param2 * param2 * param2 + 1;
                
                param2 = param2 / (param3 * 0.5);
                if (param2 / (param3 * 0.5) < 1)
                {
                    return 0.5 * param2 * param2 * param2 * param2 * param2;
                }
                param2 = param2 - 2;
                return 0.5 * ((param2 - 2) * param2 * param2 * param2 * param2 + 2);
                
                return param2 == 0 ? (0) : (Math.pow(2, 10 * (param2 / param3 - 1)));
                
                if (param2 == param3)
                {
                    return 1;
                }
                return -Math.pow(2, -10 * param2 / param3) + 1;
                
                if (param2 == 0)
                {
                    return 0;
                }
                if (param2 == param3)
                {
                    return 1;
                }
                param2 = param2 / (param3 * 0.5);
                if (param2 / (param3 * 0.5) < 1)
                {
                    return 0.5 * Math.pow(2, 10 * (param2 - 1));
                }
                param2--;
                return 0.5 * (-Math.pow(2, -10 * param2) + 2);
                
                param2 = param2 / param3;
                return -(Math.sqrt(1 - param2 / param3 * param2) - 1);
                
                param2 = param2 / param3 - 1;
                return Math.sqrt(1 - (param2 / param3 - 1) * param2);
                
                param2 = param2 / (param3 * 0.5);
                if (param2 / (param3 * 0.5) < 1)
                {
                    return -0.5 * (Math.sqrt(1 - param2 * param2) - 1);
                }
                param2 = param2 - 2;
                return 0.5 * (Math.sqrt(1 - (param2 - 2) * param2) + 1);
                
                if (param2 == 0)
                {
                    return 0;
                }
                param2 = param2 / param3;
                if (param2 / param3 == 1)
                {
                    return 1;
                }
                if (param5 == 0)
                {
                    param5 = param3 * 0.3;
                }
                if (param4 < 1)
                {
                    param4 = 1;
                    _loc_7 = param5 / 4;
                }
                else
                {
                    _loc_7 = param5 / 6.28319 * Math.asin(1 / param4);
                }
                param2 = (param2 - 1);
                return -param4 * Math.pow(2, 10 * param2) * Math.sin((param2 * param3 - _loc_7) * 6.28319 / param5);
                
                if (_loc_2 == 0)
                {
                    return 0;
                }
                _loc_2 = _loc_2 / param3;
                if (_loc_2 / param3 == 1)
                {
                    return 1;
                }
                if (param5 == 0)
                {
                    param5 = param3 * 0.3;
                }
                if (param4 < 1)
                {
                    param4 = 1;
                    _loc_8 = param5 / 4;
                }
                else
                {
                    _loc_8 = param5 / 6.28319 * Math.asin(1 / param4);
                }
                return param4 * Math.pow(2, -10 * _loc_2) * Math.sin((_loc_2 * param3 - _loc_8) * 6.28319 / param5) + 1;
                
                if (_loc_2 == 0)
                {
                    return 0;
                }
                _loc_2 = _loc_2 / (param3 * 0.5);
                if (_loc_2 / (param3 * 0.5) == 2)
                {
                    return 1;
                }
                if (param5 == 0)
                {
                    param5 = param3 * 0.45;
                }
                if (param4 < 1)
                {
                    param4 = 1;
                    _loc_6 = param5 / 4;
                }
                else
                {
                    _loc_6 = param5 / 6.28319 * Math.asin(1 / param4);
                }
                if (_loc_2 < 1)
                {
                    return -0.5 * (param4 * Math.pow(2, 10 * --_loc_2) * Math.sin((--_loc_2 * param3 - _loc_6) * 6.28319 / param5));
                }
                return param4 * Math.pow(2, -10 * --_loc_2) * Math.sin((--_loc_2 * param3 - _loc_6) * 6.28319 / param5) * 0.5 + 1;
                
                _loc_2 = _loc_2 / param3;
                return _loc_2 / param3 * _loc_2 * ((param4 + 1) * _loc_2 - param4);
                
                _loc_2 = _loc_2 / param3 - 1;
                return (_loc_2 / param3 - 1) * _loc_2 * ((param4 + 1) * _loc_2 + param4) + 1;
                
                _loc_2 = _loc_2 / (param3 * 0.5);
                if (_loc_2 / (param3 * 0.5) < 1)
                {
                    param4 = param4 * 1.525;
                    return 0.5 * (_loc_2 * _loc_2 * ((param4 * 1.525 + 1) * _loc_2 - param4));
                }
                _loc_2 = _loc_2 - 2;
                param4 = param4 * 1.525;
                return 0.5 * ((_loc_2 - 2) * _loc_2 * ((param4 * 1.525 + 1) * _loc_2 + param4) + 2);
                
                return Bounce.easeIn(_loc_2, param3);
                
                return Bounce.easeOut(_loc_2, param3);
                
                return Bounce.easeInOut(_loc_2, param3);
                
                _loc_2 = _loc_2 / param3;
                return (-_loc_2 / param3) * (_loc_2 - 2);
            }
            if (1 === _loc_9) goto 23;
            if (2 === _loc_9) goto 43;
            if (3 === _loc_9) goto 59;
            if (4 === _loc_9) goto 79;
            if (5 === _loc_9) goto 89;
            if (6 === _loc_9) goto 103;
            if (7 === _loc_9) goto 142;
            if (8 === _loc_9) goto 154;
            if (9 === _loc_9) goto 170;
            if (10 === _loc_9) goto 216;
            if (11 === _loc_9) goto 230;
            if (12 === _loc_9) goto 247;
            if (13 === _loc_9) goto 297;
            if (14 === _loc_9) goto 313;
            if (15 === _loc_9) goto 333;
            if (16 === _loc_9) goto 387;
            if (17 === _loc_9) goto 419;
            if (18 === _loc_9) goto 449;
            if (19 === _loc_9) goto 528;
            if (20 === _loc_9) goto 550;
            if (21 === _loc_9) goto 571;
            if (22 === _loc_9) goto 634;
            if (23 === _loc_9) goto 764;
            if (24 === _loc_9) goto 892;
            if (25 === _loc_9) goto 1084;
            if (26 === _loc_9) goto 1105;
            if (27 === _loc_9) goto 1130;
            if (28 === _loc_9) goto 1210;
            if (29 === _loc_9) goto 1221;
            if (30 === _loc_9) goto 1232;
            ;
        }// end function

    }
}
