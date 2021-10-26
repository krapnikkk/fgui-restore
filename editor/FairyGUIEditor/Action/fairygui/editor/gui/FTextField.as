package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.gui.text.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.text.*;

    public class FTextField extends FObject
    {
        public var clearOnPublish:Boolean;
        protected var _textField:TextField;
        protected var _ubbEnabled:Boolean;
        protected var _autoSize:String;
        protected var _widthAutoSize:Boolean;
        protected var _heightAutoSize:Boolean;
        protected var _textFormat:TextFormat;
        protected var _text:String;
        protected var _font:String;
        protected var _fontSize:int;
        protected var _align:String;
        protected var _verticalAlign:String;
        protected var _color:uint;
        protected var _leading:int;
        protected var _letterSpacing:int;
        protected var _underline:Boolean;
        protected var _handCursor:Boolean;
        protected var _input:Boolean;
        protected var _bold:Boolean;
        protected var _italic:Boolean;
        protected var _stroke:Boolean;
        protected var _strokeColor:uint;
        protected var _strokeSize:int;
        protected var _shadow:Boolean;
        protected var _shadowX:Number;
        protected var _shadowY:Number;
        protected var _singleLine:Boolean;
        protected var _fontAdjustment:int;
        protected var _textWidth:int;
        protected var _textHeight:int;
        protected var _updatingSize:Boolean;
        protected var _yOffset:int;
        protected var _bitmapMode:Boolean;
        protected var _varsEnabled:Boolean;
        protected var _textFilters:Array;
        protected var _maxFontSize:int;
        protected var _shrinkScale:Number;
        protected var _promptText:String;
        protected var _restrict:String;
        protected var _maxLength:int;
        protected var _keyboardType:int;
        protected var _password:Boolean;
        protected var _bitmapFontRef:ResourceRef;
        protected var _lines:Vector.<LineInfo>;
        protected var _bitmap:Bitmap;
        protected var _bitmapData:BitmapData;
        protected var _fontVersion:uint;
        public static const AUTOSIZE_NONE:String = "none";
        public static const AUTOSIZE_BOTH:String = "both";
        public static const AUTOSIZE_HEIGHT:String = "height";
        private static const GUTTER_X:int = 2;
        private static const GUTTER_Y:int = 2;
        private static const INIT_MIN_WIDTH:int = 40;
        private static var helperMatrix:Matrix = new Matrix();

        public function FTextField()
        {
            this._objectType = FObjectType.TEXT;
            this._textField = new TextField();
            this._textField.mouseEnabled = false;
            this._textFormat = new TextFormat();
            this._textField.defaultTextFormat = this._textFormat;
            this._fontSize = 12;
            this._color = 0;
            this._align = "left";
            this._verticalAlign = "top";
            this._text = "";
            _internalMinWidth = 10;
            this._leading = 3;
            this._strokeSize = 1;
            this._shadowX = 1;
            this._shadowY = 1;
            this._keyboardType = 0;
            this._shrinkScale = 1;
            this._updatingSize = true;
            this.autoSize = "both";
            this._updatingSize = false;
            this._textField.selectable = false;
            this._textField.multiline = true;
            _useSourceSize = false;
            _displayObject.container.addChild(this._textField);
            return;
        }// end function

        public function get nativeTextField() : TextField
        {
            return this._textField;
        }// end function

        override public function set text(param1:String) : void
        {
            if (param1 == null)
            {
                param1 = "";
            }
            param1 = param1.replace(/\r\n/g, "\n");
            param1 = param1.replace(/\r/g, "\n");
            this._text = param1;
            this._textField.width = this.width;
            if (this._textField.height < int(this._textFormat.size))
            {
                this._textField.height = int(this._textFormat.size);
            }
            this._textField.defaultTextFormat = this._textFormat;
            this._maxFontSize = 0;
            if (this._varsEnabled)
            {
                param1 = this.parseTemplate(param1);
            }
            if (this._input)
            {
                if (!this._text && this._promptText)
                {
                    this._textField.displayAsPassword = false;
                    this._textField.htmlText = UBBParser.inst.parse(ToolSet.encodeHTML(this._promptText));
                }
                else
                {
                    this._textField.displayAsPassword = this._password;
                    this._textField.text = param1;
                }
            }
            else if (this is FRichTextField)
            {
                FRichTextField(this).updateRichText(param1);
            }
            else
            {
                this._textField.displayAsPassword = this._input && this._password;
                if (this._ubbEnabled)
                {
                    this._textField.htmlText = UBBParser.inst.parse(UtilsStr.encodeXML(param1));
                    this._maxFontSize = UBBParser.inst.maxFontSize;
                }
                else
                {
                    this._textField.text = param1;
                }
            }
            if (this._bitmapFontRef)
            {
                this._bitmapFontRef.displayItem.getBitmapFont().prepareCharacters(param1, _flags);
            }
            this.updateSize();
            updateGear(6);
            return;
        }// end function

        protected function parseTemplate(param1:String) : String
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_2:* = 0;
            var _loc_6:* = "";
            do
            {
                
                if (_loc_3 > 0 && param1.charCodeAt((_loc_3 - 1)) == 92)
                {
                    _loc_6 = _loc_6 + param1.substring(_loc_2, (_loc_3 - 1));
                    _loc_6 = _loc_6 + "{";
                    _loc_2 = _loc_3 + 1;
                }
                else
                {
                    _loc_6 = _loc_6 + param1.substring(_loc_2, _loc_3);
                    _loc_2 = _loc_3;
                    _loc_3 = param1.indexOf("}", _loc_2);
                    if (_loc_3 == -1)
                    {
                        break;
                    }
                    if (_loc_3 == (_loc_2 + 1))
                    {
                        _loc_6 = _loc_6 + param1.substr(_loc_2, 2);
                        _loc_2 = _loc_3 + 1;
                    }
                    else
                    {
                        _loc_5 = param1.substring((_loc_2 + 1), _loc_3);
                        _loc_4 = _loc_5.indexOf("=");
                        if (_loc_4 != -1)
                        {
                            _loc_6 = _loc_6 + _loc_5.substring((_loc_4 + 1));
                        }
                        _loc_2 = _loc_3 + 1;
                    }
                }
                var _loc_7:* = param1.indexOf("{", _loc_2);
                _loc_3 = param1.indexOf("{", _loc_2);
            }while (_loc_7 != -1)
            if (_loc_2 < param1.length)
            {
                _loc_6 = _loc_6 + param1.substr(_loc_2);
            }
            return _loc_6;
        }// end function

        override public function get text() : String
        {
            return this._text;
        }// end function

        public function get font() : String
        {
            return this._font;
        }// end function

        public function set font(param1:String) : void
        {
            if (this._font != param1)
            {
                this._font = param1;
                this.updateTextFormat();
            }
            return;
        }// end function

        public function get fontSize() : int
        {
            return this._fontSize;
        }// end function

        public function set fontSize(param1:int) : void
        {
            if (param1 < 0)
            {
                return;
            }
            if (this._fontSize != param1)
            {
                this._fontSize = param1;
                updateGear(9);
                this.updateTextFormat();
            }
            return;
        }// end function

        public function get color() : uint
        {
            return this._color;
        }// end function

        public function set color(param1:uint) : void
        {
            if (this._color != param1)
            {
                this._color = param1;
                updateGear(4);
                this.updateTextFormat();
            }
            return;
        }// end function

        public function get align() : String
        {
            return this._align;
        }// end function

        public function set align(param1:String) : void
        {
            if (this._align != param1)
            {
                this._align = param1;
                this.updateTextFormat();
            }
            return;
        }// end function

        public function get verticalAlign() : String
        {
            return this._verticalAlign;
        }// end function

        public function set verticalAlign(param1:String) : void
        {
            if (this._verticalAlign != param1)
            {
                this._verticalAlign = param1;
                this.doAlign();
            }
            return;
        }// end function

        public function get leading() : int
        {
            return this._leading;
        }// end function

        public function set leading(param1:int) : void
        {
            if (this._leading != param1)
            {
                this._leading = param1;
                this.updateTextFormat();
            }
            return;
        }// end function

        public function get letterSpacing() : int
        {
            return this._letterSpacing;
        }// end function

        public function set letterSpacing(param1:int) : void
        {
            if (this._letterSpacing != param1)
            {
                this._letterSpacing = param1;
                this.updateTextFormat();
            }
            return;
        }// end function

        public function get handCursor() : Boolean
        {
            return this._handCursor;
        }// end function

        public function set handCursor(param1:Boolean) : void
        {
            if (this._handCursor != param1)
            {
                this._handCursor = param1;
                this.updateTextFormat();
            }
            return;
        }// end function

        public function get underline() : Boolean
        {
            return this._underline;
        }// end function

        public function set underline(param1:Boolean) : void
        {
            if (this._underline != param1)
            {
                this._underline = param1;
                this.updateTextFormat();
            }
            return;
        }// end function

        public function get bold() : Boolean
        {
            return this._bold;
        }// end function

        public function set bold(param1:Boolean) : void
        {
            if (this._bold != param1)
            {
                this._bold = param1;
                this.updateTextFormat();
            }
            return;
        }// end function

        public function get italic() : Boolean
        {
            return this._italic;
        }// end function

        public function set italic(param1:Boolean) : void
        {
            if (this._italic != param1)
            {
                this._italic = param1;
                this.updateTextFormat();
            }
            return;
        }// end function

        public function get stroke() : Boolean
        {
            return this._stroke;
        }// end function

        public function set stroke(param1:Boolean) : void
        {
            if (this._stroke != param1)
            {
                this._stroke = param1;
                this.updateStrokeAndShadow();
            }
            return;
        }// end function

        public function get strokeColor() : uint
        {
            return this._strokeColor;
        }// end function

        public function set strokeColor(param1:uint) : void
        {
            if (this._strokeColor != param1)
            {
                this._strokeColor = param1;
                this.updateStrokeAndShadow();
                updateGear(4);
            }
            return;
        }// end function

        public function get strokeSize() : int
        {
            return this._strokeSize;
        }// end function

        public function set strokeSize(param1:int) : void
        {
            if (this._strokeSize != param1)
            {
                this._strokeSize = param1;
                this.updateStrokeAndShadow();
            }
            return;
        }// end function

        private function updateStrokeAndShadow() : void
        {
            this._textFilters = null;
            if (this._stroke && this._shadow)
            {
                this._textFilters = [new DropShadowFilter(this._strokeSize, 45, this._strokeColor, 1, 1, 1, 5, 1), new DropShadowFilter(this._strokeSize, 222, this._strokeColor, 1, 1, 1, 5, 1), new DropShadowFilter(Math.sqrt(Math.pow(this._shadowX, 2) + Math.pow(this._shadowY, 2)), Math.atan2(this._shadowY, this._shadowX) * Utils.RAD_TO_DEG, this._strokeColor, 1, 1, 2)];
            }
            else if (this._stroke)
            {
                this._textFilters = [new DropShadowFilter(this._strokeSize, 45, this._strokeColor, 1, 1, 1, 5, 1), new DropShadowFilter(this._strokeSize, 222, this._strokeColor, 1, 1, 1, 5, 1)];
            }
            else if (this._shadow)
            {
                this._textFilters = [new DropShadowFilter(Math.sqrt(Math.pow(this._shadowX, 2) + Math.pow(this._shadowY, 2)), Math.atan2(this._shadowY, this._shadowX) * Utils.RAD_TO_DEG, this._strokeColor, 1, 1, 2)];
            }
            if (this._textField.parent)
            {
                this._textField.filters = this._textFilters;
            }
            else
            {
                this._bitmap.filters = this._textFilters;
            }
            return;
        }// end function

        public function get shadowY() : Number
        {
            return this._shadowY;
        }// end function

        public function set shadowY(param1:Number) : void
        {
            if (this._shadowY != param1)
            {
                this._shadowY = param1;
                this.updateStrokeAndShadow();
            }
            return;
        }// end function

        public function get shadowX() : Number
        {
            return this._shadowX;
        }// end function

        public function set shadowX(param1:Number) : void
        {
            if (this._shadowX != param1)
            {
                this._shadowX = param1;
                this.updateStrokeAndShadow();
            }
            return;
        }// end function

        public function get shadow() : Boolean
        {
            return this._shadow;
        }// end function

        public function set shadow(param1:Boolean) : void
        {
            if (this._shadow != param1)
            {
                this._shadow = param1;
                this.updateStrokeAndShadow();
            }
            return;
        }// end function

        public function set ubbEnabled(param1:Boolean) : void
        {
            if (this._ubbEnabled != param1)
            {
                this._ubbEnabled = param1;
                this.text = this._text;
            }
            return;
        }// end function

        public function get varsEnabled() : Boolean
        {
            return this._varsEnabled;
        }// end function

        public function set varsEnabled(param1:Boolean) : void
        {
            if (this._varsEnabled != param1)
            {
                this._varsEnabled = param1;
                this.text = this._text;
            }
            return;
        }// end function

        public function get ubbEnabled() : Boolean
        {
            return this._ubbEnabled;
        }// end function

        public function set autoSize(param1:String) : void
        {
            if (this._autoSize != param1)
            {
                if (this._input && (_flags & FObjectFlags.IN_TEST) != 0)
                {
                    param1 = "none";
                }
                this._autoSize = param1;
                this._widthAutoSize = param1 == "both";
                _widthEnabled = !this._widthAutoSize;
                this._heightAutoSize = param1 == "both" || param1 == "height";
                _heightEnabled = !this._heightAutoSize;
                if (this._widthAutoSize)
                {
                    this._textField.autoSize = TextFieldAutoSize.LEFT;
                    this._textField.wordWrap = false;
                }
                else
                {
                    this._textField.autoSize = TextFieldAutoSize.NONE;
                    this._textField.wordWrap = !this._singleLine;
                    this._textField.width = this.width;
                }
                this.updateSize();
            }
            return;
        }// end function

        public function get autoSize() : String
        {
            return this._autoSize;
        }// end function

        public function get selectable() : Boolean
        {
            return this._textField.selectable;
        }// end function

        public function set selectable(param1:Boolean) : void
        {
            this._textField.selectable = param1;
            return;
        }// end function

        public function get input() : Boolean
        {
            return this._input;
        }// end function

        public function set input(param1:Boolean) : void
        {
            if (this._input != param1)
            {
                this._input = param1;
                this.touchDisabled = !this._input;
                if ((_flags & FObjectFlags.IN_TEST) != 0 && this._input)
                {
                    this._widthAutoSize = false;
                    this._heightAutoSize = false;
                    this._textField.type = TextFieldType.INPUT;
                    this._textField.mouseEnabled = true;
                    this._textField.maxChars = this._maxLength;
                    this._textField.autoSize = TextFieldAutoSize.NONE;
                    this._textField.wordWrap = !this._singleLine;
                    this._textField.width = this.width;
                    this._textField.height = this.height;
                    this._textField.selectable = true;
                    this._textField.addEventListener(FocusEvent.FOCUS_IN, this.__focusIn);
                    this._textField.addEventListener(FocusEvent.FOCUS_OUT, this.__focusOut);
                }
            }
            return;
        }// end function

        public function get password() : Boolean
        {
            return this._password;
        }// end function

        public function set password(param1:Boolean) : void
        {
            this._password = param1;
            this.text = this._text;
            return;
        }// end function

        public function get keyboardType() : int
        {
            return this._keyboardType;
        }// end function

        public function set keyboardType(param1:int) : void
        {
            this._keyboardType = param1;
            return;
        }// end function

        public function get maxLength() : int
        {
            return this._maxLength;
        }// end function

        public function set maxLength(param1:int) : void
        {
            this._maxLength = param1;
            this._textField.maxChars = this._maxLength;
            return;
        }// end function

        public function get restrict() : String
        {
            return this._restrict;
        }// end function

        public function set restrict(param1:String) : void
        {
            this._restrict = param1;
            return;
        }// end function

        public function get promptText() : String
        {
            return this._promptText;
        }// end function

        public function set promptText(param1:String) : void
        {
            this._promptText = param1;
            if (!_underConstruct && this._input)
            {
                this.text = this._text;
            }
            return;
        }// end function

        public function get singleLine() : Boolean
        {
            return this._singleLine;
        }// end function

        public function set singleLine(param1:Boolean) : void
        {
            if (this._singleLine != param1)
            {
                this._singleLine = param1;
                if (!this._widthAutoSize)
                {
                    this._textField.wordWrap = !this._singleLine;
                }
                this._textField.multiline = !this._singleLine;
                if (this is FRichTextField)
                {
                    this.updateTextFormat();
                }
                else
                {
                    this.updateSize();
                }
            }
            return;
        }// end function

        public function initFrom(param1:FTextField) : void
        {
            if (param1 != null)
            {
                this._font = param1.font;
                this._fontSize = param1.fontSize;
                this._color = param1.color;
                this._leading = param1.leading;
                this._letterSpacing = param1.letterSpacing;
                this._bold = param1.bold;
                this._italic = param1.italic;
                this._underline = param1.underline;
                this._align = param1.align;
                this._verticalAlign = param1.verticalAlign;
                this._strokeColor = param1.strokeColor;
                this.stroke = param1.stroke;
            }
            this.updateTextFormat();
            return;
        }// end function

        override protected function handleCreate() : void
        {
            this.touchDisabled = !(this is FRichTextField);
            this._fontSize = _pkg.project.getSetting("common", "fontSize");
            this._color = _pkg.project.getSetting("common", "textColor");
            if (FObjectFactory.constructingDepth == 0)
            {
                this.updateTextFormat();
            }
            return;
        }// end function

        override protected function handleDispose() : void
        {
            if (this._bitmapData != null)
            {
                this._bitmapData.dispose();
                this._bitmapData = null;
            }
            if (this._bitmapFontRef)
            {
                this._bitmapFontRef.release();
                this._bitmapFontRef = null;
            }
            return;
        }// end function

        override public function get deprecated() : Boolean
        {
            if (this._bitmapFontRef != null && this._bitmapFontRef.deprecated || this._bitmapFontRef == null && this._fontVersion != FProject(_pkg.project)._globalFontVersion)
            {
                return true;
            }
            return false;
        }// end function

        protected function updateSize(param1:Boolean = false) : void
        {
            if (this._updatingSize)
            {
                return;
            }
            this._updatingSize = true;
            if (this._shrinkScale != 1)
            {
                this._textFormat.size = this._fontSize;
                this._textField.setTextFormat(this._textFormat);
                this._shrinkScale = 1;
            }
            if (this._bitmapFontRef)
            {
                this.buildLines();
            }
            else
            {
                this.getTextSize();
            }
            if (this._autoSize == "shrink")
            {
                this.doShrink();
            }
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            if (this._widthAutoSize)
            {
                _loc_2 = this._textWidth;
            }
            else
            {
                _loc_2 = _width;
            }
            if (this._heightAutoSize)
            {
                _loc_3 = this._textHeight;
            }
            else
            {
                _loc_3 = _height;
            }
            if ((_flags & FObjectFlags.INSPECTING) != 0)
            {
                if (_loc_3 > 0 && _loc_3 < _internalMinHeight)
                {
                    _loc_3 = _internalMinHeight;
                }
            }
            if (_maxHeight > 0 && _loc_3 > _maxHeight)
            {
                _loc_3 = _maxHeight;
            }
            if (this._textHeight > _loc_3)
            {
                this._textHeight = _loc_3;
            }
            if (!(this._input && (_flags & FObjectFlags.IN_TEST) != 0))
            {
                this._textField.height = Math.max(this._textHeight + this._fontAdjustment + 3, _loc_3);
            }
            if ((_flags & FObjectFlags.INSPECTING) != 0)
            {
                if (_loc_3 < _internalMinHeight)
                {
                    _loc_3 = _internalMinHeight;
                }
                if (_loc_2 == 0 && this._widthAutoSize && _width == INIT_MIN_WIDTH)
                {
                    _loc_2 = INIT_MIN_WIDTH;
                }
            }
            if (param1)
            {
                _loc_2 = _rawWidth;
            }
            if (this._widthAutoSize || this._heightAutoSize)
            {
                if ((_flags & FObjectFlags.IN_TEST) != 0 && _parent && _parent._underConstruct && _rawWidth == _loc_2 && _rawHeight == _loc_3)
                {
                    _dispatcher.emit(this, SIZE_CHANGED);
                }
                else
                {
                    setSize(_loc_2, _loc_3, false, true);
                }
            }
            this._updatingSize = false;
            this.doAlign();
            this.render();
            return;
        }// end function

        private function getTextSize() : void
        {
            if (this._textField.wordWrap && this._textField.numLines > 1)
            {
                this._textWidth = this._textField.width;
            }
            else
            {
                this._textWidth = Math.ceil(this._textField.textWidth);
                if (this._textWidth > 0)
                {
                    this._textWidth = this._textWidth + 5;
                }
            }
            this._textHeight = Math.ceil(this._textField.textHeight);
            if (this._textHeight > 0)
            {
                if (this._textField.numLines == 1)
                {
                    this._textHeight = CharSize.getSize(this._maxFontSize != 0 ? (this._maxFontSize) : (int(this._textFormat.size)), this._textFormat.font, this._textFormat.bold).height + 4;
                }
                else
                {
                    this._textHeight = this._textHeight + 4;
                }
            }
            return;
        }// end function

        private function buildLines() : void
        {
            var _loc_14:* = null;
            var _loc_20:* = null;
            var _loc_21:* = 0;
            var _loc_22:* = null;
            var _loc_23:* = 0;
            var _loc_1:* = this._bitmapFontRef.displayItem.getBitmapFont();
            if (!this._lines)
            {
                this._lines = new Vector.<LineInfo>;
            }
            else
            {
                this._lines.length = 0;
            }
            var _loc_2:* = _width - GUTTER_X * 2;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = "";
            var _loc_13:* = GUTTER_Y;
            var _loc_15:* = (_loc_1.resizable ? (this._fontSize / _loc_1.size) : (1)) * this._shrinkScale;
            this._textWidth = 0;
            this._textHeight = 0;
            var _loc_16:* = this._text;
            if (this._ubbEnabled)
            {
                _loc_16 = UBBParser.inst.parse(_loc_16, true);
            }
            var _loc_17:* = _loc_16.length;
            var _loc_18:* = 0;
            while (_loc_18 < _loc_17)
            {
                
                _loc_20 = _loc_16.charAt(_loc_18);
                _loc_21 = _loc_20.charCodeAt(0);
                if (_loc_21 == 10)
                {
                    _loc_12 = _loc_12 + _loc_20;
                    _loc_14 = new LineInfo();
                    _loc_14.width = _loc_3;
                    if (_loc_5 == 0)
                    {
                        if (_loc_11 == 0)
                        {
                            _loc_11 = this._fontSize;
                        }
                        if (_loc_4 == 0)
                        {
                            _loc_4 = _loc_11;
                        }
                        _loc_5 = _loc_4;
                    }
                    _loc_14.height = _loc_4;
                    _loc_11 = _loc_4;
                    _loc_14.textHeight = _loc_5;
                    _loc_14.text = _loc_12;
                    _loc_14.y = _loc_13;
                    _loc_13 = _loc_13 + (_loc_14.height + this._leading);
                    if (_loc_14.width > this._textWidth)
                    {
                        this._textWidth = _loc_14.width;
                    }
                    this._lines.push(_loc_14);
                    _loc_12 = "";
                    _loc_3 = 0;
                    _loc_4 = 0;
                    _loc_5 = 0;
                    _loc_8 = 0;
                    _loc_9 = 0;
                    _loc_10 = 0;
                }
                else
                {
                    if (_loc_21 >= 65 && _loc_21 <= 90 || _loc_21 >= 97 && _loc_21 <= 122)
                    {
                        if (_loc_8 == 0)
                        {
                            _loc_9 = _loc_3;
                        }
                        _loc_8++;
                    }
                    else
                    {
                        if (_loc_8 > 0)
                        {
                            _loc_10 = _loc_3;
                        }
                        _loc_8 = 0;
                    }
                    if (_loc_21 == 32)
                    {
                        _loc_6 = Math.ceil(this._fontSize * _loc_15 / 2);
                        _loc_7 = this._fontSize;
                    }
                    else
                    {
                        _loc_22 = _loc_1.getGlyph(_loc_20);
                        if (_loc_22)
                        {
                            _loc_6 = Math.ceil(_loc_22.advance * _loc_15);
                            _loc_7 = Math.ceil(_loc_22.lineHeight * _loc_15);
                        }
                        else
                        {
                            _loc_6 = 0;
                            _loc_7 = 0;
                        }
                    }
                    if (_loc_7 > _loc_5)
                    {
                        _loc_5 = _loc_7;
                    }
                    if (_loc_7 > _loc_4)
                    {
                        _loc_4 = _loc_7;
                    }
                    if (_loc_3 != 0)
                    {
                        _loc_3 = _loc_3 + this._letterSpacing;
                    }
                    _loc_3 = _loc_3 + _loc_6;
                    if (!this._textField.wordWrap || _loc_3 <= _loc_2)
                    {
                        _loc_12 = _loc_12 + _loc_20;
                    }
                    else
                    {
                        _loc_14 = new LineInfo();
                        _loc_14.height = _loc_4;
                        _loc_14.textHeight = _loc_5;
                        if (_loc_12.length == 0)
                        {
                            _loc_14.text = _loc_20;
                        }
                        else if (_loc_8 > 0 && _loc_10 > 0)
                        {
                            _loc_12 = _loc_12 + _loc_20;
                            _loc_23 = _loc_12.length - _loc_8;
                            _loc_14.text = UtilsStr.trimRight(_loc_12.substr(0, _loc_23));
                            _loc_14.width = _loc_10;
                            _loc_12 = _loc_12.substr(_loc_23);
                            _loc_3 = _loc_3 - _loc_9;
                        }
                        else
                        {
                            _loc_14.text = _loc_12;
                            _loc_14.width = _loc_3 - (_loc_6 + this._letterSpacing);
                            _loc_12 = _loc_20;
                            _loc_3 = _loc_6;
                            _loc_4 = _loc_7;
                            _loc_5 = _loc_7;
                        }
                        _loc_14.y = _loc_13;
                        _loc_13 = _loc_13 + (_loc_14.height + this._leading);
                        if (_loc_14.width > this._textWidth)
                        {
                            this._textWidth = _loc_14.width;
                        }
                        _loc_8 = 0;
                        _loc_9 = 0;
                        _loc_10 = 0;
                        this._lines.push(_loc_14);
                    }
                }
                _loc_18++;
            }
            if (_loc_12.length > 0)
            {
                _loc_14 = new LineInfo();
                _loc_14.width = _loc_3;
                if (_loc_4 == 0)
                {
                    _loc_4 = _loc_11;
                }
                if (_loc_5 == 0)
                {
                    _loc_5 = _loc_4;
                }
                _loc_14.height = _loc_4;
                _loc_14.textHeight = _loc_5;
                _loc_14.text = _loc_12;
                _loc_14.y = _loc_13;
                if (_loc_14.width > this._textWidth)
                {
                    this._textWidth = _loc_14.width;
                }
                this._lines.push(_loc_14);
            }
            if (this._textWidth > 0)
            {
                this._textWidth = this._textWidth + GUTTER_X * 2;
            }
            var _loc_19:* = this._lines.length;
            if (this._lines.length == 0)
            {
                this._textHeight = 0;
            }
            else
            {
                _loc_14 = this._lines[(this._lines.length - 1)];
                this._textHeight = _loc_14.y + _loc_14.height + GUTTER_Y;
            }
            return;
        }// end function

        private function resizeText(param1:int) : void
        {
            this._shrinkScale = param1 / this._fontSize;
            if (this._bitmapFontRef)
            {
                this.buildLines();
            }
            else
            {
                this._textFormat.size = param1;
                this._textField.setTextFormat(this._textFormat);
                this.getTextSize();
            }
            return;
        }// end function

        protected function doShrink() : void
        {
            var _loc_1:* = NaN;
            var _loc_2:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_3:* = this._bitmapFontRef ? (this._lines.length) : (this._textField.numLines);
            if (_loc_3 > 1 && this._textHeight > _height)
            {
                _loc_4 = 0;
                _loc_5 = this._fontSize;
                _loc_1 = Math.sqrt(_height / this._textHeight);
                _loc_2 = Math.floor(_loc_1 * this._fontSize);
                while (true)
                {
                    
                    this.resizeText(_loc_2);
                    if (this._textWidth > _width || this._textHeight > _height)
                    {
                        _loc_5 = _loc_2;
                    }
                    else
                    {
                        _loc_4 = _loc_2;
                    }
                    if (_loc_5 - _loc_4 > 1 || _loc_5 != _loc_4 && _loc_2 == _loc_5)
                    {
                        _loc_2 = _loc_4 + (_loc_5 - _loc_4) / 2;
                        continue;
                    }
                    break;
                }
            }
            else if (this._textWidth > _width)
            {
                _loc_1 = _width / this._textWidth;
                _loc_2 = Math.floor(_loc_1 * this._fontSize);
                this.resizeText(_loc_2);
                while (_loc_2 > 1 && this._textWidth > _width)
                {
                    
                    _loc_2 = _loc_2 - 1;
                    this.resizeText(_loc_2);
                }
            }
            return;
        }// end function

        private function render() : void
        {
            GTimers.inst.callLater(this.delayUpdate);
            return;
        }// end function

        private function delayUpdate() : void
        {
            if (this._bitmapFontRef)
            {
                if (this._bitmapFontRef.displayItem.getBitmapFont().textReady)
                {
                    this.drawBitmapText();
                }
                else
                {
                    GTimers.inst.callLater(this.delayUpdate);
                }
            }
            else
            {
                this.drawText();
            }
            return;
        }// end function

        public function get bitmapMode() : Boolean
        {
            return this._bitmapMode;
        }// end function

        public function set bitmapMode(param1:Boolean) : void
        {
            if (this._bitmapMode != param1)
            {
                this._bitmapMode = param1;
                if (this._bitmapFontRef == null)
                {
                    this.updateSize();
                    if (this._bitmapMode)
                    {
                        GTimers.inst.callLater(this.updateSize);
                    }
                }
            }
            return;
        }// end function

        private function prepareCanvas() : Boolean
        {
            var _loc_1:* = 0;
            if ((this._bitmapFontRef != null || this._bitmapMode) && !this._input)
            {
                if (!this._bitmap)
                {
                    this._bitmap = new Bitmap();
                    this._bitmap.y = this._yOffset;
                }
                if (!this._bitmap.parent)
                {
                    _displayObject.container.removeChild(this._textField);
                    _displayObject.container.addChildAt(this._bitmap, 0);
                }
                _loc_1 = _height - this._bitmap.y;
                if (_width == 0 || _loc_1 == 0)
                {
                    this._bitmap.bitmapData = null;
                    return false;
                }
                if (this._bitmapData != null && (this._bitmapData.width != _width || this._bitmapData.height != _loc_1))
                {
                    this._bitmapData.dispose();
                    this._bitmapData = null;
                }
                if (!this._bitmapData)
                {
                    this._bitmapData = new BitmapData(_width, _loc_1, true, 0);
                }
                else
                {
                    this._bitmapData.fillRect(this._bitmapData.rect, 0);
                }
                this._bitmap.bitmapData = this._bitmapData;
                this._bitmap.smoothing = true;
                if (this._bitmap.filters != this._textFilters)
                {
                    this._bitmap.filters = this._textFilters;
                }
            }
            else
            {
                if (!this._textField.parent)
                {
                    _displayObject.container.removeChild(this._bitmap);
                    _displayObject.container.addChildAt(this._textField, 0);
                }
                if (this._textField.filters != this._textFilters)
                {
                    this._textField.filters = this._textFilters;
                }
            }
            return true;
        }// end function

        private function drawText() : void
        {
            if (!this.prepareCanvas())
            {
                return;
            }
            if (this._textField.parent)
            {
                return;
            }
            this._bitmapData.draw(this._textField, null, null, null, null, true);
            return;
        }// end function

        private function drawBitmapText() : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = 0;
            var _loc_13:* = 0;
            var _loc_14:* = null;
            var _loc_15:* = 0;
            var _loc_16:* = null;
            if (!this.prepareCanvas())
            {
                return;
            }
            var _loc_1:* = this._bitmapFontRef.displayItem.getBitmapFont();
            var _loc_2:* = _width - GUTTER_X * 2;
            var _loc_3:* = GUTTER_X;
            var _loc_6:* = new Rectangle();
            var _loc_7:* = new Point();
            var _loc_8:* = (_loc_1.resizable ? (this._fontSize / _loc_1.size) : (1)) * this._shrinkScale;
            var _loc_9:* = this._lines.length;
            var _loc_10:* = 0;
            while (_loc_10 < _loc_9)
            {
                
                _loc_11 = this._lines[_loc_10];
                _loc_3 = GUTTER_X;
                if (this._align == "center")
                {
                    _loc_4 = (_loc_2 - _loc_11.width) / 2;
                }
                else if (this._align == "right")
                {
                    _loc_4 = _loc_2 - _loc_11.width;
                }
                else
                {
                    _loc_4 = 0;
                }
                _loc_12 = _loc_11.text.length;
                _loc_13 = 0;
                while (_loc_13 < _loc_12)
                {
                    
                    _loc_14 = _loc_11.text.charAt(_loc_13);
                    _loc_15 = _loc_14.charCodeAt(0);
                    if (_loc_15 == 10)
                    {
                    }
                    else if (_loc_15 == 32)
                    {
                        _loc_3 = _loc_3 + (this._letterSpacing + Math.ceil(this._fontSize * _loc_8 / 2));
                    }
                    else
                    {
                        _loc_16 = _loc_1.getGlyph(_loc_14);
                        if (_loc_16 != null)
                        {
                            _loc_5 = (_loc_11.height + _loc_11.textHeight) / 2 - Math.ceil(_loc_16.lineHeight * _loc_8);
                            _loc_7.x = _loc_3 + _loc_4;
                            _loc_7.y = _loc_11.y + _loc_5;
                            _loc_1.draw(this._bitmapData, _loc_16, _loc_7, this._color, _loc_8, _flags);
                            _loc_3 = _loc_3 + (this._letterSpacing + Math.ceil(_loc_16.advance * _loc_8));
                        }
                        else
                        {
                            _loc_3 = _loc_3 + this._letterSpacing;
                        }
                    }
                    _loc_13++;
                }
                _loc_10++;
            }
            return;
        }// end function

        private function updateTextFormat() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (this._font)
            {
                _loc_1 = this._font;
            }
            else
            {
                _loc_1 = _pkg.project.getSetting("common", "font");
            }
            if (this._bitmapFontRef)
            {
                this._bitmapFontRef.release();
                this._bitmapFontRef = null;
            }
            if (UtilsStr.startsWith(_loc_1, "ui://"))
            {
                _loc_2 = _pkg.project.getItemByURL(_loc_1);
                if (_loc_2 != null)
                {
                    this._bitmapFontRef = new ResourceRef(_loc_2, null, _flags);
                    _loc_3 = this._bitmapFontRef.displayItem.getBitmapFont();
                    this._fontVersion = _loc_2.version;
                    _internalMinHeight = Math.ceil(_loc_3.lineHeight * (_loc_3.resizable ? (this._fontSize / _loc_3.size) : (1)));
                    this._fontAdjustment = 0;
                }
                else
                {
                    _loc_1 = "Arial";
                }
            }
            if (this._bitmapFontRef == null)
            {
                this._textFormat.font = _loc_1;
                this._fontVersion = FProject(_pkg.project)._globalFontVersion;
                _loc_4 = CharSize.getSize(this._fontSize, _loc_1, this._bold);
                if (_pkg.project.getSetting("common", "fontAdjustment"))
                {
                    this._fontAdjustment = _loc_4.yIndent;
                }
                else
                {
                    this._fontAdjustment = 0;
                }
                _internalMinHeight = _loc_4.height + 4;
            }
            this._textFormat.size = this._fontSize;
            this._textFormat.bold = this._bold;
            this._textFormat.italic = this._italic;
            this._textFormat.color = this._color;
            this._textFormat.align = this._align;
            this._textFormat.leading = this._leading - this._fontAdjustment;
            this._textFormat.letterSpacing = this._letterSpacing;
            this._textFormat.underline = this._underline;
            if (this._handCursor)
            {
                this._textFormat.url = "event:x";
            }
            else
            {
                this._textFormat.url = null;
            }
            this._textField.defaultTextFormat = this._textFormat;
            this._textField.setTextFormat(this._textFormat);
            if (this._ubbEnabled)
            {
                this.text = this._text;
            }
            this.updateSize();
            return;
        }// end function

        override public function handleSizeChanged() : void
        {
            if (!this._updatingSize)
            {
                if (this._bitmapFontRef != null)
                {
                    this.updateSize(true);
                }
                else if (!this._widthAutoSize)
                {
                    this._textField.width = _width;
                    this.updateSize(true);
                }
                else
                {
                    this.doAlign();
                }
            }
            super.handleSizeChanged();
            return;
        }// end function

        protected function doAlign() : void
        {
            var _loc_1:* = NaN;
            if (this._verticalAlign == "top")
            {
                this._yOffset = 0;
            }
            else
            {
                if (this._textHeight == 0)
                {
                    _loc_1 = _height - int(int(this._textFormat.size));
                }
                else
                {
                    _loc_1 = _height - int(this._textHeight);
                }
                if (this._verticalAlign == "middle")
                {
                    this._yOffset = int(_loc_1 / 2);
                }
                else
                {
                    this._yOffset = int(_loc_1);
                }
            }
            this._yOffset = this._yOffset - this._fontAdjustment;
            if (this._bitmap)
            {
                this._bitmap.y = this._yOffset;
            }
            this._textField.y = this._yOffset;
            if (this._yOffset != 0)
            {
                this._textField.height = _height - this._yOffset;
            }
            return;
        }// end function

        public function copyTextFormat(param1:FTextField) : void
        {
            this._font = param1._font;
            this._fontSize = param1._fontSize;
            this._color = param1._color;
            this._align = param1._align;
            this._verticalAlign = param1._verticalAlign;
            this._leading = param1._leading;
            this._letterSpacing = param1._letterSpacing;
            this._ubbEnabled = param1._ubbEnabled;
            this._underline = param1._underline;
            this._italic = param1._italic;
            this._bold = param1._bold;
            this._singleLine = param1._singleLine;
            this._textField.multiline = param1._textField.multiline;
            this._varsEnabled = param1._varsEnabled;
            this._strokeColor = param1._strokeColor;
            this._strokeSize = param1._strokeSize;
            this.stroke = param1.stroke;
            this._shadowX = param1._shadowX;
            this._shadowY = param1._shadowY;
            this.shadow = param1.shadow;
            this.updateTextFormat();
            return;
        }// end function

        override public function getProp(param1:int)
        {
            switch(param1)
            {
                case ObjectPropID.Color:
                {
                    return this.color;
                }
                case ObjectPropID.OutlineColor:
                {
                    return this.strokeColor;
                }
                case ObjectPropID.FontSize:
                {
                    return this.fontSize;
                }
                default:
                {
                    return super.getProp(param1);
                    break;
                }
            }
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            switch(param1)
            {
                case ObjectPropID.Color:
                {
                    this.color = param2;
                    break;
                }
                case ObjectPropID.OutlineColor:
                {
                    this.strokeColor = param2;
                    break;
                }
                case ObjectPropID.FontSize:
                {
                    this.fontSize = param2;
                    break;
                }
                default:
                {
                    super.setProp(param1, param2);
                    break;
                    break;
                }
            }
            return;
        }// end function

        override public function read_beforeAdd(param1:XData, param2:Object) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = undefined;
            super.read_beforeAdd(param1, param2);
            this._updatingSize = true;
            this.input = param1.getAttributeBool("input");
            if (this._input)
            {
                this._promptText = param1.getAttribute("prompt", "");
                if (param2)
                {
                    _loc_5 = param2[_id + "-prompt"];
                    if (_loc_5 != undefined)
                    {
                        this._promptText = _loc_5;
                    }
                }
                this._maxLength = param1.getAttributeInt("maxLength");
                this._restrict = param1.getAttribute("restrict");
                this._keyboardType = param1.getAttributeInt("keyboardType");
                this._password = param1.getAttributeBool("password");
                this.touchDisabled = false;
                handleTouchableChanged();
            }
            this._font = param1.getAttribute("font");
            this._fontSize = param1.getAttributeInt("fontSize", _pkg.project.getSetting("common", "fontSize"));
            this._color = param1.getAttributeColor("color", false, 0);
            this._align = param1.getAttribute("align", "left");
            this._verticalAlign = param1.getAttribute("vAlign", "top");
            this._leading = param1.getAttributeInt("leading", 3);
            this._letterSpacing = param1.getAttributeInt("letterSpacing");
            this._ubbEnabled = param1.getAttributeBool("ubb");
            this._varsEnabled = param1.getAttributeBool("vars");
            this._underline = param1.getAttributeBool("underline");
            this._italic = param1.getAttributeBool("italic");
            this._bold = param1.getAttributeBool("bold");
            this._singleLine = param1.getAttributeBool("singleLine");
            this._textField.multiline = !this._singleLine;
            _loc_3 = param1.getAttribute("strokeColor");
            if (_loc_3)
            {
                this._strokeColor = UtilsStr.convertFromHtmlColor(_loc_3);
                this._strokeSize = param1.getAttributeInt("strokeSize", 1);
                this.stroke = true;
            }
            _loc_3 = param1.getAttribute("shadowColor");
            if (_loc_3)
            {
                if (!this._stroke)
                {
                    this._strokeColor = UtilsStr.convertFromHtmlColor(_loc_3);
                }
                _loc_3 = param1.getAttribute("shadowOffset");
                if (_loc_3)
                {
                    _loc_4 = _loc_3.split(",");
                    this._shadowX = parseFloat(_loc_4[0]);
                    this._shadowY = parseFloat(_loc_4[1]);
                }
                this.shadow = true;
            }
            _loc_3 = param1.getAttribute("autoSize", "both");
            this.autoSize = _loc_3;
            if (!this._widthAutoSize)
            {
                this._textField.wordWrap = !this._singleLine;
            }
            this.clearOnPublish = param1.getAttributeBool("autoClearText");
            this.updateTextFormat();
            this._updatingSize = false;
            _loc_3 = param1.getAttribute("text", "");
            if (_loc_3 || this._input)
            {
                if (param2)
                {
                    _loc_5 = param2[_id];
                    if (_loc_5 != undefined)
                    {
                        _loc_3 = _loc_5;
                    }
                }
                this.text = _loc_3;
            }
            return;
        }// end function

        override public function write() : XData
        {
            var _loc_1:* = super.write();
            if (this._input)
            {
                _loc_1.setAttribute("input", true);
                if (this._promptText)
                {
                    _loc_1.setAttribute("prompt", this._promptText);
                }
                if (this._maxLength > 0)
                {
                    _loc_1.setAttribute("maxLength", this._maxLength);
                }
                if (this._restrict)
                {
                    _loc_1.setAttribute("restrict", this._restrict);
                }
                if (this._keyboardType)
                {
                    _loc_1.setAttribute("keyboardType", this._keyboardType);
                }
                if (this._password)
                {
                    _loc_1.setAttribute("password", true);
                }
            }
            if (this._font)
            {
                _loc_1.setAttribute("font", this._font);
            }
            _loc_1.setAttribute("fontSize", this._fontSize);
            if (this._color != 0)
            {
                _loc_1.setAttribute("color", UtilsStr.convertToHtmlColor(this._color));
            }
            if (this._align != "left")
            {
                _loc_1.setAttribute("align", this._align);
            }
            if (this._verticalAlign != "top")
            {
                _loc_1.setAttribute("vAlign", this._verticalAlign);
            }
            if (this._leading != 3)
            {
                _loc_1.setAttribute("leading", this._leading);
            }
            if (this._letterSpacing != 0)
            {
                _loc_1.setAttribute("letterSpacing", this._letterSpacing);
            }
            if (this._ubbEnabled)
            {
                _loc_1.setAttribute("ubb", true);
            }
            if (this._varsEnabled)
            {
                _loc_1.setAttribute("vars", true);
            }
            if (this._autoSize != "both")
            {
                _loc_1.setAttribute("autoSize", this._autoSize);
            }
            if (this._underline)
            {
                _loc_1.setAttribute("underline", true);
            }
            if (this._bold)
            {
                _loc_1.setAttribute("bold", true);
            }
            if (this._italic)
            {
                _loc_1.setAttribute("italic", true);
            }
            if (this._stroke)
            {
                _loc_1.setAttribute("strokeColor", UtilsStr.convertToHtmlColor(this._strokeColor));
                if (this._strokeSize != 1)
                {
                    _loc_1.setAttribute("strokeSize", this._strokeSize);
                }
            }
            if (this._shadow)
            {
                _loc_1.setAttribute("shadowColor", UtilsStr.convertToHtmlColor(this._strokeColor));
                _loc_1.setAttribute("shadowOffset", this._shadowX + "," + this._shadowY);
            }
            if (this._singleLine)
            {
                _loc_1.setAttribute("singleLine", true);
            }
            if (this.clearOnPublish)
            {
                _loc_1.setAttribute("autoClearText", true);
            }
            _loc_1.setAttribute("text", this._text);
            return _loc_1;
        }// end function

        private function __focusIn(event:Event) : void
        {
            if (!this._text && this._promptText)
            {
                this._textField.displayAsPassword = this.password;
                this._textField.text = "";
            }
            return;
        }// end function

        private function __focusOut(event:Event) : void
        {
            this._text = this._textField.text;
            if (!this._text && this._promptText)
            {
                this._textField.displayAsPassword = false;
                this._textField.htmlText = UBBParser.inst.parse(ToolSet.encodeHTML(this._promptText));
            }
            return;
        }// end function

    }
}

import *.*;

import __AS3__.vec.*;

import fairygui.*;

import fairygui.editor.gui.text.*;

import fairygui.utils.*;

import flash.display.*;

import flash.events.*;

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

