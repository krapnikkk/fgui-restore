package _-5l
{
    import _-Gs.*;
    import _-Pz.*;
    import fairygui.*;
    import fairygui.editor.api.*;

    public class TreeSettingsPanel extends _-5I
    {

        public function TreeSettingsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "TreeSettingsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-Ix;
            _form._-G([{name:"indent", type:"int", min:0}, {name:"clickToExpand", type:"int"}]);
            return;
        }// end function

    }
}
