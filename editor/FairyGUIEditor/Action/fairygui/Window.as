package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.event.*;
    import flash.events.*;
    import flash.geom.*;

    public class Window extends GComponent
    {
        private var _contentPane:GComponent;
        private var _modalWaitPane:GObject;
        private var _closeButton:GObject;
        private var _dragArea:GObject;
        private var _contentArea:GObject;
        private var _frame:GComponent;
        private var _modal:Boolean;
        private var _uiSources:Vector.<IUISource>;
        private var _inited:Boolean;
        private var _loading:Boolean;
        protected var _requestingCmd:int;
        public var bringToFontOnClick:Boolean;

        public function Window() : void
        {
            this.focusable = true;
            _uiSources = new Vector.<IUISource>;
            bringToFontOnClick = UIConfig.bringWindowToFrontOnClick;
            displayObject.addEventListener("addedToStage", __onShown);
            displayObject.addEventListener("removedFromStage", __onHidden);
            displayObject.addEventListener("mouseDown", __mouseDown, true);
            return;
        }// end function

        public function addUISource(param1:IUISource) : void
        {
            _uiSources.push(param1);
            return;
        }// end function

        public function set contentPane(param1:GComponent) : void
        {
            if (_contentPane != param1)
            {
                if (_contentPane != null)
                {
                    removeChild(_contentPane);
                }
                _contentPane = param1;
                if (_contentPane != null)
                {
                    addChild(_contentPane);
                    this.setSize(_contentPane.width, _contentPane.height);
                    _contentPane.addRelation(this, 24);
                    _frame = _contentPane.getChild("frame") as GComponent;
                    if (_frame != null)
                    {
                        this.closeButton = _frame.getChild("closeButton");
                        this.dragArea = _frame.getChild("dragArea");
                        this.contentArea = _frame.getChild("contentArea");
                    }
                }
            }
            return;
        }// end function

        public function get contentPane() : GComponent
        {
            return _contentPane;
        }// end function

        public function get frame() : GComponent
        {
            return _frame;
        }// end function

        public function get closeButton() : GObject
        {
            return _closeButton;
        }// end function

        public function set closeButton(param1:GObject) : void
        {
            if (_closeButton != null)
            {
                _closeButton.removeClickListener(closeEventHandler);
            }
            _closeButton = param1;
            if (_closeButton != null)
            {
                _closeButton.addClickListener(closeEventHandler);
            }
            return;
        }// end function

        public function get dragArea() : GObject
        {
            return _dragArea;
        }// end function

        public function set dragArea(param1:GObject) : void
        {
            if (_dragArea != param1)
            {
                if (_dragArea != null)
                {
                    _dragArea.draggable = false;
                    _dragArea.removeEventListener("startDrag", __dragStart);
                }
                _dragArea = param1;
                if (_dragArea != null)
                {
                    if (_dragArea is GGraph && this.GGraph(_dragArea).displayObject == null)
                    {
                        _dragArea.asGraph.drawRect(0, 0, 0, 0, 0);
                    }
                    _dragArea.draggable = true;
                    _dragArea.addEventListener("startDrag", __dragStart);
                }
            }
            return;
        }// end function

        public function get contentArea() : GObject
        {
            return _contentArea;
        }// end function

        public function set contentArea(param1:GObject) : void
        {
            _contentArea = param1;
            return;
        }// end function

        public function show() : void
        {
            GRoot.inst.showWindow(this);
            return;
        }// end function

        public function showOn(param1:GRoot) : void
        {
            param1.showWindow(this);
            return;
        }// end function

        public function hide() : void
        {
            if (this.isShowing)
            {
                doHideAnimation();
            }
            return;
        }// end function

        public function hideImmediately() : void
        {
            var _loc_1:* = parent is GRoot ? (this.GRoot(parent)) : (null);
            if (!_loc_1)
            {
                _loc_1 = GRoot.inst;
            }
            _loc_1.hideWindowImmediately(this);
            return;
        }// end function

        public function centerOn(param1:GRoot, param2:Boolean = false) : void
        {
            this.setXY((param1.width - this.width) / 2, (param1.height - this.height) / 2);
            if (param2)
            {
                this.addRelation(param1, 3);
                this.addRelation(param1, 10);
            }
            return;
        }// end function

        public function toggleStatus() : void
        {
            if (isTop)
            {
                hide();
            }
            else
            {
                show();
            }
            return;
        }// end function

        public function get isShowing() : Boolean
        {
            return parent != null;
        }// end function

        public function get isTop() : Boolean
        {
            return parent != null && parent.getChildIndex(this) == (parent.numChildren - 1);
        }// end function

        public function get modal() : Boolean
        {
            return _modal;
        }// end function

        public function set modal(param1:Boolean) : void
        {
            _modal = param1;
            return;
        }// end function

        public function bringToFront() : void
        {
            this.root.bringToFront(this);
            return;
        }// end function

        public function showModalWait(param1:int = 0) : void
        {
            if (param1 != 0)
            {
                _requestingCmd = param1;
            }
            if (UIConfig.windowModalWaiting)
            {
                if (!_modalWaitPane)
                {
                    _modalWaitPane = UIPackage.createObjectFromURL(UIConfig.windowModalWaiting);
                }
                layoutModalWaitPane();
                addChild(_modalWaitPane);
            }
            return;
        }// end function

        protected function layoutModalWaitPane() : void
        {
            var _loc_1:* = null;
            if (_contentArea != null)
            {
                _loc_1 = _frame.localToGlobal();
                _loc_1 = this.globalToLocal(_loc_1.x, _loc_1.y);
                _modalWaitPane.setXY(_loc_1.x + _contentArea.x, _loc_1.y + _contentArea.y);
                _modalWaitPane.setSize(_contentArea.width, _contentArea.height);
            }
            else
            {
                _modalWaitPane.setSize(this.width, this.height);
            }
            return;
        }// end function

        public function closeModalWait(param1:int = 0) : Boolean
        {
            if (param1 != 0)
            {
                if (_requestingCmd != param1)
                {
                    return false;
                }
            }
            _requestingCmd = 0;
            if (_modalWaitPane && _modalWaitPane.parent != null)
            {
                removeChild(_modalWaitPane);
            }
            return true;
        }// end function

        public function get modalWaiting() : Boolean
        {
            return _modalWaitPane && _modalWaitPane.parent != null;
        }// end function

        public function init() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_1:* = null;
            if (_inited || _loading)
            {
                return;
            }
            if (_uiSources.length > 0)
            {
                _loading = false;
                _loc_2 = _uiSources.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_1 = _uiSources[_loc_3];
                    if (!_loc_1.loaded)
                    {
                        _loc_1.load(__uiLoadComplete);
                        _loading = true;
                    }
                    _loc_3++;
                }
                if (!_loading)
                {
                    _init();
                }
            }
            else
            {
                _init();
            }
            return;
        }// end function

        protected function onInit() : void
        {
            return;
        }// end function

        protected function onShown() : void
        {
            return;
        }// end function

        protected function onHide() : void
        {
            return;
        }// end function

        protected function doShowAnimation() : void
        {
            onShown();
            return;
        }// end function

        protected function doHideAnimation() : void
        {
            this.hideImmediately();
            return;
        }// end function

        private function __uiLoadComplete() : void
        {
            var _loc_3:* = 0;
            var _loc_1:* = null;
            var _loc_2:* = _uiSources.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1 = _uiSources[_loc_3];
                if (!_loc_1.loaded)
                {
                    return;
                }
                _loc_3++;
            }
            _loading = false;
            _init();
            return;
        }// end function

        private function _init() : void
        {
            _inited = true;
            onInit();
            if (this.isShowing)
            {
                doShowAnimation();
            }
            return;
        }// end function

        override public function dispose() : void
        {
            displayObject.removeEventListener("addedToStage", __onShown);
            displayObject.removeEventListener("removedFromStage", __onHidden);
            if (parent != null)
            {
                this.hideImmediately();
            }
            super.dispose();
            return;
        }// end function

        protected function closeEventHandler(event:Event) : void
        {
            hide();
            return;
        }// end function

        private function __onShown(event:Event) : void
        {
            if (event.target == displayObject)
            {
                if (!_inited)
                {
                    init();
                }
                else
                {
                    doShowAnimation();
                }
            }
            return;
        }// end function

        private function __onHidden(event:Event) : void
        {
            if (event.target == displayObject)
            {
                closeModalWait();
                onHide();
            }
            return;
        }// end function

        private function __mouseDown(event:Event) : void
        {
            if (this.isShowing && bringToFontOnClick)
            {
                bringToFront();
            }
            return;
        }// end function

        private function __dragStart(event:DragEvent) : void
        {
            event.preventDefault();
            this.startDrag(event.touchPointID);
            return;
        }// end function

    }
}
