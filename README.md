# 1 in 8 Billion — PowerShell edition

上班摸魚用的自作學習版，請支持正版https://1in8b.life/ 。（NT$90即可開通珍藏通行證）
無需聯網，無圖形界面，僅在powershell中游玩。

A text-only life simulation for Windows PowerShell 5.1 or PowerShell 7. English, Japanese, and Simplified Chinese are included. There is no GUI, browser, image, installer, or external dependency.

The game runs completely offline. All data is bundled in `data/`. It never checks for updates, downloads files, or calls an online service. New lives default to the computer's current year. Random and custom birth years range from 1950 through the current system year, inclusive. The demographic figures remain a fixed game dataset based around 2024; choosing an earlier year adjusts the simulation locally, while later years use the fixed baseline. Place and personal names may retain their original spelling or Latin transcription.

## Play

Open PowerShell and run:

```powershell
cd D:\work\psg\1in8b
.\1in8b.ps1 -Lang en
.\1in8b.ps1 -Lang ja
.\1in8b.ps1 -Lang zh
```

Run one language command at a time. If Windows blocks scripts, use this command for that process:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File D:\work\psg\1in8b\1in8b.ps1 -Lang ja
```

You can also run `.\Play.cmd en`, `.\Play.cmd ja`, or `.\Play.cmd zh` from a terminal. The launcher does not change your permanent execution policy.

## Controls

| Key | Action |
| --- | --- |
| Enter / Space / N | Advance one year |
| 1–9 | Choose a numbered option |
| D | Advance to the next decision or reflection |
| A | Auto-advance; press any key to pause |
| F | Choose this year's focus |
| S | Experiences and shop |
| L | Read the life log |
| R at a decision | Choose randomly |
| V / Q / Escape during a life | Save and return to the menu |
| 5 in the menu | Continue the saved life |
| 4 in the menu | Switch English → Japanese → Chinese |
| Q in the menu | Quit |

On a log, focus, or shop screen, Q goes back to the life. At a birth card you can reroll before committing to a new life. Starting a new life replaces the current checkpoint after you accept the birth card.

## Local saves

Progress saves automatically at playable checkpoints and after decisions. Use V or Q to save and return to the menu, then Q again to exit. Resume with menu option 5 or:

```powershell
.\1in8b.ps1 -Lang zh -Resume
```

All saves stay beside the game in `D:\work\psg\1in8b\saves`:

- `current_life.json`: the current life, including pending choices, family, stats, and log.
- `past_lives.json`: the most recent 50 completed lives.
- `achievements.json`: achievements earned across lives.

Copy this folder to back up the game. Save data contains JSON only; choice handlers are restored from the bundled game code. You can resume in another language. `-SaveDirectory 'D:\another-local-folder'` selects a different local folder. `-NoSave` disables all save writes and deletions.

## Other options

```powershell
# Use the system year, a historical year, or a random year from 1950 through the system year
.\1in8b.ps1 -Lang en -Era current
.\1in8b.ps1 -Lang en -Era 1970
.\1in8b.ps1 -Lang ja -Era random

# Simulate a complete life without input or save changes
.\1in8b.ps1 -Lang zh -AutoPlay -Seed 42 -NoSave

# Run the offline regression checks; no test framework is required
.\tests\Test-Game.ps1
```

`-Seed` makes a fresh simulation repeatable with the same era and PowerShell runtime. For `current` and `random`, the system year must also match. Resuming restores the life state and starts a new random sequence for future events.

The simulation includes births weighted by country data, life stages, education and career choices, family, annual focus, activities, reflections, peers born in the same second, achievements, and an end-of-life summary. Incomplete scraped events have been replaced with complete localized events and explicit eligibility rules.

## 日本語

` .\1in8b.ps1 -Lang ja ` で開始します。画面は文字だけで、インターネット接続も追加のダウンロードも不要です。データは固定されています。プレイ中に V または Q で保存してメニューに戻り、メニューの 5 または `-Resume` で再開します。保存先はゲームフォルダー内の `saves` です。

## 中文

运行 ` .\1in8b.ps1 -Lang zh ` 开始游戏。全程纯文字，完全离线，不更新数据，不下载任何文件。游戏中按 V 或 Q 保存并返回菜单，选择菜单 5 或使用 `-Resume` 继续。存档保存在游戏目录下的 `saves` 文件夹。

## Attribution

Programming by gpt-6.1-sol.

## Notice of Infringement

If any content in this repository inadvertently infringes upon your rights, please open an Issue. I will review and address the matter promptly by removing or modifying the content.
