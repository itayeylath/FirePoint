using Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Graphics;

class HomeView extends WatchUi.View {

    var _compassLabel as Lang.String;
    var _positionLabel as Lang.String;
    var _savedLabel as Lang.String;

    var _btnX as Lang.Number;
    var _btnW as Lang.Number;
    var _btnH as Lang.Number;
    var _btnRadius as Lang.Number;
    var _rowY0 as Lang.Number;
    var _rowY1 as Lang.Number;
    var _rowY2 as Lang.Number;
    var _homeFont as Graphics.FontDefinition;

    function initialize() {
        View.initialize();
        _compassLabel = WatchUi.loadResource(Rez.Strings.CompassLabel) as Lang.String;
        _positionLabel = WatchUi.loadResource(Rez.Strings.PositionLabel) as Lang.String;
        _savedLabel = WatchUi.loadResource(Rez.Strings.SavedLabel) as Lang.String;
        _btnX = 0;
        _btnW = 0;
        _btnH = 0;
        _btnRadius = 0;
        _rowY0 = 0;
        _rowY1 = 0;
        _rowY2 = 0;
        _homeFont = Graphics.FONT_SMALL;
    }

    function getSubtitleForIndex(idx as Lang.Number) as Lang.String {
        if (idx == 0) {
            return _compassLabel;
        }
        if (idx == 1) {
            return _positionLabel;
        }
        return _savedLabel;
    }

