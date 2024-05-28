
#include <stdlib.h>
#include <string.h>

#include <stdlib.h>
#include <string.h>

#include <stdio.h>

// include NESLIB header
#include "neslib.h"

// include CC65 NES Header (PPU)
#include <nes.h>

// link the pattern table into CHR ROM
//#link "chr_generic.s"

// BCD arithmetic support
#include "bcd.h"
//#link "bcd.c"
  
// VRAM update buffer
#include "vrambuf.h"
//#link "vrambuf.c"

//Variables
//Vaguely useful to have
char i;
char j;
int t = 0;
//int hold;
//int pos;
int enemies;
//[floor 1-5][doors 0-1x4][num enemies 1-5]
//ie 311101

char testSeed[2];


void randSeed(char seed[]){
  seed[0]=rand8()%3+1;
  seed[1]=rand8()%2;
}

//Global use
char map[30][32]; //[string index/y][character number/x]

//Metasprite Constants
#define TILE 0xc4
#define ATTR 0

#define pf1 0xc4 //player front 1
#define pf2 0xc8 //player front 2
#define ps1 0xcc //player side 1
#define ps2 0xd0 //player side 2
#define pb1 0xd4 //player back 1
#define pb2 0xd8 //player back 2

/*{pal:"nes",layout:"nes"}*/
const char PALETTE[32] = { 
  0x0B,			// screen color

  0x0D,0x03,0x0A,0x00,	// background palette 0
  0x0D,0x03,0x0A,0x00,	// background palette 1
  0x0D,0x03,0x0A,0x00,	// background palette 2
  0x0D,0x03,0x0A,0x00,   // background palette 3

  0x30,0x17,0x37,0x00,	// sprite palette 0
  0x20,0x26,0x16,0x00,	// sprite palette 1
  0x0D,0x2D,0x3A,0x00,	// sprite palette 2
  0x0D,0x27,0x2A	// sprite palette 3
};


// setup PPU and tables
void setup_graphics() {
  // clear sprites
  oam_clear();
  // set palette colors
  pal_all(PALETTE);
}

//HELPER METHODS
void nameTableWrite(int offset, int line, char stringy[], int size){
  vram_adr(NTADR_A(offset,line));
  vram_write(stringy, size);
}

   ///////////////
   //MAP METHODS//
   ///////////////

void drawGrass(){
  for(i=3;i<=25;i++){
    for(j=3; j<29; j++){
      map[i][j]='\x80';
    }
  }
}

void drawWalls(){
  //North Wall
  for(i=0;i<=2;i++){
    for(j=0; j<=31; j++){
      map[i][j]='\x82';
    }
  }
 /* //The SCORE:
      map[1][5]='\x53';
      map[1][6]='\x43';
      map[1][7]='\x4f';
      map[1][8]='\x52';
      map[1][9]='\x45';
      map[1][10]='\x3a';
 //the 000000
  //all the numbers 0-9 are 0x30-0x39
  for(i=2;i<=2;i++){
    for(j=5; j<=10; j++){
      map[i][j]='\x30';
    }
  }
*/
  for(i=0;i<=2;i++){
    for(j=11; j<=31; j++){
      map[i][j]='\x82';
    }
  }
  
  //East Wall
  for(i=0;i<=29;i++){
    for(j=29; j<=31; j++){
      map[i][j]='\x86';
    }
  }
  //South Wall
  for(i=26;i<=28;i++){
    for(j=0; j<=31; j++){
      map[i][j]='\x82';
    }
  }
  //West Wall
  for(i=0;i<=29;i++){
    for(j=0; j<=2; j++){
      map[i][j]='\x86';
    }
  }
  //corners
  for(i=0;i<=2;i++){
    for(j=0;j<=2;j++){
    	map[i][j]='\x85';
	map[i][j+29]='\x85';
        map[i+26][j+29]='\x85';
	map[i+26][j]='\x85';
        
    }
  }
}

