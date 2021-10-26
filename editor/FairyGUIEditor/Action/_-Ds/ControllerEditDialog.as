package _-Ds
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;

    public class ControllerEditDialog extends _-3g
    {
        private var _-1D:IDocument;
        private var _-26:FController;
        private var _controller:FController;
        private var _-86:GList;
        private var _-46:_-Gg;
        private var _-Ms:PopupMenu;
        private var _-S:GList;
        private var _-1M:_-Gg;
        private var _-5i:PopupMenu;
        private var _-6O:_-BM;

        public function ControllerEditDialog(param1:IEditor)
        {
            var editor:* = param1;
            super(editor);
            UIObjectFactory.setPackageItemExtension("ui://Builder/ControllerEdit_PageItem", _-MC);
            UIObjectFactory.setPackageItemExtension("ui://Builder/ControllerEdit_ActionItem", _-EO);
            UIObjectFactory.setPackageItemExtension("ui://Builder/ControllerEdit_ActionPropsPanel", _-BM);
            this.contentPane = UIPackage.createObject("Builder", "ControllerEditDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._-6O = UIPackage.createObject("Builder", "ControllerEdit_ActionPropsPanel") as _-BM;
            this._-86 = contentPane.getChild("pageList").asList;
            this._-46 = new _-Gg(this._-86, "index");
            this._-46._-Pt = this._-IW;
            this._-46._-K9 = this._-CT;
            this._-46._-Mm = this._-Ki;
            this._-S = contentPane.getChild("actionList").asList;
            this._-1M = new _-Gg(this._-S);
            this._-1M._-K9 = this._-9g;
            this._-1M._-Mm = this._-EF;
            contentPane.getChild("addPage").addClickListener(this._-46.add);
            contentPane.getChild("insertPage").addClickListener(this._-46.insert);
            contentPane.getChild("removePage").addClickListener(this._-46.remove);
            contentPane.getChild("moveUp").addClickListener(this._-46.moveUp);
            contentPane.getChild("moveDown").addClickListener(this._-46.moveDown);
            contentPane.getChild("buttonTemplate").addClickListener(function (event:Event) : void
            {
                _-Ms.show(GObject(event.target));
                return;
            }// end function
            );
            contentPane.getChild("addAction").addClickListener(this._-Ju);
            contentPane.getChild("removeAction").addClickListener(this._-1M.remove);
            contentPane.getChild("moveUpAction").addClickListener(this._-1M.moveUp);
            contentPane.getChild("moveDownAction").addClickListener(this._-1M.moveDown);
            contentPane.getChild("name").asLabel.getTextField().asTextInput.disableIME = true;
            contentPane.getChild("deleteController").addClickListener(this._-Nl);
            contentPane.getChild("save").addClickListener(this._-Dd);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            this._-Ms = new PopupMenu();
            this._-Ms.contentPane.width = 350;
            this._-Ms.addItem("up/down/over/selectedOver", this._-K5);
            this._-Ms.addItem("up/down", this._-K5);
            this._-Ms.addItem("up/down/over/selectedOver/disabled/selectedDisabled", this._-K5);
            this._-Ms.addItem("up/down/disabled/selectedDisabled", this._-K5);
            this._-5i = new PopupMenu();
            this._-5i.contentPane.width = 200;
            this._-5i.addItem(Consts.strings.text337, function () : void
            {
                addAction("play_transition");
                return;
            }// end function
            );
            this._-5i.addItem(Consts.strings.text338, function () : void
            {
                addAction("change_page");
                return;
            }// end function
            );
            this._controller = new FController();
            return;
        }// end function

        public function open(param1:FController) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            show();
            this._-26 = param1;
            this._-1D = _editor.docView.activeDocument;
            if (this._-26 == null)
            {
                this.frame.text = Consts.strings.text65;
                this._controller.parent = this._-1D.content;
                this._controller.reset();
                _loc_4 = this._-1D.content;
                _loc_5 = 1;
                while (_loc_4.getController("c" + _loc_5) != null)
                {
                    
                    _loc_5++;
                }
                this._controller.name = "c" + _loc_5;
                this._controller.addPage("");
                this._controller.addPage("");
            }
            else
            {
                this.frame.text = Consts.strings.text66;
                this._controller.parent = param1.parent;
                _loc_6 = this._-26.write();
                this._controller.read(_loc_6);
            }
            contentPane.getChild("name").text = this._controller.name;
            contentPane.getChild("alias").text = this._controller.alias;
            contentPane.getChild("autoRadioGroupDepth").asButton.selected = this._controller.autoRadioGroupDepth;
            contentPane.getChild("exported").asButton.selected = this._controller.exported;
            contentPane.getChild("homePageType").asComboBox.value = this._controller.homePageType;
            var _loc_2:* = ControllerPageInput(contentPane.getChild("homePage"));
            _loc_2._-H7 = false;
            _loc_2.controller = this._controller;
            if (this._controller.homePageType == "specific")
            {
                _loc_2.value = this._controller.homePage;
            }
            var _loc_3:* = contentPane.getChild("homePage_var").asComboBox;
            CustomProps(_editor.project.getSettings("customProps")).fillCombo(_loc_3);
            if (this._controller.homePageType == "variable")
            {
                _loc_3.value = this._controller.homePage;
            }
            contentPane.getChild("deleteController").visible = this._-26 != null;
            this._-2m();
            this._-Il();
            return;
        }// end function

        private function _-2m() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            this._-86.removeChildrenToPool();
            var _loc_1:* = this._controller.getPages();
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                _loc_3 = _loc_1[_loc_2];
                _loc_4 = _-MC(this._-86.addItemFromPool());
                _loc_4._-DQ(_loc_2);
                _loc_4._-JE(_loc_3);
                _loc_2++;
            }
            this._-86.selectedIndex = 0;
            return;
        }// end function

        private function _-Il() : void
        {
            var _loc_3:* = null;
            this._-S.removeChildrenToPool();
            var _loc_1:* = this._controller.getActions();
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                _loc_3 = _-EO(this._-S.addItemFromPool());
                _loc_3._-5v(this._controller, _loc_1[_loc_2]);
                _loc_2++;
            }
            this._-S.selectedIndex = 0;
            return;
        }// end function

        public function get _-Js() : FController
        {
            return this._controller;
        }// end function

        public function get detailsPropsPanel() : _-BM
        {
            return this._-6O;
        }// end function

        private function _-IW(param1:int, param2:_-MC) : void
        {
            var _loc_3:* = this._controller.addPageAt("", param1);
            param2._-DQ(param1);
            param2._-JE(_loc_3);
            return;
        }// end function

        private function _-CT(param1:int) : void
        {
            this._controller.removePageAt(param1);
            return;
        }// end function

        private function _-Ki(param1:int, param2:int) : void
        {
            this._controller.swapPage(param1, param2);
            return;
        }// end function

        private function _-9g(param1:int) : void
        {
            var _loc_2:* = this._controller.getActions()[param1];
            this._controller.removeAction(_loc_2);
            return;
        }// end function

        private function _-EF(param1:int, param2:int) : void
        {
            this._controller.swapAction(param1, param2);
            return;
        }// end function

        private function addPage(param1:String) : void
        {
            var _loc_2:* = this._controller.addPage(param1);
            var _loc_3:* = _-MC(this._-86.addItemFromPool());
            _loc_3._-DQ((this._-86.numChildren - 1));
            _loc_3._-JE(_loc_2);
            return;
        }// end function

        private function _-Ju(event:Event) : void
        {
            this._-5i.show(GObject(event.target));
            return;
        }// end function

        private function addAction(param1:String) : void
        {
            var _loc_2:* = this._controller.addAction(param1);
            var _loc_3:* = _-EO(this._-S.addItemFromPool());
            _loc_3._-5v(this._controller, _loc_2);
            this._-S.selectedIndex = this._-S.numChildren - 1;
            this._-S.scrollPane.scrollBottom();
            return;
        }// end function

        private function _-Dd(event:Event) : void
        {
            this._controller.name = contentPane.getChild("name").text;
            this._controller.alias = contentPane.getChild("alias").text;
            this._controller.autoRadioGroupDepth = contentPane.getChild("autoRadioGroupDepth").asButton.selected;
            this._controller.exported = contentPane.getChild("exported").asButton.selected;
            this._controller.homePageType = contentPane.getChild("homePageType").asComboBox.value;
            if (this._controller.homePageType == "specific")
            {
                this._controller.homePage = ControllerPageInput(contentPane.getChild("homePage")).value;
            }
            else if (this._controller.homePageType == "variable")
            {
                this._controller.homePage = contentPane.getChild("homePage_var").asComboBox.value;
            }
            var _loc_2:* = this._controller.write();
            if (!this._-26)
            {
                this._-1D.addController(_loc_2);
            }
            else
            {
                this._-1D.updateController(this._-26.name, _loc_2);
            }
            this.hide();
            return;
        }// end function

        private function _-K5(event:ItemEvent) : void
        {
            var _loc_2:* = event.itemObject.text.split("/");
            contentPane.getChild("name").text = "button";
            this._controller.setPages(_loc_2);
            this._-2m();
            return;
        }// end function

        private function _-Nl(event:Event) : void
        {
            this._-1D.removeController(this._-26.name);
            this.hide();
            return;
        }// end function

    }
}
