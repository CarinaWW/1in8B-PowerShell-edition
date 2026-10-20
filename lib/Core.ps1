# Core helpers: random numbers, math utilities, localisation and data loading.
# Port of src/engine/ (original repo) random.js plus small shared helpers.

$script:Rng = New-Object System.Random
$script:Lang = 'en'
$script:DataDir = Join-Path (Split-Path $PSScriptRoot -Parent) 'data'
# The bundled demographic baseline stays fixed when the system year advances.
$script:DataYear = 2024

function Get-SystemYear { return [DateTime]::Now.Year }

function Test-Era([string]$era) {
  if ($era -in @('current', 'random')) { return $true }
  $year = 0
  return ([int]::TryParse($era, [ref]$year) -and $year -ge 1950 -and $year -le (Get-SystemYear))
}

function Resolve-BirthYear([string]$era = 'current') {
  if (-not (Test-Era $era)) {
    throw "Invalid -Era '$era'. Use 'current', 'random' or a year between 1950 and $(Get-SystemYear)."
  }
  if ($era -eq 'current') { return (Get-SystemYear) }
  if ($era -eq 'random') { return (Get-RandomInt 1950 (Get-SystemYear)) }
  return [int]$era
}

function Initialize-Rng([Nullable[int]]$Seed) {
  if ($null -ne $Seed) { $script:Rng = New-Object System.Random ([int]$Seed) }
  else { $script:Rng = New-Object System.Random }
}

function Get-Rnd { return $script:Rng.NextDouble() }

function Get-Clamp([double]$v, [double]$min, [double]$max) {
  return [Math]::Min([Math]::Max($v, $min), $max)
}

# JavaScript Math.round semantics (half rounds up), unlike .NET banker's rounding.
function Get-JsRound([double]$v) { return [Math]::Floor($v + 0.5) }

function Get-RandomInt([int]$min, [int]$max) {
  return [int]([Math]::Floor((Get-Rnd) * ($max - $min + 1)) + $min)
}

function Test-Chance([double]$prob) { return ((Get-Rnd) -lt $prob) }

function Get-Pick($array) {
  $a = @($array)
  if ($a.Count -eq 0) { return $null }
  return $a[[int][Math]::Floor((Get-Rnd) * $a.Count)]
}

function Get-WeightedPick($items, $weights) {
  $items = @($items); $weights = @($weights)
  $total = 0.0
  foreach ($w in $weights) { $total += [double]$w }
  $r = (Get-Rnd) * $total
  for ($i = 0; $i -lt $items.Count; $i++) {
    if ($r -lt $weights[$i]) { return $items[$i] }
    $r -= $weights[$i]
  }
  return $items[$items.Count - 1]
}

# weightsObj: ordered dictionary key -> weight
function Get-WeightedPickKey($weightsObj) {
  $keys = @($weightsObj.Keys)
  return Get-WeightedPick $keys @($keys | ForEach-Object { $weightsObj[$_] })
}

# Localised text: accepts an en/ja/zh record or a plain string.
function T($o) {
  if ($null -eq $o) { return '' }
  if ($o -is [string]) { return $o }
  $v = $o.($script:Lang)
  if (-not $v) { $v = $o.en }
  if (-not $v) { return '' }
  return [string]$v
}

# Pick a literal by current language: L 'English' '日本語' '中文'
function L([string]$en, [string]$ja, [string]$zh) {
  switch ($script:Lang) {
    'ja' { if ($ja) { return $ja } }
    'zh' { if ($zh) { return $zh } }
  }
  return $en
}

function Read-JsonFile([string]$name) {
  $path = Join-Path $script:DataDir $name
  return (Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json)
}

