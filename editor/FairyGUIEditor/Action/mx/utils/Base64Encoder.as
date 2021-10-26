package mx.utils
{
    import *.*;
    import flash.utils.*;

    public class Base64Encoder extends Object
    {
        public var insertNewLines:Boolean = true;
        private var _buffers:Array;
        private var _count:uint;
        private var _line:uint;
        private var _work:Array;
        public static const CHARSET_UTF_8:String = "UTF-8";
        public static var newLine:int = 10;
        public static const MAX_BUFFER_SIZE:uint = 32767;
        private static const ESCAPE_CHAR_CODE:Number = 61;
        private static const ALPHABET_CHAR_CODES:Array = [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 43, 47];

        public function Base64Encoder()
        {
            this._work = [0, 0, 0];
            this.reset();
            return;
        }// end function

        public function drain() : String
        {
            var _loc_3:* = null;
            var _loc_1:* = "";
            var _loc_2:* = 0;
            while (_loc_2 < this._buffers.length)
            {
                
                _loc_3 = this._buffers[_loc_2] as Array;
                _loc_1 = _loc_1 + String.fromCharCode.apply(null, _loc_3);
                _loc_2 = _loc_2 + 1;
            }
            this._buffers = [];
            this._buffers.push([]);
            return _loc_1;
        }// end function

        public function encode(param1:String, param2:uint = 0, param3:uint = 0) : void
        {
            if (param3 == 0)
            {
                param3 = param1.length;
            }
            var _loc_4:* = param2;
            var _loc_5:* = param2 + param3;
            if (param2 + param3 > param1.length)
            {
                _loc_5 = param1.length;
            }
            while (_loc_4 < _loc_5)
            {
                
                this._work[this._count] = param1.charCodeAt(_loc_4);
                var _loc_6:* = this;
                var _loc_7:* = this._count + 1;
                _loc_6._count = _loc_7;
                if (this._count == this._work.length || _loc_5 - _loc_4 == 1)
                {
                    this.encodeBlock();
                    this._count = 0;
                    this._work[0] = 0;
                    this._work[1] = 0;
                    this._work[2] = 0;
                }
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        public function encodeUTFBytes(param1:String) : void
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeUTFBytes(param1);
            _loc_2.position = 0;
            this.encodeBytes(_loc_2);
            return;
        }// end function

        public function encodeBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void
        {
            if (param3 == 0)
            {
                param3 = param1.length;
            }
            var _loc_4:* = param1.position;
            param1.position = param2;
            var _loc_5:* = param2;
            var _loc_6:* = param2 + param3;
            if (param2 + param3 > param1.length)
            {
                _loc_6 = param1.length;
            }
            while (_loc_5 < _loc_6)
            {
                
                this._work[this._count] = param1[_loc_5];
                var _loc_7:* = this;
                var _loc_8:* = this._count + 1;
                _loc_7._count = _loc_8;
                if (this._count == this._work.length || _loc_6 - _loc_5 == 1)
                {
                    this.encodeBlock();
                    this._count = 0;
                    this._work[0] = 0;
                    this._work[1] = 0;
                    this._work[2] = 0;
                }
                _loc_5 = _loc_5 + 1;
            }
            param1.position = _loc_4;
            return;
        }// end function

        public function flush() : String
        {
            if (this._count > 0)
            {
                this.encodeBlock();
            }
            var _loc_1:* = this.drain();
            this.reset();
            return _loc_1;
        }// end function

        public function reset() : void
        {
            this._buffers = [];
            this._buffers.push([]);
            this._count = 0;
            this._line = 0;
            this._work[0] = 0;
            this._work[1] = 0;
            this._work[2] = 0;
            return;
        }// end function

        public function toString() : String
        {
            return this.flush();
        }// end function

        private function encodeBlock() : void
        {
            var _loc_1:* = this._buffers[(this._buffers.length - 1)] as Array;
            if (_loc_1.length >= MAX_BUFFER_SIZE)
            {
                _loc_1 = [];
                this._buffers.push(_loc_1);
            }
            _loc_1.push(ALPHABET_CHAR_CODES[(this._work[0] & 255) >> 2]);
            _loc_1.push(ALPHABET_CHAR_CODES[(this._work[0] & 3) << 4 | (this._work[1] & 240) >> 4]);
            if (this._count > 1)
            {
                _loc_1.push(ALPHABET_CHAR_CODES[(this._work[1] & 15) << 2 | (this._work[2] & 192) >> 6]);
            }
            else
            {
                _loc_1.push(ESCAPE_CHAR_CODE);
            }
            if (this._count > 2)
            {
                _loc_1.push(ALPHABET_CHAR_CODES[this._work[2] & 63]);
            }
            else
            {
                _loc_1.push(ESCAPE_CHAR_CODE);
            }
            if (this.insertNewLines)
            {
                var _loc_2:* = this._line + 4;
                this._line = this._line + 4;
                if (_loc_2 == 76)
                {
                    _loc_1.push(newLine);
                    this._line = 0;
                }
            }
            return;
        }// end function

    }
}
