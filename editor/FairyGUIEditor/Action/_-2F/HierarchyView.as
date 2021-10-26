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

    public class HierarchyView extends GComponent
    {
        private var _editor:IEditor;
        private var _panel:GComponent;
        private var _treeView:GTree;
        private var _-27:GButton;
        private var _-2q:GButton;
        private var _-Ff:GButton;
        private var _-IS:InlineSearchBar;
        private var _updating:Boolean;
        private var _refreshFlag:int;
        private var _-7n:Boolean;
        private var _-LQ:Array;

        public function HierarchyView(param1:IEditor)
        {
            var editor:* = param1;
            this._editor = editor;
            UIObjectFactory.setPackageItemExtension("ui://Builder/HierarchyView_item", HierarchyViewItem);
            this._panel = UIPackage.createObject("Builder", "HierarchyView").asCom;
            this.setSize(this._panel.width, this._panel.height);
            this._panel.addRelation(this, RelationType.Size);
            addChild(this._panel);
            this._treeView = this._panel.getChild("list").asTree;
            this._treeView.treeNodeRender = this.renderTreeNode;
            this._treeView.treeNodeWillExpand = this.treeNodeWillExpand;
            this._treeView.addEventListener(ItemEvent.CLICK, this.__clickItem);
            this._panel.getChild("status").addClickListener(this._-3u);
            this._panel.getChild("lock").addClickListener(this._-9e);
            this._panel.getChild("expand").asButton.addEventListener(StateChangeEvent.CHANGED, this._-FX);
            this._panel.getChild("rename").addClickListener(this._-Fa);
            this._-27 = this._panel.getChild("warnings").asButton;
            this._-27.visible = false;
            this._-27.addClickListener(this._-CD);
            this._-IS = this._panel.getChild("searchBar") as InlineSearchBar;
            this._-IS.reset();
            this._-IS.addEventListener(_-Fr._-CF, function () : void
            {
                _refreshFlag = 3;
                return;
            }// end function
            );
            this._-2q = this._panel.getChild("btnRelationDisabled").asButton;
            this._-2q.addEventListener(StateChangeEvent.CHANGED, this._-Mv);
            this._-Ff = this._panel.getChild("btnShowAllInvisibles").asButton;
            this._-Ff.addEventListener(StateChangeEvent.CHANGED, this._-KL);
            this._-LQ = [];
            addEventListener(DropEvent.DROP, this._-G6);
            addEventListener(_-4U._-76, this.handleKeyEvent);
            addEventListener(FocusChangeEvent.CHANGED, this._-AB);
            this._editor.on(EditorEvent.OnLateUpdate, this._-4v);
            this._editor.on(EditorEvent.SelectionChanged, function () : void
            {
                _refreshFlag = _refreshFlag | 2;
                return;
            }// end function
            );
            this._editor.on(EditorEvent.DocumentActivated, this._-A2);
            this._editor.on(EditorEvent.DocumentDeactivated, this._-1f);
            this._editor.on(EditorEvent.HierarchyChanged, this.refresh);
            return;
        }// end function

        private function _-4v() : void
        {
            if (this._refreshFlag == 0)
            {
                return;
            }
            this._-7U();
            return;
        }// end function

        private function _-A2() : void
        {
            this._refreshFlag = 3;
            var _loc_1:* = this._editor.docView.activeDocument;
            this._-2q.selected = _loc_1.getVar("relationsDisabled");
            this._-Ff.selected = _loc_1.getVar("showAllInvisibles");
            return;
        }// end function

        private function _-1f() : void
        {
            this._refreshFlag = 3;
            this._-2q.selected = false;
            this._-Ff.selected = false;
            this._-27.visible = false;
            this._-IS.reset();
            return;
        }// end function

        private function refresh(param1:FObject = null) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            if (param1 == null)
            {
                this._refreshFlag = 3;
            }
            else
            {
                if ((this._refreshFlag & 1) != 0)
                {
                    return;
                }
                this._updating = true;
                _loc_2 = this._treeView.numChildren;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = this._treeView.getChildAt(_loc_3).asCom;
                    if (_loc_4.name == param1._id)
                    {
                        this.renderTreeNode(_loc_4.treeNode, _loc_4);
                        this._-Fg();
                        break;
                    }
                    _loc_3++;
                }
                this._updating = false;
            }
            return;
        }// end function

        private function _-7U() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_1:* = this._editor.docView.activeDocument;
            if (_loc_1 == null)
            {
                this._treeView.rootNode.removeChildren();
                this._refreshFlag = 0;
                return;
            }
            if ((this._refreshFlag & 1) != 0)
            {
                this._updating = true;
                this._treeView.rootNode.removeChildren();
                this._-9r(this._treeView.rootNode, _loc_1.content);
                this._-Fg();
                this._updating = false;
            }
            if ((this._refreshFlag & 2) != 0)
            {
                this._treeView.clearSelection();
                _loc_2 = this._treeView.numChildren;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = this._treeView.getChildAt(_loc_3);
                    _loc_5 = _loc_4.treeNode;
                    _loc_6 = FObject(_loc_5.data);
                    if (_loc_6 is FGroup)
                    {
                        _loc_5.expanded = !FGroup(_loc_6).collapsed || _loc_6._opened;
                    }
                    if (_loc_6.docElement.selected)
                    {
                        this._treeView.selectNode(_loc_5, true);
                    }
                    else
                    {
                        this._treeView.unselectNode(_loc_5);
                    }
                    _loc_3++;
                }
            }
            this._refreshFlag = 0;
            return;
        }// end function

        private function _-9r(param1:GTreeNode, param2:FObject) : void
        {
            var _loc_3:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_4:* = param2 is FGroup;
            if (param2 is FGroup)
            {
                _loc_3 = FGroup(param2).children;
            }
            else
            {
                _loc_3 = FComponent(param2).children;
            }
            var _loc_5:* = _loc_3.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = _loc_3[_loc_6];
                if (!_loc_4 && _loc_7._group)
                {
                }
                else if (_loc_7 is FGroup)
                {
                    _loc_8 = new GTreeNode(true);
                    _loc_8.expanded = !FGroup(_loc_7).collapsed || _loc_7._opened;
                    _loc_8.data = _loc_7;
                    param1.addChild(_loc_8);
                    this._-9r(_loc_8, _loc_7);
                    if (_loc_8.numChildren == 0 && this._-IS.visible && _loc_7.name.search(this._-IS._-P2) == -1)
                    {
                        param1.removeChild(_loc_8);
                    }
                }
                else if (!this._-IS.visible || _loc_7.name.search(this._-IS._-P2) != -1)
                {
                    _loc_9 = new GTreeNode(false);
                    _loc_9.data = _loc_7;
                    param1.addChild(_loc_9);
                }
                _loc_6++;
            }
            return;
        }// end function

        private function _-5P(param1:GTreeNode, param2:FObject) : GTreeNode
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_3:* = param1.numChildren;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = param1.getChildAt(_loc_4);
                if (_loc_5.data == param2)
                {
                    return _loc_5;
                }
                if (_loc_5.isFolder)
                {
                    _loc_6 = this._-5P(_loc_5, param2);
                    if (_loc_6)
                    {
                        return _loc_6;
                    }
                }
                _loc_4++;
            }
            return null;
        }// end function

        private function renderTreeNode(param1:GTreeNode, param2:GComponent) : void
        {
            var _loc_3:* = HierarchyViewItem(param2);
            _loc_3.draggable = true;
            _loc_3.setActive(this._-7n);
            _loc_3.addEventListener(DragEvent.DRAG_START, this._-5x);
            _loc_3.addEventListener(_-Fr._-CF, this._-2k);
            _loc_3._status.addEventListener(GTouchEvent.BEGIN, this._-13);
            _loc_3._lock.addEventListener(GTouchEvent.BEGIN, this._-GL);
            var _loc_4:* = FObject(param1.data);
            _loc_3.name = _loc_4.id;
            _loc_3.title = _loc_4.toString();
            _loc_3.icon = _loc_4.docElement.displayIcon;
            _loc_3._status.selected = _loc_4.hideByEditor;
            _loc_3._lock.selected = _loc_4.locked;
            return;
        }// end function

        private function treeNodeWillExpand(param1:GTreeNode, param2:Boolean) : void
        {
            if (this._updating)
            {
                return;
            }
            var _loc_3:* = param1.data as FGroup;
            if (_loc_3 != null)
            {
                FGroup(_loc_3).collapsed = !param2;
            }
            return;
        }// end function

        private function __clickItem(event:ItemEvent) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_2:* = this._editor.docView.activeDocument;
            if (_loc_2 == null)
            {
                return;
            }
            if (this._refreshFlag != 0)
            {
                this._-7U();
            }
            var _loc_3:* = event.itemObject.treeNode;
            if (HierarchyViewItem(_loc_3.cell).isEditing)
            {
                return;
            }
            var _loc_4:* = FObject(_loc_3.data);
            if (FObject(_loc_3.data) != null && _loc_4.parent != null)
            {
                _loc_5 = this._treeView.getSelectedNodes();
                if (_loc_5.length == 1 || !(this._editor.groot.shiftKeyDown || this._editor.groot.ctrlKeyDown) && !event.rightButton)
                {
                    _loc_2.unselectAll();
                    _loc_2.selectObject(_loc_4, true, true);
                }
                else
                {
                    if (this._editor.groot.ctrlKeyDown)
                    {
                        _loc_2.unselectObject(_loc_4);
                    }
                    for each (_loc_3 in _loc_5)
                    {
                        
                        _loc_6 = FObject(_loc_3.data);
                        if (_loc_6._group == _loc_2.openedGroup)
                        {
                            if (!_loc_4.docElement.selected)
                            {
                                _loc_2.selectObject(_loc_6);
                            }
                            continue;
                        }
                        this._treeView.unselectNode(_loc_3);
                    }
                }
                if (this._refreshFlag == 2)
                {
                    this._refreshFlag = 0;
                }
                if (event)
                {
                    if (event.rightButton)
                    {
                        _loc_2.showContextMenu();
                    }
                    else if (event.clickCount == 2)
                    {
                        if (_loc_4 is FGroup)
                        {
                            _loc_2.openGroup(_loc_4);
                        }
                        else
                        {
                            _loc_2.openChild(_loc_4);
                        }
                    }
                    else if (_loc_4 is FLoader)
                    {
                        if (!FLoader(_loc_4).contentRes.isMissing)
                        {
                            this._editor.showPreview(FLoader(_loc_4).contentRes.displayItem);
                        }
                    }
                    else if (_loc_4._res && !_loc_4._res.isMissing)
                    {
                        this._editor.showPreview(_loc_4._res.displayItem);
                    }
                }
            }
            return;
        }// end function

        private function _-Fg() : void
        {
            var _loc_3:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_1:* = this._editor.docView.activeDocument;
            var _loc_2:* = {};
            var _loc_4:* = _loc_1.content.numChildren;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_5 = _loc_1.content.getChildAt(_loc_3);
                if (_loc_5.name)
                {
                    _loc_2[_loc_5.name] = int(_loc_2[_loc_5.name]) + 1;
                }
                _loc_3++;
            }
            this._-LQ.length = 0;
            for (_loc_6 in _loc_2)
            {
                
                if (_loc_2[_loc_6] > 1)
                {
                    this._-LQ.push(_loc_6);
                }
            }
            if (this._-LQ.length > 0)
            {
                this._-27.tooltips = UtilsStr.formatString(Consts.strings.text323, this._-LQ.join(", "));
                this._-27.visible = true;
            }
            else
            {
                this._-27.visible = false;
            }
            return;
        }// end function

        private function _-CD(event:Event) : void
        {
            var _loc_6:* = null;
            var _loc_2:* = this._editor.docView.activeDocument;
            if (!_loc_2)
            {
                return;
            }
            _loc_2.unselectAll();
            var _loc_3:* = this._-LQ[0];
            var _loc_4:* = _loc_2.content.numChildren;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = _loc_2.content.getChildAt(_loc_5);
                if (_loc_6.name == _loc_3)
                {
                    _loc_2.selectObject(_loc_6, true, true);
                }
                _loc_5++;
            }
            return;
        }// end function

        private function _-Mv(event:Event) : void
        {
            var _loc_2:* = this._editor.docView.activeDocument;
            if (!_loc_2)
            {
                return;
            }
            _loc_2.setVar("relationsDisabled", GButton(event.currentTarget).selected);
            return;
        }// end function

        private function _-KL(event:Event) : void
        {
            var _loc_2:* = this._editor.docView.activeDocument;
            if (!_loc_2)
            {
                return;
            }
            _loc_2.setVar("showAllInvisibles", GButton(event.currentTarget).selected);
            _loc_2.content.updateDisplayList(true);
            return;
        }// end function

        private function _-5x(event:DragEvent) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            event.preventDefault();
            var _loc_2:* = this._editor.docView.activeDocument;
            if (_loc_2 == null)
            {
                return;
            }
            if (_loc_2.isPickingObject)
            {
                return;
            }
            if (this._refreshFlag != 0)
            {
                this._-7U();
            }
            var _loc_3:* = GButton(event.currentTarget);
            if (!_loc_3.selected)
            {
                this._treeView.clearSelection();
                _loc_5 = _loc_3.treeNode;
                _loc_6 = FObject(_loc_5.data);
                this._treeView.selectNode(_loc_5);
                _loc_2.unselectAll();
                _loc_2.selectObject(_loc_6, true, true);
            }
            else
            {
                _loc_5 = this._treeView.getSelectedNode();
                _loc_6 = FObject(_loc_5.data);
                if (!_loc_6.docElement.selected)
                {
                    _loc_2.selectObject(_loc_6, false, true);
                }
            }
            var _loc_4:* = this._treeView.getSelectedNodes();
            this._editor.dragManager.startDrag(this, _loc_4);
            return;
        }// end function

        private function _-13(event:Event) : void
        {
            event.stopPropagation();
            var _loc_2:* = HierarchyViewItem(event.currentTarget.parent);
            _loc_2._status.selected = !_loc_2._status.selected;
            var _loc_3:* = this._editor.docView.activeDocument;
            if (_loc_3 == null)
            {
                return;
            }
            var _loc_4:* = _loc_3.content;
            var _loc_5:* = _loc_4.getChildById(_loc_2.name);
            if (_loc_4.getChildById(_loc_2.name) != null)
            {
                _loc_5.hideByEditor = _loc_2._status.selected;
            }
            _loc_4.updateChildrenVisible();
            return;
        }// end function

        private function _-GL(event:Event) : void
        {
            event.stopPropagation();
            var _loc_2:* = HierarchyViewItem(event.currentTarget.parent);
            _loc_2._lock.selected = !_loc_2._lock.selected;
            var _loc_3:* = this._editor.docView.activeDocument;
            if (_loc_3 == null)
            {
                return;
            }
            var _loc_4:* = _loc_3.content;
            var _loc_5:* = _loc_4.getChildById(_loc_2.name);
            if (_loc_4.getChildById(_loc_2.name) != null)
            {
                _loc_5.locked = _loc_2._lock.selected;
            }
            return;
        }// end function

        private function _-3u(event:Event) : void
        {
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_2:* = this._editor.docView.activeDocument;
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_3:* = _loc_2.content;
            var _loc_4:* = false;
            var _loc_5:* = false;
            var _loc_6:* = _loc_3.numChildren;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_8 = _loc_3.getChildAt(_loc_7);
                if (_loc_8.hideByEditor)
                {
                    _loc_5 = true;
                    break;
                }
                _loc_7++;
            }
            if (_loc_5)
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_8 = _loc_3.getChildAt(_loc_7);
                    if (_loc_8.hideByEditor)
                    {
                        _loc_8.hideByEditor = false;
                        _loc_4 = true;
                    }
                    _loc_7++;
                }
            }
            else
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_8 = _loc_3.getChildAt(_loc_7);
                    if (!_loc_8.hideByEditor)
                    {
                        _loc_8.hideByEditor = true;
                        _loc_4 = true;
                    }
                    _loc_7++;
                }
            }
            if (_loc_4)
            {
                _loc_6 = this._treeView.numChildren;
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_9 = HierarchyViewItem(this._treeView.getChildAt(_loc_7));
                    _loc_10 = _loc_9.treeNode;
                    _loc_8 = FObject(_loc_10.data);
                    _loc_9._status.selected = _loc_8.hideByEditor;
                    _loc_7++;
                }
                _loc_3.updateChildrenVisible();
            }
            return;
        }// end function

        private function _-9e(event:Event) : void
        {
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_2:* = this._editor.docView.activeDocument;
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_3:* = _loc_2.content;
            var _loc_4:* = false;
            var _loc_5:* = false;
            var _loc_6:* = _loc_3.numChildren;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_8 = _loc_3.getChildAt(_loc_7);
                if (_loc_8.locked)
                {
                    _loc_5 = true;
                    break;
                }
                _loc_7++;
            }
            if (_loc_5)
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_8 = _loc_3.getChildAt(_loc_7);
                    if (_loc_8.locked)
                    {
                        _loc_8.locked = false;
                        _loc_4 = true;
                    }
                    _loc_7++;
                }
            }
            else
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_8 = _loc_3.getChildAt(_loc_7);
                    if (!_loc_8.locked)
                    {
                        _loc_8.locked = true;
                        _loc_4 = true;
                    }
                    _loc_7++;
                }
            }
            if (_loc_4)
            {
                _loc_6 = this._treeView.numChildren;
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_9 = HierarchyViewItem(this._treeView.getChildAt(_loc_7));
                    _loc_10 = _loc_9.treeNode;
                    _loc_8 = FObject(_loc_10.data);
                    _loc_9._lock.selected = _loc_8.locked;
                    _loc_7++;
                }
            }
            return;
        }// end function

        private function _-FX(event:Event) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_2:* = this._editor.docView.activeDocument;
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_3:* = event.currentTarget.selected;
            this._updating = true;
            if (_loc_3)
            {
                this._treeView.collapseAll();
                _loc_4 = _loc_2.content;
                _loc_5 = _loc_4.numChildren;
                _loc_6 = 0;
                while (_loc_6 < _loc_5)
                {
                    
                    _loc_7 = _loc_4.getChildAt(_loc_6) as FGroup;
                    if (_loc_7)
                    {
                        FGroup(_loc_7).collapsed = true;
                    }
                    _loc_6++;
                }
            }
            else
            {
                this._treeView.expandAll();
                _loc_6 = 0;
                while (_loc_6 < _loc_5)
                {
                    
                    _loc_7 = _loc_4.getChildAt(_loc_6) as FGroup;
                    if (_loc_7)
                    {
                        FGroup(_loc_7).collapsed = false;
                    }
                    _loc_6++;
                }
            }
            this._updating = false;
            return;
        }// end function

        private function _-G6(event:DropEvent) : void
        {
            var _loc_6:* = null;
            if (event.source != this)
            {
                return;
            }
            var _loc_2:* = this._editor.docView.activeDocument;
            if (_loc_2 == null)
            {
                return;
            }
            if (_loc_2.timelineMode)
            {
                return;
            }
            var _loc_3:* = _loc_2.content;
            var _loc_4:* = this._treeView.getItemNear(this._panel.displayObject.stage.mouseX, this._panel.displayObject.stage.mouseY);
            var _loc_5:* = -1;
            if (_loc_4 == null)
            {
                if (this._treeView.displayListContainer.globalToLocal(new Point(this._panel.displayObject.stage.mouseX, this._panel.displayObject.stage.mouseY)).y < 0)
                {
                    _loc_5 = 0;
                }
                else
                {
                    _loc_5 = _loc_3.numChildren - 1;
                }
            }
            else
            {
                _loc_6 = _loc_3.getChildById(_loc_4.name);
                if (_loc_6)
                {
                    _loc_5 = _loc_3.getChildIndex(_loc_6);
                }
            }
            if (_loc_5 >= 0 && _loc_5 < _loc_3.numChildren)
            {
                _loc_2.adjustDepth(_loc_5);
            }
            return;
        }// end function

        private function handleKeyEvent(param1:_-4U) : void
        {
            var _loc_2:* = null;
            if (this._-IS.handleKeyEvent(param1))
            {
                return;
            }
            switch(param1._-T)
            {
                case "0201":
                {
                    _loc_2 = this._treeView.getSelectedNode();
                    if (_loc_2)
                    {
                        HierarchyViewItem(_loc_2.cell).startEditing(FObject(_loc_2.data).name);
                    }
                    break;
                }
                default:
                {
                    this._editor.docView.handleKeyEvent(param1);
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function _-AB(event:FocusChangeEvent) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_2:* = event.newFocusedObject == this;
            if (this._-7n != _loc_2)
            {
                this._-7n = _loc_2;
                _loc_3 = this._treeView.numChildren;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_5 = HierarchyViewItem(this._treeView.getChildAt(_loc_4));
                    _loc_5.setActive(_loc_2);
                    _loc_4++;
                }
            }
            return;
        }// end function

        private function _-2k(event:Event) : void
        {
            var _loc_2:* = GObject(event.currentTarget).treeNode;
            var _loc_3:* = FObject(_loc_2.data);
            _loc_3.docElement.setProperty("name", _loc_2.text ? (_loc_2.text) : (UtilsStr.getNameFromId(_loc_3.id)));
            return;
        }// end function

        private function _-Fa(event:Event) : void
        {
            var _loc_2:* = null;
            _loc_2 = this._treeView.getSelectedNode();
            if (_loc_2)
            {
                this._treeView.scrollToView(this._treeView.getChildIndex(_loc_2.cell));
                HierarchyViewItem(_loc_2.cell).startEditing(FObject(_loc_2.data).name);
            }
            return;
        }// end function

    }
}

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

class HierarchyViewItem extends EditableTreeItem
{
    public var _status:GButton;
    public var _lock:GButton;

    function HierarchyViewItem()
    {
        return;
    }// end function

    override protected function constructFromXML(param1:XML) : void
    {
        super.constructFromXML(param1);
        this._status = getChild("status").asButton;
        this._lock = getChild("lock").asButton;
        this._status.changeStateOnClick = false;
        this._lock.changeStateOnClick = false;
        return;
    }// end function

}

