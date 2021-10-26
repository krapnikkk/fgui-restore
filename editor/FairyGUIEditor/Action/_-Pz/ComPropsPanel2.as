package _-Pz
{
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class ComPropsPanel2 extends _-5I
    {

        public function ComPropsPanel2(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "ComPropsPanel2").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-Ix;
            _form._-G([{name:"pageController", type:"string"}]);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = this.inspectingTargets;
            if (_loc_1.length == 1 && (FComponent(_loc_1[0]).scrollBarFlags & FScrollPane.PAGE_MODE) == 0)
            {
                return false;
            }
            _form._-Cm(_loc_1[0]);
            _form.updateUI();
            return true;
        }// end function

    }
}
