package _-2F
{
    import *.*;
    import _-Ds.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class TestView extends GComponent implements ITestView
    {
        var _editor:IEditor;
        private var _panel:GComponent;
        var _content:FComponent;
        private var _-9a:GComponent;
        private var _-PB:GGraph;
        private var _-GK:Graphics;
        private var _-PH:GGraph;
        private var _container:Sprite;
        private var _-8p:FObject;
        private var _-La:Number;
        private var _-8a:GComboBox;
        private var _-Id:GComboBox;
        private var _-LJ:GComboBox;
        private var _-MV:Controller;
        private var _-LM:GList;
        private var _-7Y:FPackageItem;
        private var _-MO:String;
        private var _-Hm:int;
        private var _-Pf:int;
        private var _contentWidth:int;
        private var _contentHeight:int;
        private var _scaleFactor:Number;
        private var _-Px:int;
        private var _-JT:Array;
        private var _-JO:FObject;
        private var _-Jv:FObject;
        private var _-JR:FObject;
        private var _running:Boolean;
        private var _-6x:int;
        private var _-M7:int;
        private var _-2H:String;
        private var _-IG:Boolean;

        public function TestView(param1:IEditor)
        {
            var editor:* = param1;
            this._editor = editor;
            this._panel = UIPackage.createObject("Builder", "TestView").asCom;
            this.setSize(this._panel.width, this._panel.height);
            this._panel.addRelation(this, RelationType.Size);
            addChild(this._panel);
            this._-9a = this._panel.getChild("docContainer").asCom;
            this._-9a.addSizeChangeCallback(this._-Ej);
            this._-9a.displayObject.addEventListener(MouseEvent.MOUSE_WHEEL, this.__mouseWheel, false, 1);
            this._container = new Sprite();
            this._-PB = this._panel.getChild("n1").asGraph;
            var canvas:* = new GGraph();
            this._-9a.addChild(canvas);
            this._-GK = canvas.graphics;
            this._-PH = new GGraph();
            this._-9a.addChild(this._-PH);
            this._-PH.setNativeObject(this._container);
            this._-8a = this._editor.mainPanel.getChild("viewScale").asComboBox;
            this._-8a.addEventListener(StateChangeEvent.CHANGED, this._-Kj);
            this._-La = 1;
            this._-Id = this._panel.getChild("device").asComboBox;
            this._-Id.addEventListener(StateChangeEvent.CHANGED, this._-Fz);
            this._panel.getChild("adaptation").asButton.addEventListener(StateChangeEvent.CHANGED, this._-Fz);
            this._-LJ = this._panel.getChild("screenMatch").asComboBox;
            this._-LJ.addEventListener(StateChangeEvent.CHANGED, this._-Fz);
            this._-MV = this._panel.getController("orientation");
            this._-MV.addEventListener(StateChangeEvent.CHANGED, this._-Fz);
            this._panel.getChild("contentScaler").addClickListener(this._-Av);
            this._-LM = this._panel.getChild("controllerList").asList;
            this._-LM.addSizeChangeCallback(this._-a);
            this._-LM.addEventListener(ItemEvent.CLICK, this._-6V);
            this._-LM.removeChildrenToPool();
            this._-JT = [];
            addEventListener(_-4U._-76, this.handleKeyEvent);
            this._editor.on(EditorEvent.BackgroundChanged, function (event:Event) : void
            {
                if (_running)
                {
                    drawBackground();
                }
                return;
            }// end function
            );
            return;
        }// end function

        public function start() : void
        {
            var _loc_2:* = 0;
            var _loc_1:* = this._editor.docView.activeDocument;
            if (!_loc_1)
            {
                return;
            }
            this._editor.consoleView.clear();
            this._running = true;
            this._-7Y = _loc_1.packageItem;
            if (_loc_1.timelineMode)
            {
                this._-MO = _loc_1.editingTransition.name;
            }
            else
            {
                this._-MO = null;
            }
            var _loc_3:* = _loc_1.content.controllers.length;
            this._-JT.length = _loc_3;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                this._-JT[_loc_2] = _loc_1.content.controllers[_loc_2].selectedIndex;
                _loc_2++;
            }
            this._-Hh();
            this._-La = _loc_1.getVar("testViewScale");
            this._-2H = this._-8a.text;
            this._-8a.text = (this._-La * 100).toFixed(0) + "%";
            this._panel.root.nativeStage.addEventListener(MouseEvent.MOUSE_DOWN, this.__stageMouseDownCapture, true);
            this._panel.root.nativeStage.addEventListener(MouseEvent.MOUSE_DOWN, this.__stageMouseDown, false, 1);
            GTimers.inst.add(500, 0, this._-5q);
            this._editor.on(EditorEvent.Validate, this._-9C);
            this._-Hj();
            this._editor.emit(EditorEvent.TestStart);
            return;
        }// end function

        private function _-Hj() : void
        {
            var i18n:I18nSettings;
            var clen:int;
            var i:int;
            var designImageItem:FPackageItem;
            var cc:FController;
            var doc:* = this._editor.docView.activeDocument;
            if (!doc)
            {
                return;
            }
            try
            {
                this._-I5();
                i18n = I18nSettings(this._editor.project.getSettings("i18n"));
                i18n.loadStrings();
                this._-GH();
                this._-6x = this._-7Y.version;
                this._-M7 = FObjectFlags.IN_TEST + this._-Px;
                this._content = FObjectFactory.createObject(this._-7Y, this._-M7 | FObjectFlags.ROOT) as FComponent;
                this._container.addChild(this._content.displayObject);
                if (this._content.designImage && this._content.designImageForTest)
                {
                    designImageItem = this._editor.project.getItemByURL(this._content.designImage);
                    if (designImageItem != null)
                    {
                        this._-8p = FObjectFactory.createObject(designImageItem, this._-M7);
                        this._-8p.name = "designImage";
                        this._-8p.touchable = false;
                        if (this._content.designImageLayer == 0)
                        {
                            this._container.addChildAt(this._-8p.displayObject, 0);
                        }
                        else
                        {
                            this._container.addChild(this._-8p.displayObject);
                        }
                        this._-8p.x = this._content.designImageOffsetX;
                        this._-8p.y = this._content.designImageOffsetY;
                        this._-8p.alpha = this._content.designImageAlpha / 100;
                    }
                }
                this._content.updateDisplayList(true);
                clen = this._content.controllers.length;
                i;
                while (i < clen)
                {
                    
                    cc = this._content.controllers[i];
                    if (doc.timelineMode || cc.homePageType == "default")
                    {
                        cc.selectedIndex = this._-JT[i];
                    }
                    cc.addEventListener(StateChangeEvent.CHANGED, this._-7A);
                    i = (i + 1);
                }
                this._-5W();
                this._contentWidth = this._content.width;
                this._contentHeight = this._content.height;
                this._-1N();
                this._-9a.scrollPane.percX = 0;
                this._-9a.scrollPane.percY = 0;
                if (!this._content.transitions.isEmpty)
                {
                    this._content.transitions.takeSnapshot();
                }
                if (this._-MO != null)
                {
                    this._content.transitions.getItem(this._-MO).play();
                }
                this._content.playAutoPlayTransitions();
                this._-5q();
            }
            catch (err:Error)
            {
                _editor.alert(null, err);
            }
            return;
        }// end function

        private function _-I5() : void
        {
            if (this._-8p)
            {
                this._-8p.dispose();
                this._-8p = null;
            }
            if (this._-JR)
            {
                this._-JR.dispose();
                this._-JR = null;
            }
            if (this._content != null)
            {
                if (this._content.displayObject.parent != null)
                {
                    this._container.removeChild(this._content.displayObject);
                }
                this._content.dispose();
                this._content = null;
            }
            return;
        }// end function

        private function _-9C() : void
        {
            this._-7Y.touch();
            if (this._-6x != this._-7Y.version)
            {
                this._-Hj();
            }
            else if (this._content)
            {
                this._content.validateChildren();
            }
            return;
        }// end function

        private function _-5q() : void
        {
            if (this._content)
            {
                this._content.handleTextBitmapMode(false);
            }
            return;
        }// end function

        public function reload() : void
        {
            this._editor.cursorManager.setWaitCursor(true);
            this._-Hj();
            this._editor.cursorManager.setWaitCursor(false);
            return;
        }// end function

        public function stop() : void
        {
            if (!this._running)
            {
                return;
            }
            this._running = false;
            this.hidePopup();
            this.hideTooltips();
            this._-I5();
            this._-MO = null;
            this._-JO = null;
            this._-Jv = null;
            this._-JR = null;
            this._-7Y = null;
            this._panel.root.nativeStage.removeEventListener(MouseEvent.MOUSE_DOWN, this.__stageMouseDownCapture, true);
            this._panel.root.nativeStage.removeEventListener(MouseEvent.MOUSE_DOWN, this.__stageMouseDown);
            GTimers.inst.remove(this._-5q);
            this._editor.off(EditorEvent.Validate, this._-9C);
            this._-8a.text = this._-2H;
            this._editor.emit(EditorEvent.TestStop);
            this._editor.docView.requestFocus();
            return;
        }// end function

        public function get running() : Boolean
        {
            return this._running;
        }// end function

        public function playTransition(param1:String) : void
        {
            if (this._-MO != null)
            {
                this._content.transitions.getItem(this._-MO).stop();
                this._content.transitions.readSnapshot();
            }
            this._-MO = param1;
            if (this._-MO != null)
            {
                this._content.transitions.getItem(this._-MO).play();
            }
            return;
        }// end function

        private function _-Kj(event:Event) : void
        {
            if (!this._running)
            {
                return;
            }
            this._-La = parseInt(event.currentTarget.text) / 100;
            this._-AC();
            return;
        }// end function

        private function _-3a(param1:Number) : void
        {
            this._-La = param1;
            this._-8a.text = (this._-La * 100).toFixed(0) + "%";
            this._-AC();
            return;
        }// end function

        private function _-Ii(param1:Boolean, param2:Boolean) : void
        {
            if (param1)
            {
                if (param2)
                {
                    this._-La = this._-La * 2;
                }
                else
                {
                    this._-La = this._-La * 1.25;
                }
                if (this._-La > 16)
                {
                    this._-La = 16;
                }
            }
            else
            {
                if (param2)
                {
                    this._-La = this._-La / 2;
                }
                else
                {
                    this._-La = this._-La / 1.25;
                }
                if (this._-La < 0.25)
                {
                    this._-La = 0.25;
                }
            }
            this._-8a.text = (this._-La * 100).toFixed(0) + "%";
            this._-AC();
            return;
        }// end function

        private function _-Hh() : void
        {
            var _loc_1:* = this._editor.docView.activeDocument;
            var _loc_2:* = AdaptationSettings(this._editor.project.getSettings("adaptation"));
            _loc_2.fillCombo(this._-Id);
            this._-IG = _loc_1.getMeta("adaptiveTest");
            this._panel.getChild("adaptation").asButton.selected = this._-IG;
            this._-LJ.value = _loc_1.getMeta("fitScreen");
            this._-Id.value = this._editor.workspaceSettings.get("test.device");
            this._-MV.setSelectedPage(this._editor.workspaceSettings.get("test.orientation"));
            return;
        }// end function

        private function _-GH() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            this._scaleFactor = 1;
            this._-Px = 0;
            if (this._-IG)
            {
                _loc_3 = AdaptationSettings(this._editor.project.getSettings("adaptation"));
                _loc_4 = this._-Oi();
                _loc_5 = _loc_4[0];
                _loc_6 = _loc_4[1];
                if (_loc_3.scaleMode == "ScaleWithScreenSize")
                {
                    _loc_7 = _loc_3.designResolutionX;
                    _loc_8 = _loc_3.designResolutionY;
                    if (_loc_7 != 0 && _loc_8 != 0)
                    {
                        if (_loc_5 > _loc_6 && _loc_7 < _loc_8 || _loc_5 < _loc_6 && _loc_7 > _loc_8)
                        {
                            _loc_9 = _loc_7;
                            _loc_7 = _loc_8;
                            _loc_8 = _loc_9;
                        }
                        if (_loc_3.screenMathMode == "MatchWidthOrHeight")
                        {
                            _loc_10 = _loc_5 / _loc_7;
                            _loc_11 = _loc_6 / _loc_8;
                            this._scaleFactor = Math.min(_loc_10, _loc_11);
                        }
                        else if (_loc_3.screenMathMode == "MatchWidth")
                        {
                            this._scaleFactor = _loc_5 / _loc_7;
                        }
                        else
                        {
                            this._scaleFactor = _loc_6 / _loc_8;
                        }
                    }
                }
            }
            var _loc_1:* = GlobalPublishSettings(this._editor.project.getSettings("publish"));
            var _loc_2:* = this._scaleFactor * this._editor.groot.nativeStage.contentsScaleFactor;
            if (_loc_2 >= 3.5)
            {
                if (_loc_1.include4x)
                {
                    this._-Px = 3;
                }
            }
            if (this._-Px == 0 && _loc_2 >= 2.5)
            {
                if (_loc_1.include3x)
                {
                    this._-Px = 2;
                }
            }
            if (this._-Px == 0 && _loc_2 >= 1.5)
            {
                if (_loc_1.include2x)
                {
                    this._-Px = 1;
                }
            }
            return;
        }// end function

        private function _-1N() : void
        {
            var _loc_1:* = null;
            if (this._-IG)
            {
                _loc_1 = this._-Oi();
                this._-Hm = Math.ceil(_loc_1[0] / this._scaleFactor);
                this._-Pf = Math.ceil(_loc_1[1] / this._scaleFactor);
                this._container.scrollRect = new Rectangle(0, 0, this._-Hm, this._-Pf);
            }
            else
            {
                this._-Hm = this._contentWidth;
                this._-Pf = this._contentHeight;
                this._container.scrollRect = null;
            }
            if (this._-LJ.value == "FitSize")
            {
                this._content.setSize(this._-Hm, this._-Pf, true);
                this._content.setTopLeft(0, 0);
            }
            else if (this._-LJ.value == "FitWidthAndSetMiddle")
            {
                this._content.setSize(this._-Hm, this._contentHeight, true);
                this._content.setTopLeft(0, int((this._-Pf - this._contentHeight) / 2));
            }
            else if (this._-LJ.value == "FitHeightAndSetCenter")
            {
                this._content.setSize(this._contentWidth, this._-Pf, true);
                this._content.setTopLeft(this.int((this._-Hm - this._contentWidth) / 2), 0);
            }
            else
            {
                this._content.setSize(this._contentWidth, this._contentHeight, true);
                this._content.setTopLeft(0, 0);
            }
            this._-AC();
            return;
        }// end function

        private function _-AC() : void
        {
            var _loc_1:* = this._editor.docView.activeDocument;
            _loc_1.setVar("testViewScale", this._-La);
            this._container.scaleX = this._-La * this._scaleFactor;
            this._container.scaleY = this._-La * this._scaleFactor;
            var _loc_2:* = this._-9a.scrollPane.percX;
            var _loc_3:* = this._-9a.scrollPane.percY;
            this._-DM();
            this._-9a.scrollPane.percX = _loc_2;
            this._-9a.scrollPane.percY = _loc_3;
            return;
        }// end function

        private function _-DM() : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_1:* = this._-Hm * this._container.scaleX;
            var _loc_2:* = this._-Pf * this._container.scaleY;
            if (_loc_1 < this._-9a.viewWidth)
            {
                _loc_3 = (this._-9a.viewWidth - _loc_1) / 2;
            }
            if (_loc_3 < 0)
            {
                _loc_3 = 0;
            }
            if (_loc_2 < this._-9a.viewHeight)
            {
                _loc_4 = (this._-9a.viewHeight - _loc_2) / 2;
            }
            if (_loc_4 < 0)
            {
                _loc_4 = 0;
            }
            this._-PH.x = _loc_3;
            this._-PH.y = _loc_4;
            this._-PH.setSize(_loc_1, _loc_2);
            this.drawBackground();
            return;
        }// end function

        private function drawBackground() : void
        {
            var _loc_3:* = 0;
            this._-PB.drawRect(0, 0, 0, this._editor.workspaceSettings.get("backgroundColor"), 1);
            var _loc_1:* = this._-PH.x;
            var _loc_2:* = this._-PH.y;
            if (this._content.bgColorEnabled)
            {
                _loc_3 = this._content.bgColor;
            }
            else
            {
                _loc_3 = this._editor.workspaceSettings.get("canvasColor");
            }
            this._-GK.clear();
            this._-GK.lineStyle(0, 0, 0, true);
            this._-GK.beginFill(_loc_3, 1);
            this._-GK.drawRect(_loc_1, _loc_2, this._-Hm * this._container.scaleX, this._-Pf * this._container.scaleY);
            this._-GK.endFill();
            return;
        }// end function

        private function __mouseWheel(event:MouseEvent) : void
        {
            var _loc_2:* = NaN;
            if (event.ctrlKey)
            {
                event.stopImmediatePropagation();
                _loc_2 = event.delta;
                if (_loc_2 < 0)
                {
                    this._-Ii(false, false);
                }
                else
                {
                    this._-Ii(true, false);
                }
            }
            return;
        }// end function

        private function _-Ej() : void
        {
            if (this._content != null)
            {
                this._-DM();
            }
            return;
        }// end function

        public function togglePopup(param1:FObject, param2:FObject = null, param3:String = null) : void
        {
            if (this._-Jv == param1)
            {
                return;
            }
            this.showPopup(param1, param2, param3);
            return;
        }// end function

        public function showPopup(param1:FObject, param2:FObject = null, param3:String = null) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            if (this._-JO)
            {
                this.hidePopup();
            }
            this._-JO = param1;
            if (param2)
            {
                _loc_4 = param2.displayObject.localToGlobal(new Point(0, 0));
                _loc_4 = this._container.globalToLocal(_loc_4);
                _loc_5 = param2.width;
                _loc_6 = param2.height;
            }
            else
            {
                _loc_4 = this._container.globalToLocal(new Point(this._panel.root.nativeStage.mouseX, this._panel.root.nativeStage.mouseY));
            }
            if (this._-IG && param2 != this._content)
            {
                _loc_7 = this._-Hm;
                _loc_8 = this._-Pf;
            }
            else
            {
                _loc_7 = int.MAX_VALUE;
                _loc_8 = int.MAX_VALUE;
            }
            _loc_9 = _loc_4.x;
            if (_loc_9 + param1.width > _loc_7)
            {
                _loc_9 = _loc_9 + _loc_5 - param1.width;
            }
            _loc_10 = _loc_4.y + _loc_6;
            if ((param3 == null || param3 == "auto") && _loc_10 + param1.height > _loc_8 || param3 == "up")
            {
                _loc_10 = _loc_4.y - param1.height - 1;
                if (_loc_10 < 0)
                {
                    _loc_10 = 0;
                    _loc_9 = _loc_9 + _loc_5 / 2;
                }
            }
            param1.x = _loc_9;
            param1.y = _loc_10;
            this._container.addChild(param1.displayObject);
            return;
        }// end function

        public function hidePopup() : void
        {
            if (this._-JO != null && this._-JO.displayObject.parent != null)
            {
                this._container.removeChild(this._-JO.displayObject);
                this._-Jv = this._-JO;
            }
            this._-JO = null;
            return;
        }// end function

        public function showTooltips(param1:String) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            if (this._content == null)
            {
                return;
            }
            if (this._-JR == null)
            {
                _loc_7 = this._editor.project.getSetting("common", "tipsRes");
                if (!_loc_7)
                {
                    return;
                }
                _loc_8 = this._content._pkg.project.getItemByURL(_loc_7);
                if (_loc_8)
                {
                    this._-JR = FObjectFactory.createObject(_loc_8, this._-M7);
                    if (!this._-JR)
                    {
                        return;
                    }
                    this._-JR.touchable = false;
                }
            }
            this._-JR.text = param1;
            if (this._-IG)
            {
                _loc_2 = this._-Hm;
                _loc_3 = this._-Pf;
            }
            else
            {
                _loc_2 = int.MAX_VALUE;
                _loc_3 = int.MAX_VALUE;
            }
            _loc_4 = this._panel.root.nativeStage.mouseX + 10;
            _loc_5 = this._panel.root.nativeStage.mouseY + 20;
            var _loc_6:* = this._container.globalToLocal(new Point(_loc_4, _loc_5));
            _loc_4 = _loc_6.x;
            _loc_5 = _loc_6.y;
            if (_loc_4 + this._-JR.width > _loc_2)
            {
                _loc_4 = _loc_4 - this._-JR.width - 1;
                if (_loc_4 < 0)
                {
                    _loc_4 = 10;
                }
            }
            if (_loc_5 + this._-JR.height > _loc_3)
            {
                _loc_5 = _loc_5 - this._-JR.height - 1;
                if (_loc_4 - this._-JR.width - 1 > 0)
                {
                    _loc_4 = _loc_4 - this._-JR.width - 1;
                }
                if (_loc_5 < 0)
                {
                    _loc_5 = 10;
                }
            }
            this._-JR.x = _loc_4;
            this._-JR.y = _loc_5;
            this._container.addChild(this._-JR.displayObject);
            return;
        }// end function

        public function hideTooltips() : void
        {
            if (this._-JR != null)
            {
                if (this._-JR.displayObject.parent)
                {
                    this._container.removeChild(this._-JR.displayObject);
                }
            }
            return;
        }// end function

        private function handleKeyEvent(param1:_-4U) : void
        {
            switch(param1._-T)
            {
                case "0124":
                {
                    this._-Ii(true, true);
                    break;
                }
                case "0125":
                {
                    this._-Ii(false, true);
                    break;
                }
                case "0126":
                {
                    this._-3a(1);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function __stageMouseDown(event:MouseEvent) : void
        {
            if (event.eventPhase == EventPhase.AT_TARGET)
            {
                this.__stageMouseDownCapture(event);
            }
            return;
        }// end function

        private function __stageMouseDownCapture(event:MouseEvent) : void
        {
            this._-Jv = null;
            if (this._-JO == null)
            {
                return;
            }
            if (!this._-JO.displayObject.hitTestPoint(event.currentTarget.stage.mouseX, event.currentTarget.stage.mouseY))
            {
                this.hidePopup();
            }
            return;
        }// end function

        function _-Oi() : Array
        {
            var _loc_1:* = AdaptationSettings(this._editor.project.getSettings("adaptation"));
            var _loc_2:* = _loc_1.getDeviceResolution(this._-Id.value);
            if (this._-MV.selectedPage == "landscape")
            {
                return [_loc_2.resolutionX, _loc_2.resolutionY];
            }
            return [_loc_2.resolutionY, _loc_2.resolutionX];
        }// end function

        private function _-Av(event:Event) : void
        {
            ProjectSettingsDialog(this._editor.getDialog(ProjectSettingsDialog)).openAdaptationSettings();
            return;
        }// end function

        private function _-Fz(event:Event) : void
        {
            var _loc_2:* = this._editor.docView.activeDocument;
            this._-IG = this._panel.getChild("adaptation").asButton.selected;
            if (this._-IG)
            {
                _loc_2.setMeta("adaptiveTest", true);
            }
            else
            {
                _loc_2.setMeta("adaptiveTest", undefined);
            }
            _loc_2.setMeta("fitScreen", this._-LJ.value);
            this._editor.workspaceSettings.set("test.device", this._-Id.value);
            this._editor.workspaceSettings.set("test.orientation", this._-MV.selectedPage);
            this._-Hj();
            return;
        }// end function

        private function _-5W() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            this._-LM.removeChildrenToPool();
            for each (_loc_1 in this._content.controllers)
            {
                
                _loc_2 = this._-LM.addItemFromPool().asButton;
                _loc_2.name = _loc_1.name;
                _loc_2.title = _loc_1.name + (_loc_1.alias ? (" - " + _loc_1.alias) : (""));
                this.setPages(_loc_1, _loc_2, -1);
            }
            this._-LM.resizeToFit(int.MAX_VALUE, this._-LM.initHeight);
            return;
        }// end function

        private function _-7A(event:Event) : void
        {
            var _loc_9:* = null;
            var _loc_2:* = FController(event.currentTarget);
            var _loc_3:* = this._content.controllers.indexOf(_loc_2);
            if (_loc_3 != -1)
            {
                this._-JT[_loc_3] = _loc_2.selectedIndex;
            }
            var _loc_4:* = this._-LM.getChild(_loc_2.name) as GComponent;
            if (this._-LM.getChild(_loc_2.name) as GComponent == null)
            {
                return;
            }
            var _loc_5:* = this._-LM.getChildIndex(_loc_4) + 1;
            var _loc_6:* = this._-LM.numChildren;
            var _loc_7:* = 0;
            var _loc_8:* = _loc_5;
            while (_loc_8 < _loc_6)
            {
                
                _loc_9 = this._-LM.getChildAt(_loc_8) as GButton;
                if (!_loc_9.data)
                {
                    break;
                }
                if (_loc_7 == _loc_2.selectedIndex)
                {
                    _loc_9.selected = true;
                }
                else
                {
                    _loc_9.selected = false;
                }
                _loc_7++;
                _loc_8++;
            }
            return;
        }// end function

        private function setPages(param1:FController, param2:GComponent, param3:int) : void
        {
            var _loc_4:* = null;
            var _loc_8:* = null;
            var _loc_5:* = param3 < 0;
            var _loc_6:* = param1.getPages();
            var _loc_7:* = 0;
            while (_loc_7 < _loc_6.length)
            {
                
                if (_loc_5)
                {
                    _loc_4 = this._-LM.addItemFromPool("ui://Builder/ControllerItem").asButton;
                }
                else
                {
                    _loc_4 = this._-LM.addChildAt(this._-LM.getFromPool("ui://Builder/ControllerItem"), param3++).asButton;
                }
                _loc_8 = _loc_6[_loc_7];
                if (_loc_8.name)
                {
                    _loc_4.text = _loc_7 + ":" + _loc_8.name;
                }
                else if (_loc_8.remark)
                {
                    _loc_4.text = _loc_7 + ":" + _loc_8.remark;
                }
                else
                {
                    _loc_4.text = "" + _loc_7;
                }
                _loc_4.data = param2;
                _loc_4.selected = _loc_7 == param1.selectedIndex;
                _loc_7++;
            }
            return;
        }// end function

        private function _-6V(event:ItemEvent) : void
        {
            var _loc_8:* = 0;
            var _loc_11:* = null;
            var _loc_2:* = event.itemObject as GButton;
            if (!_loc_2.data)
            {
                return;
            }
            _loc_2.selected = true;
            var _loc_3:* = GComponent(_loc_2.data);
            var _loc_4:* = this._content.getController(_loc_3.name);
            var _loc_5:* = this._-LM.getChildIndex(_loc_3);
            var _loc_6:* = this._-LM.numChildren;
            var _loc_7:* = _loc_4.selectedIndex;
            var _loc_9:* = _loc_5 + 1;
            while (_loc_9 < _loc_6)
            {
                
                _loc_11 = this._-LM.getChildAt(_loc_9) as GButton;
                if (!_loc_11.data)
                {
                    break;
                }
                else if (_loc_11 == _loc_2)
                {
                    _loc_8 = _loc_9 - _loc_5 - 1;
                }
                else
                {
                    GButton(_loc_11).selected = false;
                }
                _loc_9++;
            }
            _loc_4.setSelectedIndex(_loc_8);
            var _loc_10:* = this._content.controllers.indexOf(_loc_4);
            if (this._content.controllers.indexOf(_loc_4) != -1)
            {
                this._-JT[_loc_10] = _loc_4.selectedIndex;
            }
            return;
        }// end function

        private function _-a() : void
        {
            GTimers.inst.callLater(this._-6G);
            return;
        }// end function

        private function _-6G() : void
        {
            this._-LM.resizeToFit(int.MAX_VALUE, this._-LM.initHeight);
            return;
        }// end function

    }
}
