package fairygui.utils
{
    import *.*;
    import flash.filesystem.*;
    import flash.system.*;
    import flash.utils.*;

    public class FontInfoReader extends Object
    {
        private static var isMac:Boolean;

        public function FontInfoReader()
        {
            return;
        }// end function

        public static function enumerateFonts() : Array
        {
            var fontFolder:File;
            var files:Array;
            var fontFile:File;
            var ext:String;
            var info:Array;
            var m:Object;
            isMac = Capabilities.os.toLowerCase().indexOf("mac") != -1;
            if (isMac)
            {
                fontFolder = new File("/System/Library/Fonts");
                if (fontFolder.exists)
                {
                    files = fontFolder.getDirectoryListing();
                }
                fontFolder = new File("/Library/Fonts");
                if (fontFolder.exists)
                {
                    files = files.concat(fontFolder.getDirectoryListing());
                }
                fontFolder = File.userDirectory.resolvePath("Library/Fonts");
                if (fontFolder.exists)
                {
                    files = files.concat(fontFolder.getDirectoryListing());
                }
            }
            else
            {
                fontFolder = new File("c:\\windows\\fonts\\");
                files = fontFolder.getDirectoryListing();
                fontFolder = File.userDirectory.resolvePath("appdata\\local\\microsoft\\windows\\fonts\\");
                if (fontFolder.exists)
                {
                    files = files.concat(fontFolder.getDirectoryListing());
                }
            }
            var result:Array;
            var keys:Object;
            var _loc_2:* = 0;
            var _loc_3:* = files;
            do
            {
                
                fontFile = _loc_3[_loc_2];
                if (fontFile.name.charAt(0) == ".")
                {
                }
                else
                {
                    ext = fontFile.extension;
                    if (!ext)
                    {
                    }
                    else
                    {
                        ext = ext.toLowerCase();
                        if (ext == "ttf" || ext == "ttc" || ext == "otf" || ext == "dfont")
                        {
                            try
                            {
                                info = getFontFamily(fontFile);
                                if (info)
                                {
                                    var _loc_4:* = 0;
                                    var _loc_5:* = info;
                                    while (_loc_5 in _loc_4)
                                    {
                                        
                                        m = _loc_5[_loc_4];
                                        if (!keys[m.family])
                                        {
                                            result.push(m);
                                            keys[m.family] = true;
                                        }
                                    }
                                }
                            }
                            catch (err:Error)
                            {
                            }
                        }
                    }
                }
            }while (_loc_3 in _loc_2)
            result.sort(sortFont);
            return result;
        }// end function

        private static function sortFont(param1:Object, param2:Object) : int
        {
            var _loc_3:* = param2.matchLang - param1.matchLang;
            if (_loc_3 != 0)
            {
                return _loc_3;
            }
            return param1.family.localeCompare(param2.family);
        }// end function

        public static function getFontFamily(param1:File) : Array
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_2:* = new FileStream();
            _loc_2.endian = Endian.BIG_ENDIAN;
            _loc_2.open(param1, FileMode.READ);
            var _loc_3:* = [];
            var _loc_4:* = _loc_2.readUnsignedInt();
            if (_loc_2.readUnsignedInt() == 65536 || _loc_4 == 1330926671)
            {
                _loc_5 = readTTF(_loc_2, 0);
                if (_loc_5 != null)
                {
                    _loc_3.push(_loc_5);
                }
            }
            else if (_loc_4 == 1953784678)
            {
                _loc_6 = [];
                _loc_2.readInt();
                _loc_7 = _loc_2.readInt();
                _loc_8 = 0;
                while (_loc_8 < _loc_7)
                {
                    
                    _loc_6.push(_loc_2.readInt());
                    _loc_8++;
                }
                _loc_8 = 0;
                while (_loc_8 < _loc_7)
                {
                    
                    _loc_5 = readTTF(_loc_2, _loc_6[_loc_8]);
                    if (_loc_5 != null)
                    {
                        _loc_3.push(_loc_5);
                    }
                    _loc_8++;
                }
            }
            _loc_2.close();
            return _loc_3;
        }// end function

        public static function readTTF(param1:FileStream, param2:int) : Object
        {
            var _loc_17:* = null;
            var _loc_18:* = 0;
            var _loc_19:* = 0;
            var _loc_20:* = 0;
            var _loc_21:* = 0;
            var _loc_22:* = 0;
            var _loc_23:* = 0;
            var _loc_24:* = null;
            var _loc_25:* = null;
            var _loc_3:* = new ByteArray();
            _loc_3.endian = Endian.BIG_ENDIAN;
            param1.position = param2;
            var _loc_4:* = param1.readUnsignedInt();
            if (param1.readUnsignedInt() != 65536 && _loc_4 != 1330926671)
            {
                return null;
            }
            var _loc_5:* = param1.readShort();
            var _loc_6:* = -1;
            param1.position = param1.position + 6;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_5)
            {
                
                param1.position = param2 + 12 + 16 * _loc_7;
                _loc_17 = param1.readMultiByte(4, "iso-8859-1");
                if (_loc_17 == "name")
                {
                    param1.position = param1.position + 4;
                    _loc_6 = param1.readUnsignedInt();
                    break;
                }
                _loc_7++;
            }
            if (_loc_6 == -1)
            {
                return null;
            }
            var _loc_8:* = [];
            param1.position = _loc_6;
            var _loc_9:* = param1.readUnsignedShort();
            var _loc_10:* = param1.readUnsignedShort();
            var _loc_11:* = param1.readUnsignedShort();
            var _loc_12:* = param1.position;
            var _loc_13:* = _loc_6 + _loc_11;
            _loc_10 = Math.min(_loc_10, int((_loc_11 - 6) / 12));
            var _loc_14:* = 0;
            while (_loc_14 < _loc_10)
            {
                
                param1.position = _loc_12 + _loc_14 * 12;
                _loc_18 = param1.readUnsignedShort();
                _loc_19 = param1.readUnsignedShort();
                _loc_20 = param1.readUnsignedShort();
                _loc_21 = param1.readUnsignedShort();
                _loc_22 = param1.readUnsignedShort();
                _loc_23 = param1.readUnsignedShort();
                if (_loc_21 == 1)
                {
                    param1.position = _loc_13 + _loc_23;
                    param1.readBytes(_loc_3, 0, _loc_22);
                    _loc_3.position = 0;
                    _loc_24 = "utf8";
                    if (_loc_18 == 0)
                    {
                        _loc_24 = "unicodeFFFE";
                    }
                    else
                    {
                        switch(_loc_19)
                        {
                            case 0:
                            {
                                break;
                            }
                            case 1:
                            {
                                break;
                            }
                            case 2:
                            {
                                break;
                            }
                            case 3:
                            {
                                break;
                            }
                            case 4:
                            {
                                break;
                            }
                            case 5:
                            {
                                break;
                            }
                            case 6:
                            {
                                break;
                            }
                            case 7:
                            {
                                break;
                            }
                            case 24:
                            {
                                break;
                            }
                            case 25:
                            {
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                        if (_loc_18 == 3)
                        {
                            switch(_loc_19)
                            {
                                case 0:
                                {
                                    break;
                                }
                                case 1:
                                {
                                    break;
                                }
                                case 2:
                                {
                                    break;
                                }
                                case 3:
                                {
                                    break;
                                }
                                case 4:
                                {
                                    break;
                                }
                                default:
                                {
                                    break;
                                }
                            }
                        }
                    }
                    _loc_25 = _loc_3.readMultiByte(_loc_22, _loc_24);
                    _loc_25 = UtilsStr.trim(_loc_25);
                    if (_loc_25.length)
                    {
                        if (_loc_25.charAt(0) == ".")
                        {
                        }
                        else
                        {
                            _loc_8.push(translateLangId(_loc_18, _loc_20), _loc_18, _loc_25);
                        }
                    }
                }
                _loc_14++;
            }
            var _loc_15:* = {matchLang:0};
            var _loc_16:* = _loc_8.length;
            _loc_7 = 0;
            while (_loc_7 < _loc_16)
            {
                
                if (_loc_8[_loc_7] == 1033 || _loc_8[_loc_7] == 0)
                {
                    if (_loc_15.family)
                    {
                        if (isMac && _loc_15[(_loc_7 + 1)] == 1 || !isMac && _loc_15[(_loc_7 + 1)] != 1)
                        {
                            _loc_15.family = _loc_8[_loc_7 + 2];
                            _loc_8[_loc_7] = -1;
                        }
                    }
                    else
                    {
                        _loc_15.family = _loc_8[_loc_7 + 2];
                        _loc_8[_loc_7] = -1;
                    }
                }
                _loc_7 = _loc_7 + 3;
            }
            _loc_7 = 0;
            while (_loc_7 < _loc_16)
            {
                
                if (_loc_8[_loc_7] < 0)
                {
                }
                else if (matchLanguage(_loc_8[_loc_7]))
                {
                    _loc_15.matchLang = 1;
                    _loc_15.localeFamily = _loc_8[_loc_7 + 2];
                }
                else if (!_loc_15.localeFamily && _loc_8[_loc_7 + 2] != _loc_15.family)
                {
                    _loc_15.localeFamily = _loc_8[_loc_7 + 2];
                }
                _loc_7 = _loc_7 + 3;
            }
            if (!_loc_15.family)
            {
                _loc_15.family = _loc_15.localeFamily;
            }
            if (!_loc_15.family)
            {
                return null;
            }
            return _loc_15;
        }// end function

        private static function translateLangId(param1:int, param2:int) : int
        {
            switch(param2)
            {
                case 25:
                {
                    return 2052;
                }
                case 19:
                {
                    return 1028;
                }
                case 1:
                {
                    return 1041;
                }
                case 3:
                {
                    return 1042;
                }
                default:
                {
                    return 1033;
                    break;
                }
            }
            return param2;
        }// end function

        private static function matchLanguage(param1:int) : Boolean
        {
            var _loc_2:* = Capabilities.language;
            if (_loc_2 == "zh-CN" && param1 == 2052 || _loc_2 == "zh-TW" && param1 == 1028 || _loc_2 == "zh_HK" && param1 == 3076 || _loc_2 == "ja_JP" && param1 == 1041 || _loc_2 == "ko_KR" && param1 == 1042)
            {
                return true;
            }
            return false;
        }// end function

    }
}
