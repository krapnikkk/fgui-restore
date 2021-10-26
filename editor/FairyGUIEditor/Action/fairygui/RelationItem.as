package fairygui
{
    import *.*;
    import __AS3__.vec.*;

    class RelationItem extends Object
    {
        private var _owner:GObject;
        private var _target:GObject;
        private var _defs:Vector.<RelationDef>;
        private var _targetX:Number;
        private var _targetY:Number;
        private var _targetWidth:Number;
        private var _targetHeight:Number;

        function RelationItem(param1:GObject)
        {
            _owner = param1;
            _defs = new Vector.<RelationDef>;
            return;
        }// end function

        final public function get owner() : GObject
        {
            return _owner;
        }// end function

        public function set target(param1:GObject) : void
        {
            if (_target != param1)
            {
                if (_target)
                {
                    releaseRefTarget(_target);
                }
                _target = param1;
                if (_target)
                {
                    addRefTarget(_target);
                }
            }
            return;
        }// end function

        final public function get target() : GObject
        {
            return _target;
        }// end function

        public function add(param1:int, param2:Boolean) : void
        {
            if (param1 == 24)
            {
                add(14, param2);
                add(15, param2);
                return;
            }
            for each (_loc_3 in _defs)
            {
                
                if (_loc_3.type == param1)
                {
                    return;
                }
            }
            internalAdd(param1, param2);
            return;
        }// end function

        public function internalAdd(param1:int, param2:Boolean) : void
        {
            if (param1 == 24)
            {
                internalAdd(14, param2);
                internalAdd(15, param2);
                return;
            }
            var _loc_3:* = new RelationDef();
            _loc_3.percent = param2;
            _loc_3.type = param1;
            _loc_3.axis = param1 <= 6 || param1 == 14 || param1 >= 16 && param1 <= 19 ? (0) : (1);
            _defs.push(_loc_3);
            if (param2 || param1 == 1 || param1 == 3 || param1 == 5 || param1 == 8 || param1 == 10 || param1 == 12)
            {
                _owner.pixelSnapping = true;
            }
            return;
        }// end function

        public function remove(param1:int) : void
        {
            var _loc_2:* = 0;
            if (param1 == 24)
            {
                remove(14);
                remove(15);
                return;
            }
            var _loc_3:* = _defs.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                if (_defs[_loc_2].type == param1)
                {
                    _defs.splice(_loc_2, 1);
                    break;
                }
                _loc_2++;
            }
            return;
        }// end function

        public function copyFrom(param1:RelationItem) : void
        {
            var _loc_3:* = null;
            this.target = param1.target;
            _defs.length = 0;
            for each (_loc_2 in param1._defs)
            {
                
                _loc_3 = new RelationDef();
                _loc_3.copyFrom(_loc_2);
                _defs.push(_loc_3);
            }
            return;
        }// end function

        public function dispose() : void
        {
            if (_target != null)
            {
                releaseRefTarget(_target);
                _target = null;
            }
            return;
        }// end function

        final public function get isEmpty() : Boolean
        {
            return _defs.length == 0;
        }// end function

        public function applyOnSelfResized(param1:Number, param2:Number, param3:Boolean) : void
        {
            var _loc_6:* = 0;
            var _loc_8:* = null;
            var _loc_4:* = _defs.length;
            if (_defs.length == 0)
            {
                return;
            }
            var _loc_5:* = _owner.x;
            var _loc_7:* = _owner.y;
            _loc_6 = 0;
            while (_loc_6 < _loc_4)
            {
                
                _loc_8 = _defs[_loc_6];
                switch(_loc_8.type - 3) branch count is:<10>[38, 79, 79, 79, 196, 196, 196, 119, 160, 160, 160] default offset is:<196>;
                _owner.x = _owner.x - (0.5 - (param3 ? (_owner.pivotX) : (0))) * param1;
                ;
                _owner.x = _owner.x - (1 - (param3 ? (_owner.pivotX) : (0))) * param1;
                ;
                _owner.y = _owner.y - (0.5 - (param3 ? (_owner.pivotY) : (0))) * param2;
                ;
                _owner.y = _owner.y - (1 - (param3 ? (_owner.pivotY) : (0))) * param2;
                _loc_6++;
            }
            if (_loc_5 != _owner.x || _loc_7 != _owner.y)
            {
                _loc_5 = _owner.x - _loc_5;
                _loc_7 = _owner.y - _loc_7;
                _owner.updateGearFromRelations(1, _loc_5, _loc_7);
                if (_owner.parent != null && _owner.parent._transitions.length > 0)
                {
                    for each (_loc_9 in _owner.parent._transitions)
                    {
                        
                        (_loc_9).updateFromRelations(_owner.id, _loc_5, _loc_7);
                    }
                }
            }
            return;
        }// end function

        private function applyOnXYChanged(param1:RelationDef, param2:Number, param3:Number) : void
        {
            var _loc_4:* = NaN;
            var _loc_5:* = param1.type;
            while (_loc_5 === 0)
            {
                
                
                
                
                
                
                
                _owner.x = _owner.x + param2;
                do
                {
                    
                    
                    
                    
                    
                    
                    
                    _owner.y = _owner.y + param3;
                    do
                    {
                        
                        
                        do
                        {
                            
                            
                            if (_owner != _target.parent)
                            {
                                _loc_4 = _owner.xMin;
                                _owner.width = _owner._rawWidth - param2;
                                _owner.xMin = _loc_4 + param2;
                            }
                            else
                            {
                                _owner.width = _owner._rawWidth - param2;
                            }
                            do
                            {
                                
                                
                                if (_owner != _target.parent)
                                {
                                    _loc_4 = _owner.xMin;
                                    _owner.width = _owner._rawWidth + param2;
                                    _owner.xMin = _loc_4;
                                }
                                else
                                {
                                    _owner.width = _owner._rawWidth + param2;
                                }
                                do
                                {
                                    
                                    
                                    if (_owner != _target.parent)
                                    {
                                        _loc_4 = _owner.yMin;
                                        _owner.height = _owner._rawHeight - param3;
                                        _owner.yMin = _loc_4 + param3;
                                    }
                                    else
                                    {
                                        _owner.height = _owner._rawHeight - param3;
                                    }
                                    do
                                    {
                                        
                                        
                                        if (_owner != _target.parent)
                                        {
                                            _loc_4 = _owner.yMin;
                                            _owner.height = _owner._rawHeight + param3;
                                            _owner.yMin = _loc_4;
                                        }
                                        else
                                        {
                                            _owner.height = _owner._rawHeight + param3;
                                        }
                                        break;
                                    }
                                    if (1 === _loc_5) goto 16;
                                    if (2 === _loc_5) goto 17;
                                    if (3 === _loc_5) goto 18;
                                    if (4 === _loc_5) goto 19;
                                    if (5 === _loc_5) goto 20;
                                    if (6 === _loc_5) goto 21;
                                }while (_loc_5 === 7)
                                if (8 === _loc_5) goto 42;
                                if (9 === _loc_5) goto 43;
                                if (10 === _loc_5) goto 44;
                                if (11 === _loc_5) goto 45;
                                if (12 === _loc_5) goto 46;
                                if (13 === _loc_5) goto 47;
                            }while (_loc_5 === 14)
                            if (15 === _loc_5) goto 68;
                        }while (_loc_5 === 16)
                        if (17 === _loc_5) goto 74;
                    }while (_loc_5 === 18)
                    if (19 === _loc_5) goto 144;
                }while (_loc_5 === 20)
                if (21 === _loc_5) goto 212;
            }while (_loc_5 === 22)
            if (23 === _loc_5) goto 282;
            return;
        }// end function

        private function applyOnSizeChanged(param1:RelationDef) : void
        {
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_2:* = 0;
            var _loc_6:* = 0;
            var _loc_5:* = 0;
            if (param1.axis == 0)
            {
                if (_target != _owner.parent)
                {
                    _loc_2 = _target.x;
                    if (_target.pivotAsAnchor)
                    {
                        _loc_6 = _target.pivotX;
                    }
                }
                if (param1.percent)
                {
                    if (_targetWidth != 0)
                    {
                        _loc_5 = _target._width / _targetWidth;
                    }
                }
                else
                {
                    _loc_5 = _target._width - _targetWidth;
                }
            }
            else
            {
                if (_target != _owner.parent)
                {
                    _loc_2 = _target.y;
                    if (_target.pivotAsAnchor)
                    {
                        _loc_6 = _target.pivotY;
                    }
                }
                if (param1.percent)
                {
                    if (_targetHeight != 0)
                    {
                        _loc_5 = _target._height / _targetHeight;
                    }
                }
                else
                {
                    _loc_5 = _target._height - _targetHeight;
                }
            }
            var _loc_7:* = param1.type;
            while (_loc_7 === 0)
            {
                
                if (param1.percent)
                {
                    _owner.xMin = _loc_2 + (_owner.xMin - _loc_2) * _loc_5;
                }
                else if (_loc_6 != 0)
                {
                    _owner.x = _owner.x + _loc_5 * (-_loc_6);
                }
                do
                {
                    
                    if (param1.percent)
                    {
                        _owner.xMin = _loc_2 + (_owner.xMin - _loc_2) * _loc_5;
                    }
                    else
                    {
                        _owner.x = _owner.x + _loc_5 * (0.5 - _loc_6);
                    }
                    do
                    {
                        
                        if (param1.percent)
                        {
                            _owner.xMin = _loc_2 + (_owner.xMin - _loc_2) * _loc_5;
                        }
                        else
                        {
                            _owner.x = _owner.x + _loc_5 * (1 - _loc_6);
                        }
                        do
                        {
                            
                            if (param1.percent)
                            {
                                _owner.xMin = _loc_2 + (_owner.xMin + _owner._rawWidth * 0.5 - _loc_2) * _loc_5 - _owner._rawWidth * 0.5;
                            }
                            else
                            {
                                _owner.x = _owner.x + _loc_5 * (0.5 - _loc_6);
                            }
                            do
                            {
                                
                                if (param1.percent)
                                {
                                    _owner.xMin = _loc_2 + (_owner.xMin + _owner._rawWidth - _loc_2) * _loc_5 - _owner._rawWidth;
                                }
                                else if (_loc_6 != 0)
                                {
                                    _owner.x = _owner.x + _loc_5 * (-_loc_6);
                                }
                                do
                                {
                                    
                                    if (param1.percent)
                                    {
                                        _owner.xMin = _loc_2 + (_owner.xMin + _owner._rawWidth - _loc_2) * _loc_5 - _owner._rawWidth;
                                    }
                                    else
                                    {
                                        _owner.x = _owner.x + _loc_5 * (0.5 - _loc_6);
                                    }
                                    do
                                    {
                                        
                                        if (param1.percent)
                                        {
                                            _owner.xMin = _loc_2 + (_owner.xMin + _owner._rawWidth - _loc_2) * _loc_5 - _owner._rawWidth;
                                        }
                                        else
                                        {
                                            _owner.x = _owner.x + _loc_5 * (1 - _loc_6);
                                        }
                                        do
                                        {
                                            
                                            if (param1.percent)
                                            {
                                                _owner.yMin = _loc_2 + (_owner.yMin - _loc_2) * _loc_5;
                                            }
                                            else if (_loc_6 != 0)
                                            {
                                                _owner.y = _owner.y + _loc_5 * (-_loc_6);
                                            }
                                            do
                                            {
                                                
                                                if (param1.percent)
                                                {
                                                    _owner.yMin = _loc_2 + (_owner.yMin - _loc_2) * _loc_5;
                                                }
                                                else
                                                {
                                                    _owner.y = _owner.y + _loc_5 * (0.5 - _loc_6);
                                                }
                                                do
                                                {
                                                    
                                                    if (param1.percent)
                                                    {
                                                        _owner.yMin = _loc_2 + (_owner.yMin - _loc_2) * _loc_5;
                                                    }
                                                    else
                                                    {
                                                        _owner.y = _owner.y + _loc_5 * (1 - _loc_6);
                                                    }
                                                    do
                                                    {
                                                        
                                                        if (param1.percent)
                                                        {
                                                            _owner.yMin = _loc_2 + (_owner.yMin + _owner._rawHeight * 0.5 - _loc_2) * _loc_5 - _owner._rawHeight * 0.5;
                                                        }
                                                        else
                                                        {
                                                            _owner.y = _owner.y + _loc_5 * (0.5 - _loc_6);
                                                        }
                                                        do
                                                        {
                                                            
                                                            if (param1.percent)
                                                            {
                                                                _owner.yMin = _loc_2 + (_owner.yMin + _owner._rawHeight - _loc_2) * _loc_5 - _owner._rawHeight;
                                                            }
                                                            else if (_loc_6 != 0)
                                                            {
                                                                _owner.y = _owner.y + _loc_5 * (-_loc_6);
                                                            }
                                                            do
                                                            {
                                                                
                                                                if (param1.percent)
                                                                {
                                                                    _owner.yMin = _loc_2 + (_owner.yMin + _owner._rawHeight - _loc_2) * _loc_5 - _owner._rawHeight;
                                                                }
                                                                else
                                                                {
                                                                    _owner.y = _owner.y + _loc_5 * (0.5 - _loc_6);
                                                                }
                                                                do
                                                                {
                                                                    
                                                                    if (param1.percent)
                                                                    {
                                                                        _owner.yMin = _loc_2 + (_owner.yMin + _owner._rawHeight - _loc_2) * _loc_5 - _owner._rawHeight;
                                                                    }
                                                                    else
                                                                    {
                                                                        _owner.y = _owner.y + _loc_5 * (1 - _loc_6);
                                                                    }
                                                                    do
                                                                    {
                                                                        
                                                                        if (_owner._underConstruct && _owner == _target.parent)
                                                                        {
                                                                            _loc_4 = _owner.sourceWidth - _target.initWidth;
                                                                        }
                                                                        else
                                                                        {
                                                                            _loc_4 = _owner._rawWidth - _targetWidth;
                                                                        }
                                                                        if (param1.percent)
                                                                        {
                                                                            _loc_4 = _loc_4 * _loc_5;
                                                                        }
                                                                        if (_target == _owner.parent)
                                                                        {
                                                                            if (_owner.pivotAsAnchor)
                                                                            {
                                                                                _loc_3 = _owner.xMin;
                                                                                _owner.setSize(_target._width + _loc_4, _owner._rawHeight, true);
                                                                                _owner.xMin = _loc_3;
                                                                            }
                                                                            else
                                                                            {
                                                                                _owner.setSize(_target._width + _loc_4, _owner._rawHeight, true);
                                                                            }
                                                                        }
                                                                        else
                                                                        {
                                                                            _owner.width = _target._width + _loc_4;
                                                                        }
                                                                        do
                                                                        {
                                                                            
                                                                            if (_owner._underConstruct && _owner == _target.parent)
                                                                            {
                                                                                _loc_4 = _owner.sourceHeight - _target.initHeight;
                                                                            }
                                                                            else
                                                                            {
                                                                                _loc_4 = _owner._rawHeight - _targetHeight;
                                                                            }
                                                                            if (param1.percent)
                                                                            {
                                                                                _loc_4 = _loc_4 * _loc_5;
                                                                            }
                                                                            if (_target == _owner.parent)
                                                                            {
                                                                                if (_owner.pivotAsAnchor)
                                                                                {
                                                                                    _loc_3 = _owner.yMin;
                                                                                    _owner.setSize(_owner._rawWidth, _target._height + _loc_4, true);
                                                                                    _owner.yMin = _loc_3;
                                                                                }
                                                                                else
                                                                                {
                                                                                    _owner.setSize(_owner._rawWidth, _target._height + _loc_4, true);
                                                                                }
                                                                            }
                                                                            else
                                                                            {
                                                                                _owner.height = _target._height + _loc_4;
                                                                            }
                                                                            do
                                                                            {
                                                                                
                                                                                _loc_3 = _owner.xMin;
                                                                                if (param1.percent)
                                                                                {
                                                                                    _loc_4 = _loc_2 + (_loc_3 - _loc_2) * _loc_5 - _loc_3;
                                                                                }
                                                                                else
                                                                                {
                                                                                    _loc_4 = _loc_5 * (-_loc_6);
                                                                                }
                                                                                _owner.width = _owner._rawWidth - _loc_4;
                                                                                _owner.xMin = _loc_3 + _loc_4;
                                                                                do
                                                                                {
                                                                                    
                                                                                    _loc_3 = _owner.xMin;
                                                                                    if (param1.percent)
                                                                                    {
                                                                                        _loc_4 = _loc_2 + (_loc_3 - _loc_2) * _loc_5 - _loc_3;
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        _loc_4 = _loc_5 * (1 - _loc_6);
                                                                                    }
                                                                                    _owner.width = _owner._rawWidth - _loc_4;
                                                                                    _owner.xMin = _loc_3 + _loc_4;
                                                                                    do
                                                                                    {
                                                                                        
                                                                                        _loc_3 = _owner.xMin;
                                                                                        if (param1.percent)
                                                                                        {
                                                                                            _loc_4 = _loc_2 + (_loc_3 + _owner._rawWidth - _loc_2) * _loc_5 - (_loc_3 + _owner._rawWidth);
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            _loc_4 = _loc_5 * (-_loc_6);
                                                                                        }
                                                                                        _owner.width = _owner._rawWidth + _loc_4;
                                                                                        _owner.xMin = _loc_3;
                                                                                        do
                                                                                        {
                                                                                            
                                                                                            _loc_3 = _owner.xMin;
                                                                                            if (param1.percent)
                                                                                            {
                                                                                                if (_owner == _target.parent)
                                                                                                {
                                                                                                    if (_owner._underConstruct)
                                                                                                    {
                                                                                                        _owner.width = _loc_2 + _target._width - _target._width * _loc_6 + (_owner.sourceWidth - _loc_2 - _target.initWidth + _target.initWidth * _loc_6) * _loc_5;
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        _owner.width = _loc_2 + (_owner._rawWidth - _loc_2) * _loc_5;
                                                                                                    }
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    _loc_4 = _loc_2 + (_loc_3 + _owner._rawWidth - _loc_2) * _loc_5 - (_loc_3 + _owner._rawWidth);
                                                                                                    _owner.width = _owner._rawWidth + _loc_4;
                                                                                                    _owner.xMin = _loc_3;
                                                                                                }
                                                                                            }
                                                                                            else if (_owner == _target.parent)
                                                                                            {
                                                                                                if (_owner._underConstruct)
                                                                                                {
                                                                                                    _owner.width = _owner.sourceWidth + (_target._width - _target.initWidth) * (1 - _loc_6);
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    _owner.width = _owner._rawWidth + _loc_5 * (1 - _loc_6);
                                                                                                }
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                _loc_4 = _loc_5 * (1 - _loc_6);
                                                                                                _owner.width = _owner._rawWidth + _loc_4;
                                                                                                _owner.xMin = _loc_3;
                                                                                            }
                                                                                            do
                                                                                            {
                                                                                                
                                                                                                _loc_3 = _owner.yMin;
                                                                                                if (param1.percent)
                                                                                                {
                                                                                                    _loc_4 = _loc_2 + (_loc_3 - _loc_2) * _loc_5 - _loc_3;
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    _loc_4 = _loc_5 * (-_loc_6);
                                                                                                }
                                                                                                _owner.height = _owner._rawHeight - _loc_4;
                                                                                                _owner.yMin = _loc_3 + _loc_4;
                                                                                                do
                                                                                                {
                                                                                                    
                                                                                                    _loc_3 = _owner.yMin;
                                                                                                    if (param1.percent)
                                                                                                    {
                                                                                                        _loc_4 = _loc_2 + (_loc_3 - _loc_2) * _loc_5 - _loc_3;
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        _loc_4 = _loc_5 * (1 - _loc_6);
                                                                                                    }
                                                                                                    _owner.height = _owner._rawHeight - _loc_4;
                                                                                                    _owner.yMin = _loc_3 + _loc_4;
                                                                                                    do
                                                                                                    {
                                                                                                        
                                                                                                        _loc_3 = _owner.yMin;
                                                                                                        if (param1.percent)
                                                                                                        {
                                                                                                            _loc_4 = _loc_2 + (_loc_3 + _owner._rawHeight - _loc_2) * _loc_5 - (_loc_3 + _owner._rawHeight);
                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                            _loc_4 = _loc_5 * (-_loc_6);
                                                                                                        }
                                                                                                        _owner.height = _owner._rawHeight + _loc_4;
                                                                                                        _owner.yMin = _loc_3;
                                                                                                        do
                                                                                                        {
                                                                                                            
                                                                                                            _loc_3 = _owner.yMin;
                                                                                                            if (param1.percent)
                                                                                                            {
                                                                                                                if (_owner == _target.parent)
                                                                                                                {
                                                                                                                    if (_owner._underConstruct)
                                                                                                                    {
                                                                                                                        _owner.height = _loc_2 + _target._height - _target._height * _loc_6 + (_owner.sourceHeight - _loc_2 - _target.initHeight + _target.initHeight * _loc_6) * _loc_5;
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        _owner.height = _loc_2 + (_owner._rawHeight - _loc_2) * _loc_5;
                                                                                                                    }
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    _loc_4 = _loc_2 + (_loc_3 + _owner._rawHeight - _loc_2) * _loc_5 - (_loc_3 + _owner._rawHeight);
                                                                                                                    _owner.height = _owner._rawHeight + _loc_4;
                                                                                                                    _owner.yMin = _loc_3;
                                                                                                                }
                                                                                                            }
                                                                                                            else if (_owner == _target.parent)
                                                                                                            {
                                                                                                                if (_owner._underConstruct)
                                                                                                                {
                                                                                                                    _owner.height = _owner.sourceHeight + (_target._height - _target.initHeight) * (1 - _loc_6);
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    _owner.height = _owner._rawHeight + _loc_5 * (1 - _loc_6);
                                                                                                                }
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                _loc_4 = _loc_5 * (1 - _loc_6);
                                                                                                                _owner.height = _owner._rawHeight + _loc_4;
                                                                                                                _owner.yMin = _loc_3;
                                                                                                            }
                                                                                                            break;
                                                                                                        }
                                                                                                    }while (_loc_7 === 1)
                                                                                                }while (_loc_7 === 2)
                                                                                            }while (_loc_7 === 3)
                                                                                        }while (_loc_7 === 4)
                                                                                    }while (_loc_7 === 5)
                                                                                }while (_loc_7 === 6)
                                                                            }while (_loc_7 === 7)
                                                                        }while (_loc_7 === 8)
                                                                    }while (_loc_7 === 9)
                                                                }while (_loc_7 === 10)
                                                            }while (_loc_7 === 11)
                                                        }while (_loc_7 === 12)
                                                    }while (_loc_7 === 13)
                                                }while (_loc_7 === 14)
                                            }while (_loc_7 === 15)
                                        }while (_loc_7 === 16)
                                    }while (_loc_7 === 17)
                                }while (_loc_7 === 18)
                            }while (_loc_7 === 19)
                        }while (_loc_7 === 20)
                    }while (_loc_7 === 21)
                }while (_loc_7 === 22)
            }while (_loc_7 === 23)
            return;
        }// end function

        private function addRefTarget(param1:GObject) : void
        {
            if (param1 != _owner.parent)
            {
                param1.addXYChangeCallback(__targetXYChanged);
            }
            param1.addSizeChangeCallback(__targetSizeChanged);
            param1.addSizeDelayChangeCallback(__targetSizeWillChange);
            _targetX = _target.x;
            _targetY = _target.y;
            _targetWidth = _target._width;
            _targetHeight = _target._height;
            return;
        }// end function

        private function releaseRefTarget(param1:GObject) : void
        {
            param1.removeXYChangeCallback(__targetXYChanged);
            param1.removeSizeChangeCallback(__targetSizeChanged);
            param1.removeSizeDelayChangeCallback(__targetSizeWillChange);
            return;
        }// end function

        private function __targetXYChanged(param1:GObject) : void
        {
            if (_owner.relations.handling != null || _owner.group != null && _owner.group._updating)
            {
                _targetX = _target.x;
                _targetY = _target.y;
                return;
            }
            _owner.relations.handling = param1;
            var _loc_4:* = _owner.x;
            var _loc_5:* = _owner.y;
            var _loc_2:* = _target.x - _targetX;
            var _loc_3:* = _target.y - _targetY;
            for each (_loc_6 in _defs)
            {
                
                applyOnXYChanged(_loc_6, _loc_2, _loc_3);
            }
            _targetX = _target.x;
            _targetY = _target.y;
            if (_loc_4 != _owner.x || _loc_5 != _owner.y)
            {
                _loc_4 = _owner.x - _loc_4;
                _loc_5 = _owner.y - _loc_5;
                _owner.updateGearFromRelations(1, _loc_4, _loc_5);
                if (_owner.parent != null && _owner.parent._transitions.length > 0)
                {
                    for each (_loc_7 in _owner.parent._transitions)
                    {
                        
                        (_loc_7).updateFromRelations(_owner.id, _loc_4, _loc_5);
                    }
                }
            }
            _owner.relations.handling = null;
            return;
        }// end function

        private function __targetSizeChanged(param1:GObject) : void
        {
            if (_owner.relations.sizeDirty)
            {
                _owner.relations.ensureRelationsSizeCorrect();
            }
            if (_owner.relations.handling != null)
            {
                _targetWidth = _target._width;
                _targetHeight = _target._height;
                return;
            }
            _owner.relations.handling = param1;
            var _loc_3:* = _owner.x;
            var _loc_5:* = _owner.y;
            var _loc_2:* = _owner._rawWidth;
            var _loc_4:* = _owner._rawHeight;
            for each (_loc_6 in _defs)
            {
                
                applyOnSizeChanged(_loc_6);
            }
            _targetWidth = _target._width;
            _targetHeight = _target._height;
            if (_loc_3 != _owner.x || _loc_5 != _owner.y)
            {
                _loc_3 = _owner.x - _loc_3;
                _loc_5 = _owner.y - _loc_5;
                _owner.updateGearFromRelations(1, _loc_3, _loc_5);
                if (_owner.parent != null && _owner.parent._transitions.length > 0)
                {
                    for each (_loc_7 in _owner.parent._transitions)
                    {
                        
                        (_loc_7).updateFromRelations(_owner.id, _loc_3, _loc_5);
                    }
                }
            }
            if (_loc_2 != _owner._rawWidth || _loc_4 != _owner._rawHeight)
            {
                _loc_2 = _owner._rawWidth - _loc_2;
                _loc_4 = _owner._rawHeight - _loc_4;
                _owner.updateGearFromRelations(2, _loc_2, _loc_4);
            }
            _owner.relations.handling = null;
            return;
        }// end function

        private function __targetSizeWillChange(param1:GObject) : void
        {
            _owner.relations.sizeDirty = true;
            return;
        }// end function

    }
}

import *.*;

import __AS3__.vec.*;

class RelationDef extends Object
{
    public var percent:Boolean;
    public var type:int;
    public var axis:int;

    function RelationDef()
    {
        return;
    }// end function

    public function copyFrom(param1:RelationDef) : void
    {
        this.percent = param1.percent;
        this.type = param1.type;
        this.axis = param1.axis;
        return;
    }// end function

}

