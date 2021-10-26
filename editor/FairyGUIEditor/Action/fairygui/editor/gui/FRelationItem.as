package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;

    public class FRelationItem extends Object
    {
        private var _owner:FObject;
        private var _target:FObject;
        private var _defs:Vector.<FRelationDef>;
        private var _targetX:Number;
        private var _targetY:Number;
        private var _targetWidth:Number;
        private var _targetHeight:Number;
        private var _readOnly:Boolean;
        private var _containsWidthRelated:Boolean;
        private var _containsHeightRelated:Boolean;

        public function FRelationItem(param1:FObject)
        {
            this._owner = param1;
            this._defs = new Vector.<FRelationDef>;
            return;
        }// end function

        public function get owner() : FObject
        {
            return this._owner;
        }// end function

        public function get readOnly() : Boolean
        {
            return this._readOnly;
        }// end function

        public function set(param1:FObject, param2:String, param3:Boolean = false) : void
        {
            this._readOnly = param3;
            this.target = param1;
            this.desc = param2;
            return;
        }// end function

        public function get target() : FObject
        {
            return this._target;
        }// end function

        public function set target(param1:FObject) : void
        {
            if (this._target != param1)
            {
                if (this._target)
                {
                    this.releaseRefTarget(this._target);
                }
                this._target = param1;
                if (this._target)
                {
                    this.addRefTarget(this._target);
                }
            }
            return;
        }// end function

        public function get containsWidthRelated() : Boolean
        {
            return this._containsWidthRelated;
        }// end function

        public function get containsHeightRelated() : Boolean
        {
            return this._containsHeightRelated;
        }// end function

        public function dispose() : void
        {
            if (this._target)
            {
                this.releaseRefTarget(this._target);
                this._target = null;
            }
            return;
        }// end function

        public function get defs() : Vector.<FRelationDef>
        {
            return this._defs;
        }// end function

        public function get desc() : String
        {
            var _loc_2:* = null;
            var _loc_1:* = "";
            for each (_loc_2 in this._defs)
            {
                
                if (_loc_1.length > 0)
                {
                    _loc_1 = _loc_1 + ",";
                }
                _loc_1 = _loc_1 + _loc_2.toString();
            }
            return _loc_1;
        }// end function

        public function set desc(param1:String) : void
        {
            this._containsWidthRelated = false;
            this._containsHeightRelated = false;
            this._defs.length = 0;
            this.addDefs(param1, false);
            return;
        }// end function

        public function addDef(param1:int, param2:Boolean = false, param3:Boolean = true) : void
        {
            var _loc_4:* = null;
            if (param1 == FRelationType.Size)
            {
                this.addDef(FRelationType.Width, param2, param3);
                this.addDef(FRelationType.Height, param2, param3);
                return;
            }
            if (param3)
            {
                for each (_loc_4 in this._defs)
                {
                    
                    if (_loc_4.type == param1)
                    {
                        _loc_4.percent = param2;
                        return;
                    }
                }
            }
            _loc_4 = new FRelationDef();
            _loc_6.push(_loc_4);
            _loc_4.affectBySelfSizeChanged = param1 >= FRelationType.Center_Center && param1 <= FRelationType.Right_Right || param1 >= FRelationType.Middle_Middle && param1 <= FRelationType.Bottom_Bottom;
            _loc_4.percent = param2;
            _loc_4.type = param1;
            if (_loc_4.type == FRelationType.Width || _loc_4.type == FRelationType.RightExt_Right)
            {
                this._containsWidthRelated = true;
            }
            if (_loc_4.type == FRelationType.Height || _loc_4.type == FRelationType.BottomExt_Bottom)
            {
                this._containsHeightRelated = true;
            }
            return;
        }// end function

        public function addDefs(param1:String, param2:Boolean = true) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = false;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_11:* = 0;
            var _loc_3:* = param1.split(",");
            var _loc_10:* = _loc_3.length;
            _loc_8 = 0;
            while (_loc_8 < _loc_10)
            {
                
                _loc_4 = _loc_3[_loc_8];
                if (!_loc_4)
                {
                }
                else
                {
                    if (_loc_4.charAt((_loc_4.length - 1)) == "%")
                    {
                        _loc_4 = _loc_4.substr(0, (_loc_4.length - 1));
                        _loc_7 = true;
                    }
                    else
                    {
                        _loc_7 = false;
                    }
                    _loc_11 = _loc_4.indexOf("-");
                    if (_loc_11 == -1)
                    {
                        _loc_5 = _loc_4;
                        _loc_6 = _loc_4;
                    }
                    else
                    {
                        _loc_5 = _loc_4.substring(0, _loc_11);
                        _loc_6 = _loc_4.substring((_loc_11 + 1));
                    }
                    _loc_9 = FRelationType.Names.indexOf(_loc_5 + "-" + _loc_6);
                    if (_loc_9 == -1)
                    {
                    }
                    else
                    {
                        this.addDef(_loc_9, _loc_7, param2);
                    }
                }
                _loc_8++;
            }
            return;
        }// end function

        public function hasDef(param1:int) : Boolean
        {
            var _loc_2:* = null;
            for each (_loc_2 in this._defs)
            {
                
                if (_loc_2.type == param1)
                {
                    return true;
                }
            }
            return false;
        }// end function

        private function applyXYChanged(param1:Number, param2:Number) : void
        {
            var _loc_3:* = null;
            if (this._owner.docElement && this._owner.docElement.relationsDisabled)
            {
                return;
            }
            for each (_loc_3 in this._defs)
            {
                
                this.applyXYChanged2(_loc_3, param1, param2);
            }
            return;
        }// end function

        private function applySizeChanged() : void
        {
            var _loc_1:* = null;
            if (this._owner.docElement && this._owner.docElement.relationsDisabled)
            {
                return;
            }
            for each (_loc_1 in this._defs)
            {
                
                this.applySizeChanged2(_loc_1);
            }
            return;
        }// end function

        public function applySelfSizeChanged(param1:Number, param2:Number, param3:Boolean) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            if (this._owner.docElement && this._owner.docElement.relationsDisabled)
            {
                return;
            }
            var _loc_4:* = this._owner.x;
            var _loc_5:* = this._owner.y;
            for each (_loc_6 in this._defs)
            {
                
                this.applySelfSizeChanged2(_loc_6, param1, param2, param3);
            }
            if (_loc_4 != this._owner.x || _loc_5 != this._owner.y)
            {
                _loc_4 = this._owner.x - _loc_4;
                _loc_5 = this._owner.y - _loc_5;
                this._owner.updateGearFromRelations(1, _loc_4, _loc_5);
                if ((this._owner._flags & FObjectFlags.IN_TEST) != 0 && this._owner._parent != null && !this._owner._parent.transitions.isEmpty)
                {
                    for each (_loc_7 in this._owner._parent.transitions.items)
                    {
                        
                        _loc_7.updateFromRelations(this._owner._id, _loc_4, _loc_5);
                    }
                }
            }
            return;
        }// end function

        private function applyXYChanged2(param1:FRelationDef, param2:Number, param3:Number) : void
        {
            var _loc_4:* = NaN;
            switch(param1.type)
            {
                case FRelationType.Left_Left:
                case FRelationType.Left_Center:
                case FRelationType.Left_Right:
                case FRelationType.Center_Center:
                case FRelationType.Right_Left:
                case FRelationType.Right_Center:
                case FRelationType.Right_Right:
                {
                    this._owner.x = this._owner.x + param2;
                    break;
                }
                case FRelationType.Top_Top:
                case FRelationType.Top_Middle:
                case FRelationType.Top_Bottom:
                case FRelationType.Middle_Middle:
                case FRelationType.Bottom_Top:
                case FRelationType.Bottom_Middle:
                case FRelationType.Bottom_Bottom:
                {
                    this._owner.y = this._owner.y + param3;
                    break;
                }
                case FRelationType.Width:
                case FRelationType.Height:
                {
                    break;
                }
                case FRelationType.LeftExt_Left:
                case FRelationType.LeftExt_Right:
                {
                    if (this._owner != this._target.parent)
                    {
                        _loc_4 = this._owner.xMin;
                        this._owner.width = this._owner._rawWidth - param2;
                        this._owner.xMin = _loc_4 + param2;
                    }
                    else
                    {
                        this._owner.setSize(this._owner._rawWidth - param2, this._owner._rawHeight, false, true);
                    }
                    break;
                }
                case FRelationType.RightExt_Left:
                case FRelationType.RightExt_Right:
                {
                    if (this._owner != this._target.parent)
                    {
                        _loc_4 = this._owner.xMin;
                        this._owner.width = this._owner._rawWidth + param2;
                        this._owner.xMin = _loc_4;
                    }
                    else
                    {
                        this._owner.setSize(this._owner._rawWidth + param2, this._owner._rawHeight, false, true);
                    }
                    break;
                }
                case FRelationType.TopExt_Top:
                case FRelationType.TopExt_Bottom:
                {
                    if (this._owner != this._target.parent)
                    {
                        _loc_4 = this._owner.yMin;
                        this._owner.height = this._owner._rawHeight - param3;
                        this._owner.yMin = _loc_4 + param3;
                    }
                    else
                    {
                        this._owner.setSize(this._owner._rawWidth, this._owner._rawHeight - param3, false, true);
                    }
                    break;
                }
                case FRelationType.BottomExt_Top:
                case FRelationType.BottomExt_Bottom:
                {
                    if (this._owner != this._target.parent)
                    {
                        _loc_4 = this._owner.yMin;
                        this._owner.height = this._owner._rawHeight + param3;
                        this._owner.yMin = _loc_4;
                    }
                    else
                    {
                        this._owner.setSize(this._owner._rawWidth, this._owner._rawHeight + param3, false, true);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function applySizeChanged2(param1:FRelationDef) : void
        {
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            if (param1.type < FRelationType.Top_Top)
            {
                if (this._target != this._owner._parent)
                {
                    _loc_2 = this._target.x;
                    if (this._target.anchor)
                    {
                        _loc_3 = this._target.pivotX;
                    }
                }
                if (param1.percent)
                {
                    if (this._targetWidth != 0)
                    {
                        _loc_4 = this._target._width / this._targetWidth;
                    }
                }
                else
                {
                    _loc_4 = this._target._width - this._targetWidth;
                }
            }
            else
            {
                if (this._target != this._owner._parent)
                {
                    _loc_2 = this._target.y;
                    if (this._target.anchor)
                    {
                        _loc_3 = this._target.pivotY;
                    }
                }
                if (param1.percent)
                {
                    if (this._targetHeight != 0)
                    {
                        _loc_4 = this._target._height / this._targetHeight;
                    }
                }
                else
                {
                    _loc_4 = this._target._height - this._targetHeight;
                }
            }
            switch(param1.type)
            {
                case FRelationType.Left_Left:
                {
                    if (param1.percent)
                    {
                        this._owner.xMin = _loc_2 + (this._owner.xMin - _loc_2) * _loc_4;
                    }
                    else
                    {
                        this._owner.x = this._owner.x + _loc_4 * (-_loc_3);
                    }
                    break;
                }
                case FRelationType.Left_Center:
                {
                    if (param1.percent)
                    {
                        this._owner.xMin = _loc_2 + (this._owner.xMin - _loc_2) * _loc_4;
                    }
                    else
                    {
                        this._owner.x = this._owner.x + _loc_4 * (0.5 - _loc_3);
                    }
                    break;
                }
                case FRelationType.Left_Right:
                {
                    if (param1.percent)
                    {
                        this._owner.xMin = _loc_2 + (this._owner.xMin - _loc_2) * _loc_4;
                    }
                    else
                    {
                        this._owner.x = this._owner.x + _loc_4 * (1 - _loc_3);
                    }
                    break;
                }
                case FRelationType.Center_Center:
                {
                    if (param1.percent)
                    {
                        this._owner.xMin = _loc_2 + (this._owner.xMin + this._owner._rawWidth * 0.5 - _loc_2) * _loc_4 - this._owner._rawWidth * 0.5;
                    }
                    else
                    {
                        this._owner.x = this._owner.x + _loc_4 * (0.5 - _loc_3);
                    }
                    break;
                }
                case FRelationType.Right_Left:
                {
                    if (param1.percent)
                    {
                        this._owner.xMin = _loc_2 + (this._owner.xMin + this._owner._rawWidth - _loc_2) * _loc_4 - this._owner._rawWidth;
                    }
                    else
                    {
                        this._owner.x = this._owner.x + _loc_4 * (-_loc_3);
                    }
                    break;
                }
                case FRelationType.Right_Center:
                {
                    if (param1.percent)
                    {
                        this._owner.xMin = _loc_2 + (this._owner.xMin + this._owner._rawWidth - _loc_2) * _loc_4 - this._owner._rawWidth;
                    }
                    else
                    {
                        this._owner.x = this._owner.x + _loc_4 * (0.5 - _loc_3);
                    }
                    break;
                }
                case FRelationType.Right_Right:
                {
                    if (param1.percent)
                    {
                        this._owner.xMin = _loc_2 + (this._owner.xMin + this._owner._rawWidth - _loc_2) * _loc_4 - this._owner._rawWidth;
                    }
                    else
                    {
                        this._owner.x = this._owner.x + _loc_4 * (1 - _loc_3);
                    }
                    break;
                }
                case FRelationType.Top_Top:
                {
                    if (param1.percent)
                    {
                        this._owner.yMin = _loc_2 + (this._owner.yMin - _loc_2) * _loc_4;
                    }
                    else
                    {
                        this._owner.y = this._owner.y + _loc_4 * (-_loc_3);
                    }
                    break;
                }
                case FRelationType.Top_Middle:
                {
                    if (param1.percent)
                    {
                        this._owner.yMin = _loc_2 + (this._owner.yMin - _loc_2) * _loc_4;
                    }
                    else
                    {
                        this._owner.y = this._owner.y + _loc_4 * (0.5 - _loc_3);
                    }
                    break;
                }
                case FRelationType.Top_Bottom:
                {
                    if (param1.percent)
                    {
                        this._owner.yMin = _loc_2 + (this._owner.yMin - _loc_2) * _loc_4;
                    }
                    else
                    {
                        this._owner.y = this._owner.y + _loc_4 * (1 - _loc_3);
                    }
                    break;
                }
                case FRelationType.Middle_Middle:
                {
                    if (param1.percent)
                    {
                        this._owner.yMin = _loc_2 + (this._owner.yMin + this._owner._rawHeight * 0.5 - _loc_2) * _loc_4 - this._owner._rawHeight * 0.5;
                    }
                    else
                    {
                        this._owner.y = this._owner.y + _loc_4 * (0.5 - _loc_3);
                    }
                    break;
                }
                case FRelationType.Bottom_Top:
                {
                    if (param1.percent)
                    {
                        this._owner.yMin = _loc_2 + (this._owner.yMin + this._owner._rawHeight - _loc_2) * _loc_4 - this._owner._rawHeight;
                    }
                    else
                    {
                        this._owner.y = this._owner.y + _loc_4 * (-_loc_3);
                    }
                    break;
                }
                case FRelationType.Bottom_Middle:
                {
                    if (param1.percent)
                    {
                        this._owner.yMin = _loc_2 + (this._owner.yMin + this._owner._rawHeight - _loc_2) * _loc_4 - this._owner._rawHeight;
                    }
                    else
                    {
                        this._owner.y = this._owner.y + _loc_4 * (0.5 - _loc_3);
                    }
                    break;
                }
                case FRelationType.Bottom_Bottom:
                {
                    if (param1.percent)
                    {
                        this._owner.yMin = _loc_2 + (this._owner.yMin + this._owner._rawHeight - _loc_2) * _loc_4 - this._owner._rawHeight;
                    }
                    else
                    {
                        this._owner.y = this._owner.y + _loc_4 * (1 - _loc_3);
                    }
                    break;
                }
                case FRelationType.Width:
                {
                    if (!FObjectFlags.isDocRoot(this._owner._flags) && this._owner == this._target.parent)
                    {
                        _loc_5 = this._owner.sourceWidth - this._target.initWidth;
                    }
                    else
                    {
                        _loc_5 = this._owner._rawWidth - this._targetWidth;
                    }
                    if (param1.percent)
                    {
                        _loc_5 = _loc_5 * _loc_4;
                    }
                    if (this._target == this._owner._parent)
                    {
                        if (this._owner.anchor)
                        {
                            _loc_6 = this._owner.xMin;
                            this._owner.setSize(this._target._width + _loc_5, this._owner._rawHeight, true);
                            this._owner.xMin = _loc_6;
                        }
                        else
                        {
                            this._owner.setSize(this._target._width + _loc_5, this._owner._rawHeight, true);
                        }
                    }
                    else
                    {
                        this._owner.setSize(this._target._width + _loc_5, this._owner._rawHeight, false, this._owner == this._target.parent);
                    }
                    break;
                }
                case FRelationType.Height:
                {
                    if (!FObjectFlags.isDocRoot(this._owner._flags) && this._owner == this._target.parent)
                    {
                        _loc_5 = this._owner.sourceHeight - this._target.initHeight;
                    }
                    else
                    {
                        _loc_5 = this._owner._rawHeight - this._targetHeight;
                    }
                    if (param1.percent)
                    {
                        _loc_5 = _loc_5 * _loc_4;
                    }
                    if (this._target == this._owner._parent)
                    {
                        if (this._owner.anchor)
                        {
                            _loc_6 = this._owner.yMin;
                            this._owner.setSize(this._owner._rawWidth, this._target._height + _loc_5, true);
                            this._owner.yMin = _loc_6;
                        }
                        else
                        {
                            this._owner.setSize(this._owner._rawWidth, this._target._height + _loc_5, true);
                        }
                    }
                    else
                    {
                        this._owner.setSize(this._owner._rawWidth, this._target._height + _loc_5, false, this._owner == this._target.parent);
                    }
                    break;
                }
                case FRelationType.LeftExt_Left:
                {
                    _loc_6 = this._owner.xMin;
                    if (param1.percent)
                    {
                        _loc_5 = _loc_2 + (_loc_6 - _loc_2) * _loc_4 - _loc_6;
                    }
                    else
                    {
                        _loc_5 = _loc_4 * (-_loc_3);
                    }
                    this._owner.width = this._owner._rawWidth - _loc_5;
                    this._owner.xMin = _loc_6 + _loc_5;
                    break;
                }
                case FRelationType.LeftExt_Right:
                {
                    _loc_6 = this._owner.xMin;
                    if (param1.percent)
                    {
                        _loc_5 = _loc_2 + (_loc_6 - _loc_2) * _loc_4 - _loc_6;
                    }
                    else
                    {
                        _loc_5 = _loc_4 * (1 - _loc_3);
                    }
                    this._owner.width = this._owner._rawWidth - _loc_5;
                    this._owner.xMin = _loc_6 + _loc_5;
                    break;
                }
                case FRelationType.RightExt_Left:
                {
                    _loc_6 = this._owner.xMin;
                    if (param1.percent)
                    {
                        _loc_5 = _loc_2 + (_loc_6 + this._owner._rawWidth - _loc_2) * _loc_4 - (_loc_6 + this._owner._rawWidth);
                    }
                    else
                    {
                        _loc_5 = _loc_4 * (-_loc_3);
                    }
                    this._owner.width = this._owner._rawWidth + _loc_5;
                    this._owner.xMin = _loc_6;
                    break;
                }
                case FRelationType.RightExt_Right:
                {
                    if (param1.percent)
                    {
                        if (this._owner == this._target.parent)
                        {
                            if (!FObjectFlags.isDocRoot(this._owner._flags))
                            {
                                _loc_6 = _loc_2 + this._target._width - this._target._width * _loc_3 + (this._owner.sourceWidth - _loc_2 - this._target.initWidth + this._target.initWidth * _loc_3) * _loc_4;
                            }
                            else
                            {
                                _loc_6 = _loc_2 + (this._owner._rawWidth - _loc_2) * _loc_4;
                            }
                            this._owner.setSize(_loc_6, this._owner._rawHeight, false, true);
                        }
                        else
                        {
                            _loc_6 = this._owner.xMin;
                            _loc_5 = _loc_2 + (_loc_6 + this._owner._rawWidth - _loc_2) * _loc_4 - (_loc_6 + this._owner._rawWidth);
                            this._owner.width = this._owner._rawWidth + _loc_5;
                            this._owner.xMin = _loc_6;
                        }
                    }
                    else if (this._owner == this._target.parent)
                    {
                        if (!FObjectFlags.isDocRoot(this._owner._flags))
                        {
                            _loc_6 = this._owner.sourceWidth + (this._target._width - this._target.initWidth) * (1 - _loc_3);
                        }
                        else
                        {
                            _loc_6 = this._owner._rawWidth + _loc_4 * (1 - _loc_3);
                        }
                        this._owner.setSize(_loc_6, this._owner._rawHeight, false, true);
                    }
                    else
                    {
                        _loc_6 = this._owner.xMin;
                        _loc_5 = _loc_4 * (1 - _loc_3);
                        this._owner.width = this._owner._rawWidth + _loc_5;
                        this._owner.xMin = _loc_6;
                    }
                    break;
                }
                case FRelationType.TopExt_Top:
                {
                    _loc_6 = this._owner.yMin;
                    if (param1.percent)
                    {
                        _loc_5 = _loc_2 + (_loc_6 - _loc_2) * _loc_4 - _loc_6;
                    }
                    else
                    {
                        _loc_5 = _loc_4 * (-_loc_3);
                    }
                    this._owner.height = this._owner._rawHeight - _loc_5;
                    this._owner.yMin = _loc_6 + _loc_5;
                    break;
                }
                case FRelationType.TopExt_Bottom:
                {
                    _loc_6 = this._owner.yMin;
                    if (param1.percent)
                    {
                        _loc_5 = _loc_2 + (_loc_6 - _loc_2) * _loc_4 - _loc_6;
                    }
                    else
                    {
                        _loc_5 = _loc_4 * (1 - _loc_3);
                    }
                    this._owner.height = this._owner._rawHeight - _loc_5;
                    this._owner.yMin = _loc_6 + _loc_5;
                    break;
                }
                case FRelationType.BottomExt_Top:
                {
                    _loc_6 = this._owner.yMin;
                    if (param1.percent)
                    {
                        _loc_5 = _loc_2 + (_loc_6 + this._owner._rawHeight - _loc_2) * _loc_4 - (_loc_6 + this._owner._rawHeight);
                    }
                    else
                    {
                        _loc_5 = _loc_4 * (-_loc_3);
                    }
                    this._owner.height = this._owner._rawHeight + _loc_5;
                    this._owner.yMin = _loc_6;
                    break;
                }
                case FRelationType.BottomExt_Bottom:
                {
                    if (param1.percent)
                    {
                        if (this._owner == this._target.parent)
                        {
                            if (!FObjectFlags.isDocRoot(this._owner._flags))
                            {
                                _loc_6 = _loc_2 + this._target._height - this._target._height * _loc_3 + (this._owner.sourceHeight - _loc_2 - this._target.initHeight + this._target.initHeight * _loc_3) * _loc_4;
                            }
                            else
                            {
                                _loc_6 = _loc_2 + (this._owner._rawHeight - _loc_2) * _loc_4;
                            }
                            this._owner.setSize(this._owner._rawWidth, _loc_6, false, true);
                        }
                        else
                        {
                            _loc_6 = this._owner.yMin;
                            _loc_5 = _loc_2 + (_loc_6 + this._owner._rawHeight - _loc_2) * _loc_4 - (_loc_6 + this._owner._rawHeight);
                            this._owner.height = this._owner._rawHeight + _loc_5;
                            this._owner.yMin = _loc_6;
                        }
                    }
                    else if (this._owner == this._target.parent)
                    {
                        if (!FObjectFlags.isDocRoot(this._owner._flags))
                        {
                            _loc_6 = this._owner.sourceHeight + (this._target._height - this._target.initHeight) * (1 - _loc_3);
                        }
                        else
                        {
                            _loc_6 = this._owner._rawHeight + _loc_4 * (1 - _loc_3);
                        }
                        this._owner.setSize(this._owner._rawWidth, _loc_6, false, true);
                    }
                    else
                    {
                        _loc_6 = this._owner.yMin;
                        _loc_5 = _loc_4 * (1 - _loc_3);
                        this._owner.height = this._owner._rawHeight + _loc_5;
                        this._owner.yMin = _loc_6;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function applySelfSizeChanged2(param1:FRelationDef, param2:Number, param3:Number, param4:Boolean) : void
        {
            switch(param1.type)
            {
                case FRelationType.Center_Center:
                {
                    this._owner.x = this._owner.x - (0.5 - (param4 ? (this._owner.pivotX) : (0))) * param2;
                    break;
                }
                case FRelationType.Right_Center:
                case FRelationType.Right_Left:
                case FRelationType.Right_Right:
                {
                    this._owner.x = this._owner.x - (1 - (param4 ? (this._owner.pivotX) : (0))) * param2;
                    break;
                }
                case FRelationType.Middle_Middle:
                {
                    this._owner.y = this._owner.y - (0.5 - (param4 ? (this._owner.pivotY) : (0))) * param3;
                    break;
                }
                case FRelationType.Bottom_Middle:
                case FRelationType.Bottom_Top:
                case FRelationType.Bottom_Bottom:
                {
                    this._owner.y = this._owner.y - (1 - (param4 ? (this._owner.pivotY) : (0))) * param3;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function addRefTarget(param1:FObject) : void
        {
            if (param1 != this._owner._parent)
            {
                param1.dispatcher.on(FObject.XY_CHANGED, this.__targetXYChanged);
            }
            param1.dispatcher.on(FObject.SIZE_CHANGED, this.__targetSizeChanged);
            this._targetX = this._target.x;
            this._targetY = this._target.y;
            this._targetWidth = this._target._width;
            this._targetHeight = this._target._height;
            return;
        }// end function

        private function releaseRefTarget(param1:FObject) : void
        {
            param1.dispatcher.off(FObject.XY_CHANGED, this.__targetXYChanged);
            param1.dispatcher.off(FObject.SIZE_CHANGED, this.__targetSizeChanged);
            return;
        }// end function

        private function __targetXYChanged(param1:FObject) : void
        {
            var _loc_6:* = null;
            if (this._owner.relations.handling || FObject.loadingSnapshot && this._owner._hasSnapshot || this._owner._group != null && this._owner._group._updating != 0 || this._owner is FGroup && !FGroup(this._owner).advanced)
            {
                this._targetX = this._target.x;
                this._targetY = this._target.y;
                return;
            }
            this._owner.relations.handling = param1;
            var _loc_2:* = this._owner.x;
            var _loc_3:* = this._owner.y;
            var _loc_4:* = this._target.x - this._targetX;
            var _loc_5:* = this._target.y - this._targetY;
            this.applyXYChanged(_loc_4, _loc_5);
            this._targetX = this._target.x;
            this._targetY = this._target.y;
            if (_loc_2 != this._owner.x || _loc_3 != this._owner.y)
            {
                _loc_2 = this._owner.x - _loc_2;
                _loc_3 = this._owner.y - _loc_3;
                this._owner.updateGearFromRelations(1, _loc_2, _loc_3);
                if ((this._owner._flags & FObjectFlags.IN_TEST) != 0 && this._owner._parent != null && !this._owner._parent.transitions.isEmpty)
                {
                    for each (_loc_6 in this._owner._parent.transitions.items)
                    {
                        
                        _loc_6.updateFromRelations(this._owner._id, _loc_2, _loc_3);
                    }
                }
            }
            this._owner.relations.handling = null;
            return;
        }// end function

        private function __targetSizeChanged(param1:FObject) : void
        {
            var _loc_6:* = null;
            if (this._owner.relations.handling || FObject.loadingSnapshot && this._owner._hasSnapshot || this._owner._group != null && this._owner._group._updating != 0 || this._owner is FGroup && !FGroup(this._owner).advanced)
            {
                this._targetWidth = this._target._width;
                this._targetHeight = this._target._height;
                return;
            }
            this._owner.relations.handling = param1;
            var _loc_2:* = this._owner.x;
            var _loc_3:* = this._owner.y;
            var _loc_4:* = this._owner._rawWidth;
            var _loc_5:* = this._owner._rawHeight;
            this.applySizeChanged();
            this._targetWidth = param1._width;
            this._targetHeight = param1._height;
            if (_loc_2 != this._owner.x || _loc_3 != this._owner.y)
            {
                _loc_2 = this._owner.x - _loc_2;
                _loc_3 = this._owner.y - _loc_3;
                this._owner.updateGearFromRelations(1, _loc_2, _loc_3);
                if ((this._owner._flags & FObjectFlags.IN_TEST) != 0 && this._owner._parent != null && !this._owner._parent.transitions.isEmpty)
                {
                    for each (_loc_6 in this._owner._parent.transitions.items)
                    {
                        
                        _loc_6.updateFromRelations(this._owner._id, _loc_2, _loc_3);
                    }
                }
            }
            if (_loc_4 != this._owner._rawWidth || _loc_5 != this._owner._rawHeight)
            {
                _loc_2 = this._owner._rawWidth - _loc_4;
                _loc_3 = this._owner._rawHeight - _loc_5;
                this._owner.updateGearFromRelations(2, _loc_2, _loc_3);
            }
            this._owner.relations.handling = null;
            return;
        }// end function

    }
}
