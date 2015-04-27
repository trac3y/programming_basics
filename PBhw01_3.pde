/*
* Tracey Lum
* Programming Basics Assignment 01
*/

//GLOBAL VARIABLES
int width = 560;
int height = 680;
int backgroundColor = 0;

PFont font;
int fontSize = 64;
int start = 500;
String words;
int clickCounter = 0;
int textOp = 255; // text opacity
int textColor;

// PARTICLE CONSTANTS
float PARTICLE_DIAMETER = 40;
float spring = 0.001;
float gravity = 0.2;
float friction = -0.6;
ArrayList<Particle> particles = new ArrayList<Particle>();
int SPAWN_SIZE = 50;

void setup() {
  size(width, height);
  background(backgroundColor);

  font = loadFont("AGHelveticaBold-120.vlw");
  textFont(font, fontSize);
  textAlign(LEFT);
  textColor = 255;  
  words = "Hi, \nplease click.";
  font = loadFont("AGHelveticaBold-120.vlw");
  textFont(font, fontSize);
}

void draw() {
  background(backgroundColor);

  for (int i = 0; i < particles.size (); i++) {
    Particle curr = particles.get(i);
    if (curr.lifespan < 0.0) {
      particles.remove(i);
      print("Removing particle " + i);
    } else {
      curr.collide();
      curr.update();
      curr.display();
    }
  }

  //fill(textOp);
  fill(textColor);
  text(words, 15, start);
  textAlign(LEFT);
}

void updateText() {
  background(backgroundColor);
  // Changes text based on how many clicks you have made
  switch(clickCounter) {
  case 0:
    words = "My \nname \nis Tracey.";
    textColor = 0;
    break;
  case 1:
    words = "I am\nfrom \nNew York.";
    break;
  case 2: 
    fontSize = 56;
    start = 450;
    words = "I am\nstudying \nComputer Science\n& Interactive Media.";
    break;
  case 3:
    fontSize = 64;
    start = 500;
    words = "I play \nultimate \nfrisbee.";
    break;
  case 4:
    words = "I like \nriding \nmy bike.";
    break;
  case 5:
    words = "I am \nbad at \ncooking.";
    break;
  case 6:
    words = "My \nfavorite color \nis green.";
    fill(96, 210, 92);
    //text("green", 80, 650);
    //fill(255);
    //text(".", 260, 650);
    break;
  case 7:
    words = "I \nlike \nfun socks.";
    break;
  case 8:
    words = "I have \nan eraser \ncollection.";
    break;
  case 9:
    words = "I think \nfractals \nare cool.";
    break;
  default:
    words = "the \nend.";
    break;
  }
  clickCounter++;
  //textOp -= 10;
}

// Updates the text and creates new particles at location user clicks
void mouseClicked() {
  updateText();
  float newX = mouseX;
  float newY = mouseY;
  for (int i = 0; i < SPAWN_SIZE; i++) {
    particles.add(new Particle(newX, newY, i, particles));
  }
}

// A Particle class
class Particle {
  float x, y;  // position
  float vx, vy;  // velocity
  float diameter; // diameter;
  int id;  // particle id
  float lifespan;
  ArrayList<Particle> others;

  // Particle class constructor
  // Takes in x-position and y-position
  Particle(float xin, float yin, int iid, ArrayList<Particle> othersin) {
    x = xin;
    y = yin;
    vx = random(-3, 3);
    vy = random(-4, 4);
    diameter = PARTICLE_DIAMETER;
    id = iid;
    lifespan = 255;
    others = othersin;
  }

  // handling collisions
  void collide() {
    for (int i = id + 1; i < others.size (); i++) {
      float distx = others.get(i).x - x;
      float disty = others.get(i).y - y;
      float distance = sqrt(distx*distx + disty*disty);
      float minDist = PARTICLE_DIAMETER;
      if (distance < minDist) {
        print(id + " colliding with particle " + i + "\n");
        float angle = atan2(distx, disty);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others.get(i).x) * spring;
        float ay = (targetY - others.get(i).y) * spring;
        vx -= ax;
        vy -= ay;
        others.get(i).vx += ax;
        others.get(i).vy += ay;
      }
    }
  }

  void update() {
    others = particles;
    vy += gravity;
    x += vx;
    y += vy;

    // Handles wall collisions
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction;
    } else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction;
    } else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
    // decrement lifespan each tick
    lifespan -= 1.0;
  }

  void display() {
    //print("displaying particle" + id + "\n");
    noStroke();
    fill(255, lifespan);
    ellipse(x, y, diameter, diameter);
  }
}
