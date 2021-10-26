package _-An
{
    import *.*;
    import _-Ds.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.ui.*;
    import flash.utils.*;

    public class DocumentView extends GComponent implements IDocumentView
    {
        var _editor:IEditor;
        var _-6B:_-4i;
        private var _panel:GComponent;
        private var _-PB:GGraph;
        private var _-9a:GComponent;
        private var _-7I:GList;
        private var _-74:GComponent;
        private var _-BV:GComponent;
        private var _-GS:Controller;
        private var _-La:Number;
        private var _-8a:GComboBox;
        private var _tabView:GList;
        private var _-O8:PopupMenu;
        private var _-6i:_-JK;
        private var _-B9:Vector.<_-On>;
        private var _activeDoc:_-On;
        private var _-h:Boolean;
        private var _-40:Boolean;

        public function DocumentView(param1:IEditor)
        {
            var btn:GButton;
            var editor:* = param1;
            this._editor = editor;
            this._-B9 = new Vector.<_-On>;
            this._panel = UIPackage.createObject("Builder", "DocumentView").asCom;
            this.setSize(this._panel.width, this._panel.height);
            this._panel.addRelation(this, RelationType.Size);
            addChild(this._panel);
            this._tabView = this._panel.getChild("tabs").asList;
            this._tabView.addEventListener(ItemEvent.CLICK, this._-Ow);
            this._tabView.addEventListener(DropEvent.DROP, this._-MG);
            this._panel.getChild("tabs").addEventListener(MouseEvent.RIGHT_CLICK, this._-6Y);
            this._panel.getChild("tabBar").addEventListener(MouseEvent.RIGHT_CLICK, this._-6Y);
            this._-9a = this._panel.getChild("docContainer").asCom;
            this._-6B = new _-4i(this);
            this._-6i = new _-JK(this);
            this._-74 = this._panel.getChild("groupPathBar").asCom;
            this._-74.visible = false;
            this._-7I = this._-74.getChild("list").asList;
            this._-7I.addEventListener(ItemEvent.CLICK, this._-Oe);
            this._-BV = this._panel.getChild("editingTransBar").asCom;
            this._-BV.visible = false;
            this._-BV.addClickListener(this._-AM);
            this._-GS = this._panel.getController("editType");
            this._-GS.addEventListener(StateChangeEvent.CHANGED, this._-E7);
            this._panel.getChild("n26").addClickListener(function (event:Event) : void
            {
                dragAndCreate("text");
                return;
            }// end function
            );
            this._panel.getChild("n49").addClickListener(function (event:Event) : void
            {
                dragAndCreate("richtext");
                return;
            }// end function
            );
            this._panel.getChild("n27").addClickListener(function (event:Event) : void
            {
                dragAndCreate("graph");
                return;
            }// end function
            );
            this._panel.getChild("n28").addClickListener(function (event:Event) : void
            {
                dragAndCreate("list");
                return;
            }// end function
            );
            this._panel.getChild("n29").addClickListener(function (event:Event) : void
            {
                dragAndCreate("loader");
                return;
            }// end function
            );
            this._panel.getChild("n31").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _activeDoc.createGroup();
                }
                return;
            }// end function
            );
            this._panel.getChild("n32").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _activeDoc.destroyGroup();
                }
                return;
            }// end function
            );
            this._panel.getChild("n33").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _-2W._-72(_activeDoc);
                }
                return;
            }// end function
            );
            this._panel.getChild("n34").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _-2W._-H9(_activeDoc);
                }
                return;
            }// end function
            );
            this._panel.getChild("n35").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _-2W._-JJ(_activeDoc);
                }
                return;
            }// end function
            );
            this._panel.getChild("n36").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _-2W._-7z(_activeDoc);
                }
                return;
            }// end function
            );
            this._panel.getChild("n37").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _-2W._-36(_activeDoc);
                }
                return;
            }// end function
            );
            this._panel.getChild("n38").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _-2W._-OX(_activeDoc);
                }
                return;
            }// end function
            );
            this._panel.getChild("n39").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _-2W._-Jr(_activeDoc);
                }
                return;
            }// end function
            );
            this._panel.getChild("n40").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _-2W._-9d(_activeDoc);
                }
                return;
            }// end function
            );
            this._panel.getChild("n41").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _-6i.open(0, GObject(event.currentTarget));
                }
                return;
            }// end function
            );
            this._panel.getChild("n96").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _-6i.open(1, GObject(event.currentTarget));
                }
                return;
            }// end function
            );
            this._panel.getChild("n97").addClickListener(function (event:Event) : void
            {
                if (_activeDoc)
                {
                    _-6i.open(2, GObject(event.currentTarget));
                }
                return;
            }// end function
            );
            this._-O8 = new PopupMenu();
            this._-O8.contentPane.width = 220;
            btn = this._-O8.addItem(Consts.strings.text13, function () : void
            {
                queryToCloseDocument(_activeDoc);
                return;
            }// end function
            );
            btn.name = "close";
            btn.getChild("shortcut").text = Consts.isMacOS ? ("⌘W") : ("Ctrl+W");
            this._-O8.addItem(Consts.strings.text14, function () : void
            {
                queryToCloseOtherDocuments();
                return;
            }// end function
            ).name = "closeOthers";
            this._-O8.addItem(Consts.strings.text428, function () : void
            {
                queryToCloseDocumentsToTheRight();
                return;
            }// end function
            ).name = "closeRight";
            this._-O8.addItem(Consts.strings.text15, function () : void
            {
                queryToCloseAllDocuments();
                return;
            }// end function
            ).name = "closeAll";
            this._-8a = this._editor.mainPanel.getChild("viewScale").asComboBox;
            this._-8a.addEventListener(StateChangeEvent.CHANGED, this._-Kj);
            this._-La = 1;
            this._-PB = this._panel.getChild("docBg").asGraph;
            this._-9a.addSizeChangeCallback(this._-Ej);
            this._-9a.displayObject.addEventListener(MouseEvent.MOUSE_WHEEL, this.__mouseWheel, false, 1);
            addEventListener(_-4U._-76, this.handleKeyEvent);
            this._editor.on(EditorEvent.ProjectOpened, this.onLoad);
            this._editor.on(EditorEvent.ProjectClosed, this._-24);
            this._editor.on(EditorEvent.OnUpdate, this.onUpdate);
            this._editor.on(EditorEvent.PackageItemChanged, this._-E2);
            this._editor.on(EditorEvent.PackageItemDeleted, this._-CC);
            this._editor.on(EditorEvent.DocumentActivated, this._-A2);
            this._editor.on(EditorEvent.DocumentDeactivated, this._-1f);
            this._editor.on(EditorEvent.BackgroundChanged, this._-Hx);
            this._editor.on(EditorEvent.Validate, function () : void
            {
                if (_activeDoc)
                {
                    _activeDoc._-DU();
                }
                return;
            }// end function
            );
            return;
        }// end function

        private function onLoad() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            this._-40 = true;
            var _loc_1:* = this._editor.workspaceSettings.get("doc.openedDocs") as Array;
            if (_loc_1)
            {
                _loc_2 = _loc_1.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_5 = this._editor.project.getItemByURL(_loc_1[_loc_3]);
                    if (_loc_5)
                    {
                        _loc_4 = this.openDocument(_loc_5, false);
                    }
                    _loc_3++;
                }
            }
            else if (this._editor.project.allPackages.length == 1)
            {
                _loc_6 = this._editor.project.allPackages[0];
                if (_loc_6.items.length == 1 && _loc_6.items[0].type == FPackageItemType.COMPONENT)
                {
                    _loc_5 = _loc_6.items[0];
                    _loc_4 = this.openDocument(_loc_5, false);
                }
            }
            this._-40 = false;
            _loc_4 = this.findDocument(this._editor.workspaceSettings.get("doc.activeDoc"));
            if (_loc_4)
            {
                this.activeDocument = _loc_4;
            }
            else if (this._tabView.numChildren)
            {
                this._-M9(this._tabView.getChildAt(0));
            }
            if (this._activeDoc)
            {
                this._editor.libView.highlight(this._activeDoc.packageItem);
            }
            this._-PB.drawRect(0, 0, 0, this._editor.workspaceSettings.get("backgroundColor"), 1);
            GTimers.inst.add(500, 0, this._-AJ);
            return;
        }// end function

        private function _-24() : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_1:* = [];
            var _loc_2:* = this._tabView.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._tabView.getChildAt(_loc_3);
                _loc_5 = _loc_4.data.doc as IDocument;
                _loc_1.push(_loc_5.uid);
                _loc_3++;
            }
            this._editor.workspaceSettings.set("doc.openedDocs", _loc_1);
            if (this._activeDoc)
            {
                this._editor.workspaceSettings.set("doc.activeDoc", this._activeDoc.uid);
                this._activeDoc.release();
            }
            else
            {
                this._editor.workspaceSettings.set("doc.activeDoc", undefined);
            }
            GTimers.inst.remove(this._-AJ);
            return;
        }// end function

        private function onUpdate() : void
        {
            if (this._activeDoc)
            {
                this._activeDoc.onUpdate();
            }
            return;
        }// end function

        private function _-AJ() : void
        {
            if (this._activeDoc && this._editor.active)
            {
                this._activeDoc._-AJ();
            }
            return;
        }// end function

        private function _-E2(param1:FPackageItem) : void
        {
            var _loc_2:* = param1.getVar("doc");
            if (_loc_2)
            {
                this._-LV(_loc_2);
            }
            return;
        }// end function

        private function _-CC(param1:FPackageItem) : void
        {
            var _loc_2:* = this.findDocument(param1.getURL());
            if (_loc_2)
            {
                this.closeDocument(_loc_2);
            }
            return;
        }// end function

        private function dragAndCreate(param1:String) : void
        {
            if (this._activeDoc)
            {
                this._editor.dragManager.startDrag(this._activeDoc, [param1]);
            }
            return;
        }// end function

        public function set activeDocument(param1:IDocument) : void
        {
            var _loc_2:* = this._tabView.getChild(param1.uid);
            this._-M9(_loc_2);
            return;
        }// end function

        public function get activeDocument() : IDocument
        {
            return this._activeDoc;
        }// end function

        public function get editType() : int
        {
            return this._-GS.selectedIndex;
        }// end function

        public function set editType(param1:int) : void
        {
            this._-GS.selectedIndex = param1;
            return;
        }// end function

        public function findDocument(param1:String) : IDocument
        {
            var _loc_4:* = null;
            var _loc_2:* = this._tabView.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._tabView.getChildAt(_loc_3);
                if (IDocument(_loc_4.data.doc).uid == param1)
                {
                    return IDocument(_loc_4.data.doc);
                }
                _loc_3++;
            }
            return null;
        }// end function

        public function closeDocuments(param1:IUIPackage) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = this._tabView.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._tabView.getChildAt(_loc_3);
                if (IDocument(_loc_4.data.doc).packageItem.owner == param1)
                {
                    this.closeDocument(IDocument(_loc_4.data.doc));
                    break;
                }
                _loc_3++;
            }
            return;
        }// end function

        public function openDocument(param1:FPackageItem, param2:Boolean = true) : IDocument
        {
            var _loc_5:* = null;
            var _loc_3:* = _-On(this.findDocument(param1.getURL()));
            if (_loc_3 != null)
            {
                _loc_5 = this._tabView.getChild(_loc_3.uid);
                this._-M9(_loc_5);
                return _loc_3;
            }
            if (this._-B9.length)
            {
                _loc_3 = this._-B9.pop();
            }
            else
            {
                _loc_3 = new _-On();
            }
            _loc_3.open(param1);
            var _loc_4:* = this._tabView.selectedIndex;
            if (this._tabView.selectedIndex == -1 || _loc_4 == (this._tabView.numChildren - 1))
            {
                _loc_5 = this._tabView.addItemFromPool();
            }
            else
            {
                _loc_5 = this._tabView.getFromPool();
                this._tabView.addChildAt(_loc_5, (_loc_4 + 1));
            }
            _loc_5.name = _loc_3.uid;
            _loc_5.text = param1.name;
            _loc_5.icon = param1.getIcon();
            _loc_5.data = {doc:_loc_3, activeTime:0};
            _loc_5.asCom.getController("modified").selectedIndex = 0;
            _loc_5.asCom.getChild("closeButton").addClickListener(this._-PA);
            _loc_5.draggable = true;
            _loc_5.addEventListener(DragEvent.DRAG_START, this._-FD);
            _loc_5.addEventListener(MouseEvent.MIDDLE_CLICK, this._-2l);
            if (param2)
            {
                this._-M9(_loc_5);
                this.requestFocus();
            }
            return _loc_3;
        }// end function

        public function saveDocument(param1:IDocument = null) : void
        {
            if (param1 == null)
            {
                param1 = this._activeDoc;
            }
            if (param1 != null)
            {
                param1.save();
            }
            return;
        }// end function

        public function saveAllDocuments() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this._tabView.numChildren;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = IDocument(this._tabView.getChildAt(_loc_2).data.doc);
                _loc_3.save();
                _loc_2++;
            }
            return;
        }// end function

        public function closeDocument(param1:IDocument = null) : void
        {
            if (param1 == null)
            {
                param1 = this._activeDoc;
            }
            if (param1 != null)
            {
                this.closeTab(this._tabView.getChild(_-On(param1).uid));
            }
            return;
        }// end function

        public function closeAllDocuments() : void
        {
            var _loc_3:* = null;
            this._-h = true;
            var _loc_1:* = this._tabView.numChildren;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = IDocument(this._tabView.getChildAt(_loc_2).data.doc);
                _loc_3.release();
                this._-B9.push(_loc_3);
                _loc_2++;
            }
            this._tabView.removeChildrenToPool();
            this._activeDoc = null;
            this._-9a.removeChildren();
            this._-h = false;
            this._editor.inspectorView.showDefault();
            GComponent(this._editor.libView).requestFocus();
            return;
        }// end function

        public function queryToCloseDocument(param1:IDocument = null) : void
        {
            var uid:String;
            var doc:* = param1;
            if (doc == null)
            {
                doc = this._activeDoc;
            }
            if (doc == null)
            {
                return;
            }
            uid = _-On(doc).uid;
            if (!doc.isModified)
            {
                this.closeTab(this._tabView.getChild(uid));
                return;
            }
            var ti:* = this._tabView.getChild(uid);
            SaveConfirmDialog(this._editor.getDialog(SaveConfirmDialog)).open([ti.text], function (param1:String) : void
            {
                if (param1 == "yes")
                {
                    saveDocument(doc);
                    closeTab(_tabView.getChild(uid));
                }
                else if (param1 == "no")
                {
                    closeTab(_tabView.getChild(uid));
                }
                return;
            }// end function
            );
            return;
        }// end function

        public function queryToCloseOtherDocuments() : void
        {
            var doc:IDocument;
            var cnt:int;
            var ti:GObject;
            var doc2:IDocument;
            doc = this._activeDoc;
            var modifies:Array;
            cnt = this._tabView.numChildren;
            var i:int;
            while (i < cnt)
            {
                
                ti = this._tabView.getChildAt(i);
                doc2 = IDocument(ti.data.doc);
                if (doc2.isModified && doc2 != doc)
                {
                    modifies.push(ti.text);
                }
                i = (i + 1);
            }
            if (modifies.length == 0)
            {
                this.closeDocumentsExcept(doc);
                return;
            }
            SaveConfirmDialog(this._editor.getDialog(SaveConfirmDialog)).open(modifies, function (param1:String) : void
            {
                var _loc_2:* = 0;
                var _loc_3:* = null;
                var _loc_4:* = null;
                if (param1 == "yes")
                {
                    _loc_2 = 0;
                    while (_loc_2 < cnt)
                    {
                        
                        _loc_3 = _tabView.getChildAt(_loc_2);
                        _loc_4 = IDocument(_loc_3.data.doc);
                        if (_loc_4 != doc && _loc_4.isModified)
                        {
                            saveDocument(_loc_4);
                        }
                        _loc_2++;
                    }
                    closeDocumentsExcept(doc);
                }
                else if (param1 == "no")
                {
                    closeDocumentsExcept(doc);
                }
                return;
            }// end function
            );
            return;
        }// end function

        private function queryToCloseDocumentsToTheRight() : void
        {
            var cnt:int;
            var start:int;
            var ti:GObject;
            var doc:IDocument;
            var modifies:Array;
            cnt = this._tabView.numChildren;
            start = (this._tabView.selectedIndex + 1);
            var i:* = start;
            while (i < cnt)
            {
                
                ti = this._tabView.getChildAt(i);
                doc = IDocument(ti.data.doc);
                if (doc.isModified)
                {
                    modifies.push(ti.text);
                }
                i = (i + 1);
            }
            if (modifies.length == 0)
            {
                this.closeDocumentsToTheRight();
                return;
            }
            SaveConfirmDialog(this._editor.getDialog(SaveConfirmDialog)).open(modifies, function (param1:String) : void
            {
                var _loc_2:* = 0;
                var _loc_3:* = null;
                var _loc_4:* = null;
                if (param1 == "yes")
                {
                    _loc_2 = start;
                    while (_loc_2 < cnt)
                    {
                        
                        _loc_3 = _tabView.getChildAt(_loc_2);
                        _loc_4 = IDocument(_loc_3.data.doc);
                        if (_loc_4.isModified)
                        {
                            saveDocument(_loc_4);
                        }
                        _loc_2++;
                    }
                    closeDocumentsToTheRight();
                }
                else if (param1 == "no")
                {
                    closeDocumentsToTheRight();
                }
                return;
            }// end function
            );
            return;
        }// end function

        private function closeDocumentsExcept(param1:IDocument) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_2:* = this._tabView.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._tabView.getChildAt(_loc_3);
                _loc_5 = IDocument(_loc_4.data.doc);
                if (_loc_5 != param1)
                {
                    this.closeTab(_loc_4);
                    _loc_2 = _loc_2 - 1;
                    continue;
                }
                _loc_3++;
            }
            return;
        }// end function

        private function closeDocumentsToTheRight() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this._tabView.selectedIndex + 1;
            var _loc_2:* = this._tabView.numChildren;
            while (_loc_1 < _loc_2)
            {
                
                _loc_3 = this._tabView.getChildAt(_loc_1);
                this.closeTab(_loc_3);
                _loc_2 = _loc_2 - 1;
            }
            return;
        }// end function

        public function queryToCloseAllDocuments() : void
        {
            this.queryToSaveAllDocuments(function (param1:String) : void
            {
                if (param1 != "cancel")
                {
                    closeAllDocuments();
                }
                return;
            }// end function
            );
            return;
        }// end function

        public function queryToSaveAllDocuments(param1:Function) : void
        {
            var cnt:int;
            var i:int;
            var ti:GObject;
            var doc:IDocument;
            var callback:* = param1;
            var docs:Array;
            cnt = this._tabView.numChildren;
            i;
            while (i < cnt)
            {
                
                ti = this._tabView.getChildAt(i);
                doc = IDocument(ti.data.doc);
                if (doc.isModified)
                {
                    docs.push(ti.text);
                }
                i = (i + 1);
            }
            if (docs.length == 0)
            {
                if (callback != null)
                {
                    this.callback("yes");
                }
                return;
            }
            SaveConfirmDialog(this._editor.getDialog(SaveConfirmDialog)).open(docs, function (param1:String) : void
            {
                var _loc_2:* = null;
                var _loc_3:* = null;
                if (param1 == "yes")
                {
                    i = 0;
                    while (i < cnt)
                    {
                        
                        _loc_2 = _tabView.getChildAt(i);
                        _loc_3 = IDocument(_loc_2.data.doc);
                        if (_loc_3.isModified)
                        {
                            saveDocument(_loc_3);
                        }
                        var _loc_5:* = i + 1;
                        i = _loc_5;
                    }
                    if (callback != null)
                    {
                        callback(param1);
                    }
                }
                else if (param1 == "no")
                {
                    if (callback != null)
                    {
                        callback(param1);
                    }
                }
                else if (callback != null)
                {
                    callback(param1);
                }
                return;
            }// end function
            );
            return;
        }// end function

        public function _-Ht() : Boolean
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_1:* = this._tabView.numChildren;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._tabView.getChildAt(_loc_2);
                _loc_4 = IDocument(_loc_3.data.doc);
                if (_loc_4.isModified)
                {
                    return true;
                }
                _loc_2++;
            }
            return false;
        }// end function

        private function _-M9(param1:GObject) : void
        {
            if (!param1.asButton.selected)
            {
                this._tabView.clearSelection();
                this._tabView.addSelection(this._tabView.getChildIndex(param1), true);
            }
            var _loc_2:* = this._activeDoc;
            this._activeDoc = null;
            if (_loc_2)
            {
                _loc_2._-BA();
            }
            var _loc_3:* = _-On(param1.data.doc);
            this._activeDoc = _-On(param1.data.doc);
            _loc_2 = _loc_3;
            this._-9a.removeChildren();
            this._-9a.addChild(this._activeDoc.panel);
            if (this._editor.workspaceSettings.get("docScaleOption") == 1)
            {
                this._-La = this._activeDoc.getVar("docViewScale");
                this._-8a.text = (this._-La * 100).toFixed(0) + "%";
            }
            this._activeDoc.activate();
            param1.data.activeTime = getTimer();
            return;
        }// end function

        private function closeTab(param1:GObject) : void
        {
            var _loc_2:* = _-On(param1.data.doc);
            if (_loc_2 == this._activeDoc)
            {
                this._activeDoc = null;
                _loc_2._-BA();
                this._-9a.removeChildren();
            }
            _-On(_loc_2).release();
            this._-B9.push(_loc_2);
            this._tabView.removeChildToPool(param1);
            if (this._activeDoc == null && this._tabView.numChildren > 0)
            {
                this._-12();
            }
            else
            {
                this._editor.inspectorView.showDefault();
                GComponent(this._editor.libView).requestFocus();
            }
            return;
        }// end function

        function _-LV(param1:_-On) : void
        {
            var _loc_2:* = this._tabView.getChild(param1.uid);
            if (!_loc_2)
            {
                return;
            }
            var _loc_3:* = param1.packageItem;
            _loc_2.text = _loc_3.name;
            _loc_2.icon = _loc_3.getIcon();
            _loc_2.asButton.getController("modified").selectedIndex = param1.isModified ? (1) : (0);
            return;
        }// end function

        private function _-12() : void
        {
            var _loc_5:* = null;
            var _loc_1:* = this._tabView.numChildren;
            var _loc_2:* = int.MIN_VALUE;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_1)
            {
                
                _loc_5 = this._tabView.getChildAt(_loc_4);
                if (_loc_5.data.activeTime > _loc_2 && _loc_5.data.doc != this._activeDoc)
                {
                    _loc_2 = _loc_5.data.activeTime;
                    _loc_3 = _loc_5;
                }
                _loc_4++;
            }
            if (_loc_3 != null)
            {
                this._-M9(_loc_3);
            }
            return;
        }// end function

        private function _-Ow(event:ItemEvent) : void
        {
            var _loc_2:* = event.itemObject;
            if (IDocument(_loc_2.data.doc) != this._activeDoc)
            {
                this._-M9(_loc_2);
            }
            return;
        }// end function

        private function _-2l(event:Event) : void
        {
            var _loc_2:* = GObject(event.currentTarget);
            var _loc_3:* = IDocument(_loc_2.data.doc);
            if (_loc_3.isModified)
            {
                this.queryToCloseDocument(_loc_3);
            }
            else
            {
                this.closeTab(_loc_2);
            }
            return;
        }// end function

        private function _-PA(event:Event) : void
        {
            event.stopPropagation();
            var _loc_2:* = GObject(event.currentTarget.parent);
            var _loc_3:* = IDocument(_loc_2.data.doc);
            if (_loc_3.isModified)
            {
                this.queryToCloseDocument(_loc_3);
            }
            else
            {
                this.closeTab(_loc_2);
            }
            return;
        }// end function

        private function _-FD(event:DragEvent) : void
        {
            event.preventDefault();
            var _loc_2:* = GObject(event.currentTarget);
            this._editor.dragManager.startDrag(this, _loc_2, _loc_2);
            return;
        }// end function

        private function _-MG(event:DropEvent) : void
        {
            if (event.source != this)
            {
                return;
            }
            if (this._tabView.numChildren == 0)
            {
                return;
            }
            var _loc_2:* = this._tabView.getItemNear(this._editor.groot.nativeStage.mouseX, this._editor.groot.nativeStage.mouseY);
            if (!_loc_2)
            {
                _loc_2 = this._tabView.getChildAt((this._tabView.numChildren - 1));
            }
            if (_loc_2 == event.source)
            {
                return;
            }
            var _loc_3:* = this._tabView.getChildIndex(_loc_2);
            _loc_2 = GObject(event._-LE);
            if (_loc_2.parent)
            {
                this._tabView.setChildIndex(_loc_2, _loc_3);
            }
            return;
        }// end function

        function _-Dl(param1:FGroup) : void
        {
            var _loc_5:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = param1;
            while (_loc_3 != null)
            {
                
                _loc_2++;
                _loc_3 = _loc_3._group;
            }
            if (_loc_2 == 0)
            {
                this._-74.visible = false;
                return;
            }
            this._-74.visible = true;
            this._-7I.removeChildrenToPool();
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_5 = this._-7I.addItemFromPool().asButton;
                _loc_5.icon = Consts.icons.group;
                _loc_5.name = "" + (_loc_2 - _loc_4);
                _loc_4++;
            }
            this._-7I.resizeToFit();
            return;
        }// end function

        function _-MD() : void
        {
            if (this._activeDoc && this._activeDoc.timelineMode)
            {
                this._-BV.visible = true;
                this._-BV.text = this._activeDoc.editingTransition.name;
            }
            else
            {
                this._-BV.visible = false;
            }
            return;
        }// end function

        public function handleKeyEvent(param1:_-4U) : void
        {
            if (!this._activeDoc)
            {
                return;
            }
            if (!param1.ctrlKey && !param1.commandKey && !param1.shiftKey && param1.charCode == Keyboard.SPACE)
            {
                if (this._-GS.selectedIndex == 0)
                {
                    this._editor.groot.nativeStage.addEventListener(KeyboardEvent.KEY_UP, this._-HF);
                    this._-GS.selectedIndex = 1;
                }
            }
            switch(param1._-T)
            {
                case "0115":
                {
                    if (this._tabView.numChildren > 1)
                    {
                        this._-12();
                    }
                    break;
                }
                case "0124":
                {
                    this._-Ii(true, true);
                    break;
                }
                case "0125":
                {
                    this._-Ii(false, true);
                    break;
                }
                case "0126":
                {
                    this._-3a(1);
                    break;
                }
                case "0308":
                {
                    _-2W._-72(this._activeDoc);
                    break;
                }
                case "0309":
                {
                    _-2W._-H9(this._activeDoc);
                    break;
                }
                case "0310":
                {
                    _-2W._-JJ(this._activeDoc);
                    break;
                }
                case "0311":
                {
                    _-2W._-7z(this._activeDoc);
                    break;
                }
                case "0312":
                {
                    _-2W._-36(this._activeDoc);
                    break;
                }
                case "0313":
                {
                    _-2W._-OX(this._activeDoc);
                    break;
                }
                case "0314":
                {
                    _-2W._-Jr(this._activeDoc);
                    break;
                }
                case "0315":
                {
                    _-2W._-9d(this._activeDoc);
                    break;
                }
                case "0316":
                {
                    this._-6i.open(0, this._panel.getChild("41"));
                    break;
                }
                case "0320":
                {
                    this._-6i.open(1, this._panel.getChild("96"));
                    break;
                }
                case "0321":
                {
                    this._-6i.open(2, this._panel.getChild("97"));
                    break;
                }
                default:
                {
                    this._activeDoc.handleKeyEvent(param1);
                    break;
                }
            }
            return;
        }// end function

        private function _-HF(event:KeyboardEvent) : void
        {
            if (event.charCode == Keyboard.SPACE && this._-GS.selectedIndex == 1)
            {
                this._editor.groot.nativeStage.removeEventListener(KeyboardEvent.KEY_UP, this._-HF);
                this._-GS.selectedIndex = 0;
            }
            return;
        }// end function

        private function _-Oe(event:ItemEvent) : void
        {
            var _loc_2:* = 0;
            if (this._activeDoc)
            {
                _loc_2 = int(event.itemObject.name);
                this._activeDoc.closeGroup(_loc_2);
            }
            return;
        }// end function

        private function _-AM(event:Event) : void
        {
            this._activeDoc.exitTimelineMode();
            return;
        }// end function

        private function _-E7(event:Event) : void
        {
            if (this._-GS.selectedIndex == 1)
            {
                this._editor.cursorManager.setCursorForObject(this._-9a.displayObject, CursorType.HAND, this._-Lt, true);
            }
            else
            {
                this._editor.cursorManager.setCursorForObject(this._-9a.displayObject, null, null, true);
            }
            return;
        }// end function

        private function _-Hx() : void
        {
            var _loc_3:* = null;
            this._-PB.drawRect(0, 0, 0, this._editor.workspaceSettings.get("backgroundColor"), 1);
            var _loc_1:* = this._tabView.numChildren;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._tabView.getChildAt(_loc_2);
                if (_loc_3.data.doc is _-On)
                {
                    _-On(_loc_3.data.doc).redrawBackground();
                }
                _loc_2++;
            }
            return;
        }// end function

        private function _-Ej() : void
        {
            if (this._activeDoc)
            {
                this._activeDoc._-In();
            }
            return;
        }// end function

        private function _-Lt() : Boolean
        {
            if (this._-9a.displayObject.mouseX < this._-9a.viewWidth && this._-9a.displayObject.mouseY < this._-9a.viewHeight)
            {
                return true;
            }
            return false;
        }// end function

        private function _-6Y(event:Event) : void
        {
            this._-O8.setItemGrayed("close", this._tabView.numChildren == 0);
            this._-O8.setItemGrayed("closeOthers", this._tabView.numChildren < 2);
            this._-O8.setItemGrayed("closeAll", this._tabView.numChildren == 0);
            this._-O8.show(this._editor.groot, true);
            return;
        }// end function

        private function __mouseWheel(event:MouseEvent) : void
        {
            var _loc_2:* = NaN;
            if (event.ctrlKey)
            {
                event.stopImmediatePropagation();
                _loc_2 = event.delta;
                if (_loc_2 < 0)
                {
                    this._-Ii(false, false);
                }
                else
                {
                    this._-Ii(true, false);
                }
            }
            return;
        }// end function

        private function _-Kj(event:Event) : void
        {
            if (!this._panel.onStage)
            {
                return;
            }
            this._-La = parseInt(event.currentTarget.text) / 100;
            if (this._activeDoc)
            {
                this._activeDoc._-G4();
            }
            return;
        }// end function

        public function get viewScale() : Number
        {
            return this._-La;
        }// end function

        private function _-3a(param1:Number) : void
        {
            this._-La = param1;
            this._-8a.text = (this._-La * 100).toFixed(0) + "%";
            if (this._activeDoc)
            {
                this._activeDoc._-G4();
            }
            return;
        }// end function

        private function _-Ii(param1:Boolean, param2:Boolean) : void
        {
            if (param1)
            {
                if (param2)
                {
                    this._-La = this._-La * 2;
                }
                else
                {
                    this._-La = this._-La * 1.25;
                }
                if (this._-La > 16)
                {
                    this._-La = 16;
                }
            }
            else
            {
                if (param2)
                {
                    this._-La = this._-La / 2;
                }
                else
                {
                    this._-La = this._-La / 1.25;
                }
                if (this._-La < 0.25)
                {
                    this._-La = 0.25;
                }
            }
            this._-8a.text = (this._-La * 100).toFixed(0) + "%";
            if (this._activeDoc)
            {
                this._activeDoc._-G4();
            }
            return;
        }// end function

        private function _-A2() : void
        {
            this._-6B.refresh();
            this._-Dl(FGroup(this._activeDoc.openedGroup));
            return;
        }// end function

        private function _-1f() : void
        {
            this._-6B.clear();
            this._-74.visible = false;
            this._-BV.visible = false;
            return;
        }// end function

    }
}
