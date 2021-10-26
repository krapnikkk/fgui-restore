package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.tween.*;

    public class FTransitionItem extends Object
    {
        private var _frame:int;
        private var _targetId:String;
        private var _type:String;
        private var _tween:Boolean;
        private var _usePath:Boolean;
        private var _pathPoints:Vector.<GPathPoint>;
        private var _path:GPath;
        private var _pathDirty:Boolean;
        public var easeType:String;
        public var easeInOutType:String;
        public var repeat:int;
        public var yoyo:Boolean;
        public var label:String;
        public var value:FTransitionValue;
        public var tweenValue:FTransitionValue;
        public var pathOffsetX:Number;
        public var pathOffsetY:Number;
        public var target:FObject;
        public var owner:FTransition;
        public var tweener:GTweener;
        public var innerTrans:FTransition;
        public var nextItem:FTransitionItem;
        public var prevItem:FTransitionItem;
        public var displayLockToken:uint;

        public function FTransitionItem(param1:FTransition)
        {
            this.owner = param1;
            this.easeType = "Quad";
            this.easeInOutType = "Out";
            this.value = new FTransitionValue();
            this.tweenValue = new FTransitionValue();
            return;
        }// end function

        public function get type() : String
        {
            return this._type;
        }// end function

        public function set type(param1:String) : void
        {
            this._type = param1;
            this.owner._orderDirty = true;
            return;
        }// end function

        public function get targetId() : String
        {
            return this._targetId;
        }// end function

        public function set targetId(param1:String) : void
        {
            this._targetId = param1;
            this.owner._orderDirty = true;
            return;
        }// end function

        public function get frame() : int
        {
            return this._frame;
        }// end function

        public function set frame(param1:int) : void
        {
            this._frame = param1;
            this.owner._orderDirty = true;
            return;
        }// end function

        public function get tween() : Boolean
        {
            return this._tween;
        }// end function

        public function set tween(param1:Boolean) : void
        {
            this._tween = param1;
            this.owner._orderDirty = true;
            return;
        }// end function

        public function get easeName() : String
        {
            if (this.easeType == "Linear")
            {
                return this.easeType;
            }
            return this.easeType + "." + this.easeInOutType;
        }// end function

        public function get usePath() : Boolean
        {
            return this._usePath;
        }// end function

        public function set usePath(param1:Boolean) : void
        {
            this._usePath = param1;
            if (!this._usePath)
            {
                return;
            }
            if (!this._pathPoints)
            {
                this._pathPoints = new Vector.<GPathPoint>;
            }
            if (!this._path)
            {
                this._path = new GPath();
            }
            if (this._pathPoints.length < 2)
            {
                this._pathPoints.push(this.generateOrigin());
                this._pathPoints.push(GPathPoint.newCubicBezierPoint(0, 0));
            }
            this._pathDirty = true;
            return;
        }// end function

        public function get path() : GPath
        {
            return this._path;
        }// end function

        public function get pathPoints() : Vector.<GPathPoint>
        {
            return this._pathPoints;
        }// end function

        public function set pathPoints(param1:Vector.<GPathPoint>) : void
        {
            this._pathPoints = param1;
            this._pathDirty = true;
            return;
        }// end function

        public function setPathToTweener() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            this.pathOffsetX = this.tweener.startValue.x;
            this.pathOffsetY = this.tweener.startValue.y;
            if (this.nextItem)
            {
                _loc_1 = this._pathPoints[(this._pathPoints.length - 1)];
                if (this.nextItem.value.b1)
                {
                    _loc_2 = this.nextItem.value.f1 - this.pathOffsetX;
                }
                else
                {
                    _loc_2 = 0;
                }
                if (this.nextItem.value.b2)
                {
                    _loc_3 = this.nextItem.value.f2 - this.pathOffsetY;
                }
                else
                {
                    _loc_3 = 0;
                }
                if (_loc_2 != _loc_1.x || _loc_3 != _loc_1.y || this._pathDirty)
                {
                    _loc_1.x = _loc_2;
                    _loc_1.y = _loc_3;
                    this._pathDirty = false;
                    this._path.create(this._pathPoints);
                }
            }
            this.tweener.setPath(this._path);
            return;
        }// end function

        private function generateOrigin() : GPathPoint
        {
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_1:* = GPathPoint.newCubicBezierPoint();
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            if (this.nextItem)
            {
                if (this.nextItem.value.b1)
                {
                    _loc_2 = this.nextItem.value.f1 - this.value.f1;
                }
                if (this.nextItem.value.b2)
                {
                    _loc_3 = this.nextItem.value.f2 - this.value.f2;
                }
                if (_loc_2 == 0 && _loc_3 == 0)
                {
                    _loc_4 = Math.PI / 4;
                }
                else
                {
                    _loc_4 = Math.acos(_loc_2 / Math.sqrt(Math.pow(_loc_2, 2) + Math.pow(_loc_3, 2)));
                }
                _loc_5 = 50;
                _loc_6 = _loc_4 + Math.PI / 6;
                _loc_7 = Math.PI + _loc_4 - Math.PI / 6;
                _loc_1.control1_x = Math.floor(_loc_5 * Math.cos(_loc_6));
                _loc_1.control1_y = Math.floor(_loc_5 * Math.sin(_loc_6));
                _loc_1.control2_x = Math.floor(_loc_2 + _loc_5 * Math.cos(_loc_7));
                _loc_1.control2_y = Math.floor(_loc_3 + _loc_5 * Math.sin(_loc_7));
            }
            else
            {
                _loc_1.control1_x = 50;
                _loc_1.control1_x = 50;
                _loc_1.control2_x = 100;
                _loc_1.control2_y = 100;
            }
            return _loc_1;
        }// end function

        public function addPathPoint(param1:Number, param2:Number, param3:Boolean) : void
        {
            var _loc_6:* = 0;
            var _loc_11:* = 0;
            var _loc_4:* = GPathPoint.newCubicBezierPoint(param1, param2);
            var _loc_5:* = this._pathPoints.length;
            if (param3)
            {
                _loc_11 = this._path.findSegmentNear(param1, param2);
                _loc_6 = _loc_11 + 1;
            }
            else
            {
                _loc_6 = _loc_5 - 1;
            }
            this._pathPoints.splice(_loc_6, 0, _loc_4);
            var _loc_7:* = this._pathPoints[(_loc_6 - 1)];
            var _loc_8:* = this._pathPoints[(_loc_6 + 1)];
            var _loc_9:* = Math.sqrt(Math.pow(_loc_8.x - _loc_7.x, 2) + Math.pow(_loc_8.y - _loc_7.y, 2));
            if (Math.sqrt(Math.pow(_loc_8.x - _loc_7.x, 2) + Math.pow(_loc_8.y - _loc_7.y, 2)) == 0)
            {
                _loc_9 = 50;
            }
            var _loc_10:* = 50;
            _loc_4.control2_x = _loc_7.control2_x;
            _loc_4.control2_y = _loc_7.control2_y;
            _loc_7.control2_x = _loc_4.x - _loc_10 * (_loc_8.x - _loc_7.x) / _loc_9;
            _loc_7.control2_y = _loc_4.y + _loc_10 * (_loc_7.y - _loc_8.y) / _loc_9;
            _loc_4.control1_x = _loc_4.x + _loc_10 * (_loc_8.x - _loc_7.x) / _loc_9;
            _loc_4.control1_y = _loc_4.y - _loc_10 * (_loc_7.y - _loc_8.y) / _loc_9;
            this._pathDirty = true;
            return;
        }// end function

        public function removePathPoint(param1:int) : void
        {
            if (param1 == 0 || param1 == (this._pathPoints.length - 1))
            {
                throw new Error("cannot remove end point");
            }
            var _loc_2:* = this._pathPoints[param1];
            var _loc_3:* = this._pathPoints[(param1 - 1)];
            if (_loc_2.curveType == CurveType.CubicBezier && _loc_3.curveType == CurveType.CubicBezier)
            {
                _loc_3.control2_x = _loc_2.control2_x;
                _loc_3.control2_y = _loc_2.control2_y;
            }
            this._pathPoints.splice(param1, 1);
            this._pathDirty = true;
            return;
        }// end function

        public function updatePathPoint(param1:int, param2:Number, param3:Number) : void
        {
            var _loc_7:* = null;
            var _loc_4:* = this._pathPoints[param1];
            var _loc_5:* = param2 - _loc_4.x;
            var _loc_6:* = param3 - _loc_4.y;
            _loc_4.x = param2;
            _loc_4.y = param3;
            _loc_4.control1_x = _loc_4.control1_x + _loc_5;
            _loc_4.control1_y = _loc_4.control1_y + _loc_6;
            if (param1 != 0)
            {
                _loc_7 = this._pathPoints[(param1 - 1)];
                if (_loc_7.curveType == CurveType.CubicBezier)
                {
                    _loc_7.control2_x = _loc_7.control2_x + _loc_5;
                    _loc_7.control2_y = _loc_7.control2_y + _loc_6;
                }
            }
            this._pathDirty = true;
            return;
        }// end function

        public function updateControlPoint(param1:int, param2:int, param3:Number, param4:Number) : void
        {
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_5:* = this._pathPoints[param1];
            if (param2 == 0)
            {
                _loc_5.control1_x = param3;
                _loc_5.control1_y = param4;
                if (param1 != 0)
                {
                    _loc_8 = this._pathPoints[(param1 - 1)];
                    if (_loc_8.curveType == CurveType.CubicBezier && _loc_5.smooth)
                    {
                        _loc_6 = Math.sqrt(Math.pow(_loc_8.control2_x - _loc_5.x, 2) + Math.pow(_loc_8.control2_y - _loc_5.y, 2));
                        _loc_7 = Math.sqrt(Math.pow(_loc_5.control1_x - _loc_5.x, 2) + Math.pow(_loc_5.control1_y - _loc_5.y, 2));
                        if (_loc_7 != 0)
                        {
                            _loc_8.control2_x = _loc_5.x - _loc_6 * (_loc_5.control1_x - _loc_5.x) / _loc_7;
                            _loc_8.control2_y = _loc_5.y - _loc_6 * (_loc_5.control1_y - _loc_5.y) / _loc_7;
                        }
                    }
                }
            }
            else
            {
                _loc_5.control2_x = param3;
                _loc_5.control2_y = param4;
                if (param1 < (this._pathPoints.length - 1))
                {
                    _loc_9 = this._pathPoints[(param1 + 1)];
                    if (_loc_9.curveType == CurveType.CubicBezier && _loc_9.smooth)
                    {
                        _loc_6 = Math.sqrt(Math.pow(_loc_9.control1_x - _loc_9.x, 2) + Math.pow(_loc_9.control1_y - _loc_9.y, 2));
                        _loc_7 = Math.sqrt(Math.pow(_loc_5.control2_x - _loc_9.x, 2) + Math.pow(_loc_5.control2_y - _loc_9.y, 2));
                        if (_loc_7 != 0)
                        {
                            _loc_9.control1_x = _loc_9.x - _loc_6 * (_loc_5.control2_x - _loc_9.x) / _loc_7;
                            _loc_9.control1_y = _loc_9.y - _loc_6 * (_loc_5.control2_y - _loc_9.y) / _loc_7;
                        }
                    }
                }
            }
            this._pathDirty = true;
            return;
        }// end function

        public function get pathData() : String
        {
            var _loc_4:* = null;
            var _loc_1:* = this._pathPoints.length;
            var _loc_2:* = [];
            var _loc_3:* = 0;
            while (_loc_3 < _loc_1)
            {
                
                _loc_4 = this._pathPoints[_loc_3];
                if (_loc_3 == (_loc_1 - 1))
                {
                    if (this.nextItem.value.b1)
                    {
                        _loc_4.x = this.nextItem.value.f1 - this.value.f1;
                    }
                    else
                    {
                        _loc_4.x = 0;
                    }
                    if (this.nextItem.value.b2)
                    {
                        _loc_4.y = this.nextItem.value.f2 - this.value.f2;
                    }
                    else
                    {
                        _loc_4.y = 0;
                    }
                }
                _loc_2.push(_loc_4.toString());
                _loc_3++;
            }
            return _loc_2.join(",");
        }// end function

        public function set pathData(param1:String) : void
        {
            var _loc_5:* = null;
            var _loc_2:* = param1.split(",");
            if (_loc_2.length == 0)
            {
                return;
            }
            this._usePath = true;
            this._pathPoints = new Vector.<GPathPoint>;
            this._path = new GPath();
            var _loc_3:* = _loc_2.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = new GPathPoint();
                _loc_5.curveType = parseInt(_loc_2[_loc_4++]);
                switch(_loc_5.curveType)
                {
                    case CurveType.Bezier:
                    {
                        _loc_5.x = parseInt(_loc_2[_loc_4++]);
                        _loc_5.y = parseInt(_loc_2[_loc_4++]);
                        _loc_5.control1_x = parseInt(_loc_2[_loc_4++]);
                        _loc_5.control1_y = parseInt(_loc_2[_loc_4++]);
                        break;
                    }
                    case CurveType.CubicBezier:
                    {
                        _loc_5.x = parseInt(_loc_2[_loc_4++]);
                        _loc_5.y = parseInt(_loc_2[_loc_4++]);
                        _loc_5.control1_x = parseInt(_loc_2[_loc_4++]);
                        _loc_5.control1_y = parseInt(_loc_2[_loc_4++]);
                        _loc_5.control2_x = parseInt(_loc_2[_loc_4++]);
                        _loc_5.control2_y = parseInt(_loc_2[_loc_4++]);
                        _loc_5.smooth = _loc_2[_loc_4++] == "1";
                        break;
                    }
                    default:
                    {
                        _loc_5.x = parseInt(_loc_2[_loc_4++]);
                        _loc_5.y = parseInt(_loc_2[_loc_4++]);
                        break;
                        break;
                    }
                }
                this._pathPoints.push(_loc_5);
            }
            this._pathDirty = true;
            return;
        }// end function

        public function get encodedValue() : String
        {
            return this.value.encode(this._type);
        }// end function

        public function set encodedValue(param1:String) : void
        {
            this.value.decode(this._type, param1);
            return;
        }// end function

    }
}
