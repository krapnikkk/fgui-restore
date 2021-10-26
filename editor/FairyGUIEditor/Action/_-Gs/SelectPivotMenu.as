package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;

    public class SelectPivotMenu extends Object
    {
        private var _-Kz:PopupMenu;
        private var _-Og:NumericInput;
        private var _-I4:NumericInput;
        private var _editor:IEditor;

        public function SelectPivotMenu(param1:IEditor)
        {
            this._editor = param1;
            this._-Kz = new PopupMenu();
            return;
        }// end function

        public function show(param1:GObject, param2:GObject, param3:GObject = null) : void
        {
            this._-Kz.clearItems();
            this._-Kz.addItem(Consts.strings.text109, this._-9l);
            this._-Kz.addItem(Consts.strings.text261, this._-9l);
            this._-Kz.addItem(Consts.strings.text262, this._-9l);
            this._-Kz.addItem(Consts.strings.text263, this._-9l);
            this._-Kz.addItem(Consts.strings.text264, this._-9l);
            this._-Og = param1 as NumericInput;
            this._-I4 = param2 as NumericInput;
            this._-Kz.show(param3);
            return;
        }// end function

        private function _-9l(event:ItemEvent) : void
        {
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_2:* = this._-Kz.list.getChildIndex(event.itemObject);
            switch(_loc_2)
            {
                case 0:
                {
                    _loc_3 = 0.5;
                    _loc_4 = 0.5;
                    break;
                }
                case 1:
                {
                    _loc_3 = 0;
                    _loc_4 = 0;
                    break;
                }
                case 2:
                {
                    _loc_3 = 1;
                    _loc_4 = 0;
                    break;
                }
                case 3:
                {
                    _loc_3 = 0;
                    _loc_4 = 1;
                    break;
                }
                case 4:
                {
                    _loc_3 = 1;
                    _loc_4 = 1;
                    break;
                }
                default:
                {
                    break;
                }
            }
            this._-Og.value = _loc_3;
            this._-Og.dispatchEvent(new _-Fr(_-Fr._-CF));
            this._-I4.value = _loc_4;
            this._-I4.dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

        public static function _-30(param1:IEditor) : SelectPivotMenu
        {
            var _loc_2:* = param1.project.getVar("SelectPivotMenu") as ;
            if (!_loc_2)
            {
                _loc_2 = new SelectPivotMenu(param1);
                param1.project.setVar("SelectPivotMenu", _loc_2);
            }
            return _loc_2;
        }// end function

    }
}
