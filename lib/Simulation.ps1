# Yearly simulation: mortality, growth, career, family, events, peers, decisions,
# reflections and achievements. Port of src/engine/ (original repo) simulation.js,
# src/engine/ (original repo) achievements.js and the game flow parts of src/App.jsx.

$script:CausesInfant = @(
  @{ id = 'neonatal'; ja = '新生児の疾患（早産・出産時の合併症）'; en = 'Neonatal conditions (preterm birth, complications)'; zh = '新生儿疾病（早产、出生并发症）' }
  @{ id = 'congenital'; ja = '先天性疾患'; en = 'Congenital anomalies'; zh = '先天畸形' }
  @{ id = 'infection'; ja = '新生児敗血症'; en = 'Neonatal sepsis'; zh = '新生儿败血症' }
  @{ id = 'pneumonia'; ja = '急性肺炎'; en = 'Acute pneumonia'; zh = '急性肺炎' }
)
$script:CausesChild = @(
  @{ id = 'pneumonia'; ja = '肺炎（下気道感染症）'; en = 'Pneumonia (lower respiratory infection)'; zh = '肺炎（下呼吸道感染）' }
  @{ id = 'diarrhea'; ja = '下痢性疾患と重度の脱水'; en = 'Diarrheal disease and severe dehydration'; zh = '腹泻及严重脱水' }
  @{ id = 'malaria'; ja = '重症マラリア'; en = 'Severe malaria'; zh = '重症疟疾' }
  @{ id = 'malnutrition'; ja = '重度の急性栄養失調'; en = 'Severe acute malnutrition'; zh = '严重急性营养不良' }
  @{ id = 'drowning'; ja = '水難事故'; en = 'Accidental drowning'; zh = '意外溺水' }
)
$script:CausesYouth = @(
  @{ id = 'traffic'; ja = '交通事故'; en = 'Road traffic injuries'; zh = '道路交通伤害' }
  @{ id = 'accident'; ja = '労働災害・転落事故'; en = 'Occupational injury / accidental fall'; zh = '工伤或意外跌落' }
  @{ id = 'conflict'; ja = '武力紛争'; en = 'Casualty of armed conflict'; zh = '武装冲突' }
  @{ id = 'violence'; ja = '殺人・暴力犯罪'; en = 'Homicide / violent crime'; zh = '凶杀或暴力犯罪' }
  @{ id = 'maternal'; ja = '出産の合併症'; en = 'Maternal childbirth complications'; zh = '分娩并发症' }
  @{ id = 'dengue'; ja = '重症デング熱'; en = 'Severe dengue fever'; zh = '重症登革热' }
)
$script:CausesElder = @(
  @{ id = 'heart'; ja = '虚血性心疾患（心筋梗塞）'; en = 'Ischemic heart disease (heart attack)'; zh = '缺血性心脏病（心肌梗死）' }
  @{ id = 'stroke'; ja = '脳卒中'; en = 'Stroke (cerebrovascular accident)'; zh = '脑卒中' }
  @{ id = 'cancer'; ja = 'がん'; en = 'Cancer'; zh = '癌症' }
  @{ id = 'copd'; ja = '慢性閉塞性肺疾患（COPD）'; en = 'Chronic obstructive pulmonary disease (COPD)'; zh = '慢性阻塞性肺病（COPD）' }
  @{ id = 'kidney'; ja = '末期の慢性腎臓病'; en = 'End-stage chronic kidney disease'; zh = '终末期慢性肾病' }
  @{ id = 'diabetes'; ja = '糖尿病の合併症'; en = 'Complications of diabetes mellitus'; zh = '糖尿病并发症' }
  @{ id = 'old_age'; ja = '老衰'; en = 'Natural causes of old age'; zh = '自然衰老' }
)

$script:HistoricalEvents = @{
  1969 = @{ ja = 'アポロ11号が月面着陸。人類が初めて月に降り立ちました！'; en = 'Apollo 11 lands on the Moon; humanity takes its first steps on another world!'; zh = '阿波罗11号登月，人类首次踏上月球！' }
  1975 = @{ ja = 'ベトナム戦争が終結し、平和への時代が始まりました。'; en = 'The Vietnam War concludes, ushering in an era of peace.'; zh = '越南战争结束，迎来了和平的时代。' }
  1989 = @{ ja = 'ベルリンの壁が崩れ、冷戦は終結へ向かいます。'; en = 'The Berlin Wall falls; the Cold War draws toward its conclusion.'; zh = '柏林墙倒塌，冷战走向终结。' }
  1995 = @{ ja = '商用のワールド・ワイド・ウェブが世界を結び始めました。'; en = 'The global commercial World Wide Web connects millions across continents.'; zh = '商业化的万维网开始连接世界各地数百万人。' }
  2001 = @{ ja = '9月11日の同時多発テロが、世界の外交と航空に衝撃を与えました。'; en = 'The September 11 attacks shake international relations and aviation.'; zh = '九一一袭击震动了国际关系与航空业。' }
  2008 = @{ ja = '世界金融危機が起こり、経済が大きく混乱しました。'; en = 'The global financial crisis triggers widespread economic turmoil.'; zh = '全球金融危机爆发，经济陷入广泛动荡。' }
  2020 = @{ ja = '新型コロナウイルスが世界に広がり、各地で都市封鎖が始まりました。'; en = 'The COVID-19 pandemic spreads globally; worldwide lockdowns begin.'; zh = '新冠疫情蔓延全球，各地开始实施封锁。' }
}

