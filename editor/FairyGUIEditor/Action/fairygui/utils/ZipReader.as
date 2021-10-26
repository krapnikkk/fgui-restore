package fairygui.utils
{
    import *.*;
    import flash.utils.*;

    public class ZipReader extends Object
    {
        private var _stream:ByteArray;
        private var _entries:Object;

        public function ZipReader(param1:ByteArray) : void
        {
            _stream = param1;
            _stream.endian = "littleEndian";
            _entries = {};
            readEntries();
            return;
        }// end function

        public function get entries() : Object
        {
            return _entries;
        }// end function

        private function readEntries() : void
        {
            var _loc_7:* = 0;
            var _loc_3:* = 0;
            var _loc_6:* = null;
            var _loc_8:* = 0;
            var _loc_5:* = null;
            var _loc_4:* = null;
            var _loc_1:* = new ByteArray();
            _loc_1.endian = "littleEndian";
            _stream.position = _stream.length - 22;
            _stream.readBytes(_loc_1, 0, 22);
            _loc_1.position = 10;
            var _loc_2:* = _loc_1.readUnsignedShort();
            _loc_1.position = 16;
            _stream.position = _loc_1.readUnsignedInt();
            _loc_1.length = 0;
            _loc_7 = 0;
            while (_loc_7 < _loc_2)
            {
                
                _stream.readBytes(_loc_1, 0, 46);
                _loc_1.position = 28;
                _loc_3 = _loc_1.readUnsignedShort();
                _loc_6 = _stream.readUTFBytes(_loc_3);
                _loc_8 = _stream.position + _loc_1.readUnsignedShort() + _loc_1.readUnsignedShort();
                _loc_5 = _loc_6.charAt((_loc_6.length - 1));
                if (_loc_5 == "/" || _loc_5 == "\\")
                {
                    _stream.position = _loc_8;
                }
                else
                {
                    _loc_6 = _loc_6.replace(/\\/g, "/");
                    _loc_4 = new ZipEntry();
                    _loc_4.name = _loc_6;
                    _loc_1.position = 10;
                    _loc_4.compress = _loc_1.readUnsignedShort();
                    _loc_1.position = 16;
                    _loc_4.crc = _loc_1.readUnsignedInt();
                    _loc_4.size = _loc_1.readUnsignedInt();
                    _loc_4.sourceSize = _loc_1.readUnsignedInt();
                    _loc_1.position = 42;
                    _loc_4.offset = _loc_1.readUnsignedInt();
                    _stream.position = _loc_4.offset;
                    _stream.readBytes(_loc_1, 0, 30);
                    _loc_1.position = 26;
                    _loc_4.offset = _loc_4.offset + (_loc_1.readUnsignedShort() + _loc_1.readUnsignedShort() + 30);
                    _stream.position = _loc_8;
                    _entries[_loc_6] = _loc_4;
                }
                _loc_7++;
            }
            return;
        }// end function

        public function getEntryData(param1:String) : ByteArray
        {
            var _loc_2:* = _entries[param1];
            if (!_loc_2)
            {
                return null;
            }
            var _loc_3:* = new ByteArray();
            if (!_loc_2.size)
            {
                return _loc_3;
            }
            _stream.position = _loc_2.offset;
            _stream.readBytes(_loc_3, 0, _loc_2.size);
            if (_loc_2.compress)
            {
                _loc_3.inflate();
            }
            return _loc_3;
        }// end function

    }
}

import *.*;

import flash.utils.*;

class ZipEntry extends Object
{
    public var name:String;
    public var offset:uint;
    public var size:uint;
    public var sourceSize:uint;
    public var compress:int;
    public var crc:uint;

    function ZipEntry()
    {
        return;
    }// end function

}

