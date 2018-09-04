// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/IKB1hWWedMk

// Built in Variables 
//int width,height;
//int mouseX,mouseY,pmouseX, pmouseY;
//char key;
//int keyCode;
//boolean keyPressed, focused;
//float frameRate;
//int frameCount;
// blendMode(MULTIPLY);
//BLEND - linear interpolation of colours: C = A*factor + B. This is the default blending mode.
//ADD - additive blending with white clip: C = min(A*factor + B, 255)
//SUBTRACT - subtractive blending with black clip: C = max(B - A*factor, 0)
//DARKEST - only the darkest colour succeeds: C = min(A*factor, B)
//LIGHTEST - only the lightest colour succeeds: C = max(A*factor, B)
//DIFFERENCE - subtract colors from underlying image.
//EXCLUSION - similar to DIFFERENCE, but less extreme.
//MULTIPLY - multiply the colors, result will always be darker.
//SCREEN - opposite multiply, uses inverse values of the colors.
//REPLACE - the pixels entirely replace the others and don't utilize alpha (transparency) values

//We recommend using blendMode() and not the previous blend() function. 
//However, unlike blend(), the blendMode() function does not support the following: 
//HARD_LIGHT, SOFT_LIGHT, OVERLAY, DODGE, BURN. 
//On older hardware, the LIGHTEST, DARKEST, and DIFFERENCE modes might not be available as well.


int cols, rows;
int cols2, rows2;
int scl = 20;
int scl2 = 30;
int w = 2000;
int h = 1600;
// float wiggle = 0.0 ;
// float wiggleinc = 0.25 ;
float flying = 0;
float[][] terrain;
// boolean gridon = false; 
boolean gridon = true;

void setup() {
  size(600, 600, P3D);
  cols = w / scl;
  rows = h / scl;
  cols2 = w / scl2;
  rows2 = h / scl2;
  terrain = new float[cols][rows];
 // frameRate(2);  
  //blendMode(BLEND);        //unchanged
  //blendMode(ADD);          // first col unchanged 2nd row ok grid grey to white
  //blendMode(SUBTRACT);     // black
  //blendMode(DARKEST);        //...black
  //blendMode(LIGHTEST);     // whiter no outline light grey grid
  //blendMode(DIFFERENCE);   // unchanged
  //blendMode(EXCLUSION);    // first col unchanged 2nd row ok grid grey
  //blendMode(MULTIPLY);     //...black
  //blendMode(SCREEN);       // first col unchanged 2nd row ok grid rapid white
  //blendMode(REPLACE);      // unchanged
  //blend(src, sx, sy, sw, sh, dx, dy, dw, dh, mode);
    
}


void draw() {
  // this actually implements the animation, the sign controls direction of flight
  flying -= 0.1;

  // controls the noise offset
  float offinc = 0.2;    // Daniel offinc = 0.2; me 0.3
  // controls the mapped height (bumpiness)
  float randinc = 100;    // Daniel randinc = 100; me 80
  
  float yoff = flying;
  
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(xoff,yoff), 0, 1, -randinc, randinc);
      xoff += offinc;
    }
    yoff += offinc;
  }
  
  // background(200,255,0);
 background(0);
  blendMode(BLEND);        //unchanged
  if (gridon) {
    //Draw Grid to show transparency
    for (int y = 0; y < rows2; y++) {
      for (int x = 0; x < cols2; x++) {
        rect(x*scl2, y* scl2, (x+1)*scl2, (y+1)*scl2);
        if ((x % 2)==0 && (y % 2)==0){ 
           stroke(255);             // draw white boundary
//           fill(128,0,0,8);               // fill with grey colour
          noFill();
        }
        else {
          stroke(64);             // draw white boundary
          //fill(0,0,0,8);                // fill with white colour //  
          noFill();
        } 
      }
    }
  }
  
  blendMode(BLEND);        // unchanged opaque red hills DEFAULT
  //blendMode(ADD);          // Good transparent red hills
  //blendMode(SUBTRACT);     // weird like red hill blue shadows on grids
  //blendMode(DARKEST);      // weird faint red hill colors on grids 
  //blendMode(LIGHTEST);     // OK transparent red hills no outline
  //blendMode(DIFFERENCE);   // red hils opaque
  //blendMode(EXCLUSION);    // weird like grid in front of lighter red hills 
  //blendMode(MULTIPLY);     // weird like grid in front of darker red hills 
  //blendMode(SCREEN);       // OK transparent lighter red hills
  //blendMode(REPLACE);        // unchanged opaque red hills DEFAULT
  //blend(src, sx, sy, sw, sh, dx, dy, dw, dh, mode);

  
  // smooth();
  // stroke(64);
  noStroke();
  noFill();
  
  // Move coordinate origin to centre of screen width and height + a pre height adjust
  int pre_HeightAdjust = 100; // This sets height of viewpoint above the plane - default 50
  int postHeightAdjust = 400; // This sets distance of viewpoint from the plane - default 0 
  // int postHeightAdjust = pre_HeightAdjust; // default 0 
  translate(width/2,height/2+pre_HeightAdjust);
  
  // Rotate
  float rotateXAngle = 3.0;  // PI divisor for rotation def=3.0
                        // == 0 = Clouds 
                        // == 1 Vertical
                        // < 2 = Clouds 
                        // [2..4] = horizontal to 45 % vertical mountains
                        // 999999 = Verical Blue Red Top to bottom
  if ( rotateXAngle == 0.0 ) {
    //trapping divide by Zero error
    //rotateXAngle = 0.000000000000000000000000000000000000000000001);  // Plane Rotation angle in Radians
    rotateXAngle = 0.00000000000000000000000000000000000001;  // Plane Rotation angle in Radians
  }
  rotateX(PI/rotateXAngle);  // Plane Rotation angle in Radians
  // Move coordinate origin back except for post height adjust 
  translate(-w/2,-h/2-postHeightAdjust);
  
  //wiggle=rows/2;
  //wiggleinc=wiggle/rows;

  float r,g,b,a;
  int k;
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    // wiggle-=wiggleinc;
    for (int x = 0; x < cols; x++) {
      vertex(x*scl,y*scl,terrain[x][y]);
      vertex(x*scl,(y+1)*scl,terrain[x][y+1]);
      //vertex(x*scl,y*scl,random(-wiggle,wiggle));
      //vertex(x*scl,(y+1)*scl,random(-wiggle,wiggle));
      //rect(x*scl, y*scl, scl, scl);
      // fill(random(255),random(255),random(255));
    }
    // Define colours and transparency
    r = map(y,0,rows-2,0,255);
    b = 256 - map(y,0,rows-2,0,255);  
 // k = int(random(cols));
    k = cols-1;
    g = map(terrain[k][y]+randinc,0,randinc*2,0,255);
    // a = 255; //
    // Bugfix for first row (rows -2)
    a= map(y,0,rows,50,255);   // set transparency range to be related to row
    a=255; // opaque
//    fill(r,g,b,a);
    endShape();
    
    //stroke(64);             // draw grey triangle boundary
    //fill(r,g,b,a);          // fill with colour

    // Bugfix for first row     
    if ( (y % rows+1)!=rows-1) {
      stroke(64);             // draw grey triangle boundary
      fill(r,g,b,a);          // fill with colour
      } else {                // hide row
          noStroke();
          noFill();
          // stroke(64);
          //fill(0,0,0,64);
      }    
  }  
}
