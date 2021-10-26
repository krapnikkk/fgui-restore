package mx.resources
{
    import *.*;
    import flash.system.*;
    import mx.resources.*;

    public class ResourceBundle extends Object implements IResourceBundle
    {
        var _bundleName:String;
        private var _content:Object;
        var _locale:String;
        static const VERSION:String = "4.6.0.0";
        static var locale:String;
        static var backupApplicationDomain:ApplicationDomain;

        public function ResourceBundle(param1:String = null, param2:String = null)
        {
            this._content = {};
            this._locale = param1;
            this._bundleName = param2;
            this._content = this.getContent();
            return;
        }// end function

        public function get bundleName() : String
        {
            return this._bundleName;
        }// end function

        public function get content() : Object
        {
            return this._content;
        }// end function

        public function get locale() : String
        {
            return this._locale;
        }// end function

        protected function getContent() : Object
        {
            return {};
        }// end function

        private function _getObject(param1:String) : Object
        {
            var _loc_2:* = this.content[param1];
            if (!_loc_2)
            {
                throw new Error("Key " + param1 + " was not found in resource bundle " + this.bundleName);
            }
            return _loc_2;
        }// end function

        private static function getClassByName(param1:String, param2:ApplicationDomain) : Class
        {
            var _loc_3:* = null;
            if (param2.hasDefinition(param1))
            {
                _loc_3 = param2.getDefinition(param1) as Class;
            }
            return _loc_3;
        }// end function

    }
}
