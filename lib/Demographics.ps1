# Birth lottery: country, family, identity, culture and the 4 peer babies.
# Port of src/engine/ (original repo) demographics.js.

$script:SportNames = @{
  football    = @{ ja = 'サッカー'; en = 'Football (Soccer)'; zh = '足球' }
  cricket     = @{ ja = 'クリケット'; en = 'Cricket'; zh = '板球' }
  badminton   = @{ ja = 'バドミントン'; en = 'Badminton'; zh = '羽毛球' }
  tabletennis = @{ ja = '卓球'; en = 'Table Tennis'; zh = '乒乓球' }
  baseball    = @{ ja = '野球'; en = 'Baseball'; zh = '棒球' }
  basketball  = @{ ja = 'バスケットボール'; en = 'Basketball'; zh = '篮球' }
  icehockey   = @{ ja = 'アイスホッケー'; en = 'Ice Hockey'; zh = '冰球' }
  rugby       = @{ ja = 'ラグビー'; en = 'Rugby'; zh = '橄榄球' }
  muaythai    = @{ ja = 'ムエタイ'; en = 'Muay Thai'; zh = '泰拳' }
  running     = @{ ja = '陸上・ランニング'; en = 'Track & Field / Running'; zh = '田径与跑步' }
  volleyball  = @{ ja = 'バレーボール'; en = 'Volleyball'; zh = '排球' }
}

$script:VietnamNames = @{
  m = @('Minh', 'Anh', 'Huy', 'Dũng', 'Hoàng', 'Phúc', 'Tuấn', 'Đức', 'Nam', 'Hải', 'Trung', 'Long', 'Hiếu', 'Thắng', 'Khoa', 'Quân', 'Tùng', 'Khang', 'Lâm', 'Bảo', 'Khánh', 'Duy', 'Kiên', 'Việt', 'Đạt', 'Cường', 'Sơn', 'Tài')
  f = @('Linh', 'Hương', 'Mai', 'Lan', 'Trang', 'Ngọc', 'Phương', 'Thảo', 'Hà', 'Quỳnh', 'Giang', 'My', 'Châu', 'Nhi', 'Vy', 'Hạnh', 'Yến', 'Diệp', 'Trâm', 'Ngân', 'Thu', 'Ánh', 'Dung', 'Tâm', 'Hồng', 'Tuyết', 'Nhung', 'Bích')
  s = @('Nguyễn', 'Trần', 'Lê', 'Phạm', 'Hoàng', 'Huỳnh', 'Phan', 'Vũ', 'Võ', 'Đặng', 'Bùi', 'Đỗ', 'Hồ', 'Ngô', 'Dương', 'Lý', 'Đào', 'Đinh')
}

