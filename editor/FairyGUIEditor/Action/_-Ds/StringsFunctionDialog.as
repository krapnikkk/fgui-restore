package _-Ds
{
    import *.*;
    import _-NY.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.net.*;

    public class StringsFunctionDialog extends _-3g
    {
        private var _-3m:GList;
        private var _-3w:GList;
        private var _-L6:_-3O;

        public function StringsFunctionDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "StringsFunctionDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._-3m = contentPane.getChild("exportPkgList").asList;
            this._-3m.selectionMode = ListSelectionMode.Multiple_SingleClick;
            this._-3w = contentPane.getChild("importPkgList").asList;
            this._-3w.selectionMode = ListSelectionMode.None;
            contentPane.getChild("n14").addClickListener(closeEventHandler);
            contentPane.getChild("n40").addClickListener(this._-Iw);
            contentPane.getChild("n41").addClickListener(this._-63);
            contentPane.getChild("n43").addClickListener(this._-4a);
            contentPane.getChild("n53").addClickListener(this._-90);
            contentPane.getChild("n51").addClickListener(this._-P7);
            contentPane.getChild("n61").addClickListener(this._-3d);
            return;
        }// end function

        override protected function onShown() : void
        {
            contentPane.getController("c1").selectedIndex = 0;
            contentPane.getChild("n52").text = "";
            return;
        }// end function

        private function _-Iw(event:Event) : void
        {
            this._-3m.selectAll();
            return;
        }// end function

        private function _-63(event:Event) : void
        {
            this._-3m.selectNone();
            return;
        }// end function

        private function _-4a(event:Event) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (contentPane.getController("c2").selectedIndex == 0)
            {
                this._-3m.removeChildrenToPool();
                _loc_2 = _editor.project.allPackages;
                for each (_loc_3 in _loc_2)
                {
                    
                    _loc_4 = this._-3m.addItemFromPool().asButton;
                    _loc_4.icon = Consts.icons["package"];
                    _loc_4.title = _loc_3.name;
                    _loc_4.name = _loc_3.id;
                    _loc_4.selected = true;
                }
                contentPane.getController("c1").selectedIndex = 1;
            }
            else
            {
                _loc_5 = contentPane.getChild("n52").text;
                if (_loc_5.length == 0)
                {
                    _editor.alert(Consts.strings.text184);
                    return;
                }
                contentPane.getController("c1").selectedIndex = 2;
                this._-4X();
            }
            return;
        }// end function

        private function _-90(event:Event) : void
        {
            var evt:* = event;
            UtilsFile.browseForOpen("Open", [new FileFilter(Consts.strings.text186, "*.xml")], function (param1:File) : void
            {
                contentPane.getChild("n52").text = param1.nativePath;
                return;
            }// end function
            );
            return;
        }// end function

        private function _-P7(event:Event) : void
        {
            UtilsFile.browseForSave("Save", this._-Jh);
            return;
        }// end function

        private function _-Jh(param1:File) : void
        {
            var item:GButton;
            var sh:_-HQ;
            var file:* = param1;
            if (!file.extension)
            {
                file = new File(file.nativePath + ".xml");
            }
            var pkgs:* = new Vector.<IUIPackage>;
            var cnt:* = this._-3m.numChildren;
            var i:int;
            while (i < cnt)
            {
                
                item = this._-3m.getChildAt(i).asButton;
                if (item.selected)
                {
                    pkgs.push(_editor.project.getPackage(item.name));
                }
                i = (i + 1);
            }
            _editor.cursorManager.setWaitCursor(true);
            try
            {
                sh = new _-HQ(_editor);
                sh.parse(pkgs, contentPane.getChild("ignoreDiscarded").asButton.selected);
                sh._-51(file, contentPane.getChild("merge").asButton.selected);
                PromptDialog(_editor.getDialog(PromptDialog)).open(Consts.strings.text185);
                contentPane.getController("c1").selectedIndex = 0;
            }
            catch (err:Error)
            {
                _editor.alert(null, err);
            }
            _editor.cursorManager.setWaitCursor(false);
            return;
        }// end function

        private function _-4X() : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_1:* = contentPane.getChild("n52").text;
            var _loc_2:* = new File(_loc_1);
            this._-L6 = new _-3O(_editor);
            this._-L6.parse(_loc_2);
            this._-3w.removeChildrenToPool();
            var _loc_3:* = this._-L6.strings;
            for (_loc_4 in _loc_3)
            {
                
                _loc_5 = _editor.project.getPackage(_loc_4);
                if (!_loc_5)
                {
                    continue;
                }
                _loc_6 = 0;
                _loc_7 = _loc_3[_loc_4];
                for (_loc_8 in _loc_7)
                {
                    
                    _loc_10 = _loc_7[_loc_8];
                    for (_loc_11 in _loc_10)
                    {
                        
                        _loc_6++;
                    }
                }
                _loc_9 = this._-3w.addItemFromPool().asButton;
                _loc_9.icon = Consts.icons["package"];
                _loc_9.title = _loc_5.name + "(" + _loc_6 + ")";
            }
            return;
        }// end function

        private function _-3d(event:Event) : void
        {
            _editor.docView.queryToSaveAllDocuments(this._-31);
            return;
        }// end function

        private function _-31(param1:String) : void
        {
            if (param1 != "yes")
            {
                _editor.alert(Consts.strings.text187);
                return;
            }
            _editor.cursorManager.setWaitCursor(true);
            this._-L6._-77();
            _editor.cursorManager.setWaitCursor(false);
            PromptDialog(_editor.getDialog(PromptDialog)).open(Consts.strings.text189);
            contentPane.getController("c1").selectedIndex = 0;
            return;
        }// end function

    }
}
