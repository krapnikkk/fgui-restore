package fairygui.tween
{
    import *.*;

    public class EaseType extends Object
    {
        public static const Linear:int = 0;
        public static const SineIn:int = 1;
        public static const SineOut:int = 2;
        public static const SineInOut:int = 3;
        public static const QuadIn:int = 4;
        public static const QuadOut:int = 5;
        public static const QuadInOut:int = 6;
        public static const CubicIn:int = 7;
        public static const CubicOut:int = 8;
        public static const CubicInOut:int = 9;
        public static const QuartIn:int = 10;
        public static const QuartOut:int = 11;
        public static const QuartInOut:int = 12;
        public static const QuintIn:int = 13;
        public static const QuintOut:int = 14;
        public static const QuintInOut:int = 15;
        public static const ExpoIn:int = 16;
        public static const ExpoOut:int = 17;
        public static const ExpoInOut:int = 18;
        public static const CircIn:int = 19;
        public static const CircOut:int = 20;
        public static const CircInOut:int = 21;
        public static const ElasticIn:int = 22;
        public static const ElasticOut:int = 23;
        public static const ElasticInOut:int = 24;
        public static const BackIn:int = 25;
        public static const BackOut:int = 26;
        public static const BackInOut:int = 27;
        public static const BounceIn:int = 28;
        public static const BounceOut:int = 29;
        public static const BounceInOut:int = 30;
        public static const Custom:int = 31;
        private static const easeTypeMap:Object = {Linear:0, Elastic.In:22, Elastic.Out:24, Elastic.InOut:24, Quad.In:4, Quad.Out:5, Quad.InOut:6, Cube.In:7, Cube.Out:8, Cube.InOut:9, Quart.In:10, Quart.Out:11, Quart.InOut:12, Quint.In:13, Quint.Out:14, Quint.InOut:15, Sine.In:1, Sine.Out:2, Sine.InOut:3, Bounce.In:28, Bounce.Out:29, Bounce.InOut:30, Circ.In:19, Circ.Out:20, Circ.InOut:21, Expo.In:16, Expo.Out:17, Expo.InOut:18, Back.In:25, Back.Out:26, Back.InOut:27};

        public function EaseType()
        {
            return;
        }// end function

        public static function parseEaseType(param1:String) : int
        {
            var _loc_2:* = easeTypeMap[param1];
            if (_loc_2 == undefined)
            {
                return 5;
            }
            return _loc_2;
        }// end function

    }
}
