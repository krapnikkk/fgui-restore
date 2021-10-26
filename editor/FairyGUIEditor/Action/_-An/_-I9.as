package _-An
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.tween.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;

    public class _-I9 extends Sprite implements IGizmo
    {
        private var _-1D:IDocument;
        private var _owner:FObject;
        private var _-Lv:Shape;
        private var _title:TextField;
        private var _-Ex:_-Er;
        private var _-Cn:Sprite;
        private var _-Nq:Vector.<_-Jy>;
        private var _-FH:_-9z;
        private var _-1P:_-9z;
        private var _-IZ:_-9z;
        private var _anchor:Sprite;
        private var _-NN:Point;
        private var _-Nd:Point;
        private var _-JY:int;
        private var _-10:int;
        private var _-GJ:int;
        private var _-8:_-Jy;
        private var _-KW:Boolean;
        private var _needRefresh:Boolean;
        private var _-KH:Boolean;
        private var _color:uint;
        private var _-HK:Matrix;
        private var _-Lq:Matrix;
        private var _-9t:Matrix;
        private var _outlineVersion:int;
        private var _-OL:int;
        private var _-La:Number;
        private var _-5F:Number;
        private var _-1O:Number;
        private var _-9k:FTransitionItem;
        var _selected:Boolean;
        private static var helperPoint:Point = new Point();
        private static var helperPoints:Vector.<Point> = new Vector.<Point>(8, true);
        private static var helperPathPoints:PointList = new PointList();
        public static const _-DK:int = 0;
        public static const _-6n:int = 1;
        public static const _-Gp:int = 2;
        public static const _-Du:int = 3;
        public static const _-2:int = 6;
        private static const _-8C:uint = 26367;
        private static const _-61:uint = 48127;
        private static const _-Ln:uint = 1883060;
        private static const _-1u:uint = 16776960;
        private static const _-9E:uint = 65484;
        private static const _-Jc:uint = 3327794;
        private static const _-Nt:uint = 3327794;
        private static const _-7S:uint = 16777215;
        private static const _-JM:Array = [CursorType.TL_RESIZE, CursorType.V_RESIZE, CursorType.TR_RESIZE, CursorType.H_RESIZE, CursorType.BR_RESIZE, CursorType.V_RESIZE, CursorType.BL_RESIZE, CursorType.H_RESIZE];
        private static const _-Fm:int = 30;
        private static const _-JD:int = 10;

        public function _-I9(param1:IDocument, param2:FObject) : void
        {
            var _loc_4:* = null;
            this._-1D = param1;
            this._owner = param2;
            this._-NN = new Point();
            this._-Nd = new Point();
            this._-GJ = 0;
            this._-HK = new Matrix();
            this._-Lq = new Matrix();
            if (param2 is FGroup)
            {
                this._color = _-Ln;
            }
            else if (param2 is FComponent)
            {
                this._color = _-61;
            }
            else
            {
                this._color = _-8C;
            }
            this._-Nq = new Vector.<_-Jy>(8);
            this._-FH = new _-9z(_-6n, _-Jc);
            this._-1P = new _-9z(_-Gp, _-Nt);
            this._-IZ = new _-9z(_-Du, _-7S, 1);
            this._-Ex = new _-Er();
            this._-Ex.owner = this;
            this._-Cn = new Sprite();
            this._-Cn.mouseEnabled = false;
            this._-Ex.addChild(this._-Cn);
            var _loc_3:* = 0;
            while (_loc_3 < 8)
            {
                
                _loc_4 = new _-Jy(_-DK, this._color, 1);
                _loc_4.index = _loc_3;
                this._-Nq[_loc_3] = _loc_4;
                this._-1D.editor.cursorManager.setCursorForObject(_loc_4, _-JM[_loc_3]);
                this._-Cn.addChild(_loc_4);
                _loc_3++;
            }
            if ((this._owner._flags & FObjectFlags.ROOT) != 0)
            {
                _loc_3 = 0;
                while (_loc_3 < 8)
                {
                    
                    this._-Nq[_loc_3].visible = false;
                    _loc_3++;
                }
            }
            this._anchor = this._-j();
            this._-Cn.addChild(this._anchor);
            switch(this._owner._objectType)
            {
                case "graph":
                {
                    if (FGraph(this._owner).type == "empty")
                    {
                        this._-8D(true, "Graph");
                    }
                    this._owner.dispatcher.on(FGraph.TYPE_CHANGED, this._-O5);
                    break;
                }
                case "loader":
                {
                    this._-8D(true, "Loader");
                    break;
                }
                case "list":
                {
                    this._-8D(true, "List");
                    break;
                }
                case "text":
                case "richtext":
                {
                    this._-8D(true, null);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get owner() : FObject
        {
            return this._owner;
        }// end function

        public function get activeHandleIndex() : int
        {
            return this._-8 ? (this._-8.index) : (-1);
        }// end function

        public function get activeHandleType() : int
        {
            return this._-8 ? (this._-8.type) : (-1);
        }// end function

        public function get verticesEditing() : Boolean
        {
            return this._-KW;
        }// end function

        public function get keyFrame() : FTransitionItem
        {
            return this._-9k;
        }// end function

        public function get normalUI() : Sprite
        {
            return this;
        }// end function

        public function get selectedUI() : Sprite
        {
            return this._-Ex;
        }// end function

        public function _-JV() : void
        {
            this._-KW = true;
            this._needRefresh = true;
            FGraph(this._owner).shapeLocked = false;
            return;
        }// end function

        public function editPath(param1:FTransitionItem) : void
        {
            this._-9k = param1;
            this._needRefresh = true;
            if (!this._-9k)
            {
                this._-1P._-K7();
                this._-IZ._-K7();
            }
            return;
        }// end function

        public function editComplete() : void
        {
            if (this._-KW)
            {
                this._-KW = false;
                this._needRefresh = true;
                this._-FH._-K7();
                _-PX(this._owner.docElement).updateGraphBounds();
            }
            if (this._-9k)
            {
                this._-9k = null;
                this._needRefresh = true;
                this._-1P._-K7();
                this._-IZ._-K7();
            }
            return;
        }// end function

        public function refresh(param1:Boolean = false) : void
        {
            this._needRefresh = true;
            if (param1)
            {
                this.onUpdate();
            }
            return;
        }// end function

        private function _-8D(param1:Boolean, param2:String) : void
        {
            if (this._-KH != param1)
            {
                this._-KH = param1;
                if (this._-KH)
                {
                    if (!this._-Lv)
                    {
                        this._-Lv = new Shape();
                        this._-Lv.visible = !this._-Ex.parent;
                    }
                    addChild(this._-Lv);
                    this.drawDashedRect();
                }
                else if (this._-Lv && this._-Lv.parent)
                {
                    removeChild(this._-Lv);
                }
            }
            if (param2)
            {
                if (!this._title)
                {
                    this._-Jo();
                }
                if (!this._title.parent)
                {
                    addChild(this._title);
                }
                this._title.text = param2;
            }
            else if (this._title && this._title.parent)
            {
                removeChild(this._title);
            }
            return;
        }// end function

        private function _-Jo() : void
        {
            this._title = new TextField();
            this._title.defaultTextFormat = new TextFormat(null, 12, 0, null, null, null, null, null, "center");
            this._title.mouseEnabled = false;
            this._title.width = this._owner.width;
            this._title.height = Math.min(20, this._owner.height);
            addChild(this._title);
            return;
        }// end function

        private function drawDashedRect() : void
        {
            var _loc_1:* = this._-Lv.graphics;
            _loc_1.clear();
            var _loc_2:* = this._owner.width;
            var _loc_3:* = this._owner.height;
            if (_loc_2 > 0 && _loc_3 > 0)
            {
                _loc_1.lineStyle(Consts.auxLineSize, 0, 1, true, LineScaleMode.NONE);
                Utils.drawDashedRect(_loc_1, 0, 0, _loc_2, _loc_3, 5);
            }
            return;
        }// end function

        private function _-O5() : void
        {
            if (this._-KW && !FGraph(this._owner).isVerticesEditable)
            {
                this._-KW = false;
                this._-FH._-K7();
                this._needRefresh = true;
            }
            if (this._-KH)
            {
                if (FGraph(this._owner).type != "empty")
                {
                    this._-8D(false, null);
                }
            }
            else if (FGraph(this._owner).type == "empty")
            {
                this._-8D(true, "Graph");
            }
            return;
        }// end function

        public function _-HW(param1:Boolean) : void
        {
            if (this._selected != param1)
            {
                this._selected = param1;
                if (!this._selected)
                {
                    if (this._-Ex.parent)
                    {
                        this._-Ex.parent.removeChild(this._-Ex);
                        this.onRemoved();
                    }
                }
                else if (!this._-Ex.parent)
                {
                    _-On(this._-1D).selectionLayer.addChild(this._-Ex);
                    this.onAdded();
                }
            }
            return;
        }// end function

        public function onUpdate() : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            if (this._owner._parent && this._owner._parent._outlineVersion != this._-OL)
            {
                this._-OL = this._owner.parent._outlineVersion;
                this._outlineVersion = 0;
            }
            if (this._-La != _-On(this._-1D)._docView.viewScale)
            {
                this._-La = _-On(this._-1D)._docView.viewScale;
                this._outlineVersion = 0;
            }
            var _loc_1:* = false;
            if (this._owner._outlineVersion != this._outlineVersion)
            {
                this._outlineVersion = this._owner._outlineVersion;
                _loc_1 = true;
            }
            if (_loc_1)
            {
                _loc_2 = this._owner.width;
                _loc_3 = this._owner.height;
                if (_loc_2 != this._-5F || _loc_3 != this._-1O)
                {
                    this._-5F = _loc_2;
                    this._-1O = _loc_3;
                    if (this._title)
                    {
                        this._title.width = _loc_2;
                        this._title.height = Math.min(20, _loc_3);
                    }
                    if (this._-KH)
                    {
                        this.drawDashedRect();
                    }
                }
                this._needRefresh = true;
            }
            if (!this._selected)
            {
                return;
            }
            if (this._-9k)
            {
                if (!this._-1D.timelineMode || this._-9k.owner != this._-1D.editingTransition || !this._-9k.usePath || this._-9k.frame > this._-1D.head || this._-9k.nextItem && this._-9k.nextItem.frame <= this._-1D.head)
                {
                    this._-9k = null;
                    this._needRefresh = true;
                    this._-1P._-K7();
                    this._-IZ._-K7();
                }
            }
            if (this._needRefresh)
            {
                this._needRefresh = false;
                this._-n();
            }
            return;
        }// end function

        private function _-n() : void
        {
            var _loc_5:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = false;
            var _loc_13:* = false;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_1:* = this._owner.width;
            var _loc_2:* = this._owner.height;
            var _loc_3:* = (this._owner._flags & FObjectFlags.ROOT) == 0;
            if (this._owner.parent)
            {
                this._-9t = this._owner.parent.displayObject.contentMatrix;
            }
            this._-HK.identity();
            this._-HK.concat(this._owner.displayObject.contentMatrix);
            this._-HK.translate(this._owner.displayObject.x, this._owner.displayObject.y);
            if (this._owner.parent)
            {
                this._-HK.concat(this._-9t);
            }
            var _loc_4:* = this._-Dz(0, 0);
            if (_loc_3)
            {
                this._-Ex.x = this._owner.parent.displayObject.x + _loc_4.x;
                this._-Ex.y = this._owner.parent.displayObject.y + _loc_4.y;
            }
            else
            {
                this._-Ex.x = _loc_4.x;
                this._-Ex.y = _loc_4.y;
            }
            this._-HK.translate(-_loc_4.x, -_loc_4.y);
            this._-Lq.copyFrom(this._-HK);
            this._-Lq.invert();
            var _loc_6:* = 1 / this._-La;
            var _loc_7:* = 1 / this._-La;
            var _loc_8:* = -0.5 * _loc_6 / this._owner.scaleX;
            var _loc_9:* = -0.5 * _loc_6 / this._owner.scaleY;
            helperPoints[0] = this._-Dz(_loc_8, _loc_9);
            helperPoints[1] = this._-Dz(_loc_1 / 2, _loc_9);
            helperPoints[2] = this._-Dz(_loc_1 - _loc_8, _loc_9);
            helperPoints[3] = this._-Dz(_loc_1 - _loc_8, _loc_2 / 2);
            helperPoints[4] = this._-Dz(_loc_1 - _loc_8, _loc_2 - _loc_9);
            helperPoints[5] = this._-Dz(_loc_1 / 2, _loc_2 - _loc_9);
            helperPoints[6] = this._-Dz(_loc_8, _loc_2 - _loc_9);
            helperPoints[7] = this._-Dz(_loc_8, _loc_2 / 2);
            var _loc_10:* = this._-Cn.graphics;
            _loc_10.clear();
            if (this._owner.pivotX != 0 || this._owner.pivotY != 0)
            {
                _loc_11 = this._-Dz(_loc_1 * this._owner.pivotX, _loc_2 * this._owner.pivotY);
                this._anchor.x = _loc_11.x;
                this._anchor.y = _loc_11.y;
                var _loc_16:* = _loc_7;
                this._anchor.scaleY = _loc_7;
                this._anchor.scaleX = _loc_16;
                this._anchor.visible = true;
            }
            else
            {
                this._anchor.visible = false;
            }
            if (_loc_3)
            {
                if (this._-KW)
                {
                    _loc_5 = 0;
                    while (_loc_5 < 8)
                    {
                        
                        this._-Nq[_loc_5].visible = false;
                        _loc_5++;
                    }
                    this._-8V(_loc_7);
                }
                else
                {
                    _loc_10.lineStyle(Consts.auxLineSize, this._color, 0.7, true, LineScaleMode.NONE);
                    _loc_10.moveTo(helperPoints[0].x, helperPoints[0].y);
                    _loc_10.lineTo(helperPoints[2].x, helperPoints[2].y);
                    _loc_10.lineTo(helperPoints[4].x, helperPoints[4].y);
                    _loc_10.lineTo(helperPoints[6].x, helperPoints[6].y);
                    _loc_10.lineTo(helperPoints[0].x, helperPoints[0].y);
                    _loc_12 = _loc_1 * this._-La < 32;
                    _loc_13 = _loc_2 * this._-La < 32;
                    _loc_5 = 0;
                    while (_loc_5 < 8)
                    {
                        
                        _loc_14 = this._-Nq[_loc_5];
                        _loc_15 = helperPoints[_loc_5];
                        _loc_14.x = _loc_15.x;
                        _loc_14.y = _loc_15.y;
                        _loc_14.rotation = this._owner.rotation;
                        var _loc_16:* = _loc_7;
                        _loc_14.scaleY = _loc_7;
                        _loc_14.scaleX = _loc_16;
                        _loc_14.visible = true;
                        if ((_loc_5 == 1 || _loc_5 == 5) && _loc_12 || (_loc_5 == 3 || _loc_5 == 7) && _loc_13 || this._anchor.visible && Math.abs(_loc_15.x - this._anchor.x) <= 1 && Math.abs(_loc_15.y - this._anchor.y) <= 1)
                        {
                            _loc_14.alpha = 0;
                        }
                        else
                        {
                            _loc_14.alpha = 1;
                        }
                        _loc_5++;
                    }
                }
            }
            if (this._-9k)
            {
                this.drawPath(_loc_7);
            }
            return;
        }// end function

        private function _-8V(param1:Number) : void
        {
            var _loc_2:* = FGraph(this._owner).polygonPoints;
            var _loc_3:* = _loc_2.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                this._-Ae(this._-FH, _loc_2.get_x(_loc_4), _loc_2.get_y(_loc_4), param1, _loc_4);
                _loc_4++;
            }
            this._-FH._-K7();
            return;
        }// end function

        private function drawPath(param1:Number) : void
        {
            var _loc_9:* = 0;
            var _loc_2:* = this._-Cn.graphics;
            _loc_2.lineStyle(Consts.auxLineSize * 2, _-1u, 0.7, true, LineScaleMode.NONE);
            var _loc_3:* = this._-9k.path;
            var _loc_4:* = _loc_3.segmentCount;
            var _loc_5:* = false;
            var _loc_6:* = this._-9k.pathOffsetX - this._owner.x + this._anchor.x;
            var _loc_7:* = this._-9k.pathOffsetY - this._owner.y + this._anchor.y;
            var _loc_8:* = 0;
            while (_loc_8 < _loc_4)
            {
                
                _loc_9 = _loc_3.getSegment(_loc_8).type;
                helperPathPoints.length = 0;
                _loc_3.getAnchorsInSegment(_loc_8, helperPathPoints);
                this._-Dj(helperPathPoints, _loc_6, _loc_7);
                _loc_2.moveTo(helperPathPoints.get_x(0), helperPathPoints.get_y(0));
                this._-Ae(this._-1P, helperPathPoints.get_x(0), helperPathPoints.get_y(0), param1, _loc_8, _loc_5);
                _loc_5 = false;
                switch(_loc_9)
                {
                    case CurveType.Straight:
                    {
                        _loc_2.lineTo(helperPathPoints.get_x(1), helperPathPoints.get_y(1));
                        break;
                    }
                    case CurveType.Bezier:
                    {
                        _loc_2.curveTo(helperPathPoints.get_x(2), helperPathPoints.get_y(2), helperPathPoints.get_x(1), helperPathPoints.get_y(1));
                        break;
                    }
                    case CurveType.CubicBezier:
                    {
                        _loc_2.cubicCurveTo(helperPathPoints.get_x(2), helperPathPoints.get_y(2), helperPathPoints.get_x(3), helperPathPoints.get_y(3), helperPathPoints.get_x(1), helperPathPoints.get_y(1));
                        _loc_2.lineStyle(Consts.auxLineSize, _-9E, 1, true, LineScaleMode.NONE);
                        _loc_2.moveTo(helperPathPoints.get_x(0), helperPathPoints.get_y(0));
                        _loc_2.lineTo(helperPathPoints.get_x(2), helperPathPoints.get_y(2));
                        _loc_2.moveTo(helperPathPoints.get_x(1), helperPathPoints.get_y(1));
                        _loc_2.lineTo(helperPathPoints.get_x(3), helperPathPoints.get_y(3));
                        _loc_2.lineStyle(Consts.auxLineSize, _-1u, 1, true, LineScaleMode.NONE);
                        this._-Ae(this._-IZ, helperPathPoints.get_x(2), helperPathPoints.get_y(2), param1, _loc_8 * 2);
                        this._-Ae(this._-IZ, helperPathPoints.get_x(3), helperPathPoints.get_y(3), param1, _loc_8 * 2 + 1);
                        _loc_5 = true;
                        break;
                    }
                    case CurveType.CRSpline:
                    {
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_8++;
            }
            if (_loc_4 != 0)
            {
                this._-Ae(this._-1P, helperPathPoints.get_x(1), helperPathPoints.get_y(1), param1, _loc_4, _loc_5);
            }
            this._-1P._-K7();
            this._-IZ._-K7();
            return;
        }// end function

        private function _-j() : Sprite
        {
            var _loc_1:* = new _-Er();
            _loc_1.owner = this;
            _loc_1.cacheAsBitmap = true;
            _loc_1.name = "anchor";
            _loc_1.mouseEnabled = false;
            var _loc_2:* = _loc_1.graphics;
            _loc_2.lineStyle(Consts.auxLineSize, 2236962, 1, false, LineScaleMode.NONE);
            _loc_2.beginFill(16777215, 1);
            _loc_2.drawCircle(0, 0, _-2 / 2);
            _loc_2.endFill();
            return _loc_1;
        }// end function

        private function _-Ae(param1:_-9z, param2:Number, param3:Number, param4:Number, param5:int, param6:Boolean = false) : _-Jy
        {
            var _loc_8:* = null;
            var _loc_7:* = param1._-7T(this._-1D);
            if (param1 != this._-1P && param1 != this._-IZ)
            {
                _loc_8 = this._-Dz(param2, param3);
                _loc_7.x = _loc_8.x;
                _loc_7.y = _loc_8.y;
            }
            else
            {
                _loc_7.x = param2;
                _loc_7.y = param3;
            }
            var _loc_9:* = param4;
            _loc_7.scaleY = param4;
            _loc_7.scaleX = _loc_9;
            _loc_7.index = param5;
            if (param6)
            {
                this._-Cn.addChildAt(_loc_7, this._-Cn.numChildren - 2);
            }
            else
            {
                this._-Cn.addChild(_loc_7);
            }
            return _loc_7;
        }// end function

        private function _-Dz(param1:Number, param2:Number) : Point
        {
            helperPoint.setTo(param1, param2);
            return this._-HK.transformPoint(helperPoint);
        }// end function

        private function _-Dj(param1:PointList, param2:Number, param3:Number) : void
        {
            var _loc_5:* = null;
            var _loc_4:* = 0;
            while (_loc_4 < param1.length)
            {
                
                helperPoint.setTo(param1.get_x(_loc_4), param1.get_y(_loc_4));
                helperPoint.x = helperPoint.x + param2;
                helperPoint.y = helperPoint.y + param3;
                _loc_5 = this._-9t.transformPoint(helperPoint);
                param1.set(_loc_4, _loc_5.x, _loc_5.y);
                _loc_4++;
            }
            return;
        }// end function

        private function onAdded() : void
        {
            if (this._-KH)
            {
                this._-Lv.visible = false;
            }
            return;
        }// end function

        private function onRemoved() : void
        {
            if (this._-KH)
            {
                this._-Lv.visible = true;
            }
            if (this._-KW || this._-9k)
            {
                this.editComplete();
            }
            if (this._-8)
            {
                if (this._-8.parent)
                {
                    this._-8.selected = false;
                }
                this._-8 = null;
            }
            return;
        }// end function

        public function get _-LY() : _-Jy
        {
            return this._-8;
        }// end function

        public function set _-LY(param1:_-Jy) : void
        {
            var _loc_2:* = false;
            if (this._-8)
            {
                this._-8.selected = false;
                _loc_2 = this._-8.type != _-DK;
            }
            this._-8 = param1;
            if (this._-8)
            {
                this._-8.selected = true;
                if (this._-8.type != _-DK)
                {
                    _loc_2 = true;
                }
            }
            if (_loc_2)
            {
                this._-1D.refreshInspectors(_-8B._-If);
            }
            return;
        }// end function

        public function onDragStart(event:MouseEvent) : void
        {
            if (event.target is _-Jy)
            {
                this._-LY = _-Jy(event.target);
            }
            else
            {
                this._-LY = null;
            }
            helperPoint.setTo(event.stageX, event.stageY);
            this._-NN = this._-Ex.parent.globalToLocal(helperPoint);
            this._-Nd.setTo(0, 0);
            return;
        }// end function

        public function onDragMove(event:MouseEvent) : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = NaN;
            helperPoint.setTo(event.stageX, event.stageY);
            var _loc_2:* = this._-Ex.parent.globalToLocal(helperPoint);
            this._-Nd.setTo(_loc_2.x - this._-NN.x, _loc_2.y - this._-NN.y);
            var _loc_3:* = int(this._-Nd.x);
            var _loc_4:* = int(this._-Nd.y);
            this._-NN.x = _loc_2.x + _loc_3 - this._-Nd.x;
            this._-NN.y = _loc_2.y + _loc_4 - this._-Nd.y;
            this._-Nd.x = _loc_3;
            this._-Nd.y = _loc_4;
            if (event.shiftKey)
            {
                _loc_5 = -1;
                if (this._-8 && this._-8.type == _-DK)
                {
                    _loc_5 = this._-8.index;
                }
                if (_loc_5 == 0 || _loc_5 == 4 || _loc_5 == 2 || _loc_5 == 6)
                {
                    _loc_6 = this._owner.height / this._owner.width;
                    if (_loc_6 != 0 && !isNaN(_loc_6))
                    {
                        if (_loc_5 == 2 || _loc_5 == 6)
                        {
                            _loc_6 = -_loc_6;
                        }
                        this._-Nd.x = (this._-Nd.y + this._-Nd.x / _loc_6) / (_loc_6 + 1 / _loc_6);
                        this._-Nd.y = _loc_6 * this._-Nd.x;
                    }
                    else
                    {
                        this._-Nd.x = 0;
                        this._-Nd.y = 0;
                    }
                }
                else
                {
                    if (this._-GJ == 0)
                    {
                        if (Math.abs(this._-Nd.x) >= Math.abs(this._-Nd.y))
                        {
                            this._-GJ = 1;
                        }
                        else
                        {
                            this._-GJ = 2;
                        }
                    }
                    if (this._-GJ == 1)
                    {
                        this._-Nd.y = 0;
                    }
                    else if (this._-GJ == 2)
                    {
                        this._-Nd.x = 0;
                    }
                }
            }
            else
            {
                this._-GJ = 0;
            }
            this._-JY = this._-Nd.x == 0 ? (0) : (this._-Nd.x > 0 ? (1) : (-1));
            this._-10 = this._-Nd.y == 0 ? (0) : (this._-Nd.y > 0 ? (1) : (-1));
            if (this._-8 && this._-8.type != _-Gp && this._-8.type != _-Du)
            {
                this._-Nd = this._-Lq.transformPoint(this._-Nd);
            }
            this._-2s();
            return;
        }// end function

        public function onDragEnd(event:MouseEvent) : void
        {
            this._-GJ = 0;
            GTimers.inst.remove(this._-Az);
            return;
        }// end function

        private function _-2s() : void
        {
            var _loc_1:* = _-PX(this._owner.docElement);
            if (this._-8)
            {
                if (this._-8.type == _-I9._-DK)
                {
                    _loc_1._-Ce(this._-Nd.x, this._-Nd.y, this._-8.index);
                }
                else if (this._-8.type == _-I9._-6n)
                {
                    _loc_1._-6z(this._-Nd.x, this._-Nd.y, this._-8.index);
                }
                else if (this._-8.type == _-I9._-Gp)
                {
                    _loc_1._-7f(this._-Nd.x, this._-Nd.y, this._-8.index);
                }
                else if (this._-8.type == _-I9._-Du)
                {
                    _loc_1._-94(this._-Nd.x, this._-Nd.y, this._-8.index);
                }
            }
            else if (!this._-KW)
            {
                _loc_1._-Ce(this._-Nd.x, this._-Nd.y, -1);
            }
            GTimers.inst.add(333, 1, this._-Az);
            return;
        }// end function

        private function _-Az() : void
        {
            var _loc_4:* = NaN;
            var _loc_5:* = 0;
            this._-Nd.setTo(0, 0);
            var _loc_1:* = 0;
            var _loc_2:* = this._-1D.panel.parent;
            var _loc_3:* = _-On(this._-1D)._docView.viewScale;
            if (_loc_2.displayObject.mouseX < _-Fm && this._-JY < 0)
            {
                _loc_4 = _loc_2.scrollPane.posX;
                _loc_2.scrollPane.posX = _loc_2.scrollPane.posX - _-JD;
                _loc_5 = _loc_4 - _loc_2.scrollPane.posX;
                if (_loc_5 != 0)
                {
                    this._-Nd.x = this._-Nd.x - _loc_5 / _loc_3;
                    _loc_1 = _loc_1 | 1;
                }
            }
            if (_loc_2.displayObject.mouseX > _loc_2.width - _-Fm - 20 && this._-JY > 0)
            {
                _loc_4 = _loc_2.scrollPane.posX;
                _loc_2.scrollPane.posX = _loc_2.scrollPane.posX + _-JD;
                _loc_5 = _loc_4 - _loc_2.scrollPane.posX;
                if (_loc_5 != 0)
                {
                    this._-Nd.x = this._-Nd.x - _loc_5 / _loc_3;
                    _loc_1 = _loc_1 | 2;
                }
            }
            if (_loc_2.displayObject.mouseY < _-Fm && this._-10 < 0)
            {
                _loc_4 = _loc_2.scrollPane.posY;
                _loc_2.scrollPane.posY = _loc_2.scrollPane.posY - _-JD;
                _loc_5 = _loc_4 - _loc_2.scrollPane.posY;
                if (_loc_5 != 0)
                {
                    this._-Nd.y = this._-Nd.y - _loc_5 / _loc_3;
                    _loc_1 = _loc_1 | 4;
                }
            }
            if (_loc_2.displayObject.mouseY > _loc_2.height - _-Fm - 20 && this._-10 > 0)
            {
                _loc_4 = _loc_2.scrollPane.posY;
                _loc_2.scrollPane.posY = _loc_2.scrollPane.posY + _-JD;
                _loc_5 = _loc_4 - _loc_2.scrollPane.posY;
                this._-Nd.y = this._-Nd.y - _loc_5 / _loc_3;
                _loc_1 = _loc_1 | 8;
            }
            if (_loc_1)
            {
                this._-2s();
            }
            return;
        }// end function

    }
}