# ---------------------------------------------------------------- achievements
$script:Achievements = @(
  @{ id = 'survivor'; icon = '[+]'
    title = @{ ja = '逆境を越えて'; en = 'Against All Odds'; zh = '逆境求生' }
    desc = @{ ja = '5歳未満死亡率が高い国（35‰以上）で5歳を越える'; en = 'Survive past age 5 in a country with high child mortality (U5 ≥ 35‰)'; zh = '在儿童死亡率较高的国家（5岁以下死亡率≥35‰）活过5岁' }
    check = { param($s) $s.yearsLived -ge 5 -and [double]$s.country.u5 -ge 35 } }
  @{ id = 'scholar'; icon = '[+]'
    title = @{ ja = '学びの勝利'; en = 'Scholarly Triumph'; zh = '求学之路' }
    desc = @{ ja = '所得階層Q1・Q2の生まれで大学を卒業する'; en = 'Earn a university degree despite being born into quintile Q1 or Q2'; zh = '出生在Q1或Q2收入家庭，仍取得大学学历' }
    check = { param($s) $s.q -le 2 -and $s.stats.educationLevel -ge 4 } }
  @{ id = 'tycoon'; icon = '[$]'
    title = @{ ja = '一代で築いた富'; en = 'Self-Made Wealth'; zh = '白手起家' }
    desc = @{ ja = '個人資産が50,000米ドル（PPP）を超える'; en = 'Accumulate personal wealth exceeding $50,000 PPP'; zh = '个人财富超过50,000美元（购买力平价）' }
    check = { param($s) $s.stats.wealth -ge 50000 } }
  @{ id = 'centenarian'; icon = '[+]'
    title = @{ ja = '長寿の足跡'; en = 'Centenarian Legacy'; zh = '长寿人生' }
    desc = @{ ja = '85歳以上まで生きる'; en = 'Live to a grand age of 85 or older'; zh = '活到85岁或以上' }
    check = { param($s) $s.yearsLived -ge 85 } }
  @{ id = 'patriarch'; icon = '[+]'
    title = @{ ja = '家族の絆'; en = 'Golden Family Bond'; zh = '家庭之福' }
    desc = @{ ja = '2人以上の子どもを育て、孫を迎える'; en = 'Raise at least 2 children and welcome grandchildren into the world'; zh = '养育至少2名子女，并迎来孙辈' }
    check = { param($s) $s.family.children.Count -ge 2 -and $s.family.grandchildrenCount -ge 1 } }
  @{ id = 'globetrotter'; icon = '[+]'
    title = @{ ja = '世界市民'; en = 'Global Citizen'; zh = '世界公民' }
    desc = @{ ja = '海外旅行または海外で働く'; en = 'Travel abroad or work internationally'; zh = '出国旅行或在海外工作' }
    check = { param($s) [bool]$s.flags.abroad -or [bool]$s.flags.workedAbroad } }
  @{ id = 'leader'; icon = '[+]'
    title = @{ ja = '人を導く力'; en = 'Inspiring Leader'; zh = '引路人' }
    desc = @{ ja = '上級管理職になるか、自分の事業を成功させる'; en = 'Rise to senior executive leadership or start your own successful business'; zh = '成为高级管理人员，或成功创办企业' }
    check = { param($s) $s.jobId -eq 'owner' -or $s.jobId -eq 'specialist' -or ($s.job -and $s.job.Contains('Quản lý')) } }
  @{ id = 'zen'; icon = '[+]'
    title = @{ ja = '穏やかな心'; en = 'Serene Soul'; zh = '宁静心灵' }
    desc = @{ ja = '50歳以降に幸福度85%以上を保つ'; en = 'Maintain happiness at or above 85% after age 50'; zh = '50岁后保持85%以上的幸福感' }
    check = { param($s) $s.yearsLived -ge 50 -and $s.stats.happiness -ge 85 } }
  @{ id = 'philanthropist'; icon = '[+]'
    title = @{ ja = '地域の支え'; en = 'Community Pillar'; zh = '社区支柱' }
    desc = @{ ja = '慈善・地域活動・人道支援に遺産を託す'; en = 'Dedicate legacy to charity, community foundation, or humanitarian causes'; zh = '把传承奉献给慈善、社区或人道事业' }
    check = { param($s) [bool]$s.flags.charitable } }
  @{ id = 'polymath'; icon = '[+]'
    title = @{ ja = '知を究める人'; en = 'Living Polymath'; zh = '博学之人' }
    desc = @{ ja = '知性90%以上に達する'; en = 'Attain extraordinary intellectual insight (Smarts ≥ 90%)'; zh = '智力达到90%以上' }
    check = { param($s) $s.stats.smarts -ge 90 } }
  @{ id = 'athlete'; icon = '[+]'
    title = @{ ja = '衰えぬ活力'; en = 'Peak Vitality'; zh = '活力常在' }
    desc = @{ ja = '65歳を越えて健康85%以上を保つ'; en = 'Keep health at 85% or higher past the age of 65'; zh = '65岁后保持85%以上的健康' }
    check = { param($s) $s.yearsLived -ge 65 -and $s.stats.health -ge 85 } }
  @{ id = 'outliver'; icon = '[+]'
    title = @{ ja = '同世代を越えて'; en = 'Peer Outliver'; zh = '超越同龄' }
    desc = @{ ja = '同じ国と時代に生まれた人の90%より長く生きる'; en = 'Outlive 90% of peers born in the same country and era'; zh = '比同国同时代出生者中的90%活得更久' }
    check = { param($s) $le = $(if ($s.country.le) { [double]$s.country.le } else { 73 }); $s.yearsLived -ge $le + 12 } }
)

