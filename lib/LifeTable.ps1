# Demographic maths: UN-style life tables (Gompertz-Makeham, binary-search calibrated
# to the country's life expectancy) and a log-normal income model driven by Gini.
# Port of src/engine/ (original repo) lifeTable.js.

$script:LtCache = @{}

# Inverse standard normal CDF (Acklam's algorithm)
function Get-InvNorm([double]$p) {
  if ($p -le 0 -or $p -ge 1) { throw 'Probability must be between zero and one.' }
  $a = @(-39.69683028665376, 220.9460984245205, -275.9285104469687, 138.357751867269, -30.66479806614716, 2.506628277459239)
  $b = @(-54.47609879822406, 161.5858368580409, -155.6989798598866, 66.80131188771972, -13.28068155288572)
  $c = @(-0.007784894002430293, -0.3223964580411365, -2.400758277161838, -2.549732539343734, 4.374664141464968, 2.938163982698783)
  $d = @(0.07784695709041462, 0.3224671290700398, 2.445134137142996, 3.754408661907416)
  if ($p -ge 0.02425 -and $p -le 0.97575) {
    $q = $p - 0.5
    $r = $q * $q
    return $q * ((((($a[0] * $r + $a[1]) * $r + $a[2]) * $r + $a[3]) * $r + $a[4]) * $r + $a[5]) /
      ((((($b[0] * $r + $b[1]) * $r + $b[2]) * $r + $b[3]) * $r + $b[4]) * $r + 1)
  }
  $r = $(if ($p -lt 0.5) { $p } else { 1 - $p })
  $s = [Math]::Sqrt(-2 * [Math]::Log($r))
  $x = ((((($c[0] * $s + $c[1]) * $s + $c[2]) * $s + $c[3]) * $s + $c[4]) * $s + $c[5]) /
    (((($d[0] * $s + $d[1]) * $s + $d[2]) * $s + $d[3]) * $s + 1)
  if ($p -lt 0.5) { return $x } else { return -$x }
}

# Standard normal CDF (Abramowitz & Stegun)
function Get-NormCdf([double]$x) {
  $t = 1 / (1 + 0.2316419 * [Math]::Abs($x))
  $d = 0.3989423 * [Math]::Exp(-$x * $x / 2)
  $p = $d * $t * (0.3193815 + $t * (-0.3565638 + $t * (1.781478 + $t * (-1.821256 + $t * 1.330274))))
  if ($x -gt 0) { return 1 - $p } else { return $p }
}

function Get-OrDefault($v, $default) {
  if ($null -eq $v -or ($v -is [string] -and $v -eq '') -or ($v -isnot [string] -and [double]$v -eq 0)) { return $default }
  return $v
}

function Build-LtQ([double]$B, [hashtable]$P) {
  $q = New-Object 'double[]' 111
  $q[0] = $P.q0
  for ($i = 1; $i -le 4; $i++) { $q[$i] = $P.qc[$i - 1] }
  for ($x = 5; $x -le 110; $x++) {
    if ($x -eq 110) { $q[$x] = 1.0 }
    elseif ($x -lt 15) { $q[$x] = $P.q514 }
    else {
      $oldest = [Math]::Min(0.7, $P.oldK * [Math]::Exp(0.15 * ($x - 100)))
      $haz = [Math]::Max($P.A + $B * [Math]::Exp($P.g * ($x + 0.5)), $oldest)
      $q[$x] = [Math]::Min(1.0, 1 - [Math]::Exp(-$haz))
    }
  }
  $l = 1.0; $e = 0.0
  for ($x = 0; $x -le 110; $x++) {
    $dd = $l * $q[$x]
    if ($x -eq 0) { $e += $l - 0.85 * $dd } else { $e += $l - 0.5 * $dd }
    $l -= $dd
  }
  return @{ q = $q; e = $e }
}

