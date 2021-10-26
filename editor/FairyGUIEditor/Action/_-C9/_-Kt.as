package _-C9
{
    import *.*;
    import _-An.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class _-Kt extends Object implements IDocHistoryItem, IDisposable
    {
        private var _-6S:int;
        private var _-J5:String;
        private var _obj:FObject;
        private var _index:int;
        private var _-6f:int;

        public function _-Kt()
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
            var _loc_3:* = 0;
            switch(this._-6S)
            {
                case 0:
                {
                    _loc_2 = param1.content.getChildById(this._-J5);
                    if (!_loc_2)
                    {
                        return false;
                    }
                    if (_loc_2.docElement.selected)
                    {
                        param1.unselectObject(_loc_2);
                    }
                    param1.content.removeChild(_loc_2);
                    if (_loc_2 is FGroup)
                    {
                        _-On(param1).notifyGroupRemoved(FGroup(_loc_2));
                    }
                    this._-6S = 1;
                    this._obj = _loc_2;
                    break;
                }
                case 1:
                {
                    param1.content.addChildAt(this._obj, this._index);
                    if (this._obj.deprecated)
                    {
                        this._obj.recreate();
                    }
                    param1.selectObject(this._obj);
                    this._-6S = 0;
                    this._obj = null;
                    break;
                }
                case 2:
                {
                    _loc_2 = param1.content.getChildById(this._-J5);
                    if (!_loc_2)
                    {
                        return false;
                    }
                    _loc_3 = param1.content.getChildIndex(_loc_2);
                    param1.content.removeChildAt(_loc_3);
                    param1.content.addChildAt(this._obj, _loc_3);
                    param1.selectObject(this._obj);
                    this._-J5 = this._obj._id;
                    this._obj = _loc_2;
                    break;
                }
                case 3:
                {
                    _loc_2 = param1.content.getChildById(this._-J5);
                    if (!_loc_2)
                    {
                        return false;
                    }
                    _loc_3 = param1.content.getChildIndex(_loc_2);
                    param1.content.setChildIndex(_loc_2, this._index);
                    param1.selectObject(_loc_2);
                    this._index = _loc_3;
                    break;
                }
                default:
                {
                    break;
                }
            }
            param1.editor.emit(EditorEvent.HierarchyChanged);
            return true;
        }// end function

        public function dispose() : void
        {
            if (this._obj)
            {
                this._obj.dispose();
            }
            return;
        }// end function

        public static function addChild(param1:IDocument, param2:FObject) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_3:* = new _-Kt;
            _loc_3._-6S = 0;
            _loc_3._-J5 = param2._id;
            _loc_3._index = param2.parent.getChildIndex(param2);
            param1.history.add(_loc_3);
            return;
        }// end function

        public static function removeChild(param1:IDocument, param2:FObject) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_3:* = new _-Kt;
            _loc_3._-6S = 1;
            _loc_3._-J5 = param2._id;
            _loc_3._obj = param2;
            _loc_3._index = param2.parent.getChildIndex(param2);
            param1.history.add(_loc_3);
            return;
        }// end function

        public static function _-FO(param1:IDocument, param2:FObject, param3:FObject) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_4:* = new _-Kt;
            _loc_4._-6S = 2;
            _loc_4._-J5 = param3._id;
            _loc_4._obj = param2;
            param1.history.add(_loc_4);
            return;
        }// end function

        public static function setChildIndex(param1:IDocument, param2:FObject, param3:int) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            var _loc_4:* = new _-Kt;
            _loc_4._-6S = 3;
            _loc_4._-J5 = param2._id;
            _loc_4._index = param3;
            param1.history.add(_loc_4);
            return;
        }// end function

    }
}
