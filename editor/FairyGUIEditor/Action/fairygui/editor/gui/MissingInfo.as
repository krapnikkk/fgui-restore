package fairygui.editor.gui
{
    import fairygui.editor.api.*;

    public class MissingInfo extends Object
    {
        public var project:IUIProject;
        public var pkg:IUIPackage;
        public var pkgId:String;
        public var itemId:String;
        public var fileName:String;

        public function MissingInfo() : void
        {
            return;
        }// end function

        public static function create(param1:IUIPackage, param2:String, param3:String, param4:String) : MissingInfo
        {
            var _loc_5:* = new MissingInfo;
            _loc_5.project = param1.project;
            _loc_5.pkgId = param2;
            _loc_5.itemId = param3;
            _loc_5.fileName = param4;
            if (param2)
            {
                _loc_5.pkg = _loc_5.project.getPackage(param2);
            }
            return _loc_5;
        }// end function

        public static function create2(param1:IUIPackage, param2:String) : MissingInfo
        {
            var _loc_3:* = new MissingInfo;
            _loc_3.project = param1.project;
            if (param2)
            {
                _loc_3.pkgId = param2.substr(5, 8);
                _loc_3.itemId = param2.substr(13);
            }
            else
            {
                var _loc_4:* = "";
                _loc_3.itemId = "";
                _loc_3.pkgId = _loc_4;
            }
            if (_loc_3.pkgId)
            {
                _loc_3.pkg = _loc_3.project.getPackage(_loc_3.pkgId);
            }
            return _loc_3;
        }// end function

    }
}