function Get-NewAchievements($state) {
  $new = @()
  foreach ($a in $script:Achievements) {
    if (-not $state.unlockedAchievements.Contains($a.id)) {
      if (& $a.check $state) { $new += $a }
    }
  }
  return , $new
}

# ---------------------------------------------------------------- helpers
function New-LogEntry([int]$age, [string]$type, $text, $fact = $null) {
  return @{ age = $age; type = $type; text = $text; fact = $fact }
}

function Add-Logs($state, $entries) {
  $arr = @($entries)
  if ($arr.Count -gt 0) { $state.log.InsertRange(0, $arr) }
}

# Keep the 0-100 meters in range after any change (the web UI clamps on display).
function Limit-Stats($state) {
  foreach ($k in @('health', 'happiness', 'smarts', 'social')) {
    $state.stats[$k] = [Math]::Round((Get-Clamp $state.stats[$k] 0 100), 2)
  }
  if ($state.stats.wealth -lt 0) { $state.stats.wealth = 0 }
}

function Get-Field($obj, [string]$name, $default) {
  $v = $obj.$name
  if ($null -eq $v -or ($v -isnot [string] -and [double]$v -eq 0)) { return $default }
  return $v
}

# ---------------------------------------------------------------- new life
function New-Life($era = 'current') {
  $country = Select-Country $script:Data.countries
  $state = New-BirthIdentity $country $era
  $state.peers = New-PeerBabies
  $state.alive = $true
  $state.pendingDecision = $null
  $state.pendingReflection = $null
  $state.newlyUnlocked = $null
  $state.log = New-Object System.Collections.ArrayList

  $by = $state.birthYear
  $billions = $(if ($by -lt 1980) { '4' } else { '8' })
  $population = $(if ($by -lt 1980) { '40' } else { '80' })
  $cid = $state.country.id
  $en = $script:Data.countryEn.$cid; if (-not $en) { $en = $cid }
  $ja = $script:Data.countryJa.$cid; if (-not $ja) { $ja = $en }
  $zh = $script:Data.countryZh.$cid; if (-not $zh) { $zh = $en }
  $placeEn = $(if ($state.urban) { $state.cityNameEn } else { 'a rural area' })
  $placeJa = $(if ($state.urban) { $state.cityNameEn } else { '農村地域' })
  $placeZh = $(if ($state.urban) { $state.cityNameEn } else { '乡村地区' })
  [void]$state.log.Add((New-LogEntry 0 'birth' @{
        ja = "${by}年、${ja}の${placeJa}に生まれました。約${population}億人の中の、新しい命です。"
        en = "In the year $by, you were born into $placeEn in $en. One new infant among over $billions billion people."
        zh = "${by}年，你出生在${zh}的${placeZh}。你是约${population}亿人中的一个新生命。"
      }))
  return $state
}

# ---------------------------------------------------------------- one year
function Test-EventEligible($state, $event) {
  $r = $event.requirements
  if (-not $r) { return $true }
  if ($r.minQuintile -and $state.q -lt $r.minQuintile) { return $false }
  if ($r.maxQuintile -and $state.q -gt $r.maxQuintile) { return $false }
  if ($r.maxPpp -and $state.country.ppp -gt $r.maxPpp) { return $false }
  if ($r.rural -and $state.urban) { return $false }
  if ($r.countries -and $r.countries -notcontains $state.country.id) { return $false }
  if ($r.regions -and $r.regions -notcontains $state.country.p) { return $false }
  if ($r.inSchool -and $state.jobId -notlike 'student_*') { return $false }
  if ($r.sex -and $state.sex -ne $r.sex) { return $false }
  if ($r.children -and $state.family.children.Count -eq 0) { return $false }
  if ($r.grandchildren -and $state.family.grandchildrenCount -eq 0) { return $false }
  if ($r.siblings -and ($state.family.olderSiblings + $state.family.youngerSiblings) -eq 0) { return $false }
  return $true
}

