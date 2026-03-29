using Toybox.Application;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Position;
using Toybox.WatchUi;

class PositionView extends WatchUi.View {

    var _unsupported as Lang.Boolean;
    var _gpsUnavailable as Lang.Boolean;
    var _loc as Position.Location or Null;

    var _format as Lang.Number;

    var _mainLine as Lang.String;
    var _altLine as Lang.String;

    var _saveLat as Lang.Float;
    var _saveLon as Lang.Float;
    var _saveLatLonStr as Lang.String;
    var _saveMgrs as Lang.String or Null;
    var _saveAlt as Lang.Float or Null;

    var _titleStr as Lang.String;
    var _waitingStr as Lang.String;
    var _unavailableStr as Lang.String;
    var _mgrsUnavailableStr as Lang.String;
    var _utmUnavailableStr as Lang.String;
    var _nextLabel as Lang.String;
    var _saveLabel as Lang.String;
    var _backLabel as Lang.String;
    var _altPrefix as Lang.String;
    var _altMetersSuffix as Lang.String;
    var _altNone as Lang.String;

    var _titleBaselineY as Lang.Number;
    var _statusBaselineY as Lang.Number;
    var _mainBaselineY as Lang.Number;
    var _altBaselineY as Lang.Number;

    var _titleFont as Graphics.FontDefinition;
    var _statusFont as Graphics.FontDefinition;
    var _mainFont as Graphics.FontDefinition;
    var _altFont as Graphics.FontDefinition;

    var _nextX as Lang.Number;
    var _nextY as Lang.Number;
    var _nextW as Lang.Number;
    var _nextH as Lang.Number;
    var _nextR as Lang.Number;
    var _nextFont as Graphics.FontDefinition;

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

    var _layoutBackOnly as Lang.Boolean;

    function initialize() {
        View.initialize();
        _unsupported = !(Toybox has :Position);
        _gpsUnavailable = false;
        _loc = null;
        _format = PositionFormat.MGRS;

        _mainLine = "";
        _altLine = "";

        _saveLat = 0.0f;
        _saveLon = 0.0f;
        _saveLatLonStr = "";
        _saveMgrs = null;
        _saveAlt = null;

        _titleStr = WatchUi.loadResource(Rez.Strings.PositionScreenTitle) as Lang.String;
        _waitingStr = WatchUi.loadResource(Rez.Strings.PositionWaitingGps) as Lang.String;
        _unavailableStr = WatchUi.loadResource(Rez.Strings.PositionUnavailable) as Lang.String;
        _mgrsUnavailableStr = WatchUi.loadResource(Rez.Strings.PositionMgrsUnavailable) as Lang.String;
        _utmUnavailableStr = WatchUi.loadResource(Rez.Strings.PositionUtmUnavailable) as Lang.String;
        _nextLabel = WatchUi.loadResource(Rez.Strings.PositionNextFormat) as Lang.String;
        _saveLabel = WatchUi.loadResource(Rez.Strings.PositionSave) as Lang.String;
        _backLabel = WatchUi.loadResource(Rez.Strings.BackLabel) as Lang.String;
        _altPrefix = WatchUi.loadResource(Rez.Strings.PositionAltPrefix) as Lang.String;
        _altMetersSuffix = WatchUi.loadResource(Rez.Strings.PositionAltMeters) as Lang.String;
        _altNone = WatchUi.loadResource(Rez.Strings.PositionAltNone) as Lang.String;

        _titleFont = Graphics.FONT_MEDIUM;
        _statusFont = Graphics.FONT_SMALL;
        _mainFont = Graphics.FONT_SMALL;
        _altFont = Graphics.FONT_SYSTEM_TINY;

        _titleBaselineY = 0;
        _statusBaselineY = 0;
        _mainBaselineY = 0;
        _altBaselineY = 0;

        _nextX = 0;
        _nextY = 0;
        _nextW = 0;
        _nextH = 0;
        _nextR = 0;
        _nextFont = Graphics.FONT_XTINY;

        _saveX = 0;
        _saveY = 0;
        _saveW = 0;
        _saveH = 0;
        _saveR = 0;
        _saveFont = Graphics.FONT_XTINY;

        _backX = 0;
        _backY = 0;
        _backW = 0;
        _backH = 0;
        _backR = 0;
        _backFont = Graphics.FONT_XTINY;

        _layoutBackOnly = false;
    }

    function onShow() as Void {
        if (_unsupported) {
            return;
        }
        var app = Application.getApp();
        (app as FirePointWatchApp).beginPosition(self);
        var snap = Position.getInfo();
        if (snap != null) {
            applyPositionInfo(snap);
        }
    }