function Resolve-CulturalIdentity($country, [string]$religion) {
  $dish = $script:Data.dishes.($country.id)
  if (-not $dish) { $dish = @{ ja = '伝統の家庭料理'; en = 'Traditional homecooked specialty'; zh = '传统家常菜' } }

  $id = $country.id
  $sportKey = 'football'
  if (@('IND', 'PAK', 'BGD', 'LKA', 'AFG') -contains $id) { $sportKey = 'cricket' }
  elseif (@('USA', 'DOM', 'JPN', 'CUB', 'NIC', 'PAN', 'TWN') -contains $id) { $sportKey = $(if (Test-Chance 0.6) { 'baseball' } else { 'basketball' }) }
  elseif (@('CAN', 'RUS', 'FIN', 'SWE', 'CZE', 'SVK', 'NOR') -contains $id) { $sportKey = 'icehockey' }
  elseif ($id -eq 'CHN') { $sportKey = $(if (Test-Chance 0.5) { 'tabletennis' } else { 'badminton' }) }
  elseif ($id -eq 'THA') { $sportKey = $(if (Test-Chance 0.4) { 'muaythai' } else { 'football' }) }
  elseif (@('VNM', 'IDN', 'MYS') -contains $id) { $sportKey = $(if (Test-Chance 0.45) { 'badminton' } else { 'football' }) }
  elseif (@('NZL', 'ZAF', 'FJI', 'SAM', 'TON') -contains $id) { $sportKey = 'rugby' }
  $sport = $script:SportNames[$sportKey]

  $festival = $script:Data.festivals.$id
  if (-not $festival) {
    $festMap = @{
      C = @{ ja = 'クリスマスと新年'; en = 'Christmas & New Year Celebration'; zh = '圣诞节与新年' }
      M = @{ ja = 'イード・アル＝フィトル'; en = 'Eid al-Fitr Celebration'; zh = '开斋节' }
      H = @{ ja = '光の祭典ディワリ'; en = 'Diwali Festival of Lights'; zh = '排灯节' }
      B = @{ ja = 'ウェーサーカ祭（仏誕祭）'; en = "Vesak (Buddha's Birthday)"; zh = '卫塞节（佛诞日）' }
      J = @{ ja = '過越祭'; en = 'Passover Festival'; zh = '逾越节' }
      N = @{ ja = '新年の祭り'; en = 'New Year Festival'; zh = '新年庆典' }
      F = @{ ja = '先祖をまつる伝統の祭り'; en = 'Ancestral Folk Festival'; zh = '祭祖的传统节日' }
      S = @{ ja = 'ヴァイサーキー祭'; en = 'Vaisakhi Festival'; zh = '丰收节（Vaisakhi）' }
    }
    $festival = $(if ($festMap.ContainsKey($religion)) { $festMap[$religion] } else { $festMap.N })
  }

  $ethnicity = @{ ja = '先住民・多数派民族'; en = 'Indigenous / Majority'; zh = '原住民或主体民族' }
  if ($id -eq 'VNM') { $ethnicity = @{ ja = 'キン族（ベト族）'; en = 'Kinh (Viet)'; zh = '京族（越族）' } }
  elseif ($id -eq 'CHN') { $ethnicity = @{ ja = '漢民族'; en = 'Han Chinese'; zh = '汉族' } }
  elseif ($id -eq 'JPN') { $ethnicity = @{ ja = '大和民族'; en = 'Yamato'; zh = '大和民族' } }
  elseif ($id -eq 'KOR') { $ethnicity = @{ ja = '朝鮮民族'; en = 'Korean'; zh = '朝鲜民族' } }

  $eth = $script:Data.ethnicities
  if ($eth -and $eth.ETH_C -and $eth.ETH_C.$id) {
    foreach ($gk in @($eth.ETH_C.$id)) {
      $g = $eth.ETH_G.$gk
      if ($g) {
        $s = $(if ($g.s) { [double]$g.s } else { 5 })
        if (Test-Chance ($s / 100)) {
          if ($g.n) { $ethnicity = $g.n }
          break
        }
      }
    }
  }

  $hobbyKeys = @($script:Data.hobbies.PSObject.Properties.Name)
  $picked = New-Object System.Collections.ArrayList
  while ($picked.Count -lt 2 -and $hobbyKeys.Count -gt 0) {
    $k = Get-Pick $hobbyKeys
    if (-not $picked.Contains($k)) { [void]$picked.Add($k) }
  }
  $hobbies = @($picked | ForEach-Object {
      $h = $script:Data.hobbies.$_
      @{ id = $_; name = @{ ja = $h.ja; en = $h.en; zh = $h.zh } }
    })

  return @{ dish = $dish; sport = $sport; festival = $festival; ethnicity = $ethnicity; hobbies = $hobbies }
}

function Select-Country($countries) {
  $list = @($countries)
  $weights = @($list | ForEach-Object { if ($_.b) { [double]$_.b } else { 1000 } })
  return Get-WeightedPick $list $weights
}

function Select-Religion([string]$relStr) {
  if (-not $relStr) { return 'N' }
  $obj = [ordered]@{}
  foreach ($p in $relStr.Split(',')) {
    $code = $p.Substring(0, 1)
    $val = 0
    if (-not [int]::TryParse($p.Substring(1), [ref]$val) -or $val -eq 0) { $val = 1 }
    $obj[$code] = $val
  }
  return Get-WeightedPickKey $obj
}

function Get-NameCluster([string]$id) {
  switch -Regex ($id) {
    '^VNM$' { return 'vi' }
    '^(CHN|TWN|HKG|MAC)$' { return 'zh' }
    '^JPN$' { return 'ja' }
    '^(KOR|PRK)$' { return 'ko' }
    '^(USA|GBR|CAN|AUS|NZL|IRL)$' { return 'en' }
    '^(FRA|BEL|CHE)$' { return 'fr' }
    '^(DEU|AUT)$' { return 'de' }
    '^(ESP|MEX|COL|ARG|PER|CHL)$' { return 'es' }
    '^(BRA|PRT)$' { return 'pt' }
    '^(RUS|UKR|BLR|KAZ)$' { return 'ru' }
    '^IND$' { return 'hi' }
    '^IDN$' { return 'id' }
    '^THA$' { return 'th' }
    '^NGA$' { return 'ng' }
    '^(EGY|SAU|IRQ|MAR|DZA)$' { return 'ar' }
  }
  return 'en'
}

