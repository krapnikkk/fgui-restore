package mx.utils
{
    import *.*;
    import flash.utils.*;
    import mx.resources.*;

    public class Base64Decoder extends Object
    {
        private var count:int = 0;
        private var data:ByteArray;
        private var filled:int = 0;
        private var work:Array;
        private var resourceManager:IResourceManager;
        private static const ESCAPE_CHAR_CODE:Number = 61;
        private static const inverse:Array = [64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 62, 64, 64, 64, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 64, 64, 64, 64, 64, 64, 64, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 64, 64, 64, 64, 64, 64, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64];

        public function Base64Decoder()
        {
            this.work = [0, 0, 0, 0];
            this.resourceManager = ResourceManager.getInstance();
            this.data = new ByteArray();
            return;
        }// end function

        public function decode(param1:String) : void
        {
            var _loc_3:* = NaN;
            var _loc_2:* = 0;
            while (_loc_2 < param1.length)
            {
                
                _loc_3 = param1.charCodeAt(_loc_2);
                if (_loc_3 == ESCAPE_CHAR_CODE)
                {
                    var _loc_5:* = this;
                    _loc_5.count = this.count + 1;
                    this.count = this.count++;
                    this.work[this.count] = -1;
                }
                else if (inverse[_loc_3] != 64)
                {
                    var _loc_5:* = this;
                    _loc_5.count = this.count + 1;
                    this.count = this.count++;
                    this.work[this.count] = inverse[_loc_3];
                }
                else
                {
                    ;
                }
                if (this.count == 4)
                {
                    this.count = 0;
                    this.data.writeByte(this.work[0] << 2 | (this.work[1] & 255) >> 4);
                    var _loc_4:* = this;
                    var _loc_5:* = this.filled + 1;
                    _loc_4.filled = _loc_5;
                    if (this.work[2] == -1)
                    {
                        break;
                    }
                    this.data.writeByte(this.work[1] << 4 | (this.work[2] & 255) >> 2);
                    var _loc_4:* = this;
                    var _loc_5:* = this.filled + 1;
                    _loc_4.filled = _loc_5;
                    if (this.work[3] == -1)
                    {
                        break;
                    }
                    this.data.writeByte(this.work[2] << 6 | this.work[3]);
                    var _loc_4:* = this;
                    var _loc_5:* = this.filled + 1;
                    _loc_4.filled = _loc_5;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public function drain() : ByteArray
        {
            var _loc_1:* = new ByteArray();
            var _loc_2:* = this.data.position;
            this.data.position = 0;
            _loc_1.writeBytes(this.data, 0, this.data.length);
            this.data.position = _loc_2;
            _loc_1.position = 0;
            this.filled = 0;
            return _loc_1;
        }// end function

        public function flush() : ByteArray
        {
            var _loc_1:* = null;
            if (this.count > 0)
            {
                _loc_1 = this.resourceManager.getString("utils", "partialBlockDropped", [this.count]);
                throw new Error(_loc_1);
            }
            return this.drain();
        }// end function

        public function reset() : void
        {
            this.data = new ByteArray();
            this.count = 0;
            this.filled = 0;
            return;
        }// end function

        public function toByteArray() : ByteArray
        {
            var _loc_1:* = this.flush();
            this.reset();
            return _loc_1;
        }// end function

    }
}
