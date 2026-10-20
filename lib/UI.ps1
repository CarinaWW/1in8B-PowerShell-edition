# Console user interface: screens, menus and keyboard input. Text only, no GUI.

$script:Headless = $false

function Get-ConsoleWidth {
  try { $w = [Console]::WindowWidth; if ($w -ge 40) { return [Math]::Min($w, 120) } } catch { }
  return 100
}

function Clear-Screen { if (-not $script:Headless) { try { Clear-Host } catch { } } }

function W([string]$text = '', [ConsoleColor]$color = [ConsoleColor]::Gray, [switch]$NoNewline) {
  if ($NoNewline) { Write-Host $text -ForegroundColor $color -NoNewline }
  else { Write-Host $text -ForegroundColor $color }
}

# Console cells, including Japanese and Chinese full-width characters.
function Get-CharacterWidth([char]$character) {
  $category = [Globalization.CharUnicodeInfo]::GetUnicodeCategory($character)
  if ($category -in @([Globalization.UnicodeCategory]::NonSpacingMark, [Globalization.UnicodeCategory]::EnclosingMark)) { return 0 }
  $n = [int]$character
  if (($n -ge 0x1100 -and $n -le 0x115f) -or ($n -ge 0x2e80 -and $n -le 0xa4cf) -or
      ($n -ge 0xac00 -and $n -le 0xd7a3) -or ($n -ge 0xf900 -and $n -le 0xfaff) -or
      ($n -ge 0xfe10 -and $n -le 0xfe6f) -or ($n -ge 0xff01 -and $n -le 0xff60) -or
      ($n -ge 0xffe0 -and $n -le 0xffe6)) { return 2 }
  return 1
}

function Get-TextWidth([string]$text) {
  $width = 0
  foreach ($character in $text.ToCharArray()) { $width += Get-CharacterWidth $character }
  return $width
}

function Pad-Label([string]$label, [int]$width = 12) {
  return $label + (' ' * [Math]::Max(0, $width - (Get-TextWidth $label)))
}

# Wrap Latin words at spaces and long unspaced CJK text at character boundaries.
function Write-Wrapped([string]$text, [ConsoleColor]$color = [ConsoleColor]::Gray, [int]$indent = 2) {
  $width = [Math]::Max(2, (Get-ConsoleWidth) - $indent - 1)
  $pad = ' ' * $indent
  foreach ($para in ($text -split "`n")) {
    $line = ''
    $cells = 0
    foreach ($word in ($para -split ' ')) {
      $wordWidth = Get-TextWidth $word
      if ($cells -gt 0 -and ($cells + 1 + $wordWidth) -gt $width) {
        W ($pad + $line) $color; $line = ''; $cells = 0
      }
      if ($cells -gt 0) { $line += ' '; $cells++ }
      foreach ($character in $word.ToCharArray()) {
        $size = Get-CharacterWidth $character
        if ($cells + $size -gt $width) { W ($pad + $line) $color; $line = ''; $cells = 0 }
        $line += $character; $cells += $size
      }
    }
    W ($pad + $line) $color
  }
}

function Write-Rule([string]$title = '', [ConsoleColor]$color = [ConsoleColor]::DarkGray) {
  $w = (Get-ConsoleWidth) - 1
  if ($title) {
    $t = "== $title "
    W ($t + ('=' * [Math]::Max(3, $w - (Get-TextWidth $t)))) $color
  }
  else { W ('-' * $w) $color }
}

function Write-Banner {
  W ''
  W '  1 in 8 Billion' DarkYellow
  W ''
  W ('  ' + (L 'One life among 8 billion - a demographic life simulation' '80億人の中の一つの人生 ― 人口統計ライフシミュレーション' '八十亿人中的一生——人口统计人生模拟')) White
  W ('  ' + (L 'Data: United Nations, WHO, World Bank, UNESCO' 'データの出典：国連、WHO、世界銀行、UNESCO' '数据来源：联合国、世卫组织、世界银行、教科文组织')) DarkGray
  W ''
}

