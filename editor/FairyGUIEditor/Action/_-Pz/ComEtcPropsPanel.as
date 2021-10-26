package _-Pz
{
    import _-Ds.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class ComEtcPropsPanel extends _-5I
    {

        public function ComEtcPropsPanel(param1:IEditor)
        {
            var editor:* = param1;
            _editor = editor;
            _panel = UIPackage.createObject("Builder", "ComEtcPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-Ix;
            _form._-G([{name:"remark", type:"string"}]);
            _panel.getChild("editCustomProps").addClickListener(function () : void
            {
                _editor.getDialog(ComPropertyEditDialog).show();
                return;
            }// end function
            );
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = this.inspectingTarget;
            _form._-Cm(_loc_1);
            _form.updateUI();
            return true;
        }// end function

    }
}
