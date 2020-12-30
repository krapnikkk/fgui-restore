const fs = require('fs');
const zlib = require("zlib");
const Jimp = require('jimp');
const ByteArray = require('./ByteArray');
const { resolve } = require('path');
const { exists, xml2json, json2xml, getItemById } = require('./utils/utils');
const { createMovieClip } = require('./build/create');
const { type } = require('os');


const XMLHeader = '<?xml version="1.0" encoding="utf-8"?>\n';

let importFileName = "Basics",
    inputPath = "./test/",
    outputPath = './output/',
    temp = '/temp/',
    tempPath = `${outputPath}${importFileName}${temp}`,
    pkgName = "",
    pkgId = "",
    UIPackage = {},
    fontRawDataMap = {},
    mcRawDataMap = {},
    componentMap = {};

const createByPackage = async (pkgData) => {
    // 处理package.xml 获取包名&id
    const packageData = await xml2json(pkgData["package.xml"]);
    pkgName = packageData["packageDescription"]['$']['name'];
    pkgId = packageData["packageDescription"]['$']['id'];

    // 校验纹理合图是否存在同一目录
    let atlasInfo = packageData["packageDescription"]['resources']['atlas'];
    handleAltas(atlasInfo);

    // 解析 sprites.bytes
    let imageInfo = packageData["packageDescription"]['resources']['image'];
    let spritesMap = parseSprites(pkgData['sprites.bytes']);
    imageInfo.forEach((item) => {
        let image = item['$'];
        let key = image['id'];
        Object.assign(spritesMap[key], image);
    })
    await handleSprites(spritesMap);

    let soundInfo = packageData["packageDescription"]['resources']['sound'];
    handleSound(soundInfo, false);

    let fontInfo = packageData["packageDescription"]['resources']['font'];
    let fontMap = {};
    fontInfo.forEach((item) => {
        let font = item['$'];
        let file = `${font['id']}.fnt`;
        font['content'] = pkgData[file];
        fontMap[file] = font;
    })
    createFileByData(fontMap, '.fnt');
    let movieclipInfo = packageData["packageDescription"]['resources']['movieclip'];
    let movieclipMap = {};
    movieclipInfo.forEach((item) => {
        let movieclip = item['$'];
        let file = `${movieclip['id']}.xml`;
        movieclip['content'] = pkgData[file];
        delete pkgData[file];
        movieclipMap[file] = movieclip;
    })

    await handleMovieclip(movieclipMap);

    let componentInfo = packageData["packageDescription"]['resources']['component'];
    let componentMap = {};
    componentInfo.forEach((item) => {
        let component = item['$'];
        let file = `${component['id']}.xml`;
        component['content'] = pkgData[file];
        componentMap[file] = component;
    })
    createFileByData(componentMap, ".xml");
    let path = resolve(tempPath);
    let files = fs.readdirSync(path);
    files.forEach((file) => {
        fs.unlinkSync(path + '/' + file);
    });
    fs.rmdirSync(path);
}

const createByPackage2 = async (pkgData) => {
    // 处理package.xml 获取包名&id
    const packageData = pkgData["package.xml"];
    const sprites = pkgData['sprites.bytes'];
    const files = pkgData['files'];
    // 校验纹理合图是否存在同一目录
    let atlasInfo = packageData["packageDescription"]['resources']['atlas'];
    // handleAltas(atlasInfo);

    // 解析 sprites.bytes
    let imageInfo = packageData["packageDescription"]['resources']['image'];
    let spritesMap = pkgData['sprites.bytes'];
    imageInfo.forEach((item) => {
        let image = item['$'];
        let key = image['id'];
        Object.assign(spritesMap[key], image);
    })
    // await handleSprites(spritesMap, false);

    let soundInfo = packageData["packageDescription"]['resources']['sound'];
    // handleSound(soundInfo, false);

    let fontInfo = packageData["packageDescription"]['resources']['font'];
    let fontMap = {};
    fontInfo.forEach((item) => {
        let font = item['$'];
        let file = `${font['id']}.fnt`;
        font['content'] = decodeFontData(font['id'], sprites, files);
        fontMap[file] = font;
    })
    // createFileByData(fontMap, '');

    let movieclipInfo = packageData["packageDescription"]['resources']['movieclip'];
    let movieclipMap = {};
    movieclipInfo.forEach((item) => {
        let movieclip = item['$'];
        let { id } = movieclip;
        // let file = `${movieclip['id']}.xml`;
        // movieclip['content'] = pkgData[file];
        movieclip['content'] = decodeMovieclipData(id, sprites, files);
        movieclipMap[id] = movieclip;
    })
    // await handleMovieclip(movieclipMap);

    let componentInfo = packageData["packageDescription"]['resources']['component'];
    let componentMap = {};
    componentInfo.forEach((item) => {
        let component = item['$'];
        let { id } = component;
        // let file = `${component['id']}.xml`;
        component['content'] = decodeComponent(id, files);
        componentMap[file] = component;
    })
    createFileByData(componentMap, ".xml");
    // let path = resolve(tempPath);
    // let files = fs.readdirSync(path);
    // files.forEach((file) => {
    //     fs.unlinkSync(path + '/' + file);
    // });
    // fs.rmdirSync(path);
}

