package _-Pz
{
    import _-Ds.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class ComboBoxPropsPanel extends _-5I
    {

        public function ComboBoxPropsPanel(param1:IEditor)
        {
            var editor:* = param1;
            _editor = editor;
            _panel = UIPackage.createObject("Builder", "ComboBoxPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-GQ;
            _form._-G([{name:"title", type:"string"}, {name:"titleColor", type:"uint"}, {name:"titleColorSet", type:"bool"}, {name:"visibleItemCount", type:"int", min:0}, {name:"direction", type:"string"}, {name:"selectionController", type:"string"}]);
            _panel.getChild("n77").addClickListener(function (event:Event) : void
            {
                _editor.getDialog(ComboBoxEditDialog).show();
                return;
            }// end function
            );
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
