# Repository guidance

Follow [Workstation Philosophy](docs/workstation-philosophy.md): native first,
consistent workflows, minimal complexity. Read the relevant platform guide
and existing implementation before making changes. Keep changes scoped to the
requested platform and preserve working behavior on the other platforms.
Separate verified behavior from proposed experiments; test drift detection,
installation and idempotency where applicable. Never silently replace user
configuration or remove installed tools merely to achieve uniformity.

This repository owns user configuration, reusable commands and snippets, and
advisory diagnostics. Leave package installation and desktop restore to
`installers`. Preserve shared snippet data independently of launcher UI. Run
focused tests in `tests/` and installer verification after changes.
