package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.geom.*;

    public class FGraph extends FObject
    {
        private var _type:String;
        private var _cornerRadius:String;
        private var _lineColor:uint;
        private var _lineSize:int;
        private var _fillColor:uint;
        private var _fillAlpha:int;
        private var _polygonPoints:PointList;
        private var _verticesDistance:Vector.<Number>;
        private var _startAngle:Number;
        private var _shapeLocked:Boolean;
        private var _backupPoints:Vector.<Number>;
        public static const EMPTY:String = "empty";
        public static const RECT:String = "rect";
        public static const ELLIPSE:String = "ellipse";
        public static const POLYGON:String = "polygon";
        public static const REGULAR_POLYGON:String = "regular_polygon";
        public static const TYPE_CHANGED:int = 100;
        private static var helperCmds:Vector.<int> = new Vector.<int>;
        private static var helperPointList:PointList = new PointList();

        public function FGraph()
        {
            this._objectType = FObjectType.GRAPH;
            this._type = "rect";
            this._lineSize = 1;
            this._lineColor = 4278190080;
            this._fillColor = 4294967295;
            this._fillAlpha = 255;
            this._cornerRadius = "";
            this._startAngle = 0;
            _useSourceSize = false;
            this._polygonPoints = new PointList();
            this._verticesDistance = new Vector.<Number>;
            return;
        }// end function

        public function get type() : String
        {
            return this._type;
        }// end function

        public function set type(param1:String) : void
        {
            if (this._type != param1)
            {
                if (this._type == POLYGON)
                {
                    this._backupPoints = this._polygonPoints.rawList.concat();
                }
                this._type = param1;
                if (this._type == POLYGON)
                {
                    if (this._backupPoints)
                    {
                        this._polygonPoints.rawList = this._backupPoints;
                    }
                    this.validatePolygonPoints();
                }
                else if (this._type == REGULAR_POLYGON)
                {
                    this.validateRegularPolygonPoints();
                }
                if ((_flags & FObjectFlags.INSPECTING) != 0)
                {
                    _dispatcher.emit(this, TYPE_CHANGED);
                }
                var _loc_3:* = _outlineVersion + 1;
                _outlineVersion = _loc_3;
                if (!_underConstruct)
                {
                    this.updateGraph();
                }
            }
            return;
        }// end function

        public function get isVerticesEditable() : Boolean
        {
            return this._type == POLYGON || this._type == REGULAR_POLYGON;
        }// end function

        public function get shapeLocked() : Boolean
        {
            return this._shapeLocked;
        }// end function

        public function set shapeLocked(param1:Boolean) : void
        {
            this._shapeLocked = param1;
            return;
        }// end function

        public function get cornerRadius() : String
        {
            return this._cornerRadius;
        }// end function

        public function set cornerRadius(param1:String) : void
        {
            this._cornerRadius = param1;
            if (!_underConstruct)
            {
                this.updateGraph();
            }
            return;
        }// end function

        public function get lineColor() : uint
        {
            return this._lineColor;
        }// end function

        public function set lineColor(param1:uint) : void
        {
            this._lineColor = param1;
            if (!_underConstruct)
            {
                this.updateGraph();
            }
            return;
        }// end function

        public function get lineSize() : int
        {
            return this._lineSize;
        }// end function

        public function set lineSize(param1:int) : void
        {
            this._lineSize = param1;
            if (!_underConstruct)
            {
                this.updateGraph();
            }
            return;
        }// end function

        public function get color() : uint
        {
            return this._fillColor & 16777215;
        }// end function

        public function set color(param1:uint) : void
        {
            this.fillColor = (param1 & 16777215) + (this._fillAlpha << 24);
            return;
        }// end function

        public function get fillColor() : uint
        {
            return this._fillColor;
        }// end function

        public function set fillColor(param1:uint) : void
        {
            if (this._fillColor != param1)
            {
                this._fillColor = param1;
                this._fillAlpha = (this._fillColor & 4278190080) >> 24;
                updateGear(4);
                if (!_underConstruct)
                {
                    this.updateGraph();
                }
            }
            return;
        }// end function

        public function get polygonPoints() : PointList
        {
            return this._polygonPoints;
        }// end function

        public function get verticesDistance() : Vector.<Number>
        {
            return this._verticesDistance;
        }// end function

        public function get sides() : int
        {
            return this._verticesDistance.length;
        }// end function

        public function set sides(param1:int) : void
        {
            var _loc_3:* = 0;
            if (param1 < 3)
            {
                param1 = 3;
            }
            var _loc_2:* = this._verticesDistance.length;
            if (_loc_2 != param1)
            {
                this._verticesDistance.length = param1;
                _loc_3 = _loc_2;
                while (_loc_3 < param1)
                {
                    
                    this._verticesDistance[_loc_3] = 1;
                    _loc_3++;
                }
                this.validateRegularPolygonPoints();
                var _loc_5:* = _outlineVersion + 1;
                _outlineVersion = _loc_5;
                this.updateGraph();
            }
            return;
        }// end function

        public function get startAngle() : Number
        {
            return this._startAngle;
        }// end function

        public function set startAngle(param1:Number) : void
        {
            if (this._startAngle != param1)
            {
                this._startAngle = param1;
                this.validateRegularPolygonPoints();
                var _loc_3:* = _outlineVersion + 1;
                _outlineVersion = _loc_3;
                this.updateGraph();
            }
            return;
        }// end function

        public function set polygonData(param1:Vector.<Number>) : void
        {
            if (this._type == POLYGON)
            {
                this._polygonPoints.rawList = param1;
                this.validatePolygonPoints();
            }
            else
            {
                this._verticesDistance = param1;
                this.validateRegularPolygonPoints();
            }
            var _loc_3:* = _outlineVersion + 1;
            _outlineVersion = _loc_3;
            this.updateGraph();
            return;
        }// end function

        public function get polygonData() : Vector.<Number>
        {
            if (this._type == POLYGON)
            {
                return this._polygonPoints.rawList;
            }
            return this._verticesDistance;
        }// end function

        public function addVertex(param1:Number, param2:Number, param3:Boolean) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = NaN;
            var _loc_6:* = 0;
            var _loc_7:* = NaN;
            var _loc_8:* = 0;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            if (param3)
            {
                _loc_4 = this._polygonPoints.length;
                _loc_5 = int.MAX_VALUE;
                _loc_6 = -1;
                _loc_8 = 0;
                while (_loc_8 < _loc_4)
                {
                    
                    _loc_9 = this._polygonPoints.get_x(_loc_8);
                    _loc_10 = this._polygonPoints.get_y(_loc_8);
                    if (_loc_8 == 0)
                    {
                        _loc_7 = ToolSet.pointLineDistance(param1, param2, this._polygonPoints.get_x((_loc_4 - 1)), this._polygonPoints.get_y((_loc_4 - 1)), this._polygonPoints.get_x(_loc_8), this._polygonPoints.get_y(_loc_8), true);
                    }
                    else
                    {
                        _loc_7 = ToolSet.pointLineDistance(param1, param2, this._polygonPoints.get_x((_loc_8 - 1)), this._polygonPoints.get_y((_loc_8 - 1)), this._polygonPoints.get_x(_loc_8), this._polygonPoints.get_y(_loc_8), true);
                    }
                    if (_loc_7 < _loc_5)
                    {
                        _loc_6 = _loc_8;
                        _loc_5 = _loc_7;
                    }
                    _loc_8++;
                }
                this._polygonPoints.insert(_loc_6, param1, param2);
                if (this._type == REGULAR_POLYGON)
                {
                    this._verticesDistance.splice(_loc_6, 0, 1);
                    this.validateRegularPolygonPoints();
                }
            }
            else
            {
                this._polygonPoints.push(param1, param2);
                if (this._type == REGULAR_POLYGON)
                {
                    this._verticesDistance.push(1);
                    this.validateRegularPolygonPoints();
                }
            }
            var _loc_12:* = _outlineVersion + 1;
            _outlineVersion = _loc_12;
            this.updateGraph();
            return;
        }// end function

        public function removeVertex(param1:int) : void
        {
            this._polygonPoints.remove(param1);
            if (this._type == REGULAR_POLYGON)
            {
                this._verticesDistance.splice(param1, 1);
                this.validateRegularPolygonPoints();
            }
            var _loc_3:* = _outlineVersion + 1;
            _outlineVersion = _loc_3;
            this.updateGraph();
            return;
        }// end function

        public function updateVertex(param1:int, param2:Number, param3:Number) : void
        {
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            if (this._type == REGULAR_POLYGON)
            {
                _loc_4 = Math.min(_width, _height) / 2;
                _loc_5 = Math.sqrt(Math.pow(param2 - _loc_4, 2) + Math.pow(param3 - _loc_4, 2)) / _loc_4;
                if (_loc_5 > 1)
                {
                    _loc_5 = 1;
                }
                this._verticesDistance[param1] = _loc_5;
                _loc_6 = Utils.DEG_TO_RAD * this._startAngle + param1 * 2 * Math.PI / this._polygonPoints.length;
                param2 = _loc_4 + _loc_4 * _loc_5 * Math.cos(_loc_6);
                param3 = _loc_4 + _loc_4 * _loc_5 * Math.sin(_loc_6);
                this._polygonPoints.set(param1, param2, param3);
            }
            else if (this._shapeLocked)
            {
                _loc_7 = param2 - this._polygonPoints.get_x(param1);
                _loc_8 = param3 - this._polygonPoints.get_y(param1);
                _loc_9 = this._polygonPoints.length;
                _loc_10 = 0;
                while (_loc_10 < _loc_9)
                {
                    
                    param2 = this._polygonPoints.get_x(_loc_10) + _loc_7;
                    param3 = this._polygonPoints.get_y(_loc_10) + _loc_8;
                    this._polygonPoints.set(_loc_10, param2, param3);
                    _loc_10++;
                }
            }
            else
            {
                this._polygonPoints.set(param1, param2, param3);
            }
            var _loc_12:* = _outlineVersion + 1;
            _outlineVersion = _loc_12;
            this.updateGraph();
            return;
        }// end function

        public function updateVertexDistance(param1:int, param2:Number) : void
        {
            this._verticesDistance[param1] = param2;
            this.validateRegularPolygonPoints();
            var _loc_4:* = _outlineVersion + 1;
            _outlineVersion = _loc_4;
            this.updateGraph();
            return;
        }// end function

        private function validatePolygonPoints() : void
        {
            if (this._polygonPoints.length < 3)
            {
                this._polygonPoints.length = 0;
                this._polygonPoints.push(0, 0);
                this._polygonPoints.push(_width, 0);
                this._polygonPoints.push(_width, _height);
                this._polygonPoints.push(0, _height);
            }
            return;
        }// end function

        private function validateRegularPolygonPoints() : void
        {
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_1:* = Math.min(_width, _height) / 2;
            if (this._verticesDistance.length < 3)
            {
                this._verticesDistance.length = 0;
                this._verticesDistance.push(1);
                this._verticesDistance.push(1);
                this._verticesDistance.push(1);
            }
            var _loc_2:* = this._verticesDistance.length;
            this._polygonPoints.length = _loc_2;
            var _loc_3:* = Utils.DEG_TO_RAD * this._startAngle;
            var _loc_4:* = 2 * Math.PI / _loc_2;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_2)
            {
                
                _loc_6 = this._verticesDistance[_loc_5];
                _loc_7 = _loc_1 + _loc_1 * _loc_6 * Math.cos(_loc_3);
                _loc_8 = _loc_1 + _loc_1 * _loc_6 * Math.sin(_loc_3);
                this._polygonPoints.set(_loc_5, _loc_7, _loc_8);
                _loc_3 = _loc_3 + _loc_4;
                _loc_5++;
            }
            return;
        }// end function

        public function calculatePolygonBounds(param1:Rectangle = null) : Rectangle
        {
            var _loc_6:* = 0;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_2:* = int.MAX_VALUE;
            var _loc_3:* = int.MAX_VALUE;
            var _loc_4:* = int.MIN_VALUE;
            var _loc_5:* = int.MIN_VALUE;
            var _loc_7:* = this._polygonPoints.length;
            _loc_6 = 0;
            while (_loc_6 < _loc_7)
            {
                
                _loc_8 = this._polygonPoints.get_x(_loc_6);
                _loc_9 = this._polygonPoints.get_y(_loc_6);
                if (_loc_8 < _loc_2)
                {
                    _loc_2 = _loc_8;
                }
                if (_loc_9 < _loc_3)
                {
                    _loc_3 = _loc_9;
                }
                if (_loc_8 > _loc_4)
                {
                    _loc_4 = _loc_8;
                }
                if (_loc_9 > _loc_5)
                {
                    _loc_5 = _loc_9;
                }
                _loc_6++;
            }
            if (!param1)
            {
                param1 = new Rectangle();
            }
            param1.setTo(_loc_2, _loc_3, _loc_4 - _loc_2, _loc_5 - _loc_3);
            return param1;
        }// end function

        override protected function handleCreate() : void
        {
            if (_width > 0 && _height > 0)
            {
                this.updateGraph();
            }
            return;
        }// end function

        override public function handleSizeChanged() : void
        {
            super.handleSizeChanged();
            if (this._type == REGULAR_POLYGON)
            {
                this.validateRegularPolygonPoints();
            }
            if (!_underConstruct)
            {
                this.updateGraph();
            }
            return;
        }// end function

        override public function getProp(param1:int)
        {
            if (param1 == ObjectPropID.Color)
            {
                return this.color;
            }
            return super.getProp(param1);
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            if (param1 == ObjectPropID.Color)
            {
                this.color = param2;
            }
            else
            {
                super.setProp(param1, param2);
            }
            return;
        }// end function

        override public function read_beforeAdd(param1:XData, param2:Object) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            super.read_beforeAdd(param1, param2);
            this._type = param1.getAttribute("type", "empty");
            if (this._type == "eclipse")
            {
                this._type = ELLIPSE;
            }
            this._lineSize = param1.getAttributeInt("lineSize", 1);
            this._lineColor = param1.getAttributeColor("lineColor", true, 4278190080);
            this._fillColor = param1.getAttributeColor("fillColor", true, 4294967295);
            this._fillAlpha = (this._fillColor & 4278190080) >> 24;
            this._cornerRadius = param1.getAttribute("corner", "");
            if (this._type == POLYGON)
            {
                _loc_3 = param1.getAttribute("points");
                if (_loc_3)
                {
                    _loc_4 = _loc_3.split(",");
                    _loc_5 = _loc_4.length;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_5)
                    {
                        
                        this._polygonPoints.push(_loc_4[_loc_6], _loc_4[(_loc_6 + 1)]);
                        _loc_6 = _loc_6 + 2;
                    }
                }
                else
                {
                    this._polygonPoints.length = 0;
                }
                this.validatePolygonPoints();
            }
            else if (this._type == REGULAR_POLYGON)
            {
                _loc_7 = param1.getAttributeInt("sides");
                this._verticesDistance.length = _loc_7;
                this._startAngle = param1.getAttributeFloat("startAngle");
                _loc_3 = param1.getAttribute("distances");
                if (_loc_3)
                {
                    _loc_4 = _loc_3.split(",");
                    _loc_6 = 0;
                    while (_loc_6 < _loc_7)
                    {
                        
                        if (!_loc_4[_loc_6])
                        {
                            this._verticesDistance[_loc_6] = 1;
                        }
                        else
                        {
                            this._verticesDistance[_loc_6] = parseFloat(_loc_4[_loc_6]);
                        }
                        _loc_6++;
                    }
                }
                else
                {
                    _loc_6 = 0;
                    while (_loc_6 < _loc_7)
                    {
                        
                        this._verticesDistance[_loc_6] = 1;
                        _loc_6++;
                    }
                }
                this.validateRegularPolygonPoints();
            }
            return;
        }// end function

        override public function read_afterAdd(param1:XData, param2:Object) : void
        {
            super.read_afterAdd(param1, param2);
            if (param1.getAttributeBool("forHitTest"))
            {
                _parent.hitTestSource = this;
            }
            if (param1.getAttributeBool("forMask"))
            {
                _parent.mask = this;
            }
            this.updateGraph();
            return;
        }// end function

        override public function write() : XData
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_1:* = super.write();
            if (this._type != "empty")
            {
                _loc_1.setAttribute("type", this._type == "ellipse" ? ("eclipse") : (this._type));
            }
            if (this._lineSize != 1)
            {
                _loc_1.setAttribute("lineSize", this._lineSize);
            }
            if (this._lineColor != 4278190080)
            {
                _loc_1.setAttribute("lineColor", UtilsStr.convertToHtmlColor(this._lineColor, true));
            }
            if (this._fillColor != 4294967295)
            {
                _loc_1.setAttribute("fillColor", UtilsStr.convertToHtmlColor(this._fillColor, true));
            }
            if (this._cornerRadius && this._cornerRadius != "0")
            {
                _loc_1.setAttribute("corner", this._cornerRadius);
            }
            if (this.type == POLYGON)
            {
                _loc_1.setAttribute("points", this._polygonPoints.join(","));
            }
            else if (this.type == REGULAR_POLYGON)
            {
                _loc_1.setAttribute("sides", this._polygonPoints.length);
                if (this._startAngle != 0)
                {
                    _loc_1.setAttribute("startAngle", this._startAngle);
                }
                _loc_2 = this._verticesDistance.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    if (this._verticesDistance[_loc_3] < 0.99)
                    {
                        break;
                    }
                    _loc_3++;
                }
                if (_loc_3 != _loc_2)
                {
                    _loc_4 = new Vector.<String>(_loc_2, true);
                    _loc_3 = 0;
                    while (_loc_3 < _loc_2)
                    {
                        
                        if (this._verticesDistance[_loc_3] > 0.99)
                        {
                            _loc_4[_loc_3] = "";
                        }
                        else
                        {
                            _loc_4[_loc_3] = UtilsStr.toFixed(this._verticesDistance[_loc_3], 2);
                        }
                        _loc_3++;
                    }
                    _loc_1.setAttribute("distances", _loc_4.join(","));
                }
            }
            return _loc_1;
        }// end function

        public function updateGraph() : void
        {
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_1:* = _displayObject.container.graphics;
            _loc_1.clear();
            if (this._type == "empty")
            {
                return;
            }
            var _loc_2:* = Math.ceil(_width);
            var _loc_3:* = Math.ceil(_height);
            if (_loc_2 == 0 || _loc_3 == 0)
            {
                return;
            }
            var _loc_4:* = 0;
            if (this._lineSize > 0)
            {
                if (_loc_2 > 0)
                {
                    _loc_2 = _loc_2 - this._lineSize;
                }
                if (_loc_3 > 0)
                {
                    _loc_3 = _loc_3 - this._lineSize;
                }
                _loc_4 = this._lineSize * 0.5;
            }
            if (this._lineSize == 0)
            {
                _loc_1.lineStyle(0, 0, 0, true, LineScaleMode.NORMAL);
            }
            else
            {
                _loc_1.lineStyle(this._lineSize, this._lineColor & 16777215, (this._lineColor >> 24 & 255) / 255, true, LineScaleMode.NORMAL);
            }
            _loc_1.beginFill(this._fillColor & 16777215, (this._fillColor >> 24 & 255) / 255);
            if (this.type == "rect")
            {
                if (this._cornerRadius)
                {
                    _loc_5 = this._cornerRadius.split(",");
                    if (_loc_5.length == 1)
                    {
                        _loc_1.drawRoundRectComplex(_loc_4, _loc_4, _loc_2, _loc_3, int(_loc_5[0]), int(_loc_5[0]), int(_loc_5[0]), int(_loc_5[0]));
                    }
                    else
                    {
                        _loc_1.drawRoundRectComplex(_loc_4, _loc_4, _loc_2, _loc_3, int(_loc_5[0]), int(_loc_5[1]), int(_loc_5[2]), int(_loc_5[3]));
                    }
                }
                else
                {
                    _loc_1.drawRect(_loc_4, _loc_4, _loc_2, _loc_3);
                }
            }
            else if (this.type == "ellipse")
            {
                _loc_1.drawEllipse(_loc_4, _loc_4, _loc_2, _loc_3);
            }
            else if (this.type == "polygon" || this.type == "regular_polygon")
            {
                _loc_6 = this._polygonPoints.length;
                helperCmds.length = 0;
                helperCmds.push(GraphicsPathCommand.MOVE_TO);
                _loc_7 = 1;
                while (_loc_7 <= _loc_6)
                {
                    
                    helperCmds.push(GraphicsPathCommand.LINE_TO);
                    _loc_7++;
                }
                helperPointList.length = 0;
                helperPointList.addRange(this._polygonPoints);
                helperPointList.push3(this._polygonPoints, 0);
                _loc_1.drawPath(helperCmds, helperPointList.rawList);
            }
            _loc_1.endFill();
            if (!_underConstruct && _parent && !FObjectFlags.isDocRoot(_parent._flags))
            {
                if (_parent.hitTestSource == this)
                {
                    _parent.displayObject.setHitArea(this);
                }
                if (_parent.mask == this)
                {
                    _parent.displayObject.setMask(this);
                }
            }
            return;
        }// end function

    }
}
