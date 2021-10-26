package _-NY
{
    import _-Ds.*;
    import fairygui.editor.api.*;
    import flash.filesystem.*;
    import flash.geom.*;

    public class _-8G extends Object implements IResourceImportQueue
    {
        public var _-1Y:IUIPackage;
        public var files:Array;
        public var _-1K:Boolean;
        public var _-OS:Point;
        public var callback:Function;

        public function _-8G(param1:IUIPackage)
        {
            this._-1Y = param1;
            this.files = [];
            return;
        }// end function

        public function add(param1:File, param2:String = null, param3:String = null) : IResourceImportQueue
        {
            if (!param2)
            {
                param2 = "/";
            }
            this.files.push({source:param1, target:param2, resName:param3});
            return this;
        }// end function

        public function addRelative(param1:File, param2:String = null, param3:File = null, param4:String = null) : IResourceImportQueue
        {
            var _loc_5:* = null;
            if (!param2)
            {
                param2 = "/";
            }
            if (param3)
            {
                _loc_5 = param3.getRelativePath(param1.parent);
                if (_loc_5 != null && _loc_5.length > 0)
                {
                    param2 = param2 + (_loc_5.replace(/\\/g, "/") + "/");
                }
            }
            this.files.push({source:param1, target:param2, resName:param4});
            return this;
        }// end function

        public function process(param1:Function = null, param2:Boolean = false, param3:Point = null) : void
        {
            this._-1K = param2;
            this._-OS = param3;
            this.callback = param1;
            var _loc_4:* = ImportResourceDialog(this._-1Y.project.editor.getDialog(ImportResourceDialog));
            _loc_4.addTask(this);
            return;
        }// end function

    }
}
