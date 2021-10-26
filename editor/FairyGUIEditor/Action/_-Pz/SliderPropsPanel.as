package _-Pz
{
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class SliderPropsPanel extends _-5I
    {

        public function SliderPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "SliderPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-GQ;
            _form._-G([{name:"value", type:"int", min:0}, {name:"max", type:"int", min:0}, {name:"min", type:"int", min:0}]);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = FComponent(this.inspectingTarget);
            var _loc_2:* = FSlider(_loc_1.extention);
            NumericInput(_form._-Om("value")).max = _loc_2.max;
            NumericInput(_form._-Om("value")).min = _loc_2.min;
            _form._-Cm(_loc_2);
            _form.updateUI();
            return true;
        }// end function

    }
}
