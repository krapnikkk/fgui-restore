package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.gear.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class FObject extends EventDispatcher
    {
        protected var _name:String;
        protected var _x:Number;
        protected var _y:Number;
        protected var _alpha:Number;
        protected var _rotation:Number;
        protected var _visible:Boolean;
        protected var _relations:FRelations;
        protected var _locked:Boolean;
        protected var _aspectLocked:Boolean;
        protected var _aspectRatio:Number;
        protected var _groupId:String;
        protected var _touchable:Boolean;
        protected var _grayed:Boolean;
        protected var _pivotX:Number;
        protected var _pivotY:Number;
        protected var _anchor:Boolean;
        protected var _pivotFromSource:Boolean;
        protected var _scaleX:Number;
        protected var _scaleY:Number;
        protected var _tooltips:String;
        protected var _blendMode:String;
        protected var _filterData:FilterData;
        protected var _skewX:Number;
        protected var _skewY:Number;
        protected var _gears:Vector.<FGearBase>;
        protected var _touchDisabled:Boolean;
        protected var _hideByEditor:Boolean;
        protected var _scaleFactor:Number;
        protected var _useSourceSize:Boolean;
        protected var _internalMinWidth:int;
        protected var _internalMinHeight:int;
        protected var _minWidth:int;
        protected var _minHeight:int;
        protected var _maxWidth:int;
        protected var _maxHeight:int;
        protected var _restrictSizeFromSource:Boolean;
        protected var _displayObject:FSprite;
        protected var _dispatcher:DispatcherLite;
        protected var _handlingController:Boolean;
        public var _parent:FComponent;
        public var _id:String;
        public var _width:Number;
        public var _height:Number;
        public var _rawWidth:Number;
        public var _rawHeight:Number;
        public var _widthEnabled:Boolean;
        public var _heightEnabled:Boolean;
        public var _renderDepth:int;
        public var _outlineVersion:int;
        public var _pivotOffsetX:Number;
        public var _pivotOffsetY:Number;
        public var _opened:Boolean;
        public var _group:FGroup;
        public var _sizePercentInGroup:Number;
        public var _gearLocked:Boolean;
        public var _internalVisible:Boolean;
        public var _hasSnapshot:Boolean;
        public var _treeNode:FTreeNode;
        public var _pkg:FPackage;
        public var _res:ResourceRef;
        public var _objectType:String;
        public var _docElement:IDocElement;
        public var _flags:int;
        public var _underConstruct:Boolean;
        public var sourceWidth:int;
        public var sourceHeight:int;
        public var initWidth:Number;
        public var initHeight:Number;
        public var customData:String;
        protected var _disposed:Boolean;
        private var _lastClick:int;
        private var _buttonStatus:int;
        private var _touchDownPoint:Point;
        public static var loadingSnapshot:Boolean;
        public static const REMOVED:int = 0;
        public static const XY_CHANGED:int = 1;
        public static const SIZE_CHANGED:int = 2;
        public static const SCALE_CHANGED:int = 3;
        public static const ROTATION_CHANGED:int = 4;
        public static const PIVOT_CHANGED:int = 5;
        public static const SKEW_CHANGED:int = 6;
        public static const MAX_GEAR_INDEX:int = 9;
        private static var sHelperPoint:Point = new Point();
        private static var helperMatrix:Matrix = new Matrix();
        private static var helperPoint:Point = new Point();

        public function FObject()
        {
            this._x = 0;
            this._y = 0;
            this._width = 0;
            this._height = 0;
            this._rawWidth = 0;
            this._rawHeight = 0;
            this._id = "";
            this._name = "";
            this._alpha = 1;
            this._rotation = 0;
            this._visible = true;
            this._relations = new FRelations(this);
            this._displayObject = new FSprite(this);
            this._dispatcher = new DispatcherLite();
            this._locked = false;
            this._widthEnabled = true;
            this._heightEnabled = true;
            this._aspectLocked = false;
            this._useSourceSize = true;
            this._aspectRatio = 1;
            this._minWidth = 0;
            this._minHeight = 0;
            this._maxWidth = 0;
            this._maxHeight = 0;
            this._internalMinWidth = 0;
            this._internalMinHeight = 0;
            this._touchable = true;
            this._grayed = false;
            this._scaleX = 1;
            this._scaleY = 1;
            this._tooltips = "";
            this._pivotX = 0;
            this._pivotY = 0;
            this._pivotOffsetX = 0;
            this._pivotOffsetY = 0;
            this._internalVisible = true;
            this._blendMode = "normal";
            this._filterData = new FilterData();
            this._skewX = 0;
            this._skewY = 0;
            this._gears = new Vector.<FGearBase>((MAX_GEAR_INDEX + 1), true);
            if (this is FComponent)
            {
                this.initMTouch();
            }
            return;
        }// end function

        public function get id() : String
        {
            return this._id;
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

        public function get objectType() : String
        {
            return this._objectType;
        }// end function

        public function get pkg() : IUIPackage
        {
            return this._pkg;
        }// end function

        public function get docElement() : IDocElement
        {
            return this._docElement;
        }// end function

        public function get touchable() : Boolean
        {
            if (this._touchDisabled)
            {
                return false;
            }
            return this._touchable;
        }// end function

        public function set touchable(param1:Boolean) : void
        {
            if (this._touchable != param1)
            {
                this._touchable = param1;
                this.handleTouchableChanged();
                this.updateGear(3);
            }
            return;
        }// end function

        public function get touchDisabled() : Boolean
        {
            return this._touchDisabled;
        }// end function

        public function set touchDisabled(param1:Boolean) : void
        {
            if (this._touchDisabled != param1)
            {
                this._touchDisabled = param1;
                this.handleTouchableChanged();
            }
            return;
        }// end function

        public function get grayed() : Boolean
        {
            return this._grayed;
        }// end function

        public function set grayed(param1:Boolean) : void
        {
            if (this._grayed != param1)
            {
                this._grayed = param1;
                this.handleGrayedChanged();
                this.updateGear(3);
            }
            return;
        }// end function

        public function get enabled() : Boolean
        {
            return !this._grayed && this._touchable;
        }// end function

        public function set enabled(param1:Boolean) : void
        {
            this._grayed = !param1;
            this._touchable = param1;
            return;
        }// end function

        public function get resourceURL() : String
        {
            if (this._res != null)
            {
                return this._res.getURL();
            }
            return null;
        }// end function

        public function get x() : Number
        {
            return this._x;
        }// end function

        public function set x(param1:Number) : void
        {
            this.setXY(param1, this._y);
            return;
        }// end function

        public function get y() : Number
        {
            return this._y;
        }// end function

        public function set y(param1:Number) : void
        {
            this.setXY(this._x, param1);
            return;
        }// end function

        public function setXY(param1:Number, param2:Number) : void
        {
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            if (this._x != param1 || this._y != param2)
            {
                _loc_3 = param1 - this._x;
                _loc_4 = param2 - this._y;
                this._x = param1;
                this._y = param2;
                this.handleXYChanged();
                if (this._parent)
                {
                    if (!(loadingSnapshot && this._hasSnapshot))
                    {
                        if (this._group)
                        {
                            this._group.refresh(true);
                        }
                        if (this is FGroup)
                        {
                            FGroup(this).moveChildren(_loc_3, _loc_4);
                        }
                    }
                    this._parent.setBoundsChangedFlag();
                }
                this.updateGear(1);
                var _loc_5:* = this;
                var _loc_6:* = this._outlineVersion + 1;
                _loc_5._outlineVersion = _loc_6;
                this._dispatcher.emit(this, XY_CHANGED);
            }
            return;
        }// end function

        public function setTopLeft(param1:Number, param2:Number) : void
        {
            if (this._anchor)
            {
                this.setXY(param1 + this._pivotX * this._width, param2 + this._pivotY * this._height);
            }
            else
            {
                this.setXY(param1, param2);
            }
            return;
        }// end function

        public function get xMin() : Number
        {
            if (this._anchor)
            {
                return this._x - this._width * this._pivotX;
            }
            return this._x;
        }// end function

        public function set xMin(param1:Number) : void
        {
            if (this._anchor)
            {
                this.setXY(param1 + this._width * this._pivotX, this._y);
            }
            else
            {
                this.setXY(param1, this._y);
            }
            return;
        }// end function

        public function get xMax() : Number
        {
            return this.xMin + this._width;
        }// end function

        public function set xMax(param1:Number) : void
        {
            this.xMin = param1 - this._width;
            return;
        }// end function

        public function get yMin() : Number
        {
            if (this._anchor)
            {
                return this._y - this._height * this._pivotY;
            }
            return this._y;
        }// end function

        public function set yMin(param1:Number) : void
        {
            if (this._anchor)
            {
                this.setXY(this._x, param1 + this._height * this._pivotY);
            }
            else
            {
                this.setXY(this._x, param1);
            }
            return;
        }// end function

        public function get yMax() : Number
        {
            return this.yMin + this._height;
        }// end function

        public function set yMax(param1:Number) : void
        {
            this.yMin = param1 - this._height;
            return;
        }// end function

        public function get height() : Number
        {
            return this._height;
        }// end function

        public function get width() : Number
        {
            return this._width;
        }// end function

        public function set width(param1:Number) : void
        {
            this.setSize(param1, this._rawHeight);
            return;
        }// end function

        public function set height(param1:Number) : void
        {
            this.setSize(this._rawWidth, param1);
            return;
        }// end function

        public function setSize(param1:Number, param2:Number, param3:Boolean = false, param4:Boolean = false) : void
        {
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            if (!param4)
            {
                if (!this._widthEnabled)
                {
                    param1 = this._width;
                }
                if (!this._heightEnabled)
                {
                    param2 = this._height;
                }
                if (this.docElement)
                {
                    if (this.relations.widthLocked)
                    {
                        param1 = this._rawWidth;
                    }
                    if (this.relations.heightLocked)
                    {
                        param2 = this._rawHeight;
                    }
                }
            }
            if (this._rawWidth != param1 || this._rawHeight != param2)
            {
                this._rawWidth = param1;
                this._rawHeight = param2;
                if ((this._flags & FObjectFlags.INSPECTING) != 0)
                {
                    if (param1 < this._internalMinWidth)
                    {
                        param1 = this._internalMinWidth;
                    }
                    if (param2 < this._internalMinHeight)
                    {
                        param2 = this._internalMinHeight;
                    }
                }
                if (param1 < this._minWidth)
                {
                    param1 = this._minWidth;
                }
                if (param2 < this._minHeight)
                {
                    param2 = this._minHeight;
                }
                if (this._maxWidth > 0 && param1 > this._maxWidth)
                {
                    param1 = this._maxWidth;
                }
                if (this._maxHeight > 0 && param2 > this._maxHeight)
                {
                    param2 = this._maxHeight;
                }
                _loc_5 = param1 - this._width;
                _loc_6 = param2 - this._height;
                this._width = param1;
                this._height = param2;
                if ((this._pivotX != 0 || this._pivotY != 0) && (this._flags & FObjectFlags.ROOT) == 0)
                {
                    if (!this._anchor)
                    {
                        if (!param3)
                        {
                            this.setXY(this.x - this._pivotX * _loc_5, this.y - this._pivotY * _loc_6);
                        }
                        this.updatePivotOffset();
                    }
                    else
                    {
                        this.applyPivot();
                    }
                }
                if (this._res && (this._width != this.sourceWidth || this._height != this.sourceHeight))
                {
                    this._useSourceSize = false;
                }
                this.handleSizeChanged();
                if (this._parent)
                {
                    if (!(loadingSnapshot && this._hasSnapshot))
                    {
                        this._relations.onOwnerSizeChanged(_loc_5, _loc_6, this._anchor || !param3);
                        if (this is FGroup)
                        {
                            FGroup(this).resizeChildren(_loc_5, _loc_6);
                        }
                        if (this._group)
                        {
                            this._group.refresh();
                        }
                    }
                    this._parent.setBoundsChangedFlag();
                }
                this.updateGear(2);
                var _loc_7:* = this;
                var _loc_8:* = this._outlineVersion + 1;
                _loc_7._outlineVersion = _loc_8;
                this._dispatcher.emit(this, SIZE_CHANGED);
            }
            return;
        }// end function

        public function get minWidth() : int
        {
            return this._minWidth;
        }// end function

        public function set minWidth(param1:int) : void
        {
            this._minWidth = param1;
            this._restrictSizeFromSource = false;
            return;
        }// end function

        public function get minHeight() : int
        {
            return this._minHeight;
        }// end function

        public function set minHeight(param1:int) : void
        {
            this._minHeight = param1;
            this._restrictSizeFromSource = false;
            return;
        }// end function

        public function get maxWidth() : int
        {
            return this._maxWidth;
        }// end function

        public function set maxWidth(param1:int) : void
        {
            this._maxWidth = param1;
            this._restrictSizeFromSource = false;
            return;
        }// end function

        public function get maxHeight() : int
        {
            return this._maxHeight;
        }// end function

        public function set maxHeight(param1:int) : void
        {
            this._maxHeight = param1;
            this._restrictSizeFromSource = false;
            return;
        }// end function

        public function get actualWidth() : Number
        {
            return this.width * this._scaleX;
        }// end function

        public function get actualHeight() : Number
        {
            return this.height * this._scaleY;
        }// end function

        final public function get scaleX() : Number
        {
            return this._scaleX;
        }// end function

        public function set scaleX(param1:Number) : void
        {
            this.setScale(param1, this._scaleY);
            return;
        }// end function

        final public function get scaleY() : Number
        {
            return this._scaleY;
        }// end function

        public function set scaleY(param1:Number) : void
        {
            this.setScale(this._scaleX, param1);
            return;
        }// end function

        public function setScale(param1:Number, param2:Number) : void
        {
            if (this._scaleX != param1 || this._scaleY != param2)
            {
                this._scaleX = param1;
                this._scaleY = param2;
                this._displayObject.setContentScale(this._scaleX, this._scaleY);
                this.applyPivot();
                if (this._parent)
                {
                    this._parent.setBoundsChangedFlag();
                }
                this.updateGear(2);
                var _loc_3:* = this;
                var _loc_4:* = this._outlineVersion + 1;
                _loc_3._outlineVersion = _loc_4;
                this._dispatcher.emit(this, SCALE_CHANGED);
            }
            return;
        }// end function

        public function get pivotOffsetX() : Number
        {
            return this._pivotOffsetX;
        }// end function

        public function get pivotOffsetY() : Number
        {
            return this._pivotOffsetY;
        }// end function

        public function get aspectLocked() : Boolean
        {
            return this._aspectLocked;
        }// end function

        public function set aspectLocked(param1:Boolean) : void
        {
            this._aspectLocked = param1;
            if (this._aspectLocked)
            {
                this._aspectRatio = this.width / this.height;
            }
            return;
        }// end function

        public function get aspectRatio() : Number
        {
            return this._aspectRatio;
        }// end function

        public function get skewX() : Number
        {
            return this._skewX;
        }// end function

        public function set skewX(param1:Number) : void
        {
            this.setSkew(param1, this._skewY);
            return;
        }// end function

        public function get skewY() : Number
        {
            return this._skewY;
        }// end function

        public function set skewY(param1:Number) : void
        {
            this.setSkew(this._skewX, param1);
            return;
        }// end function

        public function setSkew(param1:Number, param2:Number) : void
        {
            if (this._skewX != param1 || this._skewY != param2)
            {
                this._skewX = param1;
                this._skewY = param2;
                this.displayObject.setContentSkew(this._skewX, this._skewY);
                this.applyPivot();
                var _loc_3:* = this;
                var _loc_4:* = this._outlineVersion + 1;
                _loc_3._outlineVersion = _loc_4;
                this._dispatcher.emit(this, SKEW_CHANGED);
            }
            return;
        }// end function

        public function get pivotX() : Number
        {
            return this._pivotX;
        }// end function

        public function set pivotX(param1:Number) : void
        {
            this.setPivot(param1, this._pivotY, this._anchor);
            return;
        }// end function

        public function get pivotY() : Number
        {
            return this._pivotY;
        }// end function

        public function set pivotY(param1:Number) : void
        {
            this.setPivot(this._pivotX, param1, this._anchor);
            return;
        }// end function

        public function setPivot(param1:Number, param2:Number, param3:Boolean) : void
        {
            if (this._pivotX != param1 || this._pivotY != param2 || this._anchor != param3)
            {
                this._pivotFromSource = false;
                this._pivotX = param1;
                this._pivotY = param2;
                this._anchor = param3;
                var _loc_4:* = this;
                var _loc_5:* = this._outlineVersion + 1;
                _loc_4._outlineVersion = _loc_5;
                if ((this._flags & FObjectFlags.ROOT) == 0)
                {
                    this.applyPivot();
                    if (!this._underConstruct)
                    {
                        this._dispatcher.emit(this, PIVOT_CHANGED);
                    }
                }
            }
            return;
        }// end function

        public function get anchor() : Boolean
        {
            return this._anchor;
        }// end function

        public function set anchor(param1:Boolean) : void
        {
            if (this._anchor != param1)
            {
                this._anchor = param1;
                this._pivotFromSource = false;
                var _loc_2:* = this;
                var _loc_3:* = this._outlineVersion + 1;
                _loc_2._outlineVersion = _loc_3;
                if ((this._flags & FObjectFlags.ROOT) == 0)
                {
                    this.handleXYChanged();
                    this._dispatcher.emit(this, PIVOT_CHANGED);
                }
            }
            return;
        }// end function

        private function updatePivotOffset() : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = null;
            var _loc_1:* = this.normalizeRotation;
            if (_loc_1 != 0 || this._scaleX != 1 || this._scaleY != 1 || this._skewX != 0 || this._skewY != 0)
            {
                _loc_2 = _loc_1 * Math.PI / 180;
                _loc_3 = this._pivotX * this._width;
                _loc_4 = this._pivotY * this._height;
                if (this._skewX == 0 && this._skewY == 0)
                {
                    _loc_5 = Math.cos(_loc_2);
                    _loc_6 = Math.sin(_loc_2);
                    _loc_7 = this._scaleX * _loc_5;
                    _loc_8 = this._scaleX * _loc_6;
                    _loc_9 = this._scaleY * (-_loc_6);
                    _loc_10 = this._scaleY * _loc_5;
                    this._pivotOffsetX = _loc_3 - (_loc_7 * _loc_3 + _loc_9 * _loc_4);
                    this._pivotOffsetY = _loc_4 - (_loc_10 * _loc_4 + _loc_8 * _loc_3);
                }
                else
                {
                    helperMatrix.identity();
                    helperMatrix.scale(this._scaleX, this._scaleY);
                    Utils.skew(helperMatrix, this._skewX, this._skewY);
                    helperMatrix.rotate(_loc_2);
                    helperPoint.x = this._pivotX * this._width;
                    helperPoint.y = this._pivotY * this._height;
                    _loc_11 = helperMatrix.transformPoint(helperPoint);
                    this._pivotOffsetX = _loc_3 - _loc_11.x;
                    this._pivotOffsetY = _loc_4 - _loc_11.y;
                }
            }
            else
            {
                this._pivotOffsetX = 0;
                this._pivotOffsetY = 0;
            }
            return;
        }// end function

        private function applyPivot() : void
        {
            this.updatePivotOffset();
            this.handleXYChanged();
            return;
        }// end function

        public function get locked() : Boolean
        {
            return this._locked;
        }// end function

        public function set locked(param1:Boolean) : void
        {
            if (this._locked != param1)
            {
                this._locked = param1;
                this.handleTouchableChanged();
            }
            return;
        }// end function

        public function get hideByEditor() : Boolean
        {
            return this._hideByEditor;
        }// end function

        public function set hideByEditor(param1:Boolean) : void
        {
            this._hideByEditor = param1;
            return;
        }// end function

        public function get useSourceSize() : Boolean
        {
            return this._useSourceSize;
        }// end function

        public function set useSourceSize(param1:Boolean) : void
        {
            if (!this._res)
            {
                return;
            }
            this._useSourceSize = param1;
            return;
        }// end function

        public function get rotation() : Number
        {
            return this._rotation;
        }// end function

        public function get normalizeRotation() : Number
        {
            var _loc_1:* = this._rotation % 360;
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

        public function set rotation(param1:Number) : void
        {
            if (this._rotation != param1)
            {
                this._rotation = param1;
                this.applyPivot();
                if (this._displayObject != null)
                {
                    this._displayObject.contentRotation = this.normalizeRotation;
                }
                this.updateGear(3);
                var _loc_2:* = this;
                var _loc_3:* = this._outlineVersion + 1;
                _loc_2._outlineVersion = _loc_3;
                this._dispatcher.emit(this, ROTATION_CHANGED);
            }
            return;
        }// end function

        public function get alpha() : Number
        {
            return this._alpha;
        }// end function

        public function set alpha(param1:Number) : void
        {
            if (this._alpha != param1)
            {
                this._alpha = param1;
                this.handleAlphaChanged();
                this.updateGear(3);
            }
            return;
        }// end function

        public function get visible() : Boolean
        {
            return this._visible;
        }// end function

        public function set visible(param1:Boolean) : void
        {
            if (this._visible != param1)
            {
                this._visible = param1;
                this.handleVisibleChanged();
                if (this._parent)
                {
                    this._parent.setBoundsChangedFlag();
                }
                if (this._group)
                {
                    this._group.refresh();
                }
            }
            return;
        }// end function

        public function get internalVisible() : Boolean
        {
            return this._internalVisible && (!this._group || this._group.internalVisible);
        }// end function

        public function get internalVisible2() : Boolean
        {
            var _loc_1:* = this._visible;
            if ((this._flags & FObjectFlags.INSPECTING) != 0)
            {
                if (this._hideByEditor)
                {
                    _loc_1 = false;
                }
                else if (Preferences.hideInvisibleChild)
                {
                    _loc_1 = this._visible;
                }
                else if (!this.docElement || !this.docElement.owner.timelineMode)
                {
                    _loc_1 = true;
                }
            }
            return _loc_1 && (!this._group || this._group.internalVisible2);
        }// end function

        public function get internalVisible3() : Boolean
        {
            return this._visible && this._internalVisible;
        }// end function

        public function get groupId() : String
        {
            return this._groupId;
        }// end function

        public function set groupId(param1:String) : void
        {
            if (this._groupId != param1)
            {
                if (this._group)
                {
                    this._group._childrenDirty = true;
                    this._group.refresh();
                    this._group = null;
                }
                this._groupId = param1;
                if (this._groupId)
                {
                    this._group = this._parent.getChildById(this._groupId) as FGroup;
                    if (this._group)
                    {
                        this._group._childrenDirty = true;
                        this._group.refresh();
                    }
                }
            }
            return;
        }// end function

        public function inGroup(param1:FGroup) : Boolean
        {
            if (this._group == null && param1 == null)
            {
                return true;
            }
            var _loc_2:* = this._group;
            while (_loc_2)
            {
                
                if (_loc_2 == param1)
                {
                    return true;
                }
                _loc_2 = _loc_2._group;
            }
            return false;
        }// end function

        public function get tooltips() : String
        {
            return this._tooltips;
        }// end function

        public function set tooltips(param1:String) : void
        {
            if ((this._flags & FObjectFlags.IN_TEST) != 0 && this._tooltips)
            {
                this.displayObject.removeEventListener(MouseEvent.ROLL_OVER, this.__rollOver);
                this.displayObject.removeEventListener(MouseEvent.ROLL_OUT, this.__rollOut);
            }
            this._tooltips = param1;
            if ((this._flags & FObjectFlags.IN_TEST) != 0 && this._tooltips)
            {
                this.displayObject.addEventListener(MouseEvent.ROLL_OVER, this.__rollOver);
                this.displayObject.addEventListener(MouseEvent.ROLL_OUT, this.__rollOut);
            }
            return;
        }// end function

        private function __rollOver(event:Event) : void
        {
            GTimers.inst.callDelay(100, this.__doShowTooltips);
            return;
        }// end function

        private function __doShowTooltips(param1:GRoot) : void
        {
            this.editor.testView.showTooltips(this._tooltips);
            return;
        }// end function

        private function __rollOut(event:Event) : void
        {
            GTimers.inst.remove(this.__doShowTooltips);
            this.editor.testView.hideTooltips();
            return;
        }// end function

        public function get filterData() : FilterData
        {
            return this._filterData;
        }// end function

        public function set filterData(param1:FilterData) : void
        {
            this._filterData = param1;
            this._displayObject.applyFilter();
            return;
        }// end function

        public function get filter() : String
        {
            return this._filterData.type;
        }// end function

        public function set filter(param1:String) : void
        {
            this._filterData.type = param1;
            this._displayObject.applyFilter();
            return;
        }// end function

        public function get blendMode() : String
        {
            return this._blendMode;
        }// end function

        public function set blendMode(param1:String) : void
        {
            this._blendMode = param1;
            switch(this._blendMode)
            {
                case "normal":
                {
                    this._displayObject.blendMode = BlendMode.NORMAL;
                    break;
                }
                case "none":
                {
                    this._displayObject.blendMode = BlendMode.NORMAL;
                    break;
                }
                case "add":
                {
                    this._displayObject.blendMode = BlendMode.ADD;
                    break;
                }
                case "multiply":
                {
                    this._displayObject.blendMode = BlendMode.MULTIPLY;
                    break;
                }
                case "screen":
                {
                    this._displayObject.blendMode = BlendMode.SCREEN;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        final public function getGear(param1:int, param2:Boolean = true) : FGearBase
        {
            var _loc_3:* = this._gears[param1];
            if (_loc_3 == null && param2)
            {
                var _loc_4:* = FGearBase.create(this, param1);
                _loc_3 = FGearBase.create(this, param1);
                this._gears[param1] = _loc_4;
            }
            return _loc_3;
        }// end function

        public function updateGear(param1:int) : void
        {
            if (this._underConstruct || this._gearLocked || this._docElement && this._docElement.owner.timelineMode)
            {
                return;
            }
            var _loc_2:* = this._gears[param1];
            if (_loc_2 != null && _loc_2.controllerObject != null)
            {
                _loc_2.updateState();
            }
            return;
        }// end function

        public function updateGearFromRelations(param1:int, param2:Number, param3:Number) : void
        {
            if (this._gears[param1] != null)
            {
                this._gears[param1].updateFromRelations(param2, param3);
            }
            return;
        }// end function

        public function supportGear(param1:int) : Boolean
        {
            switch(param1)
            {
                case 3:
                {
                    return !(this is FGroup);
                }
                case 4:
                {
                    return !(this is FGroup) && (!(this is FComponent) || FComponent(this).extentionId == "Button" || FComponent(this).extentionId == "Label");
                }
                case 5:
                {
                    return this is FMovieClip || this is FLoader || this is FSwfObject;
                }
                case 9:
                {
                    return this is FTextField || this is FComponent && (FComponent(this).extentionId == "Button" || FComponent(this).extentionId == "Label");
                }
                default:
                {
                    return true;
                    break;
                }
            }
        }// end function

        public function validateGears() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 <= MAX_GEAR_INDEX)
            {
                
                if (this._gears[_loc_1] != null && !this.supportGear(_loc_1))
                {
                    this._gears[_loc_1] = null;
                }
                _loc_1++;
            }
            return;
        }// end function

        public function checkGearController(param1:int, param2:FController) : Boolean
        {
            return this._gears[param1] != null && this._gears[param1].controllerObject == param2;
        }// end function

        public function checkGearsController(param1:FController) : Boolean
        {
            var _loc_2:* = 0;
            while (_loc_2 <= MAX_GEAR_INDEX)
            {
                
                if (this._gears[_loc_2] != null && this._gears[_loc_2].controllerObject == param1)
                {
                    return true;
                }
                _loc_2++;
            }
            return false;
        }// end function

        public function addDisplayLock() : uint
        {
            var _loc_2:* = 0;
            var _loc_1:* = FGearDisplay(this._gears[0]);
            if (_loc_1 && _loc_1.controllerObject)
            {
                _loc_2 = _loc_1.addLock();
                this.checkGearDisplay();
                return _loc_2;
            }
            return 0;
        }// end function

        public function releaseDisplayLock(param1:uint) : void
        {
            var _loc_2:* = FGearDisplay(this._gears[0]);
            if (_loc_2 && _loc_2.controller)
            {
                _loc_2.releaseLock(param1);
                this.checkGearDisplay();
            }
            return;
        }// end function

        public function checkGearDisplay() : void
        {
            if (this._handlingController)
            {
                return;
            }
            var _loc_1:* = this._gears[0] == null || FGearDisplay(this._gears[0]).connected;
            if (this._gears[8] != null)
            {
                _loc_1 = FGearDisplay2(this._gears[8]).evaluate(_loc_1);
            }
            if (_loc_1 != this._internalVisible)
            {
                this._internalVisible = _loc_1;
                if (this._parent)
                {
                    this._parent.updateDisplayList();
                    if (this._group)
                    {
                        this._group.refresh();
                    }
                }
            }
            return;
        }// end function

        public function get relations() : FRelations
        {
            return this._relations;
        }// end function

        public function get dispatcher() : DispatcherLite
        {
            return this._dispatcher;
        }// end function

        public function get displayObject() : FSprite
        {
            return this._displayObject;
        }// end function

        public function get parent() : FComponent
        {
            return this._parent;
        }// end function

        public function removeFromParent() : void
        {
            if (this._parent)
            {
                this._parent.removeChild(this);
            }
            return;
        }// end function

        public function localToGlobal(param1:Number = 0, param2:Number = 0) : Point
        {
            if (this._anchor)
            {
                param1 = param1 + this._pivotX * this._width;
                param2 = param2 + this._pivotY * this._height;
            }
            sHelperPoint.x = param1;
            sHelperPoint.y = param2;
            return this._displayObject.rootContainer.localToGlobal(sHelperPoint);
        }// end function

        public function globalToLocal(param1:Number = 0, param2:Number = 0) : Point
        {
            sHelperPoint.x = param1;
            sHelperPoint.y = param2;
            var _loc_3:* = this._displayObject.rootContainer.globalToLocal(sHelperPoint);
            if (this._anchor)
            {
                _loc_3.x = _loc_3.x - this._pivotX * this._width;
                _loc_3.y = _loc_3.y - this._pivotY * this._height;
            }
            return _loc_3;
        }// end function

        public function handleXYChanged() : void
        {
            this._displayObject.handleXYChanged();
            return;
        }// end function

        public function handleSizeChanged() : void
        {
            this._displayObject.handleSizeChanged();
            return;
        }// end function

        public function handleTouchableChanged() : void
        {
            if ((this._flags & FObjectFlags.INSPECTING) != 0)
            {
                if (this._locked)
                {
                    this._displayObject.mouseChildren = false;
                }
                else
                {
                    this._displayObject.mouseChildren = true;
                }
            }
            else if (this._touchDisabled)
            {
                this._displayObject.mouseChildren = false;
            }
            else
            {
                this._displayObject.mouseChildren = this._touchable;
            }
            return;
        }// end function

        public function handleGrayedChanged() : void
        {
            this._displayObject.applyFilter();
            return;
        }// end function

        public function handleAlphaChanged() : void
        {
            this._displayObject.container.alpha = this._alpha;
            return;
        }// end function

        public function handleVisibleChanged() : void
        {
            this._displayObject.visible = this.internalVisible2;
            return;
        }// end function

        public function handleControllerChanged(param1:FController) : void
        {
            var _loc_3:* = null;
            this._handlingController = true;
            var _loc_2:* = 0;
            while (_loc_2 <= MAX_GEAR_INDEX)
            {
                
                _loc_3 = this._gears[_loc_2];
                if (_loc_3 != null && _loc_3.controllerObject == param1)
                {
                    _loc_3.apply();
                }
                _loc_2++;
            }
            this._handlingController = false;
            this.checkGearDisplay();
            return;
        }// end function

        public function getProp(param1:int)
        {
            switch(param1)
            {
                case ObjectPropID.Text:
                {
                    return this.text;
                }
                case ObjectPropID.Icon:
                {
                    return this.icon;
                }
                case ObjectPropID.Color:
                {
                    return 0;
                }
                case ObjectPropID.OutlineColor:
                {
                    return 0;
                }
                case ObjectPropID.Playing:
                {
                    return false;
                }
                case ObjectPropID.Frame:
                {
                    return 0;
                }
                case ObjectPropID.DeltaTime:
                {
                    return 0;
                }
                case ObjectPropID.TimeScale:
                {
                    return 1;
                }
                case ObjectPropID.FontSize:
                {
                    return 0;
                }
                default:
                {
                    return undefined;
                    break;
                }
            }
        }// end function

        public function setProp(param1:int, param2) : void
        {
            switch(param1)
            {
                case ObjectPropID.Text:
                {
                    this.text = param2;
                    break;
                }
                case ObjectPropID.Icon:
                {
                    this.icon = param2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get deprecated() : Boolean
        {
            if (this._res)
            {
                return this._res.deprecated;
            }
            return false;
        }// end function

        public function validate(param1:Boolean = false) : Boolean
        {
            if (this.deprecated)
            {
                if (!param1)
                {
                    this.recreate();
                }
                return true;
            }
            else
            {
                if (this is FComponent)
                {
                    return FComponent(this).validateChildren(param1);
                }
            }
            return false;
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

        override public function toString() : String
        {
            var _loc_1:* = null;
            if (this._name)
            {
                _loc_1 = this._name;
            }
            else
            {
                _loc_1 = "";
            }
            if (this._res)
            {
                _loc_1 = _loc_1 + (" {" + this._res.name + "}");
            }
            return _loc_1;
        }// end function

        public function getDetailString() : String
        {
            if (this._res)
            {
                return this._res.desc;
            }
            return "";
        }// end function

        public function get errorStatus() : Boolean
        {
            return this._displayObject.errorStatus;
        }// end function

        public function set errorStatus(param1:Boolean) : void
        {
            if (param1)
            {
                if (this.sourceWidth == 0 || this.sourceHeight == 0)
                {
                    this.sourceWidth = 100;
                    this.sourceHeight = 100;
                    this.setSize(this.sourceWidth, this.sourceHeight);
                }
            }
            this.displayObject.errorStatus = param1;
            return;
        }// end function

        public function get editor() : IEditor
        {
            return this._pkg.project.editor as IEditor;
        }// end function

        public function get topmost() : FComponent
        {
            var _loc_1:* = this._parent;
            if (!_loc_1 && this is FComponent)
            {
                return FComponent(this);
            }
            while (true)
            {
                
                if (!_loc_1._parent)
                {
                    break;
                }
                _loc_1 = _loc_1._parent;
            }
            return _loc_1;
        }// end function

        final public function create() : void
        {
            this.handleCreate();
            return;
        }// end function

        protected function handleCreate() : void
        {
            return;
        }// end function

        final public function dispose() : void
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._relations.reset();
            this._dispatcher.offAll();
            this.handleDispose();
            if (this._res)
            {
                this._res.release();
                this._res = null;
            }
            return;
        }// end function

        protected function handleDispose() : void
        {
            return;
        }// end function

        public function recreate() : void
        {
            var _loc_1:* = this._width;
            var _loc_2:* = this._height;
            var _loc_3:* = this.write();
            this._name = "";
            this._alpha = 1;
            this._rotation = 0;
            this._visible = true;
            this._touchable = true;
            this._grayed = false;
            this._anchor = false;
            var _loc_5:* = 0;
            this.sourceHeight = 0;
            this.sourceWidth = _loc_5;
            this.initHeight = _loc_5;
            this.initWidth = _loc_5;
            var _loc_5:* = 0;
            this._maxHeight = 0;
            this._minHeight = _loc_5;
            this._maxWidth = _loc_5;
            this._minWidth = _loc_5;
            var _loc_5:* = 0;
            this._pivotY = 0;
            this._pivotX = _loc_5;
            this._relations.reset();
            this._displayObject.reset();
            if (this._res)
            {
                this._res.update();
            }
            this._underConstruct = true;
            this.handleCreate();
            var _loc_4:* = _loc_3.getAttribute("size");
            if (_loc_3.getAttribute("size"))
            {
                if (this.relations.widthLocked && this.relations.heightLocked)
                {
                    _loc_3.removeAttribute("size");
                }
                else if (this.relations.widthLocked)
                {
                    _loc_3.setAttribute("size", this.sourceWidth + "," + _loc_2);
                }
                else if (this.relations.heightLocked)
                {
                    _loc_3.setAttribute("size", _loc_1 + "," + this.sourceHeight);
                }
            }
            this.read_beforeAdd(_loc_3, null);
            this._relations.read(_loc_3);
            this.read_afterAdd(_loc_3, null);
            this._underConstruct = false;
            return;
        }// end function

        public function read_beforeAdd(param1:XData, param2:Object) : void
        {
            var _loc_3:* = null;
            var _loc_5:* = undefined;
            this._id = param1.getAttribute("id");
            this._name = param1.getAttribute("name");
            this._aspectLocked = param1.getAttributeBool("aspect");
            this.visible = param1.getAttributeBool("visible", true);
            this.touchable = param1.getAttributeBool("touchable", true);
            this.grayed = param1.getAttributeBool("grayed");
            _loc_3 = param1.getAttribute("xy");
            var _loc_4:* = _loc_3.split(",");
            this.setXY(int(_loc_4[0]), int(_loc_4[1]));
            _loc_3 = param1.getAttribute("pivot");
            if (_loc_3)
            {
                _loc_4 = _loc_3.split(",");
                this.setPivot(parseFloat(_loc_4[0]), parseFloat(_loc_4[1]), param1.getAttributeBool("anchor"));
            }
            else if (this._pivotX != 0 || this._pivotY != 0)
            {
                this.applyPivot();
            }
            _loc_3 = param1.getAttribute("size");
            if (_loc_3)
            {
                this._useSourceSize = false;
                _loc_4 = _loc_3.split(",");
                this.initWidth = int(_loc_4[0]);
                this.initHeight = int(_loc_4[1]);
                this.setSize(this.initWidth, this.initHeight, true, true);
                if (this._aspectLocked)
                {
                    this._aspectRatio = this._width / this._height;
                }
            }
            else
            {
                this.useSourceSize = true;
                this.initWidth = this.sourceWidth;
                this.initHeight = this.sourceHeight;
            }
            _loc_3 = param1.getAttribute("restrictSize");
            if (_loc_3)
            {
                _loc_4 = _loc_3.split(",");
                this._minWidth = int(_loc_4[0]);
                this._maxWidth = int(_loc_4[1]);
                this._minHeight = int(_loc_4[2]);
                this._maxHeight = int(_loc_4[3]);
                this._restrictSizeFromSource = false;
            }
            _loc_3 = param1.getAttribute("scale");
            if (_loc_3)
            {
                _loc_4 = _loc_3.split(",");
                this.setScale(parseFloat(_loc_4[0]), parseFloat(_loc_4[1]));
            }
            _loc_3 = param1.getAttribute("skew");
            if (_loc_3)
            {
                _loc_4 = _loc_3.split(",");
                this.setSkew(parseFloat(_loc_4[0]), parseFloat(_loc_4[1]));
            }
            _loc_3 = param1.getAttribute("alpha");
            if (_loc_3)
            {
                this.alpha = parseFloat(_loc_3);
            }
            else
            {
                this.alpha = 1;
            }
            _loc_3 = param1.getAttribute("rotation");
            if (_loc_3)
            {
                this.rotation = parseFloat(_loc_3);
            }
            else
            {
                this.rotation = 0;
            }
            _loc_3 = param1.getAttribute("tooltips");
            if (_loc_3)
            {
                if (param2)
                {
                    _loc_5 = param2[this._id + "-tips"];
                    if (_loc_5 != undefined)
                    {
                        _loc_3 = _loc_5;
                    }
                }
                this.tooltips = _loc_3;
            }
            _loc_3 = param1.getAttribute("blend");
            if (_loc_3)
            {
                this.blendMode = _loc_3;
            }
            this._filterData.read(param1);
            this._displayObject.applyFilter();
            this.customData = param1.getAttribute("customData");
            return;
        }// end function

        public function read_afterAdd(param1:XData, param2:Object) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_3:* = param1.getAttribute("group");
            if (_loc_3)
            {
                this.groupId = _loc_3;
            }
            var _loc_4:* = param1.getChildren();
            for each (_loc_5 in _loc_4)
            {
                
                _loc_6 = FGearBase.getIndexByName(_loc_5.getName());
                if (_loc_6 != -1)
                {
                    this.getGear(_loc_6).read(_loc_5, param2);
                }
            }
            return;
        }// end function

        public function write() : XData
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_1:* = this is FGroup && !FGroup(this).advanced;
            var _loc_2:* = XData.create(this._objectType);
            _loc_2.setAttribute("id", this._id);
            _loc_2.setAttribute("name", this._name);
            if (this._res)
            {
                if (this._res.packageItem)
                {
                    _loc_2.setAttribute("src", this._res.packageItem.id);
                    _loc_2.setAttribute("fileName", (this._res.packageItem.path + this._res.packageItem.fileName).substr(1));
                    if (this._parent && this._pkg != this._parent._pkg)
                    {
                        _loc_2.setAttribute("pkg", this._pkg.id);
                    }
                }
                else
                {
                    if (this._res.missingInfo.pkgId)
                    {
                        _loc_2.setAttribute("pkg", this._res.missingInfo.pkgId);
                    }
                    _loc_2.setAttribute("src", this._res.missingInfo.itemId);
                    _loc_2.setAttribute("fileName", this._res.missingInfo.fileName);
                }
            }
            _loc_2.setAttribute("xy", int(this._x) + "," + int(this._y));
            if (!this._pivotFromSource && (this._pivotX != 0 || this._pivotY != 0))
            {
                _loc_2.setAttribute("pivot", UtilsStr.toFixed(this._pivotX) + "," + UtilsStr.toFixed(this._pivotY));
                if (this._anchor)
                {
                    _loc_2.setAttribute("anchor", true);
                }
            }
            if (!this._parent || !(this._parent is FList))
            {
                if (!this._useSourceSize)
                {
                    _loc_2.setAttribute("size", int(this._width) + "," + int(this._height));
                }
            }
            if (!this._restrictSizeFromSource && (this._minWidth != 0 || this._maxWidth != 0 || this._minHeight != 0 || this._maxHeight != 0))
            {
                _loc_2.setAttribute("restrictSize", this._minWidth + "," + this._maxWidth + "," + this._minHeight + "," + this._maxHeight);
            }
            if (this._group)
            {
                _loc_2.setAttribute("group", this._groupId);
            }
            if (this._aspectLocked)
            {
                _loc_2.setAttribute("aspect", true);
            }
            if (this._scaleX != 1 || this._scaleY != 1)
            {
                _loc_2.setAttribute("scale", UtilsStr.toFixed(this._scaleX) + "," + UtilsStr.toFixed(this._scaleY));
            }
            if (this._skewX != 0 || this._skewY != 0)
            {
                _loc_2.setAttribute("skew", UtilsStr.toFixed(this._skewX) + "," + UtilsStr.toFixed(this._skewY));
            }
            if (!this._visible && !_loc_1)
            {
                _loc_2.setAttribute("visible", false);
            }
            if (this._alpha != 1)
            {
                _loc_2.setAttribute("alpha", UtilsStr.toFixed(this._alpha));
            }
            if (this._rotation != 0)
            {
                _loc_2.setAttribute("rotation", UtilsStr.toFixed(this._rotation));
            }
            if (!this._touchable && !this._touchDisabled)
            {
                _loc_2.setAttribute("touchable", false);
            }
            if (this._grayed)
            {
                _loc_2.setAttribute("grayed", true);
            }
            if (this._blendMode != "normal")
            {
                _loc_2.setAttribute("blend", this._blendMode);
            }
            this._filterData.write(_loc_2);
            if (this._tooltips)
            {
                _loc_2.setAttribute("tooltips", this._tooltips);
            }
            if (this.customData)
            {
                _loc_2.setAttribute("customData", this.customData);
            }
            if (!_loc_1)
            {
                _loc_3 = 0;
                while (_loc_3 <= MAX_GEAR_INDEX)
                {
                    
                    if (this._gears[_loc_3] != null && this._gears[_loc_3].controllerObject && this._gears[_loc_3].controllerObject.parent)
                    {
                        _loc_2.appendChild(this._gears[_loc_3].write());
                    }
                    _loc_3++;
                }
                if (!this._relations.isEmpty)
                {
                    for each (_loc_4 in this._relations.write().getChildren())
                    {
                        
                        _loc_2.appendChild(_loc_4);
                    }
                }
            }
            return _loc_2;
        }// end function

        public function takeSnapshot(param1:ObjectSnapshot) : void
        {
            param1.x = this._x;
            param1.y = this._y;
            param1.width = this._rawWidth;
            param1.height = this._rawHeight;
            param1.scaleX = this._scaleX;
            param1.scaleY = this._scaleY;
            param1.skewX = this._skewX;
            param1.skewY = this._skewY;
            param1.pivotX = this._pivotX;
            param1.pivotY = this._pivotY;
            param1.anchor = this._anchor;
            param1.alpha = this._alpha;
            param1.rotation = this._rotation;
            param1.visible = this._visible;
            param1.color = this.getProp(ObjectPropID.Color);
            param1.playing = this.getProp(ObjectPropID.Playing);
            param1.frame = this.getProp(ObjectPropID.Frame);
            param1.filterData.copyFrom(this._filterData);
            param1.text = this.text;
            param1.icon = this.icon;
            return;
        }// end function

        public function readSnapshot(param1:ObjectSnapshot) : void
        {
            loadingSnapshot = true;
            this.setPivot(param1.pivotX, param1.pivotY, param1.anchor);
            this.setSize(param1.width, param1.height, false, true);
            this.rotation = param1.rotation;
            this.setXY(param1.x, param1.y);
            this.setScale(param1.scaleX, param1.scaleY);
            this.setSkew(param1.skewX, param1.skewY);
            this.alpha = param1.alpha;
            this.visible = param1.visible;
            this.setProp(ObjectPropID.Color, param1.color);
            this.setProp(ObjectPropID.Playing, param1.playing);
            this.setProp(ObjectPropID.Frame, param1.frame);
            this._filterData.copyFrom(param1.filterData);
            if (param1.text != this.text)
            {
                this.text = param1.text;
            }
            if (param1.icon != this.icon)
            {
                this.icon = param1.icon;
            }
            this._displayObject.applyFilter();
            loadingSnapshot = false;
            return;
        }// end function

        public function get isDown() : Boolean
        {
            return this._buttonStatus == 1;
        }// end function

        public function triggerDown() : void
        {
            this._buttonStatus = 1;
            this._displayObject.stage.addEventListener(MouseEvent.MOUSE_UP, this.__stageMouseup, false, 20);
            if ((this._flags & FObjectFlags.IN_TEST) != 0 && hasEventListener(GTouchEvent.DRAG))
            {
                this._displayObject.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.__mousemove);
            }
            return;
        }// end function

        private function initMTouch() : void
        {
            this._displayObject.addEventListener(MouseEvent.MOUSE_DOWN, this.__mousedown);
            this._displayObject.addEventListener(MouseEvent.MOUSE_UP, this.__mouseup);
            return;
        }// end function

        private function __mousedown(event:Event) : void
        {
            if ((this._flags & FObjectFlags.IN_TEST) == 0)
            {
                return;
            }
            var _loc_2:* = new GTouchEvent(GTouchEvent.BEGIN);
            _loc_2.copyFrom(event);
            this.dispatchEvent(_loc_2);
            if (_loc_2.isPropagationStop)
            {
                event.stopPropagation();
            }
            if (this._touchDownPoint == null)
            {
                this._touchDownPoint = new Point();
            }
            this._touchDownPoint.x = MouseEvent(event).stageX;
            this._touchDownPoint.y = MouseEvent(event).stageY;
            this.triggerDown();
            return;
        }// end function

        private function __mousemove(event:Event) : void
        {
            if (this._buttonStatus != 1)
            {
                return;
            }
            var _loc_2:* = UIConfig.clickDragSensitivity;
            if (this._touchDownPoint != null && Math.abs(this._touchDownPoint.x - MouseEvent(event).stageX) < _loc_2 && Math.abs(this._touchDownPoint.y - MouseEvent(event).stageY) < _loc_2)
            {
                return;
            }
            var _loc_3:* = new GTouchEvent(GTouchEvent.DRAG);
            _loc_3.copyFrom(event);
            this.dispatchEvent(_loc_3);
            if (_loc_3.isPropagationStop)
            {
                event.stopPropagation();
            }
            return;
        }// end function

        private function __mouseup(event:Event) : void
        {
            if (this._buttonStatus != 1)
            {
                return;
            }
            this._buttonStatus = 2;
            return;
        }// end function

        private function __stageMouseup(event:Event) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, this.__stageMouseup);
            if (this._buttonStatus == 2)
            {
                _loc_2 = 1;
                _loc_3 = getTimer();
                if (_loc_3 - this._lastClick < 500)
                {
                    _loc_2 = 2;
                    this._lastClick = 0;
                }
                else
                {
                    this._lastClick = _loc_3;
                }
                _loc_4 = new GTouchEvent(GTouchEvent.CLICK);
                _loc_4.copyFrom(event, _loc_2);
                this.dispatchEvent(_loc_4);
            }
            this._buttonStatus = 0;
            _loc_4 = new GTouchEvent(GTouchEvent.END);
            _loc_4.copyFrom(event);
            this.dispatchEvent(_loc_4);
            return;
        }// end function

        function cancelChildrenClickEvent() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = FComponent(this).numChildren;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = FComponent(this).getChildAt(_loc_2);
                _loc_3._buttonStatus = 0;
                if (_loc_3 is FComponent)
                {
                    _loc_3.cancelChildrenClickEvent();
                }
                _loc_2++;
            }
            return;
        }// end function

    }
}
