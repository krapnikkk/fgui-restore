package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;

    public class FTreeNode extends Object
    {
        private var _data:Object;
        private var _parent:FTreeNode;
        private var _children:Vector.<FTreeNode>;
        private var _expanded:Boolean;
        private var _level:int;
        private var _tree:_-BR;
        var _cell:FComponent;
        var _resURL:String;

        public function FTreeNode(param1:Boolean, param2:String = null)
        {
            this._resURL = param2;
            if (param1)
            {
                this._children = new Vector.<FTreeNode>;
            }
            return;
        }// end function

        final public function set expanded(param1:Boolean) : void
        {
            if (this._children == null)
            {
                return;
            }
            if (this._expanded != param1)
            {
                this._expanded = param1;
                if (this._tree != null)
                {
                    if (this._expanded)
                    {
                        this._tree.afterExpanded(this);
                    }
                    else
                    {
                        this._tree.afterCollapsed(this);
                    }
                }
            }
            return;
        }// end function

        final public function get expanded() : Boolean
        {
            return this._expanded;
        }// end function

        final public function get isFolder() : Boolean
        {
            return this._children != null;
        }// end function

        final public function get parent() : FTreeNode
        {
            return this._parent;
        }// end function

        final public function set data(param1:Object) : void
        {
            this._data = param1;
            return;
        }// end function

        final public function get data() : Object
        {
            return this._data;
        }// end function

        final public function get text() : String
        {
            if (this._cell != null)
            {
                return this._cell.text;
            }
            return null;
        }// end function

        final public function get cell() : FComponent
        {
            return this._cell;
        }// end function

        final public function get level() : int
        {
            return this._level;
        }// end function

        function setLevel(param1:int) : void
        {
            this._level = param1;
            return;
        }// end function

        public function addChild(param1:FTreeNode) : FTreeNode
        {
            this.addChildAt(param1, this._children.length);
            return param1;
        }// end function

        public function addChildAt(param1:FTreeNode, param2:int) : FTreeNode
        {
            var _loc_4:* = 0;
            if (!param1)
            {
                throw new Error("child is null");
            }
            var _loc_3:* = this._children.length;
            if (param2 >= 0 && param2 <= _loc_3)
            {
                if (param1._parent == this)
                {
                    this.setChildIndex(param1, param2);
                }
                else
                {
                    if (param1._parent)
                    {
                        param1._parent.removeChild(param1);
                    }
                    _loc_4 = this._children.length;
                    if (param2 == _loc_4)
                    {
                        this._children.push(param1);
                    }
                    else
                    {
                        this._children.splice(param2, 0, param1);
                    }
                    param1._parent = this;
                    param1._level = this._level + 1;
                    param1.setTree(this._tree);
                    if (this._tree == this || this._cell != null && this._cell.parent != null && this._expanded)
                    {
                        this._tree.afterInserted(param1);
                    }
                }
                return param1;
            }
            else
            {
            }
            throw new RangeError("Invalid child index");
        }// end function

        public function removeChild(param1:FTreeNode) : FTreeNode
        {
            var _loc_2:* = this._children.indexOf(param1);
            if (_loc_2 != -1)
            {
                this.removeChildAt(_loc_2);
            }
            return param1;
        }// end function

        public function removeChildAt(param1:int) : FTreeNode
        {
            var _loc_2:* = null;
            if (param1 >= 0 && param1 < this.numChildren)
            {
                _loc_2 = this._children[param1];
                this._children.splice(param1, 1);
                _loc_2._parent = null;
                if (this._tree != null)
                {
                    _loc_2.setTree(null);
                    this._tree.afterRemoved(_loc_2);
                }
                return _loc_2;
            }
            else
            {
            }
            throw new RangeError("Invalid child index");
        }// end function

        public function removeChildren(param1:int = 0, param2:int = -1) : void
        {
            if (param2 < 0 || param2 >= this.numChildren)
            {
                param2 = this.numChildren - 1;
            }
            var _loc_3:* = param1;
            while (_loc_3 <= param2)
            {
                
                this.removeChildAt(param1);
                _loc_3++;
            }
            return;
        }// end function

        public function getChildAt(param1:int) : FTreeNode
        {
            if (param1 >= 0 && param1 < this.numChildren)
            {
                return this._children[param1];
            }
            throw new RangeError("Invalid child index");
        }// end function

        public function getChildIndex(param1:FTreeNode) : int
        {
            return this._children.indexOf(param1);
        }// end function

        public function getPrevSibling() : FTreeNode
        {
            if (this._parent == null)
            {
                return null;
            }
            var _loc_1:* = this._parent._children.indexOf(this);
            if (_loc_1 <= 0)
            {
                return null;
            }
            return this._parent._children[(_loc_1 - 1)];
        }// end function

        public function getNextSibling() : FTreeNode
        {
            if (this._parent == null)
            {
                return null;
            }
            var _loc_1:* = this._parent._children.indexOf(this);
            if (_loc_1 < 0 || _loc_1 >= (this._parent._children.length - 1))
            {
                return null;
            }
            return this._parent._children[(_loc_1 + 1)];
        }// end function

        public function setChildIndex(param1:FTreeNode, param2:int) : void
        {
            var _loc_3:* = this._children.indexOf(param1);
            if (_loc_3 == -1)
            {
                throw new ArgumentError("Not a child of this container");
            }
            var _loc_4:* = this._children.length;
            if (param2 < 0)
            {
                param2 = 0;
            }
            else if (param2 > _loc_4)
            {
                param2 = _loc_4;
            }
            if (_loc_3 == param2)
            {
                return;
            }
            this._children.splice(_loc_3, 1);
            this._children.splice(param2, 0, param1);
            if (this._cell != null && this._cell.parent != null && this._expanded)
            {
                this._tree.afterMoved(param1);
            }
            return;
        }// end function

        public function swapChildren(param1:FTreeNode, param2:FTreeNode) : void
        {
            var _loc_3:* = this._children.indexOf(param1);
            var _loc_4:* = this._children.indexOf(param2);
            if (_loc_3 == -1 || _loc_4 == -1)
            {
                throw new ArgumentError("Not a child of this container");
            }
            this.swapChildrenAt(_loc_3, _loc_4);
            return;
        }// end function

        public function swapChildrenAt(param1:int, param2:int) : void
        {
            var _loc_3:* = this._children[param1];
            var _loc_4:* = this._children[param2];
            this.setChildIndex(_loc_3, param2);
            this.setChildIndex(_loc_4, param1);
            return;
        }// end function

        final public function get numChildren() : int
        {
            return this._children.length;
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

        final public function get tree() : _-BR
        {
            return this._tree;
        }// end function

        function setTree(param1:_-BR) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            this._tree = param1;
            if (this._tree != null && this._tree.treeNodeWillExpand != null && this._expanded)
            {
                this._tree.treeNodeWillExpand(this, true);
            }
            if (this._children != null)
            {
                _loc_2 = this._children.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = this._children[_loc_3];
                    _loc_4._level = this._level + 1;
                    _loc_4.setTree(param1);
                    _loc_3++;
                }
            }
            return;
        }// end function

    }
}
