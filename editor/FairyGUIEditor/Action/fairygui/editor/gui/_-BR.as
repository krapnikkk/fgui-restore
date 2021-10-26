package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.event.*;
    import flash.events.*;

    public class _-BR extends FTreeNode
    {
        public var treeNodeRender:Function;
        public var treeNodeWillExpand:Function;
        private var _list:FList;
        private var _indent:int;
        var _expandedStatusInEvt:Boolean;
        private static var helperIntList:Vector.<int> = new Vector.<int>;

        public function _-BR(param1:FList)
        {
            super(true);
            this._list = param1;
            this._indent = 15;
            setTree(this);
            expanded = true;
            return;
        }// end function

        final public function get indent() : int
        {
            return this._indent;
        }// end function

        final public function set indent(param1:int) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (this._indent != param1)
            {
                this._indent = param1;
                _loc_2 = this._list.numChildren;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = this._list.getChildAt(_loc_3) as FComponent;
                    if (!_loc_4)
                    {
                    }
                    else
                    {
                        _loc_5 = _loc_4._treeNode;
                        if (!_loc_5)
                        {
                        }
                        else
                        {
                            _loc_6 = _loc_4.getChild("indent");
                            if (!_loc_6)
                            {
                            }
                            else
                            {
                                _loc_6.width = (_loc_5.level - 1) * this._indent;
                            }
                        }
                    }
                    _loc_3++;
                }
            }
            return;
        }// end function

        public function getSelectedNode() : FTreeNode
        {
            if (this._list.selectedIndex != -1)
            {
                return this._list.getChildAt(this._list.selectedIndex)._treeNode;
            }
            return null;
        }// end function

        public function getSelectedNodes(param1:Vector.<FTreeNode> = null) : Vector.<FTreeNode>
        {
            var _loc_5:* = null;
            if (param1 == null)
            {
                param1 = new Vector.<FTreeNode>;
            }
            helperIntList.length = 0;
            this._list.getSelection(helperIntList);
            var _loc_2:* = helperIntList.length;
            var _loc_3:* = new Vector.<FTreeNode>;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_5 = this._list.getChildAt(helperIntList[_loc_4])._treeNode;
                _loc_3.push(_loc_5);
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public function selectNode(param1:FTreeNode, param2:Boolean = false) : void
        {
            var _loc_3:* = param1.parent;
            while (_loc_3 != null && _loc_3 != this)
            {
                
                _loc_3.expanded = true;
                _loc_3 = _loc_3.parent;
            }
            if (!param1._cell)
            {
                return;
            }
            this._list.addSelection(this._list.getChildIndex(param1._cell), param2);
            return;
        }// end function

        public function unselectNode(param1:FTreeNode) : void
        {
            if (!param1._cell)
            {
                return;
            }
            this._list.removeSelection(this._list.getChildIndex(param1._cell));
            return;
        }// end function

        public function _-LW(param1:FTreeNode) : int
        {
            return this._list.getChildIndex(param1._cell);
        }// end function

        public function _-1n(param1:FTreeNode) : void
        {
            if (param1._cell == null)
            {
                return;
            }
            if (this.treeNodeRender != null)
            {
                this.treeNodeRender(param1, param1._cell);
            }
            return;
        }// end function

        public function _-Ll(param1:Vector.<FTreeNode>) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = param1.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = param1[_loc_3];
                if (_loc_4._cell == null)
                {
                    return;
                }
                if (this.treeNodeRender != null)
                {
                    this.treeNodeRender(_loc_4, _loc_4._cell);
                }
                _loc_3++;
            }
            return;
        }// end function

        public function expandAll(param1:FTreeNode = null) : void
        {
            var _loc_4:* = null;
            if (param1 == null)
            {
                param1 = this;
            }
            param1.expanded = true;
            var _loc_2:* = param1.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = param1.getChildAt(_loc_3);
                if (_loc_4.isFolder)
                {
                    this.expandAll(_loc_4);
                }
                _loc_3++;
            }
            return;
        }// end function

        public function collapseAll(param1:FTreeNode = null) : void
        {
            var _loc_4:* = null;
            if (param1 == null)
            {
                param1 = this;
            }
            if (param1 != this)
            {
                param1.expanded = false;
            }
            var _loc_2:* = param1.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = param1.getChildAt(_loc_3);
                if (_loc_4.isFolder)
                {
                    this.collapseAll(_loc_4);
                }
                _loc_3++;
            }
            return;
        }// end function

        public function createCell(param1:FTreeNode) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = param1._resURL;
            if (!_loc_2)
            {
                _loc_2 = this._list.defaultItem;
            }
            if (!_loc_2)
            {
                return;
            }
            var _loc_4:* = this._list._pkg.project.getItemByURL(_loc_2);
            if (this._list._pkg.project.getItemByURL(_loc_2) == null)
            {
                _loc_3 = FObjectFactory.createObject2(this._list._pkg, "component", MissingInfo.create2(this._list._pkg, _loc_2), this._list._flags & 255);
            }
            else
            {
                _loc_3 = FObjectFactory.createObject(_loc_4, this._list._flags & 255);
                if (!_loc_3 is FComponent)
                {
                    _loc_3.dispose();
                    _loc_3 = FObjectFactory.createObject2(this._list._pkg, "component", null, this._list._flags & 255);
                }
            }
            var _loc_5:* = _loc_3 as FComponent;
            _loc_3._treeNode = param1;
            param1._cell = _loc_5;
            var _loc_6:* = _loc_5.getChild("indent");
            if (_loc_5.getChild("indent") != null)
            {
                _loc_6.width = (param1.level - 1) * this._indent;
            }
            var _loc_7:* = _loc_5.getController("expanded");
            if (_loc_5.getController("expanded"))
            {
                _loc_7.addEventListener(StateChangeEvent.CHANGED, this.__expandedStateChanged);
                _loc_7.selectedIndex = param1.expanded ? (1) : (0);
            }
            _loc_5.addEventListener(GTouchEvent.BEGIN, this.__cellMouseDown);
            _loc_7 = _loc_5.getController("leaf");
            if (_loc_7)
            {
                _loc_7.selectedIndex = param1.isFolder ? (0) : (1);
            }
            if (this.treeNodeRender != null)
            {
                this.treeNodeRender(param1, _loc_5);
            }
            return;
        }// end function

        function afterInserted(param1:FTreeNode) : void
        {
            if (!param1._cell)
            {
                this.createCell(param1);
            }
            var _loc_2:* = this.getInsertIndexForNode(param1);
            this._list.addChildAt(param1._cell, _loc_2);
            if (this.treeNodeRender != null)
            {
                this.treeNodeRender(param1, param1._cell);
            }
            if (param1.isFolder && param1.expanded)
            {
                this.checkChildren(param1, _loc_2);
            }
            return;
        }// end function

        private function getInsertIndexForNode(param1:FTreeNode) : int
        {
            var _loc_7:* = null;
            var _loc_2:* = param1.getPrevSibling();
            if (_loc_2 == null)
            {
                _loc_2 = param1.parent;
            }
            var _loc_3:* = this._list.getChildIndex(_loc_2._cell) + 1;
            var _loc_4:* = param1.level;
            var _loc_5:* = this._list.numChildren;
            var _loc_6:* = _loc_3;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = this._list.getChildAt(_loc_6)._treeNode;
                if (_loc_7.level <= _loc_4)
                {
                    break;
                }
                _loc_3++;
                _loc_6++;
            }
            return _loc_3;
        }// end function

        function afterRemoved(param1:FTreeNode) : void
        {
            this.removeNode(param1);
            return;
        }// end function

        function afterExpanded(param1:FTreeNode) : void
        {
            if (param1 == this)
            {
                this.checkChildren(this, 0);
                return;
            }
            if (this.treeNodeWillExpand != null)
            {
                this.treeNodeWillExpand(param1, true);
            }
            if (param1._cell == null)
            {
                return;
            }
            if (this.treeNodeRender != null)
            {
                this.treeNodeRender(param1, param1._cell);
            }
            var _loc_2:* = param1._cell.getController("expanded");
            if (_loc_2)
            {
                _loc_2.selectedIndex = 1;
            }
            if (param1._cell.parent != null)
            {
                this.checkChildren(param1, this._list.getChildIndex(param1._cell));
            }
            return;
        }// end function

        function afterCollapsed(param1:FTreeNode) : void
        {
            if (param1 == this)
            {
                this.checkChildren(this, 0);
                return;
            }
            if (this.treeNodeWillExpand != null)
            {
                this.treeNodeWillExpand(param1, false);
            }
            if (param1._cell == null)
            {
                return;
            }
            if (this.treeNodeRender != null)
            {
                this.treeNodeRender(param1, param1._cell);
            }
            var _loc_2:* = param1._cell.getController("expanded");
            if (_loc_2)
            {
                _loc_2.selectedIndex = 0;
            }
            if (param1._cell.parent != null)
            {
                this.hideFolderNode(param1);
            }
            return;
        }// end function

        function afterMoved(param1:FTreeNode) : void
        {
            var _loc_3:* = 0;
            var _loc_5:* = 0;
            var _loc_7:* = null;
            var _loc_2:* = this._list.getChildIndex(param1._cell);
            if (param1.isFolder)
            {
                _loc_3 = this.getFolderEndIndex(_loc_2, param1.level);
            }
            else
            {
                _loc_3 = _loc_2 + 1;
            }
            var _loc_4:* = this.getInsertIndexForNode(param1);
            var _loc_6:* = _loc_3 - _loc_2;
            if (_loc_4 < _loc_2)
            {
                _loc_5 = 0;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_7 = this._list.getChildAt(_loc_2 + _loc_5);
                    this._list.setChildIndex(_loc_7, _loc_4 + _loc_5);
                    _loc_5++;
                }
            }
            else
            {
                _loc_5 = 0;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_7 = this._list.getChildAt(_loc_2);
                    this._list.setChildIndex(_loc_7, _loc_4);
                    _loc_5++;
                }
            }
            return;
        }// end function

        private function getFolderEndIndex(param1:int, param2:int) : int
        {
            var _loc_5:* = null;
            var _loc_3:* = this._list.numChildren;
            var _loc_4:* = param1 + 1;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = this._list.getChildAt(_loc_4)._treeNode;
                if (_loc_5.level <= param2)
                {
                    return _loc_4;
                }
                _loc_4++;
            }
            return _loc_3;
        }// end function

        private function checkChildren(param1:FTreeNode, param2:int) : int
        {
            var _loc_5:* = null;
            var _loc_3:* = param1.numChildren;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                param2++;
                _loc_5 = param1.getChildAt(_loc_4);
                if (_loc_5._cell == null)
                {
                    this.createCell(_loc_5);
                }
                if (!_loc_5._cell.parent)
                {
                    this._list.addChildAt(_loc_5._cell, param2);
                }
                if (_loc_5.isFolder && _loc_5.expanded)
                {
                    param2 = this.checkChildren(_loc_5, param2);
                }
                _loc_4++;
            }
            return param2;
        }// end function

        private function hideFolderNode(param1:FTreeNode) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = param1.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = param1.getChildAt(_loc_3);
                if (_loc_4._cell && _loc_4._cell.parent != null)
                {
                    this._list.removeChild(_loc_4._cell);
                }
                if (_loc_4.isFolder && _loc_4.expanded)
                {
                    this.hideFolderNode(_loc_4);
                }
                _loc_3++;
            }
            return;
        }// end function

        private function removeNode(param1:FTreeNode) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            if (param1._cell != null)
            {
                if (param1._cell.parent != null)
                {
                    this._list.removeChild(param1._cell);
                }
                param1._cell.dispose();
                param1._cell._treeNode = null;
                param1._cell = null;
            }
            if (param1.isFolder)
            {
                _loc_2 = param1.numChildren;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = param1.getChildAt(_loc_3);
                    this.removeNode(_loc_4);
                    _loc_3++;
                }
            }
            return;
        }// end function

        private function __cellMouseDown(event:Event) : void
        {
            var _loc_2:* = event.currentTarget._treeNode;
            this._expandedStatusInEvt = _loc_2.expanded;
            return;
        }// end function

        private function __expandedStateChanged(event:Event) : void
        {
            var _loc_2:* = FController(event.currentTarget);
            var _loc_3:* = _loc_2.parent._treeNode;
            _loc_3.expanded = _loc_2.selectedIndex == 1;
            return;
        }// end function

    }
}
