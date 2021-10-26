package _-Ds
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import flash.events.*;

    public class PackageGroupsEditDialog extends _-3g
    {
        private var _-A0:GList;
        private var _-Lg:GTextField;
        private var _-Gh:GList;
        private var _-Go:GLabel;
        private var _changed:Boolean;
        private var _needRefresh:Boolean;
        private var _-Da:int;
        private var _-Q1:PackageGroupSettings;
        private var _-KE:RegExp;

        public function PackageGroupsEditDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "PackageGroupsEditDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._-A0 = contentPane.getChild("groupList").asList;
            this._-A0.addEventListener(ItemEvent.CLICK, this._-6s);
            this._-Gh = contentPane.getChild("pkgList").asList;
            this._-Gh.foldInvisibleItems = true;
            this._-Gh.addEventListener(ItemEvent.CLICK, this.__clickItem);
            this._-Lg = contentPane.getChild("count").asTextField;
            this._-Go = contentPane.getChild("find").asLabel;
            this._-Go.getTextField().addEventListener(Event.CHANGE, this.__find);
            contentPane.getChild("selectAll").addClickListener(this._-Iw);
            contentPane.getChild("selectReverse").addClickListener(this._-6a);
            contentPane.getChild("selectNone").addClickListener(this._-63);
            contentPane.getChild("addGroup").addClickListener(this._-LT);
            contentPane.getChild("removeGroup").addClickListener(this._-2Z);
            contentPane.getChild("editGroup").addClickListener(this._-Dy);
            contentPane.getChild("moveUp").addClickListener(this._-7v);
            contentPane.getChild("moveDown").addClickListener(this._-Md);
            contentPane.getChild("close").addClickListener(closeEventHandler);
            this._-Q1 = PackageGroupSettings(_editor.project.getSettings("packageGroups"));
            return;
        }// end function

        override protected function onShown() : void
        {
            var _loc_1:* = 0;
            var _loc_3:* = null;
            var _loc_5:* = null;
            this._-A0.removeChildrenToPool();
            var _loc_2:* = this._-Q1.groups.length;
            _loc_3 = this._-A0.addItemFromPool().asButton;
            _loc_3.text = Consts.strings.text433;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                _loc_3 = this._-A0.addItemFromPool().asButton;
                _loc_3.text = this._-Q1.groups[_loc_1].name;
                _loc_3.data = _loc_1;
                _loc_1++;
            }
            if (this._-A0.selectedIndex == -1)
            {
                this._-A0.selectedIndex = 0;
            }
            var _loc_4:* = _editor.project.allPackages;
            this._-Gh.removeChildrenToPool();
            for each (_loc_5 in _loc_4)
            {
                
                _loc_3 = this._-Gh.addItemFromPool().asButton;
                _loc_3.icon = Consts.icons["package"];
                _loc_3.title = _loc_5.name;
                _loc_3.name = _loc_5.id;
            }
            this._-Da = this._-A0.selectedIndex;
            this._-5A();
            return;
        }// end function

        override protected function onHide() : void
        {
            super.onHide();
            if (this._changed)
            {
                this._-9Q();
            }
            if (this._needRefresh)
            {
                this._needRefresh = false;
                _editor.emit(EditorEvent.PackageListChanged);
            }
            return;
        }// end function

        private function _-5A() : void
        {
            var _loc_1:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_6:* = null;
            if (this._changed)
            {
                this._-9Q();
            }
            this._-Da = this._-A0.selectedIndex;
            var _loc_2:* = {};
            if (this._-Da == 0)
            {
                _loc_1 = _editor.workspaceSettings.get("packageGroup.mine") as Array;
            }
            else if (this._-Q1.groups.length > 0)
            {
                _loc_1 = this._-Q1.groups[(this._-Da - 1)].pkgs;
            }
            if (_loc_1)
            {
                _loc_4 = _loc_1.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_4)
                {
                    
                    _loc_2[_loc_1[_loc_3]] = true;
                    _loc_3++;
                }
            }
            var _loc_5:* = 0;
            _loc_4 = this._-Gh.numChildren;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_6 = this._-Gh.getChildAt(_loc_3).asButton;
                _loc_6.selected = _loc_2[_loc_6.name];
                _loc_6.visible = true;
                if (_loc_6.selected)
                {
                    _loc_5++;
                }
                _loc_3++;
            }
            this._-Lg.text = _loc_5 + "/" + _loc_4;
            this._-Go.text = "";
            this._-KE = null;
            return;
        }// end function

        private function __find(event:Event) : void
        {
            if (this._-Go.text.length > 0)
            {
                this._-KE = new RegExp(this._-Go.text, "i");
            }
            else
            {
                this._-KE = null;
            }
            this.applyFilter();
            return;
        }// end function

        private function applyFilter() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this._-Gh.numChildren;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._-Gh.getChildAt(_loc_2).asButton;
                _loc_3.visible = !this._-KE || _loc_3.text.search(this._-KE) != -1;
                _loc_2++;
            }
            return;
        }// end function

        private function _-6s(event:Event) : void
        {
            this._-5A();
            return;
        }// end function

        private function _-LT(event:Event) : void
        {
            var _loc_2:* = Consts.strings.text418;
            var _loc_3:* = 1;
            while (this._-Q1.groups.indexOf(_loc_2 + _loc_3) != -1)
            {
                
                _loc_3++;
            }
            this._-Q1.groups.push({name:_loc_2, pkgs:[]});
            var _loc_4:* = this._-A0.addItemFromPool().asButton;
            this._-A0.selectedIndex = this._-A0.numChildren - 1;
            _loc_4.text = _loc_2;
            var _loc_5:* = _loc_4.getChild("title") as ListItemInput;
            (_loc_5).addEventListener(_-Fr._-CF, this.__submit);
            _loc_5.startEditing();
            this._-9Q();
            this._-5A();
            return;
        }// end function

        private function _-2Z(event:Event) : void
        {
            if (this._-A0.numChildren == 0)
            {
                return;
            }
            var _loc_2:* = this._-A0.selectedIndex;
            if (_loc_2 == 0)
            {
                return;
            }
            this._-Q1.groups.splice((_loc_2 - 1), 1);
            this._-A0.removeChildAt(_loc_2);
            if (_loc_2 >= this._-A0.numChildren)
            {
                _loc_2 = this._-A0.numChildren - 1;
            }
            this._-A0.selectedIndex = _loc_2;
            this._-Da = -1;
            this._changed = false;
            this._needRefresh = true;
            _editor.project.saveSettings("packageGroups");
            this._-5A();
            return;
        }// end function

        private function _-Dy(event:Event) : void
        {
            if (this._-A0.numChildren == 0)
            {
                return;
            }
            var _loc_2:* = this._-A0.selectedIndex;
            if (_loc_2 == 0)
            {
                return;
            }
            var _loc_3:* = this._-A0.getChildAt(_loc_2).asButton;
            var _loc_4:* = _loc_3.getChild("title") as ListItemInput;
            (_loc_4).addEventListener(_-Fr._-CF, this.__submit);
            _loc_4.startEditing();
            return;
        }// end function

        private function _-7v(event:Event) : void
        {
            if (this._-A0.numChildren <= 2)
            {
                return;
            }
            var _loc_2:* = this._-A0.selectedIndex;
            if (_loc_2 <= 1)
            {
                return;
            }
            var _loc_3:* = _loc_2 - 1;
            var _loc_4:* = this._-Q1.groups[(_loc_3 - 1)];
            this._-Q1.groups[(_loc_3 - 1)] = this._-Q1.groups[_loc_3];
            this._-Q1.groups[_loc_3] = _loc_4;
            this._-A0.swapChildrenAt(_loc_2, (_loc_2 - 1));
            this._-A0.selectedIndex = _loc_2 - 1;
            this._-Da = _loc_2 - 1;
            this._-9Q();
            return;
        }// end function

        private function _-Md(event:Event) : void
        {
            if (this._-A0.numChildren <= 2)
            {
                return;
            }
            var _loc_2:* = this._-A0.selectedIndex;
            if (_loc_2 == 0 || _loc_2 == (this._-A0.numChildren - 1))
            {
                return;
            }
            var _loc_3:* = _loc_2 - 1;
            var _loc_4:* = this._-Q1.groups[(_loc_3 + 1)];
            this._-Q1.groups[(_loc_3 + 1)] = this._-Q1.groups[_loc_3];
            this._-Q1.groups[_loc_3] = _loc_4;
            this._-A0.swapChildrenAt(_loc_2, (_loc_2 + 1));
            this._-A0.selectedIndex = _loc_2 + 1;
            this._-Da = _loc_2 + 1;
            this._-9Q();
            return;
        }// end function

        private function __submit(event:Event) : void
        {
            var _loc_2:* = this._-A0.selectedIndex;
            var _loc_3:* = this._-A0.getChildAt(_loc_2).asButton;
            var _loc_4:* = event.currentTarget.text;
            this._-Q1.groups[(_loc_2 - 1)].name = _loc_4;
            this._-9Q();
            return;
        }// end function

        private function __clickItem(event:ItemEvent) : void
        {
            this._changed = true;
            return;
        }// end function

        private function _-Iw(event:Event) : void
        {
            this._changed = true;
            this._-Gh.selectAll();
            return;
        }// end function

        private function _-63(event:Event) : void
        {
            this._changed = true;
            this._-Gh.selectNone();
            return;
        }// end function

        private function _-6a(event:Event) : void
        {
            this._changed = true;
            this._-Gh.selectReverse();
            return;
        }// end function

        private function _-9Q() : void
        {
            var _loc_1:* = null;
            this._changed = false;
            this._needRefresh = true;
            if (this._-Da == 0)
            {
                _editor.workspaceSettings.set("myPackageGroup", this.getSelection());
            }
            else if (this._-Da > 0)
            {
                if (this._-Q1.groups.length == 0)
                {
                    return;
                }
                _loc_1 = this._-Q1.groups[(this._-Da - 1)];
                _loc_1.pkgs = this.getSelection();
                _editor.project.saveSettings("packageGroups");
            }
            return;
        }// end function

        private function getSelection() : Array
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_1:* = [];
            var _loc_2:* = this._-Gh.numChildren;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._-Gh.getChildAt(_loc_3).asButton;
                if (_loc_4.selected)
                {
                    _loc_1.push(_loc_4.name);
                }
                _loc_3++;
            }
            return _loc_1;
        }// end function

    }
}
