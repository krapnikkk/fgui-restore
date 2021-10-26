package fairygui.editor.gui
{
    import *.*;
    import fairygui.event.*;
    import fairygui.tween.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class FScrollPane extends Object
    {
        private var _owner:FComponent;
        private var _container:Sprite;
        private var _maskContainer:Sprite;
        private var _alignContainer:Sprite;
        private var _scrollType:String;
        private var _scrollStep:int;
        private var _mouseWheelStep:int;
        private var _decelerationRate:Number;
        private var _scrollBarMargin:FMargin;
        private var _bouncebackEffect:Boolean;
        private var _touchEffect:Boolean;
        private var _scrollBarDisplay:String;
        private var _vScrollNone:Boolean;
        private var _hScrollNone:Boolean;
        private var _displayOnLeft:Boolean;
        private var _snapToItem:Boolean;
        var _displayInDemand:Boolean;
        private var _mouseWheelEnabled:Boolean;
        private var _pageMode:Boolean;
        private var _inertiaDisabled:Boolean;
        private var _maskDisabled:Boolean;
        private var _floating:Boolean;
        private var _yPos:Number;
        private var _xPos:Number;
        private var _viewSize:Point;
        private var _contentSize:Point;
        private var _overlapSize:Point;
        private var _pageSize:Point;
        private var _tweening:int;
        private var _tweenTime:Point;
        private var _tweenDuration:Point;
        private var _tweenStart:Point;
        private var _tweenChange:Point;
        private var _isDragged:Boolean;
        private var _isHoldAreaDone:Boolean;
        private var _aniFlag:int;
        private var _containerPos:Point;
        private var _beginTouchPos:Point;
        private var _lastTouchPos:Point;
        private var _lastTouchGlobalPos:Point;
        private var _velocity:Point;
        private var _velocityScale:Number;
        private var _lastMoveTime:Number;
        private var _loop:int;
        private var _needRefresh:Boolean;
        private var _pageControllerFlag:Boolean;
        private var _hzScrollBar:FScrollBar;
        private var _vtScrollBar:FScrollBar;
        private var _header:FComponent;
        private var _footer:FComponent;
        private var _refreshBarAxis:String;
        private var _hover:Boolean;
        private var _savedHzScrollBar:FComponent;
        private var _savedVtScrollBar:FComponent;
        private var _installed:Boolean;
        public static const DISPLAY_ON_LEFT:int = 1;
        public static const SNAP_TO_ITEM:int = 2;
        public static const DISPLAY_IN_DEMAND:int = 4;
        public static const PAGE_MODE:int = 8;
        public static const TOUCH_EFFECT_ON:int = 16;
        public static const TOUCH_EFFECT_OFF:int = 32;
        public static const BOUNCE_BACK_EFFECT_ON:int = 64;
        public static const BOUNCE_BACK_EFFECT_OFF:int = 128;
        public static const INERTIA_DISABLED:int = 256;
        public static const MASK_DISABLED:int = 512;
        public static const FLOATING:int = 1024;
        private static const TWEEN_TIME_GO:Number = 0.5;
        private static const TWEEN_TIME_DEFAULT:Number = 0.3;
        private static const PULL_RATIO:Number = 0.5;
        private static var draggingPane:FScrollPane;
        private static var _gestureFlag:int;
        private static var sHelperPoint:Point = new Point();
        private static var sEndPos:Point = new Point();
        private static var sOldChange:Point = new Point();

        public function FScrollPane(param1:FComponent) : void
        {
            this._owner = param1;
            this._maskContainer = new Sprite();
            this._maskContainer.mouseEnabled = false;
            this._xPos = 0;
            this._yPos = 0;
            this._aniFlag = 0;
            this._viewSize = new Point();
            this._contentSize = new Point();
            this._pageSize = new Point(1, 1);
            this._overlapSize = new Point();
            this._tweenTime = new Point();
            this._tweenStart = new Point();
            this._tweenDuration = new Point();
            this._tweenChange = new Point();
            this._velocity = new Point();
            this._containerPos = new Point();
            this._beginTouchPos = new Point();
            this._lastTouchPos = new Point();
            this._lastTouchGlobalPos = new Point();
            this._scrollStep = 25;
            this._mouseWheelStep = this._scrollStep * 2;
            this._decelerationRate = 0.967;
            draggingPane = null;
            _gestureFlag = 0;
            this.install();
            return;
        }// end function

        public function dispose() : void
        {
            if (this._hzScrollBar)
            {
                this._hzScrollBar.owner.dispose();
            }
            if (this._savedHzScrollBar)
            {
                this._savedHzScrollBar.dispose();
            }
            if (this._vtScrollBar)
            {
                this._vtScrollBar.owner.dispose();
            }
            if (this._savedVtScrollBar)
            {
                this._savedVtScrollBar.dispose();
            }
            if (this._header)
            {
                this._header.dispose();
            }
            if (this._footer)
            {
                this._footer.dispose();
            }
            return;
        }// end function

        public function install() : void
        {
            if (this._installed)
            {
                return;
            }
            this._installed = true;
            this._container = this._owner.displayObject.container;
            this._container.x = 0;
            this._container.y = 0;
            this._container.mouseEnabled = false;
            this._maskContainer.addChild(this._container);
            this._owner.displayObject.rootContainer.addChildAt(this._maskContainer, 0);
            var _loc_1:* = this._owner.scrollBarFlags;
            this._displayOnLeft = (_loc_1 & 1) != 0;
            this._snapToItem = (_loc_1 & 2) != 0;
            this._displayInDemand = (_loc_1 & 4) != 0;
            this._pageMode = (_loc_1 & 8) != 0;
            if (_loc_1 & 32)
            {
                this._touchEffect = false;
            }
            else
            {
                this._touchEffect = true;
            }
            if (_loc_1 & 128)
            {
                this._bouncebackEffect = false;
            }
            else
            {
                this._bouncebackEffect = true;
            }
            this._scrollType = this._owner.scroll;
            this._scrollBarDisplay = this._owner.scrollBarDisplay;
            this._mouseWheelEnabled = true;
            this._inertiaDisabled = (_loc_1 & 256) != 0;
            this._maskDisabled = (_loc_1 & 512) != 0;
            this._floating = (_loc_1 & 1024) != 0;
            this._scrollBarMargin = this._owner.scrollBarMargin;
            if (!this._maskDisabled)
            {
                this._maskContainer.scrollRect = new Rectangle();
            }
            this.createScrollBars();
            if ((this._owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                if (this._owner.headerRes)
                {
                    this._header = this.createHeaderOrFooter(this._owner.headerRes);
                }
                if (this._owner.footerRes)
                {
                    this._footer = this.createHeaderOrFooter(this._owner.footerRes);
                }
                if (this._header || this._footer)
                {
                    this._refreshBarAxis = this._scrollType == "both" || this._scrollType == "vertical" ? ("y") : ("x");
                }
            }
            this.setSize(this.owner.width, this.owner.height);
            if ((this._owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                this._owner.displayObject.rootContainer.addEventListener(MouseEvent.MOUSE_WHEEL, this.__mouseWheel);
                this._owner.addEventListener(GTouchEvent.BEGIN, this.__mouseDown);
                this._owner.addEventListener(GTouchEvent.END, this.__mouseUp);
            }
            return;
        }// end function

        public function uninstall() : void
        {
            if (!this._installed)
            {
                return;
            }
            this._installed = false;
            if ((this._owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                this._owner.displayObject.rootContainer.removeEventListener(MouseEvent.MOUSE_WHEEL, this.__mouseWheel);
                this._owner.removeEventListener(GTouchEvent.BEGIN, this.__mouseDown);
                this._owner.removeEventListener(GTouchEvent.DRAG, this.__mouseMove);
                this._owner.removeEventListener(GTouchEvent.END, this.__mouseUp);
            }
            this._owner.displayObject.rootContainer.removeChild(this._maskContainer);
            if (this._vtScrollBar)
            {
                this._owner.displayObject.rootContainer.removeChild(this._vtScrollBar.owner.displayObject);
            }
            if (this._hzScrollBar)
            {
                this._owner.displayObject.rootContainer.removeChild(this._hzScrollBar.owner.displayObject);
            }
            this._container.x = 0;
            this._container.y = 0;
            this._owner.displayObject.rootContainer.addChildAt(this._container, 0);
            if (draggingPane == this)
            {
                draggingPane = null;
            }
            return;
        }// end function

        public function get installed() : Boolean
        {
            return this._installed;
        }// end function

        public function get vtScrollBar() : FScrollBar
        {
            return this._vtScrollBar;
        }// end function

        public function get hzScrollBar() : FScrollBar
        {
            return this._hzScrollBar;
        }// end function

        private function createScrollBars() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (this._hzScrollBar)
            {
                if (this._hzScrollBar.owner.displayObject.parent)
                {
                    this._owner.displayObject.rootContainer.removeChild(this._hzScrollBar.owner.displayObject);
                }
                this._savedHzScrollBar = this._hzScrollBar.owner;
            }
            if (this._vtScrollBar)
            {
                if (this._vtScrollBar.owner.displayObject.parent)
                {
                    this._owner.displayObject.rootContainer.removeChild(this._vtScrollBar.owner.displayObject);
                }
                this._savedVtScrollBar = this._vtScrollBar.owner;
            }
            this._hzScrollBar = null;
            this._vtScrollBar = null;
            var _loc_1:* = this._owner.scrollBarDisplay;
            if (_loc_1 == ScrollBarDisplayConst.DEFAULT)
            {
                _loc_1 = this._owner._pkg.project.getSetting("common", "defaultScrollBarDisplay");
            }
            if (_loc_1 != "hidden")
            {
                if (this._scrollType == "both" || this._scrollType == "vertical")
                {
                    _loc_2 = this._owner.vtScrollBarRes ? (this._owner.vtScrollBarRes) : (this._owner._pkg.project.getSetting("common", "verticalScrollBar"));
                    if (!this._savedVtScrollBar || this._savedVtScrollBar.resourceURL != _loc_2)
                    {
                        _loc_3 = this.createScrollBar(_loc_2);
                        if (_loc_3)
                        {
                            this._vtScrollBar = FScrollBar(_loc_3.extention);
                            this._vtScrollBar.setScrollPane(this, true);
                            this._owner.displayObject.rootContainer.addChildAt(_loc_3.displayObject, 1);
                        }
                    }
                    else
                    {
                        this._vtScrollBar = FScrollBar(this._savedVtScrollBar.extention);
                        this._owner.displayObject.rootContainer.addChildAt(this._vtScrollBar.owner.displayObject, 1);
                    }
                }
                if (this._scrollType == "both" || this._scrollType == "horizontal")
                {
                    _loc_2 = this._owner.hzScrollBarRes ? (this._owner.hzScrollBarRes) : (this._owner._pkg.project.getSetting("common", "horizontalScrollBar"));
                    if (!this._savedHzScrollBar || this._savedHzScrollBar.resourceURL != _loc_2)
                    {
                        _loc_3 = this.createScrollBar(_loc_2);
                        if (_loc_3)
                        {
                            this._hzScrollBar = FScrollBar(_loc_3.extention);
                            this._hzScrollBar.setScrollPane(this, false);
                            this._owner.displayObject.rootContainer.addChildAt(_loc_3.displayObject, 1);
                        }
                    }
                    else
                    {
                        this._hzScrollBar = FScrollBar(this._savedHzScrollBar.extention);
                        this._owner.displayObject.rootContainer.addChildAt(this._hzScrollBar.owner.displayObject, 1);
                    }
                }
                if ((this._owner._flags & FObjectFlags.IN_TEST) != 0)
                {
                    this._owner.displayObject.rootContainer.addEventListener(MouseEvent.ROLL_OVER, this.__rollOver);
                    this._owner.displayObject.rootContainer.addEventListener(MouseEvent.ROLL_OUT, this.__rollOut);
                }
            }
            else
            {
                this._mouseWheelEnabled = false;
            }
            if (this._savedVtScrollBar && this._vtScrollBar)
            {
                if (this._savedVtScrollBar != this._vtScrollBar.owner)
                {
                    this._savedVtScrollBar.dispose();
                }
                this._savedVtScrollBar = null;
            }
            if (this._savedHzScrollBar && this._hzScrollBar)
            {
                if (this._savedHzScrollBar != this._hzScrollBar.owner)
                {
                    this._savedHzScrollBar.dispose();
                }
                this._savedHzScrollBar = null;
            }
            return;
        }// end function

        private function createScrollBar(param1:String) : FComponent
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (param1)
            {
                _loc_2 = this._owner._pkg.project.getItemByURL(param1);
                if (_loc_2 == null)
                {
                    return null;
                }
                _loc_3 = FObjectFactory.createObject(_loc_2, this._owner._flags & 255) as FComponent;
                if (_loc_3 != null && !(_loc_3.extention is FScrollBar))
                {
                    _loc_3.dispose();
                    _loc_3 = null;
                }
                return _loc_3;
            }
            else
            {
                return null;
            }
        }// end function

        private function createHeaderOrFooter(param1:String) : FComponent
        {
            var _loc_2:* = null;
            if (param1)
            {
                _loc_2 = this._owner._pkg.project.getItemByURL(param1);
                if (_loc_2 == null)
                {
                    return null;
                }
                return FObjectFactory.createObject(_loc_2, this._owner._flags & 255) as FComponent;
            }
            else
            {
                return null;
            }
        }// end function

        public function get owner() : FComponent
        {
            return this._owner;
        }// end function

        public function get percX() : Number
        {
            return this._overlapSize.x == 0 ? (0) : (this._xPos / this._overlapSize.x);
        }// end function

        public function set percX(param1:Number) : void
        {
            this.setPercX(param1, false);
            return;
        }// end function

        public function setPercX(param1:Number, param2:Boolean = false) : void
        {
            this._owner.ensureBoundsCorrect();
            this.setPosX(this._overlapSize.x * Utils.clamp01(param1), param2);
            return;
        }// end function

        public function get percY() : Number
        {
            return this._overlapSize.y == 0 ? (0) : (this._yPos / this._overlapSize.y);
        }// end function

        public function set percY(param1:Number) : void
        {
            this.setPercY(param1, false);
            return;
        }// end function

        public function setPercY(param1:Number, param2:Boolean = false) : void
        {
            this._owner.ensureBoundsCorrect();
            this.setPosY(this._overlapSize.y * Utils.clamp01(param1), param2);
            return;
        }// end function

        public function get posX() : Number
        {
            return this._xPos;
        }// end function

        public function set posX(param1:Number) : void
        {
            this.setPosX(param1, false);
            return;
        }// end function

        public function setPosX(param1:Number, param2:Boolean = false) : void
        {
            this._owner.ensureBoundsCorrect();
            if (this._loop == 1 && this._overlapSize.x > 0)
            {
                if (param1 < 0.001)
                {
                    param1 = param1 + this._contentSize.x / 2;
                }
                else if (param1 >= this._overlapSize.x)
                {
                    param1 = param1 - this._contentSize.x / 2;
                }
            }
            param1 = Utils.clamp(param1, 0, this._overlapSize.x);
            if (param1 != this._xPos)
            {
                this._xPos = param1;
                if (this._pageMode)
                {
                    this.updatePageController();
                }
                this.posChanged(param2);
            }
            return;
        }// end function

        public function get posY() : Number
        {
            return this._yPos;
        }// end function

        public function set posY(param1:Number) : void
        {
            this.setPosY(param1, false);
            return;
        }// end function

        public function setPosY(param1:Number, param2:Boolean = false) : void
        {
            this._owner.ensureBoundsCorrect();
            if (this._loop == 2 && this._overlapSize.y > 0)
            {
                if (param1 < 0.001)
                {
                    param1 = param1 + this._contentSize.y / 2;
                }
                else if (param1 >= this._overlapSize.y)
                {
                    param1 = param1 - this._contentSize.y / 2;
                }
            }
            param1 = Utils.clamp(param1, 0, this._overlapSize.y);
            if (param1 != this._yPos)
            {
                this._yPos = param1;
                if (this._pageMode)
                {
                    this.updatePageController();
                }
                this.posChanged(param2);
            }
            return;
        }// end function

        public function get contentWidth() : Number
        {
            return this._contentSize.x;
        }// end function

        public function get contentHeight() : Number
        {
            return this._contentSize.y;
        }// end function

        public function get viewWidth() : int
        {
            return this._viewSize.x;
        }// end function

        public function set viewWidth(param1:int) : void
        {
            param1 = param1 + this._owner.margin.left + this._owner.margin.right;
            if (this._vtScrollBar != null && !this._floating)
            {
                param1 = param1 + this._vtScrollBar.owner.width;
            }
            this._owner.width = param1;
            return;
        }// end function

        public function get viewHeight() : int
        {
            return this._viewSize.y;
        }// end function

        public function set viewHeight(param1:int) : void
        {
            param1 = param1 + this._owner.margin.top + this._owner.margin.bottom;
            if (this._hzScrollBar != null && !this._floating)
            {
                param1 = param1 + this._hzScrollBar.owner.height;
            }
            this._owner.height = param1;
            return;
        }// end function

        public function get pageX() : int
        {
            if (!this._pageMode)
            {
                return 0;
            }
            var _loc_1:* = Math.floor(this._xPos / this._pageSize.x);
            if (this._xPos - _loc_1 * this._pageSize.x > this._pageSize.x * 0.5)
            {
                _loc_1++;
            }
            return _loc_1;
        }// end function

        public function set pageX(param1:int) : void
        {
            this.setPageX(param1, false);
            return;
        }// end function

        public function setPageX(param1:int, param2:Boolean = false) : void
        {
            if (this._pageMode && this._overlapSize.x > 0)
            {
                this.setPosX(param1 * this._pageSize.x, param2);
            }
            return;
        }// end function

        public function get pageY() : int
        {
            if (!this._pageMode)
            {
                return 0;
            }
            var _loc_1:* = Math.floor(this._yPos / this._pageSize.y);
            if (this._yPos - _loc_1 * this._pageSize.y > this._pageSize.y * 0.5)
            {
                _loc_1++;
            }
            return _loc_1;
        }// end function

        public function set pageY(param1:int) : void
        {
            this.setPageY(param1, false);
            return;
        }// end function

        public function setPageY(param1:int, param2:Boolean = false) : void
        {
            if (this._pageMode && this._overlapSize.y > 0)
            {
                this.setPosY(param1 * this._pageSize.y, param2);
            }
            return;
        }// end function

        public function scrollTop(param1:Boolean = false) : void
        {
            this.setPercY(0, param1);
            return;
        }// end function

        public function scrollBottom(param1:Boolean = false) : void
        {
            this.setPercY(1, param1);
            return;
        }// end function

        public function scrollUp(param1:Number = 1, param2:Boolean = false) : void
        {
            if (this._pageMode)
            {
                this.setPosY(this._yPos - this._pageSize.y * param1, param2);
            }
            else
            {
                this.setPosY(this._yPos - this._scrollStep * param1, param2);
            }
            return;
        }// end function

        public function scrollDown(param1:Number = 1, param2:Boolean = false) : void
        {
            if (this._pageMode)
            {
                this.setPosY(this._yPos + this._pageSize.y * param1, param2);
            }
            else
            {
                this.setPosY(this._yPos + this._scrollStep * param1, param2);
            }
            return;
        }// end function

        public function scrollLeft(param1:Number = 1, param2:Boolean = false) : void
        {
            if (this._pageMode)
            {
                this.setPosX(this._xPos - this._pageSize.x * param1, param2);
            }
            else
            {
                this.setPosX(this._xPos - this._scrollStep * param1, param2);
            }
            return;
        }// end function

        public function scrollRight(param1:Number = 1, param2:Boolean = false) : void
        {
            if (this._pageMode)
            {
                this.setPosX(this._xPos + this._pageSize.x * param1, param2);
            }
            else
            {
                this.setPosX(this._xPos + this._scrollStep * param1, param2);
            }
            return;
        }// end function

        public function scrollToView(param1:FObject, param2:Boolean = false, param3:Boolean = false) : void
        {
            this._owner.ensureBoundsCorrect();
            if (this._needRefresh)
            {
                this.refresh();
            }
            var _loc_4:* = new Rectangle(param1.x, param1.y, param1.width, param1.height);
            this.scrollToView2(_loc_4, param2, param3);
            return;
        }// end function

        public function scrollToView2(param1:Rectangle, param2:Boolean = false, param3:Boolean = false) : void
        {
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            this._owner.ensureBoundsCorrect();
            if (this._needRefresh)
            {
                this.refresh();
            }
            if (this._overlapSize.y > 0)
            {
                _loc_4 = this._yPos + this._viewSize.y;
                if (param3 || param1.y <= this._yPos || param1.height >= this._viewSize.y)
                {
                    if (this._pageMode)
                    {
                        this.setPosY(Math.floor(param1.y / this._pageSize.y) * this._pageSize.y, param2);
                    }
                    else
                    {
                        this.setPosY(param1.y, param2);
                    }
                }
                else if (param1.y + param1.height > _loc_4)
                {
                    if (this._pageMode)
                    {
                        this.setPosY(Math.floor(param1.y / this._pageSize.y) * this._pageSize.y, param2);
                    }
                    else if (param1.height <= this._viewSize.y / 2)
                    {
                        this.setPosY(param1.y + param1.height * 2 - this._viewSize.y, param2);
                    }
                    else
                    {
                        this.setPosY(param1.y + param1.height - this._viewSize.y, param2);
                    }
                }
            }
            if (this._overlapSize.x > 0)
            {
                _loc_5 = this._xPos + this._viewSize.x;
                if (param3 || param1.x <= this._xPos || param1.width >= this._viewSize.x)
                {
                    if (this._pageMode)
                    {
                        this.setPosX(Math.floor(param1.x / this._pageSize.x) * this._pageSize.x, param2);
                    }
                    this.setPosX(param1.x, param2);
                }
                else if (param1.x + param1.width > _loc_5)
                {
                    if (this._pageMode)
                    {
                        this.setPosX(Math.floor(param1.x / this._pageSize.x) * this._pageSize.x, param2);
                    }
                    else if (param1.width <= this._viewSize.x / 2)
                    {
                        this.setPosX(param1.x + param1.width * 2 - this._viewSize.x, param2);
                    }
                    else
                    {
                        this.setPosX(param1.x + param1.width - this._viewSize.x, param2);
                    }
                }
            }
            if (!param2 && this._needRefresh)
            {
                this.refresh();
            }
            return;
        }// end function

        public function OnOwnerSizeChanged() : void
        {
            this.setSize(this._owner.width, this._owner.height);
            this.posChanged(false);
            return;
        }// end function

        public function onFlagsChanged(param1:Boolean = false) : void
        {
            var _loc_2:* = this._owner.scrollBarFlags;
            this._displayOnLeft = (_loc_2 & 1) != 0;
            this._displayInDemand = (_loc_2 & 4) != 0;
            this._maskDisabled = (_loc_2 & 512) != 0;
            this._floating = (_loc_2 & 1024) != 0;
            if (!this._maskDisabled)
            {
                this._maskContainer.scrollRect = new Rectangle();
            }
            else
            {
                this._maskContainer.scrollRect = null;
            }
            if (param1 || this._scrollType != this._owner.scroll || this._owner.scrollBarDisplay != this._scrollBarDisplay)
            {
                this._scrollType = this._owner.scroll;
                this._scrollBarDisplay = this._owner.scrollBarDisplay;
                this.createScrollBars();
            }
            return;
        }// end function

        public function validate(param1:Boolean = false) : Boolean
        {
            var _loc_2:* = false;
            if (this._hzScrollBar)
            {
                if (this._hzScrollBar.owner.validate(param1))
                {
                    _loc_2 = true;
                    if (!(this._hzScrollBar.owner.extention is FScrollBar))
                    {
                        this._hzScrollBar = null;
                    }
                }
            }
            else if (this._savedHzScrollBar)
            {
                if (this._savedHzScrollBar.validate(param1))
                {
                    _loc_2 = true;
                    if (!(this._savedHzScrollBar.extention is FScrollBar))
                    {
                        this._savedHzScrollBar = null;
                    }
                }
            }
            if (this._vtScrollBar)
            {
                if (this._vtScrollBar.owner.validate(param1))
                {
                    _loc_2 = true;
                    if (!(this._vtScrollBar.owner.extention is FScrollBar))
                    {
                        this._vtScrollBar = null;
                    }
                }
            }
            else if (this._savedVtScrollBar)
            {
                if (this._savedVtScrollBar.validate(param1))
                {
                    _loc_2 = true;
                    if (!(this._savedVtScrollBar.extention is FScrollBar))
                    {
                        this._savedVtScrollBar = null;
                    }
                }
            }
            return _loc_2;
        }// end function

        public function updateScrollRect() : void
        {
            var _loc_1:* = null;
            this._maskContainer.x = int(this._owner.margin.left);
            if (this._displayOnLeft && this._vtScrollBar && !this._floating)
            {
                this._maskContainer.x = this._maskContainer.x + this._vtScrollBar.owner.width;
            }
            this._maskContainer.y = int(this._owner.margin.top);
            if (!this._maskDisabled)
            {
                _loc_1 = this._maskContainer.scrollRect;
                _loc_1.width = this._viewSize.x;
                _loc_1.height = this._viewSize.y;
                if (this._vScrollNone && this._vtScrollBar)
                {
                    _loc_1.width = _loc_1.width + this._vtScrollBar.owner.width;
                }
                if (this._hScrollNone && this._hzScrollBar)
                {
                    _loc_1.height = _loc_1.height + this._hzScrollBar.owner.height;
                }
                this._maskContainer.scrollRect = _loc_1;
            }
            if (this._owner._alignOffset.x != 0 || this._owner._alignOffset.y != 0)
            {
                if (this._alignContainer == null)
                {
                    this._alignContainer = new Sprite();
                    this._alignContainer.mouseEnabled = false;
                    this._maskContainer.addChild(this._alignContainer);
                    this._alignContainer.addChild(this._container);
                }
                this._alignContainer.x = this._owner._alignOffset.x;
                this._alignContainer.y = this._owner._alignOffset.y;
            }
            else if (this._alignContainer)
            {
                var _loc_2:* = 0;
                this._alignContainer.y = 0;
                this._alignContainer.x = _loc_2;
            }
            return;
        }// end function

        private function setSize(param1:Number, param2:Number) : void
        {
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            _loc_3 = param1;
            _loc_4 = param2;
            if (this._hzScrollBar)
            {
                this._hzScrollBar.owner.y = param2 - this._hzScrollBar.owner.height;
                if (this._vtScrollBar)
                {
                    this._hzScrollBar.owner.width = param1 - this._vtScrollBar.owner.width - this._scrollBarMargin.left - this._scrollBarMargin.right;
                    if (this._displayOnLeft)
                    {
                        this._hzScrollBar.owner.x = this._scrollBarMargin.left + this._vtScrollBar.owner.width;
                    }
                    else
                    {
                        this._hzScrollBar.owner.x = this._scrollBarMargin.left;
                    }
                }
                else
                {
                    this._hzScrollBar.owner.width = param1 - this._scrollBarMargin.left - this._scrollBarMargin.right;
                    this._hzScrollBar.owner.x = this._scrollBarMargin.left;
                }
            }
            if (this._vtScrollBar)
            {
                if (!this._displayOnLeft)
                {
                    this._vtScrollBar.owner.x = param1 - this._vtScrollBar.owner.width;
                }
                else
                {
                    this._vtScrollBar.owner.x = 0;
                }
                if (this._hzScrollBar != null)
                {
                    this._vtScrollBar.owner.height = param2 - this._hzScrollBar.owner.height - this._scrollBarMargin.top - this._scrollBarMargin.bottom;
                }
                else
                {
                    this._vtScrollBar.owner.height = param2 - this._scrollBarMargin.top - this._scrollBarMargin.bottom;
                }
                this._vtScrollBar.owner.y = this._scrollBarMargin.top;
            }
            this._viewSize.x = param1;
            this._viewSize.y = param2;
            if (this._hzScrollBar != null && !this._floating)
            {
                this._viewSize.y = this._viewSize.y - this._hzScrollBar.owner.height;
            }
            if (this._vtScrollBar != null && !this._floating)
            {
                this._viewSize.x = this._viewSize.x - this._vtScrollBar.owner.width;
            }
            this._viewSize.x = this._viewSize.x - (this._owner.margin.left + this._owner.margin.right);
            this._viewSize.y = this._viewSize.y - (this._owner.margin.top + this._owner.margin.bottom);
            this._viewSize.x = Math.max(1, this._viewSize.x);
            this._viewSize.y = Math.max(1, this._viewSize.y);
            this._pageSize.x = this._viewSize.x;
            this._pageSize.y = this._viewSize.y;
            this.handleSizeChanged();
            return;
        }// end function

        function setContentSize(param1:Number, param2:Number) : void
        {
            if (this._contentSize.x == param1 && this._contentSize.y == param2)
            {
                return;
            }
            this._contentSize.x = param1;
            this._contentSize.y = param2;
            if (this._installed)
            {
                this.handleSizeChanged();
            }
            return;
        }// end function

        private function handleSizeChanged() : void
        {
            if (this._displayInDemand)
            {
                this._vScrollNone = this._contentSize.y <= this._viewSize.y;
                this._hScrollNone = this._contentSize.x <= this._viewSize.x;
            }
            if (this._vtScrollBar)
            {
                if (this._contentSize.y == 0)
                {
                    this._vtScrollBar.setDisplayPerc(0);
                }
                else
                {
                    this._vtScrollBar.setDisplayPerc(Math.min(1, this._viewSize.y / this._contentSize.y));
                }
            }
            if (this._hzScrollBar)
            {
                if (this._contentSize.x == 0)
                {
                    this._hzScrollBar.setDisplayPerc(0);
                }
                else
                {
                    this._hzScrollBar.setDisplayPerc(Math.min(1, this._viewSize.x / this._contentSize.x));
                }
            }
            this.updateScrollBarVisible();
            this.updateScrollRect();
            if (this._scrollType == "horizontal" || this._scrollType == "both")
            {
                this._overlapSize.x = Math.ceil(Math.max(0, this._contentSize.x - this._viewSize.x));
            }
            else
            {
                this._overlapSize.x = 0;
            }
            if (this._scrollType == "vertical" || this._scrollType == "both")
            {
                this._overlapSize.y = Math.ceil(Math.max(0, this._contentSize.y - this._viewSize.y));
            }
            else
            {
                this._overlapSize.y = 0;
            }
            this._xPos = Utils.clamp(this._xPos, 0, this._overlapSize.x);
            this._yPos = Utils.clamp(this._yPos, 0, this._overlapSize.y);
            this._container.x = Utils.clamp(this._container.x, -this._overlapSize.x, 0);
            this._container.y = Utils.clamp(this._container.y, -this._overlapSize.y, 0);
            if (this._header != null)
            {
                if (this._refreshBarAxis == "x")
                {
                    this._header.height = this._viewSize.y;
                }
                else
                {
                    this._header.width = this._viewSize.x;
                }
            }
            if (this._footer != null)
            {
                if (this._refreshBarAxis == "x")
                {
                    this._footer.height = this._viewSize.y;
                }
                else
                {
                    this._footer.width = this._viewSize.x;
                }
            }
            this.updateScrollBarPos();
            if (this._pageMode)
            {
                this.updatePageController();
            }
            return;
        }// end function

        private function posChanged(param1:Boolean) : void
        {
            if ((this._owner._flags & FObjectFlags.IN_TEST) == 0)
            {
                return;
            }
            if (this._aniFlag == 0)
            {
                this._aniFlag = param1 ? (1) : (-1);
            }
            else if (this._aniFlag == 1 && !param1)
            {
                this._aniFlag = -1;
            }
            this._needRefresh = true;
            GTimers.inst.callLater(this.refresh);
            return;
        }// end function

        private function updatePageController() : void
        {
            var _loc_1:* = 0;
            if (this._pageMode && (this._owner._flags & FObjectFlags.IN_TEST) != 0 && this.owner.pageControllerObj && !this._pageControllerFlag)
            {
                _loc_1 = this._overlapSize.y > 0 ? (this.pageY) : (this.pageX);
                if (_loc_1 < this.owner.pageControllerObj.pageCount)
                {
                    this._pageControllerFlag = true;
                    this.owner.pageControllerObj.selectedIndex = _loc_1;
                    this._pageControllerFlag = false;
                }
            }
            return;
        }// end function

        public function handleControllerChanged(param1:FController) : void
        {
            if (this._pageMode && (this._owner._flags & FObjectFlags.IN_TEST) != 0 && !this._pageControllerFlag)
            {
                this._pageControllerFlag = true;
                if (this._scrollType == "horizontal")
                {
                    this.setPageX(param1.selectedIndex, true);
                }
                else
                {
                    this.setPageY(param1.selectedIndex, true);
                }
                this._pageControllerFlag = false;
            }
            return;
        }// end function

        private function refresh() : void
        {
            if (this._owner == null)
            {
                return;
            }
            this._needRefresh = false;
            if (this._pageMode || this._snapToItem)
            {
                sEndPos.setTo(-this._xPos, -this._yPos);
                this.alignPosition(sEndPos, false);
                this._xPos = -sEndPos.x;
                this._yPos = -sEndPos.y;
                if (this._pageMode)
                {
                    this.updatePageController();
                }
            }
            if (this._isDragged)
            {
                GTimers.inst.callLater(this.refresh);
                return;
            }
            this.refresh2();
            if (this._needRefresh)
            {
                this._needRefresh = false;
                GTimers.inst.remove(this.refresh);
                this.refresh2();
            }
            this.updateScrollBarPos();
            this._aniFlag = 0;
            return;
        }// end function

        private function refresh2() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            if (this._aniFlag == 1 && !this._isDragged)
            {
                if (this._overlapSize.x > 0)
                {
                    _loc_1 = -int(this._xPos);
                }
                else
                {
                    if (this._container.x != 0)
                    {
                        this._container.x = 0;
                    }
                    _loc_1 = this._container.x;
                }
                if (this._overlapSize.y > 0)
                {
                    _loc_2 = -int(this._yPos);
                }
                else
                {
                    if (this._container.y != 0)
                    {
                        this._container.y = 0;
                    }
                    _loc_2 = this._container.y;
                }
                if (_loc_1 != this._container.x || _loc_2 != this._container.y)
                {
                    this._tweening = 1;
                    this._tweenTime.setTo(0, 0);
                    this._tweenDuration.setTo(TWEEN_TIME_GO, TWEEN_TIME_GO);
                    this._tweenStart.setTo(this._container.x, this._container.y);
                    this._tweenChange.setTo(_loc_1 - this._tweenStart.x, _loc_2 - this._tweenStart.y);
                    GTimers.inst.add(1, 0, this.__tweenUpdate);
                }
                else if (this._tweening != 0)
                {
                    this.killTween();
                }
            }
            else
            {
                if (this._tweening != 0)
                {
                    this.killTween();
                }
                this._container.x = int(-this._xPos);
                this._container.y = int(-this._yPos);
                this.loopCheckingCurrent();
            }
            return;
        }// end function

        private function __mouseDown(event:GTouchEvent) : void
        {
            if (!this._touchEffect)
            {
                return;
            }
            if (this._tweening != 0)
            {
                this.killTween();
            }
            sHelperPoint.setTo(event.stageX, event.stageY);
            var _loc_2:* = this._owner.displayObject.globalToLocal(sHelperPoint);
            this._containerPos.setTo(this._container.x, this._container.y);
            this._beginTouchPos.copyFrom(_loc_2);
            this._lastTouchPos.copyFrom(_loc_2);
            this._lastTouchGlobalPos.copyFrom(sHelperPoint);
            this._isHoldAreaDone = false;
            this._isDragged = false;
            this._velocity.setTo(0, 0);
            this._velocityScale = 1;
            this._lastMoveTime = getTimer();
            this._owner.addEventListener(GTouchEvent.DRAG, this.__mouseMove);
            return;
        }// end function

        private function __mouseMove(event:GTouchEvent) : void
        {
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_16:* = NaN;
            if (this._owner == null || !this._touchEffect)
            {
                return;
            }
            sHelperPoint.setTo(event.stageX, event.stageY);
            var _loc_2:* = this._owner.displayObject.globalToLocal(sHelperPoint);
            var _loc_3:* = 8;
            var _loc_6:* = false;
            var _loc_7:* = false;
            if (this._scrollType == "vertical")
            {
                if (!this._isHoldAreaDone)
                {
                    _gestureFlag = _gestureFlag | 1;
                    _loc_4 = Math.abs(this._beginTouchPos.y - _loc_2.y);
                    if (_loc_4 < _loc_3)
                    {
                        return;
                    }
                    if ((_gestureFlag & 2) != 0)
                    {
                        _loc_5 = Math.abs(this._beginTouchPos.x - _loc_2.x);
                        if (_loc_4 < _loc_5)
                        {
                            return;
                        }
                    }
                }
                _loc_6 = true;
            }
            else if (this._scrollType == "horizontal")
            {
                if (!this._isHoldAreaDone)
                {
                    _gestureFlag = _gestureFlag | 2;
                    _loc_4 = Math.abs(this._beginTouchPos.x - _loc_2.x);
                    if (_loc_4 < _loc_3)
                    {
                        return;
                    }
                    if ((_gestureFlag & 1) != 0)
                    {
                        _loc_5 = Math.abs(this._beginTouchPos.y - _loc_2.y);
                        if (_loc_4 < _loc_5)
                        {
                            return;
                        }
                    }
                }
                _loc_7 = true;
            }
            else
            {
                _gestureFlag = 3;
                if (!this._isHoldAreaDone)
                {
                    _loc_4 = Math.abs(this._beginTouchPos.y - _loc_2.y);
                    if (_loc_4 < _loc_3)
                    {
                        _loc_4 = Math.abs(this._beginTouchPos.x - _loc_2.x);
                        if (_loc_4 < _loc_3)
                        {
                            return;
                        }
                    }
                }
                var _loc_17:* = true;
                _loc_7 = true;
                _loc_6 = _loc_17;
            }
            var _loc_8:* = this._containerPos.x + _loc_2.x - this._beginTouchPos.x;
            var _loc_9:* = this._containerPos.y + _loc_2.y - this._beginTouchPos.y;
            if (_loc_6)
            {
                if (_loc_9 > 0)
                {
                    if (!this._bouncebackEffect)
                    {
                        this._container.y = 0;
                    }
                    else if (this._header && this._header.maxHeight > 0)
                    {
                        this._container.y = int(Math.min(_loc_9 / 2, this._header.maxHeight));
                    }
                    else
                    {
                        this._container.y = int(Math.min(_loc_9 / 2, this._viewSize.y * PULL_RATIO));
                    }
                }
                else if (_loc_9 < -this._overlapSize.y)
                {
                    if (!this._bouncebackEffect)
                    {
                        this._container.y = -this._overlapSize.y;
                    }
                    else if (this._footer && this._footer.maxHeight > 0)
                    {
                        this._container.y = int(Math.max((_loc_9 + this._overlapSize.y) / 2, -this._footer.maxHeight)) - this._overlapSize.y;
                    }
                    else
                    {
                        this._container.y = int(Math.max((_loc_9 + this._overlapSize.y) / 2, (-this._viewSize.y) * PULL_RATIO)) - this._overlapSize.y;
                    }
                }
                else
                {
                    this._container.y = _loc_9;
                }
            }
            if (_loc_7)
            {
                if (_loc_8 > 0)
                {
                    if (!this._bouncebackEffect)
                    {
                        this._container.x = 0;
                    }
                    else if (this._header && this._header.maxWidth > 0)
                    {
                        this._container.x = int(Math.min(_loc_8, this._header.maxWidth) * PULL_RATIO);
                    }
                    else
                    {
                        this._container.x = int(Math.min(_loc_8, this._viewSize.x) * PULL_RATIO);
                    }
                }
                else if (_loc_8 < -this._overlapSize.x)
                {
                    if (!this._bouncebackEffect)
                    {
                        this._container.x = -this._overlapSize.x;
                    }
                    else if (this._footer && this._footer.maxWidth > 0)
                    {
                        this._container.x = int(Math.max(_loc_8 + this._overlapSize.x, -this._footer.maxWidth) * PULL_RATIO) - this._overlapSize.x;
                    }
                    else
                    {
                        this._container.x = int(Math.max(_loc_8 + this._overlapSize.x, -this._viewSize.x) * PULL_RATIO) - this._overlapSize.x;
                    }
                }
                else
                {
                    this._container.x = _loc_8;
                }
            }
            var _loc_10:* = (getTimer() - this._lastMoveTime) / 1000;
            if ((getTimer() - this._lastMoveTime) / 1000 == 0)
            {
                _loc_10 = 0.001;
            }
            var _loc_11:* = _loc_10 * 60 - 1;
            if (_loc_10 * 60 - 1 > 1)
            {
                _loc_16 = Math.pow(0.833, _loc_11);
                this._velocity.x = this._velocity.x * _loc_16;
                this._velocity.y = this._velocity.y * _loc_16;
            }
            var _loc_12:* = _loc_2.x - this._lastTouchPos.x;
            var _loc_13:* = _loc_2.y - this._lastTouchPos.y;
            if (!_loc_7)
            {
                _loc_12 = 0;
            }
            if (!_loc_6)
            {
                _loc_13 = 0;
            }
            this._velocity.x = this._velocity.x + (_loc_12 / _loc_10 - this._velocity.x) * _loc_10 * 10;
            this._velocity.y = this._velocity.y + (_loc_13 / _loc_10 - this._velocity.y) * _loc_10 * 10;
            var _loc_14:* = this._lastTouchGlobalPos.x - sHelperPoint.x;
            var _loc_15:* = this._lastTouchGlobalPos.y - sHelperPoint.y;
            if (_loc_12 != 0)
            {
                this._velocityScale = Math.abs(_loc_14 / _loc_12);
            }
            else if (_loc_13 != 0)
            {
                this._velocityScale = Math.abs(_loc_15 / _loc_13);
            }
            this._lastTouchPos.copyFrom(_loc_2);
            this._lastTouchGlobalPos.setTo(event.stageX, event.stageY);
            this._lastMoveTime = getTimer();
            if (this._overlapSize.x > 0)
            {
                this._xPos = Utils.clamp(-this._container.x, 0, this._overlapSize.x);
            }
            if (this._overlapSize.y > 0)
            {
                this._yPos = Utils.clamp(-this._container.y, 0, this._overlapSize.y);
            }
            if (this._loop != 0)
            {
                _loc_8 = this._container.x;
                _loc_9 = this._container.y;
                if (this.loopCheckingCurrent())
                {
                    this._containerPos.x = this._containerPos.x + (this._container.x - _loc_8);
                    this._containerPos.y = this._containerPos.y + (this._container.y - _loc_9);
                }
            }
            draggingPane = this;
            this._isHoldAreaDone = true;
            if (!this._isDragged)
            {
                this._isDragged = true;
                this._owner.cancelChildrenClickEvent();
            }
            this.updateScrollBarPos();
            this.updateScrollBarVisible();
            if (this._pageMode)
            {
                this.updatePageController();
            }
            return;
        }// end function

        private function __mouseUp(event:GTouchEvent) : void
        {
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            if (this._owner == null)
            {
                return;
            }
            if (draggingPane == this)
            {
                draggingPane = null;
            }
            _gestureFlag = 0;
            if (!this._isDragged || !this._touchEffect)
            {
                this._isDragged = false;
                return;
            }
            this._isDragged = false;
            this._tweenStart.setTo(this._container.x, this._container.y);
            sEndPos.copyFrom(this._tweenStart);
            var _loc_2:* = false;
            if (this._container.x > 0)
            {
                sEndPos.x = 0;
                _loc_2 = true;
            }
            else if (this._container.x < -this._overlapSize.x)
            {
                sEndPos.x = -this._overlapSize.x;
                _loc_2 = true;
            }
            if (this._container.y > 0)
            {
                sEndPos.y = 0;
                _loc_2 = true;
            }
            else if (this._container.y < -this._overlapSize.y)
            {
                sEndPos.y = -this._overlapSize.y;
                _loc_2 = true;
            }
            if (!this._inertiaDisabled)
            {
                _loc_3 = (getTimer() - this._lastMoveTime) / 1000 * 60 - 1;
                if (_loc_3 > 1)
                {
                    _loc_4 = Math.pow(0.833, _loc_3);
                    this._velocity.x = this._velocity.x * _loc_4;
                    this._velocity.y = this._velocity.y * _loc_4;
                }
                this.updateTargetAndDuration(this._tweenStart, sEndPos);
            }
            else
            {
                this._tweenDuration.setTo(TWEEN_TIME_DEFAULT, TWEEN_TIME_DEFAULT);
            }
            sOldChange.setTo(sEndPos.x - this._tweenStart.x, sEndPos.y - this._tweenStart.y);
            this.loopCheckingTarget(sEndPos);
            if (this._pageMode || this._snapToItem)
            {
                this.alignPosition(sEndPos, true);
            }
            this._tweenChange.setTo(sEndPos.x - this._tweenStart.x, sEndPos.y - this._tweenStart.y);
            if (this._tweenChange.x == 0 && this._tweenChange.y == 0)
            {
                return;
            }
            if (this._pageMode || this._snapToItem)
            {
                this.fixDuration("x", sOldChange.x);
                this.fixDuration("y", sOldChange.y);
            }
            this._tweening = 2;
            this._tweenTime.setTo(0, 0);
            GTimers.inst.add(1, 0, this.__tweenUpdate);
            return;
        }// end function

        private function __mouseWheel(event:MouseEvent) : void
        {
            if (!this._mouseWheelEnabled)
            {
                return;
            }
            var _loc_2:* = event.delta;
            _loc_2 = _loc_2 > 0 ? (-1) : (1);
            if (this._overlapSize.x > 0 && this._overlapSize.y == 0)
            {
                if (this._pageMode)
                {
                    this.setPosX(this._xPos + this._pageSize.x * _loc_2, false);
                }
                else
                {
                    this.setPosX(this._xPos + this._mouseWheelStep * _loc_2, false);
                }
            }
            else if (this._pageMode)
            {
                this.setPosY(this._yPos + this._pageSize.y * _loc_2, false);
            }
            else
            {
                this.setPosY(this._yPos + this._mouseWheelStep * _loc_2, false);
            }
            return;
        }// end function

        private function __rollOver(event:Event) : void
        {
            this._hover = true;
            this.updateScrollBarVisible();
            return;
        }// end function

        private function __rollOut(event:Event) : void
        {
            this._hover = false;
            this.updateScrollBarVisible();
            return;
        }// end function

        private function updateScrollBarPos() : void
        {
            if (this._vtScrollBar != null)
            {
                this._vtScrollBar.setScrollPerc(this._overlapSize.y == 0 ? (0) : (Utils.clamp(-this._container.y, 0, this._overlapSize.y) / this._overlapSize.y));
            }
            if (this._hzScrollBar != null)
            {
                this._hzScrollBar.setScrollPerc(this._overlapSize.x == 0 ? (0) : (Utils.clamp(-this._container.x, 0, this._overlapSize.x) / this._overlapSize.x));
            }
            this.checkRefreshBar();
            return;
        }// end function

        function updateScrollBarVisible() : void
        {
            if (this._vtScrollBar)
            {
                if (this._viewSize.y <= this._vtScrollBar.minSize || this._vScrollNone)
                {
                    this._vtScrollBar.owner.displayObject.visible = false;
                }
                else
                {
                    this.updateScrollBarVisible2(this._vtScrollBar);
                }
            }
            if (this._hzScrollBar)
            {
                if (this._viewSize.x <= this._hzScrollBar.minSize || this._hScrollNone)
                {
                    this._hzScrollBar.owner.displayObject.visible = false;
                }
                else
                {
                    this.updateScrollBarVisible2(this._hzScrollBar);
                }
            }
            return;
        }// end function

        private function updateScrollBarVisible2(param1:FScrollBar) : void
        {
            if ((this._owner._flags & FObjectFlags.IN_TEST) == 0)
            {
                param1.owner.displayObject.visible = true;
                return;
            }
            if (this._scrollBarDisplay == "auto")
            {
                GTween.kill(param1.owner, false, "alpha");
            }
            if (this._scrollBarDisplay == "auto" && !this._hover && this._tweening == 0 && !this._isDragged && !param1.gripDragging)
            {
                if (param1.owner.displayObject.visible)
                {
                    GTween.to(1, 0, 0.5).setDelay(0.5).onComplete(this.__barTweenComplete).setTarget(param1.owner, "alpha");
                }
            }
            else
            {
                param1.owner.alpha = 1;
                param1.owner.displayObject.visible = true;
            }
            return;
        }// end function

        private function __barTweenComplete(param1:GTweener) : void
        {
            var _loc_2:* = FObject(param1.target);
            _loc_2.alpha = 1;
            _loc_2.displayObject.visible = false;
            return;
        }// end function

        private function loopCheckingCurrent() : Boolean
        {
            var _loc_1:* = false;
            if (this._loop == 1 && this._overlapSize.x > 0)
            {
                if (this._xPos < 0.001)
                {
                    this._xPos = this._xPos + this._contentSize.x / 2;
                    _loc_1 = true;
                }
                else if (this._xPos >= this._overlapSize.x)
                {
                    this._xPos = this._xPos - this._contentSize.x / 2;
                    _loc_1 = true;
                }
            }
            else if (this._loop == 2 && this._overlapSize.y > 0)
            {
                if (this._yPos < 0.001)
                {
                    this._yPos = this._yPos + this._contentSize.y / 2;
                    _loc_1 = true;
                }
                else if (this._yPos >= this._overlapSize.y)
                {
                    this._yPos = this._yPos + (this._contentSize.y / 2 - this._overlapSize.y);
                    _loc_1 = true;
                }
            }
            if (_loc_1)
            {
                this._container.x = int(-this._xPos);
                this._container.y = int(-this._yPos);
                if (this._pageMode)
                {
                    this.updatePageController();
                }
            }
            return _loc_1;
        }// end function

        private function loopCheckingTarget(param1:Point) : void
        {
            if (this._loop == 1)
            {
                this.loopCheckingTarget2(param1, "x");
            }
            if (this._loop == 2)
            {
                this.loopCheckingTarget2(param1, "y");
            }
            return;
        }// end function

        private function loopCheckingTarget2(param1:Point, param2:String) : void
        {
            var _loc_3:* = NaN;
            if (param1[param2] > 0)
            {
                _loc_3 = this._tweenStart[param2] - this._contentSize[param2] / 2;
                if (_loc_3 <= 0 && _loc_3 >= -this._overlapSize[param2])
                {
                    param1[param2] = param1[param2] - this._contentSize[param2] / 2;
                    this._tweenStart[param2] = _loc_3;
                }
            }
            else if (param1[param2] < -this._overlapSize[param2])
            {
                _loc_3 = this._tweenStart[param2] + this._contentSize[param2] / 2;
                if (_loc_3 <= 0 && _loc_3 >= -this._overlapSize.x)
                {
                    param1[param2] = param1[param2] + this._contentSize[param2] / 2;
                    this._tweenStart[param2] = _loc_3;
                }
            }
            return;
        }// end function

        private function alignPosition(param1:Point, param2:Boolean) : void
        {
            var _loc_3:* = null;
            if (this._pageMode)
            {
                param1.x = this.alignByPage(param1.x, "x", param2);
                param1.y = this.alignByPage(param1.y, "y", param2);
            }
            else if (this._snapToItem)
            {
                _loc_3 = this._owner.getSnappingPosition(-param1.x, -param1.y, sHelperPoint);
                if (param1.x < 0 && param1.x > -this._overlapSize.x)
                {
                    param1.x = -_loc_3.x;
                }
                if (param1.y < 0 && param1.y > -this._overlapSize.y)
                {
                    param1.y = -_loc_3.y;
                }
            }
            return;
        }// end function

        private function alignByPage(param1:Number, param2:String, param3:Boolean) : Number
        {
            var _loc_4:* = 0;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            if (param1 > 0)
            {
                _loc_4 = 0;
            }
            else if (param1 < -this._overlapSize[param2])
            {
                _loc_4 = Math.ceil(this._contentSize[param2] / this._pageSize[param2]) - 1;
            }
            else
            {
                _loc_4 = Math.floor((-param1) / this._pageSize[param2]);
                _loc_5 = param3 ? (param1 - this._containerPos[param2]) : (param1 - this._container[param2]);
                _loc_6 = Math.min(this._pageSize[param2], this._contentSize[param2] - (_loc_4 + 1) * this._pageSize[param2]);
                _loc_7 = -param1 - _loc_4 * this._pageSize[param2];
                if (Math.abs(_loc_5) > this._pageSize[param2])
                {
                    if (_loc_7 > _loc_6 * 0.5)
                    {
                        _loc_4++;
                    }
                }
                else if (_loc_7 > _loc_6 * (_loc_5 < 0 ? (0.3) : (0.7)))
                {
                    _loc_4++;
                }
                param1 = (-_loc_4) * this._pageSize[param2];
                if (param1 < -this._overlapSize[param2])
                {
                    param1 = -this._overlapSize[param2];
                }
            }
            if (param3)
            {
                _loc_8 = this._tweenStart[param2];
                if (_loc_8 > 0)
                {
                    _loc_9 = 0;
                }
                else if (_loc_8 < -this._overlapSize[param2])
                {
                    _loc_9 = Math.ceil(this._contentSize[param2] / this._pageSize[param2]) - 1;
                }
                else
                {
                    _loc_9 = Math.floor((-_loc_8) / this._pageSize[param2]);
                }
                _loc_10 = Math.floor((-this._containerPos[param2]) / this._pageSize[param2]);
                if (Math.abs(_loc_4 - _loc_10) > 1 && Math.abs(_loc_9 - _loc_10) <= 1)
                {
                    if (_loc_4 > _loc_10)
                    {
                        _loc_4 = _loc_10 + 1;
                    }
                    else
                    {
                        _loc_4 = _loc_10 - 1;
                    }
                    param1 = (-_loc_4) * this._pageSize[param2];
                }
            }
            return param1;
        }// end function

        private function updateTargetAndDuration(param1:Point, param2:Point) : void
        {
            param2.x = this.updateTargetAndDuration2(param1.x, "x");
            param2.y = this.updateTargetAndDuration2(param1.y, "y");
            return;
        }// end function

        private function updateTargetAndDuration2(param1:Number, param2:String) : Number
        {
            var _loc_5:* = NaN;
            var _loc_6:* = false;
            var _loc_7:* = NaN;
            var _loc_8:* = 0;
            var _loc_3:* = this._velocity[param2];
            var _loc_4:* = 0;
            if (param1 > 0)
            {
                param1 = 0;
            }
            else if (param1 < -this._overlapSize[param2])
            {
                param1 = -this._overlapSize[param2];
            }
            else
            {
                _loc_5 = Math.abs(_loc_3) * this._velocityScale;
                _loc_6 = false;
                _loc_7 = 0;
                if (this._pageMode || !_loc_6)
                {
                    if (_loc_5 > 500)
                    {
                        _loc_7 = Math.pow((_loc_5 - 500) / 500, 2);
                    }
                }
                else if (_loc_5 > 1000)
                {
                    _loc_7 = Math.pow((_loc_5 - 1000) / 1000, 2);
                }
                if (_loc_7 != 0)
                {
                    if (_loc_7 > 1)
                    {
                        _loc_7 = 1;
                    }
                    _loc_5 = _loc_5 * _loc_7;
                    _loc_3 = _loc_3 * _loc_7;
                    this._velocity[param2] = _loc_3;
                    _loc_4 = Math.log(60 / _loc_5) / Math.log(this._decelerationRate) / 60;
                    _loc_8 = int(_loc_3 * _loc_4 * 0.4);
                    param1 = param1 + _loc_8;
                }
            }
            if (_loc_4 < TWEEN_TIME_DEFAULT)
            {
                _loc_4 = TWEEN_TIME_DEFAULT;
            }
            this._tweenDuration[param2] = _loc_4;
            return param1;
        }// end function

        private function fixDuration(param1:String, param2:Number) : void
        {
            if (this._tweenChange[param1] == 0 || Math.abs(this._tweenChange[param1]) >= Math.abs(param2))
            {
                return;
            }
            var _loc_3:* = Math.abs(this._tweenChange[param1] / param2) * this._tweenDuration[param1];
            if (_loc_3 < TWEEN_TIME_DEFAULT)
            {
                _loc_3 = TWEEN_TIME_DEFAULT;
            }
            this._tweenDuration[param1] = _loc_3;
            return;
        }// end function

        private function killTween() : void
        {
            if (this._tweening == 1)
            {
                this._container.x = this._tweenStart.x + this._tweenChange.x;
                this._container.y = this._tweenStart.y + this._tweenChange.y;
            }
            this._tweening = 0;
            GTimers.inst.remove(this.__tweenUpdate);
            return;
        }// end function

        private function checkRefreshBar() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = NaN;
            if (this._header == null && this._footer == null)
            {
                return;
            }
            var _loc_1:* = this._container[this._refreshBarAxis];
            if (this._header != null)
            {
                if (_loc_1 > 0)
                {
                    if (this._header.displayObject.parent == null)
                    {
                        this._maskContainer.addChildAt(this._header.displayObject, 0);
                    }
                    _loc_2 = sHelperPoint;
                    _loc_2.setTo(this._header.width, this._header.height);
                    _loc_2[this._refreshBarAxis] = _loc_1;
                    this._header.setSize(_loc_2.x, _loc_2.y);
                }
                else if (this._header.displayObject.parent != null)
                {
                    this._maskContainer.removeChild(this._header.displayObject);
                }
            }
            if (this._footer != null)
            {
                _loc_3 = this._overlapSize[this._refreshBarAxis];
                if (_loc_1 < -_loc_3)
                {
                    if (this._footer.displayObject.parent == null)
                    {
                        this._maskContainer.addChildAt(this._footer.displayObject, 0);
                    }
                    _loc_2 = sHelperPoint;
                    _loc_2.setTo(this._footer.x, this._footer.y);
                    if (_loc_3 > 0)
                    {
                        _loc_2[this._refreshBarAxis] = _loc_1 + this._contentSize[this._refreshBarAxis];
                    }
                    else
                    {
                        _loc_2[this._refreshBarAxis] = Math.max(Math.min(_loc_1 + this._viewSize[this._refreshBarAxis], this._viewSize[this._refreshBarAxis]), this._viewSize[this._refreshBarAxis] - this._contentSize[this._refreshBarAxis]);
                    }
                    this._footer.setXY(_loc_2.x, _loc_2.y);
                    _loc_2.setTo(this._footer.width, this._footer.height);
                    if (_loc_3 > 0)
                    {
                        _loc_2[this._refreshBarAxis] = -_loc_3 - _loc_1;
                    }
                    else
                    {
                        _loc_2[this._refreshBarAxis] = this._viewSize[this._refreshBarAxis] - this._footer[this._refreshBarAxis];
                    }
                    this._footer.setSize(_loc_2.x, _loc_2.y);
                }
                else if (this._footer.displayObject.parent != null)
                {
                    this._maskContainer.removeChild(this._footer.displayObject);
                }
            }
            return;
        }// end function

        private function __tweenUpdate() : void
        {
            if (this._owner == null)
            {
                GTimers.inst.remove(this.__tweenUpdate);
                return;
            }
            var _loc_1:* = this.runTween("x");
            var _loc_2:* = this.runTween("y");
            this._container.x = _loc_1;
            this._container.y = _loc_2;
            if (this._tweening == 2)
            {
                if (this._overlapSize.x > 0)
                {
                    this._xPos = Utils.clamp(-_loc_1, 0, this._overlapSize.x);
                }
                if (this._overlapSize.y > 0)
                {
                    this._yPos = Utils.clamp(-_loc_2, 0, this._overlapSize.y);
                }
                if (this._pageMode)
                {
                    this.updatePageController();
                }
            }
            if (this._tweenChange.x == 0 && this._tweenChange.y == 0)
            {
                this._tweening = 0;
                GTimers.inst.remove(this.__tweenUpdate);
                this.loopCheckingCurrent();
                this.updateScrollBarPos();
                this.updateScrollBarVisible();
            }
            else
            {
                this.updateScrollBarPos();
                this.checkRefreshBar();
            }
            return;
        }// end function

        private function runTween(param1:String) : Number
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            if (this._tweenChange[param1] != 0)
            {
                this._tweenTime[param1] = this._tweenTime[param1] + GTimers.deltaTime / 1000;
                if (this._tweenTime[param1] >= this._tweenDuration[param1])
                {
                    _loc_2 = this._tweenStart[param1] + this._tweenChange[param1];
                    this._tweenChange[param1] = 0;
                }
                else
                {
                    _loc_3 = easeFunc(this._tweenTime[param1], this._tweenDuration[param1]);
                    _loc_2 = this._tweenStart[param1] + int(this._tweenChange[param1] * _loc_3);
                }
                if (this._tweening == 2 && this._bouncebackEffect)
                {
                    if (_loc_2 > 20 && this._tweenChange[param1] > 0 || _loc_2 > 0 && this._tweenChange[param1] == 0)
                    {
                        this._tweenTime[param1] = 0;
                        this._tweenDuration[param1] = TWEEN_TIME_DEFAULT;
                        this._tweenChange[param1] = -_loc_2;
                        this._tweenStart[param1] = _loc_2;
                    }
                    else if (_loc_2 < -this._overlapSize[param1] - 20 && this._tweenChange[param1] < 0 || _loc_2 < -this._overlapSize[param1] && this._tweenChange[param1] == 0)
                    {
                        this._tweenTime[param1] = 0;
                        this._tweenDuration[param1] = TWEEN_TIME_DEFAULT;
                        this._tweenChange[param1] = -this._overlapSize[param1] - _loc_2;
                        this._tweenStart[param1] = _loc_2;
                    }
                }
                else if (_loc_2 > 0)
                {
                    _loc_2 = 0;
                    this._tweenChange[param1] = 0;
                }
                else if (_loc_2 < -this._overlapSize[param1])
                {
                    _loc_2 = -this._overlapSize[param1];
                    this._tweenChange[param1] = 0;
                }
            }
            else
            {
                _loc_2 = this._container[param1];
            }
            return _loc_2;
        }// end function

        private static function easeFunc(param1:Number, param2:Number) : Number
        {
            var _loc_3:* = param1 / param2 - 1;
            param1 = param1 / param2 - 1;
            return _loc_3 * param1 * param1 + 1;
        }// end function

    }
}
