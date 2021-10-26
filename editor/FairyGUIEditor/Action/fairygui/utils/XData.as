package fairygui.utils
{
    import *.*;
    import __AS3__.vec.*;
    import flash.system.*;

    public class XData extends Object
    {
        private var _children:Vector.<XData>;
        private var _xml:XML;

        public function XData()
        {
            return;
        }// end function

        public function getName() : String
        {
            return this._xml.name().localName;
        }// end function

        public function setName(param1:String) : void
        {
            this._xml.setLocalName(param1);
            return;
        }// end function

        public function getText() : String
        {
            return this._xml.text();
        }// end function

        public function setText(param1:String) : void
        {
            this._xml.setChildren(param1);
            return;
        }// end function

        public function getAttribute(param1:String, param2:String = null) : String
        {
            var _loc_3:* = this._xml.attribute(param1);
            if (_loc_3 && _loc_3.length())
            {
                return _loc_3.toString();
            }
            return param2;
        }// end function

        public function getAttributeInt(param1:String, param2:int = 0) : int
        {
            var _loc_3:* = this.getAttribute(param1);
            if (_loc_3 == null)
            {
                return param2;
            }
            return parseInt(_loc_3);
        }// end function

        public function getAttributeFloat(param1:String, param2:Number = 0) : Number
        {
            var _loc_3:* = this.getAttribute(param1);
            if (_loc_3 == null)
            {
                return param2;
            }
            return parseFloat(_loc_3);
        }// end function

        public function getAttributeBool(param1:String, param2:Boolean = false) : Boolean
        {
            var _loc_3:* = this.getAttribute(param1);
            if (_loc_3 == null)
            {
                return param2;
            }
            return _loc_3 == "true";
        }// end function

        public function getAttributeColor(param1:String, param2:Boolean, param3:uint = 0) : uint
        {
            var _loc_4:* = this.getAttribute(param1);
            if (this.getAttribute(param1) == null)
            {
                return param3;
            }
            return UtilsStr.convertFromHtmlColor(_loc_4, param2);
        }// end function

        public function setAttribute(param1:String, param2) : void
        {
            this._xml[param1] = param2;
            return;
        }// end function

        public function removeAttribute(param1:String) : void
        {
            delete this._xml[param1];
            return;
        }// end function

        public function hasAttribute(param1:String) : Boolean
        {
            var _loc_2:* = this._xml.attribute(param1);
            return _loc_2 && _loc_2.length() > 0;
        }// end function

        public function hasAttributes() : Boolean
        {
            return this._xml.attributes().length() > 0;
        }// end function

        private function buildChildrenList() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = this._xml.children();
            this._children = new Vector.<XData>;
            for each (_loc_2 in _loc_1)
            {
                
                _loc_3 = new XData();
                _loc_3._xml = _loc_2;
                this._children.push(_loc_3);
            }
            return;
        }// end function

        public function getChild(param1:String) : XData
        {
            var _loc_2:* = null;
            if (this._children == null)
            {
                this.buildChildrenList();
            }
            for each (_loc_2 in this._children)
            {
                
                if (_loc_2.getName() == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public function getChildAt(param1:int) : XData
        {
            if (this._children == null)
            {
                this.buildChildrenList();
            }
            if (param1 >= 0 && param1 < this._children.length)
            {
                return this._children[param1];
            }
            throw new Error("index out of bounds!");
        }// end function

        public function getChildren() : Vector.<XData>
        {
            if (this._children == null)
            {
                this.buildChildrenList();
            }
            return this._children;
        }// end function

        public function appendChild(param1:XData) : XData
        {
            var _loc_2:* = null;
            if (param1._xml.parent() == this._xml)
            {
                return param1;
            }
            this._xml.appendChild(param1._xml);
            if (this._children != null)
            {
                _loc_2 = new XData();
                _loc_2._xml = param1._xml;
                this._children.push(_loc_2);
            }
            return param1;
        }// end function

        public function removeChild(param1:XData) : void
        {
            var _loc_2:* = 0;
            if (param1._xml.parent() == this._xml)
            {
                delete this._xml.children()[param1._xml.childIndex()];
                if (this._children != null)
                {
                    _loc_2 = this._children.indexOf(param1);
                    if (_loc_2 != -1)
                    {
                        this._children.removeAt(_loc_2);
                    }
                }
            }
            return;
        }// end function

        public function removeChildAt(param1:int) : void
        {
            if (param1 >= 0 && param1 < this._xml.children().length())
            {
                delete this._xml.children()[param1];
                if (this._children != null)
                {
                    this._children.removeAt(param1);
                }
            }
            else
            {
                throw new Error("index out of bounds!");
            }
            return;
        }// end function

        public function removeChildren(param1:String = null) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            if (param1 == null)
            {
                this._xml.setChildren("");
                if (this._children != null)
                {
                    this._children.length = 0;
                }
            }
            else
            {
                _loc_2 = this._xml[param1];
                _loc_3 = _loc_2.length();
                if (_loc_3)
                {
                    _loc_4 = _loc_3;
                    while (_loc_4 >= 0)
                    {
                        
                        delete _loc_2[_loc_4];
                        if (this._children)
                        {
                            this._children.splice(_loc_4, 1);
                        }
                        _loc_4 = _loc_4 - 1;
                    }
                }
            }
            return;
        }// end function

        public function getEnumerator(param1:String = null) : XDataEnumerator
        {
            return new XDataEnumerator(this, param1);
        }// end function

        public function copy() : XData
        {
            var _loc_1:* = new XData();
            _loc_1._xml = this._xml.copy();
            return _loc_1;
        }// end function

        public function equals(param1:XData) : Boolean
        {
            return param1 && this._xml.toXMLString() == param1._xml.toXMLString();
        }// end function

        public function toXML() : XML
        {
            return this._xml;
        }// end function

        public function dispose() : void
        {
            if (this._xml)
            {
                System.disposeXML(this._xml);
                this._xml = null;
            }
            return;
        }// end function

        public static function parse(param1:String) : XData
        {
            var _loc_2:* = new XData;
            XML.ignoreWhitespace = true;
            _loc_2._xml = new XML(param1);
            return _loc_2;
        }// end function

        public static function create(param1:String) : XData
        {
            var _loc_2:* = new XData;
            _loc_2._xml = new XML("<" + param1 + "/>");
            return _loc_2;
        }// end function

        public static function attach(param1:XML) : XData
        {
            var _loc_2:* = new XData;
            _loc_2._xml = param1;
            return _loc_2;
        }// end function

    }
}
