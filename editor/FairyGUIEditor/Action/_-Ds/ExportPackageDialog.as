package _-Ds
{
    import *.*;
    import _-NY.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.filesystem.*;
    import riaidea.utils.zip.*;

    public class ExportPackageDialog extends _-3g
    {
        private var _treeView:GTree;
        private var _-Gw:_-JG;

        public function ExportPackageDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "ExportPackageDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._treeView = contentPane.getChild("list").asTree;
            this._treeView.treeNodeRender = this.renderTreeNode;
            contentPane.getChild("ok").addClickListener(_-IJ);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            var _loc_4:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_1:* = _editor.libView.getSelectedResources(true);
            this._-Gw = new _-JG();
            this._-Gw._-5a(_loc_1, null, "/", _-y._-D0);
            var _loc_2:* = {};
            var _loc_3:* = new GTreeNode(true);
            _loc_3.data = "Assets";
            _loc_2["/"] = _loc_3;
            var _loc_5:* = this._-Gw._-CN.length;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_8 = this._-Gw._-CN[_loc_6].targetPath;
                if (!_loc_2[_loc_8])
                {
                    _loc_4 = _loc_3;
                    _loc_9 = _loc_8.length;
                    _loc_10 = 1;
                    _loc_7 = 1;
                    while (_loc_7 < _loc_9)
                    {
                        
                        if (_loc_8.charAt(_loc_7) == "/")
                        {
                            _loc_11 = _loc_8.substring(0, (_loc_7 + 1));
                            _loc_12 = _loc_2[_loc_11];
                            if (!_loc_12)
                            {
                                _loc_12 = new GTreeNode(true);
                                _loc_12.data = _loc_11.substring(_loc_10, _loc_7);
                                _loc_2[_loc_11] = _loc_12;
                                _loc_4.addChild(_loc_12);
                            }
                            _loc_4 = _loc_12;
                            _loc_10 = _loc_7 + 1;
                        }
                        _loc_7++;
                    }
                }
                _loc_6++;
            }
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_13 = this._-Gw._-CN[_loc_6].item;
                if (_loc_13.type == FPackageItemType.FOLDER)
                {
                }
                else
                {
                    _loc_4 = _loc_2[this._-Gw._-CN[_loc_6].targetPath];
                    _loc_12 = new GTreeNode(false);
                    _loc_12.data = _loc_13;
                    _loc_4.addChild(_loc_12);
                }
                _loc_6++;
            }
            this._treeView.rootNode.removeChildren();
            this._treeView.rootNode.addChild(_loc_3);
            this._treeView.expandAll();
            return;
        }// end function

        override public function _-2a() : void
        {
            UtilsFile.browseForSave("FairyGUI package", function (param1:File) : void
            {
                if (!param1.exists && (!param1.extension || param1.extension.toLowerCase() != "fairypackage"))
                {
                    doExport(new File(param1.nativePath + ".fairypackage"));
                }
                else
                {
                    doExport(param1);
                }
                return;
            }// end function
            );
            return;
        }// end function

        private function doExport(param1:File) : void
        {
            var proj:FProject;
            var pkg:IUIPackage;
            var zip:ZipArchive;
            var folder:File;
            var targetFile:* = param1;
            var tempFolder:* = File.createTempDirectory();
            try
            {
                FProject.createNew(tempFolder.nativePath, "tempProject", _editor.project.type);
                proj = new FProject(null);
                proj.open(tempFolder.resolvePath("tempProject.fairy"));
                pkg = proj.createPackage("Dummy");
                _editor.cursorManager.setWaitCursor(true);
                this._-Gw.copy(pkg, _-JG._-u);
                _editor.cursorManager.setWaitCursor(false);
                zip = new ZipArchive(null, "GBK");
                folder = new File(pkg.basePath);
                this._-1v(zip, folder, "");
                UtilsFile.saveBytes(targetFile, zip.output());
                proj.close();
                this.hide();
            }
            catch (err:Error)
            {
                _editor.alert(null, err);
            }
            finally
            {
                tempFolder.deleteDirectory(true);
            }
            return;
        }// end function

        private function _-1v(param1:ZipArchive, param2:File, param3:String) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_4:* = param2.getDirectoryListing();
            for each (_loc_5 in _loc_4)
            {
                
                if (_loc_5.isDirectory)
                {
                    _loc_6 = new ZipFile(param3 + _loc_5.name + "/");
                    param1.addFile(_loc_6);
                    this._-1v(param1, _loc_5, _loc_6.name);
                    continue;
                }
                param1.addFileFromBytes(param3 + _loc_5.name, UtilsFile.loadBytes(_loc_5));
            }
            return;
        }// end function

        private function renderTreeNode(param1:GTreeNode, param2:GComponent) : void
        {
            var _loc_5:* = null;
            var _loc_3:* = param2.asButton;
            var _loc_4:* = param2.getChild("sign") as GLoader;
            if (param1.isFolder)
            {
                _loc_3.title = String(param1.data);
                _loc_3.icon = Consts.icons.folder;
                _loc_4.url = null;
            }
            else
            {
                _loc_5 = param1.data as FPackageItem;
                _loc_3.title = _loc_5.title;
                _loc_3.icon = _loc_5.getIcon(param1.expanded);
                if (_loc_5.exported)
                {
                    _loc_4.url = "ui://Builder/bullet_red";
                }
                else
                {
                    _loc_4.url = null;
                }
            }
            return;
        }// end function

    }
}