function decodeFontData(id, sprites, files) {
    let rawData = fontRawDataMap[id], pi = {};
    rawData.seek(0, 0);
    pi.font = { glyphs: [] };
    pi.font.ttf = rawData.readBool();
    pi.font.tint = rawData.readBool();
    pi.font.resizable = rawData.readBool();
    pi.font.hasChannel = rawData.readBool();
    pi.font.size = rawData.readInt();
    pi.font.xadvance = rawData.readInt();
    pi.font.lineHeight = rawData.readInt();

    rawData.seek(0, 1);

    var mainTexture;
    let mainSprite = sprites[id];
    // if (mainSprite)
    //     mainTexture = mainSprite.atlas;

    let charCnt = rawData.readInt();
    for (let j = 0; j < charCnt; j++) {
        let nextPosition = rawData.readShort();
        nextPosition += rawData.pos;

        let bg = {};
        let ch = rawData.readChar() || " ";
        pi.font.glyphs[ch] = bg;

        let img = rawData.readS();
        bg.bx = rawData.readInt();
        bg.by = rawData.readInt();
        bg.x = rawData.readInt();
        bg.y = rawData.readInt();
        bg.width = rawData.readInt();
        bg.height = rawData.readInt();
        bg.advance = rawData.readInt();
        bg.channel = rawData.readByte();
        if (bg.channel == 1)
            bg.channel = 3;
        else if (bg.channel == 2)
            bg.channel = 2;
        else if (bg.channel == 3)
            bg.channel = 1;

        if (pi.font.ttf) { // face
            bg.texture = mainSprite;
            bg.lineHeight = pi.font.lineHeight;
        }
        else { // creator=UIBuilder
            let charImg = getItemById(files, img);
            if (charImg) {
                mainTexture = sprites[charImg.id];
                bg.width = charImg.width;
                bg.height = charImg.height;
                bg.texture = charImg.id;
                let { x, y } = mainTexture.offset;
                bg.xoffset = x;
                bg.yoffset = y;
            }

            if (bg.advance == 0) {
                if (pi.font.xadvance == 0)
                    bg.advance = bg.x + bg.width;
                else
                    bg.advance = pi.font.xadvance;
            }

            bg.lineHeight = bg.y < 0 ? bg.height : (bg.y + bg.height);
            if (bg.lineHeight < pi.font.size)
                bg.lineHeight = pi.font.size;
        }
        rawData.pos = nextPosition;
    }
    return parseFont(pi.font);
}

function decodeMovieclipData(id, _sprites, files) {
    let rawData = mcRawDataMap[id], pi = {};

    rawData.seek(0, 0);

    let interval = rawData.readInt();
    let swing = rawData.readBool();
    let repeatDelay = rawData.readInt();

    rawData.seek(0, 1);

    var frameCount = rawData.readShort();
    pi.frames = frameCount;

    // var spriteId;
    // var sprite;
    let movieclip = {
        "movieclip": {
            "$": {
                interval,
                swing,
                repeatDelay
            },
            "frames": {
                "frame": []
            }
        }
    };

    for (var i = 0; i < frameCount; i++) {
        var nextPos = rawData.readShort();
        nextPos += rawData.pos;

        let frame = {};
        let x = rawData.readInt();
        let y = rawData.readInt();
        let width = rawData.readInt();//width
        let height = rawData.readInt();//height
        let rect = `${x},${y},${width},${height}`;
        frame.rect = rect;
        let addDelay = rawData.readInt();
        if (addDelay) { frame.addDelay = addDelay };
        movieclip['movieclip']['frames']['frame'].push({ "$": frame });
        // spriteId = rawData.readS();

        // if (spriteId != null && (sprite = _sprites[spriteId]) != null) {
        // var atlas = this.getItemAsset(sprite.atlas);
        // frame.texture = new egret.Texture();
        // frame.texture.bitmapData = atlas.bitmapData;
        // frame.texture.$initData(atlas.$bitmapX + sprite.rect.x, atlas.$bitmapY + sprite.rect.y,
        //     sprite.rect.width, sprite.rect.height,
        //     fx, fy,
        //     item.width, item.height,
        //     atlas.$sourceWidth, atlas.$sourceHeight, sprite.rotated);
        // }
        pi.frames[i] = frame;

        rawData.pos = nextPos;
    }
    return movieclip;
}

function decodeComponent(id) {
    let rawData = componentMap[id];
    decodeComponent2(rawData)
}

