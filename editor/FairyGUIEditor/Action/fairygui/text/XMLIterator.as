package fairygui.text
{
    import *.*;
    import fairygui.utils.*;

    public class XMLIterator extends Object
    {
        public static var tagName:String;
        public static var tagType:int;
        public static var lastTagName:String;
        private static var source:String;
        private static var sourceLen:int;
        private static var parsePos:int;
        private static var tagPos:int;
        private static var tagLength:int;
        private static var lastTagEnd:int;
        private static var attrParsed:Boolean;
        private static var lowerCaseName:Boolean;
        private static var attributes:Object;
        public static const TAG_START:int = 0;
        public static const TAG_END:int = 1;
        public static const TAG_VOID:int = 2;
        public static const TAG_CDATA:int = 3;
        public static const TAG_COMMENT:int = 4;
        public static const TAG_INSTRUCTION:int = 5;
        private static const CDATA_START:String = "<![CDATA[";
        private static const CDATA_END:String = "]]>";
        private static const COMMENT_START:String = "<!--";
        private static const COMMENT_END:String = "-->";

        public function XMLIterator()
        {
            return;
        }// end function

        public static function begin(param1:String, param2:Boolean = false) : void
        {
            XMLIterator.source = param1;
            XMLIterator.lowerCaseName = param2;
            sourceLen = param1.length;
            parsePos = 0;
            lastTagEnd = 0;
            tagPos = 0;
            tagLength = 0;
            tagName = null;
            return;
        }// end function

        public static function nextTag() : Boolean
        {
            var _loc_3:* = 0;
            var _loc_1:* = 0;
            var _loc_2:* = false;
            var _loc_5:* = 0;
            tagType = 0;
            lastTagEnd = parsePos;
            attrParsed = false;
            lastTagName = tagName;
            do
            {
                
                parsePos = _loc_3;
                _loc_3++;
                if (_loc_3 != sourceLen)
                {
                    _loc_1 = source.charCodeAt(_loc_3);
                    if (_loc_1 == 33)
                    {
                        if (sourceLen > _loc_3 + 7 && source.substr((_loc_3 - 1), 9) == "<![CDATA[")
                        {
                            _loc_3 = source.indexOf("]]>", _loc_3);
                            tagType = 3;
                            tagName = "";
                            tagPos = parsePos;
                            if (_loc_3 == -1)
                            {
                                tagLength = sourceLen - parsePos;
                            }
                            else
                            {
                                tagLength = _loc_3 + 3 - parsePos;
                            }
                            parsePos = parsePos + tagLength;
                            return true;
                        }
                        if (sourceLen > _loc_3 + 2 && source.substr((_loc_3 - 1), 4) == "<!--")
                        {
                            _loc_3 = source.indexOf("-->", _loc_3);
                            tagType = 4;
                            tagName = "";
                            tagPos = parsePos;
                            if (_loc_3 == -1)
                            {
                                tagLength = sourceLen - parsePos;
                            }
                            else
                            {
                                tagLength = _loc_3 + 3 - parsePos;
                            }
                            parsePos = parsePos + tagLength;
                            return true;
                        }
                        _loc_3++;
                        tagType = 5;
                    }
                    else if (_loc_1 == 47)
                    {
                        _loc_3++;
                        tagType = 1;
                    }
                    else if (_loc_1 == 63)
                    {
                        _loc_3++;
                        tagType = 5;
                    }
                    while (_loc_3 < sourceLen)
                    {
                        
                        _loc_1 = source.charCodeAt(_loc_3);
                        if (!(_loc_1 == 32 || _loc_1 == 9 || _loc_1 == 10 || _loc_1 == 13 || _loc_1 == 62 || _loc_1 == 47))
                        {
                            _loc_3++;
                        }
                    }
                    if (_loc_3 != sourceLen)
                    {
                        if (source.charCodeAt((parsePos + 1)) == 47)
                        {
                            tagName = source.substr(parsePos + 2, _loc_3 - parsePos - 2);
                        }
                        else
                        {
                            tagName = source.substr((parsePos + 1), _loc_3 - parsePos - 1);
                        }
                        if (lowerCaseName)
                        {
                            tagName = tagName.toLowerCase();
                        }
                        _loc_2 = false;
                        var _loc_4:* = false;
                        _loc_5 = -1;
                        while (_loc_3 < sourceLen)
                        {
                            
                            _loc_1 = source.charCodeAt(_loc_3);
                            if (_loc_1 == 34)
                            {
                                if (!_loc_2)
                                {
                                    _loc_4 = !_loc_4;
                                }
                            }
                            else if (_loc_1 == 39)
                            {
                                if (!_loc_4)
                                {
                                    _loc_2 = !_loc_2;
                                }
                            }
                            if (_loc_1 == 62)
                            {
                                if (!(_loc_2 || _loc_4))
                                {
                                    _loc_5 = -1;
                                    break;
                                }
                                _loc_5 = _loc_3;
                            }
                            else
                            {
                            }
                            _loc_3++;
                        }
                        if (_loc_5 != -1)
                        {
                            _loc_3 = _loc_5;
                        }
                        if (_loc_3 != sourceLen)
                        {
                            if (source.charCodeAt((_loc_3 - 1)) == 47)
                            {
                                tagType = 2;
                            }
                            tagPos = parsePos;
                            tagLength = (_loc_3 + 1) - parsePos;
                            parsePos = parsePos + tagLength;
                            return true;
                            _loc_3 = source.indexOf("<", parsePos);
                        }while (source.indexOf("<", parsePos) != -1)
                    }
                }
            }
            tagPos = sourceLen;
            tagLength = 0;
            tagName = null;
            return false;
        }// end function

        public static function getTagSource() : String
        {
            return source.substr(tagPos, tagLength);
        }// end function

        public static function getRawText(param1:Boolean = false) : String
        {
            var _loc_3:* = 0;
            var _loc_2:* = 0;
            if (lastTagEnd == tagPos)
            {
                return "";
            }
            if (param1)
            {
                _loc_3 = lastTagEnd;
                while (_loc_3 < tagPos)
                {
                    
                    _loc_2 = source.charCodeAt(_loc_3);
                    if (!(_loc_2 != 32 && _loc_2 != 9 && _loc_2 != 13 && _loc_2 != 10))
                    {
                        _loc_3++;
                    }
                }
                if (_loc_3 == tagPos)
                {
                    return "";
                }
                return ToolSet.trimRight(source.substr(_loc_3, tagPos - _loc_3));
            }
            return source.substr(lastTagEnd, tagPos - lastTagEnd);
        }// end function

        public static function getText(param1:Boolean = false) : String
        {
            var _loc_3:* = 0;
            var _loc_2:* = 0;
            if (lastTagEnd == tagPos)
            {
                return "";
            }
            if (param1)
            {
                _loc_3 = lastTagEnd;
                while (_loc_3 < tagPos)
                {
                    
                    _loc_2 = source.charCodeAt(_loc_3);
                    if (!(_loc_2 != 32 && _loc_2 != 9 && _loc_2 != 13 && _loc_2 != 10))
                    {
                        _loc_3++;
                    }
                }
                if (_loc_3 == tagPos)
                {
                    return "";
                }
                return ToolSet.decodeXML(ToolSet.trimRight(source.substr(_loc_3, tagPos - _loc_3)));
            }
            return ToolSet.decodeXML(source.substr(lastTagEnd, tagPos - lastTagEnd));
        }// end function

        public static function hasAttribute(param1:Boolean) : Boolean
        {
            if (!attrParsed)
            {
                attributes = {};
                parseAttributes(attributes);
                attrParsed = true;
            }
            return attributes.ContainsKey(param1);
        }// end function

        public static function getAttribute(param1:String, param2:String = null) : String
        {
            if (!attrParsed)
            {
                attributes = {};
                parseAttributes(attributes);
                attrParsed = true;
            }
            var _loc_3:* = attributes[param1];
            if (_loc_3 != undefined)
            {
                return _loc_3.toString();
            }
            return param2;
        }// end function

        public static function getAttributeInt(param1:String, param2:int = 0) : int
        {
            var _loc_3:* = NaN;
            var _loc_4:* = getAttribute(param1);
            if (getAttribute(param1) == null || _loc_4.length == 0)
            {
                return param2;
            }
            if (_loc_4.charAt((_loc_4.length - 1)) == "%")
            {
                _loc_3 = XMLIterator.parseInt(_loc_4.substr(0, (_loc_4.length - 1)));
                if (XMLIterator.isNaN(_loc_3))
                {
                    return 0;
                }
                return _loc_3 / 100 * param2;
            }
            _loc_3 = XMLIterator.parseInt(_loc_4);
            if (XMLIterator.isNaN(_loc_3))
            {
                return 0;
            }
            return _loc_3;
        }// end function

        public static function getAttributeFloat(param1:String, param2:Number = 0) : Number
        {
            var _loc_3:* = NaN;
            var _loc_4:* = getAttribute(param1);
            if (getAttribute(param1) == null || _loc_4.length == 0)
            {
                return param2;
            }
            if (_loc_4.charAt((_loc_4.length - 1)) == "%")
            {
                _loc_3 = XMLIterator.parseFloat(_loc_4.substr(0, (_loc_4.length - 1)));
                if (XMLIterator.isNaN(_loc_3))
                {
                    return 0;
                }
                return _loc_3 / 100 * param2;
            }
            _loc_3 = XMLIterator.parseFloat(_loc_4);
            if (XMLIterator.isNaN(_loc_3))
            {
                return 0;
            }
            return _loc_3;
        }// end function

        public static function getAttributeBool(param1:String, param2:Boolean) : Boolean
        {
            var _loc_3:* = getAttribute(param1);
            if (_loc_3 == null || _loc_3.length == 0)
            {
                return param2;
            }
            return _loc_3 == "true";
        }// end function

        public static function getAttributes() : Object
        {
            var _loc_1:* = {};
            if (attrParsed)
            {
                for (_loc_2 in attributes)
                {
                    
                    _loc_1[_loc_2] = _loc_3[_loc_2];
                }
            }
            else
            {
                parseAttributes(_loc_1);
            }
            return _loc_1;
        }// end function

        private static function parseAttributes(param1:Object) : void
        {
            var _loc_11:* = null;
            var _loc_2:* = 0;
            var _loc_6:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_8:* = 0;
            var _loc_12:* = 0;
            var _loc_5:* = false;
            var _loc_7:* = tagPos;
            var _loc_10:* = tagPos + tagLength;
            var _loc_9:* = "";
            if (_loc_7 < _loc_10 && source.charCodeAt(_loc_7) == 60)
            {
                while (_loc_7 < _loc_10)
                {
                    
                    _loc_4 = source.charCodeAt(_loc_7);
                    if (!(_loc_4 == 32 || _loc_4 == 9 || _loc_4 == 10 || _loc_4 == 13 || _loc_4 == 62 || _loc_4 == 47))
                    {
                        _loc_7++;
                    }
                }
            }
            while (_loc_7 < _loc_10)
            {
                
                _loc_4 = source.charCodeAt(_loc_7);
                if (_loc_4 == 61)
                {
                    _loc_2 = -1;
                    _loc_6 = -1;
                    _loc_3 = 0;
                    _loc_8 = _loc_7 + 1;
                    while (_loc_8 < _loc_10)
                    {
                        
                        _loc_12 = source.charCodeAt(_loc_8);
                        if (_loc_12 == 32 || _loc_12 == 9 && _loc_12 == 13 || _loc_12 == 10)
                        {
                            if (_loc_2 != -1 && _loc_3 == 0)
                            {
                                _loc_6 = _loc_8 - 1;
                                break;
                            }
                        }
                        else if (_loc_12 == 62)
                        {
                            if (_loc_3 == 0)
                            {
                                _loc_6 = _loc_8 - 1;
                                break;
                            }
                        }
                        else if (_loc_12 == 34)
                        {
                            if (_loc_2 != -1)
                            {
                                if (_loc_3 != 1)
                                {
                                    _loc_6 = _loc_8 - 1;
                                    break;
                                }
                            }
                            else
                            {
                                _loc_3 = 2;
                                _loc_2 = _loc_8 + 1;
                            }
                        }
                        else if (_loc_12 == 39)
                        {
                            if (_loc_2 != -1)
                            {
                                if (_loc_3 != 2)
                                {
                                    _loc_6 = _loc_8 - 1;
                                    break;
                                }
                            }
                            else
                            {
                                _loc_3 = 1;
                                _loc_2 = _loc_8 + 1;
                            }
                        }
                        else if (_loc_2 == -1)
                        {
                            _loc_2 = _loc_8;
                        }
                        _loc_8++;
                    }
                    if (_loc_2 != -1 && _loc_6 != -1)
                    {
                        _loc_11 = _loc_9;
                        if (lowerCaseName)
                        {
                            _loc_11 = _loc_11.toLowerCase();
                        }
                        _loc_9 = "";
                        param1[_loc_11] = ToolSet.decodeXML(source.substr(_loc_2, _loc_6 - _loc_2 + 1));
                        _loc_7 = _loc_6 + 1;
                    }
                    else
                    {
                        break;
                    }
                }
                else if (_loc_4 != 32 && _loc_4 != 9 && _loc_4 != 13 && _loc_4 != 10)
                {
                    if (_loc_5 || _loc_4 == 47 || _loc_4 == 62)
                    {
                        if (_loc_9.length > 0)
                        {
                            _loc_11 = _loc_9;
                            if (lowerCaseName)
                            {
                                _loc_11 = _loc_11.toLowerCase();
                            }
                            param1[_loc_11] = "";
                            _loc_9 = "";
                        }
                        _loc_5 = false;
                    }
                    if (_loc_4 != 47 && _loc_4 != 62)
                    {
                        _loc_9 = _loc_9 + String.fromCharCode(_loc_4);
                    }
                }
                else if (_loc_9.length > 0)
                {
                    _loc_5 = true;
                }
                _loc_7++;
            }
            return;
        }// end function

    }
}
