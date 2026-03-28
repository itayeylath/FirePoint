using Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Graphics;

class FeatureDetailView extends WatchUi.View {

    var _subtitle as Lang.String;
    var _helloLine as Lang.String;
    var _backLabel as Lang.String;

    var _helloFont as Graphics.FontDefinition;
    var _subFont as Graphics.FontDefinition;
    var _backFont as Graphics.FontDefinition;

    var _helloBaselineY as Lang.Number;
    var _subBaselineY as Lang.Number;

    var _backX as Lang.Number;
    var _backY as Lang.Number;
    var _backW as Lang.Number;
    var _backH as Lang.Number;
    var _backRadius as Lang.Number;

    function initialize(subtitle as Lang.String) {
        View.initialize();
        _subtitle = subtitle;
        _helloLine = WatchUi.loadResource(Rez.Strings.HelloLabel) as Lang.String;
        _backLabel = WatchUi.loadResource(Rez.Strings.BackLabel) as Lang.String;
        _helloFont = Graphics.FONT_MEDIUM;
        _subFont = Graphics.FONT_MEDIUM;
        _backFont = Graphics.FONT_SMALL;
        _helloBaselineY = 0;
        _subBaselineY = 0;
        _backX = 0;
        _backY = 0;
        _backW = 0;
        _backH = 0;
        _backRadius = 0;
    }

    function onLayout(dc as Graphics.Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var padX = 24;
        var padY = 16;
        var minBtnH = 48;
        var maxWPct = 70;
        var bottomInset = 26;
        var wMargin = 8;

        var maxW = (width * maxWPct) / 100;
        var bfont = Graphics.FONT_SMALL;
        var bdims = dc.getTextDimensions(_backLabel, bfont);
        if (bdims == null || bdims.size() < 2) {
            _backW = 0;
            return;
        }

        var bdw = bdims[0] as Lang.Number;
        var bwp = dc.getTextWidthInPixels(_backLabel, bfont);
        var bw = bdw > bwp ? bdw : bwp;
        bw = bw + wMargin;
        var bh = bdims[1] as Lang.Number;
        var bfh = dc.getFontHeight(bfont);
        if (bfh > bh) {
            bh = bfh;
        }
        var bneedW = bw + 2 * padX;
        if (bneedW > maxW) {
            bfont = Graphics.FONT_SYSTEM_TINY;
            bdims = dc.getTextDimensions(_backLabel, bfont);
            if (bdims == null || bdims.size() < 2) {
                _backW = 0;
                return;
            }
            bdw = bdims[0] as Lang.Number;
            bwp = dc.getTextWidthInPixels(_backLabel, bfont);
            bw = bdw > bwp ? bdw : bwp;
            bw = bw + wMargin;
            bh = bdims[1] as Lang.Number;
            bfh = dc.getFontHeight(bfont);
            if (bfh > bh) {
                bh = bfh;
            }
            bneedW = bw + 2 * padX;
        }

        if (bneedW > maxW) {
            bfont = Graphics.FONT_XTINY;
            bdims = dc.getTextDimensions(_backLabel, bfont);
            if (bdims == null || bdims.size() < 2) {
                _backW = 0;
                return;
            }
            bdw = bdims[0] as Lang.Number;
            bwp = dc.getTextWidthInPixels(_backLabel, bfont);
            bw = bdw > bwp ? bdw : bwp;
            bw = bw + wMargin;
            bh = bdims[1] as Lang.Number;
            bfh = dc.getFontHeight(bfont);
            if (bfh > bh) {
                bh = bfh;
            }
            bneedW = bw + 2 * padX;
        }

        _backFont = bfont;
        _backW = bneedW;
        _backH = bh + 2 * padY;
        if (_backH < minBtnH) {
            _backH = minBtnH;
        }

        _backX = (width - _backW) / 2;
        _backY = height - _backH - bottomInset;

        var br = _backH / 2;
        if (br > _backW / 2) {
            br = _backW / 2;
        }
        _backRadius = br;

        var lineGap = 8;
        var backReserve = _backH + 40;
        var fhHello = dc.getFontHeight(_helloFont);
        var fhSub = dc.getFontHeight(_subFont);
        var blockH = fhHello + lineGap + fhSub;
        var contentTop = (height - backReserve - blockH) / 2;
        if (contentTop < 4) {
            contentTop = 4;
        }

        _helloBaselineY = contentTop + Graphics.getFontAscent(_helloFont);
        _subBaselineY = contentTop + fhHello + lineGap + Graphics.getFontAscent(_subFont);
    }

    function hitBackButton(x as Lang.Number, y as Lang.Number) as Lang.Boolean {
        if (_backW <= 0) {
            return false;
        }
        return x >= _backX && x < _backX + _backW && y >= _backY && y < _backY + _backH;
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var width = dc.getWidth();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
            width / 2,
            _helloBaselineY,
            _helloFont,
            _helloLine,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            width / 2,
            _subBaselineY,
            _subFont,
            _subtitle,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        if (_backW > 0) {
            PillUi.drawPillColored(
                dc,
                _backX,
                _backY,
                _backW,
                _backH,
                _backRadius,
                _backLabel,
                _backFont,
                Graphics.COLOR_DK_GRAY,
                Graphics.COLOR_WHITE,
                Graphics.COLOR_WHITE
            );
        }
    }
}
