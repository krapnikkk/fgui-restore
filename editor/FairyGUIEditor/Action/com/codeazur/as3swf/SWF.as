package com.codeazur.as3swf
{
    import com.codeazur.as3swf.data.*;
    import com.codeazur.as3swf.events.*;
    import com.codeazur.utils.*;
    import flash.utils.*;

    public class SWF extends SWFTimelineContainer
    {
        public var signature:String;
        public var version:int;
        public var fileLength:uint;
        public var fileLengthCompressed:uint;
        public var frameSize:SWFRectangle;
        public var frameRate:Number;
        public var frameCount:uint;
        public var compressed:Boolean;
        public var compressionMethod:String;
        protected var bytes:SWFData;
        public static const COMPRESSION_METHOD_ZLIB:String = "zlib";
        public static const COMPRESSION_METHOD_LZMA:String = "lzma";
        public static const TOSTRING_FLAG_TIMELINE_STRUCTURE:uint = 1;
        public static const TOSTRING_FLAG_AVM1_BYTECODE:uint = 2;
        static const FILE_LENGTH_POS:uint = 4;
        static const COMPRESSION_START_POS:uint = 8;

        public function SWF(param1:ByteArray = null)
        {
            this.bytes = new SWFData();
            if (param1 != null)
            {
                this.loadBytes(param1);
            }
            else
            {
                this.version = 10;
                this.fileLength = 0;
                this.fileLengthCompressed = 0;
                this.frameSize = new SWFRectangle();
                this.frameRate = 50;
                this.frameCount = 1;
                this.compressed = true;
                this.compressionMethod = COMPRESSION_METHOD_ZLIB;
            }
            return;
        }// end function

        public function loadBytes(param1:ByteArray) : void
        {
            this.bytes.length = 0;
            param1.position = 0;
            param1.readBytes(this.bytes);
            this.parse(this.bytes);
            return;
        }// end function

        public function loadBytesAsync(param1:ByteArray) : void
        {
            this.bytes.length = 0;
            param1.position = 0;
            param1.readBytes(this.bytes);
            this.parseAsync(this.bytes);
            return;
        }// end function

        public function parse(param1:SWFData) : void
        {
            this.bytes = param1;
            this.parseHeader();
            parseTags(param1, this.version);
            return;
        }// end function

        public function parseAsync(param1:SWFData) : void
        {
            this.bytes = param1;
            this.parseHeader();
            parseTagsAsync(param1, this.version);
            return;
        }// end function

        public function publish(param1:ByteArray) : void
        {
            var _loc_2:* = new SWFData();
            this.publishHeader(_loc_2);
            publishTags(_loc_2, this.version);
            this.publishFinalize(_loc_2);
            param1.writeBytes(_loc_2);
            return;
        }// end function

        public function publishAsync(param1:ByteArray) : void
        {
            var data:SWFData;
            var ba:* = param1;
            data = new SWFData();
            this.publishHeader(data);
            publishTagsAsync(data, this.version);
            addEventListener(SWFProgressEvent.COMPLETE, function (event:SWFProgressEvent) : void
            {
                removeEventListener(SWFProgressEvent.COMPLETE, arguments.callee);
                publishFinalize(data);
                ba.length = 0;
                ba.writeBytes(data);
                return;
            }// end function
            , false, int.MAX_VALUE);
            return;
        }// end function

        protected function parseHeader() : void
        {
            this.signature = "";
            this.compressed = false;
            this.compressionMethod = COMPRESSION_METHOD_ZLIB;
            this.bytes.position = 0;
            var _loc_1:* = this.bytes.readUI8();
            if (_loc_1 == 67)
            {
                this.compressed = true;
            }
            else if (_loc_1 == 90)
            {
                this.compressed = true;
                this.compressionMethod = COMPRESSION_METHOD_LZMA;
            }
            else if (_loc_1 != 70)
            {
                throw new Error("Not a SWF. First signature byte is 0x" + _loc_1.toString(16) + " (expected: 0x43 or 0x5A or 0x46)");
            }
            this.signature = this.signature + String.fromCharCode(_loc_1);
            _loc_1 = this.bytes.readUI8();
            if (_loc_1 != 87)
            {
                throw new Error("Not a SWF. Second signature byte is 0x" + _loc_1.toString(16) + " (expected: 0x57)");
            }
            this.signature = this.signature + String.fromCharCode(_loc_1);
            _loc_1 = this.bytes.readUI8();
            if (_loc_1 != 83)
            {
                throw new Error("Not a SWF. Third signature byte is 0x" + _loc_1.toString(16) + " (expected: 0x53)");
            }
            this.signature = this.signature + String.fromCharCode(_loc_1);
            this.version = this.bytes.readUI8();
            this.fileLength = this.bytes.readUI32();
            this.fileLengthCompressed = this.bytes.length;
            if (this.compressed)
            {
                this.bytes.swfUncompress(this.compressionMethod, this.fileLength);
            }
            this.frameSize = this.bytes.readRECT();
            this.frameRate = this.bytes.readFIXED8();
            this.frameCount = this.bytes.readUI16();
            return;
        }// end function

        protected function publishHeader(param1:SWFData) : void
        {
            var _loc_2:* = 70;
            if (this.compressed)
            {
                if (this.compressionMethod == COMPRESSION_METHOD_ZLIB)
                {
                    _loc_2 = 67;
                }
                else if (this.compressionMethod == COMPRESSION_METHOD_LZMA)
                {
                    _loc_2 = 90;
                }
            }
            param1.writeUI8(_loc_2);
            param1.writeUI8(87);
            param1.writeUI8(83);
            param1.writeUI8(this.version);
            param1.writeUI32(0);
            param1.writeRECT(this.frameSize);
            param1.writeFIXED8(this.frameRate);
            param1.writeUI16(this.frameCount);
            return;
        }// end function

        protected function publishFinalize(param1:SWFData) : void
        {
            var _loc_3:* = param1.length;
            this.fileLengthCompressed = param1.length;
            this.fileLength = _loc_3;
            if (this.compressed)
            {
                this.compressionMethod = SWF.COMPRESSION_METHOD_ZLIB;
                param1.position = COMPRESSION_START_POS;
                param1.swfCompress(this.compressionMethod);
                this.fileLengthCompressed = param1.length;
            }
            var _loc_2:* = param1.position;
            param1.position = FILE_LENGTH_POS;
            param1.writeUI32(this.fileLength);
            param1.position = 0;
            return;
        }// end function

        override public function toString(param1:uint = 0, param2:uint = 0) : String
        {
            var _loc_3:* = StringUtils.repeat(param1);
            var _loc_4:* = StringUtils.repeat(param1 + 2);
            var _loc_5:* = StringUtils.repeat(param1 + 4);
            var _loc_6:* = _loc_3 + "[SWF]\n" + _loc_4 + "Header:\n" + _loc_5 + "Version: " + this.version + "\n" + _loc_5 + "Compression: ";
            if (this.compressed)
            {
                if (this.compressionMethod == COMPRESSION_METHOD_ZLIB)
                {
                    _loc_6 = _loc_6 + "ZLIB";
                }
                else if (this.compressionMethod == COMPRESSION_METHOD_LZMA)
                {
                    _loc_6 = _loc_6 + "LZMA";
                }
                else
                {
                    _loc_6 = _loc_6 + "Unknown";
                }
            }
            else
            {
                _loc_6 = _loc_6 + "None";
            }
            return _loc_6 + "\n" + _loc_5 + "FileLength: " + this.fileLength + "\n" + _loc_5 + "FileLengthCompressed: " + this.fileLengthCompressed + "\n" + _loc_5 + "FrameSize: " + this.frameSize.toStringSize() + "\n" + _loc_5 + "FrameRate: " + this.frameRate + "\n" + _loc_5 + "FrameCount: " + this.frameCount + super.toString(param1);
        }// end function

    }
}
