$raceInputCsv = Import-Csv .\races.csv
$bonusInput = Import-csv .\bonus.csv
$bonusAnswers = Import-csv .\bonusAnswers.csv
$sideBets = Import-csv .\sideBets.csv -WarningAction Ignore | Select-Object Race,Bet,P1,P1Pick,P2,P2Pick,Result 


#Write-Host $sideBets 

#break

$checkBonus =  $bonusAnswers.Answer

$raceResultsRow = $raceInputCsv[0]

$raceInputArray = @()
for($x=0;$x -le (($raceInputCsv.Name).Count); $x++){
    $raceInputArray += $raceInputCsv[($x+1)]
}

$tracks = @{
    'Race1' = 'AUS'
    'Race2' = 'CHN'
    'Race3' = 'JAP'
    'Race4' = 'BAH'
    'Race5' = 'SAU'
    'Race6' = 'MIA'
    'Race7' = 'EmR'
    'Race8' = 'MON'
    'Race9' = 'SPN'
    'Race10' = "CAN"
    'Race11' = 'AUT'
    'Race12' = 'GBR'
    'Race13' = 'BEL'
    'Race14' = 'HUN'
    'Race15' = 'NLD'
    'Race16' = 'MZA'
    'Race17' = 'AZE'
    'Race18' = 'SGP'
    'Race19' = 'TEX'
    'Race20' = 'MEX'
    'Race21' = 'BRA'
    'Race22' = 'LAS'
    'Race23' = 'QAT'
    'Race24' = 'ABU'
}

#write-host $tracks.

#break

$data = @()

for($init=0;$init -lt (($raceInputArray.Name).Count); $init++){
    $data += @(
        [pscustomobject]@{Name=$raceInputArray[$init].Name;$tracks.Race1="";$tracks.Race2="";$tracks.Race3="";$tracks.Race4="";$tracks.Race5="";
                        $tracks.Race6="";$tracks.Race7="";$tracks.Race8="";$tracks.Race9="";$tracks.Race10="";$tracks.Race11="";
                        $tracks.Race12="";$tracks.Race13="";$tracks.Race14="";$tracks.Race15="";$tracks.Race16="";$tracks.Race17="";
                        $tracks.Race18="";$tracks.Race19="";$tracks.Race20="";$tracks.Race21="";$tracks.Race22="";$tracks.Race23="";
                        $tracks.Race24="";CDP="";Points="";Bets="";Total="";PSQP="";Final="";}
    )
}

for($r=1; $r -le $tracks.Count; $r++){
    $raceNo = "Race" + $r.ToString()
    $first = "-1"
    $second = "-2"
    $third = "-3"
    $dnfStr = "-DNF"
    $raceBonusQuestion1 = "-BQ1"
    $raceBonusQuestion2 = "-BQ2"
    $preQualySelection = "-PQ"

    $resultArray = @()
    $resultArray += $raceResultsRow.($raceNo + $first), $raceResultsRow.($raceNo + $second), $raceResultsRow.($raceNo + $third)

    if($resultArray -contains ""){
        $currentRaceNo = $r - 1
        $playerRaceSelection = @()
        for($p=0; $p -lt ($data.Name).Count; $p++){
            $playerRaceSelection += @(
                [pscustomobject]@{Name=$data[$p].Name;
                                    PreQualy=$raceInputArray[$p].($raceNo + $preQualySelection);
                                    First=$raceInputArray[$p].($raceNo + $first);
                                    Second=$raceInputArray[$p].($raceNo + $second);
                                    Third=$raceInputArray[$p].($raceNo + $third);
                                    DNF=$raceInputArray[$p].($raceNo + $dnfStr);
                                    Head2Head=$raceInputArray[$p].($raceNo + $raceBonusQuestion1)
                                    BonusQ=$raceInputArray[$p].($raceNo + $raceBonusQuestion2)}
                )
        }
        #$stewards = @()
        #$stewards = Get-Random -Count 2 $data.Name
            
        Write-Host "`nPlayer Selection for" $tracks.$raceNo
        $playerRaceSelection | Format-Table
        #Write-Host "The race stewards are" $stewards[0] "and" $stewards[1]
        break
    }

    for($p=0; $p -lt ($data.Name).Count; $p++){
        $playerArray = @()
        $playerArray += $raceInputArray[$p].($raceNo + $first), $raceInputArray[$p].($raceNo + $second), $raceInputArray[$p].($raceNo + $third)

        $playerRaceScore = 0
        $playerCorrectAnswer = 0
        for($q = 0;$q -le 2; $q++){
            if($resultArray[$q] -eq $playerArray[$q]){
                $playerCorrectAnswer += 1
                if(($raceInputArray[$p].($raceNo + $preQualySelection)) -match "Yes"){
                    $playerRaceScore += 15
                }
                else {
                    $playerRaceScore += 10
                }                
            }elseif ($playerArray -contains $resultArray[$q]) {
                if(($raceInputArray[$p].($raceNo + $preQualySelection)) -eq "Yes"){
                    $playerRaceScore += 7.5
                }
                else {
                    $playerRaceScore += 5
                } 
            }
        }
        if(($raceResultsRow.($raceNo + $dnfStr)) -match ($raceInputArray[$p].($raceNo + $dnfStr))){
            $playerRaceScore += 5
        }

        if(($raceResultsRow.($raceNo + $raceBonusQuestion1)) -ne "NA") {
            if(($raceResultsRow.($raceNo + $raceBonusQuestion1)) -match ($raceInputArray[$p].($raceNo + $raceBonusQuestion1))){
                            $playerRaceScore += 5
            
             }
        }

        if(($raceResultsRow.($raceNo + $raceBonusQuestion2)) -ne "NA") {
            if(($raceResultsRow.($raceNo + $raceBonusQuestion2)) -match ($raceInputArray[$p].($raceNo + $raceBonusQuestion2))){
                            $playerRaceScore += 20
            
             }
        }

        


        [double]$data[($p)].Points += $playerRaceScore
        [double]$data[($p)].Total += $playerRaceScore
        [int]$data[($p)].CDP += $playerCorrectAnswer

        $data[($p)].($tracks.$raceNo) = $playerRaceScore
    }
}

