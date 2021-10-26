package _-Pz
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class CustomPropsPanel extends _-5I
    {
        private var _list:GList;

        public function CustomPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "CustomPropsPanel").asCom;
            this._list = _panel.getChild("list").asList;
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_1:* = this.inspectingTarget as FComponent;
            if (!_loc_1)
            {
                return false;
            }
            this._list.removeChildrenToPool();
            var _loc_2:* = _loc_1.customProperties;
            for each (_loc_3 in _loc_2)
            {
                
                _loc_4 = this._list.addItemFromPool() as ComPropertyInput;
                _loc_4.addEventListener(_-Fr._-CF, this._-Ps);
                _loc_4.data = _loc_3;
                _loc_4.update(_loc_3, _loc_1);
            }
            if (this._list.numChildren > 0)
            {
                this._list.resizeToFit();
                return true;
            }
            return false;
        }// end function

        private function _-Ps(event:Event) : void
        {
            var _loc_7:* = null;
            var _loc_2:* = ComPropertyInput(event.currentTarget);
            var _loc_3:* = ComProperty(_loc_2.data);
            var _loc_4:* = this.inspectingTargets;
            var _loc_5:* = _loc_4.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = _loc_4[_loc_6] as FComponent;
                _loc_7.docElement.setChildProperty(_loc_3.target, _loc_3.propertyId, _loc_2.value);
                _loc_6++;
            }
            return;
        }// end function

    }
}
