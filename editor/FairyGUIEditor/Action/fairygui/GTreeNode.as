package fairygui
{
    import *.*;
    import __AS3__.vec.*;

    public class GTreeNode extends Object
    {
        private var _data:Object;
        private var _parent:GTreeNode;
        private var _children:Vector.<GTreeNode>;
        private var _expanded:Boolean;
        private var _level:int;
        private var _tree:GTree;
        var _cell:GComponent;
        var _resURL:String;

        public function GTreeNode(param1:Boolean, param2:String = null)
        {
            _resURL = param2;
            if (param1)
            {
                _children = new Vector.<GTreeNode>;
            }
            return;
        }// end function

        final public function set expanded(param1:Boolean) : void
        {
            if (_children == null)
            {
                return;
            }
            if (_expanded != param1)
            {
                _expanded = param1;
                if (_tree != null)
                {
                    if (_expanded)
                    {
                        _tree.afterExpanded(this);
                    }
                    else
                    {
                        _tree.afterCollapsed(this);
                    }
                }
            }
            return;
        }// end function

        final public function get expanded() : Boolean
        {
            return _expanded;
        }// end function

        final public function get isFolder() : Boolean
        {
            return _children != null;
        }// end function

        final public function get parent() : GTreeNode
        {
            return _parent;
        }// end function

        final public function set data(param1:Object) : void
        {
            _data = param1;
            return;
        }// end function

        final public function get data() : Object
        {
            return _data;
        }// end function

        final public function get text() : String
        {
            if (_cell != null)
            {
                return _cell.text;
            }
            return null;
        }// end function

        final public function set text(param1:String) : void
        {
            if (_cell != null)
            {
                _cell.text = param1;
            }
            return;
        }// end function

        final public function get icon() : String
        {
            if (_cell != null)
            {
                return _cell.icon;
            }
            return null;
        }// end function

        final public function set icon(param1:String) : void
        {
            if (_cell != null)
            {
                _cell.icon = param1;
            }
            return;
        }// end function

        final public function get cell() : GComponent
        {
            return _cell;
        }// end function

        final public function get level() : int
        {
            return _level;
        }// end function

        function setLevel(param1:int) : void
        {
            _level = param1;
            return;
        }// end function

        public function addChild(param1:GTreeNode) : GTreeNode
        {
            addChildAt(param1, _children.length);
            return param1;
        }// end function

        public function addChildAt(param1:GTreeNode, param2:int) : GTreeNode
        {
            var _loc_4:* = 0;
            if (!param1)
            {
                throw new Error("child is null");
            }
            var _loc_3:* = _children.length;
            if (param2 >= 0 && param2 <= _loc_3)
            {
                if (param1._parent == this)
                {
                    setChildIndex(param1, param2);
                }
                else
                {
                    if (param1._parent)
                    {
                        param1._parent.removeChild(param1);
                    }
                    _loc_4 = _children.length;
                    if (param2 == _loc_4)
                    {
                        _children.push(param1);
                    }
                    else
                    {
                        _children.splice(param2, 0, param1);
                    }
                    param1._parent = this;
                    param1._level = this._level + 1;
                    param1.setTree(_tree);
                    if (_tree != null && _tree.rootNode == this || this._cell != null && this._cell.parent != null && _expanded)
                    {
                        _tree.afterInserted(param1);
                    }
                }
                return param1;
            }
            throw new RangeError("Invalid child index");
        }// end function

        public function removeChild(param1:GTreeNode) : GTreeNode
        {
            var _loc_2:* = _children.indexOf(param1);
            if (_loc_2 != -1)
            {
                removeChildAt(_loc_2);
            }
            return param1;
        }// end function

        public function removeChildAt(param1:int) : GTreeNode
        {
            var _loc_2:* = null;
            if (param1 >= 0 && param1 < numChildren)
            {
                _loc_2 = _children[param1];
                _children.splice(param1, 1);
                _loc_2._parent = null;
                if (_tree != null)
                {
                    _loc_2.setTree(null);
                    _tree.afterRemoved(_loc_2);
                }
                return _loc_2;
            }
            throw new RangeError("Invalid child index");
        }// end function

        public function removeChildren(param1:int = 0, param2:int = -1) : void
        {
            var _loc_3:* = 0;
            if (param2 < 0 || param2 >= numChildren)
            {
                param2 = numChildren - 1;
            }
            _loc_3 = param1;
            while (_loc_3 <= param2)
            {
                
                removeChildAt(param1);
                _loc_3++;
            }
            return;
        }// end function

        public function getChildAt(param1:int) : GTreeNode
        {
            if (param1 >= 0 && param1 < numChildren)
            {
                return _children[param1];
            }
            throw new RangeError("Invalid child index");
        }// end function

        public function getChildIndex(param1:GTreeNode) : int
        {
            return _children.indexOf(param1);
        }// end function

        public function getPrevSibling() : GTreeNode
        {
            if (_parent == null)
            {
                return null;
            }
            var _loc_1:* = _parent._children.indexOf(this);
            if (_loc_1 <= 0)
            {
                return null;
            }
            return _parent._children[(_loc_1 - 1)];
        }// end function

        public function getNextSibling() : GTreeNode
        {
            if (_parent == null)
            {
                return null;
            }
            var _loc_1:* = _parent._children.indexOf(this);
            if (_loc_1 < 0 || _loc_1 >= (_parent._children.length - 1))
            {
                return null;
            }
            return _parent._children[(_loc_1 + 1)];
        }// end function

        public function setChildIndex(param1:GTreeNode, param2:int) : void
        {
            var _loc_4:* = _children.indexOf(param1);
            if (_children.indexOf(param1) == -1)
            {
                throw new ArgumentError("Not a child of this container");
            }
            var _loc_3:* = _children.length;
            if (param2 < 0)
            {
                param2 = 0;
            }
            else if (param2 > _loc_3)
            {
                param2 = _loc_3;
            }
            if (_loc_4 == param2)
            {
                return;
            }
            _children.splice(_loc_4, 1);
            _children.splice(param2, 0, param1);
            if (_tree != null && _tree.rootNode == this || this._cell != null && this._cell.parent != null && _expanded)
            {
                _tree.afterMoved(param1);
            }
            return;
        }// end function

        public function swapChildren(param1:GTreeNode, param2:GTreeNode) : void
        {
            var _loc_3:* = _children.indexOf(param1);
            var _loc_4:* = _children.indexOf(param2);
            if (_loc_3 == -1 || _loc_4 == -1)
            {
                throw new ArgumentError("Not a child of this container");
            }
            swapChildrenAt(_loc_3, _loc_4);
            return;
        }// end function

        public function swapChildrenAt(param1:int, param2:int) : void
        {
            var _loc_4:* = _children[param1];
            var _loc_3:* = _children[param2];
            setChildIndex(_loc_4, param2);
            setChildIndex(_loc_3, param1);
            return;
        }// end function

        final public function get numChildren() : int
        {
            return _children.length;
        }// end function

        public function expandToRoot() : void
        {
            var _loc_1:* = this;
            while (_loc_1)
            {
                
                _loc_1.expanded = true;
                _loc_1 = _loc_1.parent;
            }
            return;
        }// end function

        final public function get tree() : GTree
        {
            return _tree;
        }// end function

        function setTree(param1:GTree) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_2:* = null;
            _tree = param1;
            if (_tree != null && _tree.treeNodeWillExpand != null && _expanded)
            {
                _tree.treeNodeWillExpand(this, true);
            }
            if (_children != null)
            {
                _loc_3 = _children.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_2 = _children[_loc_4];
                    _loc_2._level = _level + 1;
                    _loc_2.setTree(param1);
                    _loc_4++;
                }
            }
            return;
        }// end function

    }
}
