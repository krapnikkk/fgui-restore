package _-NY
{
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;

    public class _-1l extends Object
    {
        public var _-f:IUIPackage;
        public var pkgId:String;
        public var itemId:String;
        public var content:Object;
        public var _-Fe:Object;
        public var _-Ch:int;
        public static const _-9j:int = 0;
        public static const _-6e:int = 1;
        public static const _-Gd:int = 2;
        public static const _-9y:int = 3;
        public static const _-N:int = 4;

        public function _-1l()
        {
            return;
        }// end function

        public function update(param1:FPackageItem) : Boolean
        {
            var _loc_3:* = null;
            var _loc_2:* = false;
            if (param1)
            {
                if (this._-Ch == _-9j)
                {
                    (this.content as XData).setAttribute(String(this._-Fe), param1.id);
                    if (this._-f == param1.owner)
                    {
                        (this.content as XData).removeAttribute("pkg");
                    }
                    else
                    {
                        (this.content as XData).setAttribute("pkg", param1.owner.id);
                    }
                }
                else if (this._-Ch == _-6e)
                {
                    (this.content as XData).setAttribute(String(this._-Fe), param1.getURL());
                }
                else if (this._-Ch == _-Gd)
                {
                    _loc_3 = (this.content as XData).getAttribute(String(this._-Fe));
                    (this.content as XData).setAttribute(String(this._-Fe), _loc_3.replace("ui://" + this.pkgId + this.itemId, param1.getURL()));
                }
                else if (this._-Ch == _-9y)
                {
                    this.content[this._-Fe] = this.content[this._-Fe].replace(this.itemId, param1.id);
                }
                else if (this._-Ch == _-N)
                {
                    (this.content as _-1F).item.fontSettings.texture = param1.id;
                    _loc_2 = true;
                }
            }
            else if (this._-Ch == _-9j)
            {
                if (this._-f.id == this.pkgId)
                {
                    (this.content as XData).removeAttribute("pkg");
                }
                else
                {
                    (this.content as XData).setAttribute("pkg", this.pkgId);
                }
            }
            return _loc_2;
        }// end function

    }
}
