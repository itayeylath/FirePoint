# FirePoint

**FirePoint** is a [Garmin Connect IQ](https://developer.garmin.com/connect-iq/overview/) **watch app** written in Monkey C. It is aimed at quick field use: bearings, position, and saved readings on the wrist.

## What the app does

- **Home** — Three main actions: open **Compass**, **Position**, and **Saved** items.
- **Compass** — Shows device heading when available, with a toggle between **degrees** and **mils** (6400 mil style). You can **save** a bearing for later.
- **Position / saved flows** — The app uses **Positioning** (see `manifest.xml`) so location-related features can work on supported devices; real hardware may behave differently from the simulator.

The codebase splits **sensor handling**, **math/conversion**, **persistence**, and **UI** into separate modules where possible. User-visible text lives in `FirePointWatchApp/resources/strings.xml` rather than hardcoded in source files.

## How to contribute

1. **Prerequisites** — Install the **Connect IQ SDK** and set up a **developer key** (Garmin’s docs cover this). You need the Monkey C toolchain (`monkeyc`, simulator, `monkeydo`).
2. **Project root** — The app lives under **`FirePointWatchApp/`** (`manifest.xml`, `monkey.jungle`, `source/`, `resources/`). Build output goes to `FirePointWatchApp/bin/`.
3. **Build and run** — Use the Monkey C extension in your editor (e.g. “Build Current Project”) or follow the step-by-step commands in **[simulator.md](simulator.md)** (simulator path and device id may need to match your machine and `manifest.xml`).
4. **Before you open a PR**
   - Add or change **permissions** in `manifest.xml` when a feature needs them.
   - Add **strings** in `resources/strings.xml` for any new UI copy.
   - Prefer **small, focused changes**; avoid drive-by refactors unrelated to the fix or feature.
   - Test on the **simulator** and, when you can, on a **real watch** that matches a product id in `manifest.xml`.

If you are unsure about scope, open an issue or draft PR and describe the behavior you want; maintainers can help align it with watch-app constraints (memory, sensors, and screen shapes).
