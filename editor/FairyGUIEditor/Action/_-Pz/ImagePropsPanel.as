package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class ImagePropsPanel extends _-5I
    {
        private var _-IC:Object;

        public function ImagePropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "ImagePropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"color", type:"uint"}, {name:"brightness", type:"int", min:0, max:255, dummy:true}, {name:"flipHZ", type:"bool", dummy:true}, {name:"flipVT", type:"bool", dummy:true}, {name:"fillMethod", type:"string", items:[Consts.strings.text331, Consts.strings.text268, Consts.strings.text269, Consts.strings.text270, Consts.strings.text271, Consts.strings.text272], values:["none", "hz", "vt", "radial90", "radial180", "radial360"]}, {name:"fillAmount", type:"float", min:0, max:100}, {name:"fillOrigin", type:"int"}, {name:"fillClockwise", type:"bool"}]);
            this._-IC = {none:[Consts.strings.text331], hz:[Consts.strings.text274, Consts.strings.text275], vt:[Consts.strings.text276, Consts.strings.text277], radial90:[Consts.strings.text278, Consts.strings.text280, Consts.strings.text279, Consts.strings.text281], radial180:[Consts.strings.text276, Consts.strings.text277, Consts.strings.text274, Consts.strings.text275], radial360:[Consts.strings.text276, Consts.strings.text277, Consts.strings.text274, Consts.strings.text275]};
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = FImage(this.inspectingTarget);
            var _loc_2:* = _loc_1.color >> 16 & 255;
            var _loc_3:* = _loc_1.color >> 8 & 255;
            var _loc_4:* = _loc_1.color & 255;
            if (_loc_2 == _loc_3 && _loc_3 == _loc_4)
            {
                _form.setValue("brightness", _loc_2);
            }
            else
            {
                _form.setValue("brightness", 255);
            }
            _form.setValue("flipHZ", _loc_1.flip == "hz" || _loc_1.flip == "both");
            _form.setValue("flipVT", _loc_1.flip == "vt" || _loc_1.flip == "both");
            _form._-Om("fillOrigin").asComboBox.items = this._-IC[_loc_1.fillMethod];
            _form._-Om("fillClockwise").enabled = _loc_1.fillMethod != "hz" && _loc_1.fillMethod != "vt";
            _form._-Cm(_loc_1);
            _form.updateUI();
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = false;
            var _loc_6:* = false;
            if (param1 == "brightness")
            {
                _loc_4 = int(param2);
                _loc_4 = (_loc_4 << 16) + (_loc_4 << 8) + _loc_4;
                _-Ix("color", _loc_4, param3);
            }
            else if (param1 == "flipHZ" || param1 == "flipVT")
            {
                _loc_5 = _form._-4y("flipHZ");
                _loc_6 = _form._-4y("flipVT");
                _-Ix("flip", _loc_5 && _loc_6 ? ("both") : (_loc_5 ? ("hz") : (_loc_6 ? ("vt") : ("none"))), param3);
            }
            else
            {
                _-Ix(param1, param2, param3);
            }
            return;
        }// end function

    }
}
