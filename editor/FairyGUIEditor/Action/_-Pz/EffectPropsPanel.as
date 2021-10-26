package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class EffectPropsPanel extends _-5I
    {
        private var _-GI:GObject;

        public function EffectPropsPanel(param1:IEditor)
        {
            var editor:* = param1;
            _editor = editor;
            _panel = UIPackage.createObject("Builder", "EffectPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-Ix;
            _form._-G([{name:"blendMode", type:"string", items:["Normal", "None", "Add", "Multiply", "Screen"], values:["normal", "none", "add", "multiply", "screen"]}, {name:"filter", type:"string", items:[Consts.strings.text331, Consts.strings.text288], values:["none", "color"]}]);
            this._-GI = _panel.getChild("filterEdit");
            this._-GI.addClickListener(function (event:Event) : void
            {
                _editor.inspectorView.showPopup("filter", GObject(event.currentTarget));
                return;
            }// end function
            );
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = this.inspectingTarget;
            if (_loc_1 is FGroup)
            {
                return false;
            }
            _form._-Cm(_loc_1);
            _form.updateUI();
            this._-GI.visible = _loc_1.filter != "none";
            return true;
        }// end function

    }
}
