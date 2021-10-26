package _-Pz
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class InfoPropsPanel extends _-5I
    {
        private var _title:GObject;
        private var _icon:GLoader;
        private var _-NG:ResourceRef;

        public function InfoPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "InfoPropsPanel").asCom;
            this._title = _panel.getChild("title");
            this._icon = _panel.getChild("icon").asLoader;
            this._title.addClickListener(this._-4O);
            _editor.on(EditorEvent.PackageItemChanged, this._-E2);
            return;
        }// end function

        private function _-E2(param1:FPackageItem) : void
        {
            if (_panel.parent && this._-NG.packageItem == param1)
            {
                this.updateUI();
            }
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            this._-NG = null;
            if (this.inspectingTargets.length > 1)
            {
                return false;
            }
            var _loc_1:* = this.inspectingTarget;
            if (!_loc_1._res)
            {
                return false;
            }
            this._-NG = _loc_1._res;
            this._title.text = _loc_1.getDetailString();
            this._icon.url = _loc_1.docElement.displayIcon;
            return true;
        }// end function

        private function _-4O(event:Event) : void
        {
            if (this._-NG)
            {
                if (this._-NG.packageItem)
                {
                    _editor.libView.highlight(this._-NG.packageItem);
                }
                else if (this._-NG.missingInfo)
                {
                    _editor.consoleView.log("Resource is missing: (pkg=\'" + this._-NG.missingInfo.pkgId + "\', id=\'" + this._-NG.missingInfo.itemId + "\', file=\'" + this._-NG.missingInfo.fileName + "\')");
                }
            }
            return;
        }// end function

    }
}
