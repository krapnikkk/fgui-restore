package _-Ds
{
    import *.*;
    import _-2F.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import flash.events.*;

    public class AtlasDefinitionDialog extends _-3g
    {
        private var _atlasList:GList;
        private var _-JU:GList;
        private var _-DG:NumericInput;
        private var _compression:GButton;
        private var _selectedPkg:IUIPackage;
        private var _-Kz:_-GW;
        private var _-J6:Vector.<AtlasSettingsBrief>;
        private var _-3F:Vector.<FPackageItem>;
        private static var helperIntList:Vector.<int> = new Vector.<int>;

        public function AtlasDefinitionDialog(param1:IEditor) : void
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "AtlasDefinitionDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._atlasList = contentPane.getChild("atlasList").asList;
            this._atlasList.itemRenderer = this._-GG;
            this._atlasList.addEventListener(ItemEvent.CLICK, this._-Ar);
            this._-JU = contentPane.getChild("resList").asList;
            this._-JU.itemRenderer = this.renderListItem;
            this._-JU.addEventListener(ItemEvent.CLICK, this.__clickItem);
            this._compression = contentPane.getChild("compression").asButton;
            this._compression.addEventListener(StateChangeEvent.CHANGED, this._-HR);
            this._-DG = contentPane.getChild("max") as NumericInput;
            this._-DG.min = 5;
            this._-DG.max = 100;
            this._-DG.addEventListener(_-Fr._-CF, this._-OT);
            contentPane.getChild("close").addClickListener(closeEventHandler);
            this._-Kz = new _-GW(param1);
            this._-J6 = new Vector.<AtlasSettingsBrief>;
            this._-3F = new Vector.<FPackageItem>;
            return;
        }// end function

        public function open(param1:IUIPackage) : void
        {
            this._selectedPkg = param1;
            var _loc_2:* = PublishSettings(this._selectedPkg.publishSettings);
            var _loc_3:* = _loc_2.atlasList;
            var _loc_4:* = _loc_3.length;
            this._-AG(_loc_4);
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                this._-J6[_loc_5].read(_loc_3[_loc_5]);
                _loc_5++;
            }
            _loc_5 = _loc_4;
            while (_loc_5 < this._-J6.length)
            {
                
                this._-J6[_loc_5].reset();
                _loc_5++;
            }
            this._atlasList.numItems = _loc_4 + 1;
            if (this._atlasList.selectedIndex == -1)
            {
                this._atlasList.selectedIndex = 0;
            }
            this._-DG.value = _loc_4 - 1;
            this._-Ar(null);
            show();
            return;
        }// end function

        override protected function onShown() : void
        {
            _editor.on(EditorEvent.PackageItemChanged, this._-E2);
            return;
        }// end function

        override protected function onHide() : void
        {
            _editor.off(EditorEvent.PackageItemChanged, this._-E2);
            return;
        }// end function

        private function _-E2(param1:FPackageItem) : void
        {
            if (!param1.imageSettings)
            {
                return;
            }
            var _loc_2:* = this._atlasList.selectedIndex;
            if (_loc_2 == (this._atlasList.numItems - 1))
            {
                _loc_2 = -1;
            }
            var _loc_3:* = param1.getAtlasIndex();
            var _loc_4:* = _loc_3 == _loc_2 || _loc_2 < 0 && _loc_3 < 0;
            var _loc_5:* = this._-3F.indexOf(param1) != -1;
            if (_loc_4 != _loc_5)
            {
                this._-B8();
            }
            return;
        }// end function

        private function _-AG(param1:int) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = this._-J6.length;
            var _loc_3:* = _loc_2;
            while (_loc_3 < param1)
            {
                
                _loc_4 = new AtlasSettingsBrief();
                this._-J6.push(_loc_4);
                _loc_3++;
            }
            return;
        }// end function

        private function _-GG(param1:int, param2:GObject) : void
        {
            var _loc_6:* = null;
            var _loc_3:* = param2.asButton;
            var _loc_4:* = _loc_3.getChild("name");
            var _loc_5:* = _loc_3.getChild("index");
            if (param1 == (this._atlasList.numChildren - 1))
            {
                _loc_5.text = "-";
                _loc_4.text = Consts.strings.text438;
            }
            else
            {
                _loc_6 = this._-J6[param1];
                _loc_5.text = "" + param1;
                _loc_4.text = _loc_6.name;
                _loc_4.addEventListener(_-Fr._-CF, this._-1i);
            }
            return;
        }// end function

        private function _-B8() : void
        {
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_1:* = this._atlasList.selectedIndex;
            if (_loc_1 == (this._atlasList.numItems - 1))
            {
                _loc_1 = -1;
            }
            this._-3F.length = 0;
            var _loc_2:* = this._selectedPkg.items;
            var _loc_3:* = _loc_2.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = _loc_2[_loc_4];
                if (_loc_5.imageSettings)
                {
                    _loc_6 = _loc_5.getAtlasIndex();
                    if (_loc_6 == _loc_1 || _loc_1 < 0 && _loc_6 < 0)
                    {
                        this._-3F.push(_loc_5);
                    }
                }
                _loc_4++;
            }
            this._-3F.sort(_-FL);
            this._-JU.numItems = this._-3F.length;
            this._-JU.selectedIndex = -1;
            if (_loc_1 != -1)
            {
                this._compression.visible = this._selectedPkg.project.isH5;
                this._compression.selected = this._-J6[_loc_1].compression;
            }
            else
            {
                this._compression.visible = false;
            }
            return;
        }// end function

        private function renderListItem(param1:int, param2:GObject) : void
        {
            var _loc_3:* = ListItem(param2);
            _loc_3.width = 120;
            var _loc_4:* = this._-3F[param1];
            var _loc_5:* = _loc_4.name;
            if (_loc_4.branch.length > 0)
            {
                _loc_5 = _loc_5 + ("  (" + _loc_4.branch + ")");
            }
            _loc_3.text = _loc_5;
            _loc_3.icon = _loc_4.getIcon();
            _loc_3.data = _loc_4;
            return;
        }// end function

        private function save() : void
        {
            var _loc_5:* = null;
            var _loc_1:* = PublishSettings(this._selectedPkg.publishSettings);
            var _loc_2:* = _loc_1.atlasList;
            var _loc_3:* = this._atlasList.numItems - 1;
            _loc_2.length = _loc_3;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = _loc_2[_loc_4];
                if (!_loc_5)
                {
                    _loc_5 = new AtlasSettings();
                    _loc_5.copyFrom(_loc_2[0]);
                    _loc_2[_loc_4] = _loc_5;
                }
                this._-J6[_loc_4].write(_loc_5);
                _loc_4++;
            }
            this._selectedPkg.save();
            return;
        }// end function

        private function _-Ar(event:ItemEvent) : void
        {
            this._-B8();
            return;
        }// end function

        private function __clickItem(event:ItemEvent) : void
        {
            var _loc_2:* = FPackageItem(event.itemObject.data);
            if (event.clickCount == 2)
            {
                _editor.libView.openResource(_loc_2);
            }
            else
            {
                if (event.rightButton)
                {
                    this._-Nx();
                    this._-Kz.show(event);
                }
                _editor.showPreview(_loc_2);
            }
            return;
        }// end function

        public function _-Nx() : void
        {
            helperIntList.length = 0;
            var _loc_1:* = this._-JU.getSelection(helperIntList);
            var _loc_2:* = this._-Kz._-H0;
            _loc_2.length = 0;
            var _loc_3:* = _loc_1.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2.push(this._-3F[_loc_1[_loc_4]]);
                _loc_4++;
            }
            return;
        }// end function

        private function _-HR(event:Event) : void
        {
            this._-J6[this._atlasList.selectedIndex].compression = event.currentTarget.selected;
            this.save();
            return;
        }// end function

        private function _-1i(event:Event) : void
        {
            var _loc_2:* = this._atlasList.getChildIndex(event.currentTarget.parent);
            this._-J6[_loc_2].name = event.currentTarget.text;
            this.save();
            return;
        }// end function

        private function _-OT(event:Event) : void
        {
            var _loc_2:* = this._-DG.value;
            this._-AG((_loc_2 + 1));
            this._atlasList.numItems = _loc_2 + 2;
            this.save();
            return;
        }// end function

        private static function _-FL(param1:FPackageItem, param2:FPackageItem) : int
        {
            var _loc_3:* = 0;
            _loc_3 = param1.type.localeCompare(param2.type);
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

import *.*;

import _-2F.*;

import _-Gs.*;

import __AS3__.vec.*;

import fairygui.*;

import fairygui.editor.*;

import fairygui.editor.api.*;

import fairygui.editor.gui.*;

import fairygui.editor.settings.*;

import fairygui.event.*;

import flash.events.*;

class AtlasSettingsBrief extends Object
{
    public var name:String;
    public var compression:Boolean;

    function AtlasSettingsBrief() : void
    {
        this.name = "";
        return;
    }// end function

    public function read(param1:AtlasSettings) : void
    {
        this.name = param1.name;
        this.compression = param1.compression;
        return;
    }// end function

    public function write(param1:AtlasSettings) : void
    {
        param1.name = this.name;
        param1.compression = this.compression;
        return;
    }// end function

    public function reset() : void
    {
        this.name = "";
        this.compression = false;
        return;
    }// end function

}

