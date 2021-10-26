package fairygui.tween
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.utils.*;
    import flash.geom.*;

    public class GPath extends Object
    {
        private var _segments:Vector.<Segment>;
        private var _points:PointList;
        private var _fullLength:Number;
        private static var helperList:Vector.<GPathPoint> = new Vector.<GPathPoint>;
        private static var helperPoints:PointList = new PointList();
        private static var helperPoint:Point = new Point();

        public function GPath()
        {
            _segments = new Vector.<Segment>;
            _points = new PointList();
            return;
        }// end function

        public function get length() : Number
        {
            return _fullLength;
        }// end function

        public function create2(param1:GPathPoint, param2:GPathPoint, param3:GPathPoint = null, param4:GPathPoint = null) : void
        {
            helperList.length = 0;
            helperList.push(param1);
            helperList.push(param2);
            if (param3)
            {
                helperList.push(param3);
            }
            if (param4)
            {
                helperList.push(param4);
            }
            create(helperList);
            return;
        }// end function

        public function create(param1:Vector.<GPathPoint>) : void
        {
            var _loc_6:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = null;
            _segments.length = 0;
            _points.length = 0;
            helperPoints.length = 0;
            _fullLength = 0;
            var _loc_5:* = param1.length;
            if (param1.length == 0)
            {
                return;
            }
            var _loc_4:* = param1[0];
            if (_loc_4.curveType == 0)
            {
                helperPoints.push(_loc_4.x, _loc_4.y);
            }
            _loc_6 = 1;
            while (_loc_6 < _loc_5)
            {
                
                _loc_2 = param1[_loc_6];
                if (_loc_4.curveType != 0)
                {
                    _loc_3 = new Segment();
                    _loc_3.type = _loc_4.curveType;
                    _loc_3.ptStart = _points.length;
                    if (_loc_4.curveType == 3)
                    {
                        _loc_3.ptCount = 2;
                        _points.push(_loc_4.x, _loc_4.y);
                        _points.push(_loc_2.x, _loc_2.y);
                    }
                    else if (_loc_4.curveType == 1)
                    {
                        _loc_3.ptCount = 3;
                        _points.push(_loc_4.x, _loc_4.y);
                        _points.push(_loc_2.x, _loc_2.y);
                        _points.push(_loc_4.control1_x, _loc_4.control1_y);
                    }
                    else if (_loc_4.curveType == 2)
                    {
                        _loc_3.ptCount = 4;
                        _points.push(_loc_4.x, _loc_4.y);
                        _points.push(_loc_2.x, _loc_2.y);
                        _points.push(_loc_4.control1_x, _loc_4.control1_y);
                        _points.push(_loc_4.control2_x, _loc_4.control2_y);
                    }
                    _loc_3.length = ToolSet.distance(_loc_4.x, _loc_4.y, _loc_2.x, _loc_2.y);
                    _fullLength = _fullLength + _loc_3.length;
                    _segments.push(_loc_3);
                }
                if (_loc_2.curveType != 0)
                {
                    if (helperPoints.length > 0)
                    {
                        helperPoints.push(_loc_2.x, _loc_2.y);
                        createSplineSegment();
                    }
                }
                else
                {
                    helperPoints.push(_loc_2.x, _loc_2.y);
                }
                _loc_4 = _loc_2;
                _loc_6++;
            }
            if (helperPoints.length > 1)
            {
                createSplineSegment();
            }
            return;
        }// end function

        private function createSplineSegment() : void
        {
            var _loc_3:* = 0;
            var _loc_2:* = helperPoints.length;
            helperPoints.insert3(0, helperPoints, 0);
            helperPoints.push3(helperPoints, _loc_2);
            helperPoints.push3(helperPoints, _loc_2);
            _loc_2 = _loc_2 + 3;
            var _loc_1:* = new Segment();
            _loc_1.type = 0;
            _loc_1.ptStart = _points.length;
            _loc_1.ptCount = _loc_2;
            _points.addRange(helperPoints);
            _loc_1.length = 0;
            _loc_3 = 1;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1.length = _loc_1.length + ToolSet.distance(helperPoints.get_x((_loc_3 - 1)), helperPoints.get_y((_loc_3 - 1)), helperPoints.get_x(_loc_3), helperPoints.get_y(_loc_3));
                _loc_3++;
            }
            _fullLength = _fullLength + _loc_1.length;
            _segments.push(_loc_1);
            helperPoints.length = 0;
            return;
        }// end function

        public function clear() : void
        {
            _segments.length = 0;
            _points.length = 0;
            return;
        }// end function

        public function getPointAt(param1:Number, param2:Point = null) : Point
        {
            var _loc_3:* = null;
            var _loc_6:* = 0;
            if (param2 == null)
            {
                param2 = new Point();
            }
            else
            {
                param2.setTo(0, 0);
            }
            param1 = ToolSet.clamp01(param1);
            var _loc_5:* = _segments.length;
            if (_segments.length == 0)
            {
                return param2;
            }
            if (param1 == 1)
            {
                _loc_3 = _segments[(_loc_5 - 1)];
                if (_loc_3.type == 3)
                {
                    param2.x = ToolSet.lerp(_points.get_x(_loc_3.ptStart), _points.get_x((_loc_3.ptStart + 1)), param1);
                    param2.y = ToolSet.lerp(_points.get_y(_loc_3.ptStart), _points.get_y((_loc_3.ptStart + 1)), param1);
                    return param2;
                }
                if (_loc_3.type == 1 || _loc_3.type == 2)
                {
                    return onBezierCurve(_loc_3.ptStart, _loc_3.ptCount, param1, param2);
                }
                return onCRSplineCurve(_loc_3.ptStart, _loc_3.ptCount, param1, param2);
            }
            var _loc_4:* = param1 * _fullLength;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_3 = _segments[_loc_6];
                _loc_4 = _loc_4 - _loc_3.length;
                if (_loc_4 < 0)
                {
                    param1 = 1 + _loc_4 / _loc_3.length;
                    if (_loc_3.type == 3)
                    {
                        param2.x = ToolSet.lerp(_points.get_x(_loc_3.ptStart), _points.get_x((_loc_3.ptStart + 1)), param1);
                        param2.y = ToolSet.lerp(_points.get_y(_loc_3.ptStart), _points.get_y((_loc_3.ptStart + 1)), param1);
                    }
                    else if (_loc_3.type == 1 || _loc_3.type == 2)
                    {
                        param2 = onBezierCurve(_loc_3.ptStart, _loc_3.ptCount, param1, param2);
                    }
                    else
                    {
                        param2 = onCRSplineCurve(_loc_3.ptStart, _loc_3.ptCount, param1, param2);
                    }
                    break;
                }
                _loc_6++;
            }
            return param2;
        }// end function

        public function get segmentCount() : int
        {
            return _segments.length;
        }// end function

        public function getSegment(param1:int) : Object
        {
            return _segments[param1];
        }// end function

        public function getAnchorsInSegment(param1:int, param2:PointList = null) : PointList
        {
            var _loc_4:* = 0;
            if (param2 == null)
            {
                param2 = new PointList();
            }
            var _loc_3:* = _segments[param1];
            _loc_4 = 0;
            while (_loc_4 < _loc_3.ptCount)
            {
                
                param2.push3(_points, _loc_3.ptStart + _loc_4);
                _loc_4++;
            }
            return param2;
        }// end function

        public function getPointsInSegment(param1:int, param2:Number, param3:Number, param4:PointList = null, param5:Vector.<Number> = null, param6:Number = 0.1) : PointList
        {
            var _loc_8:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_9:* = NaN;
            if (param4 == null)
            {
                param4 = new PointList();
            }
            if (param5 != null)
            {
                param5.push(param2);
            }
            var _loc_7:* = _segments[param1];
            if (_loc_7.type == 3)
            {
                param4.push(ToolSet.lerp(_points.get_x(_loc_7.ptStart), _points.get_x((_loc_7.ptStart + 1)), param2), ToolSet.lerp(_points.get_y(_loc_7.ptStart), _points.get_y((_loc_7.ptStart + 1)), param2));
                param4.push(ToolSet.lerp(_points.get_x(_loc_7.ptStart), _points.get_x((_loc_7.ptStart + 1)), param3), ToolSet.lerp(_points.get_y(_loc_7.ptStart), _points.get_y((_loc_7.ptStart + 1)), param3));
            }
            else
            {
                if (_loc_7.type == 1 || _loc_7.type == 2)
                {
                    _loc_8 = onBezierCurve;
                }
                else
                {
                    _loc_8 = onCRSplineCurve;
                }
                param4.push2(this._loc_8(_loc_7.ptStart, _loc_7.ptCount, param2, helperPoint));
                _loc_10 = Math.min(_loc_7.length * param6, 50);
                _loc_11 = 0;
                while (_loc_11 <= _loc_10)
                {
                    
                    _loc_9 = _loc_11 / _loc_10;
                    if (_loc_9 > param2 && _loc_9 < param3)
                    {
                        param4.push2(this._loc_8(_loc_7.ptStart, _loc_7.ptCount, _loc_9, helperPoint));
                        if (param5 != null)
                        {
                            param5.push(_loc_9);
                        }
                    }
                    _loc_11++;
                }
                param4.push2(this._loc_8(_loc_7.ptStart, _loc_7.ptCount, param3, helperPoint));
            }
            if (param5 != null)
            {
                param5.push(param3);
            }
            return param4;
        }// end function

        public function getAllPoints(param1:PointList = null, param2:Vector.<Number> = null, param3:Number = 0.1) : PointList
        {
            var _loc_5:* = 0;
            if (param1 == null)
            {
                param1 = new PointList();
            }
            var _loc_4:* = _segments.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                getPointsInSegment(_loc_5, 0, 1, param1, param2, param3);
                _loc_5++;
            }
            return param1;
        }// end function

        public function findSegmentNear(param1:Number, param2:Number) : int
        {
            var _loc_7:* = NaN;
            var _loc_8:* = 0;
            var _loc_12:* = null;
            var _loc_14:* = NaN;
            var _loc_13:* = NaN;
            var _loc_16:* = NaN;
            var _loc_15:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_9:* = 0;
            var _loc_6:* = _segments.length;
            var _loc_11:* = 2147483647;
            var _loc_10:* = -1;
            _loc_8 = 0;
            while (_loc_8 < _loc_6)
            {
                
                _loc_12 = _segments[_loc_8];
                if (_loc_12.type == 3)
                {
                    _loc_14 = _points.get_x(_loc_12.ptStart);
                    _loc_13 = _points.get_y(_loc_12.ptStart);
                    _loc_16 = _points.get_x((_loc_12.ptStart + 1));
                    _loc_15 = _points.get_y((_loc_12.ptStart + 1));
                    _loc_3 = _loc_15 - _loc_13;
                    _loc_4 = _loc_14 - _loc_16;
                    _loc_5 = _loc_16 * _loc_13 - _loc_14 * _loc_15;
                    _loc_7 = ToolSet.pointLineDistance(param1, param2, _loc_14, _loc_13, _loc_16, _loc_15, true);
                    if (_loc_7 < _loc_11)
                    {
                        _loc_11 = _loc_7;
                        _loc_10 = _loc_8;
                    }
                }
                else
                {
                    helperPoints.length = 0;
                    getPointsInSegment(_loc_8, 0, 1, helperPoints);
                    _loc_9 = 0;
                    while (_loc_9 < helperPoints.length)
                    {
                        
                        _loc_7 = ToolSet.distance(helperPoints.get_x(_loc_9), helperPoints.get_y(_loc_9), param1, param2);
                        if (_loc_7 < _loc_11)
                        {
                            _loc_11 = _loc_7;
                            _loc_10 = _loc_8;
                        }
                        _loc_9++;
                    }
                }
                _loc_8++;
            }
            return _loc_10;
        }// end function

        private function onCRSplineCurve(param1:int, param2:int, param3:Number, param4:Point) : Point
        {
            var _loc_5:* = Math.floor(param3 * (param2 - 4)) + param1;
            var _loc_13:* = _points.get_x(_loc_5);
            var _loc_12:* = _points.get_y(_loc_5);
            var _loc_8:* = _points.get_x((_loc_5 + 1));
            var _loc_14:* = _points.get_y((_loc_5 + 1));
            var _loc_10:* = _points.get_x(_loc_5 + 2);
            var _loc_9:* = _points.get_y(_loc_5 + 2);
            var _loc_7:* = _points.get_x(_loc_5 + 3);
            var _loc_11:* = _points.get_y(_loc_5 + 3);
            var _loc_6:* = param3 == 1 ? (1) : (ToolSet.repeat(param3 * (param2 - 4), 1));
            var _loc_15:* = ((-(param3 == 1 ? (1) : (ToolSet.repeat(param3 * (param2 - 4), 1))) + 2) * _loc_6 - 1) * _loc_6 * 0.5;
            var _loc_16:* = ((3 * _loc_6 - 5) * _loc_6 * _loc_6 + 2) * 0.5;
            var _loc_17:* = ((-3 * _loc_6 + 4) * _loc_6 + 1) * _loc_6 * 0.5;
            var _loc_18:* = (_loc_6 - 1) * _loc_6 * _loc_6 * 0.5;
            param4.x = _loc_13 * _loc_15 + _loc_8 * _loc_16 + _loc_10 * _loc_17 + _loc_7 * _loc_18;
            param4.y = _loc_12 * _loc_15 + _loc_14 * _loc_16 + _loc_9 * _loc_17 + _loc_11 * _loc_18;
            return param4;
        }// end function

        private function onBezierCurve(param1:int, param2:int, param3:Number, param4:Point) : Point
        {
            var _loc_10:* = NaN;
            var _loc_12:* = NaN;
            var _loc_13:* = 1 - param3;
            var _loc_8:* = _points.get_x(param1);
            var _loc_6:* = _points.get_y(param1);
            var _loc_5:* = _points.get_x((param1 + 1));
            var _loc_9:* = _points.get_y((param1 + 1));
            var _loc_11:* = _points.get_x(param1 + 2);
            var _loc_7:* = _points.get_y(param1 + 2);
            if (param2 == 4)
            {
                _loc_10 = _points.get_x(param1 + 3);
                _loc_12 = _points.get_y(param1 + 3);
                param4.x = _loc_13 * _loc_13 * _loc_13 * _loc_8 + 3 * _loc_13 * _loc_13 * param3 * _loc_11 + 3 * _loc_13 * param3 * param3 * _loc_10 + param3 * param3 * param3 * _loc_5;
                param4.y = _loc_13 * _loc_13 * _loc_13 * _loc_6 + 3 * _loc_13 * _loc_13 * param3 * _loc_7 + 3 * _loc_13 * param3 * param3 * _loc_12 + param3 * param3 * param3 * _loc_9;
            }
            else
            {
                param4.x = _loc_13 * _loc_13 * _loc_8 + 2 * _loc_13 * param3 * _loc_11 + param3 * param3 * _loc_5;
                param4.y = _loc_13 * _loc_13 * _loc_6 + 2 * _loc_13 * param3 * _loc_7 + param3 * param3 * _loc_9;
            }
            return param4;
        }// end function

    }
}

import *.*;

import __AS3__.vec.*;

import fairygui.utils.*;

import flash.geom.*;

class Segment extends Object
{
    public var type:int;
    public var length:Number;
    public var ptStart:int;
    public var ptCount:int;

    function Segment()
    {
        return;
    }// end function

}

