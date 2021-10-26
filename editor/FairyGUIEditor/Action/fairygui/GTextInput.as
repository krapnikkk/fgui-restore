package fairygui
{
    import *.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.system.*;

    public class GTextInput extends GTextField
    {
        private var _changed:Boolean;
        private var _promptText:String;
        private var _password:Boolean;
        public var disableIME:Boolean;

        public function GTextInput()
        {
            this.focusable = true;
            _textField.wordWrap = true;
            _textField.addEventListener("keyDown", __textChanged);
            _textField.addEventListener("change", __textChanged);
            _textField.addEventListener("focusIn", __focusIn);
            _textField.addEventListener("focusOut", __focusOut);
            return;
        }// end function

        public function set maxLength(param1:int) : void
        {
            _textField.maxChars = param1;
            return;
        }// end function

        public function get maxLength() : int
        {
            return _textField.maxChars;
        }// end function

        public function set editable(param1:Boolean) : void
        {
            if (param1)
            {
                _textField.type = "input";
                _textField.selectable = true;
            }
            else
            {
                _textField.type = "dynamic";
                _textField.selectable = false;
            }
            return;
        }// end function

        public function get editable() : Boolean
        {
            return _textField.type == "input";
        }// end function

        public function get promptText() : String
        {
            return _promptText;
        }// end function

        public function set promptText(param1:String) : void
        {
            _promptText = param1;
            renderNow();
            return;
        }// end function

        public function get restrict() : String
        {
            return _textField.restrict;
        }// end function

        public function set restrict(param1:String) : void
        {
            _textField.restrict = param1;
            return;
        }// end function

        public function get password() : Boolean
        {
            return _password;
        }// end function

        public function set password(param1:Boolean) : void
        {
            if (_password != param1)
            {
                _password = param1;
                render();
            }
            return;
        }// end function

        override protected function createDisplayObject() : void
        {
            super.createDisplayObject();
            _textField.type = "input";
            _textField.selectable = true;
            _textField.mouseEnabled = true;
            return;
        }// end function

        override public function get text() : String
        {
            if (_changed)
            {
                _changed = false;
                _text = _textField.text.replace(/\r\n/g, "\n");
                _text = _text.replace(/\r/g, "\n");
            }
            return _text;
        }// end function

        override protected function updateAutoSize() : void
        {
            return;
        }// end function

        override protected function render() : void
        {
            renderNow();
            return;
        }// end function

        override protected function renderNow() : void
        {
            var _loc_2:* = NaN;
            var _loc_1:* = NaN;
            _loc_1 = this.width;
            if (_loc_1 != _textField.width)
            {
                _textField.width = _loc_1;
            }
            _loc_2 = this.height + _fontAdjustment + 1;
            if (_loc_2 != _textField.height)
            {
                _textField.height = _loc_2;
            }
            _yOffset = -_fontAdjustment;
            _textField.y = this.y + _yOffset;
            if (!_text && _promptText)
            {
                _textField.displayAsPassword = false;
                _textField.htmlText = UBBParser.inst.parse(ToolSet.encodeHTML(_promptText));
            }
            else
            {
                _textField.displayAsPassword = _password;
                _textField.text = _text;
            }
            _changed = false;
            return;
        }// end function

        override protected function handleSizeChanged() : void
        {
            _textField.width = this.width;
            _textField.height = this.height + _fontAdjustment;
            return;
        }// end function

        override public function setup_beforeAdd(param1:XML) : void
        {
            super.setup_beforeAdd(param1);
            _promptText = param1.@prompt;
            var _loc_2:* = param1.@maxLength;
            if (_loc_2)
            {
                _textField.maxChars = this.parseInt(_loc_2);
            }
            _loc_2 = param1.@restrict;
            if (_loc_2)
            {
                _textField.restrict = _loc_2;
            }
            _password = param1.@password == "true";
            return;
        }// end function

        override public function setup_afterAdd(param1:XML) : void
        {
            super.setup_afterAdd(param1);
            if (!_text)
            {
                if (_promptText)
                {
                    _textField.displayAsPassword = false;
                    _textField.htmlText = UBBParser.inst.parse(ToolSet.encodeHTML(_promptText));
                }
            }
            return;
        }// end function

        private function __textChanged(event:Event) : void
        {
            _changed = true;
            TextInputHistory.inst.markChanged(_textField);
            return;
        }// end function

        private function __focusIn(event:Event) : void
        {
            if (disableIME && Capabilities.hasIME)
            {
                IME.enabled = false;
            }
            if (!_text && _promptText)
            {
                _textField.displayAsPassword = _password;
                _textField.text = "";
            }
            TextInputHistory.inst.startRecord(_textField);
            return;
        }// end function

        private function __focusOut(event:Event) : void
        {
            if (disableIME && Capabilities.hasIME)
            {
                IME.enabled = true;
            }
            _text = _textField.text;
            TextInputHistory.inst.stopRecord(_textField);
            _changed = false;
            if (!_text && _promptText)
            {
                _textField.displayAsPassword = false;
                _textField.htmlText = UBBParser.inst.parse(ToolSet.encodeHTML(_promptText));
            }
            return;
        }// end function

    }
}
