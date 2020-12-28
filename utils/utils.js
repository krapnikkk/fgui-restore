const fs = require('fs');
const { parseStringPromise, Builder } = require('xml2js');
const uuidv4 = () => {
    return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        let r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

const exists = (path) => {
    return fs.existsSync(path);
}

const xml2json = (xml) => {
    return new Promise((resolve, reject) => {
        parseStringPromise(xml, { trim: true, explicitArray: false }).then((result) => {
            resolve(result);
        }).catch((err) => {
            reject(err);
        })
    })
}

const getItemById = (itemMap, id) => {
    let item;
    for (let key in itemMap) {
        let ele = itemMap[key];
        if (ele.id == id) {
            item = ele;
        }
    };
    return item;
}

const json2xml = (json) => {
    var builder = new Builder({ xmldec: { 'version': '1.0', 'encoding': 'UTF-8' } });
    return builder.buildObject(json);
}

module.exports.xml2json = xml2json;
module.exports.json2xml = json2xml;
module.exports.exists = exists;
module.exports.uuidv4 = uuidv4;
module.exports.getItemById = getItemById;