package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.display.*;
    import fairygui.text.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.text.*;

    public class GRichTextField extends GTextField
    {
        private var _ALinkFormat:TextFormat;
        private var _AHoverFormat:TextFormat;
        private var _elements:Vector.<HtmlElement>;
        private var _nodes:Vector.<HtmlNode>;
        private var _objectsContainer:Sprite;
        private var _linkButtonCache:Vector.<LinkButton>;
        public static var objectFactory:IRichTextObjectFactory = new RichTextObjectFactory();
        private static var _nodeCache:Vector.<HtmlNode> = new Vector.<HtmlNode>;
        private static var _elementCache:Vector.<HtmlElement> = new Vector.<HtmlElement>;

        public function GRichTextField()
        {
            _ALinkFormat = new TextFormat();
            _ALinkFormat.underline = true;
            _AHoverFormat = new TextFormat();
            _AHoverFormat.underline = true;
            _elements = new Vector.<HtmlElement>;
            _nodes = new Vector.<HtmlNode>;
            _linkButtonCache = new Vector.<LinkButton>;
            return;
        }// end function

        public function get ALinkFormat() : TextFormat
        {
            return _ALinkFormat;
        }// end function

        public function set ALinkFormat(param1:TextFormat) : void
        {
            _ALinkFormat = param1;
            render();
            return;
        }// end function

        public function get AHoverFormat() : TextFormat
        {
            return _AHoverFormat;
        }// end function

        public function set AHoverFormat(param1:TextFormat) : void
        {
            _AHoverFormat = param1;
            return;
        }// end function

        override protected function createDisplayObject() : void
        {
            super.createDisplayObject();
            _textField.mouseEnabled = true;
            _objectsContainer = new Sprite();
            _objectsContainer.mouseEnabled = false;
            var _loc_1:* = new UISprite(this);
            _loc_1.mouseEnabled = false;
            _loc_1.addChild(_textField);
            _loc_1.addChild(_objectsContainer);
            setDisplayObject(_loc_1);
            return;
        }// end function

        override protected function updateTextFieldText(param1:String) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            destroyNodes();
            clearElements();
            _textField.htmlText = "";
            _textField.defaultTextFormat = _textFormat;
            if (!_text.length)
            {
                return;
            }
            if (_ubbEnabled)
            {
                param1 = UBBParser.inst.parse(param1);
            }
            _textField.text = parseHtml(param1);
            var _loc_2:* = _elements.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = _elements[_loc_3];
                if (_loc_4.textFormat && _loc_4.end > _loc_4.start)
                {
                    _textField.setTextFormat(_loc_4.textFormat, _loc_4.start, _loc_4.end);
                }
                _loc_3++;
            }
            createNodes();
            return;
        }// end function

        private function onAddedToStage(event:Event) : void
        {
            adjustNodes();
            return;
        }// end function

        override protected function doAlign() : void
        {
            super.doAlign();
            _objectsContainer.y = _yOffset;
            if (_objectsContainer.stage == null)
            {
                _objectsContainer.addEventListener("addedToStage", onAddedToStage, false, 0, true);
            }
            else
            {
                adjustNodes();
            }
            return;
        }// end function

        override public function dispose() : void
        {
            destroyNodes();
            super.dispose();
            return;
        }// end function

        private function parseHtml(param1:String) : String
        {
            var _loc_2:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_11:* = null;
            var _loc_8:* = 0;
            var _loc_6:* = null;
            var _loc_9:* = 0;
            var _loc_3:* = false;
            var _loc_7:* = "";
            var _loc_10:* = false;
            XMLIterator.begin(param1, true);
            while (XMLIterator.nextTag())
            {
                
                if (_loc_9 == 0)
                {
                    _loc_2 = XMLIterator.getText(_loc_3);
                    if (_loc_2.length > 0)
                    {
                        if (_loc_10 && _loc_2.charCodeAt(0) == 10)
                        {
                            _loc_7 = _loc_7 + _loc_2.substr(1);
                        }
                        else
                        {
                            _loc_7 = _loc_7 + _loc_2;
                        }
                    }
                }
                _loc_10 = false;
                var _loc_12:* = XMLIterator.tagName;
                while (_loc_12 === "b")
                {
                    
                    if (XMLIterator.tagType == 0)
                    {
                        _loc_4 = new TextFormat();
                        _loc_4.bold = true;
                        _loc_11 = createElement();
                        _loc_11.tag = XMLIterator.tagName;
                        _loc_11.start = _loc_7.length;
                        _loc_11.end = -1;
                        _loc_11.textFormat = _loc_4;
                    }
                    else if (XMLIterator.tagType == 1)
                    {
                        _loc_11 = findStartTag(XMLIterator.tagName);
                        if (_loc_11)
                        {
                            _loc_11.end = _loc_7.length;
                        }
                    }
                    do
                    {
                        
                        if (XMLIterator.tagType == 0)
                        {
                            _loc_11 = createElement();
                            _loc_11.tag = XMLIterator.tagName;
                            _loc_11.start = _loc_7.length;
                            _loc_11.end = -1;
                            _loc_4 = new TextFormat();
                            _loc_4.italic = true;
                            _loc_11.textFormat = _loc_4;
                        }
                        else if (XMLIterator.tagType == 1)
                        {
                            _loc_11 = findStartTag(XMLIterator.tagName);
                            if (_loc_11)
                            {
                                _loc_11.end = _loc_7.length;
                            }
                        }
                        do
                        {
                            
                            if (XMLIterator.tagType == 0)
                            {
                                _loc_11 = createElement();
                                _loc_11.tag = XMLIterator.tagName;
                                _loc_11.start = _loc_7.length;
                                _loc_11.end = -1;
                                _loc_4 = new TextFormat();
                                _loc_4.underline = true;
                                _loc_11.textFormat = _loc_4;
                            }
                            else if (XMLIterator.tagType == 1)
                            {
                                _loc_11 = findStartTag(XMLIterator.tagName);
                                if (_loc_11)
                                {
                                    _loc_11.end = _loc_7.length;
                                }
                            }
                            do
                            {
                                
                                if (XMLIterator.tagType == 0)
                                {
                                    _loc_11 = createElement();
                                    _loc_11.tag = XMLIterator.tagName;
                                    _loc_11.start = _loc_7.length;
                                    _loc_11.end = -1;
                                    _loc_4 = new TextFormat();
                                    _loc_8 = XMLIterator.getAttributeInt("size", -1);
                                    if (_loc_8 > 0)
                                    {
                                        _loc_4.size = _loc_8;
                                        if (_loc_8 > _maxFontSize)
                                        {
                                            _maxFontSize = _loc_8;
                                        }
                                    }
                                    _loc_2 = XMLIterator.getAttribute("color");
                                    if (_loc_2)
                                    {
                                        _loc_4.color = ToolSet.convertFromHtmlColor(_loc_2);
                                    }
                                    _loc_2 = XMLIterator.getAttribute("align");
                                    if (_loc_2)
                                    {
                                        _loc_4.align = _loc_2;
                                    }
                                    _loc_11.textFormat = _loc_4;
                                }
                                else if (XMLIterator.tagType == 1)
                                {
                                    _loc_11 = findStartTag(XMLIterator.tagName);
                                    if (_loc_11)
                                    {
                                        _loc_11.end = _loc_7.length;
                                    }
                                }
                                do
                                {
                                    
                                    _loc_7 = _loc_7 + "\n";
                                    do
                                    {
                                        
                                        if (XMLIterator.tagType == 0 || XMLIterator.tagType == 2)
                                        {
                                            _loc_2 = XMLIterator.getAttribute("src");
                                            if (_loc_2)
                                            {
                                                _loc_11 = createElement();
                                                _loc_11.tag = XMLIterator.tagName;
                                                _loc_11.start = _loc_7.length;
                                                _loc_11.end = _loc_11.start + 1;
                                                _loc_11.text = _loc_2;
                                                _loc_6 = UIPackage.getItemByURL(_loc_2);
                                                if (_loc_6)
                                                {
                                                    _loc_11.width = _loc_6.width;
                                                    _loc_11.height = _loc_6.height;
                                                }
                                                _loc_11.width = XMLIterator.getAttributeInt("width", _loc_11.width);
                                                _loc_11.height = XMLIterator.getAttributeInt("height", _loc_11.height);
                                                _loc_4 = new TextFormat();
                                                _loc_4.font = _textFormat.font;
                                                _loc_8 = CharSize.getFontSizeByHeight(_loc_11.height, _loc_4.font);
                                                _loc_4.size = _loc_8;
                                                if (_loc_8 > _maxFontSize)
                                                {
                                                    _maxFontSize = _loc_8;
                                                }
                                                _loc_4.bold = false;
                                                _loc_4.italic = false;
                                                _loc_4.letterSpacing = _loc_11.width + 4 - CharSize.getHolderWidth(_loc_4.font, _loc_4.size);
                                                _loc_11.textFormat = _loc_4;
                                                _loc_7 = _loc_7 + "　";
                                            }
                                        }
                                        do
                                        {
                                            
                                            if (XMLIterator.tagType == 0)
                                            {
                                                _loc_11 = createElement();
                                                _loc_11.tag = XMLIterator.tagName;
                                                _loc_11.start = _loc_7.length;
                                                _loc_11.end = -1;
                                                _loc_11.text = XMLIterator.getAttribute("href");
                                                _loc_11.textFormat = _ALinkFormat;
                                            }
                                            else if (XMLIterator.tagType == 1)
                                            {
                                                _loc_11 = findStartTag(XMLIterator.tagName);
                                                if (_loc_11)
                                                {
                                                    _loc_11.end = _loc_7.length;
                                                }
                                            }
                                            do
                                            {
                                                
                                                if (XMLIterator.tagType == 0)
                                                {
                                                    if (_loc_7.length && _loc_7.charCodeAt((_loc_7.length - 1)) != 10)
                                                    {
                                                        _loc_7 = _loc_7 + "\n";
                                                    }
                                                    _loc_2 = XMLIterator.getAttribute("align");
                                                    if (_loc_2 == "center" || _loc_2 == "right")
                                                    {
                                                        _loc_11 = createElement();
                                                        _loc_11.tag = XMLIterator.tagName;
                                                        _loc_11.start = _loc_7.length;
                                                        _loc_11.end = -1;
                                                        _loc_4 = new TextFormat();
                                                        _loc_4.align = _loc_2;
                                                        _loc_11.textFormat = _loc_4;
                                                    }
                                                }
                                                else if (XMLIterator.tagType == 1)
                                                {
                                                    _loc_7 = _loc_7 + "\n";
                                                    _loc_10 = true;
                                                    _loc_11 = findStartTag(XMLIterator.tagName);
                                                    if (_loc_11)
                                                    {
                                                        _loc_11.end = _loc_7.length;
                                                    }
                                                }
                                                do
                                                {
                                                    
                                                    
                                                    
                                                    if (XMLIterator.tagType == 0)
                                                    {
                                                        if (_loc_7.length && _loc_7.charCodeAt((_loc_7.length - 1)) != 10)
                                                        {
                                                            _loc_7 = _loc_7 + "\n";
                                                        }
                                                    }
                                                    else if (XMLIterator.tagType == 1)
                                                    {
                                                        _loc_7 = _loc_7 + "\n";
                                                        _loc_10 = true;
                                                    }
                                                    do
                                                    {
                                                        
                                                        
                                                        _loc_3 = true;
                                                        do
                                                        {
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            if (XMLIterator.tagType == 0)
                                                            {
                                                                _loc_9++;
                                                            }
                                                            else if (XMLIterator.tagType == 1)
                                                            {
                                                                _loc_9--;
                                                            }
                                                            break;
                                                        }
                                                    }while (_loc_12 === "i")
                                                }while (_loc_12 === "u")
                                            }while (_loc_12 === "font")
                                        }while (_loc_12 === "br")
                                    }while (_loc_12 === "img")
                                }while (_loc_12 === "a")
                            }while (_loc_12 === "p")
                        }while (_loc_12 === "ui")
                        if ("div" === _loc_12) goto 1391;
                        if ("li" === _loc_12) goto 1392;
                    }while (_loc_12 === "html")
                    if ("body" === _loc_12) goto 1475;
                }while (_loc_12 === "input")
                if ("select" === _loc_12) goto 1483;
                if ("head" === _loc_12) goto 1484;
                if ("style" === _loc_12) goto 1485;
                if ("script" === _loc_12) goto 1486;
                if ("form" === _loc_12) goto 1487;
            }
            if (_loc_9 == 0)
            {
                _loc_2 = XMLIterator.getText(_loc_3);
                if (_loc_2.length > 0)
                {
                    if (_loc_10 && _loc_2.charCodeAt(0) == 10)
                    {
                        _loc_7 = _loc_7 + _loc_2.substr(1);
                    }
                    else
                    {
                        _loc_7 = _loc_7 + _loc_2;
                    }
                }
            }
            return _loc_7;
        }// end function

        private function createElement() : HtmlElement
        {
            var _loc_1:* = null;
            if (_elementCache.length)
            {
                _loc_1 = _elementCache.pop();
            }
            else
            {
                _loc_1 = new HtmlElement();
            }
            _elements.push(_loc_1);
            return _loc_1;
        }// end function

        private function createNodes() : void
        {
            var _loc_5:* = 0;
            var _loc_10:* = null;
            var _loc_4:* = 0;
            var _loc_6:* = 0;
            var _loc_9:* = 0;
            var _loc_8:* = 0;
            var _loc_2:* = 0;
            var _loc_7:* = 0;
            var _loc_1:* = null;
            var _loc_3:* = _elements.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_10 = _elements[_loc_5];
                if (_loc_10.tag == "a")
                {
                    _loc_4 = _loc_10.start;
                    _loc_10.end = (_loc_10.end - 1);
                    if (_loc_10.end < 0)
                    {
                        return;
                    }
                    _loc_9 = _textField.getLineIndexOfChar(_loc_4);
                    _loc_8 = _textField.getLineIndexOfChar(_loc_10.end);
                    if (_loc_9 == _loc_8)
                    {
                        createLinkButton(_loc_4, _loc_6, _loc_10);
                    }
                    else
                    {
                        _loc_2 = _textField.getLineOffset(_loc_9);
                        createLinkButton(_loc_4, _loc_2 + _textField.getLineLength(_loc_9) - 1, _loc_10);
                        _loc_7 = _loc_9 + 1;
                        while (_loc_7 < _loc_8)
                        {
                            
                            _loc_2 = _textField.getLineOffset(_loc_7);
                            createLinkButton(_loc_2, _loc_2 + _textField.getLineLength(_loc_7) - 1, _loc_10);
                            _loc_7++;
                        }
                        createLinkButton(_textField.getLineOffset(_loc_8), _loc_6, _loc_10);
                    }
                }
                else if (_loc_10.tag == "img")
                {
                    _loc_1 = createNode();
                    _loc_1.charStart = _loc_10.start;
                    _loc_1.charEnd = _loc_10.start;
                    _loc_1.element = _loc_10;
                }
                _loc_5++;
            }
            return;
        }// end function

        private function createNode() : HtmlNode
        {
            var _loc_1:* = null;
            if (_nodeCache.length)
            {
                _loc_1 = _nodeCache.pop();
            }
            else
            {
                _loc_1 = new HtmlNode();
            }
            _nodes.push(_loc_1);
            return _loc_1;
        }// end function

        private function createLinkButton(param1:int, param2:int, param3:HtmlElement) : void
        {
            param1 = skipLeftCR(param1, param2);
            param2 = skipRightCR(param1, param2);
            var _loc_4:* = createNode();
            _loc_4.charStart = param1;
            _loc_4.charEnd = param2;
            _loc_4.element = param3;
            return;
        }// end function

        private function clearElements() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_1:* = _elements.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = _elements[_loc_2];
                _loc_3.textFormat = null;
                _loc_3.text = null;
                _loc_3.tag = null;
                _elementCache.push(_loc_3);
                _loc_2++;
            }
            _elements.length = 0;
            return;
        }// end function

        private function destroyNodes() : void
        {
            var _loc_3:* = 0;
            var _loc_1:* = null;
            var _loc_2:* = _nodes.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1 = _nodes[_loc_3];
                if (_loc_1.displayObject != null)
                {
                    if (_loc_1.displayObject.parent != null)
                    {
                        _objectsContainer.removeChild(_loc_1.displayObject);
                    }
                    if (_loc_1.element.tag == "a")
                    {
                        _linkButtonCache.push(_loc_1.displayObject);
                    }
                    else if (_loc_1.element.tag == "img")
                    {
                        objectFactory.freeObject(_loc_1.displayObject);
                    }
                }
                _loc_1.reset();
                _nodeCache.push(_loc_1);
                _loc_3++;
            }
            _nodes.length = 0;
            _objectsContainer.removeChildren();
            return;
        }// end function

        private function adjustNodes() : void
        {
            var _loc_7:* = null;
            var _loc_10:* = null;
            var _loc_3:* = 0;
            var _loc_8:* = 0;
            var _loc_1:* = null;
            var _loc_12:* = null;
            var _loc_11:* = null;
            var _loc_2:* = null;
            var _loc_5:* = 0;
            var _loc_4:* = null;
            var _loc_9:* = null;
            var _loc_6:* = _nodes.length;
            _loc_8 = 0;
            while (_loc_8 < _loc_6)
            {
                
                _loc_1 = _nodes[_loc_8];
                _loc_12 = _loc_1.element;
                if (_loc_12.tag == "a")
                {
                    if (_loc_1.displayObject == null)
                    {
                        if (_linkButtonCache.length)
                        {
                            _loc_11 = _linkButtonCache.pop();
                        }
                        else
                        {
                            _loc_11 = new LinkButton();
                            _loc_11.addEventListener("rollOver", onLinkRollOver);
                            _loc_11.addEventListener("rollOut", onLinkRollOut);
                            _loc_11.addEventListener("click", onLinkClick);
                        }
                        _loc_11.owner = _loc_1;
                        _loc_1.displayObject = _loc_11;
                    }
                    _loc_7 = _textField.getCharBoundaries(_loc_1.charStart);
                    if (_loc_7 == null)
                    {
                        return;
                    }
                    _loc_10 = _textField.getCharBoundaries(_loc_1.charEnd);
                    if (_loc_10 == null)
                    {
                        return;
                    }
                    _loc_3 = _textField.getLineIndexOfChar(_loc_1.charStart);
                    _loc_2 = _textField.getLineMetrics(_loc_3);
                    _loc_5 = _loc_10.right - _loc_7.left;
                    if (_loc_7.left + _loc_5 > _textField.width - 2)
                    {
                        _loc_5 = _textField.width - _loc_7.left - 2;
                    }
                    _loc_1.displayObject.x = _loc_7.left;
                    this.LinkButton(_loc_1.displayObject).setSize(_loc_5, _loc_2.height);
                    if (_loc_7.top < _loc_10.top)
                    {
                        _loc_1.topY = 0;
                    }
                    else
                    {
                        _loc_1.topY = _loc_10.top - _loc_7.top;
                    }
                    _loc_1.displayObject.y = _loc_7.top + _loc_1.topY;
                    if (isLineVisible(_loc_3))
                    {
                        if (_loc_1.displayObject.parent == null)
                        {
                            _objectsContainer.addChild(_loc_1.displayObject);
                        }
                    }
                    else if (_loc_1.displayObject.parent)
                    {
                        _objectsContainer.removeChild(_loc_1.displayObject);
                    }
                }
                else if (_loc_12.tag == "img")
                {
                    if (_loc_1.displayObject == null)
                    {
                        _loc_4 = objectFactory.createObject(_loc_12.text, _loc_12.width, _loc_12.height);
                        _loc_1.displayObject = _loc_4;
                    }
                    _loc_7 = _textField.getCharBoundaries(_loc_1.charStart);
                    if (_loc_7 == null)
                    {
                        return;
                    }
                    _loc_3 = _textField.getLineIndexOfChar(_loc_1.charStart);
                    _loc_9 = _textField.getLineMetrics(_loc_3);
                    if (_loc_9 == null)
                    {
                        return;
                    }
                    _loc_1.displayObject.x = _loc_7.left + 2;
                    if (_loc_12.height < _loc_9.ascent)
                    {
                        _loc_1.displayObject.y = _loc_7.top + _loc_9.ascent - _loc_12.height;
                    }
                    else
                    {
                        _loc_1.displayObject.y = _loc_7.bottom - _loc_12.height;
                    }
                    if (isLineVisible(_loc_3) && _loc_1.displayObject.x + _loc_12.width < _textField.width - 2)
                    {
                        if (_loc_1.displayObject.parent == null)
                        {
                            _objectsContainer.addChildAt(_loc_1.displayObject, _objectsContainer.numChildren);
                        }
                    }
                    else if (_loc_1.displayObject.parent)
                    {
                        _objectsContainer.removeChild(_loc_1.displayObject);
                    }
                }
                _loc_8++;
            }
            return;
        }// end function

        private function findStartTag(param1:String) : HtmlElement
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = _elements.length;
            _loc_3 = _loc_2 - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_4 = _elements[_loc_3];
                if (_loc_4.tag == param1 && _loc_4.end == -1)
                {
                    return _loc_4;
                }
                _loc_3--;
            }
            return null;
        }// end function

        private function isLineVisible(param1:int) : Boolean
        {
            return param1 >= (_textField.scrollV - 1) && param1 <= (_textField.bottomScrollV - 1);
        }// end function

        private function skipLeftCR(param1:int, param2:int) : int
        {
            var _loc_4:* = 0;
            var _loc_3:* = null;
            var _loc_5:* = _textField.text;
            _loc_4 = param1;
            while (_loc_4 < param2)
            {
                
                _loc_3 = _loc_5.charAt(_loc_4);
                if (!(_loc_3 != "\r" && _loc_3 != "\n"))
                {
                    _loc_4++;
                }
            }
            return _loc_4;
        }// end function

        private function skipRightCR(param1:int, param2:int) : int
        {
            var _loc_4:* = 0;
            var _loc_3:* = null;
            var _loc_5:* = _textField.text;
            _loc_4 = param2;
            while (_loc_4 > param1)
            {
                
                _loc_3 = _loc_5.charAt(_loc_4);
                if (!(_loc_3 != "\r" && _loc_3 != "\n"))
                {
                    _loc_4--;
                }
            }
            return _loc_4;
        }// end function

        private function onLinkRollOver(event:Event) : void
        {
            var _loc_2:* = this.LinkButton(event.currentTarget).owner;
            if (_AHoverFormat)
            {
                _textField.setTextFormat(_AHoverFormat, _loc_2.element.start, _loc_2.element.end);
            }
            return;
        }// end function

        private function onLinkRollOut(event:Event) : void
        {
            var _loc_2:* = this.LinkButton(event.currentTarget).owner;
            if (!_loc_2.displayObject || !_loc_2.displayObject.stage)
            {
                return;
            }
            if (_AHoverFormat && _ALinkFormat)
            {
                _textField.setTextFormat(_ALinkFormat, _loc_2.element.start, _loc_2.element.end);
            }
            return;
        }// end function

        private function onLinkClick(event:Event) : void
        {
            event.stopPropagation();
            var _loc_2:* = this.LinkButton(event.currentTarget).owner;
            var _loc_4:* = _loc_2.element.text;
            var _loc_3:* = _loc_4.indexOf("event:");
            if (_loc_3 == 0)
            {
                _loc_4 = _loc_4.substring(6);
                this.displayObject.dispatchEvent(new TextEvent("link", true, false, _loc_4));
            }
            else
            {
                this.navigateToURL(new URLRequest(_loc_4), "_blank");
            }
            return;
        }// end function

    }
}
