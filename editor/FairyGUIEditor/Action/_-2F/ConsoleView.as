package _-2F
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.desktop.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.utils.*;

    public class ConsoleView extends GComponent implements IConsoleView
    {
        private var _editor:IEditor;
        private var _panel:GComponent;
        private var _-15:GComponent;
        private var _list:GList;
        private var _msgs:Array;
        private static const _-8Q:int = 86400;
        private static const _-6P:int = 3600;

        public function ConsoleView(param1:IEditor)
        {
            var editor:* = param1;
            this._editor = editor;
            this._msgs = [];
            this._panel = UIPackage.createObject("Builder", "ConsoleView").asCom;
            this.setSize(this._panel.width, this._panel.height);
            this._panel.addRelation(this, RelationType.Size);
            addChild(this._panel);
            this._-15 = this._editor.mainPanel.getChild("logItem").asCom;
            this._-15.asButton.changeStateOnClick = false;
            this._-15.addClickListener(function () : void
            {
                _-15.visible = false;
                _editor.viewManager.showView("fairygui.ConsoleView");
                return;
            }// end function
            );
            this._list = this._panel.getChild("list").asList;
            this._list.itemRenderer = this.renderListItem;
            this._list.setVirtual();
            this._panel.getChild("btnClear").addClickListener(function () : void
            {
                clear();
                return;
            }// end function
            );
            this._panel.getChild("btnCopy").addClickListener(this._-P5);
            addEventListener(FocusChangeEvent.CHANGED, this._-AB);
            this._editor.on(EditorEvent.ProjectClosed, this._-NK);
            this._editor.on(EditorEvent.DocumentActivated, this._-NK);
            this._editor.on(EditorEvent.TestStart, this._-NK);
            this._editor.on(EditorEvent.TestStop, this._-NK);
            return;
        }// end function

        public function log(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = {type:0, msg:this.getTime() + param1, data:param2};
            this._msgs.push(_loc_3);
            if (this._msgs.length > 100)
            {
                this._msgs.splice(0, 2);
            }
            this._list.numItems = this._msgs.length;
            this._list.scrollPane.scrollBottom();
            this._-5D(_loc_3);
            return;
        }// end function

        public function logError(param1:String, param2:Error = null, param3:Object = null) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (param1 == null)
            {
                param1 = "";
            }
            if (param2 != null)
            {
                if (param1.length > 0)
                {
                    param1 = param1 + "\n";
                }
                param1 = param1 + RuntimeErrorUtil.toString(param2);
                _loc_5 = param2.getStackTrace();
                if (_loc_5)
                {
                    if (param1.length > 0)
                    {
                        param1 = param1 + "\n";
                    }
                    _loc_6 = _loc_5.split("\n");
                    if (_loc_6.length > 5)
                    {
                        _loc_6[5] = "...";
                        _loc_6.length = 6;
                        _loc_5 = _loc_6.join("\n");
                    }
                    param1 = param1 + _loc_5;
                }
            }
            if (param1.length == 0)
            {
                return;
            }
            var _loc_4:* = {type:2, msg:this.getTime() + param1, data:param3};
            this._msgs.push(_loc_4);
            if (this._msgs.length > 100)
            {
                this._msgs.splice(0, 2);
            }
            this._list.numItems = this._msgs.length;
            this._list.scrollPane.scrollBottom();
            this._-5D(_loc_4);
            this._editor.viewManager.showView("fairygui.ConsoleView");
            return;
        }// end function

        public function logWarning(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = {type:1, msg:this.getTime() + param1, data:param2};
            this._msgs.push(_loc_3);
            if (this._msgs.length > 100)
            {
                this._msgs.splice(0, 2);
            }
            this._list.numItems = this._msgs.length;
            this._list.scrollPane.scrollBottom();
            this._-5D(_loc_3);
            this._editor.viewManager.showView("fairygui.ConsoleView");
            return;
        }// end function

        public function clear() : void
        {
            this._msgs.length = 0;
            this._list.numItems = 0;
            this._-NK();
            return;
        }// end function

        private function _-5D(param1:Object) : void
        {
            this._-15.visible = true;
            this._-15.text = param1.msg;
            this._-15.getController("type").selectedIndex = param1.type;
            return;
        }// end function

        private function _-NK() : void
        {
            this._-15.visible = false;
            return;
        }// end function

        private function renderListItem(param1:int, param2:GObject) : void
        {
            var _loc_3:* = this._msgs[param1];
            param2.text = _loc_3.msg;
            param2.asCom.getController("type").selectedIndex = _loc_3.type;
            param2.asCom.getController("bg").selectedIndex = param1 % 2 == 0 ? (0) : (1);
            param2.asCom.getChild("title").addEventListener(TextEvent.LINK, this._-LX);
            param2.data = _loc_3.data;
            return;
        }// end function

        private function _-P5(event:Event) : void
        {
            var _loc_2:* = this._list.getSelection();
            var _loc_3:* = _loc_2.length;
            var _loc_4:* = "";
            var _loc_5:* = 0;
            while (_loc_5 < _loc_3)
            {
                
                if (_loc_4.length > 0)
                {
                    _loc_4 = _loc_4 + "\n";
                }
                _loc_4 = _loc_4 + this._msgs[_loc_5].msg;
                _loc_5++;
            }
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _loc_4);
            return;
        }// end function

        private function _-AB(event:FocusChangeEvent) : void
        {
            this._list.selectedIndex = -1;
            return;
        }// end function

        private function _-LX(event:TextEvent) : void
        {
            var _loc_2:* = GObject(event.currentTarget.parent);
            if (event.text == "open")
            {
                this._editor.libView.highlight(_loc_2.data as FPackageItem);
            }
            else if (event.text == "external_open")
            {
                (_loc_2.data as File).openWithDefaultApplication();
            }
            return;
        }// end function

        private function _-41(param1:String, param2:Error) : void
        {
            var _loc_3:* = "Error in (" + param1 + "): " + RuntimeErrorUtil.toString(param2) + "\n" + param2.getStackTrace();
            var _loc_4:* = new File(this._editor.project.basePath + "/logs/");
            if (!_loc_4.exists)
            {
                _loc_4.createDirectory();
            }
            var _loc_5:* = _loc_4.resolvePath("error.log");
            var _loc_6:* = new FileStream();
            _loc_6.open(_loc_5, FileMode.APPEND);
            _loc_6.writeUTFBytes("====" + new Date() + "====\n" + _loc_3 + "\n\n");
            _loc_6.close();
            return;
        }// end function

        private function getTime() : String
        {
            var _loc_5:* = null;
            var _loc_1:* = getTimer();
            var _loc_2:* = _loc_1 / 1000;
            var _loc_3:* = _loc_1 - _loc_2 * 1000;
            var _loc_4:* = "[";
            if (_loc_2 > _-6P)
            {
                _loc_5 = "" + int(_loc_2 / _-6P);
                _loc_2 = _loc_2 % _-6P;
                if (_loc_5.length == 1)
                {
                    _loc_5 = "0" + _loc_5;
                }
            }
            else
            {
                _loc_5 = "00";
            }
            _loc_4 = _loc_4 + (_loc_5 + ":");
            if (_loc_2 > 60)
            {
                _loc_5 = "" + int(_loc_2 / 60);
                _loc_2 = _loc_2 % 60;
                if (_loc_5.length == 1)
                {
                    _loc_5 = "0" + _loc_5;
                }
            }
            else
            {
                _loc_5 = "00";
            }
            _loc_4 = _loc_4 + (_loc_5 + ":");
            if (_loc_2 > 0 || _loc_4.length == 0)
            {
                _loc_5 = "" + _loc_2;
                if (_loc_5.length == 1)
                {
                    _loc_5 = "0" + _loc_5;
                }
            }
            else
            {
                _loc_5 = "00";
            }
            _loc_4 = _loc_4 + _loc_5;
            _loc_4 = _loc_4 + ".";
            if (_loc_3 == 0)
            {
                _loc_4 = _loc_4 + "000";
            }
            else if (_loc_3 < 10)
            {
                _loc_4 = _loc_4 + ("00" + _loc_3);
            }
            else if (_loc_3 < 100)
            {
                _loc_4 = _loc_4 + ("0" + _loc_3);
            }
            else
            {
                _loc_4 = _loc_4 + _loc_3;
            }
            _loc_4 = _loc_4 + "] ";
            return _loc_4;
        }// end function

    }
}
