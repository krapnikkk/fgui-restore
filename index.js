const fs = require('fs');
const zlib = require("zlib");
const Jimp = require('jimp');
const ByteArray = require('./ByteArray');
const { resolve } = require('path');
const { exists, xml2json, json2xml, getItemById, getObjectById, rgbaToHex, isEmptyObject, changeTwoDecimal } = require('./utils/utils');
const { createMovieClip } = require('./build/create');

process.on("uncaughtException", function (err) {
    console.log(err);
    debugger;
});

const XMLHeader = '<?xml version="1.0" encoding="utf-8"?>\n';
let importFileName = "Basics",
    inputPath = "./test/",
    outputPath = './output/',
    temp = '/temp/',
    tempPath = `${outputPath}${importFileName}${temp}`,
    pkgName = "",
    pkgId = "",
    UIPackage = {},
    ObjectType = [
        "Image",
        "MovieClip",
        "Swf",
        "Graph",
        "Loader",
        "Group",
        "Text",
        "RichText",
        "InputText",
        "Component",
        "List",
        "Label",
        "Button",
        "ComboBox",
        "ProgressBar",
        "Slider",
        "ScrollBar",
        "Tree",
        "Loader3D"
    ],
    downEffectType = [
        "none",
        "dark",
        "scale"
    ],
    OverflowType = [
        "visible",
        "hidden",
        "scroll"
    ],
    ChildrenRenderOrder = [
        "ascent",
        "descent",
        "arch"
    ],
    ListSelectionMode = [
        "single",
        "multiple",
        "multipleSingleClick",
        "none"
    ],
    ListLayoutType = [
        "singleColumn",
        "singleRow",
        "flowHorizontal",
        "flowVertical",
        "pagination"
    ],
    ButtonMode = [
        "Common",
        "Check",
        "Radio"
    ],
    GraphType = [
        "none",
        "rect",
        "ellipse",
        "polygon",
        "regular_polygon"
    ],
    RelationType = [
        "left-left",
        "left-center",
        "left-right",
        "center-center",
        "right-left",
        "right-center",
        "right-right",
        "top-top",
        "top-middle",
        "top-bottom",
        "middle-middle",
        "bottom-top",
        "bottom-middle",
        "bottom-bottom",
        "width-width",
        "height-height",
        "leftext-left",
        "leftext-right",
        "rightext-left",
        "rightext-right",
        "topext-top",
        "topext-bottom",
        "bottomext-top",
        "bottomext-bottom",
        // Size
    ],
    fillMethodType = [
        "None",
        "hz",
        "vt",
        "radial90",
        "radial180",
        "radial360",
    ],
    FlipType = [
        "None",
        "hz",
        "vt",
        "both"
    ],
    LoaderFillType = [
        "none",
        "scale",
        "scaleMatchHeight",
        "scaleMatchWidth",
        "scaleFree",
        "scaleNoBorder"
    ],
    FillOrigin = [
        "topLeft",
        "topRight",
        "bottomLeft",
        "bottomRight"
    ],
    ScrollType = [
        "horizontal",
        "vertical",
        "both"
    ],
    easeType = [
        "Linear",
        "Sine.In",
        "Sine.Out",
        "Sine.InOut",
        "Quad.In",
        "Quad.Out",
        "Quad.InOut",
        "Cubic.In",
        "Cubic.Out",
        "Cubic.InOut",
        "Quart.In",
        "Quart.Out",
        "Quart.InOut",
        "Quint.In",
        "Quint.Out",
        "Quint.InOut",
        "Expo.In",
        "Expo.Out",
        "Expo.InOut",
        "Circ.In",
        "Circ.Out",
        "Circ.InOut",
        "Elastic.In",
        "Elastic.Out",
        "Elastic.InOut",
        "Back.In",
        "Back.Out",
        "Back.InOut",
        "Bounce.In",
        "Bounce.Out",
        "Bounce.InOut",
        "Custom",
    ],
    AutoSizeType = [
        "none",
        "both",
        "height",
        "shrink"
    ],
    ScrollBarDisplayType = [
        "default",
        "visible",
        "auto",
        "hidden"
    ],
    PackageItemType = [
        // Image,
        // MovieClip,
        // Sound,
        // Component,
        // Atlas,
        // Font,
        // Swf,
        // Misc,
        // Unknown
        ".png",
        ".jta",
        "Sound",
        ".xml",
        ".png",
        ".fnt",
        ".swf"
    ],
    packageItemMap = {},
    UIConfig = {},// default
    GearType = [
        "gearDisplay", "gearXY", "gearSize", "gearLook", "gearColor",
        "gearAni", "gearText", "gearIcon", "gearDisplay2", "gearFontSize"
    ];

/**
 *  check package format
 *  decodeUncompressed only for [Laya/Egret/CocosCreateor] version 
 */

const start = async (path) => {
    console.time('start');
    let buf = fs.readFileSync(`${path}`); // Buffer 
    let arrayBuffer = Buffer.from(buf).buffer;
    let ba = new ByteArray(arrayBuffer), pkgData;
    let formatFlag = ba.readUint(); // 1179080009
    if (formatFlag == 0x46475549) { // binary 
        pkgData = await parseBufferBin(ba);
        await handlePackageFileBin(pkgData);
        await createByPackageBin(pkgData);
    } else { // xml
        pkgData = await parseBufferXML(buf);
        await handlePackageFileXML(pkgData);
        await createByPackageXML(pkgData);
    }
    console.timeEnd('start');
}

/** XML */
const parseBufferXML = async (buf) => {
    let data;
    let mark = new Uint8Array(buf.buffer.slice(0, 2));
    if (mark[0] == 0x50 && mark[1] == 0x4b) {
        data = decodeUncompressed(buf.buffer);
    } else {
        let str = zlib.inflateRawSync(buf).toString();
        data = formatXMLStr(str);
    }
    return data;
}

const formatXMLStr = (source) => {
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

const decodeUncompressed = (buf) => {
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

const handlePackageDataXML = async (data) => {
    let json = await xml2json(data);
    let packageDescription = json['packageDescription'];
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
        if (!Array.isArray(components)) components = [components];
        components.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.xml';
            delete item['$']['size'];
        })
    }
    if (images) {
        if (!Array.isArray(images)) images = [images];
        images.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.png';
            delete item['$']['size'];
        })
    }
    if (movieclips) {
        if (!Array.isArray(movieclips)) movieclips = [movieclips];
        movieclips.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.jta';
            delete item['$']['size'];
        })
    }
    if (fonts) {
        if (!Array.isArray(fonts)) fonts = [fonts];
        fonts.forEach((item) => {
            item['$']['name'] = item['$']['name'] + '.fnt';
            delete item['$']['size'];
        })
    }
    if (sounds) {
        if (!Array.isArray(sounds)) sounds = [sounds];
        sounds.forEach((item) => {
            // todo check file ext
            item['$']['name'] = item['$']['name'] + '.' + item['$']['file'].split(".").pop();
            delete item['$']['size'];
            delete item['$']['file'];
        })
    }
    return json2xml(json);
}

const handlePackageFileXML = async (data) => {
    let packageXml = XMLHeader + data['package.xml'];
    packageXml = await handlePackageDataXML(packageXml);

    let output = `${outputPath}${importFileName}`;
    if (!exists(output)) {
        fs.mkdirSync(resolve(output));
    }
    fs.writeFileSync(`${output}/package.xml`, packageXml);
}

