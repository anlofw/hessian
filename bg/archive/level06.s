                processor 6502

                include memory.s
                include mainsym.s

                org lvlCodeStart

UpdateLevel:    ldy chars+139*8+15
                ldx #$0e
UL_Waterfall:   lda chars+139*8,x
                sta chars+139*8+1,x
                dex
                bpl UL_Waterfall
                sty chars+139*8
                and #%01010101
                sta chars+164*8+6
                tya
                ora #%01010101
                sta chars+164*8+7
                inc UL_Delay+1
UL_Delay:       lda #$00
                tay
                and #$07
                bne UL_NoWaterAnim
                ldx #$07
UL_WaterLoop:   lda chars+28*8,x
                asl
                adc #$00
                asl
                adc #$00
                sta chars+28*8,x
                dex
                bne UL_WaterLoop
UL_NoWaterAnim: rts

                org charInfo
                incbin bg/level06.chi
                incbin bg/level06.chc

                org chars
                incbin bg/level06.chr

                org lvlDataActX
                incbin bg/level06.lva

                org lvlLoadName
                dc.b "SEWERS",0

                org lvlLoadWaterSplashColor
                dc.b $05                        ;Water splash color override
                dc.b $10                        ;Water damage