    function onLayout(dc as Graphics.Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var padX = 24;
        var padY = 16;
        var minBtnH = 48;
        var maxWPct = 70;
        var roundBiasY = 8;
        var rowGap = 16;
        var wMargin = 8;

        var maxW = (width * maxWPct) / 100;
        var font = Graphics.FONT_SMALL;

        var dims0 = dc.getTextDimensions(_compassLabel, font);
        var dims1 = dc.getTextDimensions(_positionLabel, font);
        var dims2 = dc.getTextDimensions(_savedLabel, font);
        if (dims0 == null || dims1 == null || dims2 == null) {
            _btnW = 0;
            return;
        }
        if (dims0.size() < 2 || dims1.size() < 2 || dims2.size() < 2) {
            _btnW = 0;
            return;
        }

        var d0w = dims0[0] as Lang.Number;
        var d1w = dims1[0] as Lang.Number;
        var d2w = dims2[0] as Lang.Number;
        var w0 = dc.getTextWidthInPixels(_compassLabel, font);
        var w1 = dc.getTextWidthInPixels(_positionLabel, font);
        var w2 = dc.getTextWidthInPixels(_savedLabel, font);
        var m0 = d0w > w0 ? d0w : w0;
        var m1 = d1w > w1 ? d1w : w1;
        var m2 = d2w > w2 ? d2w : w2;
        var maxTW = m0;
        if (m1 > maxTW) {
            maxTW = m1;
        }
        if (m2 > maxTW) {
            maxTW = m2;
        }
        maxTW = maxTW + wMargin;

        var maxTH = dims0[1] as Lang.Number;
        var t1h = dims1[1] as Lang.Number;
        var t2h = dims2[1] as Lang.Number;
        if (t1h > maxTH) {
            maxTH = t1h;
        }
        if (t2h > maxTH) {
            maxTH = t2h;
        }

        var fh = dc.getFontHeight(font);
        if (fh > maxTH) {
            maxTH = fh;
        }

        var needW = maxTW + 2 * padX;
        if (needW > maxW) {
            font = Graphics.FONT_SYSTEM_TINY;
            dims0 = dc.getTextDimensions(_compassLabel, font);
            dims1 = dc.getTextDimensions(_positionLabel, font);
            dims2 = dc.getTextDimensions(_savedLabel, font);
            if (dims0 == null || dims1 == null || dims2 == null || dims0.size() < 2 || dims1.size() < 2 || dims2.size() < 2) {
                _btnW = 0;
                return;
            }
            d0w = dims0[0] as Lang.Number;
            d1w = dims1[0] as Lang.Number;
            d2w = dims2[0] as Lang.Number;
            w0 = dc.getTextWidthInPixels(_compassLabel, font);
            w1 = dc.getTextWidthInPixels(_positionLabel, font);
            w2 = dc.getTextWidthInPixels(_savedLabel, font);
            m0 = d0w > w0 ? d0w : w0;
            m1 = d1w > w1 ? d1w : w1;
            m2 = d2w > w2 ? d2w : w2;
            maxTW = m0;
            if (m1 > maxTW) {
                maxTW = m1;
            }
            if (m2 > maxTW) {
                maxTW = m2;
            }
            maxTW = maxTW + wMargin;
            maxTH = dims0[1] as Lang.Number;
            t1h = dims1[1] as Lang.Number;
            t2h = dims2[1] as Lang.Number;
            if (t1h > maxTH) {
                maxTH = t1h;
            }
            if (t2h > maxTH) {
                maxTH = t2h;
            }
            fh = dc.getFontHeight(font);
            if (fh > maxTH) {
                maxTH = fh;
            }
            needW = maxTW + 2 * padX;
        }

        if (needW > maxW) {
            font = Graphics.FONT_XTINY;
            dims0 = dc.getTextDimensions(_compassLabel, font);
            dims1 = dc.getTextDimensions(_positionLabel, font);
            dims2 = dc.getTextDimensions(_savedLabel, font);
            if (dims0 == null || dims1 == null || dims2 == null || dims0.size() < 2 || dims1.size() < 2 || dims2.size() < 2) {
                _btnW = 0;
                return;
            }
            d0w = dims0[0] as Lang.Number;
            d1w = dims1[0] as Lang.Number;
            d2w = dims2[0] as Lang.Number;
            w0 = dc.getTextWidthInPixels(_compassLabel, font);
            w1 = dc.getTextWidthInPixels(_positionLabel, font);
            w2 = dc.getTextWidthInPixels(_savedLabel, font);
            m0 = d0w > w0 ? d0w : w0;
            m1 = d1w > w1 ? d1w : w1;
            m2 = d2w > w2 ? d2w : w2;
            maxTW = m0;
            if (m1 > maxTW) {
                maxTW = m1;
            }
            if (m2 > maxTW) {
                maxTW = m2;
            }
            maxTW = maxTW + wMargin;
            maxTH = dims0[1] as Lang.Number;
            t1h = dims1[1] as Lang.Number;
            t2h = dims2[1] as Lang.Number;
            if (t1h > maxTH) {
                maxTH = t1h;
            }
            if (t2h > maxTH) {
                maxTH = t2h;
            }
            fh = dc.getFontHeight(font);
            if (fh > maxTH) {
                maxTH = fh;
            }
            needW = maxTW + 2 * padX;
        }

        _homeFont = font;
        _btnW = needW;

        _btnH = maxTH + 2 * padY;
        if (_btnH < minBtnH) {
            _btnH = minBtnH;
        }

        _btnX = (width - _btnW) / 2;

        var totalH = 3 * _btnH + 2 * rowGap;
        var startY = ((height - totalH) / 2) - roundBiasY;
        _rowY0 = startY;
        _rowY1 = startY + _btnH + rowGap;
        _rowY2 = startY + 2 * (_btnH + rowGap);

        var r = _btnH / 2;
        if (r > _btnW / 2) {
            r = _btnW / 2;
        }
        _btnRadius = r;
    }

    function hitButtonIndex(x as Lang.Number, y as Lang.Number) as Lang.Number {
        if (_btnW <= 0) {
            return -1;
        }
        if (x < _btnX || x >= _btnX + _btnW) {
            return -1;
        }
        if (y >= _rowY0 && y < _rowY0 + _btnH) {
            return 0;
        }
        if (y >= _rowY1 && y < _rowY1 + _btnH) {
            return 1;
        }
        if (y >= _rowY2 && y < _rowY2 + _btnH) {
            return 2;
        }
        return -1;
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        if (_btnW > 0) {
            PillUi.drawPill(dc, _btnX, _rowY0, _btnW, _btnH, _btnRadius, _compassLabel, _homeFont);
            PillUi.drawPill(dc, _btnX, _rowY1, _btnW, _btnH, _btnRadius, _positionLabel, _homeFont);
            PillUi.drawPill(dc, _btnX, _rowY2, _btnW, _btnH, _btnRadius, _savedLabel, _homeFont);
        }
    }
}
