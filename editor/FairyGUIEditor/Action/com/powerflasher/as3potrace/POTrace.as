package com.powerflasher.as3potrace
{
    import *.*;
    import __AS3__.vec.*;
    import com.powerflasher.as3potrace.backend.*;
    import com.powerflasher.as3potrace.geom.*;
    import flash.display.*;
    import flash.geom.*;

    public class POTrace extends Object
    {
        protected var bmWidth:uint;
        protected var bmHeight:uint;
        protected var _params:POTraceParams;
        protected var _backend:IBackend;
        static const POTRACE_CORNER:int = 1;
        static const POTRACE_CURVETO:int = 2;
        static const COS179:Number = Math.cos(179 * Math.PI / 180);

        public function POTrace(param1:POTraceParams = null, param2:IBackend = null)
        {
            this._params = param1 || new POTraceParams();
            this._backend = param2 || new NullBackend();
            return;
        }// end function

        public function get params() : POTraceParams
        {
            return this._params;
        }// end function

        public function set params(param1:POTraceParams) : void
        {
            this._params = param1;
            return;
        }// end function

        public function get backend() : IBackend
        {
            return this._backend;
        }// end function

        public function set backend(param1:IBackend) : void
        {
            this._backend = param1;
            return;
        }// end function

        public function potrace_trace(param1:BitmapData) : Array
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_2:* = new BitmapData(param1.width + 2, param1.height + 2, false, 16777215);
            _loc_2.threshold(param1, param1.rect, new Point(1, 1), this.params.thresholdOperator, this.params.threshold, 0, 16777215, false);
            this.bmWidth = _loc_2.width;
            this.bmHeight = _loc_2.height;
            var _loc_6:* = 0;
            var _loc_7:* = _loc_2.getVector(_loc_2.rect);
            var _loc_8:* = new Vector.<Vector.<uint>>(this.bmHeight);
            _loc_3 = 0;
            while (_loc_3 < this.bmHeight)
            {
                
                _loc_11 = _loc_7.slice(_loc_6, _loc_6 + this.bmWidth);
                _loc_4 = 0;
                while (_loc_4 < _loc_11.length)
                {
                    
                    _loc_11[_loc_4] = _loc_11[_loc_4] & 16777215;
                    _loc_4++;
                }
                _loc_8[_loc_3] = _loc_11;
                _loc_6 = _loc_6 + this.bmWidth;
                _loc_3++;
            }
            var _loc_9:* = this.bm_to_pathlist(_loc_8);
            this.process_path(_loc_9);
            var _loc_10:* = this.pathlist_to_curvearrayslist(_loc_9);
            if (this.backend != null)
            {
                this.backend.init(this.bmWidth, this.bmHeight);
                _loc_3 = 0;
                while (_loc_3 < _loc_10.length)
                {
                    
                    this.backend.initShape();
                    _loc_12 = _loc_10[_loc_3] as Array;
                    _loc_4 = 0;
                    while (_loc_4 < _loc_12.length)
                    {
                        
                        this.backend.initSubShape(_loc_4 % 2 == 0);
                        _loc_13 = _loc_12[_loc_4] as Array;
                        if (_loc_13.length > 0)
                        {
                            _loc_14 = _loc_13[0] as Curve;
                            this.backend.moveTo(_loc_14.a.clone());
                            _loc_5 = 0;
                            while (_loc_5 < _loc_13.length)
                            {
                                
                                _loc_14 = _loc_13[_loc_5] as Curve;
                                switch(_loc_14.kind)
                                {
                                    case CurveKind.BEZIER:
                                    {
                                        this.backend.addBezier(_loc_14.a.clone(), _loc_14.cpa.clone(), _loc_14.cpb.clone(), _loc_14.b.clone());
                                        break;
                                    }
                                    case CurveKind.LINE:
                                    {
                                        this.backend.addLine(_loc_14.a.clone(), _loc_14.b.clone());
                                        break;
                                    }
                                    default:
                                    {
                                        break;
                                    }
                                }
                                _loc_5++;
                            }
                        }
                        this.backend.exitSubShape();
                        _loc_4++;
                    }
                    this.backend.exitShape();
                    _loc_3++;
                }
                this.backend.exit();
            }
            return _loc_10;
        }// end function

        private function bm_to_pathlist(param1:Vector.<Vector.<uint>>) : Array
        {
            var _loc_3:* = null;
            var _loc_2:* = [];
            do
            {
                
                this.get_contour(param1, _loc_3, _loc_2);
                var _loc_4:* = this.find_next(param1);
                _loc_3 = this.find_next(param1);
            }while (_loc_4 != null)
            return _loc_2;
        }// end function

        private function find_next(param1:Vector.<Vector.<uint>>) : PointInt
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            _loc_3 = 1;
            while (_loc_3 < (this.bmHeight - 1))
            {
                
                _loc_2 = 0;
                while (_loc_2 < (this.bmWidth - 1))
                {
                    
                    if (param1[_loc_3][(_loc_2 + 1)] == 0)
                    {
                        return new PointInt(_loc_2, _loc_3);
                    }
                    _loc_2++;
                }
                _loc_3++;
            }
            return null;
        }// end function

        private function get_contour(param1:Vector.<Vector.<uint>>, param2:PointInt, param3:Array) : void
        {
            var _loc_6:* = null;
            var _loc_4:* = [];
            var _loc_5:* = this.find_path(param1, param2);
            this.xor_path(param1, _loc_5);
            if (_loc_5.area > this.params.turdSize)
            {
                _loc_4.push(_loc_5);
                param3.push(_loc_4);
            }
            do
            {
                
                _loc_6 = this.find_path(param1, param2);
                this.xor_path(param1, _loc_6);
                if (_loc_6.area > this.params.turdSize)
                {
                    _loc_4.push(_loc_6);
                }
                var _loc_7:* = this.find_next_in_path(param1, _loc_6);
                param2 = this.find_next_in_path(param1, _loc_6);
                if (_loc_7 != null)
                {
                    this.get_contour(param1, param2, param3);
                }
                var _loc_7:* = this.find_next_in_path(param1, _loc_5);
                param2 = this.find_next_in_path(param1, _loc_5);
            }while (_loc_7 != null)
            return;
        }// end function

        private function find_path(param1:Vector.<Vector.<uint>>, param2:PointInt) : Path
        {
            var _loc_9:* = 0;
            var _loc_3:* = new Vector.<PointInt>;
            var _loc_4:* = param2.clone();
            var _loc_5:* = Direction.NORTH;
            var _loc_6:* = 0;
            do
            {
                
                _loc_3.push(_loc_4.clone());
                _loc_9 = _loc_4.y;
                _loc_5 = this.find_next_trace(param1, _loc_4, _loc_5);
                _loc_6 = _loc_6 + _loc_4.x * (_loc_9 - _loc_4.y);
            }while (_loc_4.x != param2.x || _loc_4.y != param2.y)
            if (_loc_3.length == 0)
            {
                return null;
            }
            var _loc_7:* = new Path();
            _loc_7.area = _loc_6;
            _loc_7.pt = new Vector.<PointInt>(_loc_3.length);
            var _loc_8:* = 0;
            while (_loc_8 < _loc_3.length)
            {
                
                _loc_7.pt[_loc_8] = _loc_3[_loc_8];
                _loc_8++;
            }
            if (_loc_7.pt.length > 1)
            {
                _loc_7.pt.unshift(_loc_7.pt.pop());
            }
            _loc_7.monotonIntervals = this.get_monoton_intervals(_loc_7.pt);
            return _loc_7;
        }// end function

        private function find_next_in_path(param1:Vector.<Vector.<uint>>, param2:Path) : PointInt
        {
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_13:* = 0;
            var _loc_14:* = null;
            var _loc_15:* = 0;
            var _loc_16:* = null;
            var _loc_17:* = 0;
            if (param2.monotonIntervals.length == 0)
            {
                return null;
            }
            var _loc_3:* = 0;
            var _loc_4:* = param2.pt.length;
            var _loc_5:* = param2.monotonIntervals;
            var _loc_6:* = _loc_5[0];
            _loc_6.resetCurrentId(_loc_4);
            var _loc_7:* = param2.pt[_loc_6.currentId].y;
            var _loc_8:* = new Vector.<MonotonInterval>;
            _loc_8[0] = _loc_6;
            _loc_6.currentId = _loc_6.min();
            while (_loc_5.length > (_loc_3 + 1) && _loc_6.minY(param2.pt) == _loc_7)
            {
                
                _loc_6 = _loc_5[(_loc_3 + 1)];
                _loc_6.resetCurrentId(_loc_4);
                _loc_8.push(_loc_6);
                _loc_3++;
            }
            while (_loc_8.length > 0)
            {
                
                _loc_10 = 0;
                while (_loc_10 < (_loc_8.length - 1))
                {
                    
                    _loc_11 = param2.pt[_loc_8[_loc_10].currentId].x + 1;
                    _loc_12 = param2.pt[_loc_8[(_loc_10 + 1)].currentId].x;
                    _loc_13 = _loc_11;
                    while (_loc_13 <= _loc_12)
                    {
                        
                        if (param1[_loc_7][_loc_13] == 0)
                        {
                            return new PointInt((_loc_13 - 1), _loc_7);
                        }
                        _loc_13++;
                    }
                    _loc_10++;
                    _loc_10++;
                }
                _loc_7++;
                _loc_9 = _loc_8.length - 1;
                while (_loc_9 >= 0)
                {
                    
                    _loc_14 = _loc_8[_loc_9];
                    if (_loc_7 > _loc_14.maxY(param2.pt))
                    {
                        _loc_8.splice(_loc_9, 1);
                    }
                    else
                    {
                        _loc_15 = _loc_14.currentId;
                        do
                        {
                            
                            _loc_15 = _loc_14.increasing ? (this.mod((_loc_15 + 1), _loc_4)) : (this.mod((_loc_15 - 1), _loc_4));
                        }while (param2.pt[_loc_15].y < _loc_7)
                        _loc_14.currentId = _loc_15;
                    }
                    _loc_9 = _loc_9 - 1;
                }
                while (_loc_5.length > (_loc_3 + 1) && _loc_6.minY(param2.pt) == _loc_7)
                {
                    
                    _loc_16 = _loc_5[(_loc_3 + 1)];
                    _loc_9 = 0;
                    _loc_17 = param2.pt[_loc_16.min()].x;
                    while (_loc_8.length > _loc_9 && _loc_17 > param2.pt[_loc_14.currentId].x)
                    {
                        
                        _loc_9++;
                    }
                    _loc_8.splice(_loc_9, 0, _loc_16);
                    _loc_16.resetCurrentId(_loc_4);
                    _loc_3++;
                }
            }
            return null;
        }// end function

        private function xor_path(param1:Vector.<Vector.<uint>>, param2:Path) : void
        {
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_13:* = 0;
            var _loc_14:* = null;
            var _loc_15:* = 0;
            var _loc_16:* = null;
            var _loc_17:* = 0;
            if (param2.monotonIntervals.length == 0)
            {
                return;
            }
            var _loc_3:* = 0;
            var _loc_4:* = param2.pt.length;
            var _loc_5:* = param2.monotonIntervals;
            var _loc_6:* = _loc_5[0];
            _loc_6.resetCurrentId(_loc_4);
            var _loc_7:* = param2.pt[_loc_6.currentId].y;
            var _loc_8:* = new Vector.<MonotonInterval>;
            _loc_8.push(_loc_6);
            _loc_6.currentId = _loc_6.min();
            while (_loc_5.length > (_loc_3 + 1) && _loc_6.minY(param2.pt) == _loc_7)
            {
                
                _loc_6 = _loc_5[(_loc_3 + 1)];
                _loc_6.resetCurrentId(_loc_4);
                _loc_8.push(_loc_6);
                _loc_3++;
            }
            while (_loc_8.length > 0)
            {
                
                _loc_10 = 0;
                while (_loc_10 < (_loc_8.length - 1))
                {
                    
                    _loc_11 = param2.pt[_loc_8[_loc_10].currentId].x + 1;
                    _loc_12 = param2.pt[_loc_8[(_loc_10 + 1)].currentId].x;
                    _loc_13 = _loc_11;
                    while (_loc_13 <= _loc_12)
                    {
                        
                        param1[_loc_7][_loc_13] = param1[_loc_7][_loc_13] ^ 16777215;
                        _loc_13++;
                    }
                    _loc_10++;
                    _loc_10++;
                }
                _loc_7++;
                _loc_9 = _loc_8.length - 1;
                while (_loc_9 >= 0)
                {
                    
                    _loc_14 = _loc_8[_loc_9];
                    if (_loc_7 > _loc_14.maxY(param2.pt))
                    {
                        _loc_8.splice(_loc_9, 1);
                    }
                    else
                    {
                        _loc_15 = _loc_14.currentId;
                        do
                        {
                            
                            _loc_15 = _loc_14.increasing ? (this.mod((_loc_15 + 1), _loc_4)) : (this.mod((_loc_15 - 1), _loc_4));
                        }while (param2.pt[_loc_15].y < _loc_7)
                        _loc_14.currentId = _loc_15;
                    }
                    _loc_9 = _loc_9 - 1;
                }
                while (_loc_5.length > (_loc_3 + 1) && _loc_6.minY(param2.pt) == _loc_7)
                {
                    
                    _loc_16 = _loc_5[(_loc_3 + 1)];
                    _loc_9 = 0;
                    _loc_17 = param2.pt[_loc_16.min()].x;
                    while (_loc_8.length > _loc_9 && _loc_17 > param2.pt[_loc_14.currentId].x)
                    {
                        
                        _loc_9++;
                    }
                    _loc_8.splice(_loc_9, 0, _loc_16);
                    _loc_16.resetCurrentId(_loc_4);
                    _loc_3++;
                }
            }
            return;
        }// end function

        private function get_monoton_intervals(param1:Vector.<PointInt>) : Vector.<MonotonInterval>
        {
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_2:* = new Vector.<MonotonInterval>;
            var _loc_3:* = param1.length;
            if (_loc_3 == 0)
            {
                return _loc_2;
            }
            var _loc_4:* = new Vector.<MonotonInterval>;
            var _loc_5:* = 0;
            while (param1[_loc_5].y == param1[(_loc_5 + 1)].y)
            {
                
                _loc_5++;
            }
            var _loc_6:* = _loc_5;
            var _loc_7:* = param1[_loc_5].y < param1[(_loc_5 + 1)].y;
            var _loc_8:* = new MonotonInterval(_loc_7, _loc_5, _loc_5);
            _loc_4.push(_loc_8);
            do
            {
                
                _loc_9 = this.mod((_loc_6 + 1), _loc_3);
                if (param1[_loc_6].y == param1[_loc_9].y || _loc_7 == param1[_loc_6].y < param1[_loc_9].y)
                {
                    _loc_8.to = _loc_6;
                }
                else
                {
                    _loc_7 = param1[_loc_6].y < param1[_loc_9].y;
                    _loc_8 = new MonotonInterval(_loc_7, _loc_6, _loc_6);
                    _loc_4.push(_loc_8);
                }
                _loc_6 = _loc_9;
            }while (_loc_6 != _loc_5)
            if ((_loc_4.length & 1) == 1)
            {
                _loc_10 = _loc_4.pop();
                _loc_4[0].from = _loc_10.from;
            }
            while (_loc_4.length > 0)
            {
                
                _loc_6 = 0;
                _loc_11 = _loc_4.shift();
                while (_loc_6 < _loc_2.length && param1[_loc_11.min()].y > param1[_loc_2[_loc_6].min()].y)
                {
                    
                    _loc_6++;
                }
                while (_loc_6 < _loc_2.length && param1[_loc_11.min()].y == param1[_loc_2[_loc_6].min()].y && param1[_loc_11.min()].x > param1[_loc_2[_loc_6].min()].x)
                {
                    
                    _loc_6++;
                }
                _loc_2.splice(_loc_6, 0, _loc_11);
            }
            return _loc_2;
        }// end function

        private function find_next_trace(param1:Vector.<Vector.<uint>>, param2:PointInt, param3:uint) : uint
        {
            switch(param3)
            {
                case Direction.WEST:
                {
                    if (param1[(param2.y + 1)][(param2.x + 1)] == 0)
                    {
                        param3 = Direction.NORTH;
                        var _loc_4:* = param2;
                        var _loc_5:* = _loc_4.y + 1;
                        _loc_4.y = _loc_5;
                    }
                    else if (param1[_loc_4.y][(_loc_4.x + 1)] == 0)
                    {
                        param3 = Direction.WEST;
                        var _loc_4:* = param2;
                        var _loc_5:* = _loc_4.x + 1;
                        _loc_4.x = _loc_5;
                    }
                    else
                    {
                        param3 = Direction.SOUTH;
                        var _loc_4:* = param2;
                        var _loc_5:* = _loc_4.y - 1;
                        _loc_4.y = _loc_5;
                    }
                    break;
                }
                case Direction.SOUTH:
                {
                    if (param1[_loc_4.y][(_loc_4.x + 1)] == 0)
                    {
                        param3 = Direction.WEST;
                        var _loc_4:* = param2;
                        var _loc_5:* = _loc_4.x + 1;
                        _loc_4.x = _loc_5;
                    }
                    else if (param1[_loc_4.y][_loc_4.x] == 0)
                    {
                        param3 = Direction.SOUTH;
                        var _loc_4:* = param2;
                        var _loc_5:* = _loc_4.y - 1;
                        _loc_4.y = _loc_5;
                    }
                    else
                    {
                        param3 = Direction.EAST;
                        var _loc_4:* = param2;
                        var _loc_5:* = _loc_4.x - 1;
                        _loc_4.x = _loc_5;
                    }
                    break;
                }
                case Direction.EAST:
                {
                    if (param1[_loc_4.y][_loc_4.x] == 0)
                    {
                        param3 = Direction.SOUTH;
                        var _loc_4:* = param2;
                        var _loc_5:* = _loc_4.y - 1;
                        _loc_4.y = _loc_5;
                    }
                    else if (param1[(_loc_4.y + 1)][_loc_4.x] == 0)
                    {
                        param3 = Direction.EAST;
                        var _loc_4:* = param2;
                        var _loc_5:* = _loc_4.x - 1;
                        _loc_4.x = _loc_5;
                    }
                    else
                    {
                        param3 = Direction.NORTH;
                        var _loc_4:* = param2;
                        var _loc_5:* = _loc_4.y + 1;
                        _loc_4.y = _loc_5;
                    }
                    break;
                }
                case Direction.NORTH:
                {
                    if (param1[(_loc_4.y + 1)][_loc_4.x] == 0)
                    {
                        param3 = Direction.EAST;
                        var _loc_4:* = param2;
                        var _loc_5:* = _loc_4.x - 1;
                        _loc_4.x = _loc_5;
                    }
                    else if (param1[(_loc_4.y + 1)][(_loc_4.x + 1)] == 0)
                    {
                        param3 = Direction.NORTH;
                        var _loc_4:* = param2;
                        var _loc_5:* = _loc_4.y + 1;
                        _loc_4.y = _loc_5;
                    }
                    else
                    {
                        param3 = Direction.WEST;
                        var _loc_4:* = param2;
                        var _loc_5:* = _loc_4.x + 1;
                        _loc_4.x = _loc_5;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return param3;
        }// end function

        private function process_path(param1:Array) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_2:* = 0;
            while (_loc_2 < param1.length)
            {
                
                _loc_3 = param1[_loc_2] as Array;
                _loc_4 = 0;
                while (_loc_4 < _loc_3.length)
                {
                    
                    _loc_5 = _loc_3[_loc_4] as Path;
                    this.calc_sums(_loc_5);
                    this.calc_lon(_loc_5);
                    this.bestpolygon(_loc_5);
                    this.adjust_vertices(_loc_5);
                    this.smooth(_loc_5.curves, 1, this.params.alphaMax);
                    if (this.params.curveOptimizing)
                    {
                        this.opticurve(_loc_5, this.params.optTolerance);
                        _loc_5.fCurves = _loc_5.optimizedCurves;
                    }
                    else
                    {
                        _loc_5.fCurves = _loc_5.curves;
                    }
                    _loc_5.curves = _loc_5.fCurves;
                    _loc_4++;
                }
                _loc_2++;
            }
            return;
        }// end function

        private function calc_sums(param1:Path) : void
        {
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_2:* = param1.pt.length;
            var _loc_3:* = param1.pt[0].x;
            var _loc_4:* = param1.pt[0].y;
            param1.sums = new Vector.<SumStruct>((_loc_2 + 1));
            var _loc_5:* = new SumStruct();
            var _loc_9:* = 0;
            _loc_5.y = 0;
            _loc_5.x = _loc_9;
            _loc_5.y2 = _loc_9;
            _loc_5.xy = _loc_9;
            _loc_5.x2 = _loc_9;
            param1.sums[0] = _loc_5;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_2)
            {
                
                _loc_7 = param1.pt[_loc_6].x - _loc_3;
                _loc_8 = param1.pt[_loc_6].y - _loc_4;
                _loc_5 = new SumStruct();
                _loc_5.x = param1.sums[_loc_6].x + _loc_7;
                _loc_5.y = param1.sums[_loc_6].y + _loc_8;
                _loc_5.x2 = param1.sums[_loc_6].x2 + _loc_7 * _loc_7;
                _loc_5.xy = param1.sums[_loc_6].xy + _loc_7 * _loc_8;
                _loc_5.y2 = param1.sums[_loc_6].y2 + _loc_8 * _loc_8;
                param1.sums[(_loc_6 + 1)] = _loc_5;
                _loc_6++;
            }
            return;
        }// end function

        private function calc_lon(param1:Path) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_20:* = false;
            var _loc_11:* = new Vector.<int>(4);
            var _loc_12:* = new Vector.<PointInt>(2);
            _loc_12[0] = new PointInt();
            _loc_12[1] = new PointInt();
            var _loc_13:* = new PointInt();
            var _loc_14:* = new PointInt();
            var _loc_15:* = new PointInt();
            var _loc_16:* = param1.pt;
            var _loc_17:* = _loc_16.length;
            var _loc_18:* = new Vector.<int>(_loc_17);
            var _loc_19:* = new Vector.<int>(_loc_17);
            _loc_4 = 0;
            _loc_2 = _loc_17 - 1;
            while (_loc_2 >= 0)
            {
                
                if (_loc_16[_loc_2].x != _loc_16[_loc_4].x && _loc_16[_loc_2].y != _loc_16[_loc_4].y)
                {
                    _loc_4 = _loc_2 + 1;
                }
                _loc_19[_loc_2] = _loc_4;
                _loc_2 = _loc_2 - 1;
            }
            param1.lon = new Vector.<int>(_loc_17);
            _loc_2 = _loc_17 - 1;
            while (_loc_2 >= 0)
            {
                
                var _loc_21:* = 0;
                _loc_11[3] = 0;
                _loc_11[2] = _loc_21;
                _loc_11[1] = _loc_21;
                _loc_11[0] = _loc_21;
                _loc_10 = (3 + 3 * (_loc_16[this.mod((_loc_2 + 1), _loc_17)].x - _loc_16[_loc_2].x) + (_loc_16[this.mod((_loc_2 + 1), _loc_17)].y - _loc_16[_loc_2].y)) / 2;
                var _loc_21:* = _loc_11;
                var _loc_22:* = _loc_10 % 4;
                var _loc_23:* = _loc_11[_loc_10 % 4] + 1;
                _loc_21[_loc_22] = _loc_23;
                _loc_12[0].x = 0;
                _loc_12[0].y = 0;
                _loc_12[1].x = 0;
                _loc_12[1].y = 0;
                _loc_4 = _loc_19[_loc_2];
                _loc_5 = _loc_2;
                _loc_20 = false;
                while (true)
                {
                    
                    _loc_10 = (3 + 3 * this.sign(_loc_16[_loc_4].x - _loc_16[_loc_5].x) + this.sign(_loc_16[_loc_4].y - _loc_16[_loc_5].y)) / 2;
                    var _loc_21:* = _loc_11;
                    var _loc_22:* = _loc_10;
                    var _loc_23:* = _loc_11[_loc_10] + 1;
                    _loc_21[_loc_22] = _loc_23;
                    if (_loc_11[0] >= 1 && _loc_11[1] >= 1 && _loc_11[2] >= 1 && _loc_11[3] >= 1)
                    {
                        _loc_18[_loc_2] = _loc_5;
                        _loc_20 = true;
                        break;
                    }
                    _loc_13.x = _loc_16[_loc_4].x - _loc_16[_loc_2].x;
                    _loc_13.y = _loc_16[_loc_4].y - _loc_16[_loc_2].y;
                    if (this.xprod(_loc_12[0], _loc_13) < 0 || this.xprod(_loc_12[1], _loc_13) > 0)
                    {
                        break;
                    }
                    if (this.abs(_loc_13.x) <= 1 && this.abs(_loc_13.y) <= 1)
                    {
                    }
                    else
                    {
                        _loc_14.x = _loc_13.x + (_loc_13.y >= 0 && (_loc_13.y > 0 || _loc_13.x < 0) ? (1) : (-1));
                        _loc_14.y = _loc_13.y + (_loc_13.x <= 0 && (_loc_13.x < 0 || _loc_13.y < 0) ? (1) : (-1));
                        if (this.xprod(_loc_12[0], _loc_14) >= 0)
                        {
                            _loc_12[0] = _loc_14.clone();
                        }
                        _loc_14.x = _loc_13.x + (_loc_13.y <= 0 && (_loc_13.y < 0 || _loc_13.x < 0) ? (1) : (-1));
                        _loc_14.y = _loc_13.y + (_loc_13.x >= 0 && (_loc_13.x > 0 || _loc_13.y < 0) ? (1) : (-1));
                        if (this.xprod(_loc_12[1], _loc_14) <= 0)
                        {
                            _loc_12[1] = _loc_14.clone();
                        }
                    }
                    _loc_5 = _loc_4;
                    _loc_4 = _loc_19[_loc_5];
                    if (!this.cyclic(_loc_4, _loc_2, _loc_5))
                    {
                        break;
                    }
                }
                if (_loc_20)
                {
                }
                else
                {
                    _loc_15.x = this.sign(_loc_16[_loc_4].x - _loc_16[_loc_5].x);
                    _loc_15.y = this.sign(_loc_16[_loc_4].y - _loc_16[_loc_5].y);
                    _loc_13.x = _loc_16[_loc_5].x - _loc_16[_loc_2].x;
                    _loc_13.y = _loc_16[_loc_5].y - _loc_16[_loc_2].y;
                    _loc_6 = this.xprod(_loc_12[0], _loc_13);
                    _loc_7 = this.xprod(_loc_12[0], _loc_15);
                    _loc_8 = this.xprod(_loc_12[1], _loc_13);
                    _loc_9 = this.xprod(_loc_12[1], _loc_15);
                    _loc_3 = int.MAX_VALUE;
                    if (_loc_7 < 0)
                    {
                        _loc_3 = this.floordiv(_loc_6, -_loc_7);
                    }
                    if (_loc_9 > 0)
                    {
                        _loc_3 = this.min(_loc_3, this.floordiv(-_loc_8, _loc_9));
                    }
                    _loc_18[_loc_2] = this.mod(_loc_5 + _loc_3, _loc_17);
                }
                _loc_2 = _loc_2 - 1;
            }
            _loc_3 = _loc_18[(_loc_17 - 1)];
            param1.lon[(_loc_17 - 1)] = _loc_3;
            _loc_2 = _loc_17 - 2;
            while (_loc_2 >= 0)
            {
                
                if (this.cyclic((_loc_2 + 1), _loc_18[_loc_2], _loc_3))
                {
                    _loc_3 = _loc_18[_loc_2];
                }
                param1.lon[_loc_2] = _loc_3;
                _loc_2 = _loc_2 - 1;
            }
            _loc_2 = _loc_17 - 1;
            while (this.cyclic(this.mod((_loc_2 + 1), _loc_17), _loc_3, param1.lon[_loc_2]))
            {
                
                param1.lon[_loc_2] = _loc_3;
                _loc_2 = _loc_2 - 1;
            }
            return;
        }// end function

        private function penalty3(param1:Path, param2:int, param3:int) : Number
        {
            var _loc_4:* = param1.pt.length;
            var _loc_5:* = param1.sums;
            var _loc_6:* = param1.pt;
            var _loc_7:* = 0;
            if (param3 >= _loc_4)
            {
                param3 = param3 - _loc_4;
                _loc_7++;
            }
            var _loc_8:* = _loc_5[(param3 + 1)].x - _loc_5[param2].x + _loc_7 * _loc_5[_loc_4].x;
            var _loc_9:* = _loc_5[(param3 + 1)].y - _loc_5[param2].y + _loc_7 * _loc_5[_loc_4].y;
            var _loc_10:* = _loc_5[(param3 + 1)].x2 - _loc_5[param2].x2 + _loc_7 * _loc_5[_loc_4].x2;
            var _loc_11:* = _loc_5[(param3 + 1)].xy - _loc_5[param2].xy + _loc_7 * _loc_5[_loc_4].xy;
            var _loc_12:* = _loc_5[(param3 + 1)].y2 - _loc_5[param2].y2 + _loc_7 * _loc_5[_loc_4].y2;
            var _loc_13:* = (param3 + 1) - param2 + _loc_7 * _loc_4;
            var _loc_14:* = (_loc_6[param2].x + _loc_6[param3].x) / 2 - _loc_6[0].x;
            var _loc_15:* = (_loc_6[param2].y + _loc_6[param3].y) / 2 - _loc_6[0].y;
            var _loc_16:* = _loc_6[param3].x - _loc_6[param2].x;
            var _loc_17:* = -(_loc_6[param3].y - _loc_6[param2].y);
            var _loc_18:* = (_loc_10 - 2 * _loc_8 * _loc_14) / _loc_13 + _loc_14 * _loc_14;
            var _loc_19:* = (_loc_11 - _loc_8 * _loc_15 - _loc_9 * _loc_14) / _loc_13 + _loc_14 * _loc_15;
            var _loc_20:* = (_loc_12 - 2 * _loc_9 * _loc_15) / _loc_13 + _loc_15 * _loc_15;
            return Math.sqrt(_loc_17 * _loc_17 * _loc_18 + 2 * _loc_17 * _loc_16 * _loc_19 + _loc_16 * _loc_16 * _loc_20);
        }// end function

        private function bestpolygon(param1:Path) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_13:* = NaN;
            var _loc_14:* = NaN;
            var _loc_15:* = 0;
            var _loc_6:* = param1.pt.length;
            var _loc_7:* = new Vector.<Number>((_loc_6 + 1));
            var _loc_8:* = new Vector.<int>((_loc_6 + 1));
            var _loc_9:* = new Vector.<int>(_loc_6);
            var _loc_10:* = new Vector.<int>((_loc_6 + 1));
            var _loc_11:* = new Vector.<int>((_loc_6 + 1));
            var _loc_12:* = new Vector.<int>((_loc_6 + 1));
            _loc_2 = 0;
            while (_loc_2 < _loc_6)
            {
                
                _loc_15 = this.mod((param1.lon[this.mod((_loc_2 - 1), _loc_6)] - 1), _loc_6);
                if (_loc_15 == _loc_2)
                {
                    _loc_15 = this.mod((_loc_2 + 1), _loc_6);
                }
                _loc_9[_loc_2] = _loc_15 < _loc_2 ? (_loc_6) : (_loc_15);
                _loc_2++;
            }
            _loc_3 = 1;
            _loc_2 = 0;
            while (_loc_2 < _loc_6)
            {
                
                while (_loc_3 <= _loc_9[_loc_2])
                {
                    
                    _loc_10[_loc_3] = _loc_2;
                    _loc_3++;
                }
                _loc_2++;
            }
            _loc_2 = 0;
            _loc_3 = 0;
            while (_loc_2 < _loc_6)
            {
                
                _loc_11[_loc_3] = _loc_2;
                _loc_2 = _loc_9[_loc_2];
                _loc_3++;
            }
            _loc_11[_loc_3] = _loc_6;
            _loc_2 = _loc_6;
            _loc_4 = _loc_3;
            _loc_3 = _loc_4;
            while (_loc_3 > 0)
            {
                
                _loc_12[_loc_3] = _loc_2;
                _loc_2 = _loc_10[_loc_2];
                _loc_3 = _loc_3 - 1;
            }
            _loc_12[0] = 0;
            _loc_7[0] = 0;
            _loc_3 = 1;
            while (_loc_3 <= _loc_4)
            {
                
                _loc_2 = _loc_12[_loc_3];
                while (_loc_2 <= _loc_11[_loc_3])
                {
                    
                    _loc_14 = -1;
                    _loc_5 = _loc_11[(_loc_3 - 1)];
                    while (_loc_5 >= _loc_10[_loc_2])
                    {
                        
                        _loc_13 = this.penalty3(param1, _loc_5, _loc_2) + _loc_7[_loc_5];
                        if (_loc_14 < 0 || _loc_13 < _loc_14)
                        {
                            _loc_8[_loc_2] = _loc_5;
                            _loc_14 = _loc_13;
                        }
                        _loc_5 = _loc_5 - 1;
                    }
                    _loc_7[_loc_2] = _loc_14;
                    _loc_2++;
                }
                _loc_3++;
            }
            param1.po = new Vector.<int>(_loc_4);
            _loc_2 = _loc_6;
            _loc_3 = _loc_4 - 1;
            while (_loc_2 > 0)
            {
                
                _loc_2 = _loc_8[_loc_2];
                param1.po[_loc_3] = _loc_2;
                _loc_3 = _loc_3 - 1;
            }
            return;
        }// end function

        private function adjust_vertices(param1:Path) : void
        {
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = NaN;
            var _loc_18:* = null;
            var _loc_19:* = null;
            var _loc_20:* = NaN;
            var _loc_21:* = NaN;
            var _loc_22:* = NaN;
            var _loc_23:* = NaN;
            var _loc_24:* = NaN;
            var _loc_25:* = NaN;
            var _loc_26:* = NaN;
            var _loc_27:* = 0;
            var _loc_2:* = param1.pt;
            var _loc_3:* = param1.po;
            var _loc_4:* = _loc_2.length;
            var _loc_5:* = _loc_3.length;
            var _loc_6:* = _loc_2[0].x;
            var _loc_7:* = _loc_2[0].y;
            var _loc_13:* = new Vector.<Number>(3);
            var _loc_14:* = new Vector.<Vector.<Vector.<Number>>>(_loc_5);
            var _loc_15:* = new Vector.<Point>(_loc_5);
            var _loc_16:* = new Vector.<Point>(_loc_5);
            _loc_8 = 0;
            while (_loc_8 < _loc_5)
            {
                
                _loc_14[_loc_8] = new Vector.<Vector.<Number>>(3);
                _loc_9 = 0;
                while (_loc_9 < 3)
                {
                    
                    _loc_14[_loc_8][_loc_9] = new Vector.<Number>(3);
                    _loc_9++;
                }
                _loc_15[_loc_8] = new Point();
                _loc_16[_loc_8] = new Point();
                _loc_8++;
            }
            var _loc_17:* = new Point();
            param1.curves = new PrivCurve(_loc_5);
            _loc_8 = 0;
            while (_loc_8 < _loc_5)
            {
                
                _loc_9 = _loc_3[this.mod((_loc_8 + 1), _loc_5)];
                _loc_9 = this.mod(_loc_9 - _loc_3[_loc_8], _loc_4) + _loc_3[_loc_8];
                this.pointslope(param1, _loc_3[_loc_8], _loc_9, _loc_15[_loc_8], _loc_16[_loc_8]);
                _loc_8++;
            }
            _loc_8 = 0;
            while (_loc_8 < _loc_5)
            {
                
                _loc_12 = _loc_16[_loc_8].x * _loc_16[_loc_8].x + _loc_16[_loc_8].y * _loc_16[_loc_8].y;
                if (_loc_12 == 0)
                {
                    _loc_9 = 0;
                    while (_loc_9 < 3)
                    {
                        
                        _loc_10 = 0;
                        while (_loc_10 < 3)
                        {
                            
                            _loc_14[_loc_8][_loc_9][_loc_10] = 0;
                            _loc_10++;
                        }
                        _loc_9++;
                    }
                }
                else
                {
                    _loc_13[0] = _loc_16[_loc_8].y;
                    _loc_13[1] = -_loc_16[_loc_8].x;
                    _loc_13[2] = (-_loc_13[1]) * _loc_15[_loc_8].y - _loc_13[0] * _loc_15[_loc_8].x;
                    _loc_11 = 0;
                    while (_loc_11 < 3)
                    {
                        
                        _loc_10 = 0;
                        while (_loc_10 < 3)
                        {
                            
                            _loc_14[_loc_8][_loc_11][_loc_10] = _loc_13[_loc_11] * _loc_13[_loc_10] / _loc_12;
                            _loc_10++;
                        }
                        _loc_11++;
                    }
                }
                _loc_8++;
            }
            _loc_8 = 0;
            while (_loc_8 < _loc_5)
            {
                
                _loc_18 = new Vector.<Vector.<Number>>(3);
                _loc_19 = new Point();
                _loc_9 = 0;
                while (_loc_9 < 3)
                {
                    
                    _loc_18[_loc_9] = new Vector.<Number>(3);
                    _loc_9++;
                }
                _loc_17.x = _loc_2[_loc_3[_loc_8]].x - _loc_6;
                _loc_17.y = _loc_2[_loc_3[_loc_8]].y - _loc_7;
                _loc_9 = this.mod((_loc_8 - 1), _loc_5);
                _loc_11 = 0;
                while (_loc_11 < 3)
                {
                    
                    _loc_10 = 0;
                    while (_loc_10 < 3)
                    {
                        
                        _loc_18[_loc_11][_loc_10] = _loc_14[_loc_9][_loc_11][_loc_10] + _loc_14[_loc_8][_loc_11][_loc_10];
                        _loc_10++;
                    }
                    _loc_11++;
                }
                while (true)
                {
                    
                    _loc_22 = _loc_18[0][0] * _loc_18[1][1] - _loc_18[0][1] * _loc_18[1][0];
                    if (_loc_22 != 0)
                    {
                        _loc_19.x = ((-_loc_18[0][2]) * _loc_18[1][1] + _loc_18[1][2] * _loc_18[0][1]) / _loc_22;
                        _loc_19.y = (_loc_18[0][2] * _loc_18[1][0] - _loc_18[1][2] * _loc_18[0][0]) / _loc_22;
                        break;
                    }
                    if (_loc_18[0][0] > _loc_18[1][1])
                    {
                        _loc_13[0] = -_loc_18[0][1];
                        _loc_13[1] = _loc_18[0][0];
                    }
                    else if (_loc_18[1][1] != 0)
                    {
                        _loc_13[0] = -_loc_18[1][1];
                        _loc_13[1] = _loc_18[1][0];
                    }
                    else
                    {
                        _loc_13[0] = 1;
                        _loc_13[1] = 0;
                    }
                    _loc_12 = _loc_13[0] * _loc_13[0] + _loc_13[1] * _loc_13[1];
                    _loc_13[2] = (-_loc_13[1]) * _loc_17.y - _loc_13[0] * _loc_17.x;
                    _loc_11 = 0;
                    while (_loc_11 < 3)
                    {
                        
                        _loc_10 = 0;
                        while (_loc_10 < 3)
                        {
                            
                            _loc_18[_loc_11][_loc_10] = _loc_18[_loc_11][_loc_10] + _loc_13[_loc_11] * _loc_13[_loc_10] / _loc_12;
                            _loc_10++;
                        }
                        _loc_11++;
                    }
                }
                _loc_20 = Math.abs(_loc_19.x - _loc_17.x);
                _loc_21 = Math.abs(_loc_19.y - _loc_17.y);
                if (_loc_20 <= 0.5 && _loc_21 <= 0.5)
                {
                    param1.curves.vertex[_loc_8] = new Point(_loc_19.x + _loc_6, _loc_19.y + _loc_7);
                }
                else
                {
                    _loc_23 = this.quadform(_loc_18, _loc_17);
                    _loc_25 = _loc_17.x;
                    _loc_26 = _loc_17.y;
                    if (_loc_18[0][0] != 0)
                    {
                        _loc_27 = 0;
                        while (_loc_27 < 2)
                        {
                            
                            _loc_19.y = _loc_17.y - 0.5 + _loc_27;
                            _loc_19.x = (-(_loc_18[0][1] * _loc_19.y + _loc_18[0][2])) / _loc_18[0][0];
                            _loc_20 = Math.abs(_loc_19.x - _loc_17.x);
                            _loc_24 = this.quadform(_loc_18, _loc_19);
                            if (_loc_20 <= 0.5 && _loc_24 < _loc_23)
                            {
                                _loc_23 = _loc_24;
                                _loc_25 = _loc_19.x;
                                _loc_26 = _loc_19.y;
                            }
                            _loc_27++;
                        }
                    }
                    if (_loc_18[1][1] != 0)
                    {
                        _loc_27 = 0;
                        while (_loc_27 < 2)
                        {
                            
                            _loc_19.x = _loc_17.x - 0.5 + _loc_27;
                            _loc_19.y = (-(_loc_18[1][0] * _loc_19.x + _loc_18[1][2])) / _loc_18[1][1];
                            _loc_21 = Math.abs(_loc_19.y - _loc_17.y);
                            _loc_24 = this.quadform(_loc_18, _loc_19);
                            if (_loc_21 <= 0.5 && _loc_24 < _loc_23)
                            {
                                _loc_23 = _loc_24;
                                _loc_25 = _loc_19.x;
                                _loc_26 = _loc_19.y;
                            }
                            _loc_27++;
                        }
                    }
                    _loc_11 = 0;
                    while (_loc_11 < 2)
                    {
                        
                        _loc_10 = 0;
                        while (_loc_10 < 2)
                        {
                            
                            _loc_19.x = _loc_17.x - 0.5 + _loc_11;
                            _loc_19.y = _loc_17.y - 0.5 + _loc_10;
                            _loc_24 = this.quadform(_loc_18, _loc_19);
                            if (_loc_24 < _loc_23)
                            {
                                _loc_23 = _loc_24;
                                _loc_25 = _loc_19.x;
                                _loc_26 = _loc_19.y;
                            }
                            _loc_10++;
                        }
                        _loc_11++;
                    }
                    param1.curves.vertex[_loc_8] = new Point(_loc_25 + _loc_6 - 1, _loc_26 + _loc_7 - 1);
                    ;
                }
                _loc_8++;
            }
            return;
        }// end function

        private function smooth(param1:PrivCurve, param2:int, param3:Number) : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_4:* = param1.n;
            if (param2 < 0)
            {
                _loc_5 = 0;
                _loc_6 = _loc_4 - 1;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_14 = param1.vertex[_loc_5];
                    param1.vertex[_loc_5] = param1.vertex[_loc_6];
                    param1.vertex[_loc_6] = _loc_14;
                    _loc_5++;
                    _loc_6 = _loc_6 - 1;
                }
            }
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = this.mod((_loc_5 + 1), _loc_4);
                _loc_7 = this.mod(_loc_5 + 2, _loc_4);
                _loc_13 = this.interval(1 / 2, param1.vertex[_loc_7], param1.vertex[_loc_6]);
                _loc_9 = this.ddenom(param1.vertex[_loc_5], param1.vertex[_loc_7]);
                if (_loc_9 != 0)
                {
                    _loc_8 = this.dpara(param1.vertex[_loc_5], param1.vertex[_loc_6], param1.vertex[_loc_7]) / _loc_9;
                    _loc_8 = Math.abs(_loc_8);
                    _loc_10 = _loc_8 > 1 ? (1 - 1 / _loc_8) : (0);
                    _loc_10 = _loc_10 / 0.75;
                }
                else
                {
                    _loc_10 = 4 / 3;
                }
                param1.alpha0[_loc_6] = _loc_10;
                if (_loc_10 > param3)
                {
                    param1.tag[_loc_6] = POTRACE_CORNER;
                    param1.controlPoints[_loc_6][1] = param1.vertex[_loc_6];
                    param1.controlPoints[_loc_6][2] = _loc_13;
                }
                else
                {
                    if (_loc_10 < 0.55)
                    {
                        _loc_10 = 0.55;
                    }
                    else if (_loc_10 > 1)
                    {
                        _loc_10 = 1;
                    }
                    _loc_11 = this.interval(0.5 + 0.5 * _loc_10, param1.vertex[_loc_5], param1.vertex[_loc_6]);
                    _loc_12 = this.interval(0.5 + 0.5 * _loc_10, param1.vertex[_loc_7], param1.vertex[_loc_6]);
                    param1.tag[_loc_6] = POTRACE_CURVETO;
                    param1.controlPoints[_loc_6][0] = _loc_11;
                    param1.controlPoints[_loc_6][1] = _loc_12;
                    param1.controlPoints[_loc_6][2] = _loc_13;
                }
                param1.alpha[_loc_6] = _loc_10;
                param1.beta[_loc_6] = 0.5;
                _loc_5++;
            }
            return;
        }// end function

        private function opticurve(param1:Path, param2:Number) : void
        {
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = NaN;
            var _loc_13:* = NaN;
            var _loc_14:* = null;
            var _loc_15:* = 0;
            var _loc_17:* = false;
            var _loc_21:* = 0;
            var _loc_3:* = param1.curves.n;
            var _loc_4:* = new Vector.<int>(_loc_3);
            var _loc_5:* = new Vector.<Number>((_loc_3 + 1));
            var _loc_6:* = new Vector.<int>((_loc_3 + 1));
            var _loc_7:* = new Vector.<Opti>((_loc_3 + 1));
            var _loc_8:* = new Vector.<int>(_loc_3);
            var _loc_9:* = new Vector.<Number>((_loc_3 + 1));
            var _loc_16:* = new Opti();
            _loc_10 = 0;
            while (_loc_10 < _loc_3)
            {
                
                if (param1.curves.tag[_loc_10] == POTRACE_CURVETO)
                {
                    _loc_8[_loc_10] = this.sign(this.dpara(param1.curves.vertex[this.mod((_loc_10 - 1), _loc_3)], param1.curves.vertex[_loc_10], param1.curves.vertex[this.mod((_loc_10 + 1), _loc_3)]));
                }
                else
                {
                    _loc_8[_loc_10] = 0;
                }
                _loc_10++;
            }
            _loc_12 = 0;
            _loc_9[0] = 0;
            _loc_14 = param1.curves.vertex[0];
            _loc_10 = 0;
            while (_loc_10 < _loc_3)
            {
                
                _loc_15 = this.mod((_loc_10 + 1), _loc_3);
                if (param1.curves.tag[_loc_15] == POTRACE_CURVETO)
                {
                    _loc_13 = param1.curves.alpha[_loc_15];
                    _loc_12 = _loc_12 + 0.3 * _loc_13 * (4 - _loc_13) * this.dpara(param1.curves.controlPoints[_loc_10][2], param1.curves.vertex[_loc_15], param1.curves.controlPoints[_loc_15][2]) / 2;
                    _loc_12 = _loc_12 + this.dpara(_loc_14, param1.curves.controlPoints[_loc_10][2], param1.curves.controlPoints[_loc_15][2]) / 2;
                }
                _loc_9[(_loc_10 + 1)] = _loc_12;
                _loc_10++;
            }
            _loc_4[0] = -1;
            _loc_5[0] = 0;
            _loc_6[0] = 0;
            _loc_11 = 1;
            while (_loc_11 <= _loc_3)
            {
                
                _loc_4[_loc_11] = _loc_11 - 1;
                _loc_5[_loc_11] = _loc_5[(_loc_11 - 1)];
                _loc_6[_loc_11] = _loc_6[(_loc_11 - 1)] + 1;
                _loc_10 = _loc_11 - 2;
                while (_loc_10 >= 0)
                {
                    
                    _loc_17 = this.opti_penalty(param1, _loc_10, this.mod(_loc_11, _loc_3), _loc_16, param2, _loc_8, _loc_9);
                    if (_loc_17)
                    {
                        break;
                    }
                    if (_loc_6[_loc_11] > (_loc_6[_loc_10] + 1) || _loc_6[_loc_11] == (_loc_6[_loc_10] + 1) && _loc_5[_loc_11] > _loc_5[_loc_10] + _loc_16.pen)
                    {
                        _loc_4[_loc_11] = _loc_10;
                        _loc_5[_loc_11] = _loc_5[_loc_10] + _loc_16.pen;
                        _loc_6[_loc_11] = _loc_6[_loc_10] + 1;
                        _loc_7[_loc_11] = _loc_16.clone();
                    }
                    _loc_10 = _loc_10 - 1;
                }
                _loc_11++;
            }
            var _loc_18:* = _loc_6[_loc_3];
            param1.optimizedCurves = new PrivCurve(_loc_18);
            var _loc_19:* = new Vector.<Number>(_loc_18);
            var _loc_20:* = new Vector.<Number>(_loc_18);
            _loc_11 = _loc_3;
            _loc_10 = _loc_18 - 1;
            while (_loc_10 >= 0)
            {
                
                _loc_21 = this.mod(_loc_11, _loc_3);
                if (_loc_4[_loc_11] == (_loc_11 - 1))
                {
                    param1.optimizedCurves.tag[_loc_10] = param1.curves.tag[_loc_21];
                    param1.optimizedCurves.controlPoints[_loc_10][0] = param1.curves.controlPoints[_loc_21][0];
                    param1.optimizedCurves.controlPoints[_loc_10][1] = param1.curves.controlPoints[_loc_21][1];
                    param1.optimizedCurves.controlPoints[_loc_10][2] = param1.curves.controlPoints[_loc_21][2];
                    param1.optimizedCurves.vertex[_loc_10] = param1.curves.vertex[_loc_21];
                    param1.optimizedCurves.alpha[_loc_10] = param1.curves.alpha[_loc_21];
                    param1.optimizedCurves.alpha0[_loc_10] = param1.curves.alpha0[_loc_21];
                    param1.optimizedCurves.beta[_loc_10] = param1.curves.beta[_loc_21];
                    var _loc_22:* = 1;
                    _loc_20[_loc_10] = 1;
                    _loc_19[_loc_10] = _loc_22;
                }
                else
                {
                    param1.optimizedCurves.tag[_loc_10] = POTRACE_CURVETO;
                    param1.optimizedCurves.controlPoints[_loc_10][0] = _loc_7[_loc_11].c[0];
                    param1.optimizedCurves.controlPoints[_loc_10][1] = _loc_7[_loc_11].c[1];
                    param1.optimizedCurves.controlPoints[_loc_10][2] = param1.curves.controlPoints[_loc_21][2];
                    param1.optimizedCurves.vertex[_loc_10] = this.interval(_loc_7[_loc_11].s, param1.curves.controlPoints[_loc_21][2], param1.curves.vertex[_loc_21]);
                    param1.optimizedCurves.alpha[_loc_10] = _loc_7[_loc_11].alpha;
                    param1.optimizedCurves.alpha0[_loc_10] = _loc_7[_loc_11].alpha;
                    _loc_19[_loc_10] = _loc_7[_loc_11].s;
                    _loc_20[_loc_10] = _loc_7[_loc_11].t;
                }
                _loc_11 = _loc_4[_loc_11];
                _loc_10 = _loc_10 - 1;
            }
            _loc_10 = 0;
            while (_loc_10 < _loc_18)
            {
                
                _loc_15 = this.mod((_loc_10 + 1), _loc_18);
                param1.optimizedCurves.beta[_loc_10] = _loc_19[_loc_10] / (_loc_19[_loc_10] + _loc_20[_loc_15]);
                _loc_10++;
            }
            return;
        }// end function

        private function opti_penalty(param1:Path, param2:int, param3:int, param4:Opti, param5:Number, param6:Vector.<int>, param7:Vector.<Number>) : Boolean
        {
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_13:* = 0;
            var _loc_14:* = NaN;
            var _loc_15:* = NaN;
            var _loc_16:* = NaN;
            var _loc_17:* = NaN;
            var _loc_18:* = null;
            var _loc_8:* = param1.curves.n;
            if (param2 == param3)
            {
                return true;
            }
            _loc_9 = param2;
            _loc_13 = this.mod((param2 + 1), _loc_8);
            _loc_10 = this.mod((_loc_9 + 1), _loc_8);
            _loc_12 = param6[_loc_10];
            if (_loc_12 == 0)
            {
                return true;
            }
            _loc_15 = this.ddist(param1.curves.vertex[param2], param1.curves.vertex[_loc_13]);
            _loc_9 = _loc_10;
            while (_loc_9 != param3)
            {
                
                _loc_10 = this.mod((_loc_9 + 1), _loc_8);
                _loc_11 = this.mod(_loc_9 + 2, _loc_8);
                if (param6[_loc_10] != _loc_12)
                {
                    return true;
                }
                if (this.sign(this.cprod(param1.curves.vertex[param2], param1.curves.vertex[_loc_13], param1.curves.vertex[_loc_10], param1.curves.vertex[_loc_11])) != _loc_12)
                {
                    return true;
                }
                if (this.iprod1(param1.curves.vertex[param2], param1.curves.vertex[_loc_13], param1.curves.vertex[_loc_10], param1.curves.vertex[_loc_11]) < _loc_15 * this.ddist(param1.curves.vertex[_loc_10], param1.curves.vertex[_loc_11]) * COS179)
                {
                    return true;
                }
                _loc_9 = _loc_10;
            }
            var _loc_19:* = param1.curves.controlPoints[this.mod(param2, _loc_8)][2];
            var _loc_20:* = param1.curves.vertex[this.mod((param2 + 1), _loc_8)];
            var _loc_21:* = param1.curves.vertex[this.mod(param3, _loc_8)];
            var _loc_22:* = param1.curves.controlPoints[this.mod(param3, _loc_8)][2];
            _loc_14 = param7[param3] - param7[param2];
            _loc_14 = _loc_14 - this.dpara(param1.curves.vertex[0], param1.curves.controlPoints[param2][2], param1.curves.controlPoints[param3][2]) / 2;
            if (param2 >= param3)
            {
                _loc_14 = _loc_14 + param7[_loc_8];
            }
            var _loc_23:* = this.dpara(_loc_19, _loc_20, _loc_21);
            var _loc_24:* = this.dpara(_loc_19, _loc_20, _loc_22);
            var _loc_25:* = this.dpara(_loc_19, _loc_21, _loc_22);
            var _loc_26:* = _loc_23 + _loc_25 - _loc_24;
            if (_loc_24 == _loc_23)
            {
                return true;
            }
            var _loc_27:* = _loc_25 / (_loc_25 - _loc_26);
            var _loc_28:* = _loc_24 / (_loc_24 - _loc_23);
            var _loc_29:* = _loc_24 * _loc_27 / 2;
            if (_loc_24 * _loc_27 / 2 == 0)
            {
                return true;
            }
            var _loc_30:* = _loc_14 / _loc_29;
            var _loc_31:* = 2 - Math.sqrt(4 - _loc_30 / 0.3);
            param4.c = new Vector.<Point>(2);
            param4.c[0] = this.interval(_loc_27 * _loc_31, _loc_19, _loc_20);
            param4.c[1] = this.interval(_loc_28 * _loc_31, _loc_22, _loc_21);
            param4.alpha = _loc_31;
            param4.t = _loc_27;
            param4.s = _loc_28;
            _loc_20 = param4.c[0];
            _loc_21 = param4.c[1];
            param4.pen = 0;
            _loc_9 = this.mod((param2 + 1), _loc_8);
            while (_loc_9 != param3)
            {
                
                _loc_10 = this.mod((_loc_9 + 1), _loc_8);
                _loc_27 = this.tangent(_loc_19, _loc_20, _loc_21, _loc_22, param1.curves.vertex[_loc_9], param1.curves.vertex[_loc_10]);
                if (_loc_27 < -0.5)
                {
                    return true;
                }
                _loc_18 = this.bezier(_loc_27, _loc_19, _loc_20, _loc_21, _loc_22);
                _loc_15 = this.ddist(param1.curves.vertex[_loc_9], param1.curves.vertex[_loc_10]);
                if (_loc_15 == 0)
                {
                    return true;
                }
                _loc_16 = this.dpara(param1.curves.vertex[_loc_9], param1.curves.vertex[_loc_10], _loc_18) / _loc_15;
                if (Math.abs(_loc_16) > param5)
                {
                    return true;
                }
                if (this.iprod(param1.curves.vertex[_loc_9], param1.curves.vertex[_loc_10], _loc_18) < 0 || this.iprod(param1.curves.vertex[_loc_10], param1.curves.vertex[_loc_9], _loc_18) < 0)
                {
                    return true;
                }
                param4.pen = param4.pen + _loc_16 * _loc_16;
                _loc_9 = _loc_10;
            }
            _loc_9 = param2;
            while (_loc_9 != param3)
            {
                
                _loc_10 = this.mod((_loc_9 + 1), _loc_8);
                _loc_27 = this.tangent(_loc_19, _loc_20, _loc_21, _loc_22, param1.curves.controlPoints[_loc_9][2], param1.curves.controlPoints[_loc_10][2]);
                if (_loc_27 < -0.5)
                {
                    return true;
                }
                _loc_18 = this.bezier(_loc_27, _loc_19, _loc_20, _loc_21, _loc_22);
                _loc_15 = this.ddist(param1.curves.controlPoints[_loc_9][2], param1.curves.controlPoints[_loc_10][2]);
                if (_loc_15 == 0)
                {
                    return true;
                }
                _loc_16 = this.dpara(param1.curves.controlPoints[_loc_9][2], param1.curves.controlPoints[_loc_10][2], _loc_18) / _loc_15;
                _loc_17 = this.dpara(param1.curves.controlPoints[_loc_9][2], param1.curves.controlPoints[_loc_10][2], param1.curves.vertex[_loc_10]) / _loc_15;
                _loc_17 = _loc_17 * (0.75 * param1.curves.alpha[_loc_10]);
                if (_loc_17 < 0)
                {
                    _loc_16 = -_loc_16;
                    _loc_17 = -_loc_17;
                }
                if (_loc_16 < _loc_17 - param5)
                {
                    return true;
                }
                if (_loc_16 < _loc_17)
                {
                    param4.pen = param4.pen + (_loc_16 - _loc_17) * (_loc_16 - _loc_17);
                }
                _loc_9 = _loc_10;
            }
            return false;
        }// end function

        private function pathlist_to_curvearrayslist(param1:Array) : Array
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = 0;
            var _loc_2:* = [];
            var _loc_3:* = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_4 = param1[_loc_3] as Array;
                _loc_5 = [];
                _loc_2.push(_loc_5);
                _loc_6 = 0;
                while (_loc_6 < _loc_4.length)
                {
                    
                    _loc_7 = _loc_4[_loc_6] as Path;
                    _loc_8 = _loc_7.curves.controlPoints[(_loc_7.curves.n - 1)][2];
                    _loc_9 = [];
                    _loc_10 = 0;
                    while (_loc_10 < _loc_7.curves.n)
                    {
                        
                        _loc_11 = _loc_7.curves.controlPoints[_loc_10][0];
                        _loc_12 = _loc_7.curves.controlPoints[_loc_10][1];
                        _loc_13 = _loc_7.curves.controlPoints[_loc_10][2];
                        if (_loc_7.curves.tag[_loc_10] == POTRACE_CORNER)
                        {
                            this.add_curve(_loc_9, _loc_8, _loc_8, _loc_12, _loc_12);
                            this.add_curve(_loc_9, _loc_12, _loc_12, _loc_13, _loc_13);
                        }
                        else
                        {
                            this.add_curve(_loc_9, _loc_8, _loc_11, _loc_12, _loc_13);
                        }
                        _loc_8 = _loc_13;
                        _loc_10++;
                    }
                    if (_loc_9.length > 0)
                    {
                        _loc_14 = _loc_9[(_loc_9.length - 1)] as Curve;
                        _loc_15 = _loc_9[0] as Curve;
                        if (_loc_14.kind == CurveKind.LINE && _loc_15.kind == CurveKind.LINE && this.iprod(_loc_14.b, _loc_14.a, _loc_15.b) < 0 && Math.abs(this.xprodf(new Point(_loc_15.b.x - _loc_15.a.x, _loc_15.b.y - _loc_15.a.y), new Point(_loc_14.a.x - _loc_14.a.x, _loc_14.b.y - _loc_14.a.y))) < 0.01)
                        {
                            _loc_9[0] = new Curve(CurveKind.LINE, _loc_14.a, _loc_14.a, _loc_14.a, _loc_15.b);
                            _loc_9.pop();
                        }
                        _loc_16 = [];
                        _loc_17 = 0;
                        while (_loc_17 < _loc_9.length)
                        {
                            
                            _loc_16.push(_loc_9[_loc_17]);
                            _loc_17++;
                        }
                        _loc_5.push(_loc_16);
                    }
                    _loc_6++;
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        private function add_curve(param1:Array, param2:Point, param3:Point, param4:Point, param5:Point) : void
        {
            var _loc_6:* = 0;
            var _loc_7:* = null;
            if (Math.abs(this.xprodf(new Point(param3.x - param2.x, param3.y - param2.y), new Point(param5.x - param2.x, param5.y - param2.y))) < 0.01 && Math.abs(this.xprodf(new Point(param4.x - param5.x, param4.y - param5.y), new Point(param5.x - param2.x, param5.y - param2.y))) < 0.01)
            {
                _loc_6 = CurveKind.LINE;
            }
            else
            {
                _loc_6 = CurveKind.BEZIER;
            }
            if (_loc_6 == CurveKind.LINE)
            {
                if (param1.length > 0 && Curve(param1[(param1.length - 1)]).kind == CurveKind.LINE)
                {
                    _loc_7 = param1[(param1.length - 1)] as Curve;
                    if (Math.abs(this.xprodf(new Point(_loc_7.b.x - _loc_7.a.x, _loc_7.b.y - _loc_7.a.y), new Point(param5.x - param2.x, param5.y - param2.y))) < 0.01 && this.iprod(_loc_7.b, _loc_7.a, param5) < 0)
                    {
                        param1[(param1.length - 1)] = new Curve(_loc_6, _loc_7.a, _loc_7.a, _loc_7.a, param5);
                    }
                    else
                    {
                        param1.push(new Curve(CurveKind.LINE, param2, param3, param4, param5));
                    }
                }
                else
                {
                    param1.push(new Curve(CurveKind.LINE, param2, param3, param4, param5));
                }
            }
            else
            {
                param1.push(new Curve(CurveKind.BEZIER, param2, param3, param4, param5));
            }
            return;
        }// end function

        private function dorth_infty(param1:Point, param2:Point) : PointInt
        {
            return new PointInt(-this.sign(param2.y - param1.y), this.sign(param2.x - param1.x));
        }// end function

        private function dpara(param1:Point, param2:Point, param3:Point) : Number
        {
            return (param2.x - param1.x) * (param3.y - param1.y) - (param3.x - param1.x) * (param2.y - param1.y);
        }// end function

        private function ddenom(param1:Point, param2:Point) : Number
        {
            var _loc_3:* = this.dorth_infty(param1, param2);
            return _loc_3.y * (param2.x - param1.x) - _loc_3.x * (param2.y - param1.y);
        }// end function

        private function cyclic(param1:int, param2:int, param3:int) : Boolean
        {
            if (param1 <= param3)
            {
                return param1 <= param2 && param2 < param3;
            }
            return param1 <= param2 || param2 < param3;
        }// end function

        private function pointslope(param1:Path, param2:int, param3:int, param4:Point, param5:Point) : void
        {
            var _loc_8:* = NaN;
            var _loc_6:* = param1.pt.length;
            var _loc_7:* = param1.sums;
            var _loc_9:* = 0;
            while (param3 >= _loc_6)
            {
                
                param3 = param3 - _loc_6;
                _loc_9++;
            }
            while (param2 >= _loc_6)
            {
                
                param2 = param2 - _loc_6;
                _loc_9 = _loc_9 - 1;
            }
            while (param3 < 0)
            {
                
                param3 = param3 + _loc_6;
                _loc_9 = _loc_9 - 1;
            }
            while (param2 < 0)
            {
                
                param2 = param2 + _loc_6;
                _loc_9++;
            }
            var _loc_10:* = _loc_7[(param3 + 1)].x - _loc_7[param2].x + _loc_9 * _loc_7[_loc_6].x;
            var _loc_11:* = _loc_7[(param3 + 1)].y - _loc_7[param2].y + _loc_9 * _loc_7[_loc_6].y;
            var _loc_12:* = _loc_7[(param3 + 1)].x2 - _loc_7[param2].x2 + _loc_9 * _loc_7[_loc_6].x2;
            var _loc_13:* = _loc_7[(param3 + 1)].xy - _loc_7[param2].xy + _loc_9 * _loc_7[_loc_6].xy;
            var _loc_14:* = _loc_7[(param3 + 1)].y2 - _loc_7[param2].y2 + _loc_9 * _loc_7[_loc_6].y2;
            var _loc_15:* = (param3 + 1) - param2 + _loc_9 * _loc_6;
            param4.x = _loc_10 / _loc_15;
            param4.y = _loc_11 / _loc_15;
            var _loc_16:* = (_loc_12 - _loc_10 * _loc_10 / _loc_15) / _loc_15;
            var _loc_17:* = (_loc_13 - _loc_10 * _loc_11 / _loc_15) / _loc_15;
            var _loc_18:* = (_loc_14 - _loc_11 * _loc_11 / _loc_15) / _loc_15;
            var _loc_19:* = (_loc_16 + _loc_18 + Math.sqrt((_loc_16 - _loc_18) * (_loc_16 - _loc_18) + 4 * _loc_17 * _loc_17)) / 2;
            _loc_16 = _loc_16 - _loc_19;
            _loc_18 = _loc_18 - _loc_19;
            if (Math.abs(_loc_16) >= Math.abs(_loc_18))
            {
                _loc_8 = Math.sqrt(_loc_16 * _loc_16 + _loc_17 * _loc_17);
                if (_loc_8 != 0)
                {
                    param5.x = (-_loc_17) / _loc_8;
                    param5.y = _loc_16 / _loc_8;
                }
            }
            else
            {
                _loc_8 = Math.sqrt(_loc_18 * _loc_18 + _loc_17 * _loc_17);
                if (_loc_8 != 0)
                {
                    param5.x = (-_loc_18) / _loc_8;
                    param5.y = _loc_17 / _loc_8;
                }
            }
            if (_loc_8 == 0)
            {
                var _loc_20:* = 0;
                param5.y = 0;
                param5.x = _loc_20;
            }
            return;
        }// end function

        private function quadform(param1:Vector.<Vector.<Number>>, param2:Point) : Number
        {
            var _loc_6:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = new Vector.<Number>(3);
            _loc_4[0] = param2.x;
            _loc_4[1] = param2.y;
            _loc_4[2] = 1;
            var _loc_5:* = 0;
            while (_loc_5 < 3)
            {
                
                _loc_6 = 0;
                while (_loc_6 < 3)
                {
                    
                    _loc_3 = _loc_3 + _loc_4[_loc_5] * param1[_loc_5][_loc_6] * _loc_4[_loc_6];
                    _loc_6++;
                }
                _loc_5++;
            }
            return _loc_3;
        }// end function

        private function bezier(param1:Number, param2:Point, param3:Point, param4:Point, param5:Point) : Point
        {
            var _loc_6:* = 1 - param1;
            var _loc_7:* = new Point();
            _loc_7.x = _loc_6 * _loc_6 * _loc_6 * param2.x + 3 * (_loc_6 * _loc_6 * param1) * param3.x + 3 * (param1 * param1 * _loc_6) * param4.x + param1 * param1 * param1 * param5.x;
            _loc_7.y = _loc_6 * _loc_6 * _loc_6 * param2.y + 3 * (_loc_6 * _loc_6 * param1) * param3.y + 3 * (param1 * param1 * _loc_6) * param4.y + param1 * param1 * param1 * param5.y;
            return _loc_7;
        }// end function

        private function tangent(param1:Point, param2:Point, param3:Point, param4:Point, param5:Point, param6:Point) : Number
        {
            var _loc_7:* = this.cprod(param1, param2, param5, param6);
            var _loc_8:* = this.cprod(param2, param3, param5, param6);
            var _loc_9:* = this.cprod(param3, param4, param5, param6);
            var _loc_10:* = _loc_7 - 2 * _loc_8 + _loc_9;
            var _loc_11:* = -2 * _loc_7 + 2 * _loc_8;
            var _loc_12:* = _loc_7;
            var _loc_13:* = _loc_11 * _loc_11 - 4 * _loc_10 * _loc_12;
            if (_loc_10 == 0 || _loc_13 < 0)
            {
                return -1;
            }
            var _loc_14:* = Math.sqrt(_loc_13);
            var _loc_15:* = (-_loc_11 + _loc_14) / (2 * _loc_10);
            var _loc_16:* = (-_loc_11 - _loc_14) / (2 * _loc_10);
            if (_loc_15 >= 0 && _loc_15 <= 1)
            {
                return _loc_15;
            }
            if (_loc_16 >= 0 && _loc_16 <= 1)
            {
                return _loc_16;
            }
            return -1;
        }// end function

        private function ddist(param1:Point, param2:Point) : Number
        {
            return Math.sqrt((param1.x - param2.x) * (param1.x - param2.x) + (param1.y - param2.y) * (param1.y - param2.y));
        }// end function

        private function xprod(param1:PointInt, param2:PointInt) : int
        {
            return param1.x * param2.y - param1.y * param2.x;
        }// end function

        private function xprodf(param1:Point, param2:Point) : int
        {
            return param1.x * param2.y - param1.y * param2.x;
        }// end function

        private function cprod(param1:Point, param2:Point, param3:Point, param4:Point) : Number
        {
            return (param2.x - param1.x) * (param4.y - param3.y) - (param4.x - param3.x) * (param2.y - param1.y);
        }// end function

        private function iprod(param1:Point, param2:Point, param3:Point) : Number
        {
            return (param2.x - param1.x) * (param3.x - param1.x) + (param2.y - param1.y) * (param3.y - param1.y);
        }// end function

        private function iprod1(param1:Point, param2:Point, param3:Point, param4:Point) : Number
        {
            return (param2.x - param1.x) * (param4.x - param3.x) + (param2.y - param1.y) * (param4.y - param3.y);
        }// end function

        private function interval(param1:Number, param2:Point, param3:Point) : Point
        {
            return new Point(param2.x + param1 * (param3.x - param2.x), param2.y + param1 * (param3.y - param2.y));
        }// end function

        private function abs(param1:int) : int
        {
            return param1 > 0 ? (param1) : (-param1);
        }// end function

        private function floordiv(param1:int, param2:int) : int
        {
            return param1 >= 0 ? (param1 / param2) : (-1 - (-1 - param1) / param2);
        }// end function

        private function min(param1:int, param2:int) : int
        {
            return param1 < param2 ? (param1) : (param2);
        }// end function

        private function mod(param1:int, param2:int) : int
        {
            return param1 >= param2 ? (param1 % param2) : (param1 >= 0 ? (param1) : ((param2 - 1) - (-1 - param1) % param2));
        }// end function

        private function sign(param1:int) : int
        {
            return param1 > 0 ? (1) : (param1 < 0 ? (-1) : (0));
        }// end function

    }
}
