# Run manual scenarios on a T3 Code device

A **device scenario** is a `manual` scenario that an iOS Simulator or an Android Emulator can run. With the T3 Code device tools, you run it instead of the user.

1. Call `device_list`. If it reports that agent device access is off, stop. Tell the user to turn on **Settings → Integrations → Devices → Agent device access** and start a new session, because the setting applies only to new sessions.
2. Pick each platform that the app targets. Do not run a scenario on a platform that the app does not target.
3. If a `manual` scenario needs physical hardware, such as signing on a real device, leave it `NEEDS_HUMAN`. Name the device.
4. If a target platform is unavailable, leave its scenarios `NEEDS_HUMAN` with the reason from `device_list`.
5. Build the app. Install it on the device.
6. Call `device_open`. Follow the T3 Code device rules in your system prompt.
7. Run the `Steps:` of each device scenario. Compare the screen with each `Then` and `And` line.
8. If a device scenario fails before `code-review`, fix the cause. Commit the fix, and run the scenario again.
9. In the Test column of the results table, write `device: <device name>`.

**Done when:** each device scenario has `PASS` or `FAIL`, and each other `manual` scenario has `NEEDS_HUMAN` and the device that it needs.
