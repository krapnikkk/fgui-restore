package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class BasicPropsInTransPanel extends _-5I
    {
        private var _title:GObject;
        private var _icon:GLoader;

        public function BasicPropsInTransPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "BasicPropsInTransPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-Ix;
            _form._-G([{name:"name", type:"string"}, {name:"x", type:"int"}, {name:"y", type:"int"}, {name:"width", type:"int", min:0}, {name:"height", type:"int", min:0}, {name:"pivotX", type:"float", precision:2}, {name:"pivotY", type:"float", precision:2}, {name:"scaleX", type:"float", precision:2}, {name:"scaleY", type:"float", precision:2}, {name:"skewX", type:"float", precision:2, step:0.1, min:-360, max:360}, {name:"skewY", type:"float", precision:2, step:0.1, min:-360, max:360}, {name:"rotation", type:"float", precision:2, step:0.1}, {name:"alpha", type:"float", precision:2, min:0, max:1}]);
            this._title = _panel.getChild("title");
            this._icon = _panel.getChild("icon").asLoader;
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = this.inspectingTarget;
            _form._-Cm(_loc_1);
            _form.updateUI();
            this._title.text = _loc_1.getDetailString();
            this._icon.url = _loc_1.docElement.displayIcon;
            return true;
        }// end function

    }
}
