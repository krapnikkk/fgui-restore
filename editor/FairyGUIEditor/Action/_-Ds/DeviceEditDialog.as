package _-Ds
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.settings.*;
    import flash.events.*;

    public class DeviceEditDialog extends _-3g
    {
        private var _list:GList;
        private var _-AD:_-Gg;

        public function DeviceEditDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "DeviceEditDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._list = contentPane.getChild("list").asList;
            this._-AD = new _-Gg(this._list);
            this._-AD._-Pt = this._-8f;
            contentPane.getChild("save").addClickListener(_-IJ);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            contentPane.getChild("add").addClickListener(this._-AD.add);
            contentPane.getChild("insert").addClickListener(this._-AD.insert);
            contentPane.getChild("remove").addClickListener(this._-AD.remove);
            contentPane.getChild("moveUp").addClickListener(this._-AD.moveUp);
            contentPane.getChild("moveDown").addClickListener(this._-AD.moveDown);
            return;
        }// end function

        private function _-IY(param1:GButton, param2:String, param3:String, param4:String) : void
        {
            param1.getChild("name").text = param2;
            param1.getChild("x").text = param3;
            param1.getChild("y").text = param4;
            return;
        }// end function

        private function _-8f(param1:int, param2:GButton) : void
        {
            this._-IY(param2, "noname", "", "");
            return;
        }// end function

        override protected function onShown() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_1:* = AdaptationSettings(_editor.project.getSettings("adaptation"));
            var _loc_2:* = _loc_1.devices.length;
            this._list.removeChildrenToPool();
            _loc_4 = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3 = _loc_1.devices[_loc_4];
                _loc_5 = this._list.addItemFromPool().asButton;
                this._-IY(_loc_5, _loc_3.name, _loc_3.resolutionX, _loc_3.resolutionY);
                _loc_4++;
            }
            this._list.selectedIndex = 0;
            return;
        }// end function

        private function _-2p(event:Event) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_2:* = AdaptationSettings(_editor.project.getSettings("adaptation"));
            var _loc_3:* = _loc_2.devices;
            var _loc_4:* = this._list.numChildren;
            _loc_3.length = _loc_4;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = this._list.getChildAt(_loc_5).asButton;
                _loc_7 = _loc_6.getChild("name").text;
                _loc_8 = parseInt(_loc_6.getChild("x").text);
                _loc_9 = parseInt(_loc_6.getChild("y").text);
                if (!_loc_7)
                {
                    _loc_7 = "noname";
                }
                if (_loc_8 == 0)
                {
                    _loc_8 = 1280;
                }
                if (_loc_9 == 0)
                {
                    _loc_9 = 720;
                }
                _loc_10 = _loc_3[_loc_5];
                if (!_loc_10)
                {
                    _loc_10 = {};
                    _loc_3[_loc_5] = _loc_10;
                }
                _loc_10.name = _loc_7;
                _loc_10.resolutionX = _loc_8;
                _loc_10.resolutionY = _loc_9;
                _loc_5++;
            }
            _loc_2.save();
            return;
        }// end function

        override public function _-2a() : void
        {
            this._-2p(null);
            this.hide();
            return;
        }// end function

        override protected function handleKeyEvent(param1:_-4U) : void
        {
            if (param1._-2h != 0)
            {
                this._list.handleArrowKey(param1._-2h);
            }
            return;
        }// end function

    }
}
