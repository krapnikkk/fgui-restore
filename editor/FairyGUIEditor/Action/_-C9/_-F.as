package _-C9
{
    import *.*;
    import _-An.*;
    import fairygui.editor.api.*;
    import fairygui.utils.*;

    public class _-F extends Object implements IDocHistoryItem
    {
        private var _value:Object;

        public function _-F()
        {
            return;
        }// end function

        public function get isPersists() : Boolean
        {
            return true;
        }// end function

        public function process(param1:IDocument) : Boolean
        {
            var _loc_2:* = _-On(param1).content.transitions.write();
            _-On(param1).updateTransitions(this._value);
            this._value = _loc_2;
            return true;
        }// end function

        public static function _-Pc(param1:IDocument, param2) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_3:* = new _-F;
            _loc_3._value = param2;
            param1.history.add(_loc_3);
            return;
        }// end function

    }
}
