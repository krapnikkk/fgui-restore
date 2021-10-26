package _-NY
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.filesystem.*;

    public class _-JG extends Object
    {
        private var _-G9:int;
        private var _query:_-y;
        public static const _-IT:int = 0;
        public static const _-u:int = 1;
        public static const _-Kv:int = 2;

        public function _-JG() : void
        {
            return;
        }// end function

        public function _-5a(param1:Vector.<FPackageItem>, param2:IUIPackage, param3:String, param4:int) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_13:* = null;
            this._query = new _-y();
            if (param1.length == 0)
            {
                return;
            }
            var _loc_8:* = param1.length;
            var _loc_9:* = int.MAX_VALUE;
            _loc_7 = 0;
            while (_loc_7 < _loc_8)
            {
                
                _loc_6 = param1[_loc_7];
                _loc_10 = _loc_6.path.length;
                _loc_11 = 0;
                _loc_12 = 1;
                while (_loc_12 < _loc_10)
                {
                    
                    if (_loc_6.path.charAt(_loc_12) == "/")
                    {
                        _loc_11++;
                    }
                    _loc_12++;
                }
                if (_loc_11 < _loc_9)
                {
                    _loc_9 = _loc_11;
                }
                _loc_7++;
            }
            this._query._-Mz(param1, param4);
            for each (_loc_5 in this._query._-CN)
            {
                
                _loc_5.targetPath = this._-3I(_loc_5.item, param3, _loc_9);
            }
            this._-G9 = 0;
            if (param2)
            {
                for each (_loc_5 in this._query._-CN)
                {
                    
                    _loc_6 = _loc_5.item;
                    if (_loc_6.type == FPackageItemType.FOLDER)
                    {
                        continue;
                    }
                    _loc_13 = param2.getItem(_loc_5.targetPath);
                    if (_loc_13 && param2.getItemByFileName(_loc_13, _loc_6.fileName))
                    {
                        var _loc_16:* = this;
                        var _loc_17:* = this._-G9 + 1;
                        _loc_16._-G9 = _loc_17;
                    }
                }
            }
            return;
        }// end function

        public function _-Ko(param1:FPackage, param2:XData, param3:FPackage, param4:String, param5:Boolean = false) : void
        {
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            if (!param3 || param3.project != param1.project)
            {
                _loc_6 = _-y._-D0;
            }
            else if (!param3 || param3 != param1)
            {
                if (param5)
                {
                    _loc_6 = _-y._-62;
                }
                else
                {
                    _loc_6 = _-y._-EB;
                }
            }
            else
            {
                _loc_6 = _-y._-Hs;
            }
            this._query = new _-y();
            this._query._-6d(param1, param2, _loc_6);
            for each (_loc_7 in this._query._-CN)
            {
                
                _loc_7.targetPath = this._-3I(_loc_7.item, param4, 0);
            }
            this._-G9 = 0;
            if (param3)
            {
                for each (_loc_7 in this._query._-CN)
                {
                    
                    _loc_8 = _loc_7.item;
                    if (_loc_8.type == FPackageItemType.FOLDER)
                    {
                        continue;
                    }
                    _loc_9 = param3.getItem(_loc_7.targetPath);
                    if (_loc_9 && param3.getItemByFileName(_loc_9, _loc_8.fileName))
                    {
                        var _loc_12:* = this;
                        var _loc_13:* = this._-G9 + 1;
                        _loc_12._-G9 = _loc_13;
                    }
                }
            }
            return;
        }// end function

        public function copy(param1:IUIPackage, param2:int, param3:Boolean = false) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = false;
            var _loc_12:* = false;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = 0;
            var _loc_18:* = 0;
            var _loc_4:* = {};
            if (param3)
            {
                _loc_13 = new Vector.<FPackageItem>;
            }
            param1.beginBatch();
            for each (_loc_6 in this._query._-CN)
            {
                
                _loc_5 = _loc_6.item;
                _loc_12 = false;
                _loc_11 = false;
                _loc_8 = param1.createPath(_loc_6.targetPath);
                _loc_7 = null;
                if (param2 == _-Kv || _loc_5.type == FPackageItemType.FOLDER)
                {
                    _loc_7 = param1.getItemByFileName(_loc_8, _loc_5.fileName);
                    _loc_9 = _loc_5.fileName;
                    _loc_12 = _loc_7 != null;
                }
                else if (param2 == _-IT)
                {
                    _loc_9 = param1.getUniqueName(_loc_8, _loc_5.fileName);
                }
                else if (param2 == _-u)
                {
                    _loc_7 = param1.getItemByFileName(_loc_8, _loc_5.fileName);
                    _loc_9 = _loc_5.fileName;
                }
                if (!_loc_7)
                {
                    _loc_11 = true;
                    if (_loc_5.type == FPackageItemType.FOLDER)
                    {
                        _loc_15 = _loc_6.targetPath + _loc_9 + "/";
                    }
                    else if (param3 && !param1.getItem(_loc_5.id))
                    {
                        _loc_15 = _loc_5.id;
                    }
                    else
                    {
                        _loc_15 = param1.getNextId();
                    }
                    _loc_7 = new FPackageItem(param1, _loc_5.type, _loc_15);
                    _loc_7.setFile(_loc_6.targetPath, _loc_9);
                    _loc_7.exported = _loc_5.exported;
                    _loc_7.favorite = _loc_5.favorite;
                    if (_loc_5.type == FPackageItemType.IMAGE || _loc_5.type == FPackageItemType.MOVIECLIP)
                    {
                        _loc_7.imageSettings.copyFrom(_loc_5.imageSettings);
                    }
                }
                _loc_4[_loc_5.getURL()] = _loc_7;
                _loc_10 = _loc_5.file;
                _loc_6.item = _loc_7;
                if (!_loc_12)
                {
                    if (_loc_5.type == FPackageItemType.FOLDER)
                    {
                        _loc_10.createDirectory();
                    }
                    else if (_loc_10.exists)
                    {
                        UtilsFile.copyFile(_loc_10, _loc_5.file);
                    }
                    if (param3)
                    {
                        _loc_13.push(_loc_5);
                    }
                }
                else
                {
                    _loc_6.content = null;
                }
                if (_loc_11)
                {
                    param1.addItem(_loc_6.item);
                }
            }
            for each (_loc_14 in this._query._-O2)
            {
                
                _loc_7 = _loc_4["ui://" + _loc_14.pkgId + _loc_14.itemId];
                _loc_14._-f = param1;
                _loc_14.update(_loc_7);
            }
            for each (_loc_6 in this._query._-CN)
            {
                
                _loc_5 = _loc_6.item;
                if (_loc_5.type == FPackageItemType.COMPONENT)
                {
                    if (_loc_6.content)
                    {
                        UtilsFile.saveXData(_loc_5.file, _loc_6.content);
                    }
                    continue;
                }
                if (_loc_5.type == FPackageItemType.FONT)
                {
                    if (_loc_6.content)
                    {
                        UtilsFile.saveString(_loc_5.file, _loc_6.content.join("\n"));
                    }
                }
            }
            param1.endBatch();
            if (param3 && _loc_13.length > 0)
            {
                for each (_loc_5 in _loc_13)
                {
                    
                    _loc_7 = _loc_4[_loc_5.getURL()];
                    if (_loc_7)
                    {
                        this._query._-Ea(param1.project, _loc_5.getURL());
                        this._query.replaceReferences(_loc_7);
                    }
                }
                _loc_16 = _loc_13[0].owner;
                _loc_16.beginBatch();
                _loc_17 = _loc_13.length;
                _loc_18 = 0;
                while (_loc_18 < _loc_17)
                {
                    
                    _loc_16.deleteItem(_loc_13[_loc_18]);
                    _loc_18++;
                }
                _loc_16.endBatch();
            }
            return;
        }// end function

        public function get _-CN() : Vector.<_-1F>
        {
            return this._query._-CN;
        }// end function

        public function get _-LR() : int
        {
            return this._-G9;
        }// end function

        private function _-3I(param1:FPackageItem, param2:String, param3:int) : String
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            if (param3 != 0)
            {
                _loc_4 = param1.path.length;
                _loc_5 = 0;
                _loc_6 = 1;
                while (_loc_6 < _loc_4)
                {
                    
                    if (param1.path.charAt(_loc_6) == "/")
                    {
                        _loc_5++;
                        if (_loc_5 == param3)
                        {
                            if (_loc_6 != (_loc_4 - 1))
                            {
                                return param2 + param1.path.substr((_loc_6 + 1));
                            }
                            return param2;
                        }
                    }
                    _loc_6++;
                }
            }
            return param2 + param1.path.substr(1);
        }// end function

    }
}
