package _-2F
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.geom.*;

    public class _-Dc extends Object
    {
        public var _-Nz:Function;
        public var _-FC:Function;
        public var _-O1:Boolean;
        private var _editor:IEditor;
        private var _treeView:GTree;
        private var _-Od:GList;
        private var _-Dk:GObject;
        private var _treeActive:Boolean;
        private var _-7n:Boolean;
        private var _-EJ:int;
        private var _-Cb:Vector.<FPackageItem>;
        private var _-71:FPackageItem;
        private var _-6M:String;
        private var _-Dw:Boolean;
        private var _-DZ:Vector.<GTreeNode>;
        private var _-Is:Vector.<FPackageItem>;
        private static const _-Gj:Array = ["folder"];

        public function _-Dc(param1:IEditor, param2:GTree, param3:GObject = null, param4:GList = null) : void
        {
            var editor:* = param1;
            var tree:* = param2;
            var sep:* = param3;
            var list:* = param4;
            this._editor = editor;
            this._treeActive = true;
            this._-6M = UtilsStr.generateUID();
            this._-Cb = new Vector.<FPackageItem>;
            this._-DZ = new Vector.<GTreeNode>;
            this._-Is = new Vector.<FPackageItem>;
            this._-FC = this._-Pj;
            this._treeView = tree;
            this._treeView.treeNodeRender = this.renderTreeNode;
            this._treeView.treeNodeWillExpand = this.treeNodeWillExpand;
            this._treeView.addEventListener(ItemEvent.CLICK, this._-5t);
            this._treeView.addEventListener(GTouchEvent.BEGIN, function () : void
            {
                _treeActive = true;
                handleActiveChanged();
                return;
            }// end function
            );
            this._treeView.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function () : void
            {
                _treeActive = true;
                handleActiveChanged();
                return;
            }// end function
            );
            this._-Od = list;
            if (this._-Od)
            {
                this._-Od.visible = false;
                this._-Od.addEventListener(ItemEvent.CLICK, this.__clickItem);
                this._-Od.itemRenderer = this.renderListItem;
                this._-Od.setVirtual();
                this._-Od.addEventListener(GTouchEvent.BEGIN, function () : void
            {
                _treeActive = false;
                handleActiveChanged();
                return;
            }// end function
            );
                this._-Od.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function () : void
            {
                _treeActive = false;
                handleActiveChanged();
                return;
            }// end function
            );
            }
            this._-Dk = sep;
            if (this._-Dk)
            {
                this._-Dk.visible = false;
                this._editor.cursorManager.setCursorForObject(this._-Dk.displayObject, CursorType.H_RESIZE);
                this._-Dk.draggable = true;
                this._-Dk.dragBounds = new Rectangle();
                this._-Dk.addEventListener(DragEvent.DRAG_START, this._-6b);
                this._-Dk.addEventListener(DragEvent.DRAG_MOVING, this._-1g);
            }
            return;
        }// end function

        public function setChanged(param1:FPackageItem) : Boolean
        {
            var _loc_5:* = 0;
            var _loc_2:* = false;
            var _loc_3:* = this._-5P(param1);
            if (_loc_3)
            {
                if (_loc_3.cell)
                {
                    this.renderTreeNode(_loc_3, _loc_3.cell);
                }
                _loc_2 = true;
            }
            if (!this._-Od || !this._-Od.visible || this._-Cb.length == 0 || this._-71.owner != param1.owner || this._-71.id != param1.path)
            {
                return _loc_2;
            }
            var _loc_4:* = this._-Cb.indexOf(param1);
            if (this._-Cb.indexOf(param1) != -1)
            {
                _loc_2 = true;
                _loc_5 = this._-Od.itemIndexToChildIndex(_loc_4);
                if (_loc_5 >= 0 && _loc_5 < this._-Od.numChildren)
                {
                    this.renderListItem(_loc_4, this._-Od.getChildAt(_loc_5));
                }
            }
            return _loc_2;
        }// end function

        public function _-5Q(param1:FPackageItem, param2:Boolean = false, param3:Boolean = false) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            if (!param1)
            {
                this._-80(this._treeView.rootNode);
                if (param3)
                {
                    this._-FZ();
                }
                if (param2)
                {
                    _loc_4 = this._-3H(this._treeView.rootNode);
                    this._treeView.collapseAll(this._treeView.rootNode);
                    _loc_5 = this._treeView.rootNode.numChildren;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_5)
                    {
                        
                        this._treeView.rootNode.getChildAt(_loc_6).removeChildren();
                        _loc_6++;
                    }
                    this._-1X(_loc_4);
                }
            }
            else
            {
                _loc_7 = this._-5P(param1);
                if (_loc_7)
                {
                    if (param2)
                    {
                        _loc_4 = this._-3H(_loc_7);
                        _loc_7.removeChildren();
                        if (!param1.isRoot || _loc_7.expanded)
                        {
                            this._-Fd(_loc_7);
                            this._-1X(_loc_4);
                        }
                        if (this._-71 == param1)
                        {
                            this._-PL(this._-71, true);
                        }
                    }
                    else if (!param1.isRoot || _loc_7.expanded || _loc_7.numChildren > 0)
                    {
                        this._-80(_loc_7);
                        if (param3)
                        {
                            this._-FZ();
                        }
                    }
                }
            }
            return;
        }// end function

        private function _-Pj(param1:FPackageItem, param2:Array, param3:Vector.<FPackageItem>) : Vector.<FPackageItem>
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (!param3)
            {
                param3 = new Vector.<FPackageItem>;
            }
            if (param1 == null)
            {
                _loc_4 = this._editor.project.allPackages;
                for each (_loc_5 in _loc_4)
                {
                    
                    if (!_loc_5.getVar("hide_in_lib"))
                    {
                        param3.push(_loc_5.rootItem);
                    }
                }
            }
            else
            {
                param1.owner.getItemListing(param1, param2, true, false, param3);
            }
            return param3;
        }// end function

        private function _-Fd(param1:GTreeNode) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_2:* = FPackageItem(param1.data);
            var _loc_3:* = this._-FC(_loc_2, this._-Od && this._-Od.visible ? (_-Gj) : (null), null);
            for each (_loc_4 in _loc_3)
            {
                
                _loc_5 = this.createNode(_loc_4);
                param1.addChild(_loc_5);
                if (_loc_5.isFolder)
                {
                    this._-Fd(_loc_5);
                }
            }
            return;
        }// end function

        private function _-4v() : void
        {
            if (this._-DZ.length > 0)
            {
                this._-FZ();
            }
            return;
        }// end function

        public function get treeView() : GTree
        {
            return this._treeView;
        }// end function

        public function get listView() : GList
        {
            return this._-Od;
        }// end function

        public function set _-8Z(param1:Boolean) : void
        {
            var _loc_2:* = param1;
            this._-Od.visible = param1;
            this._-Dk.visible = _loc_2;
            if (!param1)
            {
                this._-EJ = this._treeView.width;
            }
            else if (this._-EJ > 0)
            {
                this._treeView.width = this._-EJ;
            }
            if (!param1)
            {
                if (!this._treeActive)
                {
                    this._treeActive = true;
                    this.handleActiveChanged();
                }
                this._-Od.numItems = 0;
                this._-Cb.length = 0;
                this._-71 = null;
            }
            return;
        }// end function

        public function _-4d() : IUIPackage
        {
            var _loc_1:* = this.getSelectedFolder();
            if (_loc_1)
            {
                return _loc_1.owner;
            }
            return null;
        }// end function

        public function getSelectedFolder() : FPackageItem
        {
            var _loc_1:* = this.getSelectedResource();
            if (_loc_1)
            {
                if (_loc_1.type == FPackageItemType.FOLDER)
                {
                    return _loc_1;
                }
                return _loc_1.parent;
            }
            else
            {
                return null;
            }
        }// end function

        public function getSelectedResource() : FPackageItem
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            if (this._treeActive)
            {
                _loc_1 = this._treeView.getSelectedNode();
                if (_loc_1)
                {
                    _loc_2 = FPackageItem(_loc_1.data);
                    return _loc_2;
                }
                return null;
            }
            else
            {
            }
            return this._-Cb[this._-Od.selectedIndex];
            return null;
        }// end function

        public function getSelectedResources(param1:Vector.<FPackageItem> = null) : Vector.<FPackageItem>
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            if (!param1)
            {
                param1 = new Vector.<FPackageItem>;
            }
            if (this._treeActive)
            {
                _loc_6 = this._treeView.getSelectedNodes();
                _loc_4 = _loc_6.length;
                if (_loc_4 == 0)
                {
                    return param1;
                }
                _loc_2 = _loc_6[0].data.owner;
                _loc_3 = 0;
                while (_loc_3 < _loc_4)
                {
                    
                    _loc_7 = _loc_6[_loc_3];
                    _loc_5 = FPackageItem(_loc_7.data);
                    if (_loc_5.owner != _loc_2)
                    {
                    }
                    else
                    {
                        param1.push(_loc_5);
                    }
                    _loc_3++;
                }
            }
            else
            {
                if (this._-Od.selectedIndex == -1 || this._-Cb.length == 0)
                {
                    return param1;
                }
                _loc_8 = this._-Od.getSelection();
                _loc_2 = this._-71.owner;
                _loc_4 = _loc_8.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_4)
                {
                    
                    _loc_5 = this._-Cb[_loc_8[_loc_3]];
                    param1.push(_loc_5);
                    _loc_3++;
                }
            }
            return param1;
        }// end function

        public function getFolderUnderPoint(param1:Number, param2:Number) : FPackageItem
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = NaN;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = null;
            var _loc_13:* = 0;
            if (this._-Od)
            {
                _loc_6 = this._-Od.globalToLocal(param1, param2);
                if (_loc_6.x > 0 && _loc_6.y > 0 && _loc_6.x < this._-Od.width && _loc_6.y < this._-Od.height)
                {
                    _loc_7 = this._-Od.getItemNear(param1, param2);
                    if (_loc_7)
                    {
                        _loc_3 = this._-Cb[this._-Od.childIndexToItemIndex(this._-Od.getChildIndex(_loc_7))];
                        if (_loc_3.type == FPackageItemType.FOLDER)
                        {
                            return _loc_3;
                        }
                    }
                    return this._-71;
                }
            }
            var _loc_5:* = this._treeView.getItemNear(param1, param2);
            if (this._treeView.getItemNear(param1, param2) != null)
            {
                _loc_4 = _loc_5.treeNode;
            }
            else
            {
                _loc_8 = param2;
                _loc_9 = this._treeView.root.numChildren;
                _loc_10 = int.MAX_VALUE;
                _loc_11 = 0;
                while (_loc_11 < _loc_9)
                {
                    
                    _loc_12 = this._treeView.rootNode.getChildAt(_loc_11);
                    _loc_13 = _loc_12.cell.y + _loc_12.cell.height / 2 - _loc_8;
                    if (_loc_13 < _loc_10)
                    {
                        _loc_13 = _loc_10;
                        _loc_4 = _loc_12;
                    }
                    _loc_11++;
                }
                if (_loc_4 == null)
                {
                    return null;
                }
            }
            _loc_3 = FPackageItem(_loc_4.data);
            if (_loc_3.type != FPackageItemType.FOLDER)
            {
                _loc_3 = _loc_3.owner.getItem(_loc_3.path);
            }
            return _loc_3;
        }// end function

        public function _-3H(param1:GTreeNode = null, param2:Array = null) : Array
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (param2 == null)
            {
                param2 = [];
            }
            if (param1 == null)
            {
                param1 = this._treeView.rootNode;
            }
            var _loc_3:* = param1.numChildren;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = param1.getChildAt(_loc_4);
                _loc_6 = FPackageItem(_loc_5.data);
                if (_loc_5.isFolder && _loc_5.expanded)
                {
                    param2.push(_loc_6.owner.id);
                    param2.push(_loc_6.id);
                    if (param2.length < 60)
                    {
                        this._-3H(_loc_5, param2);
                    }
                }
                _loc_4++;
            }
            return param2;
        }// end function

        public function _-1X(param1:Array) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_2:* = param1.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._editor.project.getPackage(param1[_loc_3]);
                if (_loc_4)
                {
                    _loc_5 = _loc_4.getItem(param1[(_loc_3 + 1)]);
                    if (_loc_5)
                    {
                        _loc_6 = this._-5P(_loc_5);
                        if (_loc_6)
                        {
                            _loc_6.expanded = true;
                        }
                    }
                }
                _loc_3 = _loc_3 + 2;
            }
            return;
        }// end function

        public function _-1o(param1:FPackageItem) : Boolean
        {
            if (this._-5P(param1) != null)
            {
                return true;
            }
            if (this._-71 && this._-71.owner == param1.owner && this._-Cb.indexOf(param1) != -1)
            {
                return true;
            }
            return false;
        }// end function

        public function select(param1:FPackageItem) : Boolean
        {
            var _loc_3:* = 0;
            if (!param1)
            {
                return false;
            }
            this._treeView.clearSelection();
            var _loc_2:* = this._-5P(param1.owner.rootItem);
            if (!_loc_2)
            {
                return false;
            }
            _loc_2.expanded = true;
            _loc_2 = this._-5P(param1);
            if (_loc_2)
            {
                this._treeView.selectNode(_loc_2);
                if (_loc_2.cell)
                {
                    this._treeView.scrollPane.scrollToView(_loc_2.cell);
                }
                this._editor.showPreview(param1);
                this._-PL(param1);
                return true;
            }
            else if (this._-Od && this._-Od.visible)
            {
                _loc_2 = this._-5P(param1.parent);
                if (_loc_2)
                {
                    this._treeView.selectNode(_loc_2);
                    if (_loc_2.cell)
                    {
                        this._treeView.scrollPane.scrollToView(_loc_2.cell);
                    }
                    this._-PL(FPackageItem(_loc_2.data));
                }
                _loc_3 = this._-Cb.indexOf(param1);
                if (_loc_3 != -1)
                {
                    this._-Od.clearSelection();
                    this._-Od.addSelection(_loc_3, true);
                    this._editor.showPreview(param1);
                    return true;
                }
            }
            return false;
        }// end function

        public function _-DI(param1:FPackageItem) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            if (this._treeActive)
            {
                _loc_2 = this._-5P(param1);
                if (_loc_2)
                {
                    _loc_3 = _loc_2.getNextSibling();
                    if (_loc_3 == null)
                    {
                        _loc_3 = _loc_2.parent.getNextSibling();
                    }
                    if (_loc_3)
                    {
                        this._treeView.selectNode(_loc_3);
                    }
                }
            }
            else if (this._-Od)
            {
                _loc_4 = this._-Cb.indexOf(param1);
                if (_loc_4 != -1)
                {
                    _loc_4++;
                    if (_loc_4 > (this._-Cb.length - 1))
                    {
                        _loc_4 = this._-Cb.length - 1;
                    }
                    this._-Od.addSelection(_loc_4, true);
                }
            }
            return;
        }// end function

        public function expand(param1:FPackageItem) : void
        {
            var _loc_2:* = this._-5P(param1);
            if (_loc_2)
            {
                _loc_2.expandToRoot();
            }
            return;
        }// end function

        public function rename(param1:FPackageItem = null) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            if (this._-DZ.length > 0)
            {
                this._-FZ();
            }
            if (this._treeActive)
            {
                _loc_2 = this._treeView.getSelectedNode();
                if (!param1 || param1 == _loc_2.data)
                {
                    EditableTreeItem(_loc_2.cell).startEditing(FPackageItem(_loc_2.data).title);
                }
            }
            else if (this._-Od)
            {
                if (param1)
                {
                    _loc_3 = this._-Cb.indexOf(param1);
                    if (_loc_3 != -1)
                    {
                        this._-Od.addSelection(_loc_3, true);
                    }
                }
                else
                {
                    _loc_3 = this._-Od.selectedIndex;
                    if (_loc_3 != -1)
                    {
                        param1 = this._-Cb[_loc_3];
                    }
                }
                if (_loc_3 != -1)
                {
                    _loc_4 = this._-Od.itemIndexToChildIndex(_loc_3);
                    if (_loc_4 >= 0 && _loc_4 < this._-Od.numChildren)
                    {
                        EditableListItem(this._-Od.getChildAt(_loc_4)).startEditing(param1.title);
                    }
                }
            }
            return;
        }// end function

        public function open() : void
        {
            var _loc_1:* = null;
            if (this._treeActive)
            {
                _loc_1 = this._treeView.getSelectedNode();
                if (_loc_1.isFolder)
                {
                    _loc_1.expanded = !_loc_1.expanded;
                }
                else
                {
                    this._editor.libView.openResource(FPackageItem(_loc_1.data));
                }
            }
            else if (this._-Od.selectedIndex != -1)
            {
                this._editor.libView.openResource(this._-Cb[this._-Od.selectedIndex]);
            }
            return;
        }// end function

        private function _-5P(param1:FPackageItem) : GTreeNode
        {
            var _loc_2:* = param1.getVar(this._-6M) as GTreeNode;
            if (_loc_2 && _loc_2.tree)
            {
                return _loc_2;
            }
            return null;
        }// end function

        private function createNode(param1:FPackageItem) : GTreeNode
        {
            var _loc_2:* = new GTreeNode(param1.type == FPackageItemType.FOLDER);
            _loc_2.data = param1;
            param1.setVar(this._-6M, _loc_2);
            return _loc_2;
        }// end function

        private function renderTreeNode(param1:GTreeNode, param2:GComponent) : void
        {
            var _loc_3:* = param2 as EditableTreeItem;
            _loc_3.draggable = true;
            _loc_3.setActive(this._-7n && this._treeActive);
            _loc_3.addEventListener(DragEvent.DRAG_START, this._-5x);
            _loc_3.addEventListener(_-Fr._-CF, this._-2k);
            var _loc_4:* = param1.data as FPackageItem;
            var _loc_5:* = (_loc_4).title;
            if (_loc_4.isError)
            {
                _loc_3.title = "[color=#ff7272]" + _loc_5 + "[/color]";
            }
            else if (param1.isFolder && !_loc_4.folderSettings.empty)
            {
                _loc_3.title = _loc_5 + " [color=#959595][I](" + _loc_4.folderSettings.atlas + ")[/I][/color]";
            }
            else
            {
                _loc_3.title = _loc_5;
            }
            _loc_3.icon = _loc_4.getIcon(param1.expanded);
            var _loc_6:* = param2.getChild("sign") as GLoader;
            if (_loc_4.exported)
            {
                _loc_6.url = "ui://Builder/bullet_red";
            }
            else
            {
                _loc_6.url = null;
            }
            return;
        }// end function

        private function treeNodeWillExpand(param1:GTreeNode, param2:Boolean) : void
        {
            if (!param2 || this._-Dw)
            {
                return;
            }
            var _loc_3:* = param1.data as FPackageItem;
            if (_loc_3 == _loc_3.owner.rootItem && param1.numChildren == 0)
            {
                this._-Fd(param1);
            }
            return;
        }// end function

        private function _-5t(event:ItemEvent) : void
        {
            var _loc_2:* = event.itemObject.treeNode;
            this._-5h(_loc_2, event);
            return;
        }// end function

        private function _-5h(param1:GTreeNode, param2:ItemEvent) : void
        {
            var _loc_3:* = param1.data as FPackageItem;
            var _loc_4:* = _loc_3.type == FPackageItemType.FOLDER;
            if (param2 && param2.rightButton)
            {
                if (this._-Nz != null)
                {
                    this._-Nz(_loc_3, param2);
                }
            }
            if (_loc_4)
            {
                if (!param2 || param2.clickCount == 1)
                {
                    this._-PL(_loc_3, false);
                }
            }
            else if (param2 && param2.clickCount == 2)
            {
                this._editor.libView.openResource(_loc_3);
            }
            this._editor.showPreview(this.getSelectedResource());
            return;
        }// end function

        private function _-5x(event:DragEvent) : void
        {
            event.preventDefault();
            if (!this._-O1)
            {
                return;
            }
            var _loc_2:* = GButton(event.currentTarget);
            if (!_loc_2.selected)
            {
                this._treeView.clearSelection();
                this._treeView.selectNode(_loc_2.treeNode);
            }
            var _loc_3:* = this.getSelectedResources();
            this._editor.dragManager.startDrag(this._editor.libView, _loc_3);
            return;
        }// end function

        private function _-2k(param1:_-Fr) : void
        {
            var node:GTreeNode;
            var pi:FPackageItem;
            var evt:* = param1;
            node = GObject(evt.currentTarget).treeNode;
            pi = node.data as FPackageItem;
            if (pi.isBranchRoot)
            {
                this._editor.confirm(Consts.strings.text435, function (param1:String) : void
            {
                var ret:* = param1;
                if (ret == "ok")
                {
                    try
                    {
                        pi.owner.project.renameBranch(pi.branch, node.text);
                    }
                    catch (err:Error)
                    {
                        renderTreeNode(node, node.cell);
                        _editor.alert(null, err);
                    }
                }
                else
                {
                    renderTreeNode(node, node.cell);
                }
                return;
            }// end function
            );
            }
            else
            {
                try
                {
                    pi.owner.renameItem(pi, node.text);
                }
                catch (err:Error)
                {
                    renderTreeNode(node, node.cell);
                    _editor.alert(null, err);
                }
            }
            return;
        }// end function

        private function _-PL(param1:FPackageItem, param2:Boolean = true) : void
        {
            var _loc_5:* = null;
            if (!this._-Od || !this._-Od.visible)
            {
                return;
            }
            var _loc_3:* = this._-71 == param1;
            if (_loc_3 && !param2)
            {
                return;
            }
            var _loc_4:* = this._-Od.selectedIndex;
            if (this._-Od.selectedIndex != -1)
            {
                _loc_5 = this._-Cb[_loc_4];
            }
            this._-Od.clearSelection();
            this._-71 = param1;
            this._-Cb.length = 0;
            this._-FC(param1, null, this._-Cb);
            this._-Od.numItems = this._-Cb.length;
            if (_loc_3)
            {
                _loc_4 = this._-Cb.indexOf(_loc_5);
                if (_loc_4 != -1)
                {
                    this._-Od.addSelection(_loc_4, true);
                }
            }
            return;
        }// end function

        private function renderListItem(param1:int, param2:GObject) : void
        {
            var _loc_3:* = this._-Cb[param1];
            var _loc_4:* = _loc_3.title;
            param2.asButton.getTextField().ubbEnabled = true;
            if (_loc_3.isError)
            {
                param2.text = "[color=#ff7272]" + _loc_4 + "[/color]";
            }
            else if (_loc_3.folderSettings && !_loc_3.folderSettings.empty)
            {
                param2.text = _loc_4 + " [color=#959595][I](" + _loc_3.folderSettings.atlas + ")[/I][/color]";
            }
            else
            {
                param2.text = _loc_4;
            }
            param2.icon = _loc_3.getIcon();
            var _loc_5:* = param2.asCom.getChild("sign") as GLoader;
            if (_loc_3.exported)
            {
                _loc_5.url = "ui://Builder/bullet_red";
            }
            else
            {
                _loc_5.url = null;
            }
            param2.draggable = true;
            EditableListItem(param2).setActive(!this._treeActive && this._-7n);
            param2.data = _loc_3;
            param2.addEventListener(DragEvent.DRAG_START, this._-Bh);
            param2.addEventListener(_-Fr._-CF, this._-Fx);
            return;
        }// end function

        private function __clickItem(event:ItemEvent) : void
        {
            var _loc_2:* = FPackageItem(event.itemObject.data);
            this._editor.showPreview(_loc_2);
            if (event.clickCount == 2)
            {
                if (_loc_2.type == FPackageItemType.FOLDER)
                {
                    this.select(_loc_2);
                }
                else
                {
                    this._editor.libView.openResource(_loc_2);
                }
            }
            else if (event.rightButton && this._-Nz != null)
            {
                this._-Nz(_loc_2, event);
            }
            return;
        }// end function

        private function _-Bh(event:DragEvent) : void
        {
            event.preventDefault();
            if (!this._-O1)
            {
                return;
            }
            var _loc_2:* = GButton(event.currentTarget);
            if (!_loc_2.selected)
            {
                this._-Od.clearSelection();
                this._-Od.addSelection(this._-Od.childIndexToItemIndex(this._-Od.getChildIndex(_loc_2)));
            }
            var _loc_3:* = this.getSelectedResources();
            this._editor.dragManager.startDrag(this._editor.libView, _loc_3);
            return;
        }// end function

        private function _-Fx(event:Event) : void
        {
            var btn:GObject;
            var index:int;
            var pi:FPackageItem;
            var evt:* = event;
            btn = GObject(evt.currentTarget);
            index = this._-Od.childIndexToItemIndex(this._-Od.getChildIndex(btn));
            pi = this._-Cb[index];
            if (pi.isBranchRoot)
            {
                this._editor.confirm(Consts.strings.text435, function (param1:String) : void
            {
                var ret:* = param1;
                if (ret == "ok")
                {
                    try
                    {
                        pi.owner.project.renameBranch(pi.branch, btn.text);
                    }
                    catch (err:Error)
                    {
                        renderListItem(index, btn);
                        _editor.alert(null, err);
                    }
                }
                else
                {
                    renderListItem(index, btn);
                }
                return;
            }// end function
            );
            }
            else
            {
                try
                {
                    pi.owner.renameItem(pi, btn.text);
                }
                catch (err:Error)
                {
                    renderListItem(index, btn);
                    _editor.alert(null, err);
                }
            }
            return;
        }// end function

        public function handleKeyEvent(param1:_-4U) : void
        {
            var _loc_2:* = null;
            if (param1._-2h != 0)
            {
                if (this._treeActive)
                {
                    this._treeView.handleArrowKey(param1._-2h);
                }
                else if (this._-Od)
                {
                    this._-Od.handleArrowKey(param1._-2h);
                }
                _loc_2 = this._treeView.getSelectedNode();
                if (_loc_2)
                {
                    this._-5h(_loc_2, null);
                }
                return;
            }
            if (param1._-8r != null)
            {
                if (this._treeActive)
                {
                    this._-B0(param1._-8r);
                }
                else
                {
                    this._-8F(param1._-8r);
                }
            }
            return;
        }// end function

        private function _-B0(param1:String) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_2:* = this._treeView.getSelectedNode();
            if (!_loc_2)
            {
                _loc_2 = this._treeView.rootNode.getChildAt(0);
            }
            if (_loc_2)
            {
                _loc_3 = _loc_2.parent.getChildIndex(_loc_2);
                _loc_4 = _loc_2.parent.numChildren;
                if (_loc_4 == 0)
                {
                    return;
                }
                _loc_7 = _loc_3;
                while (_loc_7 < _loc_4)
                {
                    
                    _loc_8 = _loc_2.parent.getChildAt(_loc_7);
                    _loc_5 = FPackageItem(_loc_8.data);
                    if (_loc_5.matchName(param1))
                    {
                        _loc_6 = _loc_8;
                        break;
                    }
                    _loc_7++;
                }
                if (!_loc_6)
                {
                    _loc_7 = 0;
                    while (_loc_7 < _loc_3)
                    {
                        
                        _loc_8 = _loc_2.parent.getChildAt(_loc_7);
                        _loc_5 = FPackageItem(_loc_8.data);
                        if (_loc_5.matchName(param1))
                        {
                            _loc_6 = _loc_8;
                            break;
                        }
                        _loc_7++;
                    }
                }
                if (_loc_6)
                {
                    this._treeView.clearSelection();
                    this._treeView.selectNode(_loc_6, true);
                    this._-5h(_loc_6, null);
                }
            }
            return;
        }// end function

        private function _-8F(param1:String) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_2:* = this._-Od.selectedIndex;
            if (_loc_2 == -1)
            {
                _loc_2 = 0;
            }
            var _loc_3:* = this._-Cb.length;
            if (_loc_3 == 0)
            {
                return;
            }
            var _loc_4:* = -1;
            _loc_6 = _loc_2;
            while (_loc_6 < _loc_3)
            {
                
                _loc_5 = this._-Cb[_loc_6];
                if (_loc_5.matchName(param1))
                {
                    _loc_4 = _loc_6;
                    break;
                }
                _loc_6++;
            }
            if (_loc_4 == -1)
            {
                _loc_6 = 0;
                while (_loc_6 < _loc_2)
                {
                    
                    _loc_5 = this._-Cb[_loc_6];
                    if (_loc_5.matchName(param1))
                    {
                        _loc_4 = _loc_6;
                        break;
                    }
                    _loc_6++;
                }
            }
            if (_loc_4 != -1)
            {
                this._-Od.clearSelection();
                this._-Od.addSelection(_loc_4, true);
                this._editor.showPreview(FPackageItem(this._-Cb[_loc_4]));
            }
            return;
        }// end function

        public function setActive(param1:Boolean) : void
        {
            if (this._-7n != param1)
            {
                this._-7n = param1;
                this.handleActiveChanged();
            }
            return;
        }// end function

        private function handleActiveChanged() : void
        {
            var _loc_4:* = null;
            var _loc_1:* = this._treeActive && this._-7n;
            var _loc_2:* = this._treeView.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = EditableTreeItem(this._treeView.getChildAt(_loc_3));
                _loc_4.setActive(_loc_1);
                _loc_3++;
            }
            if (this._-Od)
            {
                _loc_1 = !this._treeActive && this._-7n;
                _loc_2 = this._-Od.numChildren;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    EditableListItem(this._-Od.getChildAt(_loc_3)).setActive(_loc_1);
                    _loc_3++;
                }
            }
            return;
        }// end function

        private function _-6b(event:Event) : void
        {
            var _loc_2:* = this._-Dk.dragBounds;
            _loc_2.x = this._treeView.x + Math.min(100, this._treeView.width);
            _loc_2.right = this._-Od.x + this._-Od.width - Math.min(100, this._-Od.width) - 1;
            _loc_2.y = this._-Dk.y;
            _loc_2.height = 0;
            this._-Dk.dragBounds = this._-Dk.parent.localToGlobalRect(_loc_2.x, _loc_2.y, _loc_2.width, _loc_2.height, _loc_2);
            return;
        }// end function

        private function _-1g(event:Event) : void
        {
            var _loc_2:* = NaN;
            this._treeView.width = this._-Dk.x - this._treeView.x;
            _loc_2 = this._-Dk.x + this._-Dk.width;
            this._-Od.width = this._-Od.width + (this._-Od.x - _loc_2);
            this._-Od.x = _loc_2;
            return;
        }// end function

        private function _-80(param1:GTreeNode) : void
        {
            if (!param1.isFolder)
            {
                param1 = param1.parent;
            }
            if (this._-DZ.indexOf(param1) == -1)
            {
                if (this._-DZ.length == 0)
                {
                    this._editor.on(EditorEvent.OnLateUpdate, this._-4v);
                }
                this._-DZ.push(param1);
            }
            return;
        }// end function

        private function _-FZ() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = false;
            var _loc_8:* = null;
            var _loc_9:* = false;
            var _loc_10:* = 0;
            this._-Dw = true;
            for each (_loc_2 in this._-DZ)
            {
                
                if (!_loc_2.tree)
                {
                    continue;
                }
                this._-Is.length = 0;
                _loc_1 = FPackageItem(_loc_2.data);
                if (_loc_1 == null)
                {
                    _loc_9 = true;
                    this._-FC(null, null, this._-Is);
                }
                else
                {
                    if (this._-71 == _loc_1)
                    {
                        this._-PL(this._-71);
                    }
                    this._-FC(_loc_1, this._-Od && this._-Od.visible ? (_-Gj) : (null), this._-Is);
                }
                _loc_6 = 0;
                for each (_loc_3 in this._-Is)
                {
                    
                    _loc_4 = this._-5P(_loc_3);
                    if (_loc_4)
                    {
                        if (_loc_4.parent == _loc_2)
                        {
                            _loc_2.setChildIndex(_loc_4, _loc_6++);
                            _loc_7 = false;
                        }
                        else
                        {
                            _loc_2.addChildAt(_loc_4, _loc_6++);
                            _loc_7 = true;
                        }
                    }
                    else
                    {
                        _loc_7 = true;
                        _loc_4 = this.createNode(_loc_3);
                        _loc_2.addChildAt(_loc_4, _loc_6++);
                        if (_loc_4.isFolder && _loc_3 != _loc_3.owner.rootItem)
                        {
                            this._-Fd(_loc_4);
                        }
                    }
                    if (_loc_7)
                    {
                        if (!_loc_8)
                        {
                            this._treeView.clearSelection();
                        }
                        _loc_8 = _loc_4;
                        this._treeView.selectNode(_loc_8);
                    }
                }
                _loc_2.removeChildren(_loc_6, _loc_2.numChildren);
            }
            if (_loc_8)
            {
                if (_loc_8.cell)
                {
                    this._treeView.scrollPane.scrollToView(_loc_8.cell);
                }
                this._editor.showPreview(FPackageItem(_loc_8.data));
            }
            if (_loc_9)
            {
                _loc_10 = this._treeView.selectedIndex;
                this._treeView.clearSelection();
                if (_loc_10 != -1)
                {
                    this._treeView.addSelection(_loc_10, true);
                }
            }
            _loc_12.length = 0;
            _loc_14.length = 0;
            this._-Dw = false;
            this._editor.off(EditorEvent.OnLateUpdate, this._-4v);
            return;
        }// end function

    }
}
