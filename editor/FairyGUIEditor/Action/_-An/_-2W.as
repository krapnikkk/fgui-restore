package _-An
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.gui.*;

    class _-2W extends Object
    {

        function _-2W()
        {
            return;
        }// end function

        private static function _-CS(param1:FObject, param2:Number) : void
        {
            if (param1.anchor)
            {
                param1.docElement.setProperty("x", param2 + param1.width * param1.pivotX);
            }
            else
            {
                param1.docElement.setProperty("x", param2);
            }
            return;
        }// end function

        private static function _-Gi(param1:FObject, param2:Number) : void
        {
            _-CS(param1, param2 - param1.width);
            return;
        }// end function

        private static function _-PO(param1:FObject, param2:Number) : void
        {
            if (param1.anchor)
            {
                param1.docElement.setProperty("y", param2 + param1.height * param1.pivotY);
            }
            else
            {
                param1.docElement.setProperty("y", param2);
            }
            return;
        }// end function

        private static function _-Hv(param1:FObject, param2:Number) : void
        {
            _-PO(param1, param2 - param1.height);
            return;
        }// end function

        public static function _-72(param1:_-On) : void
        {
            var _loc_4:* = 0;
            var _loc_7:* = null;
            var _loc_2:* = param1.getSelection();
            var _loc_3:* = _loc_2.length;
            if (_loc_3 == 0)
            {
                return;
            }
            if (_loc_3 == 1)
            {
                _loc_7 = _loc_2[0];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 1))
                {
                    _-CS(_loc_7, 0);
                }
                return;
            }
            param1.setVar("selectionTransforming", true);
            var _loc_5:* = _loc_7.xMin;
            var _loc_6:* = 1;
            while (_loc_6 < _loc_3)
            {
                
                _loc_7 = _loc_2[_loc_6];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 1))
                {
                    _-CS(_loc_7, _loc_5);
                }
                _loc_6++;
            }
            param1.setVar("selectionTransforming", false);
            return;
        }// end function

        public static function _-JJ(param1:_-On) : void
        {
            var _loc_4:* = 0;
            var _loc_7:* = null;
            var _loc_2:* = param1.getSelection();
            var _loc_3:* = _loc_2.length;
            if (_loc_3 == 0)
            {
                return;
            }
            if (_loc_3 == 1)
            {
                _loc_7 = _loc_2[0];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 1))
                {
                    _-Gi(_loc_7, param1.content.width);
                }
                return;
            }
            param1.setVar("selectionTransforming", true);
            var _loc_5:* = _loc_7.xMax;
            var _loc_6:* = 1;
            while (_loc_6 < _loc_3)
            {
                
                _loc_7 = _loc_2[_loc_6];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 1))
                {
                    _-Gi(_loc_7, _loc_5);
                }
                _loc_6++;
            }
            param1.setVar("selectionTransforming", false);
            return;
        }// end function

        public static function _-H9(param1:_-On) : void
        {
            var _loc_4:* = 0;
            var _loc_7:* = null;
            var _loc_2:* = param1.getSelection();
            var _loc_3:* = _loc_2.length;
            if (_loc_3 == 0)
            {
                return;
            }
            if (_loc_3 == 1)
            {
                _loc_7 = _loc_2[0];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 1))
                {
                    _-CS(_loc_7, int((param1.content.width - _loc_7.width) / 2));
                }
                return;
            }
            param1.setVar("selectionTransforming", true);
            var _loc_5:* = _loc_7.xMin + _loc_7.width / 2;
            var _loc_6:* = 1;
            while (_loc_6 < _loc_3)
            {
                
                _loc_7 = _loc_2[_loc_6];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 1))
                {
                    _-CS(_loc_7, int(_loc_5 - _loc_7.width / 2));
                }
                _loc_6++;
            }
            param1.setVar("selectionTransforming", false);
            return;
        }// end function

        public static function _-7z(param1:_-On) : void
        {
            var _loc_4:* = 0;
            var _loc_7:* = null;
            var _loc_2:* = param1.getSelection();
            var _loc_3:* = _loc_2.length;
            if (_loc_3 == 0)
            {
                return;
            }
            if (_loc_3 == 1)
            {
                _loc_7 = _loc_2[0];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 2))
                {
                    _-PO(_loc_7, 0);
                }
                return;
            }
            param1.setVar("selectionTransforming", true);
            var _loc_5:* = _loc_7.yMin;
            var _loc_6:* = 1;
            while (_loc_6 < _loc_3)
            {
                
                _loc_7 = _loc_2[_loc_6];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 2))
                {
                    _-PO(_loc_7, _loc_5);
                }
                _loc_6++;
            }
            param1.setVar("selectionTransforming", false);
            return;
        }// end function

        public static function _-OX(param1:_-On) : void
        {
            var _loc_4:* = 0;
            var _loc_7:* = null;
            var _loc_2:* = param1.getSelection();
            var _loc_3:* = _loc_2.length;
            if (_loc_3 == 0)
            {
                return;
            }
            if (_loc_3 == 1)
            {
                _loc_7 = _loc_2[0];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 2))
                {
                    _-Hv(_loc_7, param1.content.height);
                }
                return;
            }
            param1.setVar("selectionTransforming", true);
            var _loc_5:* = _loc_7.yMax;
            var _loc_6:* = 1;
            while (_loc_6 < _loc_3)
            {
                
                _loc_7 = _loc_2[_loc_6];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 2))
                {
                    _-Hv(_loc_7, _loc_5);
                }
                _loc_6++;
            }
            param1.setVar("selectionTransforming", false);
            return;
        }// end function

        public static function _-36(param1:_-On) : void
        {
            var _loc_4:* = 0;
            var _loc_7:* = null;
            var _loc_2:* = param1.getSelection();
            var _loc_3:* = _loc_2.length;
            if (_loc_3 == 0)
            {
                return;
            }
            if (_loc_3 == 1)
            {
                _loc_7 = _loc_2[0];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 2))
                {
                    _-PO(_loc_7, int((param1.content.height - _loc_7.height) / 2));
                }
                return;
            }
            param1.setVar("selectionTransforming", true);
            var _loc_5:* = _loc_7.yMin + _loc_7.height / 2;
            var _loc_6:* = 1;
            while (_loc_6 < _loc_3)
            {
                
                _loc_7 = _loc_2[_loc_6];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 2))
                {
                    _-PO(_loc_7, int(_loc_5 - _loc_7.height / 2));
                }
                _loc_6++;
            }
            param1.setVar("selectionTransforming", false);
            return;
        }// end function

        public static function _-Jr(param1:_-On) : void
        {
            var _loc_4:* = 0;
            var _loc_7:* = null;
            var _loc_2:* = param1.getSelection();
            var _loc_3:* = _loc_2.length;
            if (_loc_3 == 0)
            {
                return;
            }
            if (_loc_3 == 1)
            {
                _loc_7 = _loc_2[0];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 4))
                {
                    _loc_7.docElement.setProperty("width", param1.content.width);
                }
                return;
            }
            param1.setVar("selectionTransforming", true);
            var _loc_5:* = _loc_7.width;
            var _loc_6:* = 1;
            while (_loc_6 < _loc_3)
            {
                
                _loc_7 = _loc_2[_loc_6];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 4))
                {
                    _loc_7.docElement.setProperty("width", _loc_5);
                    _loc_5 = _loc_7.width;
                    if (_loc_7.aspectLocked)
                    {
                        _loc_7.docElement.setProperty("height", int(_loc_5 / _loc_7.aspectRatio));
                    }
                }
                _loc_6++;
            }
            param1.setVar("selectionTransforming", false);
            return;
        }// end function

        public static function _-9d(param1:_-On) : void
        {
            var _loc_4:* = 0;
            var _loc_7:* = null;
            var _loc_2:* = param1.getSelection();
            var _loc_3:* = _loc_2.length;
            if (_loc_3 == 0)
            {
                return;
            }
            if (_loc_3 == 1)
            {
                _loc_7 = _loc_2[0];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 8))
                {
                    _loc_7.docElement.setProperty("height", param1.content.height);
                }
                return;
            }
            param1.setVar("selectionTransforming", true);
            var _loc_5:* = _loc_7.height;
            var _loc_6:* = 1;
            while (_loc_6 < _loc_3)
            {
                
                _loc_7 = _loc_2[_loc_6];
                _loc_4 = param1._-MJ(_loc_7);
                if (!(_loc_4 & 8))
                {
                    _loc_7.docElement.setProperty("height", _loc_5);
                    _loc_5 = _loc_7.height;
                    if (_loc_7.aspectLocked)
                    {
                        _loc_7.docElement.setProperty("width", int(_loc_5 * _loc_7.aspectRatio));
                    }
                }
                _loc_6++;
            }
            param1.setVar("selectionTransforming", false);
            return;
        }// end function

        public static function _-Kx(param1:_-On, param2:int, param3:int, param4:int, param5:int) : void
        {
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_12:* = 0;
            var _loc_13:* = 0;
            var _loc_14:* = 0;
            var _loc_15:* = null;
            var _loc_6:* = param1.getSelection();
            var _loc_7:* = _loc_6.length;
            if (_loc_6.length <= 1)
            {
                return;
            }
            param1.setVar("selectionTransforming", true);
            var _loc_11:* = [];
            if (param2 == 0)
            {
                _loc_9 = 0;
                while (_loc_9 < _loc_7)
                {
                    
                    _loc_10 = _loc_6[_loc_9];
                    _loc_11.push(_loc_10);
                    _loc_9++;
                }
                _loc_11.sortOn("y", Array.NUMERIC);
                _loc_9 = 1;
                while (_loc_9 < _loc_7)
                {
                    
                    _loc_10 = _loc_11[_loc_9];
                    _loc_8 = param1._-MJ(_loc_10);
                    if (!(_loc_8 & 2))
                    {
                        _loc_10.docElement.setProperty("y", int(_loc_11[(_loc_9 - 1)].y + _loc_11[(_loc_9 - 1)].height + param5));
                    }
                    _loc_9++;
                }
            }
            else if (param2 == 1)
            {
                _loc_9 = 0;
                while (_loc_9 < _loc_7)
                {
                    
                    _loc_10 = _loc_6[_loc_9];
                    _loc_11.push(_loc_10);
                    _loc_9++;
                }
                _loc_11.sortOn("x", Array.NUMERIC);
                _loc_9 = 1;
                while (_loc_9 < _loc_7)
                {
                    
                    _loc_10 = _loc_11[_loc_9];
                    _loc_8 = param1._-MJ(_loc_10);
                    if (!(_loc_8 & 1))
                    {
                        _loc_10.docElement.setProperty("x", int(_loc_11[(_loc_9 - 1)].x + _loc_11[(_loc_9 - 1)].width + param4));
                    }
                    _loc_9++;
                }
            }
            else
            {
                if (param3 == 0)
                {
                    param3 = 1;
                }
                _loc_9 = 0;
                while (_loc_9 < _loc_7)
                {
                    
                    _loc_10 = _loc_6[_loc_9];
                    _loc_11.push(_loc_10);
                    _loc_9++;
                }
                _loc_11.sortOn("x", Array.NUMERIC);
                _loc_12 = _loc_11[0].x;
                _loc_11.sortOn("y", Array.NUMERIC);
                _loc_13 = _loc_11[0].y;
                while (true)
                {
                    
                    _loc_15 = _loc_11.slice(0, param3);
                    _loc_15.sortOn("x", Array.NUMERIC);
                    _loc_14 = 0;
                    _loc_9 = 0;
                    while (_loc_9 < param3)
                    {
                        
                        _loc_10 = _loc_15[_loc_9];
                        if (!_loc_10)
                        {
                            break;
                        }
                        _loc_8 = param1._-MJ(_loc_10);
                        if (!(_loc_8 & 1))
                        {
                            if (_loc_9 == 0)
                            {
                                _loc_10.docElement.setProperty("x", _loc_12);
                            }
                            else
                            {
                                _loc_10.docElement.setProperty("x", _loc_15[(_loc_9 - 1)].x + _loc_15[(_loc_9 - 1)].width + param4);
                            }
                        }
                        if (!(_loc_8 & 2))
                        {
                            _loc_10.docElement.setProperty("y", _loc_13);
                        }
                        if (_loc_10.height > _loc_14)
                        {
                            _loc_14 = _loc_10.height;
                        }
                        _loc_9++;
                    }
                    if (_loc_9 != param3)
                    {
                        break;
                    }
                    _loc_13 = _loc_13 + (_loc_14 + param5);
                    _loc_11.splice(0, param3);
                    if (_loc_11.length == 0)
                    {
                        break;
                    }
                }
            }
            param1.setVar("selectionTransforming", false);
            return;
        }// end function

    }
}
