#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "fileio.h"

#define MAX_LEVELS 64
#define MAX_LVLACT 128
#define MAX_LVLOBJ 128

int numlvlact[MAX_LEVELS];
int numbytes[MAX_LEVELS];
int numlvlobj[MAX_LEVELS];
int numlvlobjbytes[MAX_LEVELS];
unsigned char lvlactx[MAX_LVLACT];
unsigned char lvlacty[MAX_LVLACT];
unsigned char lvlactf[MAX_LVLACT];
unsigned char lvlactt[MAX_LVLACT];
unsigned char lvlactw[MAX_LVLACT];
unsigned char lvlobjx[MAX_LVLOBJ];
unsigned char lvlobjy[MAX_LVLOBJ];
unsigned char lvlobjb[MAX_LVLOBJ];
unsigned char lvlobjd1[MAX_LVLOBJ];
unsigned char lvlobjd2[MAX_LVLOBJ];
int bitareasize = 0;
int lvlobjbitareasize = 0;

int main(int argc, char** argv)
{
    int c,d;
    int actuallevels = 0;
    int offset = 0;
    for (c = 0; c < MAX_LEVELS; c++)
    {
        int length;
        int numact;
        int numobj;
        int actualnumobj;
        int numpersistentobj;
        char namebuf[256];

        sprintf(namebuf, "bg/level%02d.lva", c);
        FILE* in = fopen(namebuf, "rb");
        if (!in)
            break;
        fseek(in, 0, SEEK_END);
        length = ftell(in);
        fseek(in, 0, SEEK_SET);
        numact = length / 5;
        memset(lvlactt, 0, sizeof lvlactt);
        fread(&lvlactx[0], numact, 1, in);
        fread(&lvlacty[0], numact, 1, in);
        fread(&lvlactf[0], numact, 1, in);
        fread(&lvlactt[0], numact, 1, in);
        fread(&lvlactw[0], numact, 1, in);
        fclose(in);
        for (d = MAX_LVLACT-1; d >= 0; d--)
        {
            if (lvlactt[d])
                break;
        }
        printf("Level %d has %d actors\n", c, d+1);
        if (d < 0) d = 0; // Always have some data per level
        numlvlact[c] = d+1;
        numbytes[c] = (numlvlact[c] + 7) / 8;
        bitareasize += numbytes[c];

        sprintf(namebuf, "bg/level%02d.lvo", c);
        in = fopen(namebuf, "rb");
        if (!in)
            break;
        fseek(in, 0, SEEK_END);
        length = ftell(in);
        fseek(in, 0, SEEK_SET);
        numobj = length / 5;
        memset(lvlobjx, 0, sizeof lvlobjx);
        memset(lvlobjy, 0, sizeof lvlobjy);
        fread(&lvlobjx[0], numobj, 1, in);
        fread(&lvlobjy[0], numobj, 1, in);
        fread(&lvlobjb[0], numobj, 1, in);
        fread(&lvlobjd1[0], numobj, 1, in);
        fread(&lvlobjd2[0], numobj, 1, in);
        fclose(in);
        numpersistentobj = 0;
        actualnumobj = 0;
        for (d = 0; d < MAX_LVLOBJ; d++)
        {
            if (lvlobjx[d] || lvlobjy[d])
            {
                actualnumobj++;
                // If object is not a sidedoor or spawner, and it does NOT have auto-deactivation,
                // it needs to be persisted. Note: game must obey exact same criteria
                // for decoding the object indices
                if ((lvlobjb[d] & 0x18) < 0x18 && (lvlobjb[d] & 0x20) == 0x00)
                    numpersistentobj++;
            }
        }
        printf("Level %d has %d objects, %d persistent\n", c, actualnumobj, numpersistentobj);
        // Always have some data per level
        if (!numpersistentobj) numpersistentobj++;
        numlvlobj[c] = numpersistentobj;
        numlvlobjbytes[c] = (numlvlobj[c] + 7) / 8;
        lvlobjbitareasize += numbytes[c];
        actuallevels++;
    }
    printf("Total actor bitarea size is %d\n", bitareasize);
    printf("Total levelobject bitarea size is %d\n", lvlobjbitareasize);
    FILE* out = fopen("levelactors.s", "wt");
    fprintf(out, "LVLDATAACTTOTALSIZE = %d\n\n", bitareasize);
    fprintf(out, "LVLOBJTOTALSIZE = %d\n\n", lvlobjbitareasize);
    fprintf(out, "lvlDataActBitsStart:\n");
    for (c = 0; c < actuallevels; c++)
    {
        fprintf(out, "                dc.b %d\n", offset);
        offset += numbytes[c];
    }
    fprintf(out, "lvlDataActBitsLen:\n");
    for  (c = 0; c < actuallevels; c++)
    {
        fprintf(out, "                dc.b %d\n", numbytes[c]);
    }
    offset = 0;
    fprintf(out, "lvlObjBitsStart:\n");
    for (c = 0; c < actuallevels; c++)
    {
        fprintf(out, "                dc.b %d\n", offset);
        offset += numlvlobjbytes[c];
    }
    fprintf(out, "lvlObjBitsLen:\n");
    for  (c = 0; c < actuallevels; c++)
    {
        fprintf(out, "                dc.b %d\n", numlvlobjbytes[c]);
    }
    fclose(out);
}