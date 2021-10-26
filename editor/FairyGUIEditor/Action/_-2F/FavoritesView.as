package _-2F
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;

    public class FavoritesView extends GComponent
    {
        private var _editor:IEditor;
        private var _panel:GComponent;
        private var _projectView:_-Dc;
        private var _-Kz:_-GW;

        public function FavoritesView(param1:IEditor)
        {
            var editor:* = param1;
            this._editor = editor;
            this._panel = UIPackage.createObject("Builder", "FavoritesView").asCom;
            this.setSize(this._panel.width, this._panel.height);
            this._panel.addRelation(this, RelationType.Size);
            addChild(this._panel);
            this._projectView = new _-Dc(this._editor, this._panel.getChild("treeView").asTree);
            this._projectView._-Nz = this._-Nz;
            this._projectView._-FC = this._-FC;
            this._projectView._-O1 = true;
            this._panel.getChild("btnExpandAll").addClickListener(function () : void
            {
                _projectView.treeView.expandAll();
                return;
            }// end function
            );
            this._panel.getChild("btnCollapseAll").addClickListener(function () : void
            {
                _projectView.treeView.collapseAll();
                return;
            }// end function
            );
            this._-Kz = new _-GW(editor);
            addEventListener(_-4U._-76, this.handleKeyEvent);
            addEventListener(FocusChangeEvent.CHANGED, this._-AB);
            this._editor.on(EditorEvent.ProjectOpened, this.onLoad);
            this._editor.on(EditorEvent.PackageListChanged, this._-LK);
            this._editor.on(EditorEvent.PackageReloaded, this._-FJ);
            this._editor.on(EditorEvent.PackageTreeChanged, this._-5Y);
            this._editor.on(EditorEvent.PackageItemChanged, this._-E2);
            return;
        }// end function

        private function onLoad() : void
        {
            this._projectView._-5Q(null, true, true);
            this._projectView.treeView.expandAll();
            return;
        }// end function

        private function _-LK() : void
        {
            this._projectView._-5Q(null);
            return;
        }// end function

        private function _-FJ(param1:IUIPackage) : void
        {
            this._projectView._-5Q(param1.rootItem, true);
            return;
        }// end function

        private function _-5Y(param1:FPackageItem) : void
        {
            this._projectView._-5Q(param1);
            return;
        }// end function

        private function _-E2(param1:FPackageItem) : void
        {
            var _loc_2:* = this._projectView.setChanged(param1);
            if (param1.favorite && !_loc_2 || !param1.favorite && _loc_2)
            {
                if (_loc_2 && !param1.owner.rootItem.favorite || param1.favorite && !this._projectView._-1o(param1.owner.rootItem))
                {
                    this._projectView._-5Q(null, true);
                }
                else
                {
                    this._projectView._-5Q(param1.owner.rootItem, true);
                }
            }
            return;
        }// end function

        private function _-FC(param1:FPackageItem, param2:Array, param3:Vector.<FPackageItem>) : Vector.<FPackageItem>
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (!param3)
            {
                param3 = new Vector.<FPackageItem>;
            }
            if (!param1)
            {
                _loc_4 = this._editor.project.allPackages;
                for each (_loc_5 in _loc_4)
                {
                    
                    if (_loc_5.rootItem.favorite)
                    {
                        param3.push(_loc_5.rootItem);
                    }
                }
            }
            else if (param1.isRoot)
            {
                param1.owner.getFavoriteItems(param3);
            }
            else
            {
                param1.owner.getItemListing(param1, param2, true, false, param3);
            }
            return param3;
        }// end function

        private function _-Nz(param1:FPackageItem, param2:ItemEvent) : void
        {
            var _loc_3:* = this._-Kz._-H0;
            _loc_3.length = 0;
            this._projectView.getSelectedResources(_loc_3);
            this._-Kz.show(param2);
            return;
        }// end function

        private function handleKeyEvent(param1:_-4U) : void
        {
            this._projectView.handleKeyEvent(param1);
            return;
        }// end function

        private function _-AB(event:FocusChangeEvent) : void
        {
            this._projectView.setActive(event.newFocusedObject == this);
            return;
        }// end function

    }
}