function Import-GameData {
  $script:Data = @{
    countries   = @(Read-JsonFile 'countries.json')
    names       = Read-JsonFile 'names.json'
    citiesEn    = Read-JsonFile 'cities_en.json'
    countryEn   = Read-JsonFile 'country_en.json'
    countryJa   = Read-JsonFile 'country_ja.json'
    countryZh   = Read-JsonFile 'country_zh.json'
    eras        = Read-JsonFile 'eras.json'
    dishes      = Read-JsonFile 'dishes.json'
    festivals   = Read-JsonFile 'festivals.json'
    hobbies     = Read-JsonFile 'hobbies.json'
    ethnicities = Read-JsonFile 'ethnicities.json'
    events      = @(Read-JsonFile 'events.json')
    reflections = Read-JsonFile 'reflections.json'
    shop        = @(Read-JsonFile 'shop.json')
  }
  $script:CountryById = @{}
  foreach ($c in $script:Data.countries) { $script:CountryById[$c.id] = $c }
}

# Shallow copy of a country record (PSCustomObject) into a hashtable so it can be calibrated.
function Copy-Country($c) {
  $h = @{}
  foreach ($p in $c.PSObject.Properties) { $h[$p.Name] = $p.Value }
  return $h
}

function Get-CountryName([string]$id) {
  $map = switch ($script:Lang) { 'ja' { $script:Data.countryJa } 'zh' { $script:Data.countryZh } default { $script:Data.countryEn } }
  if ($map.$id) { return $map.$id }
  return $id
}

function Get-ReligionName([string]$code) {
  $map = @{
    C = @{ ja = 'キリスト教'; en = 'Christianity'; zh = '基督教' }
    M = @{ ja = 'イスラム教'; en = 'Islam'; zh = '伊斯兰教' }
    H = @{ ja = 'ヒンドゥー教'; en = 'Hinduism'; zh = '印度教' }
    B = @{ ja = '仏教'; en = 'Buddhism'; zh = '佛教' }
    J = @{ ja = 'ユダヤ教'; en = 'Judaism'; zh = '犹太教' }
    N = @{ ja = '無宗教'; en = 'No Religion'; zh = '无宗教信仰' }
    F = @{ ja = '民間・伝統信仰'; en = 'Folk / Traditional faith'; zh = '民间或传统信仰' }
    S = @{ ja = 'シク教'; en = 'Sikhism'; zh = '锡克教' }
    O = @{ ja = 'その他の宗教'; en = 'Other religion'; zh = '其他宗教' }
  }
  if ($map.ContainsKey($code)) { return T $map[$code] }
  return (L 'None' 'なし' '无')
}

# The original engine stores job titles as Vietnamese strings; translate them for display.
$script:JobNames = @{
  'Infant'                         = @{ en = 'Infant'; ja = '乳児'; zh = '婴儿' }
  'Học sinh tiểu học'              = @{ en = 'Primary school pupil'; ja = '小学生'; zh = '小学生' }
  'Học sinh cấp hai'               = @{ en = 'Middle school student'; ja = '中学生'; zh = '初中生' }
  'Học sinh cấp ba'                = @{ en = 'High school student'; ja = '高校生'; zh = '高中生' }
  'Sinh viên Đại học'              = @{ en = 'University student'; ja = '大学生'; zh = '大学生' }
  'Phụ giúp gia đình'              = @{ en = 'Helping the family'; ja = '家族の手伝い'; zh = '帮家里做事' }
  'Lao động phụ việc'              = @{ en = 'Helping hand / child labourer'; ja = '手伝い・児童労働'; zh = '帮工或童工' }
  'Học nghề thợ sửa chữa'          = @{ en = 'Repair apprentice'; ja = '修理工の見習い'; zh = '修理学徒' }
  'Kỹ thuật viên thực tập'         = @{ en = 'Trainee technician'; ja = '技術研修生'; zh = '见习技术员' }
  'Công nhân / Nhân viên bán hàng' = @{ en = 'Worker / Sales clerk'; ja = '作業員・販売員'; zh = '工人或售货员' }
  'Nhân viên văn phòng'            = @{ en = 'Office worker'; ja = '事務員'; zh = '办公室职员' }
  'Chuyên viên văn phòng'          = @{ en = 'Office specialist'; ja = '事務専門職'; zh = '办公专业人员' }
  'Kỹ thuật viên lành nghề'        = @{ en = 'Skilled technician'; ja = '熟練技術者'; zh = '熟练技术员' }
  'Cử nhân / Chuyên viên'          = @{ en = 'Graduate / Specialist'; ja = '大卒専門職'; zh = '大学毕业生或专业人员' }
  'Quản lý cấp cao'                = @{ en = 'Senior manager'; ja = '上級管理職'; zh = '高级管理人员' }
  'Chủ doanh nghiệp'               = @{ en = 'Business owner'; ja = '経営者'; zh = '企业主' }
  'Chủ doanh nghiệp nhỏ'           = @{ en = 'Small business owner'; ja = '小規模事業主'; zh = '小企业主' }
  'Nghỉ hưu'                       = @{ en = 'Retired'; ja = '退職者'; zh = '退休人员' }
  'Nghỉ hưu an nhàn'               = @{ en = 'Happily retired'; ja = '穏やかな退職生活'; zh = '安享退休生活' }
}

