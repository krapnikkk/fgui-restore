package _-2F
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.system.*;
    import flash.ui.*;

    public class SearchView extends GComponent
    {
        private var _editor:IEditor;
        private var _panel:GComponent;
        private var _list:GList;
        private var _-8E:GLabel;
        private var _-B4:GTextField;
        private var _-Kz:_-GW;
        private var _-7n:Boolean;
        private var _-HX:Vector.<FPackageItem>;
        private static var helperIntList:Vector.<int> = new Vector.<int>;

        public function SearchView(param1:IEditor)
        {
            var editor:* = param1;
            this._editor = editor;
            this._-HX = new Vector.<FPackageItem>;
            this._panel = UIPackage.createObject("Builder", "SearchView").asCom;
            this.setSize(this._panel.width, this._panel.height);
            this._panel.addRelation(this, RelationType.Size);
            addChild(this._panel);
            this._list = this._panel.getChild("list").asList;
            this._list.itemRenderer = this.renderListItem;
            this._list.addEventListener(ItemEvent.CLICK, this.__clickItem);
            this._list.setVirtual();
            this._-Kz = new _-GW(editor);
            this._-8E = this._panel.getChild("keyword").asLabel;
            this._-8E.getTextField().addEventListener(KeyboardEvent.KEY_DOWN, this._-6W);
            this._panel.getChild("find").addClickListener(this.__find);
            this._-B4 = this._panel.getChild("result").asTextField;
            this._-B4.visible = false;
            this._panel.addEventListener(Event.ADDED_TO_STAGE, function () : void
            {
                _-8E.getTextField().requestFocus();
                return;
            }// end function
            );
            addEventListener(_-4U._-76, this.handleKeyEvent);
            addEventListener(FocusChangeEvent.CHANGED, this._-AB);
            return;
        }// end function

        private function __find(event:Event) : void
        {
            this._-B4.visible = false;
            this._list.numItems = 0;
            if (this._-8E.text.length == 0)
            {
                return;
            }
            this._editor.cursorManager.setWaitCursor(true);
            GTimers.inst.callLater(this._-Fn);
            return;
        }// end function

        private function _-Fn() : void
        {
            var pkg:IUIPackage;
            var branches:Vector.<String>;
            var branch:String;
            var file:File;
            this._-HX.length = 0;
            var key:* = new RegExp(this._-8E.text, "i");
            var pi:* = this._editor.project.getItemByURL(this._-8E.text);
            if (pi)
            {
                this._-HX.push(pi);
            }
            var pkgs:* = this._editor.project.allPackages;
            var _loc_2:* = 0;
            var _loc_3:* = pkgs;
            while (_loc_3 in _loc_2)
            {
                
                pkg = _loc_3[_loc_2];
                if (pkg.name.toLowerCase().search(key) != -1)
                {
                    this._-HX.push(pkg.rootItem);
                }
                try
                {
                    this._-Ed(pkg, new File(pkg.basePath + "/package.xml"), key);
                }
                catch (err:Error)
                {
                    _editor.consoleView.logError("SearchView", err);
                }
                branches = this._editor.project.allBranches;
                var _loc_4:* = 0;
                var _loc_5:* = branches;
                do
                {
                    
                    branch = _loc_5[_loc_4];
                    file = new File(pkg.getBranchPath(branch) + "/package_branch.xml");
                    if (file.exists)
                    {
                        try
                        {
                            this._-Ed(pkg, file, key);
                        }
                        catch (err:Error)
                        {
                            _editor.consoleView.logError("SearchView", err);
                        }
                    }
                }while (_loc_5 in _loc_4)
            }
            this._-HX.sort(_-FL);
            this._-B4.visible = true;
            this._-B4.setVar("count", "" + this._-HX.length).flushVars();
            this._list.numItems = this._-HX.length;
            this._editor.cursorManager.setWaitCursor(false);
            return;
        }// end function

        private function _-Ed(param1:IUIPackage, param2:File, param3:Object) : void
        {
            var resources:XMLList;
            var rss:XMLList;
            var pi:FPackageItem;
            var cxml:XML;
            var pkg:* = param1;
            var file:* = param2;
            var key:* = param3;
            var xml:* = UtilsFile.loadXML(file);
            var col:* = xml.resources;
            if (col)
            {
                resources = col.elements();
                var _loc_6:* = 0;
                var _loc_7:* = resources;
                var _loc_5:* = new XMLList("");
                for each (_loc_8 in _loc_7)
                {
                    
                    var _loc_9:* = _loc_7[_loc_6];
                    with (_loc_7[_loc_6])
                    {
                        if (@name.toString().toLowerCase().search(key) != -1)
                        {
                            _loc_5[_loc_6] = _loc_8;
                        }
                    }
                }
                rss = _loc_5;
                if (rss.length() > 0)
                {
                    var _loc_5:* = 0;
                    var _loc_6:* = rss;
                    while (_loc_6 in _loc_5)
                    {
                        
                        cxml = _loc_6[_loc_5];
                        pi = pkg.getItem(cxml.@id);
                        if (pi)
                        {
                            this._-HX.push(pi);
                        }
                    }
                }
            }
            System.disposeXML(xml);
            return;
        }// end function

        private function renderListItem(param1:int, param2:GObject) : void
        {
            var _loc_3:* = ListItem(param2);
            var _loc_4:* = this._-HX[param1];
            var _loc_5:* = _loc_4.name + "@" + _loc_4.owner.name;
            if (_loc_4.branch.length > 0)
            {
                _loc_5 = _loc_5 + ("  (" + _loc_4.branch + ")");
            }
            _loc_3.text = _loc_5;
            _loc_3.icon = _loc_4.getIcon();
            _loc_3.data = _loc_4;
            _loc_3.draggable = true;
            _loc_3.addEventListener(DragEvent.DRAG_START, this._-5E);
            return;
        }// end function

        private function __clickItem(event:ItemEvent) : void
        {
            var _loc_2:* = FPackageItem(event.itemObject.data);
            this._editor.showPreview(_loc_2);
            if (event.clickCount == 2)
            {
                this._editor.libView.openResource(_loc_2);
            }
            else if (event.rightButton)
            {
                this._-Nx();
                this._-Kz.show(event);
            }
            return;
        }// end function

        public function _-Nx() : void
        {
            helperIntList.length = 0;
            var _loc_1:* = this._list.getSelection(helperIntList);
            var _loc_2:* = this._-Kz._-H0;
            _loc_2.length = 0;
            var _loc_3:* = _loc_1.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2.push(this._-HX[_loc_1[_loc_4]]);
                _loc_4++;
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
                _loc_3 = this._list.numChildren;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_5 = ListItem(this._list.getChildAt(_loc_4));
                    _loc_5.setActive(_loc_2);
                    _loc_4++;
                }
            }
            return;
        }// end function

        private function handleKeyEvent(param1:_-4U) : void
        {
            if (param1._-2h != 0)
            {
                this._list.handleArrowKey(param1._-2h);
            }
            return;
        }// end function

        private function _-6W(event:KeyboardEvent) : void
        {
            if (event.keyCode == Keyboard.ENTER)
            {
                this.__find(null);
            }
            return;
        }// end function

        private function _-5E(event:DragEvent) : void
        {
            event.preventDefault();
            var _loc_2:* = GButton(event.currentTarget);
            if (!_loc_2.selected)
            {
                this._list.clearSelection();
                this._list.addSelection(this._list.childIndexToItemIndex(this._list.getChildIndex(_loc_2)));
            }
            this._editor.dragManager.startDrag(this._editor.libView, [_loc_2.data]);
            return;
        }// end function

        private static function _-FL(param1:FPackageItem, param2:FPackageItem) : int
        {
            var _loc_3:* = 0;
            _loc_3 = param1.owner.name.localeCompare(param2.owner.name);
            if (_loc_3 == 0)
            {
                _loc_3 = param1.type.localeCompare(param2.type);
            }
            if (_loc_3 == 0)
            {
                _loc_3 = param1.path.localeCompare(param2.path);
            }
            if (_loc_3 == 0)
            {
                _loc_3 = param1.name.localeCompare(param2.name);
            }
            return _loc_3;
        }// end function

    }
}
