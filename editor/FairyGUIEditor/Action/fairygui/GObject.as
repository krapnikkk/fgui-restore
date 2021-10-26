package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.event.*;
    import fairygui.gears.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;

    public class GObject extends EventDispatcher
    {
        public var packageItem:PackageItem;
        public var sourceWidth:Number;
        public var sourceHeight:Number;
        public var initWidth:Number;
        public var initHeight:Number;
        public var minWidth:Number;
        public var minHeight:Number;
        public var maxWidth:Number;
        public var maxHeight:Number;
        private var _x:Number;
        private var _y:Number;
        private var _alpha:Number;
        private var _rotation:Number;
        private var _visible:Boolean;
        private var _touchable:Boolean;
        private var _grayed:Boolean;
        private var _draggable:Boolean;
        private var _pivotX:Number;
        private var _pivotY:Number;
        protected var _scaleX:Number;
        protected var _scaleY:Number;
        protected var _yOffset:int;
        protected var _displayObject:DisplayObject;
        protected var _disposed:Boolean;
        private var _pivotAsAnchor:Boolean;
        private var _pivotOffsetX:Number;
        private var _pivotOffsetY:Number;
        private var _sortingOrder:int;
        private var _internalVisible:Boolean;
        private var _handlingController:Boolean;
        private var _focusable:Boolean;
        private var _tooltips:String;
        private var _pixelSnapping:Boolean;
        private var _data:Object;
        private var _relations:Relations;
        private var _group:GGroup;
        private var _gears:Vector.<GearBase>;
        private var _dragBounds:Rectangle;
        var _parent:GComponent;
        var _dispatcher:SimpleDispatcher;
        var _width:Number;
        var _height:Number;
        var _rawWidth:Number;
        var _rawHeight:Number;
        var _id:String;
        var _name:String;
        var _underConstruct:Boolean;
        var _sizePercentInGroup:Number;
        var _treeNode:GTreeNode;
        public var _gearLocked:Boolean;
        private var _touchPointId:int;
        private var _lastClick:int;
        private var _buttonStatus:int;
        private var _touchDownPoint:Point;
        public static var draggingObject:GObject;
        static var _gInstanceCounter:uint;
        static const XY_CHANGED:int = 1;
        static const SIZE_CHANGED:int = 2;
        static const SIZE_DELAY_CHANGE:int = 3;
        static const MAX_GEAR_INDEX:int = 9;
        private static const MTOUCH_EVENTS:Array = ["beginGTouch", "dragGTouch", "endGTouch", "clickGTouch"];
        private static var sGlobalDragStart:Point = new Point();
        private static var sGlobalRect:Rectangle = new Rectangle();
        private static var sHelperPoint:Point = new Point();
        private static var sDragHelperRect:Rectangle = new Rectangle();
        private static var sUpdateInDragging:Boolean;

        public function GObject()
        {
            _x = 0;
            _y = 0;
            _width = 0;
            _height = 0;
            _rawWidth = 0;
            _rawHeight = 0;
            sourceWidth = 0;
            sourceHeight = 0;
            initWidth = 0;
            initHeight = 0;
            minWidth = 0;
            minHeight = 0;
            maxWidth = 0;
            maxHeight = 0;
            (_gInstanceCounter + 1);
            _id = "_n" + _gInstanceCounter;
            _name = "";
            _alpha = 1;
            _rotation = 0;
            _visible = true;
            _internalVisible = true;
            _touchable = true;
            _scaleX = 1;
            _scaleY = 1;
            _pivotX = 0;
            _pivotY = 0;
            _pivotOffsetX = 0;
            _pivotOffsetY = 0;
            createDisplayObject();
            _relations = new Relations(this);
            _dispatcher = new SimpleDispatcher();
            _gears = new Vector.<GearBase>((9 + 1), true);
            return;
        }// end function

        final public function get id() : String
        {
            return _id;
        }// end function

        final public function get name() : String
        {
            return _name;
        }// end function

        final public function set name(param1:String) : void
        {
            _name = param1;
            return;
        }// end function

        final public function set data(param1:Object) : void
        {
            this._data = param1;
            return;
        }// end function

        final public function get data() : Object
        {
            return this._data;
        }// end function

        final public function get x() : Number
        {
            return _x;
        }// end function

        final public function set x(param1:Number) : void
        {
            setXY(param1, _y);
            return;
        }// end function

        final public function get y() : Number
        {
            return _y;
        }// end function

        final public function set y(param1:Number) : void
        {
            setXY(_x, param1);
            return;
        }// end function

        final public function setXY(param1:Number, param2:Number) : void
        {
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            if (_x != param1 || _y != param2)
            {
                _loc_3 = param1 - _x;
                _loc_4 = param2 - _y;
                _x = param1;
                _y = param2;
                handlePositionChanged();
                if (this is GGroup)
                {
                    this.GGroup(this).moveChildren(_loc_3, _loc_4);
                }
                updateGear(1);
                if (parent != null && !(parent is GList))
                {
                    _parent.setBoundsChangedFlag();
                    if (_group != null)
                    {
                        _group.setBoundsChangedFlag(true);
                    }
                    _dispatcher.dispatch(this, 1);
                }
                if (draggingObject == this && !sUpdateInDragging)
                {
                    this.localToGlobalRect(0, 0, this.width, this.height, sGlobalRect);
                }
            }
            return;
        }// end function

        final public function get xMin() : Number
        {
            return _pivotAsAnchor ? (_x - _width * _pivotX) : (_x);
        }// end function

        final public function set xMin(param1:Number) : void
        {
            if (_pivotAsAnchor)
            {
                setXY(param1 + _width * _pivotX, _y);
            }
            else
            {
                setXY(param1, _y);
            }
            return;
        }// end function

        final public function get yMin() : Number
        {
            return _pivotAsAnchor ? (_y - _height * _pivotY) : (_y);
        }// end function

        final public function set yMin(param1:Number) : void
        {
            if (_pivotAsAnchor)
            {
                setXY(_x, param1 + _height * _pivotY);
            }
            else
            {
                setXY(_x, param1);
            }
            return;
        }// end function

        public function get pixelSnapping() : Boolean
        {
            return _pixelSnapping;
        }// end function

        public function set pixelSnapping(param1:Boolean) : void
        {
            if (_pixelSnapping != param1)
            {
                _pixelSnapping = param1;
                handlePositionChanged();
            }
            return;
        }// end function

        public function center(param1:Boolean = false) : void
        {
            var _loc_2:* = null;
            if (parent != null)
            {
                _loc_2 = parent;
            }
            else
            {
                _loc_2 = this.root;
            }
            this.setXY((_loc_2.width - this.width) / 2, (_loc_2.height - this.height) / 2);
            if (param1)
            {
                this.addRelation(_loc_2, 3);
                this.addRelation(_loc_2, 10);
            }
            return;
        }// end function

        final public function get width() : Number
        {
            if (!this._underConstruct)
            {
                ensureSizeCorrect();
                if (_relations.sizeDirty)
                {
                    _relations.ensureRelationsSizeCorrect();
                }
            }
            return _width;
        }// end function

        final public function set width(param1:Number) : void
        {
            setSize(param1, _rawHeight);
            return;
        }// end function

        final public function get height() : Number
        {
            if (!this._underConstruct)
            {
                ensureSizeCorrect();
                if (_relations.sizeDirty)
                {
                    _relations.ensureRelationsSizeCorrect();
                }
            }
            return _height;
        }// end function

        final public function set height(param1:Number) : void
        {
            setSize(_rawWidth, param1);
            return;
        }// end function

        public function setSize(param1:Number, param2:Number, param3:Boolean = false) : void
        {
            var _loc_5:* = NaN;
            var _loc_4:* = NaN;
            if (_rawWidth != param1 || _rawHeight != param2)
            {
                _rawWidth = param1;
                _rawHeight = param2;
                if (param1 < minWidth)
                {
                    param1 = minWidth;
                }
                if (param2 < minHeight)
                {
                    param2 = minHeight;
                }
                if (maxWidth > 0 && param1 > maxWidth)
                {
                    param1 = maxWidth;
                }
                if (maxHeight > 0 && param2 > maxHeight)
                {
                    param2 = maxHeight;
                }
                _loc_5 = param1 - _width;
                _loc_4 = param2 - _height;
                _width = param1;
                _height = param2;
                handleSizeChanged();
                if (_pivotX != 0 || _pivotY != 0)
                {
                    if (!_pivotAsAnchor)
                    {
                        if (!param3)
                        {
                            this.setXY(this.x - _pivotX * _loc_5, this.y - _pivotY * _loc_4);
                        }
                        updatePivotOffset();
                    }
                    else
                    {
                        applyPivot();
                    }
                }
                if (this is GGroup)
                {
                    this.GGroup(this).resizeChildren(_loc_5, _loc_4);
                }
                updateGear(2);
                if (_parent)
                {
                    _parent.setBoundsChangedFlag();
                    _relations.onOwnerSizeChanged(_loc_5, _loc_4, _pivotAsAnchor || !param3);
                    if (_group != null)
                    {
                        _group.setBoundsChangedFlag();
                    }
                }
                _dispatcher.dispatch(this, 2);
            }
            return;
        }// end function

        public function ensureSizeCorrect() : void
        {
            return;
        }// end function

        final public function get actualWidth() : Number
        {
            return this.width * _scaleX;
        }// end function

        final public function get actualHeight() : Number
        {
            return this.height * _scaleY;
        }// end function

        final public function get scaleX() : Number
        {
            return _scaleX;
        }// end function

        final public function set scaleX(param1:Number) : void
        {
            setScale(param1, _scaleY);
            return;
        }// end function

        final public function get scaleY() : Number
        {
            return _scaleY;
        }// end function

        final public function set scaleY(param1:Number) : void
        {
            setScale(_scaleX, param1);
            return;
        }// end function

        final public function setScale(param1:Number, param2:Number) : void
        {
            if (_scaleX != param1 || _scaleY != param2)
            {
                _scaleX = param1;
                _scaleY = param2;
                handleScaleChanged();
                applyPivot();
                updateGear(2);
            }
            return;
        }// end function

        final public function get pivotX() : Number
        {
            return _pivotX;
        }// end function

        final public function set pivotX(param1:Number) : void
        {
            setPivot(param1, _pivotY);
            return;
        }// end function

        final public function get pivotY() : Number
        {
            return _pivotY;
        }// end function

        final public function set pivotY(param1:Number) : void
        {
            setPivot(_pivotX, param1);
            return;
        }// end function

        final public function setPivot(param1:Number, param2:Number, param3:Boolean = false) : void
        {
            if (_pivotX != param1 || _pivotY != param2 || _pivotAsAnchor != param3)
            {
                _pivotX = param1;
                _pivotY = param2;
                _pivotAsAnchor = param3;
                updatePivotOffset();
                handlePositionChanged();
            }
            return;
        }// end function

        final public function get pivotAsAnchor() : Boolean
        {
            return _pivotAsAnchor;
        }// end function

        protected function internalSetPivot(param1:Number, param2:Number, param3:Boolean) : void
        {
            _pivotX = param1;
            _pivotY = param2;
            _pivotAsAnchor = param3;
            if (_pivotAsAnchor)
            {
                handlePositionChanged();
            }
            return;
        }// end function

        private function updatePivotOffset() : void
        {
            var _loc_5:* = NaN;
            var _loc_10:* = NaN;
            var _loc_6:* = NaN;
            var _loc_8:* = NaN;
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_7:* = NaN;
            var _loc_9:* = NaN;
            if (_pivotX != 0 || _pivotY != 0)
            {
                _loc_5 = this.normalizeRotation;
                if (_loc_5 != 0 || _scaleX != 1 || _scaleY != 1)
                {
                    _loc_10 = _loc_5 * 0.0174533;
                    _loc_6 = Math.cos(_loc_10);
                    _loc_8 = Math.sin(_loc_10);
                    _loc_1 = _scaleX * _loc_6;
                    _loc_2 = _scaleX * _loc_8;
                    _loc_3 = _scaleY * (-_loc_8);
                    _loc_4 = _scaleY * _loc_6;
                    _loc_7 = _pivotX * _width;
                    _loc_9 = _pivotY * _height;
                    _pivotOffsetX = _loc_7 - (_loc_1 * _loc_7 + _loc_3 * _loc_9);
                    _pivotOffsetY = _loc_9 - (_loc_4 * _loc_9 + _loc_2 * _loc_7);
                }
                else
                {
                    _pivotOffsetX = 0;
                    _pivotOffsetY = 0;
                }
            }
            else
            {
                _pivotOffsetX = 0;
                _pivotOffsetY = 0;
            }
            return;
        }// end function

        private function applyPivot() : void
        {
            if (_pivotX != 0 || _pivotY != 0)
            {
                updatePivotOffset();
                handlePositionChanged();
            }
            return;
        }// end function

        final public function get touchable() : Boolean
        {
            return _touchable;
        }// end function

        public function set touchable(param1:Boolean) : void
        {
            if (_touchable != param1)
            {
                _touchable = param1;
                updateGear(3);
                if (this is GImage || this is GMovieClip || this is GTextField && !(this is GTextInput) && !(this is GRichTextField))
                {
                    return;
                }
                if (_displayObject is InteractiveObject)
                {
                    if (this is GComponent)
                    {
                        this.GComponent(this).handleTouchable(_touchable);
                    }
                    else
                    {
                        this.InteractiveObject(_displayObject).mouseEnabled = _touchable;
                        if (_displayObject is DisplayObjectContainer)
                        {
                            this.DisplayObjectContainer(_displayObject).mouseChildren = _touchable;
                        }
                    }
                }
            }
            return;
        }// end function

        final public function get grayed() : Boolean
        {
            return _grayed;
        }// end function

        public function set grayed(param1:Boolean) : void
        {
            if (_grayed != param1)
            {
                _grayed = param1;
                handleGrayedChanged();
                updateGear(3);
            }
            return;
        }// end function

        final public function get enabled() : Boolean
        {
            return !_grayed && _touchable;
        }// end function

        public function set enabled(param1:Boolean) : void
        {
            this.grayed = !param1;
            this.touchable = param1;
            return;
        }// end function

        final public function get rotation() : Number
        {
            return _rotation;
        }// end function

        public function set rotation(param1:Number) : void
        {
            if (_rotation != param1)
            {
                _rotation = param1;
                if (_displayObject)
                {
                    _displayObject.rotation = this.normalizeRotation;
                }
                applyPivot();
                updateGear(3);
            }
            return;
        }// end function

        public function get normalizeRotation() : Number
        {
            var _loc_1:* = _rotation % 360;
            if (_loc_1 > 180)
            {
                _loc_1 = _loc_1 - 360;
            }
            else if (_loc_1 < -180)
            {
                _loc_1 = 360 + _loc_1;
            }
            return _loc_1;
        }// end function

        final public function get alpha() : Number
        {
            return _alpha;
        }// end function

        public function set alpha(param1:Number) : void
        {
            if (_alpha != param1)
            {
                _alpha = param1;
                handleAlphaChanged();
                updateGear(3);
            }
            return;
        }// end function

        final public function get visible() : Boolean
        {
            return _visible;
        }// end function

        public function set visible(param1:Boolean) : void
        {
            if (_visible != param1)
            {
                _visible = param1;
                handleVisibleChanged();
                if (_parent)
                {
                    _parent.setBoundsChangedFlag();
                }
                if (_group && _group.excludeInvisibles)
                {
                    _group.setBoundsChangedFlag();
                }
            }
            return;
        }// end function

        function get internalVisible() : Boolean
        {
            return _internalVisible && (!_group || _group.internalVisible);
        }// end function

        function get internalVisible2() : Boolean
        {
            return _visible && (!_group || _group.internalVisible2);
        }// end function

        function get internalVisible3() : Boolean
        {
            return _internalVisible && _visible;
        }// end function

        final public function get sortingOrder() : int
        {
            return _sortingOrder;
        }// end function

        public function set sortingOrder(param1:int) : void
        {
            var _loc_2:* = 0;
            if (param1 < 0)
            {
                param1 = 0;
            }
            if (_sortingOrder != param1)
            {
                _loc_2 = _sortingOrder;
                _sortingOrder = param1;
                if (_parent != null)
                {
                    _parent.childSortingOrderChanged(this, _loc_2, _sortingOrder);
                }
            }
            return;
        }// end function

        final public function get focusable() : Boolean
        {
            return _focusable;
        }// end function

        public function set focusable(param1:Boolean) : void
        {
            _focusable = param1;
            return;
        }// end function

        public function get focused() : Boolean
        {
            return this.root.focus == this;
        }// end function

        public function requestFocus() : void
        {
            var _loc_1:* = this;
            while (_loc_1 && !_loc_1._focusable)
            {
                
                _loc_1 = _loc_1.parent;
            }
            if (_loc_1 != null)
            {
                this.root.focus = _loc_1;
            }
            return;
        }// end function

        final public function get tooltips() : String
        {
            return _tooltips;
        }// end function

        public function set tooltips(param1:String) : void
        {
            if (_tooltips && Mouse.supportsCursor)
            {
                this.removeEventListener("rollOver", __rollOver);
                this.removeEventListener("rollOut", __rollOut);
            }
            _tooltips = param1;
            if (_tooltips && Mouse.supportsCursor)
            {
                this.addEventListener("rollOver", __rollOver);
                this.addEventListener("rollOut", __rollOut);
            }
            return;
        }// end function

        private function __rollOver(event:Event) : void
        {
            GTimers.inst.callDelay(100, __doShowTooltips);
            return;
        }// end function

        private function __doShowTooltips() : void
        {
            var _loc_1:* = this.root;
            if (_loc_1)
            {
                _loc_1.showTooltips(_tooltips);
            }
            return;
        }// end function

        private function __rollOut(event:Event) : void
        {
            GTimers.inst.remove(__doShowTooltips);
            this.root.hideTooltips();
            return;
        }// end function

        public function get blendMode() : String
        {
            return _displayObject.blendMode;
        }// end function

        public function set blendMode(param1:String) : void
        {
            _displayObject.blendMode = param1;
            return;
        }// end function

        public function get filters() : Array
        {
            return _displayObject.filters;
        }// end function

        public function set filters(param1:Array) : void
        {
            _displayObject.filters = param1;
            return;
        }// end function

        final public function get inContainer() : Boolean
        {
            return _displayObject != null && _displayObject.parent != null;
        }// end function

        final public function get onStage() : Boolean
        {
            return _displayObject != null && _displayObject.stage != null;
        }// end function

        final public function get resourceURL() : String
        {
            if (packageItem != null)
            {
                return "ui://" + packageItem.owner.id + packageItem.id;
            }
            return null;
        }// end function

        final public function set group(param1:GGroup) : void
        {
            if (_group != param1)
            {
                if (_group != null)
                {
                    _group.setBoundsChangedFlag();
                }
                _group = param1;
                if (_group != null)
                {
                    _group.setBoundsChangedFlag();
                }
                handleVisibleChanged();
                if (_parent != null)
                {
                    _parent.childStateChanged(this);
                }
            }
            return;
        }// end function

        final public function get group() : GGroup
        {
            return _group;
        }// end function

        public function getGear(param1:int) : GearBase
        {
            var _loc_2:* = _gears[param1];
            if (_loc_2 == null)
            {
                _loc_2 = GearBase.create(this, param1);
                _gears[param1] = GearBase.create(this, param1);
            }
            return _loc_2;
        }// end function

        protected function updateGear(param1:int) : void
        {
            if (_underConstruct || _gearLocked)
            {
                return;
            }
            var _loc_2:* = _gears[param1];
            if (_loc_2 != null && _loc_2.controller != null)
            {
                _loc_2.updateState();
            }
            return;
        }// end function

        public function checkGearController(param1:int, param2:Controller) : Boolean
        {
            return _gears[param1] != null && _gears[param1].controller == param2;
        }// end function

        public function updateGearFromRelations(param1:int, param2:Number, param3:Number) : void
        {
            if (_gears[param1] != null)
            {
                _gears[param1].updateFromRelations(param2, param3);
            }
            return;
        }// end function

        public function addDisplayLock() : uint
        {
            var _loc_1:* = 0;
            var _loc_2:* = this.GearDisplay(_gears[0]);
            if (_loc_2 && _loc_2.controller)
            {
                _loc_1 = _loc_2.addLock();
                checkGearDisplay();
                return _loc_1;
            }
            return 0;
        }// end function

        public function releaseDisplayLock(param1:uint) : void
        {
            var _loc_2:* = this.GearDisplay(_gears[0]);
            if (_loc_2 && _loc_2.controller)
            {
                _loc_2.releaseLock(param1);
                checkGearDisplay();
            }
            return;
        }// end function

        private function checkGearDisplay() : void
        {
            if (_handlingController)
            {
                return;
            }
            var _loc_1:* = _gears[0] == null || this.GearDisplay(_gears[0]).connected;
            if (_gears[8] != null)
            {
                _loc_1 = this.GearDisplay2(_gears[8]).evaluate(_loc_1);
            }
            if (_loc_1 != _internalVisible)
            {
                _internalVisible = _loc_1;
                if (_parent)
                {
                    _parent.childStateChanged(this);
                    if (_group && _group.excludeInvisibles)
                    {
                        _group.setBoundsChangedFlag();
                    }
                }
            }
            return;
        }// end function

        final public function get gearDisplay() : GearDisplay
        {
            return this.GearDisplay(getGear(0));
        }// end function

        final public function get gearXY() : GearXY
        {
            return this.GearXY(getGear(1));
        }// end function

        final public function get gearSize() : GearSize
        {
            return this.GearSize(getGear(2));
        }// end function

        final public function get gearLook() : GearLook
        {
            return this.GearLook(getGear(3));
        }// end function

        final public function get relations() : Relations
        {
            return _relations;
        }// end function

        final public function addRelation(param1:GObject, param2:int, param3:Boolean = false) : void
        {
            _relations.add(param1, param2, param3);
            return;
        }// end function

        final public function removeRelation(param1:GObject, param2:int) : void
        {
            _relations.remove(param1, param2);
            return;
        }// end function

        final public function get displayObject() : DisplayObject
        {
            return _displayObject;
        }// end function

        final protected function setDisplayObject(param1:DisplayObject) : void
        {
            _displayObject = param1;
            return;
        }// end function

        final public function get parent() : GComponent
        {
            return _parent;
        }// end function

        final public function set parent(param1:GComponent) : void
        {
            _parent = param1;
            return;
        }// end function

        final public function removeFromParent() : void
        {
            if (_parent)
            {
                _parent.removeChild(this);
            }
            return;
        }// end function

        public function get root() : GRoot
        {
            if (this is GRoot)
            {
                return this.GRoot(this);
            }
            var _loc_1:* = _parent;
            while (_loc_1)
            {
                
                if (_loc_1 is GRoot)
                {
                    return this.GRoot(_loc_1);
                }
                _loc_1 = _loc_1.parent;
            }
            return GRoot.inst;
        }// end function

        final public function get asCom() : GComponent
        {
            return this as GComponent;
        }// end function

        final public function get asButton() : GButton
        {
            return this as GButton;
        }// end function

        final public function get asLabel() : GLabel
        {
            return this as GLabel;
        }// end function

        final public function get asProgress() : GProgressBar
        {
            return this as GProgressBar;
        }// end function

        final public function get asTextField() : GTextField
        {
            return this as GTextField;
        }// end function

        final public function get asRichTextField() : GRichTextField
        {
            return this as GRichTextField;
        }// end function

        final public function get asTextInput() : GTextInput
        {
            return this as GTextInput;
        }// end function

        final public function get asLoader() : GLoader
        {
            return this as GLoader;
        }// end function

        final public function get asList() : GList
        {
            return this as GList;
        }// end function

        final public function get asTree() : GTree
        {
            return this as GTree;
        }// end function

        final public function get asGraph() : GGraph
        {
            return this as GGraph;
        }// end function

        final public function get asGroup() : GGroup
        {
            return this as GGroup;
        }// end function

        final public function get asSlider() : GSlider
        {
            return this as GSlider;
        }// end function

        final public function get asComboBox() : GComboBox
        {
            return this as GComboBox;
        }// end function

        final public function get asImage() : GImage
        {
            return this as GImage;
        }// end function

        final public function get asMovieClip() : GMovieClip
        {
            return this as GMovieClip;
        }// end function

        public function get text() : String
        {
            return null;
        }// end function

        public function set text(param1:String) : void
        {
            return;
        }// end function

        public function get icon() : String
        {
            return null;
        }// end function

        public function set icon(param1:String) : void
        {
            return;
        }// end function

        final public function get treeNode() : GTreeNode
        {
            return _treeNode;
        }// end function

        public function get isDisposed() : Boolean
        {
            return _disposed;
        }// end function

        public function dispose() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            if (_disposed)
            {
                return;
            }
            _disposed = true;
            removeFromParent();
            _relations.dispose();
            _loc_1 = 0;
            while (_loc_1 <= 9)
            {
                
                _loc_2 = _gears[_loc_1];
                if (_loc_2 != null)
                {
                    _loc_2.dispose();
                }
                _loc_1++;
            }
            _group = null;
            return;
        }// end function

        public function addClickListener(param1:Function) : void
        {
            addEventListener("clickGTouch", param1);
            return;
        }// end function

        public function removeClickListener(param1:Function) : void
        {
            removeEventListener("clickGTouch", param1);
            return;
        }// end function

        public function hasClickListener() : Boolean
        {
            return hasEventListener("clickGTouch");
        }// end function

        public function addXYChangeCallback(param1:Function) : void
        {
            _dispatcher.addListener(1, param1);
            return;
        }// end function

        public function addSizeChangeCallback(param1:Function) : void
        {
            _dispatcher.addListener(2, param1);
            return;
        }// end function

        function addSizeDelayChangeCallback(param1:Function) : void
        {
            _dispatcher.addListener(3, param1);
            return;
        }// end function

        public function removeXYChangeCallback(param1:Function) : void
        {
            _dispatcher.removeListener(1, param1);
            return;
        }// end function

        public function removeSizeChangeCallback(param1:Function) : void
        {
            _dispatcher.removeListener(2, param1);
            return;
        }// end function

        function removeSizeDelayChangeCallback(param1:Function) : void
        {
            _dispatcher.removeListener(3, param1);
            return;
        }// end function

        override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
        {
            super.addEventListener(param1, param2, false, param4, param5);
            if (_displayObject != null)
            {
                if (MTOUCH_EVENTS.indexOf(param1) != -1)
                {
                    initMTouch();
                }
                else
                {
                    _displayObject.addEventListener(param1, _reDispatch, param3, param4, param5);
                }
            }
            return;
        }// end function

        override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
        {
            super.removeEventListener(param1, param2, false);
            if (_displayObject != null && !this.hasEventListener(param1))
            {
                _displayObject.removeEventListener(param1, _reDispatch, true);
                _displayObject.removeEventListener(param1, _reDispatch, false);
            }
            return;
        }// end function

        private function _reDispatch(event:Event) : void
        {
            var _loc_2:* = event.clone();
            this.dispatchEvent(_loc_2);
            if (event.bubbles && _loc_2 is IBubbleEvent && this.IBubbleEvent(_loc_2).propagationStopped)
            {
                event.stopPropagation();
            }
            return;
        }// end function

        final public function get draggable() : Boolean
        {
            return _draggable;
        }// end function

        final public function set draggable(param1:Boolean) : void
        {
            if (_draggable != param1)
            {
                _draggable = param1;
                initDrag();
            }
            return;
        }// end function

        final public function get dragBounds() : Rectangle
        {
            return _dragBounds;
        }// end function

        final public function set dragBounds(param1:Rectangle) : void
        {
            _dragBounds = param1;
            return;
        }// end function

        public function startDrag(param1:int = -1) : void
        {
            if (_displayObject.stage == null)
            {
                return;
            }
            dragBegin(null);
            triggerDown(param1);
            return;
        }// end function

        public function stopDrag() : void
        {
            dragEnd();
            return;
        }// end function

        public function get dragging() : Boolean
        {
            return draggingObject == this;
        }// end function

        public function localToGlobal(param1:Number = 0, param2:Number = 0) : Point
        {
            if (_pivotAsAnchor)
            {
                param1 = param1 + _pivotX * _width;
                param2 = param2 + _pivotY * _height;
            }
            sHelperPoint.x = param1;
            sHelperPoint.y = param2;
            return _displayObject.localToGlobal(sHelperPoint);
        }// end function

        public function globalToLocal(param1:Number = 0, param2:Number = 0) : Point
        {
            sHelperPoint.x = param1;
            sHelperPoint.y = param2;
            var _loc_3:* = _displayObject.globalToLocal(sHelperPoint);
            if (_pivotAsAnchor)
            {
                _loc_3.x = _loc_3.x - _pivotX * _width;
                _loc_3.y = _loc_3.y - _pivotY * _height;
            }
            return _loc_3;
        }// end function

        public function localToRoot(param1:Number = 0, param2:Number = 0) : Point
        {
            if (_pivotAsAnchor)
            {
                param1 = param1 + _pivotX * _width;
                param2 = param2 + _pivotY * _height;
            }
            sHelperPoint.x = param1;
            sHelperPoint.y = param2;
            var _loc_3:* = _displayObject.localToGlobal(sHelperPoint);
            _loc_3.x = _loc_3.x / GRoot.contentScaleFactor;
            _loc_3.y = _loc_3.y / GRoot.contentScaleFactor;
            return _loc_3;
        }// end function

        public function rootToLocal(param1:Number = 0, param2:Number = 0) : Point
        {
            sHelperPoint.x = param1;
            sHelperPoint.y = param2;
            sHelperPoint.x = sHelperPoint.x * GRoot.contentScaleFactor;
            sHelperPoint.y = sHelperPoint.y * GRoot.contentScaleFactor;
            var _loc_3:* = _displayObject.globalToLocal(sHelperPoint);
            if (_pivotAsAnchor)
            {
                _loc_3.x = _loc_3.x - _pivotX * _width;
                _loc_3.y = _loc_3.y - _pivotY * _height;
            }
            return _loc_3;
        }// end function

        public function localToGlobalRect(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Rectangle = null) : Rectangle
        {
            if (param5 == null)
            {
                param5 = new Rectangle();
            }
            var _loc_6:* = this.localToGlobal(param1, param2);
            param5.x = _loc_6.x;
            param5.y = _loc_6.y;
            _loc_6 = this.localToGlobal(param1 + param3, param2 + param4);
            param5.right = _loc_6.x;
            param5.bottom = _loc_6.y;
            return param5;
        }// end function

        public function globalToLocalRect(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Rectangle = null) : Rectangle
        {
            if (param5 == null)
            {
                param5 = new Rectangle();
            }
            var _loc_6:* = this.globalToLocal(param1, param2);
            param5.x = _loc_6.x;
            param5.y = _loc_6.y;
            _loc_6 = this.globalToLocal(param1 + param3, param2 + param4);
            param5.right = _loc_6.x;
            param5.bottom = _loc_6.y;
            return param5;
        }// end function

        protected function createDisplayObject() : void
        {
            return;
        }// end function

        protected function switchDisplayObject(param1:DisplayObject) : void
        {
            var _loc_3:* = 0;
            if (param1 == _displayObject)
            {
                return;
            }
            var _loc_2:* = _displayObject;
            if (_loc_2.parent != null)
            {
                _loc_3 = _loc_2.parent.getChildIndex(_displayObject);
                _loc_2.parent.addChildAt(param1, _loc_3);
                _loc_2.parent.removeChild(_displayObject);
            }
            _displayObject = param1;
            _loc_2.x = _loc_2.x;
            _loc_2.y = _loc_2.y;
            _loc_2.rotation = _loc_2.rotation;
            _loc_2.alpha = _loc_2.alpha;
            _loc_2.visible = _loc_2.visible;
            _loc_2.scaleX = _loc_2.scaleX;
            _loc_2.scaleY = _loc_2.scaleY;
            _loc_2.filters = _loc_2.filters;
            _loc_2.filters = null;
            if (_displayObject is InteractiveObject && _loc_2 is InteractiveObject)
            {
                this.InteractiveObject(_displayObject).mouseEnabled = this.InteractiveObject(_loc_2).mouseEnabled;
                if (_displayObject is DisplayObjectContainer)
                {
                    this.DisplayObjectContainer(_displayObject).mouseChildren = this.DisplayObjectContainer(_loc_2).mouseChildren;
                }
            }
            return;
        }// end function

        protected function handlePositionChanged() : void
        {
            var _loc_2:* = NaN;
            var _loc_1:* = NaN;
            if (_displayObject)
            {
                _loc_2 = _x;
                _loc_1 = _y + _yOffset;
                if (_pivotAsAnchor)
                {
                    _loc_2 = _loc_2 - _pivotX * _width;
                    _loc_1 = _loc_1 - _pivotY * _height;
                }
                if (_pixelSnapping)
                {
                    _loc_2 = Math.round(_loc_2);
                    _loc_1 = Math.round(_loc_1);
                }
                _displayObject.x = _loc_2 + _pivotOffsetX;
                _displayObject.y = _loc_1 + _pivotOffsetY;
            }
            return;
        }// end function

        protected function handleSizeChanged() : void
        {
            return;
        }// end function

        protected function handleScaleChanged() : void
        {
            if (_displayObject != null)
            {
                _displayObject.scaleX = _scaleX;
                _displayObject.scaleY = _scaleY;
            }
            return;
        }// end function

        public function handleControllerChanged(param1:Controller) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            _handlingController = true;
            _loc_2 = 0;
            while (_loc_2 <= 9)
            {
                
                _loc_3 = _gears[_loc_2];
                if (_loc_3 != null && _loc_3.controller == param1)
                {
                    _loc_3.apply();
                }
                _loc_2++;
            }
            _handlingController = false;
            checkGearDisplay();
            return;
        }// end function

        protected function handleGrayedChanged() : void
        {
            if (_displayObject)
            {
                if (_grayed)
                {
                    _displayObject.filters = ToolSet.GRAY_FILTERS;
                }
                else
                {
                    _displayObject.filters = null;
                }
            }
            return;
        }// end function

        protected function handleAlphaChanged() : void
        {
            if (_displayObject)
            {
                _displayObject.alpha = _alpha;
            }
            return;
        }// end function

        function handleVisibleChanged() : void
        {
            if (_displayObject)
            {
                _displayObject.visible = internalVisible2;
            }
            return;
        }// end function

        public function getProp(param1:int)
        {
            switch(param1) branch count is:<9>[35, 40, 45, 48, 51, 53, 56, 59, 62, 65] default offset is:<67>;
            return this.text;
            return this.icon;
            return 0;
            return 0;
            return false;
            return 0;
            return 0;
            return 1;
            return 0;
            return false;
            return;
        }// end function

        public function setProp(param1:int, param2) : void
        {
            switch(param1) branch count is:<1>[11, 20] default offset is:<25>;
            this.text = param2;
            ;
            this.icon = param2;
            return;
        }// end function

        public function constructFromResource() : void
        {
            return;
        }// end function

        public function setup_beforeAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_5:* = null;
            var _loc_4:* = null;
            _id = param1.@id;
            _name = param1.@name;
            _loc_2 = param1.@xy;
            _loc_3 = _loc_2.split(",");
            this.setXY(this.parseInt(_loc_3[0]), this.parseInt(_loc_3[1]));
            _loc_2 = param1.@size;
            if (_loc_2)
            {
                _loc_3 = _loc_2.split(",");
                initWidth = this.parseInt(_loc_3[0]);
                initHeight = this.parseInt(_loc_3[1]);
                setSize(initWidth, initHeight, true);
            }
            _loc_2 = param1.@restrictSize;
            if (_loc_2)
            {
                _loc_3 = _loc_2.split(",");
                minWidth = this.parseInt(_loc_3[0]);
                maxWidth = this.parseInt(_loc_3[1]);
                minHeight = this.parseInt(_loc_3[2]);
                maxHeight = this.parseInt(_loc_3[3]);
            }
            _loc_2 = param1.@scale;
            if (_loc_2)
            {
                _loc_3 = _loc_2.split(",");
                setScale(this.parseFloat(_loc_3[0]), this.parseFloat(_loc_3[1]));
            }
            _loc_2 = param1.@rotation;
            if (_loc_2)
            {
                this.rotation = this.parseFloat(_loc_2);
            }
            _loc_2 = param1.@alpha;
            if (_loc_2)
            {
                this.alpha = this.parseFloat(_loc_2);
            }
            _loc_2 = param1.@pivot;
            if (_loc_2)
            {
                _loc_3 = _loc_2.split(",");
                _loc_2 = param1.@anchor;
                this.setPivot(this.parseFloat(_loc_3[0]), this.parseFloat(_loc_3[1]), _loc_2 == "true");
            }
            if (param1.@touchable == "false")
            {
                this.touchable = false;
            }
            if (param1.@visible == "false")
            {
                this.visible = false;
            }
            if (param1.@grayed == "true")
            {
                this.grayed = true;
            }
            this.tooltips = param1.@tooltips;
            _loc_2 = param1.@blend;
            if (_loc_2)
            {
                this.blendMode = _loc_2;
            }
            _loc_2 = param1.@filter;
            if (_loc_2)
            {
                var _loc_6:* = _loc_2;
                while (_loc_6 === "color")
                {
                    
                    _loc_2 = param1.@filterData;
                    _loc_3 = _loc_2.split(",");
                    _loc_5 = new ColorMatrix();
                    _loc_5.adjustBrightness(this.parseFloat(_loc_3[0]));
                    _loc_5.adjustContrast(this.parseFloat(_loc_3[1]));
                    _loc_5.adjustSaturation(this.parseFloat(_loc_3[2]));
                    _loc_5.adjustHue(this.parseFloat(_loc_3[3]));
                    _loc_4 = new ColorMatrixFilter(_loc_5);
                    this.filters = [_loc_4];
                    break;
                }
            }
            _loc_2 = param1.@customData;
            if (_loc_2)
            {
                this.data = _loc_2;
            }
            return;
        }// end function

        public function setup_afterAdd(param1:XML) : void
        {
            var _loc_4:* = 0;
            var _loc_3:* = param1.@group;
            if (_loc_3)
            {
                _group = _parent.getChildById(_loc_3) as GGroup;
            }
            var _loc_2:* = param1.elements();
            for each (_loc_5 in _loc_2)
            {
                
                _loc_4 = GearBase.getIndexByName(_loc_5.name().localName);
                if (_loc_4 != -1)
                {
                    getGear(_loc_4).setup(_loc_5);
                }
            }
            return;
        }// end function

        public function get isDown() : Boolean
        {
            return _buttonStatus == 1;
        }// end function

        public function triggerDown(param1:int = -1) : void
        {
            var _loc_2:* = _displayObject.stage;
            if (_loc_2 != null)
            {
                _buttonStatus = 1;
                if (!GRoot.touchPointInput)
                {
                    _loc_2.addEventListener("mouseUp", __stageMouseup, false, 20);
                    if (hasEventListener("dragGTouch"))
                    {
                        _loc_2.addEventListener("mouseMove", __mousemove);
                    }
                }
                else
                {
                    _touchPointId = param1;
                    _loc_2.addEventListener("touchEnd", __stageMouseup, false, 20);
                    if (hasEventListener("dragGTouch"))
                    {
                        _loc_2.addEventListener("touchMove", __mousemove);
                    }
                }
            }
            return;
        }// end function

        private function initMTouch() : void
        {
            if (!GRoot.touchPointInput)
            {
                _displayObject.addEventListener("mouseDown", __mousedown);
                _displayObject.addEventListener("mouseUp", __mouseup);
            }
            else
            {
                _displayObject.addEventListener("touchBegin", __mousedown);
                _displayObject.addEventListener("touchEnd", __mouseup);
            }
            return;
        }// end function

        private function __mousedown(event:Event) : void
        {
            var _loc_2:* = new GTouchEvent("beginGTouch");
            _loc_2.copyFrom(event);
            this.dispatchEvent(_loc_2);
            if (_loc_2.isPropagationStop)
            {
                event.stopPropagation();
            }
            if (_touchDownPoint == null)
            {
                _touchDownPoint = new Point();
            }
            if (!GRoot.touchPointInput)
            {
                _touchDownPoint.x = this.MouseEvent(event).stageX;
                _touchDownPoint.y = this.MouseEvent(event).stageY;
                triggerDown();
            }
            else
            {
                _touchDownPoint.x = this.TouchEvent(event).stageX;
                _touchDownPoint.y = this.TouchEvent(event).stageY;
                triggerDown(this.TouchEvent(event).touchPointID);
            }
            return;
        }// end function

        private function __mousemove(event:MouseEvent) : void
        {
            var _loc_3:* = 0;
            if (_buttonStatus != 1 || GRoot.touchPointInput && _touchPointId != this.TouchEvent(event).touchPointID)
            {
                return;
            }
            if (GRoot.touchPointInput)
            {
                _loc_3 = UIConfig.touchDragSensitivity;
                if (_touchDownPoint != null && Math.abs(_touchDownPoint.x - this.TouchEvent(event).stageX) < _loc_3 && Math.abs(_touchDownPoint.y - this.TouchEvent(event).stageY) < _loc_3)
                {
                    return;
                }
            }
            else
            {
                _loc_3 = UIConfig.clickDragSensitivity;
                if (_touchDownPoint != null && Math.abs(_touchDownPoint.x - this.MouseEvent(event).stageX) < _loc_3 && Math.abs(_touchDownPoint.y - this.MouseEvent(event).stageY) < _loc_3)
                {
                    return;
                }
            }
            event.updateAfterEvent();
            var _loc_2:* = new GTouchEvent("dragGTouch");
            _loc_2.copyFrom(event);
            this.dispatchEvent(_loc_2);
            if (_loc_2.isPropagationStop)
            {
                event.stopPropagation();
            }
            return;
        }// end function

        private function __mouseup(event:Event) : void
        {
            if (_buttonStatus != 1 || GRoot.touchPointInput && _touchPointId != this.TouchEvent(event).touchPointID)
            {
                return;
            }
            _buttonStatus = 2;
            return;
        }// end function

        private function __stageMouseup(event:Event) : void
        {
            var _loc_2:* = 0;
            var _loc_5:* = 0;
            var _loc_4:* = null;
            var _loc_3:* = null;
            if (!GRoot.touchPointInput)
            {
                event.currentTarget.removeEventListener("mouseUp", __stageMouseup);
                event.currentTarget.removeEventListener("mouseMove", __mousemove);
            }
            else
            {
                if (_touchPointId != this.TouchEvent(event).touchPointID)
                {
                    return;
                }
                event.currentTarget.removeEventListener("touchEnd", __stageMouseup);
                event.currentTarget.removeEventListener("touchMove", __mousemove);
            }
            if (_buttonStatus == 2)
            {
                _loc_2 = 1;
                _loc_5 = this.getTimer();
                if (_loc_5 - _lastClick < 500)
                {
                    _loc_2 = 2;
                    _lastClick = 0;
                }
                else
                {
                    _lastClick = _loc_5;
                }
                _loc_4 = new GTouchEvent("clickGTouch");
                _loc_4.copyFrom(event, _loc_2);
                this.dispatchEvent(_loc_4);
                if (_loc_4.isPropagationStop)
                {
                    _loc_3 = this.parent;
                    while (_loc_3 != null)
                    {
                        
                        _loc_3._buttonStatus = 0;
                        _loc_3 = _loc_3.parent;
                    }
                }
            }
            _buttonStatus = 0;
            _loc_4 = new GTouchEvent("endGTouch");
            _loc_4.copyFrom(event);
            this.dispatchEvent(_loc_4);
            return;
        }// end function

        public function cancelClick() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            _buttonStatus = 0;
            var _loc_1:* = this.GComponent(this).numChildren;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this.GComponent(this).getChildAt(_loc_2);
                _loc_3._buttonStatus = 0;
                if (_loc_3 is GComponent)
                {
                    _loc_3.cancelClick();
                }
                _loc_2++;
            }
            return;
        }// end function

        private function initDrag() : void
        {
            if (_draggable)
            {
                addEventListener("beginGTouch", __begin);
            }
            else
            {
                removeEventListener("beginGTouch", __begin);
            }
            return;
        }// end function

        private function dragBegin(event:GTouchEvent) : void
        {
            if (draggingObject != null)
            {
                draggingObject.stopDrag();
                draggingObject = null;
            }
            if (event != null)
            {
                sGlobalDragStart.x = event.stageX;
                sGlobalDragStart.y = event.stageY;
            }
            else
            {
                sGlobalDragStart.x = _displayObject.stage.mouseX;
                sGlobalDragStart.y = _displayObject.stage.mouseY;
            }
            this.localToGlobalRect(0, 0, this.width, this.height, sGlobalRect);
            draggingObject = this;
            addEventListener("dragGTouch", __dragging);
            addEventListener("endGTouch", __dragEnd);
            return;
        }// end function

        private function dragEnd() : void
        {
            if (draggingObject == this)
            {
                removeEventListener("dragGTouch", __dragStart);
                removeEventListener("endGTouch", __dragEnd);
                removeEventListener("dragGTouch", __dragging);
                draggingObject = null;
            }
            return;
        }// end function

        private function __begin(event:GTouchEvent) : void
        {
            if (event.realTarget is TextField && this.TextField(event.realTarget).type == "input")
            {
                return;
            }
            addEventListener("dragGTouch", __dragStart);
            return;
        }// end function

        private function __dragStart(event:GTouchEvent) : void
        {
            removeEventListener("dragGTouch", __dragStart);
            if (event.realTarget is TextField && this.TextField(event.realTarget).type == "input")
            {
                return;
            }
            var _loc_2:* = new DragEvent("startDrag");
            _loc_2.stageX = event.stageX;
            _loc_2.stageY = event.stageY;
            _loc_2.touchPointID = event.touchPointID;
            dispatchEvent(_loc_2);
            if (!_loc_2.isDefaultPrevented())
            {
                dragBegin(event);
            }
            return;
        }// end function

        private function __dragging(event:GTouchEvent) : void
        {
            var _loc_4:* = null;
            if (this.parent == null)
            {
                return;
            }
            var _loc_2:* = event.stageX - sGlobalDragStart.x + sGlobalRect.x;
            var _loc_3:* = event.stageY - sGlobalDragStart.y + sGlobalRect.y;
            if (_dragBounds != null)
            {
                _loc_4 = GRoot.inst.localToGlobalRect(_dragBounds.x, _dragBounds.y, _dragBounds.width, _dragBounds.height, sDragHelperRect);
                if (_loc_2 < _loc_4.x)
                {
                    _loc_2 = _loc_4.x;
                }
                else if (_loc_2 + sGlobalRect.width > _loc_4.right)
                {
                    _loc_2 = _loc_4.right - sGlobalRect.width;
                    if (_loc_2 < _loc_4.x)
                    {
                        _loc_2 = _loc_4.x;
                    }
                }
                if (_loc_3 < _loc_4.y)
                {
                    _loc_3 = _loc_4.y;
                }
                else if (_loc_3 + sGlobalRect.height > _loc_4.bottom)
                {
                    _loc_3 = _loc_4.bottom - sGlobalRect.height;
                    if (_loc_3 < _loc_4.y)
                    {
                        _loc_3 = _loc_4.y;
                    }
                }
            }
            sUpdateInDragging = true;
            var _loc_6:* = this.parent.globalToLocal(_loc_2, _loc_3);
            this.setXY(Math.round(_loc_6.x), Math.round(_loc_6.y));
            sUpdateInDragging = false;
            var _loc_5:* = new DragEvent("dragMoving");
            _loc_5.stageX = event.stageX;
            _loc_5.stageY = event.stageY;
            _loc_5.touchPointID = event.touchPointID;
            dispatchEvent(_loc_5);
            return;
        }// end function

        private function __dragEnd(event:GTouchEvent) : void
        {
            var _loc_2:* = null;
            if (draggingObject == this)
            {
                stopDrag();
                _loc_2 = new DragEvent("endDrag");
                _loc_2.stageX = event.stageX;
                _loc_2.stageY = event.stageY;
                _loc_2.touchPointID = event.touchPointID;
                dispatchEvent(_loc_2);
            }
            return;
        }// end function

    }
}