function New-PersonName([string]$countryId, [string]$sex) {
  if ($countryId -eq 'VNM') {
    $s = Get-Pick $script:VietnamNames.s
    $g = $(if ($sex -eq 'M') { Get-Pick $script:VietnamNames.m } else { Get-Pick $script:VietnamNames.f })
    return @{ first = $g; last = $s; full = "$s $g" }
  }
  $cl = Get-NameCluster $countryId
  $pool = $script:Data.names.$cl
  if (-not $pool) { $pool = $script:Data.names.en }
  $gk = $(if ($sex -eq 'M') { 'm' } else { 'f' })
  if ($pool -and $pool.$gk -and $pool.s) {
    $g = Get-Pick $pool.$gk
    $s = Get-Pick $pool.s
    $full = $(if (@('ko', 'zh', 'ja', 'vi') -contains $cl) { "$s $g" } else { "$g $s" })
    return @{ first = $g; last = $s; full = $full }
  }
  $ff = $(if ($sex -eq 'M') { Get-Pick @('James', 'Alex', 'Liam', 'Lucas', 'Noah') } else { Get-Pick @('Emma', 'Sophia', 'Mia', 'Olivia', 'Chloe') })
  $fl = Get-Pick @('Smith', 'Johnson', 'Williams', 'Brown', 'Jones')
  return @{ first = $ff; last = $fl; full = "$ff $fl" }
}

