package fairygui
{
    import __AS3__.vec.*;
    import fairygui.text.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.media.*;

    public class PackageItem extends Object
    {
        public var owner:UIPackage;
        public var type:int;
        public var id:String;
        public var name:String;
        public var width:int;
        public var height:int;
        public var file:String;
        public var lastVisitTime:int;
        public var callbacks:Array;
        public var loading:int;
        public var loaded:Boolean;
        public var highResolution:Array;
        public var branches:Array;
        public var scale9Grid:Rectangle;
        public var scaleByTile:Boolean;
        public var smoothing:Boolean;
        public var tileGridIndice:int;
        public var image:BitmapData;
        public var interval:Number;
        public var repeatDelay:Number;
        public var swing:Boolean;
        public var frames:Vector.<Frame>;
        public var componentData:XML;
        public var displayList:Vector.<DisplayListItem>;
        public var extensionType:Object;
        public var sound:Sound;
        public var bitmapFont:BitmapFont;

        public function PackageItem()
        {
            callbacks = [];
            return;
        }// end function

        public function addCallback(param1:Function) : void
        {
            var _loc_2:* = callbacks.indexOf(param1);
            if (_loc_2 == -1)
            {
                callbacks.push(param1);
            }
            return;
        }// end function

        public function removeCallback(param1:Function) : Function
        {
            var _loc_2:* = callbacks.indexOf(param1);
            if (_loc_2 != -1)
            {
                callbacks.splice(_loc_2, 1);
                return param1;
            }
            return null;
        }// end function

        public function completeLoading() : void
        {
            loading = 0;
            loaded = true;
            var _loc_1:* = callbacks.slice();
            for each (_loc_2 in _loc_1)
            {
                
                this._loc_2(this);
            }
            callbacks.length = 0;
            return;
        }// end function

        public function getBranch() : PackageItem
        {
            var _loc_1:* = null;
            if (branches && owner._branchIndex != -1)
            {
                _loc_1 = branches[owner._branchIndex];
                if (_loc_1)
                {
                    return owner.getItemById(_loc_1);
                }
            }
            return this;
        }// end function

        public function getHighResolution() : PackageItem
        {
            var _loc_1:* = null;
            if (highResolution && GRoot.contentScaleLevel > 0)
            {
                _loc_1 = highResolution[(GRoot.contentScaleLevel - 1)];
                if (_loc_1)
                {
                    return owner.getItemById(_loc_1);
                }
            }
            return this;
        }// end function

        public function toString() : String
        {
            return name;
        }// end function

    }
}
