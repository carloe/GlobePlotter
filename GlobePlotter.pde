import processing.opengl.*;

// Author:  Carlo Eugster <carlo@relaun.ch>
// Web:     http://carlo.io

// Settings
int latOffset = 2;
int lonOffset = 3;
int windowWith = 1200;
int windowHeight = 600;
float distance = 2000;

Globe globe;

//===----------------------------------------------------------------------===//
// Main Application
//===----------------------------------------------------------------------===//
void setup() {
  size(windowWith, windowHeight, OPENGL);
  background(0);
  camera(windowWith/2, windowHeight/2, distance, windowWith/2, windowHeight/2, 0.0, 0.0, 1.0, 0.0);
  smooth();

  globe = new Globe();
  globe.loadData();
}

void draw() {
  background(0, 0, 0, 255);
  globe.update();
  globe.render();
}

//===----------------------------------------------------------------------===//
// Globe Class
//===----------------------------------------------------------------------===//
class Globe {
  float xPos   = 0;
  float yPos   = 0;
  float zPos   = 0;
  float radius = 800;
  float rotation = 0;

  ArrayList<Marker> items = new ArrayList<Marker>();

  public void init() {
    for(int i=0; i<300; i++) {
      Marker si = new Marker();
      si.parentSphere = this;
      si.theta = random(PI * 2);
      si.phi = random(PI * 2);
      items.add(items.size(), si);
      si.init();
    }
  };

  public void update() {
    rotation += 1;
    if(rotation>=360) rotation = 0;

    xPos = round(width/2);
    yPos = round(height/2);

    for(Marker m : this.items) {
      m.update();
    }
  };

  public void render() {
    translate(xPos, yPos, zPos);
    rotateX(radians(90));
    rotateZ(radians(90 + (rotation)));

    fill(0, 0, 0, 255);
    noStroke();
    sphereDetail(32, 32);
    sphere(radius-1);

    for(Marker m : this.items) {
      m.render();
    }
  };

  void loadData() {
    String[] src = loadStrings("data/cities.csv");
    for(int i=0; i<src.length; i++) {
      print(src[i]);
      String [] item = src[i].split(",");
      Marker m = new Marker();

      m.location.lon = Float.valueOf(item[lonOffset]);
      m.location.lat = Float.valueOf(item[latOffset]);

      m.parentSphere = this;
      m.pop = int(item[1]);
      items.add(m);
      m.init();
    }
    print("Loaded " + items.size() + " cities.\n");
  }
};

//===----------------------------------------------------------------------===//
// Marker Class
//===----------------------------------------------------------------------===//
class Marker {
  Location location;
  Globe parentSphere;
  float radius;
  float theta;
  float phi;

  String name;
  int pop=0;

  Marker() {
    location = new Location();
  }

  void init() {
    // stub
  }

  void update() {
    // stub
  }

  void render() {
    //Get the radius from the parent Sphere
    float r = parentSphere.radius;
    //Convert spherical coordinates into Cartesian coordinates
    float lon = (-1)*radians(location.lon);
    float lat = radians(location.lat);

    float x = cos(lat) * cos(lon) * r;
    float y = cos(lat) * sin(lon) * r;
    float z = sin(lat) * r;

    pushMatrix();
    translate(x,y,z);
    noStroke();
    blendMode(ADD);

    fill(0, 106, 255, 150);
    float multi  = (pop/1000000)+1;
    sphereDetail(round(multi), round(multi)*2);
    sphere(5*multi);
    popMatrix();
  }
};

//===----------------------------------------------------------------------===//
// Location Class
//===----------------------------------------------------------------------===//
class Location {
  float lon;
  float lat;
};