# ---------------------------------------------------------------- input
function Read-GameKey {
  if ($script:Headless) { return 'enter' }
  $line = $null
  if ([Console]::IsInputRedirected) {
    $line = [Console]::ReadLine()
  }
  else {
  try {
      $k = [Console]::ReadKey($true)
      if ($k.Key -eq [ConsoleKey]::Enter) { return 'enter' }
      if ($k.Key -eq [ConsoleKey]::Spacebar) { return 'enter' }
      if ($k.Key -eq [ConsoleKey]::Escape) { return 'esc' }
      return ([string]$k.KeyChar).ToLowerInvariant()
  }
  catch { $line = Read-Host '>' }
  }
  if ($null -eq $line) { throw [System.OperationCanceledException]::new('Input closed.') }
  if ($line.Trim() -eq '') { return 'enter' }
  return $line.Trim().Substring(0, 1).ToLowerInvariant()
}

function Wait-AnyKey {
  if ($script:Headless) { return }
  W ''
  W ('  ' + (L '[press any key]' '［何かキーを押してください］' '[按任意键]')) DarkGray
  [void](Read-GameKey)
}

function Test-KeyPressed {
  try {
    if (-not [Console]::IsInputRedirected -and [Console]::KeyAvailable) { [void][Console]::ReadKey($true); return $true }
  }
  catch { }
  return $false
}

# Read a free-text line (used for the era year)
function Read-GameLine([string]$prompt) {
  if ($script:Headless) { return '' }
  if ([Console]::IsInputRedirected) {
    W ("  {0}:" -f $prompt)
    $line = [Console]::ReadLine()
    if ($null -eq $line) { throw [System.OperationCanceledException]::new('Input closed.') }
    return $line
  }
  return (Read-Host "  $prompt")
}

# ---------------------------------------------------------------- widgets
function Get-Bar([double]$value, [int]$width = 20) {
  $v = [Math]::Max(0, [Math]::Min(100, $value))
  $filled = [int][Math]::Round($v / 100 * $width)
  return ('#' * $filled) + ('.' * ($width - $filled))
}

function Write-StatBar([string]$label, [double]$value, [ConsoleColor]$color) {
  $lbl = Pad-Label $label
  W ("  $lbl ") Gray -NoNewline
  W (Get-Bar $value) $color -NoNewline
  W (" {0,3}" -f [int][Math]::Round($value)) White
}

function Get-Quintile([int]$q) { return '[' + ('#' * $q) + ('.' * (5 - $q)) + ']' }

function Format-Money($v) { return '$' + ([double]$v).ToString('N0', [Globalization.CultureInfo]::InvariantCulture) }

function Get-LogColor([string]$type) {
  switch ($type) {
    'death' { return [ConsoleColor]::Red }
    'family' { return [ConsoleColor]::Magenta }
    'achievement' { return [ConsoleColor]::Yellow }
    'decision' { return [ConsoleColor]::Cyan }
    'reflection' { return [ConsoleColor]::DarkCyan }
    'joy' { return [ConsoleColor]::Green }
    'birth' { return [ConsoleColor]::White }
  }
  return [ConsoleColor]::Gray
}

function Get-PlaceName($state) {
  if (-not $state.urban) { return (L 'rural area' '農村地域' '乡村地区') }
  if ($state.cityNameEn) { return $state.cityNameEn }
  return $state.cityName
}

function Get-SexName([string]$sex) {
  if ($sex -eq 'M') { return (L 'Male' '男性' '男性') } else { return (L 'Female' '女性' '女性') }
}

