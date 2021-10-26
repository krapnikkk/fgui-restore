package _-Pz
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class RelationPropsPanel extends _-5I
    {
        private var _list:GList;
        private var _-Kz:GComponent;
        private var _-DO:GComponent;
        private var _-7E:Object;

        public function RelationPropsPanel(param1:IEditor)
        {
            _editor = param1;
            UIObjectFactory.setPackageItemExtension("ui://Builder/RelationPropsItem", RelationPropsItem);
            UIObjectFactory.setPackageItemExtension("ui://Builder/RelationLabel", RelationLabel);
            _panel = UIPackage.createObject("Builder", "RelationPropsPanel").asCom;
            var _loc_2:* = "->";
            this._-7E = [Consts.strings.text247 + _loc_2 + Consts.strings.text247, Consts.strings.text247 + _loc_2 + Consts.strings.text248, Consts.strings.text247 + _loc_2 + Consts.strings.text249, Consts.strings.text259, Consts.strings.text249 + _loc_2 + Consts.strings.text247, Consts.strings.text249 + _loc_2 + Consts.strings.text248, Consts.strings.text249 + _loc_2 + Consts.strings.text249, Consts.strings.text255 + _loc_2 + Consts.strings.text247, Consts.strings.text255 + _loc_2 + Consts.strings.text249, Consts.strings.text256 + _loc_2 + Consts.strings.text247, Consts.strings.text256 + _loc_2 + Consts.strings.text249, Consts.strings.text253 + _loc_2 + Consts.strings.text253, Consts.strings.text250 + _loc_2 + Consts.strings.text250, Consts.strings.text250 + _loc_2 + Consts.strings.text251, Consts.strings.text250 + _loc_2 + Consts.strings.text252, Consts.strings.text260, Consts.strings.text252 + _loc_2 + Consts.strings.text250, Consts.strings.text252 + _loc_2 + Consts.strings.text251, Consts.strings.text252 + _loc_2 + Consts.strings.text252, Consts.strings.text257 + _loc_2 + Consts.strings.text250, Consts.strings.text257 + _loc_2 + Consts.strings.text252, Consts.strings.text258 + _loc_2 + Consts.strings.text250, Consts.strings.text258 + _loc_2 + Consts.strings.text252, Consts.strings.text254 + _loc_2 + Consts.strings.text254];
            this._list = _panel.getChild("list").asList;
            this._list.removeChildrenToPool();
            _panel.getChild("add").addClickListener(this._-Mr);
            this._-Kz = UIPackage.createObject("Builder", "RelationTypePopup").asCom;
            this._-DO = UIPackage.createObject("Builder", "RelationTypePopup2").asCom;
            this._-Kz.getChild("finish").addClickListener(this._-Hp);
            this._-Kz.addEventListener(Event.REMOVED_FROM_STAGE, this._-L5);
            this._-DO.getChild("finish").addClickListener(this._-Hp);
            this._-DO.addEventListener(Event.REMOVED_FROM_STAGE, this._-L5);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            if (this.inspectingTargets.length > 1)
            {
                return false;
            }
            var _loc_1:* = this.inspectingTarget;
            if (_loc_1 is FGroup && !FGroup(_loc_1).advanced)
            {
                return false;
            }
            this._list.removeChildrenToPool();
            var _loc_2:* = _loc_1.relations.getItem(_loc_1.parent);
            if (!_loc_1.docElement.isRoot)
            {
                this.addItem(_loc_2, true);
            }
            var _loc_3:* = _loc_1.relations.items;
            var _loc_4:* = _loc_3.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_2 = _loc_3[_loc_5];
                if (!_loc_2.readOnly)
                {
                    if (_loc_2.target != _loc_1.parent)
                    {
                        this.addItem(_loc_2, false);
                    }
                }
                _loc_5++;
            }
            this._list.resizeToFit();
            return true;
        }// end function

        private function addItem(param1:FRelationItem, param2:Boolean) : RelationPropsItem
        {
            var _loc_3:* = null;
            var _loc_4:* = this._list.addItemFromPool() as RelationPropsItem;
            if (param1)
            {
                _loc_4._-Iu.value = param1.target;
                _loc_4._-14.text = this._-Jb(param1);
                _loc_4._-H1.selectedIndex = 1;
            }
            else
            {
                _loc_4._-Iu.value = null;
                _loc_4._-14.text = Consts.strings.text26;
                _loc_4._-H1.selectedIndex = 0;
            }
            _loc_4._-Iu.addEventListener(_-Fr._-CF, this.__objectSelected);
            _loc_4._-8T.addClickListener(this._-1s);
            _loc_4._-14.addClickListener(this._-JZ);
            _loc_4._-Hy.addClickListener(this._-Ks);
            _loc_4.data = param1;
            _loc_4._-Cp.selectedIndex = param2 ? (1) : (0);
            return _loc_4;
        }// end function

        private function _-Jb(param1:FRelationItem) : String
        {
            var _loc_5:* = null;
            var _loc_2:* = param1.defs;
            var _loc_3:* = "";
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_5 = _loc_2[_loc_4];
                if (_loc_3.length > 0)
                {
                    _loc_3 = _loc_3 + ", ";
                }
                _loc_3 = _loc_3 + (this._-7E[_loc_5.type] + (_loc_5.percent ? (" %") : ("")));
                _loc_4++;
            }
            if (_loc_3.length == 0)
            {
                _loc_3 = Consts.strings.text26;
            }
            return _loc_3;
        }// end function

        private function __objectSelected(event:Event) : void
        {
            var _loc_2:* = RelationPropsItem(event.currentTarget.parent);
            var _loc_3:* = FRelationItem(_loc_2.data);
            var _loc_4:* = ChildObjectInput(event.currentTarget).value;
            var _loc_5:* = this.inspectingTarget;
            _loc_5.docElement.setRelation(_loc_4, _loc_3 ? (_loc_3.desc) : (""));
            return;
        }// end function

        private function _-1s(event:Event) : void
        {
            var _loc_2:* = RelationPropsItem(event.currentTarget.parent);
            var _loc_3:* = FRelationItem(_loc_2.data);
            if (!_loc_3)
            {
                return;
            }
            var _loc_4:* = this.inspectingTarget;
            _loc_4.docElement.removeRelation(_loc_3.target);
            return;
        }// end function

        private function _-GY(param1:GComponent, param2:FRelationItem) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_3:* = param1.numChildren;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_6 = param1.getChildAt(_loc_4) as RelationLabel;
                if (!_loc_6)
                {
                }
                else
                {
                    _loc_6.selected = false;
                }
                _loc_4++;
            }
            param1.data = param2;
            if (param2 == null)
            {
                return;
            }
            for each (_loc_5 in param2.defs)
            {
                
                _loc_6 = param1.getChild("" + _loc_5.type) as RelationLabel;
                if (!_loc_6)
                {
                    continue;
                }
                _loc_6.selected = true;
                if (_loc_5.percent)
                {
                    _loc_6._-4P = true;
                }
            }
            return;
        }// end function

        private function _-JZ(event:Event) : void
        {
            var _loc_2:* = RelationPropsItem(event.currentTarget.parent);
            var _loc_3:* = FRelationItem(_loc_2.data);
            var _loc_4:* = this.inspectingTarget;
            if (_loc_4.docElement.isRoot)
            {
                this._-GY(this._-DO, _loc_3);
                _editor.groot.showPopup(this._-DO);
            }
            else
            {
                this._-GY(this._-Kz, _loc_3);
                _editor.groot.showPopup(this._-Kz);
            }
            return;
        }// end function

        private function _-Hp(event:Event) : void
        {
            var _loc_2:* = GComponent(event.currentTarget.parent);
            _editor.groot.hidePopup(_loc_2);
            return;
        }// end function

        private function _-L5(event:Event) : void
        {
            var _loc_8:* = null;
            var _loc_2:* = this.inspectingTarget;
            var _loc_3:* = GComponent(event.currentTarget);
            var _loc_4:* = FRelationItem(_loc_3.data);
            var _loc_5:* = "";
            var _loc_6:* = _loc_3.numChildren;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_8 = _loc_3.getChildAt(_loc_7) as RelationLabel;
                if (!_loc_8 || !_loc_8.selected)
                {
                }
                else
                {
                    if (_loc_5.length > 0)
                    {
                        _loc_5 = _loc_5 + ",";
                    }
                    _loc_5 = _loc_5 + FRelationType.Names[int(_loc_8.name)];
                    if (_loc_8._-4P)
                    {
                        _loc_5 = _loc_5 + "%";
                    }
                }
                _loc_7++;
            }
            _loc_2.docElement.setRelation(_loc_4 ? (_loc_4.target) : (_loc_2.parent), _loc_5);
            return;
        }// end function

        private function _-Mr(event:Event) : void
        {
            var _loc_2:* = this.addItem(null, false);
            _loc_2._-Iu.start();
            return;
        }// end function

        private function _-Ks(event:Event) : void
        {
            var _loc_2:* = this.inspectingTarget;
            _loc_2.docElement.setRelation(_loc_2.parent, "width-width,height-height");
            return;
        }// end function

    }
}