function decodeComponent2(rawData) {
    let pi = { "children": [] };
    rawData.seek(0, 0);

    pi._underConstruct = true;

    // size
    pi.sourceWidth = rawData.readInt();
    pi.sourceHeight = rawData.readInt();

    // pi.setSize(pi.sourceWidth, pi.sourceHeight);

    // restrictSize
    if (rawData.readBool()) {
        pi.minWidth = rawData.readInt();
        pi.maxWidth = rawData.readInt();
        pi.minHeight = rawData.readInt();
        pi.maxHeight = rawData.readInt();
    }

    // pivot
    if (rawData.readBool()) {
        f1 = rawData.readFloat();
        f2 = rawData.readFloat();
        // pi.internalSetPivot(f1, f2, rawData.readBool());
    }

    // margin
    if (rawData.readBool()) {
        pi._margin.top = rawData.readInt();
        pi._margin.bottom = rawData.readInt();
        pi._margin.left = rawData.readInt();
        pi._margin.right = rawData.readInt();
    }

    // overflow
    // export enum OverflowType {
    //     Visible,
    //     Hidden,
    //     Scroll
    // }
    var overflow = rawData.readByte();
    if (overflow == 2) { // 2
        var savedPos = rawData.pos;
        rawData.seek(0, 7);
        pi.setupScroll(rawData);
        rawData.pos = savedPos;
    }


    if (rawData.readBool())
        rawData.skip(8);

    pi._buildingDisplayList = true;

    rawData.seek(0, 1);

    //controller
    var controllerCount = rawData.readShort();
    pi.controllers = [];
    for (i = 0; i < controllerCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        // controller.parent = pi;
        // controller.setup(rawData);
        let controller = decodeController(rawData);
        pi.controllers.push(controller);
        rawData.pos = nextPos;
    }

    rawData.seek(0, 2);

    var child;
    var childCount = rawData.readShort();
    for (i = 0; i < childCount; i++) {
        let dataLen = rawData.readShort();
        curPos = rawData.pos;


        rawData.seek(curPos, 0);

        let type = rawData.readByte();
        pi.src = rawData.readS();
        pi.pkgId = rawData.readS();

        // var pi = null;

        // if (src != null) {
        //     var pkg;
        //     if (pkgId != null)
        //         pkg = UIPackage.getById(pkgId);
        //     else
        //         pkg = contentItem.owner;

        //     pi = pkg ? pkg.getItemById(src) : null;
        // }

        // if (pi) {
        //     child = UIObjectFactory.newObject(pi);
        //     child.constructFromResource();
        // }
        // else
        //     child = UIObjectFactory.newObject(type);


        // child._underConstruct = true;
        // child.setup_beforeAdd(rawData, curPos);
        child.content = decodeNewObject(type, rawData, curPos)
        // child.parent = pi;
        pi.children.push(child);

        rawData.pos = curPos + dataLen;
    }

    rawData.seek(0, 3);
    pi.relations.setup(rawData, true);

    rawData.seek(0, 2);
    rawData.skip(2);

    for (i = 0; i < childCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        rawData.seek(rawData.pos, 3);
        pi.children[i].relations.setup(rawData, false);

        rawData.pos = nextPos;
    }

    rawData.seek(0, 2);
    rawData.skip(2);

    for (i = 0; i < childCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        child = pi._children[i];
        child.setup_afterAdd(rawData, rawData.pos);
        child._underConstruct = false;

        rawData.pos = nextPos;
    }

    rawData.seek(0, 4);

    rawData.skip(2); //customData
    pi.opaque = rawData.readBool();
    var maskId = rawData.readShort();
    if (maskId != -1) {
        pi.mask = pi.getChildAt(maskId).displayObject;
        pi.reversedMask = rawData.readBool(); //reversedMask
    }
    var hitTestId = rawData.readS();
    i1 = rawData.readInt();
    i2 = rawData.readInt();
    if (hitTestId != null) {
        pi = contentItem.owner.getItemById(hitTestId);
        if (pi && pi.pixelHitTestData)
            pi._rootContainer.hitArea = new PixelHitTest(pi.pixelHitTestData, i1, i2);
    }
    else if (i1 != 0 && i2 != -1) {
        pi._rootContainer.hitArea = pi.getChildAt(i2).displayObject;
    }

    rawData.seek(0, 5);

    var transitionCount = rawData.readShort();
    for (i = 0; i < transitionCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        var trans = new Transition(pi);
        trans.setup(rawData);
        pi._transitions.push(trans);

        rawData.pos = nextPos;
    }

    if (pi._transitions.length > 0) {
        pi.displayObject.addEventListener(egret.Event.ADDED_TO_STAGE, pi.___added, pi);
        pi.displayObject.addEventListener(egret.Event.REMOVED_FROM_STAGE, pi.___removed, pi);
    }

    pi.applyAllControllers();

    pi._buildingDisplayList = false;
    pi._underConstruct = false;

    pi.buildNativeDisplayList();
    pi.setBoundsChangedFlag();

    if (contentItem.objectType != ObjectType.Component)
        pi.constructExtension(rawData);

    pi.onConstruct();
}

