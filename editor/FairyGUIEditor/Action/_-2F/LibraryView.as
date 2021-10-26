package _-2F
{
    import *.*;
    import _-Ds.*;
    import _-Gs.*;
    import _-NY.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.desktop.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.net.*;

    public class LibraryView extends GComponent implements ILibraryView
    {
        private var _editor:IEditor;
        private var _panel:GComponent;
        private var _projectView:_-Dc;
        private var _-Hr:GComboBox;
        private var _-9L:GButton;
        private var _-Ka:GButton;
        private var _-Ng:GGroup;
        private var _-5V:Transition;
        private var _-Kz:PopupMenu;
        private var _-7W:PopupMenu;
        private var _-68:PopupMenu;
        private var _-23:String;
        private var _-Is:Vector.<FPackageItem>;

        public function LibraryView(param1:IEditor)
        {
            var editor:* = param1;
            this._editor = editor;
            this._panel = UIPackage.createObject("Builder", "LibraryView").asCom;
            this.setSize(this._panel.width, this._panel.height);
            this._panel.addRelation(this, RelationType.Size);
            addChild(this._panel);
            this.createMenu();
            this._projectView = new _-Dc(this._editor, this._panel.getChild("treeView").asTree, this._panel.getChild("sep"), this._panel.getChild("listView").asList);
            this._projectView._-O1 = true;
            this._projectView._-Nz = this._-Nz;
            this._-Ng = this._panel.getChild("columns").asGroup;
            this._panel.getChild("btnCollapseAll").addClickListener(this._-8H);
            var btn:* = this._panel.getChild("btnRefresh").asButton;
            btn.addClickListener(this._-5z);
            this._-5V = btn.getTransition("t0");
            this._-9L = this._panel.getChild("btnSync").asButton;
            this._-9L.addEventListener(StateChangeEvent.CHANGED, this._-7x);
            this._panel.getChild("btnLocate").addClickListener(function (event:Event) : void
            {
                var _loc_2:* = _editor.docView.activeDocument;
                if (!_loc_2)
                {
                    return;
                }
                highlight(_loc_2.packageItem);
                return;
            }// end function
            );
            this._-Hr = this._panel.getChild("group").asComboBox;
            this._-Hr.addEventListener(StateChangeEvent.CHANGED, this._-9P);
            this._-23 = "";
            this._-Ka = this._panel.getChild("btnTwoColumn").asButton;
            this._-Ka.addEventListener(StateChangeEvent.CHANGED, this._-PG);
            this._-Is = new Vector.<FPackageItem>;
            addEventListener(_-4U._-76, this.handleKeyEvent);
            addEventListener(FocusChangeEvent.CHANGED, this._-AB);
            addEventListener(DropEvent.DROP, this._-G6);
            this._editor.on(EditorEvent.ProjectOpened, this.onLoad);
            this._editor.on(EditorEvent.ProjectClosed, this._-24);
            this._editor.on(EditorEvent.DocumentActivated, this._-A2);
            this._editor.on(EditorEvent.PackageListChanged, this._-LK);
            this._editor.on(EditorEvent.PackageReloaded, this._-FJ);
            this._editor.on(EditorEvent.PackageTreeChanged, this._-5Y);
            this._editor.on(EditorEvent.PackageItemChanged, this._-E2);
            this._editor.on(EditorEvent.ProjectRefreshStart, function () : void
            {
                _-5V.play();
                return;
            }// end function
            );
            this._editor.on(EditorEvent.ProjectRefreshEnd, function () : void
            {
                _-5V.stop(true);
                return;
            }// end function
            );
            return;
        }// end function

        private function onLoad() : void
        {
            this._-9L.selected = this._editor.workspaceSettings.get("libview.syncEditor");
            this._-Ka.selected = this._editor.workspaceSettings.get("libview.twoColumn");
            this._projectView._-8Z = this._-Ka.selected;
            var _loc_1:* = this._editor.workspaceSettings.get("libview.firstColumnWidth");
            if (_loc_1 > 0 && _loc_1 < this._-Ng.width - 50)
            {
                this._projectView.treeView.width = _loc_1;
            }
            this._-23 = this._editor.workspaceSettings.get("libview.currentGroup");
            if (this._-23)
            {
                this._-GT();
            }
            else if (!this._-23)
            {
                this._-23 = "";
            }
            this._-5m();
            this._projectView._-5Q(null, true, true);
            var _loc_2:* = this._editor.workspaceSettings.get("libview.expandedNodes") as Array;
            if (_loc_2)
            {
                this._projectView._-1X(_loc_2);
            }
            return;
        }// end function

        private function _-24() : void
        {
            this._editor.workspaceSettings.set("libview.expandedNodes", this._projectView._-3H());
            this._editor.workspaceSettings.set("libview.currentGroup", this._-23);
            this._editor.workspaceSettings.set("libview.twoColumn", this._-Ka.selected);
            this._editor.workspaceSettings.set("libview.firstColumnWidth", int(this._projectView.treeView.width));
            return;
        }// end function

        private function _-A2(param1:IDocument) : void
        {
            if (this._-9L.selected)
            {
                this.highlight(param1.packageItem, false);
            }
            return;
        }// end function

        private function _-E2(param1:FPackageItem) : void
        {
            this._projectView.setChanged(param1);
            return;
        }// end function

        private function _-LK() : void
        {
            this._-5m();
            this._projectView._-5Q(null);
            return;
        }// end function

        private function _-FJ(param1:IUIPackage) : void
        {
            this._projectView._-5Q(param1.rootItem, true);
            return;
        }// end function

        private function _-5Y(param1:FPackageItem) : void
        {
            this._projectView._-5Q(param1);
            return;
        }// end function

        public function getFolderUnderPoint(param1:Number, param2:Number) : FPackageItem
        {
            return this._projectView.getFolderUnderPoint(param1, param2);
        }// end function

        public function getSelectedResource() : FPackageItem
        {
            return this._projectView.getSelectedResource();
        }// end function

        public function getSelectedResources(param1:Boolean) : Vector.<FPackageItem>
        {
            var _loc_2:* = this._projectView.getSelectedResources();
            _loc_2 = this._-BS(_loc_2, param1, true);
            return _loc_2;
        }// end function

        public function getSelectedFolder() : FPackageItem
        {
            return this._projectView.getSelectedFolder();
        }// end function

        public function highlight(param1:FPackageItem, param2:Boolean = true) : void
        {
            if (param2)
            {
                this._editor.viewManager.showView("fairygui.LibraryView");
                this._panel.requestFocus();
            }
            this._projectView.select(param1);
            return;
        }// end function

        public function moveResources(param1:FPackageItem, param2:Vector.<FPackageItem>) : void
        {
            var i:int;
            var pi:FPackageItem;
            var targetPkg:IUIPackage;
            var str:String;
            var cnt2:int;
            var msg:String;
            var dropTarget:* = param1;
            var items:* = param2;
            var cnt:* = items.length;
            if (cnt == 0)
            {
                return;
            }
            var pkg:* = items[0].owner;
            i;
            while (i < cnt)
            {
                
                pi = items[i];
                if (pi.owner != pkg)
                {
                    this._editor.alert(Consts.strings.text437);
                    return;
                }
                i = (i + 1);
            }
            var targetPath:* = dropTarget.id;
            targetPkg = dropTarget.owner;
            if (pkg == targetPkg)
            {
                items = this._-BS(items, false);
                cnt = items.length;
                if (cnt == 0)
                {
                    return;
                }
                if (items.indexOf(dropTarget) != -1)
                {
                    return;
                }
                this._projectView.expand(dropTarget);
                i;
                while (i < cnt)
                {
                    
                    pi = items[i];
                    try
                    {
                        pkg.moveItem(pi, targetPath);
                    }
                    catch (err:Error)
                    {
                        _editor.alert(null, err);
                        break;
                    }
                    i = (i + 1);
                }
            }
            else
            {
                items = this._-BS(items, true);
                cnt = items.length;
                if (cnt == 0)
                {
                    return;
                }
                if (items.indexOf(dropTarget) != -1)
                {
                    return;
                }
                str;
                cnt2 = Math.min(2, cnt);
                i;
                while (i < cnt2)
                {
                    
                    pi = items[i];
                    if (str)
                    {
                        str = str + ",";
                    }
                    str = str + pi.name;
                    i = (i + 1);
                }
                msg = UtilsStr.formatString(Consts.strings.text33, str, cnt, targetPkg.name);
                this._editor.confirm(msg, function () : void
            {
                var copyHandler:_-JG;
                _projectView.expand(dropTarget);
                copyHandler = new _-JG();
                _editor.cursorManager.setWaitCursor(true);
                copyHandler._-5a(items, targetPkg, dropTarget.id, _-y._-Hs);
                _editor.cursorManager.setWaitCursor(false);
                if (copyHandler._-LR > 0)
                {
                    PasteOptionDialog(_editor.getDialog(PasteOptionDialog)).open(function (param1:int) : void
                {
                    _editor.cursorManager.setWaitCursor(true);
                    copyHandler.copy(targetPkg, param1, true);
                    _editor.cursorManager.setWaitCursor(false);
                    return;
                }// end function
                );
                }
                else
                {
                    _editor.cursorManager.setWaitCursor(true);
                    copyHandler.copy(targetPkg, _-JG._-IT, true);
                    _editor.cursorManager.setWaitCursor(false);
                }
                return;
            }// end function
            );
            }
            return;
        }// end function

        public function deleteResources(param1:Vector.<FPackageItem>) : void
        {
            var cnt:int;
            var pkg:IUIPackage;
            var i:int;
            var pi:FPackageItem;
            var msg:String;
            var items:* = param1;
            cnt = items.length;
            if (cnt == 0)
            {
                return;
            }
            pkg = items[0].owner;
            i;
            while (i < cnt)
            {
                
                pi = items[i];
                if (pi.owner != pkg)
                {
                    this._editor.alert(Consts.strings.text437);
                    return;
                }
                i = (i + 1);
            }
            if (cnt > 1 || !items[0].isBranchRoot)
            {
                items = this._-BS(items, false);
                cnt = items.length;
                if (cnt == 0)
                {
                    return;
                }
            }
            var str:String;
            var cnt2:* = Math.min(2, cnt);
            i;
            while (i < cnt2)
            {
                
                pi = items[i];
                if (str)
                {
                    str = str + ",";
                }
                str = str + pi.name;
                i = (i + 1);
            }
            if (cnt > 1)
            {
                msg = UtilsStr.formatString(Consts.strings.text30, str, cnt);
            }
            else
            {
                msg = UtilsStr.formatString(Consts.strings.text31, str);
            }
            this._editor.confirm(msg, function () : void
            {
                _projectView._-DI(items[(cnt - 1)]);
                pkg.beginBatch();
                if (cnt == 1 && items[0].isBranchRoot)
                {
                    pkg.deleteItem(items[0]);
                }
                else
                {
                    i = 0;
                    while (i < cnt)
                    {
                        
                        pi = items[i];
                        if (!pi.isRoot && !pi.isBranchRoot && !pi.isDisposed)
                        {
                            pkg.deleteItem(pi);
                        }
                        var _loc_2:* = i + 1;
                        i = _loc_2;
                    }
                }
                pkg.endBatch();
                _editor.showPreview(getSelectedResource());
                return;
            }// end function
            );
            return;
        }// end function

        public function setResourcesExported(param1:Vector.<FPackageItem>, param2:Boolean) : void
        {
            this._-AZ(param1, "exported", param2, true, true);
            return;
        }// end function

        public function setResourcesFavorite(param1:Vector.<FPackageItem>, param2:Boolean) : void
        {
            this._-AZ(param1, "favorite", param2, true, false);
            return;
        }// end function

        private function _-AZ(param1:Vector.<FPackageItem>, param2:String, param3:Boolean, param4:Boolean, param5:Boolean) : void
        {
            var _loc_8:* = 0;
            var _loc_9:* = null;
            var _loc_6:* = param1.length;
            if (param1.length == 0)
            {
                return;
            }
            var _loc_7:* = param1[0].owner;
            _loc_8 = 1;
            while (_loc_8 < _loc_6)
            {
                
                _loc_9 = param1[_loc_8];
                if (_loc_9.owner != _loc_7)
                {
                    this._editor.alert(Consts.strings.text437);
                    return;
                }
                _loc_8++;
            }
            param1 = this._-BS(param1, param4);
            _loc_6 = param1.length;
            if (_loc_6 == 0)
            {
                return;
            }
            _loc_7.beginBatch();
            _loc_8 = 0;
            while (_loc_8 < _loc_6)
            {
                
                _loc_9 = param1[_loc_8];
                if (_loc_9.isRoot || _loc_9.isBranchRoot)
                {
                }
                else if (!param5 || _loc_9.type != FPackageItemType.FOLDER)
                {
                    _loc_9.owner.setItemProperty(_loc_9, param2, param3);
                }
                _loc_8++;
            }
            _loc_7.endBatch();
            return;
        }// end function

        public function openResource(param1:FPackageItem) : void
        {
            if (param1 == null)
            {
                return;
            }
            if (param1.isRoot || param1.isBranchRoot)
            {
                this.highlight(param1);
            }
            else if (param1.type == FPackageItemType.FOLDER)
            {
                FolderPropertyDialog(this._editor.getDialog(FolderPropertyDialog)).open(param1);
            }
            else if (param1.type == FPackageItemType.COMPONENT)
            {
                if (!_-D._-8J)
                {
                    _-1L(this._editor).checkRegisterStatus();
                }
                this._editor.docView.openDocument(param1);
            }
            else if (param1.type == FPackageItemType.IMAGE)
            {
                ImageEditDialog(this._editor.getDialog(ImageEditDialog)).open(param1);
            }
            else if (param1.type == FPackageItemType.FONT)
            {
                FontEditDialog(this._editor.getDialog(FontEditDialog)).open(param1);
            }
            else if (param1.type == FPackageItemType.MOVIECLIP)
            {
                MovieClipEditDialog(this._editor.getDialog(MovieClipEditDialog)).open(param1);
            }
            else
            {
                param1.file.openWithDefaultApplication();
            }
            return;
        }// end function

        public function openResources(param1:Vector.<FPackageItem>) : void
        {
            var _loc_5:* = null;
            var _loc_2:* = param1.length;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_5 = param1[_loc_4];
                if (_loc_5.type == FPackageItemType.IMAGE || _loc_5.type == FPackageItemType.MOVIECLIP)
                {
                    _loc_3++;
                }
                _loc_4++;
            }
            if (_loc_3 == _loc_2 && _loc_2 > 1)
            {
                MultiImageEditDialog(this._editor.getDialog(MultiImageEditDialog)).open(param1);
            }
            else
            {
                this.openResource(param1[0]);
            }
            return;
        }// end function

        public function showResourceInExplorer(param1:FPackageItem) : void
        {
            arguments = new NativeProcessStartupInfo();
            var _loc_4:* = new Vector.<String>;
            if (!Consts.isMacOS)
            {
                arguments.executable = new File("c:\\windows\\explorer.exe");
                _loc_4.push("/select," + param1.file.nativePath);
            }
            else
            {
                arguments.executable = new File("/usr/bin/open");
                _loc_4.push("-R");
                _loc_4.push(param1.file.nativePath);
            }
            arguments.arguments = _loc_4;
            var _loc_5:* = new NativeProcess();
            _loc_5.start(arguments);
            return;
        }// end function

        public function showUpdateResourceDialog(param1:FPackageItem) : void
        {
            var ff:Array;
            var pi:* = param1;
            var pkg:* = pi.owner;
            if (pi.type == FPackageItemType.IMAGE)
            {
                ff;
            }
            else if (pi.type == FPackageItemType.SWF)
            {
                ff;
            }
            else if (pi.type == FPackageItemType.MOVIECLIP)
            {
                ff;
            }
            else if (pi.type == FPackageItemType.SOUND)
            {
                ff;
            }
            else if (pi.type == FPackageItemType.FONT)
            {
                ff;
            }
            else if (pi.type == FPackageItemType.COMPONENT)
            {
                ff;
            }
            else
            {
                return;
            }
            UtilsFile.browseForOpen(Consts.strings.text54 + ":" + pi.name, ff, function (param1:File) : void
            {
                updateResource(pi, param1);
                return;
            }// end function
            );
            return;
        }// end function

        public function showImportResourcesDialog(param1:IUIPackage = null, param2:String = null) : void
        {
            var pkg:* = param1;
            var toPath:* = param2;
            var pi:* = this._editor.getActiveFolder();
            if (pkg == null)
            {
                pkg = pi.owner;
                toPath = pi.id;
            }
            else if (toPath == null)
            {
                if (pkg == pi.owner)
                {
                    toPath = pi.id;
                }
                else
                {
                    toPath;
                }
            }
            UtilsFile.browseForOpenMultiple(Consts.strings.text46 + ":" + pkg.name, [new FileFilter(Consts.strings.text47, "*.jpg;*.png;*.psd;*.tga;*.gif;*.plist;*.eas;*.jta;*.swf;*.wav;*.mp3;*.ogg;*.fnt;*.xml"), new FileFilter(Consts.strings.text48, "*.*"), new FileFilter(Consts.strings.text49, "*.jpg;*.png;*.psd;*.tga;*.svg"), new FileFilter(Consts.strings.text50, "*.swf"), new FileFilter(Consts.strings.text51, "*.gif;*.plist;*.eas;*.jta"), new FileFilter(Consts.strings.text52, "*.fnt"), new FileFilter(Consts.strings.text53, "*.mp3;*.wav;*.ogg"), new FileFilter(Consts.strings.text316, "*.xml")], function (param1:Array) : void
            {
                var _loc_2:* = File(param1[0]).parent;
                var _loc_3:* = _editor.importResource(pkg);
                var _loc_4:* = 0;
                while (_loc_4 < param1.length)
                {
                    
                    _loc_3.addRelative(param1[_loc_4], toPath, _loc_2);
                    _loc_4++;
                }
                _loc_3.process();
                return;
            }// end function
            );
            return;
        }// end function

        private function updateResource(param1:FPackageItem, param2:File) : void
        {
            var callback2:Callback;
            var pi:* = param1;
            var file:* = param2;
            this._editor.showWaiting();
            callback2 = new Callback();
            callback2.success = function () : void
            {
                _editor.closeWaiting();
                _editor.showPreview(null);
                var _loc_1:* = ImageEditDialog(_editor.getDialog(ImageEditDialog));
                if (_loc_1.isShowing && _loc_1.imageItem == pi)
                {
                    _loc_1.open(pi);
                }
                return;
            }// end function
            ;
            callback2.failed = function () : void
            {
                _editor.closeWaiting();
                _editor.alert(Consts.strings.text55 + ": " + callback2.msgs.join("\n"));
                return;
            }// end function
            ;
            pi.owner.updateResource(pi, file, callback2);
            return;
        }// end function

        private function _-5z(event:Event) : void
        {
            this._editor.refreshProject();
            return;
        }// end function

        private function _-8H(event:Event) : void
        {
            this._projectView.treeView.collapseAll();
            return;
        }// end function

        private function _-7x(event:Event) : void
        {
            this._editor.workspaceSettings.set("libview.syncEditor", GButton(event.currentTarget).selected ? (1) : (0));
            return;
        }// end function

        private function _-AB(event:FocusChangeEvent) : void
        {
            this._projectView.setActive(event.newFocusedObject == this);
            return;
        }// end function

        private function createMenu() : void
        {
            var btn:GButton;
            this._-Kz = new PopupMenu();
            this._-Kz.contentPane.width = 210;
            btn = this._-Kz.addItem(Consts.strings.text236 + "...", this._-DR);
            btn.name = "property";
            btn = this._-Kz.addItem(Consts.strings.text17, this._-d);
            btn.name = "rename";
            btn.getChild("shortcut").text = "F2";
            this._-Kz.addItem(Consts.strings.text174, this._-Ni).name = "newCom";
            this._-Kz.addItem(Consts.strings.text18, this._-IB).name = "newFolder";
            this._-Kz.addSeperator();
            this._-Kz.addItem(Consts.strings.text2, this._-5G).name = "copy";
            this._-Kz.addItem(Consts.strings.text246 + "...", this._-OB).name = "duplicate";
            this._-Kz.addItem(Consts.strings.text245 + "...", this._-Bv).name = "move";
            this._-Kz.addItem(Consts.strings.text3, this._-Eo).name = "paste";
            this._-Kz.addItem(Consts.strings.text336, this._-MK).name = "pasteAll";
            this._-Kz.addItem(Consts.strings.text25, this._-Lr).name = "delete";
            this._-Kz.addSeperator();
            this._-Kz.addItem(Consts.strings.text16, this._-H2).name = "copyLink";
            this._-Kz.addItem(Consts.strings.text194, this._-Bj).name = "copyName";
            this._-Kz.addItem(Consts.strings.text171, this._-M2).name = "findRef";
            this._-Kz.addSeperator();
            this._-Kz.addItem(Consts.strings.text20, this._-II).name = "setExport";
            this._-Kz.addItem(Consts.strings.text21, this._-2S).name = "setNotExport";
            this._-Kz.addItem(Consts.strings.text334, this._-D4).name = "favorite";
            this._-Kz.addSeperator();
            this._-Kz.addItem(Consts.strings.text22 + "...", this._-6c).name = "update";
            this._-Kz.addItem(Consts.strings.text192, this._-Gb).name = "openWithExternal";
            this._-Kz.addItem(Consts.isMacOS ? (Consts.strings.text90) : (Consts.strings.text24), this._-M3).name = "openInExplorer";
            this._-68 = new PopupMenu();
            btn = this._-68.addItem(Consts.strings.text236 + "...", this._-DR);
            btn.name = "property";
            btn = this._-68.addItem(Consts.strings.text17, this._-d);
            btn.name = "rename";
            btn.getChild("shortcut").text = "F2";
            this._-68.addItem(Consts.strings.text174, this._-Ni).name = "newCom";
            this._-68.addItem(Consts.strings.text18, this._-IB).name = "newFolder";
            this._-68.addSeperator();
            this._-68.addItem(Consts.strings.text2, this._-5G).name = "copy";
            this._-68.addItem(Consts.strings.text245 + "...", this._-Bv).name = "move";
            this._-68.addItem(Consts.strings.text3, this._-Eo).name = "paste";
            this._-68.addItem(Consts.strings.text336, this._-MK).name = "pasteAll";
            this._-68.addItem(Consts.strings.text25, this._-Lr).name = "delete";
            this._-68.addSeperator();
            this._-68.addItem(Consts.strings.text20, this._-II).name = "setExport";
            this._-68.addItem(Consts.strings.text21, this._-2S).name = "setNotExport";
            this._-68.addItem(Consts.strings.text334, this._-D4).name = "favorite";
            this._-68.addSeperator();
            this._-68.addItem(Consts.strings.text24, this._-M3).name = "openInExplorer";
            this._-7W = new PopupMenu();
            this._-7W.addItem(Consts.strings.text174, this._-Ni).name = "newCom";
            this._-7W.addItem(Consts.strings.text18, this._-IB).name = "newFolder";
            this._-7W.addItem(Consts.strings.text420, this._-Lx).name = "createBranch";
            this._-7W.addSeperator();
            this._-7W.addItem(Consts.strings.text3, this._-Eo).name = "paste";
            this._-7W.addItem(Consts.strings.text336, this._-MK).name = "pasteAll";
            this._-7W.addSeperator();
            btn = this._-7W.addItem(Consts.strings.text17, this._-d);
            btn.name = "rename";
            btn.getChild("shortcut").text = "F2";
            this._-7W.addItem(Consts.strings.text28 + "...", function () : void
            {
                _editor.getDialog(PublishDialog).show();
                return;
            }// end function
            );
            this._-7W.addSeperator();
            this._-7W.addItem(Consts.strings.text29, this._-7j).name = "deletePkg";
            this._-7W.addSeperator();
            this._-7W.addItem(Consts.strings.text192, this._-Gb).name = "openWithExternal";
            this._-7W.addItem(Consts.isMacOS ? (Consts.strings.text90) : (Consts.strings.text24), this._-M3).name = "openInExplorer";
            return;
        }// end function

        private function _-Nz(param1:FPackageItem, param2:ItemEvent) : void
        {
            var _loc_3:* = param1.type == FPackageItemType.FOLDER;
            var _loc_4:* = _-Ia.hasFormat(_-Ia._-Kf);
            if (param1.isRoot)
            {
                this._-7W.setItemGrayed("paste", !_loc_4);
                this._-7W.setItemGrayed("pasteAll", !_loc_4);
                this._-7W.show(this._editor.groot);
            }
            else if (_loc_3)
            {
                this._-68.setItemGrayed("property", param1.isBranchRoot);
                this._-68.setItemText("favorite", param1.favorite ? (Consts.strings.text335) : (Consts.strings.text334));
                this._-68.show(this._editor.groot);
            }
            else
            {
                this._-Kz.setItemGrayed("property", param1.type != FPackageItemType.IMAGE && param1.type != FPackageItemType.MOVIECLIP);
                this._-Kz.setItemGrayed("paste", !_loc_4);
                this._-Kz.setItemGrayed("pasteAll", !_loc_4);
                this._-Kz.setItemText("favorite", param1.favorite ? (Consts.strings.text335) : (Consts.strings.text334));
                this._-Kz.show(this._editor.groot);
            }
            return;
        }// end function

        private function _-d(event:Event) : void
        {
            this._projectView.rename();
            return;
        }// end function

        private function _-M3(event:Event) : void
        {
            var _loc_2:* = this._projectView.getSelectedResource();
            this.showResourceInExplorer(_loc_2);
            return;
        }// end function

        private function _-Gb(event:Event) : void
        {
            var _loc_2:* = this._projectView.getSelectedResource();
            _loc_2.openWithDefaultApplication();
            return;
        }// end function

        private function _-H2(event:Event) : void
        {
            var _loc_2:* = this._projectView.getSelectedResource();
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _loc_2.getURL());
            return;
        }// end function

        private function _-Bj(event:Event) : void
        {
            var _loc_2:* = this._projectView.getSelectedResource();
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _loc_2.name);
            return;
        }// end function

        private function _-II(event:Event) : void
        {
            this.setResourcesExported(this._projectView.getSelectedResources(), true);
            return;
        }// end function

        private function _-2S(event:Event) : void
        {
            this.setResourcesExported(this._projectView.getSelectedResources(), false);
            return;
        }// end function

        private function _-D4(event:Event) : void
        {
            this.setResourcesFavorite(this._projectView.getSelectedResources(), true);
            return;
        }// end function

        private function _-6c(event:Event) : void
        {
            var _loc_2:* = this._projectView.getSelectedResource();
            this.showUpdateResourceDialog(_loc_2);
            return;
        }// end function

        private function _-Lr(event:Event) : void
        {
            var _loc_2:* = this._projectView.getSelectedResources();
            this.deleteResources(_loc_2);
            return;
        }// end function

        private function _-7j(event:Event) : void
        {
            var _loc_2:* = this._projectView.getSelectedResource();
            var _loc_3:* = UtilsStr.formatString(Consts.strings.text32, _loc_2.name);
            this._editor.confirm(_loc_3, this._-g);
            return;
        }// end function

        private function _-g() : void
        {
            var _loc_1:* = this._projectView.getSelectedResource();
            this._editor.project.deletePackage(_loc_1.owner.id);
            return;
        }// end function

        private function _-IB(event:Event) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = this._projectView.getSelectedResource();
            if (_loc_2.type == FPackageItemType.FOLDER)
            {
                _loc_3 = _loc_2;
            }
            else
            {
                _loc_3 = _loc_2.owner.getItem(_loc_2.path);
            }
            this._projectView.expand(_loc_3);
            var _loc_4:* = _loc_2.owner.createFolder("Folder", _loc_3.id, true);
            this._projectView.rename(_loc_4);
            return;
        }// end function

        private function _-DR(event:Event) : void
        {
            var _loc_2:* = this._projectView.getSelectedResources();
            var _loc_3:* = _loc_2.length;
            if (_loc_3 == 0)
            {
                return;
            }
            this.openResources(_loc_2);
            return;
        }// end function

        private function _-N8() : void
        {
            var _loc_1:* = this._projectView.getSelectedResources();
            if (_loc_1.length > 0)
            {
                _-Ia.setValue(_-Ia._-Kf, _loc_1);
            }
            return;
        }// end function

        private function _-Im(param1:Boolean) : void
        {
            var dropTarget:FPackageItem;
            var seekLevel:int;
            var copyHandler:_-JG;
            var ignoreExported:* = param1;
            var items:* = _-Ia._-4y(_-Ia._-Kf) as Vector.<FPackageItem>;
            if (!items)
            {
                return;
            }
            dropTarget = this._projectView.getSelectedFolder();
            if (items[0].id == dropTarget.id)
            {
                dropTarget = dropTarget.parent;
            }
            this._projectView.expand(dropTarget);
            items = this._-BS(items, true);
            if (dropTarget.owner.project != items[0].owner.project)
            {
                seekLevel = _-y._-D0;
            }
            else if (dropTarget.owner != items[0].owner)
            {
                if (ignoreExported)
                {
                    seekLevel = _-y._-62;
                }
                else
                {
                    seekLevel = _-y._-EB;
                }
            }
            else
            {
                seekLevel = _-y._-Hs;
            }
            if (items.length == 0)
            {
                return;
            }
            copyHandler = new _-JG();
            this._editor.cursorManager.setWaitCursor(true);
            copyHandler._-5a(items, dropTarget.owner, dropTarget.id, seekLevel);
            this._editor.cursorManager.setWaitCursor(false);
            if (copyHandler._-LR > 0)
            {
                PasteOptionDialog(this._editor.getDialog(PasteOptionDialog)).open(function (param1:int) : void
            {
                var overrideOption:* = param1;
                _editor.cursorManager.setWaitCursor(true);
                try
                {
                    copyHandler.copy(dropTarget.owner, overrideOption);
                }
                catch (err:Error)
                {
                    _editor.alert("copy failed", err);
                }
                _editor.cursorManager.setWaitCursor(false);
                return;
            }// end function
            );
            }
            else
            {
                this._editor.cursorManager.setWaitCursor(true);
                copyHandler.copy(dropTarget.owner, _-JG._-IT);
                this._editor.cursorManager.setWaitCursor(false);
            }
            return;
        }// end function

        private function _-5G(event:Event) : void
        {
            this._-N8();
            return;
        }// end function

        private function _-Eo(event:Event) : void
        {
            this._-Im(true);
            return;
        }// end function

        private function _-MK(event:Event) : void
        {
            this._-Im(false);
            return;
        }// end function

        private function _-Bv(event:Event) : void
        {
            var evt:* = event;
            ChooseFolderDialog(this._editor.getDialog(ChooseFolderDialog)).open(null, function (param1:FPackageItem) : void
            {
                moveResources(param1, _projectView.getSelectedResources());
                return;
            }// end function
            );
            return;
        }// end function

        private function _-OB(event:Event) : void
        {
            var _loc_2:* = this._projectView.getSelectedResources();
            if (_loc_2.length == 0)
            {
                return;
            }
            FixConflictedNameDialog(this._editor.getDialog(FixConflictedNameDialog)).open(_loc_2, _loc_2[0].path, this._-AY);
            return;
        }// end function

        private function _-AY(param1:Vector.<FPackageItem>, param2:Vector.<String>) : void
        {
            var pi:FPackageItem;
            var newItem:FPackageItem;
            var pis:* = param1;
            var newNames:* = param2;
            try
            {
                pi = pis[0];
                newItem = pi.owner.duplicateItem(pi, newNames[0]);
                if (pi.type == FPackageItemType.COMPONENT)
                {
                    this._editor.libView.openResource(newItem);
                }
            }
            catch (err:Error)
            {
                _editor.alert(null, err);
            }
            return;
        }// end function

        private function _-Ni(event:Event) : void
        {
            this._editor.getDialog(CreateComDialog).show();
            return;
        }// end function

        private function _-Lx(event:Event) : void
        {
            var evt:* = event;
            if (this._editor.project.allBranches.length == 0)
            {
                this._editor.alert(Consts.strings.text421);
                return;
            }
            if (this._editor.project.activeBranch.length == 0)
            {
                this._editor.alert(Consts.strings.text422);
                return;
            }
            var pkg:* = this._projectView._-4d();
            try
            {
                pkg.createBranch(this._editor.project.activeBranch);
            }
            catch (err:Error)
            {
                _editor.alert(null, err);
            }
            return;
        }// end function

        private function handleKeyEvent(param1:_-4U) : void
        {
            var _loc_2:* = null;
            this._projectView.handleKeyEvent(param1);
            switch(param1._-T)
            {
                case "0000":
                {
                    this._projectView.open();
                    break;
                }
                case "0001":
                {
                    _loc_2 = this._projectView.getSelectedResource();
                    if (_loc_2)
                    {
                        if (_loc_2.isRoot)
                        {
                            this._-7j(null);
                        }
                        else
                        {
                            this._-Lr(null);
                        }
                    }
                    break;
                }
                case "0002":
                {
                    this._-N8();
                    break;
                }
                case "0003":
                {
                    this._-Im(true);
                    break;
                }
                case "0120":
                {
                    _loc_2 = this._projectView.getSelectedResource();
                    if (_loc_2 && _loc_2.type != FPackageItemType.FOLDER)
                    {
                        this._editor.findReference(_loc_2.getURL());
                    }
                    break;
                }
                case "0201":
                {
                    this._projectView.rename();
                    break;
                }
                case "0202":
                {
                    this._-IB(null);
                    break;
                }
                case "0203":
                {
                    this._-II(null);
                    break;
                }
                case "0204":
                {
                    this._-2S(null);
                    break;
                }
                case "0205":
                {
                    this._-Gb(null);
                    break;
                }
                case "0206":
                {
                    this._-M3(null);
                    break;
                }
                case "0207":
                {
                    this._-8H(null);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function _-G6(event:DropEvent) : void
        {
            if (event.source != this)
            {
                return;
            }
            var _loc_2:* = this._editor.groot.nativeStage.mouseX;
            var _loc_3:* = this._editor.groot.nativeStage.mouseY;
            var _loc_4:* = this._projectView.getFolderUnderPoint(_loc_2, _loc_3);
            if (!this._projectView.getFolderUnderPoint(_loc_2, _loc_3))
            {
                return;
            }
            this.moveResources(_loc_4, event._-LE as Vector.<FPackageItem>);
            return;
        }// end function

        private function _-M2(event:Event) : void
        {
            var _loc_2:* = this._projectView.getSelectedResource();
            this._editor.findReference(_loc_2.getURL());
            return;
        }// end function

        private function _-BS(param1:Vector.<FPackageItem>, param2:Boolean = false, param3:Boolean = false) : Vector.<FPackageItem>
        {
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_9:* = 0;
            var _loc_4:* = param1.length;
            if (param1.length == 1)
            {
                _loc_6 = param1[0];
                if (_loc_6.isRoot || _loc_6.isBranchRoot)
                {
                    if (param3)
                    {
                        param1.length = 0;
                        return param1;
                    }
                    return new Vector.<FPackageItem>;
                }
                else if (_loc_6.type == FPackageItemType.FOLDER && param2)
                {
                    if (!param3)
                    {
                        param1 = param1.concat();
                    }
                    _loc_6.owner.getItemListing(_loc_6, null, false, true, param1);
                    return param1;
                }
                else
                {
                    return param1;
                }
            }
            _loc_5 = 0;
            var _loc_7:* = null;
            var _loc_8:* = false;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = param1[_loc_5];
                if (_loc_6.isRoot || _loc_6.isBranchRoot)
                {
                    if (!_loc_8 && !param3)
                    {
                        param1 = param1.concat();
                        _loc_8 = true;
                    }
                    _loc_4 = _loc_4 - 1;
                    param1.splice(_loc_5, 1);
                    continue;
                    continue;
                }
                _loc_5++;
                if (_loc_6.type == FPackageItemType.FOLDER)
                {
                    if (!_loc_7)
                    {
                        _loc_7 = {};
                    }
                    _loc_7[_loc_6.id] = true;
                }
            }
            if (_loc_7)
            {
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_6 = param1[_loc_5];
                    this._-Is.length = 0;
                    _loc_6.owner.getItemPath(_loc_6, this._-Is);
                    _loc_9 = 0;
                    while (_loc_9 < (this._-Is.length - 1))
                    {
                        
                        if (_loc_7[this._-Is[_loc_9].id])
                        {
                            if (!_loc_8 && !param3)
                            {
                                param1 = param1.concat();
                                _loc_8 = true;
                            }
                            param1.splice(_loc_5, 1);
                            _loc_5 = _loc_5 - 1;
                            _loc_4 = _loc_4 - 1;
                            break;
                        }
                        _loc_9++;
                    }
                    _loc_5++;
                }
            }
            if (param2)
            {
                this._-Is.length = 0;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_6 = param1[_loc_5];
                    this._-Is.push(_loc_6);
                    if (_loc_6.type == FPackageItemType.FOLDER)
                    {
                        _loc_6.owner.getItemListing(_loc_6, null, false, true, this._-Is);
                    }
                    _loc_5++;
                }
                if (this._-Is.length != _loc_4)
                {
                    if (!_loc_8 && !param3)
                    {
                        param1 = this._-Is.concat();
                    }
                    else
                    {
                        _loc_4 = this._-Is.length;
                        param1.length = _loc_4;
                        _loc_5 = 0;
                        while (_loc_5 < _loc_4)
                        {
                            
                            param1[_loc_5] = this._-Is[_loc_5];
                            _loc_5++;
                        }
                    }
                }
            }
            return param1;
        }// end function

        private function _-5m() : void
        {
            var _loc_4:* = null;
            var _loc_1:* = [];
            var _loc_2:* = [];
            _loc_1.push(Consts.strings.text417);
            _loc_2.push("");
            _loc_1.push(Consts.strings.text433);
            _loc_2.push("~");
            var _loc_3:* = PackageGroupSettings(this._editor.project.getSettings("packageGroups")).groups;
            for each (_loc_4 in _loc_3)
            {
                
                if (_loc_4.name)
                {
                    _loc_1.push(_loc_4.name);
                    _loc_2.push(_loc_4.name);
                }
            }
            _loc_1.push(Consts.strings.text416 + "...");
            _loc_2.push("@@@");
            this._-Hr.items = _loc_1;
            this._-Hr.values = _loc_2;
            if (_loc_2.indexOf(this._-23) != -1)
            {
                this._-Hr.value = this._-23;
            }
            else
            {
                this._-23 = "";
                this._-Hr.value = "";
            }
            this._-GT();
            return;
        }// end function

        private function _-GT() : void
        {
            var _loc_1:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            if (this._-23)
            {
                if (this._-23 == "~")
                {
                    _loc_1 = this._editor.workspaceSettings.get("packageGroup.mine") as Array;
                }
                else
                {
                    _loc_5 = PackageGroupSettings(this._editor.project.getSettings("packageGroups"));
                    for each (_loc_6 in _loc_5.groups)
                    {
                        
                        if (_loc_6.name == this._-23)
                        {
                            _loc_1 = _loc_6.pkgs as Array;
                            break;
                        }
                    }
                }
            }
            var _loc_2:* = this._editor.project.allPackages;
            var _loc_3:* = _loc_2.length;
            if (this._-23)
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_2[_loc_4].setVar("hide_in_lib", true);
                    _loc_4++;
                }
                if (_loc_1)
                {
                    for each (_loc_7 in _loc_1)
                    {
                        
                        _loc_8 = this._editor.project.getPackage(_loc_7);
                        if (_loc_8)
                        {
                            _loc_8.setVar("hide_in_lib", undefined);
                        }
                    }
                }
            }
            else
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_2[_loc_4].setVar("hide_in_lib", undefined);
                    _loc_4++;
                }
            }
            return;
        }// end function

        private function _-9P(event:Event) : void
        {
            var _loc_2:* = this._-Hr.value;
            if (_loc_2 == "@@@")
            {
                this._-Hr.value = this._-23;
                this._editor.getDialog(PackageGroupsEditDialog).show();
            }
            else
            {
                this._-23 = _loc_2;
                this._-GT();
                this._-LK();
            }
            return;
        }// end function

        private function _-PG(event:Event) : void
        {
            this._projectView._-8Z = this._-Ka.selected;
            this._projectView._-5Q(null, true, true);
            return;
        }// end function

    }
}