const createByPackageXML = async (pkgData) => {
    // handle package.xml & get pkgName and pkgId
    const packageData = await xml2json(pkgData["package.xml"]);
    pkgName = packageData["packageDescription"]['$']['name'];
    pkgId = packageData["packageDescription"]['$']['id'];

    // Verifies if the texture exists in the same directory
    let atlasInfo = packageData["packageDescription"]['resources']['atlas'];
    if (atlasInfo) {
        if (!Array.isArray(atlasInfo)) atlasInfo = [atlasInfo];
        handleAltas(atlasInfo);
    }

    // parse sprites.bytes
    let imageInfo = packageData["packageDescription"]['resources']['image'];
    if (imageInfo) {
        if (!Array.isArray(imageInfo)) imageInfo = [imageInfo];
        let spritesMap = parseSprites(pkgData['sprites.bytes']);
        imageInfo.forEach((item) => {
            let image = item['$'];
            let key = image['id'];
            Object.assign(spritesMap[key], image);
        })
        await handleSprites(spritesMap);
    }

    let soundInfo = packageData["packageDescription"]['resources']['sound'];
    if (soundInfo) {
        if (!Array.isArray(soundInfo)) soundInfo = [soundInfo];
        handleSound(soundInfo, false);
    }

    let fontInfo = packageData["packageDescription"]['resources']['font'];
    if (fontInfo) {
        let fontMap = {};
        if (!Array.isArray(fontInfo)) fontInfo = [fontInfo];
        fontInfo.forEach((item) => {
            let font = item['$'];
            let file = `${font['id']}.fnt`;
            font['content'] = pkgData[file];
            fontMap[file] = font;
        })
        createFileByData(fontMap, '.fnt');
    }
    let movieclipInfo = packageData["packageDescription"]['resources']['movieclip'];
    if (movieclipInfo) {
        if (!Array.isArray(movieclipInfo)) movieclipInfo = [movieclipInfo];
        let movieclipMap = {};
        movieclipInfo.forEach((item) => {
            let movieclip = item['$'];
            let file = `${movieclip['id']}.xml`;
            movieclip['content'] = pkgData[file];
            delete pkgData[file];
            movieclipMap[file] = movieclip;
        })

        await handleMovieclip(movieclipMap);
    }

    let componentInfo = packageData["packageDescription"]['resources']['component'];
    if (componentInfo) {
        if (!Array.isArray(componentInfo)) componentInfo = [componentInfo];
        let componentMap = {};
        componentInfo.forEach((item) => {
            let component = item['$'];
            let file = `${component['id']}.xml`;
            component['content'] = XMLHeader + pkgData[file];
            componentMap[file] = component;
        })
        createFileByData(componentMap, ".xml");
    }

    deleteTemp(tempPath);
}

const handlePackageDataBin = (pkgData) => {
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

const handlePackageFileBin = async (data) => {
    let str = handlePackageDataBin(data);
    let output = `${outputPath}${importFileName}`;
    if (!exists(output)) {
        fs.mkdirSync(resolve(output));
    }
    fs.writeFileSync(`${output}/package.xml`, str);
}

const parseBufferBin = async (ba) => {
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
    }
    return data;
}

const createByPackageBin = async (pkgData) => {
    // handle package.xml & get pkgName and pkgId
    const packageData = pkgData["package.xml"];
    const sprites = pkgData['sprites.bytes'];
    const files = pkgData['files'];
    // Verifies if the texture exists in the same directory
    let atlasInfo = packageData["packageDescription"]['resources']['atlas'];
    if (atlasInfo) {
        if (!Array.isArray(atlasInfo)) atlasInfo = [atlasInfo];
        // handleAltas(atlasInfo);
    }

    // parse sprites.bytes
    let imageInfo = packageData["packageDescription"]['resources']['image'];
    if (imageInfo) {
        if (!Array.isArray(imageInfo)) imageInfo = [imageInfo];
        let spritesMap = pkgData['sprites.bytes'];
        imageInfo.forEach((item) => {
            let image = item['$'];
            let key = image['id'];
            Object.assign(spritesMap[key], image);
        })
        // await handleSprites(spritesMap, false);
    }

    let soundInfo = packageData["packageDescription"]['resources']['sound'];
    if (soundInfo) {
        if (!Array.isArray(soundInfo)) soundInfo = [soundInfo];
        // handleSound(soundInfo, false);
    }

    let fontInfo = packageData["packageDescription"]['resources']['font'];
    if (fontInfo) {
        let fontMap = {};
        if (!Array.isArray(fontInfo)) fontInfo = [fontInfo];
        fontInfo.forEach((item) => {
            let font = item['$'];
            let file = `${font['id']}.fnt`;
            font['content'] = decodeFontData(font['id'], sprites, files);
            fontMap[file] = font;
        })
        // createFileByData(fontMap, '');
    }

    let movieclipInfo = packageData["packageDescription"]['resources']['movieclip'];
    if (movieclipInfo) {
        if (!Array.isArray(movieclipInfo)) movieclipInfo = [movieclipInfo];
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
    }

    let componentInfo = packageData["packageDescription"]['resources']['component'];
    if (componentInfo) {
        if (!Array.isArray(componentInfo)) componentInfo = [componentInfo];
        let componentMap = {};
        componentInfo.forEach((item) => {
            let component = item['$'];
            let { id } = component;
            let content = decodeComponentData(UIPackage[id], files);
            console.log(id);
            component['content'] = parseJSON2XML(content);
            componentMap[id] = component;
        })
        createFileByData(componentMap, "");
    }
    // debugger;
    deleteTemp(tempPath);
}

