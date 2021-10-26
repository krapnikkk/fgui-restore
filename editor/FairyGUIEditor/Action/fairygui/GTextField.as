package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.display.*;
    import fairygui.text.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.text.*;

    public class GTextField extends GObject
    {
        protected var _ubbEnabled:Boolean;
        protected var _autoSize:int;
        protected var _widthAutoSize:Boolean;
        protected var _heightAutoSize:Boolean;
        protected var _textFormat:TextFormat;
        protected var _text:String;
        protected var _font:String;
        protected var _fontSize:int;
        protected var _align:int;
        protected var _verticalAlign:int;
        protected var _color:uint;
        protected var _leading:int;
        protected var _letterSpacing:int;
        protected var _underline:Boolean;
        protected var _bold:Boolean;
        protected var _italic:Boolean;
        protected var _singleLine:Boolean;
        protected var _stroke:int;
        protected var _strokeColor:uint;
        protected var _shadowOffset:Point;
        protected var _textFilters:Array;
        protected var _templateVars:Object;
        protected var _textField:TextField;
        protected var _bitmap:UIImage;
        protected var _bitmapData:BitmapData;
        protected var _updatingSize:Boolean;
        protected var _requireRender:Boolean;
        protected var _sizeDirty:Boolean;
        protected var _textWidth:int;
        protected var _textHeight:int;
        protected var _fontAdjustment:int;
        protected var _maxFontSize:int;
        protected var _bitmapFont:BitmapFont;
        protected var _lines:Vector.<LineInfo>;
        private static const GUTTER_X:int = 2;
        private static const GUTTER_Y:int = 2;

        public function GTextField()
        {
            _textFormat = new TextFormat();
            _fontSize = 12;
            _color = 0;
            _align = 0;
            _verticalAlign = 0;
            _text = "";
            _leading = 3;
            _autoSize = 1;
            _widthAutoSize = true;
            _heightAutoSize = true;
            updateAutoSize();
            return;
        }// end function

        override protected function createDisplayObject() : void
        {
            _textField = new UITextField(this);
            _textField.mouseEnabled = false;
            _textField.selectable = false;
            _textField.multiline = true;
            _textField.width = 10;
            _textField.height = 1;
            setDisplayObject(_textField);
            return;
        }// end function

        private function switchBitmapMode(param1:Boolean) : void
        {
            if (param1 && this.displayObject == _textField)
            {
                if (_bitmap == null)
                {
                    _bitmap = new UIImage(this);
                }
                switchDisplayObject(_bitmap);
            }
            else if (!param1 && this.displayObject == _bitmap)
            {
                switchDisplayObject(_textField);
            }
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            if (_bitmapData)
            {
                _bitmapData.dispose();
                _bitmapData = null;
            }
            _requireRender = false;
            _bitmapFont = null;
            return;
        }// end function

        override public function set text(param1:String) : void
        {
            _text = param1;
            if (_text == null)
            {
                _text = "";
            }
            updateGear(6);
            if (parent && parent._underConstruct)
            {
                renderNow();
            }
            else
            {
                render();
            }
            return;
        }// end function

        override public function get text() : String
        {
            return _text;
        }// end function

        final public function get font() : String
        {
            return _font;
        }// end function

        public function set font(param1:String) : void
        {
            if (_font != param1)
            {
                _font = param1;
                updateTextFormat();
            }
            return;
        }// end function

        final public function get fontSize() : int
        {
            return _fontSize;
        }// end function

        public function set fontSize(param1:int) : void
        {
            if (param1 < 0)
            {
                return;
            }
            if (_fontSize != param1)
            {
                _fontSize = param1;
                updateTextFormat();
            }
            return;
        }// end function

        final public function get color() : uint
        {
            return _color;
        }// end function

        public function set color(param1:uint) : void
        {
            if (_color != param1)
            {
                _color = param1;
                updateGear(4);
                updateTextFormat();
            }
            return;
        }// end function

        final public function get align() : int
        {
            return _align;
        }// end function

        public function set align(param1:int) : void
        {
            if (_align != param1)
            {
                _align = param1;
                updateTextFormat();
            }
            return;
        }// end function

        final public function get verticalAlign() : int
        {
            return _verticalAlign;
        }// end function

        public function set verticalAlign(param1:int) : void
        {
            if (_verticalAlign != param1)
            {
                _verticalAlign = param1;
                doAlign();
            }
            return;
        }// end function

        final public function get leading() : int
        {
            return _leading;
        }// end function

        public function set leading(param1:int) : void
        {
            if (_leading != param1)
            {
                _leading = param1;
                updateTextFormat();
            }
            return;
        }// end function

        final public function get letterSpacing() : int
        {
            return _letterSpacing;
        }// end function

        public function set letterSpacing(param1:int) : void
        {
            if (_letterSpacing != param1)
            {
                _letterSpacing = param1;
                updateTextFormat();
            }
            return;
        }// end function

        final public function get underline() : Boolean
        {
            return _underline;
        }// end function

        public function set underline(param1:Boolean) : void
        {
            if (_underline != param1)
            {
                _underline = param1;
                updateTextFormat();
            }
            return;
        }// end function

        final public function get bold() : Boolean
        {
            return _bold;
        }// end function

        public function set bold(param1:Boolean) : void
        {
            if (_bold != param1)
            {
                _bold = param1;
                updateTextFormat();
            }
            return;
        }// end function

        final public function get italic() : Boolean
        {
            return _italic;
        }// end function

        public function set italic(param1:Boolean) : void
        {
            if (_italic != param1)
            {
                _italic = param1;
                updateTextFormat();
            }
            return;
        }// end function

        public function get singleLine() : Boolean
        {
            return _singleLine;
        }// end function

        public function set singleLine(param1:Boolean) : void
        {
            if (_singleLine != param1)
            {
                _singleLine = param1;
                _textField.multiline = !_singleLine;
                if (!_widthAutoSize)
                {
                    _textField.wordWrap = !_singleLine;
                }
                if (!_underConstruct)
                {
                    render();
                }
            }
            return;
        }// end function

        final public function get stroke() : int
        {
            return _stroke;
        }// end function

        public function set stroke(param1:int) : void
        {
            if (_stroke != param1)
            {
                _stroke = param1;
                updateTextFilters();
            }
            return;
        }// end function

        final public function get strokeColor() : uint
        {
            return _strokeColor;
        }// end function

        public function set strokeColor(param1:uint) : void
        {
            if (_strokeColor != param1)
            {
                _strokeColor = param1;
                updateTextFilters();
                updateGear(4);
            }
            return;
        }// end function

        final public function get shadowOffset() : Point
        {
            return _shadowOffset;
        }// end function

        public function set shadowOffset(param1:Point) : void
        {
            _shadowOffset = param1;
            updateTextFilters();
            return;
        }// end function

        private function updateTextFilters() : void
        {
            if (_stroke && _shadowOffset != null)
            {
                _textFilters = [new DropShadowFilter(_stroke, 45, _strokeColor, 1, 1, 1, 5, 1), new DropShadowFilter(_stroke, 222, _strokeColor, 1, 1, 1, 5, 1), new DropShadowFilter(Math.sqrt(Math.pow(_shadowOffset.x, 2) + Math.pow(_shadowOffset.y, 2)), Math.atan2(_shadowOffset.y, _shadowOffset.x) * 57.2958, _strokeColor, 1, 1, 2)];
            }
            else if (_stroke)
            {
                _textFilters = [new DropShadowFilter(_stroke, 45, _strokeColor, 1, 1, 1, 5, 1), new DropShadowFilter(_stroke, 222, _strokeColor, 1, 1, 1, 5, 1)];
            }
            else if (_shadowOffset != null)
            {
                _textFilters = [new DropShadowFilter(Math.sqrt(Math.pow(_shadowOffset.x, 2) + Math.pow(_shadowOffset.y, 2)), Math.atan2(_shadowOffset.y, _shadowOffset.x) * 57.2958, _strokeColor, 1, 1, 2)];
            }
            else
            {
                _textFilters = null;
            }
            _textField.filters = _textFilters;
            return;
        }// end function

        public function set ubbEnabled(param1:Boolean) : void
        {
            if (_ubbEnabled != param1)
            {
                _ubbEnabled = param1;
                render();
            }
            return;
        }// end function

        final public function get ubbEnabled() : Boolean
        {
            return _ubbEnabled;
        }// end function

        public function set autoSize(param1:int) : void
        {
            if (_autoSize != param1)
            {
                _autoSize = param1;
                _widthAutoSize = param1 == 1;
                _heightAutoSize = param1 == 1 || param1 == 2;
                updateAutoSize();
                render();
            }
            return;
        }// end function

        final public function get autoSize() : int
        {
            return _autoSize;
        }// end function

        public function get textWidth() : int
        {
            if (_requireRender)
            {
                renderNow();
            }
            return _textWidth;
        }// end function

        override public function ensureSizeCorrect() : void
        {
            if (_sizeDirty && _requireRender)
            {
                renderNow();
            }
            return;
        }// end function

        protected function updateTextFormat() : void
        {
            var _loc_1:* = null;
            _textFormat.size = _fontSize;
            if (ToolSet.startsWith(_font, "ui://") && !(this is GRichTextField))
            {
                _bitmapFont = UIPackage.getBitmapFontByURL(_font);
                _fontAdjustment = 0;
            }
            else
            {
                _bitmapFont = null;
                if (_font)
                {
                    _textFormat.font = _font;
                }
                else
                {
                    _textFormat.font = UIConfig.defaultFont;
                }
                _loc_1 = CharSize.getSize(_textFormat.size, _textFormat.font, _bold);
                _fontAdjustment = _loc_1.yIndent;
            }
            if (this.grayed)
            {
                _textFormat.color = 11184810;
            }
            else
            {
                _textFormat.color = _color;
            }
            _textFormat.align = AlignType.toString(_align);
            _textFormat.leading = _leading - _fontAdjustment;
            _textFormat.letterSpacing = _letterSpacing;
            _textFormat.bold = _bold;
            _textFormat.underline = _underline;
            _textFormat.italic = _italic;
            _textField.defaultTextFormat = _textFormat;
            _textField.embedFonts = FontUtils.isEmbeddedFont(_textFormat);
            if (!_underConstruct)
            {
                render();
            }
            return;
        }// end function

        protected function updateAutoSize() : void
        {
            if (_widthAutoSize)
            {
                _textField.autoSize = "left";
                _textField.wordWrap = false;
            }
            else
            {
                _textField.autoSize = "none";
                _textField.wordWrap = !_singleLine;
            }
            return;
        }// end function

        protected function render() : void
        {
            if (!_requireRender)
            {
                _requireRender = true;
                GTimers.inst.add(0, 1, __render);
            }
            if (!_sizeDirty && (_widthAutoSize || _heightAutoSize))
            {
                _sizeDirty = true;
                _dispatcher.dispatch(this, 3);
            }
            return;
        }// end function

        private function __render() : void
        {
            if (_requireRender)
            {
                renderNow();
            }
            return;
        }// end function

        protected function updateTextFieldText(param1:String) : void
        {
            if (_ubbEnabled)
            {
                _textField.htmlText = UBBParser.inst.parse(ToolSet.encodeHTML(param1));
                _maxFontSize = Math.max(_maxFontSize, UBBParser.inst.maxFontSize);
            }
            else
            {
                _textField.text = param1;
            }
            return;
        }// end function

        protected function renderNow() : void
        {
            var _loc_3:* = NaN;
            var _loc_1:* = NaN;
            _requireRender = false;
            _sizeDirty = false;
            if (_bitmapFont != null)
            {
                renderWithBitmapFont();
                return;
            }
            switchBitmapMode(false);
            _loc_1 = _width;
            if (_loc_1 != _textField.width)
            {
                _textField.width = _loc_1;
            }
            _loc_3 = Math.max(_height, _textFormat.size);
            if (_loc_3 != _textField.height)
            {
                _textField.height = _loc_3;
            }
            _textField.defaultTextFormat = _textFormat;
            _maxFontSize = _textFormat.size;
            var _loc_2:* = _text;
            if (_templateVars != null)
            {
                _loc_2 = parseTemplate(_loc_2);
            }
            updateTextFieldText(_loc_2);
            _textWidth = Math.ceil(_textField.textWidth);
            if (_textWidth > 0)
            {
                _textWidth = _textWidth + 5;
            }
            _textHeight = Math.ceil(_textField.textHeight);
            if (_textHeight > 0)
            {
                if (_textField.numLines == 1)
                {
                    _textHeight = CharSize.getSize(_maxFontSize, _textFormat.font, _textFormat.bold).height;
                }
                _textHeight = _textHeight + 4;
            }
            if (_widthAutoSize)
            {
                _loc_1 = _textWidth;
            }
            else
            {
                _loc_1 = _width;
            }
            if (_heightAutoSize)
            {
                _loc_3 = _textHeight;
            }
            else
            {
                _loc_3 = _height;
            }
            if (maxHeight > 0 && _loc_3 > maxHeight)
            {
                _loc_3 = maxHeight;
            }
            if (_textHeight > _loc_3)
            {
                _textHeight = _loc_3;
            }
            _textField.height = _textHeight + _fontAdjustment + 3;
            if (_widthAutoSize || _heightAutoSize)
            {
                _updatingSize = true;
                if (_parent && _parent._underConstruct && _rawWidth == _loc_1 && _rawHeight == _loc_3)
                {
                    _dispatcher.dispatch(this, 2);
                }
                else
                {
                    setSize(_loc_1, _loc_3);
                }
                _updatingSize = false;
            }
            doAlign();
            return;
        }// end function

        private function renderWithBitmapFont() : void
        {
            var _loc_3:* = null;
            var _loc_15:* = 0;
            var _loc_16:* = null;
            var _loc_13:* = 0;
            var _loc_25:* = null;
            var _loc_9:* = 0;
            var _loc_18:* = 0;
            var _loc_28:* = 0;
            var _loc_26:* = 0;
            var _loc_29:* = 0;
            var _loc_21:* = 0;
            var _loc_22:* = 0;
            switchBitmapMode(true);
            if (!_lines)
            {
                _lines = new Vector.<LineInfo>;
            }
            else
            {
                LineInfo.returnList(_lines);
            }
            var _loc_19:* = _letterSpacing;
            var _loc_6:* = _leading - 1;
            var _loc_1:* = this.width - 2 * 2;
            var _loc_7:* = 0;
            var _loc_30:* = 0;
            var _loc_31:* = 0;
            var _loc_32:* = 0;
            var _loc_24:* = 0;
            var _loc_8:* = 0;
            var _loc_11:* = 0;
            var _loc_10:* = 0;
            var _loc_5:* = 0;
            var _loc_23:* = "";
            var _loc_2:* = 2;
            var _loc_4:* = !_widthAutoSize && !_singleLine;
            var _loc_33:* = _bitmapFont.resizable ? (_fontSize / _bitmapFont.size) : (1);
            _textWidth = 0;
            _textHeight = 0;
            var _loc_27:* = _text;
            if (_templateVars != null)
            {
                _loc_27 = parseTemplate(_loc_27);
            }
            var _loc_20:* = _loc_27.length;
            _loc_15 = 0;
            while (_loc_15 < _loc_20)
            {
                
                _loc_16 = _loc_27.charAt(_loc_15);
                _loc_13 = _loc_16.charCodeAt(0);
                if (_loc_13 == 10)
                {
                    _loc_23 = _loc_23 + _loc_16;
                    _loc_3 = LineInfo.borrow();
                    _loc_3.width = _loc_7;
                    if (_loc_31 == 0)
                    {
                        if (_loc_5 == 0)
                        {
                            _loc_5 = _fontSize;
                        }
                        if (_loc_30 == 0)
                        {
                            _loc_30 = _loc_5;
                        }
                        _loc_31 = _loc_30;
                    }
                    _loc_3.height = _loc_30;
                    _loc_5 = _loc_30;
                    _loc_3.textHeight = _loc_31;
                    _loc_3.text = _loc_23;
                    _loc_3.y = _loc_2;
                    _loc_2 = _loc_2 + (_loc_3.height + _loc_6);
                    if (_loc_3.width > _textWidth)
                    {
                        _textWidth = _loc_3.width;
                    }
                    _lines.push(_loc_3);
                    _loc_23 = "";
                    _loc_7 = 0;
                    _loc_30 = 0;
                    _loc_31 = 0;
                    _loc_8 = 0;
                    _loc_11 = 0;
                    _loc_10 = 0;
                }
                else
                {
                    if (_loc_13 >= 65 && _loc_13 <= 90 || _loc_13 >= 97 && _loc_13 <= 122)
                    {
                        if (_loc_8 == 0)
                        {
                            _loc_11 = _loc_7;
                        }
                        _loc_8++;
                    }
                    else
                    {
                        if (_loc_8 > 0)
                        {
                            _loc_10 = _loc_7;
                        }
                        _loc_8 = 0;
                    }
                    if (_loc_13 == 32)
                    {
                        _loc_32 = Math.ceil(_fontSize / 2);
                        _loc_24 = _fontSize;
                    }
                    else
                    {
                        _loc_25 = _bitmapFont.glyphs[_loc_16];
                        if (_loc_25)
                        {
                            _loc_32 = Math.ceil(_loc_25.advance * _loc_33);
                            _loc_24 = Math.ceil(_loc_25.lineHeight * _loc_33);
                        }
                        else
                        {
                            _loc_32 = 0;
                            _loc_24 = 0;
                        }
                    }
                    if (_loc_24 > _loc_31)
                    {
                        _loc_31 = _loc_24;
                    }
                    if (_loc_24 > _loc_30)
                    {
                        _loc_30 = _loc_24;
                    }
                    if (_loc_7 != 0)
                    {
                        _loc_7 = _loc_7 + _loc_19;
                    }
                    _loc_7 = _loc_7 + _loc_32;
                    if (!_loc_4 || _loc_7 <= _loc_1)
                    {
                        _loc_23 = _loc_23 + _loc_16;
                    }
                    else
                    {
                        _loc_3 = LineInfo.borrow();
                        _loc_3.height = _loc_30;
                        _loc_3.textHeight = _loc_31;
                        if (_loc_23.length == 0)
                        {
                            _loc_3.text = _loc_16;
                        }
                        else if (_loc_8 > 0 && _loc_10 > 0)
                        {
                            _loc_23 = _loc_23 + _loc_16;
                            _loc_9 = _loc_23.length - _loc_8;
                            _loc_3.text = ToolSet.trimRight(_loc_23.substr(0, _loc_9));
                            _loc_3.width = _loc_10;
                            _loc_23 = _loc_23.substr(_loc_9);
                            _loc_7 = _loc_7 - _loc_11;
                        }
                        else
                        {
                            _loc_3.text = _loc_23;
                            _loc_3.width = _loc_7 - (_loc_32 + _loc_19);
                            _loc_23 = _loc_16;
                            _loc_7 = _loc_32;
                            _loc_30 = _loc_24;
                            _loc_31 = _loc_24;
                        }
                        _loc_3.y = _loc_2;
                        _loc_2 = _loc_2 + (_loc_3.height + _loc_6);
                        if (_loc_3.width > _textWidth)
                        {
                            _textWidth = _loc_3.width;
                        }
                        _loc_8 = 0;
                        _loc_11 = 0;
                        _loc_10 = 0;
                        _lines.push(_loc_3);
                    }
                }
                _loc_15++;
            }
            if (_loc_23.length > 0)
            {
                _loc_3 = LineInfo.borrow();
                _loc_3.width = _loc_7;
                if (_loc_30 == 0)
                {
                    _loc_30 = _loc_5;
                }
                if (_loc_31 == 0)
                {
                    _loc_31 = _loc_30;
                }
                _loc_3.height = _loc_30;
                _loc_3.textHeight = _loc_31;
                _loc_3.text = _loc_23;
                _loc_3.y = _loc_2;
                if (_loc_3.width > _textWidth)
                {
                    _textWidth = _loc_3.width;
                }
                _lines.push(_loc_3);
            }
            if (_textWidth > 0)
            {
                _textWidth = _textWidth + 2 * 2;
            }
            var _loc_17:* = _lines.length;
            if (_lines.length == 0)
            {
                _textHeight = 0;
            }
            else
            {
                _loc_3 = _lines[(_lines.length - 1)];
                _textHeight = _loc_3.y + _loc_3.height + 2;
            }
            if (_widthAutoSize)
            {
                _loc_28 = _textWidth;
            }
            else
            {
                _loc_28 = _width;
            }
            if (_heightAutoSize)
            {
                _loc_18 = _textHeight;
            }
            else
            {
                _loc_18 = _height;
            }
            if (maxHeight > 0 && _loc_18 > maxHeight)
            {
                _loc_18 = maxHeight;
            }
            if (_widthAutoSize || _heightAutoSize)
            {
                _updatingSize = true;
                if (_parent && _parent._underConstruct && _rawWidth == _loc_28 && _rawHeight == _loc_18)
                {
                    _dispatcher.dispatch(this, 2);
                }
                else
                {
                    setSize(_loc_28, _loc_18);
                }
                _updatingSize = false;
            }
            doAlign();
            if (_bitmapData != null)
            {
                _bitmapData.dispose();
            }
            if (_loc_28 == 0 || _loc_18 == 0)
            {
                return;
            }
            _bitmapData = new BitmapData(_loc_28, _loc_18, true, 0);
            var _loc_14:* = 2;
            _loc_1 = this.width - 2 * 2;
            var _loc_12:* = _lines.length;
            _loc_21 = 0;
            while (_loc_21 < _loc_12)
            {
                
                _loc_3 = _lines[_loc_21];
                _loc_14 = 2;
                if (_align == 1)
                {
                    _loc_26 = (_loc_1 - _loc_3.width) / 2;
                }
                else if (_align == 2)
                {
                    _loc_26 = _loc_1 - _loc_3.width;
                }
                else
                {
                    _loc_26 = 0;
                }
                _loc_20 = _loc_3.text.length;
                _loc_22 = 0;
                while (_loc_22 < _loc_20)
                {
                    
                    _loc_16 = _loc_3.text.charAt(_loc_22);
                    _loc_13 = _loc_16.charCodeAt(0);
                    if (_loc_13 != 10)
                    {
                        if (_loc_13 == 32)
                        {
                            _loc_14 = _loc_14 + (_letterSpacing + Math.ceil(_fontSize / 2));
                        }
                        else
                        {
                            _loc_25 = _bitmapFont.glyphs[_loc_16];
                            if (_loc_25 != null)
                            {
                                _loc_29 = (_loc_3.height + _loc_3.textHeight) / 2 - Math.ceil(_loc_25.lineHeight * _loc_33);
                                _bitmapFont.draw(_bitmapData, _loc_25, _loc_14 + _loc_26, _loc_3.y + _loc_29, _color, _loc_33);
                                _loc_14 = _loc_14 + (_loc_19 + Math.ceil(_loc_25.advance * _loc_33));
                            }
                            else
                            {
                                _loc_14 = _loc_14 + _loc_19;
                            }
                        }
                    }
                    _loc_22++;
                }
                _loc_21++;
            }
            _bitmap.bitmapData = _bitmapData;
            _bitmap.smoothing = true;
            return;
        }// end function

        protected function parseTemplate(param1:String) : String
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_3:* = 0;
            var _loc_2:* = "";
            do
            {
                
                if (_loc_4 > 0 && param1.charCodeAt((_loc_4 - 1)) == 92)
                {
                    _loc_2 = _loc_2 + param1.substring(_loc_3, (_loc_4 - 1));
                    _loc_2 = _loc_2 + "{";
                    _loc_3 = _loc_4 + 1;
                }
                else
                {
                    _loc_2 = _loc_2 + param1.substring(_loc_3, _loc_4);
                    _loc_3 = _loc_4;
                    _loc_4 = param1.indexOf("}", _loc_3);
                    if (_loc_4 == (_loc_3 + 1))
                    {
                        _loc_2 = _loc_2 + param1.substr(_loc_3, 2);
                        _loc_3 = _loc_4 + 1;
                    }
                    else
                    {
                        _loc_6 = param1.substring((_loc_3 + 1), _loc_4);
                        _loc_5 = _loc_6.indexOf("=");
                        if (_loc_5 != -1)
                        {
                            _loc_7 = _templateVars[_loc_6.substring(0, _loc_5)];
                            if (_loc_7 == null)
                            {
                                _loc_2 = _loc_2 + _loc_6.substring((_loc_5 + 1));
                            }
                            else
                            {
                                _loc_2 = _loc_2 + _loc_7;
                            }
                        }
                        else
                        {
                            _loc_7 = _templateVars[_loc_6];
                            if (_loc_7 != null)
                            {
                                _loc_2 = _loc_2 + _loc_7;
                            }
                        }
                        _loc_3 = _loc_4 + 1;
                    }
                }
                _loc_4 = param1.indexOf("{", _loc_3);
            }while (param1.indexOf("{", _loc_3) != -1)
            if (_loc_3 < param1.length)
            {
                _loc_2 = _loc_2 + param1.substr(_loc_3);
            }
            return _loc_2;
        }// end function

        public function get templateVars() : Object
        {
            return _templateVars;
        }// end function

        public function set templateVars(param1:Object) : void
        {
            if (_templateVars == null && param1 == null)
            {
                return;
            }
            _templateVars = param1;
            flushVars();
            return;
        }// end function

        public function setVar(param1:String, param2:String) : GTextField
        {
            if (!_templateVars)
            {
                _templateVars = {};
            }
            _templateVars[param1] = param2;
            return this;
        }// end function

        public function flushVars() : void
        {
            render();
            return;
        }// end function

        override protected function handleSizeChanged() : void
        {
            if (!_updatingSize)
            {
                if (!_widthAutoSize)
                {
                    render();
                }
                else
                {
                    doAlign();
                }
            }
            return;
        }// end function

        override protected function handleGrayedChanged() : void
        {
            if (_bitmapFont)
            {
                super.handleGrayedChanged();
            }
            updateTextFormat();
            return;
        }// end function

        protected function doAlign() : void
        {
            var _loc_1:* = NaN;
            if (_verticalAlign == 0)
            {
                _yOffset = 0;
            }
            else
            {
                if (_textHeight == 0)
                {
                    _loc_1 = this.height - _textFormat.size;
                }
                else
                {
                    _loc_1 = this.height - _textHeight;
                }
                if (_verticalAlign == 1)
                {
                    _yOffset = _loc_1 / 2;
                }
                else
                {
                    _yOffset = _loc_1;
                }
            }
            _yOffset = _yOffset - _fontAdjustment;
            displayObject.y = this.y + _yOffset;
            return;
        }// end function

        override public function getProp(param1:int)
        {
            switch(param1 - 2) branch count is:<6>[26, 31, 41, 41, 41, 41, 36] default offset is:<41>;
            return this.color;
            return this.strokeColor;
            return this.fontSize;
            return super.getProp(param1);
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            switch(param1 - 2) branch count is:<6>[26, 35, 53, 53, 53, 53, 44] default offset is:<53>;
            this.color = param2;
            ;
            this.strokeColor = param2;
            ;
            this.fontSize = param2;
            ;
            super.setProp(param1, param2);
            return;
        }// end function

        override public function setup_beforeAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            super.setup_beforeAdd(param1);
            _loc_2 = param1.@font;
            if (_loc_2)
            {
                _font = _loc_2;
            }
            _loc_2 = param1.@fontSize;
            if (_loc_2)
            {
                _fontSize = this.parseInt(_loc_2);
            }
            _loc_2 = param1.@color;
            if (_loc_2)
            {
                _color = ToolSet.convertFromHtmlColor(_loc_2);
            }
            _loc_2 = param1.@align;
            if (_loc_2)
            {
                _align = AlignType.parse(_loc_2);
            }
            _loc_2 = param1.@vAlign;
            if (_loc_2)
            {
                _verticalAlign = VertAlignType.parse(_loc_2);
            }
            _loc_2 = param1.@leading;
            if (_loc_2)
            {
                _leading = this.parseInt(_loc_2);
            }
            else
            {
                _leading = 3;
            }
            _loc_2 = param1.@letterSpacing;
            if (_loc_2)
            {
                _letterSpacing = this.parseInt(_loc_2);
            }
            _ubbEnabled = param1.@ubb == "true";
            _loc_2 = param1.@autoSize;
            if (_loc_2)
            {
                _autoSize = AutoSizeType.parse(_loc_2);
                _widthAutoSize = _autoSize == 1;
                _heightAutoSize = _autoSize == 1 || _autoSize == 2;
                updateAutoSize();
            }
            _underline = param1.@underline == "true";
            _italic = param1.@italic == "true";
            _bold = param1.@bold == "true";
            this.singleLine = param1.@singleLine == "true";
            _loc_2 = param1.@strokeColor;
            if (_loc_2)
            {
                _strokeColor = ToolSet.convertFromHtmlColor(_loc_2);
                _loc_2 = param1.@strokeSize;
                if (_loc_2)
                {
                    _stroke = this.parseInt(_loc_2);
                }
                else
                {
                    _stroke = 1;
                }
            }
            _loc_2 = param1.@shadowColor;
            if (_loc_2)
            {
                if (!_stroke)
                {
                    _strokeColor = ToolSet.convertFromHtmlColor(_loc_2);
                }
                _loc_2 = param1.@shadowOffset;
                if (_loc_2)
                {
                    _loc_3 = _loc_2.split(",");
                    _shadowOffset = new Point(this.parseFloat(_loc_3[0]), this.parseFloat(_loc_3[1]));
                }
            }
            if (_stroke || _shadowOffset != null)
            {
                updateTextFilters();
            }
            if (param1.@vars == "true")
            {
                _templateVars = {};
            }
            return;
        }// end function

        override public function setup_afterAdd(param1:XML) : void
        {
            super.setup_afterAdd(param1);
            updateTextFormat();
            var _loc_2:* = param1.@text;
            if (_loc_2)
            {
                this.text = _loc_2;
            }
            _sizeDirty = false;
            return;
        }// end function

    }
}

import *.*;

import __AS3__.vec.*;

import fairygui.display.*;

import fairygui.text.*;

import fairygui.utils.*;

import flash.display.*;

import flash.filters.*;

import flash.geom.*;

import flash.text.*;

class LineInfo extends Object
{
    public var width:int;
    public var height:int;
    public var textHeight:int;
    public var text:String;
    public var y:int;
    private static var pool:Array = [];

    function LineInfo()
    {
        return;
    }// end function

    public static function borrow() : LineInfo
    {
        var _loc_1:* = null;
        if (pool.length)
        {
            _loc_1 = pool.pop();
            _loc_1.width = 0;
            _loc_1.height = 0;
            _loc_1.textHeight = 0;
            _loc_1.text = null;
            _loc_1.y = 0;
            return _loc_1;
        }
        return new LineInfo;
    }// end function

    public static function returns(param1:LineInfo) : void
    {
        pool.push(param1);
        return;
    }// end function

    public static function returnList(param1:Vector.<LineInfo>) : void
    {
        for each (_loc_2 in param1)
        {
            
            pool.push(_loc_2);
        }
        _loc_3.length = 0;
        return;
    }// end function

}

