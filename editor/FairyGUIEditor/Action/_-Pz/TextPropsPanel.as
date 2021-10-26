package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class TextPropsPanel extends _-5I
    {
        private var _-NQ:GObject;

        public function TextPropsPanel(param1:IEditor)
        {
            var editor:* = param1;
            _editor = editor;
            _panel = UIPackage.createObject("Builder", "TextPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-Ix;
            _form._-G([{name:"text", type:"string"}, {name:"font", type:"string"}, {name:"fontSize", type:"int", min:1}, {name:"ubbEnabled", type:"bool"}, {name:"varsEnabled", type:"bool"}, {name:"clearOnPublish", type:"bool"}, {name:"input", type:"bool"}, {name:"color", type:"uint"}, {name:"autoSize", type:"string", items:[Consts.strings.text331, Consts.strings.text168, Consts.strings.text169, Consts.strings.text304], values:["none", "both", "height", "shrink"]}, {name:"align", type:"string"}, {name:"verticalAlign", type:"string"}, {name:"leading", type:"int"}, {name:"letterSpacing", type:"int"}, {name:"underline", type:"bool"}, {name:"italic", type:"bool"}, {name:"bold", type:"bool"}, {name:"singleLine", type:"bool"}, {name:"stroke", type:"bool"}, {name:"strokeColor", type:"uint"}, {name:"strokeSize", type:"int", min:0}, {name:"shadow", type:"bool"}, {name:"shadowX", type:"int"}, {name:"shadowY", type:"int"}, {name:"clearOnPublish", type:"bool"}]);
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
            var _loc_1:* = FTextField(this.inspectingTarget);
            _form._-Cm(_loc_1);
            _form.updateUI();
            this._-NQ.visible = _loc_1.input;
            return true;
        }// end function

    }
}
