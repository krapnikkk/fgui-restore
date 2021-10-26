package _-Ds
{
    import *.*;
    import _-NY.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.events.*;

    public class ImportResourceDialog extends _-3g
    {
        private var _-Ma:GProgressBar;
        private var _-7R:GTextField;
        private var _-s:BulkTasks;
        private var _-K6:BulkTasks;
        private var _-PD:int;
        private var _stepCallback:Callback;
        private var _-BX:Boolean;
        private var _-HX:Vector.<FPackageItem>;

        public function ImportResourceDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "ImportResourceDialog").asCom;
            this.modal = true;
            this.centerOn(_editor.groot, true);
            this._-Ma = contentPane.getChild("n8").asProgress;
            this._-7R = contentPane.getChild("n9").asTextField;
            contentPane.getChild("btnCancel").addClickListener(this._-4j);
            this._-s = new BulkTasks(1);
            this._-K6 = new BulkTasks(1);
            this._stepCallback = new Callback();
            this._stepCallback.success = this._-1S;
            this._stepCallback.failed = this._-1S;
            return;
        }// end function

        override protected function onHide() : void
        {
            if (this._-BX)
            {
                _editor.docView.requestFocus();
            }
            super.onHide();
            return;
        }// end function

        private function _-4j(event:Event) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (this._-s.running)
            {
                _loc_2 = this._-s.getRemainingTasks();
                this._-s.clear();
                this._-K6.clear();
                _loc_3 = _loc_2.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_5 = _-8G(_loc_2[_loc_4]);
                    if (_loc_4 == 0)
                    {
                        _loc_5._-1Y.endBatch();
                        _loc_6 = this._-HX;
                    }
                    else
                    {
                        _loc_6 = new Vector.<FPackageItem>;
                    }
                    if (_loc_5.callback != null)
                    {
                        if (_loc_5.callback.length == 0)
                        {
                            _loc_5.callback();
                        }
                        else
                        {
                            _loc_5.callback(_loc_6);
                        }
                    }
                    _loc_4++;
                }
            }
            return;
        }// end function

        override public function _-E4() : void
        {
            return;
        }// end function

        public function addTask(param1:IResourceImportQueue) : void
        {
            this._-s.addTask(this._-CK, param1);
            this._-PD = this._-PD + _-8G(param1).files.length;
            this._-Ma.max = this._-PD;
            show();
            if (!this._-s.running)
            {
                this._-Ma.value = 0;
                this._-7R.text = UtilsStr.formatString(Consts.strings.text199, 1, this._-PD);
                this._-s.start(this._-AO);
            }
            return;
        }// end function

        private function _-CK() : void
        {
            var _loc_1:* = _-8G(this._-s.taskData);
            this._-BX = _loc_1._-1K;
            if (this._-BX && _editor.docView.activeDocument)
            {
                _editor.docView.activeDocument.unselectAll();
            }
            this._-HX = new Vector.<FPackageItem>;
            var _loc_2:* = _loc_1.files.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                this._-K6.addTask(this._-Dm, _loc_1.files[_loc_3]);
                _loc_3++;
            }
            _loc_1._-1Y.beginBatch();
            this._-K6.start(this._-4c);
            return;
        }// end function

        private function _-Dm() : void
        {
            var _loc_1:* = _-8G(this._-s.taskData);
            var _loc_2:* = this._-K6.taskData;
            this._stepCallback.result = null;
            _loc_1._-1Y.importResource(_loc_2.source, _loc_2.target, _loc_2.resName, this._stepCallback);
            this._-7R.text = UtilsStr.formatString(Consts.strings.text199, (this._-Ma.value + 1), this._-Ma.max);
            return;
        }// end function

        private function _-1S() : void
        {
            var _loc_3:* = this._-Ma;
            var _loc_4:* = _loc_3.value + 1;
            _loc_3.value = _loc_4;
            var _loc_1:* = _-8G(this._-s.taskData);
            var _loc_2:* = FPackageItem(this._stepCallback.result);
            if (_loc_2)
            {
                this._-HX.push(_loc_2);
                if (_loc_1._-1K && _editor.docView.activeDocument)
                {
                    if (_editor.docView.activeDocument.insertObject(_loc_2.getURL(), _loc_1._-OS) != null)
                    {
                        if (_loc_1._-OS)
                        {
                            _loc_1._-OS.x = _loc_1._-OS.x + 30;
                            _loc_1._-OS.y = _loc_1._-OS.y + 30;
                        }
                    }
                }
                else
                {
                    _editor.libView.highlight(_loc_2, false);
                }
            }
            if (this._stepCallback.msgs.length)
            {
                _editor.alert(this._stepCallback.msgs.join("\n"));
            }
            this._-K6.finishItem();
            return;
        }// end function

        private function _-4c() : void
        {
            var _loc_1:* = _-8G(this._-s.taskData);
            _loc_1._-1Y.endBatch();
            this._-s.finishItem();
            if (_loc_1.callback != null)
            {
                if (_loc_1.callback.length == 0)
                {
                    _loc_1.callback();
                }
                else
                {
                    _loc_1.callback(this._-HX);
                }
            }
            this._-HX = null;
            return;
        }// end function

        private function _-AO() : void
        {
            this._-PD = 0;
            this.hide();
            return;
        }// end function

    }
}
