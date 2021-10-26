package _-Ds
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class _-EO extends GButton
    {
        private var _-B6:Controller;
        private var _-4e:FControllerAction;
        private var _-Fo:FController;
        private var _form:_-7r;

        public function _-EO()
        {
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._form = new _-7r(this);
            this._form.onPropChanged = this.onPropChanged;
            this._form._-G([{name:"fromPage", type:"array", prompt:Consts.strings.text172}, {name:"toPage", type:"array", prompt:Consts.strings.text172}, {name:"transitionName", type:"string"}, {name:"controllerName", type:"string", dummy:true, includeChildren:true}, {name:"targetPage", type:"string"}]);
            ControllerPageInput(this._form._-Om("targetPage")).additionalOptions = true;
            this._-B6 = getController("type");
            getChild("edit").addClickListener(this._-4h);
            return;
        }// end function

        public function _-5v(param1:FController, param2:FControllerAction) : void
        {
            this._-4e = param2;
            this._-Fo = param1;
            this._-B6.selectedPage = this._-4e.type;
            this.updateUI();
            return;
        }// end function

        private function updateUI() : void
        {
            if (this._-4e.type == "change_page")
            {
                this._form.setValue("controllerName", this._-4e.getFullControllerName(this._-Fo.parent));
            }
            ControllerMultiPageInput(this._form._-Om("fromPage")).controller = this._-Fo;
            ControllerMultiPageInput(this._form._-Om("toPage")).controller = this._-Fo;
            ControllerInput(this._form._-Om("controllerName")).owner = this._-Fo.parent;
            ControllerPageInput(this._form._-Om("targetPage")).controller = this._-4e.getControllerObj(this._-Fo.parent);
            this._form._-Cm(this._-4e);
            this._form.updateUI();
            return;
        }// end function

        private function _-4h(event:Event) : void
        {
            var _loc_2:* = FairyGUIEditor._-Eb(this);
            var _loc_3:* = ControllerEditDialog(_loc_2.getDialog(ControllerEditDialog)).detailsPropsPanel;
            _loc_2.groot.togglePopup(_loc_3, GObject(event.currentTarget), null, true);
            if (_loc_3.onStage)
            {
                _loc_3._-5v(this._-4e);
            }
            return;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : Boolean
        {
            var _loc_4:* = 0;
            if (param1 == "controllerName")
            {
                _loc_4 = param2.indexOf(".");
                if (_loc_4 == -1)
                {
                    if (param2 == this._-Fo.name)
                    {
                        return false;
                    }
                    this._-4e.objectId = null;
                    this._-4e.controllerName = param2;
                }
                else
                {
                    this._-4e.objectId = param2.substr(0, _loc_4);
                    this._-4e.controllerName = param2.substr((_loc_4 + 1));
                }
            }
            else
            {
                this._-4e[param1] = param2;
            }
            this.updateUI();
            return true;
        }// end function

    }
}
