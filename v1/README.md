# v1 — frozen

`index.html` here is the v1.0 dome exactly as it was served before v2, byte for byte.

It is kept for rollback and comparison only. It is deliberately **not** linked from
navigation and **not** referenced by `manifest.webmanifest` or `sw.js`, so an installed
PWA is never offered two versions of the same app under one identity.

To roll back: copy `v1/index.html` over the root `index.html` and push.