function Step-Year($state) {
  if (-not $state.alive) { return }
  $currentAge = [int]$state.yearsLived
  $nextAge = $currentAge + 1
  $state.yearsLived = $nextAge
  $country = $state.country
  $newLogs = New-Object System.Collections.ArrayList

  # 1. Mortality (UN life table + local risks)
  $sex = $(if ($state.sex) { $state.sex } else { 'M' })
  $lt = Get-LifeTable $country $sex
  $ageIdx = [Math]::Min([Math]::Max($currentAge, 0), 110)
  $p = $lt.q[$ageIdx]
  if ($currentAge -ge 15 -and $currentAge -lt 50) {
    $p += ((Get-Field $country 'road' 15) / 150000) + ([double]$country.war * 0.003) + ((Get-Field $country 'hom' 3) / 150000)
  }
  $healthAdj = (100 - $state.stats.health) / 50
  $p *= (Get-Clamp $healthAdj 0.3 2.5)
  if ($state.currentFocus -eq 'health') { $p *= 0.75 }
  if ($nextAge -ge 115) { $p = 1.0 }

  if (Test-Chance $p) {
    $state.alive = $false
    if ($currentAge -eq 0) { $cause = Get-Pick $script:CausesInfant }
    elseif ($currentAge -le 4) { $cause = Get-Pick $script:CausesChild }
    elseif ($currentAge -le 50) { $cause = Get-Pick $script:CausesYouth }
    elseif ($nextAge -ge ((Get-Field $country 'le' 75) + 8)) { $cause = $script:CausesElder[$script:CausesElder.Count - 1] }
    else { $cause = Get-Pick $script:CausesElder }
    $state.causeOfDeath = $cause
    $state.stats.health = 0
    Add-Logs $state (New-LogEntry $nextAge 'death' @{
        ja = "${nextAge}歳で、$($cause.ja)により亡くなりました。"
        en = "Passed away at age $nextAge due to $($cause.en)."
        zh = "你在${nextAge}岁时因$($cause.zh)去世。"
      })
    return
  }

  # 2. Growth and milestones
  if ($nextAge -eq 1) {
    [void]$newLogs.Add((New-LogEntry 1 'event' @{
          ja = '1歳の誕生日を迎え、小さな一歩と言葉が出始めました！'
          en = 'Celebrated your 1st birthday, taking tiny steps and babbling first words!'
          zh = '你迎来一岁生日，迈着小步子，开始咿呀学语！'
        }))
  }
  elseif ($nextAge -eq 7 -and $state.stats.educationLevel -eq 0) {
    if ($country.p -eq 'hi' -or $country.p -eq 'eca') {
      $state.stats.educationLevel = 1
      $state.job = 'Học sinh tiểu học'
      $state.jobId = 'student_prim'
      [void]$newLogs.Add((New-LogEntry 7 'event' @{
            ja = '小学校に入り、読み書きや計算を学び始めました。'
            en = 'Entered primary school, learning to read stories and solve arithmetic.'
            zh = '你进入小学，开始学习读写和算术。'
          }))
    }
  }

  # Annual focus
  $focus = $(if ($state.currentFocus) { $state.currentFocus } else { 'study' })
  switch ($focus) {
    'study' {
      $state.stats.smarts = Get-Clamp ($state.stats.smarts + (Get-RandomInt 2 4)) 10 100
      $state.stats.happiness = Get-Clamp ($state.stats.happiness - 1) 10 100
    }
    'work' {
      if ($nextAge -ge 16) {
        $basePpp = Get-Field $country 'ppp' 15000
        $state.stats.wealth += Get-JsRound (($basePpp / 12) * 0.25 * (0.6 + $state.q * 0.2))
        if ($nextAge -ge 35) { $state.stats.health = Get-Clamp ($state.stats.health - 1) 10 100 }
      }
    }
    'family' {
      $state.stats.social = Get-Clamp ($state.stats.social + 3) 10 100
      $state.stats.happiness = Get-Clamp ($state.stats.happiness + 3) 10 100
    }
    'health' { $state.stats.health = Get-Clamp ($state.stats.health + (Get-RandomInt 3 5)) 10 100 }
    'hobby' { $state.stats.happiness = Get-Clamp ($state.stats.happiness + (Get-RandomInt 4 6)) 10 100 }
  }

  # Career salary & promotions
  if ($nextAge -ge 18) {
    $edu = $(if ($state.stats.educationLevel) { $state.stats.educationLevel } else { 2 })
    $qq = $(if ($state.q) { $state.q } else { 3 })
    $pct = Get-Clamp ((($qq - 0.5) / 5) + $edu * 0.06 - 0.08) 0.02 0.98
    $state.stats.wealth += Get-JsRound ((Get-IncomeAt $country $pct) * 0.14)

    if ($nextAge -eq 23 -and $state.jobId -eq 'student_uni') {
      $state.job = 'Cử nhân / Chuyên viên'; $state.jobId = 'specialist'
      [void]$newLogs.Add((New-LogEntry 23 'event' @{
            ja = '大学を優秀な成績で卒業し、専門職の道を歩み始めました！'
            en = 'Graduated from university with honors and stepped into a professional career!'
            zh = '你以优异成绩大学毕业，踏上专业职业道路！'
          }))
    }
    elseif ($nextAge -eq 40 -and $state.jobId -ne 'owner') {
      $state.job = 'Quản lý cấp cao'
      [void]$newLogs.Add((New-LogEntry 40 'event' @{
            ja = '長年の努力が認められ、上級管理職に昇進しました。'
            en = 'Promoted to a senior leadership role in recognition of years of dedicated work.'
            zh = '多年的努力得到认可，你晋升为高级管理人员。'
          }))
    }
    elseif ($nextAge -eq 65 -and -not $state.flags.retired) {
      $state.flags.retired = $true
      $state.job = 'Nghỉ hưu'; $state.jobId = 'retired'
      [void]$newLogs.Add((New-LogEntry 65 'event' @{
            ja = '長年の仕事を終えて退職し、穏やかな生活を始めました。'
            en = 'Officially retired after four decades of honest labor to enjoy peaceful leisure.'
            zh = '结束多年的工作后，你正式退休，开始享受安宁生活。'
          }))
    }
  }

  # Partner & children
  if ($state.family.partner -and $state.family.partner.alive) {
    $maxChildren = [Math]::Max(1, (Get-JsRound (Get-Field $country 'tfr' 2)))
    if ($nextAge -ge 23 -and $nextAge -le 38 -and $state.family.children.Count -lt $maxChildren -and (Test-Chance 0.28)) {
      $g = $(if (Test-Chance 0.51) { 'M' } else { 'F' })
      [void]$state.family.children.Add(@{ name = $(if ($g -eq 'M') { 'Bé trai' } else { 'Bé gái' }); gender = $g; bornAtAge = $nextAge; alive = $true })
      $state.stats.happiness += 12
      [void]$newLogs.Add((New-LogEntry $nextAge 'family' @{
            ja = '赤ちゃんが生まれました！あなたも親になりました。'
            en = 'Welcomed a beautiful baby into the world! You became a proud parent.'
            zh = '一个可爱的宝宝降生了！你成为了父母。'
          }))
    }
  }

  # Grandchildren
  if ($nextAge -ge 55 -and $state.family.children.Count -gt 0 -and (Test-Chance 0.2) -and $state.family.grandchildrenCount -lt 4) {
    $state.family.grandchildrenCount++
    $state.stats.happiness += 10
    [void]$newLogs.Add((New-LogEntry $nextAge 'family' @{
          ja = '子どもに赤ちゃんが生まれ、初めて孫を抱きました！'
          en = 'Your child had a baby! You held your beloved grandchild in your arms.'
          zh = '你的孩子有了宝宝！你把心爱的孙辈抱在怀里。'
        }))
  }

  # Aging parents
  $mom = $state.family.mom
  if ($mom.alive) {
    $mom.age++
    if ($mom.age -ge 75 -and (Test-Chance 0.08)) {
      $mom.alive = $false
      $state.stats.happiness -= 15
      [void]$newLogs.Add((New-LogEntry $nextAge 'family' @{
            ja = "大切な母が$($mom.age)歳で穏やかに亡くなりました。"
            en = "Your beloved mother passed away peacefully at age $($mom.age)."
            zh = "你亲爱的母亲在$($mom.age)岁时安详离世。"
          }))
    }
  }
  $dad = $state.family.dad
  if ($dad.alive) {
    $dad.age++
    if ($dad.age -ge 75 -and (Test-Chance 0.09)) {
      $dad.alive = $false
      $state.stats.happiness -= 15
      [void]$newLogs.Add((New-LogEntry $nextAge 'family' @{
            ja = "大切な父が$($dad.age)歳で亡くなりました。"
            en = "Your respected father passed away at age $($dad.age)."
            zh = "你敬爱的父亲在$($dad.age)岁时离世。"
          }))
    }
  }

  if ($nextAge -ge 60) { $state.stats.health = [Math]::Max(10, $state.stats.health - (Get-RandomInt 1 3)) }

  # World history
  $calYear = [int]$state.birthYear + $nextAge
  if ($script:HistoricalEvents.ContainsKey($calYear) -and -not $state.flags["hist_$calYear"]) {
    $state.flags["hist_$calYear"] = $true
    [void]$newLogs.Add((New-LogEntry $nextAge 'event' $script:HistoricalEvents[$calYear] @{
          ja = "${calYear}年に起きた世界の出来事。"
          en = "Global historical milestone of the year $calYear."
          zh = "${calYear}年发生的世界历史事件。"
        }))
  }

  # Demographic event database
  $eligible = @(foreach ($ev in $script:Data.events) {
      if ($nextAge -lt $ev.minAge -or $nextAge -gt $ev.maxAge) { continue }
      if ($state.flags["ev_$($ev.id)"]) { continue }
      if (Test-EventEligible $state $ev) { $ev }
    })
  if ($eligible.Count -gt 0 -and (Test-Chance 0.45)) {
    $ev = Get-WeightedPick $eligible @($eligible | ForEach-Object { Get-Field $_ 'weight' 1 })
    $state.flags["ev_$($ev.id)"] = $nextAge
    $fx = $ev.statEffects
    if ($fx) {
      foreach ($k in @('health', 'happiness', 'smarts', 'social')) {
        if ($fx.$k) { $state.stats[$k] = Get-Clamp ($state.stats[$k] + $fx.$k) 5 100 }
      }
    }
    $type = $(if ($ev.cat -eq 'family') { 'family' } else { 'event' })
    [void]$newLogs.Add((New-LogEntry $nextAge $type $ev.text $ev.fact))
  }

  # Peers
  if ($state.peers -and $state.peers.Count) { Step-Peers $state.peers $currentAge $nextAge }

  # Decisions
  foreach ($dk in $script:DECISIONS.Keys) {
    $d = $script:DECISIONS[$dk]
    if ($d.age -eq $nextAge -and -not $state.flags["dec_$dk"]) {
      $state.pendingDecision = $d
      $state.flags["dec_$dk"] = $true
      break
    }
  }

  # Reflections (5, 15, 30, 50, 70)
  $refl = $script:Data.reflections."$nextAge"
  if ($refl -and -not $state.flags["refl_$nextAge"]) {
    $state.pendingReflection = $refl
    $state.flags["refl_$nextAge"] = $true
  }

  # Achievements
  $newly = Get-NewAchievements $state
  if ($newly.Count -gt 0) {
    foreach ($a in $newly) {
      [void]$state.unlockedAchievements.Add($a.id)
      Save-GlobalAchievement $a.id
      [void]$newLogs.Add((New-LogEntry $nextAge 'achievement' @{
            ja = "実績解除：$($a.title.ja) — $($a.desc.ja)"
            en = "Unlocked Achievement: $($a.title.en) — $($a.desc.en)"
            zh = "解锁成就：$($a.title.zh) — $($a.desc.zh)"
          }))
    }
    $state.newlyUnlocked = $newly[0]
  }
  else { $state.newlyUnlocked = $null }

  Limit-Stats $state
  Add-Logs $state $newLogs
}

