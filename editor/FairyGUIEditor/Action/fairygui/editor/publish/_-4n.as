package fairygui.editor.publish
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.gui.gear.*;
    import fairygui.tween.*;
    import fairygui.utils.*;
    import flash.utils.*;

    public class _-4n extends Object
    {
        public var _-FV:Array;
        private var _-59:Object;
        private var _-P4:int;
        private var displayList:Object;
        private var _-67:Object;
        private var _-Ck:int;
        private var publishData:_-4Z;
        private var helperIntList:Vector.<int>;
        private static var _-J9:FTransitionValue = new FTransitionValue();
        private static var _-H8:Object = {left-left:0, left-center:1, left-right:2, center-center:3, right-left:4, right-center:5, right-right:6, top-top:7, top-middle:8, top-bottom:9, middle-middle:10, bottom-top:11, bottom-middle:12, bottom-bottom:13, width-width:14, height-height:15, leftext-left:16, leftext-right:17, rightext-left:18, rightext-right:19, topext-top:20, topext-bottom:21, bottomext-top:22, bottomext-bottom:23};

        public function _-4n()
        {
            this._-FV = [];
            this._-67 = {};
            this.helperIntList = new Vector.<int>;
            return;
        }// end function

        public function encode(param1:_-4Z, param2:Boolean = false) : ByteArray
        {
            var ba:ByteArray;
            var ba2:ByteArray;
            var arr:Array;
            var cnt:int;
            var str:String;
            var cntPos:int;
            var element:XData;
            var longStrings:ByteArray;
            var i:int;
            var pkg:IUIPackage;
            var itemId:String;
            var atlasId:String;
            var binIndex:int;
            var pos:int;
            var len:int;
            var publishData:* = param1;
            var compress:* = param2;
            this.publishData = publishData;
            var outputDesc:* = publishData.outputDesc;
            ba = new ByteArray();
            var xml:* = XData.attach(outputDesc["package.xml"]);
            var resources:* = xml.getChild("resources").getChildren();
            this._-FU(ba, 6, false);
            this._-Pu(ba, 0);
            var pkgs:* = new Vector.<IUIPackage>;
            var _loc_4:* = 0;
            var _loc_5:* = publishData._-DJ;
            while (_loc_5 in _loc_4)
            {
                
                str = _loc_5[_loc_4];
                pkg = publishData.project.getPackage(str);
                if (pkg)
                {
                    pkgs.push(pkg);
                }
            }
            pkgs.sort(comparePackage);
            ba.writeShort(pkgs.length);
            i;
            while (i < pkgs.length)
            {
                
                this.writeString(ba, pkgs[i].id);
                this.writeString(ba, pkgs[i].name);
                i = (i + 1);
            }
            str = xml.getAttribute("branches");
            if (str)
            {
                arr = str.split(",");
                ba.writeShort(arr.length);
                i;
                while (i < arr.length)
                {
                    
                    this.writeString(ba, arr[i]);
                    i = (i + 1);
                }
            }
            else
            {
                ba.writeShort(0);
            }
            this._-Pu(ba, 1);
            ba.writeShort(resources.length);
            var _loc_4:* = 0;
            var _loc_5:* = resources;
            while (_loc_5 in _loc_4)
            {
                
                element = _loc_5[_loc_4];
                ba2 = this._-Ab(element);
                ba.writeInt(ba2.length);
                ba.writeBytes(ba2);
                ba2.clear();
            }
            this._-Pu(ba, 2);
            cnt = publishData._-Fc.length;
            ba.writeShort(cnt);
            i;
            while (i < cnt)
            {
                
                arr = publishData._-Fc[i];
                ba2 = new ByteArray();
                itemId = arr[0];
                this.writeString(ba2, itemId);
                binIndex = parseInt(arr[1]);
                if (binIndex >= 0)
                {
                    atlasId = "atlas" + binIndex;
                }
                else
                {
                    pos = itemId.indexOf("_");
                    if (pos == -1)
                    {
                        atlasId = "atlas_" + itemId;
                    }
                    else
                    {
                        atlasId = "atlas_" + itemId.substring(0, pos);
                    }
                }
                this.writeString(ba2, atlasId);
                ba2.writeInt(arr[2]);
                ba2.writeInt(arr[3]);
                ba2.writeInt(arr[4]);
                ba2.writeInt(arr[5]);
                ba2.writeBoolean(arr[6]);
                if (arr[7] != undefined && (arr[7] != 0 || arr[8] != 0 || arr[9] != arr[4] || arr[10] != arr[5]))
                {
                    ba2.writeBoolean(true);
                    ba2.writeInt(arr[7]);
                    ba2.writeInt(arr[8]);
                    ba2.writeInt(arr[9]);
                    ba2.writeInt(arr[10]);
                }
                else
                {
                    ba2.writeBoolean(false);
                }
                ba.writeShort(ba2.length);
                ba.writeBytes(ba2);
                ba2.clear();
                i = (i + 1);
            }
            if (publishData.hitTestData.length > 0)
            {
                this._-Pu(ba, 3);
                ba2 = publishData.hitTestData;
                ba2.position = 0;
                cntPos = ba.position;
                ba.writeShort(0);
                cnt;
                while (ba2.bytesAvailable)
                {
                    
                    str = ba2.readUTF();
                    pos = ba2.position;
                    ba2.position = ba2.position + 9;
                    len = ba2.readInt();
                    ba.writeInt(len + 15);
                    this.writeString(ba, str);
                    ba.writeBytes(ba2, pos, len + 13);
                    ba2.position = pos + 13 + len;
                    cnt = (cnt + 1);
                }
                this._-4J(ba, cntPos, cnt);
            }
            this._-Pu(ba, 4);
            var longStringsCnt:int;
            cnt = this._-FV.length;
            ba.writeInt(cnt);
            i;
            while (i < cnt)
            {
                
                try
                {
                    ba.writeUTF(this._-FV[i]);
                }
                catch (err:RangeError)
                {
                    ba.writeShort(0);
                    if (longStrings == null)
                    {
                        longStrings = new ByteArray();
                    }
                    longStrings.writeShort(i);
                    pos = longStrings.position;
                    longStrings.writeInt(0);
                    longStrings.writeUTFBytes(_-FV[i]);
                    len = longStrings.position - pos - 4;
                    longStrings.position = pos;
                    longStrings.writeInt(len);
                    longStrings.position = longStrings.length;
                    longStringsCnt = (longStringsCnt + 1);
                }
                i = (i + 1);
            }
            if (longStringsCnt > 0)
            {
                this._-Pu(ba, 5);
                ba.writeInt(longStringsCnt);
                ba.writeBytes(longStrings);
                longStrings.clear();
            }
            ba2 = ba;
            ba = new ByteArray();
            ba.writeByte("F".charCodeAt(0));
            ba.writeByte("G".charCodeAt(0));
            ba.writeByte("U".charCodeAt(0));
            ba.writeByte("I".charCodeAt(0));
            ba.writeInt(2);
            ba.writeBoolean(compress);
            ba.writeUTF(xml.getAttribute("id"));
            ba.writeUTF(xml.getAttribute("name"));
            i;
            while (i < 20)
            {
                
                ba.writeByte(0);
                i = (i + 1);
            }
            if (compress)
            {
                ba2.deflate();
            }
            ba.writeBytes(ba2);
            ba2.clear();
            return ba;
        }// end function

        private function _-Ab(param1:XData) : ByteArray
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_2:* = new ByteArray();
            var _loc_7:* = param1.getName();
            switch(_loc_7)
            {
                case FPackageItemType.IMAGE:
                {
                    _loc_2.writeByte(0);
                    break;
                }
                case FPackageItemType.MOVIECLIP:
                {
                    _loc_2.writeByte(1);
                    break;
                }
                case FPackageItemType.SOUND:
                {
                    _loc_2.writeByte(2);
                    break;
                }
                case FPackageItemType.COMPONENT:
                {
                    _loc_2.writeByte(3);
                    break;
                }
                case FPackageItemType.ATLAS:
                {
                    _loc_2.writeByte(4);
                    break;
                }
                case FPackageItemType.FONT:
                {
                    _loc_2.writeByte(5);
                    break;
                }
                case FPackageItemType.SWF:
                {
                    _loc_2.writeByte(6);
                    break;
                }
                case FPackageItemType.MISC:
                {
                    _loc_2.writeByte(7);
                    break;
                }
                default:
                {
                    _loc_2.writeByte(8);
                    break;
                    break;
                }
            }
            _loc_8 = param1.getAttribute("id");
            this.writeString(_loc_2, _loc_8);
            this.writeString(_loc_2, param1.getAttribute("name", ""));
            this.writeString(_loc_2, param1.getAttribute("path", ""));
            if (_loc_7 == FPackageItemType.SOUND || _loc_7 == FPackageItemType.SWF || _loc_7 == FPackageItemType.ATLAS || _loc_7 == FPackageItemType.MISC)
            {
                this.writeString(_loc_2, param1.getAttribute("file", ""));
            }
            else
            {
                this.writeString(_loc_2, null);
            }
            _loc_2.writeBoolean(param1.getAttributeBool("exported"));
            _loc_4 = param1.getAttribute("size", "");
            _loc_5 = _loc_4.split(",");
            _loc_2.writeInt(parseInt(_loc_5[0]));
            _loc_2.writeInt(parseInt(_loc_5[1]));
            switch(param1.getName())
            {
                case FPackageItemType.IMAGE:
                {
                    _loc_4 = param1.getAttribute("scale");
                    if (_loc_4 == "9grid")
                    {
                        _loc_2.writeByte(1);
                        _loc_4 = param1.getAttribute("scale9grid");
                        if (_loc_4)
                        {
                            _loc_5 = _loc_4.split(",");
                            _loc_2.writeInt(parseInt(_loc_5[0]));
                            _loc_2.writeInt(parseInt(_loc_5[1]));
                            _loc_2.writeInt(parseInt(_loc_5[2]));
                            _loc_2.writeInt(parseInt(_loc_5[3]));
                        }
                        else
                        {
                            _loc_2.writeInt(0);
                            _loc_2.writeInt(0);
                            _loc_2.writeInt(0);
                            _loc_2.writeInt(0);
                        }
                        _loc_2.writeInt(param1.getAttributeInt("gridTile"));
                    }
                    else if (_loc_4 == "tile")
                    {
                        _loc_2.writeByte(2);
                    }
                    else
                    {
                        _loc_2.writeByte(0);
                    }
                    _loc_2.writeBoolean(param1.getAttributeBool("smoothing", true));
                    break;
                }
                case FPackageItemType.MOVIECLIP:
                {
                    _loc_2.writeBoolean(param1.getAttributeBool("smoothing", true));
                    _loc_9 = this.publishData.outputDesc[_loc_8 + ".xml"];
                    if (_loc_9)
                    {
                        _loc_3 = this._-3y(_loc_8, _loc_9);
                        _loc_2.writeInt(_loc_3.length);
                        _loc_2.writeBytes(_loc_3);
                        _loc_3.clear();
                    }
                    else
                    {
                        _loc_2.writeInt(0);
                    }
                    break;
                }
                case FPackageItemType.FONT:
                {
                    _loc_4 = this.publishData.outputDesc[_loc_8 + ".fnt"];
                    if (_loc_4)
                    {
                        _loc_3 = this._-Ox(_loc_8, _loc_4);
                        _loc_2.writeInt(_loc_3.length);
                        _loc_2.writeBytes(_loc_3);
                        _loc_3.clear();
                    }
                    else
                    {
                        _loc_2.writeInt(0);
                    }
                    break;
                }
                case FPackageItemType.COMPONENT:
                {
                    _loc_9 = this.publishData.outputDesc[_loc_8 + ".xml"];
                    if (_loc_9)
                    {
                        _loc_10 = _loc_9.@extention;
                        switch(_loc_10)
                        {
                            case FObjectType.EXT_LABEL:
                            {
                                break;
                            }
                            case FObjectType.EXT_BUTTON:
                            {
                                break;
                            }
                            case FObjectType.EXT_COMBOBOX:
                            {
                                break;
                            }
                            case FObjectType.EXT_PROGRESS_BAR:
                            {
                                break;
                            }
                            case FObjectType.EXT_SLIDER:
                            {
                                break;
                            }
                            case FObjectType.EXT_SCROLLBAR:
                            {
                                break;
                            }
                            default:
                            {
                                break;
                                break;
                            }
                        }
                        _loc_3 = this._-KC(_loc_8, XData.attach(_loc_9));
                        _loc_2.writeInt(_loc_3.length);
                        _loc_2.writeBytes(_loc_3);
                        _loc_3.clear();
                    }
                    else
                    {
                        _loc_2.writeByte(0);
                        _loc_2.writeInt(0);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_4 = param1.getAttribute("branch");
            this.writeString(_loc_2, _loc_4);
            _loc_4 = param1.getAttribute("branches");
            if (_loc_4)
            {
                _loc_5 = _loc_4.split(",");
                _loc_2.writeByte(_loc_5.length);
                _loc_6 = 0;
                while (_loc_6 < _loc_5.length)
                {
                    
                    this.writeString(_loc_2, _loc_5[_loc_6]);
                    _loc_6++;
                }
            }
            else
            {
                _loc_2.writeByte(0);
            }
            _loc_4 = param1.getAttribute("highRes");
            if (_loc_4)
            {
                _loc_5 = _loc_4.split(",");
                _loc_2.writeByte(_loc_5.length);
                _loc_6 = 0;
                while (_loc_6 < _loc_5.length)
                {
                    
                    this.writeString(_loc_2, _loc_5[_loc_6]);
                    _loc_6++;
                }
            }
            else
            {
                _loc_2.writeByte(0);
            }
            return _loc_2;
        }// end function

        private function _-KC(param1:String, param2:XData) : ByteArray
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_15:* = null;
            var _loc_3:* = new ByteArray();
            this._-59 = {};
            this._-P4 = 0;
            this.displayList = {};
            _loc_9 = param2.getChild("displayList");
            if (_loc_9 != null)
            {
                _loc_8 = _loc_9.getChildren();
                _loc_7 = _loc_8.length;
                _loc_6 = 0;
                while (_loc_6 < _loc_7)
                {
                    
                    this.displayList[_loc_8[_loc_6].getAttribute("id")] = _loc_6;
                    _loc_6++;
                }
            }
            this._-FU(_loc_3, 8, false);
            this._-Pu(_loc_3, 0);
            _loc_4 = param2.getAttribute("size", "");
            _loc_5 = _loc_4.split(",");
            _loc_3.writeInt(parseInt(_loc_5[0]));
            _loc_3.writeInt(parseInt(_loc_5[1]));
            _loc_4 = param2.getAttribute("restrictSize");
            if (_loc_4)
            {
                _loc_5 = _loc_4.split(",");
                _loc_3.writeBoolean(true);
                _loc_3.writeInt(parseInt(_loc_5[0]));
                _loc_3.writeInt(parseInt(_loc_5[1]));
                _loc_3.writeInt(parseInt(_loc_5[2]));
                _loc_3.writeInt(parseInt(_loc_5[3]));
            }
            else
            {
                _loc_3.writeBoolean(false);
            }
            _loc_4 = param2.getAttribute("pivot");
            if (_loc_4)
            {
                _loc_5 = _loc_4.split(",");
                _loc_3.writeBoolean(true);
                _loc_3.writeFloat(parseFloat(_loc_5[0]));
                _loc_3.writeFloat(parseFloat(_loc_5[1]));
                _loc_3.writeBoolean(param2.getAttributeBool("anchor"));
            }
            else
            {
                _loc_3.writeBoolean(false);
            }
            _loc_4 = param2.getAttribute("margin");
            if (_loc_4)
            {
                _loc_5 = _loc_4.split(",");
                _loc_3.writeBoolean(true);
                _loc_3.writeInt(parseInt(_loc_5[0]));
                _loc_3.writeInt(parseInt(_loc_5[1]));
                _loc_3.writeInt(parseInt(_loc_5[2]));
                _loc_3.writeInt(parseInt(_loc_5[3]));
            }
            else
            {
                _loc_3.writeBoolean(false);
            }
            var _loc_12:* = false;
            _loc_4 = param2.getAttribute("overflow");
            if (_loc_4 == "hidden")
            {
                _loc_3.writeByte(1);
            }
            else if (_loc_4 == "scroll")
            {
                _loc_3.writeByte(2);
                _loc_12 = true;
            }
            else
            {
                _loc_3.writeByte(0);
            }
            _loc_4 = param2.getAttribute("clipSoftness");
            if (_loc_4)
            {
                _loc_5 = _loc_4.split(",");
                _loc_3.writeBoolean(true);
                _loc_3.writeInt(parseInt(_loc_5[0]));
                _loc_3.writeInt(parseInt(_loc_5[1]));
            }
            else
            {
                _loc_3.writeBoolean(false);
            }
            this._-Pu(_loc_3, 1);
            _loc_7 = 0;
            _loc_11 = _loc_3.position;
            _loc_3.writeShort(0);
            var _loc_13:* = param2.getEnumerator("controller");
            while (_loc_13.moveNext())
            {
                
                _loc_10 = this._-66(_loc_13.current);
                _loc_3.writeShort(_loc_10.length);
                _loc_3.writeBytes(_loc_10);
                _loc_10.clear();
                _loc_7++;
            }
            this._-4J(_loc_3, _loc_11, _loc_7);
            this._-Pu(_loc_3, 2);
            if (_loc_9 != null)
            {
                _loc_8 = _loc_9.getChildren();
                _loc_7 = _loc_8.length;
                _loc_3.writeShort(_loc_7);
                _loc_6 = 0;
                while (_loc_6 < _loc_7)
                {
                    
                    _loc_10 = this._-2N(_loc_8[_loc_6]);
                    _loc_3.writeShort(_loc_10.length);
                    _loc_3.writeBytes(_loc_10);
                    _loc_10.clear();
                    _loc_6++;
                }
            }
            else
            {
                _loc_3.writeShort(0);
            }
            this._-Pu(_loc_3, 3);
            this._-57(param2, _loc_3, true);
            this._-Pu(_loc_3, 4);
            this.writeString(_loc_3, param2.getAttribute("customData"), true);
            _loc_3.writeBoolean(param2.getAttributeBool("opaque", true));
            _loc_4 = param2.getAttribute("mask");
            if (this.displayList[_loc_4] != undefined)
            {
                _loc_3.writeShort(this.displayList[_loc_4]);
                _loc_3.writeBoolean(param2.getAttributeBool("reversedMask"));
            }
            else
            {
                _loc_3.writeShort(-1);
            }
            _loc_4 = param2.getAttribute("hitTest");
            if (_loc_4)
            {
                _loc_5 = _loc_4.split(",");
                if (_loc_5.length == 1)
                {
                    this.writeString(_loc_3, null);
                    _loc_3.writeInt(1);
                    if (this.displayList[_loc_5[0]] != undefined)
                    {
                        _loc_3.writeInt(this.displayList[_loc_5[0]]);
                    }
                    else
                    {
                        _loc_3.writeInt(-1);
                    }
                }
                else
                {
                    this.writeString(_loc_3, _loc_5[0]);
                    _loc_3.writeInt(parseInt(_loc_5[1]));
                    _loc_3.writeInt(parseInt(_loc_5[2]));
                }
            }
            else
            {
                this.writeString(_loc_3, null);
                _loc_3.writeInt(0);
                _loc_3.writeInt(0);
            }
            this._-Pu(_loc_3, 5);
            _loc_7 = 0;
            _loc_11 = _loc_3.position;
            _loc_3.writeShort(0);
            _loc_13 = param2.getEnumerator("transition");
            while (_loc_13.moveNext())
            {
                
                _loc_10 = this._-70(_loc_13.current);
                _loc_3.writeShort(_loc_10.length);
                _loc_3.writeBytes(_loc_10);
                _loc_10.clear();
                _loc_7++;
            }
            this._-4J(_loc_3, _loc_11, _loc_7);
            var _loc_14:* = param2.getAttribute("extention");
            if (param2.getAttribute("extention"))
            {
                this._-Pu(_loc_3, 6);
                _loc_15 = param2.getChild(_loc_14);
                if (!_loc_15)
                {
                    _loc_15 = XData.create(_loc_14);
                }
                switch(_loc_14)
                {
                    case FObjectType.EXT_LABEL:
                    {
                        break;
                    }
                    case FObjectType.EXT_BUTTON:
                    {
                        _loc_4 = _loc_15.getAttribute("mode");
                        if (_loc_4 == FButton.CHECK)
                        {
                            _loc_3.writeByte(1);
                        }
                        else if (_loc_4 == FButton.RADIO)
                        {
                            _loc_3.writeByte(2);
                        }
                        else
                        {
                            _loc_3.writeByte(0);
                        }
                        this.writeString(_loc_3, _loc_15.getAttribute("sound"));
                        _loc_3.writeFloat(_loc_15.getAttributeInt("volume", 100) / 100);
                        _loc_4 = _loc_15.getAttribute("downEffect", "none");
                        if (_loc_4 == "dark")
                        {
                            _loc_3.writeByte(1);
                        }
                        else if (_loc_4 == "scale")
                        {
                            _loc_3.writeByte(2);
                        }
                        else
                        {
                            _loc_3.writeByte(0);
                        }
                        _loc_3.writeFloat(_loc_15.getAttributeFloat("downEffectValue", 0.8));
                        break;
                    }
                    case FObjectType.EXT_COMBOBOX:
                    {
                        this.writeString(_loc_3, _loc_15.getAttribute("dropdown"));
                        break;
                    }
                    case FObjectType.EXT_PROGRESS_BAR:
                    {
                        _loc_4 = _loc_15.getAttribute("titleType");
                        switch(_loc_4)
                        {
                            case "percent":
                            {
                                _loc_3.writeByte(0);
                                break;
                            }
                            case "valueAndmax":
                            {
                                _loc_3.writeByte(1);
                                break;
                            }
                            case "value":
                            {
                                _loc_3.writeByte(2);
                                break;
                            }
                            case "max":
                            {
                                _loc_3.writeByte(3);
                                break;
                            }
                            default:
                            {
                                _loc_3.writeByte(0);
                                break;
                                break;
                            }
                        }
                        _loc_3.writeBoolean(_loc_15.getAttributeBool("reverse"));
                        break;
                    }
                    case FObjectType.EXT_SLIDER:
                    {
                        _loc_4 = _loc_15.getAttribute("titleType");
                        switch(_loc_4)
                        {
                            case "percent":
                            {
                                _loc_3.writeByte(0);
                                break;
                            }
                            case "valueAndmax":
                            {
                                _loc_3.writeByte(1);
                                break;
                            }
                            case "value":
                            {
                                _loc_3.writeByte(2);
                                break;
                            }
                            case "max":
                            {
                                _loc_3.writeByte(3);
                                break;
                            }
                            default:
                            {
                                _loc_3.writeByte(0);
                                break;
                                break;
                            }
                        }
                        _loc_3.writeBoolean(_loc_15.getAttributeBool("reverse"));
                        _loc_3.writeBoolean(_loc_15.getAttributeBool("wholeNumbers"));
                        _loc_3.writeBoolean(_loc_15.getAttributeBool("changeOnClick", true));
                        break;
                    }
                    case FObjectType.EXT_SCROLLBAR:
                    {
                        _loc_3.writeBoolean(_loc_15.getAttributeBool("fixedGripSize"));
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            if (_loc_12)
            {
                this._-Pu(_loc_3, 7);
                _loc_10 = this._-Nu(param2);
                _loc_3.writeBytes(_loc_10);
                _loc_10.clear();
            }
            return _loc_3;
        }// end function

        private function _-66(param1:XData) : ByteArray
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = 0;
            var _loc_2:* = new ByteArray();
            this._-FU(_loc_2, 3, true);
            this._-Pu(_loc_2, 0);
            _loc_4 = param1.getAttribute("name");
            this.writeString(_loc_2, _loc_4);
            var _loc_14:* = this;
            _loc_14._-P4 = this._-P4 + 1;
            this._-59[_loc_4] = this._-P4 + 1;
            _loc_2.writeBoolean(param1.getAttributeBool("autoRadioGroupDepth"));
            this._-Pu(_loc_2, 1);
            _loc_4 = param1.getAttribute("pages");
            if (_loc_4)
            {
                _loc_5 = _loc_4.split(",");
                _loc_7 = _loc_5.length / 2;
                _loc_2.writeShort(_loc_7);
                _loc_6 = 0;
                while (_loc_6 < _loc_7)
                {
                    
                    this.writeString(_loc_2, _loc_5[_loc_6 * 2], false, false);
                    this.writeString(_loc_2, _loc_5[_loc_6 * 2 + 1], false, false);
                    _loc_6++;
                }
                _loc_11 = param1.getAttribute("homePageType", "default");
                _loc_12 = param1.getAttribute("homePage", "");
                _loc_13 = 0;
                if (_loc_11 == "specific")
                {
                    _loc_6 = 0;
                    while (_loc_6 < _loc_7)
                    {
                        
                        if (_loc_5[_loc_6 * 2] == _loc_12)
                        {
                            _loc_13 = _loc_6;
                            break;
                        }
                        _loc_6++;
                    }
                }
                switch(_loc_11)
                {
                    case "specific":
                    {
                        _loc_2.writeByte(1);
                        _loc_2.writeShort(_loc_13);
                        break;
                    }
                    case "branch":
                    {
                        _loc_2.writeByte(2);
                        break;
                    }
                    case "variable":
                    {
                        _loc_2.writeByte(3);
                        this.writeString(_loc_2, _loc_12);
                        break;
                    }
                    default:
                    {
                        _loc_2.writeByte(0);
                        break;
                        break;
                    }
                }
            }
            else
            {
                _loc_2.writeShort(0);
                _loc_2.writeByte(0);
            }
            this._-Pu(_loc_2, 2);
            var _loc_9:* = param1.getChildren();
            _loc_7 = 0;
            _loc_8 = _loc_2.position;
            _loc_2.writeShort(0);
            for each (_loc_10 in _loc_9)
            {
                
                if (_loc_10.getName() == "action")
                {
                    _loc_4 = _loc_10.getAttribute("type");
                    _loc_3 = this._-KY(_loc_4, _loc_10);
                    _loc_2.writeShort((_loc_3.length + 1));
                    if (_loc_4 == "play_transition")
                    {
                        _loc_2.writeByte(0);
                    }
                    else if (_loc_4 == "change_page")
                    {
                        _loc_2.writeByte(1);
                    }
                    else
                    {
                        _loc_2.writeByte(0);
                    }
                    _loc_2.writeBytes(_loc_3);
                    _loc_7++;
                }
            }
            this._-4J(_loc_2, _loc_8, _loc_7);
            return _loc_2;
        }// end function

        private function _-KY(param1:String, param2:XData) : ByteArray
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_3:* = new ByteArray();
            _loc_4 = param2.getAttribute("fromPage");
            if (_loc_4)
            {
                _loc_5 = _loc_4.split(",");
                _loc_6 = _loc_5.length;
                _loc_3.writeShort(_loc_6);
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    this.writeString(_loc_3, _loc_5[_loc_7]);
                    _loc_7++;
                }
            }
            else
            {
                _loc_3.writeShort(0);
            }
            _loc_4 = param2.getAttribute("toPage");
            if (_loc_4)
            {
                _loc_5 = _loc_4.split(",");
                _loc_6 = _loc_5.length;
                _loc_3.writeShort(_loc_6);
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    this.writeString(_loc_3, _loc_5[_loc_7]);
                    _loc_7++;
                }
            }
            else
            {
                _loc_3.writeShort(0);
            }
            if (param1 == "play_transition")
            {
                this.writeString(_loc_3, param2.getAttribute("transition"));
                _loc_3.writeInt(param2.getAttributeInt("repeat", 1));
                _loc_3.writeFloat(param2.getAttributeFloat("delay"));
                _loc_3.writeBoolean(param2.getAttributeBool("stopOnExit"));
            }
            else if (param1 == "change_page")
            {
                this.writeString(_loc_3, param2.getAttribute("objectId"));
                this.writeString(_loc_3, param2.getAttribute("controller"));
                this.writeString(_loc_3, param2.getAttribute("targetPage"));
            }
            return _loc_3;
        }// end function

        private function _-57(param1:XData, param2:ByteArray, param3:Boolean) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = false;
            var _loc_16:* = 0;
            var _loc_17:* = undefined;
            var _loc_6:* = [];
            var _loc_7:* = {};
            var _loc_8:* = param1.getEnumerator("relation");
            while (_loc_8.moveNext())
            {
                
                _loc_9 = _loc_8.current;
                _loc_4 = _loc_9.getAttribute("target");
                _loc_10 = -1;
                if (_loc_4)
                {
                    if (this.displayList[_loc_4] != undefined)
                    {
                        _loc_10 = this.displayList[_loc_4];
                    }
                    else
                    {
                        continue;
                    }
                }
                else if (param3)
                {
                    continue;
                }
                _loc_4 = _loc_9.getAttribute("sidePair");
                if (!_loc_4)
                {
                    continue;
                }
                _loc_11 = _loc_7[_loc_10];
                if (!_loc_11)
                {
                    _loc_6.push(_loc_10);
                    _loc_11 = [];
                    _loc_7[_loc_10] = _loc_11;
                }
                _loc_5 = _loc_4.split(",");
                _loc_16 = 0;
                while (_loc_16 < _loc_5.length)
                {
                    
                    _loc_12 = _loc_5[_loc_16];
                    if (!_loc_12)
                    {
                    }
                    else
                    {
                        if (_loc_12.charAt((_loc_12.length - 1)) == "%")
                        {
                            _loc_12 = _loc_12.substr(0, (_loc_12.length - 1));
                            _loc_15 = true;
                        }
                        else
                        {
                            _loc_15 = false;
                        }
                        _loc_17 = _-H8[_loc_12];
                        if (_loc_17 != undefined)
                        {
                            _loc_11.push(_loc_15 ? (10000 + _loc_17) : (_loc_17));
                        }
                    }
                    _loc_16++;
                }
            }
            param2.writeByte(_loc_6.length);
            for each (_loc_10 in _loc_6)
            {
                
                param2.writeShort(_loc_10);
                _loc_11 = _loc_7[_loc_10];
                param2.writeByte(_loc_11.length);
                for each (_loc_16 in _loc_11)
                {
                    
                    if (_loc_16 >= 10000)
                    {
                        param2.writeByte(_loc_16 - 10000);
                        param2.writeBoolean(true);
                        continue;
                    }
                    param2.writeByte(_loc_16);
                    param2.writeBoolean(false);
                }
            }
            return;
        }// end function

        private function _-Nu(param1:XData) : ByteArray
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_2:* = new ByteArray();
            _loc_3 = param1.getAttribute("scroll");
            if (_loc_3 == "horizontal")
            {
                _loc_2.writeByte(0);
            }
            else if (_loc_3 == "both")
            {
                _loc_2.writeByte(2);
            }
            else
            {
                _loc_2.writeByte(1);
            }
            _loc_3 = param1.getAttribute("scrollBar");
            if (_loc_3 == "visible")
            {
                _loc_2.writeByte(1);
            }
            else if (_loc_3 == "auto")
            {
                _loc_2.writeByte(2);
            }
            else if (_loc_3 == "hidden")
            {
                _loc_2.writeByte(3);
            }
            else
            {
                _loc_2.writeByte(0);
            }
            _loc_2.writeInt(param1.getAttributeInt("scrollBarFlags"));
            _loc_3 = param1.getAttribute("scrollBarMargin");
            if (_loc_3)
            {
                _loc_4 = _loc_3.split(",");
                _loc_2.writeBoolean(true);
                _loc_2.writeInt(parseInt(_loc_4[0]));
                _loc_2.writeInt(parseInt(_loc_4[1]));
                _loc_2.writeInt(parseInt(_loc_4[2]));
                _loc_2.writeInt(parseInt(_loc_4[3]));
            }
            else
            {
                _loc_2.writeBoolean(false);
            }
            _loc_3 = param1.getAttribute("scrollBarRes");
            if (_loc_3)
            {
                _loc_4 = _loc_3.split(",");
                this.writeString(_loc_2, _loc_4[0]);
                this.writeString(_loc_2, _loc_4[1]);
            }
            else
            {
                this.writeString(_loc_2, null);
                this.writeString(_loc_2, null);
            }
            _loc_3 = param1.getAttribute("ptrRes");
            if (_loc_3)
            {
                _loc_4 = _loc_3.split(",");
                this.writeString(_loc_2, _loc_4[0]);
                this.writeString(_loc_2, _loc_4[1]);
            }
            else
            {
                this.writeString(_loc_2, null);
                this.writeString(_loc_2, null);
            }
            return _loc_2;
        }// end function

        private function _-70(param1:XData) : ByteArray
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = NaN;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = undefined;
            var _loc_2:* = new ByteArray();
            this.writeString(_loc_2, param1.getAttribute("name"));
            _loc_2.writeInt(param1.getAttributeInt("options"));
            _loc_2.writeBoolean(param1.getAttributeBool("autoPlay"));
            _loc_2.writeInt(param1.getAttributeInt("autoPlayRepeat", 1));
            _loc_2.writeFloat(param1.getAttributeFloat("autoPlayDelay"));
            _loc_4 = param1.getAttribute("frameRate");
            if (_loc_4)
            {
                _loc_9 = 1 / parseInt(_loc_4);
            }
            else
            {
                _loc_9 = 1 / 24;
            }
            _loc_8 = _loc_2.position;
            _loc_2.writeShort(0);
            _loc_7 = 0;
            var _loc_10:* = param1.getEnumerator("item");
            while (_loc_10.moveNext())
            {
                
                _loc_11 = _loc_10.current;
                _loc_3 = new ByteArray();
                this._-FU(_loc_3, 4, true);
                this._-Pu(_loc_3, 0);
                _loc_12 = _loc_11.getAttribute("type");
                this._-Gc(_loc_3, _loc_12);
                _loc_3.writeFloat(_loc_11.getAttributeInt("time") * _loc_9);
                _loc_4 = _loc_11.getAttribute("target");
                if (!_loc_4)
                {
                    _loc_3.writeShort(-1);
                }
                else
                {
                    _loc_13 = this.displayList[_loc_4];
                    if (_loc_13 == undefined)
                    {
                        _loc_3.clear();
                        continue;
                    }
                    _loc_3.writeShort(int(_loc_13));
                }
                this.writeString(_loc_3, _loc_11.getAttribute("label"));
                _loc_4 = _loc_11.getAttribute("endValue");
                if (_loc_11.getAttributeBool("tween") && _loc_4 != null)
                {
                    _loc_3.writeBoolean(true);
                    this._-Pu(_loc_3, 1);
                    _loc_3.writeFloat(_loc_11.getAttributeInt("duration") * _loc_9);
                    _loc_3.writeByte(EaseType.parseEaseType(_loc_11.getAttribute("ease")));
                    _loc_3.writeInt(_loc_11.getAttributeInt("repeat"));
                    _loc_3.writeBoolean(_loc_11.getAttributeBool("yoyo"));
                    this.writeString(_loc_3, _loc_11.getAttribute("label2"));
                    this._-Pu(_loc_3, 2);
                    _loc_4 = _loc_11.getAttribute("startValue");
                    this._-Ok(_loc_3, _loc_12, _loc_4);
                    this._-Pu(_loc_3, 3);
                    _loc_4 = _loc_11.getAttribute("endValue");
                    this._-Ok(_loc_3, _loc_12, _loc_4);
                    _loc_4 = _loc_11.getAttribute("path");
                    this._-Pk(_loc_4, _loc_3);
                }
                else
                {
                    _loc_3.writeBoolean(false);
                    this._-Pu(_loc_3, 2);
                    _loc_4 = _loc_11.getAttribute("value");
                    if (_loc_4 == null)
                    {
                        _loc_4 = _loc_11.getAttribute("startValue");
                    }
                    this._-Ok(_loc_3, _loc_12, _loc_4);
                }
                _loc_2.writeShort(_loc_3.length);
                _loc_2.writeBytes(_loc_3);
                _loc_3.clear();
                _loc_7++;
            }
            this._-4J(_loc_2, _loc_8, _loc_7);
            return _loc_2;
        }// end function

        private function _-Pk(param1:String, param2:ByteArray) : void
        {
            var _loc_9:* = 0;
            if (!param1)
            {
                param2.writeInt(0);
                return;
            }
            var _loc_3:* = param2.position;
            param2.writeInt(0);
            var _loc_4:* = param1.split(",");
            var _loc_5:* = _loc_4.length;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_5)
            {
                
                _loc_6++;
                _loc_9 = parseInt(_loc_4[_loc_7++]);
                param2.writeByte(_loc_9);
                switch(_loc_9)
                {
                    case CurveType.Bezier:
                    {
                        param2.writeFloat(parseFloat(_loc_4[_loc_7++]));
                        param2.writeFloat(parseFloat(_loc_4[_loc_7++]));
                        param2.writeFloat(parseFloat(_loc_4[_loc_7++]));
                        param2.writeFloat(parseFloat(_loc_4[_loc_7++]));
                        break;
                    }
                    case CurveType.CubicBezier:
                    {
                        param2.writeFloat(parseFloat(_loc_4[_loc_7++]));
                        param2.writeFloat(parseFloat(_loc_4[_loc_7++]));
                        param2.writeFloat(parseFloat(_loc_4[_loc_7++]));
                        param2.writeFloat(parseFloat(_loc_4[_loc_7++]));
                        param2.writeFloat(parseFloat(_loc_4[_loc_7++]));
                        param2.writeFloat(parseFloat(_loc_4[_loc_7++]));
                        _loc_7++;
                        break;
                    }
                    default:
                    {
                        param2.writeFloat(parseFloat(_loc_4[_loc_7++]));
                        param2.writeFloat(parseFloat(_loc_4[_loc_7++]));
                        break;
                        break;
                    }
                }
            }
            var _loc_8:* = param2.position;
            param2.position = _loc_3;
            param2.writeInt(_loc_6);
            param2.position = _loc_8;
            return;
        }// end function

        private function _-9Z(param1:XData, param2:ByteArray) : void
        {
            var _loc_3:* = param2.position;
            param2.writeShort(0);
            var _loc_4:* = 0;
            var _loc_5:* = param1.getEnumerator("property");
            while (_loc_5.moveNext())
            {
                
                this.writeString(param2, _loc_5.current.getAttribute("target"));
                param2.writeShort(_loc_5.current.getAttributeInt("propertyId"));
                this.writeString(param2, _loc_5.current.getAttribute("value"), true, true);
                _loc_4++;
            }
            this._-4J(param2, _loc_3, _loc_4);
            return;
        }// end function

        private function _-2N(param1:XData) : ByteArray
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_13:* = 0;
            var _loc_14:* = null;
            var _loc_15:* = 0;
            var _loc_16:* = undefined;
            var _loc_17:* = 0;
            var _loc_18:* = 0;
            var _loc_19:* = null;
            var _loc_20:* = 0;
            var _loc_21:* = 0;
            var _loc_22:* = null;
            var _loc_23:* = null;
            var _loc_24:* = 0;
            var _loc_25:* = 0;
            var _loc_26:* = false;
            var _loc_27:* = null;
            var _loc_28:* = null;
            var _loc_29:* = 0;
            var _loc_2:* = new ByteArray();
            var _loc_12:* = param1.getName();
            switch(_loc_12)
            {
                case FObjectType.IMAGE:
                {
                    _loc_11 = 0;
                    break;
                }
                case FObjectType.MOVIECLIP:
                {
                    _loc_11 = 1;
                    break;
                }
                case FObjectType.SWF:
                {
                    _loc_11 = 2;
                    break;
                }
                case FObjectType.GRAPH:
                {
                    _loc_11 = 3;
                    break;
                }
                case FObjectType.LOADER:
                {
                    _loc_11 = 4;
                    break;
                }
                case FObjectType.GROUP:
                {
                    _loc_11 = 5;
                    break;
                }
                case FObjectType.TEXT:
                {
                    if (param1.getAttributeBool("input"))
                    {
                        _loc_11 = 8;
                    }
                    else
                    {
                        _loc_11 = 6;
                    }
                    break;
                }
                case FObjectType.RICHTEXT:
                {
                    _loc_11 = 7;
                    break;
                }
                case FObjectType.COMPONENT:
                {
                    _loc_11 = 9;
                    break;
                }
                case FObjectType.LIST:
                {
                    if (param1.getAttributeBool("treeView"))
                    {
                        _loc_11 = 17;
                    }
                    else
                    {
                        _loc_11 = 10;
                    }
                    break;
                }
                default:
                {
                    _loc_11 = 0;
                    break;
                    break;
                }
            }
            if (_loc_11 == 17)
            {
                _loc_13 = 10;
            }
            else if (_loc_11 == 10)
            {
                _loc_13 = 9;
            }
            else
            {
                _loc_13 = 7;
            }
            this._-FU(_loc_2, _loc_13, true);
            this._-Pu(_loc_2, 0);
            _loc_2.writeByte(_loc_11);
            this.writeString(_loc_2, param1.getAttribute("src"));
            this.writeString(_loc_2, param1.getAttribute("pkg"));
            this.writeString(_loc_2, param1.getAttribute("id", ""));
            this.writeString(_loc_2, param1.getAttribute("name", ""));
            _loc_4 = param1.getAttribute("xy");
            _loc_5 = _loc_4.split(",");
            _loc_2.writeInt(int(_loc_5[0]));
            _loc_2.writeInt(int(_loc_5[1]));
            _loc_4 = param1.getAttribute("size");
            if (_loc_4)
            {
                _loc_2.writeBoolean(true);
                _loc_5 = _loc_4.split(",");
                _loc_2.writeInt(parseInt(_loc_5[0]));
                _loc_2.writeInt(parseInt(_loc_5[1]));
            }
            else
            {
                _loc_2.writeBoolean(false);
            }
            _loc_4 = param1.getAttribute("restrictSize");
            if (_loc_4)
            {
                _loc_2.writeBoolean(true);
                _loc_5 = _loc_4.split(",");
                _loc_2.writeInt(parseInt(_loc_5[0]));
                _loc_2.writeInt(parseInt(_loc_5[1]));
                _loc_2.writeInt(parseInt(_loc_5[2]));
                _loc_2.writeInt(parseInt(_loc_5[3]));
            }
            else
            {
                _loc_2.writeBoolean(false);
            }
            _loc_4 = param1.getAttribute("scale");
            if (_loc_4)
            {
                _loc_2.writeBoolean(true);
                _loc_5 = _loc_4.split(",");
                _loc_2.writeFloat(parseFloat(_loc_5[0]));
                _loc_2.writeFloat(parseFloat(_loc_5[1]));
            }
            else
            {
                _loc_2.writeBoolean(false);
            }
            _loc_4 = param1.getAttribute("skew");
            if (_loc_4)
            {
                _loc_2.writeBoolean(true);
                _loc_5 = _loc_4.split(",");
                _loc_2.writeFloat(parseFloat(_loc_5[0]));
                _loc_2.writeFloat(parseFloat(_loc_5[1]));
            }
            else
            {
                _loc_2.writeBoolean(false);
            }
            _loc_4 = param1.getAttribute("pivot");
            if (_loc_4)
            {
                _loc_5 = _loc_4.split(",");
                _loc_2.writeBoolean(true);
                _loc_2.writeFloat(parseFloat(_loc_5[0]));
                _loc_2.writeFloat(parseFloat(_loc_5[1]));
                _loc_2.writeBoolean(param1.getAttributeBool("anchor"));
            }
            else
            {
                _loc_2.writeBoolean(false);
            }
            _loc_2.writeFloat(param1.getAttributeFloat("alpha", 1));
            _loc_2.writeFloat(param1.getAttributeFloat("rotation"));
            _loc_2.writeBoolean(param1.getAttributeBool("visible", true));
            _loc_2.writeBoolean(param1.getAttributeBool("touchable", true));
            _loc_2.writeBoolean(param1.getAttributeBool("grayed"));
            _loc_4 = param1.getAttribute("blend");
            switch(_loc_4)
            {
                case "add":
                {
                    _loc_2.writeByte(2);
                    break;
                }
                case "multiply":
                {
                    _loc_2.writeByte(3);
                    break;
                }
                case "none":
                {
                    _loc_2.writeByte(1);
                    break;
                }
                case "screen":
                {
                    _loc_2.writeByte(4);
                    break;
                }
                case "erase":
                {
                    _loc_2.writeByte(5);
                    break;
                }
                default:
                {
                    _loc_2.writeByte(0);
                    break;
                    break;
                }
            }
            _loc_4 = param1.getAttribute("filter");
            if (_loc_4)
            {
                if (_loc_4 == "color")
                {
                    _loc_2.writeByte(1);
                    _loc_4 = param1.getAttribute("filterData");
                    _loc_5 = _loc_4.split(",");
                    _loc_2.writeFloat(parseFloat(_loc_5[0]));
                    _loc_2.writeFloat(parseFloat(_loc_5[1]));
                    _loc_2.writeFloat(parseFloat(_loc_5[2]));
                    _loc_2.writeFloat(parseFloat(_loc_5[3]));
                }
                else
                {
                    _loc_2.writeByte(0);
                }
            }
            else
            {
                _loc_2.writeByte(0);
            }
            this.writeString(_loc_2, param1.getAttribute("customData"), true);
            this._-Pu(_loc_2, 1);
            this.writeString(_loc_2, param1.getAttribute("tooltips"), true);
            _loc_4 = param1.getAttribute("group");
            if (_loc_4 && this.displayList[_loc_4] != undefined)
            {
                _loc_2.writeShort(this.displayList[_loc_4]);
            }
            else
            {
                _loc_2.writeShort(-1);
            }
            this._-Pu(_loc_2, 2);
            _loc_8 = param1.getChildren();
            _loc_7 = 0;
            _loc_10 = _loc_2.position;
            _loc_2.writeShort(0);
            for each (_loc_14 in _loc_8)
            {
                
                _loc_15 = FGearBase.getIndexByName(_loc_14.getName());
                if (_loc_15 != -1)
                {
                    _loc_3 = this._-7Q(int(_loc_15), _loc_14);
                    if (_loc_3 == null)
                    {
                        continue;
                    }
                    _loc_7++;
                    _loc_2.writeShort((_loc_3.length + 1));
                    _loc_2.writeByte(_loc_15);
                    _loc_2.writeBytes(_loc_3);
                    _loc_3.clear();
                }
            }
            this._-4J(_loc_2, _loc_10, _loc_7);
            this._-Pu(_loc_2, 3);
            this._-57(param1, _loc_2, false);
            if (_loc_12 == FObjectType.COMPONENT || _loc_12 == FObjectType.LIST)
            {
                this._-Pu(_loc_2, 4);
                _loc_16 = this._-59[param1.getAttribute("pageController")];
                if (_loc_16 != undefined)
                {
                    _loc_2.writeShort(_loc_16);
                }
                else
                {
                    _loc_2.writeShort(-1);
                }
                _loc_4 = param1.getAttribute("controller");
                if (_loc_4)
                {
                    _loc_10 = _loc_2.position;
                    _loc_2.writeShort(0);
                    _loc_5 = _loc_4.split(",");
                    _loc_7 = 0;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_5.length)
                    {
                        
                        if (_loc_5[_loc_6])
                        {
                            this.writeString(_loc_2, _loc_5[_loc_6]);
                            this.writeString(_loc_2, _loc_5[(_loc_6 + 1)]);
                            _loc_7++;
                        }
                        _loc_6 = _loc_6 + 2;
                    }
                    this._-4J(_loc_2, _loc_10, _loc_7);
                }
                else
                {
                    _loc_2.writeShort(0);
                }
                this._-9Z(param1, _loc_2);
            }
            else if (_loc_11 == 8)
            {
                this._-Pu(_loc_2, 4);
                this.writeString(_loc_2, param1.getAttribute("prompt"));
                this.writeString(_loc_2, param1.getAttribute("restrict"));
                _loc_2.writeInt(param1.getAttributeInt("maxLength"));
                _loc_2.writeInt(param1.getAttributeInt("keyboardType"));
                _loc_2.writeBoolean(param1.getAttributeBool("password"));
            }
            this._-Pu(_loc_2, 5);
            switch(_loc_12)
            {
                case FObjectType.IMAGE:
                {
                    _loc_4 = param1.getAttribute("color");
                    if (_loc_4)
                    {
                        _loc_2.writeBoolean(true);
                        this._-5g(_loc_2, _loc_4, false);
                    }
                    else
                    {
                        _loc_2.writeBoolean(false);
                    }
                    _loc_4 = param1.getAttribute("flip");
                    switch(_loc_4)
                    {
                        case "both":
                        {
                            _loc_2.writeByte(3);
                            break;
                        }
                        case "hz":
                        {
                            _loc_2.writeByte(1);
                            break;
                        }
                        case "vt":
                        {
                            _loc_2.writeByte(2);
                            break;
                        }
                        default:
                        {
                            _loc_2.writeByte(0);
                            break;
                            break;
                        }
                    }
                    _loc_4 = param1.getAttribute("fillMethod");
                    this._-Hl(_loc_2, _loc_4);
                    if (_loc_4 && _loc_4 != "none")
                    {
                        _loc_2.writeByte(param1.getAttributeInt("fillOrigin"));
                        _loc_2.writeBoolean(param1.getAttributeBool("fillClockwise", true));
                        _loc_2.writeFloat(param1.getAttributeInt("fillAmount", 100) / 100);
                    }
                    break;
                }
                case FObjectType.MOVIECLIP:
                {
                    _loc_4 = param1.getAttribute("color");
                    if (_loc_4)
                    {
                        _loc_2.writeBoolean(true);
                        this._-5g(_loc_2, _loc_4, false);
                    }
                    else
                    {
                        _loc_2.writeBoolean(false);
                    }
                    _loc_2.writeByte(0);
                    _loc_2.writeInt(param1.getAttributeInt("frame"));
                    _loc_2.writeBoolean(param1.getAttributeBool("playing", true));
                    break;
                }
                case FObjectType.GRAPH:
                {
                    _loc_4 = param1.getAttribute("type");
                    _loc_17 = this._-H3(_loc_2, _loc_4);
                    _loc_2.writeInt(param1.getAttributeInt("lineSize", 1));
                    this._-5g(_loc_2, param1.getAttribute("lineColor"));
                    this._-5g(_loc_2, param1.getAttribute("fillColor"), true, 4294967295);
                    _loc_4 = param1.getAttribute("corner", "");
                    if (_loc_4)
                    {
                        _loc_2.writeBoolean(true);
                        _loc_5 = _loc_4.split(",");
                        _loc_18 = parseInt(_loc_5[0]);
                        _loc_2.writeFloat(_loc_18);
                        if (_loc_5[1])
                        {
                            _loc_2.writeFloat(parseInt(_loc_5[1]));
                        }
                        else
                        {
                            _loc_2.writeFloat(_loc_18);
                        }
                        if (_loc_5[2])
                        {
                            _loc_2.writeFloat(parseInt(_loc_5[2]));
                        }
                        else
                        {
                            _loc_2.writeFloat(_loc_18);
                        }
                        if (_loc_5[3])
                        {
                            _loc_2.writeFloat(parseInt(_loc_5[3]));
                        }
                        else
                        {
                            _loc_2.writeFloat(_loc_18);
                        }
                    }
                    else
                    {
                        _loc_2.writeBoolean(false);
                    }
                    if (_loc_17 == 3)
                    {
                        _loc_4 = param1.getAttribute("points");
                        _loc_5 = _loc_4.split(",");
                        _loc_7 = _loc_5.length;
                        _loc_2.writeShort(_loc_7);
                        _loc_6 = 0;
                        while (_loc_6 < _loc_7)
                        {
                            
                            _loc_2.writeFloat(parseFloat(_loc_5[_loc_6]));
                            _loc_6++;
                        }
                    }
                    else if (_loc_17 == 4)
                    {
                        _loc_2.writeShort(param1.getAttributeInt("sides"));
                        _loc_2.writeFloat(param1.getAttributeFloat("startAngle"));
                        _loc_4 = param1.getAttribute("distances");
                        if (_loc_4)
                        {
                            _loc_5 = _loc_4.split(",");
                            _loc_7 = _loc_5.length;
                            _loc_2.writeShort(_loc_7);
                            _loc_6 = 0;
                            while (_loc_6 < _loc_7)
                            {
                                
                                if (_loc_5[_loc_6])
                                {
                                    _loc_2.writeFloat(parseFloat(_loc_5[_loc_6]));
                                }
                                else
                                {
                                    _loc_2.writeFloat(1);
                                }
                                _loc_6++;
                            }
                        }
                        else
                        {
                            _loc_2.writeShort(0);
                        }
                    }
                    break;
                }
                case FObjectType.LOADER:
                {
                    this.writeString(_loc_2, param1.getAttribute("url", ""));
                    this._-6R(_loc_2, param1.getAttribute("align"));
                    this._-N7(_loc_2, param1.getAttribute("vAlign"));
                    _loc_4 = param1.getAttribute("fill");
                    switch(_loc_4)
                    {
                        case "none":
                        {
                            _loc_2.writeByte(0);
                            break;
                        }
                        case "scale":
                        {
                            _loc_2.writeByte(1);
                            break;
                        }
                        case "scaleMatchHeight":
                        {
                            _loc_2.writeByte(2);
                            break;
                        }
                        case "scaleMatchWidth":
                        {
                            _loc_2.writeByte(3);
                            break;
                        }
                        case "scaleFree":
                        {
                            _loc_2.writeByte(4);
                            break;
                        }
                        case "scaleNoBorder":
                        {
                            _loc_2.writeByte(5);
                            break;
                        }
                        default:
                        {
                            _loc_2.writeByte(0);
                            break;
                            break;
                        }
                    }
                    _loc_2.writeBoolean(param1.getAttributeBool("shrinkOnly"));
                    _loc_2.writeBoolean(param1.getAttributeBool("autoSize"));
                    _loc_2.writeBoolean(param1.getAttributeBool("errorSign"));
                    _loc_2.writeBoolean(param1.getAttributeBool("playing", true));
                    _loc_2.writeInt(param1.getAttributeInt("frame"));
                    _loc_4 = param1.getAttribute("color");
                    if (_loc_4)
                    {
                        _loc_2.writeBoolean(true);
                        this._-5g(_loc_2, _loc_4, false);
                    }
                    else
                    {
                        _loc_2.writeBoolean(false);
                    }
                    _loc_4 = param1.getAttribute("fillMethod");
                    this._-Hl(_loc_2, _loc_4);
                    if (_loc_4 && _loc_4 != "none")
                    {
                        _loc_2.writeByte(param1.getAttributeInt("fillOrigin"));
                        _loc_2.writeBoolean(param1.getAttributeBool("fillClockwise", true));
                        _loc_2.writeFloat(param1.getAttributeInt("fillAmount", 100) / 100);
                    }
                    break;
                }
                case FObjectType.GROUP:
                {
                    _loc_4 = param1.getAttribute("layout");
                    switch(_loc_4)
                    {
                        case "hz":
                        {
                            _loc_2.writeByte(1);
                            break;
                        }
                        case "vt":
                        {
                            _loc_2.writeByte(2);
                            break;
                        }
                        default:
                        {
                            _loc_2.writeByte(0);
                            break;
                            break;
                        }
                    }
                    _loc_2.writeInt(param1.getAttributeInt("lineGap"));
                    _loc_2.writeInt(param1.getAttributeInt("colGap"));
                    _loc_2.writeBoolean(param1.getAttributeBool("excludeInvisibles"));
                    _loc_2.writeBoolean(param1.getAttributeBool("autoSizeDisabled"));
                    _loc_2.writeShort(param1.getAttributeInt("mainGridIndex", -1));
                    break;
                }
                case FObjectType.TEXT:
                case FObjectType.RICHTEXT:
                {
                    this.writeString(_loc_2, param1.getAttribute("font"));
                    _loc_2.writeShort(param1.getAttributeInt("fontSize"));
                    this._-5g(_loc_2, param1.getAttribute("color"), false);
                    this._-6R(_loc_2, param1.getAttribute("align"));
                    this._-N7(_loc_2, param1.getAttribute("vAlign"));
                    _loc_2.writeShort(param1.getAttributeInt("leading", 3));
                    _loc_2.writeShort(param1.getAttributeInt("letterSpacing"));
                    _loc_2.writeBoolean(param1.getAttributeBool("ubb"));
                    this._-Bu(_loc_2, param1.getAttribute("autoSize", "both"));
                    _loc_2.writeBoolean(param1.getAttributeBool("underline"));
                    _loc_2.writeBoolean(param1.getAttributeBool("italic"));
                    _loc_2.writeBoolean(param1.getAttributeBool("bold"));
                    _loc_2.writeBoolean(param1.getAttributeBool("singleLine"));
                    _loc_4 = param1.getAttribute("strokeColor");
                    if (_loc_4)
                    {
                        _loc_2.writeBoolean(true);
                        this._-5g(_loc_2, _loc_4);
                        _loc_2.writeFloat(param1.getAttributeInt("strokeSize", 1));
                    }
                    else
                    {
                        _loc_2.writeBoolean(false);
                    }
                    _loc_4 = param1.getAttribute("shadowColor");
                    if (_loc_4)
                    {
                        _loc_2.writeBoolean(true);
                        this._-5g(_loc_2, param1.getAttribute("shadowColor"));
                        _loc_4 = param1.getAttribute("shadowOffset");
                        if (_loc_4)
                        {
                            _loc_5 = _loc_4.split(",");
                            _loc_2.writeFloat(parseFloat(_loc_5[0]));
                            _loc_2.writeFloat(parseFloat(_loc_5[1]));
                        }
                        else
                        {
                            _loc_2.writeFloat(1);
                            _loc_2.writeFloat(1);
                        }
                    }
                    else
                    {
                        _loc_2.writeBoolean(false);
                    }
                    _loc_2.writeBoolean(param1.getAttributeBool("vars"));
                    break;
                }
                case FObjectType.COMPONENT:
                {
                    break;
                }
                case FObjectType.LIST:
                {
                    _loc_19 = param1.getAttribute("layout");
                    switch(_loc_19)
                    {
                        case "column":
                        {
                            _loc_2.writeByte(0);
                            break;
                        }
                        case "row":
                        {
                            _loc_2.writeByte(1);
                            break;
                        }
                        case "flow_hz":
                        {
                            _loc_2.writeByte(2);
                            break;
                        }
                        case "flow_vt":
                        {
                            _loc_2.writeByte(3);
                            break;
                        }
                        case "pagination":
                        {
                            _loc_2.writeByte(4);
                            break;
                        }
                        default:
                        {
                            _loc_2.writeByte(0);
                            break;
                            break;
                        }
                    }
                    _loc_4 = param1.getAttribute("selectionMode");
                    switch(_loc_4)
                    {
                        case "single":
                        {
                            _loc_2.writeByte(0);
                            break;
                        }
                        case "multiple":
                        {
                            _loc_2.writeByte(1);
                            break;
                        }
                        case "multipleSingleClick":
                        {
                            _loc_2.writeByte(2);
                            break;
                        }
                        case "none":
                        {
                            _loc_2.writeByte(3);
                            break;
                        }
                        default:
                        {
                            _loc_2.writeByte(0);
                            break;
                            break;
                        }
                    }
                    this._-6R(_loc_2, param1.getAttribute("align"));
                    this._-N7(_loc_2, param1.getAttribute("vAlign"));
                    _loc_2.writeShort(param1.getAttributeInt("lineGap"));
                    _loc_2.writeShort(param1.getAttributeInt("colGap"));
                    _loc_20 = param1.getAttributeInt("lineItemCount");
                    _loc_21 = param1.getAttributeInt("lineItemCount2");
                    if (_loc_19 == "flow_hz")
                    {
                        _loc_2.writeShort(0);
                        _loc_2.writeShort(_loc_20);
                    }
                    else if (_loc_19 == "flow_vt")
                    {
                        _loc_2.writeShort(_loc_20);
                        _loc_2.writeShort(0);
                    }
                    else if (_loc_19 == "pagination")
                    {
                        _loc_2.writeShort(_loc_21);
                        _loc_2.writeShort(_loc_20);
                    }
                    else
                    {
                        _loc_2.writeShort(0);
                        _loc_2.writeShort(0);
                    }
                    if (!_loc_19 || _loc_19 == "row" || _loc_19 == "column")
                    {
                        _loc_2.writeBoolean(param1.getAttributeBool("autoItemSize", true));
                    }
                    else
                    {
                        _loc_2.writeBoolean(param1.getAttributeBool("autoItemSize", false));
                    }
                    _loc_4 = param1.getAttribute("renderOrder");
                    switch(_loc_4)
                    {
                        case "ascent":
                        {
                            _loc_2.writeByte(0);
                            break;
                        }
                        case "descent":
                        {
                            _loc_2.writeByte(1);
                            break;
                        }
                        case "arch":
                        {
                            _loc_2.writeByte(2);
                            break;
                        }
                        default:
                        {
                            _loc_2.writeByte(0);
                            break;
                            break;
                        }
                    }
                    _loc_2.writeShort(param1.getAttributeInt("apex"));
                    _loc_4 = param1.getAttribute("margin");
                    if (_loc_4)
                    {
                        _loc_5 = _loc_4.split(",");
                        _loc_2.writeBoolean(true);
                        _loc_2.writeInt(parseInt(_loc_5[0]));
                        _loc_2.writeInt(parseInt(_loc_5[1]));
                        _loc_2.writeInt(parseInt(_loc_5[2]));
                        _loc_2.writeInt(parseInt(_loc_5[3]));
                    }
                    else
                    {
                        _loc_2.writeBoolean(false);
                    }
                    _loc_4 = param1.getAttribute("overflow");
                    if (_loc_4 == "hidden")
                    {
                        _loc_2.writeByte(1);
                    }
                    else if (_loc_4 == "scroll")
                    {
                        _loc_2.writeByte(2);
                    }
                    else
                    {
                        _loc_2.writeByte(0);
                    }
                    _loc_4 = param1.getAttribute("clipSoftness");
                    if (_loc_4)
                    {
                        _loc_5 = _loc_4.split(",");
                        _loc_2.writeBoolean(true);
                        _loc_2.writeInt(parseInt(_loc_5[0]));
                        _loc_2.writeInt(parseInt(_loc_5[1]));
                    }
                    else
                    {
                        _loc_2.writeBoolean(false);
                    }
                    _loc_2.writeBoolean(param1.getAttributeBool("scrollItemToViewOnClick", true));
                    _loc_2.writeBoolean(param1.getAttributeBool("foldInvisibleItems"));
                    break;
                }
                case FObjectType.SWF:
                {
                    _loc_2.writeBoolean(param1.getAttributeBool("playing", true));
                    break;
                }
                default:
                {
                    break;
                }
            }
            this._-Pu(_loc_2, 6);
            switch(_loc_12)
            {
                case FObjectType.TEXT:
                case FObjectType.RICHTEXT:
                {
                    this.writeString(_loc_2, param1.getAttribute("text"), true);
                    break;
                }
                case FObjectType.COMPONENT:
                {
                    _loc_8 = param1.getChildren();
                    for each (_loc_14 in _loc_8)
                    {
                        
                        switch(_loc_14.getName())
                        {
                            case FObjectType.EXT_LABEL:
                            {
                                _loc_2.writeByte(11);
                                this.writeString(_loc_2, _loc_14.getAttribute("title"), true);
                                this.writeString(_loc_2, _loc_14.getAttribute("icon"));
                                _loc_4 = _loc_14.getAttribute("titleColor");
                                if (_loc_4)
                                {
                                    _loc_2.writeBoolean(true);
                                    this._-5g(_loc_2, _loc_4);
                                }
                                else
                                {
                                    _loc_2.writeBoolean(false);
                                }
                                _loc_2.writeInt(_loc_14.getAttributeInt("titleFontSize"));
                                _loc_22 = _loc_14.getAttribute("prompt");
                                _loc_23 = _loc_14.getAttribute("restrict");
                                _loc_24 = _loc_14.getAttributeInt("maxLength");
                                _loc_25 = _loc_14.getAttributeInt("keyboardType");
                                _loc_26 = _loc_14.getAttributeBool("password");
                                if (_loc_22 || _loc_23 || _loc_24 || _loc_25 || _loc_26)
                                {
                                    _loc_2.writeBoolean(true);
                                    this.writeString(_loc_2, _loc_22, true);
                                    this.writeString(_loc_2, _loc_23);
                                    _loc_2.writeInt(_loc_24);
                                    _loc_2.writeInt(_loc_25);
                                    _loc_2.writeBoolean(_loc_26);
                                }
                                else
                                {
                                    _loc_2.writeBoolean(false);
                                }
                                break;
                            }
                            case FObjectType.EXT_BUTTON:
                            {
                                _loc_2.writeByte(12);
                                this.writeString(_loc_2, _loc_14.getAttribute("title"), true);
                                this.writeString(_loc_2, _loc_14.getAttribute("selectedTitle"), true);
                                this.writeString(_loc_2, _loc_14.getAttribute("icon"));
                                this.writeString(_loc_2, _loc_14.getAttribute("selectedIcon"));
                                _loc_4 = _loc_14.getAttribute("titleColor");
                                if (_loc_4)
                                {
                                    _loc_2.writeBoolean(true);
                                    this._-5g(_loc_2, _loc_4);
                                }
                                else
                                {
                                    _loc_2.writeBoolean(false);
                                }
                                _loc_2.writeInt(_loc_14.getAttributeInt("titleFontSize"));
                                _loc_4 = _loc_14.getAttribute("controller");
                                if (_loc_4)
                                {
                                    _loc_16 = this._-59[_loc_4];
                                    if (_loc_16 != undefined)
                                    {
                                        _loc_2.writeShort(_loc_16);
                                    }
                                    else
                                    {
                                        _loc_2.writeShort(-1);
                                    }
                                }
                                else
                                {
                                    _loc_2.writeShort(-1);
                                }
                                this.writeString(_loc_2, _loc_14.getAttribute("page"));
                                this.writeString(_loc_2, _loc_14.getAttribute("sound"), false, false);
                                _loc_4 = _loc_14.getAttribute("volume");
                                if (_loc_4)
                                {
                                    _loc_2.writeBoolean(true);
                                    _loc_2.writeFloat(parseInt(_loc_4) / 100);
                                }
                                else
                                {
                                    _loc_2.writeBoolean(false);
                                }
                                _loc_2.writeBoolean(_loc_14.getAttributeBool("checked"));
                                break;
                            }
                            case FObjectType.EXT_COMBOBOX:
                            {
                                _loc_2.writeByte(13);
                                _loc_10 = _loc_2.position;
                                _loc_2.writeShort(0);
                                _loc_28 = _loc_14.getEnumerator("item");
                                _loc_7 = 0;
                                while (_loc_28.moveNext())
                                {
                                    
                                    _loc_7++;
                                    _loc_27 = _loc_28.current;
                                    _loc_3 = new ByteArray();
                                    this.writeString(_loc_3, _loc_27.getAttribute("title"), true, false);
                                    this.writeString(_loc_3, _loc_27.getAttribute("value"), false, false);
                                    this.writeString(_loc_3, _loc_27.getAttribute("icon"));
                                    _loc_2.writeShort(_loc_3.length);
                                    _loc_2.writeBytes(_loc_3);
                                    _loc_3.clear();
                                }
                                this._-4J(_loc_2, _loc_10, _loc_7);
                                this.writeString(_loc_2, _loc_14.getAttribute("title"), true);
                                this.writeString(_loc_2, _loc_14.getAttribute("icon"));
                                _loc_4 = _loc_14.getAttribute("titleColor");
                                if (_loc_4)
                                {
                                    _loc_2.writeBoolean(true);
                                    this._-5g(_loc_2, _loc_4);
                                }
                                else
                                {
                                    _loc_2.writeBoolean(false);
                                }
                                _loc_2.writeInt(_loc_14.getAttributeInt("visibleItemCount"));
                                _loc_4 = _loc_14.getAttribute("direction");
                                switch(_loc_4)
                                {
                                    case "down":
                                    {
                                        _loc_2.writeByte(2);
                                        break;
                                    }
                                    case "up":
                                    {
                                        _loc_2.writeByte(1);
                                        break;
                                    }
                                    default:
                                    {
                                        _loc_2.writeByte(0);
                                        break;
                                        break;
                                    }
                                }
                                _loc_4 = _loc_14.getAttribute("selectionController");
                                if (_loc_4)
                                {
                                    _loc_16 = this._-59[_loc_4];
                                    if (_loc_16 != undefined)
                                    {
                                        _loc_2.writeShort(_loc_16);
                                    }
                                    else
                                    {
                                        _loc_2.writeShort(-1);
                                    }
                                }
                                else
                                {
                                    _loc_2.writeShort(-1);
                                }
                                break;
                            }
                            case FObjectType.EXT_PROGRESS_BAR:
                            {
                                _loc_2.writeByte(14);
                                _loc_2.writeInt(_loc_14.getAttributeInt("value"));
                                _loc_2.writeInt(_loc_14.getAttributeInt("max", 100));
                                _loc_2.writeInt(_loc_14.getAttributeInt("min"));
                                break;
                            }
                            case FObjectType.EXT_SLIDER:
                            {
                                _loc_2.writeByte(15);
                                _loc_2.writeInt(_loc_14.getAttributeInt("value"));
                                _loc_2.writeInt(_loc_14.getAttributeInt("max", 100));
                                _loc_2.writeInt(_loc_14.getAttributeInt("min"));
                                break;
                            }
                            case FObjectType.EXT_SCROLLBAR:
                            {
                                _loc_2.writeByte(16);
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                    }
                    break;
                }
                case FObjectType.LIST:
                {
                    _loc_4 = param1.getAttribute("selectionController");
                    if (_loc_4)
                    {
                        _loc_16 = this._-59[_loc_4];
                        if (_loc_16 != undefined)
                        {
                            _loc_2.writeShort(_loc_16);
                        }
                        else
                        {
                            _loc_2.writeShort(-1);
                        }
                    }
                    else
                    {
                        _loc_2.writeShort(-1);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (_loc_12 == FObjectType.LIST)
            {
                if (param1.getAttribute("overflow") == "scroll")
                {
                    this._-Pu(_loc_2, 7);
                    _loc_3 = this._-Nu(param1);
                    _loc_2.writeBytes(_loc_3);
                    _loc_3.clear();
                }
                this._-Pu(_loc_2, 8);
                this.writeString(_loc_2, param1.getAttribute("defaultItem"));
                _loc_28 = param1.getEnumerator("item");
                _loc_7 = 0;
                this.helperIntList.length = _loc_7;
                while (_loc_28.moveNext())
                {
                    
                    _loc_14 = _loc_28.current;
                    _loc_29 = _loc_14.getAttributeInt("level", 0);
                    this.helperIntList[_loc_7] = _loc_29;
                    _loc_7++;
                }
                _loc_28.reset();
                _loc_6 = 0;
                _loc_2.writeShort(_loc_7);
                while (_loc_28.moveNext())
                {
                    
                    _loc_14 = _loc_28.current;
                    _loc_3 = new ByteArray();
                    this.writeString(_loc_3, _loc_14.getAttribute("url"));
                    if (_loc_11 == 17)
                    {
                        _loc_29 = this.helperIntList[_loc_6];
                        if (_loc_6 != (_loc_7 - 1) && this.helperIntList[(_loc_6 + 1)] > _loc_29)
                        {
                            _loc_3.writeBoolean(true);
                        }
                        else
                        {
                            _loc_3.writeBoolean(false);
                        }
                        _loc_3.writeByte(_loc_29);
                    }
                    this.writeString(_loc_3, _loc_14.getAttribute("title"), true);
                    this.writeString(_loc_3, _loc_14.getAttribute("selectedTitle"), true);
                    this.writeString(_loc_3, _loc_14.getAttribute("icon"));
                    this.writeString(_loc_3, _loc_14.getAttribute("selectedIcon"));
                    this.writeString(_loc_3, _loc_14.getAttribute("name"));
                    _loc_4 = _loc_14.getAttribute("controllers");
                    if (_loc_4)
                    {
                        _loc_5 = _loc_4.split(",");
                        _loc_3.writeShort(_loc_5.length / 2);
                        _loc_6 = 0;
                        while (_loc_6 < _loc_5.length)
                        {
                            
                            this.writeString(_loc_3, _loc_5[_loc_6]);
                            this.writeString(_loc_3, _loc_5[(_loc_6 + 1)]);
                            _loc_6 = _loc_6 + 2;
                        }
                    }
                    else
                    {
                        _loc_3.writeShort(0);
                    }
                    this._-9Z(_loc_14, _loc_3);
                    _loc_2.writeShort(_loc_3.length);
                    _loc_2.writeBytes(_loc_3);
                    _loc_3.clear();
                    _loc_6++;
                }
            }
            if (_loc_11 == 17)
            {
                this._-Pu(_loc_2, 9);
                _loc_2.writeInt(param1.getAttributeInt("indent", 15));
                _loc_2.writeByte(param1.getAttributeInt("clickToExpand"));
            }
            return _loc_2;
        }// end function

        private function _-7Q(param1:int, param2:XData) : ByteArray
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_9:* = undefined;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = false;
            var _loc_13:* = 0;
            _loc_3 = param2.getAttribute("controller");
            if (_loc_3)
            {
                _loc_9 = this._-59[_loc_3];
                if (_loc_9 == undefined)
                {
                    return null;
                }
            }
            else
            {
                return null;
            }
            var _loc_8:* = new ByteArray();
            _loc_8.writeShort(_loc_9);
            if (param1 == 0 || param1 == 8)
            {
                _loc_3 = param2.getAttribute("pages");
                if (_loc_3)
                {
                    _loc_4 = _loc_3.split(",");
                    _loc_5 = _loc_4.length;
                    if (_loc_5 == 0)
                    {
                        return null;
                    }
                    _loc_8.writeShort(_loc_5);
                    _loc_6 = 0;
                    while (_loc_6 < _loc_5)
                    {
                        
                        this.writeString(_loc_8, _loc_4[_loc_6], false, false);
                        _loc_6++;
                    }
                }
                else
                {
                    _loc_8.writeShort(0);
                }
            }
            else
            {
                _loc_3 = param2.getAttribute("pages");
                if (_loc_3)
                {
                    _loc_10 = _loc_3.split(",");
                }
                else
                {
                    _loc_10 = [];
                }
                _loc_3 = param2.getAttribute("values");
                if (_loc_3)
                {
                    _loc_11 = _loc_3.split("|");
                }
                else
                {
                    _loc_11 = [];
                }
                _loc_5 = _loc_10.length;
                _loc_8.writeShort(_loc_5);
                _loc_6 = 0;
                while (_loc_6 < _loc_5)
                {
                    
                    _loc_3 = _loc_11[_loc_6];
                    if (param1 != 6 && param1 != 7 && (!_loc_3 || _loc_3 == "-"))
                    {
                        this.writeString(_loc_8, null);
                    }
                    else
                    {
                        this.writeString(_loc_8, _loc_10[_loc_6], false, false);
                        this._-8h(param1, _loc_3, _loc_8);
                    }
                    _loc_6++;
                }
                _loc_3 = param2.getAttribute("default");
                if (_loc_3)
                {
                    _loc_8.writeBoolean(true);
                    this._-8h(param1, _loc_3, _loc_8);
                }
                else
                {
                    _loc_8.writeBoolean(false);
                }
            }
            if (param2.getAttributeBool("tween"))
            {
                _loc_8.writeBoolean(true);
                _loc_8.writeByte(EaseType.parseEaseType(param2.getAttribute("ease")));
                _loc_8.writeFloat(param2.getAttributeFloat("duration", 0.3));
                _loc_8.writeFloat(param2.getAttributeFloat("delay"));
            }
            else
            {
                _loc_8.writeBoolean(false);
            }
            if (param1 == 1)
            {
                _loc_12 = param2.getAttributeBool("positionsInPercent");
                _loc_8.writeBoolean(_loc_12);
                if (_loc_12)
                {
                    _loc_6 = 0;
                    while (_loc_6 < _loc_5)
                    {
                        
                        _loc_3 = _loc_11[_loc_6];
                        if (_loc_3 && _loc_3 != "-")
                        {
                            this.writeString(_loc_8, _loc_10[_loc_6], false, false);
                            _loc_4 = _loc_3.split(",");
                            _loc_8.writeFloat(parseFloat(_loc_4[2]));
                            _loc_8.writeFloat(parseFloat(_loc_4[3]));
                        }
                        _loc_6++;
                    }
                    _loc_3 = param2.getAttribute("default");
                    if (_loc_3)
                    {
                        _loc_8.writeBoolean(true);
                        _loc_4 = _loc_3.split(",");
                        _loc_8.writeFloat(parseFloat(_loc_4[2]));
                        _loc_8.writeFloat(parseFloat(_loc_4[3]));
                    }
                    else
                    {
                        _loc_8.writeBoolean(false);
                    }
                }
            }
            if (param1 == 8)
            {
                _loc_13 = param2.getAttributeInt("condition");
                _loc_8.writeByte(_loc_13);
            }
            return _loc_8;
        }// end function

        private function _-8h(param1:int, param2:String, param3:ByteArray) : void
        {
            var _loc_4:* = null;
            switch(param1)
            {
                case 1:
                {
                    _loc_4 = param2.split(",");
                    param3.writeInt(parseInt(_loc_4[0]));
                    param3.writeInt(parseInt(_loc_4[1]));
                    break;
                }
                case 2:
                {
                    _loc_4 = param2.split(",");
                    param3.writeInt(parseInt(_loc_4[0]));
                    param3.writeInt(parseInt(_loc_4[1]));
                    if (_loc_4.length > 2)
                    {
                        param3.writeFloat(parseFloat(_loc_4[2]));
                        param3.writeFloat(parseFloat(_loc_4[3]));
                    }
                    else
                    {
                        param3.writeFloat(1);
                        param3.writeFloat(1);
                    }
                    break;
                }
                case 3:
                {
                    _loc_4 = param2.split(",");
                    param3.writeFloat(parseFloat(_loc_4[0]));
                    param3.writeFloat(parseFloat(_loc_4[1]));
                    param3.writeBoolean(_loc_4[2] == "1");
                    param3.writeBoolean(_loc_4.length < 4 || _loc_4[3] == "1");
                    break;
                }
                case 4:
                {
                    _loc_4 = param2.split(",");
                    if (_loc_4.length < 2)
                    {
                        this._-5g(param3, _loc_4[0]);
                        this._-5g(param3, "#000000");
                    }
                    else
                    {
                        this._-5g(param3, _loc_4[0]);
                        this._-5g(param3, _loc_4[1]);
                    }
                    break;
                }
                case 5:
                {
                    _loc_4 = param2.split(",");
                    param3.writeBoolean(_loc_4[1] == "p");
                    param3.writeInt(parseInt(_loc_4[0]));
                    break;
                }
                case 6:
                {
                    this.writeString(param3, param2, true);
                    break;
                }
                case 7:
                {
                    this.writeString(param3, param2);
                    break;
                }
                case 9:
                {
                    param3.writeInt(parseInt(param2));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function _-3y(param1:String, param2:XML) : ByteArray
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_3:* = XData.attach(param2);
            var _loc_4:* = new ByteArray();
            this._-FU(_loc_4, 2, false);
            this._-Pu(_loc_4, 0);
            _loc_4.writeInt(_loc_3.getAttributeInt("interval"));
            _loc_4.writeBoolean(_loc_3.getAttributeBool("swing"));
            _loc_4.writeInt(_loc_3.getAttributeInt("repeatDelay"));
            this._-Pu(_loc_4, 1);
            var _loc_8:* = _loc_3.getChild("frames").getEnumerator("frame");
            _loc_4.writeShort(_loc_3.getAttributeInt("frameCount"));
            var _loc_9:* = 0;
            while (_loc_8.moveNext())
            {
                
                _loc_10 = _loc_8.current;
                _loc_5 = _loc_10.getAttribute("rect");
                _loc_6 = _loc_5.split(",");
                _loc_7 = new ByteArray();
                _loc_7.writeInt(parseInt(_loc_6[0]));
                _loc_7.writeInt(parseInt(_loc_6[1]));
                _loc_11 = parseInt(_loc_6[2]);
                _loc_7.writeInt(_loc_11);
                _loc_7.writeInt(parseInt(_loc_6[3]));
                _loc_7.writeInt(_loc_10.getAttributeInt("addDelay"));
                _loc_5 = _loc_10.getAttribute("sprite");
                if (_loc_5)
                {
                    this.writeString(_loc_7, param1 + "_" + _loc_5);
                }
                else if (_loc_11)
                {
                    this.writeString(_loc_7, param1 + "_" + _loc_9);
                }
                else
                {
                    this.writeString(_loc_7, null);
                }
                _loc_4.writeShort(_loc_7.length);
                _loc_4.writeBytes(_loc_7);
                _loc_7.clear();
                _loc_9++;
            }
            return _loc_4;
        }// end function

        private function _-Ox(param1:String, param2:String) : ByteArray
        {
            var _loc_4:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_17:* = 0;
            var _loc_18:* = 0;
            var _loc_19:* = 0;
            var _loc_20:* = 0;
            var _loc_21:* = 0;
            var _loc_22:* = 0;
            var _loc_23:* = null;
            var _loc_24:* = null;
            var _loc_25:* = 0;
            var _loc_26:* = null;
            var _loc_27:* = null;
            var _loc_28:* = 0;
            var _loc_3:* = new ByteArray();
            var _loc_5:* = param2.split("\n");
            var _loc_6:* = _loc_5.length;
            var _loc_9:* = false;
            var _loc_10:* = false;
            var _loc_11:* = false;
            var _loc_12:* = false;
            var _loc_13:* = 0;
            var _loc_14:* = 0;
            var _loc_15:* = 0;
            var _loc_16:* = 0;
            _loc_7 = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_23 = _loc_5[_loc_7];
                if (!_loc_23)
                {
                }
                else
                {
                    _loc_23 = UtilsStr.trim(_loc_23);
                    _loc_24 = _loc_23.split(" ");
                    _loc_8 = {};
                    _loc_25 = 1;
                    while (_loc_25 < _loc_24.length)
                    {
                        
                        _loc_26 = _loc_24[_loc_25].split("=");
                        _loc_8[_loc_26[0]] = _loc_26[1];
                        _loc_25++;
                    }
                    _loc_23 = _loc_24[0];
                    if (_loc_23 == "char")
                    {
                        _loc_27 = _loc_8["img"];
                        if (!_loc_9)
                        {
                            if (!_loc_27)
                            {
                                ;
                            }
                        }
                        _loc_28 = _loc_8["id"];
                        if (_loc_28 == 0)
                        {
                        }
                        _loc_17 = _loc_8["xoffset"];
                        _loc_18 = _loc_8["yoffset"];
                        _loc_19 = _loc_8["width"];
                        _loc_20 = _loc_8["height"];
                        _loc_21 = _loc_8["xadvance"];
                        _loc_22 = _loc_8["chnl"];
                        if (_loc_22 != 0 && _loc_22 != 15)
                        {
                            _loc_12 = true;
                        }
                        _loc_4 = new ByteArray();
                        _loc_4.writeShort(_loc_28);
                        this.writeString(_loc_4, _loc_27);
                        _loc_4.writeInt(_loc_8["x"]);
                        _loc_4.writeInt(_loc_8["y"]);
                        _loc_4.writeInt(_loc_17);
                        _loc_4.writeInt(_loc_18);
                        _loc_4.writeInt(_loc_19);
                        _loc_4.writeInt(_loc_20);
                        _loc_4.writeInt(_loc_21);
                        _loc_4.writeByte(_loc_22);
                        _loc_3.writeShort(_loc_4.length);
                        _loc_3.writeBytes(_loc_4);
                        _loc_4.clear();
                        _loc_16++;
                    }
                    else if (_loc_23 == "info")
                    {
                        _loc_9 = _loc_8.face != null;
                        _loc_10 = _loc_9;
                        _loc_13 = _loc_8.size;
                        _loc_11 = _loc_8.resizable == "true";
                        if (_loc_8.colored != undefined)
                        {
                            _loc_10 = _loc_8.colored == "true";
                        }
                    }
                    else if (_loc_23 == "common")
                    {
                        _loc_14 = _loc_8.lineHeight;
                        _loc_15 = _loc_8.xadvance;
                        if (_loc_13 == 0)
                        {
                            _loc_13 = _loc_14;
                        }
                        else if (_loc_14 == 0)
                        {
                            _loc_14 = _loc_13;
                        }
                    }
                }
                _loc_7++;
            }
            _loc_4 = _loc_3;
            _loc_3 = new ByteArray();
            this._-FU(_loc_3, 2, false);
            this._-Pu(_loc_3, 0);
            _loc_3.writeBoolean(_loc_9);
            _loc_3.writeBoolean(_loc_10);
            _loc_3.writeBoolean(_loc_13 > 0 ? (_loc_11) : (false));
            _loc_3.writeBoolean(_loc_12);
            _loc_3.writeInt(_loc_13);
            _loc_3.writeInt(_loc_15);
            _loc_3.writeInt(_loc_14);
            this._-Pu(_loc_3, 1);
            _loc_3.writeInt(_loc_16);
            _loc_3.writeBytes(_loc_4);
            _loc_4.clear();
            return _loc_3;
        }// end function

        private function _-FU(param1:ByteArray, param2:int, param3:Boolean) : void
        {
            param1.writeByte(param2);
            param1.writeBoolean(param3);
            var _loc_4:* = 0;
            while (_loc_4 < param2)
            {
                
                if (param3)
                {
                    param1.writeShort(0);
                }
                else
                {
                    param1.writeInt(0);
                }
                _loc_4++;
            }
            return;
        }// end function

        private function _-Pu(param1:ByteArray, param2:int) : void
        {
            var _loc_3:* = param1.position;
            param1.position = 1;
            var _loc_4:* = param1.readBoolean();
            param1.position = 2 + param2 * (_loc_4 ? (2) : (4));
            if (_loc_4)
            {
                param1.writeShort(_loc_3);
            }
            else
            {
                param1.writeInt(_loc_3);
            }
            param1.position = _loc_3;
            return;
        }// end function

        private function _-4J(param1:ByteArray, param2:int, param3:int) : void
        {
            var _loc_4:* = param1.position;
            param1.position = param2;
            param1.writeShort(param3);
            param1.position = _loc_4;
            return;
        }// end function

        private function writeString(param1:ByteArray, param2:String, param3:Boolean = false, param4:Boolean = true) : void
        {
            var _loc_5:* = undefined;
            if (param4)
            {
                if (!param2)
                {
                    param1.writeShort(65534);
                    return;
                }
            }
            else
            {
                if (param2 == null)
                {
                    param1.writeShort(65534);
                    return;
                }
                if (param2.length == 0)
                {
                    param1.writeShort(65533);
                    return;
                }
            }
            if (!param3)
            {
                _loc_5 = this._-67[param2];
                if (_loc_5 != undefined)
                {
                    param1.writeShort(int(_loc_5));
                    return;
                }
            }
            this._-FV.push(param2);
            if (!param3)
            {
                this._-67[param2] = this._-FV.length - 1;
            }
            param1.writeShort((this._-FV.length - 1));
            return;
        }// end function

        private function _-5g(param1:ByteArray, param2:String, param3:Boolean = true, param4:uint = 4.27819e+009) : void
        {
            var _loc_5:* = 0;
            if (param2)
            {
                _loc_5 = ToolSet.convertFromHtmlColor(param2, param3);
            }
            else
            {
                _loc_5 = param4;
            }
            param1.writeByte(_loc_5 >> 16 & 255);
            param1.writeByte(_loc_5 >> 8 & 255);
            param1.writeByte(_loc_5 & 255);
            if (param3)
            {
                param1.writeByte(_loc_5 >> 24 & 255);
            }
            else
            {
                param1.writeByte(255);
            }
            return;
        }// end function

        private function _-6R(param1:ByteArray, param2:String) : void
        {
            switch(param2)
            {
                case "left":
                {
                    param1.writeByte(0);
                    break;
                }
                case "center":
                {
                    param1.writeByte(1);
                    break;
                }
                case "right":
                {
                    param1.writeByte(2);
                    break;
                }
                default:
                {
                    param1.writeByte(0);
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function _-N7(param1:ByteArray, param2:String) : void
        {
            switch(param2)
            {
                case "top":
                {
                    param1.writeByte(0);
                    break;
                }
                case "middle":
                {
                    param1.writeByte(1);
                    break;
                }
                case "bottom":
                {
                    param1.writeByte(2);
                    break;
                }
                default:
                {
                    param1.writeByte(0);
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function _-Hl(param1:ByteArray, param2:String) : void
        {
            switch(param2)
            {
                case "none":
                {
                    param1.writeByte(0);
                    break;
                }
                case "hz":
                {
                    param1.writeByte(1);
                    break;
                }
                case "vt":
                {
                    param1.writeByte(2);
                    break;
                }
                case "radial90":
                {
                    param1.writeByte(3);
                    break;
                }
                case "radial180":
                {
                    param1.writeByte(4);
                    break;
                }
                case "radial360":
                {
                    param1.writeByte(5);
                    break;
                }
                default:
                {
                    param1.writeByte(0);
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function _-Bu(param1:ByteArray, param2:String) : void
        {
            switch(param2)
            {
                case "none":
                {
                    param1.writeByte(0);
                    break;
                }
                case "both":
                {
                    param1.writeByte(1);
                    break;
                }
                case "height":
                {
                    param1.writeByte(2);
                    break;
                }
                case "shrink":
                {
                    param1.writeByte(3);
                    break;
                }
                default:
                {
                    param1.writeByte(0);
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function _-Gc(param1:ByteArray, param2:String) : void
        {
            switch(param2)
            {
                case "XY":
                {
                    param1.writeByte(0);
                    break;
                }
                case "Size":
                {
                    param1.writeByte(1);
                    break;
                }
                case "Scale":
                {
                    param1.writeByte(2);
                    break;
                }
                case "Pivot":
                {
                    param1.writeByte(3);
                    break;
                }
                case "Alpha":
                {
                    param1.writeByte(4);
                    break;
                }
                case "Rotation":
                {
                    param1.writeByte(5);
                    break;
                }
                case "Color":
                {
                    param1.writeByte(6);
                    break;
                }
                case "Animation":
                {
                    param1.writeByte(7);
                    break;
                }
                case "Visible":
                {
                    param1.writeByte(8);
                    break;
                }
                case "Sound":
                {
                    param1.writeByte(9);
                    break;
                }
                case "Transition":
                {
                    param1.writeByte(10);
                    break;
                }
                case "Shake":
                {
                    param1.writeByte(11);
                    break;
                }
                case "ColorFilter":
                {
                    param1.writeByte(12);
                    break;
                }
                case "Skew":
                {
                    param1.writeByte(13);
                    break;
                }
                case "Text":
                {
                    param1.writeByte(14);
                    break;
                }
                case "Icon":
                {
                    param1.writeByte(15);
                    break;
                }
                default:
                {
                    param1.writeByte(16);
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function _-H3(param1:ByteArray, param2:String) : int
        {
            switch(param2)
            {
                case "rect":
                {
                    param1.writeByte(1);
                    return 1;
                }
                case "ellipse":
                case "eclipse":
                {
                    param1.writeByte(2);
                    return 2;
                }
                case "polygon":
                {
                    param1.writeByte(3);
                    return 3;
                }
                case "regular_polygon":
                {
                    param1.writeByte(4);
                    return 4;
                }
                default:
                {
                    return 0;
                    break;
                }
            }
        }// end function

        private function _-Ok(param1:ByteArray, param2:String, param3:String) : void
        {
            _-J9.decode(param2, param3);
            _-J9.encodeBinary(param2, param1, this.writeString);
            return;
        }// end function

        private static function comparePackage(param1:FPackage, param2:FPackage) : int
        {
            return param1.rootItem.sortKey.localeCompare(param2.rootItem.sortKey);
        }// end function

    }
}
