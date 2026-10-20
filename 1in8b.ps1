<#
.SYNOPSIS
  1 in 8 Billion - a demographic life simulation played in the PowerShell console.

.DESCRIPTION
  You are born at random somewhere on Earth, weighted by real birth numbers.
  Live year by year, make life decisions, and see how far fate takes you.
  Port of https://github.com/nguyenngocduy0401/1in8b-clone (a clone of 1in8b.life).
  Entirely offline. All data is bundled; saves stay in the local saves folder.

.PARAMETER Lang
  Language: en (English, default), ja (Japanese) or zh (Simplified Chinese).

.PARAMETER Era
  Birth year: 'current' (system year, default), 'random' (1950 through the
  system year, inclusive) or a specific year within that range.

.PARAMETER Seed
  Seed for the random generator (reproducible lives).

.PARAMETER AutoPlay
  Headless mode: simulate one whole life with random choices and print it, no input needed.

.PARAMETER NoSave
  Do not create, change, or delete any saves or achievements.

.PARAMETER Resume
  Continue the current locally saved life.

.PARAMETER SaveDirectory
  Local save folder. Defaults to the saves folder beside this script.

.EXAMPLE
  .\1in8b.ps1
.EXAMPLE
  .\1in8b.ps1 -Lang ja -Era random
.EXAMPLE
  .\1in8b.ps1 -AutoPlay -Seed 42
