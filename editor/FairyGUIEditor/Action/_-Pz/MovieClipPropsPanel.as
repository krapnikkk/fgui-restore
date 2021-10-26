package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class MovieClipPropsPanel extends _-5I
    {

        public function MovieClipPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "MovieClipPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"playing", type:"bool"}, {name:"frame", type:"int", min:0}, {name:"color", type:"uint"}, {name:"brightness", type:"int", min:0, max:255, dummy:true}]);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = FMovieClip(this.inspectingTarget);
            var _loc_2:* = _loc_1.color >> 16 & 255;
            var _loc_3:* = _loc_1.color >> 8 & 255;
            var _loc_4:* = _loc_1.color & 255;
            if (_loc_2 == _loc_3 && _loc_3 == _loc_4)
            {
                _form.setValue("brightness", _loc_2);
            }
            else
            {
                _form.setValue("brightness", 255);
            }
            _form._-Cm(_loc_1);
            _form.updateUI();
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_4:* = 0;
            if (param1 == "brightness")
            {
                _loc_4 = int(param2);
                _loc_4 = (_loc_4 << 16) + (_loc_4 << 8) + _loc_4;
                _-Ix("color", _loc_4, param3);
            }
            else
            {
                _-Ix(param1, param2, param3);
            }
            return;
        }// end function

    }
}
