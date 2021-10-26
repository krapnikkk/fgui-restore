package fairygui.editor
{
    import *.*;
    import _-Gs.*;
    import _-NY.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.settings.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.system.*;

    public class FairyGUIEditor extends Sprite
    {
        private static var _-8b:NativeMenu;
        private static var _-Pa:Vector.<_-1L>;
        static var _-PI:Boolean;
        private static var _-Iz:Boolean;
        private static var _-Fs:Boolean;
        private static var _-O0:Class = _-Db;
        private static var _-Pn:Class = _-3X;

        public function FairyGUIEditor()
        {
            var _loc_2:* = null;
            stage.frameRate = 24;
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.color = 3684408;
            _-Pa = new Vector.<_-1L>;
            XML.ignoreWhitespace = true;
            var _loc_1:* = UIPackage.addPackage(new _-O0(), null);
            _loc_1.loadAllImages();
            _loc_1 = UIPackage.addPackage(new _-Pn(), null);
            _loc_1.loadAllImages();
            Preferences.load();
            _-D.load();
            Consts.init();
            Consts.auxLineSize = stage.contentsScaleFactor;
            _-44.init();
            if (Consts.isMacOS)
            {
                _-8b = new NativeMenu();
                DockIcon(NativeApplication.nativeApplication.icon).menu = _-8b;
                _-8b.addItem(new NativeMenuItem("", true));
                _loc_2 = new NativeMenuItem(Consts.strings.text311);
                _loc_2.data = -1;
                _-8b.addItem(_loc_2);
                _-8b.addEventListener(Event.SELECT, this._-J1);
                _-8b.addEventListener(Event.PREPARING, this._-Q0);
                UIPackage.setVar("os", "mac");
            }
            UIPackage.waitToLoadCompleted(this._-B2);
            _-Iz = true;
            return;
        }// end function

        private function _-B2() : void
        {
            if (stage.contentsScaleFactor != 1 && !Consts.isMacOS)
            {
                UIConfig.defaultFont = "MicroSoft YaHei,Tahoma,_sans";
            }
            else
            {
                UIConfig.defaultFont = "Tahoma,_sans";
            }
            UIConfig.defaultScrollBounceEffect = false;
            UIConfig.defaultScrollTouchEffect = false;
            UIConfig.modalLayerAlpha = 0;
            UIConfig.verticalScrollBar = "ui://Basic/ScrollBar_VT";
            UIConfig.horizontalScrollBar = "ui://Basic/ScrollBar_HZ";
            UIConfig.popupMenu = "ui://Basic/PopupMenu";
            UIConfig.popupMenu_seperator = "ui://Basic/MenuSeperator";
            UIConfig.tooltipsWin = "ui://Basic/TooltipsWin";
            UIConfig.defaultComboBoxVisibleItemCount = int.MAX_VALUE;
            _-7k._-DL();
            _-3n.start();
            NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, this._-Ep);
            NativeApplication.nativeApplication.addEventListener(Event.EXITING, this._-DF);
            if (_-Fs)
            {
                _-GM.run();
            }
            else
            {
                _-BW(null);
            }
            _-Iz = false;
            return;
        }// end function

        private function _-Ep(event:InvokeEvent) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (event.arguments.length > 0)
            {
                _loc_4 = event.arguments[0];
                if (_loc_4.charAt(0) != "-")
                {
                    if (event.currentDirectory != null)
                    {
                        _loc_5 = event.currentDirectory.resolvePath(_loc_4);
                        if (_loc_5.exists)
                        {
                            _-BW(_loc_5.nativePath);
                            return;
                        }
                    }
                }
                else if (_-GM.parse(event))
                {
                    if (_-Iz)
                    {
                        _-Fs = true;
                    }
                    else
                    {
                        _-GM.run();
                    }
                    return;
                }
            }
            if (Consts.isMacOS)
            {
                return;
            }
            arguments = _-C(null);
            if (arguments)
            {
                arguments.nativeWindow.activate();
                NativeApplication.nativeApplication.activate(arguments.nativeWindow);
            }
            else
            {
                _-BW(null);
            }
            return;
        }// end function

        private function _-DF(event:Event) : void
        {
            NativeApplication.nativeApplication.activate();
            _-A9();
            return;
        }// end function

        private function _-J1(event:Event) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = int(event.target.data);
            if (_loc_2 == -1)
            {
                _-BW(null);
            }
            else
            {
                _loc_3 = _-8Y[_loc_2].nativeWindow;
                _loc_3.activate();
                NativeApplication.nativeApplication.activate(_loc_3);
            }
            return;
        }// end function

        private function _-Q0(event:Event) : void
        {
            var _loc_4:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_2:* = _-8b.numItems - 2;
            var _loc_3:* = 0;
            var _loc_5:* = NativeApplication.nativeApplication.activeWindow;
            var _loc_6:* = 0;
            while (_loc_6 < _-8Y.length)
            {
                
                _loc_7 = _-8Y[_loc_6];
                if (_loc_7.forPublish)
                {
                }
                else
                {
                    if (_loc_7.project)
                    {
                        _loc_8 = _loc_7.project.name;
                    }
                    else
                    {
                        _loc_8 = Consts.strings.text427;
                    }
                    if (_loc_3 >= _loc_2)
                    {
                        _loc_4 = new NativeMenuItem(_loc_8);
                        _-8b.addItemAt(_loc_4, _loc_3);
                        _loc_4.data = _loc_6;
                    }
                    else
                    {
                        _loc_4 = _-8b.getItemAt(_loc_3);
                        _loc_4.label = _loc_8;
                        _loc_4.data = _loc_6;
                    }
                    _loc_4.checked = _loc_7.active;
                    _loc_3++;
                }
                _loc_6++;
            }
            if (_loc_3 < _loc_2)
            {
                _loc_6 = _loc_3;
                while (_loc_6 < _loc_2)
                {
                    
                    _-8b.removeItemAt(_loc_6);
                    _loc_6++;
                }
            }
            return;
        }// end function

        public static function get _-8Y() : Vector.<_-1L>
        {
            return _-Pa;
        }// end function

        public static function _-BW(param1:String, param2:Boolean = false) : _-1L
        {
            var _loc_3:* = null;
            var _loc_6:* = 0;
            if (param1)
            {
                if (!param2)
                {
                    _loc_3 = _-C(param1);
                    if (_loc_3)
                    {
                        _loc_3.nativeWindow.activate();
                        NativeApplication.nativeApplication.activate(_loc_3.nativeWindow);
                        return _loc_3;
                    }
                }
                _loc_6 = 0;
                while (_loc_6 < _-8Y.length)
                {
                    
                    _loc_3 = _-8Y[_loc_6];
                    if (!_loc_3.project)
                    {
                        _loc_3.openProject(param1);
                        if (param2)
                        {
                            _loc_3.nativeWindow.visible = false;
                            _loc_3.forPublish = true;
                        }
                        else
                        {
                            _loc_3.nativeWindow.activate();
                            NativeApplication.nativeApplication.activate(_loc_3.nativeWindow);
                        }
                        return _loc_3;
                    }
                    _loc_6++;
                }
            }
            var _loc_4:* = new NativeWindowInitOptions();
            _loc_4.resizable = true;
            _loc_4.maximizable = true;
            _loc_4.minimizable = true;
            var _loc_5:* = new NativeWindow(_loc_4);
            _loc_5.width = 1000;
            _loc_5.height = 600;
            _loc_5.x = Math.max(0, (Capabilities.screenResolutionX - _loc_5.width) / 2);
            _loc_5.y = Math.max(0, (Capabilities.screenResolutionY - _loc_5.height) / 2);
            _loc_5.title = Consts.strings.text84;
            _loc_5.addEventListener(Event.CLOSE, _-MW);
            _loc_3 = new _-1L();
            _loc_5.stage.addChild(_loc_3);
            _-8Y.push(_loc_3);
            _loc_3.create(param1, param2);
            if (!param2)
            {
                _loc_5.activate();
                NativeApplication.nativeApplication.activate(_loc_5);
            }
            else
            {
                _loc_5.visible = false;
            }
            return _loc_3;
        }// end function

        public static function _-C(param1:String) : _-1L
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            if (param1)
            {
                _loc_2 = new File(param1);
                if (!_loc_2.isDirectory)
                {
                    _loc_2 = _loc_2.parent;
                }
                _loc_2.canonicalize();
                param1 = _loc_2.nativePath;
                _loc_3 = 0;
                while (_loc_3 < _-8Y.length)
                {
                    
                    _loc_4 = _-8Y[_loc_3];
                    if (_loc_4.project && _loc_4.project.basePath == param1)
                    {
                        return _loc_4;
                    }
                    _loc_3++;
                }
            }
            else
            {
                _loc_3 = 0;
                while (_loc_3 < _-8Y.length)
                {
                    
                    _loc_4 = _-8Y[_loc_3];
                    if (!_loc_4.project)
                    {
                        return _loc_4;
                    }
                    _loc_3++;
                }
            }
            return null;
        }// end function

        public static function _-Eb(param1:GObject) : _-1L
        {
            var _loc_4:* = null;
            var _loc_2:* = param1.root;
            var _loc_3:* = 0;
            while (_loc_3 < _-8Y.length)
            {
                
                _loc_4 = _-8Y[_loc_3];
                if (_loc_4.groot == _loc_2)
                {
                    return _loc_4;
                }
                _loc_3++;
            }
            return null;
        }// end function

        public static function _-A9() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < _-8Y.length)
            {
                
                _-8Y[_loc_1].queryToClose();
                _loc_1++;
            }
            return;
        }// end function

        public static function _-GC() : void
        {
            _-PI = true;
            _-A9();
            return;
        }// end function

        private static function _-MW(event:Event) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_2:* = NativeWindow(event.currentTarget);
            var _loc_3:* = 0;
            while (_loc_3 < _-8Y.length)
            {
                
                if (_-8Y[_loc_3].nativeWindow == _loc_2)
                {
                    _-8Y.splice(_loc_3, 1);
                    break;
                }
                _loc_3++;
            }
            if (_-8Y.length == 0)
            {
                if (_-PI)
                {
                    _loc_4 = new File(new File(File.applicationDirectory.url).nativePath);
                    if (Consts.isMacOS)
                    {
                        _loc_5 = _loc_4.resolvePath("../MacOS/FairyGUI-Editor");
                    }
                    else
                    {
                        _loc_5 = _loc_4.resolvePath("FairyGUI-Editor.exe");
                    }
                    _loc_6 = new NativeProcessStartupInfo();
                    _loc_6.executable = _loc_5;
                    _loc_7 = new NativeProcess();
                    _loc_7.start(_loc_6);
                }
                NativeApplication.nativeApplication.exit();
            }
            return;
        }// end function

    }
}
