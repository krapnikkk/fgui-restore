package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class LabelPropsPanel extends _-5I
    {
        private var _-NQ:GObject;

        public function LabelPropsPanel(param1:IEditor)
        {
            var editor:* = param1;
            _editor = editor;
            _panel = UIPackage.createObject("Builder", "LabelPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-GQ;
            _form._-G([{name:"title", type:"string"}, {name:"icon", type:"string"}, {name:"titleColor", type:"uint"}, {name:"titleColorSet", type:"bool"}, {name:"titleFontSize", type:"int", min:0}, {name:"titleFontSizeSet", type:"bool"}]);
            this._-NQ = _panel.getChild("inputEdit");
            this._-NQ.addClickListener(function (event:Event) : void
            {
                _editor.inspectorView.showPopup("textInput", GObject(event.currentTarget));
                return;
            }// end function
            );
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = FComponent(this.inspectingTarget);
            var _loc_2:* = FLabel(_loc_1.extention);
            _form._-Cm(_loc_2);
            _form.updateUI();
            _form._-Om("titleColor").enabled = _loc_2.titleColorSet;
            _form._-Om("titleFontSize").enabled = _loc_2.titleFontSizeSet;
            this._-NQ.visible = _loc_2.input;
            return true;
        }// end function

    }
}