//HOLE PATTERNS (81 is the char for top of hole, 2 is for black)
void map1floor(){ //The one that looks like a plus sign
  for(i=3; i<11;i++){
    for(j=3; j<13;j++){
      map[i][j]='\x2';
      map[i][j+16]='\x2';
    }
  }
  for(i=18; i<26;i++){
    for(j=3; j<13;j++){
      map[17][j]='\x81';
      map[17][j+16]='\x81';
      map[i][j]='\x2';
      map[i][j+16]='\x2';
    }
  }
}

void map2floor(){ //two holes in the middle
  for(i=0; i<10;i++){
    for(j=0; j<8;j++){
      map[i+7][j+18]='\x2';
      map[i+12][j+6]='\x2';
    }
  }
  for(j=0; j<8;j++){
    map[7][j+18]='\x81';
    map[12][j+6]='\x81';
  }
}
void map3floor(){ //weird equals sign
  for(i=0; i<2;i++){ //Horizontal lines
    for(j=0; j<10;j++){
      map[i+3][j+3]='\x2';
      map[i+3][j+19]='\x2';
      
      map[23][j+19]='\x81';
      map[i+24][j+19]='\x2';
      
      map[23][j+3]='\x81';
      map[i+24][j+3]='\x2';
      
      map[8][j+11]='\x81';
      map[i+9][j+11]='\x2';
      
      map[16][j+11]='\x81';
      map[i+17][j+11]='\x2';
    }
  }
  for(i=0; i<8;i++){ //Vertical lines
    for(j=0; j<2;j++){
      map[i+3][j+3]='\x2';
      map[i+3][j+27]='\x2';
      map[17][j+3]='\x81';
      map[i+18][j+3]='\x2';
      map[17][j+27]='\x81';
      map[i+18][j+27]='\x2';
    }
  }
  for(i=0; i<2;i++){//Corner Boxes
    for(j=0; j<2;j++){
      
      map[i+5][j+5]='\x2';
      map[i+5][j+25]='\x2';
      map[21][j+5]='\x81';
      map[i+22][j+25]='\x2';
      map[21][j+25]='\x81';
      map[i+22][j+5]='\x2';
    }
  }
}


//Creates Base for All Other Maps
void vanillaMap(){
  drawGrass();
  drawWalls();
}

//Creates map from a 6 digit seed
//[floor 1-5][doors 0-1x4][num enemies 1-5]
//ie 311101
void loadFromSeed(char seed[]){
  //Initialize Map
  vanillaMap();
  
  //Load Floor Pattern
  if(seed[0]==1){
    map1floor();
  }
  else if(seed[0]==2){
    map2floor();
  }
  else if(seed[0]==3){
    map3floor();
  }
}


//Adds Map to nametable
void loadmap(){
  for(i=0; i<=30; i++){
    nameTableWrite(0, i, map[i], 32);
  }
}

   /////////////
   // SPRITES //
   /////////////

//Generalized Structs

struct moveVars{
  //for movement
  unsigned char x;
  unsigned char y;
  unsigned char dir; //0 is left 1 is right           
};

struct actorDude {   // Structure declaration
  struct moveVars mv;
  
  //Logistics
  unsigned char id;
  unsigned char size;
  char name[32]; //unsure if we need this
  
  //Booleans
  unsigned char attacking;
  
  
  //Status
  unsigned char health;
  unsigned char alive; //0 if killed by blob or player
}; 
/*
struct scoreBoard {
  unsigned char score;
  unsigned char digi;
};
*/
//Define Metasprites

// Player Metasprites
const unsigned char Playerf1[]={
        0,      0,      pf1+0,   ATTR, 
        0,      8,      pf1+1,   ATTR, 
        8,      0,      pf1+2,   ATTR, 
        8,      8,      pf1+3,   ATTR, 
        128};
const unsigned char Playerf2[]={
        0,      0,      pf2+0,   ATTR, 
        0,      8,      pf2+1,   ATTR, 
        8,      0,      pf2+2,   ATTR, 
        8,      8,      pf2+3,   ATTR, 
        128};
