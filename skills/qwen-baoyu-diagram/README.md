# Qwen Baoyu Diagram

A weak-model wrapper for local LLMs, tuned on qwen3.8-27b. It uses a compact JSON content template and the Baoyu diagram renderer.

## Install

Run `scripts/setup.sh` from this directory. Node.js and npm are required; the setup installs the skill-local Sharp dependency and invokes Bun through npm.

## Use

Copy `templates/content.json` to a work directory, edit its content, then run:

```sh
scripts/make.sh <work>/content.json <work>/output
```

Prompt pattern: “Use the qwen-baoyu-diagram skill to make an architecture/flow diagram about: <topic>. Save everything to <work>/out/.”

## Results

Best attempt: 2, overall critic score 8.2/10 (AI critic assessment, not a benchmark). Overall score history: attempt 1 — 8.0/10; attempt 2 — 8.2/10; attempt 3 — 8.0/10; attempt 4 — 5.3/10. The scores are subjective AI critic assessments, not benchmark results.

Example: [Combined-cycle power plant](examples/combined-cycle-power-plant.png).

## License

The upstream repository is MIT licensed; its license applies. This wrapper modifies the upstream Baoyu diagram skill. The upstream `LICENSE` file is at the repository root.