$script:FocusOptions = @(
  @{ id = 'study'; label = @{ en = 'Study'; ja = '勉強'; zh = '学习' }; sub = @{ en = 'Smarts up, happiness slightly down'; ja = '知性が上がり、幸福が少し下がる'; zh = '提高智力，幸福略降' } }
  @{ id = 'work'; label = @{ en = 'Work & earn'; ja = '仕事・収入'; zh = '工作赚钱' }; sub = @{ en = 'Wealth up from 16; health down after 35'; ja = '16歳から資産増、35歳以降は健康低下'; zh = '16岁起增加财富，35岁后降低健康' } }
  @{ id = 'family'; label = @{ en = 'Family & friends'; ja = '家族・友人'; zh = '家人与朋友' }; sub = @{ en = 'Social and happiness up'; ja = '社交と幸福が上がる'; zh = '提高社交与幸福' } }
  @{ id = 'health'; label = @{ en = 'Health & exercise'; ja = '健康・運動'; zh = '健康与运动' }; sub = @{ en = 'Health up, 25% lower yearly death risk'; ja = '健康向上、年間死亡リスク25%減'; zh = '提高健康，年度死亡风险降低25%' } }
  @{ id = 'hobby'; label = @{ en = 'Hobbies & leisure'; ja = '趣味・余暇'; zh = '爱好与休闲' }; sub = @{ en = 'Happiness up'; ja = '幸福が上がる'; zh = '提高幸福' } }
)

function Get-FocusLabel([string]$id) {
  foreach ($f in $script:FocusOptions) { if ($f.id -eq $id) { return T $f.label } }
  return $id
}

# ---------------------------------------------------------------- screens
function Show-BirthCard($state) {
  Clear-Screen
  $c = $state.country
  Write-Rule (L 'BIRTH CERTIFICATE' '出生証明書' '出生证明') DarkYellow
  W ''
  W ("  {0}" -f $state.name.full) White
  W ("  {0}: {1}   {2}: {3}" -f (L 'Sex' '性別' '性别'), (Get-SexName $state.sex), (L 'Born' '生年' '出生年份'), $state.birthYear)
  W ("  {0}: {1}, {2} ({3})" -f (L 'Birthplace' '出生地' '出生地'), (Get-PlaceName $state), (Get-CountryName $c.id), $c.id)
  W ("  {0}: {1}  (Q{2})" -f (L 'Family wealth quintile' '家庭の所得階層' '家庭收入五等分位'), (Get-Quintile $state.q), $state.q)
  W ("  {0}: {1}" -f (L 'Religion' '宗教' '宗教'), (Get-ReligionName $state.religion))
  W ("  {0}: {1}" -f (L 'Ethnicity' '民族' '民族'), (T $state.culture.ethnicity))
  W ''
  W ('  ' + (L 'Family' '家族' '家庭')) Cyan
  $m = $state.family.mom; $d = $state.family.dad
  W ("    {0}: {1} {2}, {3}" -f (L 'Mother' '母' '母亲'), $m.age, (L 'yrs' '歳' '岁'), (Get-ParentJobName $m.job))
  if ($d.absent) { W ("    {0}: {1}" -f (L 'Father' '父' '父亲'), (L 'absent from the household' '同居していない' '不在家庭中')) DarkGray }
  else { W ("    {0}: {1} {2}, {3}" -f (L 'Father' '父' '父亲'), $d.age, (L 'yrs' '歳' '岁'), (Get-ParentJobName $d.job)) }
  W ("    {0}: {1} {2}, {3} {4}" -f (L 'Siblings' 'きょうだい' '兄弟姐妹'), $state.family.olderSiblings, (L 'older' '年上' '年长'), $state.family.youngerSiblings, (L 'younger (to come)' '年下（今後）' '年幼（将来出生）'))
  foreach ($s in $state.family.siblingList) { W ("      - {0}, {1}" -f (T $s.relation), $s.age) DarkGray }
  W ''
  W ('  ' + (L 'Culture' '文化' '文化')) Cyan
  W ("    {0}: {1}" -f (L 'Home dish' '郷土料理' '家乡菜'), (T $state.culture.dish))
  W ("    {0}: {1}" -f (L 'Popular sport' '人気のスポーツ' '热门运动'), (T $state.culture.sport))
  W ("    {0}: {1}" -f (L 'Festival' '祭り' '节日'), (T $state.culture.festival))
  W ("    {0}: {1}" -f (L 'Hobbies' '趣味' '爱好'), ((@($state.hobbies) | ForEach-Object { T $_.name }) -join ', '))
  W ''
  W ('  ' + (L 'Your country in numbers' '国を知る数字' '国家统计')) Cyan
  $lt = Get-LifeTable $c $state.sex
  W ("    {0}: {1:N1}  ({2}: {3:N1})" -f (L 'Life expectancy' '平均寿命' '预期寿命'), [double]$c.le, (L 'for you' 'あなたの場合' '你的估计值'), $lt.e0)
  W ("    {0}: {1}‰   {2}: {3}‰" -f (L 'Infant mortality' '乳児死亡率' '婴儿死亡率'), $c.im, (L 'Under-5' '5歳未満死亡率' '5岁以下死亡率'), $c.u5)
  W ("    {0}: {1}   {2}: {3}%   {4}: {5}" -f (L 'GDP/capita PPP' '1人当たりGDP（PPP）' '人均GDP（购买力平价）'), (Format-Money $c.ppp), (L 'Urban' '都市人口率' '城市人口比例'), $c.urb, (L 'Fertility' '出生率' '生育率'), $c.tfr)
  W ("    {0}: {1:P1}" -f (L 'Chance to reach 65' '65歳まで生きる確率' '活到65岁的概率'), (Get-SurvivalAtAge $c $state.sex 65))
  W ''
  W ('  ' + (L 'Born in the same second' '同じ瞬間に生まれた人々' '同一秒出生的人')) Cyan
  foreach ($p in $state.peers) {
    W ("    - {0} ({1}), {2}" -f $p.name.full, (Get-SexName $p.sex), (Get-CountryName $p.countryId))
  }
  W ''
  Write-Wrapped (T $state.log[0].text) White
}

