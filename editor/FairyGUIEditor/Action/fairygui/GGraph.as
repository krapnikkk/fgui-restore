package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.display.*;
    import fairygui.utils.*;
    import flash.display.*;

    public class GGraph extends GObject
    {
        private var _graphics:Graphics;
        private var _type:int;
        private var _lineSize:int;
        private var _lineColor:int;
        private var _lineAlpha:Number;
        private var _fillColor:int;
        private var _fillAlpha:Number;
        private var _fillBitmapData:BitmapData;
        private var _corner:Array;
        private var _sides:int;
        private var _startAngle:Number;
        private var _polygonPoints:PointList;
        private var _distances:Array;
        private static var helperCmds:Vector.<int> = new Vector.<int>;
        private static var helperPointList:PointList = new PointList();

        public function GGraph()
        {
            _lineSize = 1;
            _lineAlpha = 1;
            _fillAlpha = 1;
            _fillColor = 16777215;
            _startAngle = 0;
            return;
        }// end function

        public function get graphics() : Graphics
        {
            if (_graphics)
            {
                return _graphics;
            }
            delayCreateDisplayObject();
            _graphics = this.Sprite(displayObject).graphics;
            return _graphics;
        }// end function

        public function get color() : uint
        {
            return _fillColor;
        }// end function

        public function set color(param1:uint) : void
        {
            if (_fillColor != param1)
            {
                _fillColor = param1;
                updateGear(4);
                if (_type != 0)
                {
                    updateGraph();
                }
            }
            return;
        }// end function

        public function drawRect(param1:int, param2:int, param3:Number, param4:int, param5:Number, param6:Array = null) : void
        {
            _type = 1;
            _lineSize = param1;
            _lineColor = param2;
            _lineAlpha = param3;
            _fillColor = param4;
            _fillAlpha = param5;
            _fillBitmapData = null;
            _corner = param6;
            updateGraph();
            return;
        }// end function

        public function drawRectWithBitmap(param1:int, param2:int, param3:Number, param4:BitmapData) : void
        {
            _type = 1;
            _lineSize = param1;
            _lineColor = param2;
            _lineAlpha = param3;
            _fillBitmapData = param4;
            updateGraph();
            return;
        }// end function

        public function drawEllipse(param1:int, param2:int, param3:Number, param4:int, param5:Number) : void
        {
            _type = 2;
            _lineSize = param1;
            _lineColor = param2;
            _lineAlpha = param3;
            _fillColor = param4;
            _fillAlpha = param5;
            _corner = null;
            updateGraph();
            return;
        }// end function

        public function drawRegularPolygon(param1:int, param2:int, param3:Number, param4:int, param5:Number, param6:int, param7:Number = 0, param8:Array = null) : void
        {
            _type = 3;
            _lineSize = param1;
            _lineColor = param2;
            _lineAlpha = param3;
            _fillColor = param4;
            _fillAlpha = param5;
            _corner = null;
            _sides = param6;
            _startAngle = param7;
            _distances = param8;
            updateGraph();
            return;
        }// end function

        public function get distances() : Array
        {
            return _distances;
        }// end function

        public function set distances(param1:Array) : void
        {
            _distances = param1;
            if (_type == 3)
            {
                updateGraph();
            }
            return;
        }// end function

        public function drawPolygon(param1:int, param2:int, param3:Number, param4:int, param5:Number, param6:PointList) : void
        {
            _type = 4;
            _lineSize = param1;
            _lineColor = param2;
            _lineAlpha = param3;
            _fillColor = param4;
            _fillAlpha = param5;
            _corner = null;
            _polygonPoints = param6;
            updateGraph();
            return;
        }// end function

        public function clearGraphics() : void
        {
            if (_graphics)
            {
                _type = 0;
                _graphics.clear();
            }
            return;
        }// end function

        private function updateGraph() : void
        {
            var _loc_8:* = NaN;
            var _loc_5:* = NaN;
            var _loc_2:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = 0;
            var _loc_10:* = NaN;
            var _loc_9:* = NaN;
            _graphics.clear();
            var _loc_3:* = Math.ceil(this.width);
            var _loc_4:* = Math.ceil(this.height);
            if (_loc_3 == 0 || _loc_4 == 0)
            {
                return;
            }
            if (_lineSize == 0)
            {
                _graphics.lineStyle(0, 0, 0, true, "normal");
            }
            else
            {
                _graphics.lineStyle(_lineSize, _lineColor, _lineAlpha, true, "normal");
            }
            var _loc_1:* = 0;
            if (_lineSize > 0)
            {
                if (_loc_3 > 0)
                {
                    _loc_3 = _loc_3 - _lineSize;
                }
                if (_loc_4 > 0)
                {
                    _loc_4 = _loc_4 - _lineSize;
                }
                _loc_1 = _lineSize * 0.5;
            }
            if (_fillBitmapData != null)
            {
                _graphics.beginBitmapFill(_fillBitmapData);
            }
            else
            {
                _graphics.beginFill(_fillColor, _fillAlpha);
            }
            if (_type == 1)
            {
                if (_corner)
                {
                    if (_corner.length == 1)
                    {
                        _graphics.drawRoundRectComplex(_loc_1, _loc_1, _loc_3, _loc_4, _corner[0], _corner[0], _corner[0], _corner[0]);
                    }
                    else
                    {
                        _graphics.drawRoundRectComplex(_loc_1, _loc_1, _loc_3, _loc_4, _corner[0], _corner[1], _corner[2], _corner[3]);
                    }
                }
                else
                {
                    _graphics.drawRect(_loc_1, _loc_1, _loc_3, _loc_4);
                }
            }
            else if (_type == 2)
            {
                _graphics.drawEllipse(_loc_1, _loc_1, _loc_3, _loc_4);
            }
            else if (_type == 3 || _type == 4)
            {
                if (_type == 3)
                {
                    if (!_polygonPoints)
                    {
                        _polygonPoints = new PointList();
                    }
                    _loc_8 = Math.min(_width, _height) / 2;
                    _polygonPoints.length = _sides;
                    _loc_5 = 0.0174533 * _startAngle;
                    _loc_2 = 2 * 3.14159 / _sides;
                    _loc_7 = 0;
                    while (_loc_7 < _sides)
                    {
                        
                        if (_distances)
                        {
                            _loc_6 = _distances[_loc_7];
                            if (this.isNaN(_loc_6))
                            {
                                _loc_6 = 1;
                            }
                        }
                        else
                        {
                            _loc_6 = 1;
                        }
                        _loc_10 = _loc_8 + _loc_8 * _loc_6 * Math.cos(_loc_5);
                        _loc_9 = _loc_8 + _loc_8 * _loc_6 * Math.sin(_loc_5);
                        _polygonPoints.set(_loc_7, _loc_10, _loc_9);
                        _loc_5 = _loc_5 + _loc_2;
                        _loc_7++;
                    }
                }
                helperCmds.length = 0;
                helperCmds.push(1);
                _loc_7 = 1;
                while (_loc_7 <= _polygonPoints.length)
                {
                    
                    helperCmds.push(2);
                    _loc_7++;
                }
                helperPointList.length = 0;
                helperPointList.addRange(_polygonPoints);
                helperPointList.push3(_polygonPoints, 0);
                _graphics.drawPath(helperCmds, helperPointList.rawList);
            }
            _graphics.endFill();
            return;
        }// end function

        public function replaceMe(param1:GObject) : void
        {
            if (!_parent)
            {
                throw new Error("parent not set");
            }
            param1.name = this.name;
            param1.alpha = this.alpha;
            param1.rotation = this.rotation;
            param1.visible = this.visible;
            param1.touchable = this.touchable;
            param1.grayed = this.grayed;
            param1.setXY(this.x, this.y);
            param1.setSize(this.width, this.height);
            var _loc_2:* = _parent.getChildIndex(this);
            _parent.addChildAt(param1, _loc_2);
            param1.relations.copyFrom(this.relations);
            _parent.removeChild(this, true);
            return;
        }// end function

        public function addBeforeMe(param1:GObject) : void
        {
            if (_parent == null)
            {
                throw new Error("parent not set");
            }
            var _loc_2:* = _parent.getChildIndex(this);
            _parent.addChildAt(param1, _loc_2);
            return;
        }// end function

        public function addAfterMe(param1:GObject) : void
        {
            if (_parent == null)
            {
                throw new Error("parent not set");
            }
            var _loc_2:* = _parent.getChildIndex(this);
            _loc_2++;
            _parent.addChildAt(param1, _loc_2);
            return;
        }// end function

        public function setNativeObject(param1:DisplayObject) : void
        {
            delayCreateDisplayObject();
            this.Sprite(displayObject).addChild(param1);
            return;
        }// end function

        private function delayCreateDisplayObject() : void
        {
            if (!displayObject)
            {
                setDisplayObject(new UISprite(this));
                if (_parent)
                {
                    _parent.childStateChanged(this);
                }
                handlePositionChanged();
                displayObject.alpha = this.alpha;
                displayObject.rotation = this.normalizeRotation;
                displayObject.visible = this.visible;
                this.Sprite(displayObject).mouseEnabled = this.touchable;
                this.Sprite(displayObject).mouseChildren = this.touchable;
            }
            else
            {
                this.Sprite(displayObject).graphics.clear();
                this.Sprite(displayObject).removeChildren();
                _graphics = null;
            }
            return;
        }// end function

        override protected function handleSizeChanged() : void
        {
            if (_graphics)
            {
                if (_type != 0)
                {
                    updateGraph();
                }
            }
            return;
        }// end function

        override public function getProp(param1:int)
        {
            if (param1 == 2)
            {
                return this.color;
            }
            return super.getProp(param1);
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            if (param1 == 2)
            {
                this.color = param2;
            }
            else
            {
                super.setProp(param1, param2);
            }
            return;
        }// end function

        override public function setup_beforeAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_4:* = 0;
            var _loc_3:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = param1.@type;
            if (param1.@type && _loc_7 != "empty")
            {
                setDisplayObject(new UISprite(this));
            }
            super.setup_beforeAdd(param1);
            if (displayObject != null)
            {
                _graphics = this.Sprite(this.displayObject).graphics;
                _loc_2 = param1.@lineSize;
                if (_loc_2)
                {
                    _lineSize = this.parseInt(_loc_2);
                }
                _loc_2 = param1.@lineColor;
                if (_loc_2)
                {
                    _loc_4 = ToolSet.convertFromHtmlColor(_loc_2, true);
                    _lineColor = _loc_4 & 16777215;
                    _lineAlpha = (_loc_4 >> 24 & 255) / 255;
                }
                _loc_2 = param1.@fillColor;
                if (_loc_2)
                {
                    _loc_4 = ToolSet.convertFromHtmlColor(_loc_2, true);
                    _fillColor = _loc_4 & 16777215;
                    _fillAlpha = (_loc_4 >> 24 & 255) / 255;
                }
                _loc_2 = param1.@corner;
                if (_loc_2)
                {
                    _corner = _loc_2.split(",");
                }
                if (_loc_7 == "rect")
                {
                    _type = 1;
                }
                else if (_loc_7 == "ellipse" || _loc_7 == "eclipse")
                {
                    _type = 2;
                }
                else if (_loc_7 == "regular_polygon")
                {
                    _type = 3;
                    _loc_2 = param1.@sides;
                    _sides = this.parseInt(_loc_2);
                    _loc_2 = param1.@startAngle;
                    if (_loc_2)
                    {
                        _startAngle = this.parseFloat(_loc_2);
                    }
                    _loc_2 = param1.@distances;
                    if (_loc_2)
                    {
                        _loc_3 = _loc_2.split(",");
                        _loc_5 = _loc_3.length;
                        _distances = [];
                        _loc_6 = 0;
                        while (_loc_6 < _loc_5)
                        {
                            
                            if (_loc_3[_loc_6])
                            {
                                _distances[_loc_6] = 1;
                            }
                            else
                            {
                                _distances[_loc_6] = this.parseFloat(_loc_3[_loc_6]);
                            }
                            _loc_6++;
                        }
                    }
                }
                else if (_loc_7 == "polygon")
                {
                    _type = 4;
                    _polygonPoints = new PointList();
                    _loc_2 = param1.@points;
                    if (_loc_2)
                    {
                        _loc_3 = _loc_2.split(",");
                        _loc_5 = _loc_3.length;
                        _loc_6 = 0;
                        while (_loc_6 < _loc_5)
                        {
                            
                            _polygonPoints.push(_loc_3[_loc_6], _loc_3[(_loc_6 + 1)]);
                            _loc_6 = _loc_6 + 2;
                        }
                    }
                }
                updateGraph();
            }
            return;
        }// end function

    }
}
