package _-Pz
{
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class ProgressBarPropsPanel2 extends _-5I
    {

        public function ProgressBarPropsPanel2(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "ProgressBarPropsPanel2").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-GQ;
            _form._-G([{name:"reverse", type:"bool"}, {name:"titleType", type:"string", items:[Consts.strings.text128, Consts.strings.text129, Consts.strings.text130, Consts.strings.text131], values:["percent", "valueAndmax", "value", "max"]}]);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = FComponent(this.inspectingTarget);
            var _loc_2:* = FProgressBar(_loc_1.extention);
            _form._-Cm(_loc_2);
            _form.updateUI();
            return true;
        }// end function

    }
}
