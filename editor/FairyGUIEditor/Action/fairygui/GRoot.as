package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.display.*;
    import fairygui.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.system.*;
    import flash.text.*;
    import flash.ui.*;

    public class GRoot extends GComponent
    {
        private var _nativeStage:Stage;
        private var _modalLayer:GGraph;
        private var _popupStack:Vector.<GObject>;
        private var _justClosedPopups:Vector.<GObject>;
        private var _modalWaitPane:GObject;
        private var _focusedObject:GObject;
        private var _tooltipWin:GObject;
        private var _defaultTooltipWin:GObject;
        private var _hitUI:Boolean;
        private var _contextMenuDisabled:Boolean;
        private var _volumeScale:Number;
        private var _designResolutionX:int;
        private var _designResolutionY:int;
        private var _screenMatchMode:int;
        private var _popupCloseFlags:Vector.<Boolean>;
        public var buttonDown:Boolean;
        public var ctrlKeyDown:Boolean;
        public var shiftKeyDown:Boolean;
        private static var _inst:GRoot;
        public static var touchScreen:Boolean;
        public static var touchPointInput:Boolean;
        public static var eatUIEvents:Boolean;
        public static var contentScaleFactor:Number = 1;
        public static var contentScaleLevel:int = 0;

        public function GRoot() : void
        {
            if (_inst == null)
            {
                _inst = this;
            }
            _volumeScale = 1;
            _contextMenuDisabled = Capabilities.playerType == "Desktop";
            _popupStack = new Vector.<GObject>;
            _justClosedPopups = new Vector.<GObject>;
            _popupCloseFlags = new Vector.<Boolean>;
            displayObject.addEventListener("addedToStage", __addedToStage);
            return;
        }// end function

        public function get nativeStage() : Stage
        {
            return _nativeStage;
        }// end function

        public function setContentScaleFactor(param1:int, param2:int, param3:int = 0) : void
        {
            _designResolutionX = param1;
            _designResolutionY = param2;
            _screenMatchMode = param3;
            if (_designResolutionX == 0)
            {
                _screenMatchMode = 1;
            }
            else if (_designResolutionY == 0)
            {
                _screenMatchMode = 2;
            }
            applyScaleFactor();
            return;
        }// end function

        private function applyScaleFactor() : void
        {
            var _loc_4:* = 0;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_1:* = _nativeStage.stageWidth;
            var _loc_5:* = _nativeStage.stageHeight;
            if (_designResolutionX == 0 || _designResolutionY == 0)
            {
                this.setSize(_loc_1, _loc_5);
                return;
            }
            var _loc_2:* = _designResolutionX;
            var _loc_3:* = _designResolutionY;
            if (_loc_1 > _loc_5 && _loc_2 < _loc_3 || _loc_1 < _loc_5 && _loc_2 > _loc_3)
            {
                _loc_4 = _loc_2;
                _loc_2 = _loc_3;
                _loc_3 = _loc_4;
            }
            if (_screenMatchMode == 0)
            {
                _loc_6 = _loc_1 / _loc_2;
                _loc_7 = _loc_5 / _loc_3;
                contentScaleFactor = Math.min(_loc_6, _loc_7);
            }
            else if (_screenMatchMode == 1)
            {
                contentScaleFactor = _loc_1 / _loc_2;
            }
            else
            {
                contentScaleFactor = _loc_5 / _loc_3;
            }
            this.setSize(Math.round(_loc_1 / contentScaleFactor), Math.round(_loc_5 / contentScaleFactor));
            this.scaleX = contentScaleFactor;
            this.scaleY = contentScaleFactor;
            updateContentScaleLevel();
            return;
        }// end function

        private function updateContentScaleLevel() : void
        {
            var _loc_1:* = contentScaleFactor;
            if (_nativeStage.hasOwnProperty("contentsScaleFactor"))
            {
                _loc_1 = _loc_1 * _nativeStage["contentsScaleFactor"];
            }
            if (_loc_1 >= 8)
            {
                contentScaleLevel = 4;
            }
            else if (_loc_1 >= 3.5)
            {
                contentScaleLevel = 3;
            }
            else if (_loc_1 >= 2.5)
            {
                contentScaleLevel = 2;
            }
            else if (_loc_1 >= 1.5)
            {
                contentScaleLevel = 1;
            }
            else
            {
                contentScaleLevel = 0;
            }
            return;
        }// end function

        public function setFlashContextMenuDisabled(param1:Boolean) : void
        {
            _contextMenuDisabled = param1;
            if (_nativeStage)
            {
                if (_contextMenuDisabled)
                {
                    _nativeStage.addEventListener("rightMouseDown", __stageMouseDownCapture, true);
                    _nativeStage.addEventListener("rightMouseUp", __stageMouseUpCapture, true);
                }
                else
                {
                    _nativeStage.removeEventListener("rightMouseDown", __stageMouseDownCapture, true);
                    _nativeStage.removeEventListener("rightMouseUp", __stageMouseUpCapture, true);
                }
            }
            return;
        }// end function

        public function showWindow(param1:Window) : void
        {
            addChild(param1);
            param1.requestFocus();
            if (param1.x > this.width)
            {
                param1.x = this.width - param1.width;
            }
            else if (param1.x + param1.width < 0)
            {
                param1.x = 0;
            }
            if (param1.y > this.height)
            {
                param1.y = this.height - param1.height;
            }
            else if (param1.y + param1.height < 0)
            {
                param1.y = 0;
            }
            adjustModalLayer();
            return;
        }// end function

        public function hideWindow(param1:Window) : void
        {
            param1.hide();
            return;
        }// end function

        public function hideWindowImmediately(param1:Window) : void
        {
            if (param1.parent == this)
            {
                removeChild(param1);
            }
            adjustModalLayer();
            return;
        }// end function

        public function bringToFront(param1:Window) : void
        {
            var _loc_4:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = this.numChildren;
            if (this._modalLayer.parent != null && !param1.modal)
            {
                _loc_4 = this.getChildIndex(this._modalLayer) - 1;
            }
            else
            {
                _loc_4 = _loc_3 - 1;
            }
            while (_loc_4 >= 0)
            {
                
                _loc_2 = this.getChildAt(_loc_4);
                if (_loc_2 == param1)
                {
                    return;
                }
                if (!(_loc_2 is Window))
                {
                    _loc_4--;
                }
            }
            if (_loc_4 >= 0)
            {
                this.setChildIndex(param1, _loc_4);
            }
            return;
        }// end function

        public function showModalWait(param1:String = null) : void
        {
            if (UIConfig.globalModalWaiting != null)
            {
                if (_modalWaitPane == null)
                {
                    _modalWaitPane = UIPackage.createObjectFromURL(UIConfig.globalModalWaiting);
                }
                _modalWaitPane.setSize(this.width, this.height);
                _modalWaitPane.addRelation(this, 24);
                addChild(_modalWaitPane);
                _modalWaitPane.text = param1;
            }
            return;
        }// end function

        public function closeModalWait() : void
        {
            if (_modalWaitPane != null && _modalWaitPane.parent != null)
            {
                removeChild(_modalWaitPane);
            }
            return;
        }// end function

        public function closeAllExceptModals() : void
        {
            var _loc_4:* = 0;
            var _loc_2:* = null;
            var _loc_1:* = _children.slice();
            var _loc_3:* = _loc_1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = _loc_1[_loc_4];
                if (_loc_2 is Window && !(_loc_2 as Window).modal)
                {
                    (_loc_2 as Window).hide();
                }
                _loc_4++;
            }
            return;
        }// end function

        public function closeAllWindows() : void
        {
            var _loc_4:* = 0;
            var _loc_2:* = null;
            var _loc_1:* = _children.slice();
            var _loc_3:* = _loc_1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = _loc_1[_loc_4];
                if (_loc_2 is Window)
                {
                    (_loc_2 as Window).hide();
                }
                _loc_4++;
            }
            return;
        }// end function

        public function getTopWindow() : Window
        {
            var _loc_3:* = 0;
            var _loc_1:* = null;
            var _loc_2:* = this.numChildren;
            _loc_3 = _loc_2 - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_1 = this.getChildAt(_loc_3);
                if (_loc_1 is Window)
                {
                    return this.Window(_loc_1);
                }
                _loc_3--;
            }
            return null;
        }// end function

        public function getWindowBefore(param1:Window) : Window
        {
            var _loc_4:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = this.numChildren;
            var _loc_5:* = false;
            _loc_4 = _loc_3 - 1;
            while (_loc_4 >= 0)
            {
                
                _loc_2 = this.getChildAt(_loc_4);
                if (_loc_2 is Window)
                {
                    if (_loc_5)
                    {
                        return this.Window(_loc_2);
                    }
                    if (_loc_2 == param1)
                    {
                        _loc_5 = true;
                    }
                }
                _loc_4--;
            }
            return null;
        }// end function

        public function get modalLayer() : GGraph
        {
            return _modalLayer;
        }// end function

        public function get hasModalWindow() : Boolean
        {
            return _modalLayer.parent != null;
        }// end function

        public function get modalWaiting() : Boolean
        {
            return _modalWaitPane && _modalWaitPane.inContainer;
        }// end function

        public function showPopup(param1:GObject, param2:GObject = null, param3:Object = null, param4:Boolean = false) : void
        {
            var _loc_12:* = 0;
            var _loc_11:* = 0;
            var _loc_5:* = null;
            var _loc_10:* = null;
            var _loc_9:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            if (_popupStack.length > 0)
            {
                _loc_12 = _popupStack.indexOf(param1);
                if (_loc_12 != -1)
                {
                    _loc_11 = _popupStack.length - 1;
                    while (_loc_11 >= _loc_12)
                    {
                        
                        closePopup(_popupStack.pop());
                        _popupCloseFlags.pop();
                        _loc_11--;
                    }
                }
            }
            _popupStack.push(param1);
            _popupCloseFlags.push(param4);
            if (param2 != null)
            {
                _loc_5 = param2;
                while (_loc_5 != null)
                {
                    
                    if (_loc_5.parent == this)
                    {
                        if (param1.sortingOrder < _loc_5.sortingOrder)
                        {
                            param1.sortingOrder = _loc_5.sortingOrder;
                        }
                        break;
                    }
                    _loc_5 = _loc_5.parent;
                }
            }
            addChild(param1);
            adjustModalLayer();
            if (param2)
            {
                _loc_10 = param2.localToRoot();
                _loc_6 = param2.width;
                _loc_9 = param2.height;
            }
            else
            {
                _loc_10 = this.globalToLocal(nativeStage.mouseX, nativeStage.mouseY);
            }
            _loc_8 = _loc_10.x;
            if (_loc_8 + param1.width > this.width)
            {
                _loc_8 = _loc_8 + _loc_6 - param1.width;
            }
            _loc_7 = _loc_10.y + _loc_9;
            if (param3 == null && _loc_7 + param1.height > this.height || param3 == false)
            {
                _loc_7 = _loc_10.y - param1.height - 1;
                if (_loc_7 < 0)
                {
                    _loc_7 = 0;
                    _loc_8 = _loc_8 + _loc_6 / 2;
                    if (_loc_8 + param1.width > this.width)
                    {
                        _loc_8 = this.width - param1.width;
                    }
                }
            }
            param1.setXY(_loc_8, _loc_7);
            return;
        }// end function

        public function togglePopup(param1:GObject, param2:GObject = null, param3:Object = null, param4:Boolean = false) : void
        {
            if (_justClosedPopups.indexOf(param1) != -1)
            {
                return;
            }
            showPopup(param1, param2, param3, param4);
            return;
        }// end function

        public function hidePopup(param1:GObject = null) : void
        {
            var _loc_4:* = 0;
            var _loc_3:* = 0;
            var _loc_2:* = 0;
            if (param1 != null)
            {
                _loc_4 = _popupStack.indexOf(param1);
                if (_loc_4 != -1)
                {
                    _loc_3 = _popupStack.length - 1;
                    while (_loc_3 >= _loc_4)
                    {
                        
                        closePopup(_popupStack.pop());
                        _popupCloseFlags.pop();
                        _loc_3--;
                    }
                }
            }
            else
            {
                _loc_2 = _popupStack.length;
                _loc_3 = _loc_2 - 1;
                while (_loc_3 >= 0)
                {
                    
                    closePopup(_popupStack[_loc_3]);
                    _loc_3--;
                }
                _popupStack.length = 0;
                _popupCloseFlags.length = 0;
            }
            return;
        }// end function

        public function get hasAnyPopup() : Boolean
        {
            return _popupStack.length != 0;
        }// end function

        private function closePopup(param1:GObject) : void
        {
            if (param1.parent != null)
            {
                if (param1 is Window)
                {
                    this.Window(param1).hide();
                }
                else
                {
                    removeChild(param1);
                }
            }
            return;
        }// end function

        public function showTooltips(param1:String) : void
        {
            var _loc_2:* = null;
            if (_defaultTooltipWin == null)
            {
                _loc_2 = UIConfig.tooltipsWin;
                if (!_loc_2)
                {
                    return;
                }
                _defaultTooltipWin = UIPackage.createObjectFromURL(_loc_2);
                _defaultTooltipWin.touchable = false;
            }
            _defaultTooltipWin.text = param1;
            showTooltipsWin(_defaultTooltipWin);
            return;
        }// end function

        public function showTooltipsWin(param1:GObject, param2:Point = null) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            hideTooltips();
            _tooltipWin = param1;
            if (param2 == null)
            {
                _loc_3 = _nativeStage.mouseX + 10;
                _loc_4 = _nativeStage.mouseY + 20;
            }
            else
            {
                _loc_3 = param2.x;
                _loc_4 = param2.y;
            }
            var _loc_5:* = this.globalToLocal(_loc_3, _loc_4);
            _loc_3 = _loc_5.x;
            _loc_4 = _loc_5.y;
            if (_loc_3 + _tooltipWin.width > this.width)
            {
                _loc_3 = _loc_3 - _tooltipWin.width - 1;
                if (_loc_3 < 0)
                {
                    _loc_3 = 10;
                }
            }
            if (_loc_4 + _tooltipWin.height > this.height)
            {
                _loc_4 = _loc_4 - _tooltipWin.height - 1;
                if (_loc_3 - _tooltipWin.width - 1 > 0)
                {
                    _loc_3 = _loc_3 - _tooltipWin.width - 1;
                }
                if (_loc_4 < 0)
                {
                    _loc_4 = 10;
                }
            }
            _tooltipWin.x = _loc_3;
            _tooltipWin.y = _loc_4;
            addChild(_tooltipWin);
            return;
        }// end function

        public function hideTooltips() : void
        {
            if (_tooltipWin != null)
            {
                if (_tooltipWin.parent)
                {
                    removeChild(_tooltipWin);
                }
                _tooltipWin = null;
            }
            return;
        }// end function

        public function getObjectUnderMouse() : GObject
        {
            return getObjectUnderPoint(_nativeStage.mouseX, _nativeStage.mouseY);
        }// end function

        public function getObjectUnderPoint(param1:Number, param2:Number) : GObject
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_3:* = null;
            var _loc_6:* = _nativeStage.getObjectsUnderPoint(new Point(param1, param2));
            if (!_nativeStage.getObjectsUnderPoint(new Point(param1, param2)) || _loc_6.length == 0)
            {
                return null;
            }
            _loc_4 = _loc_6.length;
            _loc_5 = _loc_4 - 1;
            while (_loc_5 >= 0)
            {
                
                _loc_3 = isTouchableGObject(_loc_6[_loc_5]);
                if (_loc_3)
                {
                    return _loc_3;
                }
                _loc_5--;
            }
            return null;
        }// end function

        private function isTouchableGObject(param1:DisplayObject) : GObject
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            while (param1 != null && !(param1 is Stage))
            {
                
                if (param1 is UIDisplayObject)
                {
                    _loc_2 = this.UIDisplayObject(param1).owner;
                    if (!_loc_3)
                    {
                        _loc_3 = _loc_2;
                        if (_loc_3.touchable)
                        {
                            return _loc_3;
                        }
                    }
                    else if (_loc_2.touchable)
                    {
                        if (_loc_2 is GRoot)
                        {
                            return null;
                        }
                        return _loc_3;
                    }
                }
                param1 = param1.parent;
            }
            return null;
        }// end function

        public function get focus() : GObject
        {
            if (_focusedObject && !_focusedObject.onStage)
            {
                _focusedObject = null;
            }
            return _focusedObject;
        }// end function

        public function set focus(param1:GObject) : void
        {
            if (param1 && (!param1.focusable || !param1.onStage))
            {
                return;
            }
            setFocus(param1);
            if (param1 is GTextInput)
            {
                _nativeStage.focus = this.TextField(this.GTextInput(param1).displayObject);
            }
            return;
        }// end function

        private function setFocus(param1:GObject) : void
        {
            var _loc_2:* = null;
            if (_focusedObject != param1)
            {
                if (_focusedObject != null && _focusedObject.onStage)
                {
                    _loc_2 = _focusedObject;
                }
                _focusedObject = param1;
                dispatchEvent(new FocusChangeEvent("focusChanged", _loc_2, param1));
            }
            return;
        }// end function

        public function get volumeScale() : Number
        {
            return _volumeScale;
        }// end function

        public function set volumeScale(param1:Number) : void
        {
            _volumeScale = param1;
            return;
        }// end function

        public function playOneShotSound(param1:Sound, param2:Number = 1) : void
        {
            var _loc_3:* = _volumeScale * param2;
            if (_loc_3 == 1)
            {
                param1.play();
            }
            else
            {
                param1.play(0, 0, new SoundTransform(_loc_3));
            }
            return;
        }// end function

        private function adjustModalLayer() : void
        {
            var _loc_3:* = 0;
            var _loc_1:* = null;
            var _loc_2:* = this.numChildren;
            if (_modalWaitPane != null && _modalWaitPane.parent != null)
            {
                setChildIndex(_modalWaitPane, (_loc_2 - 1));
            }
            _loc_3 = _loc_2 - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_1 = this.getChildAt(_loc_3);
                if (_loc_1 is Window && (_loc_1 as Window).modal)
                {
                    if (_modalLayer.parent == null)
                    {
                        addChildAt(_modalLayer, _loc_3);
                    }
                    else
                    {
                        setChildIndexBefore(_modalLayer, _loc_3);
                    }
                    return;
                }
                _loc_3--;
            }
            if (_modalLayer.parent != null)
            {
                removeChild(_modalLayer);
            }
            return;
        }// end function

        private function __addedToStage(event:Event) : void
        {
            displayObject.removeEventListener("addedToStage", __addedToStage);
            _nativeStage = displayObject.stage;
            touchScreen = Capabilities.os.toLowerCase().slice(0, 3) != "win" && Capabilities.os.toLowerCase().slice(0, 3) != "mac" && Capabilities.touchscreenType != "none";
            if (touchScreen)
            {
                Multitouch.inputMode = "touchPoint";
                touchPointInput = true;
            }
            updateContentScaleLevel();
            _nativeStage.addEventListener("mouseDown", __stageMouseDownCapture, true);
            _nativeStage.addEventListener("mouseDown", __stageMouseDown, false, 1);
            _nativeStage.addEventListener("mouseUp", __stageMouseUpCapture, true);
            _nativeStage.addEventListener("mouseUp", __stageMouseUp, false, 1);
            if (_contextMenuDisabled)
            {
                _nativeStage.addEventListener("rightMouseDown", __stageMouseDownCapture, true);
                _nativeStage.addEventListener("rightMouseUp", __stageMouseUpCapture, true);
            }
            _modalLayer = new GGraph();
            _modalLayer.setSize(this.width, this.height);
            _modalLayer.drawRect(0, 0, 0, UIConfig.modalLayerColor, UIConfig.modalLayerAlpha);
            _modalLayer.addRelation(this, 24);
            if (Capabilities.os.toLowerCase().slice(0, 3) == "win" || Capabilities.os.toLowerCase().slice(0, 3) == "mac")
            {
                _nativeStage.addEventListener("resize", __winResize);
            }
            else
            {
                _nativeStage.addEventListener("orientationChange", __orientationChange);
            }
            __winResize(null);
            return;
        }// end function

        private function __stageMouseDownCapture(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            var _loc_5:* = false;
            var _loc_3:* = null;
            var _loc_8:* = 0;
            var _loc_7:* = 0;
            var _loc_6:* = 0;
            ctrlKeyDown = event.ctrlKey;
            shiftKeyDown = event.shiftKey;
            buttonDown = true;
            _hitUI = event.target != _nativeStage;
            var _loc_4:* = event.target as DisplayObject;
            while (_loc_4 != _nativeStage && _loc_4 != null)
            {
                
                if (_loc_4 is UIDisplayObject)
                {
                    _loc_2 = this.UIDisplayObject(_loc_4).owner;
                    if (_loc_2.touchable && _loc_2.focusable)
                    {
                        this.setFocus(_loc_2);
                        break;
                    }
                }
                _loc_4 = _loc_4.parent;
            }
            if (_tooltipWin != null)
            {
                hideTooltips();
            }
            _justClosedPopups.length = 0;
            if (_popupStack.length > 0)
            {
                _loc_4 = event.target as DisplayObject;
                _loc_5 = false;
                while (_loc_4 != _nativeStage && _loc_4 != null)
                {
                    
                    if (_loc_4 is UIDisplayObject)
                    {
                        _loc_8 = _popupStack.indexOf(this.UIDisplayObject(_loc_4).owner);
                        if (_loc_8 != -1)
                        {
                            _loc_7 = _popupStack.length - 1;
                            while (_loc_7 > _loc_8)
                            {
                                
                                if (!_popupCloseFlags[_loc_7])
                                {
                                    _loc_3 = _popupStack[_loc_7];
                                    _popupStack.splice(_loc_7, 1);
                                    _popupCloseFlags.splice(_loc_7, 1);
                                    closePopup(_loc_3);
                                    _justClosedPopups.push(_loc_3);
                                }
                                _loc_7--;
                            }
                            _loc_5 = true;
                            break;
                        }
                    }
                    _loc_4 = _loc_4.parent;
                }
                if (!_loc_5)
                {
                    _loc_6 = _popupStack.length;
                    _loc_7 = _loc_6 - 1;
                    while (_loc_7 >= 0)
                    {
                        
                        if (!_popupCloseFlags[_loc_7])
                        {
                            _loc_3 = _popupStack[_loc_7];
                            _popupStack.splice(_loc_7, 1);
                            _popupCloseFlags.splice(_loc_7, 1);
                            closePopup(_loc_3);
                            _justClosedPopups.push(_loc_3);
                        }
                        _loc_7--;
                    }
                }
            }
            return;
        }// end function

        private function __stageMouseDown(event:MouseEvent) : void
        {
            if (event.eventPhase == 2)
            {
                __stageMouseDownCapture(event);
            }
            if (eatUIEvents && event.target != _nativeStage)
            {
                event.stopImmediatePropagation();
            }
            return;
        }// end function

        private function __stageMouseUpCapture(event:MouseEvent) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = false;
            var _loc_2:* = null;
            var _loc_7:* = 0;
            var _loc_6:* = 0;
            var _loc_5:* = 0;
            buttonDown = false;
            if (_popupStack.length > 0)
            {
                _loc_3 = event.target as DisplayObject;
                _loc_4 = false;
                while (_loc_3 != _nativeStage && _loc_3 != null)
                {
                    
                    if (_loc_3 is UIDisplayObject)
                    {
                        _loc_7 = _popupStack.indexOf(this.UIDisplayObject(_loc_3).owner);
                        if (_loc_7 != -1)
                        {
                            _loc_6 = _popupStack.length - 1;
                            while (_loc_6 > _loc_7)
                            {
                                
                                if (_popupCloseFlags[_loc_6])
                                {
                                    _loc_2 = _popupStack[_loc_6];
                                    _popupStack.splice(_loc_6, 1);
                                    _popupCloseFlags.splice(_loc_6, 1);
                                    closePopup(_loc_2);
                                    _justClosedPopups.push(_loc_2);
                                }
                                _loc_6--;
                            }
                            _loc_4 = true;
                            break;
                        }
                    }
                    _loc_3 = _loc_3.parent;
                }
                if (!_loc_4)
                {
                    _loc_5 = _popupStack.length;
                    _loc_6 = _loc_5 - 1;
                    while (_loc_6 >= 0)
                    {
                        
                        if (_popupCloseFlags[_loc_6])
                        {
                            _loc_2 = _popupStack[_loc_6];
                            _popupStack.splice(_loc_6, 1);
                            _popupCloseFlags.splice(_loc_6, 1);
                            closePopup(_loc_2);
                            _justClosedPopups.push(_loc_2);
                        }
                        _loc_6--;
                    }
                }
            }
            return;
        }// end function

        private function __stageMouseUp(event:MouseEvent) : void
        {
            if (event.eventPhase == 2)
            {
                __stageMouseUpCapture(event);
            }
            if (eatUIEvents && (_hitUI || event.target != _nativeStage))
            {
                event.stopImmediatePropagation();
            }
            _hitUI = false;
            return;
        }// end function

        private function __winResize(event:Event) : void
        {
            applyScaleFactor();
            return;
        }// end function

        private function __orientationChange(event:Event) : void
        {
            applyScaleFactor();
            return;
        }// end function

        public static function get inst() : GRoot
        {
            if (_inst == null)
            {
                new GRoot;
            }
            return _inst;
        }// end function

    }
}