function Step-Peers($peers, [int]$currentAge, [int]$nextAge) {
  foreach ($peer in $peers) {
    if (-not $peer.alive) { continue }
    $c = $peer.country
    $lt = Get-LifeTable $c $(if ($peer.sex) { $peer.sex } else { 'M' })
    $p = $lt.q[[Math]::Min([Math]::Max($currentAge, 0), 110)]
    if ($currentAge -ge 15 -and $currentAge -lt 50) { $p += ((Get-Field $c 'road' 15) / 150000) + ([double]$c.war * 0.003) }
    if ($nextAge -ge 115) { $p = 1.0 }
    if (Test-Chance $p) {
      if ($currentAge -eq 0) { $cause = Get-Pick $script:CausesInfant }
      elseif ($currentAge -lt 5) { $cause = Get-Pick $script:CausesChild }
      elseif ($currentAge -lt 50) { $cause = Get-Pick $script:CausesYouth }
      else { $cause = Get-Pick $script:CausesElder }
      $peer.alive = $false; $peer.deathAge = $nextAge; $peer.deathCause = $cause
      continue
    }
    $status = $peer.status
    switch ($nextAge) {
      3 { $status = @{ ja = '幼稚園に通う'; en = 'In kindergarten'; zh = '就读幼儿园' } }
      6 { $status = @{ ja = '小学校に通う'; en = 'In primary school'; zh = '就读小学' } }
      12 { $status = @{ ja = '中学校に通う'; en = 'In middle school'; zh = '就读初中' } }
      15 { $status = @{ ja = '高校に通う'; en = 'In high school'; zh = '就读高中' } }
      18 {
        $status = Get-Pick @(
          @{ ja = '大学に通う'; en = 'In university'; zh = '就读大学' }
          @{ ja = '働き始める'; en = 'Started working'; zh = '开始工作' }
          @{ ja = '農業に従事'; en = 'Farming'; zh = '务农' })
      }
      25 {
        $status = Get-Pick @(
          @{ ja = '事務員'; en = 'Office worker'; zh = '办公室职员' }
          @{ ja = 'ソフトウェア技術者'; en = 'Software engineer'; zh = '软件工程师' }
          @{ ja = '看護師'; en = 'Nurse'; zh = '护士' }
          @{ ja = '小規模事業主'; en = 'Small business owner'; zh = '小企业主' }
          @{ ja = '工場の作業員'; en = 'Factory worker'; zh = '工厂工人' }
          @{ ja = '農家'; en = 'Farmer'; zh = '农民' })
      }
      30 {
        if (-not $status.en.Contains('Married')) {
          $status = @{ ja = "$($status.ja) · 既婚"; en = "$($status.en) · Married"; zh = "$($status.zh) · 已婚" }
        }
      }
      62 { $status = @{ ja = '退職者'; en = 'Retired'; zh = '退休人员' } }
    }
    $peer.status = $status
  }
}

