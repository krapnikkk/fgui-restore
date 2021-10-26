package fairygui.editor
{
    import *.*;
    import fairygui.editor.api.*;
    import fairygui.editor.settings.*;
    import fairygui.utils.*;
    import fairygui.utils.loader.*;
    import flash.desktop.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class _-3n extends Object
    {
        public static var newVersionPrompt:Boolean;
        public static var _-l:Object;
        private static var iLoader:URLLoader;
        private static var _-J8:Boolean;
        private static var _-78:_-1L;
        private static var _-Hf:Downloader;
        public static const _-2i:String = "https://jk.fairygui.com/version/check/index.php";

        public function _-3n()
        {
            return;
        }// end function

        public static function start(param1:IEditor = null) : void
        {
            if (_-J8)
            {
                return;
            }
            _-78 = _-1L(param1);
            _-J8 = true;
            var _loc_2:* = new URLVariables();
            _loc_2.ver = Consts.versionCode;
            _loc_2.build = Consts.build;
            _loc_2.type = Capabilities.os.toLowerCase().indexOf("mac") != -1 ? ("mac") : ("win");
            _loc_2.lang = Consts.language;
            _loc_2.id = _-D.clientId;
            if (_-D._-F3)
            {
                _loc_2.key = _-D._-F3;
            }
            iLoader = new URLLoader();
            iLoader.addEventListener(Event.COMPLETE, _-2L);
            iLoader.addEventListener(IOErrorEvent.IO_ERROR, _-6);
            var _loc_3:* = new URLRequest();
            _loc_3.url = _-2i;
            _loc_3.method = URLRequestMethod.GET;
            _loc_3.data = _loc_2;
            iLoader.load(_loc_3);
            return;
        }// end function

        public static function cancel() : void
        {
            cleanup();
            return;
        }// end function

        private static function success(param1:String) : void
        {
            var result:Object;
            var data:* = param1;
            cleanup();
            if (!data)
            {
                _-I(null);
                return;
            }
            try
            {
                result = JSON.parse(data);
            }
            catch (err)
            {
                result;
                result.code = 10001;
                result.msg = RuntimeErrorUtil.toString(err);
            }
            if (result.code == 999)
            {
                NativeApplication.nativeApplication.exit();
                return;
            }
            if (result.code || !result.url)
            {
                return;
            }
            _-I(result);
            return;
        }// end function

        private static function failed(param1:String) : void
        {
            cleanup();
            return;
        }// end function

        private static function cleanup() : void
        {
            try
            {
                iLoader.close();
            }
            catch (e)
            {
            }
            iLoader = null;
            _-J8 = false;
            return;
        }// end function

        private static function _-2L(event:Event) : void
        {
            var _loc_2:* = event.currentTarget;
            if (_loc_2 != iLoader)
            {
                return;
            }
            success(_loc_2.data);
            return;
        }// end function

        private static function _-6(event:IOErrorEvent) : void
        {
            var _loc_2:* = event.currentTarget;
            if (_loc_2 != iLoader)
            {
                return;
            }
            failed(event.text);
            return;
        }// end function

        private static function _-I(param1:Object) : void
        {
            if (param1 == null)
            {
                if (_-78)
                {
                    _-78.mainView._-5M();
                }
                return;
            }
            if (!_-78 && Preferences.checkNewVersion == "disabled")
            {
                return;
            }
            _-l = param1;
            var _loc_2:* = new File(new File(File.applicationStorageDirectory.url).nativePath).resolvePath("upgrade");
            if (!_loc_2.exists)
            {
                _loc_2.createDirectory();
            }
            var _loc_3:* = _loc_2.resolvePath(UtilsStr.getFileFullName(_-l.url));
            if (_loc_3.exists && _loc_3.size == _-l.size)
            {
                _-Jt(_loc_3.nativePath);
                return;
            }
            if (_-Hf && _-Hf.running)
            {
                return;
            }
            _-Hf = new Downloader();
            _-Hf.addEventListener(Event.COMPLETE, _-4N);
            _-Hf.addEventListener(IOErrorEvent.IO_ERROR, _-i);
            _-Hf.download(_-l.url, _loc_3.nativePath, 3, false);
            return;
        }// end function

        public static function _-3q(param1:_-1L) : void
        {
            var zipFile:File;
            var ba:ByteArray;
            var zip:ZipReader;
            var appFolder:File;
            var entry:Object;
            var file:File;
            var folder:File;
            var initiator:* = param1;
            try
            {
                zipFile = new File(_-l.filePath);
                ba = UtilsFile.loadBytes(zipFile);
                zip = new ZipReader(ba);
                appFolder = new File(new File(File.applicationDirectory.url).nativePath);
                var _loc_3:* = 0;
                var _loc_4:* = zip.entries;
                while (_loc_4 in _loc_3)
                {
                    
                    entry = _loc_4[_loc_3];
                    file = appFolder.resolvePath(entry.name);
                    folder = file.parent;
                    if (!folder.exists)
                    {
                        folder.createDirectory();
                    }
                    UtilsFile.saveBytes(file, zip.getEntryData(entry.name));
                }
                UtilsFile.deleteFile(zipFile);
                if (initiator)
                {
                    initiator.mainView._-Ib();
                }
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        private static function _-4N(param1:String) : void
        {
            var _loc_2:* = new File(_-Hf.filePath);
            if (_loc_2.size != _-l.size)
            {
                return;
            }
            _-Jt(_-Hf.filePath);
            return;
        }// end function

        private static function _-Jt(param1:String) : void
        {
            _-l.filePath = param1;
            if (Preferences.checkNewVersion == "auto")
            {
                _-3q(null);
                return;
            }
            if (FairyGUIEditor._-8Y.length > 0)
            {
                FairyGUIEditor._-8Y[0].mainView._-8t();
            }
            else
            {
                newVersionPrompt = true;
            }
            return;
        }// end function

        private static function _-i(event:IOErrorEvent) : void
        {
            return;
        }// end function

    }
}