function parseFont(font) {
    let str = '';
    let { lineHeight, glyphs } = font;
    // todo complete font
    if (font.ttf) {
        str += `info creator=UIBuilder\ncommon lineHeight=${lineHeight}\n`;
        for (let key in glyphs) {
            let glyph = glyphs[key];
            let { x, y, width, height, advance, page, bx, by, channel } = glyph;
            str += `char id=${key.charCodeAt()} x=${bx} y=${by} width=${width} height=${height} xoffset=${x} yoffset=${y} xadvance=${advance} page=${page || 0} chnl=${channel}\n`
        }
    } else {
        str += `info creator=UIBuilder\ncommon lineHeight=${lineHeight}\n`;
        for (let key in glyphs) {
            let glyph = glyphs[key];
            let { x, y, texture, advance } = glyph;
            str += `char id=${key.charCodeAt()} img=${texture} xoffset=${x} yoffset=${y} xadvance=${advance}\n`
        }
    }
    return str;
}

function decodeUncompressed(buf) {
    let ba = new ByteArray(buf);
    ba.littleEndian = true;
    let pos = ba.length - 22;
    ba.pos = pos + 10;
    let entryCount = ba.readUshort();
    ba.pos = pos + 16;
    pos = ba.readInt();
    let data = {};
    for (let i = 0; i < entryCount; i++) {
        ba.pos = pos + 28;
        let len = ba.readUshort();
        let len2 = ba.readUshort() + ba.readUshort();

        ba.pos = pos + 46;
        let entryName = ba.readString(len);

        if (entryName[entryName.length - 1] != '/' && entryName[entryName.length - 1] != '\\') //not directory
        {
            ba.pos = pos + 20;
            let size = ba.readInt();
            ba.pos = pos + 42;
            let offset = ba.readInt() + 30 + len;

            if (size > 0) {
                ba.pos = offset;
                data[entryName] = ba.readString(size);
            }
        }

        pos += 46 + len + len2;
    }
    return data;
}

function decodeController(buffer) {
    var controller = {
        "pageIds": [],
        "pageNames": [],
        "selectedIndex": []
    };
    var beginPos = buffer.pos;
    buffer.seek(beginPos, 0);

    controller.name = buffer.readS();
    if (buffer.readBool()) // autoRadioGroupDepth
        controller.autoRadioGroupDepth = true;

    buffer.seek(beginPos, 1);

    var i;
    var nextPos;
    var cnt = buffer.readShort();

    for (i = 0; i < cnt; i++) {
        controller.pageIds.push(buffer.readS());
        controller.pageNames.push(buffer.readS());
    }

    var homePageIndex = 0;
    if (buffer.version >= 2) {
        var homePageType = buffer.readByte();
        switch (homePageType) {
            case 1: // "specific"
                homePageIndex = buffer.readShort();
                break;

            case 2: // "branch"
                homePageIndex = controller.pageNames.indexOf(UIPackage.branch);
                if (homePageIndex == -1)
                    homePageIndex = 0;
                break;

            case 3: // "variable"
                // todo
                homePageIndex = controller.pageNames.indexOf(UIPackage.getVar(buffer.readS()));
                if (homePageIndex == -1)
                    homePageIndex = 0;
                break;
        }
    }

    buffer.seek(beginPos, 2);

    cnt = buffer.readShort();
    if (cnt > 0) {
        if (!controller.actions)
            controller.actions = [];

        for (i = 0; i < cnt; i++) {
            nextPos = buffer.readShort();
            nextPos += buffer.pos;
            let type = buffer.readByte();
            let action = {};
            let count = buffer.readShort();
            action.fromPage = [];
            for (i = 0; i < count; i++)
                action.fromPage[i] = buffer.readS();

            count = buffer.readShort();
            action.toPage = [];
            for (i = 0; i < count; i++)
                action.toPage[i] = buffer.readS();
            if (type == 0) { // PlayTransitionAction
                action.transitionName = buffer.readS();
                action.playTimes = buffer.readInt();
                action.delay = buffer.readFloat();
                action.stopOnExit = buffer.readBool();
            } else if (type == 1) { // ChangePageAction
                action.objectId = buffer.readS();
                action.controllerName = buffer.readS();
                action.targetPage = buffer.readS();
            }
            controller.actions.push(action);

            buffer.pos = nextPos;
        }
    }

    if (controller.pageIds.length > 0)
        controller.selectedIndex = homePageIndex;
    else
        controller.selectedIndex = -1;
    return controller;
}

function decodeNewObject(type, buffer, position) {
    if (typeof type === 'number') {
        switch (type) {
            case 0: // Image
                return new GImage();

            case 1: // MovieClip
                return new GMovieClip();

            case 2: // Component
                let component = decodeComponent2(buffer);
                return component;

            case 3: // Text
                return new GTextField();

            case 4: // RichText
                return new GRichTextField();

            case ObjectType.InputText:
                return new GTextInput();

            case ObjectType.Group:
                return new GGroup();

            case ObjectType.List:
                return new GList();

            case ObjectType.Graph:
                return new GGraph();

            case ObjectType.Loader:
                if (UIObjectFactory.loaderType)
                    return new UIObjectFactory.loaderType();
                else
                    return new GLoader();

            case ObjectType.Button:
                return new GButton();

            case ObjectType.Label:
                return new GLabel();

            case ObjectType.ProgressBar:
                return new GProgressBar();

            case ObjectType.Slider:
                return new GSlider();

            case ObjectType.ScrollBar:
                return new GScrollBar();

            case ObjectType.ComboBox:
                return new GComboBox();

            case ObjectType.Tree:
                return new GTree();

            case ObjectType.Loader3D:
                return new GLoader3D();

            default:
                return null;
        }
    }
}

