#!/usr/bin/env python3
"""
Antigravity CLI Statusline (Python implementation)
Ultra-fast, readable, resilient: Never crashes, parses JSON natively,
with adaptive multi-row wrapping to guarantee zero clipping.
"""
import sys
import os
import re
import json
import subprocess

# ANSI Colors & Styles
R = "\033[0m"       # Reset
B = "\033[1m"       # Bold
D = "\033[2m"       # Dim
I = "\033[3m"       # Italic

FG_GRAY = "\033[90m"
FG_WHITE = "\033[37m"
FG_BRIGHT_RED = "\033[91m"
FG_BRIGHT_GREEN = "\033[92m"
FG_BRIGHT_YELLOW = "\033[93m"
FG_BRIGHT_BLUE = "\033[94m"
FG_BRIGHT_MAGENTA = "\033[95m"
FG_BRIGHT_CYAN = "\033[96m"
FG_BRIGHT_WHITE = "\033[97m"

NUM_COLOR = f"{FG_BRIGHT_WHITE}{B}"
DOT = f"{FG_GRAY} · {R}"

ANSI_REGEX = re.compile(r"\033\[[0-9;]*[a-zA-Z]")


def strip_ansi(s: str) -> str:
    """Strip ANSI escape sequences to compute visible terminal length."""
    return ANSI_REGEX.sub("", s)


def format_duration(seconds: float | int | None) -> str:
    if seconds is None or seconds <= 0:
        return ""
    sec = int(seconds)
    days = sec // 86400
    hours = (sec % 86400) // 3600
    mins = (sec % 3600) // 60

    if days > 0:
        return f"{days}d{hours}h" if hours > 0 else f"{days}d"
    if hours > 0:
        return f"{hours}h{mins}m" if mins > 0 else f"{hours}h"
    if mins > 0:
        return f"{mins}m"
    return f"{sec}s"


def render_context_bar(used_pct: float, exceeds_200k: bool = False) -> str:
    clamped = max(0.0, min(100.0, used_pct))
    bar_len = 10
    filled = int(clamped * bar_len / 100)
    remainder = int((clamped * bar_len) % 100)

    if exceeds_200k or clamped >= 90:
        bar_color = FG_BRIGHT_RED
    elif clamped >= 60:
        bar_color = FG_BRIGHT_YELLOW
    else:
        bar_color = FG_BRIGHT_GREEN

    blocks = []
    for i in range(bar_len):
        if i < filled:
            blocks.append("█")
        elif i == filled:
            if remainder >= 75:
                blocks.append("▓")
            elif remainder >= 50:
                blocks.append("▒")
            elif remainder >= 25:
                blocks.append("░")
            else:
                blocks.append("·")
        else:
            blocks.append("·")

    bar_str = "".join(blocks)
    warn = f" {FG_BRIGHT_RED}{B}!200k{R}" if exceeds_200k else ""
    return f"{FG_GRAY}ctx {bar_color}{bar_str} {NUM_COLOR}{clamped:.1f}%{R}{warn}"


def get_git_info(cwd: str) -> tuple[str, bool]:
    try:
        inside = subprocess.run(
            ["git", "rev-parse", "--is-inside-work-tree"],
            cwd=cwd,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=0.3,
        )
        if inside.returncode != 0:
            return "", False

        branch_proc = subprocess.run(
            ["git", "rev-parse", "--abbrev-ref", "HEAD"],
            cwd=cwd,
            capture_output=True,
            text=True,
            timeout=0.3,
        )
        branch = branch_proc.stdout.strip()
        if not branch or branch == "HEAD":
            return "", False

        dirty_proc = subprocess.run(
            ["git", "status", "--porcelain"],
            cwd=cwd,
            capture_output=True,
            text=True,
            timeout=0.3,
        )
        dirty = bool(dirty_proc.stdout.strip())
        return branch, dirty
    except Exception:
        return "", False