    function onHide() as Void {
        var app = Application.getApp();
        (app as FirePointWatchApp).endPosition(self);
    }

    function applyPositionInfo(info as Position.Info) as Void {
        if (_unsupported) {
            return;
        }

        var acc = info.accuracy;
        if (acc != null && acc == Position.QUALITY_NOT_AVAILABLE) {
            _gpsUnavailable = true;
            _loc = null;
            clearFixCaches();
            return;
        }
        _gpsUnavailable = false;

        var pos = info.position;
        if (pos == null) {
            _loc = null;
            clearFixCaches();
            return;
        }

        _loc = pos;
        var deg = pos.toDegrees();
        if (deg != null && deg.size() >= 2) {
            _saveLat = deg[0] as Lang.Float;
            _saveLon = deg[1] as Lang.Float;
        }
        _saveLatLonStr = PositionFormatHelper.formatLatLon(pos);
        _saveMgrs = PositionFormatHelper.formatMgrs(pos);
        _saveAlt = info.altitude;

        rebuildAltLine();
        rebuildDisplayedMainLine();
    }

    function clearFixCaches() as Void {
        _saveLatLonStr = "";
        _saveMgrs = null;
        _saveAlt = null;
        _mainLine = "";
        _altLine = _altPrefix + _altNone;
    }

    function rebuildAltLine() as Void {
        if (_saveAlt == null) {
            _altLine = _altPrefix + _altNone;
        } else {
            _altLine = _altPrefix + _saveAlt.toString() + _altMetersSuffix;
        }
    }

    function rebuildDisplayedMainLine() as Void {
        if (_loc == null) {
            _mainLine = "";
            return;
        }
        if (_format == PositionFormat.UTM) {
            _mainLine = _utmUnavailableStr;
            return;
        }
        if (_format == PositionFormat.MGRS) {
            if (_saveMgrs != null) {
                _mainLine = _saveMgrs as Lang.String;
            } else {
                _mainLine = _mgrsUnavailableStr;
            }
            return;
        }
        _mainLine = _saveLatLonStr;
    }

    function cycleFormat() as Void {
        _format = _format + 1;
        if (_format >= PositionFormat.MODE_COUNT) {
            _format = 0;
        }
        rebuildDisplayedMainLine();
    }

    function saveCurrentPoint() as Void {
        if (_loc == null) {
            return;
        }
        PointStore.savePoint(_saveLat, _saveLon, _saveLatLonStr, _saveMgrs, _saveAlt);
    }

    function isReady() as Lang.Boolean {
        return _loc != null;
    }

    function isScreenBad() as Lang.Boolean {
        return _unsupported || _gpsUnavailable;
    }