function Get-LifeTable($country, [string]$sex = 'M') {
  $key = "$($country.id)_$($sex)_$($country.yr)"
  if ($script:LtCache.ContainsKey($key)) { return $script:LtCache[$key] }

  $gap = [double](Get-OrDefault $country.gap 4.5)
  $le = [double]$country.le
  $e0 = $(if ($sex -eq 'F') { $le + $gap * 0.49 } else { $le - $gap * 0.51 })
  $k = $(if ($sex -eq 'F') { 0.92 } else { 1.08 })
  $u5v = [double](Get-OrDefault $country.u5 25)
  $imv = [double](Get-OrDefault $country.im 15)
  $q0 = [Math]::Min(0.25, $imv / 1000 * $k)
  $u5 = [Math]::Min(0.35, [Math]::Max($q0 + 0.0005, $u5v / 1000 * $k))
  $H = -[Math]::Log((1 - $u5) / (1 - $q0))
  $qc = @(0.4, 0.27, 0.19, 0.14) | ForEach-Object { 1 - [Math]::Exp(-$H * $_) }
  $P = @{
    q0   = $q0
    qc   = @($qc)
    A    = 0.00025 + 0.000028 * $u5v
    g    = [Math]::Min([Math]::Max(0.112 - 0.00016 * $u5v, 0.085), 0.112)
    q514 = 1 - [Math]::Pow(1 - [Math]::Min(0.2, 0.2 * $u5v / 1000 * $k), 0.1)
    oldK = $(if ($sex -eq 'F') { 0.39 } else { 0.5 })
  }

  $lo = [Math]::Log(1e-8); $hi = [Math]::Log(5e-2); $r = $null
  for ($i = 0; $i -lt 50; $i++) {
    $m = ($lo + $hi) / 2
    $r = Build-LtQ ([Math]::Exp($m)) $P
    if ($r.e -gt $e0) { $lo = $m } else { $hi = $m }
  }
  $l = New-Object 'double[]' 112
  $l[0] = 1.0
  for ($x = 0; $x -le 110; $x++) { $l[$x + 1] = $l[$x] * (1 - $r.q[$x]) }

  $result = @{ q = $r.q; l = $l; e0 = $e0 }
  $script:LtCache[$key] = $result
  return $result
}

function Get-SurvivalAtAge($country, [string]$sex, [double]$age) {
  $lt = Get-LifeTable $country $sex
  $a = [int][Math]::Min([Math]::Max((Get-JsRound $age), 0), 110)
  return $lt.l[$a]
}

# Remaining life expectancy at a given age from the life table.
function Get-RemainingLifeExpectancy($country, [string]$sex, [int]$age) {
  $lt = Get-LifeTable $country $sex
  $a = [Math]::Min([Math]::Max($age, 0), 110)
  if ($lt.l[$a] -le 0) { return 0 }
  $sum = 0.0
  for ($x = $a; $x -le 110; $x++) { $sum += ($lt.l[$x] + $lt.l[$x + 1]) / 2 }
  return $sum / $lt.l[$a]
}

function Get-IncomeSigma($country) {
  $g = [double](Get-OrDefault $country.gi 35)
  if ($g -gt 1) { $g /= 100 }
  if (@('ssa', 'sa', 'mena') -contains $country.p -or ($country.p -eq 'eap' -and $country.id -ne 'CHN')) { $g += 0.07 }
  $g = [Math]::Min([Math]::Max($g, 0.22), 0.68)
  return [Math]::Sqrt(2) * (Get-InvNorm (($g + 1) / 2))
}

# Annual income (USD PPP) at percentile pct
function Get-IncomeAt($country, [double]$pct) {
  $s = Get-IncomeSigma $country
  $ppp = [double](Get-OrDefault $country.ppp 15000)
  $cp = [Math]::Min([Math]::Max($pct, 0.003), 0.997)
  return (Get-JsRound ($ppp * 0.9 * [Math]::Exp($s * (Get-InvNorm $cp) - ($s * $s) / 2)))
}

function Get-PctOfIncome($country, [double]$income) {
  $s = Get-IncomeSigma $country
  $ppp = [double](Get-OrDefault $country.ppp 15000)
  $mu = [Math]::Log($ppp * 0.9) - ($s * $s) / 2
  return Get-NormCdf (([Math]::Log([Math]::Max(1, $income)) - $mu) / $s)
}
