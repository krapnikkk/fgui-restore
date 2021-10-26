package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;
    import fairygui.utils.*;

    public class ViewGrid extends GComponent
    {
        public var uid:String;
        var _hResizePiority:int;
        var _vResizePiority:int;
        private var _-HJ:GList;
        private var _-7H:GList;
        private var _content:GComponent;
        private var _-Nv:Controller;
        private var _mode:Controller;
        private var _-BP:Number;
        private var _-D1:Number;

        public function ViewGrid()
        {
            this.uid = UtilsStr.generateUID();
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            this._content = getChild("content").asCom;
            this.addSizeChangeCallback(this._-9I);
            this._mode = getController("mode");
            this._-Nv = getController("tabLayout");
            this._-HJ = getChild("tab").asList;
            this._-HJ.draggable = true;
            this._-7H = getChild("tab2").asList;
            this._-7H.draggable = true;
            this._-BP = this.width - this._content.width;
            this._-D1 = this.height - this._content.height;
            this._-HJ.addEventListener(ItemEvent.CLICK, this._-OP);
            this._-HJ.addEventListener(DragEvent.DRAG_START, this.onDragStart);
            this._-7H.addEventListener(ItemEvent.CLICK, this._-OP);
            this._-7H.addEventListener(DragEvent.DRAG_START, this.onDragStart);
            return;
        }// end function

        override public function dispose() : void
        {
            this._content.removeChildren();
            super.dispose();
            return;
        }// end function

        public function get _-BE() : Boolean
        {
            return this._mode.selectedIndex != 1;
        }// end function

        public function set _-BE(param1:Boolean) : void
        {
            this._mode.selectedIndex = param1 ? (0) : (1);
            return;
        }// end function

        public function _-Mf(param1:int) : GComponent
        {
            return GComponent(this._-HJ.getChildAt(param1).data);
        }// end function

        public function addView(param1:GComponent) : void
        {
            this._-1I(param1, this._-HJ.numChildren);
            return;
        }// end function

        public function _-1I(param1:GComponent, param2:int) : void
        {
            var _loc_3:* = null;
            if (this._-HJ.numChildren == 0)
            {
                this._hResizePiority = param1.data.hResizePiority;
                this._vResizePiority = param1.data.vResizePiority;
            }
            _loc_3 = this._-HJ.getFromPool();
            this._-HJ.addChildAt(_loc_3, param2);
            _loc_3.text = param1.data.title;
            _loc_3.icon = param1.data.icon;
            _loc_3.data = param1;
            _loc_3 = this._-7H.getFromPool();
            this._-7H.addChildAt(_loc_3, param2);
            _loc_3.text = param1.data.title;
            _loc_3.icon = param1.data.icon;
            _loc_3.data = param1;
            this._-91();
            if (this._-HJ.selectedIndex == -1)
            {
                this.selectedIndex = 0;
            }
            return;
        }// end function

        public function removeView(param1:GComponent) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = this._-HJ.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._-HJ.getChildAt(_loc_3);
                if (_loc_4.data == param1)
                {
                    this._-2o(_loc_3);
                    return;
                }
                _loc_3++;
            }
            throw new Error("Not a child");
        }// end function

        public function _-2o(param1:int) : void
        {
            this._-HJ.getChildAt(param1).data = null;
            this._-HJ.removeChildToPoolAt(param1);
            this._-7H.getChildAt(param1).data = null;
            this._-7H.removeChildToPoolAt(param1);
            this._-91();
            if (this._-HJ.selectedIndex == -1 && this._-HJ.numChildren > 0)
            {
                this._-HJ.selectedIndex = 0;
                this._-7H.selectedIndex = 0;
            }
            this.refresh();
            return;
        }// end function

        public function _-Mg(param1:GComponent, param2:int) : void
        {
            var _loc_5:* = null;
            var _loc_3:* = this._-HJ.numChildren;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = this._-HJ.getChildAt(_loc_4);
                if (_loc_5.data == param1)
                {
                    this._-HJ.setChildIndexBefore(_loc_5, param2);
                    _loc_5 = this._-7H.getChildAt(_loc_4);
                    this._-7H.setChildIndexBefore(_loc_5, param2);
                    this.refresh();
                    break;
                }
                _loc_4++;
            }
            return;
        }// end function

        public function get _-47() : int
        {
            return this._-HJ.numChildren;
        }// end function

        public function _-2V(param1:GComponent) : int
        {
            var _loc_4:* = null;
            var _loc_2:* = this._-HJ.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._-HJ.getChildAt(_loc_3);
                if (_loc_4.data == param1)
                {
                    return _loc_3;
                }
                _loc_3++;
            }
            return -1;
        }// end function

        public function _-OI(param1:String) : int
        {
            var _loc_4:* = null;
            var _loc_2:* = this._-HJ.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._-HJ.getChildAt(_loc_3);
                if (GComponent(_loc_4.data).name == param1)
                {
                    return _loc_3;
                }
                _loc_3++;
            }
            return -1;
        }// end function

        public function _-Pr(param1:Array) : Boolean
        {
            var _loc_4:* = null;
            var _loc_2:* = this._-HJ.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._-HJ.getChildAt(_loc_3);
                if (param1.indexOf(GComponent(_loc_4.data).name) != -1)
                {
                    return true;
                }
                _loc_3++;
            }
            return false;
        }// end function

        public function _-PE(param1:ViewGrid) : void
        {
            var _loc_5:* = null;
            var _loc_2:* = param1._-HJ.numChildren;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_5 = GComponent(param1._-HJ.getChildAt(_loc_4).data);
                if (_loc_4 == param1._-HJ.selectedIndex)
                {
                    _loc_3 = _loc_5;
                }
                this.addView(_loc_5);
                _loc_4++;
            }
            param1.clear();
            if (_loc_3)
            {
                this.selectedView = _loc_3;
            }
            return;
        }// end function

        public function clear() : void
        {
            this._-HJ.removeChildrenToPool();
            this._-7H.removeChildrenToPool();
            this._content.removeChildren();
            return;
        }// end function

        public function refresh() : void
        {
            var _loc_1:* = this._-HJ.selectedIndex;
            if (_loc_1 == -1)
            {
                this._content.removeChildren();
                return;
            }
            var _loc_2:* = this._-HJ.getChildAt(_loc_1);
            var _loc_3:* = GComponent(_loc_2.data);
            if (this._content.numChildren == 0 || this._content.getChildAt(0) != _loc_3)
            {
                _loc_3.setXY(0, 0);
                _loc_3.setSize(this._content.width, this._content.height);
                this.initWidth = _loc_3.initWidth + this._-BP;
                this.initHeight = _loc_3.initHeight + this._-D1;
                this._content.removeChildren();
                this._content.addChild(_loc_3);
                if (_loc_2.text != _loc_3.data.title)
                {
                    _loc_2.text = _loc_3.data.title;
                    this._-7H.getChildAt(_loc_1).text = _loc_3.data.title;
                    this._-91();
                }
            }
            return;
        }// end function

        public function get selectedIndex() : int
        {
            return this._-HJ.selectedIndex;
        }// end function

        public function set selectedIndex(param1:int) : void
        {
            this._-HJ.selectedIndex = param1;
            this._-7H.selectedIndex = param1;
            this.refresh();
            return;
        }// end function

        public function get selectedView() : GComponent
        {
            if (this._-HJ.selectedIndex != -1)
            {
                return GComponent(this._-HJ.getChildAt(this._-HJ.selectedIndex).data);
            }
            return null;
        }// end function

        public function set selectedView(param1:GComponent) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = this._-HJ.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._-HJ.getChildAt(_loc_3);
                if (_loc_4.data == param1)
                {
                    this.selectedIndex = _loc_3;
                    return;
                }
                _loc_3++;
            }
            return;
        }// end function

        public function setViewTitle(param1:int, param2:String) : void
        {
            var _loc_3:* = null;
            _loc_3 = this._-HJ.getChildAt(param1);
            _loc_3.text = param2;
            _loc_3 = this._-7H.getChildAt(param1);
            _loc_3.text = param2;
            this._-91();
            return;
        }// end function

        private function _-91() : void
        {
            this._-HJ.ensureBoundsCorrect();
            if (this._-HJ.scrollPane.contentWidth > this.width)
            {
                this._-Nv.selectedIndex = 1;
            }
            else
            {
                this._-Nv.selectedIndex = 0;
            }
            return;
        }// end function

        private function _-9I() : void
        {
            if (this._content.numChildren != 0)
            {
                this._content.getChildAt(0).setSize(this._content.width, this._content.height);
            }
            this._-91();
            return;
        }// end function

        private function _-OP(event:ItemEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (event.currentTarget == this._-HJ)
            {
                this._-7H.selectedIndex = this._-HJ.getChildIndex(event.itemObject);
            }
            else
            {
                this._-HJ.selectedIndex = this._-7H.getChildIndex(event.itemObject);
            }
            this.refresh();
            if (event.rightButton && this._-HJ.selectedIndex != -1)
            {
                _loc_2 = GComponent(this._-HJ.getChildAt(this._-HJ.selectedIndex).data);
                _loc_3 = FairyGUIEditor._-Eb(this);
                _-2t(_loc_3.viewManager).showTabMenu(_loc_2);
            }
            return;
        }// end function

        private function onDragStart(event:DragEvent) : void
        {
            event.preventDefault();
            var _loc_2:* = GList(event.currentTarget);
            var _loc_3:* = _loc_2.getItemNear(event.stageX, event.stageY);
            var _loc_4:* = FairyGUIEditor._-Eb(this);
            _-2t(_loc_4.viewManager).onDragGridStart(this, _loc_3);
            return;
        }// end function

    }
}