# ---------------------------------------------------------------- player actions
function Invoke-Decision($state, $choice) {
  if ($choice.id -in @('civil_service','donate_cause','volunteer')) { $state.flags.charitable = $true }
  $text = & $choice.apply $state
  $state.pendingDecision = $null
  Limit-Stats $state
  Add-Logs $state (New-LogEntry $state.yearsLived 'decision' $text)
  return $text
}

function Invoke-Reflection($state, $opt) {
  $state.pendingReflection = $null
  if ($opt.stat) {
    foreach ($p in $opt.stat.PSObject.Properties) {
      $state.stats[$p.Name] = [Math]::Max(0, [double]$state.stats[$p.Name] + $p.Value)
    }
  }
  Limit-Stats $state
  $y = $state.yearsLived
  Add-Logs $state (New-LogEntry $y 'reflection' @{
      ja = "${y}歳の振り返り：$($opt.label.ja)"
      en = "Age $y reflection: $($opt.label.en)"
      zh = "${y}岁感悟：$($opt.label.zh)"
    })
}

function Get-ShopCost($item) {
  $w = $item.effects.wealth
  if ($w) { return [Math]::Abs([double]$w) } else { return 200 }
}

function Test-CanBuy($state, $item) {
  return ($state.alive -and $state.stats.wealth -ge (Get-ShopCost $item) -and $state.yearsLived -ge $item.minAge)
}

function Invoke-ShopItem($state, $item) {
  if (-not (Test-CanBuy $state $item)) { return $false }
  $state.stats.wealth = [Math]::Max(0, $state.stats.wealth - (Get-ShopCost $item))
  foreach ($k in @('happiness', 'health', 'smarts', 'social')) {
    if ($item.effects.$k) { $state.stats[$k] += $item.effects.$k }
  }
  if ($item.id -eq 'pet') { $state.flags.pet = 'd' }
  if ($item.id -eq 'abroad') { $state.flags.abroad = $true }
  if ($item.id -eq 'donate') { $state.flags.charitable = $true }
  Limit-Stats $state
  Add-Logs $state (New-LogEntry $state.yearsLived 'joy' @{
      ja = "体験：$($item.name.ja)。"
      en = "Experienced: $($item.name.en)."
      zh = "生活体验：$($item.name.zh)。"
    })
  return $true
}

