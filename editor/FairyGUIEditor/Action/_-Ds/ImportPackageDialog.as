package _-Ds
{
    import *.*;
    import _-2F.*;
    import _-NY.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.filesystem.*;

    public class ImportPackageDialog extends _-3g
    {
        private var _projectView:_-Dc;
        private var _-FB:IUIPackage;
        private var _path:FPackageItem;
        private var _-Gw:_-JG;

        public function ImportPackageDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "ImportPackageDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._projectView = new _-Dc(param1, contentPane.getChild("list").asTree);
            this._projectView._-FC = this._-FC;
            this.contentPane.getChild("browse").addClickListener(this._-90);
            contentPane.getChild("ok").addClickListener(_-IJ);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onHide() : void
        {
            var folder:File;
            super.onHide();
            if (this._-FB)
            {
                try
                {
                    folder = new File(this._-FB.project.basePath);
                    if (folder.exists)
                    {
                        folder.deleteDirectory(true);
                    }
                }
                catch (err:Error)
                {
                }
                FProject(this._-FB.project).close();
                this._-FB = null;
            }
            return;
        }// end function

        public function open(param1:File) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_2:* = File.createTempDirectory();
            FProject.createNew(_loc_2.nativePath, "tempProject", _editor.project.type);
            var _loc_3:* = new FProject(null);
            _loc_3.open(_loc_2.resolvePath("tempProject.fairy"));
            var _loc_4:* = new File(_loc_3.assetsPath).resolvePath("assets");
            _loc_4.createDirectory();
            var _loc_5:* = new ZipReader(UtilsFile.loadBytes(param1));
            for each (_loc_6 in _loc_5.entries)
            {
                
                _loc_7 = _loc_4.resolvePath(_loc_6.name);
                _loc_8 = _loc_7.parent;
                if (!_loc_8.exists)
                {
                    _loc_8.createDirectory();
                }
                UtilsFile.saveBytes(_loc_7, _loc_5.getEntryData(_loc_6.name));
            }
            this._-FB = _loc_3.addPackage(_loc_4);
            this._projectView._-5Q(null, true, true);
            this._projectView.expand(this._-FB.rootItem);
            contentPane.getController("c1").selectedIndex = 0;
            contentPane.getChild("targetPackage").text = UtilsStr.getFileName(param1.name);
            this._path = _editor.getActiveFolder();
            this._-2x(this._path);
            show();
            return;
        }// end function

        override public function _-2a() : void
        {
            var path:FPackageItem;
            var toNew:Boolean;
            var pkg:IUIPackage;
            toNew = contentPane.getController("c1").selectedIndex == 0;
            if (toNew)
            {
                try
                {
                    pkg = _editor.project.createPackage(contentPane.getChild("targetPackage").text);
                    path = pkg.rootItem;
                }
                catch (err:Error)
                {
                    _editor.alert(null, err);
                    return;
                }
            }
            else
            {
                path = this._path;
                pkg = path.owner;
            }
            this._-Gw = new _-JG();
            this._-Gw._-5a(this._-FB.items, pkg, path.id, _-y._-Hs);
            var func:* = function (param1:int) : void
            {
                _editor.cursorManager.setWaitCursor(true);
                _-Gw.copy(pkg, param1);
                _editor.cursorManager.setWaitCursor(false);
                if (toNew)
                {
                    _editor.libView.highlight(pkg.rootItem);
                }
                hide();
                return;
            }// end function
            ;
            if (this._-Gw._-LR > 0)
            {
                PasteOptionDialog(_editor.getDialog(PasteOptionDialog)).open(func);
            }
            else
            {
                this.func(_-JG._-IT);
            }
            return;
        }// end function

        private function _-FC(param1:FPackageItem, param2:Array, param3:Vector.<FPackageItem>) : Vector.<FPackageItem>
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (!param3)
            {
                param3 = new Vector.<FPackageItem>;
            }
            if (param1 == null)
            {
                _loc_4 = this._-FB.project.allPackages;
                for each (_loc_5 in _loc_4)
                {
                    
                    param3.push(_loc_5.rootItem);
                }
            }
            else
            {
                param1.owner.getItemListing(param1, param2, true, false, param3);
            }
            return param3;
        }// end function

        private function _-90(event:Event) : void
        {
            ChooseFolderDialog(_editor.getDialog(ChooseFolderDialog)).open(this._path, this._-2x);
            return;
        }// end function

        private function _-2x(param1:FPackageItem) : void
        {
            this._path = param1;
            contentPane.getChild("targetLocation").text = "/" + this._path.owner.name + this._path.id;
            return;
        }// end function

    }
}