function decodeGObject(buffer, position) {
    let data = {};
    buffer.seek(beginPos, 0);
    buffer.skip(5);

    var f1;
    var f2;

    data._id = buffer.readS();
    data._name = buffer.readS();
    f1 = buffer.readInt();
    f2 = buffer.readInt();
    data.setXY(f1, f2);

    if (buffer.readBool()) {
        data.initWidth = buffer.readInt();
        data.initHeight = buffer.readInt();
        data.setSize(data.initWidth, data.initHeight, true);
    }

    if (buffer.readBool()) {
        data.minWidth = buffer.readInt();
        data.maxWidth = buffer.readInt();
        data.minHeight = buffer.readInt();
        data.maxHeight = buffer.readInt();
    }

    if (buffer.readBool()) {
        f1 = buffer.readFloat();
        f2 = buffer.readFloat();
    }

    if (buffer.readBool()) {
        f1 = buffer.readFloat();
        f2 = buffer.readFloat();
    }

    if (buffer.readBool()) {
        f1 = buffer.readFloat();
        f2 = buffer.readFloat();
    }

    f1 = buffer.readFloat();
    if (f1 != 1)
        data.alpha = f1;

    f1 = buffer.readFloat();
    if (f1 != 0)
        data.rotation = f1;

    if (!buffer.readBool())
        data.visible = false;
    if (!buffer.readBool())
        data.touchable = false;
    if (buffer.readBool())
        data.grayed = true;
    var bm = buffer.readByte();
    if (bm == 2)
        data.blendMode = egret.BlendMode.ADD;
    else if (bm == 5)
        data.blendMode = egret.BlendMode.ERASE;

    var filter = buffer.readByte();
    if (filter == 1 && data._displayObject)
        ToolSet.setColorFilter(data._displayObject,
            [buffer.readFloat(), buffer.readFloat(), buffer.readFloat(), buffer.readFloat()]);

    var str = buffer.readS();
    if (str != null)
        data.data = str;
}

