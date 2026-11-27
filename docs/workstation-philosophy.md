# Workstation Philosophy: Native First, Consistent Experience

## Core principle

**Prefer native platform functionality over forcing identical tools onto every operating system.**

The goal is a consistent development experience, not necessarily an identical software stack.

## Guiding principles

- **Native first, not native only.** Prefer functionality already provided by the operating system or desktop environment. Introduce additional tools when they solve genuine problems.
- **Keep it simple.** Minimize unnecessary dependencies, background services, and configuration.
- **Consistency over uniformity.** Maintain familiar workflows and keyboard shortcuts, even when the underlying applications differ.
- **Share what makes sense.** Reuse cross-platform configurations, scripts, and data wherever practical.
- **Separate data, behavior, and presentation.** Keep reusable data and core functionality independent of platform-specific interfaces wherever practical.
- **Respect platform differences.** Embrace platform-specific strengths rather than working around them unnecessarily.
- **Preserve what works.** Do not disrupt established workflows simply to achieve consistency across platforms.
- **Keep changes focused.** Adding support for a new platform should not introduce unrelated changes to existing platforms.
- **Minimize maintenance.** Prefer distribution-managed packages and official installation methods.
- **Verify before automating.** Experiment on real hardware before incorporating changes into installers and dotfiles.
- **Be reproducible.** Document intentional customizations and automate them where practical.

## Platform strategy

Use the most appropriate implementation for each platform while maintaining familiar workflows.

| Function | LMDE / Cinnamon | Fedora Asahi / KDE | macOS |
| --- | --- | --- | --- |
| Application launcher | Rofi | KRunner | Spotlight |
| Clipboard history | CopyQ | Klipper (under evaluation) | CopyQ |
| Screenshots | Existing setup | Spectacle | Native screenshot tool |
| File manager | Nemo | Dolphin | Finder |
| System packages | APT | DNF | Homebrew |
| Shell | Fish | Fish | Fish |
| Terminal | Alacritty | Alacritty | Alacritty |
| Editor | Neovim | Neovim | Neovim |
| Language runtimes | Mise | Mise | Mise |
| Codex CLI | Official installer | Official installer | Official installer |
| Reusable snippets | Shared engine | Shared engine | Shared engine |

Existing LMDE and macOS preferences remain unchanged unless improvements are deliberately planned and validated separately.

## Fedora Asahi / KDE integration

KDE Plasma provides many useful desktop features out of the box.

| Function | Preferred native tool | Additional tool if needed |
| --- | --- | --- |
| Application launcher | KRunner | Rofi |
| Clipboard history | Klipper | CopyQ |
| Screenshots and annotations | Spectacle | Flameshot |
| Screen recording | Spectacle | OBS Studio |
| File management | Dolphin | Alternative file manager |
| System monitoring | Plasma System Monitor | Specialized monitoring tools |

Avoid installing third-party applications that merely duplicate satisfactory native functionality. However, native applications are not always complete replacements for specialized tools. KRunner does not directly replace Rofi's scriptable menu functionality, and Klipper does not provide all of CopyQ's scripting capabilities.

Evaluate actual workflows before adding or removing dependencies. CopyQ remains in the current Fedora manifest during evaluation; this strategy is not a claim that Klipper has already replaced it.

## Repository responsibilities

### installers

- Platform detection
- System packages and dependencies
- Platform-specific desktop integration
- Workstation bootstrapping
- Reproducible desktop settings
- Installation and verification

### dotfiles

- Shared user configuration
- Cross-platform scripts and data
- Consistent workflows and keyboard shortcuts
- Platform-aware application configuration
- Reusable snippet management
- Diagnostics and health checks

Keep system installation separate from user configuration.

## When to introduce an additional tool

Introduce a third-party tool when:

- Native functionality is insufficient.
- It provides meaningful productivity improvements.
- It works reliably on the target platform.
- Its maintenance cost is justified.
- It does not introduce unnecessary complexity.

Do not introduce a dependency merely to make different platforms look identical.

## Approach to platform support

1. Understand the platform's native capabilities.
2. Identify gaps in the desired development workflow.
3. Experiment with practical solutions on real hardware.
4. Prefer the simplest reliable implementation.
5. Incorporate verified changes into installers and dotfiles.
6. Test installation, verification, and idempotency.
7. Preserve compatibility with existing supported platforms.
8. Document known limitations and outstanding work.

## Non-goals

- Forcing identical applications onto every platform.
- Making all desktops look and behave exactly alike.
- Replacing working configurations without a clear benefit.
- Automating every available desktop preference.
- Introducing speculative support for untested tools.
- Refactoring unrelated platform configurations while adding support for a new platform.

## Desired outcome

A lightweight, reliable, maintainable, and reproducible development environment that feels familiar across operating systems while respecting their differences.

**Native first. Preserve what works. Change only what is necessary.**

**Same workflow. Appropriate implementation. Minimal complexity.**