# ---------------------------------------------------------------- end of life
function Get-LifeArchetype($state) {
  if ($state.yearsLived -ge 85) {
    return @{ icon = '*'; title = @{ ja = '敬愛される長老'; en = 'Venerable Elder'; zh = '德高望重的长者' }
      desc = @{ ja = '知恵を蓄え、時代の移り変わりを見届けた長い人生。'; en = 'A long life of wisdom, witnessing eras of transformation.'; zh = '漫长的一生积累了智慧，见证了时代的变迁。' } }
  }
  if ($state.stats.wealth -ge 50000 -or $state.jobId -eq 'owner') {
    return @{ icon = '$'; title = @{ ja = '自ら道を開いた人'; en = 'Self-Made Pioneer'; zh = '自主开拓者' }
      desc = @{ ja = '好機をつかみ、意志と工夫で暮らしを築いた人生。'; en = 'Energetic and financially astute, seizing opportunities with determination.'; zh = '精力充沛、善于理财，以坚定意志把握机会的一生。' } }
  }
  if ($state.stats.smarts -ge 80 -or $state.stats.educationLevel -ge 4) {
    return @{ icon = '#'; title = @{ ja = '知を求めた学者'; en = 'Enlightened Scholar'; zh = '求知的学者' }
      desc = @{ ja = '好奇心を忘れず、知識を求めて学び続けた人生。'; en = 'Endlessly curious, pursuing knowledge and illuminating minds.'; zh = '始终保持好奇，追求知识、启迪心灵的一生。' } }
  }
  if ($state.family.children.Count -ge 2 -and ($state.family.grandchildrenCount -ge 1 -or $state.stats.social -ge 75)) {
    return @{ icon = '^'; title = @{ ja = '家族を支えた人'; en = 'Loving Family Anchor'; zh = '温暖的家庭支柱' }
      desc = @{ ja = '深い愛で家族を支え、世代を超えた絆を育んだ人生。'; en = 'Anchored in profound love, cherishing generations of family bonds.'; zh = '以深厚的爱守护家庭，珍惜代代亲情的一生。' } }
  }
  if ($state.stats.happiness -ge 80) {
    return @{ icon = '~'; title = @{ ja = '自由な心の持ち主'; en = 'Free-Spirited Soul'; zh = '自由的灵魂' }
      desc = @{ ja = 'ささやかな日常に喜びを見つけ、穏やかで自由に生きた人生。'; en = 'Finding joy in simplicity, living with a serene and unbound spirit.'; zh = '在平凡中发现快乐，平和而自在的一生。' } }
  }
  if ($state.yearsLived -le 5) {
    return @{ icon = '+'; title = @{ ja = '短く輝いた命'; en = 'Fleeting Innocence'; zh = '短暂的纯真' }
      desc = @{ ja = 'この世界に短く滞在し、消えない愛を残した大切な命。'; en = 'A precious tender soul who briefly visited our world, leaving enduring love.'; zh = '短暂来到世间，却留下长久爱意的珍贵生命。' } }
  }
  return @{ icon = '>'; title = @{ ja = 'くじけぬ旅人'; en = 'Resilient Wanderer'; zh = '坚韧的旅人' }
    desc = @{ ja = '時代の波を越え、与えられた一日一日を大切に生きた人生。'; en = 'Weathering the tides of time with dignity, embracing every gifted day.'; zh = '有尊严地走过岁月风浪，珍惜每一天的一生。' } }
}

# Percentage of same-country peers this person outlived (DeathSummary.jsx).
function Get-OutlivedPercentile($state) {
  $le = Get-Field $state.country 'le' 73
  if ($state.yearsLived -le 1) { return 3 }
  if ($state.yearsLived -le 5) { return 8 }
  $z = ($state.yearsLived - $le) / 14
  $pc = Get-JsRound ((1 / (1 + [Math]::Exp(-1.6 * $z))) * 100)
  return [int][Math]::Min([Math]::Max($pc, 1), 99)
}

# ---------------------------------------------------------------- persistence
function Get-SaveDir {
  return $script:SaveDirectory
}

$script:NoSave = $false
$script:SaveDirectory = Join-Path (Split-Path $PSScriptRoot -Parent) 'saves'

function Read-SaveFile([string]$name) {
  $path = Join-Path (Get-SaveDir) $name
  if (-not (Test-Path -LiteralPath $path)) { return @() }
  try {
    $raw = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    if (-not $raw) { return @() }
    return @(ConvertFrom-Json $raw)
  }
  catch { return @() }
}

function Write-SaveFile([string]$name, $obj) {
  if ($script:NoSave) { return }
  try {
    $dir = Get-SaveDir
    if (-not (Test-Path -LiteralPath $dir)) { [void](New-Item -ItemType Directory -Path $dir -Force) }
    $json = ConvertTo-Json -InputObject @($obj) -Depth 32
    $path = Join-Path $dir $name
    $temp = Join-Path $dir ($name + '.tmp')
    [System.IO.File]::WriteAllText($temp, $json, (New-Object System.Text.UTF8Encoding $false))
    Move-Item -LiteralPath $temp -Destination $path -Force
  }
  catch { Write-Warning (L 'Could not write the local save file.' 'ローカルの保存ファイルを書き込めませんでした。' '无法写入本地存档。') }
}

