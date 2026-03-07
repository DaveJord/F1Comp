$raceInputCsv = Import-Csv .\races.csv
$bonusAnswers = Import-csv .\bonusAnswers.csv
$bonusQuestions = Import-csv .\bonusQuestions.csv
$sideBets = Import-csv .\sideBets.csv -WarningAction Ignore | Select-Object Race, Bet, P1, P1Pick, P2, P2Pick, Result 

$raceResultsRow = $raceInputCsv[0]

$pointsAllorNothing = 200

$pointsCorrectPosition = 10
$pointsTopFive = 2

$pointsCorrectPositionPreQualy = 15
$pointsTopFivePreQualy = 3

$pointsH2H = 5
$pointsBQ = 20

$pointsPSQ = 30



$raceInputArray = @()
for ($x = 0; $x -le (($raceInputCsv.Name).Count); $x++) {
    $raceInputArray += $raceInputCsv[($x + 1)]
}

$tracks = @{
    'Race1'  = 'AUS'
    'Race2'  = 'CHN'
    'Race3'  = 'JAP'
    'Race4'  = 'BAH'
    'Race5'  = 'SAU'
    'Race6'  = 'MIA'
    'Race7'  = 'CAN'
    'Race8'  = 'MON'
    'Race9'  = 'BAR'
    'Race10' = "AST"
    'Race11' = 'GBR'
    'Race12' = 'BEL'
    'Race13' = 'HUN'
    'Race14' = 'NLD'
    'Race15' = 'MZA'
    'Race16' = 'SPN'
    'Race17' = 'AZE'
    'Race18' = 'SGP'
    'Race19' = 'TEX'
    'Race20' = 'MEX'
    'Race21' = 'BRA'
    'Race22' = 'LAS'
    'Race23' = 'QAT'
    'Race24' = 'ABU'
}

$data = @()

#$bonusPointsWinners = @()

for ($init = 0; $init -lt (($raceInputArray.Name).Count); $init++) {
    $data += @(
        [pscustomobject]@{Name = $raceInputArray[$init].Name; $tracks.Race1 = ""; $tracks.Race2 = ""; $tracks.Race3 = ""; $tracks.Race4 = ""; $tracks.Race5 = "";
            $tracks.Race6 = ""; $tracks.Race7 = ""; $tracks.Race8 = ""; $tracks.Race9 = ""; $tracks.Race10 = ""; $tracks.Race11 = "";
            $tracks.Race12 = ""; $tracks.Race13 = ""; $tracks.Race14 = ""; $tracks.Race15 = ""; $tracks.Race16 = ""; $tracks.Race17 = "";
            $tracks.Race18 = ""; $tracks.Race19 = ""; $tracks.Race20 = ""; $tracks.Race21 = ""; $tracks.Race22 = ""; $tracks.Race23 = "";
            $tracks.Race24 = ""; CDP = ""; BP = ""; Points = ""; Total = ""; Bonus = ""; Final = "";
        }
    )
}