#>
[CmdletBinding()]
param(
  [ValidateSet('en', 'ja', 'zh')][string]$Lang = 'en',
  [string]$Era = 'current',
  [Nullable[int]]$Seed = $null,
  [switch]$AutoPlay,
  [switch]$NoSave,
  [switch]$Resume,
  [string]$SaveDirectory = ''
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Off
if ([string]::IsNullOrWhiteSpace($SaveDirectory)) { $SaveDirectory = Join-Path $PSScriptRoot 'saves' }

# Capture parameters first: the libraries initialise script-scope variables with the same names.
$opt = @{ Lang = $Lang.ToLowerInvariant(); Era = $Era.Trim(); Seed = $Seed; AutoPlay = [bool]$AutoPlay; NoSave = [bool]$NoSave; Resume = [bool]$Resume; SaveDirectory = $SaveDirectory }

$lib = Join-Path $PSScriptRoot 'lib'
. (Join-Path $lib 'Core.ps1')
. (Join-Path $lib 'LifeTable.ps1')
. (Join-Path $lib 'Demographics.ps1')
. (Join-Path $lib 'Decisions.ps1')
. (Join-Path $lib 'Simulation.ps1')
. (Join-Path $lib 'UI.ps1')

# ---------------------------------------------------------------- headless run
function Invoke-AutoPlay([string]$era) {
  $script:Headless = $true
  $state = New-Life $era
  $c = $state.country
  W ("{0} | {1} | {2}, {3} ({4}) | Q{5} | {6}" -f $state.name.full, (Get-SexName $state.sex), (Get-PlaceName $state), (Get-CountryName $c.id), $c.id, $state.q, $state.birthYear) White
  W (T $state.log[0].text)
  $shopItems = @($script:Data.shop)
  while ($state.alive) {
    if ($state.yearsLived -ge 6 -and ($state.yearsLived % 5) -eq 0) { $state.currentFocus = (Get-Pick $script:FocusOptions).id }
    $before = $state.log.Count
    Step-Year $state
    if ($state.pendingDecision) {
      $d = $state.pendingDecision
      $ch = Read-DecisionChoice $state -Random
      [void](Invoke-Decision $state $ch)
      $state.log[0].text = @{ en = "[$($d.title.en)] $($ch.label.en) -> $($state.log[0].text.en)"; ja = "[$($d.title.ja)] $($ch.label.ja) -> $($state.log[0].text.ja)"; zh = "[$($d.title.zh)] $($ch.label.zh) -> $($state.log[0].text.zh)" }
    }
    if ($state.pendingReflection) { Invoke-Reflection $state (Read-ReflectionChoice $state -Random) }
    if ($state.alive -and (Test-Chance 0.15)) {
      $item = Get-Pick $shopItems
      if (Test-CanBuy $state $item) { [void](Invoke-ShopItem $state $item) }
    }
    $added = $state.log.Count - $before
    if ($added -le 0) { continue }
    $new = @(@($state.log)[0..($added - 1)])
    [array]::Reverse($new)
    foreach ($e in $new) { W (("[{0,3}] " -f $e.age) + (T $e.text)) (Get-LogColor $e.type) }
  }
  W ''
  Show-Death $state
  Save-PastLife $state
  return $state
}

# ---------------------------------------------------------------- interactive
function Invoke-Life([string]$era, $ResumeState = $null) {
  $state = $ResumeState
  if ($null -eq $state) {
    $state = New-Life $era
    Show-BirthCard $state
    W ''
    W ('  [Enter] ' + (L 'begin this life' 'この人生を始める' '开始这一生') + '   [R] ' + (L 'reroll' '生まれ直す' '重新出生') + '   [Q] ' + (L 'menu' 'メニュー' '菜单')) DarkCyan
    while ($true) {
      $k = Read-GameKey
      if ($k -eq 'enter') { break }
      if ($k -eq 'r') { return 'reroll' }
      if ($k -eq 'q' -or $k -eq 'esc') { return 'menu' }
    }
  }

  $auto = $false
  while ($state.alive) {
    Save-ActiveLife $state
    if ($state.pendingDecision) {
      Show-Decision $state
      $ch = Read-DecisionChoice $state
      if ($null -eq $ch) { return 'menu' }
      $text = Invoke-Decision $state $ch
      Save-ActiveLife $state
      W ''
      Write-Wrapped (T $text) Green
      Wait-AnyKey
      continue
    }
    if ($state.pendingReflection) {
      Show-Reflection $state
      $choice = Read-ReflectionChoice $state
      if ($null -eq $choice) { return 'menu' }
      Invoke-Reflection $state $choice
      continue
    }

    Show-Dashboard $state
    if ($auto) {
      W ('  ' + (L 'Auto-play: press any key to pause' '自動進行中：何かキーを押すと一時停止' '自动进行中：按任意键暂停')) Yellow
      $stopped = $false
      for ($t = 0; $t -lt 8; $t++) { Start-Sleep -Milliseconds 100; if (Test-KeyPressed) { $stopped = $true; break } }
      if ($stopped) { $auto = $false } else { Step-Year $state }
      continue
    }

    $k = Read-GameKey
    switch ($k) {
      'enter' { Step-Year $state }
      'n' { Step-Year $state }
      'd' {
        while ($state.alive -and -not $state.pendingDecision -and -not $state.pendingReflection -and $state.yearsLived -lt 115) { Step-Year $state }
      }
      'a' { $auto = $true }
      'f' { Show-Focus $state }
      's' { Show-Shop $state }
      'l' { Show-FullLog $state }
      'v' { Save-ActiveLife $state; return 'menu' }
      'q' { Save-ActiveLife $state; return 'menu' }
      'esc' { Save-ActiveLife $state; return 'menu' }
    }
  }

  Show-Death $state
  Save-PastLife $state
  Clear-ActiveLife
  W ''
  W ('  [Enter] ' + (L 'reincarnate' '次の人生へ' '转世') + '   [L] ' + (L 'read life log' '人生の記録を読む' '阅读人生记录') + '   [Q] ' + (L 'menu' 'メニュー' '菜单')) DarkCyan
  while ($true) {
    $k = Read-GameKey
    if ($k -eq 'enter' -or $k -eq 'r') { return 'reroll' }
    if ($k -eq 'l') { Show-FullLog $state; Show-Death $state; W ''; W ('  [Enter] ' + (L 'reincarnate' '次の人生へ' '转世') + '   [Q] ' + (L 'menu' 'メニュー' '菜单')) DarkCyan; continue }
    if ($k -eq 'q' -or $k -eq 'esc') { return 'menu' }
  }
}

function Select-Era {
  $currentYear = Get-SystemYear
  Clear-Screen
  Write-Banner
  W ('  ' + (L 'When are you born?' '何年に生まれますか？' '选择出生年份')) White
  W ''
  W ("  [1] $currentYear (" + (L 'current year' '今年' '今年') + ')') Cyan
  W ('  [2] ' + ((L 'Random year 1950-{0}' '1950～{0}年からランダム' '随机年份（1950—{0}）') -f $currentYear)) Cyan
  W ('  [3] ' + (L 'Choose a year' '年を指定する' '指定年份')) Cyan
  W ('  [Q] ' + (L 'back' '戻る' '返回')) DarkGray
  while ($true) {
    $k = Read-GameKey
    switch ($k) {
      '1' { return 'current' }
      'enter' { return 'current' }
      '2' { return 'random' }
      '3' {
        $y = Read-GameLine ((L 'Year (1950-{0})' '年（1950～{0}）' '年份（1950—{0}）') -f (Get-SystemYear))
        if (Test-Era $y) { return $y.Trim() }
        W ('  ' + (L 'Invalid year.' '年の指定が正しくありません。' '年份无效。')) Red
      }
      'q' { return $null }
      'esc' { return $null }
    }
  }
}

function Invoke-MainMenu {
  while ($true) {
    Clear-Screen
    Write-Banner
    W ('  ' + (L 'Every second about 4 babies are born on Earth. You cannot choose where. Roll the dice and live one life.' '地球では毎秒約4人の赤ちゃんが生まれます。生まれる場所は選べません。運に身を任せ、一つの人生を歩みましょう。' '地球上每秒约有4名婴儿出生。你无法选择出生地。掷出命运的骰子，体验一段人生。')) Gray
    W ''
    W ('  [1] ' + (L 'New life' '新しい人生' '新的人生')) Cyan
    W ('  [2] ' + (L 'Past lives archive' '過去の人生' '前世档案')) Cyan
    W ('  [3] ' + (L 'Achievements' '実績' '成就')) Cyan
    W ('  [4] ' + (L 'Language' '言語' '语言') + ": $script:Lang  (en / ja / zh)") Cyan
    W ('  [5] ' + (L 'Continue saved life' '保存した人生を続ける' '继续已保存的人生')) Cyan
    if (Test-Path -LiteralPath (Join-Path (Get-SaveDir) 'current_life.json')) {
      Write-Wrapped (L 'Starting a new life replaces the current save once you begin.' '新しい人生を始めると、進行中の保存データが置き換わります。' '开始新的人生后，将替换当前进行中的存档。') DarkGray
    }
    W ('  [Q] ' + (L 'Quit' '終了' '退出')) DarkGray
    $k = Read-GameKey
    switch ($k) {
      '1' {
        $era = Select-Era
        if ($null -ne $era) {
          do { $r = Invoke-Life $era } while ($r -eq 'reroll')
        }
      }
      'enter' { do { $r = Invoke-Life $script:StartEra } while ($r -eq 'reroll') }
      '2' { Show-PastLives }
      '3' { Show-Achievements }
      '4' { $script:Lang = switch ($script:Lang) { 'en' { 'ja' } 'ja' { 'zh' } default { 'en' } } }
      '5' {
        $saved = Read-ActiveLife
        if ($null -ne $saved) {
          $r = Invoke-Life "$($saved.birthYear)" $saved
          while ($r -eq 'reroll') { $r = Invoke-Life $script:StartEra }
        }
        else { W (L 'No saved life is available.' '続けられる保存データがありません。' '没有可继续的人生存档。') Yellow; Wait-AnyKey }
      }
      'q' { return }
      'esc' { return }
    }
  }
}

# ---------------------------------------------------------------- entry point
if (-not (Test-Era $opt.Era)) { throw "Invalid -Era '$($opt.Era)'. Use 'current', 'random' or a year between 1950 and $(Get-SystemYear)." }
$script:Lang = $opt.Lang
$script:StartEra = $opt.Era
$script:NoSave = $opt.NoSave
$script:SaveDirectory = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($opt.SaveDirectory)
if ($script:SaveDirectory -match '^\\\\') { throw 'Use a local save directory, not a network share.' }
if ($opt.AutoPlay -and $opt.Resume) { throw 'Choose either -AutoPlay or -Resume.' }
Initialize-Rng $opt.Seed
Import-GameData

$prevEncoding = [Console]::OutputEncoding
try {
  try { [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding $false } catch { }
  if ($opt.AutoPlay) { [void](Invoke-AutoPlay $opt.Era) }
  else {
    if ($opt.Resume) {
      $saved = Read-ActiveLife
      if ($null -ne $saved) {
        $r = Invoke-Life "$($saved.birthYear)" $saved
        while ($r -eq 'reroll') { $r = Invoke-Life $script:StartEra }
      }
      else { W (L 'No saved life is available.' '続けられる保存データがありません。' '没有可继续的人生存档。') Yellow }
    }
    Invoke-MainMenu
    Clear-Screen
    W (L 'Thanks for living. Goodbye!' '人生を歩んでくれてありがとう。また会いましょう！' '感谢你走过这一生。再见！') Gray
  }
}
catch [System.OperationCanceledException] {
  W (L 'Input closed. Your latest checkpoint is saved unless -NoSave is set.' '入力が終了しました。-NoSave の場合を除き、直前の進行は保存されています。' '输入已关闭。除非启用 -NoSave，最近的进度已保存。') Gray
}
finally {
  try { [Console]::OutputEncoding = $prevEncoding } catch { }
}
