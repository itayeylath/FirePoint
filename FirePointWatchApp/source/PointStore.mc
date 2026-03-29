using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Lang;

//! Saved GPS points. **UTM** is always stored as null: Connect IQ has no official UTM formatter.
module PointStore {

    const _KEY_POINTS = "points";
    const _KEY_SEQ = "pointSeq";

    function savePoint(
        lat as Lang.Float,
        lon as Lang.Float,
        latLonDisplay as Lang.String,
        mgrs as Lang.String or Null,
        altitude as Lang.Float or Null
    ) as Void {
        if (!(Toybox has :Storage)) {
            return;
        }

        var seqObj = Storage.getValue(_KEY_SEQ);
        var seq = 0;
        if (seqObj != null) {
            seq = seqObj as Lang.Number;
        }
        seq = seq + 1;
        Storage.setValue(_KEY_SEQ, seq);

        var name = "Pt " + seq.toString();

        var entry = {
            "type" => "point",
            "name" => name,
            "timestamp" => seq,
            "lat" => lat,
            "lon" => lon,
            "latLonDisplay" => latLonDisplay,
            "mgrs" => mgrs,
            "utm" => null,
            "altitude" => altitude
        } as Lang.Dictionary;

        var raw = Storage.getValue(_KEY_POINTS);
        var next = [] as Lang.Array;
        if (raw != null) {
            var oldList = raw as Lang.Array;
            for (var i = 0; i < oldList.size(); i++) {
                next.add(oldList[i]);
            }
        }
        next.add(entry);
        Storage.setValue(_KEY_POINTS, next);
    }
}