function Show-Dashboard($state) {
  Clear-Screen
  $c = $state.country
  $age = $state.yearsLived
  $year = [int]$state.birthYear + $age
  W ("  {0}  |  {1} {2}  |  {3} {4}  |  {5}, {6}" -f $state.name.full, (L 'Age' '年齢' '年龄'), $age, (L 'Year' '西暦' '年份'), $year, (Get-PlaceName $state), (Get-CountryName $c.id)) White
  Write-Rule
  Write-StatBar (L 'Health' '健康' '健康') $state.stats.health $(if ($state.stats.health -ge 60) { 'Green' } elseif ($state.stats.health -ge 35) { 'Yellow' } else { 'Red' })
  Write-StatBar (L 'Happiness' '幸福' '幸福') $state.stats.happiness DarkYellow
  Write-StatBar (L 'Smarts' '知性' '智力') $state.stats.smarts Cyan
  Write-StatBar (L 'Social' '社交' '社交') $state.stats.social Magenta
  W ("  {0} {1}   {2}: {3}   {4}: {5}" -f (L 'Wealth' '資産' '财富').PadRight(12), (Format-Money $state.stats.wealth), (L 'Job' '職業' '职业'), (Get-JobName $state.job), (L 'Education' '学歴' '学历'), (Get-EducationName $state.stats.educationLevel))

  $fam = @()
  $fam += ("{0} {1}" -f (L 'Mother' '母' '母亲'), $(if ($state.family.mom.alive) { $state.family.mom.age } else { '†' }))
  if (-not $state.family.dad.absent) { $fam += ("{0} {1}" -f (L 'Father' '父' '父亲'), $(if ($state.family.dad.alive) { $state.family.dad.age } else { '†' })) }
  if ($state.family.partner) { $fam += (L 'Married' '既婚' '已婚') }
  if ($state.family.children.Count) { $fam += ("{0} {1}" -f $state.family.children.Count, (L 'child(ren)' '人の子ども' '名子女')) }
  if ($state.family.grandchildrenCount) { $fam += ("{0} {1}" -f $state.family.grandchildrenCount, (L 'grandchild(ren)' '人の孫' '名孙辈')) }
  if ($state.flags.pet) { $fam += (L 'a pet dog' '飼い犬' '宠物狗') }
  W ("  {0} {1}" -f (L 'Family' '家族' '家庭').PadRight(12), ($fam -join ' · '))
  $survive = Get-SurvivalAtAge $c $state.sex $age
  $remain = Get-RemainingLifeExpectancy $c $state.sex $age
  W ("  {0} {1}   {2}: {3:P0}   {4}: ~{5:N0}" -f (L 'Focus' '重点' '重点').PadRight(12), (Get-FocusLabel $state.currentFocus), (L 'Cohort still alive' '同世代の生存率' '同龄群体存活率'), $survive, (L 'Years left (avg)' '平均余命' '平均剩余寿命'), $remain) DarkGray

  Write-Rule (L 'Born in the same second' '同じ瞬間に生まれた人々' '同一秒出生的人')
  foreach ($p in $state.peers) {
    $where = Get-CountryName $p.countryId
    if ($p.alive) { W ("  + {0,-26} {1,-22} {2}" -f $p.name.full, $where, (T $p.status)) Gray }
    else { W ("  † {0,-26} {1,-22} {2} {3} - {4}" -f $p.name.full, $where, (L 'died at' '死亡年齢' '去世年龄'), $p.deathAge, (T $p.deathCause)) DarkGray }
  }

  Write-Rule (L 'Life story' '人生の物語' '人生故事')
  $n = [Math]::Min(8, $state.log.Count)
  for ($i = 0; $i -lt $n; $i++) {
    $e = $state.log[$i]
    $prefix = ("[{0,3}] " -f $e.age)
    Write-Wrapped ($prefix + (T $e.text)) (Get-LogColor $e.type) 2
  }
  if ($state.log.Count -gt 0 -and $state.log[0].fact -and $state.log[0].age -eq $age) {
    Write-Wrapped ('   i ' + (T $state.log[0].fact)) DarkGray 2
  }
  Write-Rule
  Write-Wrapped ('[Enter] ' + (L 'next year' '次の年' '下一年') + '  [D] ' + (L 'to next decision' '次の選択まで' '前往下个选择') + '  [A] ' + (L 'auto-play' '自動進行' '自动进行') + '  [F] ' + (L 'focus' '重点' '重点') + '  [S] ' + (L 'shop' '活動・買い物' '活动与商店') + '  [L] ' + (L 'log' '記録' '记录') + '  [V/Q] ' + (L 'save and return to menu' '保存してメニューへ' '保存并返回菜单')) DarkCyan
  if ($script:NoSave) { W (L '  Saving is disabled (-NoSave).' '  保存は無効です（-NoSave）。' '  存档已禁用（-NoSave）。') Yellow }
}

