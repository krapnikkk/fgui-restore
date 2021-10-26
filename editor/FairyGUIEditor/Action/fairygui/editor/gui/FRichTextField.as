package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.gui.text.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;

    public class FRichTextField extends FTextField
    {
        private var _objectsContainer:Sprite;
        private var _ALinkFormat:TextFormat;
        private var _elements:Vector.<FHtmlElement>;
        private var _nodes:Vector.<FHtmlNode>;
        private var _hasLink:Boolean;
        private var _linkButtonCache:Vector.<FLinkButton>;
        private var _nodeCache:Vector.<FHtmlNode>;

        public function FRichTextField()
        {
            this._objectType = FObjectType.RICHTEXT;
            this._objectsContainer = new Sprite();
            this._objectsContainer.mouseEnabled = false;
            _displayObject.container.addChild(this._objectsContainer);
            this._ALinkFormat = new TextFormat();
            this._ALinkFormat.underline = true;
            this._ALinkFormat.url = "#";
            this._elements = new Vector.<FHtmlElement>;
            this._nodes = new Vector.<FHtmlNode>;
            this._linkButtonCache = new Vector.<FLinkButton>;
            this._nodeCache = new Vector.<FHtmlNode>;
            return;
        }// end function

        public function updateRichText(param1:String) : void
        {
            var _loc_2:* = 0;
            var _loc_4:* = null;
            this.destroyNodes();
            this._elements.length = 0;
            _textField.htmlText = "";
            _textField.defaultTextFormat = _textFormat;
            if (!_text.length)
            {
                this.updateSize();
                return;
            }
            if (_ubbEnabled)
            {
                param1 = UBBParser.inst.parse(param1);
            }
            _textField.defaultTextFormat = _textFormat;
            _textField.text = this.parseHtml(param1);
            var _loc_3:* = this._elements.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = this._elements[_loc_2];
                if (_loc_4.textformat && _loc_4.end > _loc_4.start)
                {
                    _textField.setTextFormat(_loc_4.textformat, _loc_4.start, _loc_4.end);
                }
                _loc_2++;
            }
            this.createNodes();
            return;
        }// end function

        override protected function updateSize(param1:Boolean = false) : void
        {
            var fromSizeChanged:* = param1;
            super.updateSize(fromSizeChanged);
            if (fromSizeChanged && this._hasLink)
            {
                this.destroyNodes();
                this.createNodes();
            }
            if (_displayObject.stage == null)
            {
                _displayObject.addEventListener(Event.ADDED_TO_STAGE, function (event:Event) : void
            {
                adjustNodes();
                return;
            }// end function
            , false, 0, true);
            }
            else
            {
                this.adjustNodes();
            }
            return;
        }// end function

        override protected function doAlign() : void
        {
            super.doAlign();
            this._objectsContainer.y = _yOffset;
            return;
        }// end function

        override public function get deprecated() : Boolean
        {
            var _loc_4:* = null;
            var _loc_1:* = super.deprecated;
            if (_loc_1)
            {
                return _loc_1;
            }
            var _loc_2:* = this._nodes.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._nodes[_loc_3];
                if (_loc_4.displayObject && _loc_4.element.tag == "img")
                {
                    if (FSprite(_loc_4.displayObject).owner.validate(true))
                    {
                        return true;
                    }
                }
                _loc_3++;
            }
            return false;
        }// end function

        override protected function handleDispose() : void
        {
            super.handleDispose();
            this.destroyNodes();
            return;
        }// end function

        private function parseHtml(param1:String) : String
        {
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = false;
            XMLIterator.begin(param1, true);
            var _loc_5:* = "";
            var _loc_9:* = false;
            while (XMLIterator.nextTag())
            {
                
                if (_loc_2 == 0)
                {
                    _loc_4 = XMLIterator.getText(_loc_3);
                    if (_loc_4.length > 0)
                    {
                        if (_loc_9 && _loc_4.charCodeAt(0) == 10)
                        {
                            _loc_5 = _loc_5 + _loc_4.substr(1);
                        }
                        else
                        {
                            _loc_5 = _loc_5 + _loc_4;
                        }
                    }
                }
                _loc_9 = false;
                switch(XMLIterator.tagName)
                {
                    case "b":
                    {
                        if (XMLIterator.tagType == XMLIterator.TAG_START)
                        {
                            _loc_6 = new TextFormat();
                            _loc_6.bold = true;
                            _loc_8 = new FHtmlElement();
                            _loc_8.tag = XMLIterator.tagName;
                            _loc_8.start = _loc_5.length;
                            _loc_8.end = -1;
                            _loc_8.textformat = _loc_6;
                            this._elements.push(_loc_8);
                        }
                        else if (XMLIterator.tagType == XMLIterator.TAG_END)
                        {
                            _loc_8 = this.findStartTag(XMLIterator.tagName);
                            if (_loc_8)
                            {
                                _loc_8.end = _loc_5.length;
                            }
                        }
                        break;
                    }
                    case "i":
                    {
                        if (XMLIterator.tagType == XMLIterator.TAG_START)
                        {
                            _loc_8 = new FHtmlElement();
                            _loc_8.tag = XMLIterator.tagName;
                            _loc_8.start = _loc_5.length;
                            _loc_8.end = -1;
                            this._elements.push(_loc_8);
                            _loc_6 = new TextFormat();
                            _loc_6.italic = true;
                            _loc_8.textformat = _loc_6;
                        }
                        else if (XMLIterator.tagType == XMLIterator.TAG_END)
                        {
                            _loc_8 = this.findStartTag(XMLIterator.tagName);
                            if (_loc_8)
                            {
                                _loc_8.end = _loc_5.length;
                            }
                        }
                        break;
                    }
                    case "u":
                    {
                        if (XMLIterator.tagType == XMLIterator.TAG_START)
                        {
                            _loc_8 = new FHtmlElement();
                            _loc_8.tag = XMLIterator.tagName;
                            _loc_8.start = _loc_5.length;
                            _loc_8.end = -1;
                            this._elements.push(_loc_8);
                            _loc_6 = new TextFormat();
                            _loc_6.underline = true;
                            _loc_8.textformat = _loc_6;
                        }
                        else if (XMLIterator.tagType == XMLIterator.TAG_END)
                        {
                            _loc_8 = this.findStartTag(XMLIterator.tagName);
                            if (_loc_8)
                            {
                                _loc_8.end = _loc_5.length;
                            }
                        }
                        break;
                    }
                    case "font":
                    {
                        if (XMLIterator.tagType == XMLIterator.TAG_START)
                        {
                            _loc_8 = new FHtmlElement();
                            _loc_8.tag = XMLIterator.tagName;
                            _loc_8.start = _loc_5.length;
                            _loc_8.end = -1;
                            this._elements.push(_loc_8);
                            _loc_6 = new TextFormat();
                            _loc_10 = XMLIterator.getAttributeInt("size", -1);
                            if (_loc_10 > 0)
                            {
                                _loc_6.size = _loc_10;
                                if (_loc_10 > _maxFontSize)
                                {
                                    _maxFontSize = _loc_10;
                                }
                            }
                            _loc_11 = XMLIterator.getAttribute("color");
                            if (_loc_11 != null)
                            {
                                _loc_6.color = UtilsStr.convertFromHtmlColor(_loc_11);
                            }
                            _loc_8.textformat = _loc_6;
                        }
                        else if (XMLIterator.tagType == XMLIterator.TAG_END)
                        {
                            _loc_8 = this.findStartTag(XMLIterator.tagName);
                            if (_loc_8)
                            {
                                _loc_8.end = _loc_5.length;
                            }
                        }
                        break;
                    }
                    case "br":
                    {
                        _loc_5 = _loc_5 + "\n";
                        break;
                    }
                    case "img":
                    {
                        if (XMLIterator.tagType == XMLIterator.TAG_START || XMLIterator.tagType == XMLIterator.TAG_VOID)
                        {
                            _loc_12 = XMLIterator.getAttribute("src");
                            if (_loc_12)
                            {
                                _loc_8 = new FHtmlElement();
                                _loc_8.tag = XMLIterator.tagName;
                                _loc_8.start = _loc_5.length;
                                _loc_8.end = _loc_8.start + 1;
                                _loc_8.text = _loc_12;
                                _loc_13 = _pkg.project.getItemByURL(_loc_12);
                                if (_loc_13)
                                {
                                    _loc_8.width = _loc_13.width;
                                    _loc_8.height = _loc_13.height;
                                }
                                _loc_8.width = XMLIterator.getAttributeInt("width", _loc_8.width);
                                _loc_8.height = XMLIterator.getAttributeInt("height", _loc_8.height);
                                this._elements.push(_loc_8);
                                _loc_6 = new TextFormat();
                                _loc_6.font = _textFormat.font;
                                _loc_10 = CharSize.getFontSizeByHeight(_loc_8.height, _loc_6.font);
                                _loc_6.size = _loc_10;
                                if (_loc_10 > _maxFontSize)
                                {
                                    _maxFontSize = _loc_10;
                                }
                                _loc_6.bold = false;
                                _loc_6.italic = false;
                                _loc_6.letterSpacing = _loc_8.width + 4 - CharSize.getHolderWidth(_loc_6.font, int(_loc_6.size));
                                _loc_8.textformat = _loc_6;
                                _loc_5 = _loc_5 + "　";
                            }
                        }
                        break;
                    }
                    case "a":
                    {
                        if (XMLIterator.tagType == XMLIterator.TAG_START)
                        {
                            _loc_8 = new FHtmlElement();
                            _loc_8.tag = XMLIterator.tagName;
                            _loc_8.start = _loc_5.length;
                            _loc_8.end = -1;
                            _loc_8.text = XMLIterator.getAttribute("href");
                            _loc_8.textformat = this._ALinkFormat;
                            this._elements.push(_loc_8);
                        }
                        else if (XMLIterator.tagType == XMLIterator.TAG_END)
                        {
                            _loc_8 = this.findStartTag(XMLIterator.tagName);
                            if (_loc_8)
                            {
                                _loc_8.end = _loc_5.length;
                            }
                        }
                        break;
                    }
                    case "p":
                    {
                        if (XMLIterator.tagType == XMLIterator.TAG_START)
                        {
                            if (_loc_5.length && _loc_5.charCodeAt((_loc_5.length - 1)) != 10)
                            {
                                _loc_5 = _loc_5 + "\n";
                            }
                            _loc_4 = XMLIterator.getAttribute("align");
                            if (_loc_4 == "center" || _loc_4 == "right")
                            {
                                _loc_8 = new FHtmlElement();
                                _loc_8.tag = XMLIterator.tagName;
                                _loc_8.start = _loc_5.length;
                                _loc_8.end = -1;
                                this._elements.push(_loc_8);
                                _loc_6 = new TextFormat();
                                _loc_6.align = _loc_4;
                                _loc_8.textformat = _loc_6;
                            }
                        }
                        else if (XMLIterator.tagType == XMLIterator.TAG_END)
                        {
                            _loc_5 = _loc_5 + "\n";
                            _loc_9 = true;
                            _loc_8 = this.findStartTag(XMLIterator.tagName);
                            if (_loc_8)
                            {
                                _loc_8.end = _loc_5.length;
                            }
                        }
                        break;
                    }
                    case "ui":
                    case "div":
                    case "li":
                    {
                        if (XMLIterator.tagType == XMLIterator.TAG_START)
                        {
                            if (_loc_5.length && _loc_5.charCodeAt((_loc_5.length - 1)) != 10)
                            {
                                _loc_5 = _loc_5 + "\n";
                            }
                        }
                        else if (XMLIterator.tagType == XMLIterator.TAG_END)
                        {
                            _loc_5 = _loc_5 + "\n";
                            _loc_9 = true;
                        }
                        break;
                    }
                    case "html":
                    case "body":
                    {
                        _loc_3 = true;
                        break;
                    }
                    case "input":
                    case "select":
                    case "head":
                    case "style":
                    case "script":
                    case "form":
                    {
                        if (XMLIterator.tagType == XMLIterator.TAG_START)
                        {
                            _loc_2++;
                        }
                        else if (XMLIterator.tagType == XMLIterator.TAG_END)
                        {
                            _loc_2 = _loc_2 - 1;
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            if (_loc_2 == 0)
            {
                _loc_4 = XMLIterator.getText(_loc_3);
                if (_loc_4.length > 0)
                {
                    if (_loc_9 && _loc_4.charCodeAt(0) == 10)
                    {
                        _loc_5 = _loc_5 + _loc_4.substr(1);
                    }
                    else
                    {
                        _loc_5 = _loc_5 + _loc_4;
                    }
                }
            }
            return _loc_5;
        }// end function

        private function createNodes() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_1:* = this._elements.length;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._elements[_loc_2];
                if (_loc_3.tag == "a")
                {
                    if ((_flags & FObjectFlags.IN_TEST) != 0)
                    {
                        _loc_4 = _loc_3.start;
                        _loc_3.end = (_loc_3.end - 1);
                        if (_loc_3.end < 0)
                        {
                            return;
                        }
                        this._hasLink = true;
                        _loc_6 = _textField.getLineIndexOfChar(_loc_4);
                        _loc_7 = _textField.getLineIndexOfChar(_loc_3.end);
                        if (_loc_6 == _loc_7)
                        {
                            this.createLinkButton(_loc_4, _loc_5, _loc_3);
                        }
                        else
                        {
                            _loc_8 = _textField.getLineOffset(_loc_6);
                            this.createLinkButton(_loc_4, _loc_8 + _textField.getLineLength(_loc_6) - 1, _loc_3);
                            _loc_9 = _loc_6 + 1;
                            while (_loc_9 < _loc_7)
                            {
                                
                                _loc_8 = _textField.getLineOffset(_loc_9);
                                this.createLinkButton(_loc_8, _loc_8 + _textField.getLineLength(_loc_9) - 1, _loc_3);
                                _loc_9++;
                            }
                            this.createLinkButton(_textField.getLineOffset(_loc_7), _loc_5, _loc_3);
                        }
                    }
                }
                else if (_loc_3.tag == "img")
                {
                    _loc_10 = this.createNode();
                    _loc_10.charStart = _loc_3.start;
                    _loc_10.charEnd = _loc_3.start;
                    _loc_10.element = _loc_3;
                }
                _loc_2++;
            }
            return;
        }// end function

        private function createNode() : FHtmlNode
        {
            var _loc_1:* = null;
            if (this._nodeCache.length)
            {
                _loc_1 = this._nodeCache.pop();
            }
            else
            {
                _loc_1 = new FHtmlNode();
            }
            this._nodes.push(_loc_1);
            return _loc_1;
        }// end function

        private function createLinkButton(param1:int, param2:int, param3:FHtmlElement) : void
        {
            param1 = this.skipLeftCR(param1, param2);
            param2 = this.skipRightCR(param1, param2);
            var _loc_4:* = this.createNode();
            _loc_4.charStart = param1;
            _loc_4.charEnd = param2;
            _loc_4.element = param3;
            return;
        }// end function

        private function destroyNodes() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this._nodes.length;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._nodes[_loc_2];
                if (_loc_3.displayObject != null)
                {
                    if (_loc_3.displayObject.parent != null)
                    {
                        this._objectsContainer.removeChild(_loc_3.displayObject);
                    }
                    if (_loc_3.element.tag == "a")
                    {
                        this._linkButtonCache.push(_loc_3.displayObject);
                    }
                    else if (_loc_3.element.tag == "img")
                    {
                        FSprite(_loc_3.displayObject).owner.dispose();
                    }
                }
                _loc_3.reset();
                this._nodeCache.push(_loc_3);
                _loc_2++;
            }
            this._nodes.length = 0;
            this._hasLink = false;
            this._objectsContainer.removeChildren();
            return;
        }// end function

        private function adjustNodes() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_1:* = this._nodes.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_1)
            {
                
                _loc_6 = this._nodes[_loc_5];
                _loc_7 = _loc_6.element;
                if (_loc_7.tag == "a")
                {
                    if (_loc_6.displayObject == null)
                    {
                        if (this._linkButtonCache.length)
                        {
                            _loc_10 = this._linkButtonCache.pop();
                        }
                        else
                        {
                            _loc_10 = new FLinkButton();
                        }
                        _loc_10.owner = _loc_6;
                        _loc_6.displayObject = _loc_10;
                    }
                    _loc_2 = _textField.getCharBoundaries(_loc_6.charStart);
                    if (_loc_2 == null)
                    {
                        return;
                    }
                    _loc_3 = _textField.getCharBoundaries(_loc_6.charEnd);
                    if (_loc_3 == null)
                    {
                        return;
                    }
                    _loc_4 = _textField.getLineIndexOfChar(_loc_6.charStart);
                    _loc_8 = _textField.getLineMetrics(_loc_4);
                    _loc_9 = _loc_3.right - _loc_2.left;
                    if (_loc_2.left + _loc_9 > _textField.width - 2)
                    {
                        _loc_9 = _textField.width - _loc_2.left - 2;
                    }
                    _loc_6.displayObject.x = _loc_2.left;
                    FLinkButton(_loc_6.displayObject).setSize(_loc_9, _loc_8.height);
                    if (_loc_2.top < _loc_3.top)
                    {
                        _loc_6.topY = 0;
                    }
                    else
                    {
                        _loc_6.topY = _loc_3.top - _loc_2.top;
                    }
                    _loc_6.displayObject.y = _loc_2.top + _loc_6.topY;
                    if (this.isLineVisible(_loc_4))
                    {
                        if (_loc_6.displayObject.parent == null)
                        {
                            this._objectsContainer.addChild(_loc_6.displayObject);
                        }
                    }
                    else if (_loc_6.displayObject.parent)
                    {
                        this._objectsContainer.removeChild(_loc_6.displayObject);
                    }
                }
                else if (_loc_7.tag == "img")
                {
                    if (_loc_6.displayObject == null)
                    {
                        _loc_12 = FLoader(FObjectFactory.createObject2(this._pkg, "loader", null, _flags & 255));
                        _loc_12.fill = "scaleFree";
                        _loc_12.setSize(_loc_7.width, _loc_7.height);
                        _loc_12.url = _loc_7.text;
                        _loc_6.displayObject = _loc_12.displayObject;
                    }
                    _loc_2 = _textField.getCharBoundaries(_loc_6.charStart);
                    if (_loc_2 == null)
                    {
                        return;
                    }
                    _loc_4 = _textField.getLineIndexOfChar(_loc_6.charStart);
                    _loc_11 = _textField.getLineMetrics(_loc_4);
                    if (_loc_11 == null)
                    {
                        return;
                    }
                    _loc_6.displayObject.x = _loc_2.left + 2;
                    if (_loc_7.height < _loc_11.ascent)
                    {
                        _loc_6.displayObject.y = _loc_2.top + _loc_11.ascent - _loc_7.height;
                    }
                    else
                    {
                        _loc_6.displayObject.y = _loc_2.bottom - _loc_7.height;
                    }
                    if (this.isLineVisible(_loc_4) && _loc_6.displayObject.x + _loc_6.displayObject.width < _textField.width - 2)
                    {
                        if (_loc_6.displayObject.parent == null)
                        {
                            this._objectsContainer.addChildAt(_loc_6.displayObject, this._objectsContainer.numChildren);
                        }
                    }
                    else if (_loc_6.displayObject.parent)
                    {
                        this._objectsContainer.removeChild(_loc_6.displayObject);
                    }
                }
                _loc_5++;
            }
            return;
        }// end function

        private function findStartTag(param1:String) : FHtmlElement
        {
            var _loc_4:* = null;
            var _loc_2:* = this._elements.length;
            var _loc_3:* = _loc_2 - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_4 = this._elements[_loc_3];
                if (_loc_4.tag == param1 && _loc_4.end == -1)
                {
                    return _loc_4;
                }
                _loc_3 = _loc_3 - 1;
            }
            return null;
        }// end function

        private function isLineVisible(param1:int) : Boolean
        {
            return param1 >= (_textField.scrollV - 1) && param1 <= (_textField.bottomScrollV - 1);
        }// end function

        private function skipLeftCR(param1:int, param2:int) : int
        {
            var _loc_5:* = null;
            var _loc_3:* = _textField.text;
            var _loc_4:* = param1;
            while (_loc_4 < param2)
            {
                
                _loc_5 = _loc_3.charAt(_loc_4);
                if (_loc_5 != "\r" && _loc_5 != "\n")
                {
                    break;
                }
                _loc_4++;
            }
            return _loc_4;
        }// end function

        private function skipRightCR(param1:int, param2:int) : int
        {
            var _loc_5:* = null;
            var _loc_3:* = _textField.text;
            var _loc_4:* = param2;
            while (_loc_4 > param1)
            {
                
                _loc_5 = _loc_3.charAt(_loc_4);
                if (_loc_5 != "\r" && _loc_5 != "\n")
                {
                    break;
                }
                _loc_4 = _loc_4 - 1;
            }
            return _loc_4;
        }// end function

    }
}
