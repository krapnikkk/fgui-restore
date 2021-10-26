package _-Pz
{
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class ButtonPropsPanel extends _-5I
    {

        public function ButtonPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "ButtonPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-GQ;
            _form._-G([{name:"selected", type:"bool"}, {name:"title", type:"string"}, {name:"icon", type:"string"}, {name:"selectedTitle", type:"string"}, {name:"selectedIcon", type:"string"}, {name:"titleColor", type:"uint"}, {name:"titleColorSet", type:"bool"}, {name:"titleFontSize", type:"int", min:0}, {name:"titleFontSizeSet", type:"bool"}, {name:"soundSet", type:"bool"}, {name:"soundVolumeSet", type:"bool"}, {name:"sound", type:"string"}, {name:"volume", type:"int", min:0, max:100}, {name:"controller", type:"string", pages:"page"}, {name:"page", type:"string"}]);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = FComponent(this.inspectingTarget);
            var _loc_2:* = FButton(_loc_1.extention);
            _form._-Cm(_loc_2);
            _form.updateUI();
            if (_loc_2.mode == FButton.CHECK)
            {
                _editor.inspectorView.setTitle("button", Consts.strings.text125);
            }
            else if (_loc_2.mode == FButton.RADIO)
            {
                _editor.inspectorView.setTitle("button", Consts.strings.text126);
            }
            else
            {
                _editor.inspectorView.setTitle("button", Consts.strings.text127);
            }
            _form._-Om("titleColor").enabled = _loc_2.titleColorSet;
            _form._-Om("titleFontSize").enabled = _loc_2.titleFontSizeSet;
            _form._-Om("sound").enabled = _loc_2.soundSet;
            _form._-Om("volume").enabled = _loc_2.soundVolumeSet;
            return true;
        }// end function

    }
}