function Show-Decision($state) {
  $d = $state.pendingDecision
  Clear-Screen
  Write-Rule (T $d.title) Yellow
  W ''
  Write-Wrapped (T $d.body) White
  W ''
  Write-Wrapped ('i ' + (T $d.fact)) DarkGray
  W ''
  $i = 1
  foreach ($ch in $d.choices) {
    W ("  [{0}] {1}" -f $i, (T $ch.label)) Cyan
    W ("      {0}" -f (T $ch.sub)) DarkGray
    $i++
  }
  W ''
  W ('  [R] ' + (L 'let fate decide (random)' '運命に任せる（ランダム）' '交给命运（随机）')) DarkCyan
  W ('  [Q] ' + (L 'save and return to menu' '保存してメニューへ' '保存并返回菜单')) DarkGray
}

function Read-DecisionChoice($state, [switch]$Random) {
  $choices = @($state.pendingDecision.choices)
  if ($Random) { return Get-Pick $choices }
  while ($true) {
    $k = Read-GameKey
    if ($k -in @('q','v','esc')) { return $null }
    if ($k -eq 'r') { return Get-Pick $choices }
    $n = 0
    if ([int]::TryParse($k, [ref]$n) -and $n -ge 1 -and $n -le $choices.Count) { return $choices[$n - 1] }
  }
}