function Get-JobName([string]$job) {
  if (-not $job) { return '-' }
  if ($script:JobNames.ContainsKey($job)) { return T $script:JobNames[$job] }
  return $job
}

function Get-EducationName($level) {
  $lv = [double]$level
  if ($lv -ge 5) { return (L 'Postgraduate' '大学院' '研究生') }
  if ($lv -ge 4) { return (L 'University' '大学' '大学') }
  if ($lv -ge 3) { return (L 'High school' '高校' '高中') }
  if ($lv -ge 2.5) { return (L 'Vocational school' '職業学校' '职业学校') }
  if ($lv -ge 2) { return (L 'Middle school' '中学校' '初中') }
  if ($lv -ge 1) { return (L 'Primary school' '小学校' '小学') }
  return (L 'None' 'なし' '无')
}

function Get-StatName([string]$name) {
  switch ($name) {
    'health' { return (L 'Health' '健康' '健康') }
    'happiness' { return (L 'Happiness' '幸福' '幸福') }
    'smarts' { return (L 'Smarts' '知性' '智力') }
    'social' { return (L 'Social' '社交' '社交') }
    'wealth' { return (L 'Wealth' '資産' '财富') }
    default { return $name }
  }
}

function Get-ParentJobName([string]$job) {
  switch ($job) {
    'civil servant' { return (L 'Civil servant' '公務員' '公务员') }
    'teacher' { return (L 'Teacher' '教師' '教师') }
    'nurse' { return (L 'Nurse' '看護師' '护士') }
    'office manager' { return (L 'Office manager' '事務管理者' '办公室主管') }
    'accountant' { return (L 'Accountant' '会計士' '会计师') }
    'engineer' { return (L 'Engineer' '技術者' '工程师') }
    'commercial farmer' { return (L 'Commercial farmer' '農業経営者' '经营农场者') }
    'doctor' { return (L 'Doctor' '医師' '医生') }
    'homemaker' { return (L 'Homemaker' '家事に従事' '料理家务者') }
    'trader' { return (L 'Trader' '商人' '商人') }
    'clerk' { return (L 'Clerk' '事務員' '文员') }
    'tailor' { return (L 'Tailor' '仕立て職人' '裁缝') }
    'cook' { return (L 'Cook' '料理人' '厨师') }
    'driver' { return (L 'Driver' '運転手' '司机') }
    'carpenter' { return (L 'Carpenter' '大工' '木匠') }
    'mechanic' { return (L 'Mechanic' '整備士' '机械维修工') }
    'agricultural worker' { return (L 'Agricultural worker' '農業労働者' '农业工人') }
    'street vendor' { return (L 'Street vendor' '露天商' '街头摊贩') }
    'factory worker' { return (L 'Factory worker' '工場の作業員' '工厂工人') }
    'worker/farmer' { return (L 'Worker / Farmer' '労働者・農家' '工人或农民') }
    'day laborer' { return (L 'Day laborer' '日雇い労働者' '日结工') }
    'construction worker' { return (L 'Construction worker' '建設作業員' '建筑工人') }
    default { return $job }
  }
}
