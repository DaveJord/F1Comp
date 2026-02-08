        if (($raceResultsRow.($raceNo + $bonusQ)) -ne "NA") {
            
            $bonusAns = $raceResultsRow.($raceNo + $bonusQ)
            
            $playerAns = ($raceInputArray[$p].($raceNo + $bonusQ))

            if (($tracks.($raceNo)) -match "SAU") {
                $gap = ([math]::Abs([int]$bonusAns - [int]$playerAns))
               
                if (($gap * 2) -ge 20) {
                    $bonusPoints = 0
                    $playerRaceScore += $bonusPoints
                }
                else {
                    $bonusPoints = (20 - ($gap * 2))
                    $playerRaceScore += $bonusPoints
                }

                $bonusPointsWinners += @([pscustomobject]@{Player = "$($data[$p].Name)"; Info = "Off by: $gap seconds`t"; Points = "$bonusPoints"; })     
            
            }
            elseif (($tracks.($raceNo)) -match "MON") {
                if ($bonusAns -match "NoSelection") {
                    $bonusPoints = 0
                    $playerRaceScore += $bonusPoints 
                }
                else {
                    $gap = ([math]::Abs([int]$bonusAns - [int]$playerAns))
               
                    if ($gap -le 1) {
                        $bonusPoints = 20
                        $playerRaceScore += $bonusPoints
                    }
                    else {
                        $bonusPoints = 0
                        $playerRaceScore += $bonusPoints
                    }
                }

            }

            elseif (($tracks.($raceNo)) -match "GBR") {
                if ($bonusAns -match "NoSelection") {
                    $bonusPoints = 0
                    $playerRaceScore += $bonusPoints 
                }
                else {
                    $gap = ([math]::Abs([int]$bonusAns - [int]$playerAns))
               
                    if ($gap -le 1) {
                        $bonusPoints = 20
                        $playerRaceScore += $bonusPoints
                    }
                    else {
                        $bonusPoints = 0
                        $playerRaceScore += $bonusPoints
                    }
                }
            }

            elseif ($bonusAns -match $playerAns) {
                if ($playerAns -ne "") 
                {$playerRaceScore += 20 }
        }