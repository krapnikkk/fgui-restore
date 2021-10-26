package _-An
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    class _-JK extends Object
    {
        private var _parent:DocumentView;
        private var _panel:GComponent;
        private var _-5N:Controller;

        function _-JK(param1:DocumentView)
        {
            this._parent = param1;
            this._panel = UIPackage.createObject("Builder", "CustomArrangePanel").asCom;
            this._-5N = this._panel.getController("c1");
            this._panel.getChild("ok").addClickListener(this._-2p);
            return;
        }// end function

        private function _-2p(event:Event) : void
        {
            var _loc_2:* = this._parent.activeDocument;
            if (_loc_2 != null)
            {
                _-2W._-Kx(_-On(_loc_2), this._-5N.selectedIndex, parseInt(this._panel.getChild("columnCount").text), parseInt(this._panel.getChild("columnSpacing").text), parseInt(this._panel.getChild("lineSpacing").text));
            }
            return;
        }// end function

        public function open(param1:int, param2:GObject) : void
        {
            var _loc_3:* = this._parent.activeDocument;
            var _loc_4:* = _loc_3.getSelection();
            if (param1 == 0 || param1 == 2)
            {
                this._panel.getChild("lineSpacing").text = "" + this._-D6(_loc_4);
            }
            if (param1 == 1 || param1 == 2)
            {
                this._panel.getChild("columnSpacing").text = "" + this._-IE(_loc_4);
            }
            if (param1 == 2)
            {
                this._panel.getChild("columnCount").text = "" + this._-2B(_loc_4);
            }
            this._-5N.selectedIndex = param1;
            this._parent._editor.groot.showPopup(this._panel, param2);
            return;
        }// end function

        private function _-D6(param1:Vector.<FObject>) : int
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_2:* = param1.length;
            if (_loc_2 > 1)
            {
                _loc_5 = [];
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = param1[_loc_3];
                    _loc_5.push(_loc_4);
                    _loc_3++;
                }
                _loc_5.sortOn("y", Array.NUMERIC);
                _loc_6 = 0;
                _loc_3 = 1;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = _loc_5[_loc_3];
                    _loc_7 = _loc_4.y - (_loc_5[(_loc_3 - 1)].y + _loc_5[(_loc_3 - 1)].height);
                    if (_loc_7 > 0)
                    {
                        _loc_6 = _loc_7;
                        break;
                    }
                    _loc_3++;
                }
                return _loc_6;
            }
            else
            {
                return 0;
            }
        }// end function

        private function _-IE(param1:Vector.<FObject>) : int
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_2:* = param1.length;
            if (_loc_2 > 1)
            {
                _loc_5 = [];
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = param1[_loc_3];
                    _loc_5.push(_loc_4);
                    _loc_3++;
                }
                _loc_5.sortOn("x", Array.NUMERIC);
                _loc_6 = 0;
                _loc_3 = 1;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = _loc_5[_loc_3];
                    _loc_7 = _loc_4.x - (_loc_5[(_loc_3 - 1)].x + _loc_5[(_loc_3 - 1)].width);
                    if (_loc_7 > 0)
                    {
                        _loc_6 = _loc_7;
                        break;
                    }
                    _loc_3++;
                }
                return _loc_6;
            }
            else
            {
                return 0;
            }
        }// end function

        private function _-2B(param1:Vector.<FObject>) : int
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_2:* = param1.length;
            if (_loc_2 > 1)
            {
                _loc_5 = [];
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = param1[_loc_3];
                    _loc_5.push(_loc_4);
                    _loc_3++;
                }
                _loc_5.sortOn("y", Array.NUMERIC);
                _loc_3 = 1;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = _loc_5[_loc_3];
                    _loc_6 = _loc_4.y - (_loc_5[(_loc_3 - 1)].y + _loc_5[(_loc_3 - 1)].height);
                    if (_loc_6 > 0)
                    {
                        return _loc_3;
                    }
                    _loc_3++;
                }
                return _loc_3;
            }
            else
            {
                return 1;
            }
        }// end function

    }
}
