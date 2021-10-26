package _-An
{
    import *.*;
    import _-C9.*;
    import __AS3__.vec.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.gui.gear.*;
    import fairygui.tween.*;
    import fairygui.utils.*;
    import flash.geom.*;

    public class _-PX extends Object implements IDocElement
    {
        private var _-Gu:_-I9;
        private var _-1D:_-On;
        private var _-D7:FObject;
        private var _vars:Object;
        private var _-BN:Boolean;
        private static const _-75:Object = {designImage:1, designImageOffsetX:1, designImageOffsetY:1, designImageAlpha:1, designImageLayer:1, designImageForTest:1, bgColor:2, bgColorEnabled:2, x:3, y:3, width:4, height:4, useSourceSize:5, name:6, pivotX:10, pivotY:10, anchor:11, extentionId:12, advanced:13, locked:14, hideByEditor:14};

        public function _-PX(param1:_-On, param2:FObject, param3:Boolean = false)
        {
            this._-1D = param1;
            this._-BN = param3;
            this._-D7 = param2;
            this._vars = {};
            this._-Gu = new _-I9(param1, param2);
            param2.displayObject.rootContainer.addChild(this._-Gu);
            return;
        }// end function

        public function get owner() : IDocument
        {
            return this._-1D;
        }// end function

        public function get isRoot() : Boolean
        {
            return this._-BN;
        }// end function

        public function get isValid() : Boolean
        {
            return this._-BN ? (true) : (this._-D7.parent != null);
        }// end function

        public function get relationsDisabled() : Boolean
        {
            return this._-1D.getVar("relationsDisabled") || this._-1D.getVar("selectionTransforming") && this._-Gu._selected;
        }// end function

        public function get displayIcon() : String
        {
            var _loc_1:* = null;
            if (this._-D7 is FComponent)
            {
                if (FComponent(this._-D7).extentionId)
                {
                    _loc_1 = Consts.icons[FComponent(this._-D7).extentionId];
                    if (_loc_1)
                    {
                        return _loc_1;
                    }
                }
            }
            return Consts.icons[this._-D7._objectType];
        }// end function

        public function get selected() : Boolean
        {
            return this._-Gu._selected;
        }// end function

        public function set selected(param1:Boolean) : void
        {
            this._-Gu._-HW(param1);
            return;
        }// end function

        public function get gizmo() : IGizmo
        {
            return this._-Gu;
        }// end function

        public function setVar(param1:String, param2) : void
        {
            if (param2 == undefined)
            {
                delete this._vars[param1];
            }
            else
            {
                this._vars[param1] = param2;
            }
            return;
        }// end function

        public function getVar(param1:String)
        {
            return this._vars[param1];
        }// end function

        public function setProperty(param1:String, param2) : void
        {
            var _loc_4:* = undefined;
            var _loc_5:* = null;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = undefined;
            var _loc_11:* = NaN;
            var _loc_12:* = NaN;
            var _loc_13:* = false;
            var _loc_3:* = _-75[param1];
            if (_loc_3 == 0)
            {
                _loc_3 = 1000;
            }
            if (this._-1D.timelineMode)
            {
                if (_loc_3 == 3)
                {
                    _loc_5 = this._-1D.editingTransition.findItem(this._-1D.head, this._-D7._id, "XY");
                    if (_loc_5 != null)
                    {
                        if (param1 == "x")
                        {
                            this._-1D.setKeyFrameValue(_loc_5, {f1:param2});
                            this._-D7.x = param2;
                        }
                        else
                        {
                            this._-1D.setKeyFrameValue(_loc_5, {f2:param2});
                            this._-D7.y = param2;
                        }
                    }
                }
                else if (_loc_3 == 4)
                {
                    _loc_5 = this._-1D.editingTransition.findItem(this._-1D.head, this._-D7._id, "Size");
                    if (_loc_5 != null)
                    {
                        if (param1 == "width")
                        {
                            this._-1D.setKeyFrameValue(_loc_5, {f1:param2});
                            this._-D7.width = param2;
                        }
                        else
                        {
                            this._-1D.setKeyFrameValue(_loc_5, {f2:param2});
                            this._-D7.height = param2;
                        }
                    }
                }
                return;
            }
            if (!this._-1D.history.processing)
            {
                _loc_4 = this._-D7[param1];
                if (_loc_3 == 5)
                {
                    if (this._-D7._res)
                    {
                        if (param2)
                        {
                            if (!this._-D7.relations.widthLocked)
                            {
                                this._-K1("width", this._-D7.sourceWidth);
                            }
                            if (!this._-D7.relations.heightLocked)
                            {
                                this._-K1("height", this._-D7.sourceHeight);
                            }
                        }
                    }
                    else
                    {
                        return;
                    }
                }
                else if (_loc_3 == 4)
                {
                    if (this._-D7._res)
                    {
                        if (this._-D7.useSourceSize)
                        {
                            this._-K1("useSourceSize", false);
                        }
                    }
                    else if (this._-D7 is FTextField && (FTextField(this._-D7).autoSize != "none" && FTextField(this._-D7).autoSize != "shrink"))
                    {
                        this._-K1("autoSize", "none");
                    }
                }
            }
            if (_loc_3 == 10)
            {
                _loc_6 = this._-D7.pivotX;
                _loc_7 = this._-D7.pivotY;
                _loc_8 = this._-D7._pivotOffsetX;
                _loc_9 = this._-D7._pivotOffsetY;
            }
            this._-D7[param1] = param2;
            if (!this._-1D.history.processing)
            {
                _loc_10 = this._-D7[param1];
                if (_loc_10 == _loc_4)
                {
                    return;
                }
                _-LZ.setProperty(this._-1D, this._-D7, param1, _loc_4);
            }
            switch(_loc_3)
            {
                case 1:
                {
                    break;
                }
                case 2:
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (_loc_3 == 10)
            {
                if (this._-D7.anchor)
                {
                }
            }
            else if (_loc_3 == 11)
            {
                if (this._-D7.anchor)
                {
                }
                else
                {
                }
            }
            if (_loc_3 == 3 || _loc_3 == 10 || _loc_3 == 11)
            {
                this._-1D.refreshInspectors(_-8B._-4T);
            }
            else if (_loc_3 == 12 || _loc_3 == 13)
            {
                this._-1D.refreshInspectors();
            }
            else
            {
                this._-1D.refreshInspectors(_-8B.COMMON);
            }
            if (_loc_3 == 6 || _loc_3 == 14)
            {
                this._-1D._editor.emit(EditorEvent.HierarchyChanged, this._-D7);
            }
            return;
        }// end function

        private function _-K1(param1:String, param2) : void
        {
            var _loc_3:* = undefined;
            var _loc_4:* = undefined;
            if (this._-1D.history.processing)
            {
                this._-D7[param1] = param2;
            }
            else
            {
                _loc_3 = this._-D7[param1];
                this._-D7[param1] = param2;
                _loc_4 = this._-D7[param1];
                if (_loc_4 != _loc_3)
                {
                    _-LZ.setProperty(this._-1D, this._-D7, param1, _loc_3);
                }
            }
            return;
        }// end function

        public function setGearProperty(param1:int, param2:String, param3) : void
        {
            var _loc_5:* = undefined;
            var _loc_6:* = undefined;
            var _loc_4:* = this._-D7.getGear(param1);
            if (this._-1D.history.processing)
            {
                _loc_4[param2] = param3;
            }
            else
            {
                _loc_5 = _loc_4[param2];
                _loc_4[param2] = param3;
                _loc_6 = _loc_4[param2];
                if (_loc_6 == _loc_5)
                {
                    return;
                }
                _-LZ.setGearProperty(this._-1D, this._-D7, param1, param2, _loc_5);
            }
            this._-1D.refreshInspectors(_-8B._-5O);
            return;
        }// end function

        public function setRelation(param1:FObject, param2:String) : void
        {
            if (param2 == null)
            {
                param2 = "";
            }
            var _loc_3:* = this._-D7.relations.getItem(param1);
            if (_loc_3 && _loc_3.desc == param2 || !_loc_3 && param1 == this._-D7.parent && param2.length == 0 || param1 == this._-D7)
            {
                this._-1D.refreshInspectors(_-8B._-8A);
                return;
            }
            var _loc_4:* = this._-D7.relations.write();
            _-LZ._-Ji(this._-1D, this._-D7, _loc_4);
            if (_loc_3)
            {
                _loc_3.desc = param2;
            }
            else
            {
                this._-D7.relations.addItem2(param1, param2);
            }
            this._-1D.refreshInspectors(_-8B._-8A);
            return;
        }// end function

        public function removeRelation(param1:FObject) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = this._-D7.relations.getItem(param1);
            if (_loc_2)
            {
                _loc_3 = this._-D7.relations.write();
                _-LZ._-Ji(this._-1D, this._-D7, _loc_3);
                this._-D7.relations.removeTarget(param1);
                this._-1D.refreshInspectors(_-8B._-8A);
            }
            return;
        }// end function

        public function updateRelations(param1:XData) : void
        {
            this._-D7.relations.read(param1, this._-BN);
            this._-1D.refreshInspectors(_-8B._-8A);
            return;
        }// end function

        public function setExtensionProperty(param1:String, param2) : void
        {
            var _loc_4:* = undefined;
            var _loc_5:* = undefined;
            var _loc_3:* = FComponent(this._-D7).extention;
            if (!_loc_3)
            {
                return;
            }
            if (this._-1D.history.processing)
            {
                _loc_3[param1] = param2;
            }
            else
            {
                _loc_4 = _loc_3[param1];
                _loc_3[param1] = param2;
                _loc_5 = _loc_3[param1];
                if (_loc_5 == _loc_4)
                {
                    return;
                }
                if (param1 == "downEffect" && _loc_5 == "scale")
                {
                    this.setProperty("pivotX", 0.5);
                    this.setProperty("pivotY", 0.5);
                }
                _-LZ.setExtensionProperty(this._-1D, this._-D7, param1, _loc_4);
            }
            this._-1D.refreshInspectors(_-8B.COMMON);
            return;
        }// end function

        public function setChildProperty(param1:String, param2:int, param3) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_4:* = FComponent(this._-D7).getCustomProperty(param1, param2);
            if (!FComponent(this._-D7).getCustomProperty(param1, param2))
            {
                return;
            }
            var _loc_5:* = _loc_4.value;
            _loc_4.value = param3;
            if (param3 != undefined)
            {
                if (param2 == -1)
                {
                    _loc_6 = FComponent(this._-D7).getController(_loc_4.target);
                    if (_loc_6)
                    {
                        _loc_6.selectedPageId = param3;
                    }
                }
                else
                {
                    _loc_7 = FComponent(this._-D7).getChildByPath(_loc_4.target);
                    if (_loc_7)
                    {
                        _loc_7.setProp(param2, param3);
                    }
                }
            }
            if (!this._-1D.history.processing)
            {
                _-LZ.setChildProperty(this._-1D, this._-D7, param1, param2, _loc_5);
            }
            this._-1D.refreshInspectors(_-8B.COMMON);
            return;
        }// end function

        public function setVertexPosition(param1:int, param2:Number, param3:Number) : void
        {
            var _loc_4:* = FGraph(this._-D7);
            _-LZ.setProperty(this._-1D, this._-D7, "polygonData", _loc_4.polygonData.concat());
            _loc_4.updateVertex(param1, param2, param3);
            if (!this._-Gu.verticesEditing)
            {
                this.updateGraphBounds();
            }
            this._-1D.refreshInspectors(_-8B._-If);
            return;
        }// end function

        public function setVertexDistance(param1:int, param2:Number) : void
        {
            var _loc_3:* = FGraph(this._-D7);
            _-LZ.setProperty(this._-1D, this._-D7, "polygonData", _loc_3.polygonData.concat());
            _loc_3.updateVertexDistance(param1, param2);
            this._-1D.refreshInspectors(_-8B._-If);
            return;
        }// end function

        public function updateGraphBounds() : void
        {
            var _loc_1:* = null;
            if (FGraph(this._-D7).type == FGraph.POLYGON)
            {
                _loc_1 = FGraph(this._-D7).calculatePolygonBounds();
                this.setProperty("width", _loc_1.right);
                this.setProperty("height", _loc_1.bottom);
            }
            return;
        }// end function

        public function _-Ce(param1:Number, param2:Number, param3:int) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = 0;
            var _loc_11:* = NaN;
            var _loc_4:* = this._-1D.getSelection();
            var _loc_5:* = _loc_4.length;
            if (_loc_4.indexOf(this._-D7) == -1)
            {
                this._-1D.unselectAll();
            }
            this._-1D.setVar("selectionTransforming", true);
            if (param3 == -1)
            {
                _loc_8 = this._-D7.x;
                _loc_9 = this._-D7.y;
                _loc_10 = this._-1D._-MJ(this._-D7);
                if (_loc_10 & 1)
                {
                    param1 = 0;
                }
                else
                {
                    this.setProperty("x", _loc_8 + param1);
                    param1 = this._-D7.x - _loc_8;
                }
                if (_loc_10 & 2)
                {
                    param2 = 0;
                }
                else
                {
                    this.setProperty("y", _loc_9 + param2);
                    param2 = this._-D7.y - _loc_9;
                }
                _loc_7 = 0;
                while (_loc_7 < _loc_5)
                {
                    
                    _loc_6 = _loc_4[_loc_7];
                    if (_loc_6 != this._-D7)
                    {
                        _loc_10 = this._-1D._-MJ(_loc_6);
                        _loc_11 = _loc_6.x + param1;
                        if (!(_loc_10 & 1))
                        {
                            _loc_6.docElement.setProperty("x", _loc_11);
                        }
                        _loc_11 = _loc_6.y + param2;
                        if (!(_loc_10 & 2))
                        {
                            _loc_6.docElement.setProperty("y", _loc_11);
                        }
                    }
                    _loc_7++;
                }
            }
            else
            {
                this._-Eu(this._-D7, param1, param2, param3);
                _loc_7 = 0;
                while (_loc_7 < _loc_5)
                {
                    
                    _loc_6 = _loc_4[_loc_7];
                    if (_loc_6 != this._-D7)
                    {
                        this._-Eu(_loc_6, param1, param2, param3);
                    }
                    _loc_7++;
                }
            }
            this._-1D.setVar("selectionTransforming", false);
            this._-1D._-Oc(this._-D7);
            return;
        }// end function

        private function _-Eu(param1:FObject, param2:Number, param3:Number, param4:int) : void
        {
            param2 = param2 / (param1.scaleX != 0 ? (param1.scaleX) : (1));
            param3 = param3 / (param1.scaleY != 0 ? (param1.scaleY) : (1));
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            if (param4 == 0 || param4 == 1 || param4 == 2)
            {
                if (param1.pivotY != 0)
                {
                    _loc_6 = (-param3) / param1.pivotY;
                    param3 = 0;
                }
                else
                {
                    _loc_6 = -param3;
                }
            }
            else if (param4 == 4 || param4 == 5 || param4 == 6)
            {
                if (param1.pivotY != 1)
                {
                    _loc_6 = param3 / (1 - param1.pivotY);
                    param3 = 0;
                }
                else
                {
                    _loc_6 = param3;
                }
            }
            else
            {
                param3 = 0;
            }
            if (param4 == 0 || param4 == 6 || param4 == 7)
            {
                if (param1.pivotX != 0)
                {
                    _loc_5 = (-param2) / param1.pivotX;
                    param2 = 0;
                }
                else
                {
                    _loc_5 = -param2;
                }
            }
            else if (param4 == 2 || param4 == 3 || param4 == 4)
            {
                if (param1.pivotX != 1)
                {
                    _loc_5 = param2 / (1 - param1.pivotX);
                    param2 = 0;
                }
                else
                {
                    _loc_5 = param2;
                }
            }
            else
            {
                param2 = 0;
            }
            if (param1.aspectLocked)
            {
                if (Math.abs(_loc_5) > 0)
                {
                    _loc_6 = _loc_5 / param1.aspectRatio;
                }
                else
                {
                    _loc_5 = _loc_6 * param1.aspectRatio;
                }
            }
            var _loc_7:* = this._-1D._-MJ(param1);
            if (!(this._-1D._-MJ(param1) & 1) && param2 != 0)
            {
                param1.docElement.setProperty("x", param1.x + param2);
            }
            if (!(_loc_7 & 2) && param3 != 0)
            {
                param1.docElement.setProperty("y", param1.y + param3);
            }
            if (_loc_5 != 0 || _loc_6 != 0)
            {
                if (!(_loc_7 & 4))
                {
                    param1.docElement.setProperty("width", param1.width + _loc_5);
                }
                if (!(_loc_7 & 8))
                {
                    param1.docElement.setProperty("height", param1.height + _loc_6);
                }
            }
            return;
        }// end function

        public function _-6z(param1:Number, param2:Number, param3:int) : void
        {
            var _loc_4:* = FGraph(this._-D7);
            this.setVertexPosition(param3, _loc_4.polygonPoints.get_x(param3) + param1, _loc_4.polygonPoints.get_y(param3) + param2);
            return;
        }// end function

        public function _-7f(param1:Number, param2:Number, param3:int) : void
        {
            var _loc_4:* = this._-1D.editingTransition.getItemWithPath(this._-1D.head, this._-D7._id);
            if (!this._-1D.editingTransition.getItemWithPath(this._-1D.head, this._-D7._id))
            {
                return;
            }
            var _loc_5:* = _loc_4.pathPoints[param3];
            this._-1D.setKeyFramePathPos(_loc_4, param3, _loc_5.x + param1, _loc_5.y + param2);
            return;
        }// end function

        public function _-94(param1:Number, param2:Number, param3:int) : void
        {
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_4:* = this._-1D.editingTransition.getItemWithPath(this._-1D.head, this._-D7._id);
            if (!this._-1D.editingTransition.getItemWithPath(this._-1D.head, this._-D7._id))
            {
                return;
            }
            var _loc_5:* = param3 % 2;
            param3 = param3 / 2;
            var _loc_6:* = _loc_4.pathPoints[param3];
            if (_loc_5 == 0)
            {
                _loc_7 = _loc_6.control1_x + param1;
                _loc_8 = _loc_6.control1_y + param2;
            }
            else if (_loc_5 == 1)
            {
                _loc_7 = _loc_6.control2_x + param1;
                _loc_8 = _loc_6.control2_y + param2;
            }
            this._-1D.setKeyFrameControlPointPos(_loc_4, param3, _loc_5, _loc_7, _loc_8);
            return;
        }// end function

    }
}
