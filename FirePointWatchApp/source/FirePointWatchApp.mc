using Toybox.Application;
using Toybox.Lang;
using Toybox.Position;
using Toybox.WatchUi;

class FirePointWatchApp extends Application.AppBase {

    var _compassView as CompassView or Null;
    var _positionView as PositionView or Null;

    function initialize() {
        AppBase.initialize();
        _compassView = null;
        _positionView = null;
    }

    function registerCompassView(v as CompassView) as Void {
        _compassView = v;
    }

    function unregisterCompassView(v as CompassView) as Void {
        if (_compassView != null && _compassView == v) {
            _compassView = null;
        }
    }

    function registerPositionView(v as PositionView) as Void {
        _positionView = v;
    }

    function unregisterPositionView(v as PositionView) as Void {
        if (_positionView != null && _positionView == v) {
            _positionView = null;
        }
    }

    function onPosition(info as Position.Info) as Void {
        if (_compassView != null) {
            _compassView.applyHeadingInfo(info);
            WatchUi.requestUpdate();
        } else if (_positionView != null) {
            _positionView.applyPositionInfo(info);
            WatchUi.requestUpdate();
        }
    }

    function beginCompass(compass as CompassView) as Void {
        registerCompassView(compass);
        if (Toybox has :Position) {
            Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        }
    }

    function endCompass(compass as CompassView) as Void {
        unregisterCompassView(compass);
        if (Toybox has :Position) {
            Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        }
    }

    function beginPosition(posView as PositionView) as Void {
        registerPositionView(posView);
        if (Toybox has :Position) {
            Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        }
    }

    function endPosition(posView as PositionView) as Void {
        unregisterPositionView(posView);
        if (Toybox has :Position) {
            Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        }
    }

    function getInitialView() {
        var homeView = new HomeView();
        return [ homeView, new HomeInputDelegate(homeView) ];
    }
}
