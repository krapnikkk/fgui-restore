package _-C9
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.gui.gear.*;

    public class _-LZ extends Object implements IDocHistoryItem
    {
        private var _-J5:String;
        private var _-4:String;
        private var _-MN:int;
        private var _gearIndex:int;
        private var _value:Object;
        private var _-6S:int;
        private var _flag:int;
        public static const _-1H:int = 1;
        public static const _-X:int = 2;

        public function _-LZ()
        {
            return;
        }// end function

        public function get isPersists() : Boolean
        {
            return true;
        }// end function

        public function process(param1:IDocument) : Boolean
        {
            var _loc_2:* = null;
            var _loc_3:* = undefined;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            _loc_2 = this._-J5 ? (param1.content.getChildById(this._-J5)) : (param1.content);
            if (!_loc_2)
            {
                return false;
            }
            switch(this._-6S)
            {
                case 0:
                {
                    if ((this._flag & _-X) != 0)
                    {
                        param1.setVar("selectionTransforming", true);
                    }
                    if ((this._flag & _-1H) != 0 && _loc_2._group)
                    {
                        _loc_2._group._updating = 1;
                    }
                    _loc_3 = _loc_2[this._-4];
                    _loc_2.docElement.setProperty(this._-4, this._value);
                    this._value = _loc_3;
                    if ((this._flag & _-X) != 0)
                    {
                        param1.setVar("selectionTransforming", false);
                    }
                    if ((this._flag & _-1H) != 0 && _loc_2._group)
                    {
                        _loc_2._group._updating = 0;
                    }
                    break;
                }
                case 1:
                {
                    _loc_4 = FComponent(_loc_2).getCustomProperty(this._-4, this._-MN);
                    if (_loc_4)
                    {
                        _loc_3 = _loc_4.value;
                        _loc_2.docElement.setChildProperty(this._-4, this._-MN, this._value);
                        this._value = _loc_3;
                    }
                    break;
                }
                case 2:
                {
                    _loc_3 = _loc_2.relations.write();
                    _loc_2.docElement.updateRelations(this._value);
                    this._value = _loc_3;
                    break;
                }
                case 3:
                {
                    _loc_5 = _loc_2.getGear(this._gearIndex);
                    _loc_3 = _loc_5[this._-4];
                    _loc_2.docElement.setGearProperty(this._gearIndex, this._-4, this._value);
                    this._value = _loc_3;
                    break;
                }
                case 4:
                {
                    _loc_6 = FComponent(_loc_2).extention;
                    _loc_3 = _loc_6[this._-4];
                    _loc_2.docElement.setExtensionProperty(this._-4, this._value);
                    this._value = _loc_3;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this._-6S != 0 || this._-4 != "locked" && this._-4 != "hideByEditor")
            {
                param1.selectObject(_loc_2);
            }
            return true;
        }// end function

        public static function setProperty(param1:IDocument, param2:FObject, param3:String, param4) : void
        {
            var _loc_8:* = null;
            if (param1.history.processing)
            {
                return;
            }
            var _loc_5:* = param1.history.getPendingList();
            var _loc_6:* = _loc_5.length - 1;
            while (_loc_6 >= 0)
            {
                
                _loc_8 = _loc_5[_loc_6] as _-LZ;
                if (_loc_8 && _loc_8._-6S == 0 && _loc_8._-J5 == param2._id && _loc_8._-4 == param3)
                {
                    return;
                }
                _loc_6 = _loc_6 - 1;
            }
            var _loc_7:* = new _-LZ;
            _loc_7._-6S = 0;
            _loc_7._-J5 = param2._id;
            _loc_7._-4 = param3;
            _loc_7._value = param4;
            _loc_7._flag = (param1.getVar("selectionTransforming") ? (_-X) : (0)) | (param2._group && param2._group._updating ? (_-1H) : (0));
            param1.history.add(_loc_7);
            return;
        }// end function

        public static function setChildProperty(param1:IDocument, param2:FObject, param3:String, param4:int, param5) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_6:* = new _-LZ;
            _loc_6._-6S = 1;
            _loc_6._-J5 = param2._id;
            _loc_6._-4 = param3;
            _loc_6._-MN = param4;
            _loc_6._value = param5;
            param1.history.add(_loc_6);
            return;
        }// end function

        public static function _-Ji(param1:IDocument, param2:FObject, param3) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_4:* = new _-LZ;
            _loc_4._-6S = 2;
            _loc_4._-J5 = param2._id;
            _loc_4._value = param3;
            param1.history.add(_loc_4);
            return;
        }// end function

        public static function setGearProperty(param1:IDocument, param2:FObject, param3:int, param4:String, param5) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_6:* = new _-LZ;
            _loc_6._-6S = 3;
            _loc_6._-J5 = param2._id;
            _loc_6._gearIndex = param3;
            _loc_6._-4 = param4;
            _loc_6._value = param5;
            param1.history.add(_loc_6);
            return;
        }// end function

        public static function setExtensionProperty(param1:IDocument, param2:FObject, param3:String, param4) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_5:* = new _-LZ;
            _loc_5._-6S = 4;
            _loc_5._-J5 = param2._id;
            _loc_5._-4 = param3;
            _loc_5._value = param4;
            param1.history.add(_loc_5);
            return;
        }// end function

    }
}
