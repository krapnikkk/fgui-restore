package _-Pz
{
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;

    public class ComDesignPropsPanel extends _-5I
    {

        public function ComDesignPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "ComDesignPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-Ix;
            _form._-G([{name:"src", prop:"designImage", type:"string"}, {name:"offsetX", prop:"designImageOffsetX", type:"int"}, {name:"offsetY", prop:"designImageOffsetY", type:"int"}, {name:"alpha", prop:"designImageAlpha", type:"int", min:0, max:100, step:3}, {name:"forTest", prop:"designImageForTest", type:"bool"}, {name:"layer", prop:"designImageLayer", type:"int"}]);
            return;
        }// end function

    }
}
