package fairygui.editor.gui
{
    import *.*;

    public class ResourceRef extends Object
    {
        private var _main:FPackageItem;
        private var _mainVer:int;
        private var _branch:FPackageItem;
        private var _branchVer:int;
        private var _display:FPackageItem;
        private var _displayVer:int;
        private var _sourceWidth:int;
        private var _sourceHeight:int;
        private var _missingInfo:MissingInfo;
        private var _flags:int;

        public function ResourceRef(param1:FPackageItem = null, param2:MissingInfo = null, param3:int = 0) : void
        {
            this._missingInfo = param2;
            this.setPackageItem(param1, param3);
            return;
        }// end function

        public function get packageItem() : FPackageItem
        {
            return this._main;
        }// end function

        public function setPackageItem(param1:FPackageItem, param2:int = 0) : void
        {
            var _loc_3:* = 0;
            if (this._main == param1)
            {
                return;
            }
            this._flags = param2;
            if (this._main)
            {
                this._display.releaseRef();
                this._display = null;
            }
            this._main = param1;
            if (this._main)
            {
                this._main.touch();
                this._mainVer = this._main.version;
                if ((param2 & FObjectFlags.IN_PREVIEW) == 0 && (param2 & FObjectFlags.ROOT) == 0 && this._main.branch.length == 0)
                {
                    this._branch = this._main.getBranch();
                    if (this._branch != this._main)
                    {
                        this._branch.touch();
                    }
                }
                else
                {
                    this._branch = this._main;
                }
                this._branchVer = this._branch.version;
                this._sourceWidth = this._branch.width;
                this._sourceHeight = this._branch.height;
                this._display = this._branch;
                if (this._branch.imageInfo)
                {
                    _loc_3 = param2 & 15;
                    if (_loc_3 > 0)
                    {
                        this._display = this._branch.getHighResolution(_loc_3);
                        if (this._display != this._branch)
                        {
                            this._display.touch();
                        }
                    }
                }
                this._display.addRef();
                this._displayVer = this._display.version;
            }
            else
            {
                var _loc_4:* = 0;
                this._sourceHeight = 0;
                this._sourceWidth = _loc_4;
            }
            return;
        }// end function

        public function get displayItem() : FPackageItem
        {
            return this._display;
        }// end function

        public function get deprecated() : Boolean
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            if (!this._main)
            {
                return false;
            }
            this._main.touch();
            if (this._branch != this._main)
            {
                this._branch.touch();
            }
            if (this._display != this._branch)
            {
                this._display.touch();
            }
            if (this._main.version != this._mainVer || this._branch.version != this._branchVer || this._display.version != this._displayVer)
            {
                return true;
            }
            if ((this._flags & FObjectFlags.ROOT) == 0 && this._main.branch.length == 0)
            {
                _loc_1 = this._main.getBranch();
            }
            else
            {
                _loc_1 = this._main;
            }
            if (_loc_1.imageInfo)
            {
                _loc_2 = this._flags & 15;
                if (_loc_2 > 0)
                {
                    _loc_1 = _loc_1.getHighResolution(_loc_2);
                }
            }
            if (_loc_1 != this._display)
            {
                return true;
            }
            return false;
        }// end function

        public function get name() : String
        {
            return this._display ? (this._display.name) : ("");
        }// end function

        public function get desc() : String
        {
            if (this._display)
            {
                return this._display.name + " @" + this._display.owner.name;
            }
            if (this._missingInfo)
            {
                return this._missingInfo.fileName + " @" + (this._missingInfo.pkg ? (this._missingInfo.pkg.name) : (this._missingInfo.pkgId));
            }
            else
            {
                return "";
            }
        }// end function

        public function get isMissing() : Boolean
        {
            return this._main == null;
        }// end function

        public function get missingInfo() : MissingInfo
        {
            return this._missingInfo;
        }// end function

        public function getURL() : String
        {
            return this._display.getURL();
        }// end function

        public function get sourceWidth() : int
        {
            return this._sourceWidth;
        }// end function

        public function get sourceHeight() : int
        {
            return this._sourceHeight;
        }// end function

        public function update() : void
        {
            var _loc_1:* = null;
            if (this._main)
            {
                _loc_1 = this._main;
                this._main = null;
                if (_loc_1 && _loc_1.isDisposed && !this._missingInfo)
                {
                    this._missingInfo = MissingInfo.create(_loc_1.owner, _loc_1.owner.id, _loc_1.id, _loc_1.fileName);
                }
                else
                {
                    this.setPackageItem(_loc_1, this._flags);
                }
            }
            return;
        }// end function

        public function release() : void
        {
            if (this._main)
            {
                this._display.releaseRef();
                this._main = null;
                this._branch = null;
                this._display = null;
            }
            return;
        }// end function

    }
}
