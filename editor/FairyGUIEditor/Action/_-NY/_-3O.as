package _-NY
{
    import *.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.filesystem.*;
    import flash.system.*;

    public class _-3O extends Object
    {
        private var _editor:IEditor;
        private var _strings:Object;

        public function _-3O(param1:IEditor)
        {
            this._editor = param1;
            return;
        }// end function

        public function parse(param1:File) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            this._strings = {};
            var _loc_2:* = UtilsFile.loadXML(param1);
            var _loc_3:* = _loc_2.string;
            for each (_loc_4 in _loc_3)
            {
                
                _loc_5 = _loc_4.@name;
                _loc_6 = _loc_4.toString();
                _loc_7 = _loc_5.substr(0, 8);
                _loc_8 = _loc_5.indexOf("-");
                _loc_9 = _loc_5.substring(8, _loc_8);
                _loc_10 = _loc_5.substr((_loc_8 + 1));
                _loc_11 = this._strings[_loc_7];
                if (!_loc_11)
                {
                    _loc_11 = {};
                    this._strings[_loc_7] = _loc_11;
                }
                _loc_12 = _loc_11[_loc_9];
                if (!_loc_12)
                {
                    _loc_12 = {};
                    _loc_11[_loc_9] = _loc_12;
                }
                _loc_12[_loc_10] = _loc_6;
            }
            System.disposeXML(_loc_2);
            return;
        }// end function

        public function get strings() : Object
        {
            return this._strings;
        }// end function

        public function _-77() : void
        {
            var xml:XML;
            var cxml:XML;
            var dxml:XML;
            var findResult:XMLList;
            var pkgId:String;
            var coms:Object;
            var pkg:IUIPackage;
            var srcId:String;
            var elements:Object;
            var pi:FPackageItem;
            var displayList:XMLList;
            var done:Boolean;
            var elementId:String;
            var arr:Array;
            var objId:String;
            var fieldId:String;
            var specialId:String;
            var text:String;
            var col:Object;
            var ename:String;
            var str:String;
            var k:int;
            var items:XMLList;
            var index:int;
            var _loc_2:* = 0;
            var _loc_3:* = this._strings;
            while (_loc_3 in _loc_2)
            {
                
                pkgId = _loc_3[_loc_2];
                coms = _loc_3[pkgId];
                pkg = this._editor.project.getPackage(pkgId);
                var _loc_4:* = 0;
                var _loc_5:* = coms;
                while (_loc_5 in _loc_4)
                {
                    
                    srcId = _loc_5[_loc_4];
                    elements = _loc_5[srcId];
                    pi = pkg.getItem(srcId);
                    if (pi == null)
                    {
                        this._editor.consoleView.logWarning(Consts.strings.text188 + " " + srcId);
                        return;
                    }
                    try
                    {
                        xml = UtilsFile.loadXML(pi.file);
                        if (!xml)
                        {
                            this._editor.consoleView.logWarning(Consts.strings.text188 + " " + pi.name);
                            return;
                        }
                    }
                    catch (err:Error)
                    {
                        _editor.consoleView.logWarning(Consts.strings.text188 + " " + pi.name);
                        return;
                    }
                    displayList = xml.displayList.elements();
                    var _loc_6:* = 0;
                    var _loc_7:* = elements;
                    while (_loc_7 in _loc_6)
                    {
                        
                        elementId = _loc_7[_loc_6];
                        arr = elementId.split("-");
                        objId = arr[0];
                        fieldId = arr[1];
                        specialId = arr[2];
                        text = _loc_7[elementId];
                        done;
                        var _loc_9:* = 0;
                        var _loc_10:* = displayList;
                        var _loc_8:* = new XMLList("");
                        for each (_loc_11 in _loc_10)
                        {
                            
                            var _loc_12:* = _loc_10[_loc_9];
                            with (_loc_10[_loc_9])
                            {
                                if (@id == objId)
                                {
                                    _loc_8[_loc_9] = _loc_11;
                                }
                            }
                        }
                        col = _loc_8;
                        if (col.length() == 0)
                        {
                            this._editor.consoleView.logWarning(Consts.strings.text188 + " " + elementId + " " + text);
                            continue;
                        }
                        cxml = col[0];
                        ename = cxml.name().localName;
                        if (fieldId == "tips")
                        {
                            cxml.@tooltips = text;
                            done;
                        }
                        else if (UtilsStr.startsWith(fieldId, "texts_"))
                        {
                            var _loc_8:* = cxml.gearText[0];
                            dxml = cxml.gearText[0];
                            if (_loc_8 != null)
                            {
                                if (fieldId == "texts_def")
                                {
                                    dxml["default"] = text;
                                }
                                else
                                {
                                    str = dxml.@values;
                                    if (str)
                                    {
                                        arr = str.split("|");
                                        k = parseInt(fieldId.substr(6));
                                        if (k < arr.length)
                                        {
                                            arr[k] = text;
                                        }
                                        dxml.@values = arr.join("|");
                                    }
                                }
                                done;
                            }
                        }
                        else if (ename == "text" || ename == "richtext")
                        {
                            if (fieldId == "prompt")
                            {
                                cxml.@prompt = text;
                            }
                            else
                            {
                                cxml.@text = text;
                            }
                            done;
                        }
                        else if (ename == "list")
                        {
                            items = cxml.item;
                            index = int(fieldId);
                            if (index < items.length())
                            {
                                items[index].@title = text;
                                if (specialId == "0")
                                {
                                    items[index].@selectedTitle = text;
                                }
                                else if (specialId)
                                {
                                    var _loc_9:* = 0;
                                    var _loc_10:* = cxml.property.elements();
                                    var _loc_8:* = new XMLList("");
                                    for each (_loc_11 in _loc_10)
                                    {
                                        
                                        var _loc_12:* = _loc_10[_loc_9];
                                        with (_loc_10[_loc_9])
                                        {
                                            if (@target.toString() == specialId && @propertyId == 0)
                                            {
                                                _loc_8[_loc_9] = _loc_11;
                                            }
                                        }
                                    }
                                    findResult = _loc_8;
                                    if (findResult.length() > 0)
                                    {
                                        findResult[0].@value = text;
                                    }
                                }
                                else
                                {
                                    items[index].@title = text;
                                }
                                done;
                            }
                        }
                        else if (ename == "component")
                        {
                            if (fieldId == "cp")
                            {
                                var _loc_9:* = 0;
                                var _loc_10:* = cxml.property.elements();
                                var _loc_8:* = new XMLList("");
                                for each (_loc_11 in _loc_10)
                                {
                                    
                                    var _loc_12:* = _loc_10[_loc_9];
                                    with (_loc_10[_loc_9])
                                    {
                                        if (@target.toString() == specialId && @propertyId == 0)
                                        {
                                            _loc_8[_loc_9] = _loc_11;
                                        }
                                    }
                                }
                                findResult = _loc_8;
                                if (findResult.length() > 0)
                                {
                                    findResult[0].@value = text;
                                }
                            }
                            else
                            {
                                var _loc_8:* = cxml.Button[0];
                                dxml = cxml.Button[0];
                                if (_loc_8 != null)
                                {
                                    if (fieldId == "0")
                                    {
                                        dxml.@selectedTitle = text;
                                    }
                                    else
                                    {
                                        dxml.@title = text;
                                    }
                                    done;
                                }
                                else
                                {
                                    var _loc_8:* = cxml.Label[0];
                                    dxml = cxml.Label[0];
                                    if (_loc_8 != null)
                                    {
                                        if (fieldId == "prompt")
                                        {
                                            dxml.@prompt = text;
                                        }
                                        else
                                        {
                                            dxml.@title = text;
                                        }
                                        done;
                                    }
                                    else
                                    {
                                        var _loc_8:* = cxml.ComboBox[0];
                                        dxml = cxml.ComboBox[0];
                                        if (_loc_8 != null)
                                        {
                                            if (!fieldId)
                                            {
                                                dxml.@title = text;
                                                done;
                                            }
                                            else
                                            {
                                                items = dxml.item;
                                                index = int(fieldId);
                                                if (index < items.length())
                                                {
                                                    items[index].@title = text;
                                                    done;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if (!done)
                        {
                            this._editor.consoleView.logWarning(Consts.strings.text188 + " " + elementId + " " + text);
                        }
                    }
                    UtilsFile.saveXML(pi.file, xml);
                    pi.setChanged();
                    System.disposeXML(xml);
                }
                pkg.setChanged();
            }
            return;
        }// end function

    }
}
