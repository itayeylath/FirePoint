using Toybox.Lang;
using Toybox.Position;

//! Coordinate formatting for the Position screen.
//!
//! **MGRS:** Garmin exposes `Position.GEO_MGRS` and `Location.toGeoString(GEO_MGRS)` — use that
//! for real MGRS output when the runtime succeeds.
//!
//! **UTM:** Connect IQ only documents four `GEO_*` formats (DEG, DM, DMS, MGRS). There is no
//! `GEO_UTM` or official UTM string API — do not fabricate UTM strings; UI uses explicit placeholders.
module PositionFormatHelper {

    function formatLatLon(loc as Position.Location) as Lang.String {
        try {
            return loc.toGeoString(Position.GEO_DEG);
        } catch (e) {
            var deg = loc.toDegrees();
            if (deg != null && deg.size() >= 2) {
                return deg[0].toString() + ", " + deg[1].toString();
            }
            return "";
        }
    }

    //! Returns null if `toGeoString(GEO_MGRS)` fails (e.g. polar edge cases).
    function formatMgrs(loc as Position.Location) as Lang.String or Null {
        try {
            return loc.toGeoString(Position.GEO_MGRS);
        } catch (e) {
            return null;
        }
    }
}
