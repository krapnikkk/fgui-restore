package fairygui
{
    import *.*;
    import fairygui.event.*;
    import fairygui.tween.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;

    public class ScrollPane extends EventDispatcher
    {
        private var _owner:GComponent;
        private var _container:Sprite;
        private var _maskContainer:Sprite;
        private var _alignContainer:Sprite;
        private var _scrollType:int;
        private var _scrollStep:int;
        private var _mouseWheelStep:int;
        private var _decelerationRate:Number;
        private var _scrollBarMargin:Margin;
        private var _bouncebackEffect:Boolean;
        private var _touchEffect:Boolean;
        private var _scrollBarDisplayAuto:Boolean;
        private var _vScrollNone:Boolean;
        private var _hScrollNone:Boolean;
        private var _needRefresh:Boolean;
        private var _refreshBarAxis:String;
        private var _displayOnLeft:Boolean;
        private var _snapToItem:Boolean;
        var _displayInDemand:Boolean;
        private var _mouseWheelEnabled:Boolean;
        private var _pageMode:Boolean;
        private var _inertiaDisabled:Boolean;
        private var _floating:Boolean;
        private var _xPos:Number;
        private var _yPos:Number;
        private var _viewSize:Point;
        private var _contentSize:Point;
        private var _overlapSize:Point;
        private var _pageSize:Point;
        private var _containerPos:Point;
        private var _beginTouchPos:Point;
        private var _lastTouchPos:Point;
        private var _lastTouchGlobalPos:Point;
        private var _velocity:Point;
        private var _velocityScale:Number;
        private var _lastMoveTime:Number;
        private var _isHoldAreaDone:Boolean;
        private var _aniFlag:int;
        var _loop:int;
        private var _headerLockedSize:int;
        private var _footerLockedSize:int;
        private var _refreshEventDispatching:Boolean;
        private var _hover:Boolean;
        private var _tweening:int;
        private var _tweenTime:Point;
        private var _tweenDuration:Point;
        private var _tweenStart:Point;
        private var _tweenChange:Point;
        private var _pageController:Controller;
        private var _hzScrollBar:GScrollBar;
        private var _vtScrollBar:GScrollBar;
        private var _header:GComponent;
        private var _footer:GComponent;
        public var isDragged:Boolean;
        public static var draggingPane:ScrollPane;
        private static var _gestureFlag:int = 0;
        private static var sHelperPoint:Point = new Point();
        private static var sHelperRect:Rectangle = new Rectangle();
        private static var sEndPos:Point = new Point();
        private static var sOldChange:Point = new Point();
        public static const SCROLL_END:String = "scrollEnd";
        public static const PULL_DOWN_RELEASE:String = "pullDownRelease";
        public static const PULL_UP_RELEASE:String = "pullUpRelease";
        public static const TWEEN_TIME_GO:Number = 0.5;
        public static const TWEEN_TIME_DEFAULT:Number = 0.3;
        public static const PULL_RATIO:Number = 0.5;

        public function ScrollPane(param1:GComponent, param2:int, param3:Margin, param4:int, param5:int, param6:String, param7:String, param8:String, param9:String) : void
        {
            var _loc_10:* = null;
            _owner = param1;
            param1.opaque = true;
            _maskContainer = new Sprite();
            _maskContainer.mouseEnabled = false;
            _owner._rootContainer.addChild(_maskContainer);
            _container = _owner._container;
            _container.x = 0;
            _container.y = 0;
            _container.mouseEnabled = false;
            _maskContainer.addChild(_container);
            _scrollBarMargin = param3;
            _scrollType = param2;
            _scrollStep = UIConfig.defaultScrollStep;
            _mouseWheelStep = _scrollStep * 2;
            _decelerationRate = UIConfig.defaultScrollDecelerationRate;
            _displayOnLeft = (param5 & 1) != 0;
            _snapToItem = (param5 & 2) != 0;
            _displayInDemand = (param5 & 4) != 0;
            _pageMode = (param5 & 8) != 0;
            if (param5 & 16)
            {
                _touchEffect = true;
            }
            else if (param5 & 32)
            {
                _touchEffect = false;
            }
            else
            {
                _touchEffect = UIConfig.defaultScrollTouchEffect;
            }
            if (param5 & 64)
            {
                _bouncebackEffect = true;
            }
            else if (param5 & 128)
            {
                _bouncebackEffect = false;
            }
            else
            {
                _bouncebackEffect = UIConfig.defaultScrollBounceEffect;
            }
            _inertiaDisabled = (param5 & 256) != 0;
            _floating = (param5 & 1024) != 0;
            if ((param5 & 512) == 0)
            {
                _maskContainer.scrollRect = new Rectangle();
            }
            _mouseWheelEnabled = true;
            _xPos = 0;
            _yPos = 0;
            _aniFlag = 0;
            _footerLockedSize = 0;
            _headerLockedSize = 0;
            if (param4 == 0)
            {
                param4 = UIConfig.defaultScrollBarDisplay;
            }
            _viewSize = new Point();
            _contentSize = new Point();
            _pageSize = new Point(1, 1);
            _overlapSize = new Point();
            _tweenTime = new Point();
            _tweenStart = new Point();
            _tweenDuration = new Point();
            _tweenChange = new Point();
            _velocity = new Point();
            _containerPos = new Point();
            _beginTouchPos = new Point();
            _lastTouchPos = new Point();
            _lastTouchGlobalPos = new Point();
            if (param4 != 3)
            {
                if (_scrollType == 2 || _scrollType == 1)
                {
                    _loc_10 = param6 ? (param6) : (UIConfig.verticalScrollBar);
                    if (_loc_10)
                    {
                        _vtScrollBar = UIPackage.createObjectFromURL(_loc_10) as GScrollBar;
                        if (!_vtScrollBar)
                        {
                            throw new Error("cannot create scrollbar from " + _loc_10);
                        }
                        _vtScrollBar.setScrollPane(this, true);
                        _owner._rootContainer.addChild(_vtScrollBar.displayObject);
                    }
                }
                if (_scrollType == 2 || _scrollType == 0)
                {
                    _loc_10 = param7 ? (param7) : (UIConfig.horizontalScrollBar);
                    if (_loc_10)
                    {
                        _hzScrollBar = UIPackage.createObjectFromURL(_loc_10) as GScrollBar;
                        if (!_hzScrollBar)
                        {
                            throw new Error("cannot create scrollbar from " + _loc_10);
                        }
                        _hzScrollBar.setScrollPane(this, false);
                        _owner._rootContainer.addChild(_hzScrollBar.displayObject);
                    }
                }
                _scrollBarDisplayAuto = param4 == 2;
                if (_scrollBarDisplayAuto)
                {
                    if (_vtScrollBar)
                    {
                        _vtScrollBar.displayObject.visible = false;
                    }
                    if (_hzScrollBar)
                    {
                        _hzScrollBar.displayObject.visible = false;
                    }
                    if (Mouse.supportsCursor)
                    {
                        _owner._rootContainer.addEventListener("rollOver", __rollOver);
                        _owner._rootContainer.addEventListener("rollOut", __rollOut);
                    }
                }
            }
            else
            {
                _mouseWheelEnabled = false;
            }
            if (param8)
            {
                _header = UIPackage.createObjectFromURL(param8) as GComponent;
                if (_header == null)
                {
                    throw new Error("FairyGUI: cannot create scrollPane header from " + param8);
                }
            }
            if (param9)
            {
                _footer = UIPackage.createObjectFromURL(param9) as GComponent;
                if (_footer == null)
                {
                    throw new Error("FairyGUI: cannot create scrollPane footer from " + param9);
                }
            }
            if (_header != null || _footer != null)
            {
                _refreshBarAxis = _scrollType == 2 || _scrollType == 1 ? ("y") : ("x");
            }
            setSize(param1.width, param1.height);
            _owner._rootContainer.addEventListener("mouseWheel", __mouseWheel);
            _owner.addEventListener("beginGTouch", __mouseDown);
            _owner.addEventListener("endGTouch", __mouseUp);
            return;
        }// end function

        public function dispose() : void
        {
            if (_tweening != 0)
            {
                GTimers.inst.remove(tweenUpdate);
            }
            _pageController = null;
            if (_hzScrollBar != null)
            {
                _hzScrollBar.dispose();
            }
            if (_vtScrollBar != null)
            {
                _vtScrollBar.dispose();
            }
            if (_header != null)
            {
                _header.dispose();
            }
            if (_footer != null)
            {
                _footer.dispose();
            }
            return;
        }// end function

        public function get owner() : GComponent
        {
            return _owner;
        }// end function

        public function get hzScrollBar() : GScrollBar
        {
            return this._hzScrollBar;
        }// end function

        public function get vtScrollBar() : GScrollBar
        {
            return this._vtScrollBar;
        }// end function

        public function get header() : GComponent
        {
            return _header;
        }// end function

        public function get footer() : GComponent
        {
            return _footer;
        }// end function

        public function get bouncebackEffect() : Boolean
        {
            return _bouncebackEffect;
        }// end function

        public function set bouncebackEffect(param1:Boolean) : void
        {
            _bouncebackEffect = param1;
            return;
        }// end function

        public function get touchEffect() : Boolean
        {
            return _touchEffect;
        }// end function

        public function set touchEffect(param1:Boolean) : void
        {
            _touchEffect = param1;
            return;
        }// end function

        public function set scrollSpeed(param1:int) : void
        {
            this.scrollStep = param1;
            return;
        }// end function

        public function get scrollSpeed() : int
        {
            return this.scrollStep;
        }// end function

        public function set scrollStep(param1:int) : void
        {
            _scrollStep = param1;
            if (_scrollStep == 0)
            {
                _scrollStep = UIConfig.defaultScrollStep;
            }
            _mouseWheelStep = _scrollStep * 2;
            return;
        }// end function

        public function get scrollStep() : int
        {
            return _scrollStep;
        }// end function

        public function get snapToItem() : Boolean
        {
            return _snapToItem;
        }// end function

        public function set snapToItem(param1:Boolean) : void
        {
            _snapToItem = param1;
            return;
        }// end function

        public function get mouseWheelEnabled() : Boolean
        {
            return _mouseWheelEnabled;
        }// end function

        public function set mouseWheelEnabled(param1:Boolean) : void
        {
            _mouseWheelEnabled = param1;
            return;
        }// end function

        public function get decelerationRate() : Number
        {
            return _decelerationRate;
        }// end function

        public function set decelerationRate(param1:Number) : void
        {
            _decelerationRate = param1;
            return;
        }// end function

        public function get percX() : Number
        {
            return _overlapSize.x == 0 ? (0) : (_xPos / _overlapSize.x);
        }// end function

        public function set percX(param1:Number) : void
        {
            setPercX(param1, false);
            return;
        }// end function

        public function setPercX(param1:Number, param2:Boolean = false) : void
        {
            _owner.ensureBoundsCorrect();
            setPosX(_overlapSize.x * ToolSet.clamp01(param1), param2);
            return;
        }// end function

        public function get percY() : Number
        {
            return _overlapSize.y == 0 ? (0) : (_yPos / _overlapSize.y);
        }// end function

        public function set percY(param1:Number) : void
        {
            setPercY(param1, false);
            return;
        }// end function

        public function setPercY(param1:Number, param2:Boolean = false) : void
        {
            _owner.ensureBoundsCorrect();
            setPosY(_overlapSize.y * ToolSet.clamp01(param1), param2);
            return;
        }// end function

        public function get posX() : Number
        {
            return _xPos;
        }// end function

        public function set posX(param1:Number) : void
        {
            setPosX(param1, false);
            return;
        }// end function

        public function setPosX(param1:Number, param2:Boolean = false) : void
        {
            _owner.ensureBoundsCorrect();
            if (_loop == 1)
            {
                param1 = loopCheckingNewPos(param1, "x");
            }
            param1 = ToolSet.clamp(param1, 0, _overlapSize.x);
            if (param1 != _xPos)
            {
                _xPos = param1;
                posChanged(param2);
            }
            return;
        }// end function

        public function get posY() : Number
        {
            return _yPos;
        }// end function

        public function set posY(param1:Number) : void
        {
            setPosY(param1, false);
            return;
        }// end function

        public function setPosY(param1:Number, param2:Boolean = false) : void
        {
            _owner.ensureBoundsCorrect();
            if (_loop == 1)
            {
                param1 = loopCheckingNewPos(param1, "y");
            }
            param1 = ToolSet.clamp(param1, 0, _overlapSize.y);
            if (param1 != _yPos)
            {
                _yPos = param1;
                posChanged(param2);
            }
            return;
        }// end function

        public function get contentWidth() : Number
        {
            return _contentSize.x;
        }// end function

        public function get contentHeight() : Number
        {
            return _contentSize.y;
        }// end function

        public function get viewWidth() : Number
        {
            return _viewSize.x;
        }// end function

        public function set viewWidth(param1:Number) : void
        {
            param1 = param1 + _owner.margin.left + _owner.margin.right;
            if (_vtScrollBar != null && !_floating)
            {
                param1 = param1 + _vtScrollBar.width;
            }
            _owner.width = param1;
            return;
        }// end function

        public function get viewHeight() : Number
        {
            return _viewSize.y;
        }// end function

        public function set viewHeight(param1:Number) : void
        {
            param1 = param1 + _owner.margin.top + _owner.margin.bottom;
            if (_hzScrollBar != null && !_floating)
            {
                param1 = param1 + _hzScrollBar.height;
            }
            _owner.height = param1;
            return;
        }// end function

        public function get currentPageX() : int
        {
            if (!_pageMode)
            {
                return 0;
            }
            var _loc_1:* = Math.floor(_xPos / _pageSize.x);
            if (_xPos - _loc_1 * _pageSize.x > _pageSize.x * 0.5)
            {
                _loc_1++;
            }
            return _loc_1;
        }// end function

        public function set currentPageX(param1:int) : void
        {
            setCurrentPageX(param1, false);
            return;
        }// end function

        public function get currentPageY() : int
        {
            if (!_pageMode)
            {
                return 0;
            }
            var _loc_1:* = Math.floor(_yPos / _pageSize.y);
            if (_yPos - _loc_1 * _pageSize.y > _pageSize.y * 0.5)
            {
                _loc_1++;
            }
            return _loc_1;
        }// end function

        public function set currentPageY(param1:int) : void
        {
            setCurrentPageY(param1, false);
            return;
        }// end function

        public function setCurrentPageX(param1:int, param2:Boolean) : void
        {
            _owner.ensureBoundsCorrect();
            if (_pageMode && _overlapSize.x > 0)
            {
                this.setPosX(param1 * _pageSize.x, param2);
            }
            return;
        }// end function

        public function setCurrentPageY(param1:int, param2:Boolean) : void
        {
            _owner.ensureBoundsCorrect();
            if (_pageMode && _overlapSize.y > 0)
            {
                this.setPosY(param1 * _pageSize.y, param2);
            }
            return;
        }// end function

        public function get isBottomMost() : Boolean
        {
            return _yPos == _overlapSize.y || _overlapSize.y == 0;
        }// end function

        public function get isRightMost() : Boolean
        {
            return _xPos == _overlapSize.x || _overlapSize.x == 0;
        }// end function

        public function get pageController() : Controller
        {
            return _pageController;
        }// end function

        public function set pageController(param1:Controller) : void
        {
            _pageController = param1;
            return;
        }// end function

        public function get scrollingPosX() : Number
        {
            return ToolSet.clamp(-_container.x, 0, _overlapSize.x);
        }// end function

        public function get scrollingPosY() : Number
        {
            return ToolSet.clamp(-_container.y, 0, _overlapSize.y);
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
            if (_pageMode)
            {
                setPosY(_yPos - _pageSize.y * param1, param2);
            }
            else
            {
                setPosY(_yPos - _scrollStep * param1, param2);
            }
            return;
        }// end function

        public function scrollDown(param1:Number = 1, param2:Boolean = false) : void
        {
            if (_pageMode)
            {
                setPosY(_yPos + _pageSize.y * param1, param2);
            }
            else
            {
                setPosY(_yPos + _scrollStep * param1, param2);
            }
            return;
        }// end function

        public function scrollLeft(param1:Number = 1, param2:Boolean = false) : void
        {
            if (_pageMode)
            {
                setPosX(_xPos - _pageSize.x * param1, param2);
            }
            else
            {
                setPosX(_xPos - _scrollStep * param1, param2);
            }
            return;
        }// end function

        public function scrollRight(param1:Number = 1, param2:Boolean = false) : void
        {
            if (_pageMode)
            {
                setPosX(_xPos + _pageSize.x * param1, param2);
            }
            else
            {
                setPosX(_xPos + _scrollStep * param1, param2);
            }
            return;
        }// end function

        public function scrollToView(param1, param2:Boolean = false, param3:Boolean = false) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            _owner.ensureBoundsCorrect();
            if (_needRefresh)
            {
                refresh();
            }
            if (param1 is GObject)
            {
                if (param1.parent != _owner)
                {
                    this.GObject(param1).parent.localToGlobalRect(param1.x, param1.y, param1.width, param1.height, sHelperRect);
                    _loc_4 = _owner.globalToLocalRect(sHelperRect.x, sHelperRect.y, sHelperRect.width, sHelperRect.height, sHelperRect);
                }
                else
                {
                    _loc_4 = sHelperRect;
                    _loc_4.setTo(param1.x, param1.y, param1.width, param1.height);
                }
            }
            else
            {
                _loc_4 = this.Rectangle(param1);
            }
            if (_overlapSize.y > 0)
            {
                _loc_5 = _yPos + _viewSize.y;
                if (param3 || _loc_4.y <= _yPos || _loc_4.height >= _viewSize.y)
                {
                    if (_pageMode)
                    {
                        this.setPosY(Math.floor(_loc_4.y / _pageSize.y) * _pageSize.y, param2);
                    }
                    else
                    {
                        this.setPosY(_loc_4.y, param2);
                    }
                }
                else if (_loc_4.y + _loc_4.height > _loc_5)
                {
                    if (_pageMode)
                    {
                        this.setPosY(Math.floor(_loc_4.y / _pageSize.y) * _pageSize.y, param2);
                    }
                    else if (_loc_4.height <= _viewSize.y / 2)
                    {
                        this.setPosY(_loc_4.y + _loc_4.height * 2 - _viewSize.y, param2);
                    }
                    else
                    {
                        this.setPosY(_loc_4.y + _loc_4.height - _viewSize.y, param2);
                    }
                }
            }
            if (_overlapSize.x > 0)
            {
                _loc_6 = _xPos + _viewSize.x;
                if (param3 || _loc_4.x <= _xPos || _loc_4.width >= _viewSize.x)
                {
                    if (_pageMode)
                    {
                        this.setPosX(Math.floor(_loc_4.x / _pageSize.x) * _pageSize.x, param2);
                    }
                    else
                    {
                        this.setPosX(_loc_4.x, param2);
                    }
                }
                else if (_loc_4.x + _loc_4.width > _loc_6)
                {
                    if (_pageMode)
                    {
                        this.setPosX(Math.floor(_loc_4.x / _pageSize.x) * _pageSize.x, param2);
                    }
                    else if (_loc_4.width <= _viewSize.x / 2)
                    {
                        this.setPosX(_loc_4.x + _loc_4.width * 2 - _viewSize.x, param2);
                    }
                    else
                    {
                        this.setPosX(_loc_4.x + _loc_4.width - _viewSize.x, param2);
                    }
                }
            }
            if (!param2 && _needRefresh)
            {
                refresh();
            }
            return;
        }// end function

        public function isChildInView(param1:GObject) : Boolean
        {
            var _loc_2:* = NaN;
            if (_overlapSize.y > 0)
            {
                _loc_2 = param1.y + _container.y;
                if (_loc_2 < -param1.height || _loc_2 > _viewSize.y)
                {
                    return false;
                }
            }
            if (_overlapSize.x > 0)
            {
                _loc_2 = param1.x + _container.x;
                if (_loc_2 < -param1.width || _loc_2 > _viewSize.x)
                {
                    return false;
                }
            }
            return true;
        }// end function

        public function cancelDragging() : void
        {
            _owner.removeEventListener("dragGTouch", __mouseMove);
            if (draggingPane == this)
            {
                draggingPane = null;
            }
            _gestureFlag = 0;
            isDragged = false;
            _maskContainer.mouseChildren = true;
            return;
        }// end function

        public function lockHeader(param1:int) : void
        {
            if (_headerLockedSize == param1)
            {
                return;
            }
            _headerLockedSize = param1;
            if (!_refreshEventDispatching && _container[_refreshBarAxis] >= 0)
            {
                _tweenStart.setTo(_container.x, _container.y);
                _tweenChange.setTo(0, 0);
                _tweenChange[_refreshBarAxis] = _headerLockedSize - _tweenStart[_refreshBarAxis];
                _tweenDuration.setTo(0.3, 0.3);
                startTween(2);
            }
            return;
        }// end function

        public function lockFooter(param1:int) : void
        {
            var _loc_2:* = NaN;
            if (_footerLockedSize == param1)
            {
                return;
            }
            _footerLockedSize = param1;
            if (!_refreshEventDispatching && _container[_refreshBarAxis] <= -_overlapSize[_refreshBarAxis])
            {
                _tweenStart.setTo(_container.x, _container.y);
                _tweenChange.setTo(0, 0);
                _loc_2 = _overlapSize[_refreshBarAxis];
                if (_loc_2 == 0)
                {
                    _loc_2 = Math.max(_contentSize[_refreshBarAxis] + _footerLockedSize - _viewSize[_refreshBarAxis], 0);
                }
                else
                {
                    _loc_2 = _loc_2 + _footerLockedSize;
                }
                _tweenChange[_refreshBarAxis] = -_loc_2 - _tweenStart[_refreshBarAxis];
                _tweenDuration.setTo(0.3, 0.3);
                startTween(2);
            }
            return;
        }// end function

        function onOwnerSizeChanged() : void
        {
            setSize(_owner.width, _owner.height);
            posChanged(false);
            return;
        }// end function

        function handleControllerChanged(param1:Controller) : void
        {
            if (_pageController == param1)
            {
                if (_scrollType == 0)
                {
                    this.setCurrentPageX(param1.selectedIndex, true);
                }
                else
                {
                    this.setCurrentPageY(param1.selectedIndex, true);
                }
            }
            return;
        }// end function

        private function updatePageController() : void
        {
            var _loc_2:* = 0;
            var _loc_1:* = null;
            if (_pageController != null && !_pageController.changing)
            {
                if (_scrollType == 0)
                {
                    _loc_2 = this.currentPageX;
                }
                else
                {
                    _loc_2 = this.currentPageY;
                }
                if (_loc_2 < _pageController.pageCount)
                {
                    _loc_1 = _pageController;
                    _pageController = null;
                    _loc_1.selectedIndex = _loc_2;
                    _pageController = _loc_1;
                }
            }
            return;
        }// end function

        function adjustMaskContainer() : void
        {
            var _loc_2:* = NaN;
            var _loc_1:* = NaN;
            if (_displayOnLeft && _vtScrollBar != null && !_floating)
            {
                _loc_1 = Math.floor(_owner.margin.left + _vtScrollBar.width);
            }
            else
            {
                _loc_1 = Math.floor(_owner.margin.left);
            }
            _loc_2 = Math.floor(_owner.margin.top);
            _maskContainer.x = _loc_1;
            _maskContainer.y = _loc_2;
            if (_owner._alignOffset.x != 0 || _owner._alignOffset.y != 0)
            {
                if (_alignContainer == null)
                {
                    _alignContainer = new Sprite();
                    _alignContainer.mouseEnabled = false;
                    _maskContainer.addChild(_alignContainer);
                    _alignContainer.addChild(_container);
                }
                _alignContainer.x = _owner._alignOffset.x;
                _alignContainer.y = _owner._alignOffset.y;
            }
            else if (_alignContainer)
            {
                var _loc_3:* = 0;
                _alignContainer.y = 0;
                _alignContainer.x = _loc_3;
            }
            return;
        }// end function

        private function setSize(param1:Number, param2:Number) : void
        {
            adjustMaskContainer();
            if (_hzScrollBar)
            {
                _hzScrollBar.y = param2 - _hzScrollBar.height;
                if (_vtScrollBar)
                {
                    _hzScrollBar.width = param1 - _vtScrollBar.width - _scrollBarMargin.left - _scrollBarMargin.right;
                    if (_displayOnLeft)
                    {
                        _hzScrollBar.x = _scrollBarMargin.left + _vtScrollBar.width;
                    }
                    else
                    {
                        _hzScrollBar.x = _scrollBarMargin.left;
                    }
                }
                else
                {
                    _hzScrollBar.width = param1 - _scrollBarMargin.left - _scrollBarMargin.right;
                    _hzScrollBar.x = _scrollBarMargin.left;
                }
            }
            if (_vtScrollBar)
            {
                if (!_displayOnLeft)
                {
                    _vtScrollBar.x = param1 - _vtScrollBar.width;
                }
                if (_hzScrollBar)
                {
                    _vtScrollBar.height = param2 - _hzScrollBar.height - _scrollBarMargin.top - _scrollBarMargin.bottom;
                }
                else
                {
                    _vtScrollBar.height = param2 - _scrollBarMargin.top - _scrollBarMargin.bottom;
                }
                _vtScrollBar.y = _scrollBarMargin.top;
            }
            _viewSize.x = param1;
            _viewSize.y = param2;
            if (_hzScrollBar && !_floating)
            {
                _viewSize.y = _viewSize.y - _hzScrollBar.height;
            }
            if (_vtScrollBar && !_floating)
            {
                _viewSize.x = _viewSize.x - _vtScrollBar.width;
            }
            _viewSize.x = _viewSize.x - (_owner.margin.left + _owner.margin.right);
            _viewSize.y = _viewSize.y - (_owner.margin.top + _owner.margin.bottom);
            _viewSize.x = Math.max(1, _viewSize.x);
            _viewSize.y = Math.max(1, _viewSize.y);
            _pageSize.x = _viewSize.x;
            _pageSize.y = _viewSize.y;
            handleSizeChanged();
            return;
        }// end function

        function setContentSize(param1:Number, param2:Number) : void
        {
            if (_contentSize.x == param1 && _contentSize.y == param2)
            {
                return;
            }
            _contentSize.x = param1;
            _contentSize.y = param2;
            handleSizeChanged();
            return;
        }// end function

        function changeContentSizeOnScrolling(param1:Number, param2:Number, param3:Number, param4:Number) : void
        {
            var _loc_5:* = _xPos == _overlapSize.x;
            var _loc_6:* = _yPos == _overlapSize.y;
            _contentSize.x = _contentSize.x + param1;
            _contentSize.y = _contentSize.y + param2;
            handleSizeChanged();
            if (_tweening == 1)
            {
                if (param1 != 0 && _loc_5 && _tweenChange.x < 0)
                {
                    _xPos = _overlapSize.x;
                    _tweenChange.x = -_xPos - _tweenStart.x;
                }
                if (param2 != 0 && _loc_6 && _tweenChange.y < 0)
                {
                    _yPos = _overlapSize.y;
                    _tweenChange.y = -_yPos - _tweenStart.y;
                }
            }
            else if (_tweening == 2)
            {
                if (param3 != 0)
                {
                    _container.x = _container.x - param3;
                    _tweenStart.x = _tweenStart.x - param3;
                    _xPos = -_container.x;
                }
                if (param4 != 0)
                {
                    _container.y = _container.y - param4;
                    _tweenStart.y = _tweenStart.y - param4;
                    _yPos = -_container.y;
                }
            }
            else if (isDragged)
            {
                if (param3 != 0)
                {
                    _container.x = _container.x - param3;
                    _containerPos.x = _containerPos.x - param3;
                    _xPos = -_container.x;
                }
                if (param4 != 0)
                {
                    _container.y = _container.y - param4;
                    _containerPos.y = _containerPos.y - param4;
                    _yPos = -_container.y;
                }
            }
            else
            {
                if (param1 != 0 && _loc_5)
                {
                    _xPos = _overlapSize.x;
                    _container.x = -_xPos;
                }
                if (param2 != 0 && _loc_6)
                {
                    _yPos = _overlapSize.y;
                    _container.y = -_yPos;
                }
            }
            if (_pageMode)
            {
                updatePageController();
            }
            return;
        }// end function

        private function handleSizeChanged(param1:Boolean = false) : void
        {
            var _loc_3:* = NaN;
            if (_displayInDemand)
            {
                _vScrollNone = _contentSize.y <= _viewSize.y;
                _hScrollNone = _contentSize.x <= _viewSize.x;
            }
            if (_vtScrollBar)
            {
                if (_contentSize.y == 0)
                {
                    _vtScrollBar.setDisplayPerc(0);
                }
                else
                {
                    _vtScrollBar.setDisplayPerc(Math.min(1, _viewSize.y / _contentSize.y));
                }
            }
            if (_hzScrollBar)
            {
                if (_contentSize.x == 0)
                {
                    _hzScrollBar.setDisplayPerc(0);
                }
                else
                {
                    _hzScrollBar.setDisplayPerc(Math.min(1, _viewSize.x / _contentSize.x));
                }
            }
            updateScrollBarVisible();
            var _loc_2:* = _maskContainer.scrollRect;
            if (_loc_2)
            {
                _loc_2.width = _viewSize.x;
                _loc_2.height = _viewSize.y;
                if (_vScrollNone && _vtScrollBar)
                {
                    _loc_2.width = _loc_2.width + _vtScrollBar.width;
                }
                if (_hScrollNone && _hzScrollBar)
                {
                    _loc_2.height = _loc_2.height + _hzScrollBar.height;
                }
                _maskContainer.scrollRect = _loc_2;
            }
            if (_scrollType == 0 || _scrollType == 2)
            {
                _overlapSize.x = Math.ceil(Math.max(0, _contentSize.x - _viewSize.x));
            }
            else
            {
                _overlapSize.x = 0;
            }
            if (_scrollType == 1 || _scrollType == 2)
            {
                _overlapSize.y = Math.ceil(Math.max(0, _contentSize.y - _viewSize.y));
            }
            else
            {
                _overlapSize.y = 0;
            }
            _xPos = ToolSet.clamp(_xPos, 0, _overlapSize.x);
            _yPos = ToolSet.clamp(_yPos, 0, _overlapSize.y);
            if (_refreshBarAxis != null)
            {
                _loc_3 = _overlapSize[_refreshBarAxis];
                if (_loc_3 == 0)
                {
                    _loc_3 = Math.max(_contentSize[_refreshBarAxis] + _footerLockedSize - _viewSize[_refreshBarAxis], 0);
                }
                else
                {
                    _loc_3 = _loc_3 + _footerLockedSize;
                }
                if (_refreshBarAxis == "x")
                {
                    _container.x = ToolSet.clamp(_container.x, -_loc_3, _headerLockedSize);
                    _container.y = ToolSet.clamp(_container.y, -_overlapSize.y, 0);
                }
                else
                {
                    _container.x = ToolSet.clamp(_container.x, -_overlapSize.x, 0);
                    _container.y = ToolSet.clamp(_container.y, -_loc_3, _headerLockedSize);
                }
                if (_header != null)
                {
                    if (_refreshBarAxis == "x")
                    {
                        _header.height = _viewSize.y;
                    }
                    else
                    {
                        _header.width = _viewSize.x;
                    }
                }
                if (_footer != null)
                {
                    if (_refreshBarAxis == "y")
                    {
                        _footer.height = _viewSize.y;
                    }
                    else
                    {
                        _footer.width = _viewSize.x;
                    }
                }
            }
            else
            {
                _container.x = ToolSet.clamp(_container.x, -_overlapSize.x, 0);
                _container.y = ToolSet.clamp(_container.y, -_overlapSize.y, 0);
            }
            updateScrollBarPos();
            if (_pageMode)
            {
                updatePageController();
            }
            return;
        }// end function

        private function posChanged(param1:Boolean) : void
        {
            if (_aniFlag == 0)
            {
                _aniFlag = param1 ? (1) : (-1);
            }
            else if (_aniFlag == 1 && !param1)
            {
                _aniFlag = -1;
            }
            _needRefresh = true;
            GTimers.inst.callLater(refresh);
            return;
        }// end function

        private function refresh() : void
        {
            _needRefresh = false;
            GTimers.inst.remove(refresh);
            if (_pageMode || _snapToItem)
            {
                sEndPos.setTo(-_xPos, -_yPos);
                alignPosition(sEndPos, false);
                _xPos = -sEndPos.x;
                _yPos = -sEndPos.y;
            }
            refresh2();
            dispatchEvent(new Event("scroll"));
            if (_needRefresh)
            {
                _needRefresh = false;
                GTimers.inst.remove(refresh);
                refresh2();
            }
            updateScrollBarPos();
            _aniFlag = 0;
            return;
        }// end function

        private function refresh2() : void
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            if (_aniFlag == 1 && !isDragged)
            {
                if (_overlapSize.x > 0)
                {
                    _loc_1 = -_xPos;
                }
                else
                {
                    if (_container.x != 0)
                    {
                        _container.x = 0;
                    }
                    _loc_1 = 0;
                }
                if (_overlapSize.y > 0)
                {
                    _loc_2 = -_yPos;
                }
                else
                {
                    if (_container.y != 0)
                    {
                        _container.y = 0;
                    }
                    _loc_2 = 0;
                }
                if (_loc_1 != _container.x || _loc_2 != _container.y)
                {
                    _tweenDuration.setTo(0.5, 0.5);
                    _tweenStart.setTo(_container.x, _container.y);
                    _tweenChange.setTo(_loc_1 - _tweenStart.x, _loc_2 - _tweenStart.y);
                    startTween(1);
                }
                else if (_tweening != 0)
                {
                    killTween();
                }
            }
            else
            {
                if (_tweening != 0)
                {
                    killTween();
                }
                _container.x = -_xPos;
                _container.y = -_yPos;
                loopCheckingCurrent();
            }
            if (_pageMode)
            {
                updatePageController();
            }
            return;
        }// end function

        private function __mouseDown(event:GTouchEvent) : void
        {
            if (!_touchEffect)
            {
                return;
            }
            if (_tweening != 0)
            {
                killTween();
                isDragged = true;
            }
            else
            {
                isDragged = false;
            }
            var _loc_2:* = _owner.globalToLocal(event.stageX, event.stageY);
            _containerPos.setTo(_container.x, _container.y);
            _beginTouchPos.copyFrom(_loc_2);
            _lastTouchPos.copyFrom(_loc_2);
            _lastTouchGlobalPos.setTo(event.stageX, event.stageY);
            _isHoldAreaDone = false;
            _velocity.setTo(0, 0);
            _velocityScale = 1;
            _lastMoveTime = this.getTimer() / 1000;
            _owner.addEventListener("dragGTouch", __mouseMove);
            return;
        }// end function

        private function __mouseMove(event:GTouchEvent) : void
        {
            var _loc_15:* = 0;
            var _loc_19:* = NaN;
            var _loc_6:* = NaN;
            var _loc_9:* = false;
            var _loc_2:* = false;
            var _loc_3:* = false;
            var _loc_7:* = NaN;
            var _loc_17:* = NaN;
            if (!_touchEffect)
            {
                return;
            }
            if (draggingPane != null && draggingPane != this || GObject.draggingObject != null)
            {
                return;
            }
            var _loc_4:* = _owner.globalToLocal(event.stageX, event.stageY);
            if (GRoot.touchScreen)
            {
                _loc_15 = UIConfig.touchScrollSensitivity;
            }
            else
            {
                _loc_15 = 8;
            }
            if (_scrollType == 1)
            {
                if (!_isHoldAreaDone)
                {
                    _gestureFlag = _gestureFlag | 1;
                    _loc_6 = Math.abs(_beginTouchPos.y - _loc_4.y);
                    if (_loc_6 < _loc_15)
                    {
                        return;
                    }
                    if ((_gestureFlag & 2) != 0)
                    {
                        _loc_19 = Math.abs(_beginTouchPos.x - _loc_4.x);
                        if (_loc_6 < _loc_19)
                        {
                            return;
                        }
                    }
                }
                _loc_3 = true;
            }
            else if (_scrollType == 0)
            {
                if (!_isHoldAreaDone)
                {
                    _gestureFlag = _gestureFlag | 2;
                    _loc_6 = Math.abs(_beginTouchPos.x - _loc_4.x);
                    if (_loc_6 < _loc_15)
                    {
                        return;
                    }
                    if ((_gestureFlag & 1) != 0)
                    {
                        _loc_19 = Math.abs(_beginTouchPos.y - _loc_4.y);
                        if (_loc_6 < _loc_19)
                        {
                            return;
                        }
                    }
                }
                _loc_9 = true;
            }
            else
            {
                _gestureFlag = 3;
                if (!_isHoldAreaDone)
                {
                    _loc_6 = Math.abs(_beginTouchPos.y - _loc_4.y);
                    if (_loc_6 < _loc_15)
                    {
                        _loc_6 = Math.abs(_beginTouchPos.x - _loc_4.x);
                        if (_loc_6 < _loc_15)
                        {
                            return;
                        }
                    }
                }
                _loc_9 = true;
                _loc_3 = true;
            }
            var _loc_18:* = _containerPos.x + _loc_4.x - _beginTouchPos.x;
            var _loc_16:* = _containerPos.y + _loc_4.y - _beginTouchPos.y;
            if (_loc_3)
            {
                if (_loc_16 > 0)
                {
                    if (!_bouncebackEffect)
                    {
                        _container.y = 0;
                    }
                    else if (_header != null && _header.maxHeight != 0)
                    {
                        _container.y = Math.min(_loc_16 * 0.5, _header.maxHeight);
                    }
                    else
                    {
                        _container.y = Math.min(_loc_16 * 0.5, _viewSize.y * 0.5);
                    }
                }
                else if (_loc_16 < -_overlapSize.y)
                {
                    if (!_bouncebackEffect)
                    {
                        _container.y = -_overlapSize.y;
                    }
                    else if (_footer != null && _footer.maxHeight > 0)
                    {
                        _container.y = Math.max((_loc_16 + _overlapSize.y) * 0.5, -_footer.maxHeight) - _overlapSize.y;
                    }
                    else
                    {
                        _container.y = Math.max((_loc_16 + _overlapSize.y) * 0.5, (-_viewSize.y) * 0.5) - _overlapSize.y;
                    }
                }
                else
                {
                    _container.y = _loc_16;
                }
            }
            if (_loc_9)
            {
                if (_loc_18 > 0)
                {
                    if (!_bouncebackEffect)
                    {
                        _container.x = 0;
                    }
                    else if (_header != null && _header.maxWidth != 0)
                    {
                        _container.x = Math.min(_loc_18 * 0.5, _header.maxWidth);
                    }
                    else
                    {
                        _container.x = Math.min(_loc_18 * 0.5, _viewSize.x * 0.5);
                    }
                }
                else if (_loc_18 < -_overlapSize.x)
                {
                    if (!_bouncebackEffect)
                    {
                        _container.x = -_overlapSize.x;
                    }
                    else if (_footer != null && _footer.maxWidth > 0)
                    {
                        _container.x = Math.max((_loc_18 + _overlapSize.x) * 0.5, -_footer.maxWidth) - _overlapSize.x;
                    }
                    else
                    {
                        _container.x = Math.max((_loc_18 + _overlapSize.x) * 0.5, (-_viewSize.x) * 0.5) - _overlapSize.x;
                    }
                }
                else
                {
                    _container.x = _loc_18;
                }
            }
            var _loc_8:* = _owner.displayObject.stage.frameRate;
            var _loc_11:* = this.getTimer() / 1000;
            var _loc_5:* = Math.max(_loc_11 - _lastMoveTime, 1 / _loc_8);
            var _loc_14:* = _loc_4.x - _lastTouchPos.x;
            var _loc_10:* = _loc_4.y - _lastTouchPos.y;
            if (!_loc_9)
            {
                _loc_14 = 0;
            }
            if (!_loc_3)
            {
                _loc_10 = 0;
            }
            if (_loc_5 != 0)
            {
                _loc_7 = _loc_5 * _loc_8 - 1;
                if (_loc_7 > 1)
                {
                    _loc_17 = Math.pow(0.833, _loc_7);
                    _velocity.x = _velocity.x * _loc_17;
                    _velocity.y = _velocity.y * _loc_17;
                }
                _velocity.x = ToolSet.lerp(_velocity.x, _loc_14 * 60 / _loc_8 / _loc_5, _loc_5 * 10);
                _velocity.y = ToolSet.lerp(_velocity.y, _loc_10 * 60 / _loc_8 / _loc_5, _loc_5 * 10);
            }
            var _loc_12:* = _lastTouchGlobalPos.x - event.stageX;
            var _loc_13:* = _lastTouchGlobalPos.y - event.stageY;
            if (_loc_14 != 0)
            {
                _velocityScale = Math.abs(_loc_12 / _loc_14);
            }
            else if (_loc_10 != 0)
            {
                _velocityScale = Math.abs(_loc_13 / _loc_10);
            }
            _lastTouchPos.setTo(_loc_4.x, _loc_4.y);
            _lastTouchGlobalPos.setTo(event.stageX, event.stageY);
            _lastMoveTime = _loc_11;
            if (_overlapSize.x > 0)
            {
                _xPos = ToolSet.clamp(-_container.x, 0, _overlapSize.x);
            }
            if (_overlapSize.y > 0)
            {
                _yPos = ToolSet.clamp(-_container.y, 0, _overlapSize.y);
            }
            if (_loop != 0)
            {
                _loc_18 = _container.x;
                _loc_16 = _container.y;
                if (loopCheckingCurrent())
                {
                    _containerPos.x = _containerPos.x + (_container.x - _loc_18);
                    _containerPos.y = _containerPos.y + (_container.y - _loc_16);
                }
            }
            draggingPane = this;
            _isHoldAreaDone = true;
            isDragged = true;
            _maskContainer.mouseChildren = false;
            updateScrollBarPos();
            updateScrollBarVisible();
            if (_pageMode)
            {
                updatePageController();
            }
            dispatchEvent(new Event("scroll"));
            return;
        }// end function

        private function __mouseUp(event:Event) : void
        {
            var _loc_5:* = NaN;
            var _loc_3:* = NaN;
            var _loc_2:* = NaN;
            var _loc_6:* = NaN;
            _owner.removeEventListener("dragGTouch", __mouseMove);
            if (draggingPane == this)
            {
                draggingPane = null;
            }
            _gestureFlag = 0;
            if (!isDragged || !_touchEffect)
            {
                isDragged = false;
                _maskContainer.mouseChildren = true;
                return;
            }
            isDragged = false;
            _maskContainer.mouseChildren = true;
            _tweenStart.setTo(_container.x, _container.y);
            sEndPos.copyFrom(_tweenStart);
            var _loc_4:* = false;
            if (_container.x > 0)
            {
                sEndPos.x = 0;
                _loc_4 = true;
            }
            else if (_container.x < -_overlapSize.x)
            {
                sEndPos.x = -_overlapSize.x;
                _loc_4 = true;
            }
            if (_container.y > 0)
            {
                sEndPos.y = 0;
                _loc_4 = true;
            }
            else if (_container.y < -_overlapSize.y)
            {
                sEndPos.y = -_overlapSize.y;
                _loc_4 = true;
            }
            if (_loc_4)
            {
                _tweenChange.setTo(sEndPos.x - _tweenStart.x, sEndPos.y - _tweenStart.y);
                if (_tweenChange.x < -UIConfig.touchDragSensitivity || _tweenChange.y < -UIConfig.touchDragSensitivity)
                {
                    _refreshEventDispatching = true;
                    dispatchEvent(new Event("pullDownRelease"));
                    _refreshEventDispatching = false;
                }
                else if (_tweenChange.x > UIConfig.touchDragSensitivity || _tweenChange.y > UIConfig.touchDragSensitivity)
                {
                    _refreshEventDispatching = true;
                    dispatchEvent(new Event("pullUpRelease"));
                    _refreshEventDispatching = false;
                }
                if (_headerLockedSize > 0 && sEndPos[_refreshBarAxis] == 0)
                {
                    sEndPos[_refreshBarAxis] = _headerLockedSize;
                    _tweenChange.x = sEndPos.x - _tweenStart.x;
                    _tweenChange.y = sEndPos.y - _tweenStart.y;
                }
                else if (_footerLockedSize > 0 && sEndPos[_refreshBarAxis] == -_overlapSize[_refreshBarAxis])
                {
                    _loc_5 = _overlapSize[_refreshBarAxis];
                    if (_loc_5 == 0)
                    {
                        _loc_5 = Math.max(_contentSize[_refreshBarAxis] + _footerLockedSize - _viewSize[_refreshBarAxis], 0);
                    }
                    else
                    {
                        _loc_5 = _loc_5 + _footerLockedSize;
                    }
                    sEndPos[_refreshBarAxis] = -_loc_5;
                    _tweenChange.x = sEndPos.x - _tweenStart.x;
                    _tweenChange.y = sEndPos.y - _tweenStart.y;
                }
                _tweenDuration.setTo(0.3, 0.3);
            }
            else
            {
                if (!_inertiaDisabled)
                {
                    _loc_3 = _owner.displayObject.stage.frameRate;
                    _loc_2 = (this.getTimer() / 1000 - _lastMoveTime) * _loc_3 - 1;
                    if (_loc_2 > 1)
                    {
                        _loc_6 = Math.pow(0.833, _loc_2);
                        _velocity.x = _velocity.x * _loc_6;
                        _velocity.y = _velocity.y * _loc_6;
                    }
                    updateTargetAndDuration(_tweenStart, sEndPos);
                }
                else
                {
                    _tweenDuration.setTo(0.3, 0.3);
                }
                sOldChange.setTo(sEndPos.x - _tweenStart.x, sEndPos.y - _tweenStart.y);
                loopCheckingTarget(sEndPos);
                if (_pageMode || _snapToItem)
                {
                    alignPosition(sEndPos, true);
                }
                _tweenChange.x = sEndPos.x - _tweenStart.x;
                _tweenChange.y = sEndPos.y - _tweenStart.y;
                if (_tweenChange.x == 0 && _tweenChange.y == 0)
                {
                    updateScrollBarVisible();
                    return;
                }
                if (_pageMode || _snapToItem)
                {
                    fixDuration("x", sOldChange.x);
                    fixDuration("y", sOldChange.y);
                }
            }
            startTween(2);
            return;
        }// end function

        private function __mouseWheel(event:MouseEvent) : void
        {
            if (!_mouseWheelEnabled && (!_vtScrollBar || !_vtScrollBar._rootContainer.hitTestObject(this.DisplayObject(event.target))) && (!_hzScrollBar || !_hzScrollBar._rootContainer.hitTestObject(this.DisplayObject(event.target))))
            {
                return;
            }
            var _loc_3:* = _owner.displayObject.stage.focus;
            if (_loc_3 is TextField && this.TextField(_loc_3).type == "input")
            {
                return;
            }
            var _loc_2:* = event.delta;
            _loc_2 = _loc_2 > 0 ? (-1) : (_loc_2 < 0 ? (1) : (0));
            if (_overlapSize.x > 0 && _overlapSize.y == 0)
            {
                if (_pageMode)
                {
                    setPosX(_xPos + _pageSize.x * _loc_2, false);
                }
                else
                {
                    setPosX(_xPos + _mouseWheelStep * _loc_2, false);
                }
            }
            else if (_pageMode)
            {
                setPosY(_yPos + _pageSize.y * _loc_2, false);
            }
            else
            {
                setPosY(_yPos + _mouseWheelStep * _loc_2, false);
            }
            return;
        }// end function

        private function __rollOver(event:Event) : void
        {
            _hover = true;
            updateScrollBarVisible();
            return;
        }// end function

        private function __rollOut(event:Event) : void
        {
            _hover = false;
            updateScrollBarVisible();
            return;
        }// end function

        private function updateScrollBarPos() : void
        {
            if (_vtScrollBar != null)
            {
                _vtScrollBar.setScrollPerc(_overlapSize.y == 0 ? (0) : (ToolSet.clamp(-_container.y, 0, _overlapSize.y) / _overlapSize.y));
            }
            if (_hzScrollBar != null)
            {
                _hzScrollBar.setScrollPerc(_overlapSize.x == 0 ? (0) : (ToolSet.clamp(-_container.x, 0, _overlapSize.x) / _overlapSize.x));
            }
            checkRefreshBar();
            return;
        }// end function

        function updateScrollBarVisible() : void
        {
            if (_vtScrollBar)
            {
                if (_viewSize.y <= _vtScrollBar.minSize || _vScrollNone)
                {
                    _vtScrollBar.displayObject.visible = false;
                }
                else
                {
                    updateScrollBarVisible2(_vtScrollBar);
                }
            }
            if (_hzScrollBar)
            {
                if (_viewSize.x <= _hzScrollBar.minSize || _hScrollNone)
                {
                    _hzScrollBar.displayObject.visible = false;
                }
                else
                {
                    updateScrollBarVisible2(_hzScrollBar);
                }
            }
            return;
        }// end function

        private function updateScrollBarVisible2(param1:GScrollBar) : void
        {
            if (_scrollBarDisplayAuto)
            {
                GTween.kill(param1, false, "alpha");
            }
            if (_scrollBarDisplayAuto && !_hover && _tweening == 0 && !isDragged && !param1.gripDragging)
            {
                if (param1.displayObject.visible)
                {
                    GTween.to(1, 0, 0.5).setDelay(0.5).onComplete(__barTweenComplete).setTarget(param1, "alpha");
                }
            }
            else
            {
                param1.alpha = 1;
                param1.displayObject.visible = true;
            }
            return;
        }// end function

        private function __barTweenComplete(param1:GTweener) : void
        {
            var _loc_2:* = this.GObject(param1.target);
            _loc_2.alpha = 1;
            _loc_2.displayObject.visible = false;
            return;
        }// end function

        private function getLoopPartSize(param1:Number, param2:String) : Number
        {
            return (_contentSize[param2] + (param2 == "x" ? (this.GList(_owner).columnGap) : (this.GList(_owner).lineGap))) / param1;
        }// end function

        private function loopCheckingCurrent() : Boolean
        {
            var _loc_1:* = false;
            if (_loop == 1 && _overlapSize.x > 0)
            {
                if (_xPos < 0.001)
                {
                    _xPos = _xPos + getLoopPartSize(2, "x");
                    _loc_1 = true;
                }
                else if (_xPos >= _overlapSize.x)
                {
                    _xPos = _xPos - getLoopPartSize(2, "x");
                    _loc_1 = true;
                }
            }
            else if (_loop == 2 && _overlapSize.y > 0)
            {
                if (_yPos < 0.001)
                {
                    _yPos = _yPos + getLoopPartSize(2, "y");
                    _loc_1 = true;
                }
                else if (_yPos >= _overlapSize.y)
                {
                    _yPos = _yPos - getLoopPartSize(2, "y");
                    _loc_1 = true;
                }
            }
            if (_loc_1)
            {
                _container.x = -_xPos;
                _container.y = -_yPos;
            }
            return _loc_1;
        }// end function

        private function loopCheckingTarget(param1:Point) : void
        {
            if (_loop == 1)
            {
                loopCheckingTarget2(param1, "x");
            }
            if (_loop == 2)
            {
                loopCheckingTarget2(param1, "y");
            }
            return;
        }// end function

        private function loopCheckingTarget2(param1:Point, param2:String) : void
        {
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            if (param1[param2] > 0)
            {
                _loc_3 = getLoopPartSize(2, param2);
                _loc_4 = _tweenStart[param2] - _loc_3;
                if (_loc_4 <= 0 && _loc_4 >= -_overlapSize[param2])
                {
                    var _loc_5:* = param2;
                    var _loc_6:* = param1[_loc_5] - _loc_3;
                    param1[_loc_5] = _loc_6;
                    _tweenStart[param2] = _loc_4;
                }
            }
            else if (param1[param2] < -_overlapSize[param2])
            {
                _loc_3 = getLoopPartSize(2, param2);
                _loc_4 = _tweenStart[param2] + _loc_3;
                if (_loc_4 <= 0 && _loc_4 >= -_overlapSize[param2])
                {
                    _loc_6 = param2;
                    _loc_5 = param1[_loc_6] + _loc_3;
                    param1[_loc_6] = _loc_5;
                    _tweenStart[param2] = _loc_4;
                }
            }
            return;
        }// end function

        private function loopCheckingNewPos(param1:Number, param2:String) : Number
        {
            var _loc_4:* = NaN;
            if (_overlapSize[param2] == 0)
            {
                return param1;
            }
            var _loc_3:* = param2 == "x" ? (_xPos) : (_yPos);
            var _loc_5:* = false;
            if (param1 < 0.001)
            {
                param1 = param1 + getLoopPartSize(2, param2);
                if (param1 > _loc_3)
                {
                    _loc_4 = getLoopPartSize(6, param2);
                    _loc_4 = Math.ceil((param1 - _loc_3) / _loc_4) * _loc_4;
                    _loc_3 = ToolSet.clamp(_loc_3 + _loc_4, 0, _overlapSize[param2]);
                    _loc_5 = true;
                }
            }
            else if (param1 >= _overlapSize[param2])
            {
                param1 = param1 - getLoopPartSize(2, param2);
                if (param1 < _loc_3)
                {
                    _loc_4 = getLoopPartSize(6, param2);
                    _loc_4 = Math.ceil((_loc_3 - param1) / _loc_4) * _loc_4;
                    _loc_3 = ToolSet.clamp(_loc_3 - _loc_4, 0, _overlapSize[param2]);
                    _loc_5 = true;
                }
            }
            if (_loc_5)
            {
                if (param2 == "x")
                {
                    _container.x = -_loc_3;
                }
                else
                {
                    _container.y = -_loc_3;
                }
            }
            return param1;
        }// end function

        private function alignPosition(param1:Point, param2:Boolean) : void
        {
            var _loc_3:* = null;
            if (_pageMode)
            {
                param1.x = alignByPage(param1.x, "x", param2);
                param1.y = alignByPage(param1.y, "y", param2);
            }
            else if (_snapToItem)
            {
                _loc_3 = _owner.getSnappingPosition(-param1.x, -param1.y, sHelperPoint);
                if (param1.x < 0 && param1.x > -_overlapSize.x)
                {
                    param1.x = -_loc_3.x;
                }
                if (param1.y < 0 && param1.y > -_overlapSize.y)
                {
                    param1.y = -_loc_3.y;
                }
            }
            return;
        }// end function

        private function alignByPage(param1:Number, param2:String, param3:Boolean) : Number
        {
            var _loc_9:* = 0;
            var _loc_6:* = NaN;
            var _loc_10:* = NaN;
            var _loc_8:* = NaN;
            var _loc_7:* = NaN;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            if (param1 > 0)
            {
                _loc_9 = 0;
            }
            else if (param1 < -_overlapSize[param2])
            {
                _loc_9 = Math.ceil(_contentSize[param2] / _pageSize[param2]) - 1;
            }
            else
            {
                _loc_9 = Math.floor((-param1) / _pageSize[param2]);
                _loc_6 = param3 ? (param1 - _containerPos[param2]) : (param1 - _container[param2]);
                _loc_10 = Math.min(_pageSize[param2], _contentSize[param2] - (_loc_9 + 1) * _pageSize[param2]);
                _loc_8 = -param1 - _loc_9 * _pageSize[param2];
                if (Math.abs(_loc_6) > _pageSize[param2])
                {
                    if (_loc_8 > _loc_10 * 0.5)
                    {
                        _loc_9++;
                    }
                }
                else if (_loc_8 > _loc_10 * (_loc_6 < 0 ? (0.3) : (0.7)))
                {
                    _loc_9++;
                }
                param1 = (-_loc_9) * _pageSize[param2];
                if (param1 < -_overlapSize[param2])
                {
                    param1 = -_overlapSize[param2];
                }
            }
            if (param3)
            {
                _loc_7 = _tweenStart[param2];
                if (_loc_7 > 0)
                {
                    _loc_4 = 0;
                }
                else if (_loc_7 < -_overlapSize[param2])
                {
                    _loc_4 = Math.ceil(_contentSize[param2] / _pageSize[param2]) - 1;
                }
                else
                {
                    _loc_4 = Math.floor((-_loc_7) / _pageSize[param2]);
                }
                _loc_5 = Math.floor((-_containerPos[param2]) / _pageSize[param2]);
                if (Math.abs(_loc_9 - _loc_5) > 1 && Math.abs(_loc_4 - _loc_5) <= 1)
                {
                    if (_loc_9 > _loc_5)
                    {
                        _loc_9 = _loc_5 + 1;
                    }
                    else
                    {
                        _loc_9 = _loc_5 - 1;
                    }
                    param1 = (-_loc_9) * _pageSize[param2];
                }
            }
            return param1;
        }// end function

        private function updateTargetAndDuration(param1:Point, param2:Point) : void
        {
            param2.x = updateTargetAndDuration2(param1.x, "x");
            param2.y = updateTargetAndDuration2(param1.y, "y");
            return;
        }// end function

        private function updateTargetAndDuration2(param1:Number, param2:String) : Number
        {
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_5:* = 0;
            var _loc_4:* = _velocity[param2];
            var _loc_3:* = 0;
            if (param1 > 0)
            {
                param1 = 0;
            }
            else if (param1 < -_overlapSize[param2])
            {
                param1 = -_overlapSize[param2];
            }
            else
            {
                _loc_6 = Math.abs(_loc_4) * _velocityScale;
                if (GRoot.touchPointInput)
                {
                    _loc_6 = _loc_6 * (1136 / Math.max(GRoot.inst.nativeStage.stageWidth, GRoot.inst.nativeStage.stageHeight));
                }
                _loc_7 = 0;
                if (_pageMode || !GRoot.touchPointInput)
                {
                    if (_loc_6 > 500)
                    {
                        _loc_7 = Math.pow((_loc_6 - 500) / 500, 2);
                    }
                }
                else if (_loc_6 > 1000)
                {
                    _loc_7 = Math.pow((_loc_6 - 1000) / 1000, 2);
                }
                if (_loc_7 != 0)
                {
                    if (_loc_7 > 1)
                    {
                        _loc_7 = 1;
                    }
                    _loc_6 = _loc_6 * _loc_7;
                    _loc_4 = _loc_4 * _loc_7;
                    _velocity[param2] = _loc_4;
                    _loc_3 = Math.log(60 / _loc_6) / Math.log(_decelerationRate) / 60;
                    _loc_5 = _loc_4 * _loc_3 * 0.4;
                    param1 = param1 + _loc_5;
                }
            }
            if (_loc_3 < 0.3)
            {
                _loc_3 = 0.3;
            }
            _tweenDuration[param2] = _loc_3;
            return param1;
        }// end function

        private function fixDuration(param1:String, param2:Number) : void
        {
            if (_tweenChange[param1] == 0 || Math.abs(_tweenChange[param1]) >= Math.abs(param2))
            {
                return;
            }
            var _loc_3:* = Math.abs(_tweenChange[param1] / param2) * _tweenDuration[param1];
            if (_loc_3 < 0.3)
            {
                _loc_3 = 0.3;
            }
            _tweenDuration[param1] = _loc_3;
            return;
        }// end function

        private function startTween(param1:int) : void
        {
            _tweenTime.setTo(0, 0);
            _tweening = param1;
            GTimers.inst.callBy60Fps(tweenUpdate);
            updateScrollBarVisible();
            return;
        }// end function

        private function killTween() : void
        {
            if (_tweening == 1)
            {
                _container.x = _tweenStart.x + _tweenChange.x;
                _container.y = _tweenStart.y + _tweenChange.y;
                dispatchEvent(new Event("scroll"));
            }
            _tweening = 0;
            GTimers.inst.remove(tweenUpdate);
            updateScrollBarVisible();
            dispatchEvent(new Event("scrollEnd"));
            return;
        }// end function

        private function checkRefreshBar() : void
        {
            var _loc_1:* = null;
            var _loc_3:* = NaN;
            if (_header == null && _footer == null)
            {
                return;
            }
            var _loc_2:* = _container[_refreshBarAxis];
            if (_header != null)
            {
                if (_loc_2 > 0)
                {
                    if (_header.displayObject.parent == null)
                    {
                        _maskContainer.addChildAt(_header.displayObject, 0);
                    }
                    _loc_1 = sHelperPoint;
                    _loc_1.setTo(_header.width, _header.height);
                    _loc_1[_refreshBarAxis] = _loc_2;
                    _header.setSize(_loc_1.x, _loc_1.y);
                }
                else if (_header.displayObject.parent != null)
                {
                    _maskContainer.removeChild(_header.displayObject);
                }
            }
            if (_footer != null)
            {
                _loc_3 = _overlapSize[_refreshBarAxis];
                if (_loc_2 < -_loc_3 || _loc_3 == 0 && _footerLockedSize > 0)
                {
                    if (_footer.displayObject.parent == null)
                    {
                        _maskContainer.addChildAt(_footer.displayObject, 0);
                    }
                    _loc_1 = sHelperPoint;
                    _loc_1.setTo(_footer.x, _footer.y);
                    if (_loc_3 > 0)
                    {
                        _loc_1[_refreshBarAxis] = _loc_2 + _contentSize[_refreshBarAxis];
                    }
                    else
                    {
                        _loc_1[_refreshBarAxis] = Math.max(Math.min(_loc_2 + _viewSize[_refreshBarAxis], _viewSize[_refreshBarAxis] - _footerLockedSize), _viewSize[_refreshBarAxis] - _contentSize[_refreshBarAxis]);
                    }
                    _footer.setXY(_loc_1.x, _loc_1.y);
                    _loc_1.setTo(_footer.width, _footer.height);
                    if (_loc_3 > 0)
                    {
                        _loc_1[_refreshBarAxis] = -_loc_3 - _loc_2;
                    }
                    else
                    {
                        _loc_1[_refreshBarAxis] = _viewSize[_refreshBarAxis] - _footer[_refreshBarAxis];
                    }
                    _footer.setSize(_loc_1.x, _loc_1.y);
                }
                else if (_footer.displayObject.parent != null)
                {
                    _maskContainer.removeChild(_footer.displayObject);
                }
            }
            return;
        }// end function

        private function tweenUpdate() : void
        {
            var _loc_1:* = runTween("x");
            var _loc_2:* = runTween("y");
            _container.x = _loc_1;
            _container.y = _loc_2;
            if (_tweening == 2)
            {
                if (_overlapSize.x > 0)
                {
                    _xPos = ToolSet.clamp(-_loc_1, 0, _overlapSize.x);
                }
                if (_overlapSize.y > 0)
                {
                    _yPos = ToolSet.clamp(-_loc_2, 0, _overlapSize.y);
                }
                if (_pageMode)
                {
                    updatePageController();
                }
            }
            if (_tweenChange.x == 0 && _tweenChange.y == 0)
            {
                _tweening = 0;
                GTimers.inst.remove(tweenUpdate);
                loopCheckingCurrent();
                updateScrollBarPos();
                updateScrollBarVisible();
                dispatchEvent(new Event("scroll"));
                dispatchEvent(new Event("scrollEnd"));
            }
            else
            {
                updateScrollBarPos();
                dispatchEvent(new Event("scroll"));
            }
            return;
        }// end function

        private function runTween(param1:String) : Number
        {
            var _loc_2:* = NaN;
            var _loc_6:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_3:* = NaN;
            if (_tweenChange[param1] != 0)
            {
                var _loc_7:* = param1;
                var _loc_8:* = _tweenTime[_loc_7] + GTimers.deltaTime / 1000;
                _tweenTime[_loc_7] = _loc_8;
                if (_tweenTime[param1] >= _tweenDuration[param1])
                {
                    _loc_2 = _tweenStart[param1] + _tweenChange[param1];
                    _tweenChange[param1] = 0;
                }
                else
                {
                    _loc_6 = easeFunc(_tweenTime[param1], _tweenDuration[param1]);
                    _loc_2 = _tweenStart[param1] + _tweenChange[param1] * _loc_6;
                }
                _loc_4 = 0;
                _loc_5 = -_overlapSize[param1];
                if (_headerLockedSize > 0 && _refreshBarAxis == param1)
                {
                    _loc_4 = _headerLockedSize;
                }
                if (_footerLockedSize > 0 && _refreshBarAxis == param1)
                {
                    _loc_3 = _overlapSize[_refreshBarAxis];
                    if (_loc_3 == 0)
                    {
                        _loc_3 = Math.max(_contentSize[_refreshBarAxis] + _footerLockedSize - _viewSize[_refreshBarAxis], 0);
                    }
                    else
                    {
                        _loc_3 = _loc_3 + _footerLockedSize;
                    }
                    _loc_5 = -_loc_3;
                }
                if (_tweening == 2 && _bouncebackEffect)
                {
                    if (_loc_2 > 20 + _loc_4 && _tweenChange[param1] > 0 || _loc_2 > _loc_4 && _tweenChange[param1] == 0)
                    {
                        _tweenTime[param1] = 0;
                        _tweenDuration[param1] = 0.3;
                        _tweenChange[param1] = -_loc_2 + _loc_4;
                        _tweenStart[param1] = _loc_2;
                    }
                    else if (_loc_2 < _loc_5 - 20 && _tweenChange[param1] < 0 || _loc_2 < _loc_5 && _tweenChange[param1] == 0)
                    {
                        _tweenTime[param1] = 0;
                        _tweenDuration[param1] = 0.3;
                        _tweenChange[param1] = _loc_5 - _loc_2;
                        _tweenStart[param1] = _loc_2;
                    }
                }
                else if (_loc_2 > _loc_4)
                {
                    _loc_2 = _loc_4;
                    _tweenChange[param1] = 0;
                }
                else if (_loc_2 < _loc_5)
                {
                    _loc_2 = _loc_5;
                    _tweenChange[param1] = 0;
                }
            }
            else
            {
                _loc_2 = _container[param1];
            }
            return _loc_2;
        }// end function

        private static function easeFunc(param1:Number, param2:Number) : Number
        {
            param1 = param1 / param2 - 1;
            return (param1 / param2 - 1) * param1 * param1 + 1;
        }// end function

    }
}
