package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class LoaderPropsPanel extends _-5I
    {
        private var _-IC:Object;

        public function LoaderPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "LoaderPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"url", type:"string"}, {name:"align", type:"string", items:[Consts.strings.text153, Consts.strings.text154, Consts.strings.text155], values:["left", "center", "right"]}, {name:"verticalAlign", type:"string", items:[Consts.strings.text156, Consts.strings.text157, Consts.strings.text158], values:["top", "middle", "bottom"]}, {name:"autoSize", type:"bool", items:[Consts.strings.text161, Consts.strings.text162]}, {name:"shrinkOnly", type:"bool"}, {name:"playing", type:"bool"}, {name:"frame", type:"int", min:0}, {name:"color", type:"uint"}, {name:"brightness", type:"int", min:0, max:255, dummy:true}, {name:"fill", type:"string", items:[Consts.strings.text331, Consts.strings.text159, Consts.strings.text342, Consts.strings.text308, Consts.strings.text309, Consts.strings.text160], values:["none", "scale", "scaleNoBorder", "scaleMatchHeight", "scaleMatchWidth", "scaleFree"]}, {name:"fillMethod", type:"string", items:[Consts.strings.text331, Consts.strings.text268, Consts.strings.text269, Consts.strings.text270, Consts.strings.text271, Consts.strings.text272], values:["none", "hz", "vt", "radial90", "radial180", "radial360"]}, {name:"fillAmount", type:"float", min:0, max:100}, {name:"fillOrigin", type:"int"}, {name:"fillClockwise", type:"bool"}, {name:"clearOnPublish", type:"bool"}]);
            this._-IC = {none:[Consts.strings.text331], hz:[Consts.strings.text274, Consts.strings.text275], vt:[Consts.strings.text276, Consts.strings.text277], radial90:[Consts.strings.text278, Consts.strings.text280, Consts.strings.text279, Consts.strings.text281], radial180:[Consts.strings.text276, Consts.strings.text277, Consts.strings.text274, Consts.strings.text275], radial360:[Consts.strings.text276, Consts.strings.text277, Consts.strings.text274, Consts.strings.text275]};
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = FLoader(this.inspectingTarget);
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
            _form._-Om("fillOrigin").asComboBox.items = this._-IC[_loc_1.fillMethod];
            _form._-Om("fillClockwise").enabled = _loc_1.fillMethod != "hz" && _loc_1.fillMethod != "vt";
            _form._-Cm(_loc_1);
            _form.updateUI();
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_4:* = 0;
            if (param1 == "brightness")
            {
                _loc_4 = int(param2);
                _loc_4 = (_loc_4 << 16) + (_loc_4 << 8) + _loc_4;
                _-Ix("color", _loc_4, param3);
            }
            else
            {
                _-Ix(param1, param2, param3);
            }
            return;
        }// end function

    }
}
