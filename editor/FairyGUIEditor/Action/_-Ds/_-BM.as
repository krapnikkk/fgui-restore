package _-Ds
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.gui.*;

    public class _-BM extends GComponent
    {
        protected var _form:_-7r;
        protected var _-4e:FControllerAction;

        public function _-BM()
        {
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            this._form = new _-7r(this);
            this._form.onPropChanged = this.onPropChanged;
            this._form._-G([{name:"repeat", type:"int", min:-1}, {name:"delay", type:"float", min:0, precision:3}, {name:"stopOnExit", type:"bool"}]);
            return;
        }// end function

        public function _-5v(param1:FControllerAction) : void
        {
            this._-4e = param1;
            this._form._-Cm(this._-4e);
            this._form.updateUI();
            return;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            this._-4e[param1] = param2;
            return;
        }// end function

    }
}
