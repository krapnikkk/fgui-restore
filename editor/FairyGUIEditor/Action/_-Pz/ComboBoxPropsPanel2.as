package _-Pz
{
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class ComboBoxPropsPanel2 extends _-5I
    {

        public function ComboBoxPropsPanel2(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "ComboBoxPropsPanel2").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-GQ;
            _form._-G([{name:"dropdown", type:"string"}]);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = FComponent(this.inspectingTarget);
            var _loc_2:* = FComboBox(_loc_1.extention);
            _form._-Cm(_loc_2);
            _form.updateUI();
            return true;
        }// end function

    }
}
