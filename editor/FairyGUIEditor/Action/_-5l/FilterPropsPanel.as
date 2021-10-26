package _-5l
{
    import *.*;
    import _-Gs.*;
    import _-Pz.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.desktop.*;
    import flash.events.*;

    public class FilterPropsPanel extends _-5I
    {

        public function FilterPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "FilterPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"brightness", type:"float", min:-1, max:1, precision:2}, {name:"contrast", type:"float", min:-1, max:1, precision:2}, {name:"saturation", type:"float", min:-1, max:1, precision:2}, {name:"hue", type:"float", min:-1, max:1, precision:2}]);
            _panel.getChild("copy").addClickListener(this._-8M);
            _panel.getChild("paste").addClickListener(this._-HD);
            _panel.getChild("reset").addClickListener(this._-MY);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = this.inspectingTarget;
            _form.setValue("brightness", _loc_1.filterData.brightness);
            _form.setValue("contrast", _loc_1.filterData.contrast);
            _form.setValue("saturation", _loc_1.filterData.saturation);
            _form.setValue("hue", _loc_1.filterData.hue);
            _form.updateUI();
            return true;
        }// end function

        private function _-8M(event:Event) : void
        {
            var _loc_2:* = this.inspectingTarget;
            Clipboard.generalClipboard.setData("fairygui.ColorFilter", [_loc_2.filterData.brightness, _loc_2.filterData.contrast, _loc_2.filterData.saturation, _loc_2.filterData.hue]);
            return;
        }// end function

        private function _-HD(event:Event) : void
        {
            var _loc_2:* = null;
            if (Clipboard.generalClipboard.hasFormat("fairygui.ColorFilter"))
            {
                _loc_2 = Clipboard.generalClipboard.getData("fairygui.ColorFilter") as Array;
                this.setValue(_loc_2[0], _loc_2[1], _loc_2[2], _loc_2[3]);
            }
            return;
        }// end function

        private function _-MY(event:Event) : void
        {
            this.setValue(0, 0, 0, 0);
            return;
        }// end function

        private function setValue(param1:Number, param2:Number, param3:Number, param4:Number) : void
        {
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_5:* = this.inspectingTargets;
            var _loc_6:* = _loc_5.length;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_8 = _loc_5[_loc_7];
                _loc_9 = _loc_8.filterData.clone();
                _loc_9.brightness = param1;
                _loc_9.contrast = param2;
                _loc_9.saturation = param3;
                _loc_9.hue = param4;
                _loc_8.docElement.setProperty("filterData", _loc_9);
                _loc_7++;
            }
            return;
        }// end function

        protected function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_4:* = this.inspectingTargets;
            var _loc_5:* = _loc_4.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = _loc_4[_loc_6];
                _loc_8 = _loc_7.filterData.clone();
                _loc_8.copyFrom(_loc_7.filterData);
                _loc_8[param1] = param2;
                _loc_7.docElement.setProperty("filterData", _loc_8);
                _loc_6++;
            }
            return;
        }// end function

    }
}
