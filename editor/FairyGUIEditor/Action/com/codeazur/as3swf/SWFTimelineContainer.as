package com.codeazur.as3swf
{
    import __AS3__.vec.*;
    import com.codeazur.as3swf.data.*;
    import com.codeazur.as3swf.data.consts.*;
    import com.codeazur.as3swf.events.*;
    import com.codeazur.as3swf.factories.*;
    import com.codeazur.as3swf.tags.*;
    import com.codeazur.as3swf.timeline.*;
    import com.codeazur.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class SWFTimelineContainer extends SWFEventDispatcher
    {
        protected var _tags:Vector.<ITag>;
        protected var _tagsRaw:Vector.<SWFRawTag>;
        protected var _dictionary:Dictionary;
        protected var _scenes:Vector.<Scene>;
        protected var _frames:Vector.<Frame>;
        protected var _layers:Vector.<Layer>;
        protected var _soundStream:SoundStream;
        protected var currentFrame:Frame;
        protected var frameLabels:Dictionary;
        protected var hasSoundStream:Boolean = false;
        protected var enterFrameProvider:Sprite;
        protected var eof:Boolean;
        protected var _tmpData:SWFData;
        protected var _tmpVersion:uint;
        protected var _tmpTagIterator:int = 0;
        protected var _tagFactory:ISWFTagFactory;
        var rootTimelineContainer:SWFTimelineContainer;
        public var backgroundColor:uint = 16777215;
        public var jpegTablesTag:TagJPEGTables;
        public static var TIMEOUT:int = 50;
        public static var AUTOBUILD_LAYERS:Boolean = false;
        public static var EXTRACT_SOUND_STREAM:Boolean = true;

        public function SWFTimelineContainer()
        {
            this._tags = new Vector.<ITag>;
            this._tagsRaw = new Vector.<SWFRawTag>;
            this._dictionary = new Dictionary();
            this._scenes = new Vector.<Scene>;
            this._frames = new Vector.<Frame>;
            this._layers = new Vector.<Layer>;
            this._tagFactory = new SWFTagFactory();
            this.rootTimelineContainer = this;
            this.enterFrameProvider = new Sprite();
            return;
        }// end function

        public function get tags() : Vector.<ITag>
        {
            return this._tags;
        }// end function

        public function get tagsRaw() : Vector.<SWFRawTag>
        {
            return this._tagsRaw;
        }// end function

        public function get dictionary() : Dictionary
        {
            return this._dictionary;
        }// end function

        public function get scenes() : Vector.<Scene>
        {
            return this._scenes;
        }// end function

        public function get frames() : Vector.<Frame>
        {
            return this._frames;
        }// end function

        public function get layers() : Vector.<Layer>
        {
            return this._layers;
        }// end function

        public function get soundStream() : SoundStream
        {
            return this._soundStream;
        }// end function

        public function get tagFactory() : ISWFTagFactory
        {
            return this._tagFactory;
        }// end function

        public function set tagFactory(param1:ISWFTagFactory) : void
        {
            this._tagFactory = param1;
            return;
        }// end function

        public function getCharacter(param1:uint) : IDefinitionTag
        {
            var _loc_2:* = this.rootTimelineContainer.dictionary[param1];
            if (_loc_2 >= 0 && _loc_2 < this.rootTimelineContainer.tags.length)
            {
                return this.rootTimelineContainer.tags[_loc_2] as IDefinitionTag;
            }
            return null;
        }// end function

        public function parseTags(param1:SWFData, param2:uint) : void
        {
            var _loc_3:* = null;
            this.parseTagsInit(param1, param2);
            do
            {
                
                var _loc_4:* = this.parseTag(param1);
                _loc_3 = this.parseTag(param1);
            }while (_loc_4 && _loc_3.type != TagEnd.TYPE)
            this.parseTagsFinalize();
            return;
        }// end function

        public function parseTagsAsync(param1:SWFData, param2:uint) : void
        {
            this.parseTagsInit(param1, param2);
            this.enterFrameProvider.addEventListener(Event.ENTER_FRAME, this.parseTagsAsyncHandler);
            return;
        }// end function

        protected function parseTagsAsyncHandler(event:Event) : void
        {
            this.enterFrameProvider.removeEventListener(Event.ENTER_FRAME, this.parseTagsAsyncHandler);
            if (dispatchEvent(new SWFProgressEvent(SWFProgressEvent.PROGRESS, this._tmpData.position, this._tmpData.length, false, true)))
            {
                this.parseTagsAsyncInternal();
            }
            return;
        }// end function

        protected function parseTagsAsyncInternal() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = getTimer();
            do
            {
                
                if (getTimer() - _loc_2 > TIMEOUT)
                {
                    this.enterFrameProvider.addEventListener(Event.ENTER_FRAME, this.parseTagsAsyncHandler);
                    return;
                }
                var _loc_3:* = this.parseTag(this._tmpData, true);
                _loc_1 = this.parseTag(this._tmpData, true);
            }while (_loc_3 && _loc_1.type != TagEnd.TYPE)
            this.parseTagsFinalize();
            if (this.eof)
            {
                dispatchEvent(new SWFErrorEvent(SWFErrorEvent.ERROR, SWFErrorEvent.REASON_EOF));
            }
            else
            {
                dispatchEvent(new SWFProgressEvent(SWFProgressEvent.PROGRESS, this._tmpData.position, this._tmpData.length));
                dispatchEvent(new SWFProgressEvent(SWFProgressEvent.COMPLETE, this._tmpData.position, this._tmpData.length));
            }
            return;
        }// end function

        protected function parseTagsInit(param1:SWFData, param2:uint) : void
        {
            this.tags.length = 0;
            this.frames.length = 0;
            this.layers.length = 0;
            this._dictionary = new Dictionary();
            this.currentFrame = new Frame();
            this.frameLabels = new Dictionary();
            this.hasSoundStream = false;
            this._tmpData = param1;
            this._tmpVersion = param2;
            return;
        }// end function

        protected function parseTag(param1:SWFData, param2:Boolean = false) : ITag
        {
            var tag:ITag;
            var timelineContainer:SWFTimelineContainer;
            var index:uint;
            var excessBytes:int;
            var eventType:String;
            var eventData:Object;
            var event:SWFWarningEvent;
            var cancelled:Boolean;
            var data:* = param1;
            var async:* = param2;
            var pos:* = data.position;
            this.eof = pos >= data.length;
            if (this.eof)
            {
                trace("WARNING: end of file encountered, no end tag.");
                return null;
            }
            var tagRaw:* = data.readRawTag();
            var tagHeader:* = tagRaw.header;
            tag = this.tagFactory.create(tagHeader.type);
            try
            {
                if (tag is SWFTimelineContainer)
                {
                    timelineContainer = tag as SWFTimelineContainer;
                    timelineContainer.tagFactory = this.tagFactory;
                    timelineContainer.rootTimelineContainer = this;
                }
                tag.parse(data, tagHeader.contentLength, this._tmpVersion, async);
            }
            catch (e:Error)
            {
                trace("WARNING: parse error: " + e.message + ", Tag: " + tag.name + ", Index: " + tags.length);
                throw e;
            }
            this.tags.push(tag);
            this.tagsRaw.push(tagRaw);
            this.processTag(tag);
            if (data.position != pos + tagHeader.tagLength)
            {
                index = (this.tags.length - 1);
                excessBytes = data.position - (pos + tagHeader.tagLength);
                eventType = excessBytes < 0 ? (SWFWarningEvent.UNDERFLOW) : (SWFWarningEvent.OVERFLOW);
                eventData;
                if (this.rootTimelineContainer == this)
                {
                    trace("WARNING: excess bytes: " + excessBytes + ", " + "Tag: " + tag.name + ", " + "Index: " + index);
                }
                else
                {
                    eventData.indexRoot = this.rootTimelineContainer.tags.length;
                    trace("WARNING: excess bytes: " + excessBytes + ", " + "Tag: " + tag.name + ", " + "Index: " + index + ", " + "IndexRoot: " + eventData.indexRoot);
                }
                event = new SWFWarningEvent(eventType, index, eventData, false, true);
                cancelled = !dispatchEvent(event);
                if (cancelled)
                {
                    tag;
                }
                data.position = pos + tagHeader.tagLength;
            }
            return tag;
        }// end function

        protected function parseTagsFinalize() : void
        {
            if (this.soundStream && this.soundStream.data.length == 0)
            {
                this._soundStream = null;
            }
            if (AUTOBUILD_LAYERS)
            {
                this.buildLayers();
            }
            return;
        }// end function

        public function publishTags(param1:SWFData, param2:uint) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            while (_loc_5 < this.tags.length)
            {
                
                _loc_3 = this.tags[_loc_5];
                _loc_4 = _loc_5 < this.tagsRaw.length ? (this.tagsRaw[_loc_5]) : (null);
                this.publishTag(param1, _loc_3, _loc_4, param2);
                _loc_5 = _loc_5 + 1;
            }
            return;
        }// end function

        public function publishTagsAsync(param1:SWFData, param2:uint) : void
        {
            this._tmpData = param1;
            this._tmpVersion = param2;
            this._tmpTagIterator = 0;
            this.enterFrameProvider.addEventListener(Event.ENTER_FRAME, this.publishTagsAsyncHandler);
            return;
        }// end function

        protected function publishTagsAsyncHandler(event:Event) : void
        {
            this.enterFrameProvider.removeEventListener(Event.ENTER_FRAME, this.publishTagsAsyncHandler);
            if (dispatchEvent(new SWFProgressEvent(SWFProgressEvent.PROGRESS, this._tmpTagIterator, this.tags.length)))
            {
                this.publishTagsAsyncInternal();
            }
            return;
        }// end function

        protected function publishTagsAsyncInternal() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = getTimer();
            do
            {
                
                _loc_1 = this._tmpTagIterator < this.tags.length ? (this.tags[this._tmpTagIterator]) : (null);
                _loc_2 = this._tmpTagIterator < this.tagsRaw.length ? (this.tagsRaw[this._tmpTagIterator]) : (null);
                this.publishTag(this._tmpData, _loc_1, _loc_2, this._tmpVersion);
                var _loc_4:* = this;
                var _loc_5:* = this._tmpTagIterator + 1;
                _loc_4._tmpTagIterator = _loc_5;
                if (getTimer() - _loc_3 > TIMEOUT)
                {
                    this.enterFrameProvider.addEventListener(Event.ENTER_FRAME, this.publishTagsAsyncHandler);
                    return;
                }
            }while (_loc_1.type != TagEnd.TYPE)
            dispatchEvent(new SWFProgressEvent(SWFProgressEvent.PROGRESS, this._tmpTagIterator, this.tags.length));
            dispatchEvent(new SWFProgressEvent(SWFProgressEvent.COMPLETE, this._tmpTagIterator, this.tags.length));
            return;
        }// end function

        public function publishTag(param1:SWFData, param2:ITag, param3:SWFRawTag, param4:uint) : void
        {
            var data:* = param1;
            var tag:* = param2;
            var rawTag:* = param3;
            var version:* = param4;
            try
            {
                tag.publish(data, version);
            }
            catch (e:Error)
            {
                trace("WARNING: publish error: " + e.message + " (tag: " + tag.name + ")");
                if (rawTag)
                {
                    rawTag.publish(data);
                }
                else
                {
                    trace("FATAL: publish error: No raw tag fallback");
                }
            }
            return;
        }// end function

        protected function processTag(param1:ITag) : void
        {
            var _loc_2:* = this.tags.length - 1;
            if (param1 is IDefinitionTag)
            {
                this.processDefinitionTag(param1 as IDefinitionTag, _loc_2);
                return;
            }
            if (param1 is IDisplayListTag)
            {
                this.processDisplayListTag(param1 as IDisplayListTag, _loc_2);
                return;
            }
            switch(param1.type)
            {
                case TagFrameLabel.TYPE:
                case TagDefineSceneAndFrameLabelData.TYPE:
                {
                    this.processFrameLabelTag(param1, _loc_2);
                    break;
                }
                case TagSoundStreamHead.TYPE:
                case TagSoundStreamHead2.TYPE:
                case TagSoundStreamBlock.TYPE:
                {
                    if (EXTRACT_SOUND_STREAM)
                    {
                        this.processSoundStreamTag(param1, _loc_2);
                    }
                    break;
                }
                case TagSetBackgroundColor.TYPE:
                {
                    this.processBackgroundColorTag(param1 as TagSetBackgroundColor, _loc_2);
                    break;
                }
                case TagJPEGTables.TYPE:
                {
                    this.processJPEGTablesTag(param1 as TagJPEGTables, _loc_2);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function processDefinitionTag(param1:IDefinitionTag, param2:uint) : void
        {
            if (param1.characterId > 0)
            {
                this.dictionary[param1.characterId] = param2;
                this.currentFrame.characters.push(param1.characterId);
            }
            return;
        }// end function

        protected function processDisplayListTag(param1:IDisplayListTag, param2:uint) : void
        {
            switch(param1.type)
            {
                case TagShowFrame.TYPE:
                {
                    this.currentFrame.tagIndexEnd = param2;
                    if (this.currentFrame.label == null && this.frameLabels[this.currentFrame.frameNumber])
                    {
                        this.currentFrame.label = this.frameLabels[this.currentFrame.frameNumber];
                    }
                    this.frames.push(this.currentFrame);
                    this.currentFrame = this.currentFrame.clone();
                    this.currentFrame.frameNumber = this.frames.length;
                    this.currentFrame.tagIndexStart = param2 + 1;
                    break;
                }
                case TagPlaceObject.TYPE:
                case TagPlaceObject2.TYPE:
                case TagPlaceObject3.TYPE:
                {
                    this.currentFrame.placeObject(param2, param1 as TagPlaceObject);
                    break;
                }
                case TagRemoveObject.TYPE:
                case TagRemoveObject2.TYPE:
                {
                    this.currentFrame.removeObject(param1 as TagRemoveObject);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function processFrameLabelTag(param1:ITag, param2:uint) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            switch(param1.type)
            {
                case TagDefineSceneAndFrameLabelData.TYPE:
                {
                    _loc_3 = param1 as TagDefineSceneAndFrameLabelData;
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3.frameLabels.length)
                    {
                        
                        _loc_6 = _loc_3.frameLabels[_loc_4] as SWFFrameLabel;
                        this.frameLabels[_loc_6.frameNumber] = _loc_6.name;
                        _loc_4 = _loc_4 + 1;
                    }
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3.scenes.length)
                    {
                        
                        _loc_7 = _loc_3.scenes[_loc_4] as SWFScene;
                        this.scenes.push(new Scene(_loc_7.offset, _loc_7.name));
                        _loc_4 = _loc_4 + 1;
                    }
                    break;
                }
                case TagFrameLabel.TYPE:
                {
                    _loc_5 = param1 as TagFrameLabel;
                    this.currentFrame.label = _loc_5.frameName;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function processSoundStreamTag(param1:ITag, param2:uint) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            switch(param1.type)
            {
                case TagSoundStreamHead.TYPE:
                case TagSoundStreamHead2.TYPE:
                {
                    _loc_3 = param1 as TagSoundStreamHead;
                    this._soundStream = new SoundStream();
                    this.soundStream.compression = _loc_3.streamSoundCompression;
                    this.soundStream.rate = _loc_3.streamSoundRate;
                    this.soundStream.size = _loc_3.streamSoundSize;
                    this.soundStream.type = _loc_3.streamSoundType;
                    this.soundStream.numFrames = 0;
                    this.soundStream.numSamples = 0;
                    break;
                }
                case TagSoundStreamBlock.TYPE:
                {
                    if (this.soundStream != null)
                    {
                        if (!this.hasSoundStream)
                        {
                            this.hasSoundStream = true;
                            this.soundStream.startFrame = this.currentFrame.frameNumber;
                        }
                        _loc_4 = param1 as TagSoundStreamBlock;
                        _loc_5 = _loc_4.soundData;
                        _loc_5.endian = Endian.LITTLE_ENDIAN;
                        _loc_5.position = 0;
                        switch(this.soundStream.compression)
                        {
                            case SoundCompression.ADPCM:
                            {
                                break;
                            }
                            case SoundCompression.MP3:
                            {
                                _loc_6 = _loc_5.readUnsignedShort();
                                _loc_7 = _loc_5.readShort();
                                if (_loc_6 > 0)
                                {
                                    this.soundStream.numSamples = this.soundStream.numSamples + _loc_6;
                                    this.soundStream.data.writeBytes(_loc_5, 4);
                                }
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                        var _loc_8:* = this.soundStream;
                        var _loc_9:* = _loc_8.numFrames + 1;
                        _loc_8.numFrames = _loc_9;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function processBackgroundColorTag(param1:TagSetBackgroundColor, param2:uint) : void
        {
            this.backgroundColor = param1.color;
            return;
        }// end function

        protected function processJPEGTablesTag(param1:TagJPEGTables, param2:uint) : void
        {
            this.jpegTablesTag = param1;
            return;
        }// end function

        public function buildLayers() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_13:* = 0;
            var _loc_14:* = 0;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_4:* = new Dictionary();
            var _loc_5:* = [];
            _loc_1 = 0;
            while (_loc_1 < this.frames.length)
            {
                
                _loc_6 = this.frames[_loc_1];
                for (_loc_2 in _loc_6.objects)
                {
                    
                    _loc_3 = parseInt(_loc_2);
                    if (_loc_5.indexOf(_loc_3) > -1)
                    {
                        (_loc_4[_loc_2] as Array).push(_loc_6.frameNumber);
                        continue;
                    }
                    _loc_4[_loc_2] = [_loc_6.frameNumber];
                    _loc_5.push(_loc_3);
                }
                _loc_1 = _loc_1 + 1;
            }
            _loc_5.sort(Array.NUMERIC);
            _loc_1 = 0;
            while (_loc_1 < _loc_5.length)
            {
                
                _loc_7 = new Layer(_loc_5[_loc_1], this.frames.length);
                _loc_8 = _loc_4[_loc_5[_loc_1].toString()];
                _loc_9 = _loc_8.length;
                if (_loc_9 > 0)
                {
                    _loc_10 = LayerStrip.TYPE_EMPTY;
                    _loc_11 = uint.MAX_VALUE;
                    _loc_12 = uint.MAX_VALUE;
                    _loc_13 = 0;
                    while (_loc_13 < _loc_9)
                    {
                        
                        _loc_14 = _loc_8[_loc_13];
                        _loc_15 = this.frames[_loc_14].objects[_loc_7.depth] as FrameObject;
                        if (_loc_15.isKeyframe)
                        {
                            _loc_7.appendStrip(_loc_10, _loc_11, _loc_12);
                            _loc_11 = _loc_14;
                            _loc_10 = this.getCharacter(_loc_15.characterId) is TagDefineMorphShape ? (LayerStrip.TYPE_SHAPETWEEN) : (LayerStrip.TYPE_STATIC);
                        }
                        else if (_loc_10 == LayerStrip.TYPE_STATIC && _loc_15.lastModifiedAtIndex > 0)
                        {
                            _loc_10 = LayerStrip.TYPE_MOTIONTWEEN;
                        }
                        _loc_12 = _loc_14;
                        _loc_13 = _loc_13 + 1;
                    }
                    _loc_7.appendStrip(_loc_10, _loc_11, _loc_12);
                }
                this._layers.push(_loc_7);
                _loc_1 = _loc_1 + 1;
            }
            _loc_1 = 0;
            while (_loc_1 < this.frames.length)
            {
                
                _loc_16 = _loc_6.objects;
                for (_loc_2 in _loc_16)
                {
                    
                    FrameObject(_loc_16[_loc_2]).layer = _loc_5.indexOf(parseInt(_loc_2));
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

        public function toString(param1:uint = 0, param2:uint = 0) : String
        {
            var _loc_3:* = 0;
            var _loc_4:* = "";
            if (this.tags.length > 0)
            {
                _loc_4 = _loc_4 + ("\n" + StringUtils.repeat(param1 + 2) + "Tags:");
                _loc_3 = 0;
                while (_loc_3 < this.tags.length)
                {
                    
                    _loc_4 = _loc_4 + ("\n" + this.tags[_loc_3].toString(param1 + 4));
                    _loc_3 = _loc_3 + 1;
                }
            }
            if ((param2 & SWF.TOSTRING_FLAG_TIMELINE_STRUCTURE) != 0)
            {
                if (this.scenes.length > 0)
                {
                    _loc_4 = _loc_4 + ("\n" + StringUtils.repeat(param1 + 2) + "Scenes:");
                    _loc_3 = 0;
                    while (_loc_3 < this.scenes.length)
                    {
                        
                        _loc_4 = _loc_4 + ("\n" + this.scenes[_loc_3].toString(param1 + 4));
                        _loc_3 = _loc_3 + 1;
                    }
                }
                if (this.frames.length > 0)
                {
                    _loc_4 = _loc_4 + ("\n" + StringUtils.repeat(param1 + 2) + "Frames:");
                    _loc_3 = 0;
                    while (_loc_3 < this.frames.length)
                    {
                        
                        _loc_4 = _loc_4 + ("\n" + this.frames[_loc_3].toString(param1 + 4));
                        _loc_3 = _loc_3 + 1;
                    }
                }
                if (this.layers.length > 0)
                {
                    _loc_4 = _loc_4 + ("\n" + StringUtils.repeat(param1 + 2) + "Layers:");
                    _loc_3 = 0;
                    while (_loc_3 < this.layers.length)
                    {
                        
                        _loc_4 = _loc_4 + ("\n" + StringUtils.repeat(param1 + 4) + "[" + _loc_3 + "] " + this.layers[_loc_3].toString(param1 + 4));
                        _loc_3 = _loc_3 + 1;
                    }
                }
            }
            return _loc_4;
        }// end function

    }
}
