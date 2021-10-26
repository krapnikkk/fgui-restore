package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;

    public class ListItemData extends Object
    {
        public var url:String;
        public var name:String;
        public var title:String;
        public var icon:String;
        public var selectedTitle:String;
        public var selectedIcon:String;
        public var level:int;
        private var _properties:Vector.<ComProperty>;

        public function ListItemData() : void
        {
            this._properties = new Vector.<ComProperty>;
            return;
        }// end function

        public function get properties() : Vector.<ComProperty>
        {
            return this._properties;
        }// end function

        public function copyFrom(param1:ListItemData) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            this.url = param1.url;
            this.name = param1.name;
            this.title = param1.title;
            this.icon = param1.icon;
            this.selectedIcon = param1.selectedIcon;
            this.selectedTitle = param1.selectedTitle;
            this.level = param1.level;
            var _loc_2:* = param1._properties.length;
            this._properties.length = _loc_2;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._properties[_loc_3];
                _loc_5 = param1._properties[_loc_3];
                if (!_loc_4)
                {
                    _loc_4 = new ComProperty();
                    this._properties[_loc_3] = _loc_4;
                }
                _loc_4.copyFrom(_loc_5);
                _loc_3++;
            }
            return;
        }// end function

    }
}
