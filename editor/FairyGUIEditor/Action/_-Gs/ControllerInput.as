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

    public class ControllerInput extends GLabel
    {
        public var prompt:String;
        public var includeChildren:Boolean;
        private var _owner:FComponent;
        private var _value:String;

        public function ControllerInput()
        {
            this.prompt = Consts.strings.text331;
            return;
        }// end function

        public function set owner(param1:FComponent) : void
        {
            this._owner = param1;
            return;
        }// end function

        public function get owner() : FComponent
        {
            return this._owner;
        }// end function

        public function set value(param1:String) : void
        {
            this._value = param1;
            if (this._value)
            {
                this.text = this._value;
            }
            else
            {
                this.text = this.prompt;
            }
            return;
        }// end function

        public function get value() : String
        {
            return this._value;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            addClickListener(this._-9w);
            return;
        }// end function

        private function _-9w(event:Event) : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_2:* = FairyGUIEditor._-Eb(this);
            var _loc_3:* = _loc_2.project.getVar("SelectControllerMenu") as PopupMenu;
            if (!_loc_3)
            {
                _loc_3 = new PopupMenu("ui://Basic/PopupMenu2");
                _loc_3.visibleItemCount = 20;
                _loc_2.project.setVar("SelectControllerMenu", _loc_3);
            }
            var _loc_4:* = this._owner;
            if (!this._owner)
            {
                _loc_4 = _loc_2.docView.activeDocument.content;
            }
            _loc_3.clearItems();
            _loc_3.addItem(Consts.strings.text331, this._-Nm).name = "";
            this._-PV(_loc_3, _loc_4, false);
            if (this.includeChildren)
            {
                _loc_5 = _loc_4.numChildren;
                _loc_6 = 0;
                while (_loc_6 < _loc_5)
                {
                    
                    _loc_7 = _loc_4.getChildAt(_loc_6) as FComponent;
                    if (_loc_7)
                    {
                        this._-PV(_loc_3, _loc_7, true);
                    }
                    _loc_6++;
                }
            }
            _loc_3.contentPane.width = this.width;
            _loc_3.show(this);
            return;
        }// end function

        private function _-PV(param1:PopupMenu, param2:FComponent, param3:Boolean) : void
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_4:* = param2.controllers;
            var _loc_5:* = _loc_4.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = _loc_4[_loc_6];
                if (_loc_7.exported || !param3)
                {
                    if (param3)
                    {
                        _loc_8 = param2.name + "." + _loc_7.name;
                    }
                    else
                    {
                        _loc_8 = _loc_7.name;
                    }
                    _loc_9 = param1.addItem(_loc_8, this._-Nm);
                    if (param3)
                    {
                        _loc_9.name = param2._id + "." + _loc_7.name;
                    }
                    else
                    {
                        _loc_9.name = _loc_7.name;
                    }
                }
                _loc_6++;
            }
            return;
        }// end function

        private function _-Nm(event:ItemEvent) : void
        {
            this.value = event.itemObject.name;
            dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

    }
}