function decodeBinary(buffer) {
    let ver2 = buffer.version >= 2;
    let indexTablePos = buffer.pos;
    let _items = [];
    let _pixelHitTestDatas = [];
    let _itemMap = {};
    let _sprites = {};
    let cnt;
    let i;
    let nextPos;
    let str;
    let branchIncluded;

    buffer.seek(indexTablePos, 4);

    cnt = buffer.readInt();
    let stringTable = [];
    for (i = 0; i < cnt; i++)
        stringTable[i] = buffer.readString();
    buffer.stringTable = stringTable;

    buffer.seek(indexTablePos, 0);
    cnt = buffer.readShort();
    let _dependencies = [];
    for (i = 0; i < cnt; i++)
        _dependencies.push({ id: buffer.readS(), name: buffer.readS() });

    if (ver2) {
        cnt = buffer.readShort();
        if (cnt > 0) {
            let _branches = buffer.readSArray(cnt);
            if (_branch) {
                let _branchIndex = _branches.indexOf(_branch);
                console.log(_branchIndex);
            }
        }

        branchIncluded = cnt > 0;
    }

    buffer.seek(indexTablePos, 1);


    let fileNamePrefix = pkgName + "_";

    cnt = buffer.readUshort();
    for (i = 0; i < cnt; i++) { // package.xml
        let pi = {};
        nextPos = buffer.readInt();
        nextPos += buffer.pos;
        pi.type = buffer.readByte();
        pi.id = buffer.readS();
        pi.name = buffer.readS();
        pi.path = buffer.readS(); //path
        str = buffer.readS();
        if (str)
            pi.file = str;
        pi.exported = buffer.readBool();//exported
        pi.width = buffer.readInt();
        pi.height = buffer.readInt();

        switch (pi.type) {
            case 0:// Image:
                {
                    pi.objectType = 0;// Image;
                    let scaleOption = buffer.readByte();
                    if (scaleOption == 1) {
                        pi.scale9Grid = {};
                        pi.scale9Grid.x = buffer.readInt();
                        pi.scale9Grid.y = buffer.readInt();
                        pi.scale9Grid.width = buffer.readInt();
                        pi.scale9Grid.height = buffer.readInt();

                        pi.tileGridIndice = buffer.readInt();
                    }
                    else if (scaleOption == 2)
                        pi.scaleByTile = true;
                    pi.scaleOption = scaleOption;
                    pi.smoothing = buffer.readBool();
                    break;
                }

            case 1:// MovieClip:
                {
                    pi.smoothing = buffer.readBool();
                    pi.objectType = 1; // MovieClip;
                    mcRawDataMap[pi.id] = buffer.readBuffer();
                    break;
                }

            case 5: // Font:
                {
                    fontRawDataMap[pi.id] = buffer.readBuffer();
                    // pi.rawData = buffer.readBuffer();
                    break;
                }

            case 3: // Component:
                {
                    let extension = buffer.readByte();
                    if (extension > 0)
                        pi.objectType = extension;
                    else
                        pi.objectType = 9; // Component;
                    // pi.rawData = buffer.readBuffer();
                    componentMap[pi.id] = buffer.readBuffer();
                    // Decls.UIObjectFactory.resolveExtension(pi);
                    break;
                }

            case 4: // Atlas:
                {
                    break;
                }
            case 2: // Sound:
            case 7: // Misc:
                {
                    pi.file = fileNamePrefix + pi.file;
                    break;
                }
        }

        if (ver2) {
            str = buffer.readS();//branch
            if (str)
                pi.name = str + "/" + pi.name;

            let branchCnt = buffer.readByte();
            if (branchCnt > 0) {
                if (branchIncluded)
                    pi.branches = buffer.readSArray(branchCnt);
                else
                    _itemMap[buffer.readS()] = pi;
            }

            let highResCnt = buffer.readByte();
            if (highResCnt > 0)
                pi.highResolution = buffer.readSArray(highResCnt);
        }

        _items.push(pi);
        _itemMap[pi.id] = pi;
        if (pi.name != null)
            _itemMap[pi.name] = pi;

        buffer.pos = nextPos;

    }

    buffer.seek(indexTablePos, 2);

    cnt = buffer.readUshort();
    for (i = 0; i < cnt; i++) {
        nextPos = buffer.readUshort();
        nextPos += buffer.pos;

        let itemId = buffer.readS();
        pi = _itemMap[buffer.readS()];

        let rect = {};
        rect.x = buffer.readInt();
        rect.y = buffer.readInt();
        rect.width = buffer.readInt();
        rect.height = buffer.readInt();
        let sprite = { atlas: pi['id'], rect: rect, offset: {}, originalSize: {} };
        sprite.rotated = buffer.readBool();
        if (ver2 && buffer.readBool()) {
            sprite.offset.x = buffer.readInt();
            sprite.offset.y = buffer.readInt();
            sprite.originalSize.x = buffer.readInt();
            sprite.originalSize.y = buffer.readInt();
        }
        else {
            sprite.originalSize.x = sprite.rect.width;
            sprite.originalSize.y = sprite.rect.height;
        }
        _sprites[itemId] = sprite;
        // handle sprites

        buffer.pos = nextPos;
    }

    if (buffer.seek(indexTablePos, 3)) {
        cnt = buffer.readUshort();
        for (i = 0; i < cnt; i++) {
            nextPos = buffer.readInt();
            nextPos += buffer.pos;

            let pi = _itemMap[buffer.readS()];
            if (pi && pi.type == PackageItemType.Image) {
                let pixelHitTestData = {};
                buffer.readInt();
                pixelHitTestData.pixelWidth = buffer.readInt();
                pixelHitTestData.scale = 1.0 / buffer.readByte();
                let len = buffer.readInt();
                pixelHitTestData.pixels = new Uint8Array(buffer.data, buffer.pos, len);
                buffer.skip(len);
                _pixelHitTestDatas.push(pixelHitTestData);
            }

            buffer.pos = nextPos;
        }
    }
    // console.log(_items); // package.xml
    // console.log(_itemMap);
    // console.log(_sprites); // sprites.bytes
    // console.log(_pixelHitTestDatas);
    return { "package.xml": _items, "sprites.bytes": _sprites, "files": _itemMap };
}

const parseXML = (source) => {
    let curr = 0;
    let fn;
    let size;
    let resData = {};
    while (true) {
        let pos = source.indexOf("|", curr);
        if (pos == -1)
            break;
        fn = source.substring(curr, pos);
        curr = pos + 1;
        pos = source.indexOf("|", curr);
        size = parseInt(source.substring(curr, pos));
        curr = pos + 1;
        resData[fn] = source.substr(curr, size);
        curr += size;
    }
    return resData;
}

const parseSprites = (resDic) => {
    let sep1 = "\n", sep2 = " ";
    let res = resDic.split(sep1), sprites = {};
    for (let len = res.length, i = 1; len > i; i++) {
        if (r = res[i]) {
            let l = r.split(sep2)
                , u = { "rect": {} }
                , c = l[0]
                , _ = parseInt(l[1]);
            if (_ >= 0)
                u.atlas = "atlas" + _;
            else {
                let p = c.indexOf("_");
                -1 == p ? u.atlas = "atlas_" + c : u.atlas = "atlas_" + c.substr(0, p)
            }
            u.rect.x = parseInt(l[2]),
                u.rect.y = parseInt(l[3]),
                u.rect.width = parseInt(l[4]),
                u.rect.height = parseInt(l[5]),
                u.rotated = "1" == l[6],
                sprites[c] = u;
        }
    }
    return sprites;
}


