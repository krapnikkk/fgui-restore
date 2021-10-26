package _-An
{
    import *.*;
    import _-2F.*;
    import _-C9.*;
    import _-Ds.*;
    import _-Gs.*;
    import _-NY.*;
    import _-Pz.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import fairygui.tween.*;
    import fairygui.utils.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;

    public class _-On extends Object implements IDocument
    {
        var _editor:IEditor;
        var _docView:DocumentView;
        var _-Mw:TransitionListView;
        private var _panel:GComponent;
        private var _-PH:Sprite;
        private var _container:Sprite;
        private var _-PB:Graphics;
        private var _-Cn:Sprite;
        private var _-1m:Sprite;
        private var _-7N:TextField;
        private var _-3c:PopupMenu;
        private var _-L0:PopupMenu;
        private var _-CH:PopupMenu;
        private var _-5T:PopupMenu;
        private var _-3C:FPackageItem;
        private var _-I6:FComponent;
        private var _-CR:FTransition;
        private var _-3p:FGroup;
        private var _-8p:FObject;
        private var _-A8:String;
        private var _-7n:Boolean;
        private var _-85:Boolean;
        private var _-3G:Vector.<FObject>;
        private var _-LS:Boolean;
        private var _-9N:int;
        private var _-7M:int;
        private var _-1y:Number;
        private var _-4H:Number;
        private var _-N6:FTransition;
        private var _-9x:FTextField;
        private var _-Ak:Point;
        private var _-O7:Point;
        private var _-HZ:Boolean;
        private var _-IV:_-5U;
        private var _-P1:int;
        private var _-Hu:int;
        private var _-Kl:int;
        private var _-4B:FObject;
        private var _-EM:Boolean;
        private var _-KV:int;
        private var _vars:Object;
        private var _-Lz:Object;
        private var _-FP:Boolean;
        private var _-m:Vector.<FObject>;
        private var _-Ij:Number;
        private var _-Kc:Number;
        private var _-It:int;
        private var _-6p:Boolean;
        private var _-IM:int;
        private var _-1t:int;
        private var _-EI:Boolean;
        private var _-9m:FTextField;
        private var _-5w:FObject;
        private var _-Oa:Vector.<FObject>;
        private var _-1A:Object;
        private var _-DW:String;
        private var _-3D:int;
        private var _-Ip:Vector.<FGroup>;
        private var _-Oz:Vector.<FGroup>;
        private static const _-Cj:Array = [0, 0, 0, -1, 1, -1, 1, 0, 1, 1, 0, 1, -1, 1, -1, 0, -1, -1];
        private static var _-J9:FTransitionValue = new FTransitionValue();

        public function _-On()
        {
            this._-Ip = new Vector.<FGroup>;
            this._-Oz = new Vector.<FGroup>;
            this._vars = {};
            this._-Lz = {};
            this._-IV = new _-5U(this);
            this._-m = new Vector.<FObject>;
            this._-Oa = new Vector.<FObject>;
            this._-DW = "mixed";
            this._-1A = {};
            this._-3D = -1;
            this._panel = new GComponent();
            this._panel.opaque = true;
            var _loc_1:* = new GGraph();
            this._panel.addChild(_loc_1);
            this._-PB = _loc_1.graphics;
            this._-PH = new Sprite();
            this._-PH.mouseEnabled = false;
            var _loc_2:* = new GGraph();
            this._panel.addChild(_loc_2);
            _loc_2.setNativeObject(this._-PH);
            this._container = new Sprite();
            this._container.x = 0;
            this._container.y = 0;
            this._-PH.addChild(this._container);
            this._-Cn = new Sprite();
            this._-Cn.x = 0;
            this._-Cn.y = 0;
            this._-PH.addChild(this._-Cn);
            this._-1m = new Sprite();
            this._-1m.graphics.lineStyle(0.1);
            this._-1m.graphics.drawRect(0, 0, 10, 10);
            this._-1m.graphics.endFill();
            this._-Bq();
            this._panel.displayObject.addEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDown);
            this._panel.displayObject.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, this._-HS);
            this._panel.displayObject.addEventListener(MouseEvent.RIGHT_CLICK, this._-Oq);
            this._panel.addEventListener(DropEvent.DROP, this._-G6);
            return;
        }// end function

        public function get panel() : GComponent
        {
            return this._panel;
        }// end function

        public function get selectionLayer() : Sprite
        {
            return this._-Cn;
        }// end function

        public function open(param1:FPackageItem) : void
        {
            this._-3C = param1;
            this._-3C.setVar("doc", this);
            this._-A8 = this._-3C.getURL();
            this._-LS = false;
            this._-I6 = null;
            this._editor = this._-3C.owner.project.editor;
            this._docView = DocumentView(this._editor.docView);
            this._-Mw = TransitionListView(this._editor.viewManager.getView("fairygui.TransitionListView"));
            this.setVar("showAllInvisibles", false);
            this.setVar("relationsDisabled", false);
            this.setVar("docViewScale", 1);
            this.setVar("testViewScale", 1);
            return;
        }// end function

        public function activate() : void
        {
            var newCreate:Boolean;
            var cnt:int;
            var i:int;
            var child:FObject;
            if (this._-7n)
            {
                return;
            }
            this._-3C.touch();
            if (this._-I6 && this._-7M != this._-3C.version && !this._-LS)
            {
                this.cleanup();
            }
            this._-7n = true;
            if (!this._-I6)
            {
                try
                {
                    this._-I6 = FObjectFactory.createObject(this._-3C, FObjectFlags.IN_DOC | FObjectFlags.ROOT | FObjectFlags.INSPECTING) as FComponent;
                    cnt = this._-I6.numChildren;
                    i;
                    while (i < cnt)
                    {
                        
                        child = this._-I6.getChildAt(i);
                        child._docElement = new _-PX(this, child);
                        i = (i + 1);
                    }
                }
                catch (err:Error)
                {
                    _editor.alert("Open document", err);
                    if (_-I6)
                    {
                        _-I6.dispose();
                    }
                    _-I6 = FComponent(FObjectFactory.createObject2(_-3C.owner, _-3C.type, null, FObjectFlags.IN_DOC | FObjectFlags.ROOT | FObjectFlags.INSPECTING));
                    _-I6.errorStatus = true;
                    _-I6.setSize(_-3C.width, _-3C.height);
                }
                this._-I6._docElement = new _-PX(this, this._-I6, true);
                this._-I6._docElement.selected = true;
                this._-L1();
                this._-I6.updateChildrenVisible();
                this._-I6.dispatcher.on(FObject.SIZE_CHANGED, this._-EG);
                this._-I6.dispatcher.on(FObject.XY_CHANGED, this._-OO);
                this._container.addChild(this._-I6.displayObject);
                this._-I6.updateDisplayList(true);
                this._-Ja();
                this._-3p = null;
                newCreate;
                this._-9N = this._-3C.version;
            }
            else
            {
                this._-9C();
            }
            this._-7M = this._-3C.version;
            if (newCreate)
            {
                this._-DM(true);
                this._-N2();
            }
            else
            {
                this._-DM(false);
                this._-2j();
            }
            this._-G4();
            if (this._-HZ)
            {
                this.drawBackground();
            }
            this._-AJ();
            this._-3D = 0;
            this._editor.emit(EditorEvent.DocumentActivated, this);
            GTimers.inst.step();
            if (this._-N6 != null)
            {
                this.enterTimelineMode(this._-N6.name);
            }
            return;
        }// end function

        private function _-N2() : void
        {
            var _loc_1:* = this._container.x + this._-I6.width * this._container.scaleX / 2 - this._panel.parent.viewWidth / 2;
            var _loc_2:* = this._container.y + this._-I6.height * this._container.scaleY / 2 - this._panel.parent.viewHeight / 2;
            if (_loc_1 > this._container.x)
            {
                _loc_1 = this._container.x - 10;
            }
            if (_loc_2 > this._container.y)
            {
                _loc_2 = this._container.y - 10;
            }
            this._panel.parent.scrollPane.posX = _loc_1;
            this._panel.parent.scrollPane.posY = _loc_2;
            return;
        }// end function

        public function _-BA() : void
        {
            if (!this._-7n)
            {
                return;
            }
            this._-7n = false;
            this._-HM();
            this.cancelPickObject();
            this._-N6 = this._-CR;
            this.exitTimelineMode();
            this._-99();
            this._-7N = null;
            this._-9m = null;
            this._-Cn.graphics.clear();
            this._editor.groot.nativeStage.removeEventListener(MouseEvent.MOUSE_UP, this.__stageMouseUp);
            this._editor.groot.nativeStage.removeEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            this._editor.emit(EditorEvent.DocumentDeactivated, this);
            return;
        }// end function

        private function cleanup() : void
        {
            this._-BA();
            this._-m.length = 0;
            this._container.removeChildren();
            this._container.x = 0;
            this._container.y = 0;
            this._-Cn.x = 0;
            this._-Cn.y = 0;
            this._-Cn.removeChildren();
            this._-N6 = null;
            this._-5w = null;
            if (this._-8p)
            {
                this._-8p.dispose();
                this._-8p = null;
            }
            if (this._-I6)
            {
                if (this._-LS)
                {
                    this._-3C.setChanged();
                    this._-3C.owner.setChanged();
                }
                this._-IV.reset();
                this._-I6.dispose();
                this._-I6 = null;
            }
            return;
        }// end function

        public function release() : void
        {
            this.cleanup();
            if (this._-3C)
            {
                this._-3C.setVar("doc", undefined);
                this._-3C = null;
            }
            this._-A8 = null;
            return;
        }// end function

        public function _-DU() : void
        {
            var _loc_1:* = this._-IM;
            this._-IM = 0;
            this._-1t = this._editor.project.lastChanged;
            if (_loc_1 == this._-1t)
            {
                return;
            }
            this._-9C();
            return;
        }// end function

        private function _-9C() : void
        {
            this._-3C.touch();
            if (!this._-LS && this._-7M != this._-3C.version)
            {
                this.cleanup();
                this.activate();
            }
            else if (this._-I6)
            {
                if (this._-I6.validateChildren())
                {
                    this._-3D = 0;
                }
                if (this._-8p)
                {
                    this._-8p.validate();
                }
            }
            return;
        }// end function

        public function setVar(param1:String, param2) : void
        {
            if (param2 == undefined)
            {
                delete this._vars[param1];
            }
            else
            {
                this._vars[param1] = param2;
            }
            return;
        }// end function

        public function getVar(param1:String)
        {
            return this._vars[param1];
        }// end function

        public function setMeta(param1:String, param2) : void
        {
            this._-FP = true;
            if (param2 == undefined)
            {
                delete this._-Lz[param1];
            }
            else
            {
                this._-Lz[param1] = param2;
            }
            return;
        }// end function

        public function getMeta(param1:String)
        {
            return this._-Lz[param1];
        }// end function

        public function onUpdate() : void
        {
            var inspectors:Vector.<IInspectorPanel>;
            var ins:IInspectorPanel;
            var updateFlags:*;
            if (!this._editor.active)
            {
                return;
            }
            if (this._-CR)
            {
                if (this._-6p)
                {
                    this._-6p = false;
                    this._-I6.transitions.readSnapshot();
                    this._-I6.transitions.clearSnapshot();
                    this._-I6.transitions.takeSnapshot();
                    this._-EI = false;
                    this._-CR.play(null, null, 1, 0, this._-It, this._-It, true);
                    this.refreshInspectors(_-8B._-4T);
                }
                else if (this._-EI)
                {
                    this._-I6.transitions.readSnapshot(false);
                    this._-EI = false;
                    this._-CR.play(null, null, 1, 0, this._-It, this._-It, true);
                    this.refreshInspectors(_-8B._-4T);
                }
            }
            if (this._-3D != -1)
            {
                try
                {
                    if (this._-3D == 0)
                    {
                        this._-MM();
                        this._editor.inspectorView.showDefault();
                    }
                    else
                    {
                        inspectors = this._editor.inspectorView.visibleInspectors;
                        var _loc_2:* = 0;
                        var _loc_3:* = inspectors;
                        while (_loc_3 in _loc_2)
                        {
                            
                            ins = _loc_3[_loc_2];
                            updateFlags = _-8B._-Dt[ins.panel.name];
                            if (updateFlags == undefined)
                            {
                                if ((this._-3D & _-8B.COMMON) != 0)
                                {
                                    ins.updateUI();
                                }
                                continue;
                            }
                            if ((updateFlags & this._-3D) != 0)
                            {
                                ins.updateUI();
                            }
                        }
                    }
                }
                catch (e:Error)
                {
                    throw null;
                }
                finally
                {
                    this._-3D = -1;
                }
            }
            if (this._-5w)
            {
                if (!this._-5w.docElement.selected || !(this._-5w.docElement.gizmo.verticesEditing || this._-5w.docElement.gizmo.keyFrame))
                {
                    this._-5w = null;
                }
            }
            var cnt:* = this._-I6.numChildren;
            var i:int;
            while (i < cnt)
            {
                
                _-I9(this._-I6.getChildAt(i)._docElement.gizmo).onUpdate();
                i = (i + 1);
            }
            _-I9(this._-I6._docElement.gizmo).onUpdate();
            return;
        }// end function

        private function _-MM() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            this._-Oa.length = 0;
            var _loc_1:* = this._-m.length;
            this._-DW = null;
            if (_loc_1 == 0)
            {
                this._-Oa.push(this._-I6);
                if (this._-I6.extentionId)
                {
                    this._-DW = this._-I6.extentionId;
                }
                else
                {
                    this._-DW = "component";
                }
            }
            else
            {
                for (_loc_2 in this._-1A)
                {
                    
                    _loc_8[_loc_2] = 0;
                }
                _loc_3 = 0;
                while (_loc_3 < _loc_1)
                {
                    
                    _loc_4 = this._-m[_loc_3];
                    this._-Oa.push(_loc_4);
                    if (_loc_4 is FComponent && FComponent(_loc_4).extentionId)
                    {
                        _loc_5 = FComponent(_loc_4).extentionId;
                    }
                    else
                    {
                        _loc_5 = _loc_4._objectType;
                    }
                    _loc_6 = _loc_8[_loc_5];
                    _loc_6 = _loc_6 + 1;
                    _loc_8[_loc_5] = _loc_6;
                    _loc_3++;
                }
                for (_loc_2 in this._-1A)
                {
                    
                    if (_loc_8[_loc_2] == _loc_1)
                    {
                        this._-DW = _loc_2;
                        break;
                    }
                }
                if (this._-DW == null)
                {
                    this._-DW = "mixed";
                }
            }
            return;
        }// end function

        public function get inspectingTarget() : FObject
        {
            return this._-Oa[0];
        }// end function

        public function get inspectingTargets() : Vector.<FObject>
        {
            return this._-Oa;
        }// end function

        public function get inspectingObjectType() : String
        {
            return this._-DW;
        }// end function

        public function getInspectingTargetCount(param1:String) : int
        {
            return this._-1A[param1];
        }// end function

        public function _-AJ() : void
        {
            this._-I6.handleTextBitmapMode(false);
            if (this._-KV && this._-4B == null && getTimer() - this._-KV > 500)
            {
                this._-Cn.graphics.clear();
                this._-KV = 0;
            }
            return;
        }// end function

        public function _-In() : void
        {
            this._-DM(true);
            return;
        }// end function

        public function get packageItem() : FPackageItem
        {
            return this._-3C;
        }// end function

        public function get content() : FComponent
        {
            return this._-I6;
        }// end function

        public function get editor() : IEditor
        {
            return this._editor;
        }// end function

        public function get history() : IDocHistory
        {
            return this._-IV;
        }// end function

        public function get uid() : String
        {
            return this._-A8;
        }// end function

        public function get isModified() : Boolean
        {
            return this._-LS;
        }// end function

        public function setModified(param1:Boolean = true) : void
        {
            this._-3C.setChanged();
            this._-7M = this._-3C.version;
            if (this._-LS != param1)
            {
                this._-LS = param1;
                this._docView._-LV(this);
            }
            return;
        }// end function

        public function get _-6D() : int
        {
            return this._-9N;
        }// end function

        public function serialize() : Object
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            if (this._-CR)
            {
                this._-I6.transitions.readSnapshot();
                this._-6p = true;
            }
            if (this._-5w && this._-5w is FGraph && FGraph(this._-5w).type == FGraph.POLYGON)
            {
                _loc_1 = _-PX(this._-5w.docElement);
                if (_loc_1.gizmo.verticesEditing)
                {
                    _loc_1.updateGraphBounds();
                }
            }
            if (this._-3p)
            {
                _loc_2 = this._-3p;
                while (_loc_2)
                {
                    
                    if (_loc_2.boundsChanged || _loc_2.advanced && _loc_2.layout != "none" && _loc_2.excludeInvisibles)
                    {
                        _loc_2.updateImmdediately();
                    }
                    _loc_2 = _loc_2._group;
                }
            }
            return this._-I6.write_editMode();
        }// end function

        public function save() : void
        {
            if (!this._-LS || this._-I6.errorStatus)
            {
                return;
            }
            try
            {
                UtilsFile.saveXData(this._-3C.file, XData(this.serialize()));
            }
            catch (err:Error)
            {
                _editor.alert("Save failed!", err);
                return;
            }
            this._-LS = false;
            this._-3C.setUptoDate();
            var _loc_2:* = this._-3C.version;
            this._-9N = this._-3C.version;
            this._-7M = _loc_2;
            if (this._-1t == this._editor.project.lastChanged)
            {
                this._-3C.owner.setChanged();
                this._-IM = this._editor.project.lastChanged;
            }
            else
            {
                this._-3C.owner.setChanged();
            }
            this._-HM();
            this._editor.emit(EditorEvent.PackageItemChanged, this._-3C);
            if (!_-D._-8J)
            {
                _-1L(this._editor).checkRegisterStatus();
            }
            return;
        }// end function

        private function _-L1() : void
        {
            var cnt:int;
            var i:int;
            var obj:FObject;
            var info:Object;
            var metaFile:* = this._-3C.owner.metaFolder.resolvePath(this._-3C.id + ".info");
            try
            {
                if (metaFile.exists)
                {
                    this._-Lz = UtilsFile.loadJSON(metaFile);
                }
                if (!this._-Lz)
                {
                    this._-Lz = {};
                }
            }
            catch (err:Error)
            {
                _editor.consoleView.logError("load meta", err);
            }
            this._-FP = false;
            if (this._-Lz.objectStatus)
            {
                cnt = this._-I6.numChildren;
                i;
                while (i < cnt)
                {
                    
                    obj = this._-I6.getChildAt(i);
                    info = this._-Lz.objectStatus[obj.id];
                    if (info)
                    {
                        if (info.collapsed && obj is FGroup)
                        {
                            FGroup(obj).collapsed = true;
                        }
                        if (info.hidden)
                        {
                            obj.hideByEditor = true;
                        }
                        if (info.locked)
                        {
                            obj.locked = true;
                        }
                    }
                    i = (i + 1);
                }
            }
            return;
        }// end function

        private function _-HM() : void
        {
            var obj:FObject;
            var info:Object;
            var empty:Boolean;
            var key:String;
            var objectStatus:Object;
            var cnt:* = this._-I6.numChildren;
            var i:int;
            while (i < cnt)
            {
                
                obj = this._-I6.getChildAt(i);
                info;
                if (obj is FGroup && FGroup(obj).collapsed)
                {
                    if (!info)
                    {
                        info;
                    }
                    info.collapsed = true;
                }
                if (obj.hideByEditor)
                {
                    if (!info)
                    {
                        info;
                    }
                    info.hidden = true;
                }
                if (obj.locked)
                {
                    if (!info)
                    {
                        info;
                    }
                    info.locked = true;
                }
                if (info)
                {
                    if (!objectStatus)
                    {
                        objectStatus;
                    }
                    objectStatus[obj.id] = info;
                }
                i = (i + 1);
            }
            if (objectStatus)
            {
                this._-Lz.objectStatus = objectStatus;
                this._-FP = true;
            }
            else if (this._-Lz.objectStatus)
            {
                delete this._-Lz.objectStatus;
                this._-FP = true;
            }
            if (!this._-FP)
            {
                return;
            }
            this._-FP = false;
            var metaFile:* = this._-3C.owner.metaFolder.resolvePath(this._-3C.id + ".info");
            if (!metaFile.exists)
            {
                empty;
                var _loc_2:* = 0;
                var _loc_3:* = this._-Lz;
                while (_loc_3 in _loc_2)
                {
                    
                    key = _loc_3[_loc_2];
                    empty;
                    break;
                }
                if (empty)
                {
                    return;
                }
            }
            try
            {
                UtilsFile.saveJSON(metaFile, this._-Lz);
            }
            catch (err:Error)
            {
                _editor.consoleView.logError("save meta", err);
            }
            return;
        }// end function

        private function _-DM(param1:Boolean = false) : void
        {
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_2:* = this._-I6.getBounds();
            _loc_2.x = _loc_2.x + this._-I6.x;
            _loc_2.y = _loc_2.y + this._-I6.y;
            _loc_2.x = _loc_2.x * this._container.scaleX;
            _loc_2.y = _loc_2.y * this._container.scaleY;
            _loc_2.width = _loc_2.width * this._container.scaleX;
            _loc_2.height = _loc_2.height * this._container.scaleY;
            var _loc_3:* = Math.max(-_loc_2.x + 50, 400);
            var _loc_4:* = false;
            if (param1 || _loc_3 > this._container.x)
            {
                this._container.x = _loc_3;
                this._-Cn.x = _loc_3;
                _loc_4 = true;
            }
            else
            {
                _loc_3 = this._container.x;
            }
            var _loc_5:* = Math.max(-_loc_2.y + 50, 400);
            if (param1 || _loc_5 > this._container.y)
            {
                this._container.y = _loc_5;
                this._-Cn.y = _loc_5;
                _loc_4 = true;
            }
            else
            {
                _loc_5 = this._container.y;
            }
            if (param1)
            {
                _loc_6 = _loc_3 + Math.max(_loc_2.right + 50, this._-I6.width * this._container.scaleX + 400);
                _loc_7 = _loc_5 + Math.max(_loc_2.bottom + 50, this._-I6.height * this._container.scaleY + 400);
            }
            else
            {
                _loc_6 = Math.max(_loc_3 + Math.max(_loc_2.right + 50, this._-I6.width * this._container.scaleX + 400), this._panel.width - this._-PH.x);
                _loc_7 = Math.max(_loc_5 + Math.max(_loc_2.bottom + 50, this._-I6.height * this._container.scaleY + 400), this._panel.height - this._-PH.y);
            }
            if (_loc_6 < this._panel.parent.viewWidth)
            {
                _loc_8 = (this._panel.parent.viewWidth - _loc_6) / 2;
            }
            else
            {
                _loc_8 = 0;
            }
            if (_loc_7 < this._panel.parent.viewHeight)
            {
                _loc_9 = (this._panel.parent.viewHeight - _loc_7) / 2;
            }
            else
            {
                _loc_9 = 0;
            }
            this._-PH.x = _loc_8;
            this._-PH.y = _loc_9;
            _loc_6 = _loc_6 + _loc_8;
            _loc_7 = _loc_7 + _loc_9;
            if (_loc_6 != this._panel.width || _loc_7 != this._panel.height)
            {
                this._panel.setSize(_loc_6, _loc_7);
                this.drawBackground();
            }
            else if (_loc_4)
            {
                this.drawBackground();
            }
            return;
        }// end function

        public function drawBackground() : void
        {
            var _loc_7:* = 0;
            this._-HZ = false;
            this._-PB.clear();
            var _loc_1:* = Math.max(this._panel.width, this._panel.parent.width);
            var _loc_2:* = Math.max(this._panel.height, this._panel.parent.height);
            var _loc_3:* = this._-PH.x + this._container.x;
            var _loc_4:* = this._-PH.y + this._container.y;
            var _loc_5:* = _loc_3 + this._-I6.width * this._container.scaleX - 1;
            var _loc_6:* = _loc_4 + this._-I6.height * this._container.scaleY - 1;
            if (this._-I6.bgColorEnabled)
            {
                _loc_7 = this._-I6.bgColor;
            }
            else
            {
                _loc_7 = this._editor.workspaceSettings.get("canvasColor");
            }
            var _loc_8:* = this._editor.workspaceSettings.get("backgroundColor") == 0 ? (16777215) : (0);
            if (this._editor.workspaceSettings.get("auxline1"))
            {
                this._-PB.lineStyle(1, _loc_8, 1, true);
                Utils.drawDashedLine(this._-PB, _loc_3 + 0.5, 0, _loc_3 + 0.5, _loc_2, 4);
                Utils.drawDashedLine(this._-PB, _loc_5 + 0.5, 0, _loc_5 + 0.5, _loc_2, 4);
                Utils.drawDashedLine(this._-PB, 0, _loc_4 + 0.5, _loc_1, _loc_4 + 0.5, 4);
                Utils.drawDashedLine(this._-PB, 0, _loc_6 + 0.5, _loc_1, _loc_6 + 0.5, 4);
            }
            if (_loc_7 != this._editor.workspaceSettings.get("backgroundColor"))
            {
                this._-PB.lineStyle(0, 0, 0, true, LineScaleMode.NONE);
                this._-PB.beginFill(_loc_7, 1);
                this._-PB.drawRect(_loc_3, _loc_4, this._-I6.width * this._container.scaleX, this._-I6.height * this._container.scaleY);
                this._-PB.endFill();
            }
            return;
        }// end function

        public function _-Ja() : void
        {
            if (this._-8p != null)
            {
                if (this._-I6.designImage == this._-8p.resourceURL)
                {
                    this._-8p.x = this._-I6.designImageOffsetX;
                    this._-8p.y = this._-I6.designImageOffsetY;
                    this._-8p.alpha = this._-I6.designImageAlpha / 100;
                    if (this._-I6.designImageLayer == 0)
                    {
                        this._container.addChildAt(this._-8p.displayObject, 0);
                    }
                    else
                    {
                        this._container.addChild(this._-8p.displayObject);
                    }
                    return;
                }
                this._container.removeChild(this._-8p.displayObject);
                this._-8p.dispose();
                this._-8p = null;
            }
            if (!this._-I6.designImage)
            {
                return;
            }
            var _loc_1:* = this._editor.project.getItemByURL(this._-I6.designImage);
            if (_loc_1 != null)
            {
                this._-8p = FObjectFactory.createObject(_loc_1);
                this._-8p.name = "designImage";
                this._-8p.touchable = false;
                if (this._-I6.designImageLayer == 0)
                {
                    this._container.addChildAt(this._-8p.displayObject, 0);
                }
                else
                {
                    this._container.addChild(this._-8p.displayObject);
                }
                this._-8p.x = this._-I6.designImageOffsetX;
                this._-8p.y = this._-I6.designImageOffsetY;
                this._-8p.alpha = this._-I6.designImageAlpha / 100;
            }
            return;
        }// end function

        public function canPaste() : Boolean
        {
            return _-Ia.hasFormat(_-Ia._-81) || Clipboard.generalClipboard.hasFormat("air:text") || Clipboard.generalClipboard.hasFormat("air:bitmap");
        }// end function

        public function selectObject(param1:FObject, param2:Boolean = false, param3:Boolean = false) : void
        {
            var _loc_5:* = null;
            if (param1 == null || !param1.docElement)
            {
                return;
            }
            if (param1._group != this._-3p)
            {
                if (param3)
                {
                    this.openGroup(param1._group);
                    this.unselectAll();
                }
                else
                {
                    return;
                }
            }
            var _loc_4:* = this._-m.indexOf(param1);
            if (this._-m.indexOf(param1) != -1)
            {
                this._-m.splice(_loc_4, 1);
                this._-m.push(param1);
                return;
            }
            if (this._-IV.processing && !this._-IV._-KF)
            {
                this._-IV._-KF = true;
                this.setSelection(param1);
                return;
            }
            if (param1.docElement.isRoot)
            {
                this.unselectAll();
                return;
            }
            param1.docElement.selected = true;
            this._-I6._docElement.selected = false;
            this._-m.push(param1);
            if (param2)
            {
                _loc_5 = new Rectangle(this._container.x + param1.xMin * this._container.scaleX, this._container.y + param1.yMin * this._container.scaleY, param1.width * this._container.scaleX, param1.height * this._container.scaleY);
                this._panel.parent.scrollPane.scrollToView(_loc_5);
            }
            this._editor.emit(EditorEvent.SelectionChanged, this);
            this._-3D = 0;
            return;
        }// end function

        public function selectAll() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_1:* = this._-I6.numChildren;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._-I6.getChildAt(_loc_2);
                if (_loc_3.displayObject.parent && _loc_3._group == this._-3p && !_loc_3.locked && !_loc_3.hideByEditor)
                {
                    _loc_3.docElement.selected = true;
                    _loc_4 = this._-m.indexOf(_loc_3);
                    if (_loc_4 != -1)
                    {
                        this._-m.splice(_loc_4, 1);
                        this._-m.push(_loc_3);
                        return;
                    }
                    this._-m.push(_loc_3);
                }
                _loc_2++;
            }
            this._-I6._docElement.selected = this._-m.length == 0;
            this._editor.emit(EditorEvent.SelectionChanged, this);
            this._-3D = 0;
            return;
        }// end function

        public function getSelection() : Vector.<FObject>
        {
            return this._-m;
        }// end function

        private function _-DE() : Rectangle
        {
            var _loc_5:* = null;
            var _loc_1:* = new Rectangle();
            var _loc_2:* = this._-m.length;
            var _loc_3:* = [];
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_5 = this._-m[_loc_4];
                _loc_1 = _loc_1.union(new Rectangle(_loc_5.x, _loc_5.y, _loc_5.width, _loc_5.height));
                _loc_4++;
            }
            return _loc_1;
        }// end function

        public function unselectObject(param1:FObject) : void
        {
            var _loc_2:* = this._-m.indexOf(param1);
            if (_loc_2 == -1)
            {
                return;
            }
            this._-m.splice(_loc_2, 1);
            param1.docElement.selected = false;
            if (this._-m.length == 0)
            {
                this._-I6._docElement.selected = true;
            }
            this._editor.emit(EditorEvent.SelectionChanged, this);
            this._-3D = 0;
            return;
        }// end function

        public function unselectAll() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this._-m.length;
            if (_loc_1 == 0)
            {
                return;
            }
            var _loc_2:* = _loc_1 - 1;
            while (_loc_2 >= 0)
            {
                
                _loc_3 = this._-m[_loc_2];
                _loc_3.docElement.selected = false;
                _loc_2 = _loc_2 - 1;
            }
            this._-m.length = 0;
            this._-I6._docElement.selected = true;
            this._editor.emit(EditorEvent.SelectionChanged, this);
            this._-3D = 0;
            return;
        }// end function

        public function setSelection(param1:Object) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_2:* = this._-m.length;
            if (param1 is FObject)
            {
                _loc_3 = FObject(param1);
                _loc_4 = _loc_2 - 1;
                while (_loc_4 >= 0)
                {
                    
                    _loc_5 = this._-m[_loc_4];
                    if (_loc_5 != _loc_3)
                    {
                        _loc_5.docElement.selected = false;
                    }
                    _loc_4 = _loc_4 - 1;
                }
                this._-m.length = 0;
                _loc_3.docElement.selected = true;
                if (!_loc_3.docElement.isRoot)
                {
                    this._-m.push(_loc_3);
                    this._-I6._docElement.selected = false;
                }
            }
            else
            {
                _loc_6 = param1 as Vector.<FObject>;
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    _loc_5 = this._-m[_loc_4];
                    if (_loc_6.indexOf(_loc_5) == -1)
                    {
                        _loc_5.docElement.selected = false;
                        this._-m.splice(_loc_4, 1);
                        _loc_2 = _loc_2 - 1;
                        continue;
                    }
                    _loc_4++;
                }
                for each (_loc_5 in _loc_6)
                {
                    
                    if (!_loc_5.docElement.selected && !_loc_5.docElement.isRoot)
                    {
                        _loc_5.docElement.selected = true;
                        this._-m.push(_loc_5);
                    }
                }
                this._-I6._docElement.selected = this._-m.length == 0;
            }
            this._editor.emit(EditorEvent.SelectionChanged, this);
            this._-3D = 0;
            return;
        }// end function

        private function _-5X(param1:Boolean = true) : Array
        {
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_2:* = this._-m.length;
            var _loc_3:* = [];
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_5 = this._-m[_loc_4];
                if (param1 && _loc_5 is FGroup)
                {
                    _loc_6 = this._-I6.numChildren;
                    _loc_8 = 0;
                    while (_loc_8 < _loc_6)
                    {
                        
                        _loc_7 = this._-I6.getChildAt(_loc_8);
                        if (_loc_7.inGroup(FGroup(_loc_5)))
                        {
                            _loc_3.push({index:_loc_8, obj:_loc_7});
                        }
                        _loc_8++;
                    }
                }
                _loc_3.push({index:this._-I6.getChildIndex(_loc_5), obj:_loc_5});
                _loc_4++;
            }
            _loc_3.sortOn("index", Array.NUMERIC);
            return _loc_3;
        }// end function

        public function copySelection() : void
        {
            var _loc_4:* = false;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_1:* = this._-DE();
            var _loc_2:* = this._-5X();
            var _loc_3:* = _loc_2.length;
            if (_loc_3 == 0)
            {
                return;
            }
            var _loc_5:* = new Vector.<XData>;
            var _loc_6:* = {src:this._-3C, rect:_loc_1, objects:_loc_5};
            var _loc_7:* = 0;
            while (_loc_7 < _loc_3)
            {
                
                _loc_8 = _loc_2[_loc_7];
                _loc_9 = _loc_8.obj;
                _loc_10 = _loc_9.write();
                _loc_5.push(_loc_10);
                _loc_10.setAttribute("xy", _loc_9.x - _loc_1.x + "," + (_loc_9.y - _loc_1.y));
                if (_loc_9._res != null)
                {
                    _loc_10.setAttribute("pkg", _loc_9._pkg.id);
                }
                if (_loc_9._group != null)
                {
                    _loc_4 = false;
                    _loc_11 = _loc_7 + 1;
                    while (_loc_11 < _loc_3)
                    {
                        
                        if (_loc_2[_loc_11].obj == _loc_9._group)
                        {
                            _loc_4 = true;
                            break;
                        }
                        _loc_11++;
                    }
                    if (!_loc_4)
                    {
                        _loc_10.removeAttribute("group");
                    }
                }
                _loc_7++;
            }
            _-Ia.setValue(_-Ia._-81, _loc_6);
            return;
        }// end function

        public function deleteSelection() : void
        {
            var _loc_4:* = null;
            if (this._-85)
            {
                return;
            }
            var _loc_1:* = this._-m.concat();
            var _loc_2:* = _loc_1.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = _loc_1[_loc_3];
                _loc_4.docElement.selected = false;
                if (_loc_4 is FGroup)
                {
                    this._-NJ(FGroup(_loc_4));
                }
                this.removeObject(_loc_4);
                _loc_3++;
            }
            this._-m.length = 0;
            this._-I6._docElement.selected = true;
            this._editor.groot.nativeStage.focus = null;
            return;
        }// end function

        public function _-NJ(param1:FGroup) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = this._-I6.numChildren;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._-I6.getChildAt(_loc_3);
                if (_loc_4.inGroup(param1))
                {
                    this.removeObject(_loc_4);
                    _loc_2 = _loc_2 - 1;
                    continue;
                }
                _loc_3++;
            }
            return;
        }// end function

        public function moveSelection(param1:Number, param2:Number) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = NaN;
            var _loc_3:* = this._-m.length;
            if (_loc_3 == 0)
            {
                return;
            }
            this._vars.selectionTransforming = true;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = this._-m[_loc_4];
                _loc_6 = this._-MJ(_loc_5);
                _loc_7 = _loc_5.x + param1;
                if (!(_loc_6 & 1))
                {
                    _loc_5.docElement.setProperty("x", _loc_7);
                }
                _loc_7 = _loc_5.y + param2;
                if (!(_loc_6 & 2))
                {
                    _loc_5.docElement.setProperty("y", _loc_7);
                }
                _loc_4++;
            }
            this._vars.selectionTransforming = false;
            this._-Oc(this._-m[0]);
            return;
        }// end function

        public function globalToCanvas(param1:Number, param2:Number) : Point
        {
            var _loc_3:* = new Point(param1, param2);
            _loc_3 = this._container.globalToLocal(_loc_3);
            _loc_3.x = _loc_3.x - this._-I6.x;
            _loc_3.y = _loc_3.y - this._-I6.y;
            _loc_3.x = int(_loc_3.x);
            _loc_3.y = int(_loc_3.y);
            return _loc_3;
        }// end function

        public function _-1c() : Point
        {
            var _loc_1:* = this._panel.parent.localToGlobal(this._panel.parent.width / 2, this._panel.parent.height / 2);
            _loc_1 = this._container.globalToLocal(_loc_1);
            return _loc_1;
        }// end function

        public function paste(param1:Point = null, param2:Boolean = false) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            if (this._-85)
            {
                return;
            }
            if (_-Ia.hasFormat(_-Ia._-81))
            {
                _loc_3 = _-Ia._-4y(_-Ia._-81);
                this._-Ak = param1;
                if (this._-Ak == null)
                {
                    if (param2)
                    {
                        this._-Ak = this._-1c();
                        this._-Ak.x = this._-Ak.x - _loc_3.rect.width / 2;
                        this._-Ak.y = this._-Ak.y - _loc_3.rect.height / 2;
                    }
                    else
                    {
                        this._-Ak = _loc_3.rect.topLeft;
                    }
                }
                this._-Ak.x = int(this._-Ak.x);
                this._-Ak.y = int(this._-Ak.y);
                this._-DH();
            }
            else if (Clipboard.generalClipboard.hasFormat("air:bitmap"))
            {
                _loc_4 = Clipboard.generalClipboard.getData("air:bitmap") as BitmapData;
                _loc_5 = (_loc_4).encode(_loc_4.rect, new PNGEncoderOptions());
                _loc_6 = new File(this._editor.project.objsPath + "/temp");
                if (!_loc_6.exists)
                {
                    _loc_6.createDirectory();
                }
                _loc_7 = _loc_6.resolvePath("Bitmap.png");
                UtilsFile.saveBytes(_loc_7, _loc_5);
                this._editor.importResource(this._-I6._pkg).add(_loc_7, "/").process(null, true, this._-1c());
            }
            else if (Clipboard.generalClipboard.hasFormat("air:text"))
            {
                _loc_8 = Clipboard.generalClipboard.getData("air:text") as String;
                if (_loc_8)
                {
                    _loc_9 = FTextField(this.insertObject("text"));
                    _loc_9.text = _loc_8;
                    if (_loc_9.width > 600 && _loc_9.autoSize == "both")
                    {
                        _loc_9.autoSize = "height";
                        _loc_9.width = 600;
                    }
                }
            }
            return;
        }// end function

        private function _-DH() : void
        {
            var pasteToOriginal:Boolean;
            var xml:XData;
            var displayList:XData;
            var cnt:int;
            var i:int;
            var copyHandler:_-JG;
            var data:Vector.<XData>;
            var copyInfo:* = _-Ia._-4y(_-Ia._-81);
            var copiedObjects:* = copyInfo.objects;
            pasteToOriginal = copyInfo.src == this._-3C;
            if (copyInfo.src.owner != this._-3C.owner)
            {
                xml = XData.create("dummy");
                displayList = XData.create("displayList");
                cnt = copiedObjects.length;
                i;
                while (i < cnt)
                {
                    
                    displayList.appendChild(copiedObjects[i].copy());
                    i = (i + 1);
                }
                xml.appendChild(displayList);
                copyHandler = new _-JG();
                copyHandler._-Ko(copyInfo.src.owner, xml, this._-3C.owner, "/", true);
                if (copyHandler._-LR > 0)
                {
                    PasteOptionDialog(this._editor.getDialog(PasteOptionDialog)).open(function (param1:int) : void
            {
                copyHandler.copy(_-3C.owner, param1);
                _-Jk(displayList.getChildren(), pasteToOriginal);
                return;
            }// end function
            );
                }
                else
                {
                    copyHandler.copy(this._-3C.owner, _-JG._-IT);
                    this._-Jk(displayList.getChildren(), pasteToOriginal);
                }
            }
            else
            {
                data = copiedObjects.concat();
                cnt = data.length;
                i;
                while (i < cnt)
                {
                    
                    data[i] = data[i].copy();
                    i = (i + 1);
                }
                this._-Jk(data, pasteToOriginal);
            }
            return;
        }// end function

        private function _-Jk(param1:Vector.<XData>, param2:Boolean) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_6:* = {};
            for each (_loc_3 in param1)
            {
                
                _loc_4 = _loc_3.getAttribute("id");
                if (!param2 || this._-I6.isIdInUse(_loc_4))
                {
                    _loc_5 = this._-I6.getNextId();
                    _loc_6[_loc_4] = _loc_5;
                    _loc_3.setAttribute("id", _loc_5);
                    _loc_10 = _loc_3.getAttribute("name");
                    if (UtilsStr.startsWith(_loc_4, _loc_10))
                    {
                        _loc_3.setAttribute("name", UtilsStr.getNameFromId(_loc_5));
                    }
                }
            }
            for each (_loc_3 in param1)
            {
                
                _loc_4 = _loc_3.getAttribute("group");
                if (_loc_4)
                {
                    _loc_5 = _loc_6[_loc_4];
                    if (_loc_5)
                    {
                        _loc_3.setAttribute("group", _loc_5);
                    }
                }
                else if (this._-3p)
                {
                    _loc_3.setAttribute("group", this._-3p._id);
                }
                _loc_11 = _loc_3.getEnumerator("relation");
                while (_loc_11.moveNext())
                {
                    
                    _loc_5 = _loc_6[_loc_11.current.getAttribute("target")];
                    if (_loc_5)
                    {
                        _loc_11.current.setAttribute("target", _loc_5);
                    }
                }
            }
            this.unselectAll();
            _loc_7 = [];
            if (this._-3p)
            {
                _loc_8 = this._-I6.getChildIndex(this._-3p);
            }
            else
            {
                _loc_8 = this._-I6.numChildren;
            }
            for each (_loc_3 in param1)
            {
                
                _loc_12 = this._-I6.createChild(_loc_3);
                _loc_12._underConstruct = true;
                _loc_12._docElement = new _-PX(this, _loc_12);
                _loc_12.read_beforeAdd(_loc_3, null);
                _loc_12.x = _loc_12.x + this._-Ak.x;
                _loc_12.y = _loc_12.y + this._-Ak.y;
                _loc_12.locked = false;
                this._-I6.addChildAt(_loc_12, _loc_8++);
                _-Kt.addChild(this, _loc_12);
                _loc_7.push(_loc_12);
            }
            _loc_9 = 0;
            for each (_loc_3 in param1)
            {
                
                _loc_12 = _loc_7[_loc_9++];
                _loc_12.relations.read(_loc_3);
                _loc_12.read_afterAdd(_loc_3, null);
                _loc_12._underConstruct = false;
                if (_loc_12._group)
                {
                    _loc_12._group.refresh();
                }
            }
            _loc_9 = 0;
            for each (_loc_3 in param1)
            {
                
                _loc_12 = _loc_7[_loc_9++];
                this.selectObject(_loc_12);
            }
            this._editor.emit(EditorEvent.HierarchyChanged);
            return;
        }// end function

        public function replaceSelection(param1:String) : void
        {
            var _loc_2:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_3:* = this._-m.concat();
            for each (_loc_4 in _loc_3)
            {
                
                if (_loc_4 is FGroup)
                {
                    this._editor.consoleView.logWarning(Consts.strings.text457);
                    continue;
                }
                if (!UtilsStr.startsWith(param1, "ui://"))
                {
                    _loc_2 = FObjectFactory.createObject2(this._-I6._pkg, param1, null, FObjectFlags.IN_DOC | FObjectFlags.INSPECTING);
                    if (_loc_2 == null)
                    {
                        this._editor.alert("invalid object type");
                        return;
                    }
                }
                else
                {
                    _loc_7 = this._editor.project.getItemByURL(param1);
                    if (_loc_7.owner != this._-I6._pkg && !_loc_7.exported)
                    {
                        this._editor.alert(Consts.strings.text12);
                        return;
                    }
                    if (_loc_7.owner == this._-I6._pkg && _loc_7.id == this._-3C.id)
                    {
                        this._editor.alert(Consts.strings.text76);
                        return;
                    }
                    _loc_2 = FObjectFactory.createObject(_loc_7, FObjectFlags.IN_DOC | FObjectFlags.INSPECTING);
                    if (_loc_2 is FComponent && (_loc_2 as FComponent).containsComponent(this._-3C))
                    {
                        _loc_2.dispose();
                        this._editor.alert(Consts.strings.text76);
                        return;
                    }
                }
                _loc_2._docElement = new _-PX(this, _loc_2);
                _loc_5 = this._-I6.getChildIndex(_loc_4);
                _loc_6 = _loc_4.write();
                if (!_loc_2._res)
                {
                    _loc_6.setAttribute("size", int(_loc_4.width) + "," + int(_loc_4.height));
                }
                if (_loc_2 is FGraph)
                {
                    _loc_6.setAttribute("type", "rect");
                }
                else if (_loc_2 is FTextField || _loc_2 is FRichTextField)
                {
                    _loc_6.setAttribute("autoSize", "none");
                }
                else if (_loc_2 is FLoader)
                {
                    if (_loc_4 is FImage)
                    {
                        _loc_6.setAttribute("url", _loc_4.resourceURL);
                    }
                    else if (_loc_4 is FComponent)
                    {
                        _loc_8 = FComponent(_loc_4).getChildAt(0);
                        if (_loc_8 is FImage)
                        {
                            _loc_6.setAttribute("url", _loc_8.resourceURL);
                        }
                    }
                }
                this.unselectObject(_loc_4);
                this._-I6.removeChild(_loc_4);
                _loc_2.read_beforeAdd(_loc_6, null);
                this._-I6.addChildAt(_loc_2, _loc_5);
                _loc_2.relations.read(_loc_6);
                _loc_2.read_afterAdd(_loc_6, null);
                _loc_2.validateGears();
                this._-I6.notifyChildReplaced(_loc_4, _loc_2);
                _-Kt._-FO(this, _loc_4, _loc_2);
                this.selectObject(_loc_2);
                this._editor.emit(EditorEvent.HierarchyChanged);
            }
            return;
        }// end function

        private function getObjectUnderMouse(event:MouseEvent) : FObject
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_2:* = DisplayObject(event.target);
            while (_loc_2 && _loc_2 != this._container)
            {
                
                if (_loc_2 is _-Er)
                {
                    return _-Er(_loc_2).owner.owner;
                }
                if (_loc_2 is FSprite)
                {
                    _loc_3 = FSprite(_loc_2).owner;
                    if (_loc_3.docElement && _loc_3 != this._-I6 && !_loc_3.locked)
                    {
                        _loc_4 = _loc_3._group;
                        if (_loc_4 == this._-3p)
                        {
                            return _loc_3;
                        }
                        while (_loc_4 != null)
                        {
                            
                            if (_loc_4._group == this._-3p)
                            {
                                return _loc_4;
                            }
                            _loc_4 = _loc_4._group;
                        }
                    }
                }
                _loc_2 = _loc_2.parent;
            }
            return null;
        }// end function

        private function __mouseDown(event:MouseEvent) : void
        {
            var _loc_3:* = 0;
            if (this._editor.cursorManager.currentCursor == CursorType.COLOR_PICKER || this._editor.dragManager.dragging || this._-9m)
            {
                return;
            }
            this._editor.groot.nativeStage.addEventListener(MouseEvent.MOUSE_UP, this.__stageMouseUp);
            this._editor.groot.nativeStage.addEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            this._-P1 = event.stageX;
            this._-Hu = event.stageY;
            this._-Kl = 0;
            this._-4B = null;
            if (this._docView.editType == 1)
            {
                return;
            }
            this._panel.displayObject.addEventListener(MouseEvent.MOUSE_UP, this.__mouseUp);
            var _loc_2:* = this.getObjectUnderMouse(event);
            if (_loc_2 && !_loc_2.locked)
            {
                if (this._-5w && _loc_2 != this._-5w)
                {
                    return;
                }
                this._-4B = _loc_2;
                this._-Kl = getTimer();
                this._-EM = false;
                _loc_3 = this._-m.indexOf(_loc_2);
                if (!event.shiftKey)
                {
                    if (_loc_3 == -1)
                    {
                        this.unselectAll();
                        this.selectObject(_loc_2);
                    }
                }
                else if (_loc_3 == -1)
                {
                    this.selectObject(_loc_2);
                }
                else
                {
                    this._-EM = true;
                }
                _-I9(_loc_2.docElement.gizmo).onDragStart(event);
            }
            else
            {
                this._-Ij = this._-Cn.mouseX;
                this._-Kc = this._-Cn.mouseY;
            }
            return;
        }// end function

        private function __mouseMove(event:MouseEvent) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            if (this._docView.editType == 1)
            {
                _loc_2 = event.stageX - this._-P1;
                _loc_3 = event.stageY - this._-Hu;
                this._-P1 = event.stageX;
                this._-Hu = event.stageY;
                this._panel.parent.scrollPane.posX = this._panel.parent.scrollPane.posX - _loc_2;
                this._panel.parent.scrollPane.posY = this._panel.parent.scrollPane.posY - _loc_3;
            }
            else if (this._-4B)
            {
                if (this._-Kl != 0)
                {
                    if (getTimer() - this._-Kl < 100)
                    {
                        return;
                    }
                    this._-Kl = 0;
                    this._-EM = false;
                    if (event.altKey && !this._-5w && this._-4B.docElement.gizmo.activeHandleIndex == -1)
                    {
                        _loc_4 = this._-m.indexOf(this._-4B);
                        this.copySelection();
                        _loc_5 = _-Ia._-4y(_-Ia._-81);
                        if (_loc_5)
                        {
                            this.paste(new Point(_loc_5.rect.x + (event.stageX - this._-P1) / this._container.scaleX, _loc_5.rect.y + (event.stageY - this._-Hu) / this._container.scaleY));
                        }
                        this._-4B = this._-m[_loc_4];
                        _-I9(this._-4B.docElement.gizmo).onDragStart(event);
                    }
                }
                _-I9(this._-4B.docElement.gizmo).onDragMove(event);
            }
            else if (!this._-5w)
            {
                _loc_6 = Math.abs(this._-Cn.mouseX - this._-Ij);
                _loc_7 = Math.abs(this._-Cn.mouseY - this._-Kc);
                if (!this._-1m.parent)
                {
                    if (_loc_6 < 2 && _loc_7 < 2)
                    {
                        return;
                    }
                    this._-Cn.addChild(this._-1m);
                }
                this._-1m.x = Math.min(this._-Cn.mouseX, this._-Ij);
                this._-1m.y = Math.min(this._-Cn.mouseY, this._-Kc);
                this._-1m.width = _loc_6;
                this._-1m.height = _loc_7;
            }
            return;
        }// end function

        private function __mouseUp(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            this._panel.displayObject.removeEventListener(MouseEvent.MOUSE_UP, this.__mouseUp);
            if (this._docView.editType == 1)
            {
                return;
            }
            if (this._-4B)
            {
                _loc_2 = this._-4B;
                this._-4B = null;
                _-I9(_loc_2.docElement.gizmo).onDragEnd(event);
                if (this._-EM)
                {
                    _loc_3 = this._-m.indexOf(_loc_2);
                    if (_loc_3 != -1)
                    {
                        this.unselectObject(_loc_2);
                    }
                }
                if (event.clickCount == 2)
                {
                    if (_loc_2 is FGroup)
                    {
                        this.openGroup(FGroup(_loc_2));
                    }
                    else
                    {
                        this.setSelection(_loc_2);
                        this.openChild(_loc_2);
                    }
                }
            }
            else if (!this._-1m.parent)
            {
                if (this._editor.dragManager.dragging)
                {
                    return;
                }
                if (this._-5w)
                {
                    if (event.clickCount == 2)
                    {
                        _-I9(this._-5w.docElement.gizmo).editComplete();
                        this._-5w = null;
                        this.refreshInspectors(_-8B.COMMON);
                    }
                    return;
                }
                this.unselectAll();
                if (event.clickCount == 2)
                {
                    this.closeGroup();
                }
            }
            return;
        }// end function

        private function __stageMouseUp(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, this.__stageMouseUp);
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            if (this._docView.editType == 1)
            {
                return;
            }
            this._-4B = null;
            if (this._-1m.parent)
            {
                this._-1m.parent.removeChild(this._-1m);
                this.unselectAll();
                _loc_2 = new Point(this._-1m.x, this._-1m.y);
                _loc_2 = this._container.localToGlobal(_loc_2);
                _loc_2 = this._-I6.displayObject.globalToLocal(_loc_2);
                _loc_3 = new Rectangle(_loc_2.x, _loc_2.y, this._-1m.width, this._-1m.height);
                _loc_4 = this._-I6.numChildren;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_6 = this._-I6.getChildAt(_loc_5);
                    if (_loc_6.displayObject.parent && _loc_6._group == this._-3p && !_loc_6.locked && (_loc_3.containsPoint(new Point(_loc_6.x, _loc_6.y)) || _loc_3.intersects(new Rectangle(_loc_6.x, _loc_6.y, Math.max(_loc_6.width, 1), Math.max(_loc_6.height, 1)))))
                    {
                        this.selectObject(_loc_6);
                    }
                    _loc_5++;
                }
            }
            this._-DM();
            return;
        }// end function

        private function _-HS(event:MouseEvent) : void
        {
            if (this._editor.cursorManager.currentCursor == CursorType.COLOR_PICKER || this._-9m)
            {
                return;
            }
            this._docView.editType = 1;
            this._-P1 = event.stageX;
            this._-Hu = event.stageY;
            this._editor.groot.nativeStage.addEventListener(MouseEvent.MOUSE_UP, this.__stageMouseUp);
            this._editor.groot.nativeStage.addEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            this._editor.groot.nativeStage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, this._-LO);
            return;
        }// end function

        private function _-LO(event:MouseEvent) : void
        {
            this._docView.editType = 0;
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, this.__stageMouseUp);
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            event.currentTarget.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, this._-LO);
            return;
        }// end function

        private function _-Oq(event:MouseEvent) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = false;
            if (this.isPickingObject || this._editor.cursorManager.currentCursor == CursorType.COLOR_PICKER || this._-9m)
            {
                return;
            }
            if (this._-m.length == 1)
            {
                _loc_3 = _-I9(this._-m[0].docElement.gizmo);
                if (_loc_3.verticesEditing)
                {
                    if (event.target is _-Jy)
                    {
                        _loc_3._-LY = _-Jy(event.target);
                        this._-CH.setItemGrayed("remove", _loc_3.activeHandleType != _-I9._-6n);
                    }
                    else
                    {
                        this._-CH.setItemGrayed("remove", true);
                    }
                    this._-CH.show(this._editor.groot);
                    return;
                }
                else if (_loc_3.keyFrame)
                {
                    if (event.target is _-Jy)
                    {
                        _loc_3._-LY = _-Jy(event.target);
                        _loc_4 = _loc_3.activeHandleType != _-I9._-Gp;
                        this._-5T.setItemGrayed("remove", _loc_4);
                        this._-5T.setItemGrayed("smooth", _loc_4);
                        if (!_loc_4)
                        {
                            this._-5T.setItemChecked("smooth", _loc_3.keyFrame.pathPoints[_loc_3.activeHandleIndex].smooth);
                        }
                        else
                        {
                            this._-5T.setItemChecked("smooth", false);
                        }
                    }
                    else
                    {
                        this._-5T.setItemGrayed("remove", true);
                        this._-5T.setItemGrayed("smooth", true);
                        this._-5T.setItemChecked("smooth", false);
                    }
                    this._-5T.show(this._editor.groot);
                    return;
                }
            }
            var _loc_2:* = this.getObjectUnderMouse(event);
            if (_loc_2 && !_loc_2.locked)
            {
                if (this._-m.indexOf(_loc_2) == -1)
                {
                    this.unselectAll();
                    this.selectObject(_loc_2);
                }
            }
            else
            {
                this.unselectAll();
            }
            this.showContextMenu();
            return;
        }// end function

        public function openChild(param1:FObject) : void
        {
            var _loc_3:* = null;
            if (this.isPickingObject)
            {
                return;
            }
            var _loc_2:* = _-I9(param1.docElement.gizmo);
            if (this._-CR)
            {
                _loc_3 = this._-CR.getItemWithPath(this._-It, param1._id);
                if (_loc_3)
                {
                    if (_loc_2.keyFrame)
                    {
                        _loc_2.editComplete();
                    }
                    else
                    {
                        if (this._-m.length > 1)
                        {
                            this.setSelection(param1);
                        }
                        _loc_2.editPath(_loc_3);
                        this._-5w = param1;
                    }
                }
                return;
            }
            if (param1 is FGroup)
            {
                this.openGroup(FGroup(param1));
            }
            else if (param1._res)
            {
                this._editor.libView.openResource(param1._res.displayItem);
            }
            else if (param1 is FLoader)
            {
                this._editor.libView.openResource(FLoader(param1).contentRes.displayItem);
            }
            else if (param1 is FTextField)
            {
                if (!this._-CR)
                {
                    this._-Pp(FTextField(param1));
                }
            }
            else if (param1 is FList)
            {
                if (FList(param1).defaultItem)
                {
                    this._editor.libView.openResource(param1._pkg.project.getItemByURL(FList(param1).defaultItem));
                }
            }
            else if (param1 is FGraph)
            {
                if (!this._-CR && FGraph(param1).isVerticesEditable)
                {
                    if (_loc_2.verticesEditing)
                    {
                        _loc_2.editComplete();
                    }
                    else
                    {
                        if (this._-m.length > 1)
                        {
                            this.setSelection(param1);
                        }
                        _loc_2._-JV();
                        this._-5w = param1;
                    }
                    this.refreshInspectors(_-8B.COMMON);
                }
            }
            return;
        }// end function

        public function _-Pp(param1:FTextField) : void
        {
            var _loc_3:* = null;
            this._-9m = param1;
            if (!this._-7N)
            {
                this._-7N = new TextField();
                this._-7N.type = TextFieldType.INPUT;
                this._-7N.mouseEnabled = true;
                this._-7N.selectable = true;
                this._-7N.border = true;
                this._-7N.background = true;
                this._-7N.backgroundColor = 16777215;
                _loc_3 = new TextFormat(null, null, 0);
                this._-7N.defaultTextFormat = _loc_3;
                this._-7N.addEventListener(FocusEvent.FOCUS_OUT, this._-PF);
            }
            var _loc_2:* = this._-9m.nativeTextField;
            _loc_3 = this._-7N.defaultTextFormat;
            if (UtilsStr.startsWith(this._-9m.font, "ui://"))
            {
                _loc_3.font = UIConfig.defaultFont;
            }
            else
            {
                _loc_3.font = _loc_2.defaultTextFormat.font;
            }
            _loc_3.size = this._-9m.fontSize;
            _loc_3.leading = this._-9m.leading;
            _loc_3.letterSpacing = this._-9m.letterSpacing;
            this._-7N.defaultTextFormat = _loc_3;
            this._-7N.scrollH = 0;
            this._-7N.scrollV = 1;
            this._-7N.autoSize = _loc_2.autoSize;
            this._-7N.wordWrap = _loc_2.wordWrap;
            this._-7N.multiline = _loc_2.multiline;
            this._-7N.width = this._-9m.width;
            this._-7N.height = this._-9m.height;
            this._-7N.x = this._-9m.xMin;
            this._-7N.y = this._-9m.yMin;
            this._-7N.text = this._-9m.text;
            this._-9m.docElement.selected = false;
            this._-9m.displayObject.visible = false;
            this._-I6.displayObject.container.addChild(this._-7N);
            this._editor.groot.nativeStage.focus = this._-7N;
            return;
        }// end function

        private function _-PF(event:Event) : void
        {
            this._-2g();
            return;
        }// end function

        private function _-2g(param1:Boolean = false) : void
        {
            if (param1)
            {
                this._-9m = null;
            }
            else
            {
                this._-7N.parent.removeChild(this._-7N);
                this._-9m.displayObject.visible = true;
                if (this._-m.indexOf(this._-9m) != -1)
                {
                    this._-9m.docElement.selected = true;
                }
                this._-9m.docElement.gizmo.refresh(true);
                if (this._-7N.text != this._-9m.text)
                {
                    this._-9m.docElement.setProperty("text", this._-7N.text);
                }
                GTimers.inst.add(100, 1, this._-2g, true);
            }
            return;
        }// end function

        private function _-Bq() : void
        {
            var _loc_1:* = null;
            this._-3c = new PopupMenu();
            this._-3c.contentPane.width = 210;
            this._-3c.addItem(Consts.strings.text1, this._-7w).name = "cut";
            this._-3c.addItem(Consts.strings.text2, this._-5G).name = "copy";
            this._-3c.addItem(Consts.strings.text3, this._-Eo).name = "paste";
            this._-3c.addItem(Consts.strings.text4, this._-Lr).name = "delete";
            this._-3c.addSeperator();
            this._-3c.addItem(Consts.strings.text5, this._-Hw).name = "selectAll";
            this._-3c.addItem(Consts.strings.text23, this._-No).name = "unselectAll";
            this._-3c.addSeperator();
            _loc_1 = this._-3c.addItem(Consts.strings.text6, this._-ML);
            _loc_1.name = "moveTop";
            _loc_1.getChild("shortcut").text = Consts.isMacOS ? ("⌘→") : ("Ctrl+→");
            _loc_1 = this._-3c.addItem(Consts.strings.text7, this._-ND);
            _loc_1.name = "moveUp";
            _loc_1.getChild("shortcut").text = Consts.isMacOS ? ("⌘↑") : ("Ctrl+↑");
            _loc_1 = this._-3c.addItem(Consts.strings.text8, this._-o);
            _loc_1.name = "moveDown";
            _loc_1.getChild("shortcut").text = Consts.isMacOS ? ("⌘↓") : ("Ctrl+↓");
            _loc_1 = this._-3c.addItem(Consts.strings.text9, this._-DT);
            _loc_1.name = "moveBottom";
            _loc_1.getChild("shortcut").text = Consts.isMacOS ? ("⌘←") : ("Ctrl+←");
            this._-3c.addItem(Consts.strings.text382, this._-3Q).name = "exchangePos";
            this._-3c.addSeperator();
            this._-3c.addItem(Consts.strings.text10 + "...", this._-Dr).name = "replace";
            _loc_1 = this._-3c.addItem(Consts.strings.text238, this._-9f);
            _loc_1.name = "createCom";
            _loc_1.getChild("shortcut").text = "F8";
            _loc_1 = this._-3c.addItem(Consts.strings.text325, this._-2f);
            _loc_1.name = "convertToBitmap";
            this._-3c.addSeperator();
            this._-3c.addItem(Consts.strings.text11, this._-DV).name = "showInLib";
            this._-L0 = new PopupMenu();
            this._-L0.addItem(Consts.strings.text209, this._-t).name = "XY";
            this._-L0.addItem(Consts.strings.text210, this._-t).name = "Size";
            this._-L0.addItem(Consts.strings.text211, this._-t).name = "Alpha";
            this._-L0.addItem(Consts.strings.text212, this._-t).name = "Rotation";
            this._-L0.addItem(Consts.strings.text213, this._-t).name = "Scale";
            this._-L0.addItem(Consts.strings.text306, this._-t).name = "Skew";
            this._-L0.addItem(Consts.strings.text214, this._-t).name = "Color";
            this._-L0.addItem(Consts.strings.text215, this._-t).name = "Animation";
            this._-L0.addItem(Consts.strings.text216, this._-t).name = "Pivot";
            this._-L0.addItem(Consts.strings.text225, this._-t).name = "Visible";
            this._-L0.addItem(Consts.strings.text223, this._-t).name = "Transition";
            this._-L0.addItem(Consts.strings.text222, this._-t).name = "Sound";
            this._-L0.addItem(Consts.strings.text224, this._-t).name = "Shake";
            this._-L0.addItem(Consts.strings.text305, this._-t).name = "ColorFilter";
            this._-L0.addItem(Consts.strings.text379, this._-t).name = "Text";
            this._-L0.addItem(Consts.strings.text380, this._-t).name = "Icon";
            this._-CH = new PopupMenu();
            this._-CH.contentPane.width = 150;
            this._-CH.addItem(Consts.strings.text443, this._-Jd);
            this._-CH.addItem(Consts.strings.text444, this._-7a).name = "remove";
            this._-CH.addSeperator();
            this._-CH.addItem(Consts.strings.text449, this._-H4).name = "quit";
            this._-5T = new PopupMenu();
            this._-5T.contentPane.width = 150;
            this._-5T.addItem(Consts.strings.text443, this._-HC);
            this._-5T.addItem(Consts.strings.text444, this._-3W).name = "remove";
            this._-5T.addSeperator();
            this._-5T.addItem(Consts.strings.text445, this._-Ku).name = "smooth";
            this._-5T.addSeperator();
            this._-5T.addItem(Consts.strings.text449, this._-H4).name = "quit";
            return;
        }// end function

        public function showContextMenu() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_1:* = this._-m.length == 0;
            this._-O7 = this.globalToCanvas(this._panel.displayObject.stage.mouseX, this._panel.displayObject.stage.mouseY);
            if (this._-CR == null)
            {
                this._-3c.setItemGrayed("copy", _loc_1);
                this._-3c.setItemGrayed("cut", _loc_1);
                this._-3c.setItemGrayed("paste", !this.canPaste());
                this._-3c.setItemGrayed("delete", _loc_1);
                this._-3c.setItemGrayed("unselectAll", _loc_1);
                this._-3c.setItemGrayed("moveTop", _loc_1);
                this._-3c.setItemGrayed("moveBottom", _loc_1);
                this._-3c.setItemGrayed("moveUp", _loc_1);
                this._-3c.setItemGrayed("moveDown", _loc_1);
                this._-3c.setItemGrayed("replace", _loc_1);
                this._-3c.setItemGrayed("exchangePos", _loc_1);
                this._-3c.setItemGrayed("showInLib", _loc_1);
                this._-3c.setItemGrayed("createCom", _loc_1);
                this._-3c.setItemGrayed("convertToBitmap", _loc_1);
                this._-3c.show(this._editor.groot);
            }
            else
            {
                _loc_2 = _loc_1 ? (this._-I6) : (this._-m[0]);
                _loc_3 = this._-L0.itemCount;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_5 = this._-L0.list.getChildAt(_loc_4);
                    _loc_5.grayed = !FTransition.getAllowType(_loc_2, _loc_5.name);
                    _loc_4++;
                }
                this._-L0.show(this._editor.groot);
            }
            return;
        }// end function

        private function _-G6(event:DropEvent) : void
        {
            var errors:Array;
            var data:Object;
            var evt:* = event;
            if (!(evt.source is ILibraryView) && !(evt.source is _-On))
            {
                return;
            }
            if (this._-CR != null)
            {
                return;
            }
            this.unselectAll();
            errors;
            var arr:* = evt._-LE;
            var cnt:* = arr.length;
            var pos:* = this.globalToCanvas(this._panel.displayObject.stage.mouseX, this._panel.displayObject.stage.mouseY);
            var i:int;
            while (i < cnt)
            {
                
                data = arr[i];
                try
                {
                    if (data is FPackageItem)
                    {
                        this._insertObjectFromResource(FPackageItem(data), null, null, pos, -1);
                    }
                    else
                    {
                        this._-5S(String(data), null, null, pos, -1);
                    }
                    pos.x = pos.x + 50;
                    pos.y = pos.y + 50;
                }
                catch (err:Error)
                {
                    errors.push(err.message);
                }
                i = (i + 1);
            }
            if (errors.length)
            {
                this._editor.alert(errors.toString());
            }
            return;
        }// end function

        public function insertObject(param1:String, param2:Point = null, param3:int = -1) : FObject
        {
            var _loc_4:* = null;
            if (UtilsStr.startsWith(param1, "ui://"))
            {
                _loc_4 = this._-3C.owner.project.getItemByURL(param1);
                if (!_loc_4)
                {
                    throw new Error("Resource not found \'" + param1 + "\'");
                }
                return this._insertObjectFromResource(_loc_4, null, null, param2, param3);
            }
            else
            {
                return this._-5S(param1, null, null, param2, param3);
            }
        }// end function

        private function _insertObjectFromResource(param1:FPackageItem, param2:String, param3:String, param4:Point, param5:int) : FObject
        {
            var _loc_7:* = null;
            if (param1.type == FPackageItemType.FOLDER || param1.type == FPackageItemType.FONT || param1.type == FPackageItemType.SOUND)
            {
                throw new Error("Cannot instantiate this type of resource");
            }
            if (param1.owner == this._-3C.owner && param1.id == this._-3C.id)
            {
                throw new Error(Consts.strings.text76);
            }
            if (param1.owner != this._-I6._pkg && !param1.exported)
            {
                throw new Error(Consts.strings.text12 + ": \'" + param1.name + "\'");
            }
            var _loc_6:* = FObjectFactory.createObject(param1, FObjectFlags.IN_DOC | FObjectFlags.INSPECTING);
            if (FObjectFactory.createObject(param1, FObjectFlags.IN_DOC | FObjectFlags.INSPECTING) is FComponent && (_loc_6 as FComponent).containsComponent(this._-3C))
            {
                _loc_6.dispose();
                throw new Error(Consts.strings.text76);
            }
            _loc_6._docElement = new _-PX(this, _loc_6);
            _loc_6.aspectLocked = false;
            if (_loc_6 is FComponent)
            {
                if (FComponent(_loc_6).initName)
                {
                    _loc_6.name = FComponent(_loc_6).initName;
                }
            }
            if (param2)
            {
                _loc_6._id = param2;
            }
            if (param3)
            {
                _loc_6.name = param3;
            }
            if (_loc_6.pivotX == 0 && _loc_6.pivotY == 0)
            {
                _loc_7 = this._editor.project.getSetting("common", "pivot");
                if (_loc_7 == "center")
                {
                    _loc_6.setPivot(0.5, 0.5, false);
                }
                else if (_loc_7 == "center_anchor")
                {
                    _loc_6.setPivot(0.5, 0.5, true);
                }
            }
            this._-1W(_loc_6, param4, param5);
            return _loc_6;
        }// end function

        private function _-5S(param1:String, param2:String, param3:String, param4:Point, param5:int) : FObject
        {
            var _loc_7:* = null;
            var _loc_6:* = FObjectFactory.createObject2(this._-I6._pkg, param1, null, FObjectFlags.IN_DOC | FObjectFlags.INSPECTING);
            _loc_6._docElement = new _-PX(this, _loc_6);
            if (param2)
            {
                _loc_6._id = param2;
            }
            if (param3)
            {
                _loc_6.name = param3;
            }
            if (_loc_6 is FTextField)
            {
                _loc_6.setSize(40, 18, false, true);
                FTextField(_loc_6).initFrom(this._-9x);
                this._-9x = FTextField(_loc_6);
            }
            else if (_loc_6 is FList)
            {
                FList(_loc_6).overflow = OverflowConst.SCROLL;
                _loc_6.setSize(200, 300);
            }
            else if (_loc_6 is FLoader)
            {
                _loc_6.setSize(50, 50);
            }
            else
            {
                _loc_6.setSize(100, 100);
            }
            if (_loc_6.pivotX == 0 && _loc_6.pivotY == 0)
            {
                _loc_7 = this._editor.project.getSetting("common", "pivot");
                if (_loc_7 == "center")
                {
                    _loc_6.setPivot(0.5, 0.5, false);
                }
                else if (_loc_7 == "center_anchor")
                {
                    _loc_6.setPivot(0.5, 0.5, true);
                }
            }
            this._-1W(_loc_6, param4, param5);
            return _loc_6;
        }// end function

        private function _-1W(param1:FObject, param2:Point, param3:int) : void
        {
            if (param2 == null)
            {
                param2 = this._-1c();
            }
            param1.x = param2.x;
            param1.y = param2.y;
            if (param3 == -1)
            {
                if (this._-3p)
                {
                    param3 = this._-I6.getChildIndex(this._-3p);
                }
                else
                {
                    param3 = this._-I6.numChildren;
                }
            }
            else if (param3 < 0)
            {
                param3 = 0;
            }
            else if (param3 > this._-I6.numChildren)
            {
                param3 = this._-I6.numChildren;
            }
            this._-I6.addChildAt(param1, param3);
            param1.groupId = this._-3p ? (this._-3p._id) : (null);
            _-Kt.addChild(this, param1);
            this.selectObject(param1);
            this._editor.emit(EditorEvent.HierarchyChanged);
            return;
        }// end function

        public function removeObject(param1:FObject) : void
        {
            var _loc_3:* = null;
            var _loc_5:* = null;
            var _loc_2:* = this._-I6.numChildren;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3 = this._-I6.getChildAt(_loc_4);
                if (_loc_3.relations.hasTarget(param1))
                {
                    _loc_5 = _loc_3.relations.write();
                    _loc_3.relations.removeTarget(param1);
                    _-LZ._-Ji(this, _loc_3, _loc_5);
                }
                _loc_4++;
            }
            if (this._-I6.relations.hasTarget(param1))
            {
                _loc_5 = this._-I6.relations.write();
                this._-I6.relations.removeTarget(param1);
                _-LZ._-Ji(this, this._-I6, _loc_5);
            }
            this.unselectObject(param1);
            _-Kt.removeChild(this, param1);
            this._-I6.removeChild(param1);
            this._editor.emit(EditorEvent.HierarchyChanged);
            return;
        }// end function

        private function _-MX(param1:FController) : void
        {
            this._-DM();
            var _loc_2:* = this._-3p;
            var _loc_3:* = 0;
            var _loc_4:* = -1;
            while (_loc_2 != null)
            {
                
                _loc_3++;
                if (!_loc_2.internalVisible)
                {
                    _loc_4 = _loc_3;
                }
                _loc_2 = _loc_2._group;
            }
            if (_loc_4 != -1)
            {
                this.closeGroup(_loc_4);
            }
            else if (this._-3p && this._-3p.boundsChanged)
            {
                this._-3p.updateImmdediately();
            }
            return;
        }// end function

        public function _-Oc(param1:FObject) : void
        {
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_9:* = null;
            if (!this._editor.workspaceSettings.get("auxline2"))
            {
                return;
            }
            var _loc_2:* = this._-I6.numChildren;
            var _loc_3:* = this._-Cn.graphics;
            _loc_3.clear();
            _loc_3.lineStyle(1, 65280, 1, true, LineScaleMode.NONE);
            var _loc_4:* = false;
            var _loc_7:* = 500;
            var _loc_8:* = 0;
            while (_loc_8 < _loc_2)
            {
                
                _loc_9 = this._-I6.getChildAt(_loc_8);
                if (_loc_9 != param1 && _loc_9.displayObject.stage)
                {
                    if (int(_loc_9.xMin) == int(param1.xMin) || int(_loc_9.xMin) == int(param1.xMax))
                    {
                        _loc_5 = _loc_9.yMin + _loc_9.height / 2;
                        _loc_6 = param1.yMin + param1.height / 2;
                        if (Math.abs(_loc_5 - _loc_6) < _loc_7)
                        {
                            _loc_3.moveTo(_loc_9.xMin, _loc_5);
                            _loc_3.lineTo(_loc_9.xMin, _loc_6);
                            _loc_4 = true;
                        }
                    }
                    else if (int(_loc_9.xMax) == int(param1.xMin) || int(_loc_9.xMax) == int(param1.xMax))
                    {
                        _loc_5 = _loc_9.yMin + _loc_9.height / 2;
                        _loc_6 = param1.yMin + param1.height / 2;
                        if (Math.abs(_loc_5 - _loc_6) < _loc_7)
                        {
                            _loc_3.moveTo(_loc_9.xMax, _loc_5);
                            _loc_3.lineTo(_loc_9.xMax, _loc_6);
                            _loc_4 = true;
                        }
                    }
                    if (int(_loc_9.yMin) == int(param1.yMin) || int(_loc_9.yMin) == int(param1.yMax))
                    {
                        _loc_5 = _loc_9.xMin + _loc_9.width / 2;
                        _loc_6 = param1.xMin + param1.width / 2;
                        if (Math.abs(_loc_5 - _loc_6) < _loc_7)
                        {
                            _loc_3.moveTo(_loc_5, _loc_9.yMin);
                            _loc_3.lineTo(_loc_6, _loc_9.yMin);
                            _loc_4 = true;
                        }
                    }
                    else if (int(_loc_9.yMax) == int(param1.yMin) || int(_loc_9.yMax) == int(param1.yMax))
                    {
                        _loc_5 = _loc_9.xMin + _loc_9.width / 2;
                        _loc_6 = param1.xMin + param1.width / 2;
                        if (Math.abs(_loc_5 - _loc_6) < _loc_7)
                        {
                            _loc_3.moveTo(_loc_5, _loc_9.yMax);
                            _loc_3.lineTo(_loc_6, _loc_9.yMax);
                            _loc_4 = true;
                        }
                    }
                }
                _loc_8++;
            }
            if (_loc_4)
            {
                this._-KV = getTimer();
            }
            else
            {
                this._-KV = 0;
            }
            return;
        }// end function

        private function _-7w(event:Event) : void
        {
            this.copySelection();
            this.deleteSelection();
            return;
        }// end function

        private function _-5G(event:Event) : void
        {
            this.copySelection();
            return;
        }// end function

        private function _-Eo(event:Event) : void
        {
            this.paste(this._-O7);
            return;
        }// end function

        private function _-Lr(event:Event) : void
        {
            this.deleteSelection();
            return;
        }// end function

        private function _-Hw(event:Event) : void
        {
            this.selectAll();
            return;
        }// end function

        private function _-No(event:Event) : void
        {
            this.unselectAll();
            return;
        }// end function

        public function adjustDepth(param1:int) : void
        {
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            if (this._-CR != null)
            {
                return;
            }
            var _loc_2:* = this._-m.length;
            if (_loc_2 == 0)
            {
                return;
            }
            var _loc_3:* = this._-m[0]._group;
            var _loc_4:* = this._-5X();
            _loc_2 = _loc_4.length;
            var _loc_5:* = this._-I6.getChildIndex(_loc_4[(_loc_2 - 1)].obj);
            var _loc_6:* = this._-I6.getChildAt(param1);
            if (this._-I6.getChildAt(param1) is FGroup)
            {
                _loc_9 = FGroup(_loc_6).getStartIndex();
                if (_loc_9 != -1 && _loc_5 > _loc_9)
                {
                    param1 = _loc_9;
                }
            }
            if (param1 == _loc_5)
            {
                return;
            }
            this.openGroup(_loc_6._group);
            if (_loc_3 != _loc_6._group)
            {
                _loc_8 = 0;
                while (_loc_8 < _loc_2)
                {
                    
                    _loc_7 = _loc_4[_loc_8].obj;
                    if (_loc_7._group == _loc_3)
                    {
                        _loc_7.docElement.setProperty("groupId", _loc_6.groupId);
                    }
                    _loc_8++;
                }
            }
            if (param1 > _loc_5)
            {
                _loc_8 = 0;
                while (_loc_8 < _loc_2)
                {
                    
                    _loc_7 = _loc_4[_loc_8].obj;
                    _-Kt.setChildIndex(this, _loc_7, param1);
                    this._-I6.setChildIndex(_loc_7, param1);
                    _loc_8++;
                }
            }
            else
            {
                _loc_8 = _loc_2 - 1;
                while (_loc_8 >= 0)
                {
                    
                    _loc_7 = _loc_4[_loc_8].obj;
                    _-Kt.setChildIndex(this, _loc_7, param1);
                    this._-I6.setChildIndex(_loc_7, param1);
                    _loc_8 = _loc_8 - 1;
                }
            }
            if (_loc_3 != null)
            {
                _loc_3.refresh();
            }
            if (_loc_6._group != null)
            {
                _loc_6._group.refresh();
            }
            this._editor.emit(EditorEvent.HierarchyChanged);
            this.unselectAll();
            _loc_8 = 0;
            while (_loc_8 < _loc_2)
            {
                
                this.selectObject(_loc_4[_loc_8].obj);
                _loc_8++;
            }
            return;
        }// end function

        private function _-ML(event:Event) : void
        {
            var _loc_2:* = 0;
            var _loc_6:* = null;
            if (this._-CR != null)
            {
                return;
            }
            if (this._-3p)
            {
                _loc_2 = this._-I6.getChildIndex(this._-3p) - 1;
            }
            else
            {
                _loc_2 = this._-I6.numChildren - 1;
            }
            var _loc_3:* = this._-5X();
            var _loc_4:* = _loc_3.length;
            if (_loc_3.length == 0)
            {
                return;
            }
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = _loc_3[_loc_5];
                _-Kt.setChildIndex(this, _loc_6.obj, _loc_2);
                this._-I6.setChildIndex(_loc_6.obj, _loc_2);
                _loc_5++;
            }
            this._editor.emit(EditorEvent.HierarchyChanged);
            return;
        }// end function

        private function _-ND(event:Event) : void
        {
            var _loc_2:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            if (this._-CR != null)
            {
                return;
            }
            if (this._-3p)
            {
                _loc_2 = this._-I6.getChildIndex(this._-3p) - 1;
            }
            else
            {
                _loc_2 = this._-I6.numChildren - 1;
            }
            var _loc_3:* = this._-5X();
            var _loc_4:* = _loc_3.length;
            if (_loc_3.length == 0 || _loc_3[(_loc_4 - 1)].index == _loc_2)
            {
                return;
            }
            var _loc_5:* = _loc_4 - 1;
            while (_loc_5 >= 0)
            {
                
                _loc_6 = _loc_3[_loc_5];
                _loc_2 = _loc_6.index + 1;
                while (_loc_2 < (this._-I6.numChildren - 1))
                {
                    
                    _loc_7 = this._-I6.getChildAt(_loc_2);
                    if (_loc_7._group == this._-3p)
                    {
                        break;
                    }
                    _loc_2++;
                }
                _-Kt.setChildIndex(this, _loc_6.obj, this._-I6.getChildIndex(_loc_6.obj));
                this._-I6.setChildIndex(_loc_6.obj, _loc_2);
                _loc_5 = _loc_5 - 1;
            }
            this._editor.emit(EditorEvent.HierarchyChanged);
            return;
        }// end function

        private function _-o(event:Event) : void
        {
            var _loc_2:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            if (this._-CR != null)
            {
                return;
            }
            if (this._-3p)
            {
                _loc_2 = this._-3p.getStartIndex();
            }
            else
            {
                _loc_2 = 0;
            }
            var _loc_3:* = this._-5X();
            var _loc_4:* = _loc_3.length;
            if (_loc_3.length == 0 || _loc_3[0].index == _loc_2)
            {
                return;
            }
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = _loc_3[_loc_5];
                _loc_2 = _loc_6.index - 1;
                while (_loc_2 > 0)
                {
                    
                    _loc_7 = this._-I6.getChildAt(_loc_2);
                    if (_loc_7._group == this._-3p && !(_loc_7 is FGroup))
                    {
                        if (_loc_2 != (_loc_6.index - 1))
                        {
                            _loc_2++;
                        }
                        break;
                    }
                    _loc_2 = _loc_2 - 1;
                }
                _-Kt.setChildIndex(this, _loc_6.obj, this._-I6.getChildIndex(_loc_6.obj));
                this._-I6.setChildIndex(_loc_6.obj, _loc_2);
                _loc_5++;
            }
            this._editor.emit(EditorEvent.HierarchyChanged);
            return;
        }// end function

        private function _-DT(event:Event) : void
        {
            var _loc_2:* = 0;
            var _loc_6:* = null;
            if (this._-CR != null)
            {
                return;
            }
            if (this._-3p)
            {
                _loc_2 = this._-3p.getStartIndex();
            }
            else
            {
                _loc_2 = 0;
            }
            var _loc_3:* = this._-5X();
            var _loc_4:* = _loc_3.length;
            if (_loc_3.length == 0)
            {
                return;
            }
            var _loc_5:* = _loc_4 - 1;
            while (_loc_5 >= 0)
            {
                
                _loc_6 = _loc_3[_loc_5];
                _-Kt.setChildIndex(this, _loc_6.obj, _loc_2);
                this._-I6.setChildIndex(_loc_6.obj, _loc_2);
                _loc_5 = _loc_5 - 1;
            }
            this._editor.emit(EditorEvent.HierarchyChanged);
            return;
        }// end function

        private function _-DV(event:Event) : void
        {
            var _loc_2:* = null;
            if (this._-m.length == 0)
            {
                _loc_2 = this._-I6;
            }
            else
            {
                _loc_2 = this._-m[0];
            }
            if (_loc_2._res)
            {
                if (!_loc_2._res.isMissing)
                {
                    this._editor.libView.highlight(_loc_2._res.displayItem);
                }
            }
            else if (_loc_2 is FLoader)
            {
                this._editor.libView.highlight(FLoader(_loc_2).contentRes.displayItem);
            }
            else if (_loc_2 is FList)
            {
                if (FList(_loc_2).numChildren > 0)
                {
                    _loc_2 = FList(_loc_2).getChildAt(0);
                    if (_loc_2._res)
                    {
                        this._editor.libView.highlight(_loc_2._res.displayItem);
                    }
                }
            }
            return;
        }// end function

        private function _-Dr(event:Event) : void
        {
            this._editor.getDialog(ReplaceObjectDialog).show();
            return;
        }// end function

        private function _-9f(event:Event) : void
        {
            var left:int;
            var top:int;
            var i:int;
            var j:int;
            var insertIndex:int;
            var cxml:XData;
            var pns:Vector.<String>;
            var newName:String;
            var newId:String;
            var obj:FObject;
            var cc:FController;
            var evt:* = event;
            var ssl:* = this._-5X();
            if (ssl.length == 0)
            {
                return;
            }
            left = int.MAX_VALUE;
            top = int.MAX_VALUE;
            var right:* = int.MIN_VALUE;
            var bottom:* = int.MIN_VALUE;
            var cnt:* = ssl.length;
            var sels:* = new Vector.<FObject>;
            i;
            while (i < cnt)
            {
                
                obj = ssl[i].obj;
                sels.push(obj);
                if (obj.x < left)
                {
                    left = obj.x;
                }
                if (obj.y < top)
                {
                    top = obj.y;
                }
                if (obj.x + obj.width > right)
                {
                    right = obj.x + obj.width;
                }
                if (obj.y + obj.height > bottom)
                {
                    bottom = obj.y + obj.height;
                }
                i = (i + 1);
            }
            insertIndex = ssl[0].index;
            var xml:* = XData.create("component");
            xml.setAttribute("size", right - left + "," + (bottom - top));
            var ccCnt:* = this._-I6.controllers.length;
            i;
            while (i < ccCnt)
            {
                
                cc = this._-I6.controllers[i];
                j;
                while (j < cnt)
                {
                    
                    obj = sels[j];
                    if (obj.checkGearsController(cc))
                    {
                        cxml = cc.write();
                        if (cxml)
                        {
                            xml.appendChild(cxml);
                        }
                        break;
                    }
                    j = (j + 1);
                }
                i = (i + 1);
            }
            var dxml:* = XData.create("displayList");
            xml.appendChild(dxml);
            i;
            while (i < cnt)
            {
                
                obj = sels[i];
                cxml = obj.write();
                cxml.setAttribute("xy", int(obj.x - left) + "," + int(obj.y - top));
                if (obj._group != null && sels.indexOf(obj._group) == -1)
                {
                    cxml.removeAttribute("group");
                }
                dxml.appendChild(cxml);
                i = (i + 1);
            }
            newName = ssl[0].obj.name;
            newId = ssl[0].obj.id;
            CreateComDialog(this._editor.getDialog(CreateComDialog)).open(xml, function (param1:FPackageItem) : void
            {
                deleteSelection();
                _insertObjectFromResource(param1, newId, newName, new Point(left, top), insertIndex);
                return;
            }// end function
            );
            return;
        }// end function

        private function _-2f(event:Event) : void
        {
            var i:int;
            var j:int;
            var rect:Rectangle;
            var obj:FObject;
            var insertIndex:int;
            var newName:String;
            var newId:String;
            var evt:* = event;
            var ssl:* = this._-5X();
            if (ssl.length == 0)
            {
                return;
            }
            var left:* = int.MAX_VALUE;
            var top:* = int.MAX_VALUE;
            var right:* = int.MIN_VALUE;
            var bottom:* = int.MIN_VALUE;
            var cnt:* = ssl.length;
            i;
            while (i < cnt)
            {
                
                obj = ssl[i].obj;
                if (obj is FGroup)
                {
                }
                else if (rect == null)
                {
                    rect = obj.displayObject.getBounds(this._-I6.displayObject);
                }
                else
                {
                    rect = rect.union(obj.displayObject.getBounds(this._-I6.displayObject));
                }
                i = (i + 1);
            }
            var bmd:* = new BitmapData(rect.width, rect.height, true, 0);
            var mat:* = new Matrix();
            i;
            while (i < cnt)
            {
                
                obj = ssl[i].obj;
                if (obj is FGroup)
                {
                }
                else
                {
                    mat.identity();
                    mat.translate(obj.x - rect.x, obj.y - rect.y);
                    _-I9(obj.docElement.gizmo).visible = false;
                    bmd.draw(obj.displayObject, mat, null, null, null, true);
                    _-I9(obj.docElement.gizmo).visible = true;
                }
                i = (i + 1);
            }
            var ba:* = bmd.encode(bmd.rect, new PNGEncoderOptions());
            var tempFolder:* = new File(this._editor.project.objsPath + "/temp");
            if (!tempFolder.exists)
            {
                tempFolder.createDirectory();
            }
            var nn:* = ssl[0].obj.name;
            if (!nn)
            {
                nn;
            }
            else
            {
                nn = nn + ".png";
            }
            var file:* = tempFolder.resolvePath(nn);
            UtilsFile.saveBytes(file, ba);
            insertIndex = ssl[0].index;
            newName = ssl[0].obj.name;
            newId = ssl[0].obj.id;
            this._editor.importResource(this._-I6._pkg).add(file, "/").process(function (param1:Vector.<FPackageItem>) : void
            {
                deleteSelection();
                _insertObjectFromResource(param1[0], newId, newName, rect.topLeft, insertIndex);
                return;
            }// end function
            );
            return;
        }// end function

        private function _-3Q(event:Event) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = this._-5X(false);
            if (_loc_2.length <= 1)
            {
                return;
            }
            var _loc_5:* = _loc_2.length;
            var _loc_6:* = [];
            _loc_3 = 0;
            while (_loc_3 < _loc_5)
            {
                
                _loc_4 = _loc_2[_loc_3].obj;
                _loc_6.push(_loc_4.x);
                _loc_6.push(_loc_4.y);
                _loc_3++;
            }
            _loc_3 = 0;
            while (_loc_3 < _loc_5)
            {
                
                _loc_4 = _loc_2[_loc_5 - _loc_3 - 1].obj;
                _loc_4.docElement.setProperty("x", _loc_6[_loc_3 * 2]);
                _loc_4.docElement.setProperty("y", _loc_6[_loc_3 * 2 + 1]);
                _loc_3++;
            }
            return;
        }// end function

        public function createGroup() : void
        {
            var _loc_3:* = 0;
            var _loc_6:* = null;
            if (this._-CR)
            {
                return;
            }
            var _loc_1:* = this._-m.length;
            if (_loc_1 == 0)
            {
                return;
            }
            this._-ML(null);
            var _loc_2:* = new Vector.<FObject>.concat(this._-m);
            this.unselectAll();
            if (this._-3p)
            {
                _loc_3 = this._-I6.getChildIndex(this._-3p);
            }
            else
            {
                _loc_3 = this._-I6.numChildren;
            }
            var _loc_4:* = FObjectFactory.createObject2(this._-I6._pkg, "group", null, FObjectFlags.IN_DOC | FObjectFlags.INSPECTING) as FGroup;
            (_loc_4)._docElement = new _-PX(this, _loc_4);
            this._-I6.addChildAt(_loc_4, _loc_3);
            if (this._-3p)
            {
                _loc_4.groupId = this._-3p._id;
            }
            _-Kt.addChild(this, _loc_4);
            var _loc_5:* = 0;
            while (_loc_5 < _loc_1)
            {
                
                _loc_6 = _loc_2[_loc_5];
                _loc_6.docElement.setProperty("groupId", _loc_4._id);
                _loc_5++;
            }
            _loc_4.updateImmdediately();
            this.selectObject(_loc_4);
            this._editor.emit(EditorEvent.HierarchyChanged);
            return;
        }// end function

        public function destroyGroup() : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            if (this._-CR)
            {
                return;
            }
            var _loc_1:* = this._-m.length;
            if (_loc_1 == 0)
            {
                return;
            }
            var _loc_2:* = this._-m.concat();
            var _loc_3:* = 0;
            while (_loc_3 < _loc_1)
            {
                
                _loc_4 = _loc_2[_loc_3];
                if (!(_loc_4 is FGroup))
                {
                }
                else
                {
                    _loc_5 = FGroup(_loc_4);
                    _loc_6 = _loc_5.groupId;
                    _loc_7 = this._-I6.numChildren;
                    _loc_8 = 0;
                    while (_loc_8 < _loc_7)
                    {
                        
                        _loc_4 = this._-I6.getChildAt(_loc_8);
                        if (_loc_4.groupId == _loc_5._id)
                        {
                            _loc_4.docElement.setProperty("groupId", _loc_6);
                            this.selectObject(_loc_4);
                        }
                        _loc_8++;
                    }
                    this.removeObject(_loc_5);
                }
                _loc_3++;
            }
            this._-I6.updateDisplayList();
            return;
        }// end function

        public function get openedGroup() : FObject
        {
            return this._-3p;
        }// end function

        public function openGroup(param1:FObject) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            if (!param1)
            {
                this.closeGroup(int.MAX_VALUE);
                return;
            }
            if (param1 == this._-3p)
            {
                return;
            }
            this._-Ip.length = 0;
            this._-Oz.length = 0;
            _loc_2 = this._-3p;
            while (_loc_2)
            {
                
                this._-Ip.push(_loc_2);
                _loc_2 = _loc_2._group;
            }
            _loc_2 = FGroup(param1);
            while (_loc_2)
            {
                
                _loc_3 = this._-Ip.indexOf(_loc_2);
                if (_loc_3 != -1)
                {
                    this._-Ip.splice(_loc_3, 1);
                }
                this._-Oz.push(_loc_2);
                _loc_2 = _loc_2._group;
            }
            this._-Oz.reverse();
            for each (_loc_2 in this._-Ip)
            {
                
                if (_loc_2.boundsChanged)
                {
                    _loc_2.updateImmdediately();
                }
                _loc_2._opened = false;
                if (_loc_2.empty)
                {
                    this.removeObject(_loc_2);
                }
            }
            for each (_loc_2 in this._-Oz)
            {
                
                _loc_2._opened = true;
            }
            this._-3p = FGroup(param1);
            this._-I6.updateDisplayList();
            this.unselectAll();
            this._docView._-Dl(this._-3p);
            return;
        }// end function

        public function closeGroup(param1:int = 1) : void
        {
            var _loc_2:* = null;
            if (!this._-3p || param1 < 1)
            {
                return;
            }
            var _loc_3:* = 0;
            while (_loc_3 < param1)
            {
                
                if (this._-3p.boundsChanged)
                {
                    this._-3p.updateImmdediately();
                }
                this._-3p._opened = false;
                _loc_2 = this._-3p;
                this._-3p = _loc_2._group;
                if (_loc_2.parent && _loc_2.empty)
                {
                    this.removeObject(_loc_2);
                }
                if (!this._-3p)
                {
                    break;
                }
                _loc_3++;
            }
            if (this._-7n)
            {
                this.unselectAll();
                if (_loc_2.parent && _loc_2.internalVisible)
                {
                    this.selectObject(_loc_2);
                }
            }
            this._-I6.updateDisplayList();
            this._docView._-Dl(this._-3p);
            return;
        }// end function

        public function notifyGroupRemoved(param1:FGroup) : void
        {
            while (this._-3p && (this._-3p == param1 || this._-3p.inGroup(param1)))
            {
                
                this.closeGroup();
            }
            return;
        }// end function

        public function handleKeyEvent(param1:_-4U) : void
        {
            var _loc_2:* = 0;
            if (param1._-2h != 0)
            {
                _loc_2 = param1._-2h;
                if (param1.ctrlKey || param1.commandKey)
                {
                    if (_loc_2 == 1)
                    {
                        this._-ND(null);
                    }
                    else if (_loc_2 == 5)
                    {
                        this._-o(null);
                    }
                    else if (_loc_2 == 3)
                    {
                        this._-ML(null);
                    }
                    else if (_loc_2 == 7)
                    {
                        this._-DT(null);
                    }
                }
                else if (param1.shiftKey)
                {
                    this.moveSelection(_-Cj[_loc_2 * 2] * 10, _-Cj[_loc_2 * 2 + 1] * 10);
                }
                else
                {
                    this.moveSelection(_-Cj[_loc_2 * 2], _-Cj[_loc_2 * 2 + 1]);
                }
            }
            switch(param1._-T)
            {
                case "0001":
                {
                    if (this._-CR == null)
                    {
                        this.deleteSelection();
                    }
                    break;
                }
                case "0002":
                {
                    if (this._-CR == null)
                    {
                        this.copySelection();
                    }
                    break;
                }
                case "0003":
                {
                    if (this._-CR == null)
                    {
                        this.paste(null, true);
                    }
                    break;
                }
                case "0004":
                {
                    if (this._-CR == null)
                    {
                        this.copySelection();
                        this.deleteSelection();
                    }
                    break;
                }
                case "0005":
                {
                    if (this._-CR == null)
                    {
                        this.selectAll();
                    }
                    break;
                }
                case "0006":
                {
                    if (this._-CR == null)
                    {
                        this.unselectAll();
                    }
                    break;
                }
                case "0007":
                {
                    this._-IV.undo();
                    break;
                }
                case "0008":
                {
                    this._-IV.redo();
                    break;
                }
                case "0301":
                {
                    this._-I6.docElement.setProperty("designImageLayer", this._-I6.designImageLayer == 0 ? (1) : (0));
                    break;
                }
                case "0302":
                {
                    if (this._-CR == null)
                    {
                        this._-9f(null);
                    }
                    break;
                }
                case "0303":
                {
                    if (this._-CR == null)
                    {
                        this._-Dr(null);
                    }
                    break;
                }
                case "0304":
                {
                    if (this._-CR == null)
                    {
                        this.createGroup();
                    }
                    break;
                }
                case "0305":
                {
                    if (this._-CR == null)
                    {
                        this.destroyGroup();
                    }
                    break;
                }
                case "0306":
                {
                    if (this._-CR == null)
                    {
                        this.paste(null);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function pickObject(param1:FObject, param2:Function, param3:Function = null, param4:Function = null) : void
        {
            this._-3G = this._-m.concat();
            this.unselectAll();
            this._-85 = true;
            if (param1)
            {
                this.selectObject(param1, true, true);
            }
            var _loc_5:* = SelectObjectPanel(this._editor.inspectorView.getInspector("pickObject"));
            _loc_5.start(param1, param2, param3, param4);
            this._-3D = 0;
            return;
        }// end function

        public function cancelPickObject() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            if (!this._-85)
            {
                return;
            }
            this._-85 = false;
            this.unselectAll();
            for each (_loc_1 in this._-3G)
            {
                
                this.selectObject(_loc_1, true, true);
            }
            this._-MM();
            _loc_2 = SelectObjectPanel(this._editor.inspectorView.getInspector("pickObject"));
            _loc_2.reset();
            this._-3D = 0;
            return;
        }// end function

        public function get isPickingObject() : Boolean
        {
            return this._-85;
        }// end function

        public function enterTimelineMode(param1:String) : void
        {
            var _loc_2:* = this._-I6.transitions.getItem(param1);
            if (!_loc_2 || _loc_2 == this._-CR)
            {
                return;
            }
            if (this._-CR != null)
            {
                this.exitTimelineMode();
            }
            else
            {
                this.closeGroup(int.MAX_VALUE);
            }
            this._-CR = _loc_2;
            this._-6p = false;
            this._-IV.enterTimelineMode();
            this._-CR.validate();
            this._-I6.updateChildrenVisible();
            this._-I6.transitions.clearSnapshot();
            this._-I6.transitions.takeSnapshot();
            this.head = 0;
            this._-EI = true;
            this._-3D = 0;
            this._docView._-MD();
            this._editor.timelineView.fairygui.editor.api:ITimelineView::refresh(null);
            this._editor.viewManager.showView("fairygui.TimelineView");
            return;
        }// end function

        public function exitTimelineMode() : void
        {
            if (this._-CR == null)
            {
                return;
            }
            this.closeGroup(int.MAX_VALUE);
            this._-CR.onExit();
            this._-CR = null;
            this._-I6.transitions.readSnapshot();
            this._-IV.exitTimelineMode();
            this._-3D = 0;
            this._docView._-MD();
            this._editor.timelineView.fairygui.editor.api:ITimelineView::refresh(null);
            this._editor.viewManager.hideView("fairygui.TimelineView");
            return;
        }// end function

        public function get timelineMode() : Boolean
        {
            return this._-CR != null;
        }// end function

        public function get editingTransition() : FTransition
        {
            return this._-CR;
        }// end function

        public function get head() : int
        {
            return this._-It;
        }// end function

        public function set head(param1:int) : void
        {
            if (this._-It != param1)
            {
                this._-It = param1;
                this._-EI = true;
            }
            return;
        }// end function

        public function refreshTransition() : void
        {
            this._-EI = true;
            return;
        }// end function

        public function refreshInspectors(param1:int = 0) : void
        {
            if (param1 == 0 || this._-3D == -1)
            {
                this._-3D = param1;
            }
            else if (this._-3D != 0)
            {
                this._-3D = this._-3D | param1;
            }
            return;
        }// end function

        public function _-MJ(param1:FObject) : int
        {
            var _loc_3:* = null;
            var _loc_2:* = 0;
            if (param1.relations.widthLocked)
            {
                _loc_2 = _loc_2 | 4;
            }
            if (param1.relations.heightLocked)
            {
                _loc_2 = _loc_2 | 8;
            }
            if (this._-CR)
            {
                _loc_3 = this._-CR.findItem(this._-It, param1._id, "XY");
                if (!_loc_3)
                {
                    _loc_2 = _loc_2 | 3;
                }
                else
                {
                    if (!_loc_3.value.b1)
                    {
                        _loc_2 = _loc_2 | 1;
                    }
                    if (!_loc_3.value.b2)
                    {
                        _loc_2 = _loc_2 | 2;
                    }
                }
                _loc_3 = this._-CR.findItem(this._-It, param1._id, "Size");
                if (!_loc_3)
                {
                    _loc_2 = _loc_2 | 12;
                }
                else
                {
                    if (!_loc_3.value.b1)
                    {
                        _loc_2 = _loc_2 | 4;
                    }
                    if (!_loc_3.value.b2)
                    {
                        _loc_2 = _loc_2 | 8;
                    }
                }
                return _loc_2;
            }
            return _loc_2;
        }// end function

        public function redrawBackground() : void
        {
            if (this._panel.parent != null)
            {
                this.drawBackground();
            }
            else
            {
                this._-HZ = true;
            }
            return;
        }// end function

        public function _-G4(param1:Boolean = false) : Boolean
        {
            var _loc_2:* = this._docView.viewScale;
            var _loc_3:* = this._container.scaleX;
            if (_loc_2 == _loc_3)
            {
                return false;
            }
            this.setVar("docViewScale", _loc_2);
            this._container.scaleX = _loc_2;
            this._container.scaleY = _loc_2;
            this._-Cn.scaleX = _loc_2;
            this._-Cn.scaleY = _loc_2;
            this._-99();
            this._-DM(true);
            this._-2j();
            if (!param1)
            {
                GTimers.inst.step();
            }
            return true;
        }// end function

        private function _-99() : void
        {
            var _loc_1:* = this._panel.parent.scrollPane;
            if (_loc_1.contentWidth < _loc_1.viewWidth)
            {
                this._-1y = 0.5;
            }
            else
            {
                this._-1y = _loc_1.percX;
            }
            if (_loc_1.contentHeight < _loc_1.viewHeight)
            {
                this._-4H = 0.5;
            }
            else
            {
                this._-4H = _loc_1.percY;
            }
            return;
        }// end function

        private function _-2j() : void
        {
            var _loc_1:* = this._panel.parent.scrollPane;
            _loc_1.percX = this._-1y;
            _loc_1.percY = this._-4H;
            return;
        }// end function

        private function _-EG() : void
        {
            this._-DM(true);
            return;
        }// end function

        private function _-OO() : void
        {
            this._-DM(false);
            return;
        }// end function

        private function _-t(event:ItemEvent) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_2:* = event.itemObject.name;
            if (this._-m.length == 0 || _loc_2 == "Sound")
            {
                _loc_3 = this.createKeyFrame(this._-I6, _loc_2);
            }
            else
            {
                for each (_loc_4 in this._-m)
                {
                    
                    _loc_3 = this.createKeyFrame(_loc_4, _loc_2);
                }
            }
            return;
        }// end function

        public function setTransitionProperty(param1:FTransition, param2:String, param3) : void
        {
            var _loc_4:* = undefined;
            var _loc_5:* = undefined;
            if (!this._-IV.processing)
            {
                _loc_4 = param1[param2];
                param1[param2] = param3;
                _loc_5 = param1[param2];
                if (_loc_5 == _loc_4)
                {
                    return;
                }
                _-Am.setProperty(this, param1, param2, _loc_4);
            }
            else
            {
                param1[param2] = param3;
            }
            if (param2 == "name")
            {
                this._-Mw.refresh();
            }
            if (this._-CR == param1)
            {
                this._-EI = true;
                this._-3D = 0;
            }
            return;
        }// end function

        public function setKeyFrameProperty(param1:FTransitionItem, param2:String, param3) : void
        {
            var _loc_4:* = undefined;
            var _loc_5:* = undefined;
            if (!this._-CR)
            {
                throw new Error("must call in timeline mode.");
            }
            if (this._-IV.processing)
            {
                param1[param2] = param3;
            }
            else
            {
                _loc_4 = param1[param2];
                param1[param2] = param3;
                _loc_5 = param1[param2];
                if (_loc_5 == _loc_4)
                {
                    return;
                }
                _-Am.setItemProperty(this, param1, param2, _loc_4);
            }
            if (param2 == "targetId")
            {
                this._editor.timelineView.fairygui.editor.api:ITimelineView::refresh();
            }
            else if (param2 == "tween" || param2 == "frame" || param2 == "label")
            {
                this._editor.timelineView.fairygui.editor.api:ITimelineView::refresh(param1);
            }
            this._-EI = true;
            this._-3D = 0;
            return;
        }// end function

        public function setKeyFrameValue(param1:FTransitionItem, param2:Object) : void
        {
            var _loc_4:* = null;
            if (!this._-CR)
            {
                throw new Error("must call in timeline mode.");
            }
            if (param2 is FTransitionValue)
            {
                if (param1.value.equals(FTransitionValue(param2)))
                {
                    return;
                }
            }
            else
            {
                _-J9.copyFrom(param1.value);
                for (_loc_4 in param2)
                {
                    
                    _-J9[_loc_4] = _loc_6[_loc_4];
                }
                if (param1.value.equals(_-J9))
                {
                    return;
                }
                param2 = new FTransitionValue();
                _loc_6.copyFrom(_-J9);
            }
            if (param1.type == "XY")
            {
                _loc_6.f3 = _loc_6.f1 / this._-I6.width;
                _loc_6.f4 = _loc_6.f2 / this._-I6.height;
            }
            var _loc_3:* = param1.value;
            param1.value = FTransitionValue(param2);
            if (param1.target)
            {
                param1.target.docElement.gizmo.refresh();
            }
            _-Am._-NM(this, param1, _loc_3);
            this._-EI = true;
            return;
        }// end function

        public function setKeyFramePathPos(param1:FTransitionItem, param2:int, param3:Number, param4:Number) : void
        {
            var _loc_6:* = null;
            var _loc_5:* = param1.pathPoints[param2];
            if (param2 != 0)
            {
                _loc_6 = param1.pathPoints[(param2 - 1)];
            }
            if (param2 == 0)
            {
                this.setKeyFrameValue(param1, {f1:param1.value.f1 + param3, f2:param1.value.f2 + param4});
            }
            else if (param2 == (param1.pathPoints.length - 1))
            {
                _-Am._-CY(this, param1, param2, _loc_5.clone());
                _-Am._-CY(this, param1, (param2 - 1), _loc_6.clone());
                param1.updatePathPoint(param2, param3, param4);
                this.setKeyFrameValue(param1.nextItem, {f1:param1.value.f1 + param3, f2:param1.value.f2 + param4});
            }
            else
            {
                _-Am._-CY(this, param1, param2, _loc_5.clone());
                _-Am._-CY(this, param1, (param2 - 1), _loc_6.clone());
                param1.updatePathPoint(param2, param3, param4);
                if (param1.target)
                {
                    param1.target.docElement.gizmo.refresh();
                }
                this._-EI = true;
            }
            return;
        }// end function

        public function setKeyFrameControlPointPos(param1:FTransitionItem, param2:int, param3:int, param4:Number, param5:Number) : void
        {
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_6:* = param1.pathPoints[param2];
            _-Am._-CY(this, param1, param2, _loc_6.clone());
            if (param3 == 0)
            {
                if (param2 != 0)
                {
                    _-Am._-CY(this, param1, (param2 - 1), param1.pathPoints[(param2 - 1)].clone());
                }
            }
            else if (param3 == 1)
            {
                if (param2 < (param1.pathPoints.length - 1))
                {
                    _-Am._-CY(this, param1, (param2 + 1), param1.pathPoints[(param2 + 1)].clone());
                }
            }
            param1.updateControlPoint(param2, param3, param4, param5);
            if (param1.target)
            {
                param1.target.docElement.gizmo.refresh();
            }
            this._-EI = true;
            return;
        }// end function

        public function setKeyFrameControlPointSmooth(param1:FTransitionItem, param2:int, param3:Boolean) : void
        {
            var _loc_4:* = param1.pathPoints[param2];
            _-Am._-CY(this, param1, param2, _loc_4.clone());
            if (param2 != 0)
            {
                _-Am._-CY(this, param1, (param2 - 1), param1.pathPoints[(param2 - 1)].clone());
            }
            _loc_4.smooth = param3;
            param1.updateControlPoint(param2, 0, _loc_4.control1_x, _loc_4.control1_y);
            if (param1.target)
            {
                param1.target.docElement.gizmo.refresh();
            }
            this._-EI = true;
            return;
        }// end function

        public function setKeyFrame(param1:String, param2:String, param3:int) : void
        {
            if (!this._-CR)
            {
                throw new Error("must call in timeline mode.");
            }
            var _loc_4:* = this._-CR.createItem(param1, param2, param3);
            _-Am.addItem(this, _loc_4);
            this._-EI = true;
            this._-3D = 0;
            this._editor.timelineView.fairygui.editor.api:ITimelineView::refresh(_loc_4);
            return;
        }// end function

        public function setKeyFrames(param1:String, param2:String, param3:Object) : void
        {
            if (!this._-CR)
            {
                throw new Error("must call in timeline mode.");
            }
            var _loc_4:* = this._-CR.write(false);
            this._-CR.pasteItems(XData(param3), param1, param2);
            _-Am.update(this, _loc_4);
            this._-EI = true;
            this._-3D = 0;
            this._editor.timelineView.fairygui.editor.api:ITimelineView::refresh();
            return;
        }// end function

        public function createKeyFrame(param1:FObject, param2:String) : FTransitionItem
        {
            var _loc_3:* = this._-CR.findItem(this._-It, param1._id, param2);
            if (!_loc_3)
            {
                _loc_3 = this._-CR.createItem(param1._id, param2, this._-It);
                _-Am.addItem(this, _loc_3);
                if (param2 == "Transition" && !param1._hasSnapshot)
                {
                    this._-6p = true;
                }
                this._editor.timelineView.selectKeyFrame(_loc_3);
            }
            this._-EI = true;
            this._-3D = 0;
            this._editor.timelineView.refresh(_loc_3);
            return _loc_3;
        }// end function

        public function addKeyFrame(param1:FTransitionItem) : void
        {
            this._-CR.addItem(param1);
            this._-EI = true;
            this._-3D = 0;
            this._editor.timelineView.refresh(param1);
            return;
        }// end function

        public function _-HO(param1:Array) : void
        {
            this._-CR.addItems(param1);
            this._-EI = true;
            this._-3D = 0;
            this._editor.timelineView.refresh();
            return;
        }// end function

        public function removeKeyFrame(param1:FTransitionItem) : void
        {
            if (!this._-CR)
            {
                return;
            }
            this._-CR.deleteItem(param1);
            _-Am.removeItem(this, param1);
            this._-EI = true;
            this._-3D = 0;
            this._editor.timelineView.refresh(param1);
            return;
        }// end function

        public function removeKeyFrames(param1:String, param2:String) : void
        {
            if (!this._-CR)
            {
                return;
            }
            var _loc_3:* = this._-CR.deleteItems(param1, param2);
            if (_loc_3.length == 0)
            {
                return;
            }
            _-Am._-NS(this, _loc_3);
            this._-EI = true;
            this._-3D = 0;
            this._editor.timelineView.refresh();
            return;
        }// end function

        public function updateTransition(param1:Object) : void
        {
            var _loc_2:* = null;
            if (!this._-CR)
            {
                return;
            }
            if (!this._-IV.processing)
            {
                _loc_2 = this._-CR.write(false);
                _-Am.update(this, _loc_2);
            }
            this._-CR.read(XData(param1));
            this._-EI = true;
            this._-3D = 0;
            this._-Mw.refresh();
            return;
        }// end function

        public function addTransition(param1:String = null) : FTransition
        {
            var _loc_2:* = this._-I6.transitions.write();
            var _loc_3:* = this._-I6.transitions.addItem(param1);
            _-F._-Pc(this, _loc_2);
            this._-Mw.refresh();
            return _loc_3;
        }// end function

        public function removeTransition(param1:String) : void
        {
            var _loc_2:* = this._-I6.transitions.getItem(param1);
            if (!_loc_2)
            {
                return;
            }
            this.exitTimelineMode();
            var _loc_3:* = this._-I6.transitions.write();
            this._-I6.transitions.removeItem(_loc_2);
            _-F._-Pc(this, _loc_3);
            this._-Mw.refresh();
            return;
        }// end function

        public function duplicateTransition(param1:String, param2:String = null) : FTransition
        {
            var _loc_3:* = this._-I6.transitions.getItem(param1);
            if (!_loc_3)
            {
                throw new Error("transition not exists!");
            }
            this.exitTimelineMode();
            var _loc_4:* = this._-I6.transitions.write();
            var _loc_5:* = this._-I6.transitions.addItem(param2);
            var _loc_6:* = _loc_3.write(false);
            _loc_6.setAttribute("name", _loc_5.name);
            _loc_5.read(_loc_6);
            _-F._-Pc(this, _loc_4);
            this._-Mw.refresh();
            return _loc_5;
        }// end function

        public function updateTransitions(param1:XData) : void
        {
            var _loc_2:* = null;
            if (!this._-IV.processing)
            {
                _loc_2 = this._-I6.transitions.write();
                _-F._-Pc(this, _loc_2);
            }
            this._-I6.transitions.read(param1);
            this._-Mw.refresh();
            return;
        }// end function

        public function addController(param1:XData) : void
        {
            var _loc_2:* = new FController();
            _loc_2.parent = this._-I6;
            _loc_2.read(param1);
            this._-I6.addController(_loc_2, false);
            this._-I6.applyController(_loc_2);
            _-BC.add(this, _loc_2.name);
            this._-3D = 0;
            this._docView._-6B.refresh();
            return;
        }// end function

        public function updateController(param1:String, param2:XData) : void
        {
            var _loc_5:* = null;
            var _loc_3:* = this._-I6.getController(param1);
            if (!_loc_3)
            {
                throw new Error("controller not exists: " + param1);
            }
            if (!this._-IV.processing)
            {
                _loc_5 = _loc_3.write();
                if (_loc_5.equals(param2))
                {
                    return;
                }
            }
            _-BC.update(this, param1, _loc_5);
            var _loc_4:* = _loc_3.selectedIndex;
            _loc_3.read(param2);
            if (_loc_4 >= 0 && _loc_4 < _loc_3.pageCount && _loc_4 != _loc_3.selectedIndex)
            {
                _loc_3.selectedIndex = _loc_4;
            }
            else
            {
                this._-I6.applyController(_loc_3);
            }
            this._-3D = 0;
            this._docView._-6B._-Jf(_loc_3);
            return;
        }// end function

        public function removeController(param1:String) : void
        {
            var _loc_2:* = this._-I6.getController(param1);
            if (!_loc_2)
            {
                throw new Error("controller not exists: " + param1);
            }
            this._-I6.removeController(_loc_2);
            _-BC.remove(this, param1, _loc_2);
            this._-3D = 0;
            this._docView._-6B.refresh();
            return;
        }// end function

        public function switchPage(param1:String, param2:int) : int
        {
            var _loc_3:* = this._-I6.getController(param1);
            if (!_loc_3)
            {
                throw new Error("controller not exists: " + param1);
            }
            var _loc_4:* = _loc_3.selectedIndex;
            _-BC.switchPage(this, param1, _loc_4);
            _loc_3.selectedIndex = param2;
            this._-MX(_loc_3);
            this._-3D = 0;
            return _loc_4;
        }// end function

        private function _-Jd(event:ItemEvent) : void
        {
            var _loc_2:* = FGraph(this._-m[0]);
            _-LZ.setProperty(this, _loc_2, "polygonData", _loc_2.polygonData.concat());
            var _loc_3:* = _loc_2.globalToLocal(event.stageX, event.stageY);
            if (_loc_2.anchor)
            {
                _loc_3.x = _loc_3.x + _loc_2.pivotX * _loc_2.width;
                _loc_3.y = _loc_3.y + _loc_2.pivotY * _loc_2.height;
            }
            _loc_2.addVertex(_loc_3.x, _loc_3.y, true);
            return;
        }// end function

        private function _-7a(event:ItemEvent) : void
        {
            var _loc_2:* = FGraph(this._-m[0]);
            if (_loc_2.polygonPoints.length < 4)
            {
                return;
            }
            var _loc_3:* = _loc_2.docElement.gizmo.activeHandleIndex;
            _-LZ.setProperty(this, _loc_2, "polygonData", _loc_2.polygonData.concat());
            _loc_2.removeVertex(_loc_3);
            return;
        }// end function

        private function _-HC(event:ItemEvent) : void
        {
            var _loc_2:* = this._-m[0];
            var _loc_3:* = _-I9(_loc_2.docElement.gizmo).keyFrame;
            _-Am._-Kr(this, _loc_3, _loc_3.pathPoints.concat());
            var _loc_4:* = this._-I6.globalToLocal(event.stageX, event.stageY);
            _loc_4.x = _loc_4.x - _loc_3.pathOffsetX;
            _loc_4.y = _loc_4.y - _loc_3.pathOffsetY;
            _loc_3.addPathPoint(_loc_4.x, _loc_4.y, true);
            _loc_2.docElement.gizmo.refresh();
            this._-EI = true;
            return;
        }// end function

        private function _-3W(event:ItemEvent) : void
        {
            var _loc_2:* = this._-m[0];
            var _loc_3:* = _loc_2.docElement.gizmo.activeHandleIndex;
            var _loc_4:* = _-I9(_loc_2.docElement.gizmo).keyFrame;
            _-Am._-Kr(this, _loc_4, _loc_4.pathPoints.concat());
            _loc_4.removePathPoint(_loc_3);
            _loc_2.docElement.gizmo.refresh();
            this._-EI = true;
            return;
        }// end function

        private function _-Ku(event:ItemEvent) : void
        {
            var _loc_2:* = this._-m[0];
            var _loc_3:* = _loc_2.docElement.gizmo.activeHandleIndex;
            var _loc_4:* = _-I9(_loc_2.docElement.gizmo).keyFrame;
            this.setKeyFrameControlPointSmooth(_loc_4, _loc_3, this._-5T.isItemChecked("smooth"));
            return;
        }// end function

        private function _-H4(event:ItemEvent) : void
        {
            _-I9(this._-5w.docElement.gizmo).editComplete();
            this._-5w = null;
            this.refreshInspectors(_-8B.COMMON);
            return;
        }// end function

    }
}
