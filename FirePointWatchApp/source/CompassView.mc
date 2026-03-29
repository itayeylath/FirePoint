using Toybox.Application;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Position;
using Toybox.WatchUi;

class CompassView extends WatchUi.View {

    //! true = primary line shows mils (6400 default)
    var _primaryMils as Lang.Boolean;

    var _unsupported as Lang.Boolean;
    var _headingReady as Lang.Boolean;
    var _degInt as Lang.Number;
    var _milsInt as Lang.Number;

    var _mainText as Lang.String;
    var _subText as Lang.String;

    var _titleStr as Lang.String;
    var _waitingStr as Lang.String;
    var _unavailableStr as Lang.String;
    var _saveLabel as Lang.String;
    var _backLabel as Lang.String;
    var _toggleToDegLabel as Lang.String;
    var _toggleToMilLabel as Lang.String;
    var _milSuffix as Lang.String;
    var _degSuffix as Lang.String;

    var _titleBaselineY as Lang.Number;
    var _statusBaselineY as Lang.Number;
    var _mainBaselineY as Lang.Number;
    var _subBaselineY as Lang.Number;

    var _titleFont as Graphics.FontDefinition;
    var _statusFont as Graphics.FontDefinition;
    var _mainFont as Graphics.FontDefinition;
    var _subFont as Graphics.FontDefinition;

    var _toggleX as Lang.Number;
    var _toggleY as Lang.Number;
    var _toggleW as Lang.Number;
    var _toggleH as Lang.Number;
    var _toggleR as Lang.Number;
    var _toggleFont as Graphics.FontDefinition;
    var _toggleLabel as Lang.String;

    var _saveX as Lang.Number;
    var _saveY as Lang.Number;
    var _saveW as Lang.Number;
    var _saveH as Lang.Number;
    var _saveR as Lang.Number;
    var _saveFont as Graphics.FontDefinition;

    var _backX as Lang.Number;
    var _backY as Lang.Number;
    var _backW as Lang.Number;
    var _backH as Lang.Number;
    var _backR as Lang.Number;
    var _backFont as Graphics.FontDefinition;

    function initialize() {
        View.initialize();
        _primaryMils = true;
        _unsupported = !(Toybox has :Position);
        _headingReady = false;
        _degInt = 0;
        _milsInt = 0;
        _mainText = "";
        _subText = "";

        _titleStr = WatchUi.loadResource(Rez.Strings.CompassTitle) as Lang.String;
        _waitingStr = WatchUi.loadResource(Rez.Strings.CompassWaiting) as Lang.String;
        _unavailableStr = WatchUi.loadResource(Rez.Strings.CompassUnavailable) as Lang.String;
        _saveLabel = WatchUi.loadResource(Rez.Strings.CompassSave) as Lang.String;
        _backLabel = WatchUi.loadResource(Rez.Strings.BackLabel) as Lang.String;
        _toggleToDegLabel = WatchUi.loadResource(Rez.Strings.CompassToggleToDeg) as Lang.String;
        _toggleToMilLabel = WatchUi.loadResource(Rez.Strings.CompassToggleToMil) as Lang.String;
        _milSuffix = WatchUi.loadResource(Rez.Strings.CompassMilSuffix) as Lang.String;
        _degSuffix = WatchUi.loadResource(Rez.Strings.CompassDegSuffix) as Lang.String;

        _toggleLabel = _toggleToDegLabel;

        _titleFont = Graphics.FONT_MEDIUM;
        _statusFont = Graphics.FONT_SMALL;
        _mainFont = Graphics.FONT_NUMBER_HOT;
        _subFont = Graphics.FONT_MEDIUM;

        _titleBaselineY = 0;
        _statusBaselineY = 0;
        _mainBaselineY = 0;
        _subBaselineY = 0;

        _toggleX = 0;
        _toggleY = 0;
        _toggleW = 0;
        _toggleH = 0;
        _toggleR = 0;
        _toggleFont = Graphics.FONT_SMALL;

        _saveX = 0;
        _saveY = 0;
        _saveW = 0;
        _saveH = 0;
        _saveR = 0;
        _saveFont = Graphics.FONT_SMALL;

        _backX = 0;
        _backY = 0;
        _backW = 0;
        _backH = 0;
        _backR = 0;
        _backFont = Graphics.FONT_SMALL;
    }

    function onShow() as Void {
        if (_unsupported) {
            return;
        }
        var app = Application.getApp();
        (app as FirePointWatchApp).beginCompass(self);
    }

    function onHide() as Void {
        var app = Application.getApp();
        (app as FirePointWatchApp).endCompass(self);
    }

    function applyHeadingInfo(info as Position.Info) as Void {
        if (_unsupported) {
            return;
        }
        var h = info.heading;
        if (h == null) {
            _headingReady = false;
            return;
        }
        var deg = CompassMath.radiansToDegreesInt(h);
        var mils = CompassMath.degreesToMils6400(deg);
        _degInt = deg;
        _milsInt = mils;
        _headingReady = true;
        rebuildPrimaryStrings();
    }

