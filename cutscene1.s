                include memory.s
                include macros.s
                include mainsym.s

                org lvlCodeStart

                incbin cutscene1scr.dat

                org chars

                incbin cutscene1.chr

                org screen2

                dc.b MUSIC_MYSTERY              ;Song to play
                dc.b 11                         ;Multicolors
                dc.b 12
                dc.w page1                      ;Pages to display (0 = end)
                dc.w page2
                dc.w 0

page1:               ;0123456789012345678901234567890123456789
                dc.b 0
                dc.b "KIM, A SECURITY GUARD WORKING THE NIGHT",0
                dc.b "SHIFT AT THRONE GROUP SCIENCE COMPLEX",0
                dc.b "WAKES UP INSIDE A CARGO CONTAINER WHICH",0
                dc.b "HAS BEEN CONVERTED INTO AN IMPROVISED",0
                dc.b "EMERGENCY OPERATING ROOM.",0
                dc.b 0

page2:          dc.b 0
                dc.b "WHAT SHE REMEMBERS: COMBAT ROBOT PROTO-",0
                dc.b "TYPES OPENING FIRE ON STAFF, EVERYTHING",0
                dc.b "TURNING BLACK AS ROUNDS HAMMER INTO HER",0
                dc.b "CHEST, THEN THE WORDS: ",34,"NEED ARTIFICIAL",0
                dc.b "CIRCULATION .. NANOBOT INFUSION NOW!",34,0
                dc.b 0

                checkcutsceneend