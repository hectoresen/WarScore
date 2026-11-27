## Design

Initialize the completion marker at ADDON_LOADED, using the presence of an existing saved table before initialization. Existing tables without a marker are treated as completed. Newly initialized tables persist an explicit false until a welcome action completes them.

Reuse Settings controls, default values, and localized refresh. Preferences apply live; both welcome buttons keep any choices made and open General. Using X or Escape leaves the welcome pending.