function Show-Reflection($state) {
  $r = $state.pendingReflection
  $q = @($r.questions)[0]
  Clear-Screen
  Write-Rule (T $r.title) DarkCyan
  W ''
  Write-Wrapped (T $r.fact) DarkGray
  W ''
  Write-Wrapped (T $q.question) White
  W ''
  $i = 1
  foreach ($o in $q.options) {
    $fx = @()
    if ($o.stat) { foreach ($p in $o.stat.PSObject.Properties) { $fx += ("{0} +{1}" -f (Get-StatName $p.Name), $p.Value) } }
    W ("  [{0}] {1}" -f $i, (T $o.label)) Cyan -NoNewline
    W ("   ({0})" -f ($fx -join ', ')) DarkGray
    $i++
  }
  W ('  [R] ' + (L 'let fate decide (random)' '運命に任せる（ランダム）' '交给命运（随机）')) DarkCyan
  W ('  [Q] ' + (L 'save and return to menu' '保存してメニューへ' '保存并返回菜单')) DarkGray
}

function Read-ReflectionChoice($state, [switch]$Random) {
  $opts = @(@($state.pendingReflection.questions)[0].options)
  if ($Random) { return Get-Pick $opts }
  while ($true) {
    $k = Read-GameKey
    if ($k -in @('q','v','esc')) { return $null }
    if ($k -eq 'r') { return Get-Pick $opts }
    $n = 0
    if ([int]::TryParse($k, [ref]$n) -and $n -ge 1 -and $n -le $opts.Count) { return $opts[$n - 1] }
  }
}

function Show-Focus($state) {
  Clear-Screen
  Write-Rule (L "This year's focus" '今年の重点' '今年的生活重点') Yellow
  W ''
  if ($state.yearsLived -lt 6) {
    Write-Wrapped (L 'Still a little one being raised by your parents. Your choice will apply, but early years mostly shape your temperament.' 'まだ親に育てられている年齢です。重点は反映されますが、幼少期は主に気質が育ちます。' '你还年幼，由父母抚养。选择仍会生效，但早年的重点主要影响气质。') DarkGray
    W ''
  }
  $i = 1
  foreach ($f in $script:FocusOptions) {
    $mark = $(if ($f.id -eq $state.currentFocus) { '*' } else { ' ' })
    W ("  [{0}]{1} {2,-22} {3}" -f $i, $mark, (T $f.label), (T $f.sub)) $(if ($mark -eq '*') { 'Yellow' } else { 'Cyan' })
    $i++
  }
  W ''
  W ('  [Esc/Q] ' + (L 'back' '戻る' '返回')) DarkGray
  while ($true) {
    $k = Read-GameKey
    if ($k -eq 'q' -or $k -eq 'esc' -or $k -eq 'enter') { return }
    $n = 0
    if ([int]::TryParse($k, [ref]$n) -and $n -ge 1 -and $n -le $script:FocusOptions.Count) {
      $state.currentFocus = $script:FocusOptions[$n - 1].id
      return
    }
  }
}

function Show-Shop($state) {
  while ($true) {
    Clear-Screen
    Write-Rule (L 'Life experiences & shop' '体験・買い物' '生活体验与商店') Green
    W ("  {0} {1}" -f (L 'Current savings:' '現在の貯蓄：' '当前积蓄：'), (Format-Money $state.stats.wealth)) White
    W ''
    $items = @($script:Data.shop)
    for ($i = 0; $i -lt $items.Count; $i++) {
      $it = $items[$i]
      $ok = Test-CanBuy $state $it
      $col = $(if ($ok) { 'Cyan' } else { 'DarkGray' })
      $tag = ''
      if ($state.yearsLived -lt $it.minAge) { $tag = ' ' + (L "($($it.minAge)+)" "（$($it.minAge)歳以上）" "（$($it.minAge)岁以上）") }
      W ("  [{0}] {1,-8} {2}{3}" -f ($i + 1), ('-' + (Format-Money (Get-ShopCost $it))), (T $it.name), $tag) $col
      W ("               {0}" -f (T $it.desc)) DarkGray
    }
    W ''
    W ('  [Esc/Q] ' + (L 'back' '戻る' '返回')) DarkGray
    $k = Read-GameKey
    if ($k -eq 'q' -or $k -eq 'esc' -or $k -eq 'enter') { return }
    $n = 0
    if ([int]::TryParse($k, [ref]$n) -and $n -ge 1 -and $n -le $items.Count) {
      if (Invoke-ShopItem $state $items[$n - 1]) { return }
      W ('  ' + (L 'Not available yet (age or savings).' '年齢または貯蓄が足りません。' '年龄或积蓄不足，暂时不可用。')) Red
      Start-Sleep -Milliseconds 900
    }
  }
}

