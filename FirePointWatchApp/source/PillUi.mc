using Toybox.Lang;
using Toybox.Graphics;

module PillUi {

    function drawPillColored(
        dc as Graphics.Dc,
        x as Lang.Number,
        y as Lang.Number,
        w as Lang.Number,
        h as Lang.Number,
        r as Lang.Number,
        label as Lang.String,
        font as Graphics.FontDefinition,
        fillColor as Lang.Number,
        strokeColor as Lang.Number,
        textColor as Lang.Number
    ) as Void {
        var cx = x + w / 2;
        var cy = y + h / 2;

        dc.setColor(fillColor, fillColor);
        dc.fillRoundedRectangle(x, y, w, h, r);

        dc.setColor(strokeColor, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(x, y, w, h, r);

        dc.setClip(x, y, w, h);
        dc.setColor(textColor, fillColor);
        dc.drawText(
            cx,
            cy,
            font,
            label,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.clearClip();
    }

    function drawPill(
        dc as Graphics.Dc,
        x as Lang.Number,
        y as Lang.Number,
        w as Lang.Number,
        h as Lang.Number,
        r as Lang.Number,
        label as Lang.String,
        font as Graphics.FontDefinition
    ) as Void {
        drawPillColored(
            dc,
            x,
            y,
            w,
            h,
            r,
            label,
            font,
            Graphics.COLOR_DK_GRAY,
            Graphics.COLOR_WHITE,
            Graphics.COLOR_WHITE
        );
    }
}