    function rebuildPrimaryStrings() as Void {
        if (!_headingReady) {
            return;
        }
        if (_primaryMils) {
            _mainText = _milsInt.toString() + _milSuffix;
            _subText = _degInt.toString() + _degSuffix;
        } else {
            _mainText = _degInt.toString() + _degSuffix;
            _subText = _milsInt.toString() + _milSuffix;
        }
    }

    function togglePrimaryUnit() as Void {
        _primaryMils = !_primaryMils;
        _toggleLabel = _primaryMils ? _toggleToDegLabel : _toggleToMilLabel;
        if (_headingReady) {
            rebuildPrimaryStrings();
        }
    }

    function saveCurrentBearing() as Void {
        if (!_headingReady) {
            return;
        }
        BearingStore.saveBearing(_degInt, _milsInt);
    }

    function isHeadingReady() as Lang.Boolean {
        return _headingReady;
    }

    function isUnsupported() as Lang.Boolean {
        return _unsupported;
    }

    function hitToggleButton(x as Lang.Number, y as Lang.Number) as Lang.Boolean {
        if (_toggleW <= 0) {
            return false;
        }
        return x >= _toggleX && x < _toggleX + _toggleW && y >= _toggleY && y < _toggleY + _toggleH;
    }

    function hitSaveButton(x as Lang.Number, y as Lang.Number) as Lang.Boolean {
        if (_saveW <= 0) {
            return false;
        }
        return x >= _saveX && x < _saveX + _saveW && y >= _saveY && y < _saveY + _saveH;
    }

    function hitBackButton(x as Lang.Number, y as Lang.Number) as Lang.Boolean {
        if (_backW <= 0) {
            return false;
        }
        return x >= _backX && x < _backX + _backW && y >= _backY && y < _backY + _backH;
    }

    //! Compact pill: [width, height, radius, font]. Single row, small padding, capped height.
    function measureCompactPill(
        dc as Graphics.Dc,
        label as Lang.String,
        padX as Lang.Number,
        padY as Lang.Number,
        maxH as Lang.Number
    ) as Lang.Array {
        var bfont = Graphics.FONT_XTINY;
        var bdims = dc.getTextDimensions(label, bfont);
        if (bdims == null || bdims.size() < 2) {
            return [0, 0, 0, bfont] as Lang.Array;
        }
        var bdw = bdims[0] as Lang.Number;
        var bwp = dc.getTextWidthInPixels(label, bfont);
        var tw = bdw > bwp ? bdw : bwp;
        var fh = dc.getFontHeight(bfont);
        var pillW = tw + 2 * padX;
        var pillH = fh + 2 * padY;
        if (pillH > maxH) {
            pillH = maxH;
        }
        var pr = pillH / 2;
        if (pr > pillW / 2) {
            pr = pillW / 2;
        }
        return [pillW, pillH, pr, bfont] as Lang.Array;
    }

    //! Places toggle | save | back in one horizontal row at the bottom. Returns y coordinate above the row (for compass text).
    function layoutBottomPillRow(dc as Graphics.Dc, width as Lang.Number, height as Lang.Number) as Lang.Number {
        var bottomInset = 10;
        var sidePad = 4;
        var gap = 3;
        var padX = 6;
        var padY = 3;
        var maxPillH = 28;

        var tData = measureCompactPill(dc, _toggleLabel, padX, padY, maxPillH);
        var sData = measureCompactPill(dc, _saveLabel, padX, padY, maxPillH);
        var bData = measureCompactPill(dc, _backLabel, padX, padY, maxPillH);
        var tw = tData[0] as Lang.Number;
        var th = tData[1] as Lang.Number;
        var sw = sData[0] as Lang.Number;
        var sh = sData[1] as Lang.Number;
        var bw = bData[0] as Lang.Number;
        var bh = bData[1] as Lang.Number;
        if (tw <= 0 || sw <= 0 || bw <= 0) {
            _toggleW = 0;
            _saveW = 0;
            _backW = 0;
            return height - bottomInset - 8;
        }

        var rowH = th;
        if (sh > rowH) {
            rowH = sh;
        }
        if (bh > rowH) {
            rowH = bh;
        }

        var totalPillW = tw + sw + bw + 2 * gap;
        var avail = width - 2 * sidePad;
        if (totalPillW > avail) {
            var deficit = totalPillW - avail;
            padX = padX - deficit / 6;
            if (padX < 2) {
                padX = 2;
            }
            tData = measureCompactPill(dc, _toggleLabel, padX, padY, maxPillH);
            sData = measureCompactPill(dc, _saveLabel, padX, padY, maxPillH);
            bData = measureCompactPill(dc, _backLabel, padX, padY, maxPillH);
            tw = tData[0] as Lang.Number;
            th = tData[1] as Lang.Number;
            sw = sData[0] as Lang.Number;
            sh = sData[1] as Lang.Number;
            bw = bData[0] as Lang.Number;
            bh = bData[1] as Lang.Number;
            rowH = th;
            if (sh > rowH) {
                rowH = sh;
            }
            if (bh > rowH) {
                rowH = bh;
            }
            totalPillW = tw + sw + bw + 2 * gap;
        }

        var rowY = height - bottomInset - rowH;
        if (rowY < 0) {
            rowY = 0;
        }

        var extra = avail - totalPillW;
        if (extra < 0) {
            extra = 0;
        }
        var startX = sidePad + extra / 2;

        _toggleX = startX;
        _toggleY = rowY + (rowH - th) / 2;
        _toggleW = tw;
        _toggleH = th;
        _toggleR = tData[2] as Lang.Number;
        _toggleFont = tData[3] as Graphics.FontDefinition;

        _saveX = startX + tw + gap;
        _saveY = rowY + (rowH - sh) / 2;
        _saveW = sw;
        _saveH = sh;
        _saveR = sData[2] as Lang.Number;
        _saveFont = sData[3] as Graphics.FontDefinition;

        _backX = startX + tw + gap + sw + gap;
        _backY = rowY + (rowH - bh) / 2;
        _backW = bw;
        _backH = bh;
        _backR = bData[2] as Lang.Number;
        _backFont = bData[3] as Graphics.FontDefinition;

        var marginAboveRow = 8;
        var contentBottom = rowY - marginAboveRow;
        if (contentBottom < 4) {
            contentBottom = 4;
        }
        return contentBottom;
    }