def pack_badges(badges: list[str], max_width: int, separator: str = DOT) -> list[str]:
    """Pack badges into lines such that each line fits within max_width."""
    lines = []
    current_line = []
    current_len = 0
    sep_len = len(strip_ansi(separator))

    for badge in badges:
        badge_len = len(strip_ansi(badge))
        if not current_line:
            current_line.append(badge)
            current_len = badge_len
        else:
            if current_len + sep_len + badge_len <= max_width:
                current_line.append(badge)
                current_len += sep_len + badge_len
            else:
                lines.append(separator.join(current_line))
                current_line = [badge]
                current_len = badge_len

    if current_line:
        lines.append(separator.join(current_line))

    return lines


def main():
    try:
        raw = sys.stdin.read()
        data = json.loads(raw) if raw.strip() else {}
    except Exception:
        data = {}

    state = data.get("agent_state") or "idle"
    used_pct = float(data.get("context_window", {}).get("used_percentage") or 0.0)

    cwd = data.get("cwd") or os.getcwd()

    # VCS Branch & Dirty
    vcs = data.get("vcs") or {}
    branch = vcs.get("branch") or ""
    dirty = bool(vcs.get("dirty", False))

    if not branch:
        branch, dirty = get_git_info(cwd)

    # Project Dir / Name
    workspace = data.get("workspace") or {}
    project_dir = workspace.get("project_dir") or cwd
    project_name = os.path.basename(project_dir.rstrip("/")) if project_dir else ""

    # Session Title
    title = data.get("conversation_title") or data.get("title") or ""
    title = str(title).strip()

    # Model
    model = data.get("model") or {}
    model_name = model.get("display_name") or ""

    # Terminal width
    cols = int(data.get("terminal_width") or 80)
    max_w = max(40, cols - 4)

    # Badges count
    artifacts = int(data.get("artifact_count") or 0)

    subagents = data.get("total_subagent_count")
    if subagents is None:
        sub_list = data.get("subagents")
        if isinstance(sub_list, list):
            subagents = len(sub_list)
        elif data.get("has_running_subagents"):
            subagents = 1
        else:
            subagents = 0
    subagents = int(subagents)

    bg_tasks = data.get("background_task_count") or data.get("task_count")
    if bg_tasks is None:
        task_list = data.get("background_tasks") or data.get("tasks")
        if isinstance(task_list, list):
            bg_tasks = len(task_list)
        else:
            bg_tasks = 0
    bg_tasks = int(bg_tasks)

    sandbox = bool(data.get("sandbox", {}).get("enabled", False))

    # Email
    email = data.get("email") or ""

    # --- Line 1 Components ---
    state_map = {
        "idle": f"{FG_BRIGHT_GREEN}{B}● READY{R}",
        "thinking": f"{FG_BRIGHT_YELLOW}{B}◆ THINKING{R}",
        "working": f"{FG_BRIGHT_CYAN}{B}⚙ WORKING{R}",
        "tool_use": f"{FG_BRIGHT_MAGENTA}{B}🔧 TOOL{R}",
    }
    state_str = state_map.get(state, f"{FG_WHITE}{B}⏳ {state.upper()}{R}")

    line1 = state_str
    if project_name:
        line1 += f"  {FG_BRIGHT_WHITE}{B}{project_name}{R}"
    if branch:
        branch_badge = (
            f"{FG_BRIGHT_RED}{branch}{FG_BRIGHT_YELLOW}*{R}"
            if dirty
            else f"{FG_BRIGHT_BLUE}{branch}{R}"
        )
        line1 += f" {FG_GRAY}╱{R} {branch_badge}"
    if title and title.lower() not in ("untitled", "(untitled)"):
        # Truncate title dynamically if it would overflow line 1
        max_title_len = max(15, cols - 70)
        disp_title = (title[:max_title_len - 1] + "…") if len(title) > max_title_len else title
        line1 += f" {FG_GRAY}╱{R} {FG_BRIGHT_YELLOW}“{disp_title}”{R}"
    if model_name:
        line1 += f" {FG_GRAY}╱{R} {FG_BRIGHT_MAGENTA}{I}{model_name}{R}"

    # Balance check: if email fits cleanly on Line 1, place it there to save Line 2 width
    email_on_l1 = False
    if email:
        email_str = f"{FG_GRAY}{email}{R}"
        sep = f" {FG_GRAY}╱{R} "
        if len(strip_ansi(line1 + sep + email_str)) <= max_w:
            line1 += sep + email_str
            email_on_l1 = True

    # Context & Exceeds 200k Tokens (Smart Zone check)
    exceeds_200k = bool(data.get("exceeds_200k_tokens", False))

    # --- Metrics Badges (Line 2 & beyond) ---
    l2_badges = [render_context_bar(used_pct, exceeds_200k)]

    # Gemini Quotas only (5h & week) with countdown timer
    quota = data.get("quota") or {}
    g5h = quota.get("gemini-5h")
    if g5h and "remaining_fraction" in g5h:
        pct_5h = float(g5h["remaining_fraction"]) * 100.0
        if pct_5h <= 15:
            c_5h = FG_BRIGHT_RED
        elif pct_5h <= 40:
            c_5h = FG_BRIGHT_YELLOW
        else:
            c_5h = FG_BRIGHT_GREEN
        time_5h = format_duration(g5h.get("reset_in_seconds"))
        time_suffix = f" {FG_GRAY}({time_5h}){R}" if time_5h else ""
        l2_badges.append(f"{FG_GRAY}5h {c_5h}{B}{pct_5h:.1f}%{R}{time_suffix}")

    g_week = quota.get("gemini-weekly")
    if g_week and "remaining_fraction" in g_week:
        pct_week = float(g_week["remaining_fraction"]) * 100.0
        if pct_week <= 15:
            c_week = FG_BRIGHT_RED
        elif pct_week <= 40:
            c_week = FG_BRIGHT_YELLOW
        else:
            c_week = FG_BRIGHT_CYAN
        time_week = format_duration(g_week.get("reset_in_seconds"))
        time_suffix = f" {FG_GRAY}({time_week}){R}" if time_week else ""
        l2_badges.append(f"{FG_GRAY}week {c_week}{B}{pct_week:.1f}%{R}{time_suffix}")

    if artifacts > 0:
        l2_badges.append(f"{FG_GRAY}artifacts {NUM_COLOR}{artifacts}{R}")
    if subagents > 0:
        l2_badges.append(f"{FG_GRAY}subagents {FG_BRIGHT_YELLOW}{B}{subagents}{R}")
    if bg_tasks > 0:
        l2_badges.append(f"{FG_GRAY}tasks {FG_BRIGHT_CYAN}{B}{bg_tasks}{R}")
    if sandbox:
        l2_badges.append(f"{FG_BRIGHT_GREEN}{B}sandbox ON{R}")

    # If email did not fit on Line 1, add it to metrics badges
    if email and not email_on_l1:
        l2_badges.append(f"{FG_GRAY}{email}{R}")

    # Pack badges into lines that strictly obey terminal width
    packed_lines = pack_badges(l2_badges, max_w)

    # --- Adaptive Layout Decision ---
    # Prefix costs: "╭─ " = 3 visible chars; "│ " separator = 3 visible chars
    PREFIX_W = 3   # "╭─ "
    SEP_W    = 3   # " │ "

    if packed_lines:
        single_line = f"{line1} {FG_GRAY}│{R} {packed_lines[0]}"
        single_vis  = PREFIX_W + len(strip_ansi(line1)) + SEP_W + len(strip_ansi(packed_lines[0]))
    else:
        single_line = line1
        single_vis  = PREFIX_W + len(strip_ansi(line1))

    if len(packed_lines) <= 1 and single_vis <= cols:
        # Fits on one physical line — no box-drawing prefix needed
        print(single_line)
    elif len(packed_lines) == 1:
        # line1 alone forces wrap
        print(f"{FG_GRAY}╭─{R} {line1}")
        print(f"{FG_GRAY}╰─{R} {packed_lines[0]}")
    else:
        print(f"{FG_GRAY}╭─{R} {line1}")
        for p in packed_lines[:-1]:
            print(f"{FG_GRAY}├─{R} {p}")
        print(f"{FG_GRAY}╰─{R} {packed_lines[-1]}")


if __name__ == "__main__":
    try:
        main()
    except Exception:
        # Guarantee zero exit status so statusline runner NEVER auto-disables
        sys.exit(0)
