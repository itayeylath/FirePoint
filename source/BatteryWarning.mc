using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.System;

class BatteryWarning {

    const LOW_BATTERY_THRESHOLD = 20.0;
    const WARNING_RADIUS = 12;

    //! Draw a red center circle only when battery is below 20%.
    function drawLowBatteryCircle(dc as Gfx.Dc) as Void {
        var battery = System.getSystemStats().battery;

        if (battery == null || !(battery instanceof Lang.Number)) {
            return;
        }

        if (battery >= LOW_BATTERY_THRESHOLD) {
            return;
        }

        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;

        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY, WARNING_RADIUS);
    }
}
