package _-NY
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.publish.*;
    import fairygui.utils.*;
    import flash.desktop.*;
    import flash.events.*;
    import flash.filesystem.*;

    public class _-GM extends Object
    {
        private static var _editor:IEditor;
        private static var _-3J:String;
        private static var _-Lo:String;
        private static var _-K4:String;
        private static var _branchName:String;
        private static var _targetPath:String;

        public function _-GM()
        {
            return;
        }// end function

        public static function parse(event:InvokeEvent) : Boolean
        {
            var _loc_4:* = false;
            var _loc_7:* = null;
            arguments = event.arguments;
            var _loc_5:* = arguments.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = arguments[_loc_6++];
                if (_loc_7 == "-p")
                {
                    _-Lo = arguments[_loc_6++];
                    continue;
                }
                if (_loc_7 == "-b")
                {
                    _-K4 = arguments[_loc_6++];
                    continue;
                }
                if (_loc_7 == "-t")
                {
                    _branchName = arguments[_loc_6++];
                    continue;
                }
                if (_loc_7 == "-x")
                {
                    _-3J = arguments[_loc_6++];
                    continue;
                }
                if (_loc_7 == "-o")
                {
                    _targetPath = arguments[_loc_6++];
                    continue;
                }
                _loc_4 = true;
                break;
            }
            if (_loc_4 || !_-Lo)
            {
                return false;
            }
            return true;
        }// end function

        public static function run() : void
        {
            var pkgs:Vector.<IUIPackage>;
            var handler:PublishHandler;
            var bt:BulkTasks;
            var callback:Callback;
            var arr:Array;
            var cnt:int;
            var i:int;
            var pkg:IUIPackage;
            _editor = FairyGUIEditor._-BW(_-Lo, true);
            var proj:* = _editor.project;
            if (_-K4)
            {
                arr = _-K4.split(",");
                cnt = arr.length;
                pkgs = new Vector.<IUIPackage>;
                i;
                while (i < cnt)
                {
                    
                    pkg = proj.getPackageByName(arr[i]);
                    if (!pkg)
                    {
                        pkg = proj.getPackage(arr[i]);
                        if (!pkg)
                        {
                            return;
                        }
                    }
                    pkgs.push(pkg);
                    i = (i + 1);
                }
            }
            else
            {
                pkgs = proj.allPackages;
            }
            handler = new PublishHandler();
            bt = new BulkTasks(1);
            callback = new Callback();
            callback.success = function () : void
            {
                bt.finishItem();
                bt.addErrorMsgs(callback.msgs);
                return;
            }// end function
            ;
            callback.failed = function () : void
            {
                bt.clear();
                exit(Consts.strings.text98 + "\n" + callback.msgs.join("\n"));
                return;
            }// end function
            ;
            var task:* = function () : void
            {
                var _loc_1:* = IUIPackage(bt.taskData);
                handler.publish(_loc_1, _branchName, _targetPath, false, callback);
                return;
            }// end function
            ;
            var _loc_2:* = 0;
            var _loc_3:* = pkgs;
            while (_loc_3 in _loc_2)
            {
                
                pkg = _loc_3[_loc_2];
                bt.addTask(task, pkg);
            }
            bt.start(function () : void
            {
                _editor.closeWaiting();
                if (bt.errorMsgs.length > 0)
                {
                    exit(Consts.strings.text96 + "\n" + Consts.strings.text97 + "\n" + bt.errorMsgs.join("\n"));
                }
                exit(null);
                return;
            }// end function
            );
            return;
        }// end function

        public static function exit(param1:String) : void
        {
            arguments = new activation;
            var si:NativeProcessStartupInfo;
            var st:File;
            var process:NativeProcess;
            var args:Vector.<String>;
            var msg:* = param1;
            var arguments:* = arguments;
            if (_-3J)
            {
                try
                {
                    si = new NativeProcessStartupInfo();
                    st = File.applicationDirectory.resolvePath(_-3J);
                    _-GM.executable = ;
                    if ()
                    {
                        args = new Vector.<String>;
                        _-GM.push();
                        _-GM.arguments = ;
                    }
                    process = new NativeProcess();
                    _-GM.start();
                }
                catch (err:Error)
                {
                }
            }
            GTimers.inst.add(1000, 1, function () : void
            {
                if (_editor != null)
                {
                    _editor.nativeWindow.close();
                }
                if (NativeApplication.nativeApplication.openedWindows.length == 1)
                {
                    NativeApplication.nativeApplication.exit(msg != null ? (1) : (0));
                }
                return;
            }// end function
            );
            return;
        }// end function

    }
}
