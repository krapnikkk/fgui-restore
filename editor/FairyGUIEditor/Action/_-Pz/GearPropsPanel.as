package _-Pz
{
    import *.*;
    import _-5l.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.gui.gear.*;
    import fairygui.event.*;
    import flash.events.*;

    public class GearPropsPanel extends _-5I
    {
        private var _list:GList;
        private var _-Kz:PopupMenu;

        public function GearPropsPanel(param1:IEditor)
        {
            var _loc_5:* = 0;
            var _loc_6:* = null;
            _editor = param1;
            UIObjectFactory.setPackageItemExtension("ui://Builder/GearPropsItem", GearPropsItem);
            UIObjectFactory.setPackageItemExtension("ui://Builder/GearPropsItem2", GearPropsItem);
            _panel = UIPackage.createObject("Builder", "GearPropsPanel").asCom;
            this._list = _panel.getChild("list").asList;
            this._list.removeChildrenToPool();
            this._list.foldInvisibleItems = true;
            var _loc_2:* = [Consts.strings.text163, Consts.strings.text164, Consts.strings.text165, Consts.strings.text198, Consts.strings.text166, Consts.strings.text167, Consts.strings.text301, Consts.strings.text302, Consts.strings.text82, Consts.strings.text40];
            var _loc_3:* = [0, 8, 1, 2, 3, 4, 5, 6, 7, 9];
            var _loc_4:* = 0;
            while (_loc_4 <= FObject.MAX_GEAR_INDEX)
            {
                
                _loc_5 = _loc_3[_loc_4];
                if (_loc_5 == 0 || _loc_5 == 8)
                {
                    _loc_6 = this._list.addItemFromPool("ui://Builder/GearPropsItem2") as GearPropsItem;
                }
                else
                {
                    _loc_6 = this._list.addItemFromPool() as GearPropsItem;
                }
                _loc_6.getChild("image").tooltips = _loc_2[_loc_5];
                _loc_6._-11.addEventListener(_-Fr._-CF, this._-7A);
                if (_loc_5 == 0 || _loc_5 == 8)
                {
                    _loc_6.getController("second").selectedIndex = _loc_5 == 8 ? (1) : (0);
                    _loc_6._-6L.addEventListener(_-Fr._-CF, this._-NE);
                    _loc_6._-45.addEventListener(StateChangeEvent.CHANGED, this._-20);
                }
                else
                {
                    _loc_6._-3r.addEventListener(StateChangeEvent.CHANGED, this._-4C);
                    _loc_6._-7y.addEventListener(StateChangeEvent.CHANGED, this._-4C);
                    _loc_6._-R.addClickListener(this._-Aq);
                    _loc_6.getController("gearType").selectedIndex = _loc_5;
                }
                _loc_6._-L2.addClickListener(this._-M6);
                _loc_6.data = _loc_5;
                _loc_4++;
            }
            _panel.getChild("add").addClickListener(this._-Ik);
            this._-Kz = new PopupMenu();
            this._-Kz.contentPane.width = 250;
            this._-Kz.addItem(Consts.strings.text82, this._-Be).name = "gearDisplay2";
            this._-Kz.addItem(Consts.strings.text164, this._-Be).name = "gearXY";
            this._-Kz.addItem(Consts.strings.text165, this._-Be).name = "gearSize";
            this._-Kz.addItem(Consts.strings.text166, this._-Be).name = "gearColor";
            this._-Kz.addItem(Consts.strings.text198, this._-Be).name = "gearLook";
            this._-Kz.addItem(Consts.strings.text301, this._-Be).name = "gearText";
            this._-Kz.addItem(Consts.strings.text302, this._-Be).name = "gearIcon";
            this._-Kz.addItem(Consts.strings.text167, this._-Be).name = "gearAni";
            this._-Kz.addItem(Consts.strings.text40, this._-Be).name = "gearFontSize";
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            if (this.inspectingTargets.length > 1)
            {
                return false;
            }
            var _loc_1:* = this.inspectingTarget;
            if (_loc_1 is FGroup && !FGroup(_loc_1).advanced)
            {
                return false;
            }
            var _loc_2:* = 0;
            while (_loc_2 <= FObject.MAX_GEAR_INDEX)
            {
                
                _loc_3 = this._list.getChildAt(_loc_2) as GearPropsItem;
                _loc_4 = int(_loc_3.data);
                _loc_5 = _loc_1.getGear(_loc_4, _loc_4 == 0);
                _loc_3.visible = _loc_4 == 0 || _loc_5 && (_loc_5._display || _loc_5.controllerObject);
                if (_loc_3.visible)
                {
                    _loc_3._-11.text = _loc_5.controller ? (_loc_5.controller) : (Consts.strings.text331);
                    if (_loc_3._-6L)
                    {
                        _loc_3._-6L.visible = _loc_4 != 0 || _loc_5.controllerObject != null;
                        _loc_3._-6L.controller = _loc_5.controllerObject;
                        if (_loc_4 == 0)
                        {
                            _loc_3._-6L.value = FGearDisplay(_loc_5).pages;
                        }
                        else if (_loc_4 == 8)
                        {
                            _loc_3._-6L.value = FGearDisplay2(_loc_5).pages;
                            _loc_3._-45.selected = FGearDisplay2(_loc_5).condition == 1;
                        }
                    }
                    else
                    {
                        _loc_3._-3r.selected = _loc_5.tween;
                        _loc_3._-7y.selected = _loc_5.positionsInPercent;
                    }
                }
                _loc_2++;
            }
            this._list.resizeToFit();
            return true;
        }// end function

        private function _-NE(event:Event) : void
        {
            var _loc_2:* = this.inspectingTarget;
            var _loc_3:* = int(event.currentTarget.parent.data);
            _loc_2.docElement.setGearProperty(_loc_3, "pages", event.currentTarget.value);
            return;
        }// end function

        private function _-20(event:Event) : void
        {
            var _loc_2:* = this.inspectingTarget;
            var _loc_3:* = int(event.currentTarget.parent.data);
            _loc_2.docElement.setGearProperty(_loc_3, "condition", GButton(event.currentTarget).selected ? (1) : (0));
            return;
        }// end function

        private function _-Ik(event:Event) : void
        {
            var _loc_2:* = this.inspectingTarget;
            this._-Kz.setItemGrayed("gearLook", !_loc_2.supportGear(3));
            this._-Kz.setItemGrayed("gearColor", !_loc_2.supportGear(4));
            this._-Kz.setItemGrayed("gearAni", !_loc_2.supportGear(5));
            this._-Kz.setItemGrayed("gearText", !_loc_2.supportGear(6));
            this._-Kz.setItemGrayed("gearIcon", !_loc_2.supportGear(7));
            this._-Kz.setItemGrayed("gearFontSize", !_loc_2.supportGear(9));
            this._-Kz.show(_panel.getChild("add"));
            return;
        }// end function

        private function _-Be(event:ItemEvent) : void
        {
            var _loc_2:* = _editor.docView.activeDocument;
            var _loc_3:* = this.inspectingTarget;
            var _loc_4:* = FGearBase.getIndexByName(event.itemObject.name);
            var _loc_5:* = _loc_3.getGear(_loc_4);
            if (!_loc_5._display)
            {
                _loc_3.docElement.setGearProperty(_loc_5._gearIndex, "_display", true);
            }
            return;
        }// end function

        private function _-7A(event:Event) : void
        {
            var _loc_2:* = this.inspectingTarget;
            var _loc_3:* = _editor.docView.activeDocument;
            var _loc_4:* = event.currentTarget.text;
            var _loc_5:* = int(event.currentTarget.parent.data);
            _loc_2.docElement.setGearProperty(_loc_5, "controller", _loc_4);
            return;
        }// end function

        private function _-4C(event:Event) : void
        {
            var _loc_2:* = this.inspectingTarget;
            var _loc_3:* = _editor.docView.activeDocument;
            var _loc_4:* = GObject(event.currentTarget);
            var _loc_5:* = _loc_2.getGear(int(_loc_4.parent.data));
            _loc_2.docElement.setGearProperty(_loc_5._gearIndex, _loc_4.name, GButton(_loc_4).selected);
            return;
        }// end function

        private function _-Aq(event:Event) : void
        {
            var _loc_2:* = this.inspectingTarget;
            var _loc_3:* = _loc_2.getGear(int(event.currentTarget.parent.data));
            var _loc_4:* = _editor.inspectorView.getInspector("gearTween") as GearSettingsPanel;
            (_loc_4)._-At(_loc_3._gearIndex);
            _editor.inspectorView.showPopup("gearTween", GObject(event.currentTarget));
            return;
        }// end function

        private function _-M6(event:Event) : void
        {
            var _loc_2:* = _editor.docView.activeDocument;
            var _loc_3:* = this.inspectingTarget;
            var _loc_4:* = _loc_3.getGear(int(event.currentTarget.parent.data));
            _loc_3.docElement.setGearProperty(_loc_4._gearIndex, "_display", false);
            _loc_3.docElement.setGearProperty(_loc_4._gearIndex, "controller", null);
            return;
        }// end function

    }
}