for($p=0; $p -lt (($data.Name).Count); $p++){
    $sideBetScore = 0
    #write-host $data[$p].Name
    for($b=0; $b -lt (($sideBets.Race).Count);$b++){
        if($sideBets[$b].Result -ne ""){
            if($data[$p].Name -eq $sideBets[$b].P1){
                if($sideBets[$b].P1Pick -match $sideBets[$b].Result){
                    $sideBetScore += 5
                } else {
                    $sideBetScore -= 5 
                }
            }
            if($data[$p].Name -eq $sideBets[$b].P2){
                if($sideBets[$b].P2Pick -match $sideBets[$b].Result){
                    $sideBetScore += 5
                } else {
                    $sideBetScore -= 5 
                }
            }
    }
    }
    [double]$data[($p)].Bets += $sideBetScore
    [double]$data[($p)].Total += $sideBetScore
}






$previousRace = "Race" + ($currentRaceNo - 1).ToString()
$currentRace = "Race" + $currentRaceNo.ToString()
if($currentRace -ne 24){
    $nextRace = "Race" + ($currentRaceNo + 1).ToString()
}

Write-Host "`nSidebets:"
$displayBets = @()
foreach($bet in $sideBets){
    if($bet.Race -Match ($tracks.$nextRace)){
        $displayBets += $bet
    }
}
$displayBets | Format-Table


Write-Host "`n`nBonus Question Answer(s):" $raceResultsRow.($currentRace + $raceBonusQuestion2)

Write-Host "`n`nLeaderboard:"
$data | Select-Object Name, ($tracks.$previousRace), ($tracks.$currentRace), ($tracks.$nextRace), CDP, Points, Bets, Total | Sort-Object -Property Total, CDP -Descending | Format-Table
$data | Sort-Object -Property Total, CDP -Descending | Export-Csv .\Leaderboard.csv -NoTypeInformation -Force 

Write-Host "`nSidebets Results:"
$displayBets = @()
foreach($bet in $sideBets){
    if($bet.Race -Match ($tracks.$currentRace)){
        $displayBets += $bet
    }
}
$displayBets | Format-Table






if(($checkBonus -contains "") -or ($raceResultsRow.'Race24-1' -eq "") ){
    $calcBonus = $false
} else {
    $calcBonus = $true
}

if($calcBonus){  
    for($b=0;$b -lt (($data.Name).Count);$b++){

        $playerBonus = 0.00
        for($q=0;$q -lt (($bonusInput.Question).Count);$q++){
            $pn = $data[$b].Name

            if($bonusInput[$q].$pn -eq $bonusAnswers[$q].Answer){
                $playerBonus += 0.05
            }
        }
        $data[$b].PSQP = $playerBonus
        $data[$b].Total = $data[$b].Points + ($data[$b].PSQP * $data[$b].Points)
    }

    Write-Host "`nLeaderboard with bonus points:"
    $data | Sort-Object -Property Total, CDP -Descending | Format-Table * 
    $data | Sort-Object -Property Total, CDP -Descending | Export-Csv .\LeaderboardWithBonus.csv -NoTypeInformation -Force
}