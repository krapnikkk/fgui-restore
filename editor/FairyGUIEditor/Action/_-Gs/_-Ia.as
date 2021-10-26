package _-Gs
{
    import *.*;
    import fairygui.utils.*;
    import flash.desktop.*;

    public class _-Ia extends Object
    {
        public static const _-81:String = "Object";
        public static const _-Kf:String = "PackageItem";
        public static const _-OA:String = "Timeline";
        private static var _-E5:Object;
        private static var _-M4:Object;
        private static var _-7u:XData;

        public function _-Ia()
        {
            return;
        }// end function

        public static function _-4y(param1:String) : Object
        {
            validate();
            if (param1 == _-81)
            {
                return _-M4;
            }
            if (param1 == _-Kf)
            {
                return _-E5;
            }
            return _-7u;
        }// end function

        public static function setValue(param1:String, param2:Object) : void
        {
            _-E5 = null;
            _-M4 = null;
            _-7u = null;
            if (param1 == _-81)
            {
                _-M4 = param2;
            }
            else if (param1 == _-Kf)
            {
                _-E5 = param2;
            }
            else
            {
                _-7u = param2 as XData;
            }
            Clipboard.generalClipboard.setData("fairygui.SharedData", param1);
            return;
        }// end function

        public static function hasFormat(param1:String) : Boolean
        {
            if (!Clipboard.generalClipboard.hasFormat("fairygui.SharedData"))
            {
                return false;
            }
            validate();
            if (param1 == _-81)
            {
                if (_-M4)
                {
                    return true;
                }
            }
            else if (param1 == _-Kf)
            {
                if (_-E5)
                {
                    return true;
                }
            }
            else if (_-7u)
            {
                return true;
            }
            return false;
        }// end function

        private static function validate() : void
        {
            if (_-E5)
            {
                if (_-E5.length == 0 || !_-E5[0].owner.project.opened)
                {
                    _-E5 = null;
                }
            }
            if (_-M4)
            {
                if (!_-M4.src.owner.project.opened)
                {
                    _-M4 = null;
                }
            }
            return;
        }// end function

    }
}
