package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.text.*;

    public class TextInputHistory extends Object
    {
        private var _undoBuffer:Vector.<String>;
        private var _redoBuffer:Vector.<String>;
        private var _currentText:String;
        private var _textField:TextField;
        private var _lock:Boolean;
        public var maxHistoryLength:int = 5;
        private static var _inst:TextInputHistory;

        public function TextInputHistory()
        {
            _undoBuffer = new Vector.<String>;
            _redoBuffer = new Vector.<String>;
            return;
        }// end function

        public function startRecord(param1:TextField) : void
        {
            _undoBuffer.length = 0;
            _redoBuffer.length = 0;
            _textField = param1;
            _lock = false;
            _currentText = param1.text;
            return;
        }// end function

        public function markChanged(param1:TextField) : void
        {
            if (_textField != param1)
            {
                return;
            }
            if (_lock)
            {
                return;
            }
            var _loc_2:* = _textField.text;
            if (_currentText == _loc_2)
            {
                return;
            }
            _undoBuffer.push(_currentText);
            if (_undoBuffer.length > maxHistoryLength)
            {
                _undoBuffer.splice(0, 1);
            }
            _currentText = _loc_2;
            return;
        }// end function

        public function stopRecord(param1:TextField) : void
        {
            if (_textField != param1)
            {
                return;
            }
            _undoBuffer.length = 0;
            _redoBuffer.length = 0;
            _textField = null;
            _currentText = null;
            return;
        }// end function

        public function undo(param1:TextField) : void
        {
            if (_textField != param1)
            {
                return;
            }
            if (_undoBuffer.length == 0)
            {
                return;
            }
            var _loc_2:* = _undoBuffer.pop();
            _redoBuffer.push(_currentText);
            _lock = true;
            _textField.text = _loc_2;
            _currentText = _loc_2;
            _lock = false;
            _textField.dispatchEvent(new Event("change"));
            return;
        }// end function

        public function redo(param1:TextField) : void
        {
            if (_textField != param1)
            {
                return;
            }
            if (_redoBuffer.length == 0)
            {
                return;
            }
            var _loc_2:* = _redoBuffer.pop();
            _undoBuffer.push(_currentText);
            _lock = true;
            _textField.text = _loc_2;
            var _loc_3:* = _loc_2.length - _currentText.length;
            if (_loc_3 > 0)
            {
                _textField.setSelection(_textField.caretIndex + _loc_3, _textField.caretIndex + _loc_3);
            }
            _currentText = _loc_2;
            _lock = false;
            _textField.dispatchEvent(new Event("change"));
            return;
        }// end function

        public static function get inst() : TextInputHistory
        {
            if (_inst == null)
            {
                _inst = new TextInputHistory;
            }
            return _inst;
        }// end function

    }
}
