生成id方法

function genDevCode(){
    let a = 0;
    let b = 0;
    let c;
    while(b<4){
        c = Math.random() * 26;
        a = a + Math.pow(26, b) * (c + 10);
        b++;
    }
    console.log(a);
    a = a + Math.random() * 1000000 + Math.random() * 222640;
    return a.toString(36);
}

function generateUID(){
    const FIX = Number(Math.random() * 36).toString(36).substr(0, 1);
    let a = "0000" + Number(Math.random() * 1679616).toString(36);
    let b = "000" + Number(Math.random() * 46656).toString(36);
    return FIX + a.substr(a.length - 4) + b.substr(b.length - 3);
}

var _loc_3:* = 0;
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            while (_loc_2 < 4)
            {
                
                _loc_3 = Math.random() * 26;
                _loc_1 = _loc_1 + Math.pow(26, _loc_2) * (_loc_3 + 10);
                _loc_2++;
            }
            _loc_1 = _loc_1 + (int(Math.random() * 1000000) + int(Math.random() * 222640));
            return _loc_1.toString(36);