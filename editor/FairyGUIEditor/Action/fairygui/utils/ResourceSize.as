package fairygui.utils
{
    import *.*;
    import com.lorentz.SVG.utils.*;
    import flash.filesystem.*;
    import flash.geom.*;
    import flash.utils.*;

    public class ResourceSize extends Object
    {
        private static var SIGS:Array = [[71, 73, 70], [137, 80, 78, 71, 13, 10, 26, 10], [255, 216, 255], [0, 5, 121, 121, 116, 111, 117], [70, 87, 83], [67, 87, 83], [90, 87, 83], [56, 66, 80, 83]];
        private static var buffer:ByteArray = new ByteArray();
        private static var fileStream:FileStream = new FileStream();
        private static var fileLen:Number;
        private static var result:Object;
        private static const M_PSEUDO:int = 65496;
        private static const M_SOF0:int = 192;
        private static const M_SOF1:int = 193;
        private static const M_SOF2:int = 194;
        private static const M_SOF3:int = 195;
        private static const M_SOF5:int = 197;
        private static const M_SOF6:int = 198;
        private static const M_SOF7:int = 199;
        private static const M_SOF9:int = 201;
        private static const M_SOF10:int = 202;
        private static const M_SOF11:int = 203;
        private static const M_SOF13:int = 205;
        private static const M_SOF14:int = 206;
        private static const M_SOF15:int = 207;
        private static const M_SOI:int = 216;
        private static const M_EOI:int = 217;
        private static const M_SOS:int = 218;
        private static const M_APP0:int = 224;
        private static const M_APP1:int = 225;
        private static const M_APP2:int = 226;
        private static const M_APP3:int = 227;
        private static const M_APP4:int = 228;
        private static const M_APP5:int = 229;
        private static const M_APP6:int = 230;
        private static const M_APP7:int = 231;
        private static const M_APP8:int = 232;
        private static const M_APP9:int = 233;
        private static const M_APP10:int = 234;
        private static const M_APP11:int = 235;
        private static const M_APP12:int = 236;
        private static const M_APP13:int = 237;
        private static const M_APP14:int = 238;
        private static const M_APP15:int = 239;
        private static const M_COM:int = 254;
        private static var marker:int;
        private static var pos:int;
        private static var _mySwf:MySwf;

        public function ResourceSize()
        {
            return;
        }// end function

        public static function getSize(param1:File) : Object
        {
            var type:int;
            var file:* = param1;
            if (!file.exists || file.isDirectory)
            {
                return null;
            }
            var ext:* = file.extension;
            if (ext == null)
            {
                ext;
            }
            else
            {
                ext = ext.toLowerCase();
            }
            result = null;
            if (ext == "svg")
            {
                checkSVG(file);
                return result;
            }
            fileLen = file.size;
            fileStream = new FileStream();
            fileStream.open(file, FileMode.READ);
            try
            {
                type = checkSig();
                switch(type)
                {
                    case 0:
                    {
                        checkGIF();
                        break;
                    }
                    case 1:
                    {
                        checkPNG();
                        break;
                    }
                    case 2:
                    {
                        checkJPG();
                        break;
                    }
                    case 3:
                    {
                        checkJta();
                        break;
                    }
                    case 4:
                    case 5:
                    case 6:
                    {
                        checkSwf(type - 4);
                        break;
                    }
                    case 7:
                    {
                        checkPSD();
                        break;
                    }
                    default:
                    {
                        if (ext == "tga")
                        {
                            checkTga();
                        }
                        break;
                        break;
                    }
                }
            }
            catch (e:Error)
            {
                throw 0;
            }
            finally
            {
                fileStream.close();
            }
            return result;
        }// end function

        private static function checkSig() : int
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = null;
            if (fileStream.bytesAvailable < 8)
            {
                return -1;
            }
            fileStream.readBytes(buffer, 0, 8);
            buffer.position = 0;
            _loc_1 = 0;
            while (_loc_1 < SIGS.length)
            {
                
                _loc_3 = SIGS[_loc_1];
                _loc_2 = 0;
                while (_loc_2 < _loc_3.length)
                {
                    
                    if (buffer.readUnsignedByte() != _loc_3[_loc_2])
                    {
                        break;
                    }
                    _loc_2++;
                }
                buffer.position = 0;
                if (_loc_2 == _loc_3.length)
                {
                    return _loc_1;
                }
                _loc_1++;
            }
            return -1;
        }// end function

        private static function checkGIF() : void
        {
            if (fileLen < 10)
            {
                return;
            }
            fileStream.position = 6;
            fileStream.readBytes(buffer, 0, 4);
            buffer.endian = Endian.LITTLE_ENDIAN;
            buffer.position = 0;
            result = {type:"gif", width:buffer.readUnsignedShort(), height:buffer.readUnsignedShort()};
            return;
        }// end function

        private static function checkPNG() : void
        {
            if (fileLen < 26)
            {
                return;
            }
            fileStream.position = 16;
            fileStream.readBytes(buffer, 0, 10);
            buffer.endian = Endian.BIG_ENDIAN;
            buffer.position = 0;
            result = {type:"png", width:buffer.readUnsignedInt(), height:buffer.readUnsignedInt(), bitDepth:buffer.readByte(), colorType:buffer.readByte()};
            return;
        }// end function

        private static function checkJPG() : void
        {
            marker = M_PSEUDO;
            pos = 2;
            buffer.endian = Endian.BIG_ENDIAN;
            nextMarker();
            return;
        }// end function

        private static function nextMarker() : void
        {
            var _loc_1:* = 0;
            var _loc_3:* = 0;
            var _loc_2:* = marker;
            var _loc_4:* = 0;
            if (M_COM == _loc_2)
            {
                _loc_3 = 2;
            }
            else
            {
                _loc_3 = 0;
            }
            if (fileLen <= pos)
            {
                return;
            }
            do
            {
                
                if (fileLen <= pos + _loc_4)
                {
                    return;
                }
                fileStream.position = pos + _loc_4;
                _loc_1 = fileStream.readUnsignedByte();
                if (M_COM == _loc_2 && _loc_3 > 0)
                {
                    if (_loc_1 != 255)
                    {
                        _loc_1 = 255;
                        _loc_3 = _loc_3 - 1;
                    }
                    else
                    {
                        _loc_2 = M_PSEUDO;
                    }
                }
                _loc_4++;
            }while (_loc_1 == 255)
            if (_loc_4 < 2)
            {
                return;
            }
            if (M_COM == _loc_2 && _loc_3)
            {
                return;
            }
            pos = pos + _loc_4;
            marker = _loc_1;
            blockBody();
            return;
        }// end function

        private static function blockBody() : void
        {
            var _loc_1:* = 0;
            switch(marker)
            {
                case M_SOF0:
                case M_SOF1:
                case M_SOF2:
                case M_SOF3:
                case M_SOF5:
                case M_SOF6:
                case M_SOF7:
                case M_SOF9:
                case M_SOF10:
                case M_SOF11:
                case M_SOF13:
                case M_SOF14:
                case M_SOF15:
                {
                    if (fileLen <= pos + 2 + 1 + 2 + 2)
                    {
                        return;
                    }
                    fileStream.position = pos + 3;
                    fileStream.readBytes(buffer, 0, 4);
                    buffer.position = 0;
                    result = {type:"jpg"};
                    result.height = buffer.readUnsignedShort();
                    result.width = buffer.readUnsignedShort();
                    break;
                }
                case M_SOS:
                case M_EOI:
                {
                    break;
                }
                default:
                {
                    if (fileLen <= pos + 2)
                    {
                        return;
                    }
                    fileStream.position = pos;
                    fileStream.readBytes(buffer, 0, 2);
                    buffer.position = 0;
                    _loc_1 = buffer.readUnsignedShort();
                    pos = pos + _loc_1;
                    nextMarker();
                    break;
                    break;
                }
            }
            return;
        }// end function

        private static function checkJta() : void
        {
            if (fileLen < 23)
            {
                return;
            }
            fileStream.position = 19;
            fileStream.readBytes(buffer, 0, 4);
            buffer.position = 0;
            buffer.endian = Endian.BIG_ENDIAN;
            result = {type:"jta"};
            result.width = buffer.readUnsignedShort();
            result.height = buffer.readUnsignedShort();
            return;
        }// end function

        private static function checkSwf(param1:int) : void
        {
            var rect:Rectangle;
            var compress:* = param1;
            fileStream.position = 0;
            fileStream.readBytes(buffer, 0, fileLen);
            if (_mySwf == null)
            {
                _mySwf = new MySwf();
            }
            try
            {
                _mySwf.parseHeaderOnly(buffer);
                rect = _mySwf.frameSize.rect;
                result = {type:"swf", width:rect.width, height:rect.height};
            }
            catch (err:Error)
            {
                result = {type:"jta"};
            }
            return;
        }// end function

        private static function checkPSD() : void
        {
            if (fileLen < 26)
            {
                return;
            }
            fileStream.position = 14;
            fileStream.readBytes(buffer, 0, 8);
            buffer.endian = Endian.BIG_ENDIAN;
            buffer.position = 0;
            result = {type:"psd"};
            result.height = buffer.readUnsignedInt();
            result.width = buffer.readUnsignedInt();
            return;
        }// end function

        private static function checkTga() : void
        {
            if (fileLen < 16)
            {
                return;
            }
            fileStream.position = 2;
            var _loc_1:* = fileStream.readByte();
            if (_loc_1 != 0 && _loc_1 != 1 && _loc_1 != 2 && _loc_1 != 3 && _loc_1 != 9 && _loc_1 != 10 && _loc_1 != 11)
            {
                return;
            }
            fileStream.position = 12;
            fileStream.readBytes(buffer, 0, 4);
            buffer.endian = Endian.LITTLE_ENDIAN;
            buffer.position = 0;
            result = {type:"tga"};
            result.width = buffer.readUnsignedShort();
            result.height = buffer.readUnsignedShort();
            return;
        }// end function

        private static function checkSVG(param1:File) : void
        {
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_2:* = UtilsFile.loadXMLRoot(param1);
            if (!_loc_2 || _loc_2.getName() != "svg")
            {
                return;
            }
            var _loc_3:* = _loc_2.getAttribute("viewBox");
            var _loc_4:* = _loc_2.getAttribute("width");
            if (!_loc_2.getAttribute("width"))
            {
                _loc_4 = "100%";
            }
            var _loc_5:* = _loc_2.getAttribute("height");
            if (!_loc_2.getAttribute("height"))
            {
                _loc_5 = "100%";
            }
            if (_loc_3 != null)
            {
                _loc_8 = _loc_3.split(" ");
                _loc_6 = parseInt(_loc_8[2]);
                _loc_7 = parseInt(_loc_8[3]);
            }
            result = {type:"svg"};
            result.width = SVGUtil.getUserUnit(_loc_4, 0, _loc_6, _loc_7, SVGUtil.WIDTH);
            result.height = SVGUtil.getUserUnit(_loc_5, 0, _loc_6, _loc_7, SVGUtil.HEIGHT);
            return;
        }// end function

    }
}

import *.*;

import com.lorentz.SVG.utils.*;

import flash.filesystem.*;

import flash.geom.*;

import flash.utils.*;

class MySwf extends SWF
{

    function MySwf()
    {
        return;
    }// end function

    public function parseHeaderOnly(param1:ByteArray) : void
    {
        bytes.length = 0;
        param1.position = 0;
        param1.readBytes(ByteArray(bytes));
        parseHeader();
        return;
    }// end function

}

