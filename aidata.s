        ; AI jumptable

aiJumpTblLo:    dc.b <AI_Idle
                dc.b <AI_TurnTo
                dc.b <AI_Follow
                dc.b <AI_Sniper
                dc.b <AI_Mover
                dc.b <AI_Guard

aiJumpTblHi:    dc.b >AI_Idle
                dc.b >AI_TurnTo
                dc.b >AI_Follow
                dc.b >AI_Sniper
                dc.b >AI_Mover
                dc.b >AI_Guard

        ; Spawn list entry selection tables

spawnListAndTbl:dc.b $00                        ;0: entry 0

spawnListAddTbl:dc.b $00                        ;0: entry 0

        ; Spawn list entries

spawnTypeTbl:   dc.b ACT_TESTENEMY              ;0

spawnPlotTbl:   dc.b NOPLOTBIT                  ;0

spawnWpnTbl:    dc.b ITEM_AUTORIFLE             ;0
