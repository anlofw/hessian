                processor 6502

                include memory.s

                org lvlCodeStart

UpdateLevel:    rts

                org charInfo
                incbin bg/level01.chi
                incbin bg/level01.chc

                org chars
                incbin bg/level01.chr

                org lvlDataActX
                incbin bg/level01.lva

                org lvlLoadName
                dc.b "INSIDE SHIP",0

                org lvlLoadWaterDamage
                dc.b 0                          ;Water damage

                org blockInfo
                incbin bg/level01.bli
