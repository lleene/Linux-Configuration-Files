// AUTHOR: LIEUWE B LEENE 2019
// USAGE: lef_edit *.lef  # THIS WILL OUTPUT MODIFIED .edit FILES
// LEF MODIFICATION SCRIPT TO ALLOW BLOCKING LAYERS TO BE TRANSLATED
// INTO GDS BY APPENDING OBS STRUCTURES WITH PHYSICAL DUMMY EXCLUDE LAYERS
// FOR EACH BLOCKING LAYER PLEASE INCLUDE THE FOLLOWING IN THE LEF DEF FILE
//
//LAYER ODBLK
//    TYPE ROUTING ;
//    DIRECTION VERTICAL ;
//END ODBLK
//
// FURTHER MORE THE BLOCKING LAYER MUST BE OF DRAWING TYPE IN THE LAYERMAP
// THIS IS ONLY USED FOR LEF-> GDS CONVERSION
//
// ODBLK drawing 150 20
//
// IMPORTANT: PLEASE CONFIRM THAT ALL CELLS CONTAIN EXACLTY 1 OBS STRUCTURE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef int bool;
enum { false, true };

typedef struct {
    float minx; // SMALLEST X CORD
    float maxx; // LARGEST X CORD
    float miny; // SMALLEST Y CORD
    float maxy; // LARGEST Y CORD
    bool set;
} BoundingBox_t;

typedef struct {
    long int  macro_start;
    long int  macro_end;
    long int has_obstruct;
    bool is_coreclass;
    bool is_padclass;
    bool is_blockclass;
    BoundingBox_t macro_bBox;
} MacroObject_t;

// FROM LEF/DEF 5.7 Language Reference
// RECT x1 y1 x2 y2
// Assume ordered pairs for now
BoundingBox_t bBox_enclose(BoundingBox_t bBox_new, BoundingBox_t bBox_enclosure){
  if(bBox_enclosure.set == true){
    if(bBox_enclosure.minx > bBox_new.minx) bBox_enclosure.minx = bBox_new.minx;
    if(bBox_enclosure.maxx < bBox_new.maxx) bBox_enclosure.maxx = bBox_new.maxx;
    if(bBox_enclosure.miny > bBox_new.miny) bBox_enclosure.miny = bBox_new.miny;
    if(bBox_enclosure.maxy < bBox_new.maxy) bBox_enclosure.maxy = bBox_new.maxy;
  }
  else {
    bBox_enclosure = bBox_new;
    bBox_enclosure.set = true;
  }
  return bBox_enclosure;
}

void bBox_print(BoundingBox_t bBox){
  fprintf(stdout, "Enclosure: %f %f %f %f ;\n", bBox.minx, bBox.miny, bBox.maxx, bBox.maxy);
  return;
}

// awk '/OBS/{print "PIN";}/END/{print "PAD" }1' tpb018v_5lm.lef
// fsetpos(fr, &pos);
// fgetpos(fr, &pos);

char* GetMacroProperties(char* index, FILE* leffile, long int*  macro_end, long int* has_obstruct, BoundingBox_t* macro_bBox){
  char buffer[0xFF];
  char macro_name[0xFF];
  macro_bBox->set = false;
  BoundingBox_t rect_bBox;
  // Set Macro Name & Start
  strcpy( macro_name, "END ");
  strcpy( macro_name+4, index+6);
  //fprintf(stdout, "Found:%s", macro_name+4);
  index = 0; // Clear index for now
  while(fgets(buffer, 0xFF, leffile) && !index){
      // ADD MORE OBJECTS HERE THAT INDICATE SCROLLING PAST MACRO
      if(strstr(buffer,"MACRO ")){
        fprintf(stdout, "LEF ERROR: Trailing Macro at %d: %s", (int)ftell(leffile), macro_name+4);
        break;
      }
      index = strstr(buffer,macro_name); // Catch Macro End
      if(index){
        *macro_end = ftell(leffile);
      }
      index = strstr(buffer,macro_name); // Catch OBS Layers
      if(strstr(buffer,"OBS\n") || strstr(buffer,"OBS ")){
        *has_obstruct = ftell(leffile);
      }

      // WHAT ABOUT SIZE AND ORIGIN?
      char *rect_index;
      if((rect_index = strstr(buffer,"RECT "))){
        sscanf(rect_index + 5, " %f %f %f %f ;", &rect_bBox.minx, &rect_bBox.miny, &rect_bBox.maxx, &rect_bBox.maxy);
        *macro_bBox = bBox_enclose(rect_bBox,*macro_bBox);
      }
  }
  return index;
}

