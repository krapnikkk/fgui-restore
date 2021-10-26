package _-5l
{
    import _-Gs.*;
    import _-Pz.*;
    import fairygui.*;
    import fairygui.editor.api.*;

    public class ListLayoutPropsPanel extends _-5I
    {

        public function ListLayoutPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "ListLayoutPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-Ix;
            _form._-G([{name:"autoResizeItem", type:"bool"}, {name:"scrollItemToViewOnClick", type:"bool"}, {name:"foldInvisibleItems", type:"bool"}]);
            return;
        }// end function

    }
}