function Show-FullLog($state) {
  $entries = @($state.log)
  [array]::Reverse($entries)
  $page = 0
  $per = 15
  try { $per = [Math]::Max(8, [Console]::WindowHeight - 6) } catch { }
  $pages = [Math]::Max(1, [Math]::Ceiling($entries.Count / $per))
  while ($true) {
    Clear-Screen
    Write-Rule ("{0}  ({1}/{2})" -f (L 'Life log' '人生の記録' '人生记录'), ($page + 1), $pages) White
    $start = $page * $per
    for ($i = $start; $i -lt [Math]::Min($start + $per, $entries.Count); $i++) {
      $e = $entries[$i]
      Write-Wrapped (("[{0,3}] " -f $e.age) + (T $e.text)) (Get-LogColor $e.type)
    }
    W ''
    W ('  [N] ' + (L 'next page' '次のページ' '下一页') + '  [P] ' + (L 'previous' '前へ' '上一页') + '  [Q] ' + (L 'back' '戻る' '返回')) DarkGray
    $k = Read-GameKey
    if ($k -eq 'n' -or $k -eq 'enter') { if ($page -lt $pages - 1) { $page++ } elseif ($k -eq 'enter') { return } }
    elseif ($k -eq 'p') { if ($page -gt 0) { $page-- } }
    else { return }
  }
}

function Show-Death($state) {
  Clear-Screen
  $c = $state.country
  $arch = Get-LifeArchetype $state
  Write-Rule (L 'IN MEMORIAM' '人生を偲んで' '人生纪念') DarkGray
  W ''
  W ("  {0}" -f $state.name.full) White
  W ("  {0} - {1}   ({2}, {3})" -f $state.birthYear, ([int]$state.birthYear + $state.yearsLived), (Get-PlaceName $state), (Get-CountryName $c.id)) Gray
  W ''
  W ("  {0}: {1} {2}" -f (L 'Lived' '生きた年数' '享年'), $state.yearsLived, (L 'years' '年' '年')) White
  W ("  {0}: {1}" -f (L 'Cause of death' '死因' '死因'), (T $state.causeOfDeath)) Red
  W ("  {0}: {1:N1} {2}" -f (L 'Country life expectancy' '国の平均寿命' '国家预期寿命'), [double]$c.le, (L 'years' '年' '年')) Gray
  W ("  {0} {1}% {2}" -f (L 'Outlived' '長生きした割合' '比你早离世的比例'), (Get-OutlivedPercentile $state), (L 'of people born with you' '同じ時代に生まれた人のうち' '同代出生者中')) Gray
  W ''
  W ("  {0} {1}" -f $arch.icon, (T $arch.title)) Yellow
  Write-Wrapped (T $arch.desc) DarkYellow 4
  W ''
  W ("  {0}: {1}   {2}: {3}   {4}: {5}" -f (L 'Job' '職業' '职业'), (Get-JobName $state.job), (L 'Education' '学歴' '学历'), (Get-EducationName $state.stats.educationLevel), (L 'Wealth' '資産' '财富'), (Format-Money $state.stats.wealth))
  W ("  {0}: {1}   {2}: {3}   {4}: {5}" -f (L 'Partner' '配偶者' '伴侣'), $(if ($state.family.partner) { (L 'yes' 'あり' '有') } else { (L 'no' 'なし' '无') }), (L 'Children' '子ども' '子女'), $state.family.children.Count, (L 'Grandchildren' '孫' '孙辈'), $state.family.grandchildrenCount)
  W ''
  if ($state.unlockedAchievements.Count) {
    W ('  ' + (L 'Achievements this life' '今回の人生の実績' '本次人生的成就')) Yellow
    foreach ($a in $script:Achievements) {
      if ($state.unlockedAchievements.Contains($a.id)) { W ("    {0} {1} - {2}" -f $a.icon, (T $a.title), (T $a.desc)) DarkYellow }
    }
    W ''
  }
  W ('  ' + (L 'The babies born in the same second' '同じ瞬間に生まれた赤ちゃんたち' '同一秒出生的婴儿们')) Cyan
  foreach ($p in $state.peers) {
    $where = Get-CountryName $p.countryId
    if ($p.alive) { W ("    + {0} ({1}) - {2} {3}, {4}" -f $p.name.full, $where, (L 'still alive at' '現在も存命、年齢' '仍然在世，年龄'), $state.yearsLived, (T $p.status)) Gray }
    else { W ("    † {0} ({1}) - {2} {3}: {4}" -f $p.name.full, $where, (L 'died at' '死亡年齢' '去世年龄'), $p.deathAge, (T $p.deathCause)) DarkGray }
  }
}