/**
 * 
 * @param {*} spritesMap 
 * @param {*} flag  need file ext
 */
const handleSprites = async (spritesMap, flag = true) => {
    console.log("start crop image");
    for (key in spritesMap) {
        let item = spritesMap[key];
        let { name, path, atlas, rect, rotated } = item;
        if (!name) { // atlas temp
            name = key;
            path = temp
        }
        let output = path ? `${outputPath}${importFileName}${path}${name}` : `${outputPath}${importFileName}/${name}`;
        output = flag ? `${output}.png` : output;

        await new Promise((resolve, reject) => {
            Jimp.read(`${inputPath}${pkgName}@${atlas}.png`)
                .then(image => {
                    // Do stuff with the image.
                    let { x, y, width, height } = rect;
                    width = rotated ? rect.height : width;
                    height = rotated ? rect.width : height;
                    let bitmap = image.crop(x, y, width, height);
                    if (rotated) {
                        bitmap.rotate(90);
                    }
                    bitmap.write(output);
                    resolve();
                })
                .catch(err => {
                    // Handle an exception.
                    console.log(err);
                    reject(err)
                });
        })
    }
    console.log("finish crop image");
}

const handleSound = async (soundInfo, flag = true) => {
    console.log("start handleSound");
    soundInfo.forEach((item) => {
        let sound = item['$'];
        let { file, path, name } = sound;
        let extName = file.split('.').pop();
        let output = path ? `${outputPath}${importFileName}${path}` : `${outputPath}${importFileName}/`;
        file = flag ? `${inputPath}${pkgName}@${file}` : `${inputPath}${file}`;
        if (exists(file)) {
            if (!exists(output)) {
                fs.mkdirSync(resolve(output));
            }
            output = `${output}${name}.${extName}`;
            fs.copyFileSync(file, output);
        } else {
            console.warn(`FILE: ${file} NOT FOUND!`);
        }
    })
    console.log("finish handleSound");
}

const handleAltas = (atlasInfo) => {
    // todo check atlas size
    if (!atlasInfo.every((item) => {
        let file = item['$']['file'];
        let name = `${inputPath}${pkgName}@${file}`;
        if (exists(name)) {
            return true;
        } else {
            console.warn(`FILE: ${name} NOT FOUND!`);
            return false;
        }
    })) {
        throw "Atlas NOT FOUND!";
    }
}

const createFileByData = (data, ext) => {
    console.log("start createFileByData");
    for (let key in data) {
        let item = data[key];
        let { path, content, name } = item;
        let output = path ? `${outputPath}${importFileName}${path}` : `${outputPath}${importFileName}/`;
        if (!exists(output)) {
            fs.mkdirSync(resolve(output));
        }
        output = `${output}${name}${ext}`;
        if (ext == ".xml") {
            content = XMLHeader + content;
        }
        fs.writeFileSync(output, content)
    }
    console.log("finish createFileByData");
}

const handleMovieclip = async (movieclipInfo) => {
    console.log("start handleMovieclip");
    for (let key in movieclipInfo) {
        let movieclip = movieclipInfo[key];
        let { path, name } = movieclip;
        let output = path ? `${outputPath}${importFileName}${path}${name}.jta` : `${outputPath}${importFileName}/${name}.jta`;

        await createMovieClip(movieclip, tempPath, output);
    }
    console.log("finish handleMovieclip");
}

const handlePackageData = async (data) => {
    let xml = await xml2json(data);
    let packageDescription = xml['packageDescription'];
    let { id, name } = packageDescription['$'];
    delete packageDescription['$']; // reset
    delete packageDescription['resources']['atlas'];
    packageDescription['$'] = { id };
    packageDescription['publish'] = { "$": { name } };
    packageDescription['publish']['atlas'] = { "$": { name: "Default", index: 0 } };

    let resources = packageDescription['resources'];
    let components = resources['component'];
    let images = resources['image'];
    let movieclips = resources['movieclip'];
    let fonts = resources['font'];
    let sounds = resources['sound'];
    if (components) {
        components.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.xml';
            delete item['$']['size'];
        })
    }
    if (images) {
        images.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.png';
            delete item['$']['size'];
        })
    }
    if (movieclips) {
        movieclips.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.jta';
            delete item['$']['size'];
        })
    }
    if (fonts) {
        fonts.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.fnt';
            delete item['$']['size'];
        })
    }
    if (sounds) {
        sounds.forEach((item) => {
            // todo check file ext
            item['$']['name'] = item['$']['name'] + '.' + item['$']['file'].split(".").pop();
            delete item['$']['size'];
            delete item['$']['file'];
        })
    }
    return json2xml(xml);
}

