package _-Pz
{
    import *.*;
    import _-Ds.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class ListItemPropsPanel extends _-5I
    {
        private var _list:GList;

        public function ListItemPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "ListItemPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"name", type:"string"}, {name:"title", type:"string"}, {name:"icon", type:"string"}, {name:"selectedIcon", type:"string"}, {name:"selectedTitle", type:"string"}]);
            this._list = _panel.getChild("list").asList;
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_1:* = ListItemsEditDialog(_editor.getDialog(ListItemsEditDialog));
            var _loc_2:* = _loc_1._-56;
            var _loc_3:* = _loc_1._-IK;
            if (_loc_3 == null)
            {
                this._list.removeChildrenToPool();
                return true;
            }
            _form._-Cm(_loc_3);
            _form.updateUI();
            this._list.removeChildrenToPool();
            if (_loc_3.url)
            {
                _loc_4 = _editor.project.getItemByURL(_loc_3.url);
                if (_loc_4 && _loc_4.type == FPackageItemType.COMPONENT)
                {
                    _loc_5 = _loc_4.getComponentData().getCustomProperties();
                    if (_loc_5)
                    {
                        _loc_6 = _loc_5.length;
                        _loc_7 = 0;
                        while (_loc_7 < _loc_6)
                        {
                            
                            _loc_8 = _loc_5[_loc_7];
                            _loc_9 = this._list.addItemFromPool() as ComPropertyInput;
                            _loc_9.addEventListener(_-Fr._-CF, this._-Ps);
                            _loc_8 = this.addProperty(_loc_3, _loc_7, _loc_8);
                            _loc_9.data = _loc_8;
                            _loc_9.update(_loc_8, _loc_4);
                            _loc_7++;
                        }
                        if (_loc_3.properties.length > _loc_6)
                        {
                            _loc_3.properties.splice(_loc_6, _loc_6 - _loc_3.properties.length);
                        }
                    }
                    else
                    {
                        _loc_3.properties.length = 0;
                    }
                }
            }
            this._list.resizeToFit();
            return true;
        }// end function

        private function addProperty(param1:ListItemData, param2:int, param3:ComProperty) : ComProperty
        {
            var _loc_6:* = null;
            var _loc_4:* = param1.properties.length;
            var _loc_5:* = param2;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = param1.properties[_loc_5];
                if (_loc_6.target == param3.target && _loc_6.propertyId == param3.propertyId)
                {
                    if (_loc_5 != param2)
                    {
                        param1.properties.splice(_loc_5, 1);
                        param1.properties.splice(param2, 0, _loc_6);
                    }
                    return _loc_6;
                }
                _loc_5++;
            }
            _loc_6 = new ComProperty();
            _loc_6.copyFrom(param3);
            param1.properties.splice(param2, 0, _loc_6);
            return _loc_6;
        }// end function

        protected function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_4:* = ListItemsEditDialog(_editor.getDialog(ListItemsEditDialog));
            var _loc_5:* = _loc_4._-IK;
            if (_loc_4._-IK == null)
            {
                return;
            }
            _loc_5[param1] = param2;
            _loc_4.refresh();
            return;
        }// end function

        private function _-Ps(event:Event) : void
        {
            var _loc_2:* = ComPropertyInput(event.currentTarget);
            var _loc_3:* = ComProperty(_loc_2.data);
            _loc_3.value = _loc_2.value;
            return;
        }// end function

    }
}
