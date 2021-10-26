package com.powerflasher.as3potrace
{

    public class POTraceParams extends Object
    {
        public var threshold:uint;
        public var thresholdOperator:String;
        public var turdSize:int;
        public var alphaMax:Number;
        public var curveOptimizing:Boolean;
        public var optTolerance:Number;

        public function POTraceParams(param1:uint = 8947848, param2:String = "<=", param3:int = 2, param4:Number = 1, param5:Boolean = false, param6:Number = 0.2)
        {
            this.threshold = param1;
            this.thresholdOperator = param2;
            this.turdSize = param3;
            this.alphaMax = param4;
            this.curveOptimizing = param5;
            this.optTolerance = param6;
            return;
        }// end function

    }
}
