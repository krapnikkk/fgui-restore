package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class TransitionPropsPanel extends _-5I
    {

        public function TransitionPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "TransitionPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"autoPlay", type:"bool"}, {name:"autoPlayRepeat", type:"int", min:-1}, {name:"autoPlayDelay", type:"float", precision:3, min:0}, {name:"ignoreDisplayController", type:"bool", dummy:true}, {name:"autoStop", type:"bool", dummy:true}, {name:"autoStopAtEnd", type:"bool", dummy:true}, {name:"frameRate", type:"string"}]);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = _editor.docView.activeDocument.editingTransition;
            _form._-Cm(_loc_1);
            var _loc_2:* = _loc_1.options;
            _form.setValue("ignoreDisplayController", (_loc_2 & FTransition.OPTION_IGNORE_DISPLAY_CONTROLLER) != 0);
            _form.setValue("autoStop", (_loc_2 & FTransition.OPTION_AUTO_STOP_DISABLED) == 0);
            _form.setValue("autoStopAtEnd", (_loc_2 & FTransition.OPTION_AUTO_STOP_AT_END) != 0);
            _form.updateUI();
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_6:* = 0;
            var _loc_4:* = _editor.docView.activeDocument;
            var _loc_5:* = _loc_4.editingTransition;
            if (param1 == "ignoreDisplayController")
            {
                _loc_6 = _loc_5.options;
                if (param2)
                {
                    _loc_6 = _loc_6 | FTransition.OPTION_IGNORE_DISPLAY_CONTROLLER;
                }
                else
                {
                    _loc_6 = _loc_6 & ~FTransition.OPTION_IGNORE_DISPLAY_CONTROLLER;
                }
                _loc_4.setTransitionProperty(_loc_5, "options", _loc_6);
            }
            else if (param1 == "autoStop")
            {
                _loc_6 = _loc_5.options;
                if (!param2)
                {
                    _loc_6 = _loc_6 | FTransition.OPTION_AUTO_STOP_DISABLED;
                }
                else
                {
                    _loc_6 = _loc_6 & ~FTransition.OPTION_AUTO_STOP_DISABLED;
                }
                _loc_4.setTransitionProperty(_loc_5, "options", _loc_6);
            }
            else if (param1 == "autoStopAtEnd")
            {
                _loc_6 = _loc_5.options;
                if (param2)
                {
                    _loc_6 = _loc_6 | FTransition.OPTION_AUTO_STOP_AT_END;
                }
                else
                {
                    _loc_6 = _loc_6 & ~FTransition.OPTION_AUTO_STOP_AT_END;
                }
                _loc_4.setTransitionProperty(_loc_5, "options", _loc_6);
            }
            else
            {
                _loc_4.setTransitionProperty(_loc_5, param1, param2);
            }
            return;
        }// end function

    }
}
