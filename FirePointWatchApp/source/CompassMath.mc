using Toybox.Lang;
using Toybox.Math;

module CompassMath {

    function radiansToDegreesInt(rad as Lang.Float) as Lang.Number {
        var deg = rad * 180.0 / Math.PI;
        while (deg < 0.0) {
            deg += 360.0;
        }
        while (deg >= 360.0) {
            deg -= 360.0;
        }
        var n = deg.toNumber();
        if (n >= 360) {
            n = 0;
        }
        if (n < 0) {
            n = 0;
        }
        return n;
    }

    function degreesToMils6400(degInt as Lang.Number) as Lang.Number {
        var mils = (degInt * 6400) / 360;
        mils = (mils % 6400 + 6400) % 6400;
        return mils;
    }
}
