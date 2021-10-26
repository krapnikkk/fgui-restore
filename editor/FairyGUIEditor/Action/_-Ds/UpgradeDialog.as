package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.animation.*;
    import fairygui.utils.*;
    import flash.filesystem.*;
    import flash.system.*;

    public class UpgradeDialog extends _-3g
    {
        private var _-7b:GObject;
        private var _-BL:File;
        private var _-Hz:File;
        private var _-LF:File;
        private var _-A4:File;
        private var _settingsFolder:File;
        private var _-PQ:String;
        private var _nextId:uint;
        private var _-Bw:Boolean;
        private var _-7e:Object;
        private var _zipExt:String;
        private var _tasks:BulkTasks;

        public function UpgradeDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "UpgradeDialog").asCom;
            this.centerOn(_editor.groot, true);
            this.modal = true;
            this._-7b = contentPane.getChild("upgradeMsg");
            return;
        }// end function

        public function open(param1:File, param2:File) : void
        {
            var xml:XML;
            var sourceFolder:* = param1;
            var targetFolder:* = param2;
            this._-PQ = Utils.genDevCode();
            this._nextId = 0;
            this._-7e = {};
            this._-BL = sourceFolder;
            this._-Hz = targetFolder;
            var oldProjectXML:* = new XML(UtilsFile.loadString(sourceFolder.resolvePath("project.xml")));
            var str:* = oldProjectXML.@type;
            this._-Bw = str != "Flash";
            var projectXML:* = <projectDescription/>;
            projectXML.@id = oldProjectXML.@id;
            projectXML.@type = oldProjectXML.@type;
            projectXML.@version = "3";
            this._-LF = targetFolder.resolvePath("assets");
            this._-LF.createDirectory();
            this._settingsFolder = targetFolder.resolvePath("settings");
            this._settingsFolder.createDirectory();
            this._-A4 = targetFolder.resolvePath(".objs");
            this._-A4.createDirectory();
            UtilsFile.saveXML(targetFolder.resolvePath(oldProjectXML.@name + ".fairy"), projectXML);
            this._-9q(oldProjectXML);
            this._tasks = new BulkTasks(1);
            var packages:* = oldProjectXML.packages["package"];
            var _loc_4:* = 0;
            var _loc_5:* = packages;
            while (_loc_5 in _loc_4)
            {
                
                xml = _loc_5[_loc_4];
                this._tasks.addTask(this._-EY, xml);
            }
            this._tasks.start(function () : void
            {
                var _loc_1:* = null;
                var _loc_2:* = null;
                if (_zipExt)
                {
                    _loc_1 = _settingsFolder.resolvePath("Publish.json");
                    if (_loc_1.exists)
                    {
                        _loc_2 = UtilsFile.loadJSON(_loc_1);
                        _loc_2.fileExtension = _zipExt;
                        UtilsFile.saveJSON(_loc_1, _loc_2);
                    }
                }
                _editor.openProject(targetFolder.nativePath);
                return;
            }// end function
            );
            return;
        }// end function

        private function _-9q(param1:XML) : void
        {
            var workspace:Object;
            var data:Object;
            var cs:Object;
            var cxml:XML;
            var tmpMap:Object;
            var str:String;
            var publish_path:Object;
            var path:String;
            var maxUse:int;
            var defaultPublishPath:String;
            var pkgId:String;
            var t:int;
            var ss:Object;
            var col:XMLList;
            var dxml:XML;
            var key:String;
            var value:String;
            var xml:* = param1;
            try
            {
                workspace = UtilsFile.loadJSON(this._-BL.resolvePath("projectSettings.json"));
                if (workspace != null)
                {
                    tmpMap;
                    publish_path = workspace.publish_path;
                    if (publish_path)
                    {
                        var _loc_3:* = 0;
                        var _loc_4:* = publish_path;
                        while (_loc_4 in _loc_3)
                        {
                            
                            path = _loc_4[_loc_3];
                            t = tmpMap[path];
                            t = (t + 1);
                            tmpMap[path] = t;
                        }
                        maxUse;
                        var _loc_3:* = 0;
                        var _loc_4:* = tmpMap;
                        while (_loc_4 in _loc_3)
                        {
                            
                            path = _loc_4[_loc_3];
                            t = _loc_4[path];
                            if (t > maxUse)
                            {
                                maxUse = t;
                                defaultPublishPath = path;
                            }
                        }
                        var _loc_3:* = 0;
                        var _loc_4:* = publish_path;
                        while (_loc_4 in _loc_3)
                        {
                            
                            pkgId = _loc_4[_loc_3];
                            path = _loc_4[pkgId];
                            if (path != defaultPublishPath)
                            {
                                this._-7e[pkgId] = path.replace(/\\\\/g, "\\");
                            }
                        }
                        delete workspace.publish_path;
                    }
                    UtilsFile.saveJSON(this._-A4.resolvePath("workspace.json"), workspace);
                }
                data;
                if (defaultPublishPath)
                {
                    data.path = defaultPublishPath.replace(/\\\\/g, "\\");
                }
                cs;
                data.codeGeneration = cs;
                cs.codePath = String(xml.@targetPath);
                cs.classNamePrefix = String(xml.@classNamePrefix);
                cs.memberNamePrefix = String(xml.@memberNamePrefix);
                cs.packageName = String(xml.@packageName);
                str = xml.@ignoreNoname;
                if (str)
                {
                    cs.ignoreNoname = str == "true";
                }
                str = xml.@getMemberByName;
                if (str)
                {
                    cs.getMemberByName = str == "true";
                }
                str = xml.@codeType;
                if (str)
                {
                    cs.codeType = str;
                }
                UtilsFile.saveJSON(this._settingsFolder.resolvePath("Publish.json"), data, true);
                data;
                cxml = xml.textSetting[0];
                if (cxml)
                {
                    str = cxml.@font;
                    if (str)
                    {
                        data.font = str;
                    }
                    str = cxml.@size;
                    if (str)
                    {
                        data.fontSize = parseInt(str);
                    }
                    str = cxml.@color;
                    if (str)
                    {
                        data.textColor = str;
                    }
                    str = cxml.@originalPosition;
                    if (str == "false")
                    {
                        data.fontAdjustment = false;
                    }
                }
                cxml = xml.colorScheme[0];
                if (cxml)
                {
                    str = cxml.@value;
                    data.colorScheme = str.split("\r\n");
                }
                cxml = xml.fontSizeScheme[0];
                if (cxml)
                {
                    str = cxml.@value;
                    data.fontSizeScheme = str.split("\r\n");
                }
                cxml = xml.scrollBars[0];
                if (cxml)
                {
                    ss;
                    data.scrollBars = ss;
                    ss.vertical = String(cxml.@vertical);
                    ss.horizontal = String(cxml.@horizontal);
                    ss.defaultDisplay = String(cxml.@defaultDisplay);
                }
                UtilsFile.saveJSON(this._settingsFolder.resolvePath("Common.json"), data, true);
                cxml = xml.customProps[0];
                if (cxml)
                {
                    data;
                    col = cxml.elements();
                    var _loc_3:* = 0;
                    var _loc_4:* = col;
                    while (_loc_4 in _loc_3)
                    {
                        
                        dxml = _loc_4[_loc_3];
                        key = String(dxml.@key);
                        value = String(dxml.@value);
                        data[key] = value;
                    }
                    UtilsFile.saveJSON(this._settingsFolder.resolvePath("CustomProperties.json"), data, true);
                }
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        private function _-EY() : void
        {
            var itemXML:XML;
            var itemXML2:XML;
            var tmpXML:XML;
            var cname:String;
            var path:String;
            var name:String;
            var str:String;
            var folderId:String;
            var pkgXML2:XML;
            var publishXML:XML;
            var file1:File;
            var file2:File;
            var ani:AniDef;
            var pkgId:* = this._tasks.taskData.@id;
            var pkgName:* = this._tasks.taskData.@name;
            this._-7b.text = UtilsStr.formatString(Consts.strings.text315, pkgName);
            var pkgFolder1:* = this._-BL.resolvePath(pkgName);
            if (!pkgFolder1.exists)
            {
                this._tasks.finishItem();
                return;
            }
            var pkgXML1:* = UtilsFile.loadXML(pkgFolder1.resolvePath("package.xml"));
            if (pkgXML1 == null)
            {
                this._tasks.finishItem();
                return;
            }
            var pkgFolder2:* = this._-LF.resolvePath(pkgName);
            pkgFolder2.createDirectory();
            var folders:Object;
            var resources:* = pkgXML1.resources.elements();
            var _loc_2:* = 0;
            var _loc_3:* = resources;
            while (_loc_3 in _loc_2)
            {
                
                itemXML = _loc_3[_loc_2];
                name = itemXML.@name;
                itemXML.@name = name.replace(/[\:\/\\\*\?<>\|]/g, "_");
            }
            var _loc_2:* = 0;
            var _loc_3:* = resources;
            while (_loc_3 in _loc_2)
            {
                
                itemXML = _loc_3[_loc_2];
                cname = itemXML.name().localName;
                if (cname == "folder")
                {
                    path = this._-98(resources, itemXML);
                    folders[itemXML.@id] = path;
                    pkgFolder2.resolvePath("." + path).createDirectory();
                }
            }
            pkgXML2 = <packageDescription><resources/></packageDescription>;
            pkgXML2.@id = pkgId;
            str = pkgXML1.@jpegQuality;
            if (str)
            {
                pkgXML2.@jpegQuality = str;
            }
            str = pkgXML1.@compressPNG;
            if (str)
            {
                pkgXML2.@compressPNG = str;
            }
            var _loc_2:* = 0;
            var _loc_3:* = resources;
            while (_loc_3 in _loc_2)
            {
                
                itemXML = _loc_3[_loc_2];
                cname = itemXML.name().localName;
                if (cname == "folder")
                {
                    continue;
                }
                if (cname == "jta")
                {
                    cname;
                }
                itemXML2 = new XML("<" + cname + "/>");
                pkgXML2.resources.appendChild(itemXML2);
                itemXML2.@id = itemXML.@id;
                str = UtilsStr.getFileExt(itemXML.@file);
                name = itemXML.@name;
                if (UtilsStr.getFileExt(name) == str)
                {
                    if (itemXML.@exported != "true")
                    {
                        name = name.replace(/\./g, "_");
                    }
                }
                itemXML2.@name = name + (str ? ("." + str) : (""));
                folderId = itemXML.@folder;
                if (folderId)
                {
                    path = folders[folderId];
                    if (!path)
                    {
                        path;
                    }
                }
                else
                {
                    path;
                }
                itemXML2.@path = path;
                str = itemXML.@exported;
                if (str)
                {
                    itemXML2.@exported = str;
                }
                if (cname == "image" || cname == "movieclip")
                {
                    str = itemXML.@includedInAtlas;
                    if (str)
                    {
                        if (str == "no")
                        {
                            itemXML2.@atlas = "alone";
                        }
                        else if (str != "yes" && str != "default" && str != "0")
                        {
                            itemXML2.@atlas = str;
                        }
                    }
                    str = itemXML.@qualityOption;
                    if (str)
                    {
                        if (str != "package" && !(str == "source" && this._-Bw) && (str == "source" || str == "custom"))
                        {
                            itemXML2.@qualityOption = itemXML.@qualityOption;
                        }
                    }
                    str = itemXML.@scale;
                    if (str)
                    {
                        itemXML2.@scale = str;
                    }
                    str = itemXML.@scale9grid;
                    if (str)
                    {
                        itemXML2.@scale9grid = str;
                    }
                    str = itemXML.@gridTile;
                    if (str)
                    {
                        itemXML2.@gridTile = str;
                    }
                    str = itemXML.@quality;
                    if (str)
                    {
                        itemXML2.@quality = str;
                    }
                }
                file1 = pkgFolder1.resolvePath(itemXML.@file);
                file2 = pkgFolder2.resolvePath("." + path + itemXML2.@name);
                if (cname == "movieclip")
                {
                    ani = new AniDef();
                    try
                    {
                        ani.load(UtilsFile.loadBytes(file1));
                        UtilsFile.saveBytes(file2, ani.save());
                    }
                    catch (err:Error)
                    {
                    }
                    continue;
                }
                if (cname == "font")
                {
                    UtilsFile.copyFile(file1, file2);
                    file1 = pkgFolder1.resolvePath(itemXML.@id + "_.png");
                    if (file1.exists)
                    {
                        file2 = pkgFolder2.resolvePath("." + path + name + "_atlas.png");
                        UtilsFile.copyFile(file1, file2);
                        tmpXML = <image/>;
                        tmpXML.@id = this.getNextId();
                        tmpXML.@name = name + "_atlas.png";
                        tmpXML.@path = itemXML2.@path;
                        str = itemXML.@atlas;
                        if (str)
                        {
                            if (str == "no")
                            {
                                tmpXML.@atlas = "alone";
                            }
                            else if (str != "yes" && str != "default" && str != "0")
                            {
                                tmpXML.@atlas = str;
                            }
                        }
                        pkgXML2.resources.appendChild(tmpXML);
                        itemXML2.@texture = tmpXML.@id;
                    }
                    continue;
                }
                UtilsFile.copyFile(file1, file2);
            }
            publishXML = pkgXML1.publish[0];
            if (publishXML)
            {
                if (this._-7e[pkgId])
                {
                    publishXML.@path = this._-7e[pkgId];
                }
                str = publishXML.@singlePackage;
                if (str == "true")
                {
                    publishXML.@packageCount = "1";
                }
                str = publishXML.@zipExt;
                if (str)
                {
                    this._zipExt = str;
                }
                delete publishXML.@zipExt;
                pkgXML2.appendChild(publishXML);
            }
            UtilsFile.saveXML(pkgFolder2.resolvePath("package.xml"), pkgXML2);
            System.disposeXML(pkgXML1);
            System.disposeXML(pkgXML2);
            GTimers.inst.add(12, 1, this._tasks.finishItem);
            return;
        }// end function

        public function getNextId() : String
        {
            var _loc_1:* = this;
            _loc_1._nextId = this._nextId + 1;
            return this._-PQ + (this._nextId++).toString(36);
        }// end function

        private function _-98(param1:XMLList, param2:XML) : String
        {
            var p:XML;
            var resources:* = param1;
            var cur:* = param2;
            var ret:Array;
            ret.push(cur.@name);
            var parentFolderId:* = cur.@folder;
            while (parentFolderId != "")
            {
                
                var _loc_5:* = 0;
                var _loc_6:* = resources;
                var _loc_4:* = new XMLList("");
                for each (_loc_7 in _loc_6)
                {
                    
                    var _loc_8:* = _loc_6[_loc_5];
                    with (_loc_6[_loc_5])
                    {
                        if (@id == parentFolderId)
                        {
                            _loc_4[_loc_5] = _loc_7;
                        }
                    }
                }
                p = _loc_4[0];
                if (!p)
                {
                    break;
                }
                ret.push(p.@name);
                parentFolderId = p.@folder;
                if (ret.indexOf(parentFolderId) != -1)
                {
                    break;
                }
            }
            ret.reverse();
            if (ret.length == 0)
            {
                return "/";
            }
            return "/" + ret.join("/") + "/";
        }// end function

    }
}