    function hitNextButton(x as Lang.Number, y as Lang.Number) as Lang.Boolean {
        if (_nextW <= 0) {
            return false;
        }
        return x >= _nextX && x < _nextX + _nextW && y >= _nextY && y < _nextY + _nextH;
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

    function layoutBottomPillRow(dc as Graphics.Dc, width as Lang.Number, height as Lang.Number) as Lang.Number {
        var bottomInset = 10;
        var sidePad = 4;
        var gap = 3;
        var padX = 6;
        var padY = 3;
        var maxPillH = 28;

        var nData = measureCompactPill(dc, _nextLabel, padX, padY, maxPillH);
        var sData = measureCompactPill(dc, _saveLabel, padX, padY, maxPillH);
        var bData = measureCompactPill(dc, _backLabel, padX, padY, maxPillH);
        var nw = nData[0] as Lang.Number;
        var nh = nData[1] as Lang.Number;
        var sw = sData[0] as Lang.Number;
        var sh = sData[1] as Lang.Number;
        var bw = bData[0] as Lang.Number;
        var bh = bData[1] as Lang.Number;
        if (nw <= 0 || sw <= 0 || bw <= 0) {
            _nextW = 0;
            _saveW = 0;
            _backW = 0;
            return height - bottomInset - 8;
        }

        var rowH = nh;
        if (sh > rowH) {
            rowH = sh;
        }
        if (bh > rowH) {
            rowH = bh;
        }

        var totalPillW = nw + sw + bw + 2 * gap;
        var avail = width - 2 * sidePad;
        if (totalPillW > avail) {
            var deficit = totalPillW - avail;
            padX = padX - deficit / 6;
            if (padX < 2) {
                padX = 2;
            }
            nData = measureCompactPill(dc, _nextLabel, padX, padY, maxPillH);
            sData = measureCompactPill(dc, _saveLabel, padX, padY, maxPillH);
            bData = measureCompactPill(dc, _backLabel, padX, padY, maxPillH);
            nw = nData[0] as Lang.Number;
            nh = nData[1] as Lang.Number;
            sw = sData[0] as Lang.Number;
            sh = sData[1] as Lang.Number;
            bw = bData[0] as Lang.Number;
            bh = bData[1] as Lang.Number;
            rowH = nh;
            if (sh > rowH) {
                rowH = sh;
            }
            if (bh > rowH) {
                rowH = bh;
            }
            totalPillW = nw + sw + bw + 2 * gap;
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

        _nextX = startX;
        _nextY = rowY + (rowH - nh) / 2;
        _nextW = nw;
        _nextH = nh;
        _nextR = nData[2] as Lang.Number;
        _nextFont = nData[3] as Graphics.FontDefinition;

        _saveX = startX + nw + gap;
        _saveY = rowY + (rowH - sh) / 2;
        _saveW = sw;
        _saveH = sh;
        _saveR = sData[2] as Lang.Number;
        _saveFont = sData[3] as Graphics.FontDefinition;

        _backX = startX + nw + gap + sw + gap;
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

    function layoutBackOnlyRow(dc as Graphics.Dc, width as Lang.Number, height as Lang.Number) as Lang.Number {
        _nextW = 0;
        _saveW = 0;

        var bottomInset = 10;
        var padX = 16;
        var padY = 3;
        var maxPillH = 28;
        var bData = measureCompactPill(dc, _backLabel, padX, padY, maxPillH);
        var bw = bData[0] as Lang.Number;
        var bh = bData[1] as Lang.Number;
        if (bw <= 0) {
            _backW = 0;
            return height - bottomInset - 8;
        }
        var rowY = height - bottomInset - bh;
        if (rowY < 0) {
            rowY = 0;
        }
        _backX = (width - bw) / 2;
        _backY = rowY;
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

        _layoutBackOnly = isScreenBad();
        var contentBottom = 0;
        if (_layoutBackOnly) {
            contentBottom = layoutBackOnlyRow(dc, width, height);
        } else {
            contentBottom = layoutBottomPillRow(dc, width, height);
        }

        var lineGap = 6;
        var fhTitle = dc.getFontHeight(_titleFont);
        var fhStatus = dc.getFontHeight(_statusFont);
        var fhMain = dc.getFontHeight(_mainFont);
        var fhAlt = dc.getFontHeight(_altFont);

        var mainRegionH = 0;
        if (_layoutBackOnly) {
            mainRegionH = fhStatus;
        } else {
            //! Reserve ready-state height so baselines stay valid when a GPS fix arrives (onLayout is not re-run).
            mainRegionH = fhMain + lineGap + fhAlt;
        }

        var blockH = fhTitle + lineGap + mainRegionH;
        var contentTop = (contentBottom - blockH) / 2;
        if (contentTop < 4) {
            contentTop = 4;
        }

        _titleBaselineY = contentTop + Graphics.getFontAscent(_titleFont);

        if (_layoutBackOnly) {
            var stTop = contentTop + fhTitle + lineGap;
            var stOff = (mainRegionH - fhStatus) / 2;
            if (stOff < 0) {
                stOff = 0;
            }
            _statusBaselineY = stTop + stOff + Graphics.getFontAscent(_statusFont);
        } else {
            var mTop = contentTop + fhTitle + lineGap;
            _mainBaselineY = mTop + Graphics.getFontAscent(_mainFont);
            _altBaselineY = mTop + fhMain + lineGap + Graphics.getFontAscent(_altFont);
            var wOff = (mainRegionH - fhStatus) / 2;
            if (wOff < 0) {
                wOff = 0;
            }
            _statusBaselineY = mTop + wOff + Graphics.getFontAscent(_statusFont);
        }
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

        if (_layoutBackOnly) {
            dc.drawText(
                width / 2,
                _statusBaselineY,
                _statusFont,
                _unavailableStr,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        } else if (_loc == null) {
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
                _mainLine,
                Graphics.TEXT_JUSTIFY_CENTER
            );
            dc.drawText(
                width / 2,
                _altBaselineY,
                _altFont,
                _altLine,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }

        if (_nextW > 0) {
            PillUi.drawPillColored(
                dc,
                _nextX,
                _nextY,
                _nextW,
                _nextH,
                _nextR,
                _nextLabel,
                _nextFont,
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
