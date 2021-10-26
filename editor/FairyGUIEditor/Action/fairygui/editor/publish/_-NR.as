package fairygui.editor.publish
{
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import fairygui.utils.*;
    import flash.utils.*;

    public class _-NR extends _-CI
    {

        public function _-NR()
        {
            return;
        }// end function

        override public function run() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = false;
            var _loc_17:* = null;
            var _loc_18:* = null;
            var _loc_19:* = 0;
            var _loc_20:* = null;
            var _loc_21:* = null;
            var _loc_22:* = null;
            var _loc_6:* = XData.create("packageDescription");
            _loc_6.setAttribute("id", _-J.pkg.id);
            _loc_6.setAttribute("name", _-J.pkg.name);
            if (_-J._-1e > 0)
            {
                _loc_4 = [];
                for (_loc_12 in _-J._-GR)
                {
                    
                    _loc_4[_loc_24[_loc_12]] = _loc_12;
                }
                _loc_6.setAttribute("branches", _loc_4.join(","));
            }
            var _loc_7:* = XData.create("resources");
            var _loc_8:* = CommonSettings(_-J.project.getSettings("common"));
            var _loc_9:* = _loc_8.verticalScrollBar;
            var _loc_10:* = _loc_8.horizontalScrollBar;
            if (_loc_9 || _loc_10)
            {
                _loc_6.setAttribute("scrollBarRes", (_loc_9 ? (_loc_9) : ("")) + "," + (_loc_10 ? (_loc_10) : ("")));
            }
            var _loc_11:* = _-J._-Ho > 0;
            for each (_loc_1 in _-J.items)
            {
                
                _loc_13 = UtilsStr.getFileExt(_loc_1.fileName);
                if (_loc_13)
                {
                    if (_loc_13.toLowerCase() == "svg")
                    {
                        _loc_13 = "png";
                    }
                    _loc_2 = _loc_1._-e + "." + _loc_13;
                }
                else
                {
                    _loc_2 = _loc_1._-e;
                }
                _loc_14 = _loc_1.serialize(true);
                switch(_loc_1.type)
                {
                    case FPackageItemType.COMPONENT:
                    {
                        if (!_-J.outputDesc[_loc_1._-e + ".xml"])
                        {
                            _loc_14 = null;
                        }
                        break;
                    }
                    case FPackageItemType.IMAGE:
                    {
                        if (!_-J._-O4)
                        {
                            var _loc_25:* = UtilsFile.loadBytes(_loc_1.imageInfo.file);
                            _loc_3 = UtilsFile.loadBytes(_loc_1.imageInfo.file);
                            if (_loc_1.image && _loc_25 != null)
                            {
                                _loc_15 = _-J._-BD[_loc_1._-e];
                                if (_loc_15)
                                {
                                    _loc_2 = _loc_15._-e + "." + _loc_13;
                                    _-J.outputRes[_loc_2] = _loc_3;
                                    _loc_14 = null;
                                }
                                else
                                {
                                    _-J.outputRes[_loc_2] = _loc_3;
                                    _loc_14.setAttribute("file", _loc_2);
                                }
                            }
                        }
                        break;
                    }
                    case FPackageItemType.MOVIECLIP:
                    {
                        if (!_-J.outputDesc[_loc_1._-e + ".xml"])
                        {
                            _loc_14 = null;
                        }
                        break;
                    }
                    case FPackageItemType.SWF:
                    {
                        if (_-J.project.type != ProjectType.FLASH)
                        {
                            _loc_14 = null;
                        }
                        break;
                    }
                    case FPackageItemType.FONT:
                    {
                        _loc_5 = UtilsFile.loadString(_loc_1.file);
                        if (_loc_5)
                        {
                            if (_loc_1.fontSettings.texture)
                            {
                                _loc_14.setAttribute("fontTexture", _loc_1.fontSettings.texture);
                            }
                            _-J.outputDesc[_loc_2] = _loc_5;
                        }
                        else
                        {
                            _loc_14 = null;
                        }
                        break;
                    }
                    default:
                    {
                        _loc_3 = UtilsFile.loadBytes(_loc_1.file);
                        if (_loc_3)
                        {
                            _-J.outputRes[_loc_2] = _loc_3;
                            _loc_14.setAttribute("file", _loc_2);
                        }
                        else
                        {
                            _loc_14 = null;
                        }
                        break;
                        break;
                    }
                }
                if (_loc_14)
                {
                    if (_loc_1.imageInfo)
                    {
                        _loc_17 = _loc_1.getVar("pubInfo.highRes");
                        if (_loc_17)
                        {
                            _loc_14.setAttribute("highRes", _loc_17);
                        }
                    }
                    _loc_16 = _loc_1.branch.length > 0;
                    if (_loc_11)
                    {
                        if (_-J.includeBranches)
                        {
                            if (_loc_1.branch.length == 0)
                            {
                                _loc_18 = _loc_1.getVar("pubInfo.branch");
                                if (_loc_18)
                                {
                                    _loc_19 = 0;
                                    while (_loc_19 < _-J._-1e)
                                    {
                                        
                                        _loc_12 = _loc_18[_loc_19];
                                        if (!_loc_12)
                                        {
                                            _loc_18[_loc_19] = "";
                                        }
                                        _loc_19++;
                                    }
                                    _loc_14.setAttribute("branches", _loc_18.join(","));
                                }
                            }
                        }
                        else if (_loc_1.branch.length > 0 && _loc_1.getVar("pubInfo.branch"))
                        {
                            _loc_16 = false;
                            _loc_14.setAttribute("branches", _loc_1.id);
                        }
                    }
                    if (_loc_16)
                    {
                        _loc_14.setAttribute("branch", _loc_1.branch);
                    }
                    _loc_7.appendChild(_loc_14);
                }
            }
            if (_-J._-O4)
            {
                for each (_loc_20 in _-J._-F8)
                {
                    
                    _loc_21 = XData.create("atlas");
                    _loc_21.setAttribute("id", _loc_20.id);
                    _loc_21.setAttribute("size", _loc_20.width + "," + _loc_20.height);
                    _loc_21.setAttribute("file", _loc_20.fileName);
                    _loc_7.appendChild(_loc_21);
                    if (_loc_20.data)
                    {
                        _-J.outputRes[_loc_20.fileName] = _loc_20.data;
                    }
                    if (_loc_20._-8I)
                    {
                        _-J.outputRes[UtilsStr.getFileName(_loc_20.fileName) + "!a.png"] = _loc_20._-8I;
                    }
                }
            }
            _loc_6.appendChild(_loc_7);
            _-J.outputDesc["package.xml"] = _loc_6.toXML();
            if (_-J._-O4)
            {
                _loc_4 = [];
                for each (_loc_22 in _-J._-Fc)
                {
                    
                    _loc_4.push(_loc_22.join(" "));
                }
                _loc_4.sort();
                _-J.sprites = "//FairyGUI atlas sprites.\n" + _loc_4.join("\n");
            }
            _stepCallback.callOnSuccess();
            return;
        }// end function

    }
}