function New-BirthIdentity($country, $era = 'current') {
  $birthYear = Resolve-BirthYear "$era"
  $yearDelta = [Math]::Max(0, $script:DataYear - $birthYear)
  $calFactor = 1.0
  $cal = $script:Data.eras.CAL
  if ($cal -and $cal.($country.id)) { $calFactor = [double]$cal.($country.id) }

  $cc = Copy-Country $country
  $cc.yr = $birthYear
  if ($yearDelta -gt 0) {
    $cc.le = [Math]::Max(35, (Get-JsRound ($country.le - ($yearDelta * 0.22 * $calFactor))))
    $cc.u5 = Get-JsRound ($country.u5 * (1 + ($yearDelta / 55) * $calFactor))
    $cc.im = Get-JsRound ($country.im * (1 + ($yearDelta / 55) * $calFactor))
    $cc.ppp = Get-JsRound ($country.ppp * [Math]::Pow(0.97, $yearDelta / 2))
  }

  $srb = switch ($country.id) { 'CHN' { 0.528 } 'IND' { 0.519 } 'VNM' { 0.515 } default { 0.512 } }
  $sex = $(if (Test-Chance $srb) { 'M' } else { 'F' })
  $q = Get-RandomInt 1 5
  $urbanProb = Get-Clamp ($country.urb / 100 + ($q - 3) * 0.05) 0.05 0.95
  $urban = Test-Chance $urbanProb

  if ($urban) {
    $cities = $script:Data.citiesEn.($country.id)
    $cityNameEn = $(if ($cities) { (Get-Pick $cities.Split(',')).Trim() } else { 'Capital City' })
    $cityName = $cityNameEn
  }
  else { $cityName = 'Rural Area'; $cityNameEn = 'Rural Area' }

  $religion = Select-Religion $country.rel
  $name = New-PersonName $country.id $sex

  $tfr = [double]$country.tfr
  $momAge = [int](Get-JsRound (Get-Clamp (20 + (Get-RandomInt 0 15) + ($tfr - 2) * 1.5) 17 45))
  $dadAge = [int](Get-JsRound (Get-Clamp ($momAge + (Get-RandomInt 1 5)) 18 55))
  $absentP = switch ($country.p) { 'lac' { 0.25 } 'ssa' { 0.2 } default { 0.08 } }
  $absentFather = Test-Chance $absentP

  $expectedSiblings = [int][Math]::Max(0, (Get-JsRound ($tfr - 1 + ((Get-RandomInt -1 2) * 0.8))))
  $olderSiblings = [int][Math]::Min($expectedSiblings, [Math]::Max(0, [Math]::Floor(($momAge - 19) / 2.5)))
  $youngerSiblings = [int][Math]::Max(0, $expectedSiblings - $olderSiblings)
  $siblingList = New-Object System.Collections.ArrayList
  for ($i = 0; $i -lt $olderSiblings; $i++) {
    $sSex = $(if (Test-Chance 0.5) { 'M' } else { 'F' })
    $sAge = ($olderSiblings - $i) * 2 + (Get-RandomInt 1 3)
    [void]$siblingList.Add(@{
        relation = @{ en = $(if ($sSex -eq 'M') { 'older brother' } else { 'older sister' }); ja = $(if ($sSex -eq 'M') { '兄' } else { '姉' }); zh = $(if ($sSex -eq 'M') { '哥哥' } else { '姐姐' }) }
        age = $sAge; sex = $sSex
      })
  }

  if ($q -ge 4) {
    $momJob = Get-Pick @('civil servant', 'teacher', 'nurse', 'office manager', 'accountant')
    $dadJob = Get-Pick @('civil servant', 'engineer', 'teacher', 'commercial farmer', 'doctor')
  }
  elseif ($q -eq 3) {
    $momJob = Get-Pick @('homemaker', 'trader', 'clerk', 'tailor', 'cook')
    $dadJob = Get-Pick @('commercial farmer', 'driver', 'carpenter', 'mechanic', 'clerk')
  }
  else {
    $momJob = Get-Pick @('homemaker', 'agricultural worker', 'street vendor', 'factory worker')
    $dadJob = Get-Pick @('worker/farmer', 'day laborer', 'construction worker', 'driver')
  }

  $baseHealth = Get-Clamp (85 + ($q - 3) * 3 - ($country.u5 / 10) + (Get-RandomInt -5 5)) 40 99
  $baseHappiness = Get-Clamp (65 + ($q - 3) * 2 + (Get-RandomInt -6 6)) 45 95
  $baseSmarts = Get-Clamp (50 + ($q - 3) * 2 + (Get-RandomInt -8 8)) 35 95
  $baseSocial = Get-Clamp (55 + (Get-RandomInt -8 8)) 35 95

  $culture = Resolve-CulturalIdentity $cc $religion

  return @{
    bornCountryId = $country.id
    country       = $cc
    birthYear     = $birthYear
    sex           = $sex
    name          = $name
    q             = $q
    urban         = $urban
    cityName      = $cityName
    cityNameEn    = $cityNameEn
    religion      = $religion
    culture       = $culture
    currentFocus  = 'study'
    unlockedAchievements = New-Object System.Collections.ArrayList
    stats         = @{
      health = $baseHealth; happiness = $baseHappiness; smarts = $baseSmarts; social = $baseSocial
      wealth = 0; educationLevel = 0
    }
    family        = @{
      mom = @{ age = $momAge; alive = $true; job = $momJob }
      dad = @{ age = $dadAge; alive = (-not $absentFather); absent = $absentFather; job = $dadJob }
      olderSiblings = $olderSiblings
      youngerSiblings = $youngerSiblings
      siblingList = $siblingList
      partner = $null
      children = New-Object System.Collections.ArrayList
      grandchildrenCount = 0
    }
    job           = 'Infant'
    jobId         = 'infant'
    hobbies       = $culture.hobbies
    flags         = @{}
    yearsLived    = 0
    causeOfDeath  = $null
  }
}

# 4 babies born in the same second on 4 different continents
function New-PeerBabies {
  $peers = New-Object System.Collections.ArrayList
  foreach ($reg in @('ssa', 'eap', 'lac', 'eca')) {
    $regCountries = @($script:Data.countries | Where-Object { $_.p -eq $reg })
    $c = $(if ($regCountries.Count) { Select-Country $regCountries } else { Select-Country $script:Data.countries })
    $sex = $(if (Test-Chance 0.5) { 'M' } else { 'F' })
    $name = New-PersonName $c.id $sex
    [void]$peers.Add(@{
        id = "peer_$($c.id)_$([Math]::Floor((Get-Rnd) * 10000))"
        countryId = $c.id
        country = $c
        sex = $sex
        name = $name
        alive = $true
        deathAge = $null
        deathCause = $null
        status = @{ ja = '新生児'; en = 'Newborn'; zh = '新生儿' }
      })
  }
  return , $peers
}
