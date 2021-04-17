#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

#define REFNAME "bmp_converter_reference.txt"
#define DEFAULT_ENTRY "#This is the default entry:\n#Syntax: \n\t#\";\" B G R V\n\t#\";\"to start new entry\n\t#three values Blue Green Red for the lookup color and then the 4th Value which will be the result for the previously described case\n\t#Example: \"; 255 0 255 2\" -> the output file will contain a '2' for a magenta pixel\n\t#The first value of the lookup table is the default value and will be placed in the file in case of mismatching color\n"

#define OUTPUT_START  "int map[][] = {\n"
#define OUTPUT_SEPS    ","
#define OUTPUT_SEPG    "},\n"
#define OUTPUT_SEPB    "\t{"
#define OUTPUT_END    "};"


FILE *img_p, *out_p, *ref_p;
int main(int argc, char *argv[]) {

  if(argc<3) {fprintf(stderr, "call with %s <filename_image> <filename_output> instead\n", argv[0]);return 1;}

  img_p=fopen(argv[1],"rb");
  if(img_p==NULL) {
    fprintf(stderr, "Could not open %s\n", argv[1]);
    return 1;
  }
  out_p=fopen(argv[2],"w+");
  if(out_p==NULL) {
    fprintf(stderr, "Could not open %s\n", argv[2]);
    return 1;
  }
  ref_p=fopen(REFNAME,"a+");
  if(ref_p==NULL) {
    fprintf(stderr, "Could not open %s\n", REFNAME);
    return 1;
  }
  fseek(ref_p, 0, SEEK_END);
  int ref_size = ftell(ref_p);
  fseek(ref_p, 0, SEEK_SET);
  if(ref_size==0) {
    fprintf(stderr, "File %s is empty. Writing default entry\n", REFNAME);
    fprintf(ref_p, DEFAULT_ENTRY);
    return 1;
  }

  int refNum=0;
  for(int i=0; i<ref_size; i++) {
    char c=0;
    fscanf(ref_p,"%c",&c);
    if(c=='#') while(c!='\n')fscanf(ref_p, "%c", &c);
    if(c==';') refNum++;
  }

  if(refNum==0) {
    fprintf(stderr, "Could not locate references in %s\n", REFNAME);
    return 1;
  }
  fseek(ref_p, 0, SEEK_SET);
  int64_t refTable[refNum][4];
  for(int64_t i=0; i<refNum; i++) {
    char c;
    while(c!=';') {
      fscanf(ref_p, "%c", &c);
      if(c=='#') while(c!='\n')fscanf(ref_p, "%c", &c);
      if(ftell(ref_p)==ref_size) {
        fprintf(stderr, "Something went wrong when creating reference table\n");
        return 1;
      }
    }
    c=0;
    fscanf(ref_p,"%ld %ld %ld %ld", &refTable[i][0], &refTable[i][1], &refTable[i][2], &refTable[i][3]);
  }

  fprintf(stderr, "Lookup table:\n");
  for(int64_t i=0; i<refNum; i++) {
    fprintf(stderr, "\t%ld %ld %ld %ld\n", refTable[i][0], refTable[i][1], refTable[i][2], refTable[i][3]);
  }

  char signature[3];
  fread(signature, 2, sizeof(char), img_p);
  signature[2]=0;
  if(strcmp(signature,"BM")!=0) {
    fprintf(stderr, "The file is either not a bmp or corrupted: signature 0x%x%x (%s)\n",signature[0],signature[1], signature);
    return 1;
  }

  uint32_t img_pixelOffset, img_width, img_height, img_paddingsize;
  uint16_t img_bitsPerPixel;
  //search offset
  fseek(img_p, 0x0A, SEEK_SET);
  fread(&img_pixelOffset, 1, 4, img_p);
  //search width
  fseek(img_p, 0x12, SEEK_SET);
  fread(&img_width, 1, 4, img_p);
  //search height
  fread(&img_height, 1, 4, img_p);
  //search bitsPerPixel
  fseek(img_p, 0x1C, SEEK_SET);
  fread(&img_bitsPerPixel, 1, 2, img_p);

  if(img_bitsPerPixel!=24) {
    fprintf(stderr, "Program cannot work with %d bits per pixel. Please change image to 24 bits per pixel\n", img_bitsPerPixel);
    return 1;
  }

  img_paddingsize=img_width*img_bitsPerPixel/8;
  while(img_paddingsize%4) img_paddingsize++;
  img_paddingsize-=img_width*img_bitsPerPixel/8;

  fprintf(stderr, "Reading %s:\n\tpixelOffset:0x%x\n\tsizeWidth: 0x%x ~ pixel:%d\n\tsizeHeight: 0x%x ~ pixel:%d\n\tBits per Pixel:%d\n\tPadding size: %d byte\n",argv[1], img_pixelOffset, img_width, img_width, img_height, img_height, img_bitsPerPixel, img_paddingsize);

  int64_t img_raw[img_height][img_width][img_bitsPerPixel/8];

  fseek(img_p, img_pixelOffset, SEEK_SET);
  for(int64_t i=img_height-1; i>=0; i--) {
    for(uint32_t j=0; j<img_width; j++) {
      for(uint8_t k=0; k<img_bitsPerPixel/8; k++) {
        img_raw[i][j][k]=0;
        fread(&img_raw[i][j][k], 1, 1, img_p);
      }
    }
    fseek(img_p, img_paddingsize, SEEK_CUR);
  }

  fprintf(stderr, "IMG read raw:\n");
  for(int64_t i=0; i<img_height; i++) {
    for(uint32_t j=0; j<img_width; j++) {
      for(uint16_t k=0; k<img_bitsPerPixel/8; k++)
        fprintf(stderr, "0x%02lx ", img_raw[i][j][k]);
      fprintf(stderr, "| ");
    }
    fprintf(stderr, "\n" );
  }

  fprintf(out_p, OUTPUT_START);
  int found=0;
  for(int i=0; i<img_height; i++) {
    fprintf(out_p, OUTPUT_SEPB);
    for(int j=0; j<img_width; j++) {
      for(int k=0; k<refNum; k++) {
        if((uint64_t)img_raw[i][j][0]==(uint64_t)refTable[k][0]&&(uint64_t)img_raw[i][j][1]==(uint64_t)refTable[k][1]&&(uint64_t)img_raw[i][j][2]==(uint64_t)refTable[k][2]) {
          found=1;
          fprintf(out_p, "%ld", refTable[k][3]);
          fprintf(stderr, "Mapping: at(%d %d)[%ld %ld %ld for k=%d] - %ld\n", j, i, refTable[k][0], refTable[k][1], refTable[k][2], k, refTable[0][3]);
          break;
        }
      }
      if(found==0) {fprintf(out_p, "%ld", refTable[0][3]); fprintf(stderr, "Mapping: at(%d %d)[%ld %ld %ld for k=%d] - %ld\n", j, i, refTable[0][0], refTable[0][1], refTable[0][2], 0, refTable[0][3]);}
      found=0;
      fprintf(out_p, OUTPUT_SEPS);
    }
    fprintf(out_p, OUTPUT_SEPG);

  }
  fprintf(out_p, OUTPUT_END);


  fclose(img_p);
  fclose(out_p);
  fclose(ref_p);
}
