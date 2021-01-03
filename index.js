const fs = require('fs');
const zlib = require("zlib");
const Jimp = require('jimp');
const ByteArray = require('./ByteArray');
const { resolve } = require('path');
const { exists, xml2json, json2xml, getItemById, rgbaToHex } = require('./utils/utils');
const { createMovieClip } = require('./build/create');


const XMLHeader = '<?xml version="1.0" encoding="utf-8"?>\n';

let importFileName = "Basics",
    inputPath = "./test/",
    outputPath = './output/',
    temp = '/temp/',
    tempPath = `${outputPath}${importFileName}${temp}`,
    pkgName = "",
    pkgId = "",
    UIPackage = {};

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
        componentMap[id] = component;
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
    let rawData = UIPackage[id].rawData, pi = {};
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
    let rawData = UIPackage[id].rawData, pi = {};

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
        // var atlas = data.getItemAsset(sprite.atlas);
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

function decodeComponent(id, files) {
    let contentItem = UIPackage[id];
    decodeComponent2(contentItem, files)
}

function decodeComponent2(contentItem, files) {

    let { rawData, objectType } = contentItem;
    let pi = { "children": [], objectType };
    rawData.seek(0, 0);

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
        pi.pivotX = rawData.readFloat();
        pi.pivotY = rawData.readFloat();
    }

    // margin
    if (rawData.readBool()) {
        pi.margin = {};
        pi.margin.top = rawData.readInt();
        pi.margin.bottom = rawData.readInt();
        pi.margin.left = rawData.readInt();
        pi.margin.right = rawData.readInt();
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

    rawData.seek(0, 1);

    //controller
    var controllerCount = rawData.readShort();
    pi.controllers = [];
    for (i = 0; i < controllerCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        // controller.parent = pi;
        // controller.setup(rawData);
        let controller = decodeController(rawData); // controller.setup
        pi.controllers.push(controller);
        rawData.pos = nextPos;
    }

    rawData.seek(0, 2);



    var childCount = rawData.readShort();
    for (i = 0; i < childCount; i++) {
        var child = {};
        let dataLen = rawData.readShort();
        curPos = rawData.pos;


        rawData.seek(curPos, 0);

        let type = rawData.readByte();
        child.type = type;
        let src = rawData.readS();
        let pkgId = rawData.readS();

        var packageItem = null;

        if (src != null) {
            var pkg;
            if (pkgId != null)
                pkg = files[pkgId];
            else
                pkg = UIPackage[src];

            packageItem = pkg ? pkg : null;
        }

        if (packageItem) {
            packageItem.position = curPos;
            packageItem.rawData = rawData;
            child.beforeContent = decodeNewObjectByPi(packageItem);
            child.objectType = packageItem.objectType
            // child = constructFromResource(); // GComponent | GImage | GMovieClip
        }
        else {
            child.beforeContent = decodeNewObjectBefore(type, rawData, curPos);
            // child = UIObjectFactory.newObject(type);
        }


        // child.underConstruct = true;
        // child.setup_beforeAdd(type,rawData, curPos);
        // child = decodeNewObject(type, rawData, curPos) // setup_beforeAdd
        // child.parent = pi;
        pi.children.push(child);

        rawData.pos = curPos + dataLen;
    }

    rawData.seek(0, 3);
    pi.relations = relationSetup(rawData, true); //relations.setup

    rawData.seek(0, 2);
    rawData.skip(2);

    for (i = 0; i < childCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        rawData.seek(rawData.pos, 3);
        pi.children[i].relations = relationSetup(rawData, false); //relations.setup

        rawData.pos = nextPos;
    }

    rawData.seek(0, 2);
    rawData.skip(2);

    for (i = 0; i < childCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        child = pi.children[i];
        // setup_afterAdd
        // child.setup_afterAdd(rawData, rawData.pos);
        let { type, objectType } = child;
        type = objectType ? objectType : type;
        child.afterContent = decodeNewObjectAfter(type, rawData, rawData.pos);

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
    pi.hitTestId = rawData.readS();
    i1 = rawData.readInt();
    i2 = rawData.readInt();
    if (pi.hitTestId != null) {
        pi = contentItem.owner.getItemById(hitTestId);
        if (pi && pi.pixelHitTestData)
            pi.rootContainer.hitArea = new PixelHitTest(pi.pixelHitTestData, i1, i2);
    } else if (i1 != 0 && i2 != -1) {
        pi.rootContainer.hitArea = pi.getChildAt(i2).displayObject;
    }

    rawData.seek(0, 5);

    var transitionCount = rawData.readShort();
    for (i = 0; i < transitionCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        var trans = new Transition(pi);
        trans.setup(rawData);
        pi.transitions.push(trans);

        rawData.pos = nextPos;
    }

    if (pi.objectType != 9)
        pi.extensionData = constructExtension(pi.objectType, rawData);
    // pi.constructExtension(rawData);
}

function decodeGGraphBefore(rawData, position) {
    let data = {};
    rawData.seek(position, 5);

    let type = rawData.readByte();
    data.type = type;
    if (type != 0) {
        let i;
        let cnt;

        let lineSize = rawData.readInt();
        let lineColor = rgbaToHex(rawData.readFullColor());
        let fillColor = rgbaToHex(rawData.readFullColor());
        let roundedRect = rawData.readBool();
        let cornerRadius;
        if (roundedRect) {
            cornerRadius = [];
            for (i = 0; i < 4; i++)
                cornerRadius[i] = rawData.readFloat();
        }

        if (type == 1) {
            if (roundedRect)
                data.shape = { lineSize, lineColor, fillColor, cornerRadius };
            else
                data.shape = { lineSize, lineColor, fillColor };
        }
        else if (type == 2) {
            data.shape = { lineSize, fillColor, lineColor, fillColor };
        }
        else if (type == 3) {
            cnt = rawData.readShort();
            let points = [];
            points.length = cnt;
            for (i = 0; i < cnt; i++)
                points[i] = rawData.readFloat();

            data.shape = { points, fillColor, lineSize, lineColor };
        }
        else if (type == 4) {
            let sides = rawData.readShort();
            let startAngle = rawData.readFloat();
            cnt = rawData.readShort();
            let distances;
            if (cnt > 0) {
                distances = [];
                for (i = 0; i < cnt; i++)
                    distances[i] = rawData.readFloat();
            }

            data.shape = { sides, lineSize, fillColor, lineColor, fillColor, startAngle, distances };
        }
    }
    return data;
}

function decodeTextFieldBefore(rawData, position) {
    let data = { "textField": { "textFormat": {} } };
    rawData.seek(position, 5);

    let tf = data.textField.textFormat;

    tf.font = rawData.readS();
    tf.size = rawData.readShort();
    tf.color = rgbaToHex(rawData.readColor(), false);
    let c = rawData.readByte();
    data.align = c == 0 ? "left" : (c == 1 ? "center" : "right");
    c = rawData.readByte();
    data.verticalAlign = c == 0 ? "top" : (c == 1 ? "middle" : "bottom");
    tf.lineSpacing = rawData.readShort();
    tf.letterSpacing = rawData.readShort();
    data.ubbEnabled = rawData.readBool();
    data.autoSize = rawData.readByte();
    tf.underline = rawData.readBool();
    tf.italic = rawData.readBool();
    tf.bold = rawData.readBool();
    data.singleLine = rawData.readBool();
    if (rawData.readBool()) {
        tf.outlineColor = rgbaToHex(rawData.readColor(), false);
        tf.outline = rawData.readFloat() + 1;
    }

    if (rawData.readBool()) //shadow
    {
        tf.shadowColor = rawData.readColor();
        let f1 = rawData.readFloat();
        let f2 = rawData.readFloat();
        tf.shadowOffsetX = f1;
        tf.shadowOffsetY = f2;
    }

    if (rawData.readBool())
        data.template = {};

    if (rawData.version >= 3)
        tf.strikethrough = rawData.readBool();

    return data;
}

function decodeTextFieldAfter(rawData, position) {
    let data = {};
    rawData.seek(position, 6);

    var str = rawData.readS();
    if (str != null)
        data.text = str;
    return data;
}

function decodeComponetAfter(rawData, position) {
    let data = {};
    rawData.seek(position, 4);

    var pageController = rawData.readShort();
    if (pageController != -1 && this.scrollPane)
        this.scrollPane.pageController = this.parent.getControllerAt(pageController);

    var cnt;
    var i;

    cnt = rawData.readShort();
    for (i = 0; i < cnt; i++) {
        var cc = this.getController(rawData.readS());
        var pageId = rawData.readS();
        if (cc)
            cc.selectedPageId = pageId;
    }

    if (rawData.version >= 2) {
        cnt = rawData.readShort();
        for (i = 0; i < cnt; i++) {
            var target = rawData.readS();
            var propertyId = rawData.readShort();
            var value = rawData.readS();
            var obj = this.getChildByPath(target);
            if (obj)
                obj.setProp(propertyId, value);
        }
    }
    return data;
}

function relationSetup(buffer, parentToChild) {
    let data = { "items": [] };
    var cnt = buffer.readByte();
    var target;
    for (var i = 0; i < cnt; i++) {
        var targetIndex = buffer.readShort();
        if (targetIndex == -1)
            target = "";
        else if (parentToChild)
            target = this.owner.getChildAt(targetIndex);
        else
            target = this.owner.parent.getChildAt(targetIndex);

        var newItem = { "relations": [] };
        newItem.target = target;
        data.items.push(newItem);

        var cnt2 = buffer.readByte();
        for (var j = 0; j < cnt2; j++) {
            /**
             *  Left_Left = 0,
                Left_Center = 1,
                Left_Right = 2,
                Center_Center = 3,
                Right_Left = 4,
                Right_Center = 5,
                Right_Right = 6,

                Top_Top = 7,
                Top_Middle = 8,
                Top_Bottom = 9,
                Middle_Middle = 10,
                Bottom_Top = 11,
                Bottom_Middle = 12,
                Bottom_Bottom = 13,

                Width = 14,
                Height = 15,

                LeftExt_Left = 16,
                LeftExt_Right = 17,
                RightExt_Left = 18,
                RightExt_Right = 19,
                TopExt_Top = 20,
                TopExt_Bottom = 21,
                BottomExt_Top = 22,
                BottomExt_Bottom = 23,

                Size = 24
             */
            var rt = buffer.readByte();
            var usePercent = buffer.readBool();
            let relation = { rt, usePercent };
            newItem.relations.push(relation);
        }
    }
    return data;
}

function gearSetup(buffer) {
    let data = { "pages": [] };
    data.controllerId = buffer.readShort(); //  controller id
    var i;
    var page;
    var cnt = buffer.readShort();
    data.pages = buffer.readSArray(cnt);
    // todo
    // controller in this parent 
    // if ("pages" in this) { 
    //     data.pages = buffer.readSArray(cnt);
    // } else {
    //     for (i = 0; i < cnt; i++) {
    //         page = buffer.readS();
    //         if (page == null)
    //             continue;

    //         data.addStatus(page, buffer);
    //     }

    //     if (buffer.readBool())
    //         data.addStatus(null, buffer);
    // }

    if (buffer.readBool()) {
        data.tweenConfig = {};
        data.tweenConfig.easeType = buffer.readByte();
        data.tweenConfig.duration = buffer.readFloat();
        data.tweenConfig.delay = buffer.readFloat();
    }

    if (buffer.version >= 2) {
        // todo positionsInPercent && condition
        // if ("positionsInPercent" in this) {
        //     if (buffer.readBool()) {
        //         (<any>this).positionsInPercent = true;
        //         for (i = 0; i < cnt; i++) {
        //             page = buffer.readS();
        //             if (page == null)
        //                 continue;

        //             (<any>this).addExtStatus(page, buffer);
        //         }

        //         if (buffer.readBool())
        //             (<any>this).addExtStatus(null, buffer);
        //     }
        // }
        // else if ("condition" in this)
        //     (<any>this).condition = buffer.readByte();
    }
    return data;
}

function setup_afterAdd(type, buffer, position) {
    let content = {};
    let data = decodeGObjectAfter(buffer, position)
    switch (type) {
        case 0: // Image
            return new GImage();

        case 1: // MovieClip
            return new GMovieClip();

        case 3: // GGraph
            return content;

        case 4: // Loader
            return content;

        case 5: // Group:
            return content;

        case 6: // Text
            content = decodeTextFieldAfter(buffer, position);
            return content;

        case 7: // RichText
            return new GList();

        case 8: // InputText
            return new GGraph();

        case 9: // Gcomponet
            data.content = decodeComponetAfter(buffer, position);
            return data;
        case 10: // List
            return new GButton();

        case 11: // Label
            return new GLabel();

        case 12: // Button
            return new GProgressBar();

        case 13: // ComboBox
            return new GSlider();

        case 14: // ProgressBar
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeProgressBarAfter(buffer, position);
            return data;

        case ObjectType.ComboBox:
            return new GComboBox();

        case ObjectType.Tree:
            return new GTree();

        case ObjectType.Loader3D:
            return new GLoader3D();

        default:
            return content;
    }
}

function setup_beforeAdd(type, buffer, position) {
    let content = {};
    switch (type) {
        case 0: // Image
            break;

        case 1: // MovieClip
            break;

        case 3: // GGraph
            content = decodeGGraphBefore(buffer, position);
            break;

        case 4: // Loader
            break;

        case 5: // Group:
            break;

        case 6: // Text
            content = decodeTextFieldBefore(buffer, position);
            break;

        case 7: // RichText
            break;

        case 8: // InputText
            break;

        case 9: // Gcomponet
            // data.content = decodeComponent2(buffer,);
            // let dataLen = buffer.readShort();
            // curPos = buffer.pos;


            // buffer.seek(curPos, 0);

            // let type = buffer.readByte();
            // pi.src = buffer.readS();
            // pi.pkgId = buffer.readS();
            break;
        default:
            break;
    }
    return content;
}

function decodeProgressBarAfter(rawData, position) {
    let data = {};
    if (!rawData.seek(position, 6)) {
        // this.update(this.value);
        return;
    }

    if (rawData.readByte() != 14) {
        // this.update(this.value);
        return;
    }

    data.value = rawData.readInt();
    data.max = rawData.readInt();
    if (rawData.version >= 2)
        data.min = rawData.readInt();

    return data;
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

function decodeNewObjectByPi(pi) {
    let { rawData, objectType, position } = pi;
    return decodeNewObjectBefore(objectType, rawData, position);
}

function decodeNewObjectBefore(type, buffer, position) {
    let data = {};
    data = decodeGObjectBefore(buffer, position);
    data.type = type;
    data.content = setup_beforeAdd(type, buffer, position);
    console.log(data);
    return data;
}

function decodeNewObjectAfter(type, buffer, position) {
    let data = {};
    data = decodeGObjectAfter(buffer, position);
    data.type = type;
    data.content = setup_afterAdd(type, buffer, position);
    console.log(data);
    return data;
}

function decodeGObjectAfter(rawData, position) {
    let data = {};
    rawData.seek(position, 1);

    var str = rawData.readS();
    if (str)
        data.tooltips = str;

    var groupId = rawData.readShort();
    if (groupId >= 0)
        data.group = groupId;

    rawData.seek(position, 2);

    var cnt = rawData.readShort();
    for (var i = 0; i < cnt; i++) {
        var nextPos = rawData.readShort();
        nextPos += rawData.pos;

        data.gearIdx = rawData.readByte();
        // console.log(data.gearIdx)
        // gear.setup(rawData);
        data.gear = gearSetup(rawData);
        rawData.pos = nextPos;
    }
    return data;
}

function decodeGObjectBefore(rawData, position) {
    let data = {};
    rawData.seek(position, 0);
    rawData.skip(5);

    var f1;
    data.id = rawData.readS();
    data.name = rawData.readS();
    // position 
    data.x = rawData.readInt();
    data.y = rawData.readInt();

    // size
    if (rawData.readBool()) {
        data.initWidth = rawData.readInt();
        data.initHeight = rawData.readInt();
    }

    if (rawData.readBool()) {
        data.minWidth = rawData.readInt();
        data.maxWidth = rawData.readInt();
        data.minHeight = rawData.readInt();
        data.maxHeight = rawData.readInt();
    }

    // scale
    if (rawData.readBool()) {
        data.scaleX = rawData.readFloat();
        data.scaleY = rawData.readFloat();
    }

    // skew
    if (rawData.readBool()) {
        data.skewX = rawData.readFloat();
        data.skewY = rawData.readFloat();
    }

    // pivot
    if (rawData.readBool()) {
        data.pivotX = rawData.readFloat();
        data.pivotY = rawData.readFloat();
        data.isPivot = rawData.readBool();
    }

    f1 = rawData.readFloat();
    if (f1 != 1)
        data.alpha = f1;

    f1 = rawData.readFloat();
    if (f1 != 0)
        data.rotation = f1;

    if (!rawData.readBool())
        data.visible = false;
    if (!rawData.readBool())
        data.touchable = false;
    if (rawData.readBool())
        data.grayed = true;
    var bm = rawData.readByte();
    const BlendModeTranslate = {
        0: "NormalBlending",
        1: "NoBlending",
        2: "AdditiveBlending",
        3: "MultiplyBlending",
        4: "SubtractiveBlending",
    }
    data.blendMode = BlendModeTranslate[bm] || "NormalBlending";

    var filter = rawData.readByte();
    if (filter == 1) {
        //todo set filter
        // ToolSet.setColorFilter(data.displayObject,
        //     [rawData.readFloat(), rawData.readFloat(), rawData.readFloat(), rawData.readFloat()]);
    }

    var str = rawData.readS();
    if (str != null)
        data.data = str;
    return data;
}

function constructExtension(type, buffer) {
    let data = {};
    switch (type) {
        case 12:
            data.content = constructButton(buffer);
            break;
        default:
            break;
    }

    return data;
}

function constructButton(buffer) {
    let data = {};
    buffer.seek(0, 6);

    /**
     *  Common,
        Check,
        Radio
     */
    data.mode = buffer.readByte();
    var str = buffer.readS();
    if (str)
        data.sound = str;
    data.soundVolumeScale = buffer.readFloat();
    data.downEffect = buffer.readByte();
    data.downEffectValue = buffer.readFloat();
    if (data.downEffect == 2)
        this.setPivot(0.5, 0.5, this.pivotAsAnchor);

    // data.buttonController = this.getController("button");
    // data.titleObject = this.getChild("title");
    // data.iconObject = this.getChild("icon");
    // if (data.titleObject)
    //     data.title = data.titleObject.text;
    // if (data.iconObject)
    //     data.icon = data.iconObject.icon;

    // if (data.mode == ButtonMode.Common)
    //     data.setState("up");
    return data;
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
                    pi.rawData = buffer.readBuffer();
                    UIPackage[pi.id] = pi;
                    break;
                }

            case 5: // Font:
                {
                    // fontRawDataMap[pi.id] = buffer.readBuffer();
                    // pi.rawData = buffer.readBuffer();
                    pi.rawData = buffer.readBuffer();
                    UIPackage[pi.id] = pi;
                    break;
                }

            case 3: // Component:
                {
                    let extension = buffer.readByte();
                    if (extension > 0)
                        pi.objectType = extension;
                    else
                        pi.objectType = 9; // Component;
                    pi.rawData = buffer.readBuffer();
                    UIPackage[pi.id] = pi;
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











