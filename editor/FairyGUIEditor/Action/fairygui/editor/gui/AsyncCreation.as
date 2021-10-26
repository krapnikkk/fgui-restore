package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.gui.animation.*;
    import fairygui.utils.*;
    import flash.utils.*;

    public class AsyncCreation extends Object
    {
        public var callback:Function;
        private var _pkg:FPackage;
        private var _itemList:Vector.<FDisplayListItem>;
        private var _objectPool:Vector.<FObject>;
        private var _loadingImages:Vector.<FPackageItem>;
        private var _index:int;
        private var _flags:int;
        private static var frameTimeForAsyncUIConstruction:int = 2;

        public function AsyncCreation()
        {
            this._itemList = new Vector.<FDisplayListItem>;
            this._objectPool = new Vector.<FObject>;
            this._loadingImages = new Vector.<FPackageItem>;
            return;
        }// end function

        public function cancel() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            GTimers.inst.remove(this.run);
            GTimers.inst.remove(this.wait);
            GTimers.inst.remove(this.complete);
            this._loadingImages.length = 0;
            this.callback = null;
            if (this._itemList.length > 0)
            {
                for each (_loc_1 in this._itemList)
                {
                    
                    if (_loc_1.packageItem)
                    {
                        _loc_1.packageItem.releaseRef();
                    }
                }
                _loc_4.length = 0;
            }
            if (this._objectPool.length > 0)
            {
                for each (_loc_2 in this._objectPool)
                {
                    
                    _loc_2.dispose();
                }
                _loc_4.length = 0;
            }
            return;
        }// end function

        public function createObject(param1:FPackageItem, param2:int = 0) : void
        {
            var _loc_3:* = null;
            this._itemList.length = 0;
            this._objectPool.length = 0;
            this._loadingImages.length = 0;
            this._flags = param2;
            this._pkg = param1.owner;
            this.collectComponentChildren(param1);
            this._itemList.push(new FDisplayListItem(param1, null, null));
            for each (_loc_3 in this._itemList)
            {
                
                if (_loc_3.packageItem)
                {
                    _loc_3.packageItem.addRef();
                }
            }
            this._index = 0;
            GTimers.inst.add(1, 0, this.run);
            return;
        }// end function

        private function collectComponentChildren(param1:FPackageItem) : void
        {
            var _loc_6:* = null;
            var _loc_2:* = param1.owner;
            var _loc_3:* = param1.getComponentData();
            var _loc_4:* = _loc_3.displayList.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = _loc_3.displayList[_loc_5];
                if (_loc_6.packageItem != null && _loc_6.packageItem.type == FPackageItemType.COMPONENT)
                {
                    this.collectComponentChildren(_loc_6.packageItem);
                }
                this._itemList.push(_loc_6);
                _loc_5++;
            }
            return;
        }// end function

        private function run() : void
        {
            var obj:FObject;
            var di:FDisplayListItem;
            var poolStart:int;
            var k:int;
            var f:Function;
            if (!this._pkg.project || !this._pkg.project.editor)
            {
                this.cancel();
                return;
            }
            var t:* = getTimer();
            var totalItems:* = this._itemList.length;
            while (this._index < totalItems)
            {
                
                di = this._itemList[this._index];
                if (this._index == (totalItems - 1))
                {
                    FObjectFactory.constructingDepth = 1;
                    obj = FObjectFactory.newObject3(di, this._flags);
                }
                else
                {
                    FObjectFactory.constructingDepth = 2;
                    obj = FObjectFactory.newObject3(di, this._flags & 255);
                }
                if (di.packageItem != null)
                {
                    this._objectPool.push(obj);
                    if (di.packageItem.type == FPackageItemType.COMPONENT)
                    {
                        poolStart = this._objectPool.length - di.packageItem.getComponentData().displayList.length - 1;
                        obj._res.displayItem.getComponentData().setInstances(this._objectPool, poolStart);
                        try
                        {
                            obj.create();
                        }
                        catch (err:Error)
                        {
                            _pkg.project.editor.consoleView.logError("AsyncCreate", err);
                        }
                        finally
                        {
                            obj._res.displayItem.getComponentData().setInstances(null, 0);
                        }
                        this._objectPool.splice(poolStart, di.packageItem.getComponentData().displayList.length);
                    }
                    else
                    {
                        obj.create();
                    }
                }
                else
                {
                    obj.create();
                    this._objectPool.push(obj);
                }
                FObjectFactory.constructingDepth = 0;
                var _loc_2:* = this;
                var _loc_3:* = this._index + 1;
                _loc_2._index = _loc_3;
                if (this._index % 5 == 0 && getTimer() - t >= frameTimeForAsyncUIConstruction)
                {
                    return;
                }
            }
            var result:* = FComponent(this._objectPool[0]);
            this._objectPool.length = 0;
            if ((this._flags & FObjectFlags.IN_PREVIEW) != 0)
            {
                result.collectLoadingImages(this._loadingImages);
                this._index = 0;
                GTimers.inst.remove(this.run);
                GTimers.inst.add(1, 0, this.wait, result);
            }
            else
            {
                f = this.callback;
                this.cancel();
                this.f(result);
            }
            return;
        }// end function

        private function wait(param1:FObject) : void
        {
            while (this._index < this._loadingImages.length)
            {
                
                if (this._loadingImages[this._index].loading)
                {
                    return;
                }
                var _loc_2:* = this;
                var _loc_3:* = this._index + 1;
                _loc_2._index = _loc_3;
            }
            if (DecodeSupport.inst.busy)
            {
                return;
            }
            GTimers.inst.remove(this.wait);
            GTimers.inst.add(1, 1, this.complete, param1);
            return;
        }// end function

        private function complete(param1:FObject) : void
        {
            var _loc_2:* = this.callback;
            this.cancel();
            this._loc_2(param1);
            return;
        }// end function

    }
}