function deleteTemp(path) {
    path = resolve(path);
    if (exists(path)) {
        let tempfiles = fs.readdirSync(path);
        if (tempfiles) {
            tempfiles.forEach((file) => {
                fs.unlinkSync(path + '/' + file);
            });
        }
        fs.rmdirSync(path);
    }
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

    let mainTexture;
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

    let frameCount = rawData.readShort();
    pi.frames = frameCount;

    // let spriteId;
    // let sprite;
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

    for (let i = 0; i < frameCount; i++) {
        let nextPos = rawData.readShort();
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
        // let atlas = data.getItemAsset(sprite.atlas);
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

function decodeComponentData(contentItem, files) {
    let { rawData, objectType } = contentItem;
    let pi = { "children": [], objectType };
    rawData.seek(0, 0);

    // size
    pi.width = rawData.readInt();
    pi.height = rawData.readInt();

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
    let overflow = rawData.readByte();
    pi.overflow = overflow;
    if (overflow == 2) { // 2
        let savedPos = rawData.pos;
        rawData.seek(0, 7);
        pi.scroll = setupScroll(rawData);
        rawData.pos = savedPos;
    }


    if (rawData.readBool())
        rawData.skip(8);

    rawData.seek(0, 1);

    //controller
    let controllerCount = rawData.readShort();
    pi.controllers = [];
    for (let i = 0; i < controllerCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        let controller = setupController(rawData); // controller.setup
        pi.controllers.push(controller);
        rawData.pos = nextPos;
    }
    // let self = setup_beforeAdd(type, rawData, rawData.pos)
    rawData.seek(0, 2);

    let childCount = rawData.readShort();
    for (let i = 0; i < childCount; i++) {
        let child = {};
        let dataLen = rawData.readShort();
        curPos = rawData.pos;


        rawData.seek(curPos, 0);

        let type = rawData.readByte();
        let src = rawData.readS();
        let pkgId = rawData.readS(); // use src
        child.type = type;
        child.src = src;
        let packageItem = null;

        if (src != null) {
            packageItem = UIPackage[src];
            if (packageItem) { // GComponent
                child.objectType = packageItem.objectType;
                let file = getObjectById(files, "id", src);
                if (file) child.file = file.name;
            } else { // altas && image
                packageItem = files[src];
                child.file = packageItem.name;
            }
            child.path = packageItem.path;
            child.packageItemType = packageItem.type;
        }



        child.beforeContent = setup_beforeAdd(child.type, rawData, curPos) // setup_beforeAdd
        pi.children.push(child);

        rawData.pos = curPos + dataLen;
    }

    rawData.seek(0, 3);
    pi.relations = relationSetup(rawData, true); //relations.setup

    rawData.seek(0, 2);
    rawData.skip(2);

    for (let i = 0; i < childCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        rawData.seek(rawData.pos, 3);
        pi.children[i].relations = relationSetup(rawData, false); //relations.setup

        rawData.pos = nextPos;
    }

    rawData.seek(0, 2);
    rawData.skip(2);

    for (let i = 0; i < childCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        child = pi.children[i];
        // setup_afterAdd
        let type = child.objectType || child.type;
        let position = rawData.pos;
        child.afterContent = setup_afterAdd(type, rawData, position);
        child.content = Object.assign({}, child.beforeContent, child.afterContent);
        delete child.beforeContent;
        delete child.afterContent;
        rawData.pos = nextPos;
    }

    rawData.seek(0, 4);

    pi.customData = rawData.skip(2); //customData
    pi.opaque = rawData.readBool();
    let maskId = rawData.readShort();
    if (maskId != -1) {
        pi.maskId = maskId;
        pi.reversedMask = rawData.readBool(); //reversedMask
    }
    pi.hitTestId = rawData.readS();
    i1 = rawData.readInt();
    i2 = rawData.readInt();
    if (pi.hitTestId != null) {
        pi.hitTestId = _pixelHitTestDatas[hitTestId];//contentItem.owner.getItemById(hitTestId);
        if (pi && pi.pixelHitTestData)
            pi.rootContainer.hitArea = new PixelHitTest(pi.pixelHitTestData, i1, i2);
    } else if (i1 != 0 && i2 != -1) {
        pi.rootContainer.hitArea = pi.getChildAt(i2).displayObject;
    }

    rawData.seek(0, 5);

    let transitionCount = rawData.readShort();
    pi.transitions = [];
    for (i = 0; i < transitionCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        let trans = transitionSetup(rawData);
        pi.transitions.push(trans);

        rawData.pos = nextPos;
    }

    if (pi.objectType != 9)
        pi.extensionData = constructExtension(pi.objectType, rawData);
    return pi;
}

function decodeGraphBefore(rawData, position) {
    let data = { "shape": {} };
    rawData.seek(position, 5);

    let type = rawData.readByte();
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
        Object.assign(data.shape, { type });
    }
    return data;
}

function decodeTextFieldBefore(rawData, position) {
    let data = { "textFormat": {} };
    rawData.seek(position, 5);

    let tf = data.textFormat;

    tf.font = rawData.readS();
    tf.size = rawData.readShort();
    tf.color = rgbaToHex(rawData.readColor(), false);
    let c = rawData.readByte();
    data.align = c == 0 ? "left" : (c == 1 ? "center" : "right");
    c = rawData.readByte();
    data.verticalAlign = c == 0 ? "top" : (c == 1 ? "middle" : "bottom");
    tf.leading = rawData.readShort();
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

function decodeTextInputBefore(rawData, position) {
    let text = decodeTextFieldBefore(rawData, position);
    let data = {};
    rawData.seek(position, 4);

    let str = rawData.readS();
    if (str != null)
        data.promptText = str;

    str = rawData.readS();
    if (str != null)
        data.restrict = str;

    let iv = rawData.readInt();
    if (iv != 0)
        data.maxLength = iv;
    iv = rawData.readInt();
    if (iv != 0) {
        if (iv == 4)
            data.keyboardType = "number";
        else if (iv == 3)
            data.keyboardType = "url";
    }
    if (rawData.readBool())
        data.password = true;

    return Object.assign(data, text);
}

function decodeLoaderBefore(rawData, position) {
    let data = { "content": {} };
    rawData.seek(position, 5);
    data.url = rawData.readS();
    let iv = rawData.readByte();
    data.align = iv == 0 ? "left" : (iv == 1 ? "center" : "right");
    iv = rawData.readByte();
    data.vAlign = iv == 0 ? "top" : (iv == 1 ? "middle" : "bottom");
    data.fill = rawData.readByte();
    data.shrinkOnly = rawData.readBool();
    data.autoSize = rawData.readBool();
    rawData.readBool(); //_showErrorSign
    data.content.playing = rawData.readBool();
    data.content.frame = rawData.readInt();

    if (rawData.readBool()) {
        data.color = rawData.readColor();
    }
    data.content.fillMethod = rawData.readByte();
    if (data.content.fillMethod != 0) {
        data.content.fillOrigin = rawData.readByte();
        data.content.fillClockwise = rawData.readBool();
        data.content.fillAmount = rawData.readFloat();
    }
    return data;
}

function decodeGroupBefore(rawData, position) {
    let data = {};
    rawData.seek(position, 5);

    data.layout = rawData.readByte();
    data.lineGap = rawData.readInt();
    data.columnGap = rawData.readInt();
    if (rawData.version >= 2) {
        data.excludeInvisibles = rawData.readBool();
        data.autoSizeDisabled = rawData.readBool();
        data.mainGridIndex = rawData.readShort();
    }
    return data;
}

function decodeListBefore(rawData, position, treeView = false) {
    let data = { "margin": {} };
    rawData.seek(position, 5);
    let i1;

    data.layout = rawData.readByte();
    data.selectionMode = rawData.readByte();
    i1 = rawData.readByte();
    data.align = i1 == 0 ? "left" : (i1 == 1 ? "center" : "right");
    i1 = rawData.readByte();
    data.vAlign = i1 == 0 ? "top" : (i1 == 1 ? "middle" : "bottom");
    data.lineGap = rawData.readShort();
    data.columnGap = rawData.readShort();
    data.lineCount = rawData.readShort();
    data.columnCount = rawData.readShort();
    data.autoResizeItem = rawData.readBool();
    data.childrenRenderOrder = rawData.readByte();
    data.apexIndex = rawData.readShort();

    if (rawData.readBool()) {
        data.margin.top = rawData.readInt();
        data.margin.bottom = rawData.readInt();
        data.margin.left = rawData.readInt();
        data.margin.right = rawData.readInt();
    }

    data.overflow = rawData.readByte();
    if (data.overflow == 2) {
        let savedPos = rawData.pos;
        rawData.seek(position, 7);
        data.scroll = setupScroll(rawData);
        rawData.pos = savedPos;
    }

    if (rawData.readBool()) //clipSoftness
        rawData.skip(8);

    if (rawData.version >= 2) {
        data.scrollItemToViewOnClick = rawData.readBool();
        data.foldInvisibleItems = rawData.readBool();
    }

    rawData.seek(position, 8);

    data.defaultItem = rawData.readS();
    data.items = readItems(rawData, data, treeView);
    return data;
}

function readItems(buffer, list, treeView) {
    let data = [];
    let cnt;
    let i;
    let nextPos;
    let str;
    var isFolder;
    var level;

    cnt = buffer.readShort();
    for (i = 0; i < cnt; i++) {
        nextPos = buffer.readShort();
        nextPos += buffer.pos;

        str = buffer.readS();
        if (str == null) {
            str = list.defaultItem;
            if (!str) {
                buffer.pos = nextPos;
                continue;
            }
        }
        if (treeView) {
            isFolder = buffer.readBool();
            level = buffer.readByte();
        }
        // debugger;
        let id = str.replace(`ui://${pkgId}`, '');
        // let pkg = UIPackage[id];
        let obj = { id, buffer };
        let item;
        if (obj) {
            item = setupItem(buffer, id);
        }
        // item.isFolder = isFolder; // wait for extension
        item.level = level;
        data.push(item);

        buffer.pos = nextPos;
    }
    return data;
}

function setupItem(buffer, id) {
    let pkg = UIPackage[id];
    let data = {};
    let str;

    str = buffer.readS();
    if (str != null)
        data.title = str;
    str = buffer.readS();
    if (str != null && pkg.objectType == 12) // GButton
        data.selectedTitle = str;
    str = buffer.readS();
    if (str != null)
        data.icon = str;
    str = buffer.readS();
    if (str != null && pkg.objectType == 12)// GButton
        data.selectedIcon = str;
    str = buffer.readS();
    if (str != null)
        data.name = str;

    let cnt;
    let i;

    if (pkg.objectType == 9) { // GComponent todo
        debugger;
        cnt = buffer.readShort();
        for (i = 0; i < cnt; i++) {
            let cc = obj.getController(buffer.readS());
            str = buffer.readS();
            if (cc)
                cc.selectedPageId = str;
        }

        if (buffer.version >= 2) {
            cnt = buffer.readShort();
            debugger;
            for (i = 0; i < cnt; i++) {
                let target = buffer.readS();
                let propertyId = buffer.readShort();
                let value = buffer.readS();
                let obj2 = obj.getChildByPath(target);
                if (obj2)
                    obj2.setProp(propertyId, value);
            }
        }
    }
    return data;
}


function decodeTreeBefore(rawData, position) {
    let list = decodeListBefore(rawData, position, true);
    let data = {};
    rawData.seek(position, 9);

    data.indent = rawData.readInt();
    data.clickToExpand = rawData.readByte();
    return Object.assign(data, list);
}

function decodeTextFieldAfter(rawData, position) {
    let data = {};
    rawData.seek(position, 6);

    let str = rawData.readS();
    if (str != null)
        data.text = str;
    return data;
}

function decodeComponetAfter(rawData, position) {
    let data = { "scrollPane": {} };
    rawData.seek(position, 4);

    let pageController = rawData.readShort();
    if (pageController != -1)
        data.scrollPane.pageController = pageController;// this.parent.getControllerAt(pageController);

    let cnt = rawData.readShort();
    for (let i = 0; i < cnt; i++) {
        let control = rawData.readS();
        data.control = control;
        let pageId = rawData.readS();
        if (pageId)
            data.selectedPageId = pageId;
    }

    if (rawData.version >= 2) {
        cnt = rawData.readShort();
        data.props = [];
        for (i = 0; i < cnt; i++) {
            debugger;
            let target = rawData.readS();
            let propertyId = rawData.readShort();
            let value = rawData.readS();
            data.props.push({ target, propertyId, value });
        }
    }
    return data;
}

function transitionSetup(buffer) {
    let data = { "items": [] };
    data.name = buffer.readS();
    data.options = buffer.readInt();
    data.autoPlay = buffer.readBool();
    data.autoPlayTimes = buffer.readInt();
    data.autoPlayDelay = buffer.readFloat();

    let cnt = buffer.readShort();
    for (let i = 0; i < cnt; i++) {
        let dataLen = buffer.readShort();
        let curPos = buffer.pos;

        buffer.seek(curPos, 0);
        let type = buffer.readByte();
        let item = { type, value: {} };
        data.items[i] = item;

        item.time = buffer.readFloat();
        let targetId = buffer.readShort();
        if (targetId < 0)
            item.targetId = "";
        else
            item.targetId = targetId;
        item.label = buffer.readS();
        let tween = buffer.readBool();
        item.tween = tween;
        if (tween) {
            buffer.seek(curPos, 1);

            item.tweenConfig = { "startValue": {}, "endValue": {} };
            item.tweenConfig.duration = buffer.readFloat();
            if (item.time + item.tweenConfig.duration > data.totalDuration)
                data.totalDuration = item.time + item.tweenConfig.duration;
            item.tweenConfig.easeType = buffer.readByte();
            item.tweenConfig.repeat = buffer.readInt();
            item.tweenConfig.yoyo = buffer.readBool();
            item.tweenConfig.endLabel = buffer.readS();

            buffer.seek(curPos, 2);

            decodeValue(item, buffer, item.tweenConfig.startValue);

            buffer.seek(curPos, 3);

            decodeValue(item, buffer, item.tweenConfig.endValue);

            if (buffer.version >= 2) {
                let pathLen = buffer.readInt();
                if (pathLen > 0) {
                    item.tweenConfig.path = {};
                    let pts = [];
                    for (let j = 0; j < pathLen; j++) {
                        let curveType = buffer.readByte();
                        switch (curveType) {
                            case 1:
                                pts.push({
                                    x: buffer.readFloat(),
                                    y: buffer.readFloat(),
                                    control1_x: buffer.readFloat(),
                                    control1_y: buffer.readFloat()
                                });
                                break;

                            case 2:
                                pts.push({
                                    x: buffer.readFloat(),
                                    y: buffer.readFloat(),
                                    control1_x: buffer.readFloat(),
                                    control1_y: buffer.readFloat(),
                                    control2_x: buffer.readFloat(),
                                    control2_y: buffer.readFloat()
                                });
                                break;

                            default:
                                pts.push({
                                    x: buffer.readFloat(),
                                    y: buffer.readFloat(),
                                    curveType
                                });
                                break;
                        }
                    }

                    item.tweenConfig.path = pts;
                }
            }
        }
        else {
            if (item.time > data.totalDuration)
                data.totalDuration = item.time;

            buffer.seek(curPos, 2);

            decodeValue(item, buffer, item.value);
        }

        buffer.pos = curPos + dataLen;
    }
    return data;
}

function decodeValue(item, buffer, value) {
    switch (item.type) {
        case 0:
        case 1:
        case 2:
        case 3:
            value.b1 = buffer.readBool();
            value.b2 = buffer.readBool();
            value.f1 = buffer.readFloat();
            value.f2 = buffer.readFloat();

            if (buffer.version >= 2 && item.type == 0)
                value.b3 = buffer.readBool(); //percent
            break;

        case 4:
        case 5:
            value.b1 = value.b2 = true;
            value.f1 = buffer.readFloat();
            break;

        case 6:
            value.b1 = value.b2 = true;
            value.f1 = buffer.readFloat();
            value.f2 = buffer.readFloat();
            break;

        case 7:
            value.b1 = value.b2 = true;
            value.f1 = buffer.readColor();
            break;

        case 8:
            value.playing = buffer.readBool();
            value.frame = buffer.readInt();
            break;

        case 9:
            value.visible = buffer.readBool();
            break;

        case 10:
            value.sound = buffer.readS();
            value.volume = buffer.readFloat();
            break;

        case 11:
            value.transName = buffer.readS();
            value.playTimes = buffer.readInt();
            break;

        case 12:
            value.amplitude = buffer.readFloat();
            value.duration = buffer.readFloat();
            break;

        case 13:
            value.b1 = value.b2 = true;
            value.f1 = buffer.readFloat();
            value.f2 = buffer.readFloat();
            value.f3 = buffer.readFloat();
            value.f4 = buffer.readFloat();
            break;

        case 14:
        case 15:
            value.text = buffer.readS();
            break;
    }
}

function relationSetup(buffer, parentToChild) {
    let data = { "items": [] };
    let cnt = buffer.readByte();
    for (let i = 0; i < cnt; i++) {
        let targetIndex = buffer.readShort();
        let newItem = { "relations": [], targetIndex };
        if (targetIndex != -1) {
            newItem.targetIndex = targetIndex;
            newItem.parentToChild = parentToChild;
        }
        data.items.push(newItem);

        let cnt2 = buffer.readByte();
        for (let j = 0; j < cnt2; j++) {
            let rt = buffer.readByte();
            let usePercent = buffer.readBool();
            let relation = { rt, usePercent };
            newItem.relations.push(relation);
        }
    }
    return data;
}

function setupScroll(buffer) {
    let data = { "scrollBarMargin": {} };
    data.scrollType = buffer.readByte();
    let scrollBarDisplay = buffer.readByte();
    let flags = buffer.readInt();
    data.flags = flags;
    if (buffer.readBool()) {
        data.scrollBarMargin.top = buffer.readInt();
        data.scrollBarMargin.bottom = buffer.readInt();
        data.scrollBarMargin.left = buffer.readInt();
        data.scrollBarMargin.right = buffer.readInt();
    }

    data.vtScrollBarRes = buffer.readS();
    data.hzScrollBarRes = buffer.readS();
    data.headerRes = buffer.readS();
    data.footerRes = buffer.readS();

    // if ((flags & 1) != 0) data.displayOnLeft = true;
    // if ((flags & 2) != 0) data.snapToItem = true;
    // if ((flags & 4) != 0) data.displayInDemand = true;
    // if ((flags & 8) != 0) data.pageMode = true;
    // if (flags & 16)
    //     data.touchEffect = true;
    // else if (flags & 32)
    //     data.touchEffect = false;
    // else
    //     data.touchEffect = true;
    // if (flags & 64)
    //     data.bouncebackEffect = true;
    // else if (flags & 128)
    //     data.bouncebackEffect = false;
    // else
    //     data.bouncebackEffect = true;

    // if ((flags & 256) != 0) data.inertiaDisabled = true;
    // if ((flags & 512) == 0) data.maskContainer.clipRect = {};
    // if ((flags & 1024) != 0) data.floating = true;
    // if ((flags & 2048) != 0) data.dontClipMargin = true;

    // if (scrollBarDisplay == 0)
    //     scrollBarDisplay = 1;
    data.scrollBarDisplay = scrollBarDisplay;

    return data;
}

function gearSetup(buffer, gearType) {
    let gearName = GearType[gearType];
    let data = { "pages": [], gearName };
    data.controllerId = buffer.readShort(); //  controller id
    let i;
    let page, status;
    let cnt = buffer.readShort();
    data.status = [];
    data.extStatus = [];
    // todo
    // controller in this parent 
    if (gearName == "gearDisplay" || gearName == "gearDisplay2") {  // GearDisplay GearDisplay2
        data.pages = buffer.readSArray(cnt);
    } else {
        for (i = 0; i < cnt; i++) {
            page = buffer.readS();
            if (page == null) {
                page = i + "";
                status = {};
            } else {
                status = addStatus(gearType, page, buffer);
            }
            data.pages.push(page);
            data.status.push(status);
        }

        if (buffer.readBool()) {// default
            data.defaultValues = addStatus(gearType, null, buffer);
        }
    }

    if (buffer.readBool()) {
        data.tweenConfig = { tween: true };
        data.tweenConfig.ease = buffer.readByte();
        data.tweenConfig.duration = buffer.readFloat();
        data.tweenConfig.delay = buffer.readFloat();
    }

    if (buffer.version >= 2) {
        // todo positionsInPercent && condition
        if (gearName == "gearXY") { // gearXY
            if (buffer.readBool()) {
                debugger;
                data.positionsInPercent = true;
                for (i = 0; i < cnt; i++) {
                    page = buffer.readS();
                    if (page == null) {
                        extStatus = {}
                    } else {
                        extStatus = addExtStatus(page, buffer)
                    }
                    data.extStatus.push(extStatus);
                }

                if (buffer.readBool())
                    data.defaultExtStatus = addExtStatus(null, buffer);
            }
        } else if (gearName == "gearDisplay2") {// GearDisplay2
            data.condition = buffer.readByte();
        }
    }
    return data;
}

function addStatus(type, page, buffer) {
    let data = {};
    switch (GearType[type]) {
        case "gearSize":
            data.width = buffer.readInt();
            data.height = buffer.readInt();
            data.scaleX = buffer.readFloat();
            data.scaleY = buffer.readFloat();
            break;
        case "gearIcon":
            data.default = buffer.readS();
            break;
        case "gearFontSize":
            data.default = buffer.readInt();
            break;
        case "gearColor":
            data.color = buffer.readColor();
            data.strokeColor = buffer.readColor();
            break;
        case "gearText":
            data.default = buffer.readS();
            break;
        case "gearXY":
            data.x = buffer.readInt();
            data.y = buffer.readInt();
            break;
        case "gearLook":
            data.alpha = buffer.readFloat();
            data.rotation = buffer.readFloat();
            data.grayed = buffer.readBool();
            data.touchable = buffer.readBool();
            break;
        case "gearAni":
            data.playing = buffer.readBool();
            data.frame = buffer.readInt();
            break;
        default:
            debugger;
            break;
    }

    return data;


}

function addExtStatus(buffer) {
    let data = {};
    data.px = buffer.readFloat();
    data.py = buffer.readFloat();
    return data;
}

function setup_beforeAdd(type, buffer, position) {
    let content = {};
    let object = decodeGObjectBefore(buffer, position);
    switch (type) {
        case 0: // Image
            content = decodeImageBefore(buffer, position);
            break;

        case 1: // MovieClip
            content = decodeMovieClipBefore(buffer, position);
            break;

        case 3: // GGraph
            content = decodeGraphBefore(buffer, position);
            break;

        case 4: // Loader
            content = decodeLoaderBefore(buffer, position);
            break;

        case 5: // Group:
            content = decodeGroupBefore(buffer, position);
            break;

        case 6: // Text
            content = decodeTextFieldBefore(buffer, position);
            break;

        case 7: // RichText
            content = decodeTextFieldBefore(buffer, position);
            break;

        case 8: // InputText
            content = decodeTextInputBefore(buffer, position);
            break;

        case 9: // Gcomponet

            break;
        case 10: // Glist
            content = decodeListBefore(buffer, position);
            break;
        case 17: // GTree
            content = decodeTreeBefore(buffer, position);
            break;
        default:
            break;
    }
    return Object.assign(object, content);
}

function setup_afterAdd(type, buffer, position) {
    let object = decodeGObjectAfter(buffer, position);;
    let data = { "content": {}, "component": {} };
    switch (type) {
        case 6: // Text
            data.content = decodeTextFieldAfter(buffer, position);
            break;
        case 7: // RichText
            data.content = decodeTextFieldAfter(buffer, position);
            break;

        case 8: // InputText
            data.content = decodeTextFieldAfter(buffer, position);
            break;

        case 9: // Gcomponet
            data.content = decodeComponetAfter(buffer, position);
            break;
        case 10: // List
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeListAfter(buffer, position);
            break;

        case 11: // Label
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeLabelAfter(buffer, position);
            break;

        case 12: // Button
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeButtonAfter(buffer, position);
            break;

        case 13: // ComboBox
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeComboBoxAfter(buffer, position);
            break;

        case 14: // ProgressBar
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeProgressBarAfter(buffer, position);
            break;

        case 15: // Slider
            data.component = decodeComponetAfter(buffer, position);
            data.content = decodeSliderAfter(buffer, position);
            break;
        default:
            break;
    }
    return Object.assign(object, data.component, data.content, { type });
}

function decodeProgressBarAfter(rawData, position) {
    let data = {};
    if (!rawData.seek(position, 6)) {
        return;
    }

    if (rawData.readByte() != 14) {
        return;
    }

    data.value = rawData.readInt();
    data.max = rawData.readInt();
    if (rawData.version >= 2)
        data.min = rawData.readInt();

    return data;
}

function decodeSliderAfter(rawData, position) {
    let data = {};
    if (!rawData.seek(position, 6)) {
        return;
    }

    if (rawData.readByte() != 15) {
        return;
    }

    data.value = rawData.readInt();
    data.max = rawData.readInt();
    if (rawData.version >= 2)
        data.min = rawData.readInt();
    return data;
}

function decodeImageBefore(rawData, position) {
    let data = {
        "image": {}
    };
    rawData.seek(position, 5);

    if (rawData.readBool())
        data.color = rawData.readColor();
    data.flip = rawData.readByte();
    data.image.fillMethod = rawData.readByte();
    if (data.image.fillMethod != 0) {
        data.image.fillOrigin = rawData.readByte();
        data.image.fillClockwise = rawData.readBool();
        data.image.fillAmount = rawData.readFloat();
    }
    return data;
}

function decodeComboBoxAfter(rawData, position) {
    let data = { "items": [], "values": [] };
    if (!rawData.seek(position, 6))
        return;

    if (rawData.readByte() != 13)
        return;

    let i;
    let iv;
    let nextPos;
    let str;
    let itemCount = rawData.readShort();
    for (i = 0; i < itemCount; i++) {
        nextPos = rawData.readShort();
        nextPos += rawData.pos;

        data.items[i] = rawData.readS();
        data.values[i] = rawData.readS();
        str = rawData.readS();
        if (str != null) {
            if (data.icons == null)
                data.icons = [];
            data.icons[i] = str;
        }

        rawData.pos = nextPos;
    }

    str = rawData.readS();
    if (str != null) {
        data.text = str;
        data.selected = data.items.indexOf(str);
    }
    else if (data.items.length > 0) {
        data.selected = 0;
        data.text = data.items[0];
    }
    else
        data.selected = -1;

    str = rawData.readS();
    if (str != null)
        data.icon = str;

    if (rawData.readBool())
        data.titleColor = rawData.readColor();
    iv = rawData.readInt();
    if (iv > 0)
        data.visibleItemCount = iv;
    data.popupDirection = rawData.readByte();

    iv = rawData.readShort();
    if (iv >= 0)
        data.selectionController = iv;

    return data;
}

function decodeMovieClipBefore(rawData, position) {
    let data = {
        "movieClip": {
            "graphics": {}
        }
    };
    rawData.seek(position, 5);

    if (rawData.readBool())
        data.color = rawData.readColor();
    data.movieClip.graphics.flip = rawData.readByte(); //flip
    data.movieClip.frame = rawData.readInt();
    data.movieClip.playing = rawData.readBool();

    return data;
}

function decodeLabelAfter(rawData, position) {
    let data = {};
    if (!rawData.seek(position, 6))
        return;

    if (rawData.readByte() != 11)
        return;

    let str;
    str = rawData.readS();
    if (str != null)
        data.title = str;
    str = rawData.readS();
    if (str != null)
        data.icon = str;
    if (rawData.readBool())
        data.titleColor = rawData.readColor();
    let iv = rawData.readInt();
    if (iv != 0)
        data.titleFontSize = iv;

    if (rawData.readBool()) {
        let input = data.getTextField();
        if (input instanceof GTextInput) {
            str = rawData.readS();
            if (str != null)
                input.promptText = str;

            str = rawData.readS();
            if (str != null)
                input.restrict = str;

            iv = rawData.readInt();
            if (iv != 0)
                input.maxLength = iv;
            iv = rawData.readInt();
            if (iv != 0) {
                if (iv == 4)
                    input.keyboardType = 'number';
                else if (iv == 3)
                    input.keyboardType = 'url';
            }
            if (rawData.readBool())
                input.password = true;
        }
        else
            rawData.skip(13);
    }

    return data;
}

function decodeButtonAfter(rawData, position) {
    let data = {};
    if (!rawData.seek(position, 6))
        return;

    if (rawData.readByte() != 12)
        return;
    let str;
    let iv;

    str = rawData.readS();
    if (str != null)
        data.title = str;
    str = rawData.readS();
    if (str != null)
        data.selectedTitle = str;
    str = rawData.readS();
    if (str != null)
        data.icon = str;
    str = rawData.readS();
    if (str != null)
        data.selectedIcon = str;
    if (rawData.readBool())
        data.titleColor = rawData.readColor();
    iv = rawData.readInt();
    if (iv != 0)
        data.titleFontSize = iv;
    iv = rawData.readShort();
    if (iv >= 0)
        data.relatedController = iv; // data.parent.getControllerAt(iv);
    data.relatedPageId = rawData.readS();

    str = rawData.readS();
    if (str != null)
        data.sound = str;
    if (rawData.readBool())
        data.volume = rawData.readFloat();

    data.selected = rawData.readBool();

    return data;
}

function decodeListAfter(rawData, position) {
    let data = {};
    rawData.seek(position, 6);

    let i = rawData.readShort();
    if (i != -1)
        data.selectionController = i;
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

function setupController(buffer) {
    let controller = {
        "pageIds": [],
        "pageNames": [],
        "selected": []
    };
    let beginPos = buffer.pos;
    buffer.seek(beginPos, 0);

    controller.name = buffer.readS();
    if (buffer.readBool()) // autoRadioGroupDepth
        controller.autoRadioGroupDepth = true;

    buffer.seek(beginPos, 1);

    let i;
    let nextPos;
    let cnt = buffer.readShort();

    for (i = 0; i < cnt; i++) {
        controller.pageIds.push(buffer.readS());
        controller.pageNames.push(buffer.readS());
    }

    let homePageIndex = 0;
    if (buffer.version >= 2) {
        let homePageType = buffer.readByte();
        switch (homePageType) {
            case 1: // "specific"
                homePageIndex = buffer.readShort();
                break;

            case 2: // "branch"
                homePageIndex = controller.pageNames.indexOf(UIPackage.branch);
                if (homePageIndex == -1)
                    homePageIndex = 0;
                break;

            case 3: // "letiable"
                // todo
                homePageIndex = controller.pageNames.indexOf(UIPackage.getlet(buffer.readS()));
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
        controller.selected = homePageIndex;
    else
        controller.selected = -1;
    return controller;
}

function decodeGObjectAfter(rawData, position) {
    let data = {};
    rawData.seek(position, 1);

    let str = rawData.readS();
    if (str)
        data.tooltips = str;

    let groupId = rawData.readShort();
    if (groupId >= 0)
        data.group = groupId;

    rawData.seek(position, 2);

    let cnt = rawData.readShort();
    data.gears = [];
    for (let i = 0; i < cnt; i++) {
        let nextPos = rawData.readShort();
        nextPos += rawData.pos;

        data.gearType = rawData.readByte();
        let gear = gearSetup(rawData, data.gearType);
        data.gears.push(gear);
        rawData.pos = nextPos;
    }
    return data;
}

function decodeGObjectBefore(rawData, position) {
    let data = {};
    rawData.seek(position, 0);
    rawData.skip(5);

    let f1;
    data.id = rawData.readS();
    data.name = rawData.readS();
    // position 
    data.x = rawData.readInt();
    data.y = rawData.readInt();

    // size
    if (rawData.readBool()) {
        data.width = rawData.readInt();
        data.height = rawData.readInt();
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
    let bm = rawData.readByte();
    const BlendModeTranslate = {
        0: "NormalBlending",
        1: "NoBlending",
        2: "AdditiveBlending",
        3: "MultiplyBlending",
        4: "SubtractiveBlending",
    }
    data.blendMode = BlendModeTranslate[bm] || "NormalBlending";

    let filter = rawData.readByte();
    if (filter == 1) {
        debugger;
        data.filter = [rawData.readFloat(), rawData.readFloat(), rawData.readFloat(), rawData.readFloat()];
        //todo set filter
        // ToolSet.setColorFilter(data.displayObject,
        //     [rawData.readFloat(), rawData.readFloat(), rawData.readFloat(), rawData.readFloat()]);
    }

    let str = rawData.readS();
    if (str != null)
        data.remark = str;
    return data;
}

/** constructExtension */
function constructExtension(type, buffer) {
    let data = {};
    switch (type) {
        case 12:
            data = constructButton(buffer);
            break;
        case 13:
            data = constructComboBox(buffer);
            break;
        case 14:
            data = constructProgressBar(buffer);
            break;
        case 15:
            data = constructSlider(buffer);
            break;
        case 16:
            data = constructScrollBar(buffer);
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
    let str = buffer.readS();
    if (str)
        data.sound = str;
    data.soundVolumeScale = buffer.readFloat();
    data.downEffect = buffer.readByte();
    data.downEffectValue = buffer.readFloat();
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

function constructComboBox(buffer) {
    let data = {};
    data.str = buffer.readS();
    return data;
}

function constructProgressBar(buffer) {
    let data = {};
    buffer.seek(0, 6);

    data.titleType = buffer.readByte();
    data.reverse = buffer.readBool();
    return data;
}

function constructSlider(buffer) {
    let data = {};
    buffer.seek(0, 6);

    data.titleType = buffer.readByte();
    data.reverse = buffer.readBool();
    if (buffer.version >= 2) {
        data.wholeNumbers = buffer.readBool();
        data.changeOnClick = buffer.readBool();
    }
    return data;
}

function constructScrollBar(buffer) {
    let data = {};
    buffer.seek(0, 6);
    data.fixedGripSize = buffer.readBool();
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
            if (pi && pi.type == 0) {
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

const parseJSON2XML = (json) => {
    console.log(json);
    let base = {
        "component": {
            "$": {},
            "controller": [],
            "displayList": {

            }
        }
    }
    let {
        width, height,
        objectType, overflow,
        hitTestId, controllers,
        pivotX, pivotY,
        isPivot,
        extensionData, children,
        opaque, maskId, reversedMask,
        rootContainer, remark,
        minWidth,maxWidth,
        minHeight,maxHeight
    } = json;

    let { component } = base;
    let { $ } = component;
    let size = `${width},${height}` != "undefined,undefined" ? `${width},${height}` : null;
    $['size'] = size;
    let restrictSize = `${minWidth},${maxWidth},${minHeight},${maxHeight}` != "undefined,undefined,undefined,undefined" ? `${minWidth},${maxWidth},${minHeight},${maxHeight}` : null;
    $['restrictSize'] = restrictSize;
    let pivot = `${pivotX},${pivotY}` != "undefined,undefined" ? `${pivotX},${pivotY}` : null;
    $['pivot'] = pivot;
    if (isPivot) $['isPivot'] = isPivot;
    if (objectType && objectType !== 9) {
        let type = ObjectType[objectType];
        $['extention'] = type;
        component[type] = parseExtension(type, extensionData);
    }
    if (overflow) $['overflow'] = OverflowType[overflow];
    if (hitTestId) $['hitTestId'] = hitTestId;
    if (maskId) $['mask'] = children[maskId]['content']['name'];
    if (reversedMask) $['reversedMask'] = reversedMask;
    if (!opaque) $['opaque'] = opaque;
    if (rootContainer) $['rootContainer'] = rootContainer;
    if (remark) $['remark'] = remark;
    let controller = parseControllers(controllers);
    if (controller) {
        component['controller'] = controller;
    }
    if (children) {
        component['displayList'] = parseDisplayList(children, json);
    }
    let xml = json2xml(base);
    xml = xml.replace(/_{\$(\w+)}_/g, "");
    return xml;
}

function parseControllers(controllers) {
    return controllers.map((controller) => {
        let { name, selected, pageIds, pageNames } = controller;
        let pages = "";
        pageIds.forEach((pageId, idx, arr) => {
            if (idx == arr.length - 1) {
                pages += `${pageId},${pageNames[idx]}`;
            } else {
                pages += `${pageId},${pageNames[idx]},`;
            }
        })
        return { $: { name, pages, selected } };
    })
}

function parseDisplayList(children, parent) {
    let { controllers } = parent;
    let displayList = {
        // "_{$1}_image": [],
    };
    children.forEach((child, idx) => {
        let { type, src, content, relations, path, packageItemType, file } = child;
        let objectType = ObjectType[type];
        let { width, height,
            scaleX,scaleY,
            skewX,skewY,
            id, name,
            x, y,
            pivotX, pivotY,
            gears, grayed,
            group, touchable,
            visible, isPivot,
            alpha, customData,
            tooltips } = content;
        let size = `${width},${height}` != "undefined,undefined" ? `${width},${height}` : null;
        let scale = `${scaleX},${scaleY}` != "undefined,undefined" ? `${Math.round(scaleX * 100) / 100},${Math.round(scaleY * 100) / 100}` : null;
        let skew = `${skewX},${skewY}` != "undefined,undefined" ? `${skewX},${skewY}` : null;
        let xy = `${x},${y}`;
        let pivot = `${pivotX},${pivotY}` != "undefined,undefined" ? `${pivotX},${pivotY}` : null;
        isPivot ? isPivot : isPivot = null;
        let fileName;
        let GObjectData = parseObject(objectType, content);
        let { objectData, extensionData, item } = GObjectData;
        if (src) {
            let fileExt = PackageItemType[packageItemType];
            if (!fileExt) {
                throw new Error("PackageItemType undefined!!");
            }

            if (fileExt == "Sound") {
                fileName = path.slice(1, path.length) + file;
            } else {
                fileName = path.slice(1, path.length) + file + fileExt;
            }
        }
        let originData = {
            "$": { id, name, src, fileName, xy, size,scale,skew, customData, tooltips, alpha, pivot, isPivot, touchable, grayed, group, visible }
        };
        if (objectData) Object.assign(originData["$"], objectData);

        // gear
        if (gears.length > 0) {
            let gearObject = parseGear(gears, controllers);
            Object.assign(originData, gearObject);
        }

        // relation
        if (relations && relations.items) {
            let relation = [];
            relations.items.forEach((item) => {
                let $ = { "target": "", "sidePair": "" };
                let targetIndex = item.targetIndex;
                if (targetIndex > -1) {
                    $.target = parent['children'][targetIndex]['content']['id'];
                }
                let sidePairs = item.relations.map((sidePair) => {
                    let { rt, usePercent } = sidePair;
                    rt = RelationType[rt];
                    usePercent = usePercent ? "%" : "";
                    return `${rt}${usePercent}`;
                });
                if (sidePairs) {
                    $.sidePair = sidePairs.join(",");
                }
                relation.push({ $ });
            })
            Object.assign(originData, { relation });
        }
        if (extensionData) Object.assign(originData, extensionData);
        if (objectType === "Tree") objectType = "List";
        displayList[`_{$${idx}}_${objectType.toLocaleLowerCase()}`] = originData;
        if (item) {
            displayList[`_{$${idx}}_${objectType.toLocaleLowerCase()}`]['item'] = item;
        }
        // packageItemMap[id] = { originData, parent };
    })
    return displayList;
}

function parseObject(objectType, content) {
    let { align, vAlign, items } = content;
    let objectData = {}, extensionData, item;
    switch (objectType) {
        case "Image":
            {
                let { image, flip } = content;
                if (!image) image = {};
                let { fillMethod, fillOrigin, fillClockwise, fillAmount } = image;
                if (fillMethod) objectData.fillMethod = fillMethodType[fillMethod];
                if (fillOrigin) objectData.fillOrigin = FillOrigin[fillOrigin];
                objectData.fillClockwise = fillClockwise;
                objectData.fillAmount = fillAmount;
                if (flip) objectData.flip = FlipType[flip];
            }
            break;
        case "MovieClip":
            let { movieClip, color } = content;
            if (!movieClip) movieClip = {};
            let { frame, playing } = movieClip;
            if (frame) objectData.frame = frame;
            if (!playing) objectData.playing = playing;
            if (color) objectData.color = color;
            break;
        case "Graph":
            {
                let { shape } = content;
                let { lineSize, lineColor,
                    fillColor, cornerRadius,
                    distances, sides,
                    startAngle } = shape;
                if (!shape) shape = {};
                objectData.type = GraphType[shape.type];
                if (lineSize != 1) objectData.lineSize = lineSize; // default
                if (lineColor != "#ff000000") objectData.lineColor = lineColor;
                if (fillColor != "#ffffffff") objectData.fillColor = fillColor;
                if (cornerRadius) objectData.corner = `${cornerRadius[0]}`;
                if (startAngle) objectData.startAngle = startAngle;
                objectData.distances = distances;
                objectData.sides = sides;
            }
            break;
        case "Text":
            objectData = parseText(content);
            break;
        case "RichText":
            objectData = parseText(content);
            break;
        case "InputText":
            let { promptText, keyboardType, password, maxLength, restrict } = content;
            objectData = parseText(content);
            if (restrict) objectData.restrict = restrict;
            if (promptText) objectData.promptText = promptText;
            if (keyboardType) objectData.keyboardType = keyboardType;
            if (password) objectData.password = password;
            if (maxLength) objectData.maxLength = maxLength;
            break;
        case "Component":
            let { type } = content;
            let extensionName = ObjectType[type];
            switch (extensionName) {
                case "ProgressBar":
                    {
                        let { value, max } = content;
                        extensionData = {};
                        extensionData[extensionName] = {
                            "$": { value, max }
                        };
                    }
                    break;
                case "Button":
                    {
                        let { selected } = content;
                        if (selected) {
                            extensionData = {};
                            extensionData[extensionName] = {
                                "$": { "checked": selected }
                            };
                        }
                    }
                    break;
                case "Component":
                    break;
                case "Label":
                    {
                        extensionData = {};
                        let { title, icon, titleColor, titleFontSize } = content;
                        extensionData[extensionName] = {
                            "$": { title, icon, titleColor, titleFontSize }
                        };
                    }
                    break;
                case "ComboBox":
                    {
                        extensionData = {};
                        let { items, values,
                            icons, popupDirection,
                            selected, text,
                            titleColor, visibleItemCount,
                            selectionController } = content;
                        extensionData[extensionName] = {
                            "$": { popupDirection, selected, text, selectionController, titleColor, visibleItemCount }
                        };
                    }
                    break;
                case "Slider":
                    extensionData = {};
                    let { value, max, min } = content;
                    extensionData[extensionName] = {
                        "$": { value, max, min }
                    }
                    break;
                default:
                    console.log(extensionName);
                    debugger;
                    break;
            }
            break;
        case "Loader":
            {
                let { shrinkOnly, url, fill } = content;
                let loader = content.content;
                if (!loader) loader = {};
                let { fillMethod, frame, playing, fillOrigin, fillClockwise, fillAmount } = loader;
                objectData.url = url;
                if (fillMethod) objectData.fillMethod = fillMethodType[fillMethod];
                if (fillOrigin) objectData.fillOrigin = FillOrigin[fillOrigin];
                objectData.fillClockwise = fillClockwise;
                objectData.fillAmount = fillAmount;
                objectData.align = align == "left" ? null : align;
                objectData.vAlign = vAlign == "top" ? null : vAlign;
                if (fill) objectData.fill = LoaderFillType[fill];
                if (shrinkOnly) objectData.shrinkOnly = shrinkOnly;
                if (frame) objectData.frame = frame;
                if (!playing) objectData.playing = playing;
            }
            break
        case "List":
            objectData = parseList(content);
            item = [];
            items.forEach((ele) => {
                item.push({
                    "$": ele
                });
            });
            break;
        case "Tree":
            objectData = parseList(content);
            objectData.treeView = true;
            let { indent, clickToExpand } = content;
            objectData.indent = indent;
            objectData.clickToExpand = clickToExpand;
            item = [];
            items.forEach((ele) => {
                item.push({
                    "$": ele
                });
            });
            break;
        case "Group":
            let { layout, lineGap, columnGap, excludeInvisibles, autoSizeDisabled, mainGridIndex } = content;
            if (layout) objectData.layout = layout;
            if (lineGap) objectData.lineGap = lineGap;
            if (columnGap) objectData.columnGap = columnGap;
            if (excludeInvisibles) objectData.excludeInvisibles = excludeInvisibles;
            if (autoSizeDisabled) objectData.autoSizeDisabled = autoSizeDisabled;
            if (mainGridIndex > -1) objectData.mainGridIndex = mainGridIndex;
            break;
        default:
            console.log(objectType, content);
            debugger;
            break;
    }
    return { objectData, extensionData, item };
}

function parseGear(gears, controllers) {
    let gearObject = {};
    gears.forEach((gear) => {
        let { controllerId, pages, gearName, status, extStatus, defaultValues, defaultExtStatus, tweenConfig, positionsInPercent, condition } = gear;
        let defaultStr;
        let values = status.map((item, idx) => {
            let value = "-";
            switch (gearName) {
                case "gearXY":
                    if (!isEmptyObject(item)) {
                        let { x, y } = item;
                        value = `${x},${y}`;
                        if (positionsInPercent) {
                            let = { px, py } = extStatus[idx];
                            value += `${px},${py}`;
                        }
                    }
                    if (defaultValues && !isEmptyObject(defaultValues) && !defaultStr) {
                        let { x, y } = defaultValues;
                        defaultStr = `${x},${y}`;
                        if (positionsInPercent) {
                            let = { px, py } = defaultExtStatus[idx];
                            defaultStr += `${px},${py}`;
                        }
                    }
                    break;
                case "gearSize":
                    if (!isEmptyObject(item)) {
                        let { width, height, scaleX, scaleY } = item;
                        value = `${width},${height},${scaleX},${scaleY}`;
                    }
                    if (defaultValues && !isEmptyObject(defaultValues) && !defaultStr) {
                        let { width, height, scaleX, scaleY } = defaultValues;
                        defaultStr = `${width},${height},${scaleX},${scaleY}`;
                    }
                    break;
                case "gearLook":
                    if (!isEmptyObject(item)) {
                        let { alpha, rotation, grayed, touchable } = item;
                        value = `${alpha},${rotation},${+grayed},${+touchable}`;
                    }
                    if (defaultValues && !isEmptyObject(defaultValues) && !defaultStr) {
                        let { alpha, rotation, grayed, touchable } = defaultValues;
                        defaultStr = `${alpha},${rotation},${+grayed},${+touchable}`;
                    }
                    break;
                case "gearColor":
                    if (!isEmptyObject(item)) {
                        let { color, strokeColor } = item;
                        // if (strokeColor == "rgb(0,0,0)") strokeColor = null; version 3.0
                        value = `${rgbaToHex(color, false)},${rgbaToHex(strokeColor, false)}`;
                    }
                    if (defaultValues && !isEmptyObject(defaultValues) && !defaultStr) {
                        let { color, strokeColor } = defaultValues;
                        // if (strokeColor == "rgb(0,0,0)") strokeColor = null; version 3.0
                        defaultStr = `${rgbaToHex(color, false)},${rgbaToHex(strokeColor, false)}`;
                    }
                    break;
                case "gearAni":
                    if (!isEmptyObject(item)) {
                        let { frame, playing } = item;
                        value = `${frame},${playing ? "p" : "s"}`;
                    }
                    if (defaultValues && !isEmptyObject(defaultValues) && !defaultStr) {
                        let { frame, playing } = defaultValues;
                        defaultStr = `${frame},${playing ? "p" : "s"}`;
                    }
                    break;
                case "gearFontSize":
                    if (!isEmptyObject(item)) {
                        value = `${item.default}`;
                    }
                    if (defaultValues && !isEmptyObject(defaultValues) && !defaultStr) {
                        defaultStr = `${item.default}`;
                    }
                    break;
                case "gearIcon":
                    if (!isEmptyObject(item)) {
                        value = `${item.default}`;
                    }
                    if (defaultValues && !isEmptyObject(defaultValues) && !defaultStr) {
                        defaultStr = `${item.default}`;
                    }
                    break;
                case "gearText":
                    if (!isEmptyObject(item)) {
                        value = `${item.default}`;
                    }
                    if (defaultValues && !isEmptyObject(defaultValues) && !defaultStr) {
                        defaultStr = `${item.default}`;
                    }
                    break;

                default:
                    debugger;
                    break;
            }
            if (value && value.endsWith(',')) {
                value = value.slice(0, value.length - 1);
            }
            if (defaultStr && defaultStr.endsWith(',')) {
                defaultStr = defaultStr.slice(0, defaultStr.length - 1);
            }
            return value;
        });

        if (values.length == 0) {
            values = null;
        } else {
            values = values.join("|");
        }

        gearObject[gearName] = {
            "$": {
                "controller": controllers[controllerId]['name'],
                "pages": pages.join(","),
                values,
                condition,
                "default": defaultStr

            }
        }

        if (tweenConfig && tweenConfig.tween) {
            let { ease, delay, duration, tween } = tweenConfig;
            if (ease != 5) {
                ease = easeType[ease];
            } else {
                ease = null;
            }
            duration = duration.toFixed(1);
            duration = duration == "0.3" ? null : duration.replace("0.", ".");

            if (delay === 0) {
                delay = null;
            } else {
                delay = delay.toString().replace("0.", ".");
            }
            Object.assign(gearObject[gearName]['$'], { tween, ease, duration, delay });
        }
    });
    return gearObject;
}

function parseExtension(type, extensionData) {
    let data = { $: {} };
    switch (type) {
        case "Button":
            let { downEffect, downEffectValue, mode, soundVolumeScale, sound } = extensionData;
            if (downEffect) {
                data['$']['downEffect'] = downEffectType[downEffect];
                if (downEffectValue) {
                    data['$']['downEffectValue'] = (+downEffectValue.toFixed(2)).toString().replace("0.", ".");
                }

            }
            if (mode) {
                data['$']['mode'] = ButtonMode[mode]
            }
            if (soundVolumeScale > 1) {
                data['$']['volume'] = volume
            }
            if (sound) {
                data['$']['sound'] = sound;
            }
            break;
        default:
            console.log("parseExtension:", type, extensionData);
            break;
    }

    return data;
}

function parseList(content) {
    let objectData = {};
    let { defaultItem,
        align, vAlign,
        overflow, scroll,
        childrenRenderOrder, selectionMode,
        autoResizeItem, scrollItemToViewOnClick,
        foldInvisibleItems, layout,
        lineGap, columnGap,
        lineCount, columnCount,
        selectionController } = content;
    if (!scroll) scroll = {};
    let { flags, scrollBarMargin,
        footerRes, headerRes,
        vtScrollBarRes, hzScrollBarRes,
        scrollType, scrollBarDisplay } = scroll;


    if (selectionMode) objectData.selectionMode = ListSelectionMode[selectionMode];
    if (layout) objectData.layout = ListLayoutType[layout];
    if (overflow) objectData.overflow = OverflowType[overflow];
    objectData.scroll = ScrollType[scrollType];
    if (flags) objectData.scrollBarFlags = flags;
    if (scrollBarDisplay) objectData.scrollBar = ScrollBarDisplayType[scrollBarDisplay];
    if (scrollBarMargin && !isEmptyObject(scrollBarMargin)) {
        let { left, right, top, bottom } = scrollBarMargin;
        objectData.scrollBarMargin = `${top},${bottom},${left},${right}`;
    }
    if (lineGap) objectData.lineGap = lineGap;
    if (columnGap) objectData.columnGap = columnGap;
    if (lineCount) objectData.lineCount = lineCount;
    if (columnCount) objectData.columnCount = columnCount;
    if (hzScrollBarRes || vtScrollBarRes) objectData.scrollBarRes = `${hzScrollBarRes ? hzScrollBarRes : ""},${vtScrollBarRes ? vtScrollBarRes : ""}`;
    if (headerRes || footerRes) objectData.ptrRes = `${headerRes ? headerRes : ""},${footerRes ? footerRes : ""}`;
    objectData.defaultItem = defaultItem;
    objectData.align = align == "left" ? null : align;
    objectData.vAlign = vAlign == "top" ? null : vAlign;
    if (childrenRenderOrder) objectData.renderOrder = ChildrenRenderOrder[childrenRenderOrder];
    if (!autoResizeItem) objectData.autoItemSize = autoResizeItem;
    if (!scrollItemToViewOnClick) objectData.scrollItemToViewOnClick = scrollItemToViewOnClick;
    if (foldInvisibleItems) objectData.foldInvisibleItems = foldInvisibleItems;
    if (selectionController) objectData.selectionController = controllers[selectionController]['name'];
    return objectData;
}

function parseText(content) {
    let objectData = {};
    let { textFormat, singleLine,
        ubbEnabled, autoSize, text,
        align, verticalAlign, template } = content;
    if (!textFormat) textFormat = {};
    let { size, color,
        bold, underline,
        italic, letterSpacing,
        leading, font,
        strikethrough, shadowColor,
        shadowOffsetX, shadowOffsetY,
        outlineColor, outline } = textFormat;
    
    objectData.align = align == "left" ? null : align;
    objectData.vAlign = verticalAlign == "top" ? null : verticalAlign;
    if (bold) objectData.bold = bold;
    if (underline) objectData.underline = underline;
    if (italic) objectData.italic = italic;
    if (letterSpacing) objectData.letterSpacing = letterSpacing;
    if (leading != 3) objectData.leading = leading;
    if (font) objectData.font = font;
    objectData.fontSize = size;
    objectData.color = color == "#000000" ? null : color;
    if (singleLine) objectData.singleLine = singleLine;
    if (ubbEnabled) objectData.ubbEnabled = ubbEnabled;
    if (template) objectData.template = template;
    if(autoSize != 1)objectData.autoSize = AutoSizeType[autoSize]; // default:1
    objectData.strokeColor = outlineColor;
    objectData.outline = outline;
    if(strikethrough)objectData.strikethrough = strikethrough;
    objectData.shadowColor = shadowColor;
    objectData.shadowOffsetX = shadowOffsetX;
    objectData.shadowOffsetY = shadowOffsetY;
    objectData.text = text || "";
    return objectData;
}

/** utils  */
/**
 * use spritesMap to crop images
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
        fs.writeFileSync(output, content)
    }
    console.log("finish createFileByData");
}



start(`${inputPath}${importFileName}.bin`);











