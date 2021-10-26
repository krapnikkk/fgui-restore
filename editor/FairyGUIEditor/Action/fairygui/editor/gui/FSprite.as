package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import com.powerflasher.as3potrace.*;
    import com.powerflasher.as3potrace.backend.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;

    public class FSprite extends Sprite
    {
        private var _owner:FObject;
        private var _rootContainer:Sprite;
        private var _container:Sprite;
        private var _hitArea:Sprite;
        private var _maskArea:Sprite;
        private var _maskObject:FObject;
        private var _loadingSign:GMovieClip;
        private var _scaleX:Number;
        private var _scaleY:Number;
        private var _rotation:Number;
        private var _skewX:Number;
        private var _skewY:Number;
        private var _matrix:Matrix;
        private var _errorStatus:Boolean;
        private var _colorMatrix:ColorMatrix;
        private var _colorFilter:ColorMatrixFilter;
        private var _filters:Array;
        var _deformation:Boolean;
        private static var GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);

        public function FSprite(param1:FObject)
        {
            this._owner = param1;
            this._scaleX = 1;
            this._scaleY = 1;
            this._rotation = 0;
            this._skewX = 0;
            this._skewY = 0;
            this._matrix = new Matrix();
            this.mouseEnabled = false;
            this._rootContainer = new Sprite();
            addChild(this._rootContainer);
            this._container = new Sprite();
            this._rootContainer.addChild(this._container);
            return;
        }// end function

        public function get owner() : FObject
        {
            return this._owner;
        }// end function

        public function get rootContainer() : Sprite
        {
            return this._rootContainer;
        }// end function

        public function get container() : Sprite
        {
            return this._container;
        }// end function

        final public function get contentScaleX() : Number
        {
            return this._scaleX;
        }// end function

        public function set contentScaleX(param1:Number) : void
        {
            this.setContentScale(param1, this._scaleY);
            return;
        }// end function

        final public function get contentScaleY() : Number
        {
            return this._scaleY;
        }// end function

        public function set contentScaleY(param1:Number) : void
        {
            this.setContentScale(this._scaleX, param1);
            return;
        }// end function

        public function setContentScale(param1:Number, param2:Number) : void
        {
            if (this._scaleX != param1 || this._scaleY != param2)
            {
                this._scaleX = param1;
                this._scaleY = param2;
                this.updateMatrix();
            }
            return;
        }// end function

        final public function get contentRotation() : Number
        {
            return this._rotation;
        }// end function

        public function set contentRotation(param1:Number) : void
        {
            this._rotation = param1;
            this.updateMatrix();
            return;
        }// end function

        final public function get contentSkewX() : Number
        {
            return this._skewX;
        }// end function

        public function set contentSkewX(param1:Number) : void
        {
            this.setContentSkew(param1, this._skewY);
            return;
        }// end function

        final public function get contentSkewY() : Number
        {
            return this._skewY;
        }// end function

        public function set contentSkewY(param1:Number) : void
        {
            this.setContentScale(this._skewX, param1);
            return;
        }// end function

        public function setContentSkew(param1:Number, param2:Number) : void
        {
            if (this._skewX != param1 || this._skewY != param2)
            {
                this._skewX = param1;
                this._skewY = param2;
                this.updateMatrix();
            }
            return;
        }// end function

        public function get contentMatrix() : Matrix
        {
            return this._matrix;
        }// end function

        public function reset() : void
        {
            if (this._maskArea != null && this._maskArea.parent != null)
            {
                this._maskArea.parent.removeChild(this._maskArea);
            }
            this._maskArea = null;
            this.blendMode = BlendMode.NORMAL;
            this._rootContainer.mask = null;
            if (this._maskObject)
            {
                this._maskObject.dispatcher.off(FObject.XY_CHANGED, this.onMaskChanged);
                this._maskObject.dispatcher.off(FObject.SCALE_CHANGED, this.onMaskChanged);
                this._maskObject.displayObject.removeEventListener(Event.ADDED_TO_STAGE, this.onMaskChanged2);
                this._maskObject.displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, this.onMaskChanged2);
                this._maskObject = null;
            }
            if (this._hitArea != null && this._hitArea.parent != null)
            {
                this._hitArea.parent.removeChild(this._hitArea);
            }
            this._hitArea = null;
            this._rootContainer.hitArea = null;
            var _loc_1:* = true;
            this._container.mouseEnabled = true;
            this._rootContainer.mouseEnabled = _loc_1;
            return;
        }// end function

        public function setMask(param1:FObject) : void
        {
            this._maskObject = param1;
            if (this._maskArea == null)
            {
                this._maskArea = new Sprite();
                this._maskArea.mouseEnabled = false;
                if (FComponent(this._owner).reversedMask)
                {
                    this._maskArea.blendMode = BlendMode.ERASE;
                }
            }
            var _loc_2:* = this._maskObject.displayObject.parent != null;
            if (_loc_2)
            {
                this._rootContainer.addChild(this._maskArea);
            }
            this._maskObject.displayObject._rootContainer.visible = false;
            this._maskObject.dispatcher.on(FObject.XY_CHANGED, this.onMaskChanged);
            this._maskObject.dispatcher.on(FObject.SCALE_CHANGED, this.onMaskChanged);
            this._maskObject.displayObject.addEventListener(Event.ADDED_TO_STAGE, this.onMaskChanged2);
            this._maskObject.displayObject.addEventListener(Event.REMOVED_FROM_STAGE, this.onMaskChanged2);
            this.onMaskChanged();
            this._maskArea.graphics.clear();
            if (this._maskObject is FImage)
            {
                if (FImage(this._maskObject).bitmap.bitmapData != null)
                {
                    if (this._owner._pkg.project.supportAlphaMask && !FComponent(this._owner).reversedMask)
                    {
                        this.fillBitmapToGraphics(FImage(this._maskObject).bitmap.bitmapData, this._maskArea.graphics, 1);
                    }
                    else
                    {
                        this._maskArea.graphics.beginBitmapFill(FImage(this._maskObject).bitmap.bitmapData, null, false);
                        this._maskArea.graphics.drawRect(0, 0, this._maskObject.width, this._maskObject.height);
                        this._maskArea.graphics.endFill();
                    }
                }
            }
            else
            {
                this._maskArea.graphics.copyFrom(this._maskObject.displayObject._container.graphics);
            }
            if (_loc_2)
            {
                if (FComponent(this._owner).reversedMask)
                {
                    this.blendMode = BlendMode.LAYER;
                }
                else
                {
                    this._rootContainer.mask = this._maskArea;
                }
            }
            this.drawBackground();
            return;
        }// end function

        private function onMaskChanged() : void
        {
            var _loc_1:* = this._maskObject.displayObject;
            var _loc_2:* = new Matrix();
            Utils.skew(_loc_2, _loc_1.contentSkewX, _loc_1.contentSkewY);
            if (this._maskObject is FImage)
            {
                _loc_2.scale(_loc_1.contentScaleX * FImage(this._maskObject).bitmap.scaleX, _loc_1.contentScaleY * FImage(this._maskObject).bitmap.scaleY);
            }
            else
            {
                _loc_2.scale(_loc_1.contentScaleX, _loc_1.contentScaleY);
            }
            _loc_2.rotate(_loc_1.contentRotation * Utils.DEG_TO_RAD);
            _loc_2.translate(_loc_1.x, _loc_1.y);
            this._maskArea.transform.matrix = _loc_2;
            return;
        }// end function

        private function onMaskChanged2(event:Event) : void
        {
            if (event.type == Event.ADDED_TO_STAGE)
            {
                this._rootContainer.addChild(this._maskArea);
                if (FComponent(this._owner).reversedMask)
                {
                    this.blendMode = BlendMode.LAYER;
                }
                else
                {
                    this._rootContainer.mask = this._maskArea;
                }
            }
            else
            {
                if (this._maskArea.parent)
                {
                    this._rootContainer.removeChild(this._maskArea);
                }
                if (FComponent(this._owner).reversedMask)
                {
                    this.blendMode = BlendMode.NORMAL;
                }
                else
                {
                    this._rootContainer.mask = null;
                }
            }
            return;
        }// end function

        public function setHitArea(param1:FObject) : void
        {
            this._rootContainer.mouseChildren = false;
            if (this._hitArea == null)
            {
                this._hitArea = new Sprite();
                this._hitArea.mouseEnabled = false;
                this._rootContainer.addChild(this._hitArea);
            }
            this._hitArea.x = param1.x;
            this._hitArea.y = param1.y;
            this._hitArea.scaleX = param1.scaleX;
            this._hitArea.scaleY = param1.scaleY;
            this._hitArea.graphics.clear();
            this._hitArea.visible = false;
            if (param1 is FImage)
            {
                if (FImage(param1).source != null)
                {
                    this.fillBitmapToGraphics(FImage(param1).source, this._hitArea.graphics, 0);
                }
            }
            else
            {
                this._hitArea.graphics.copyFrom(param1.displayObject._container.graphics);
            }
            this._rootContainer.hitArea = this._hitArea;
            return;
        }// end function

        public function handleSizeChanged() : void
        {
            this.drawBackground();
            return;
        }// end function

        public function handleXYChanged() : void
        {
            if (this._owner.anchor && !FObjectFlags.isDocRoot(this._owner._flags))
            {
                this.x = int(this._owner.x - this._owner.pivotX * this._owner.width) + this._owner.pivotOffsetX;
                this.y = int(this._owner.y - this._owner.pivotY * this._owner.height) + this._owner.pivotOffsetY;
            }
            else
            {
                this.x = int(this._owner.x) + this._owner.pivotOffsetX;
                this.y = int(this._owner.y) + this._owner.pivotOffsetY;
            }
            return;
        }// end function

        public function get errorStatus() : Boolean
        {
            return this._errorStatus;
        }// end function

        public function set errorStatus(param1:Boolean) : void
        {
            if (this._errorStatus != param1)
            {
                this._errorStatus = param1;
                this.drawBackground();
            }
            return;
        }// end function

        private function drawBackground() : void
        {
            var _loc_1:* = this._rootContainer.graphics;
            _loc_1.clear();
            var _loc_2:* = this._owner.width;
            var _loc_3:* = this._owner.height;
            var _loc_4:* = false;
            if (this._errorStatus)
            {
                if (_loc_2 > 0 && _loc_3 > 0)
                {
                    _loc_1.lineStyle(Consts.auxLineSize, 16724736, 1, true, LineScaleMode.NORMAL);
                    _loc_1.beginFill(16777215, 1);
                    _loc_1.drawRect(0.5, 0.5, (_loc_2 - 1), (_loc_3 - 1));
                    _loc_1.endFill();
                    _loc_1.moveTo(0.5, 0.5);
                    _loc_1.lineTo((_loc_2 - 1), (_loc_3 - 1));
                    _loc_1.moveTo((_loc_2 - 1), 0.5);
                    _loc_1.lineTo(0.5, (_loc_3 - 1));
                }
                _loc_4 = true;
            }
            else if ((this._owner._flags & FObjectFlags.INSPECTING) != 0 || ((this._owner._flags & FObjectFlags.IN_PREVIEW) == 0 && (this._owner is FComponent && FComponent(this._owner).opaque) || this._owner is FList))
            {
                if (_loc_2 > 0 && _loc_3 > 0)
                {
                    _loc_1.lineStyle(0, 0, 0);
                    _loc_1.beginFill(0, 0);
                    _loc_1.drawRect(0, 0, _loc_2, _loc_3);
                    _loc_1.endFill();
                }
                _loc_4 = true;
            }
            else
            {
                _loc_4 = false;
            }
            var _loc_5:* = _loc_4;
            this._container.mouseEnabled = _loc_4;
            this._rootContainer.mouseEnabled = _loc_5;
            return;
        }// end function

        private function updateMatrix() : void
        {
            this._matrix.identity();
            Utils.skew(this._matrix, this._skewX, this._skewY);
            this._matrix.scale(this._scaleX, this._scaleY);
            this._matrix.rotate(this._rotation * Utils.DEG_TO_RAD);
            this._deformation = this._matrix.a != 1 || this._matrix.b != 0 || this._matrix.c != 0 || this._matrix.d != 1;
            this._rootContainer.transform.matrix = this._matrix;
            return;
        }// end function

        private function fillBitmapToGraphics(param1:BitmapData, param2:Graphics, param3:Number) : void
        {
            var _loc_4:* = new Vector.<IGraphicsData>;
            var _loc_5:* = new GraphicsSolidFill(0, param3);
            _loc_4.push(new GraphicsStroke(1, false, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND, 3, _loc_5));
            _loc_4.push(new GraphicsSolidFill(0, param3));
            var _loc_6:* = 0;
            var _loc_7:* = ">";
            var _loc_8:* = 10;
            var _loc_9:* = 1;
            var _loc_10:* = false;
            var _loc_11:* = 0.2;
            var _loc_12:* = new POTraceParams(_loc_6, _loc_7, _loc_8, _loc_9, _loc_10, _loc_11);
            var _loc_13:* = new BitmapData(param1.width, param1.height, false, 0);
            if (this._owner._pkg.project.type == ProjectType.CORONA)
            {
                _loc_13.draw(param1);
            }
            else
            {
                _loc_13.copyChannel(param1, param1.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
            }
            var _loc_14:* = new POTrace(_loc_12);
            _loc_14.backend = new GraphicsDataBackend(_loc_4);
            _loc_14.potrace_trace(_loc_13);
            _loc_13.dispose();
            _loc_4.push(new GraphicsEndFill());
            param2.drawGraphicsData(_loc_4);
            return;
        }// end function

        public function setLoading(param1:Boolean) : void
        {
            if (param1)
            {
                if (this._loadingSign == null)
                {
                    this._loadingSign = UIPackage.createObject("Builder", "loading").asMovieClip;
                    this._loadingSign.touchable = false;
                }
                addChild(this._loadingSign.displayObject);
            }
            else if (this._loadingSign != null && this._loadingSign.displayObject.parent != null)
            {
                removeChild(this._loadingSign.displayObject);
            }
            return;
        }// end function

        public function applyFilter() : void
        {
            var _loc_1:* = this._owner.grayed && !(this._owner is FComponent);
            if (this._owner.filter == "none" && !_loc_1)
            {
                this.filters = null;
            }
            else
            {
                if (!this._filters)
                {
                    this._filters = [];
                }
                else
                {
                    this._filters.length = 0;
                }
                if (_loc_1)
                {
                    this._filters.push(GRAY_FILTER);
                }
                if (this._owner.filter != "none")
                {
                    if (this._colorFilter == null)
                    {
                        this._colorMatrix = new ColorMatrix();
                        this._colorFilter = new ColorMatrixFilter();
                    }
                    else
                    {
                        this._colorMatrix.reset();
                    }
                    this._colorMatrix.adjustBrightness(this._owner.filterData.brightness);
                    this._colorMatrix.adjustContrast(this._owner.filterData.contrast);
                    this._colorMatrix.adjustSaturation(this._owner.filterData.saturation);
                    this._colorMatrix.adjustHue(this._owner.filterData.hue);
                    this._colorFilter.matrix = this._colorMatrix;
                    this._filters.push(this._colorFilter);
                }
                this.filters = this._filters;
            }
            return;
        }// end function

    }
}
