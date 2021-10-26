package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.tween.*;
    import fairygui.utils.*;

    public class FTransition extends Object
    {
        private var _owner:FComponent;
        private var _name:String;
        private var _options:int;
        private var _items:Vector.<FTransitionItem>;
        private var _ownerBaseX:Number;
        private var _ownerBaseY:Number;
        private var _autoPlay:Boolean;
        private var _autoPlayRepeat:int;
        private var _autoPlayDelay:Number;
        private var _editing:Boolean;
        private var _frameRate:int;
        private var _maxFrame:int;
        var _orderDirty:Boolean;
        private var _totalTimes:int;
        private var _totalTasks:int;
        private var _playing:Boolean;
        private var _startFrame:Number;
        private var _endFrame:Number;
        private var _elapsedFrame:Number;
        private var _onComplete:Function;
        private var _onCompleteParam:Object;
        public static const OPTION_IGNORE_DISPLAY_CONTROLLER:int = 1;
        public static const OPTION_AUTO_STOP_DISABLED:int = 2;
        public static const OPTION_AUTO_STOP_AT_END:int = 4;

        public function FTransition(param1:FComponent)
        {
            this._owner = param1;
            this._items = new Vector.<FTransitionItem>;
            this._ownerBaseX = 0;
            this._ownerBaseY = 0;
            this._autoPlayRepeat = 1;
            this._autoPlayDelay = 0;
            this._frameRate = 24;
            return;
        }// end function

        public function get owner() : FComponent
        {
            return this._owner;
        }// end function

        public function set owner(param1:FComponent) : void
        {
            this._owner = param1;
            return;
        }// end function

        public function get name() : String
        {
            return this._name;
        }// end function

        public function set name(param1:String) : void
        {
            this._name = param1;
            return;
        }// end function

        public function get options() : int
        {
            return this._options;
        }// end function

        public function set options(param1:int) : void
        {
            this._options = param1;
            return;
        }// end function

        public function get autoPlay() : Boolean
        {
            return this._autoPlay;
        }// end function

        public function set autoPlay(param1:Boolean) : void
        {
            this._autoPlay = param1;
            return;
        }// end function

        public function get autoPlayDelay() : Number
        {
            return this._autoPlayDelay;
        }// end function

        public function set autoPlayDelay(param1:Number) : void
        {
            this._autoPlayDelay = param1;
            return;
        }// end function

        public function get autoPlayRepeat() : int
        {
            return this._autoPlayRepeat;
        }// end function

        public function set autoPlayRepeat(param1:int) : void
        {
            this._autoPlayRepeat = param1;
            return;
        }// end function

        public function get frameRate() : int
        {
            return this._frameRate;
        }// end function

        public function set frameRate(param1:int) : void
        {
            this._frameRate = param1;
            return;
        }// end function

        public function dispose() : void
        {
            return;
        }// end function

        public function get items() : Vector.<FTransitionItem>
        {
            if (this._orderDirty)
            {
                this.arrangeItems();
            }
            return this._items;
        }// end function

        public function get maxFrame() : int
        {
            if (this._orderDirty)
            {
                this.arrangeItems();
            }
            return this._maxFrame;
        }// end function

        private function arrangeItems() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            this._orderDirty = false;
            this._items.sort(this.__compareItem);
            var _loc_1:* = this._items.length;
            if (_loc_1 > 0)
            {
                this._maxFrame = this._items[(_loc_1 - 1)].frame;
            }
            else
            {
                this._maxFrame = 0;
            }
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._items[_loc_2];
                if (_loc_3.nextItem)
                {
                    _loc_3.nextItem.prevItem = null;
                    _loc_3.nextItem = null;
                }
                if (_loc_3.tween)
                {
                    _loc_4 = _loc_2 + 1;
                    while (_loc_4 < _loc_1)
                    {
                        
                        _loc_5 = this._items[_loc_4];
                        if (_loc_5.targetId == _loc_3.targetId && _loc_5.type == _loc_3.type)
                        {
                            _loc_3.nextItem = _loc_5;
                            _loc_5.prevItem = _loc_3;
                            break;
                        }
                        _loc_4++;
                    }
                }
                _loc_2++;
            }
            return;
        }// end function

        private function __compareItem(param1:FTransitionItem, param2:FTransitionItem) : int
        {
            var _loc_3:* = 0;
            if (param1.frame == param2.frame)
            {
                _loc_3 = param1.type.localeCompare(param2.type);
                if (_loc_3 != 0)
                {
                    if (param1.type == "Pivot")
                    {
                        return -1;
                    }
                    if (param2.type == "Pivot")
                    {
                        return 1;
                    }
                    return _loc_3;
                }
                else
                {
                    return param1.targetId.localeCompare(param2.targetId);
                }
            }
            else
            {
            }
            return param1.frame - param2.frame;
        }// end function

        public function createItem(param1:String, param2:String, param3:int) : FTransitionItem
        {
            if (param1 == null)
            {
                param1 = "";
            }
            var _loc_4:* = new FTransitionItem(this);
            _loc_4.targetId = param1;
            _loc_4.type = param2;
            _loc_4.frame = param3;
            this.udpateValueFromTarget(_loc_4);
            this._items.push(_loc_4);
            this._orderDirty = true;
            return _loc_4;
        }// end function

        private function udpateValueFromTarget(param1:FTransitionItem) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = param1.value;
            if (param1.targetId)
            {
                _loc_3 = this._owner.getChildById(param1.targetId);
            }
            else
            {
                _loc_3 = this._owner;
            }
            switch(param1.type)
            {
                case "XY":
                {
                    _loc_2.f1 = _loc_3.x;
                    _loc_2.f2 = _loc_3.y;
                    _loc_2.f3 = _loc_3.x / _loc_3.width;
                    _loc_2.f4 = _loc_3.y / _loc_3.height;
                    _loc_2.b3 = false;
                    break;
                }
                case "Size":
                {
                    _loc_2.f1 = _loc_3.width;
                    _loc_2.f2 = _loc_3.height;
                    break;
                }
                case "Pivot":
                {
                    _loc_2.f1 = _loc_3.pivotX;
                    _loc_2.f2 = _loc_3.pivotY;
                    break;
                }
                case "Alpha":
                {
                    _loc_2.f1 = _loc_3.alpha;
                    break;
                }
                case "Rotation":
                {
                    _loc_2.f1 = _loc_3.rotation;
                    break;
                }
                case "Scale":
                {
                    _loc_2.f1 = _loc_3.scaleX;
                    _loc_2.f2 = _loc_3.scaleY;
                    break;
                }
                case "Skew":
                {
                    _loc_2.f1 = _loc_3.skewX;
                    _loc_2.f2 = _loc_3.skewY;
                    break;
                }
                case "Color":
                {
                    _loc_2.iu = _loc_3.getProp(ObjectPropID.Color);
                    break;
                }
                case "Animation":
                {
                    _loc_2.i = _loc_3.getProp(ObjectPropID.Frame);
                    _loc_2.b2 = _loc_3.getProp(ObjectPropID.Playing);
                    break;
                }
                case "Sound":
                {
                    _loc_2.s = "";
                    _loc_2.i = 0;
                    break;
                }
                case "Controller":
                {
                    break;
                }
                case "Transition":
                {
                    _loc_2.i = 1;
                    _loc_2.s = "";
                    break;
                }
                case "Shake":
                {
                    _loc_2.f1 = 3;
                    _loc_2.f2 = 0.5;
                    break;
                }
                case "Visible":
                {
                    _loc_2.b1 = _loc_3.visible;
                    break;
                }
                case "ColorFilter":
                {
                    _loc_2.f1 = _loc_3.filterData.brightness;
                    _loc_2.f2 = _loc_3.filterData.contrast;
                    _loc_2.f3 = _loc_3.filterData.saturation;
                    _loc_2.f4 = _loc_3.filterData.hue;
                    break;
                }
                case "Text":
                {
                    _loc_2.s = _loc_3.text;
                    break;
                }
                case "Icon":
                {
                    _loc_2.s = _loc_3.icon;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function findItem(param1:int, param2:String, param3:String) : FTransitionItem
        {
            return this.findItem2(param1, param2, param3, this._items);
        }// end function

        public function findItem2(param1:int, param2:String, param3:String, param4:Vector.<FTransitionItem>) : FTransitionItem
        {
            var _loc_7:* = null;
            var _loc_5:* = param4.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = param4[_loc_6];
                if ((param3 == null || _loc_7.type == param3) && _loc_7.targetId == param2 && _loc_7.frame == param1)
                {
                    return _loc_7;
                }
                _loc_6++;
            }
            return null;
        }// end function

        public function getItemWithPath(param1:int, param2:String) : FTransitionItem
        {
            var _loc_6:* = null;
            var _loc_3:* = this.items;
            var _loc_4:* = _loc_3.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = _loc_3[_loc_5];
                if (_loc_6.usePath && _loc_6.tween && _loc_6.targetId == param2 && param1 >= _loc_6.frame && _loc_6.nextItem && param1 < _loc_6.nextItem.frame)
                {
                    return _loc_6;
                }
                _loc_5++;
            }
            return null;
        }// end function

        public function addItem(param1:FTransitionItem) : void
        {
            this._items.push(param1);
            this._orderDirty = true;
            return;
        }// end function

        public function addItems(param1:Array) : void
        {
            var _loc_2:* = null;
            for each (_loc_2 in param1)
            {
                
                this._items.push(_loc_2);
            }
            this._orderDirty = true;
            return;
        }// end function

        public function deleteItem(param1:FTransitionItem) : void
        {
            var _loc_2:* = this._items.indexOf(param1);
            if (_loc_2 != -1)
            {
                this._items.splice(_loc_2, 1);
                if (param1.target != null && param1.displayLockToken != 0)
                {
                    param1.target.releaseDisplayLock(param1.displayLockToken);
                    param1.displayLockToken = 0;
                }
                this._orderDirty = true;
            }
            return;
        }// end function

        public function deleteItems(param1:String, param2:String) : Array
        {
            var _loc_6:* = null;
            var _loc_3:* = [];
            var _loc_4:* = this._items.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = this._items[_loc_5];
                if (_loc_6.type == param2 && _loc_6.targetId == param1)
                {
                    this._items.splice(_loc_5, 1);
                    _loc_3.push(_loc_6);
                    _loc_4 = _loc_4 - 1;
                    if (_loc_6.target != null && _loc_6.displayLockToken != 0)
                    {
                        _loc_6.target.releaseDisplayLock(_loc_6.displayLockToken);
                        _loc_6.displayLockToken = 0;
                    }
                    continue;
                }
                _loc_5++;
            }
            this._orderDirty = true;
            return _loc_3;
        }// end function

        public function copyItems(param1:String, param2:String) : XData
        {
            var _loc_7:* = null;
            var _loc_3:* = this._items.length;
            var _loc_4:* = new Vector.<FTransitionItem>;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_7 = this._items[_loc_5];
                if (_loc_7.type == param2 && _loc_7.targetId == param1)
                {
                    _loc_4.push(_loc_7);
                }
                _loc_5++;
            }
            var _loc_6:* = XData.create("transition");
            this.writeItems(_loc_4, _loc_6, false);
            return _loc_6;
        }// end function

        public function pasteItems(param1:XData, param2:String, param3:String) : void
        {
            var _loc_7:* = null;
            var _loc_4:* = this._items.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_7 = this._items[_loc_5];
                if (_loc_7.type == param3 && _loc_7.targetId == param2)
                {
                    this._items.splice(_loc_5, 1);
                    _loc_4 = _loc_4 - 1;
                    if (_loc_7.target != null && _loc_7.displayLockToken != 0)
                    {
                        _loc_7.target.releaseDisplayLock(_loc_7.displayLockToken);
                        _loc_7.displayLockToken = 0;
                    }
                    continue;
                }
                _loc_5++;
            }
            var _loc_6:* = param1.getEnumerator("item");
            while (_loc_6.moveNext())
            {
                
                _loc_6.current.setAttribute("target", param2);
                _loc_6.current.setAttribute("type", param3);
            }
            this.readItems(param1);
            this._orderDirty = true;
            return;
        }// end function

        public function updateFromRelations(param1:String, param2:Number, param3:Number) : void
        {
            var _loc_6:* = null;
            var _loc_4:* = this._items.length;
            if (this._items.length == 0)
            {
                return;
            }
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = this._items[_loc_5];
                if (_loc_6.type == "XY" && _loc_6.targetId == param1 && !_loc_6.value.b3)
                {
                    _loc_6.value.f1 = _loc_6.value.f1 + param2;
                    _loc_6.value.f2 = _loc_6.value.f2 + param3;
                }
                _loc_5++;
            }
            return;
        }// end function

        public function validate() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_1:* = this._items.length;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._items[_loc_2];
                if (_loc_3.targetId)
                {
                    _loc_3.target = this._owner.getChildById(_loc_3.targetId);
                }
                else
                {
                    _loc_3.target = this._owner;
                }
                if (_loc_3.target != null && !getAllowType(_loc_3.target, _loc_3.type))
                {
                    _loc_3.target = null;
                }
                if (_loc_3.target != null && _loc_3.type == "Transition")
                {
                    _loc_4 = FComponent(_loc_3.target).transitions.getItem(_loc_3.value.s);
                    if (_loc_4 == this)
                    {
                        _loc_4 = null;
                    }
                    if (_loc_4 != null)
                    {
                        if (_loc_3.value.i == 0)
                        {
                            _loc_5 = _loc_2 - 1;
                            while (_loc_5 >= 0)
                            {
                                
                                _loc_6 = this._items[_loc_5];
                                if (_loc_6.type == "Transition")
                                {
                                    if (_loc_6.innerTrans == _loc_4)
                                    {
                                        _loc_6.value.f1 = _loc_3.frame - _loc_6.frame;
                                        break;
                                    }
                                }
                                _loc_5 = _loc_5 - 1;
                            }
                            if (_loc_5 < 0)
                            {
                                _loc_3.value.f1 = 0;
                            }
                            else
                            {
                                _loc_4 = null;
                            }
                        }
                        else
                        {
                            _loc_3.value.f1 = -1;
                        }
                    }
                    _loc_3.innerTrans = _loc_4;
                }
                _loc_2++;
            }
            return;
        }// end function

        private function readItems(param1:XData) : void
        {
            var _loc_6:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = null;
            var _loc_2:* = new Vector.<FTransitionItem>;
            var _loc_3:* = param1.getEnumerator("item");
            var _loc_4:* = [];
            var _loc_5:* = 0;
            while (_loc_3.moveNext())
            {
                
                _loc_8 = _loc_3.current;
                _loc_9 = new FTransitionItem(this);
                _loc_2.push(_loc_9);
                _loc_10 = {};
                _loc_4[++_loc_5] = _loc_10;
                _loc_10.duration = _loc_8.getAttributeInt("duration");
                _loc_9.frame = _loc_8.getAttributeInt("time");
                _loc_9.type = _loc_8.getAttribute("type");
                _loc_9.targetId = _loc_8.getAttribute("target", "");
                _loc_9.tween = _loc_8.getAttributeBool("tween");
                _loc_9.repeat = _loc_8.getAttributeInt("repeat");
                _loc_9.yoyo = _loc_8.getAttributeBool("yoyo");
                _loc_9.label = _loc_8.getAttribute("label");
                _loc_10.label2 = _loc_8.getAttribute("label2");
                _loc_6 = _loc_8.getAttribute("ease");
                if (_loc_6)
                {
                    _loc_11 = _loc_6.indexOf(".");
                    if (_loc_11 != -1)
                    {
                        _loc_9.easeType = _loc_6.substr(0, _loc_11);
                        _loc_9.easeInOutType = _loc_6.substr((_loc_11 + 1));
                    }
                    else
                    {
                        _loc_9.easeType = _loc_6;
                    }
                }
                _loc_6 = _loc_8.getAttribute("startValue");
                if (_loc_6)
                {
                    _loc_9.value.decode(_loc_9.type, _loc_6);
                }
                else
                {
                    _loc_6 = _loc_8.getAttribute("value");
                    if (_loc_6)
                    {
                        _loc_9.value.decode(_loc_9.type, _loc_6);
                    }
                }
                _loc_6 = _loc_8.getAttribute("endValue");
                if (_loc_6)
                {
                    _loc_10.endValue = new FTransitionValue();
                    _loc_10.endValue.decode(_loc_9.type, _loc_6);
                }
                _loc_6 = _loc_8.getAttribute("path");
                if (_loc_6)
                {
                    _loc_9.pathData = _loc_6;
                }
            }
            var _loc_7:* = _loc_2.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_7)
            {
                
                _loc_9 = _loc_2[_loc_5];
                _loc_10 = _loc_4[_loc_5];
                if (_loc_9.tween && _loc_10.duration > 0)
                {
                    _loc_12 = this.findItem2(_loc_9.frame + _loc_10.duration, _loc_9.targetId, _loc_9.type, _loc_2);
                    if (_loc_12 == null)
                    {
                        _loc_12 = new FTransitionItem(this);
                        _loc_12.frame = _loc_9.frame + _loc_10.duration;
                        _loc_12.type = _loc_9.type;
                        _loc_12.targetId = _loc_9.targetId;
                        _loc_12.value.copyFrom(_loc_10.endValue);
                        _loc_12.tween = false;
                        _loc_12.label = _loc_10.label2;
                        _loc_2.push(_loc_12);
                    }
                    _loc_9.nextItem = _loc_12;
                    _loc_12.prevItem = _loc_9;
                }
                _loc_5++;
            }
            for each (_loc_9 in _loc_2)
            {
                
                this._items.push(_loc_9);
            }
            return;
        }// end function

        public function writeItems(param1:Vector.<FTransitionItem>, param2:XData, param3:Boolean) : void
        {
            var _loc_5:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_4:* = param1.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_4)
            {
                
                _loc_5 = param1[_loc_6];
                if (_loc_5.prevItem && !_loc_5.tween)
                {
                }
                else if (param3 && !_loc_5.target)
                {
                }
                else
                {
                    _loc_7 = XData.create("item");
                    _loc_7.setAttribute("time", _loc_5.frame);
                    _loc_7.setAttribute("type", _loc_5.type);
                    if (_loc_5.targetId)
                    {
                        _loc_7.setAttribute("target", _loc_5.targetId);
                    }
                    if (_loc_5.label)
                    {
                        _loc_7.setAttribute("label", _loc_5.label);
                    }
                    if (_loc_5.tween && _loc_5.nextItem)
                    {
                        _loc_7.setAttribute("tween", _loc_5.tween);
                        _loc_7.setAttribute("startValue", _loc_5.value.encode(_loc_5.type));
                        _loc_7.setAttribute("endValue", _loc_5.nextItem.value.encode(_loc_5.type));
                        _loc_7.setAttribute("duration", _loc_5.nextItem.frame - _loc_5.frame);
                        if (_loc_5.nextItem.label)
                        {
                            _loc_7.setAttribute("label2", _loc_5.nextItem.label);
                        }
                        _loc_8 = _loc_5.easeName;
                        if (_loc_8 != "Quad.Out")
                        {
                            _loc_7.setAttribute("ease", _loc_8);
                        }
                        if (_loc_5.repeat != 0)
                        {
                            _loc_7.setAttribute("repeat", _loc_5.repeat);
                        }
                        if (_loc_5.yoyo)
                        {
                            _loc_7.setAttribute("yoyo", _loc_5.yoyo);
                        }
                        if (_loc_5.usePath)
                        {
                            _loc_7.setAttribute("path", _loc_5.pathData);
                        }
                    }
                    else
                    {
                        _loc_7.setAttribute("value", _loc_5.value.encode(_loc_5.type));
                    }
                    param2.appendChild(_loc_7);
                }
                _loc_6++;
            }
            return;
        }// end function

        public function read(param1:XData) : void
        {
            this._name = param1.getAttribute("name");
            this._options = param1.getAttributeInt("options");
            this._autoPlay = param1.getAttributeBool("autoPlay");
            this._autoPlayRepeat = param1.getAttributeInt("autoPlayRepeat", 1);
            this._autoPlayDelay = param1.getAttributeFloat("autoPlayDelay");
            this._frameRate = param1.getAttributeInt("frameRate", 24);
            this._items.length = 0;
            this._orderDirty = true;
            this.readItems(param1);
            return;
        }// end function

        public function write(param1:Boolean) : XData
        {
            this.validate();
            var _loc_2:* = XData.create("transition");
            _loc_2.setAttribute("name", this._name);
            if (this._options != 0)
            {
                _loc_2.setAttribute("options", this._options);
            }
            if (this._autoPlay)
            {
                _loc_2.setAttribute("autoPlay", this._autoPlay);
            }
            if (this._autoPlayRepeat != 1)
            {
                _loc_2.setAttribute("autoPlayRepeat", this._autoPlayRepeat);
            }
            if (this._autoPlayDelay != 0)
            {
                _loc_2.setAttribute("autoPlayDelay", this._autoPlayDelay.toFixed(3));
            }
            if (this._frameRate != 24)
            {
                _loc_2.setAttribute("frameRate", this._frameRate);
            }
            this.writeItems(this._items, _loc_2, param1);
            return _loc_2;
        }// end function

        public function onExit() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this._items.length;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._items[_loc_2];
                if (_loc_3.target != null && _loc_3.displayLockToken != 0)
                {
                    _loc_3.target.releaseDisplayLock(_loc_3.displayLockToken);
                    _loc_3.displayLockToken = 0;
                }
                _loc_2++;
            }
            return;
        }// end function

        public function get playing() : Boolean
        {
            return this._playing;
        }// end function

        public function set playTimes(param1:int) : void
        {
            if (param1 < 0)
            {
                param1 = int.MAX_VALUE;
            }
            else if (param1 == 0)
            {
                param1 = 1;
            }
            this._totalTimes = param1;
            return;
        }// end function

        public function get playTimes() : int
        {
            return this._totalTimes;
        }// end function

        public function play(param1:Function = null, param2:Object = null, param3:int = 1, param4:Number = 0, param5:int = 0, param6:int = -1, param7:Boolean = false) : void
        {
            if (this._orderDirty)
            {
                this.arrangeItems();
            }
            this.stop();
            this.validate();
            this._editing = param7;
            this._totalTimes = param3;
            this._startFrame = param5;
            this._endFrame = param6;
            this._playing = true;
            this._elapsedFrame = 0;
            this._onComplete = param1;
            this._onCompleteParam = param2;
            if (param4 == 0)
            {
                this.onDelayedPlay();
            }
            else
            {
                GTween.delayedCall(param4).onComplete(this.onDelayedPlay);
            }
            return;
        }// end function

        public function stop(param1:Boolean = true, param2:Boolean = false) : void
        {
            var _loc_7:* = null;
            if (!this._playing)
            {
                return;
            }
            this._playing = false;
            this._totalTasks = 0;
            this._totalTimes = 0;
            var _loc_3:* = this._onComplete;
            var _loc_4:* = this._onCompleteParam;
            this._onComplete = null;
            this._onCompleteParam = null;
            GTween.kill(this);
            var _loc_5:* = this._items.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = this._items[_loc_6];
                if (!_loc_7.target)
                {
                }
                else
                {
                    if (_loc_7.displayLockToken != 0)
                    {
                        _loc_7.target.releaseDisplayLock(_loc_7.displayLockToken);
                        _loc_7.displayLockToken = 0;
                    }
                    if (_loc_7.tweener != null)
                    {
                        _loc_7.tweener.kill(param1);
                        _loc_7.tweener = null;
                        if (_loc_7.type == "Shake" && !param1)
                        {
                            _loc_7.target._gearLocked = true;
                            _loc_7.target.setXY(_loc_7.target.x - _loc_7.tweenValue.f1, _loc_7.target.y - _loc_7.tweenValue.f2);
                            _loc_7.target._gearLocked = false;
                        }
                    }
                    if (_loc_7.innerTrans != null)
                    {
                        _loc_7.innerTrans.stop(param1, false);
                    }
                }
                _loc_6++;
            }
            if (param2 && _loc_3 != null)
            {
                if (_loc_3.length > 0)
                {
                    this._loc_3(_loc_4);
                }
                else
                {
                    this._loc_3();
                }
            }
            return;
        }// end function

        private function onDelayedPlay() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            this.internalPlay();
            this._playing = this._totalTasks > 0;
            if (this._playing)
            {
                _loc_1 = this._items.length;
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    _loc_3 = this._items[_loc_2];
                    if (_loc_3.target != null && _loc_3.target != this._owner)
                    {
                        if (_loc_3.displayLockToken != 0)
                        {
                            _loc_3.target.releaseDisplayLock(_loc_3.displayLockToken);
                            _loc_3.displayLockToken = 0;
                        }
                        if ((this._options & OPTION_IGNORE_DISPLAY_CONTROLLER) != 0)
                        {
                            _loc_3.displayLockToken = _loc_3.target.addDisplayLock();
                        }
                    }
                    _loc_2++;
                }
            }
            else if (this._onComplete != null)
            {
                _loc_4 = this._onComplete;
                _loc_5 = this._onCompleteParam;
                this._onComplete = null;
                this._onCompleteParam = null;
                if (_loc_4.length > 0)
                {
                    this._loc_4(_loc_5);
                }
                else
                {
                    this._loc_4();
                }
            }
            return;
        }// end function

        private function internalPlay() : void
        {
            var _loc_4:* = null;
            var _loc_5:* = NaN;
            this._ownerBaseX = this._owner.x;
            this._ownerBaseY = this._owner.y;
            this._totalTasks = 0;
            this._elapsedFrame = 0;
            var _loc_1:* = false;
            var _loc_2:* = this._items.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._items[_loc_3];
                if (!_loc_4.target)
                {
                }
                else
                {
                    if (_loc_4.type == "Animation" && this._startFrame != 0 && _loc_4.frame <= this._startFrame)
                    {
                        _loc_1 = true;
                        _loc_4.value.b3 = false;
                    }
                    if (this._endFrame == -1 || _loc_4.frame <= this._endFrame)
                    {
                        switch(_loc_4.type)
                        {
                            case "XY":
                            case "Size":
                            case "Scale":
                            case "Skew":
                            {
                                break;
                            }
                            case "Alpha":
                            case "Rotation":
                            {
                                break;
                            }
                            case "Color":
                            {
                                break;
                            }
                            case "ColorFilter":
                            {
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                        if (this._endFrame >= 0)
                        {
                        }
                    }
                    if (_loc_4.type == "Shake")
                    {
                        if ((this._owner._flags & FObjectFlags.IN_TEST) != 0)
                        {
                            if (this._endFrame >= 0)
                            {
                            }
                        }
                    }
                    else if (_loc_4.prevItem == null)
                    {
                        if (_loc_4.frame <= this._startFrame)
                        {
                        }
                        else if (this._endFrame == -1 || _loc_4.frame <= this._endFrame)
                        {
                        }
                    }
                    if (_loc_4.tweener != null)
                    {
                        _loc_4.tweener.seek(this._startFrame / this._frameRate);
                    }
                }
                _loc_3++;
            }
            if (_loc_1)
            {
                this.skipAnimations();
            }
            return;
        }// end function

        private function skipAnimations() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_9:* = 0;
            var _loc_7:* = this._items.length;
            var _loc_8:* = 0;
            while (_loc_8 < _loc_7)
            {
                
                _loc_6 = this._items[_loc_8];
                if (_loc_6.type != "Animation" || _loc_6.frame > this._startFrame)
                {
                }
                else
                {
                    _loc_4 = _loc_6.value;
                    if (_loc_4.b3)
                    {
                    }
                    else
                    {
                        _loc_5 = _loc_6.target;
                        _loc_1 = _loc_5.getProp(ObjectPropID.Frame);
                        _loc_2 = _loc_5.getProp(ObjectPropID.Playing) ? (0) : (-1);
                        _loc_3 = 0;
                        _loc_9 = _loc_8;
                        while (_loc_9 < _loc_7)
                        {
                            
                            _loc_6 = this._items[_loc_9];
                            if (_loc_6.type != "Animation" || _loc_6.target != _loc_5 || _loc_6.frame > this._startFrame)
                            {
                            }
                            else
                            {
                                _loc_4 = _loc_6.value;
                                _loc_4.b3 = true;
                                if (_loc_4.b1)
                                {
                                    _loc_1 = _loc_4.i;
                                    if (_loc_4.b2)
                                    {
                                        _loc_2 = _loc_6.frame;
                                    }
                                    else
                                    {
                                        _loc_2 = -1;
                                    }
                                    _loc_3 = 0;
                                }
                                else if (_loc_4.b2)
                                {
                                    if (_loc_2 < 0)
                                    {
                                        _loc_2 = _loc_6.frame;
                                    }
                                }
                                else
                                {
                                    if (_loc_2 >= 0)
                                    {
                                        _loc_3 = _loc_3 + (_loc_6.frame - _loc_2);
                                    }
                                    _loc_2 = -1;
                                }
                            }
                            _loc_9++;
                        }
                        if (_loc_2 >= 0)
                        {
                            _loc_3 = _loc_3 + (this._startFrame - _loc_2);
                        }
                        _loc_5.setProp(ObjectPropID.Playing, !this._editing && _loc_2 >= 0);
                        _loc_5.setProp(ObjectPropID.Frame, _loc_1);
                        if (_loc_3 > 0)
                        {
                            _loc_5.setProp(ObjectPropID.DeltaTime, _loc_3 / this._frameRate * 1000);
                        }
                    }
                }
                _loc_8++;
            }
            return;
        }// end function

        private function onDelayedPlayItem(param1:GTweener) : void
        {
            var _loc_2:* = FTransitionItem(param1.target);
            _loc_2.tweener = null;
            var _loc_3:* = this;
            var _loc_4:* = this._totalTasks - 1;
            _loc_3._totalTasks = _loc_4;
            this.applyValue(_loc_2, _loc_2.value);
            this.checkAllComplete();
            return;
        }// end function

        private function onTweenStart(param1:GTweener) : void
        {
            var _loc_2:* = FTransitionItem(param1.target);
            this._elapsedFrame = _loc_2.frame;
            if (_loc_2.type == "XY")
            {
                if (_loc_2.target != this._owner)
                {
                    if (!_loc_2.value.b1)
                    {
                        param1.startValue.x = _loc_2.target.x;
                    }
                    else if (_loc_2.value.b3)
                    {
                        param1.startValue.x = _loc_2.value.f3 * this._owner.width;
                    }
                    if (!_loc_2.value.b2)
                    {
                        param1.startValue.y = _loc_2.target.y;
                    }
                    else if (_loc_2.value.b3)
                    {
                        param1.startValue.y = _loc_2.value.f4 * this._owner.height;
                    }
                    if (!_loc_2.nextItem.value.b1)
                    {
                        param1.endValue.x = param1.startValue.x;
                    }
                    else if (_loc_2.nextItem.value.b3)
                    {
                        param1.endValue.x = _loc_2.nextItem.value.f3 * this._owner.width;
                    }
                    if (!_loc_2.nextItem.value.b2)
                    {
                        param1.endValue.y = param1.startValue.y;
                    }
                    else if (_loc_2.nextItem.value.b3)
                    {
                        param1.endValue.y = _loc_2.nextItem.value.f4 * this._owner.height;
                    }
                }
                else
                {
                    if (!_loc_2.value.b1)
                    {
                        param1.startValue.x = _loc_2.target.x - this._ownerBaseX;
                    }
                    if (!_loc_2.value.b2)
                    {
                        param1.startValue.y = _loc_2.target.y - this._ownerBaseY;
                    }
                    if (!_loc_2.nextItem.value.b1)
                    {
                        param1.endValue.x = param1.startValue.x;
                    }
                    if (!_loc_2.nextItem.value.b2)
                    {
                        param1.endValue.y = param1.startValue.y;
                    }
                }
                if (_loc_2.usePath)
                {
                    var _loc_3:* = true;
                    _loc_2.tweenValue.b2 = true;
                    _loc_2.tweenValue.b1 = _loc_3;
                    _loc_2.setPathToTweener();
                }
            }
            else if (_loc_2.type == "Size")
            {
                if (!_loc_2.value.b1)
                {
                    param1.startValue.x = _loc_2.target.width;
                }
                if (!_loc_2.value.b2)
                {
                    param1.startValue.y = _loc_2.target.height;
                }
                if (!_loc_2.nextItem.value.b1)
                {
                    param1.endValue.x = param1.startValue.x;
                }
                if (!_loc_2.nextItem.value.b2)
                {
                    param1.endValue.y = param1.startValue.y;
                }
            }
            return;
        }// end function

        private function onTweenUpdate(param1:GTweener) : void
        {
            var _loc_2:* = FTransitionItem(param1.target);
            switch(_loc_2.type)
            {
                case "XY":
                case "Size":
                case "Scale":
                case "Skew":
                {
                    _loc_2.tweenValue.f1 = param1.value.x;
                    _loc_2.tweenValue.f2 = param1.value.y;
                    if (_loc_2.usePath)
                    {
                        _loc_2.tweenValue.f1 = _loc_2.tweenValue.f1 + _loc_2.pathOffsetX;
                        _loc_2.tweenValue.f2 = _loc_2.tweenValue.f2 + _loc_2.pathOffsetY;
                    }
                    this.applyValue(_loc_2, _loc_2.tweenValue);
                    break;
                }
                case "Alpha":
                case "Rotation":
                {
                    _loc_2.tweenValue.f1 = param1.value.x;
                    this.applyValue(_loc_2, _loc_2.tweenValue);
                    break;
                }
                case "Color":
                {
                    _loc_2.tweenValue.iu = param1.value.color;
                    this.applyValue(_loc_2, _loc_2.tweenValue);
                    break;
                }
                case "ColorFilter":
                {
                    _loc_2.tweenValue.f1 = param1.value.x;
                    _loc_2.tweenValue.f2 = param1.value.y;
                    _loc_2.tweenValue.f3 = param1.value.z;
                    _loc_2.tweenValue.f4 = param1.value.w;
                    this.applyValue(_loc_2, _loc_2.tweenValue);
                    break;
                }
                case "Shake":
                {
                    _loc_2.target._gearLocked = true;
                    _loc_2.target.setXY(_loc_2.target.x - _loc_2.tweenValue.f3 + param1.deltaValue.x, _loc_2.target.y - _loc_2.tweenValue.f4 + param1.deltaValue.y);
                    _loc_2.target._gearLocked = false;
                    _loc_2.tweenValue.f3 = param1.deltaValue.x;
                    _loc_2.tweenValue.f4 = param1.deltaValue.y;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onTweenComplete(param1:GTweener) : void
        {
            var _loc_2:* = FTransitionItem(param1.target);
            _loc_2.tweener = null;
            var _loc_3:* = this;
            var _loc_4:* = this._totalTasks - 1;
            _loc_3._totalTasks = _loc_4;
            this.checkAllComplete();
            return;
        }// end function

        private function onPlayTransComplete(param1:FTransitionItem) : void
        {
            var _loc_2:* = this;
            var _loc_3:* = this._totalTasks - 1;
            _loc_2._totalTasks = _loc_3;
            this.checkAllComplete();
            return;
        }// end function

        private function checkAllComplete() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (this._playing && this._totalTasks == 0)
            {
                if (this._totalTimes < 0)
                {
                    this.internalPlay();
                }
                else
                {
                    var _loc_6:* = this;
                    var _loc_7:* = this._totalTimes - 1;
                    _loc_6._totalTimes = _loc_7;
                    if (this._totalTimes > 0)
                    {
                        this.internalPlay();
                    }
                    else
                    {
                        this._playing = false;
                        if ((this._owner._flags & FObjectFlags.ROOT) == 0)
                        {
                            _loc_1 = this._items.length;
                            _loc_2 = 0;
                            while (_loc_2 < _loc_1)
                            {
                                
                                _loc_3 = this._items[_loc_2];
                                if (_loc_3.target != null && _loc_3.displayLockToken != 0)
                                {
                                    _loc_3.target.releaseDisplayLock(_loc_3.displayLockToken);
                                    _loc_3.displayLockToken = 0;
                                }
                                _loc_2++;
                            }
                        }
                        if (this._onComplete != null)
                        {
                            _loc_4 = this._onComplete;
                            _loc_5 = this._onCompleteParam;
                            this._onComplete = null;
                            this._onCompleteParam = null;
                            if (_loc_4.length > 0)
                            {
                                this._loc_4(_loc_5);
                            }
                            else
                            {
                                this._loc_4();
                            }
                        }
                    }
                }
            }
            return;
        }// end function

        private function applyValue(param1:FTransitionItem, param2:FTransitionValue) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            param1.target._gearLocked = true;
            switch(param1.type)
            {
                case "XY":
                {
                    if (param1.target == this._owner)
                    {
                        if (param2.b1 && param2.b2)
                        {
                            param1.target.setXY(param2.f1 + this._ownerBaseX, param2.f2 + this._ownerBaseY);
                        }
                        else if (param2.b1)
                        {
                            param1.target.x = param2.f1 + this._ownerBaseX;
                        }
                        else if (param2.b2)
                        {
                            param1.target.y = param2.f2 + this._ownerBaseY;
                        }
                    }
                    else if (param2.b3)
                    {
                        if (param2.b1 && param2.b2)
                        {
                            param1.target.setXY(param2.f3 * this._owner.width, param2.f4 * this._owner.height);
                        }
                        else if (param2.b1)
                        {
                            param1.target.x = param2.f3 * this._owner.width;
                        }
                        else if (param2.b2)
                        {
                            param1.target.y = param2.f4 * this._owner.height;
                        }
                    }
                    else if (param2.b1 && param2.b2)
                    {
                        param1.target.setXY(param2.f1, param2.f2);
                    }
                    else if (param2.b1)
                    {
                        param1.target.x = param2.f1;
                    }
                    else if (param2.b2)
                    {
                        param1.target.y = param2.f2;
                    }
                    break;
                }
                case "Size":
                {
                    if (!param2.b1)
                    {
                        param2.f1 = param1.target.width;
                    }
                    if (!param2.b2)
                    {
                        param2.f2 = param1.target.height;
                    }
                    param1.target.setSize(param2.f1, param2.f2);
                    break;
                }
                case "Pivot":
                {
                    param1.target.setPivot(param2.f1, param2.f2, param1.target.anchor);
                    break;
                }
                case "Alpha":
                {
                    param1.target.alpha = param2.f1;
                    break;
                }
                case "Rotation":
                {
                    param1.target.rotation = param2.f1;
                    break;
                }
                case "Scale":
                {
                    param1.target.setScale(param2.f1, param2.f2);
                    break;
                }
                case "Skew":
                {
                    param1.target.setSkew(param2.f1, param2.f2);
                    break;
                }
                case "Color":
                {
                    param1.target.setProp(ObjectPropID.Color, param2.iu);
                    break;
                }
                case "Animation":
                {
                    if (param2.b1)
                    {
                        param1.target.setProp(ObjectPropID.Frame, param2.i);
                    }
                    param1.target.setProp(ObjectPropID.Playing, !this._editing && param2.b2);
                    break;
                }
                case "Visible":
                {
                    param1.target.visible = param2.b1;
                    break;
                }
                case "Transition":
                {
                    if (this._playing)
                    {
                        if (param1.innerTrans != null)
                        {
                            var _loc_5:* = this;
                            var _loc_6:* = this._totalTasks + 1;
                            _loc_5._totalTasks = _loc_6;
                            _loc_3 = this._startFrame > param1.frame ? (this._startFrame - param1.frame) : (0);
                            _loc_4 = this._endFrame >= 0 ? (this._endFrame - param1.frame) : (-1);
                            if (param1.value.f1 >= 0 && (_loc_4 < 0 || _loc_4 > param1.value.f1))
                            {
                                _loc_4 = param1.value.f1;
                            }
                            param1.innerTrans.play(this.onPlayTransComplete, param1, param2.i, 0, _loc_3, _loc_4, this._editing);
                        }
                    }
                    break;
                }
                case "Sound":
                {
                    if (this._playing && param1.frame >= this._startFrame && (this._owner._flags & FObjectFlags.IN_TEST) != 0)
                    {
                        this._owner._pkg.project.playSound(param2.s, param2.i / 100);
                    }
                    break;
                }
                case "ColorFilter":
                {
                    param1.target.filterData.type = "color";
                    param1.target.filterData.brightness = param2.f1;
                    param1.target.filterData.contrast = param2.f2;
                    param1.target.filterData.saturation = param2.f3;
                    param1.target.filterData.hue = param2.f4;
                    param1.target.displayObject.applyFilter();
                    break;
                }
                case "Text":
                {
                    param1.target.text = param2.s;
                    break;
                }
                case "Icon":
                {
                    param1.target.icon = param2.s;
                    break;
                }
                default:
                {
                    break;
                }
            }
            param1.target._gearLocked = false;
            return;
        }// end function

        public static function getAllowType(param1:FObject, param2:String) : Boolean
        {
            var _loc_3:* = param1 is FGroup;
            var _loc_4:* = _loc_3 && !FGroup(param1).advanced;
            switch(param2)
            {
                case "XY":
                case "Alpha":
                case "Visible":
                {
                    return !_loc_4;
                }
                case "Color":
                {
                    return !_loc_3;
                }
                case "Animation":
                {
                    return param1 is FMovieClip || param1 is FSwfObject;
                }
                case "Transition":
                {
                    return param1 is FComponent && !(param1 is FList);
                }
                default:
                {
                    return !_loc_3;
                    break;
                }
            }
        }// end function

        public static function supportTween(param1:String) : Boolean
        {
            return param1 == "XY" || param1 == "Size" || param1 == "Scale" || param1 == "Skew" || param1 == "Alpha" || param1 == "Rotation" || param1 == "Color" || param1 == "ColorFilter";
        }// end function

    }
}