function Get-GlobalAchievements { return @(Read-SaveFile 'achievements.json' | ForEach-Object { [string]$_ }) }

function Save-GlobalAchievement([string]$id) {
  if ($script:NoSave) { return }
  $cur = @(Get-GlobalAchievements)
  if ($cur -notcontains $id) { Write-SaveFile 'achievements.json' (@($cur) + $id) }
}

function Get-PastLives { return @(Read-SaveFile 'past_lives.json') }

function Save-PastLife($state) {
  if ($script:NoSave) { return }
  $arch = Get-LifeArchetype $state
  $record = [ordered]@{
    id = "life_$([DateTime]::UtcNow.Ticks)"
    name = $state.name.full
    countryId = $state.country.id
    sex = $state.sex
    urban = $state.urban
    cityName = $state.cityName
    cityNameEn = $state.cityNameEn
    birthYear = $state.birthYear
    yearsLived = $state.yearsLived
    lifeExpectancy = $state.country.le
    job = $state.job
    jobId = $state.jobId
    archetype = $arch.title
    stats = [ordered]@{
      happiness = $state.stats.happiness; smarts = $state.stats.smarts; health = $state.stats.health
      social = $state.stats.social; wealth = $state.stats.wealth; educationLevel = $state.stats.educationLevel
    }
    childrenCount = $state.family.children.Count
    grandchildrenCount = $state.family.grandchildrenCount
    partner = [bool]$state.family.partner
    causeOfDeath = $state.causeOfDeath
    unlockedAchievements = @($state.unlockedAchievements)
    timestamp = [DateTime]::Now.ToString('yyyy-MM-dd HH:mm')
  }
  $all = @($record) + @(Get-PastLives)
  if ($all.Count -gt 50) { $all = $all[0..49] }
  Write-SaveFile 'past_lives.json' $all
}

function Clear-PastLives {
  if ($script:NoSave) { return }
  $path = Join-Path (Get-SaveDir) 'past_lives.json'
  if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Force }
}

# Save state contains data only. Executable decision handlers always come from lib/Decisions.ps1.
function Save-ActiveLife($state) {
  if ($script:NoSave -or -not $state.alive) { return }
  $snapshot = @{}
  foreach ($key in $state.Keys) {
    if ($key -notin @('pendingDecision', 'pendingReflection', 'newlyUnlocked')) { $snapshot[$key] = $state[$key] }
  }
  Write-SaveFile 'current_life.json' @{
    version = 1
    state = $snapshot
    decisionId = $(if ($state.pendingDecision) { $state.pendingDecision.id } else { $null })
    reflectionAge = $(if ($state.pendingReflection) { $state.yearsLived } else { $null })
  }
}

function ConvertTo-StateValue($value) {
  if ($null -eq $value) { return $null }
  if ($value -is [System.Management.Automation.PSCustomObject]) {
    $map = @{}
    foreach ($p in $value.PSObject.Properties) { $map[$p.Name] = ConvertTo-StateValue $p.Value }
    return $map
  }
  if ($value -is [array]) {
    $items = @($value | ForEach-Object { ConvertTo-StateValue $_ })
    return ,$items
  }
  return $value
}

function Read-ActiveLife {
  $path = Join-Path (Get-SaveDir) 'current_life.json'
  if (-not (Test-Path -LiteralPath $path)) { return $null }
  try {
    $records = @(Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json)
    if ($records.Count -ne 1 -or $records[0].version -ne 1) { throw 'Unsupported save format.' }
    $record = $records[0]
    $state = ConvertTo-StateValue $record.state
    if (-not $state.alive -or -not $state.country.id -or -not $script:CountryById.ContainsKey($state.country.id) -or
        $null -eq $state.stats -or $state.yearsLived -lt 0 -or $state.yearsLived -gt 115 -or $null -eq $state.log) {
      throw 'Incomplete save data.'
    }
    foreach ($key in @('log','unlockedAchievements','peers')) {
      $list = New-Object System.Collections.ArrayList
      foreach ($item in @($state[$key])) { [void]$list.Add($item) }
      $state[$key] = $list
    }
    foreach ($key in @('children','siblingList')) {
      $list = New-Object System.Collections.ArrayList
      foreach ($item in @($state.family[$key])) { [void]$list.Add($item) }
      $state.family[$key] = $list
    }
    $state.pendingDecision = $null
    if ($record.decisionId) {
      $state.pendingDecision = $script:DECISIONS[$record.decisionId]
      if (-not $state.pendingDecision) { throw 'Unknown decision.' }
    }
    $state.pendingReflection = $null
    if ($null -ne $record.reflectionAge) {
      $state.pendingReflection = $script:Data.reflections."$($record.reflectionAge)"
      if (-not $state.pendingReflection) { throw 'Unknown reflection.' }
    }
    $state.newlyUnlocked = $null
    return $state
  }
  catch {
    Write-Warning (L 'The saved life could not be loaded. The file has been kept.' '保存した人生を読み込めませんでした。ファイルは保持されています。' '无法读取存档，文件已保留。')
    return $null
  }
}

function Clear-ActiveLife {
  if ($script:NoSave) { return }
  $path = Join-Path (Get-SaveDir) 'current_life.json'
  if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Force }
}
