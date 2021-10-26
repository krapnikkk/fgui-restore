package _-Gs
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.geom.*;
    import flash.utils.*;

    public class _-2t extends GComponent implements IViewManager
    {
        private var _editor:IEditor;
        private var _-4z:ViewGrid;
        private var _-2O:GObject;
        private var _-9c:ViewGrid;
        private var _-Gv:int;
        private var _-JF:_-2b;
        private var _-Dh:_-2b;
        private var _-Kz:PopupMenu;
        private var _-Kq:GObject;
        private var _-OU:Dictionary;
        private var _-Bx:Vector.<String>;
        private var _-IV:Object;
        private static var sHelperRect:Rectangle = new Rectangle();
        private static const _-Nh:int = -1;
        private static const _-7L:int = -2;
        private static const LEFT:int = -3;
        private static const _-HI:int = -4;
        private static const _-P8:int = -5;
        private static const INVALID:int = -100;
        private static var _-KR:Class = _-Lf;

        public function _-2t(param1:IEditor)
        {
            var editor:* = param1;
            this._editor = editor;
            this._-IV = {};
            this._-OU = new Dictionary();
            this._-Bx = new Vector.<String>;
            this._-Kq = UIPackage.createObject("Builder", "highlight_border");
            this._-Kq.touchable = false;
            this._-JF = new _-2b(this._editor, GroupLayoutType.Horizontal);
            this._-Dh = new _-2b(this._editor, GroupLayoutType.Horizontal);
            addChild(this._-JF);
            addSizeChangeCallback(function () : void
            {
                getChildAt(0).setSize(width, height);
                return;
            }// end function
            );
            this._-Kz = new PopupMenu();
            this._-Kz.contentPane.width = 120;
            this._-Kz.addItem(Consts.strings.text13, this._-Gy);
            this._editor.on(EditorEvent.TestStart, function () : void
            {
                playMode = true;
                return;
            }// end function
            );
            this._editor.on(EditorEvent.TestStop, function () : void
            {
                playMode = false;
                return;
            }// end function
            );
            this.setSize(400, 400);
            return;
        }// end function

        override public function dispose() : void
        {
            var _loc_1:* = null;
            super.dispose();
            for (_loc_1 in this._-OU)
            {
                
                _loc_3[_loc_1].dispose();
            }
            return;
        }// end function

        public function get playMode() : Boolean
        {
            return getChildAt(0) == this._-Dh;
        }// end function

        public function set playMode(param1:Boolean) : void
        {
            var root:_-2b;
            var value:* = param1;
            var child:* = getChildAt(0);
            if (value)
            {
                root = this._-Dh;
            }
            else
            {
                root = this._-JF;
            }
            if (root != child)
            {
                removeChildAt(0);
                child = addChild(root);
                child.setSize(this.width, this.height);
                _-2b._-9u(root, true, function (param1:ViewGrid) : void
            {
                param1.refresh();
                return;
            }// end function
            );
            }
            return;
        }// end function

        public function addView(param1:Object, param2:String, param3:String, param4:String, param5:Object = null) : GComponent
        {
            var _loc_6:* = this._-OU[param2];
            if (this._-OU[param2])
            {
                return _loc_6;
            }
            _loc_6 = new param1(this._editor);
            _loc_6.name = param2;
            _loc_6.initWidth = _loc_6.width;
            _loc_6.initHeight = _loc_6.height;
            var _loc_7:* = {title:param3, icon:param4};
            _loc_7.hResizePiority = param5 && param5.hResizePiority != undefined ? (param5.hResizePiority) : (0);
            _loc_7.vResizePiority = param5 && param5.vResizePiority != undefined ? (param5.vResizePiority) : (0);
            _loc_7.location = param5 && param5.location != undefined ? (param5.location) : ("left");
            _loc_6.data = _loc_7;
            _loc_6.focusable = true;
            this._-OU[param2] = _loc_6;
            this._-Bx.push(param2);
            return _loc_6;
        }// end function

        public function removeView(param1:String) : void
        {
            var _loc_2:* = this._-OU[param1];
            if (!_loc_2)
            {
                return;
            }
            _loc_2.dispose();
            delete this._-OU[param1];
            var _loc_3:* = this._-Bx.indexOf(param1);
            this._-Bx.removeAt(_loc_3);
            return;
        }// end function

        public function getView(param1:String) : GComponent
        {
            return this._-OU[param1];
        }// end function

        public function get viewIds() : Vector.<String>
        {
            return this._-Bx;
        }// end function

        public function isViewShowing(param1:String) : Boolean
        {
            var _loc_2:* = this._-OU[param1];
            if (!_loc_2)
            {
                return false;
            }
            var _loc_3:* = _-2b(getChildAt(0));
            return _loc_3.isAncestorOf(_loc_2);
        }// end function

        public function setViewTitle(param1:String, param2:String) : void
        {
            var _loc_5:* = 0;
            var _loc_3:* = this._-OU[param1];
            if (!_loc_3)
            {
                return;
            }
            if (_loc_3.data.title == param2)
            {
                return;
            }
            _loc_3.data.title = param2;
            var _loc_4:* = this._-JF._-4p(_loc_3, true);
            if (this._-JF._-4p(_loc_3, true))
            {
                _loc_5 = _loc_4._-2V(_loc_3);
                _loc_4.setViewTitle(_loc_5, param2);
            }
            _loc_4 = this._-Dh._-4p(_loc_3, true);
            if (_loc_4)
            {
                _loc_5 = _loc_4._-2V(_loc_3);
                _loc_4.setViewTitle(_loc_5, param2);
            }
            return;
        }// end function

        public function showView(param1:String) : void
        {
            var _loc_2:* = this._-OU[param1];
            if (!_loc_2)
            {
                if (param1 != "fairygui.DebugView")
                {
                }
                return;
            }
            var _loc_3:* = this._-3e(_-2b(getChildAt(0)), _loc_2);
            _loc_3.selectedView = _loc_2;
            return;
        }// end function

        private function _-3e(param1:_-2b, param2:GComponent) : ViewGrid
        {
            var _loc_8:* = 0;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_3:* = param1._-4p(param2, true);
            if (_loc_3)
            {
                return _loc_3;
            }
            var _loc_4:* = param2 != this._editor.docView && param2 != this._editor.testView;
            var _loc_5:* = param2.name;
            var _loc_6:* = this._-IV[_loc_5];
            if (this._-IV[_loc_5])
            {
                delete this._-IV[_loc_5];
                _loc_3 = param1._-8q(_loc_6);
                if (_loc_3)
                {
                    _loc_3.addView(param2);
                    return _loc_3;
                }
                _loc_9 = this._-IV[_loc_6];
                if (_loc_9)
                {
                    delete this._-IV[_loc_6];
                    if (_loc_9.group)
                    {
                        _loc_10 = param1._-BT(_loc_9.group);
                        if (_loc_10)
                        {
                            _loc_3 = this._-JB(_loc_4);
                            _loc_3.uid = _loc_6;
                            _loc_3.addView(param2);
                            _loc_3.setSize(_loc_9.width, _loc_9.height);
                            this._-Ct(_loc_10, _loc_3, _loc_9.order);
                            return _loc_3;
                        }
                    }
                }
            }
            _loc_3 = this._-JB(_loc_4);
            _loc_3.addView(param2);
            _loc_3.setSize(_loc_3.initWidth, _loc_3.initHeight);
            var _loc_7:* = param1._-8q(param1 == this._-JF ? ("fairygui.DocumentView") : ("fairygui.TestView"), true);
            switch(param2.data.location)
            {
                case "left":
                {
                    _loc_8 = LEFT;
                    break;
                }
                case "right":
                {
                    _loc_8 = _-HI;
                    break;
                }
                case "top":
                {
                    _loc_8 = _-Nh;
                    break;
                }
                case "bottom":
                {
                    _loc_8 = _-7L;
                    break;
                }
                default:
                {
                    _loc_8 = LEFT;
                    break;
                    break;
                }
            }
            this._-F2(_loc_3, _loc_7, _loc_8);
            return _loc_3;
        }// end function

        public function hideView(param1:String) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_2:* = this._-OU[param1];
            if (!_loc_2)
            {
                return;
            }
            var _loc_3:* = _-2b(getChildAt(0));
            var _loc_4:* = _loc_3._-4p(_loc_2);
            if (!_loc_3._-4p(_loc_2))
            {
                return;
            }
            _loc_4.removeView(_loc_2);
            var _loc_5:* = _loc_2.name;
            this._-IV[_loc_5] = _loc_4.uid;
            if (_loc_4._-47 == 0)
            {
                _loc_6 = _-2b(_loc_4.parent);
                _loc_7 = {width:_loc_4.width, height:_loc_4.height};
                if (_loc_6 != _loc_3)
                {
                    _loc_7.group = _loc_6.uid;
                }
                _loc_7.order = _loc_6._-Oh(_loc_4);
                if (_loc_7.order == (_loc_6._-9X - 1))
                {
                    _loc_7.order = 99;
                }
                this._-IV[_loc_4.uid] = _loc_7;
                this._-Pl(_loc_4);
            }
            return;
        }// end function

        public function _-9() : void
        {
            var data:Object;
            var k:String;
            var folder:* = File.userDirectory.resolvePath(Consts.userDirectoryName);
            if (folder.exists)
            {
                data = UtilsFile.loadJSON(folder.resolvePath("editorLayout.json"));
            }
            if (data)
            {
                if (data.history)
                {
                    var _loc_2:* = 0;
                    var _loc_3:* = data.history;
                    while (_loc_3 in _loc_2)
                    {
                        
                        k = _loc_3[_loc_2];
                        this._-IV[k] = _loc_3[k];
                    }
                }
                if (!this._-I3(data.common))
                {
                    this._-2D();
                }
                else if (!this._-4K(data.playMode))
                {
                    this._-2D();
                }
            }
            else
            {
                this._-2D();
            }
            _-2b._-9u(this._-JF, true, function (param1:ViewGrid) : void
            {
                param1.refresh();
                return;
            }// end function
            );
            return;
        }// end function

        public function resetLayout() : void
        {
            this._-2D();
            _-2b._-9u(this._-JF, true, function (param1:ViewGrid) : void
            {
                param1.refresh();
                return;
            }// end function
            );
            return;
        }// end function

        private function _-2D() : void
        {
            var _loc_1:* = new _-KR();
            var _loc_2:* = JSON.parse(_loc_1.readUTFBytes(_loc_1.length));
            _loc_1.clear();
            this._-I3(_loc_2.common);
            this._-4K(_loc_2.playMode);
            return;
        }// end function

        private function _-I3(param1:Object) : Boolean
        {
            if (this._-JF.numChildren > 1)
            {
                this._-JF.removeChildren(0, this._-JF.numChildren - 2, true);
            }
            this._-Mp(this._-JF, param1);
            return this._-JF._-8q("fairygui.DocumentView", true) != null;
        }// end function

        private function _-4K(param1:Object) : Boolean
        {
            if (this._-Dh.numChildren > 1)
            {
                this._-Dh.removeChildren(0, this._-Dh.numChildren - 2, true);
            }
            this._-Mp(this._-Dh, param1);
            return this._-Dh._-8q("fairygui.TestView", true) != null;
        }// end function

        public function _-U() : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_1:* = this._-L(this._-JF);
            var _loc_2:* = this._-L(this._-Dh);
            var _loc_3:* = {};
            var _loc_4:* = {};
            for (_loc_5 in this._-IV)
            {
                
                _loc_7 = _loc_9[_loc_5];
                if (_loc_7 is String)
                {
                    _loc_4[_loc_7] = true;
                    _loc_4[_loc_5] = true;
                }
            }
            for (_loc_5 in this._-IV)
            {
                
                if (_loc_4[_loc_5])
                {
                    _loc_3[_loc_5] = _loc_9[_loc_5];
                }
            }
            _loc_6 = File.userDirectory.resolvePath(Consts.userDirectoryName);
            if (!_loc_6.exists)
            {
                _loc_6.createDirectory();
            }
            UtilsFile.saveJSON(_loc_6.resolvePath("editorLayout.json"), {common:_loc_1, playMode:_loc_2, history:_loc_3});
            return;
        }// end function

        private function _-L(param1:GObject) : Object
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_2:* = {};
            _loc_2.children = [];
            _loc_2.width = param1.width;
            _loc_2.height = param1.height;
            if (param1 is ViewGrid)
            {
                _loc_5 = ViewGrid(param1);
                _loc_2.id = _loc_5.uid;
                _loc_2.selected = _loc_5.selectedIndex;
                _loc_3 = _loc_5._-47;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_2.children.push(_loc_5._-Mf(_loc_4).name);
                    _loc_4++;
                }
            }
            else
            {
                _loc_6 = _-2b(param1);
                _loc_2.id = _loc_6.uid;
                _loc_2.layout = _loc_6.layout;
                _loc_3 = _loc_6._-9X;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_7 = _loc_6._-Bb(_loc_4);
                    _loc_2.children.push(this._-L(_loc_7));
                    _loc_4++;
                }
            }
            return _loc_2;
        }// end function

        private function _-Mp(param1:GObject, param2:Object) : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = null;
            var _loc_13:* = 0;
            var _loc_14:* = 0;
            var _loc_3:* = param2.children;
            var _loc_4:* = _loc_3.length;
            if (param1 is _-2b)
            {
                _loc_7 = _-2b(param1);
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_6 = _loc_3[_loc_5];
                    if (!_loc_6.children || _loc_6.children.length == 0)
                    {
                    }
                    else if (_loc_6.layout != undefined)
                    {
                        _loc_8 = new _-2b(this._editor, _loc_6.layout);
                        if (_loc_6.id)
                        {
                            _loc_8.uid = _loc_6.id;
                        }
                        this._-Mp(_loc_8, _loc_6);
                        if (_loc_8._-9X > 0)
                        {
                            _loc_7._-NZ(_loc_8);
                        }
                        else
                        {
                            _loc_8.dispose();
                        }
                    }
                    else
                    {
                        _loc_9 = this._-JB();
                        if (_loc_6.id)
                        {
                            _loc_9.uid = _loc_6.id;
                        }
                        this._-Mp(_loc_9, _loc_6);
                        if (_loc_9._-47 > 0)
                        {
                            _loc_7._-NZ(_loc_9);
                        }
                        else
                        {
                            _loc_9.dispose();
                        }
                    }
                    _loc_5++;
                }
            }
            else
            {
                _loc_10 = ViewGrid(param1);
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_6 = _loc_3[_loc_5];
                    if (!(_loc_6 is String))
                    {
                    }
                    else
                    {
                        _loc_12 = this.getView(String(_loc_6)) as GComponent;
                        if (!_loc_12)
                        {
                        }
                        else
                        {
                            if (_loc_12 == this._editor.docView || _loc_12 == this._editor.testView)
                            {
                                _loc_10.clear();
                                _loc_10._-BE = false;
                                _loc_10.addView(_loc_12);
                                break;
                            }
                            else
                            {
                                _loc_10.addView(_loc_12);
                            }
                            delete this._-IV[_loc_12.name];
                        }
                    }
                    _loc_5++;
                }
                _loc_11 = param2.selected;
                if (_loc_11 >= 0 && _loc_11 < _loc_10._-47)
                {
                    _loc_10.selectedIndex = _loc_11;
                }
            }
            if (param1 != this._-JF && param1 != this._-Dh)
            {
                _loc_13 = param2.width;
                _loc_14 = param2.height;
                if (_loc_13 == 0)
                {
                    _loc_13 = param1.initWidth;
                }
                if (_loc_14 == 0)
                {
                    _loc_14 = param1.initHeight;
                }
                param1.setSize(_loc_13, _loc_14);
            }
            return;
        }// end function

        private function _-JB(param1:Boolean = true) : ViewGrid
        {
            var _loc_2:* = UIPackage.createObject("Builder", "ViewGrid") as ViewGrid;
            _loc_2._-BE = param1;
            return _loc_2;
        }// end function

        private function _-Pl(param1:GObject) : void
        {
            var _loc_2:* = _-2b(param1.parent);
            _loc_2._-3v(param1);
            param1.dispose();
            this._-MB(_loc_2);
            return;
        }// end function

        private function _-MB(param1:_-2b) : void
        {
            if (param1 == this._-JF || param1 == this._-Dh)
            {
                return;
            }
            if (param1._-9X == 0)
            {
                this._-Pl(param1);
            }
            return;
        }// end function

        private function _-KB(param1:ViewGrid, param2:_-2b, param3:int) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (this._-Gv == LEFT)
            {
                param2._-3l(param1, 0);
            }
            else if (this._-Gv == _-HI)
            {
                param2._-3l(param1, param2._-9X);
            }
            else if (this._-Gv == _-Nh || this._-Gv == _-7L)
            {
                _loc_4 = new _-2b(this._editor, GroupLayoutType.Horizontal);
                _loc_4.setSize(param2.width, param2.height);
                _loc_4._-1d(param2, 0);
                _loc_5 = new _-2b(this._editor, GroupLayoutType.Vertical);
                _loc_5.setSize(param2.width, param2.height);
                _loc_5._-NZ(_loc_4);
                if (this._-Gv == _-Nh)
                {
                    _loc_5._-3l(param1, 0);
                }
                else
                {
                    _loc_5._-NZ(param1);
                }
                param2._-NZ(_loc_5);
            }
            return;
        }// end function

        private function _-F2(param1:ViewGrid, param2:ViewGrid, param3:int) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_4:* = _-2b(param2.parent);
            if (_loc_4.layout == GroupLayoutType.Horizontal && (param3 == _-Nh || param3 == _-7L) || _loc_4.layout == GroupLayoutType.Vertical && (param3 == LEFT || param3 == _-HI))
            {
                _loc_5 = new _-2b(this._editor, _loc_4.layout == 1 ? (2) : (1));
                _loc_4._-Kh(param2, _loc_5);
                param1.setSize(param1.initWidth, param1.initHeight);
                param2.setSize(param2.initWidth, param2.initHeight);
                if (param3 == _-Nh || param3 == LEFT)
                {
                    _loc_5._-NZ(param1);
                    _loc_5._-NZ(param2);
                }
                else
                {
                    _loc_5._-NZ(param2);
                    _loc_5._-NZ(param1);
                }
            }
            else
            {
                if (param1.parent != _loc_4)
                {
                    param1.setSize(param1.initWidth, param1.initHeight);
                    _loc_4._-Hc();
                }
                _loc_6 = _loc_4._-Oh(param2);
                if (param3 == _-Nh || param3 == LEFT)
                {
                    _loc_4._-3l(param1, _loc_6);
                }
                else
                {
                    _loc_4._-3l(param1, (_loc_6 + 1));
                }
            }
            return;
        }// end function

        private function _-Ct(param1:_-2b, param2:ViewGrid, param3:int) : void
        {
            var _loc_4:* = param1._-9X;
            if (param1._-9X != 0 && param3 >= _loc_4 && param3 < 99 && param3 != 0)
            {
                param3 = _loc_4 - 1;
            }
            if (param1.layout == 1)
            {
                if (param2._hResizePiority >= param1._hResizePiority)
                {
                    param1._-Hc();
                }
            }
            else if (param2._vResizePiority >= param1._vResizePiority)
            {
                param1._-Hc();
            }
            param1._-3l(param2, param3);
            return;
        }// end function

        public function showTabMenu(param1:GComponent) : void
        {
            this._-Kz.show(this._editor.groot);
            this._-Kz.contentPane.data = param1;
            return;
        }// end function

        private function _-Gy(event:Event) : void
        {
            var _loc_2:* = GComponent(this._-Kz.contentPane.data);
            this.hideView(_loc_2.name);
            return;
        }// end function

        public function onDragGridStart(param1:ViewGrid, param2:GObject) : void
        {
            this._-4z = param1;
            this._-2O = param2;
            this._-9c = null;
            this._-Gv = INVALID;
            this._editor.dragManager.startDrag(this, null, param2 != null ? (param2) : ("ui://Builder/panel_tab"), {onComplete:this.__dragEnd, onCancel:this._-BU, onMove:this.__dragging});
            return;
        }// end function

        private function __dragging(event:DragEvent) : void
        {
            var _loc_3:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_2:* = sHelperRect;
            this._editor.groot.addChild(this._-Kq);
            var _loc_4:* = this._editor.groot.getObjectUnderMouse();
            while (_loc_4 && !(_loc_4 is ViewGrid))
            {
                
                _loc_4 = _loc_4.parent;
            }
            var _loc_5:* = _loc_4 as ViewGrid;
            if (_loc_4 as ViewGrid == null)
            {
                _loc_3 = this.globalToLocal(event.stageX, event.stageY);
                if (_loc_3.x <= 0)
                {
                    this._-Gv = LEFT;
                    _loc_2 = this.localToGlobalRect(0, 0, 100, this.height, _loc_2);
                }
                else if (_loc_3.x >= this.width)
                {
                    this._-Gv = _-HI;
                    _loc_2 = this.localToGlobalRect(this.width, 0, 100, this.height, _loc_2);
                    _loc_2.x = _loc_2.x - _loc_2.width;
                }
                else if (_loc_3.y < -2)
                {
                    this._-Gv = _-Nh;
                    _loc_2 = this.localToGlobalRect(0, 0, this.width, 100, _loc_2);
                }
                else if (_loc_3.y > this.height + 2)
                {
                    this._-Gv = _-7L;
                    _loc_2 = this.localToGlobalRect(0, this.height, this.width, 100, _loc_2);
                    _loc_2.y = _loc_2.y - _loc_2.height;
                }
                else
                {
                    return;
                }
                this._-9c = null;
            }
            else
            {
                this._-9c = ViewGrid(_loc_5);
                this._-Gv = 0;
                _loc_3 = _loc_5.globalToLocal(event.stageX, event.stageY);
                if (_loc_5._-BE)
                {
                    _loc_6 = _loc_5.asCom.getChild("tab").asList;
                    if (this._-2O != null && _loc_3.y > 0 && _loc_3.y < _loc_6.y + _loc_6.height)
                    {
                        _loc_7 = _loc_6.getItemNear(event.stageX, event.stageY);
                        if (_loc_7 != null)
                        {
                            this._-Gv = _loc_6.getChildIndex(_loc_7);
                            _loc_2 = _loc_7.localToGlobalRect(0, 0, _loc_7.width, _loc_7.height, sHelperRect);
                        }
                        else
                        {
                            this._-Gv = _loc_6.numChildren;
                            _loc_7 = _loc_6.getChildAt((_loc_6.numChildren - 1));
                            _loc_2 = _loc_7.localToGlobalRect(_loc_7.width, 0, this._-2O.width, _loc_7.height, _loc_2);
                        }
                    }
                    else if (_loc_3.y < Math.min(_loc_5.height * 0.2, 100))
                    {
                        this._-Gv = _-Nh;
                        _loc_2 = _loc_5.localToGlobalRect(0, 0, _loc_5.width, Math.min(_loc_5.height * 0.3, 100), _loc_2);
                    }
                    else if (_loc_3.y > _loc_5.height - Math.min(_loc_5.height * 0.2, 100))
                    {
                        this._-Gv = _-7L;
                        _loc_2 = _loc_5.localToGlobalRect(0, _loc_5.height, _loc_5.width, Math.max(_loc_5.height * 0.3, 100), _loc_2);
                        _loc_2.y = _loc_2.y - _loc_2.height;
                    }
                    else if (_loc_3.x < Math.min(_loc_5.width * 0.2, 100))
                    {
                        this._-Gv = LEFT;
                        _loc_2 = _loc_5.localToGlobalRect(0, 0, Math.min(_loc_5.width * 0.3, 100), _loc_5.height, _loc_2);
                    }
                    else if (_loc_3.x > _loc_5.width - Math.min(_loc_5.width * 0.2, 100))
                    {
                        this._-Gv = _-HI;
                        _loc_2 = _loc_5.localToGlobalRect(_loc_5.width, 0, Math.min(_loc_5.width * 0.3, 100), _loc_5.height, _loc_2);
                        _loc_2.x = _loc_2.x - _loc_2.width;
                    }
                    else
                    {
                        this._-Gv = _-P8;
                        _loc_2 = _loc_5.localToGlobalRect(0, 0, _loc_5.width, _loc_5.height, _loc_2);
                    }
                }
                else
                {
                    if (_loc_3.x > _loc_5.width * 0.2 && _loc_3.x < _loc_5.width * 0.8)
                    {
                        if (_loc_3.y < _loc_5.height * 0.3)
                        {
                            this._-Gv = _-Nh;
                            _loc_2 = _loc_5.localToGlobalRect(0, 0, _loc_5.width, _loc_5.height * 0.3, _loc_2);
                        }
                        else if (_loc_3.y > _loc_5.height * 0.3)
                        {
                            this._-Gv = _-7L;
                            _loc_2 = _loc_5.localToGlobalRect(0, _loc_5.height, _loc_5.width, _loc_5.height * 0.3, _loc_2);
                            _loc_2.y = _loc_2.y - _loc_2.height;
                        }
                    }
                    if (this._-Gv == 0)
                    {
                        if (_loc_3.x < _loc_5.width * 0.3)
                        {
                            this._-Gv = LEFT;
                            _loc_2 = _loc_5.localToGlobalRect(0, 0, _loc_5.width * 0.3, _loc_5.height, _loc_2);
                        }
                        else
                        {
                            this._-Gv = _-HI;
                            _loc_2 = _loc_5.localToGlobalRect(_loc_5.width, 0, _loc_5.width * 0.3, _loc_5.height, _loc_2);
                            _loc_2.x = _loc_2.x - _loc_2.width;
                        }
                    }
                }
            }
            this._-Kq.setXY(_loc_2.x, _loc_2.y);
            this._-Kq.setSize(_loc_2.width, _loc_2.height);
            return;
        }// end function

        private function __dragEnd() : void
        {
            var _loc_2:* = null;
            if (this._-Kq.parent)
            {
                this._editor.groot.removeChild(this._-Kq);
            }
            if (this._-Gv == INVALID)
            {
                return;
            }
            var _loc_1:* = null;
            if (this._-2O != null)
            {
                _loc_1 = GComponent(this._-2O.data);
            }
            if (this._-Gv == _-P8)
            {
                if (this._-9c == this._-4z)
                {
                    return;
                }
                if (_loc_1)
                {
                    this._-4z.removeView(_loc_1);
                    this._-9c.addView(_loc_1);
                    if (this._-4z._-47 == 0)
                    {
                        this._-Pl(this._-4z);
                    }
                    this._-9c.selectedView = _loc_1;
                }
                else
                {
                    this._-9c._-PE(this._-4z);
                    this._-Pl(this._-4z);
                }
            }
            else if (this._-Gv >= 0)
            {
                if (this._-9c == this._-4z)
                {
                    this._-4z._-Mg(_loc_1, this._-Gv);
                }
                else
                {
                    this._-4z.removeView(_loc_1);
                    this._-9c._-1I(_loc_1, this._-Gv);
                    this._-9c.selectedView = _loc_1;
                    if (this._-4z._-47 == 0)
                    {
                        this._-Pl(this._-4z);
                    }
                }
            }
            else
            {
                if (this._-9c == this._-4z && (!_loc_1 || this._-4z._-47 == 1))
                {
                    return;
                }
                if (!_loc_1 || this._-4z._-47 == 1)
                {
                    _loc_2 = _-2b(this._-4z.parent);
                    _loc_2._-3v(this._-4z);
                }
                else
                {
                    this._-4z.removeView(_loc_1);
                    this._-4z = this._-JB();
                    this._-4z.addView(_loc_1);
                }
                if (this._-9c == null)
                {
                    this._-KB(this._-4z, _-2b(this.getChildAt(0)), this._-Gv);
                }
                else
                {
                    this._-F2(this._-4z, this._-9c, this._-Gv);
                }
                if (_loc_2 != null)
                {
                    this._-MB(_loc_2);
                }
            }
            return;
        }// end function

        private function _-BU() : void
        {
            if (this._-Kq.parent)
            {
                this._editor.groot.removeChild(this._-Kq);
            }
            this._-4z = null;
            this._-2O = null;
            return;
        }// end function

    }
}
