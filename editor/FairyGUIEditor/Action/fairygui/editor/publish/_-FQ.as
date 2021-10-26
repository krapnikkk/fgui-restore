package fairygui.editor.publish
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.gui.animation.*;
    import fairygui.editor.settings.*;
    import fairygui.utils.*;

    public class _-FQ extends _-CI
    {
        private var _-c:Object;
        private var _-Ns:Object;
        private var _-7d:Vector.<FPackageItem>;
        private static var _-4G:Vector.<String> = new Vector.<String>(3, true);

        public function _-FQ()
        {
            return;
        }// end function

        override public function run() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            this._-Ns = {};
            this._-7d = new Vector.<FPackageItem>;
            var _loc_1:* = PublishSettings(_-J.pkg.publishSettings).excludedList;
            if (_loc_1.length > 0)
            {
                this._-c = {};
                for each (_loc_4 in _loc_1)
                {
                    
                    this._-c[_loc_4] = false;
                }
            }
            var _loc_2:* = _-J.pkg.items;
            for each (_loc_3 in _loc_2)
            {
                
                _loc_3.setVar("pubInfo.added", undefined);
                _loc_3.setVar("pubInfo.highRes", undefined);
                _loc_3.setVar("pubInfo.branch", undefined);
                _loc_3.setVar("pubInfo.isFontLetter", undefined);
                _loc_3.setVar("pubInfo.keepOriginal", undefined);
                _loc_3._-e = _loc_3.id;
            }
            for each (_loc_3 in _loc_2)
            {
                
                if (_loc_3.exported)
                {
                    this.addItem(_loc_3);
                }
            }
            while (this._-7d.length > 0)
            {
                
                _loc_3 = this._-7d.pop();
                this._-E1(_loc_3);
            }
            _-J.items.sort(this._-NF);
            _-J._-FW.sort(this._-NF);
            for each (_loc_3 in _-J.items)
            {
                
                _loc_3.touch();
                if (_loc_3.isError)
                {
                    _-J2("file not exists, resource=[url=event:open]" + _loc_3.name + "[/url]", _loc_3);
                }
                _loc_3.addRef();
            }
            for each (_loc_3 in _-J._-FW)
            {
                
                _loc_3.addRef();
            }
            _stepCallback.callOnSuccess();
            return;
        }// end function

        private function _-NF(param1:FPackageItem, param2:FPackageItem) : int
        {
            var _loc_3:* = 0;
            if (param1.exported && !param2.exported)
            {
                return 1;
            }
            if (!param1.exported && param2.exported)
            {
                return -1;
            }
            _loc_3 = param1.type.localeCompare(param2.type);
            if (_loc_3 == 0)
            {
                _loc_3 = param1.id.localeCompare(param2.id);
            }
            return _loc_3;
        }// end function

        private function addItem(param1:FPackageItem, param2:Boolean = false) : void
        {
            if (param1.getVar("pubInfo.added"))
            {
                return;
            }
            if (this._-c && this._-c[param1.id] != undefined)
            {
                if (this._-c[param1.id] == false)
                {
                    this._-c[param1.id] = true;
                    var _loc_3:* = _-J;
                    var _loc_4:* = _loc_3._-BH + 1;
                    _loc_3._-BH = _loc_4;
                }
                return;
            }
            param1.setVar("pubInfo.added", true);
            if (!param2 && _loc_3._-Ho > 0)
            {
                if (_loc_3.includeBranches)
                {
                    if (param1.branch.length == 0)
                    {
                        this._-HA(param1);
                    }
                }
                else if (this.mergeBranch(param1))
                {
                    return;
                }
            }
            _loc_3.items.push(param1);
            if (param1.imageInfo)
            {
                if (_loc_3._-O4)
                {
                    this._-Ee(param1);
                }
                if (param1.type == FPackageItemType.MOVIECLIP)
                {
                    this._-ED(param1);
                }
                if (!param2)
                {
                    this._-Iv(param1);
                }
            }
            else if (param1.type == FPackageItemType.COMPONENT)
            {
                this._-7d.push(param1);
            }
            else if (param1.type == FPackageItemType.FONT)
            {
                this._-Po(param1);
            }
            return;
        }// end function

        private function _-Iv(param1:FPackageItem) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_2:* = _-J.includeHighResolution;
            var _loc_3:* = param1.path + param1.name;
            var _loc_4:* = 3;
            var _loc_5:* = 0;
            while (_loc_4 > 0)
            {
                
                _loc_7 = _loc_4 - 1;
                _-4G[_loc_7] = "";
                if ((_loc_2 & 1 >> _loc_7) != 0)
                {
                    _loc_6 = param1.owner.getItemByPath(_loc_3 + "@" + (_loc_4 + 1) + "x");
                    if (_loc_6 && _loc_6.type == param1.type)
                    {
                        this.addItem(_loc_6, true);
                        _-4G[_loc_7] = _loc_6.id;
                        _loc_5++;
                        break;
                    }
                }
                _loc_4 = _loc_4 - 1;
            }
            if (_loc_5 > 0)
            {
                if (_loc_5 == 1 && _-4G[0])
                {
                    param1.setVar("pubInfo.highRes", _-4G[0]);
                }
                else
                {
                    param1.setVar("pubInfo.highRes", _-4G.join(","));
                }
            }
            return;
        }// end function

        private function _-HA(param1:FPackageItem) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_8:* = null;
            var _loc_9:* = undefined;
            var _loc_5:* = _-J.project.allBranches;
            var _loc_6:* = _loc_5.length;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_8 = _loc_5[_loc_7];
                _loc_2 = "/:" + _loc_8 + param1.path + param1.name;
                _loc_3 = param1.owner.getItemByPath(_loc_2);
                if (_loc_3 && _loc_3.type == param1.type)
                {
                    _loc_9 = _-J._-GR[_loc_8];
                    if (_loc_9 == undefined)
                    {
                        _loc_9 = _-J._-1e;
                        _-J._-GR[_loc_8] = _loc_9;
                        var _loc_10:* = _-J;
                        var _loc_11:* = _loc_10._-1e + 1;
                        _loc_10._-1e = _loc_11;
                    }
                    if (!_loc_4)
                    {
                        _loc_4 = [];
                    }
                    _loc_4[_loc_9] = _loc_3.id;
                    this.addItem(_loc_3);
                }
                _loc_7++;
            }
            if (_loc_4)
            {
                param1.setVar("pubInfo.branch", _loc_4);
            }
            return;
        }// end function

        private function mergeBranch(param1:FPackageItem) : Boolean
        {
            var _loc_2:* = null;
            if (param1.branch.length == 0)
            {
                _loc_2 = param1.getVar("pubInfo.branch");
                if (!_loc_2)
                {
                    _loc_2 = _-J.pkg.getItemByPath("/:" + _-J.branch + param1.path + param1.name);
                    if (_loc_2 && _loc_2.type == param1.type)
                    {
                        _loc_2._-e = param1.id;
                        param1.setVar("pubInfo.branch", _loc_2);
                        _loc_2.setVar("pubInfo.branch", param1);
                        this.addItem(_loc_2);
                        return true;
                    }
                    return false;
                }
                else
                {
                    return true;
                }
            }
            else
            {
                _loc_2 = param1.getVar("pubInfo.branch");
                _loc_2 = _-J.pkg.getItemByPath(param1.path.substr(param1.branch.length + 2) + param1.name);
                param1._-e = _loc_2.id;
                param1.setVar("pubInfo.branch", _loc_2);
            }
            _loc_2.setVar("pubInfo.branch", param1);
            return false;
        }// end function

        private function _-ED(param1:FPackageItem) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_2:* = param1.getAnimation();
            if (_loc_2 != null)
            {
                _loc_3 = _loc_2.frameCount;
                for each (_loc_4 in _loc_2.textureList)
                {
                    
                    _loc_4.exportFrame = -1;
                }
                _loc_5 = 0;
                while (_loc_5 < _loc_3)
                {
                    
                    _loc_6 = _loc_2.frameList[_loc_5];
                    if (_loc_6.textureIndex != -1)
                    {
                        _loc_4 = _loc_11[_loc_6.textureIndex];
                        if (_loc_4.raw != null && _loc_4.exportFrame == -1)
                        {
                            _loc_4.exportFrame = _loc_5;
                        }
                    }
                    _loc_5++;
                }
                _loc_7 = XData.create("movieclip");
                _loc_7.setAttribute("interval", int(1000 / _loc_2.fps * (_loc_2.speed != 0 ? (_loc_2.speed) : (1))));
                if (_loc_2.repeatDelay)
                {
                    _loc_7.setAttribute("repeatDelay", int(1000 / _loc_2.fps * _loc_2.repeatDelay));
                }
                if (_loc_2.swing)
                {
                    _loc_7.setAttribute("swing", _loc_2.swing);
                }
                _loc_7.setAttribute("frameCount", _loc_3);
                _loc_8 = XData.create("frames");
                _loc_7.appendChild(_loc_8);
                _loc_5 = 0;
                while (_loc_5 < _loc_3)
                {
                    
                    _loc_6 = _loc_2.frameList[_loc_5];
                    _loc_9 = XData.create("frame");
                    _loc_8.appendChild(_loc_9);
                    _loc_9.setAttribute("rect", _loc_6.rect.x + "," + _loc_6.rect.y + "," + _loc_6.rect.width + "," + _loc_6.rect.height);
                    if (_loc_6.delay)
                    {
                        _loc_9.setAttribute("addDelay", int(1000 / _loc_2.fps * _loc_6.delay));
                    }
                    if (_loc_6.textureIndex != -1)
                    {
                        _loc_4 = _loc_11[_loc_6.textureIndex];
                        if (_loc_4.exportFrame != -1 && _loc_4.exportFrame != _loc_5)
                        {
                            _loc_9.setAttribute("sprite", _loc_4.exportFrame);
                        }
                    }
                    _loc_5++;
                }
                _-J.outputDesc[param1._-e + ".xml"] = _loc_7.toXML();
                if (!_-J._-O4)
                {
                    for each (_loc_4 in _loc_2.textureList)
                    {
                        
                        if (_loc_4.exportFrame != -1 && _loc_4.raw)
                        {
                            _-J.outputRes[param1._-e + "_" + _loc_4.exportFrame + ".png"] = _loc_4.raw;
                        }
                    }
                }
            }
            return;
        }// end function

        private function _-Ee(param1:FPackageItem) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = param1.getAtlasIndex();
            if (_loc_3 < 0)
            {
                _loc_2 = "atlas_" + param1._-e;
            }
            else
            {
                _loc_2 = "atlas" + _loc_3;
            }
            var _loc_4:* = this._-Ns[_loc_2];
            if (!this._-Ns[_loc_2])
            {
                _loc_4 = new _-Aw();
                _loc_4.id = _loc_2;
                _loc_4.index = _loc_3 < 0 ? (-1) : (_loc_3);
                if (_loc_3 == -2)
                {
                    _loc_4.npot = true;
                }
                else if (_loc_3 == -3)
                {
                    _loc_4.mof = true;
                }
                _-J._-K2.push(_loc_4);
                this._-Ns[_loc_2] = _loc_4;
            }
            _loc_4.items.push(param1);
            if (param1.imageInfo.format != "jpg")
            {
                _loc_4._-E0 = true;
            }
            if (_loc_4.index == -1 && _loc_4.npot)
            {
                param1.setVar("pubInfo.keepOriginal", true);
            }
            return;
        }// end function

        private function _-JW(param1:String) : FPackageItem
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (param1 && UtilsStr.startsWith(param1, "ui://"))
            {
                _loc_2 = param1.indexOf(",");
                if (_loc_2 != -1)
                {
                    param1 = param1.substr(0, _loc_2);
                }
                _loc_3 = param1.substr(5, 8);
                _loc_4 = _-J.project.getPackage(_loc_3);
                if (!_loc_4)
                {
                    return null;
                }
                if (_loc_4 != _-J.pkg)
                {
                    _-J._-DJ[_loc_4.id] = true;
                    return null;
                }
                _loc_5 = param1.substr(13);
                _loc_6 = _loc_4.getItem(_loc_5);
                if (_loc_6)
                {
                    this.addItem(_loc_6);
                }
                return _loc_6;
            }
            else
            {
                return null;
            }
        }// end function

        private function _-E1(param1:FPackageItem) : void
        {
            var cxml:XData;
            var dxml:XData;
            var it:XDataEnumerator;
            var ename:String;
            var cname:String;
            var str:String;
            var arr:Array;
            var src:String;
            var srcItem:FPackageItem;
            var hitTestXml:XData;
            var pkgId:String;
            var xml:XData;
            var col:Vector.<XData>;
            var cnt:int;
            var index:int;
            var defaultItem:String;
            var url:String;
            var listItem:FPackageItem;
            var gid:String;
            var pgid:String;
            var tp:String;
            var hitTestItem:FPackageItem;
            var pi:* = param1;
            try
            {
                xml = UtilsFile.loadXData(pi.file);
                if (!xml)
                {
                    return;
                }
            }
            catch (err:Error)
            {
                _-J2("XML format error, resource=[url=event:open]" + pi.name + "[/url]", pi);
                return;
            }
            xml.removeAttribute("resolution");
            xml.removeAttribute("copies");
            xml.removeAttribute("designImage");
            xml.removeAttribute("designImageOffsetX");
            xml.removeAttribute("designImageOffsetY");
            xml.removeAttribute("designImageAlpha");
            xml.removeAttribute("designImageLayer");
            xml.removeAttribute("designImageForTest");
            xml.removeAttribute("initName");
            xml.removeAttribute("bgColor");
            xml.removeAttribute("bgColorEnabled");
            xml.removeChildren("customProperty");
            var toDelete:* = new Vector.<XData>;
            var classInfo:Object;
            classInfo.classId = pi._-e;
            classInfo.className = pi.name;
            classInfo.superClassName = "G" + xml.getAttribute("extention", "Component");
            if (str != "ScrollBar")
            {
                _-J.outputClasses[pi._-e] = classInfo;
            }
            str = xml.getAttribute("customExtention");
            if (str)
            {
                classInfo.customSuperClassName = str;
                xml.removeAttribute("customExtention");
            }
            str = xml.getAttribute("remark");
            if (str)
            {
                classInfo.remark = str;
                xml.removeAttribute("remark");
                xml.setAttribute("customData", str);
            }
            var displayListNode:* = xml.getChild("displayList");
            str = xml.getAttribute("hitTest");
            if (str && displayListNode)
            {
                it = displayListNode.getEnumerator();
                while (it.moveNext())
                {
                    
                    cxml = it.current;
                    if (cxml.getAttribute("id") == str)
                    {
                        hitTestXml = cxml;
                        break;
                    }
                }
            }
            var members:Array;
            classInfo.members = members;
            it = xml.getEnumerator("controller");
            while (it.moveNext())
            {
                
                cxml = it.current;
                cxml.removeAttribute("exported");
                cxml.removeAttribute("alias");
                cxml.removeChildren("remark");
                members.push({name:cxml.getAttribute("name"), type:"Controller", index:it.index});
            }
            if (displayListNode)
            {
                col = displayListNode.getChildren();
                cnt = col.length;
                index;
                while (index < cnt)
                {
                    
                    cxml = col[index];
                    cxml.removeAttribute("aspect");
                    cxml.removeAttribute("locked");
                    cxml.removeAttribute("hideByEditor");
                    cxml.removeAttribute("fileName");
                    ename = cxml.getName();
                    cname = cxml.getAttribute("name");
                    src = cxml.getAttribute("src");
                    if (src)
                    {
                        pkgId = cxml.getAttribute("pkg");
                        if (pkgId == _-J.pkg.id)
                        {
                            cxml.removeAttribute("pkg");
                            pkgId;
                        }
                        if (!pkgId)
                        {
                            srcItem = _-J.pkg.getItem(src);
                            if (srcItem)
                            {
                                this.addItem(srcItem);
                            }
                            else
                            {
                                _-J2("child resource missing: " + src + ", resource=[url=event:open]" + pi.name + "[/url]", pi);
                            }
                        }
                        else
                        {
                            srcItem = _-J.project.getItem(pkgId, src);
                            if (srcItem)
                            {
                                _-J._-DJ[pkgId] = true;
                            }
                            else
                            {
                                _-J2("child resource missing: " + src + "@" + pkgId + ", resource=[url=event:open]" + pi.name + "[/url]");
                            }
                        }
                    }
                    switch(ename)
                    {
                        case "loader":
                        {
                            if (cxml.getAttributeBool("clearOnPublish"))
                            {
                                cxml.removeAttribute("clearOnPublish");
                                cxml.removeAttribute("url");
                            }
                            else
                            {
                                this._-JW(cxml.getAttribute("url"));
                            }
                            members.push({name:cname, type:"GLoader", index:index});
                            break;
                        }
                        case "list":
                        {
                            if (cxml.getAttributeBool("treeView"))
                            {
                                members.push({name:cname, type:"GTree", index:index});
                            }
                            else
                            {
                                members.push({name:cname, type:"GList", index:index});
                            }
                            defaultItem = cxml.getAttribute("defaultItem");
                            this._-JW(defaultItem);
                            if (cxml.getAttributeBool("autoClearItems"))
                            {
                                cxml.removeAttribute("autoClearItems");
                                cxml.removeChildren("item");
                            }
                            else
                            {
                                it = cxml.getEnumerator("item");
                                while (it.moveNext())
                                {
                                    
                                    dxml = it.current;
                                    url = dxml.getAttribute("url");
                                    if (url)
                                    {
                                        this._-JW(url);
                                    }
                                    str = dxml.getAttribute("icon");
                                    if (str)
                                    {
                                        this._-JW(str);
                                    }
                                    str = dxml.getAttribute("selectedIcon");
                                    if (str)
                                    {
                                        this._-JW(str);
                                    }
                                    if (dxml.getChild("property") || dxml.hasAttribute("controllers"))
                                    {
                                        listItem = _-J.project.getItemByURL(url ? (url) : (defaultItem));
                                        if (listItem && listItem.type == FPackageItemType.COMPONENT)
                                        {
                                            this._-5p(dxml, listItem);
                                            continue;
                                        }
                                        dxml.removeChildren("property");
                                        dxml.removeAttribute("controllers");
                                    }
                                }
                            }
                            str = cxml.getAttribute("scrollBarRes");
                            if (str)
                            {
                                arr = str.split(",");
                                this._-JW(arr[0]);
                                this._-JW(arr[1]);
                            }
                            str = cxml.getAttribute("ptrRes");
                            if (str)
                            {
                                arr = str.split(",");
                                this._-JW(arr[0]);
                                this._-JW(arr[1]);
                            }
                            break;
                        }
                        case "group":
                        {
                            if (!cxml.getAttributeBool("advanced"))
                            {
                                toDelete.push(cxml);
                                gid = cxml.getAttribute("id");
                                pgid = cxml.getAttribute("group");
                                var _loc_3:* = 0;
                                var _loc_4:* = col;
                                while (_loc_4 in _loc_3)
                                {
                                    
                                    dxml = _loc_4[_loc_3];
                                    if (dxml.getAttribute("group") == gid)
                                    {
                                        if (pgid)
                                        {
                                            dxml.setAttribute("group", pgid);
                                            continue;
                                        }
                                        dxml.removeAttribute("group");
                                    }
                                }
                            }
                            else
                            {
                                cxml.removeAttribute("collapsed");
                                members.push({name:cname, type:"GGroup", index:index});
                            }
                            break;
                        }
                        case "text":
                        case "richtext":
                        {
                            if (ename == "text")
                            {
                                if (cxml.getAttributeBool("input"))
                                {
                                    members.push({name:cname, type:"GTextInput", index:index});
                                }
                                else
                                {
                                    members.push({name:cname, type:"GTextField", index:index});
                                }
                            }
                            else
                            {
                                members.push({name:cname, type:"GRichTextField", index:index});
                            }
                            if (cxml.getAttributeBool("autoClearText"))
                            {
                                cxml.removeAttribute("autoClearText");
                                cxml.removeAttribute("text");
                            }
                            str = cxml.getAttribute("font");
                            if (str && UtilsStr.startsWith(str, "ui://") && str.length > 13)
                            {
                                pkgId = str.substr(5, 8);
                                _-J._-DJ[pkgId] = true;
                            }
                            break;
                        }
                        case "movieclip":
                        {
                            members.push({name:cname, type:"GMovieClip", index:index});
                            break;
                        }
                        case "jta":
                        {
                            cxml.setName("movieclip");
                            members.push({name:cname, type:"GMovieClip", index:index});
                            break;
                        }
                        case "image":
                        {
                            if (cxml.getAttributeBool("forHitTest"))
                            {
                                hitTestXml = cxml;
                                cxml.removeAttribute("forHitTest");
                            }
                            if (cxml.getAttributeBool("forMask"))
                            {
                                xml.setAttribute("mask", cxml.getAttribute("id"));
                                cxml.removeAttribute("forMask");
                            }
                            members.push({name:cname, type:"GImage", index:index});
                            break;
                        }
                        case "swf":
                        {
                            members.push({name:cname, type:"GSwfObject", index:index});
                            break;
                        }
                        case "graph":
                        {
                            if (cxml.getAttributeBool("forMask"))
                            {
                                xml.setAttribute("mask", cxml.getAttribute("id"));
                                cxml.removeAttribute("forMask");
                            }
                            members.push({name:cname, type:"GGraph", index:index});
                            break;
                        }
                        case "component":
                        {
                            if (srcItem)
                            {
                                if (srcItem.owner == _-J.pkg)
                                {
                                    members.push({name:cname, type:"GComponent", index:index, src:srcItem.name, src_id:src});
                                }
                                else
                                {
                                    members.push({name:cname, type:"GComponent", index:index, src:srcItem.name, src_id:src, pkg:srcItem.owner.name, pkg_id:srcItem.owner.id});
                                }
                            }
                            else
                            {
                                members.push({name:cname, type:"GComponent", index:index, src:null, src_id:src});
                            }
                            dxml = cxml.getChild("Button");
                            if (dxml)
                            {
                                this._-JW(dxml.getAttribute("icon"));
                                this._-JW(dxml.getAttribute("selectedIcon"));
                                this._-JW(dxml.getAttribute("sound"));
                            }
                            dxml = cxml.getChild("Label");
                            if (dxml)
                            {
                                this._-JW(dxml.getAttribute("icon"));
                            }
                            dxml = cxml.getChild("ComboBox");
                            if (dxml)
                            {
                                it = dxml.getEnumerator("item");
                                while (it.moveNext())
                                {
                                    
                                    this._-JW(it.current.getAttribute("icon"));
                                }
                                if (dxml.getAttributeBool("autoClearItems"))
                                {
                                    dxml.removeAttribute("autoClearItems");
                                    dxml.removeChildren("item");
                                }
                            }
                            break;
                        }
                        default:
                        {
                            _-J2("unknown display list item type: " + ename + ", resource=[url=event:open]" + pi.name + "[/url]");
                            break;
                            break;
                        }
                    }
                    if (srcItem && ename == "component")
                    {
                        this._-5p(cxml, srcItem);
                    }
                    dxml = cxml.getChild("gearIcon");
                    if (dxml)
                    {
                        str = dxml.getAttribute("values");
                        if (str)
                        {
                            arr = str.split("|");
                            var _loc_3:* = 0;
                            var _loc_4:* = arr;
                            while (_loc_4 in _loc_3)
                            {
                                
                                str = _loc_4[_loc_3];
                                this._-JW(str);
                            }
                        }
                        this._-JW(dxml.getAttribute("default"));
                    }
                    index = (index + 1);
                }
                var _loc_3:* = 0;
                var _loc_4:* = toDelete;
                while (_loc_4 in _loc_3)
                {
                    
                    cxml = _loc_4[_loc_3];
                    displayListNode.removeChild(cxml);
                }
            }
            cxml = xml.getChild("Button");
            if (cxml)
            {
                this._-JW(cxml.getAttribute("sound"));
            }
            cxml = xml.getChild("ComboBox");
            if (cxml)
            {
                this._-JW(cxml.getAttribute("dropdown"));
            }
            var transIt:* = xml.getEnumerator("transition");
            while (transIt.moveNext())
            {
                
                cxml = transIt.current;
                cname = cxml.getAttribute("name");
                members.push({name:cname, type:"Transition", index:transIt.index});
                it = cxml.getEnumerator("item");
                while (it.moveNext())
                {
                    
                    tp = it.current.getAttribute("type");
                    if (tp == "Sound" || tp == "Icon")
                    {
                        this._-JW(it.current.getAttribute("value"));
                    }
                }
            }
            str = xml.getAttribute("scrollBarRes");
            if (str)
            {
                arr = str.split(",");
                this._-JW(arr[0]);
                this._-JW(arr[1]);
            }
            str = xml.getAttribute("ptrRes");
            if (str)
            {
                arr = str.split(",");
                this._-JW(arr[0]);
                this._-JW(arr[1]);
            }
            if (hitTestXml)
            {
                src = hitTestXml.getAttribute("src");
                if (src)
                {
                    pkgId = hitTestXml.getAttribute("pkg");
                    if (!pkgId || pkgId == _-J.pkg.id)
                    {
                        xml.setAttribute("hitTest", src + "," + hitTestXml.getAttribute("xy"));
                        hitTestItem = _-J.pkg.getItem(src);
                        if (hitTestItem)
                        {
                            if (_-J._-FW.indexOf(hitTestItem) == -1)
                            {
                                _-J._-FW.push(hitTestItem);
                            }
                        }
                    }
                    else
                    {
                        _-J2("HitTest image in another pakcage! resource=[url=event:open]" + pi.name + "[/url]");
                    }
                }
                else
                {
                    xml.setAttribute("hitTest", hitTestXml.getAttribute("id"));
                }
            }
            _-J.outputDesc[pi._-e + ".xml"] = xml.toXML();
            return;
        }// end function

        private function _-5p(param1:XData, param2:FPackageItem) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_13:* = false;
            var _loc_3:* = null;
            var _loc_4:* = param1.getEnumerator("property");
            var _loc_5:* = param1.getName() == "item" ? ("controllers") : ("controller");
            while (_loc_4.moveNext())
            {
                
                _loc_7 = _loc_4.current;
                if (!_loc_3)
                {
                    _loc_3 = param2.getComponentData().getCustomProperties();
                    if (!_loc_3)
                    {
                        param1.removeChildren("property");
                        param1.removeAttribute(_loc_5);
                        break;
                    }
                }
                _loc_8 = _loc_7.getAttribute("target");
                _loc_9 = _loc_7.getAttributeInt("propertyId");
                if (this.getCustomProperty(_loc_3, _loc_8, _loc_9))
                {
                    if (_loc_9 == 1)
                    {
                        _loc_6 = _loc_7.getAttribute("value");
                        if (_loc_6)
                        {
                            this._-JW(_loc_6);
                        }
                    }
                    continue;
                }
                _loc_4.erase();
            }
            _loc_6 = param1.getAttribute(_loc_5);
            if (_loc_6)
            {
                if (!_loc_3)
                {
                    _loc_3 = param2.getComponentData().getCustomProperties();
                    if (!_loc_3)
                    {
                        param1.removeAttribute(_loc_5);
                    }
                }
                if (_loc_3)
                {
                    _loc_10 = _loc_6.split(",");
                    _loc_11 = _loc_10.length;
                    _loc_12 = 0;
                    _loc_13 = false;
                    while (_loc_12 < _loc_11)
                    {
                        
                        if (!this.getCustomProperty(_loc_3, _loc_10[_loc_12], -1))
                        {
                            _loc_10.splice(_loc_12, 2);
                            _loc_11 = _loc_11 - 2;
                            _loc_13 = true;
                            continue;
                        }
                        _loc_12 = _loc_12 + 2;
                    }
                    if (_loc_13)
                    {
                        if (_loc_11 == 0)
                        {
                            param1.removeAttribute(_loc_5);
                        }
                        else
                        {
                            param1.setAttribute(_loc_5, _loc_10.join(","));
                        }
                    }
                }
            }
            return;
        }// end function

        private function getCustomProperty(param1:Vector.<ComProperty>, param2:String, param3:int) : ComProperty
        {
            var _loc_6:* = null;
            var _loc_4:* = param1.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = param1[_loc_5];
                if (_loc_6.target == param2 && _loc_6.propertyId == param3)
                {
                    return _loc_6;
                }
                _loc_5++;
            }
            return null;
        }// end function

        private function _-Po(param1:FPackageItem) : void
        {
            var _loc_5:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_2:* = UtilsFile.loadString(param1.file);
            if (!_loc_2)
            {
                return;
            }
            var _loc_3:* = _loc_2.split("\n");
            var _loc_4:* = _loc_3.length;
            var _loc_6:* = {};
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_7 = _loc_3[_loc_5];
                if (!_loc_7)
                {
                }
                else
                {
                    _loc_8 = _loc_7.split(" ");
                    _loc_9 = 1;
                    while (_loc_9 < _loc_8.length)
                    {
                        
                        _loc_10 = _loc_8[_loc_9].split("=");
                        _loc_6[_loc_10[0]] = _loc_10[1];
                        _loc_9++;
                    }
                    _loc_7 = _loc_8[0];
                    if (_loc_7 == "char")
                    {
                        _loc_11 = this._-JW("ui://" + _-J.pkg.id + _loc_6.img);
                        if (_loc_11)
                        {
                            _loc_11.setVar("pubInfo.isFontLetter", true);
                        }
                    }
                    else if (_loc_7 == "info")
                    {
                        if (_loc_6.face != undefined)
                        {
                            break;
                        }
                    }
                }
                _loc_5++;
            }
            if (param1.fontSettings.texture)
            {
                _loc_11 = _-J.pkg.getItem(param1.fontSettings.texture);
                if (_loc_11)
                {
                    _-J._-BD[param1.fontSettings.texture] = param1;
                    this.addItem(_loc_11);
                    _loc_11.setVar("pubInfo.isFontLetter", true);
                }
            }
            return;
        }// end function

    }
}
