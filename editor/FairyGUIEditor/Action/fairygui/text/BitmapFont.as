package fairygui.text
{
    import *.*;
    import flash.display.*;
    import flash.geom.*;

    public class BitmapFont extends Object
    {
        public var id:String;
        public var size:int;
        public var ttf:Boolean;
        public var resizable:Boolean;
        public var colored:Boolean;
        public var atlas:BitmapData;
        public var glyphs:Object;
        private static var sHelperRect:Rectangle = new Rectangle();
        private static var sTransform:ColorTransform = new ColorTransform(0, 0, 0, 1);
        private static var sHelperMat:Matrix = new Matrix();
        private static var sHelperBmd:BitmapData = new BitmapData(200, 200, true, 0);
        private static var sPoint0:Point = new Point(0, 0);

        public function BitmapFont()
        {
            glyphs = {};
            return;
        }// end function

        public function dispose() : void
        {
            if (atlas != null)
            {
                atlas.dispose();
            }
            return;
        }// end function

        public function translateChannel(param1:int) : int
        {
            switch((param1 - 1)) branch count is:<7>[29, 32, 41, 35, 41, 41, 41, 38] default offset is:<41>;
            return 4;
            return 2;
            return 1;
            return 8;
            return 0;
        }// end function

        public function draw(param1:BitmapData, param2:BMGlyph, param3:Number, param4:Number, param5:uint, param6:Number) : void
        {
            param3 = param3 + Math.ceil(param2.offsetX * param6);
            param4 = param4 + Math.ceil(param2.offsetY * param6);
            var _loc_7:* = null;
            if (ttf)
            {
                if (atlas != null)
                {
                    sHelperBmd.fillRect(sHelperBmd.rect, 0);
                    sHelperRect.x = 0;
                    sHelperRect.y = 0;
                    sHelperRect.width = param2.width;
                    sHelperRect.height = param2.height;
                    if (param2.channel == 0)
                    {
                        sHelperBmd.fillRect(sHelperRect, 0);
                    }
                    else
                    {
                        sHelperBmd.fillRect(sHelperRect, 4294967295);
                    }
                    sHelperRect.x = param2.x;
                    sHelperRect.y = param2.y;
                    if (param2.channel == 0)
                    {
                        sHelperBmd.copyPixels(atlas, sHelperRect, sPoint0);
                    }
                    else
                    {
                        sHelperBmd.copyChannel(atlas, sHelperRect, sPoint0, param2.channel, 8);
                    }
                    _loc_7 = sHelperBmd;
                }
            }
            else if (param2.imageItem != null)
            {
                _loc_7 = param2.imageItem.image;
            }
            if (_loc_7 != null)
            {
                sHelperMat.identity();
                sHelperMat.scale(param6 * param2.width / _loc_7.width, param6 * param2.height / _loc_7.height);
                sHelperMat.translate(param3, param4);
                sHelperRect.x = param3;
                sHelperRect.y = param4;
                sHelperRect.width = Math.ceil(param2.width * param6);
                sHelperRect.height = Math.ceil(param2.height * param6);
                if (colored)
                {
                    sTransform.redMultiplier = (param5 >> 16 & 255) / 255;
                    sTransform.greenMultiplier = (param5 >> 8 & 255) / 255;
                    sTransform.blueMultiplier = (param5 & 255) / 255;
                    param1.draw(_loc_7, sHelperMat, sTransform, null, sHelperRect, true);
                }
                else
                {
                    param1.draw(_loc_7, sHelperMat, null, null, sHelperRect, true);
                }
            }
            return;
        }// end function

    }
}
