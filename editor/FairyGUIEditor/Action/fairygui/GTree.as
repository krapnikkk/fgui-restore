package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.event.*;
    import flash.events.*;

    public class GTree extends GList
    {
        public var treeNodeRender:Function;
        public var treeNodeWillExpand:Function;
        private var _indent:int;
        private var _clickToExpand:int;
        private var _rootNode:GTreeNode;
        private var _expandedStatusInEvt:Boolean;
        private static var helperIntList:Vector.<int> = new Vector.<int>;

        public function GTree()
        {
            _indent = 15;
            _rootNode = new GTreeNode(true);
            _rootNode.setTree(this);
            _rootNode.expanded = true;
            return;
        }// end function

        public function get rootNode() : GTreeNode
        {
            return _rootNode;
        }// end function

        final public function get indent() : int
        {
            return _indent;
        }// end function

        final public function set indent(param1:int) : void
        {
            _indent = param1;
            return;
        }// end function

        final public function get clickToExpand() : int
        {
            return _clickToExpand;
        }// end function

        final public function set clickToExpand(param1:int) : void
        {
            _clickToExpand = param1;
            return;
        }// end function

        public function getSelectedNode() : GTreeNode
        {
            if (this.selectedIndex != -1)
            {
                return this.getChildAt(this.selectedIndex)._treeNode;
            }
            return null;
        }// end function

        public function getSelectedNodes(param1:Vector.<GTreeNode> = null) : Vector.<GTreeNode>
        {
            var _loc_5:* = 0;
            var _loc_3:* = null;
            if (param1 == null)
            {
                param1 = new Vector.<GTreeNode>;
            }
            helperIntList.length = 0;
            super.getSelection(helperIntList);
            var _loc_4:* = helperIntList.length;
            var _loc_2:* = new Vector.<GTreeNode>;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_3 = this.getChildAt(helperIntList[_loc_5])._treeNode;
                _loc_2.push(_loc_3);
                _loc_5++;
            }
            return _loc_2;
        }// end function

        public function selectNode(param1:GTreeNode, param2:Boolean = false) : void
        {
            var _loc_3:* = param1.parent;
            while (_loc_3 != null && _loc_3 != _rootNode)
            {
                
                _loc_3.expanded = true;
                _loc_3 = _loc_3.parent;
            }
            if (!param1._cell)
            {
                return;
            }
            this.addSelection(this.getChildIndex(param1._cell), param2);
            return;
        }// end function

        public function unselectNode(param1:GTreeNode) : void
        {
            if (!param1._cell)
            {
                return;
            }
            this.removeSelection(this.getChildIndex(param1._cell));
            return;
        }// end function

        public function expandAll(param1:GTreeNode = null) : void
        {
            var _loc_4:* = 0;
            var _loc_2:* = null;
            if (param1 == null)
            {
                param1 = _rootNode;
            }
            param1.expanded = true;
            var _loc_3:* = param1.numChildren;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = param1.getChildAt(_loc_4);
                if (_loc_2.isFolder)
                {
                    expandAll(_loc_2);
                }
                _loc_4++;
            }
            return;
        }// end function

        public function collapseAll(param1:GTreeNode = null) : void
        {
            var _loc_4:* = 0;
            var _loc_2:* = null;
            if (param1 == null)
            {
                param1 = _rootNode;
            }
            if (param1 != _rootNode)
            {
                param1.expanded = false;
            }
            var _loc_3:* = param1.numChildren;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = param1.getChildAt(_loc_4);
                if (_loc_2.isFolder)
                {
                    collapseAll(_loc_2);
                }
                _loc_4++;
            }
            return;
        }// end function

        private function createCell(param1:GTreeNode) : void
        {
            var _loc_2:* = null;
            var _loc_4:* = getFromPool(param1._resURL) as GComponent;
            if (!(getFromPool(param1._resURL) as GComponent))
            {
                throw new Error("cannot create tree node object.");
            }
            _loc_4._treeNode = param1;
            param1._cell = _loc_4;
            var _loc_3:* = _loc_4.getChild("indent");
            if (_loc_3 != null)
            {
                _loc_3.width = (param1.level - 1) * _indent;
            }
            _loc_2 = _loc_4.getController("expanded");
            if (_loc_2)
            {
                _loc_2.addEventListener("stateChanged", __expandedStateChanged);
                _loc_2.selectedIndex = param1.expanded ? (1) : (0);
            }
            if (param1.isFolder)
            {
                _loc_4.addEventListener("beginGTouch", __cellMouseDown);
            }
            _loc_2 = _loc_4.getController("leaf");
            if (_loc_2)
            {
                _loc_2.selectedIndex = param1.isFolder ? (0) : (1);
            }
            if (treeNodeRender != null)
            {
                this.treeNodeRender(param1, _loc_4);
            }
            return;
        }// end function

        function afterInserted(param1:GTreeNode) : void
        {
            if (!param1._cell)
            {
                createCell(param1);
            }
            var _loc_2:* = getInsertIndexForNode(param1);
            this.addChildAt(param1._cell, _loc_2);
            if (treeNodeRender != null)
            {
                this.treeNodeRender(param1, param1._cell);
            }
            if (param1.isFolder && param1.expanded)
            {
                checkChildren(param1, _loc_2);
            }
            return;
        }// end function

        private function getInsertIndexForNode(param1:GTreeNode) : int
        {
            var _loc_7:* = 0;
            var _loc_3:* = null;
            var _loc_2:* = param1.getPrevSibling();
            if (_loc_2 == null)
            {
                _loc_2 = param1.parent;
            }
            var _loc_4:* = this.getChildIndex(_loc_2._cell) + 1;
            var _loc_5:* = param1.level;
            var _loc_6:* = this.numChildren;
            _loc_7 = _loc_4;
            while (_loc_7 < _loc_6)
            {
                
                _loc_3 = this.getChildAt(_loc_7)._treeNode;
                if (_loc_3.level > _loc_5)
                {
                    _loc_4++;
                    _loc_7++;
                }
            }
            return _loc_4;
        }// end function

        function afterRemoved(param1:GTreeNode) : void
        {
            removeNode(param1);
            return;
        }// end function

        function afterExpanded(param1:GTreeNode) : void
        {
            if (param1 == _rootNode)
            {
                checkChildren(_rootNode, 0);
                return;
            }
            if (treeNodeWillExpand != null)
            {
                this.treeNodeWillExpand(param1, true);
            }
            if (param1._cell == null)
            {
                return;
            }
            if (treeNodeRender != null)
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
                checkChildren(param1, this.getChildIndex(param1._cell));
            }
            return;
        }// end function

        function afterCollapsed(param1:GTreeNode) : void
        {
            if (param1 == _rootNode)
            {
                checkChildren(_rootNode, 0);
                return;
            }
            if (treeNodeWillExpand != null)
            {
                this.treeNodeWillExpand(param1, false);
            }
            if (param1._cell == null)
            {
                return;
            }
            if (treeNodeRender != null)
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
                hideFolderNode(param1);
            }
            return;
        }// end function

        function afterMoved(param1:GTreeNode) : void
        {
            var _loc_3:* = 0;
            var _loc_7:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = this.getChildIndex(param1._cell);
            if (param1.isFolder)
            {
                _loc_3 = getFolderEndIndex(_loc_2, param1.level);
            }
            else
            {
                _loc_3 = _loc_2 + 1;
            }
            var _loc_5:* = getInsertIndexForNode(param1);
            var _loc_6:* = _loc_3 - _loc_2;
            if (_loc_5 < _loc_2)
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_4 = this.getChildAt(_loc_2 + _loc_7);
                    this.setChildIndex(_loc_4, _loc_5 + _loc_7);
                    _loc_7++;
                }
            }
            else
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_4 = this.getChildAt(_loc_2);
                    this.setChildIndex(_loc_4, _loc_5);
                    _loc_7++;
                }
            }
            return;
        }// end function

        private function getFolderEndIndex(param1:int, param2:int) : int
        {
            var _loc_5:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = this.numChildren;
            _loc_5 = param1 + 1;
            while (_loc_5 < _loc_4)
            {
                
                _loc_3 = this.getChildAt(_loc_5)._treeNode;
                if (_loc_3.level <= param2)
                {
                    return _loc_5;
                }
                _loc_5++;
            }
            return _loc_4;
        }// end function

        private function checkChildren(param1:GTreeNode, param2:int) : int
        {
            var _loc_5:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = param1.numChildren;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                param2++;
                _loc_3 = param1.getChildAt(_loc_5);
                if (_loc_3._cell == null)
                {
                    createCell(_loc_3);
                }
                if (!_loc_3._cell.parent)
                {
                    this.addChildAt(_loc_3._cell, param2);
                }
                if (_loc_3.isFolder && _loc_3.expanded)
                {
                    param2 = checkChildren(_loc_3, param2);
                }
                _loc_5++;
            }
            return param2;
        }// end function

        private function hideFolderNode(param1:GTreeNode) : void
        {
            var _loc_4:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = param1.numChildren;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = param1.getChildAt(_loc_4);
                if (_loc_2._cell && _loc_2._cell.parent != null)
                {
                    this.removeChild(_loc_2._cell);
                }
                if (_loc_2.isFolder && _loc_2.expanded)
                {
                    hideFolderNode(_loc_2);
                }
                _loc_4++;
            }
            return;
        }// end function

        private function removeNode(param1:GTreeNode) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_2:* = null;
            if (param1._cell != null)
            {
                if (param1._cell.parent != null)
                {
                    this.removeChild(param1._cell);
                }
                this.returnToPool(param1._cell);
                param1._cell._treeNode = null;
                param1._cell = null;
            }
            if (param1.isFolder)
            {
                _loc_3 = param1.numChildren;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_2 = param1.getChildAt(_loc_4);
                    removeNode(_loc_2);
                    _loc_4++;
                }
            }
            return;
        }// end function

        private function __cellMouseDown(event:Event) : void
        {
            var _loc_2:* = event.currentTarget._treeNode;
            _expandedStatusInEvt = _loc_2.expanded;
            return;
        }// end function

        private function __expandedStateChanged(event:Event) : void
        {
            var _loc_2:* = this.Controller(event.currentTarget);
            var _loc_3:* = _loc_2.parent._treeNode;
            _loc_3.expanded = _loc_2.selectedIndex == 1;
            return;
        }// end function

        override protected function dispatchItemEvent(event:ItemEvent) : void
        {
            var _loc_2:* = null;
            if (_clickToExpand != 0 && !event.rightButton)
            {
                _loc_2 = event.itemObject._treeNode;
                if (_loc_2 && _expandedStatusInEvt == _loc_2.expanded)
                {
                    if (_clickToExpand == 2)
                    {
                        if (event.clickCount == 2)
                        {
                            _loc_2.expanded = !_loc_2.expanded;
                        }
                    }
                    else
                    {
                        _loc_2.expanded = !_loc_2.expanded;
                    }
                }
            }
            super.dispatchItemEvent(event);
            return;
        }// end function

        override protected function readItems(param1:XML) : void
        {
            var _loc_12:* = null;
            var _loc_3:* = 0;
            var _loc_6:* = 0;
            var _loc_11:* = 0;
            var _loc_5:* = 0;
            var _loc_13:* = null;
            var _loc_8:* = null;
            var _loc_10:* = null;
            var _loc_7:* = 0;
            var _loc_9:* = param1.@indent;
            if (param1.@indent)
            {
                _indent = this.parseInt(_loc_9);
            }
            _loc_9 = param1.@clickToExpand;
            if (_loc_9)
            {
                _clickToExpand = this.parseInt(_loc_9);
            }
            var _loc_2:* = param1.item;
            var _loc_4:* = _loc_2.length();
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_13 = _loc_2[_loc_5];
                _loc_8 = _loc_13.@url;
                if (_loc_5 == 0)
                {
                    _loc_3 = this.parseInt(_loc_13.@level);
                }
                else
                {
                    _loc_3 = _loc_6;
                }
                if (_loc_5 < (_loc_4 - 1))
                {
                    _loc_6 = this.parseInt(_loc_2[(_loc_5 + 1)].@level);
                }
                else
                {
                    _loc_6 = 0;
                }
                _loc_10 = new GTreeNode(_loc_6 > _loc_3, _loc_8);
                _loc_10.expanded = true;
                if (_loc_5 == 0)
                {
                    _rootNode.addChild(_loc_10);
                }
                else if (_loc_3 > _loc_11)
                {
                    _loc_12.addChild(_loc_10);
                }
                else if (_loc_3 < _loc_11)
                {
                    _loc_7 = _loc_3;
                    while (_loc_7 <= _loc_11)
                    {
                        
                        _loc_12 = _loc_12.parent;
                        _loc_7++;
                    }
                    _loc_12.addChild(_loc_10);
                }
                else
                {
                    _loc_12.addChild(_loc_10);
                }
                _loc_12 = _loc_10;
                _loc_11 = _loc_3;
                setupItem(_loc_13, _loc_10.cell);
                _loc_5++;
            }
            return;
        }// end function

    }
}
