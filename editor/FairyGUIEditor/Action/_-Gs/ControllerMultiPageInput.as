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

    public class ControllerMultiPageInput extends GLabel
    {
        public var prompt:String;
        private var _controller:FController;
        private var _value:Array;
        private var _-Kz:PopupMenu;

        public function ControllerMultiPageInput()
        {
            this.prompt = Consts.strings.text331;
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

        public function get value() : Array
        {
            return this._value;
        }// end function

        public function set value(param1:Array) : void
        {
            this._value = param1;
            if (this._controller != null)
            {
                this.text = this._controller.getNamesByIds(this._value, this.prompt);
            }
            else
            {
                this.text = this.prompt;
            }
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            addClickListener(this._-9w);
            return;
        }// end function

        private function createMenu() : void
        {
            this._-Kz = new PopupMenu("ui://Basic/PopupMenu_check");
            this._-Kz.visibleItemCount = 20;
            this._-Kz.hideOnClickItem = false;
            this._-Kz.contentPane.getChild("b0").addClickListener(this._-Iw);
            this._-Kz.contentPane.getChild("b1").addClickListener(this._-6a);
            this._-Kz.contentPane.getChild("b2").addClickListener(this._-63);
            this._-Kz.contentPane.getChild("b3").addClickListener(function () : void
            {
                _-Kz.hide();
                return;
            }// end function
            );
            var editor:* = FairyGUIEditor._-Eb(this);
            editor.project.setVar("SelectControllerMultiPageMenu", this._-Kz);
            return;
        }// end function

        private function _-9w(event:Event) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            if (!this._controller)
            {
                return;
            }
            if (!this._-Kz)
            {
                this.createMenu();
            }
            this._-Kz.clearItems();
            this._controller = this.controller;
            if (this._controller)
            {
                _loc_2 = this._controller.getPages();
                _loc_3 = _loc_2.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_5 = _loc_2[_loc_4];
                    if (_loc_5.name)
                    {
                        _loc_6 = _loc_4 + ":" + _loc_5.name;
                    }
                    else if (_loc_5.remark)
                    {
                        _loc_6 = _loc_4 + ":" + _loc_5.remark;
                    }
                    else
                    {
                        _loc_6 = "" + _loc_4;
                    }
                    _loc_7 = this._-Kz.addItem(_loc_6, this._-16).asCom;
                    _loc_8 = _loc_7.getController("checked");
                    _loc_7.name = _loc_5.id;
                    if (this._value && this._value.indexOf(_loc_5.id) != -1)
                    {
                        _loc_8.selectedIndex = 2;
                    }
                    else
                    {
                        _loc_8.selectedIndex = 1;
                    }
                    _loc_4++;
                }
            }
            this._-Kz.contentPane.width = this.width;
            this._-Kz.show(this);
            return;
        }// end function

        private function _-16(event:ItemEvent) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_2:* = [];
            var _loc_3:* = this._-Kz.itemCount;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = this._-Kz.list.getChildAt(_loc_4).asButton;
                _loc_6 = _loc_5.getController("checked");
                if (_loc_6.selectedIndex == 2)
                {
                    _loc_2.push(_loc_5.name);
                }
                _loc_4++;
            }
            this._-8x(_loc_2);
            return;
        }// end function

        private function _-Iw(event:Event) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_2:* = [];
            if (this._controller)
            {
                _loc_3 = this._controller.getPages();
                _loc_4 = _loc_3.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_2.push(_loc_3[_loc_5].id);
                    _loc_5++;
                }
            }
            this._-Kz.hide();
            this._-8x(_loc_2);
            return;
        }// end function

        private function _-63(event:Event) : void
        {
            this._-Kz.hide();
            this._-8x([]);
            return;
        }// end function

        private function _-6a(event:Event) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_2:* = [];
            if (this._controller)
            {
                _loc_3 = this._-Kz.itemCount;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_5 = this._-Kz.list.getChildAt(_loc_4).asButton;
                    _loc_6 = _loc_5.getController("checked");
                    if (_loc_6.selectedIndex != 2)
                    {
                        _loc_2.push(_loc_5.name);
                    }
                    _loc_4++;
                }
            }
            this._-Kz.hide();
            this._-8x(_loc_2);
            return;
        }// end function

        private function _-8x(param1:Array) : void
        {
            this.value = param1;
            dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

    }
}
