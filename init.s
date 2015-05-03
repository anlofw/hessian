scriptCodeStart:
scriptCodeEnd   = scriptCodeStart+SCRIPTAREASIZE

        ; Initialize registers/variables at startup. This code is called only once and can be
        ; disposed after that.
        ;
        ; Parameters: -
        ; Returns: -
        ; Modifies: A,X,Y,temp vars

InitAll:

        ; Initialize zeropage variables

                ldx #$90-joystick-1
                lda #$00
InitZP:         sta joystick,x
                dex
                bpl InitZP

        ; Initialize playroutine / raster IRQ variables

                sta ntFiltPos
                sta ntFiltTime
                lda #$7f
                sta ntInitSong

                lda #<fileAreaStart
                sta freeMemLo
                lda #>fileAreaStart
                sta freeMemHi

        ; Load options file
        
                lda #F_OPTIONS
                jsr MakeFileName_Direct
                jsr OpenFile
                ldx #$00
LoadOptions:    jsr GetByte
                bcs LoadOptionsDone
                sta difficulty,x
                inx
                bcc LoadOptions
LoadOptionsDone:

        ; Initialize scrolling

                jsr InitScroll

        ; Initialize panel text printing

                lda #9
                sta textLeftMargin
                lda #31
                sta textRightMargin
                lda #REDRAW_ITEM+REDRAW_AMMO+REDRAW_SCORE
                sta panelUpdateFlags

        ;Initialize the sprite multiplexing system

InitSprites:    lda #$00
                sta newFrame
                sta firstSortSpr
                lda #$ff
                sta sprFileNum
                ldx #MAX_SPR
                lda #$01
                sta temp1
ISpr_Loop:      txa
                sta sprOrder,x
                lda #$ff
                sta sprY,x
                cpx #MAX_SPR
                beq ISpr_OrValueOk
                lda temp1
                sta sprOrTbl,x
                sta sprOrTbl+MAX_SPR,x
                eor #$ff
                sta sprAndTbl,x
                sta sprAndTbl+MAX_SPR,x
                asl temp1
                bne ISpr_OrValueOk
                lda #$01
                sta temp1
ISpr_OrValueOk: dex
                bpl ISpr_Loop
                ldx #MAX_CACHESPRITES-1
ISpr_ClearCacheInUse:
                lda #$00
                sta cacheSprAge,x
                lda #$ff
                sta cacheSprFile,x
                dex
                bpl ISpr_ClearCacheInUse

        ; Load resident sprites

                ldy #C_COMMON
                jsr LoadSpriteFile
                ldy #C_ITEM
                jsr LoadSpriteFile
                ldy #C_WEAPON
                jsr LoadSpriteFile

        ; Fade out loading music now

                lda fastLoadMode
                beq InitVideo
FadeMusicLoop:  ldy #$08
FadeMusicDelay: jsr WaitBottom
                dey
                bne FadeMusicDelay
                lda musicData+$8c
                beq InitVideo
                dec musicData+$8c
                bpl FadeMusicLoop

        ; Initialize video registers and screen memory

InitVideo:      jsr WaitBottom
                lda #$00                        ;Blank screen
                sta $d011
                sta $d01b                       ;Sprites on top of BG
                sta $d01d                       ;Sprite X-expand off
                sta $d017                       ;Sprite Y-expand off
                sta screen
                lda #$ff                        ;Set all sprites multicolor
                sta $d01c
                sta $d001
                sta $d003
                sta $d005
                sta $d007
                sta $d009
                sta $d00b
                sta $d00d
                sta $d00f
                sta $d015                       ;All sprites on and to the bottom
                jsr WaitBottom                  ;(some C64's need to "warm up" sprites
                ldx #$00                        ;to avoid one frame flash when they're
                stx $d015                       ;actually used for the first time)
                stx $d026                       ;Set sprite multicolors
                lda #$0a
                sta $d025
IVid_CopyTextChars:
                lda textCharsCopy,x
                sta textChars+$100,x
                lda textCharsCopy+$100,x
                sta textChars+$200,x
                lda textCharsCopy+$200,x
                sta textChars+$300,x
                inx
                bne IVid_CopyTextChars
                ldx #7
                lda #EMPTYSPRITEFRAME
IVid_SetEmptySpriteFrame:
                sta panelScreen+1016,x
                dex
                bpl IVid_SetEmptySpriteFrame
                ldx #39
IVid_InitScorePanel:
                lda #$20
                sta panelScreen+22*40,x
                lda scorePanel,x
                sta panelScreen+23*40,x
                lda scorePanelColors,x
                sta colors+23*40,x
                lda scorePanel+40,x
                sta panelScreen+24*40,x
                lda scorePanelColors+40,x
                sta colors+24*40,x
                dex
                bpl IVid_InitScorePanel

                lda #HP_PLAYER                  ;Init health & fists item immediately
                sta actHp+ACTI_PLAYER           ;even before starting the game so that
                lda #MAX_BATTERY
                sta battery+1
                lda #ITEM_FISTS                 ;the panel looks nice
                sta invType

        ; Initialize raster IRQs
        ; Relies on loader init to have already disabled the timer interrupt

InitRaster:     sei
                ldx #$ff
                txs
                lda #$35
                sta irqSave01
                sta $01
                lda #<Irq1                      ;Set initial IRQ vector
                sta $fffe
                lda #>Irq1
                sta $ffff
                lda #$00                        ;IRQs disabled until the screen is ready to be drawn
                sta $d01a
                lda #IRQ1_LINE                  ;Line where next IRQ happens
                sta $d012
                lda fastLoadMode                ;If not using serial fastloading, disable MinSprY/MaxSprY writing
                bmi IR_UseFastLoad
                lda #$2c
                sta Irq1_StoreMinSprY
                sta Irq1_StoreMaxSprY
IR_UseFastLoad: lda #$01                        ;Init NTSC delay counter value to non-zero so that PAL machines
                sta ntscDelay                   ;will never delay
                lda ntscFlag
                bne IR_IsNtsc
                lda #$ff                        ;On PAL the colorshift check can be made more forgiving
                sta UF_ColorShiftLateCheck+1
IR_IsNtsc:      cli

        ; Initializations are complete. Start the main program

                lda #<EP_TITLE                  ;Load and execute the title screen
                ldx #>EP_TITLE
                ldy #$00
                jmp ExecScriptParam

        ; Scorepanel chars (overwritten)

textCharsCopy:  incbin bg/scorescr.chr

        ; Scorepanel screen/color data (overwritten)

scorePanel:     dc.b 35,"       ",35,"                      ",35,"       ",35
                dc.b 36
                ds.b 7,40
                dc.b 41,40,104,61,61,61,61,61,61,61
                ds.b 4,40
                dc.b 105,61,61,61,61,61,61,61,40,41
                ds.b 7,40
                dc.b 59

scorePanelColors:
                dc.b 11
                ds.b 7,1
                dc.b 11
                ds.b 22,1
                dc.b 11
                ds.b 7,1
                dc.b 11
                ds.b 10,11
                dc.b 1
                ds.b 7,9
                ds.b 4,11
                dc.b 1
                ds.b 7,9
                ds.b 10,11

                org scriptCodeEnd