using Toybox.Application;
using Toybox.Application.Storage;
using Toybox.Lang;

//! Persists saved bearings to Application.Storage when the Storage module exists.
module BearingStore {

    const _KEY_BEARINGS = "bearings";
    const _KEY_SEQ = "bearingSeq";

    function saveBearing(deg as Lang.Number, mils as Lang.Number) as Void {
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

        var name = "Brg " + seq.toString();

        var entry = {
            "type" => "bearing",
            "name" => name,
            "timestamp" => seq,
            "degrees" => deg,
            "mils6400" => mils
        } as Lang.Dictionary;

        var raw = Storage.getValue(_KEY_BEARINGS);
        var next = [] as Lang.Array;
        if (raw != null) {
            var oldList = raw as Lang.Array;
            for (var i = 0; i < oldList.size(); i++) {
                next.add(oldList[i]);
            }
        }
        next.add(entry);
        Storage.setValue(_KEY_BEARINGS, next);
    }
}
