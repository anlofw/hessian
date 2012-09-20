ITEM_NONE       = 0
ITEM_KNIFE      = 1
ITEM_PISTOL     = 2
ITEM_GRENADE    = 3

ITEM_FIRST_CONSUMABLE = ITEM_GRENADE
ITEM_FIRST_NONWEAPON = 4


        ; Item data
        
itemNameLo:     dc.b <txtKnife
                dc.b <txtPistol
                dc.b <txtGrenade
                
itemNameHi:     dc.b >txtKnife
                dc.b >txtPistol
                dc.b >txtGrenade
                
itemMaxCount:   dc.b 1
                dc.b 100
                dc.b 10
                
itemDefaultPickup:
                dc.b 1
                dc.b 12
                dc.b 2
                
itemMagazineSize:
                dc.b $ff
                dc.b 12
                dc.b 0
                

                
