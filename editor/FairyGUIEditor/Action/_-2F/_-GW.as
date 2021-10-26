package _-2F
{
    import *.*;
    import _-Ds.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import flash.desktop.*;
    import flash.events.*;

    public class _-GW extends Object
    {
        private var _editor:IEditor;
        private var _-68:PopupMenu;
        private var _-Kz:PopupMenu;
        private var _-IP:Vector.<FPackageItem>;

        public function _-GW(param1:IEditor) : void
        {
            var _loc_2:* = null;
            this._editor = param1;
            this._-IP = new Vector.<FPackageItem>;
            this._-Kz = new PopupMenu();
            this._-Kz.contentPane.width = 210;
            _loc_2 = this._-Kz.addItem(Consts.strings.text236 + "...", this._-DR);
            _loc_2.name = "property";
            this._-Kz.addSeperator();
            this._-Kz.addItem(Consts.strings.text2, this._-5G).name = "copy";
            this._-Kz.addItem(Consts.strings.text245 + "...", this._-Bv).name = "move";
            this._-Kz.addItem(Consts.strings.text25, this._-Lr).name = "delete";
            this._-Kz.addSeperator();
            this._-Kz.addItem(Consts.strings.text16, this._-H2).name = "copyLink";
            this._-Kz.addItem(Consts.strings.text194, this._-Bj).name = "copyName";
            this._-Kz.addItem(Consts.strings.text171 + "...", this._-M2).name = "findRef";
            this._-Kz.addSeperator();
            this._-Kz.addItem(Consts.strings.text20, this._-II).name = "setExport";
            this._-Kz.addItem(Consts.strings.text21, this._-2S).name = "setNotExport";
            this._-Kz.addItem(Consts.strings.text334, this._-D4).name = "favorite";
            this._-Kz.addSeperator();
            this._-Kz.addItem(Consts.strings.text22 + "...", this._-6c).name = "update";
            this._-Kz.addItem(Consts.strings.text11, this._-DV).name = "showInLib";
            this._-Kz.addItem(Consts.strings.text192, this._-Gb).name = "openWithExternal";
            this._-Kz.addItem(Consts.isMacOS ? (Consts.strings.text90) : (Consts.strings.text24), this._-M3).name = "openInExplorer";
            return;
        }// end function

        public function get _-H0() : Vector.<FPackageItem>
        {
            return this._-IP;
        }// end function

        public function show(event:ItemEvent) : void
        {
            if (this._-IP.length == 0)
            {
                return;
            }
            var _loc_2:* = this._-IP[0];
            var _loc_3:* = _loc_2.type == FPackageItemType.FOLDER;
            if (_loc_2.isRoot || _loc_2.isBranchRoot)
            {
                this._-Kz.setItemGrayed("property", true);
                this._-Kz.setItemGrayed("copy", true);
                this._-Kz.setItemGrayed("move", true);
                this._-Kz.setItemGrayed("delete", true);
                this._-Kz.setItemGrayed("copyLink", true);
                this._-Kz.setItemGrayed("findRef", true);
                this._-Kz.setItemGrayed("update", true);
                this._-Kz.setItemGrayed("setExport", true);
                this._-Kz.setItemGrayed("setNotExport", true);
                this._-Kz.setItemGrayed("favorite", true);
                this._-Kz.setItemGrayed("openWithExternal", false);
            }
            else if (_loc_3)
            {
                this._-Kz.setItemGrayed("property", false);
                this._-Kz.setItemGrayed("copy", false);
                this._-Kz.setItemGrayed("move", false);
                this._-Kz.setItemGrayed("delete", false);
                this._-Kz.setItemGrayed("copyLink", true);
                this._-Kz.setItemGrayed("findRef", true);
                this._-Kz.setItemGrayed("update", true);
                this._-Kz.setItemGrayed("setExport", false);
                this._-Kz.setItemGrayed("setNotExport", false);
                this._-Kz.setItemGrayed("favorite", false);
                this._-Kz.setItemGrayed("openWithExternal", true);
            }
            else
            {
                this._-Kz.setItemGrayed("property", _loc_2.type != FPackageItemType.IMAGE && _loc_2.type != FPackageItemType.MOVIECLIP);
                this._-Kz.setItemGrayed("copy", false);
                this._-Kz.setItemGrayed("move", false);
                this._-Kz.setItemGrayed("delete", false);
                this._-Kz.setItemGrayed("copyLink", false);
                this._-Kz.setItemGrayed("findRef", false);
                this._-Kz.setItemGrayed("update", false);
                this._-Kz.setItemGrayed("setExport", false);
                this._-Kz.setItemGrayed("setNotExport", false);
                this._-Kz.setItemGrayed("favorite", false);
                this._-Kz.setItemGrayed("openWithExternal", false);
            }
            this._-Kz.setItemText("favorite", _loc_2.favorite ? (Consts.strings.text335) : (Consts.strings.text334));
            this._-Kz.show(this._editor.groot);
            return;
        }// end function

        private function _-DR(event:Event) : void
        {
            this._editor.libView.openResources(this._-IP);
            return;
        }// end function

        private function _-5G(event:Event) : void
        {
            _-Ia.setValue(_-Ia._-Kf, this._-IP.concat());
            return;
        }// end function

        private function _-Bv(event:Event) : void
        {
            var evt:* = event;
            ChooseFolderDialog(this._editor.getDialog(ChooseFolderDialog)).open(null, function (param1:FPackageItem) : void
            {
                _editor.libView.moveResources(param1, _-IP);
                return;
            }// end function
            );
            return;
        }// end function

        private function _-Lr(event:Event) : void
        {
            this._editor.libView.deleteResources(this._-IP);
            return;
        }// end function

        private function _-II(event:Event) : void
        {
            this._editor.libView.setResourcesExported(this._-IP, true);
            return;
        }// end function

        private function _-2S(event:Event) : void
        {
            this._editor.libView.setResourcesExported(this._-IP, false);
            return;
        }// end function

        private function _-D4(event:Event) : void
        {
            this._editor.libView.setResourcesFavorite(this._-IP, !this._-IP[0].favorite);
            return;
        }// end function

        private function _-6c(event:Event) : void
        {
            this._editor.libView.showUpdateResourceDialog(this._-IP[0]);
            return;
        }// end function

        private function _-H2(event:Event) : void
        {
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this._-IP[0].getURL());
            return;
        }// end function

        private function _-Bj(event:Event) : void
        {
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this._-IP[0].name);
            return;
        }// end function

        private function _-M2(event:Event) : void
        {
            this._editor.findReference(this._-IP[0].getURL());
            return;
        }// end function

        private function _-DV(event:Event) : void
        {
            this._editor.libView.highlight(this._-IP[0]);
            return;
        }// end function

        private function _-M3(event:Event) : void
        {
            this._editor.libView.showResourceInExplorer(this._-IP[0]);
            return;
        }// end function

        private function _-Gb(event:Event) : void
        {
            this._-IP[0].openWithDefaultApplication();
            return;
        }// end function

    }
}