const handlePackageData2 = (pkgData) => {
    let data = pkgData['package.xml'];
    let sprites = pkgData['sprites.bytes'];
    let pkgXmlData = {
        'packageDescription': {
            "$": {
                id: pkgId
            },
            "resources": {
                "component": [],
                "image": [],
                "movieclip": [],
                "font": [],
                "sound": [],
                "atlas": []
            },
            "publish": {
                "$": { pkgName },
                "atlas": {
                    "$": { name: "Default", index: 0 }
                }
            }
        }
    }
    let components = pkgXmlData['packageDescription']['resources']['component'];
    let images = pkgXmlData['packageDescription']['resources']['image'];
    let movieclips = pkgXmlData['packageDescription']['resources']['movieclip'];
    let fonts = pkgXmlData['packageDescription']['resources']['font'];
    let sounds = pkgXmlData['packageDescription']['resources']['sound'];
    let atlas = pkgXmlData['packageDescription']['resources']['atlas'];

    data.forEach((element) => {
        let { type, id, name, path, size, exported, file, smoothing, width, height } = element;
        let item = {
            "$": {

            }
        };
        Object.assign(item['$'], { id, name, path, size, file, exported, smoothing });
        if (!item['$']['exported']) {
            delete item['$']['exported'];
        }
        if (item['$']['smoothing']) {
            delete item['$']['smoothing'];
        }
        switch (type) {
            case 0:
                if (element['scaleOption'] == 1) { // 9grid
                    item['$']['scale'] = '9grid';
                    let { x, y, width, height } = element['scale9Grid'];
                    item['$']['scale9Grid'] = `${x},${y},${width},${height}`;
                } else if (element['scaleOption'] == 2) { // tile
                    item['$']['scale'] = 'tile';
                }
                item['$']['name'] = item['$']['name'] + '.png';
                images.push(item);
                break;
            case 1:
                item['$']['name'] = item['$']['name'] + '.jta';
                item['$']['size'] = `${width},${height}`
                movieclips.push(item);
                break;
            case 2:
                item['$']['name'] = item['$']['name'] + '.' + item['$']['file'].split(".").pop();
                sounds.push(item);
                break;
            case 3:
                item['$']['name'] = item['$']['name'] + '.xml';
                components.push(item);
                break;
            case 4:
                atlas.push(item);
                break;
            case 5:
                item['$']['name'] = item['$']['name'] + '.fnt';
                for (let key in sprites) {
                    let sprite = sprites[key];
                    if (sprites[id] && JSON.stringify(sprite['rect']) === JSON.stringify(sprites[id]['rect']) && key != id) {
                        item['$']['texture'] = key;
                        item['$']['fontTexture'] = key;
                    }
                }

                fonts.push(item);
                break;
            default:
                break;
        }
    })
    pkgData['package.xml'] = pkgXmlData;

    return json2xml(pkgXmlData);
}



const handlePackageFile = async (data) => {
    let packageXml = XMLHeader + data['package.xml'];
    packageXml = await handlePackageData(packageXml);

    let output = `${outputPath}${importFileName}`;
    if (!exists(output)) {
        fs.mkdirSync(resolve(output));
    }
    fs.writeFileSync(`${output}/package.xml`, packageXml);
}

const handlePackageFile2 = async (data) => {
    let packageXml = handlePackageData2(data);
    let output = `${outputPath}${importFileName}`;
    if (!exists(output)) {
        fs.mkdirSync(resolve(output));
    }
    fs.writeFileSync(`${output}/package.xml`, packageXml);
}

/**
 *  check package format
 *  decodeUncompressed only for [Laya/Egret/CocosCreateor] version 
 */
const parseBuffer = async (buf) => {
    let data;
    let mark = new Uint8Array(buf.buffer.slice(0, 2));
    if (mark[0] == 0x50 && mark[1] == 0x4b) { // compressed
        data = decodeUncompressed(buf.buffer);
    } else { // Uncompressed
        let xml = zlib.inflateRawSync(buf).toString();
        data = parseXML(xml);
    }
    return data;
}

const parseBuffer2 = async (ba) => {
    let data;
    ba.version = ba.readInt();
    let compressed = ba.readBool();
    if (compressed) { // compressed
        // let buf = new Uint8Array(ba.buffer, ba.position, ba.length - ba.position);
        // let inflater = new Zlib.inflateRawSync(buf);
        // let buffer2 = new ByteBuffer(inflater.decompress());
        // buffer2.version = buffer.version;
        // buffer = buffer2;
    } else { // Uncompressed
        pkgId = ba.readString();
        pkgName = ba.readString();
        ba.skip(20);
        data = decodeBinary(ba);
        // data = parseXML2(); // obj -> xml
    }
    return data;
}

async function start() {
    console.time('start');
    let buf = fs.readFileSync(`${inputPath}${importFileName}.bin`); // Buffer 
    let ba = new ByteArray(buf.buffer), pkgData;
    if (ba.readUint() == 0x46475549) { // binary 
        pkgData = await parseBuffer2(ba);
        await handlePackageFile2(pkgData);
        await createByPackage2(pkgData);
    } else { // xml
        pkgData = await parseBuffer(buf);
        await handlePackageFile(pkgData); // create package.xml
        await createByPackage(pkgData);
    }
    console.timeEnd('start');
}

start();











