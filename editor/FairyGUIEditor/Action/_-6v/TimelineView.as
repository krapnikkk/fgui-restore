package _-6v
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.geom.*;

    public class TimelineView extends GComponent implements ITimelineView
    {
        private var _editor:IEditor;
        private var _panel:GComponent;
        private var _-IN:GComponent;
        private var _list:GList;
        private var _-Ob:GList;
        private var _-It:GObject;
        private var _-3Z:_-1C;
        private var _-DC:PopupMenu;
        private var _-Mc:PopupMenu;
        private var _-MT:GObject;
        private var _-MH:GObject;
        private var _-Jx:GObject;
        private var _status:Controller;
        private var _-PR:GSlider;
        private var _maxFrame:int;
        private var _frameRate:int;
        private var _-64:Vector.<TimelineSelection>;
        private var _-EZ:GComponent;
        private var _-F4:GObjectPool;
        private var _-2n:TimelineSelection;
        private var _-OV:Boolean;
        private var _-HV:GObject;
        private var _-Ao:Boolean;
        private var _-JI:int;
        private var _needRefresh:Boolean;
        private var _-F6:Array;
        private var _-NN:Point;
        private var _-JY:int;
        private var _-10:int;
        private var _-OY:Vector.<FObject>;
        private var _-KQ:Boolean;
        private static const _-7V:int = 100;
        private static const _-JD:int = 50;

        public function TimelineView(param1:IEditor)
        {
            var btn:GButton;
            var editor:* = param1;
            this._editor = editor;
            UIObjectFactory.setPackageItemExtension("ui://Builder/Timeline", TimelineBar);
            this._panel = UIPackage.createObject("Builder", "TimelineView").asCom;
            this.setSize(this._panel.width, this._panel.height);
            this._panel.addRelation(this, RelationType.Size);
            addChild(this._panel);
            this._maxFrame = 30 * 24;
            this._frameRate = 24;
            this._-64 = new Vector.<TimelineSelection>;
            this._-F6 = [];
            this._-NN = new Point();
            this._-OY = new Vector.<FObject>;
            this._-IN = this._panel.getChild("inner").asCom;
            this._list = this._panel.getChild("list").asList;
            this._list.autoResizeItem = false;
            this._list.draggable = true;
            this._list.addEventListener(GTouchEvent.CLICK, this._-Ay);
            this._list.addEventListener(DragEvent.DRAG_START, this.__dragStart);
            this._list.addEventListener(MouseEvent.RIGHT_CLICK, this._-CE);
            this._list.scrollPane.addEventListener(Event.SCROLL, this._-Ci);
            this._-Ob = this._panel.getChild("nameList").asList;
            this._-Ob.addClickListener(this._-EV);
            this._-Ob.addEventListener(MouseEvent.RIGHT_CLICK, this._-8K);
            this._-Ob.scrollPane.addEventListener(Event.SCROLL, this._-G7);
            var gcom:* = this._panel.getChild("selContainer").asCom;
            this._-EZ = new GComponent();
            gcom.addChild(this._-EZ);
            this._-F4 = new GObjectPool();
            this._-2n = new TimelineSelection();
            this._-HV = UIPackage.createObject("Builder", "TimelineSelection2");
            this._-It = this._-IN.getChild("head");
            this._-It.touchable = false;
            this._-MT = this._panel.getChild("fps");
            this._-MH = this._panel.getChild("frame");
            this._-Jx = this._panel.getChild("time");
            this._-PR = this._panel.getChild("maxFrame").asSlider;
            this._-PR.addEventListener(StateChangeEvent.CHANGED, this._-Oo);
            this._-3Z = new _-1C();
            this._-3Z.height = this._panel.getChild("numBar").height;
            this._-3Z.update(this._maxFrame, this._frameRate);
            this._-IN.addChild(this._-3Z);
            this._-DC = new PopupMenu();
            this._-DC.contentPane.width = 210;
            btn = this._-DC.addItem(Consts.strings.text217, this._-Of);
            btn.name = "setKeyFrame";
            btn.getChild("shortcut").text = Consts.isMacOS ? ("⌘K") : ("Ctrl+K");
            btn = this._-DC.addItem(Consts.strings.text227, this._-3S);
            btn.name = "clearKeyFrame";
            btn = this._-DC.addItem(Consts.strings.text298, this._-NI);
            btn.name = "addFrame";
            btn.getChild("shortcut").text = Consts.isMacOS ? ("⌘I") : ("Ctrl+I");
            btn = this._-DC.addItem(Consts.strings.text218, this._-8c);
            btn.name = "removeFrame";
            btn.getChild("shortcut").text = Consts.isMacOS ? ("⌘D") : ("Ctrl+D");
            this._-DC.addSeperator();
            this._-DC.addItem(Consts.strings.text265, this._-Bi).name = "addTween";
            this._-DC.addItem(Consts.strings.text266, this._-Jj).name = "removeTween";
            this._-DC.addSeperator();
            this._-DC.addItem(Consts.strings.text88, this._-AS).name = "editPath";
            this._-Mc = new PopupMenu();
            this._-Mc.contentPane.width = 210;
            this._-Mc.addItem(Consts.strings.text299, this._-BF);
            this._-Mc.addItem(Consts.strings.text300, this._-Ph).name = "paste";
            this._-Mc.addItem(Consts.strings.text219, this._-9H);
            this._-Mc.addItem(Consts.strings.text340, this._-D3).name = "changeTarget";
            this._panel.getChild("numBar").addClickListener(this._-28);
            this._panel.getChild("numBar").addEventListener(GTouchEvent.DRAG, this._-28);
            this._status = this._panel.getController("status");
            addEventListener(DropEvent.DROP, this._-G6);
            addEventListener(_-4U._-76, this.handleKeyEvent);
            this._editor.on(EditorEvent.SelectionChanged, this._-Q2);
            this._editor.on(EditorEvent.DocumentActivated, function () : void
            {
                _needRefresh = true;
                return;
            }// end function
            );
            this._editor.on(EditorEvent.DocumentDeactivated, this.clear);
            this._editor.on(EditorEvent.OnLateUpdate, this._-4v);
            return;
        }// end function

        public function _-4v() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_1:* = this._editor.docView.activeDocument;
            if (!_loc_1)
            {
                return;
            }
            if (_loc_1.timelineMode)
            {
                _loc_5 = _loc_1.editingTransition;
                if (_loc_5.frameRate != this._frameRate)
                {
                    this._frameRate = _loc_5.frameRate;
                    if (!this._-He())
                    {
                        this._-3Z.update(this._maxFrame, this._frameRate);
                    }
                    this._-MT.text = "" + this._frameRate;
                    this._-GD(_loc_1.head);
                }
                else if (_loc_5.maxFrame > this._maxFrame)
                {
                    this._-He();
                }
                if (this._needRefresh)
                {
                    this._needRefresh = false;
                    this._-KT();
                }
                else
                {
                    _loc_3 = this._list.numChildren;
                    _loc_6 = _loc_5.items;
                    _loc_2 = 0;
                    while (_loc_2 < _loc_3)
                    {
                        
                        _loc_4 = TimelineBar(this._list.getChildAt(_loc_2));
                        if (_loc_4._needRefresh)
                        {
                            _loc_4._needRefresh = false;
                            _loc_4.reset();
                            for each (_loc_7 in _loc_6)
                            {
                                
                                if (_loc_4.targetId == _loc_7.targetId && _loc_4.type == _loc_7.type)
                                {
                                    _loc_4.setKeyFrame(_loc_7.frame, _loc_7);
                                    if (_loc_7.nextItem)
                                    {
                                        _loc_4._-N5(_loc_7.frame, _loc_7.nextItem.frame);
                                    }
                                }
                            }
                        }
                        _loc_2++;
                    }
                }
                if (this._-F6.length > 0)
                {
                    _loc_4 = this._-Ei(this._-F6[0], this._-F6[1]);
                    if (_loc_4)
                    {
                        this.addSelection(_loc_4, this._-F6[2]);
                    }
                    this._-F6.length = 0;
                }
            }
            else
            {
                this.clear();
            }
            return;
        }// end function

        private function _-Q2() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (this._-OV)
            {
                return;
            }
            var _loc_1:* = this._editor.docView.activeDocument;
            if (!_loc_1.timelineMode)
            {
                return;
            }
            var _loc_2:* = _loc_1.getSelection();
            if (_loc_2.length > 0)
            {
                _loc_3 = _loc_2[(_loc_2.length - 1)];
                for each (_loc_4 in this._-64)
                {
                    
                    if (_loc_4.timeline.targetId == _loc_3._id)
                    {
                        return;
                    }
                }
                _loc_5 = this._-Ei(_loc_3._id, "*");
                if (_loc_5)
                {
                    this.addSelection(_loc_5, _loc_1.head, 0, true);
                }
            }
            else
            {
                this.clearSelection();
            }
            return;
        }// end function

        public function refresh(param1:FTransitionItem = null) : void
        {
            var _loc_2:* = null;
            if (param1 == null)
            {
                this._needRefresh = true;
            }
            else
            {
                _loc_2 = this._-Ei(param1.targetId, param1.type);
                if (_loc_2)
                {
                    _loc_2._needRefresh = true;
                }
                else
                {
                    this._needRefresh = true;
                }
            }
            return;
        }// end function

        public function selectKeyFrame(param1:FTransitionItem) : void
        {
            this._-F6[0] = param1.targetId;
            this._-F6[1] = param1.type;
            this._-F6[2] = param1.frame;
            return;
        }// end function

        public function getSelection() : FTransitionItem
        {
            if (this._-64.length == 0)
            {
                return null;
            }
            var _loc_1:* = this._editor.docView.activeDocument;
            return _loc_1.editingTransition.findItem(_loc_1.head, this._-64[0].timeline.targetId, this._-64[0].timeline.type);
        }// end function

        private function clear() : void
        {
            if (this._status.selectedIndex != 0)
            {
                this._status.selectedIndex = 0;
                this._list.removeChildrenToPool();
                this._-Ob.removeChildrenToPool();
                this._list.scrollPane.percX = 0;
                this._list.scrollPane.percY = 0;
                this._-F6.length = 0;
            }
            this._needRefresh = true;
            return;
        }// end function

        private function setKeyFrame() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_1:* = this._editor.docView.activeDocument;
            for each (_loc_2 in this._-64)
            {
                
                _loc_3 = _loc_2.start;
                while (_loc_3 <= _loc_2.end)
                {
                    
                    if (_loc_2.timeline._-C1(_loc_3))
                    {
                    }
                    else
                    {
                        _loc_1.setKeyFrame(_loc_2.timeline.targetId, _loc_2.timeline.type, _loc_3);
                    }
                    _loc_3++;
                }
            }
            return;
        }// end function

        private function clearKeyFrame() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_1:* = this._editor.docView.activeDocument;
            for each (_loc_2 in this._-64)
            {
                
                _loc_3 = _loc_2.start;
                while (_loc_3 <= _loc_2.end)
                {
                    
                    if (!_loc_2.timeline._-C1(_loc_3))
                    {
                    }
                    else
                    {
                        _loc_4 = _loc_2.timeline._-P3(_loc_3);
                        _loc_1.removeKeyFrame(_loc_4);
                    }
                    _loc_3++;
                }
            }
            return;
        }// end function

        private function _-E9() : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_1:* = this._editor.docView.activeDocument;
            var _loc_2:* = _loc_1.editingTransition;
            var _loc_3:* = _loc_2.items;
            var _loc_4:* = _loc_3.length;
            for each (_loc_9 in this._-64)
            {
                
                _loc_7 = _loc_9.timeline._-8z(_loc_9.start);
                if (_loc_7 < 0)
                {
                    continue;
                }
                _loc_8 = _loc_9.timeline._-P3(_loc_7);
                _loc_6 = _loc_3.indexOf(_loc_8);
                _loc_5 = _loc_6;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_8 = _loc_3[_loc_5];
                    if (_loc_8.type == _loc_9.timeline.type && _loc_8.targetId == _loc_9.timeline.targetId)
                    {
                        _loc_1.setKeyFrameProperty(_loc_8, "frame", (_loc_8.frame + 1));
                    }
                    _loc_5++;
                }
            }
            return;
        }// end function

        private function removeFrame() : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_1:* = this._editor.docView.activeDocument;
            var _loc_2:* = _loc_1.editingTransition;
            var _loc_3:* = _loc_2.items;
            for each (_loc_4 in this._-64)
            {
                
                _loc_5 = _loc_4.start;
                while (_loc_5 <= _loc_4.end)
                {
                    
                    if (!_loc_4.timeline._-C1(_loc_5))
                    {
                    }
                    else
                    {
                        _loc_6 = _loc_4.timeline._-P3(_loc_5);
                        _loc_4.timeline.removeKeyFrame(_loc_5);
                        _loc_1.removeKeyFrame(_loc_6);
                    }
                    _loc_5++;
                }
                _loc_7 = _loc_4.timeline._-8z(_loc_4.start);
                if (_loc_7 < 0)
                {
                    continue;
                }
                _loc_6 = _loc_4.timeline._-P3(_loc_7);
                _loc_8 = _loc_3.indexOf(_loc_6);
                _loc_9 = _loc_4.end - _loc_4.start + 1;
                _loc_10 = _loc_3.length;
                _loc_5 = _loc_8;
                while (_loc_5 < _loc_10)
                {
                    
                    _loc_6 = _loc_3[_loc_5];
                    if (_loc_6.type == _loc_4.timeline.type && _loc_6.targetId == _loc_4.timeline.targetId)
                    {
                        _loc_1.setKeyFrameProperty(_loc_6, "frame", _loc_6.frame - _loc_9);
                    }
                    _loc_5++;
                }
            }
            return;
        }// end function

        private function _-Ei(param1:String, param2:String) : TimelineBar
        {
            var _loc_5:* = null;
            var _loc_3:* = this._list.numChildren;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = TimelineBar(this._list.getChildAt(_loc_4));
                if (_loc_5.targetId == param1 && (_loc_5.type == param2 || param2 == "*"))
                {
                    return _loc_5;
                }
                _loc_4++;
            }
            return null;
        }// end function

        private function _-GD(param1:int) : void
        {
            var _loc_2:* = this._editor.docView.activeDocument;
            _loc_2.head = param1;
            this._-It.x = param1 * 10;
            this._-MH.text = "" + param1;
            this._-Jx.text = UtilsStr.toFixed(param1 / this._frameRate, 3) + "s";
            return;
        }// end function

        private function _-Fj(param1:String, param2:String) : TimelineBar
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_7:* = null;
            var _loc_5:* = this._editor.docView.activeDocument;
            var _loc_6:* = this._-Ob.addItemFromPool().asButton;
            if (param1)
            {
                _loc_7 = _loc_5.content.getChildById(param1);
                _loc_6.title = _loc_7.name;
                _loc_6.icon = _loc_7.docElement.displayIcon;
            }
            else
            {
                _loc_7 = _loc_5.content;
                _loc_6.title = Consts.strings.text170;
                _loc_6.icon = _loc_7.docElement.displayIcon;
            }
            _loc_6.getChild("type").text = param2;
            this._status.selectedIndex = 2;
            var _loc_8:* = TimelineBar(this._list.addItemFromPool());
            _loc_8.init(param1, param2, _loc_7);
            _loc_8.data = _loc_6;
            _loc_8._-6J(this._maxFrame);
            _loc_8.reset();
            return _loc_8;
        }// end function

        private function _-KT() : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_1:* = this._editor.docView.activeDocument;
            var _loc_2:* = _loc_1.editingTransition;
            this._list.removeChildrenToPool();
            this._-Ob.removeChildrenToPool();
            var _loc_3:* = _loc_2.items;
            for each (_loc_5 in _loc_3)
            {
                
                if (!_loc_5.target)
                {
                    continue;
                }
                _loc_4 = this._-Ei(_loc_5.targetId, _loc_5.type);
                if (_loc_4 == null)
                {
                    _loc_4 = this._-Fj(_loc_5.targetId, _loc_5.type);
                }
                else
                {
                    _loc_4.init(_loc_5.targetId, _loc_5.type, _loc_5.target);
                }
                _loc_4.setKeyFrame(_loc_5.frame, _loc_5);
                if (_loc_5.nextItem)
                {
                    _loc_4._-N5(_loc_5.frame, _loc_5.nextItem.frame);
                }
                _loc_4._needRefresh = false;
            }
            this._-Dg();
            this._status.selectedIndex = this._list.numChildren == 0 ? (1) : (2);
            this._-GD(_loc_1.head);
            return;
        }// end function

        private function _-Fu(param1:TimelineBar, param2:TimelineBar) : int
        {
            var _loc_3:* = 0;
            if (param1.targetId && param2.targetId)
            {
                _loc_3 = param1.data.text.localeCompare(param2.data.text);
            }
            else if (param1.targetId)
            {
                _loc_3 = 1;
            }
            else if (param2.targetId)
            {
                _loc_3 = -1;
            }
            if (_loc_3 == 0)
            {
                _loc_3 = param1.type.localeCompare(param2.type);
            }
            return _loc_3;
        }// end function

        private function _-Dg() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            this._list.sortChildren(this._-Fu);
            var _loc_1:* = this._-Ob.numChildren;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = GObject(this._list.getChildAt(_loc_2).data);
                this._-Ob.addChild(_loc_3);
                _loc_2++;
            }
            this._-Ob.setBoundsChangedFlag();
            return;
        }// end function

        private function addSelection(param1:TimelineBar, param2:int, param3:int = 0, param4:Boolean = false) : void
        {
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = null;
            var _loc_13:* = 0;
            var _loc_14:* = null;
            this._list.ensureBoundsCorrect();
            this._-GD(param2);
            var _loc_5:* = this._editor.docView.activeDocument;
            _loc_5.refreshInspectors();
            if (this._-64.length == 0)
            {
                param3 = 0;
            }
            if (param3 == 2)
            {
                _loc_8 = this._list.getChildIndex(this._-2n.timeline);
                _loc_9 = this._list.getChildIndex(param1);
                if (this._-2n.start < param2)
                {
                    _loc_6 = this._-2n.start;
                    _loc_7 = param2;
                }
                else
                {
                    _loc_6 = param2;
                    _loc_7 = this._-2n.start;
                }
                this.clearSelection();
                if (_loc_8 > _loc_9)
                {
                    _loc_11 = _loc_8;
                    _loc_8 = _loc_9;
                    _loc_9 = _loc_11;
                }
                _loc_10 = _loc_8;
                while (_loc_10 <= _loc_9)
                {
                    
                    _loc_12 = new TimelineSelection();
                    _loc_12.timeline = TimelineBar(this._list.getChildAt(_loc_10));
                    this._-64.push(_loc_12);
                    this._-w(_loc_12, _loc_6, _loc_7);
                    this._-Ob.addSelection(_loc_10);
                    _loc_10++;
                }
            }
            else
            {
                var _loc_15:* = param2;
                _loc_7 = param2;
                _loc_6 = _loc_15;
                if (param3 == 1)
                {
                    _loc_13 = this._-64.length;
                    _loc_10 = 0;
                    while (_loc_10 < _loc_13)
                    {
                        
                        _loc_12 = this._-64[_loc_10];
                        if (_loc_12.timeline == param1)
                        {
                            if (_loc_12.start <= param2 && _loc_12.end >= param2)
                            {
                                _loc_6 = -1;
                                if (_loc_12.start == param2)
                                {
                                    if (_loc_12.end == param2)
                                    {
                                        this._-64.splice(_loc_10, 1);
                                        this._-F4.returnObject(_loc_12.obj);
                                        this._-EZ.removeChild(_loc_12.obj);
                                    }
                                    else
                                    {
                                        this._-w(_loc_12, (param2 + 1), _loc_12.end);
                                    }
                                }
                                else if (_loc_12.end == param2)
                                {
                                    this._-w(_loc_12, (param2 - 1), _loc_12.end);
                                }
                                else
                                {
                                    _loc_6 = param2 + 1;
                                    _loc_7 = _loc_12.end;
                                    this._-w(_loc_12, _loc_12.start, (param2 - 1));
                                }
                                break;
                            }
                        }
                        _loc_10++;
                    }
                }
                else
                {
                    this.clearSelection();
                }
                if (_loc_6 != -1)
                {
                    _loc_12 = new TimelineSelection();
                    _loc_12.timeline = param1;
                    this._-64.push(_loc_12);
                    this._-w(_loc_12, _loc_6, _loc_7);
                    this._-Ob.addSelection(this._list.getChildIndex(param1));
                    if (this._-64.length == 1)
                    {
                        this._-2n.start = _loc_12.start;
                        this._-2n.end = _loc_12.end;
                        this._-2n.timeline = _loc_12.timeline;
                    }
                }
            }
            if (param4)
            {
                return;
            }
            this._-OV = true;
            this._-OY.length = 0;
            for each (_loc_12 in this._-64)
            {
                
                _loc_14 = _loc_12.timeline.target;
                if (!_loc_14.docElement.isRoot && this._-OY.indexOf(_loc_14) == -1)
                {
                    this._-OY.push(_loc_14);
                }
            }
            if (this._-OY.length == 0)
            {
                _loc_5.unselectAll();
            }
            else
            {
                _loc_5.setSelection(this._-OY);
            }
            this._-OV = false;
            return;
        }// end function

        private function clearSelection() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this._-64)
            {
                
                this._-F4.returnObject(_loc_1.obj);
            }
            this._-EZ.removeChildren();
            _loc_3.length = 0;
            this._-Ob.selectedIndex = -1;
            return;
        }// end function

        private function removeSelection(param1:TimelineBar) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = this._-64.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._-64[_loc_3];
                if (_loc_4.timeline == param1)
                {
                    this._-F4.returnObject(_loc_4.obj);
                    this._-EZ.removeChild(_loc_4.obj);
                    this._-64.splice(_loc_3, 1);
                    this._-Ob.removeSelection(this._list.getChildIndex(param1));
                    _loc_2 = _loc_2 - 1;
                    continue;
                }
                _loc_3++;
            }
            return;
        }// end function

        private function _-Af() : Boolean
        {
            var _loc_5:* = null;
            this._list.ensureBoundsCorrect();
            this._-64.sort(this._-HB);
            var _loc_1:* = this._-64.length;
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = true;
            while (_loc_3 < _loc_1)
            {
                
                _loc_5 = this._-64[_loc_3];
                if (_loc_2 == null)
                {
                    _loc_2 = _loc_5;
                    _loc_3++;
                    continue;
                }
                if (_loc_5.timeline == _loc_2.timeline)
                {
                    if (_loc_5.start == (_loc_2.end + 1))
                    {
                        this._-w(_loc_2, _loc_2.start, _loc_5.end);
                        this._-F4.returnObject(_loc_5.obj);
                        this._-64.splice(_loc_3, 1);
                        _loc_1 = _loc_1 - 1;
                        _loc_3 = _loc_3 - 1;
                    }
                    else
                    {
                        _loc_4 = false;
                    }
                }
                else if (_loc_5.timeline.y - _loc_2.timeline.y >= _loc_5.timeline.height * 2)
                {
                    _loc_4 = false;
                }
                _loc_2 = _loc_5;
                _loc_3++;
            }
            if (_loc_4)
            {
                _loc_1 = this._-64.length;
                _loc_2 = this._-64[0];
                _loc_3 = 1;
                while (_loc_3 < _loc_1)
                {
                    
                    _loc_5 = this._-64[_loc_3];
                    if (_loc_5.start != _loc_2.start || _loc_5.end != _loc_2.end)
                    {
                        _loc_4 = false;
                        break;
                    }
                    _loc_3++;
                }
            }
            return _loc_4;
        }// end function

        private function _-HB(param1:TimelineSelection, param2:TimelineSelection) : int
        {
            if (param1.timeline == param2.timeline)
            {
                return param1.start - param2.start;
            }
            return param1.timeline.y - param2.timeline.y;
        }// end function

        private function _-w(param1:TimelineSelection, param2:int, param3:int) : void
        {
            param1.start = param2;
            param1.end = param3;
            if (!param1.obj)
            {
                param1.obj = this._-F4.getObject("ui://Builder/TimelineSelection");
            }
            param1.obj.setXY(param1.start * 10, param1.timeline.y);
            param1.obj.width = (param1.end - param1.start + 1) * param1.obj.sourceWidth;
            if (!param1.obj.parent)
            {
                this._-EZ.addChild(param1.obj);
            }
            return;
        }// end function

        private function _-D5(param1:Number) : TimelineBar
        {
            var _loc_2:* = this._list.localToGlobal(1, 1);
            return TimelineBar(this._list.getItemNear(_loc_2.x, param1));
        }// end function

        private function _-28(event:GTouchEvent) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = this._-IN.globalToLocal(event.stageX, event.stageY);
            _loc_2.x = _loc_2.x + this._-IN.scrollPane.posX;
            var _loc_3:* = _loc_2.x / 10;
            if (_loc_3 < 0)
            {
                _loc_3 = 0;
            }
            this._-GD(_loc_3);
            for each (_loc_4 in this._-64)
            {
                
                this._-w(_loc_4, _loc_3, _loc_3);
            }
            this._-Ob.selectedIndex = -1;
            return;
        }// end function

        private function _-Ay(event:GTouchEvent) : void
        {
            var _loc_2:* = TimelineBar(this._list.getItemNear(event.stageX, event.stageY));
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_3:* = this._-IN.globalToLocal(event.stageX, event.stageY);
            _loc_3.x = _loc_3.x + this._-IN.scrollPane.posX;
            var _loc_4:* = _loc_3.x / 10;
            if (event.ctrlKey)
            {
                this.addSelection(_loc_2, _loc_4, 1);
            }
            else if (event.shiftKey)
            {
                this.addSelection(_loc_2, _loc_4, 2);
            }
            else
            {
                this.addSelection(_loc_2, _loc_4, 0);
            }
            return;
        }// end function

        private function _-CE(event:MouseEvent) : void
        {
            var _loc_12:* = null;
            var _loc_13:* = 0;
            var _loc_14:* = 0;
            var _loc_2:* = this._editor.groot.nativeStage.mouseX;
            var _loc_3:* = this._editor.groot.nativeStage.mouseY;
            var _loc_4:* = TimelineBar(this._list.getItemNear(_loc_2, _loc_3));
            if (TimelineBar(this._list.getItemNear(_loc_2, _loc_3)) == null)
            {
                return;
            }
            var _loc_5:* = this._-IN.globalToLocal(_loc_2, _loc_3);
            _loc_5.x = _loc_5.x + this._-IN.scrollPane.posX;
            var _loc_6:* = _loc_5.x / 10;
            this.addSelection(_loc_4, _loc_6, 3);
            var _loc_7:* = false;
            var _loc_8:* = false;
            var _loc_9:* = false;
            var _loc_10:* = false;
            var _loc_11:* = false;
            for each (_loc_12 in this._-64)
            {
                
                _loc_4 = _loc_12.timeline;
                if (_loc_12.start <= _loc_4.maxFrame && _loc_4.maxFrame > 0)
                {
                    _loc_8 = true;
                }
                _loc_13 = _loc_12.start;
                while (_loc_13 <= _loc_12.end)
                {
                    
                    if (_loc_4._-C1(_loc_13))
                    {
                        _loc_7 = true;
                    }
                    if (_loc_13 < _loc_4.maxFrame || _loc_13 == _loc_4.maxFrame && _loc_4.maxFrame > 0)
                    {
                        if (FTransition.supportTween(_loc_4.type))
                        {
                            _loc_9 = true;
                        }
                        _loc_14 = _loc_4._-Kd(_loc_13);
                        if (_loc_14 != -1)
                        {
                            _loc_10 = true;
                            if (_loc_4._-P3(_loc_14).usePath)
                            {
                                _loc_11 = true;
                            }
                        }
                    }
                    _loc_13++;
                }
            }
            this._-DC.setItemGrayed("setKeyFrame", false);
            this._-DC.setItemGrayed("clearKeyFrame", !_loc_7);
            this._-DC.setItemGrayed("removeFrame", !_loc_8);
            this._-DC.setItemGrayed("addFrame", !_loc_8);
            if (_loc_9)
            {
                if (_loc_10)
                {
                    this._-DC.setItemGrayed("addTween", true);
                    this._-DC.setItemGrayed("removeTween", false);
                }
                else
                {
                    this._-DC.setItemGrayed("addTween", false);
                    this._-DC.setItemGrayed("removeTween", true);
                }
                this._-DC.setItemGrayed("editPath", !_loc_11);
            }
            else
            {
                this._-DC.setItemGrayed("addTween", true);
                this._-DC.setItemGrayed("removeTween", true);
                this._-DC.setItemGrayed("editPath", true);
            }
            this._-DC.show(this._panel.root);
            return;
        }// end function

        private function _-EV(event:GTouchEvent) : void
        {
            var _loc_2:* = this._-D5(this._editor.groot.nativeStage.mouseY);
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_3:* = this._editor.docView.activeDocument;
            var _loc_4:* = _loc_3.editingTransition;
            if (event.ctrlKey)
            {
                this.addSelection(_loc_2, _loc_3.head, 1);
            }
            else if (event.shiftKey)
            {
                this.addSelection(_loc_2, _loc_3.head, 2);
            }
            else
            {
                this.addSelection(_loc_2, _loc_3.head, 0);
            }
            return;
        }// end function

        private function _-8K(event:MouseEvent) : void
        {
            var _loc_2:* = this._-D5(this._editor.groot.nativeStage.mouseY);
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_3:* = this._editor.docView.activeDocument;
            var _loc_4:* = _loc_3.editingTransition;
            var _loc_5:* = this._list.getChildIndex(_loc_2);
            if (!this._-Ob.getChildAt(_loc_5).asButton.selected)
            {
                this.addSelection(_loc_2, _loc_3.head);
            }
            this._-Mc.setItemGrayed("paste", !_-Ia.hasFormat(_-Ia._-OA));
            this._-Mc.setItemGrayed("changeTarget", _loc_2.type == "Sound");
            this._-Mc.show(this._panel.root);
            return;
        }// end function

        private function __dragStart(event:DragEvent) : void
        {
            var _loc_6:* = null;
            event.preventDefault();
            this._list.cancelClick();
            var _loc_2:* = TimelineBar(this._list.getItemNear(event.stageX, event.stageY));
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_3:* = this._-IN.globalToLocal(event.stageX, event.stageY);
            _loc_3.x = _loc_3.x + this._-IN.scrollPane.posX;
            this._-JI = _loc_3.x / 10;
            var _loc_4:* = false;
            var _loc_5:* = this._-64.length;
            for each (_loc_6 in this._-64)
            {
                
                if (_loc_6.timeline == _loc_2 && _loc_6.start <= this._-JI && _loc_6.end >= this._-JI)
                {
                    _loc_4 = true;
                    break;
                }
            }
            if (!_loc_4 || !this._-Af())
            {
                this._-Ao = false;
                this.addSelection(_loc_2, this._-JI);
            }
            else
            {
                this._-Ao = true;
                this._-HV.setXY(_loc_8[0].obj.x, _loc_8[0].obj.y);
                this._-HV.setSize(_loc_8[0].obj.width, _loc_8[(_loc_8.length - 1)].obj.y + _loc_8[(_loc_8.length - 1)].obj.height - _loc_8[0].obj.y);
                this._-EZ.addChild(this._-HV);
            }
            this._-NN.setTo(event.stageX, event.stageY);
            this._editor.dragManager.startDrag(this, null, null, {cursor:null, onComplete:this.__dragEnd, onCancel:this.__dragEnd, onMove:this.__dragging});
            return;
        }// end function

        private function __dragging(event:DragEvent) : void
        {
            this._-JY = event.stageX - this._-NN.x;
            this._-10 = event.stageY - this._-NN.y;
            GTimers.inst.add(200, 1, this._-Az);
            this._-Io(event.stageX, event.stageY);
            return;
        }// end function

        private function _-Io(param1:Number, param2:Number) : void
        {
            var _loc_6:* = NaN;
            var _loc_7:* = null;
            var _loc_3:* = this._-IN.globalToLocal(param1, param2);
            if (_loc_3.x < 1)
            {
                _loc_3.x = 1;
            }
            else if (_loc_3.x > this._-IN.width)
            {
                _loc_3.x = this._-IN.width;
            }
            if (_loc_3.y < (this._list.y + 1))
            {
                _loc_3.y = this._list.y + 1;
            }
            else if (_loc_3.y > this._-IN.height)
            {
                _loc_3.y = this._-IN.height;
            }
            _loc_3.x = _loc_3.x + this._-IN.scrollPane.posX;
            var _loc_4:* = _loc_3.x / 10;
            if (_loc_3.x / 10 < 0)
            {
                _loc_4 = 0;
            }
            var _loc_5:* = _loc_4 - this._-JI;
            _loc_3 = this._-IN.localToGlobal(_loc_3.x, _loc_3.y);
            if (this._-Ao)
            {
                _loc_6 = this._-64[0].obj.x + _loc_5 * 10;
                if (_loc_6 < 0)
                {
                    _loc_6 = 0;
                }
                this._-HV.x = _loc_6;
            }
            else
            {
                _loc_7 = TimelineBar(this._list.getItemNear(_loc_3.x, _loc_3.y));
                if (!_loc_7)
                {
                    _loc_7 = TimelineBar(this._list.getChildAt((this._list.numChildren - 1)));
                }
                this.addSelection(_loc_7, _loc_4, 2);
            }
            return;
        }// end function

        private function _-Az() : void
        {
            var _loc_1:* = this._editor.groot.nativeStage.mouseX;
            var _loc_2:* = this._editor.groot.nativeStage.mouseY;
            var _loc_3:* = this._list.scrollPane.owner.globalToLocal(_loc_1, _loc_2);
            if (_loc_3.x < _-7V && this._-JY < 0)
            {
                this._list.scrollPane.posX = this._list.scrollPane.posX - _-JD;
            }
            if (_loc_3.x > this._list.scrollPane.owner.width - _-7V - 20 && this._-JY > 0)
            {
                this._list.scrollPane.posX = this._list.scrollPane.posX + _-JD;
            }
            GTimers.inst.add(200, 1, this._-Az);
            this._-Io(_loc_1, _loc_2);
            return;
        }// end function

        private function __dragEnd() : void
        {
            this._-EZ.removeChild(this._-HV);
            GTimers.inst.remove(this._-Az);
            return;
        }// end function

        private function _-G6(event:DropEvent) : void
        {
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = null;
            if (event.source != this || !this._-Ao)
            {
                return;
            }
            var _loc_2:* = this._-HV.x / 10;
            if (_loc_2 < 0)
            {
                _loc_2 = 0;
            }
            var _loc_3:* = _loc_2 - this._-64[0].start;
            if (_loc_3 == 0)
            {
                return;
            }
            var _loc_4:* = this._editor.docView.activeDocument;
            var _loc_5:* = _loc_4.editingTransition;
            var _loc_6:* = _loc_5.items;
            var _loc_7:* = _loc_6.length;
            for each (_loc_12 in this._-64)
            {
                
                _loc_10 = _loc_12.timeline._-8z(_loc_12.start);
                _loc_12.start = _loc_12.start + _loc_3;
                _loc_12.end = _loc_12.end + _loc_3;
                _loc_12.obj.x = _loc_12.obj.x + _loc_3 * 10;
                if (_loc_10 < 0)
                {
                    continue;
                }
                _loc_11 = _loc_12.timeline._-P3(_loc_10);
                _loc_9 = _loc_6.indexOf(_loc_11);
                _loc_8 = _loc_9;
                while (_loc_8 < _loc_7)
                {
                    
                    _loc_11 = _loc_6[_loc_8];
                    if (_loc_11.type == _loc_12.timeline.type && _loc_11.targetId == _loc_12.timeline.targetId)
                    {
                        _loc_4.setKeyFrameProperty(_loc_11, "frame", _loc_11.frame + _loc_3);
                    }
                    _loc_8++;
                }
            }
            this._-GD(_loc_2);
            return;
        }// end function

        private function _-Of(event:Event) : void
        {
            this.setKeyFrame();
            return;
        }// end function

        private function _-3S(event:Event) : void
        {
            this.clearKeyFrame();
            return;
        }// end function

        private function _-NI(event:Event) : void
        {
            this._-E9();
            return;
        }// end function

        private function _-8c(event:Event) : void
        {
            this.removeFrame();
            return;
        }// end function

        private function _-Bi(event:Event) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (this._-64.length == 0)
            {
                return;
            }
            for each (_loc_2 in this._-64)
            {
                
                if (!FTransition.supportTween(_loc_2.timeline.type))
                {
                    continue;
                }
                _loc_3 = _loc_2.timeline._-9J(_loc_2.start);
                if (_loc_3 != -1)
                {
                    _loc_4 = this._editor.docView.activeDocument;
                    _loc_5 = _loc_4.editingTransition;
                    _loc_6 = _loc_2.timeline._-P3(_loc_3);
                    _loc_4.setKeyFrameProperty(_loc_6, "tween", true);
                }
            }
            return;
        }// end function

        private function _-Jj(event:Event) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (this._-64.length == 0)
            {
                return;
            }
            for each (_loc_2 in this._-64)
            {
                
                _loc_3 = _loc_2.timeline._-Kd(_loc_2.start);
                if (_loc_3 != -1)
                {
                    _loc_4 = this._editor.docView.activeDocument;
                    _loc_5 = _loc_4.editingTransition;
                    _loc_6 = _loc_2.timeline._-P3(_loc_3);
                    _loc_4.setKeyFrameProperty(_loc_6, "tween", false);
                }
            }
            return;
        }// end function

        private function _-AS(event:Event) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (this._-64.length == 0)
            {
                return;
            }
            for each (_loc_2 in this._-64)
            {
                
                _loc_3 = _loc_2.timeline._-9J(_loc_2.start);
                if (_loc_3 != -1)
                {
                    _loc_4 = this._editor.docView.activeDocument;
                    _loc_5 = _loc_4.editingTransition;
                    _loc_6 = _loc_2.timeline._-P3(_loc_3);
                    if (_loc_6.usePath)
                    {
                        _loc_4.openChild(_loc_6.target);
                        break;
                    }
                }
            }
            return;
        }// end function

        private function _-9H(event:Event) : void
        {
            if (this._-Ob.selectedIndex == -1)
            {
                return;
            }
            var _loc_2:* = TimelineBar(this._list.getChildAt(this._-Ob.selectedIndex));
            var _loc_3:* = this._editor.docView.activeDocument;
            _loc_3.removeKeyFrames(_loc_2.targetId, _loc_2.type);
            this.removeSelection(_loc_2);
            this._-Ob.selectedIndex = -1;
            var _loc_4:* = this._list.getChildIndex(_loc_2);
            this._list.removeChildToPool(_loc_2);
            this._-Ob.removeChildToPoolAt(_loc_4);
            this._status.selectedIndex = this._list.numChildren == 0 ? (1) : (2);
            return;
        }// end function

        private function _-BF(event:Event) : void
        {
            if (this._-Ob.selectedIndex == -1)
            {
                return;
            }
            var _loc_2:* = TimelineBar(this._list.getChildAt(this._-Ob.selectedIndex));
            var _loc_3:* = this._editor.docView.activeDocument;
            var _loc_4:* = _loc_3.editingTransition;
            var _loc_5:* = _loc_4.copyItems(_loc_2.targetId, _loc_2.type);
            _-Ia.setValue(_-Ia._-OA, _loc_5);
            return;
        }// end function

        private function _-Ph(event:Event) : void
        {
            if (this._-Ob.selectedIndex == -1)
            {
                return;
            }
            var _loc_2:* = TimelineBar(this._list.getChildAt(this._-Ob.selectedIndex));
            var _loc_3:* = this._editor.docView.activeDocument;
            var _loc_4:* = _-Ia._-4y(_-Ia._-OA) as XData;
            if (_-Ia._-4y(_-Ia._-OA) as XData)
            {
                _loc_3.setKeyFrames(_loc_2.targetId, _loc_2.type, _loc_4);
            }
            return;
        }// end function

        private function _-D3(event:Event) : void
        {
            var tl:TimelineBar;
            var evt:* = event;
            if (this._-Ob.selectedIndex == -1)
            {
                return;
            }
            tl = TimelineBar(this._list.getChildAt(this._-Ob.selectedIndex));
            var doc:* = this._editor.docView.activeDocument;
            doc.pickObject(doc.content.getChildById(tl.targetId), function (param1:FObject) : void
            {
                __objectSelected(param1, tl);
                return;
            }// end function
            , function (param1:FObject) : Boolean
            {
                if (!FTransition.getAllowType(param1, tl.type))
                {
                    _editor.alert("Not a valid target");
                    return false;
                }
                return true;
            }// end function
            );
            return;
        }// end function

        private function __objectSelected(param1:FObject, param2:TimelineBar) : void
        {
            var _loc_7:* = null;
            var _loc_3:* = this._editor.docView.activeDocument;
            var _loc_4:* = _loc_3.editingTransition;
            var _loc_5:* = _loc_4.items;
            var _loc_6:* = param1._id;
            for each (_loc_7 in _loc_5)
            {
                
                if (_loc_7.type == param2.type && _loc_7.targetId == param2.targetId)
                {
                    _loc_3.setKeyFrameProperty(_loc_7, "targetId", _loc_6);
                }
            }
            return;
        }// end function

        private function _-Ci(event:Event) : void
        {
            if (this._-KQ)
            {
                return;
            }
            this._-KQ = true;
            this._-Ob.scrollPane.posY = this._list.scrollPane.posY;
            this._-IN.scrollPane.posX = this._list.scrollPane.posX;
            this._-EZ.setXY(-this._list.scrollPane.posX, -this._list.scrollPane.posY);
            this._-KQ = false;
            return;
        }// end function

        private function _-G7(event:Event) : void
        {
            if (this._-KQ)
            {
                return;
            }
            this._-KQ = true;
            this._list.scrollPane.posY = this._-Ob.scrollPane.posY;
            this._-EZ.setXY(-this._list.scrollPane.posX, -this._list.scrollPane.posY);
            this._-KQ = false;
            return;
        }// end function

        private function handleKeyEvent(param1:_-4U) : void
        {
            switch(param1._-T)
            {
                case "0317":
                {
                    this.removeFrame();
                    break;
                }
                case "0318":
                {
                    this.setKeyFrame();
                    break;
                }
                case "0319":
                {
                    this._-E9();
                    break;
                }
                default:
                {
                    this._editor.docView.handleKeyEvent(param1);
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function _-Oo(event:Event) : void
        {
            this._-He();
            return;
        }// end function

        private function _-He() : Boolean
        {
            var _loc_4:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_1:* = this._editor.docView.activeDocument;
            var _loc_2:* = _loc_1.editingTransition;
            if (!_loc_2)
            {
                this._-PR.value = 0;
                return false;
            }
            var _loc_3:* = Math.ceil(_loc_2.maxFrame / this._frameRate);
            if (_loc_3 < 30)
            {
                _loc_4 = 0;
            }
            else
            {
                _loc_4 = Math.ceil((_loc_3 - 30) / 15);
            }
            _loc_4 = Math.max(_loc_4, this._-PR.value);
            var _loc_5:* = (30 + _loc_4 * 15) * this._frameRate;
            this._-PR.value = _loc_4;
            if (_loc_5 != this._maxFrame)
            {
                this._maxFrame = _loc_5;
                this._-3Z.update(this._maxFrame, this._frameRate);
                _loc_7 = this._list.numChildren;
                _loc_6 = 0;
                while (_loc_6 < _loc_7)
                {
                    
                    _loc_8 = TimelineBar(this._list.getChildAt(_loc_6));
                    _loc_8._-6J(this._maxFrame);
                    _loc_6++;
                }
                return true;
            }
            else
            {
                return false;
            }
        }// end function

    }
}