//Right
const unsigned char Players1[]={
        0,      0,      ps1+0,   ATTR, 
        0,      8,      ps1+1,   ATTR, 
        8,      0,      ps1+2,   ATTR, 
        8,      8,      ps1+3,   ATTR, 
        128};
const unsigned char Players2[]={
        0,      0,      ps2+0,   ATTR, 
        0,      8,      ps2+1,   ATTR, 
        8,      0,      ps2+2,   ATTR, 
        8,      8,      ps2+3,   ATTR, 
        128};

//Left
const unsigned char Playerl1[]={
        8,      0,      ps1+0,   ATTR|OAM_FLIP_H, 
        8,      8,      ps1+1,   ATTR|OAM_FLIP_H, 
        0,      0,      ps1+2,   ATTR|OAM_FLIP_H, 
        0,      8,      ps1+3,   ATTR|OAM_FLIP_H, 
        128};
const unsigned char Playerl2[]={
        8,      0,      ps2+0,   ATTR|OAM_FLIP_H, 
        8,      8,      ps2+1,   ATTR|OAM_FLIP_H, 
        0,      0,      ps2+2,   ATTR|OAM_FLIP_H, 
        0,      8,      ps2+3,   ATTR|OAM_FLIP_H, 
        128};

const unsigned char Playerb1[]={
        0,      0,      pb1+0,   ATTR, 
        0,      8,      pb1+1,   ATTR, 
        8,      0,      pb1+2,   ATTR, 
        8,      8,      pb1+3,   ATTR, 
        128};
const unsigned char Playerb2[]={
        0,      0,      pb2+0,   ATTR, 
        0,      8,      pb2+1,   ATTR, 
        8,      0,      pb2+2,   ATTR, 
        8,      8,      pb2+3,   ATTR, 
        128};
const unsigned char PlayerLoss[]={
        0,      0,      0xe8+0,   ATTR, 
        0,      8,      0xe8+1,   ATTR, 
        8,      0,      0xe8+2,   ATTR, 
        8,      8,      0xe8+3,   ATTR, 
        128};

//Enemy metasprites
const unsigned char blobert1[]={
        0,      0,      0xf8+0,   1, 
        0,      8,      0xf8+1,   1, 
        8,      0,      0xf8+2,   1, 
        8,      8,      0xf8+3,   1, 
        128};
const unsigned char blobert2[]={
        0,      0,      0xfc+0,   1, 
        0,      8,      0xfc+1,   1, 
        8,      0,      0xfc+2,   1, 
        8,      8,      0xfc+3,   1, 
        128};
const unsigned char blobert3[]={
        0,      0,      0xEc+0,   1, 
        0,      8,      0xEc+1,   1, 
        8,      0,      0xEc+2,   1, 
        8,      8,      0xEc+3,   1, 
        128};

//creating structs
struct actorDude p;
struct actorDude b;
//struct scoreBoard s;


  /*
    map[2][5] -- hundred thousands
    map[2][6] -- ten thousands
    map[2][7] -- thousands
    map[2][8] -- hundreds
    map[2][9] -- tens
    map[2][10] -- ones
    
    all the numbers 0-9 are 0x30-0x39

  */
/*
byte whichNum(char pls){
  if(pls == 0){
    return 0x30;
  }
  else if(pls == 1){
    return 0x31;
  }
  else if(pls == 2){
    return 0x32;
  }
  else if(pls == 3){
    return 0x33;
  }
  else if(pls == 4){
    return 0x34;
  }
  else if(pls == 5){
    return 0x35;
  }
  else if(pls == 6){
    return 0x36;
  }
  else if(pls == 7){
    return 0x37;
  }
  else if(pls == 8){
    return 0x38;
  }
  else {
    return 0x39;
  }
}

void updateScore(char num){
  s.score += num;
  hold = s.score;
  for(i = 10; i >= 5; i--){
    pos = hold % 10;
    //map[2][i] = pos;
    oam_spr(i, 2, 0x37, 32, 128);
    hold = (hold - (pos))/10;
  }
}*/