for ($r = 1; $r -le $tracks.Count; $r++) {
    $raceNo = "Race" + $r.ToString()
    $betType = "-BetType"
    $first = "-1"
    $second = "-2"
    $third = "-3"
    $fourth = "-4"
    $fifth = "-5"
    $H2H = "-H2H"
    $BQT = "-BQT"
    $bonusQ = "-BQ"


    $resultArray = @()
    $resultArray += $raceResultsRow.($raceNo + $first), $raceResultsRow.($raceNo + $second), $raceResultsRow.($raceNo + $third), $raceResultsRow.($raceNo + $fourth), $raceResultsRow.($raceNo + $fifth)

    $currentRaceNo = $r - 1
    if ($resultArray -contains "" -or $currentRaceNo -eq $tracks.Count) {

        $playerRaceSelection = @()
        for ($p = 0; $p -lt ($data.Name).Count; $p++) {
            $playerRaceSelection += @(
                [pscustomobject]@{Name = $data[$p].Name;
                    BetType           = $raceInputArray[$p].($raceNo + $betType);
                    First              = $raceInputArray[$p].($raceNo + $first);
                    Second             = $raceInputArray[$p].($raceNo + $second);
                    Third              = $raceInputArray[$p].($raceNo + $third);
                    Fourth             = $raceInputArray[$p].($raceNo + $third);
                    Fifth              = $raceInputArray[$p].($raceNo + $third);
                    Head2Head          = $raceInputArray[$p].($raceNo + $H2H)
                    BonusQ             = $raceInputArray[$p].($raceNo + $bonusQ)
                }
            )
        }
        #$stewards = @()
        #$stewards = Get-Random -Count 2 $data.Name
            
        Write-Host "`nPlayer Selection for" $tracks.$raceNo
        $playerRaceSelection | Sort-Object Name | Format-Table
        #Write-Host "The race stewards are" $stewards[0] "and" $stewards[1]
        break
    }

    $GPData = @()
    <#
    for ($init = 0; $init -lt (($raceInputArray.Name).Count); $init++) {
        $GPData += @(
            [pscustomobject]@{Name = $raceInputArray[$init].Name; Points = "";IncorrectAnswers = "";CorrectBonus = "";
            }
        )
    } #>

    for ($p = 0; $p -lt ($data.Name).Count; $p++) {
        $playerArray = @()
        $playerArray += $raceInputArray[$p].($raceNo + $first), $raceInputArray[$p].($raceNo + $second), $raceInputArray[$p].($raceNo + $third), $raceInputArray[$p].($raceNo + $fourth), $raceInputArray[$p].($raceNo + $fifth)

        $playerRaceScore = 0
        $playerCorrectAnswer = 0
        $playerIncorrectCount = 0
        $playerBonusPoints = 0


        ## All or nothing Bet
        if (($raceInputArray[$p].($raceNo + $betType)) -eq "All") {

            $allCorrect = $true

                for ($q = 0; $q -le 4; $q++) {
                    if ($resultArray[$q] -ne $playerArray[$q]) {
                        $allCorrect = $false
                        $playerIncorrectCount += 1
                    }
                    if ($resultArray[$q] -eq $playerArray[$q]) {
                        $playerCorrectAnswer += 1
                    }
                }

            if($allCorrect)
            {$playerRaceScore += $pointsAllorNothing}

        }

        ## Pre Qualy Bet
        if (($raceInputArray[$p].($raceNo + $betType)) -eq "Pre") {

            for ($q = 0; $q -le 4; $q++) {
                if ($resultArray[$q] -eq $playerArray[$q]) {
                   $playerCorrectAnswer += 1
                   $playerRaceScore += $pointsCorrectPositionPreQualy
                }
                elseif ($playerArray -contains $resultArray[$q]){
                    $playerRaceScore += $pointsTopFivePreQualy
                }
                else{
                    $playerIncorrectCount += 1
                }
        }
    }

        ## Reg Bet
        if (($raceInputArray[$p].($raceNo + $betType)) -eq "Reg") {

            for ($q = 0; $q -le 4; $q++) {
                if ($resultArray[$q] -eq $playerArray[$q]) {
                   $playerCorrectAnswer += 1
                   $playerRaceScore += $pointsCorrectPosition
                }
                elseif ($playerArray -contains $resultArray[$q]){
                    $playerRaceScore += $pointsTopFive
                }
                else{
                    $playerIncorrectCount += 1
                }
             }
        }

        ## Head to Head
        if (($raceResultsRow.($raceNo + $H2H)) -match ($raceInputArray[$p].($raceNo + $H2H))) {
                if (($raceInputArray[$p].($raceNo + $H2H)) -ne "") {           
                    $playerRaceScore += $pointsH2H
                    $playerCorrectAnswer += 1
                } else {
                    $playerIncorrectCount += 1
                }
        }

        ##Bonus Questions

        $bonusAns = $raceResultsRow.($raceNo + $bonusQ)
        $playerAns = ($raceInputArray[$p].($raceNo + $bonusQ))


        if($playerAns -ne "N/A"){
        if (($raceResultsRow.($raceNo + $BQT)) -eq "StrMatch"){
            if ($playerAns -ne "") {
                if ($bonusAns -match $playerAns){
                    $playerRaceScore += $pointsBQ 
                    $playerBonusPoints += 1
                    $playerCorrectAnswer += 1
                }else {
                    $playerIncorrectCount += 1
                }
            }
        }

        if (($raceResultsRow.($raceNo + $BQT)) -eq "IntMatch"){
            if([int]$bonusAns -eq [int]$playerAns){
                $playerRaceScore += $pointsBQ
                $playerBonusPoints += 1
                $playerCorrectAnswer += 1
            }else {
                    $playerIncorrectCount += 1
                }
        }

        if (($raceResultsRow.($raceNo + $BQT)) -eq "IntDiff"){

            $diff = ([math]::Abs([int]$bonusAns - [int]$playerAns))
               
                if (($diff * 2) -lt $pointsBQ) {
                    $bonusPoints = ($pointsBQ - ($diff * 2))
                    if($diff -eq 0){
                        $playerBonusPoints += 1
                        $playerCorrectAnswer += 1
                    }
                    $playerRaceScore += $bonusPoints
                }else {
                    $playerIncorrectCount += 1
                } 
        }
        }

    [double]$data[($p)].Points += $playerRaceScore
    [double]$data[($p)].Total += $playerRaceScore
    [int]$data[($p)].CDP += $playerCorrectAnswer
    [int]$data[($p)].BP += $playerBonusPoints

    $data[($p)].($tracks.$raceNo) = $playerRaceScore

    $GPData += @(
            [pscustomobject]@{Name = $data[($p)].Name;Points = $playerRaceScore;IncorrectAnswers = $playerIncorrectCount;CorrectBonus = $playerBonusPoints;
            }
        )   
    }    
    }


