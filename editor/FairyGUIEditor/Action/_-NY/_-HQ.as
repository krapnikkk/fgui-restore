package _-NY
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.api.*;
    import fairygui.utils.*;
    import flash.filesystem.*;
    import flash.system.*;

    public class _-HQ extends Object
    {
        private var _editor:IEditor;
        private var _-HX:Array;
        private var _-C5:Boolean;
        private var _-Ax:String;
        private var _-De:String;
        private var _-FM:Array;

        public function _-HQ(param1:IEditor)
        {
            this._editor = param1;
            return;
        }// end function

        public function parse(param1:Vector.<IUIPackage>, param2:Boolean = true) : void
        {
            var pkg:IUIPackage;
            var result:Array;
            var items:Array;
            var pkgFolder:File;
            var pkgXML:XData;
            var branches:Vector.<String>;
            var branch:String;
            var data:Object;
            var resNode:XData;
            var xml:XML;
            var item:Object;
            var pkgs:* = param1;
            var ignoreDiscarded:* = param2;
            this._-C5 = ignoreDiscarded;
            this._-HX = [];
            this._-FM = [];
            var _loc_4:* = 0;
            var _loc_5:* = pkgs;
            while (_loc_5 in _loc_4)
            {
                
                pkg = _loc_5[_loc_4];
                this._-Ax = pkg.id;
                result;
                this._-HX.push(result);
                items;
                pkgFolder = new File(this._editor.project.assetsPath + "/" + pkg.name);
                pkgXML = UtilsFile.loadXData(pkgFolder.resolvePath("package.xml"));
                if (pkgXML)
                {
                    resNode = pkgXML.getChild("resources");
                    if (resNode)
                    {
                        this.parseItems(resNode.getChildren(), pkgFolder, items);
                    }
                }
                branches = this._editor.project.allBranches;
                var _loc_6:* = 0;
                var _loc_7:* = branches;
                while (_loc_7 in _loc_6)
                {
                    
                    branch = _loc_7[_loc_6];
                    pkgFolder = new File(this._editor.project.basePath + "/assets_" + branch + "/" + pkg.name);
                    if (pkgFolder.exists)
                    {
                        pkgXML = UtilsFile.loadXData(pkgFolder.resolvePath("package_branch.xml"));
                        if (pkgXML)
                        {
                            resNode = pkgXML.getChild("resources");
                            if (resNode)
                            {
                                this.parseItems(resNode.getChildren(), pkgFolder, items);
                            }
                        }
                    }
                }
                items.sortOn("name");
                var _loc_6:* = 0;
                var _loc_7:* = items;
                while (_loc_7 in _loc_6)
                {
                    
                    data = _loc_7[_loc_6];
                    this._-De = data.id;
                    this._-FM.length = 0;
                    try
                    {
                        xml = UtilsFile.loadXML(data.file);
                        if (!xml)
                        {
                            return;
                        }
                    }
                    catch (err:Error)
                    {
                        continue;
                    }
                    this._-5b(xml);
                    if (this._-FM.length > 0)
                    {
                        result.push("<!-- " + pkg.name + data.name + " -->");
                        var _loc_8:* = 0;
                        var _loc_9:* = this._-FM;
                        while (_loc_9 in _loc_8)
                        {
                            
                            item = _loc_9[_loc_8];
                            result.push(item);
                        }
                    }
                }
            }
            return;
        }// end function

        public function _-51(param1:File, param2:Boolean) : void
        {
            var _loc_3:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            if (param2 && param1.exists)
            {
                _loc_3 = this._-CQ(param1);
            }
            XML.ignoreComments = false;
            var _loc_4:* = <resources/>;
            for each (_loc_5 in this._-HX)
            {
                
                for each (_loc_6 in _loc_5)
                {
                    
                    if (_loc_6 is String)
                    {
                        _loc_4.appendChild(new XML(_loc_6));
                        continue;
                    }
                    _loc_7 = <string/>;
                    _loc_7.@name = _loc_6.name;
                    _loc_7.@mz = _loc_6.mz;
                    _loc_8 = _loc_6.text;
                    if (_loc_3)
                    {
                        _loc_9 = _loc_3[_loc_6.name];
                        if (_loc_9 != null)
                        {
                            _loc_8 = _loc_9;
                        }
                    }
                    _loc_7.appendChild(new XML(UtilsStr.encodeXML(_loc_8)));
                    _loc_4.appendChild(_loc_7);
                }
            }
            UtilsFile.saveXML(param1, _loc_4);
            XML.ignoreComments = true;
            System.disposeXML(_loc_4);
            return;
        }// end function

        private function parseItems(param1:Vector.<XData>, param2:File, param3:Array) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            for each (_loc_4 in param1)
            {
                
                _loc_5 = _loc_4.getAttribute("id");
                if (!_loc_5)
                {
                    continue;
                }
                _loc_6 = _loc_4.getName();
                if (_loc_6 == "component")
                {
                    _loc_7 = _loc_4.getAttribute("path", "");
                    if (_loc_7.length == 0)
                    {
                        _loc_7 = "/";
                    }
                    else
                    {
                        if (_loc_7.charAt(0) != "/")
                        {
                            _loc_7 = "/" + _loc_7;
                        }
                        if (_loc_7.charAt((_loc_7.length - 1)) != "/")
                        {
                            _loc_7 = _loc_7 + "/";
                        }
                    }
                    _loc_8 = _loc_4.getAttribute("name");
                    _loc_9 = new File(param2.nativePath + _loc_7 + _loc_8);
                    if (_loc_9.exists)
                    {
                        param3.push({id:_loc_5, name:_loc_7 + _loc_8, file:_loc_9});
                    }
                }
            }
            return;
        }// end function

        private function _-OJ(param1:String, param2:String, param3:String, param4:String) : void
        {
            if (!this._-32(param4))
            {
                return;
            }
            var _loc_5:* = {};
            var _loc_6:* = this._-Ax + this._-De + "-" + param1 + (param3 ? ("-" + param3) : (""));
            _loc_5.name = _loc_6;
            _loc_5.mz = param2;
            _loc_5.text = param4;
            this._-FM.push(_loc_5);
            return;
        }// end function

        private function _-5b(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = 0;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = 0;
            var _loc_16:* = 0;
            var _loc_7:* = param1.displayList.elements();
            for each (_loc_2 in _loc_7)
            {
                
                _loc_8 = _loc_2.name().localName;
                _loc_9 = _loc_2.@id;
                _loc_10 = _loc_2.@name;
                this._-OJ(_loc_9, _loc_10, "tips", _loc_2.@tooltips);
                if (_loc_8 == "text" || _loc_8 == "richtext")
                {
                    _loc_6 = _loc_2.@autoClearText;
                    if (!this._-C5 || _loc_6 != "true")
                    {
                        this._-OJ(_loc_9, _loc_10, null, _loc_2.@text);
                    }
                    this._-OJ(_loc_9, _loc_10, "prompt", _loc_2.@prompt);
                }
                else if (_loc_8 == "list")
                {
                    _loc_6 = _loc_2.@autoClearItems;
                    if (!this._-C5 || _loc_6 != "true")
                    {
                        _loc_11 = _loc_2.item;
                        _loc_12 = 0;
                        for each (_loc_4 in _loc_11)
                        {
                            
                            this._-OJ(_loc_9, _loc_10, "" + _loc_12, _loc_4.@title);
                            this._-OJ(_loc_9, _loc_10, "" + _loc_12 + "-0", _loc_4.@selectedTitle);
                            _loc_13 = _loc_4.property;
                            for each (_loc_5 in _loc_13)
                            {
                                
                                this._-OJ(_loc_9, _loc_10, "" + _loc_12 + "-" + _loc_5.@target, _loc_5.@value);
                            }
                            _loc_12++;
                        }
                    }
                }
                else if (_loc_8 == "component")
                {
                    var _loc_19:* = _loc_2.Button[0];
                    _loc_3 = _loc_2.Button[0];
                    if (_loc_19 != null)
                    {
                        this._-OJ(_loc_9, _loc_10, null, _loc_3.@title);
                        this._-OJ(_loc_9, _loc_10, "0", _loc_3.@selectedTitle);
                    }
                    else
                    {
                        var _loc_19:* = _loc_2.Label[0];
                        _loc_3 = _loc_2.Label[0];
                        if (_loc_19 != null)
                        {
                            this._-OJ(_loc_9, _loc_10, null, _loc_3.@title);
                            this._-OJ(_loc_9, _loc_10, "prompt", _loc_3.@prompt);
                        }
                        else
                        {
                            var _loc_19:* = _loc_2.ComboBox[0];
                            _loc_3 = _loc_2.ComboBox[0];
                            if (_loc_19 != null)
                            {
                                this._-OJ(_loc_9, _loc_10, null, _loc_3.@title);
                                _loc_6 = _loc_3.@autoClearItems;
                                if (!this._-C5 || _loc_6 != "true")
                                {
                                    _loc_11 = _loc_3.item;
                                    _loc_12 = 0;
                                    for each (_loc_4 in _loc_11)
                                    {
                                        
                                        this._-OJ(_loc_9, _loc_10, "" + _loc_12, _loc_4.@title);
                                        _loc_12++;
                                    }
                                }
                            }
                        }
                    }
                    _loc_13 = _loc_2.property;
                    for each (_loc_5 in _loc_13)
                    {
                        
                        this._-OJ(_loc_9, _loc_10, "cp-" + _loc_5.@target, _loc_5.@value);
                    }
                }
                var _loc_19:* = _loc_2.gearText[0];
                _loc_3 = _loc_2.gearText[0];
                if (_loc_19 != null)
                {
                    _loc_6 = _loc_3.@values;
                    if (_loc_6)
                    {
                        _loc_14 = _loc_6.split("|");
                        _loc_15 = _loc_14.length;
                        _loc_16 = 0;
                        while (_loc_16 < _loc_15)
                        {
                            
                            _loc_6 = _loc_14[_loc_16];
                            if (_loc_6 == "-")
                            {
                            }
                            else
                            {
                                this._-OJ(_loc_9, _loc_10, "texts_" + _loc_16, _loc_6);
                            }
                            _loc_16++;
                        }
                    }
                    _loc_6 = _loc_3["default"];
                    this._-OJ(_loc_9, _loc_10, "texts_def", _loc_6);
                }
            }
            System.disposeXML(param1);
            return;
        }// end function

        private function _-32(param1:String) : Boolean
        {
            var _loc_5:* = 0;
            if (!param1)
            {
                return false;
            }
            var _loc_2:* = param1.length;
            var _loc_3:* = true;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_5 = param1.charCodeAt(_loc_4);
                if (_loc_5 >= 65)
                {
                    _loc_3 = false;
                }
                _loc_4++;
            }
            return !_loc_3;
        }// end function

        private function _-CQ(param1:File) : Object
        {
            var xml:XML;
            var col:XMLList;
            var sxml:XML;
            var name:String;
            var file:* = param1;
            var refValues:Object;
            try
            {
                if (file.exists && file.size > 0)
                {
                    xml = UtilsFile.loadXML(file);
                    col = xml.string;
                    var _loc_3:* = 0;
                    var _loc_4:* = col;
                    while (_loc_4 in _loc_3)
                    {
                        
                        sxml = _loc_4[_loc_3];
                        name = sxml.@name;
                        refValues[name] = sxml.toString();
                    }
                    System.disposeXML(xml);
                }
            }
            catch (err:Error)
            {
                _editor.consoleView.logError("read " + file.name + " failed", err);
            }
            return refValues;
        }// end function

    }
}
