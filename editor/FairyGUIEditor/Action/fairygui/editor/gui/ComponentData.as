package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.api.*;
    import fairygui.utils.*;

    public class ComponentData extends Object
    {
        private var _packageItem:FPackageItem;
        private var _xml:XData;
        private var _displayList:Vector.<FDisplayListItem>;
        private static var helperComPropertyList:Vector.<ComProperty> = new Vector.<ComProperty>;

        public function ComponentData(param1:FPackageItem)
        {
            this._packageItem = param1;
            return;
        }// end function

        public function get packageItem() : FPackageItem
        {
            return this._packageItem;
        }// end function

        public function get xml() : XData
        {
            if (!this._xml)
            {
                this.loadXML();
            }
            return this._xml;
        }// end function

        private function loadXML() : void
        {
            var doc:* = this._packageItem.getVar("doc");
            if (doc && doc.isModified && doc.content)
            {
                this._xml = XData(doc.serialize());
            }
            else if (this._packageItem.file.exists)
            {
                try
                {
                    this._xml = UtilsFile.loadXData(this._packageItem.file);
                }
                catch (err:Error)
                {
                }
            }
            return;
        }// end function

        public function get displayList() : Vector.<FDisplayListItem>
        {
            if (!this._displayList)
            {
                this.loadChildren();
            }
            return this._displayList;
        }// end function

        private function loadChildren() : void
        {
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            if (!this._xml)
            {
                this.loadXML();
            }
            if (this._xml == null)
            {
                this._displayList = new Vector.<FDisplayListItem>(0);
                return;
            }
            var _loc_1:* = this._xml.getChild("displayList");
            if (_loc_1 == null)
            {
                this._displayList = new Vector.<FDisplayListItem>(0);
                return;
            }
            var _loc_2:* = _loc_1.getChildren();
            var _loc_3:* = _loc_2.length;
            this._displayList = new Vector.<FDisplayListItem>(_loc_3);
            var _loc_5:* = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_6 = _loc_2[_loc_5];
                _loc_7 = _loc_6.getName();
                _loc_8 = _loc_6.getAttribute("src");
                if (_loc_8)
                {
                    _loc_9 = _loc_6.getAttribute("pkg");
                    if (_loc_9 && _loc_9 != this._packageItem.owner.id)
                    {
                        _loc_10 = this._packageItem.owner.project.getPackage(_loc_9) as FPackage;
                    }
                    else
                    {
                        _loc_10 = this._packageItem.owner;
                    }
                    _loc_11 = _loc_10 ? (_loc_10.getItem(_loc_8)) : (null);
                    _loc_4 = new FDisplayListItem(_loc_11, _loc_10 ? (_loc_10) : (this._packageItem.owner), _loc_7);
                    if (_loc_11 == null)
                    {
                        _loc_4.missingInfo = MissingInfo.create(this._packageItem.owner, _loc_10 ? (_loc_10.id) : (_loc_9), _loc_8, _loc_6.getAttribute("fileName"));
                    }
                }
                else
                {
                    _loc_4 = new FDisplayListItem(null, this._packageItem.owner, _loc_7);
                }
                _loc_4.desc = _loc_6;
                this._displayList[_loc_5] = _loc_4;
                _loc_5++;
            }
            return;
        }// end function

        public function setInstances(param1:Vector.<FObject>, param2:int) : void
        {
            var _loc_4:* = 0;
            var _loc_3:* = this.displayList.length;
            if (param1)
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    this._displayList[_loc_4].existingInstance = param1[param2 + _loc_4];
                    _loc_4++;
                }
            }
            else
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    this._displayList[_loc_4].existingInstance = null;
                    _loc_4++;
                }
            }
            return;
        }// end function

        public function getCustomProperties() : Vector.<ComProperty>
        {
            if (!this._xml)
            {
                this.loadXML();
            }
            if (!this._xml)
            {
                return null;
            }
            helperComPropertyList.length = 0;
            var _loc_1:* = this._xml.getEnumerator("controller");
            while (_loc_1.moveNext())
            {
                
                if (_loc_1.current.getAttributeBool("exported"))
                {
                    helperComPropertyList.push(new ComProperty(_loc_1.current.getAttribute("name"), -1, _loc_1.current.getAttribute("alias")));
                }
            }
            _loc_1 = this._xml.getEnumerator("customProperty");
            while (_loc_1.moveNext())
            {
                
                helperComPropertyList.push(new ComProperty(_loc_1.current.getAttribute("target"), _loc_1.current.getAttributeInt("propertyId"), _loc_1.current.getAttribute("label")));
            }
            if (helperComPropertyList.length > 0)
            {
                return helperComPropertyList.concat();
            }
            return null;
        }// end function

        public function getControllerPages(param1:String, param2:Array, param3:Array) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            if (!this._xml)
            {
                this.loadXML();
            }
            if (!this._xml)
            {
                return;
            }
            var _loc_4:* = this._xml.getEnumerator("controller");
            while (_loc_4.moveNext())
            {
                
                if (_loc_4.current.getAttribute("name") == param1)
                {
                    _loc_5 = _loc_4.current.getAttribute("pages");
                    if (_loc_5)
                    {
                        _loc_6 = _loc_5.split(",");
                        _loc_7 = _loc_6.length / 2;
                        _loc_8 = 0;
                        while (_loc_8 < _loc_7)
                        {
                            
                            param3.push(_loc_6[_loc_8 * 2]);
                            _loc_5 = _loc_6[_loc_8 * 2 + 1];
                            if (_loc_5)
                            {
                                _loc_5 = _loc_8 + ":" + _loc_5;
                            }
                            else
                            {
                                _loc_5 = "" + _loc_8;
                            }
                            param2.push(_loc_5);
                            _loc_8++;
                        }
                    }
                    break;
                }
            }
            return;
        }// end function

        public function dispose() : void
        {
            if (this._xml)
            {
                this._xml.dispose();
                this._xml = null;
            }
            this._displayList = null;
            return;
        }// end function

    }
}
