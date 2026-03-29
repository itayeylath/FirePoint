using Toybox.Lang;

//! Display mode order: MGRS -> UTM -> Lat/Lon -> MGRS.
module PositionFormat {
    const MGRS = 0;
    const UTM = 1;
    const LAT_LON = 2;
    const MODE_COUNT = 3;
}
