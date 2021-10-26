package _-Gs
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import flash.events.*;

    public class ControllerPageInput extends GLabel
    {
        public var prompt:String;
        public var _-H7:Boolean;
        public var additionalOptions:Boolean;
        private var _controller:FController;
        private var _-E6:String;

        public function ControllerPageInput()
        {
            this.prompt = Consts.strings.text331;
            this._-H7 = true;
            this.additionalOptions = false;
            return;
        }// end function

        public function set controller(param1:FController) : void
        {
            this._controller = param1;
            return;
        }// end function

        public function get controller() : FController
        {
            return this._controller;
        }// end function

        public function set value(param1:String) : void
        {
            this._-E6 = param1;
            if (this._-E6 && this._controller)
            {
                if (this._-E6 == "~1")
                {
                    this.text = Consts.strings.text429;
                }
                else if (this._-E6 == "~2")
                {
                    this.text = Consts.strings.text430;
                }
                else
                {
                    this.text = this._controller.getNameById(this._-E6, this._-H7 ? (this.prompt) : (""));
                }
            }
            else
            {
                this.text = this._-H7 ? (this.prompt) : ("");
            }
            return;
        }// end function

        public function get value() : String
        {
            return this._-E6;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            addClickListener(this._-9w);
            return;
        }// end function

        private function _-9w(event:Event) : void
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            if (this._controller == null)
            {
                return;
            }
            var _loc_2:* = FairyGUIEditor._-Eb(this);
            var _loc_3:* = _loc_2.project.getVar("SelectControllerPageMenu") as PopupMenu;
            if (!_loc_3)
            {
                _loc_3 = new PopupMenu("ui://Basic/PopupMenu2");
                _loc_3.visibleItemCount = 20;
                _loc_2.project.setVar("SelectControllerPageMenu", _loc_3);
            }
            _loc_3.clearItems();
            if (this._-H7)
            {
                _loc_3.addItem(Consts.strings.text331, this._-16).name = "";
            }
            var _loc_4:* = this._controller.getPages();
            var _loc_5:* = _loc_4.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = _loc_4[_loc_6];
                if (_loc_7.name)
                {
                    _loc_8 = _loc_6 + ":" + _loc_7.name;
                }
                else if (_loc_7.remark)
                {
                    _loc_8 = _loc_6 + ":" + _loc_7.remark;
                }
                else
                {
                    _loc_8 = "" + _loc_6;
                }
                _loc_9 = _loc_3.addItem(_loc_8, this._-16).asCom;
                _loc_9.name = _loc_7.id;
                _loc_6++;
            }
            if (this.additionalOptions)
            {
                _loc_3.addItem(Consts.strings.text429, this._-16).name = "~1";
                _loc_3.addItem(Consts.strings.text430, this._-16).name = "~2";
            }
            _loc_3.contentPane.width = this.width;
            _loc_3.show(this);
            return;
        }// end function

        private function _-16(event:ItemEvent) : void
        {
            this.value = event.itemObject.name;
            dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

    }
}