function Show-PastLives {
  while ($true) {
    Clear-Screen
    Write-Rule (L 'Past lives archive' '過去の人生' '前世档案') DarkYellow
    $lives = @(Get-PastLives)
    if ($lives.Count -eq 0) { W ('  ' + (L 'No past lives yet.' 'まだ過去の人生はありません。' '尚无前世记录。')) DarkGray }
    else {
      $total = 0
      foreach ($l in $lives) {
        $total += [int]$l.yearsLived
        $place = $(if ($l.urban) { $l.cityNameEn } else { L 'rural area' '農村地域' '乡村地区' })
        W ("  {0}  {1,-24} {2,-20} {3,4}-{4,-4} {5,3} {6}  {7}" -f $l.timestamp, $l.name, (Get-CountryName $l.countryId), $l.birthYear, ([int]$l.birthYear + [int]$l.yearsLived), $l.yearsLived, (L 'yrs' '歳' '岁'), (T $l.archetype)) Gray
        W ("        {0} · {1}" -f $place, (T $l.causeOfDeath)) DarkGray
      }
      W ''
      W ("  {0}: {1}   {2}: {3:N1}" -f (L 'Lives lived' '生きた人生の数' '经历的人生数'), $lives.Count, (L 'Average lifespan' '平均生存年数' '平均寿命'), ($total / $lives.Count)) White
    }
    W ''
    W ('  [C] ' + (L 'clear history' '履歴を消す' '清空历史') + '  [Q] ' + (L 'back' '戻る' '返回')) DarkGray
    $k = Read-GameKey
    if ($k -eq 'c') {
      W ('  ' + (L 'Delete all past lives? [Y/N]' 'すべての過去の人生を削除しますか？ [Y/N]' '删除全部前世记录？ [Y/N]')) Red
      if ((Read-GameKey) -eq 'y') { Clear-PastLives }
    }
    else { return }
  }
}

function Show-Achievements($state = $null) {
  Clear-Screen
  Write-Rule (L 'Achievements' '実績' '成就') Yellow
  $global = @(Get-GlobalAchievements)
  $count = 0
  foreach ($a in $script:Achievements) {
    $have = ($global -contains $a.id) -or ($state -and $state.unlockedAchievements.Contains($a.id))
    if ($have) { $count++ }
    W ("  {0} {1}" -f $(if ($have) { '[x]' } else { '[ ]' }), (T $a.title)) $(if ($have) { 'Yellow' } else { 'DarkGray' })
    W ("      {0}" -f (T $a.desc)) DarkGray
  }
  W ''
  W ("  {0}: {1}/{2}" -f (L 'Unlocked' '解除済み' '已解锁'), $count, $script:Achievements.Count) White
  Wait-AnyKey
}