void GetLEFMacros(FILE* leffile,FILE* modfile){
  int i=0;
  char buffer[0xFF]; // Max Buffer - String Size
  long int has_obstruct;
  has_obstruct = ftell(leffile); // Check if inside macro bound
  char *index;
  // Scan file for MACROS with Bounding Check
  while(fgets(buffer, 0xFF, leffile)){
    i++;
    fprintf(modfile, buffer);
    index = strstr(buffer,"MACRO ");
    if(index){
      long int  macro_end;
      BoundingBox_t macro_bBox;
      long int  macro_start = ftell(leffile);

      // Find END of MACRO and Populate Properties
      // This will Advance file pointer to next MACRO
      index = GetMacroProperties(index, leffile, &macro_end, &has_obstruct, &macro_bBox);

      // If Valid MACRO Index will be Set
      if( index ){
        fseek(leffile,macro_start,SEEK_SET);
        bool inside_obstruct = false;
         // FINAL PROGRESSION THROUGH MACRO
        fgets(buffer, 0xFF, leffile);
        bool is_coreclass = false;
        if(strstr(buffer,"CLASS CORE")) is_coreclass = true;
        while( (macro_start = ftell(leffile)) <= macro_end){
          if( macro_start == has_obstruct) {
            fprintf(modfile, buffer);
            //fprintf(stdout, "Placing OBS edit\n");
            //fprintf(modfile, "    PIN LEFGEN\n");
            //fprintf(modfile, "        PORT\n");
             inside_obstruct = true;
          }
          else if (inside_obstruct == true && strstr(buffer,"END")){
            fprintf(modfile, buffer);
            //fprintf(stdout, "Placing END edit\n");
            //fprintf(modfile, "        END\n");
            //fprintf(modfile, "    END LEFGEN\n");
            fprintf(modfile, "    PIN LEFBLK\n");
            fprintf(modfile, "        PORT\n");
            fprintf(modfile, "        LAYER ODBLK ;\n");
            fprintf(modfile, "        RECT %f %f %f %f ;\n", macro_bBox.minx,macro_bBox.miny,macro_bBox.maxx,macro_bBox.maxy);
            fprintf(modfile, "        LAYER POBLK ;\n");
            fprintf(modfile, "        RECT %f %f %f %f ;\n", macro_bBox.minx,macro_bBox.miny,macro_bBox.maxx,macro_bBox.maxy);
            fprintf(modfile, "        LAYER DMEXCL1 ;\n");
            fprintf(modfile, "        RECT %f %f %f %f ;\n", macro_bBox.minx,macro_bBox.miny,macro_bBox.maxx,macro_bBox.maxy);
            if(is_coreclass == false){
              fprintf(modfile, "        LAYER DMEXCL2 ;\n");
              fprintf(modfile, "        RECT %f %f %f %f ;\n", macro_bBox.minx,macro_bBox.miny,macro_bBox.maxx,macro_bBox.maxy);
              fprintf(modfile, "        LAYER DMEXCL3 ;\n");
              fprintf(modfile, "        RECT %f %f %f %f ;\n", macro_bBox.minx,macro_bBox.miny,macro_bBox.maxx,macro_bBox.maxy);
              fprintf(modfile, "        LAYER DMEXCL4 ;\n");
              fprintf(modfile, "        RECT %f %f %f %f ;\n", macro_bBox.minx,macro_bBox.miny,macro_bBox.maxx,macro_bBox.maxy);
              fprintf(modfile, "        LAYER DMEXCL5 ;\n");
              fprintf(modfile, "        RECT %f %f %f %f ;\n", macro_bBox.minx,macro_bBox.miny,macro_bBox.maxx,macro_bBox.maxy);
            }
            fprintf(modfile, "        END\n");
            fprintf(modfile, "    END LEFBLK\n");
            inside_obstruct = false;
          }
          else {
            fprintf(modfile, buffer);
            i++;
          }
          fgets(buffer, 0xFF, leffile);
        }
        fprintf(modfile, buffer); // Dont Forget the Trailing Line
        i++;
      }
      else{ // Backtrack one line to parse next macro / OBJECT
        fseek(leffile,-0xF,SEEK_CUR);
      }
    }
  }
}

int main(int argc, char *argv[]) {
  fprintf(stdout, "Adding BLK structure to lef files:\n" );
  int i=0;
  char buffer[0xFF];
  char* file_name = &buffer[0];
  for (i = 1; i<argc; i++){ // For each file from STD ARG IN
    fprintf(stdout, "%s\n",argv[i]);
    FILE* leffile = 0;
    FILE* modfile = 0;

    // Try to Open LEF file
    leffile = fopen(argv[i],"r");
    if(!leffile){
      fprintf(stdout, "Could not open: %s\n",argv[i]);
      exit(0);
    }

    strcpy(file_name,argv[i]);
    strcat(file_name,".edit");
    // Try to Open MOD file
    modfile = fopen(file_name,"w+");
    if(!modfile){
      fprintf(stdout, "Could not open: %s\n",file_name);
      exit(0);
    }
    GetLEFMacros(leffile,modfile);
    fclose(leffile);
    fclose(modfile);
  }
}
