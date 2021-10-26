package _-Pz
{
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;

    public class SwfPropsPanel extends _-5I
    {

        public function SwfPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "SwfPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-Ix;
            _form._-G([{name:"playing", type:"bool"}, {name:"frame", type:"int", min:0}]);
            return;
        }// end function

    }
}
