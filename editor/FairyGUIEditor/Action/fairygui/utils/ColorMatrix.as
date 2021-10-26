package fairygui.utils
{
    import *.*;

    dynamic public class ColorMatrix extends Array
    {
        private static const IDENTITY_MATRIX:Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
        private static const LENGTH:Number = IDENTITY_MATRIX.length;
        private static const LUMA_R:Number = 0.299;
        private static const LUMA_G:Number = 0.587;
        private static const LUMA_B:Number = 0.114;

        public function ColorMatrix()
        {
            reset();
            return;
        }// end function

        public function reset() : void
        {
            var _loc_1:* = 0;
            _loc_1 = 0;
            while (_loc_1 < LENGTH)
            {
                
                this[_loc_1] = IDENTITY_MATRIX[_loc_1];
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

        public function invert() : void
        {
            multiplyMatrix([-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0]);
            return;
        }// end function

        public function adjustColor(param1:Number, param2:Number, param3:Number, param4:Number) : void
        {
            adjustHue(param4);
            adjustContrast(param2);
            adjustBrightness(param1);
            adjustSaturation(param3);
            return;
        }// end function

        public function adjustBrightness(param1:Number) : void
        {
            param1 = cleanValue(param1, 1) * 255;
            multiplyMatrix([1, 0, 0, 0, param1, 0, 1, 0, 0, param1, 0, 0, 1, 0, param1, 0, 0, 0, 1, 0]);
            return;
        }// end function

        public function adjustContrast(param1:Number) : void
        {
            param1 = cleanValue(param1, 1);
            var _loc_2:* = param1 + 1;
            var _loc_3:* = 128 * (1 - _loc_2);
            multiplyMatrix([_loc_2, 0, 0, 0, _loc_3, 0, _loc_2, 0, 0, _loc_3, 0, 0, _loc_2, 0, _loc_3, 0, 0, 0, 1, 0]);
            return;
        }// end function

        public function adjustSaturation(param1:Number) : void
        {
            param1 = cleanValue(param1, 1);
            param1 = param1 + 1;
            var _loc_3:* = 1 - param1;
            var _loc_4:* = _loc_3 * 0.299;
            var _loc_2:* = _loc_3 * 0.587;
            var _loc_5:* = _loc_3 * 0.114;
            multiplyMatrix([_loc_4 + param1, _loc_2, _loc_5, 0, 0, _loc_4, _loc_2 + param1, _loc_5, 0, 0, _loc_4, _loc_2, _loc_5 + param1, 0, 0, 0, 0, 0, 1, 0]);
            return;
        }// end function

        public function adjustHue(param1:Number) : void
        {
            param1 = cleanValue(param1, 1);
            param1 = param1 * 3.14159;
            var _loc_2:* = Math.cos(param1);
            var _loc_3:* = Math.sin(param1);
            multiplyMatrix([0.299 + _loc_2 * (1 - 0.299) + _loc_3 * (-0.299), 0.587 + _loc_2 * (-0.587) + _loc_3 * (-0.587), 0.114 + _loc_2 * (-0.114) + _loc_3 * (1 - 0.114), 0, 0, 0.299 + _loc_2 * (-0.299) + _loc_3 * 0.143, 0.587 + _loc_2 * (1 - 0.587) + _loc_3 * 0.14, 0.114 + _loc_2 * (-0.114) + _loc_3 * -0.283, 0, 0, 0.299 + _loc_2 * (-0.299) + _loc_3 * -0.701, 0.587 + _loc_2 * (-0.587) + _loc_3 * 0.587, 0.114 + _loc_2 * (1 - 0.114) + _loc_3 * 0.114, 0, 0, 0, 0, 0, 1, 0]);
            return;
        }// end function

        public function clone() : ColorMatrix
        {
            var _loc_1:* = new ColorMatrix();
            _loc_1.copyMatrix(this);
            return _loc_1;
        }// end function

        protected function copyMatrix(param1:Array) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = LENGTH;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                this[_loc_2] = param1[_loc_2];
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        protected function multiplyMatrix(param1:Array) : void
        {
            var _loc_5:* = 0;
            var _loc_3:* = 0;
            var _loc_2:* = [];
            var _loc_4:* = 0;
            _loc_5 = 0;
            while (_loc_5 < 4)
            {
                
                _loc_3 = 0;
                while (_loc_3 < 5)
                {
                    
                    _loc_2[_loc_4 + _loc_3] = param1[_loc_4] * this[_loc_3] + param1[(_loc_4 + 1)] * this[_loc_3 + 5] + param1[_loc_4 + 2] * this[_loc_3 + 10] + param1[_loc_4 + 3] * this[_loc_3 + 15] + (_loc_3 == 4 ? (param1[_loc_4 + 4]) : (0));
                    _loc_3++;
                }
                _loc_4 = _loc_4 + 5;
                _loc_5++;
            }
            copyMatrix(_loc_2);
            return;
        }// end function

        protected function cleanValue(param1:Number, param2:Number) : Number
        {
            return Math.min(param2, Math.max(-param2, param1));
        }// end function

        public static function create(param1:Number, param2:Number, param3:Number, param4:Number) : ColorMatrix
        {
            var _loc_5:* = new ColorMatrix;
            _loc_5.adjustColor(param1, param2, param3, param4);
            return _loc_5;
        }// end function

    }
}
