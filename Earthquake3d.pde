float angle;

Table table;
float r = 300;

PImage earth;
PShape globe;

//create window
void setup() {
  size(900, 900, P3D);
  
//wraps an image onto sphere
 
  earth = loadImage("Earth.jpg");
  
//tables files being read from web
  
  //table = loadTable("http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_day.csv", "header");
     table = loadTable("http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv", "header");

  noStroke();
  globe = createShape(SPHERE, r);
  globe.setTexture(earth);
}

void draw() {
  background(100);
 
 //takes me to center of sphere abd rotates on y axis
  
  translate(width*0.5, height*0.5);
  rotateY(angle / 7);
  angle += 0.05;

//lights is general shading
  
  lights();
  fill(255);
  noStroke();
 
 //sphere(r);
  shape(globe);

//reads comma seperated table using java enhanced loop
  
  for (TableRow row : table.rows()) {
    float lat = row.getFloat("latitude");
    float lon = row.getFloat("longitude");
    float mag = row.getFloat("mag");
    
//sets latitude and longitude 
    
    float theta = radians(lat) + PI/2;
    float phi = radians(-lon) + PI;
    float x = r * sin(theta) * cos(phi);
    float y = r * cos(theta);
    float z = r * sin(theta) * sin(phi);
    PVector pos = new PVector(x, y, z);

//set power to mag * 10
    float h = pow(10, mag);

//set max power to magnitude 7 due to sizing issue
    float maxh = pow(5.5, 7);
    h = map(h, 0, maxh , 10, 100);
    
//rotates box around the axis to point from center and not straight down 
    
    PVector xaxis = new PVector(1, 0, 0);
    float angleb = PVector.angleBetween(xaxis, pos);//returns angle
   //gets cross product
    PVector raxis = xaxis.cross(pos);


//places a point on map and places box on there
    pushMatrix();
    translate(x, y, z);
  
  //rotates box from center
    rotate(angleb, raxis.x, raxis.y, raxis.z);
    fill(255, 0, 0);
    
  
  // box uses 3 arguments height width and depth
  //maps to earthquake height
    box(h, 2, 2);
    popMatrix();
  }
}