    function onLayout(dc as Graphics.Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();

        var contentBottom = layoutBottomPillRow(dc, width, height);

        var lineGap = 6;
        var fhTitle = dc.getFontHeight(_titleFont);
        var fhStatus = dc.getFontHeight(_statusFont);
        var fhMain = dc.getFontHeight(_mainFont);
        var fhSub = dc.getFontHeight(_subFont);

        //! Always reserve ready-state height so baselines stay valid when heading arrives (onLayout is not re-run).
        var mainRegionH = fhMain + lineGap + fhSub;
        var blockH = fhTitle + lineGap + mainRegionH;

        var contentTop = (contentBottom - blockH) / 2;
        if (contentTop < 4) {
            contentTop = 4;
        }

        _titleBaselineY = contentTop + Graphics.getFontAscent(_titleFont);
        var mainRegionTop = contentTop + fhTitle + lineGap;
        _mainBaselineY = mainRegionTop + Graphics.getFontAscent(_mainFont);
        _subBaselineY = mainRegionTop + fhMain + lineGap + Graphics.getFontAscent(_subFont);

        var statusOffset = (mainRegionH - fhStatus) / 2;
        if (statusOffset < 0) {
            statusOffset = 0;
        }
        _statusBaselineY = mainRegionTop + statusOffset + Graphics.getFontAscent(_statusFont);
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var width = dc.getWidth();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
            width / 2,
            _titleBaselineY,
            _titleFont,
            _titleStr,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        if (_unsupported) {
            dc.drawText(
                width / 2,
                _statusBaselineY,
                _statusFont,
                _unavailableStr,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        } else if (!_headingReady) {
            dc.drawText(
                width / 2,
                _statusBaselineY,
                _statusFont,
                _waitingStr,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        } else {
            dc.drawText(
                width / 2,
                _mainBaselineY,
                _mainFont,
                _mainText,
                Graphics.TEXT_JUSTIFY_CENTER
            );
            dc.drawText(
                width / 2,
                _subBaselineY,
                _subFont,
                _subText,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }

        if (_toggleW > 0) {
            PillUi.drawPillColored(
                dc,
                _toggleX,
                _toggleY,
                _toggleW,
                _toggleH,
                _toggleR,
                _toggleLabel,
                _toggleFont,
                Graphics.COLOR_DK_GRAY,
                Graphics.COLOR_WHITE,
                Graphics.COLOR_WHITE
            );
        }
        if (_saveW > 0) {
            PillUi.drawPillColored(
                dc,
                _saveX,
                _saveY,
                _saveW,
                _saveH,
                _saveR,
                _saveLabel,
                _saveFont,
                Graphics.COLOR_DK_GRAY,
                Graphics.COLOR_WHITE,
                Graphics.COLOR_WHITE
            );
        }
        if (_backW > 0) {
            PillUi.drawPillColored(
                dc,
                _backX,
                _backY,
                _backW,
                _backH,
                _backR,
                _backLabel,
                _backFont,
                Graphics.COLOR_DK_GRAY,
                Graphics.COLOR_WHITE,
                Graphics.COLOR_WHITE
            );
        }
    }
}
