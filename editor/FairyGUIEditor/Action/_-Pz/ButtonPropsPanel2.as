package _-Pz
{
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class ButtonPropsPanel2 extends _-5I
    {

        public function ButtonPropsPanel2(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "ButtonPropsPanel2").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-GQ;
            _form._-G([{name:"mode", type:"string", items:[Consts.strings.text127, Consts.strings.text125, Consts.strings.text126], values:["Common", "Check", "Radio"]}, {name:"sound", type:"string"}, {name:"volume", type:"int", min:0, max:100}, {name:"downEffect", type:"string", min:0, precision:2, step:0.05, items:[Consts.strings.text331, Consts.strings.text282, Consts.strings.text283], values:["none", "dark", "scale"]}, {name:"downEffectValue", type:"float", min:0, precision:2}]);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = FComponent(this.inspectingTarget);
            var _loc_2:* = FButton(_loc_1.extention);
            _form._-Cm(_loc_2);
            _form.updateUI();
            _form._-Om("downEffectValue").visible = _loc_2.downEffect != "none";
            return true;
        }// end function

    }
}
