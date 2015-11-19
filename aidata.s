        ; AI jumptable

aiJumpTblLo:    dc.b <AI_DoNothing
                dc.b <AI_TurnTo
                dc.b <AI_Follow
                dc.b <AI_Sniper
                dc.b <AI_Mover
                dc.b <AI_Guard
                dc.b <AI_Berzerk
                dc.b <AI_Flyer
                dc.b <AI_Animal
                dc.b <AI_FreeMoveWithTurn

aiJumpTblHi:    dc.b >AI_DoNothing
                dc.b >AI_TurnTo
                dc.b >AI_Follow
                dc.b >AI_Sniper
                dc.b >AI_Mover
                dc.b >AI_Guard
                dc.b >AI_Berzerk
                dc.b >AI_Flyer
                dc.b >AI_Animal
                dc.b >AI_FreeMoveWithTurn

flyerDirTbl:    dc.b JOY_LEFT|JOY_UP
                dc.b JOY_LEFT|JOY_DOWN
                dc.b JOY_RIGHT|JOY_UP
                dc.b JOY_RIGHT|JOY_DOWN

        ; Spawn list entry selection tables

spawnListAndTbl:dc.b $00                        ;0: entry 0

spawnListAddTbl:dc.b $00                        ;0: entry 0

        ; Spawn list entries

spawnTypeTbl:   dc.b ACT_FLYER                  ;0

spawnPlotTbl:   dc.b NOPLOTBIT                  ;0

spawnWpnTbl:    dc.b ITEM_MINIGUN|SPAWN_AIR        ;0
