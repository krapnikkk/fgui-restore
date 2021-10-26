package _-NY
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.display.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.geom.*;

    public class _-PC extends Object
    {
        private var _editor:IEditor;

        public function _-PC(param1:IEditor) : void
        {
            this._editor = param1;
            this._editor.groot.nativeStage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, this._-W);
            this._editor.groot.nativeStage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, this._-3);
            return;
        }// end function

        public function dispose() : void
        {
            this._editor.groot.nativeStage.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, this._-W);
            this._editor.groot.nativeStage.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, this._-3);
            return;
        }// end function

        private function _-W(event:NativeDragEvent) : void
        {
            if (!event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
            {
                return;
            }
            var _loc_2:* = DisplayObject(event.target);
            var _loc_3:* = _loc_2;
            var _loc_4:* = _loc_2.stage;
            var _loc_5:* = GComponent(this._editor.docView).displayObject;
            var _loc_6:* = GComponent(this._editor.libView).displayObject;
            while (_loc_3 && _loc_3 != _loc_4)
            {
                
                if (_loc_3 == _loc_5 && this._editor.docView.activeDocument != null || _loc_3 == _loc_6 || _loc_3 is UISprite && UISprite(_loc_3).owner is ResourceInput)
                {
                    NativeDragManager.acceptDragDrop(Sprite(_loc_3));
                    break;
                }
                _loc_3 = _loc_3.parent;
            }
            return;
        }// end function

        private function _-3(event:NativeDragEvent) : void
        {
            var _loc_5:* = 0;
            var _loc_7:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = null;
            if (!event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
            {
                return;
            }
            this._editor.nativeWindow.activate();
            NativeApplication.nativeApplication.activate(this._editor.nativeWindow);
            var _loc_2:* = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
            var _loc_3:* = _loc_2.length;
            if (_loc_3 == 0)
            {
                return;
            }
            var _loc_4:* = _loc_2[0].parent;
            while (_loc_5 < _loc_3)
            {
                
                _loc_13 = _loc_2[_loc_5];
                if (_loc_13.isDirectory)
                {
                    _loc_2.splice(_loc_5, 1);
                    UtilsFile.listAllFiles(_loc_13, _loc_2);
                    _loc_3 = _loc_2.length;
                    continue;
                }
                _loc_14 = _loc_13.extension.toLowerCase();
                if (!FPackageItemType.fileExtensionMap[_loc_14])
                {
                    _loc_2.splice(_loc_5, 1);
                    _loc_3 = _loc_3 - 1;
                    continue;
                }
                _loc_5++;
            }
            if (_loc_2.length == 0)
            {
                return;
            }
            var _loc_6:* = this._editor.docView.activeDocument;
            var _loc_8:* = null;
            if (event.target != GComponent(this._editor.libView).displayObject)
            {
                _loc_7 = "doc";
                _loc_8 = _loc_6.globalToCanvas(event.stageX, event.stageY);
            }
            else
            {
                _loc_7 = "lib";
            }
            if (_loc_7 == "lib")
            {
                _loc_15 = this._editor.libView.getFolderUnderPoint(event.stageX, event.stageY);
                if (_loc_15 == null)
                {
                    return;
                }
                _loc_9 = _loc_15.owner;
                _loc_10 = _loc_15.id;
            }
            else
            {
                _loc_9 = _loc_6.packageItem.owner;
                _loc_10 = _loc_6.packageItem.parent.id;
            }
            _loc_3 = _loc_2.length;
            _loc_5 = 0;
            _loc_5 = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_13 = _loc_2[_loc_5];
                _loc_16 = this._editor.project.findItemByFile(_loc_13);
                if (_loc_16)
                {
                    if (_loc_11 == null)
                    {
                        _loc_11 = new Vector.<FPackageItem>;
                    }
                    _loc_11.push(_loc_16);
                }
                else
                {
                    if (!_loc_12)
                    {
                        _loc_12 = this._editor.importResource(_loc_9);
                    }
                    _loc_12.addRelative(_loc_13, _loc_10, _loc_4);
                }
                _loc_5++;
            }
            if (_loc_12)
            {
                _loc_12.process(null, _loc_7 == "doc", _loc_8);
            }
            else if (_loc_11)
            {
                if (event.target is UISprite)
                {
                    _loc_17 = UISprite(event.target).owner as ResourceInput;
                    if (_loc_17)
                    {
                        _loc_17.text = _loc_11[0].getURL();
                        _loc_17.dispatchEvent(new _-Fr(_-Fr._-CF));
                        return;
                    }
                }
                if (_loc_7 == "doc")
                {
                    _loc_6.unselectAll();
                    _loc_3 = _loc_11.length;
                    _loc_5 = 0;
                    while (_loc_5 < _loc_3)
                    {
                        
                        if (_loc_6.insertObject(_loc_11[_loc_5].getURL(), _loc_8) != null)
                        {
                            _loc_8.x = _loc_8.x + 50;
                            _loc_8.y = _loc_8.y + 50;
                        }
                        _loc_5++;
                    }
                    this._editor.docView.requestFocus();
                }
            }
            return;
        }// end function

    }
}
