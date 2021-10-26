package _-Ds
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.plugin.*;

    public class PlugInManageDialog extends _-3g
    {
        private var _-9b:FComboBox;
        private var _itemList:GList;

        public function PlugInManageDialog(param1:IEditor)
        {
            var editor:* = param1;
            super(editor);
            this.contentPane = UIPackage.createObject("Builder", "PlugInManageDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._itemList = contentPane.getChild("n19").asList;
            contentPane.getChild("n14").addClickListener(closeEventHandler);
            contentPane.getChild("n41").addClickListener(function () : void
            {
                _editor.showWaiting();
                _-1L(_editor).plugInManager.load(function () : void
                {
                    _editor.closeWaiting();
                    _-4r();
                    return;
                }// end function
                );
                return;
            }// end function
            );
            contentPane.getChild("n28").addClickListener(function () : void
            {
                _-1L(_editor).plugInManager.pluginFolder.openWithDefaultApplication();
                return;
            }// end function
            );
            this._-4r();
            return;
        }// end function

        private function _-4r() : void
        {
            var _loc_2:* = null;
            this._itemList.removeChildrenToPool();
            var _loc_1:* = _-1L(_editor).plugInManager.allPlugins;
            for each (_loc_2 in _loc_1)
            {
                
                this.addItem(_loc_2.name, "");
            }
            return;
        }// end function

        private function addItem(param1:String, param2:String) : void
        {
            var _loc_3:* = this._itemList.addItemFromPool().asButton;
            _loc_3.getChild("text").text = param1;
            _loc_3.getChild("value").text = param2;
            return;
        }// end function

    }
}