void initplayer(){
  p.mv.x=120;
  p.mv.y=100;
  p.mv.dir=0;
  p.health=100;
  p.attacking=0;
  b.health=150;
  p.alive = 1;
}

void initBlob(){
  b.mv.x=120;
  b.mv.y=100;
  b.mv.dir=0;
  b.attacking=0;
  b.health=50;
  b.alive = 1;
}

//Player Movement
void walkUp(){
  if(t%2==0){ 
     p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , Playerb1);
  }
  else{
     p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , Playerb2);
  }
}
void walkRight(){
  if(t%2==0){ 
     p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , Players1);
  }
  else{
     p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , Players2);
  }
}
void walkDown(){
  if(t%2==0){ 
     p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , Playerf1);
  }
  else{
     p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , Playerf2);
  }
}
void walkLeft(){
  if(t%2==0){ 
     p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , Playerl1);
  }
  else{
     p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , Playerl2);
  }
}

//////////////
// Controls //
//////////////

void cont(){
  if(pad_poll(0)&PAD_LEFT){
     p.mv.x=p.mv.x-1;
     p.mv.dir = 3;
  }
  if(pad_poll(0)&PAD_RIGHT){
     p.mv.x=p.mv.x+1;
     p.mv.dir = 1;
  }
  if(pad_poll(0)&PAD_UP){
     p.mv.y=p.mv.y-1;
     p.mv.dir = 0;
  }
  if(pad_poll(0)&PAD_DOWN){
     p.mv.y=p.mv.y+1;
     p.mv.dir = 2;
  }
  //ATTACK BUTTON
  //future idea: add a timer for recharge so we can't just hold down space bar
  if(pad_poll(0)&PAD_A){
     p.attacking=1;
     //updateScore(10);
  }
  else{
     p.attacking=0;
  }
}

////////////////////////////////
// Collison Detection Methods //
////////////////////////////////

//NOTE THAT FOR THE map ARRAY THE OBJECT INDEXES AS [Y][X] INSTEAD OF X Y SINCE IT REPRESENTS [STRING][CHAR]

char spriteToMap(char x){
  return x/8;
}

char spriteOnGrass(char x, char y){
  x=x+8;
  y=y+16;
  if(map[spriteToMap(y)][spriteToMap(x)]=='\x80'){
    return 1;
  }
  else{
    return 0;
  }
}

char spriteOnWall(char x, char y){
  x=x+8;
  y=y+16;
  
  if(map[spriteToMap(y)][spriteToMap(x)]=='\x82' || map[spriteToMap(y)][spriteToMap(x)]=='\x86'){
    return 1;
  }
  else{
    return 0;
  }
}

/*DECISION: All overlap is noted, within the overlap we have a check if player is attacking*/
char spriteOverlap(char blobx, char bloby, char playx, char playy){
  if(map[spriteToMap(bloby)][spriteToMap(blobx)] == map[spriteToMap(playy)][spriteToMap(playx)] && (b.mv.dir != p.mv.dir)){
    return 1;
  }
  return 0;
}

char sqrt(char num){
  i = num / 2; //i is sqrt
  j = 0; //j is temp 
  
  while(i != j){ //Not perfectly accurate but so it goes
        
        j = i;
        i = ( num/j + j) / 2;
    }
  
  return i;
}

char spriteDist(s1x, s1y, s2x, s2y){
  return(sqrt((s1x-s2x)*(s1x-s2x)+(s1y-s2y)*(s1y-s2y)));
}

//////////////
// Enemy Ai //
//////////////

//   3
// 2 + 0
//   1

