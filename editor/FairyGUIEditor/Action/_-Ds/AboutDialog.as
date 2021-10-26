package _-Ds
{
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.settings.*;
    import flash.desktop.*;

    public class AboutDialog extends _-3g
    {

        public function AboutDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "AboutDialog").asCom;
            this.centerOn(_editor.groot, true);
            this.modal = true;
            var _loc_2:* = NativeApplication.nativeApplication.applicationDescriptor;
            var _loc_3:* = _loc_2.namespace("");
            var _loc_4:* = _loc_3::versionLabel;
            contentPane.getChild("msg").text = "Version " + _loc_4 + "\n" + Consts.about;
            contentPane.getChild("n14").addClickListener(this.closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            var _loc_1:* = null;
            if (_-D._-8J || _-D._-DB)
            {
                _loc_1 = Consts.strings.text450;
                if (_-D._-DB)
                {
                    _loc_1 = _loc_1 + ("(" + Consts.strings.text453 + ")");
                }
                _loc_1 = _loc_1 + ("\n" + Consts.strings.text452 + ": " + _-D._-2Q);
            }
            else
            {
                _loc_1 = Consts.strings.text451;
            }
            contentPane.getChild("license").text = _loc_1;
            return;
        }// end function

    }
}
