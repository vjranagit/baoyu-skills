---
name: qwen-baoyu-diagram
description: Use when asked for a technical process or architecture diagram with Baoyu diagram; edit one JSON template and render the SVG through the installed Baoyu renderer.
---

# Qwen Baoyu Diagram

1. Copy `templates/content.json` to `<work>/content.json`.
2. Edit only JSON: provide a precise title, subtitle, six ordered node labels and details, and a short caveat footer.
3. Keep title/subtitle/footer to 48/80/95 characters, labels to 26, and details to 48; state sequence and security facts accurately, and verify each node's stated state at process transitions. Avoid unconditional outcome claims when results depend on conditions.
4. Run exactly `scripts/make.sh <work>/content.json <work>/output`.
5. Require the one-line JSON `status` to be `rendered`; keep `output/diagram.svg`, `output/diagram.png`, and `output/poster.png`.
6. Look at the poster and full-size PNG; confirm nodes and arrows are readable and no labels clip.
7. If text clips or order is wrong, shorten or reorder JSON values and rerun.

| Common failure | Fix |
| --- | --- |
| Missing Baoyu install | Restore `samples/09-baoyu` dependencies; retain its Baoyu renderer. |
| Missing required values | Keep six nodes and non-empty title, subtitle and footer. |
| Text is too long | Use short labels/details within the given limits and review the new PNG. |
| Invalid output | Check the renderer error; rerun and require `rendered` before delivery. |