void blobertBob(){
    if(t%1000<150){
      b.id = oam_meta_spr(b.mv.x,b.mv.y, 32, blobert1);
      b.attacking = 1;
    }
    else{
      b.id = oam_meta_spr(b.mv.x,b.mv.y, 32, blobert2);
      b.attacking = 0; //when scrunched, not attacking
      b.health += 10;
      if(b.health > 100){ b.health = 100;} //max blobbert healths at 100
    }
}

void blobertJog(){
  if(spriteOnGrass(b.mv.x, b.mv.y)==0){
    b.mv.dir=(b.mv.dir+2)%4;
    while(spriteOnGrass(b.mv.x, b.mv.y)==0){
      if(b.mv.dir==0){
        b.mv.x=b.mv.x+1;
      }
      if(b.mv.dir==1){
        b.mv.y=b.mv.y+1;
      }
      if(b.mv.dir==2){
        b.mv.x=b.mv.x-1;
      }
      if(b.mv.dir==3){
        b.mv.y=b.mv.y-1;
      }
    }
  }
  if(t%150==0){
    b.mv.dir=rand8()%4;
  }
  if(b.mv.dir==0){
    if(t%12==0){
       b.mv.x=b.mv.x+1;
    }
  }
  else if(b.mv.dir==1){
    if(t%12==0){
       b.mv.y=b.mv.y+1;
    }
  }
  else if(b.mv.dir==2){
    if(t%12==0){
       b.mv.x=b.mv.x-1;
    }
  }
  else if(b.mv.dir==3){
    if(t%12==0){
       b.mv.y=b.mv.y-1;
    }
  }
}

void attack(){
  if((p.attacking)&&(spriteOverlap(p.mv.x, p.mv.y, b.mv.x, b.mv.y))){
    b.health = b.health - 5;
  }
     
  if((b.attacking)&&(spriteOverlap(b.mv.x, b.mv.y, p.mv.x, p.mv.y))){
      p.health = p.health - 5;
    }
}

void checkHealth(){
  if(p.health <= 0){
    p.alive = 0;
    p.attacking = 0;
    p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , PlayerLoss);

  }
  //for-loop for each blobbert once multiple added
  if(b.health <= 0){
    b.alive = 0;
    b.attacking = 0;
    b.id = oam_meta_spr(b.mv.x,b.mv.y, 32, blobert3);
  }
}


///////////////////
// Main Clean Up //
///////////////////

//Initializing Methods

void init(){
  
  loadmap();
  initplayer();
  initBlob();
}

//Runtime Methods


void move(){
  if(spriteOnGrass(p.mv.x, p.mv.y)==0&spriteOnWall(p.mv.x, p.mv.y)==0){
     initplayer();
  }
  if(p.mv.dir==0){ //up
    if(pad_poll(0)){ 
      walkUp();
    }
    else{
      p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , Playerb1);
    }
  }
  else if(p.mv.dir==1){ //right
    if(pad_poll(0)){
      walkRight();
    }
    else{
      p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , Players1);
    }
  }
  else if(p.mv.dir==2){ //down
    if(pad_poll(0)){ 
      walkDown();
    }
    else{
      p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , Playerf1);
    }
  }
  else if(p.mv.dir==3){ //left
    if(pad_poll(0)){ 
      walkLeft();
    }
    else{
      p.id = oam_meta_spr(p.mv.x,p.mv.y, 0 , Playerl1);
    }
  }
}

void main(void){
  setup_graphics();
    
  randSeed(testSeed);
  
  randSeed(testSeed);
  
  randSeed(testSeed);
  randSeed(testSeed);
    
  loadFromSeed(testSeed);
    
  loadmap();
  initplayer();
  initBlob(); //one day :D
  b.mv.x=150;
  b.mv.y=10;
    
  
  
  // enable rendering
  ppu_on_all();
  // infinite loop
  while(1) {
    
    t=t+1;
    checkHealth();
    attack();
    if(b.alive){
      blobertBob();
      blobertJog();
    }
    if(p.alive){
      move();
    }
    if(t%7==0){
      cont();
    }
    
    if(t==1000){
      t=0;
    }
  }
}