for ($p = 0; $p -lt (($data.Name).Count); $p++) {
    $sideBetScore = 0
    #write-host $data[$p].Name
    for ($b = 0; $b -lt (($sideBets.Race).Count); $b++) {
        if ($sideBets[$b].Result -ne "") {
            if ($data[$p].Name -eq $sideBets[$b].P1) {
                if ($sideBets[$b].P1Pick -match $sideBets[$b].Result) {
                    $sideBetScore += 5
                }
                else {
                    $sideBetScore -= 5 
                }
            }
            if ($data[$p].Name -eq $sideBets[$b].P2) {
                if ($sideBets[$b].P2Pick -match $sideBets[$b].Result) {
                    $sideBetScore += 5
                }
                else {
                    $sideBetScore -= 5 
                }
            }
        }
    }
    #[double]$data[($p)].Bets += $sideBetScore
    [double]$data[($p)].Total += $sideBetScore
}

for ($b = 0; $b -lt (($data.Name).Count); $b++) {

    $playerBonus = 0.00
    for ($q = 0; $q -lt (($bonusAnswers.Question).Count); $q++) {
        $pn = $data[$b].Name

        if($bonusAnswers[$q].$pn -ne ""){
        if ($bonusAnswers[$q].$pn -eq $bonusQuestions[$q].Answer) {
            $playerBonus += $pointsPSQ
        }
    }
    }
    $data[$b].Bonus = $playerBonus
    $data[$b].Total = $data[$b].Total + $data[$b].Bonus
}

$previousRace = "Race" + ($currentRaceNo - 1).ToString()

if($currentRaceNo -eq 0){
        $currentRaceNo = 1
        $currentRace = "Race" + $currentRaceNo.ToString()
    }else{
        $currentRace = "Race" + $currentRaceNo.ToString() 
    }
if ($currentRace -ne 24) {
    $nextRace = "Race" + ($currentRaceNo + 1).ToString()
}

<# Sidebets not in use for 2026
Write-Host "`nSidebets:"
$displayBets = @()
foreach ($bet in $sideBets) {
    if ($bet.Race -Match ($tracks.$nextRace)) {
        $displayBets += $bet
    }
}
$displayBets | Format-Table
#>


Write-Host "`nLeaderboard:"
if(($tracks.$previousRace)){   
    $tableOutput = $data | Select-Object Name, ($tracks.$previousRace), ($tracks.$currentRace), ($tracks.$nextRace), BP, Points, Bonus, Total | Sort-Object -Property Total, CDP -Descending | Format-Table | Out-String
} else{
     $tableOutput = $data | Select-Object Name, ($tracks.$currentRace), ($tracks.$nextRace), BP, Points, Bonus, Total | Sort-Object -Property Total, CDP -Descending | Format-Table | Out-String
     #($tracks.$currentRace), ($tracks.$nextRace),
}


Write-Host $tableOutput



$data | Sort-Object -Property Total, CDP -Descending | Export-Csv .\Leaderboard.csv -NoTypeInformation -Force

$maxPoints = ($GPData | Measure-Object -Property Points -Maximum).Maximum
$topScorers = $GPData | Where-Object { $_.Points -eq $maxPoints } | Select-Object -ExpandProperty Name

$maxIncorrect = ($GPData | Measure-Object -Property IncorrectAnswers -Maximum).Maximum
$mostIncorrect = $GPData | Where-Object { $_.IncorrectAnswers -eq $maxIncorrect } | Select-Object -ExpandProperty Name

$bonusWinners = $GPData | Where-Object { $_.CorrectBonus -eq 1 } | Select-Object -ExpandProperty Name

$bonusOutput = if ($bonusWinners) { 
    $bonusWinners -join ', ' 
} else { 
    "Not even one of ye." 
}


Write-Host "Podium... Top Points Scorer(s) this GP: " -NoNewline; Write-Host "$($topScorers -join ', ')" -ForegroundColor "Yellow"
Write-Host "`nGone for a Stroll... Most Incorrect Answers: " -NoNewline; Write-Host "$($mostIncorrect -join ', ')" -ForegroundColor "Red"
Write-Host "`nBonus Question Correct: "-NoNewline; Write-Host "$($bonusOutput -join ', ')`n`n" -ForegroundColor "Cyan"


<# Sidebets not in use for 2026
Write-Host "`nSidebets Results:"
$displayBets = @()
foreach ($bet in $sideBets) {
    if ($bet.Race -Match ($tracks.$currentRace)) {
        $displayBets += $bet
    }
}
$displayBets | Format-Table
#>
