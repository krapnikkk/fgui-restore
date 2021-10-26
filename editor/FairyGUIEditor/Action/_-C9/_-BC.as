package _-C9
{
    import *.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;

    public class _-BC extends Object implements IDocHistoryItem
    {
        private var _-6S:int;
        private var _-OF:String;
        private var _value:Object;

        public function _-BC()
        {
            return;
        }// end function

        public function get isPersists() : Boolean
        {
            return this._-6S != 3;
        }// end function

        public function process(param1:IDocument) : Boolean
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            switch(this._-6S)
            {
                case 0:
                {
                    _loc_2 = param1.content.getController(this._-OF);
                    if (!_loc_2)
                    {
                        return false;
                    }
                    param1.removeController(this._-OF);
                    this._-6S = 1;
                    this._value = _loc_2.write();
                    break;
                }
                case 1:
                {
                    param1.addController(this._value);
                    this._-6S = 0;
                    break;
                }
                case 2:
                {
                    _loc_2 = param1.content.getController(this._-OF);
                    if (!_loc_2)
                    {
                        return false;
                    }
                    _loc_3 = _loc_2.write();
                    param1.updateController(this._-OF, this._value);
                    this._value = _loc_3;
                    break;
                }
                case 3:
                {
                    this._value = param1.switchPage(this._-OF, this._value);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return true;
        }// end function

        public static function add(param1:IDocument, param2:String) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_3:* = new _-BC;
            _loc_3._-6S = 0;
            _loc_3._-OF = param2;
            param1.history.add(_loc_3);
            return;
        }// end function

        public static function remove(param1:IDocument, param2:String, param3:FController) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_4:* = new _-BC;
            _loc_4._-6S = 1;
            _loc_4._-OF = param2;
            _loc_4._value = param3.write();
            param1.history.add(_loc_4);
            return;
        }// end function

        public static function update(param1:IDocument, param2:String, param3:XData) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_4:* = new _-BC;
            _loc_4._-6S = 2;
            _loc_4._-OF = param2;
            _loc_4._value = param3;
            param1.history.add(_loc_4);
            return;
        }// end function

        public static function switchPage(param1:IDocument, param2:String, param3:int) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_4:* = new _-BC;
            _loc_4._-6S = 3;
            _loc_4._-OF = param2;
            _loc_4._value = param3;
            param1.history.add(_loc_4);
            return;
        }// end function

    }
}
