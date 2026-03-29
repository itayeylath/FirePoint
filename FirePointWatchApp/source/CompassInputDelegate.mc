using Toybox.Lang;
using Toybox.WatchUi;

class CompassInputDelegate extends WatchUi.InputDelegate {

    var _view as CompassView;

    function initialize(view as CompassView) {
        InputDelegate.initialize();
        _view = view;
    }

    function onSelect() as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onBack() as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onTap(clickEvent as WatchUi.ClickEvent) as Lang.Boolean {
        var coords = clickEvent.getCoordinates();
        if (coords == null || coords.size() < 2) {
            return false;
        }
        var x = coords[0] as Lang.Number;
        var y = coords[1] as Lang.Number;

        if (_view.hitToggleButton(x, y)) {
            _view.togglePrimaryUnit();
            WatchUi.requestUpdate();
            return true;
        }
        if (_view.hitSaveButton(x, y)) {
            _view.saveCurrentBearing();
            return true;
        }
        if (_view.hitBackButton(x, y)) {
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
            return true;
        }
        return false;
    }
}
