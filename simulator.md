# Garmin Connect IQ simulator — FirePointWatchApp

The Monkey C app project is **`FirePointWatchApp/`** at the repo root (`manifest.xml`, `monkey.jungle`, `source/`, `resources/`). Build output is written to **`FirePointWatchApp/bin/`**.

When you open the **`FirePoint`** folder in Cursor, Monkey C should use **`FirePointWatchApp/monkey.jungle`** (see `.vscode/settings.json` → `monkeyC.jungleFiles`).

**Device target:** `fr57047mm` (Forerunner 570 47 mm), matching `manifest.xml`.

---

## Run flow (terminal)

Run these from any directory; paths below are absolute.

### 1. Start the simulator

```bash
"/Users/itayeylath/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.1.0-2026-03-09-6a872a80b/bin/connectiq"
```

Wait until the simulator window is open and a device is shown.

### 2. Build the app

```bash
"/Users/itayeylath/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.1.0-2026-03-09-6a872a80b/bin/monkeyc" \
  -f "/Users/itayeylath/Desktop/dev/FirePoint/FirePointWatchApp/monkey.jungle" \
  -o "/Users/itayeylath/Desktop/dev/FirePoint/FirePointWatchApp/bin/FirePointWatchApp.prg" \
  -y "/Users/itayeylath/Desktop/dev/FirePoint/developer_key" \
  -d fr57047mm
```

### 3. Load and run the app on the simulator

```bash
"/Users/itayeylath/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.1.0-2026-03-09-6a872a80b/bin/monkeydo" \
  "/Users/itayeylath/Desktop/dev/FirePoint/FirePointWatchApp/bin/FirePointWatchApp.prg" \
  fr57047mm
```

If you see **`Unable to connect to simulator`**, wait a few seconds after step 1, then run step 3 again.

---

## Cursor / Monkey C extension

- **Build:** Command Palette → `Monkey C: Build Current Project`
- After changing SDK version, update the `connectiq-sdk-mac-...` path in the commands above to match your installed SDK folder under  
  `~/Library/Application Support/Garmin/ConnectIQ/Sdks/`.
