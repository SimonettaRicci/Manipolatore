/*

Si consideri il manipolatore a 5 gradi di libertà riportato a pag. 4-6 di questo documento e illustrato nella figura qui sopra per comodità. 
Utilizzando Processing, disegnare tale manipolatore (per semplicità i vari link, incluso il link 0, possono anche essere disegnati come semplici parallelepipedi) e scrivere il codice necessario per implementare la cinematica diretta. 
In particolare:
Mediante la pressione dei tasti da 1 a 5, deve essere possibile selezionare il giunto corrispondente che può quindi essere mosso in entrambi i versi usando le frecce destra e sinistra.
Prevedere dei finecorsa per il secondo e per il quarto giunto, cioè vincolare i parametri d2 e θ4 in un intervallo: vincolare d2 in modo che il link 2 non si sfili dal link 1 e questo non urti col link 3; vincolare θ4 in modo che il link 4 non si sovrapponga col link 3. Ignorare eventuali urti del robot col piano d'appoggio (cioè il robot può attraversare il piano d'appoggio senza problemi).
Non è richiesta l'apertura/chiusura della pinza che può essere disegnata anche come un semplice parallelepipedo.
Il sistema di riferimento di base (x0,y0,z0) deve essere scelto come in figura e i suoi assi devono essere disegnati, riportando vicino ad ogni versore anche il testo x0, y0 e z0 ad esso relativo. 
Disegnare allo stesso modo anche il sistema di riferimento della pinza (x5,y5,z5).
Riportare a schermo in tempo reale il valore assunto dalle cinque variabili di giunto (θ1, d2, θ3, θ4 e θ5), le corrispondenti coordinate dell'estremità della pinza (cioè le coordinate del punto O5 rispetto alla terna di base) e il suo orientamento (cioè le componenti dei versori x5, y5 e z5 rispetto alla terna di base).
Il valore dei vari angoli di giunto va riportato a schermo in gradi con un valore compreso tra -180o e 180o. 
Si noti che questo non è un vincolo sugli angoli effettivi dei vari giunti (che possono muoversi liberamente al di fuori di questo intervallo) ma solo una richiesta sulla loro visualizzzione a schermo.
Lasciare attive le funzionalità presenti negli sketch visti a lezione che permettono: 1) di spostare la base del robot con un click di mouse, 2) di modificare la vista verticale della scena con le frecce SU e GIÙ.

Ricci Simonetta

CORREZIONI
- il parametro d2 dovrebbe essere positivo ed avere lo stesso valore 
della coordinata y della pinza.



*/

//variabili globali utili

float xBase;
float yBase;

//parametro visuale
float eyeY = 0;

//seleziona giunto
int giunto = 0;

//variabile segno 
int segno = 1;


//dimensioni link0 (base del robot)
//uso solo due componenti perchè la funzione che disegna il cilindro usa solo le misure del raggio e dell'altezza
float d0x = 80;
float d0y = 40;
//float d0z = 45;

//dimensioni link1 (giunto rotoidale)
float d1x = 30;
float d1y = 30;
float d1z = 154;

//dimensioni link2 (giunto prismatico)
float d2x = 26;
float d2y = 26;
float d2z = 200;

//dimensioni link3 (giunto rotoidale)
float d3x = 26;
float d3y = 120;
float d3z = 26;

//dimensioni link4 (giunto rotoidale)
float d4x = 150;
float d4y = 26;
float d4z = 26;

//dimensioni link5
float d5x = 10;
float d5y = 30;
float d5z = 60;

//coordinate link5: orientamento rispetto alla terna di base
float X_5;
float Y_5;
float Z_5;

//componenti dei versori della mano rispetto al sistema di riferimento della base
float X_x5;
float X_y5;
float X_z5;
float Y_x5;
float Y_y5;
float Y_z5;
float Z_x5;
float Z_y5;
float Z_z5;

//dimensioni pinza
float d6x = 40;
float d6y = 30;
float d6z = 10;

float posPinza = 0;

//parametri di giunto q = {theta1, d2, theta3, theta4, theta5}
float[] q = {0,0,0,0,0};

//creo un vettore d'appoggio per stampare a schermo gli angoli dei giunti compresi tra -180 e 180 gradi
float[] q_schermo = {0,0,0,0,0};

void setup(){
  size(1275, 700, P3D);
  
  //posiziono il centro del robot al centro della canva
  xBase = width/2;
  yBase = height/2;

  strokeWeight(2);
  smooth();
}


void draw(){
  
  pushMatrix();
  
  background(#000000); 
  lights();
  
  // Permette di ruotare la vista:
  camera((width/2.0), height/2 - eyeY, (height/2.0) / tan(PI*60.0 / 360.0), width/2.0, height/2.0, 0, 0, 1, 0);  
  
  
  if (mousePressed){
    xBase = mouseX;
    yBase = mouseY;
  }
  if (keyPressed){
    // movimento camera
    if (keyCode == DOWN){
      eyeY -= 2;
    }
    if (keyCode == UP){
      eyeY += 2;
    }
    if (key == '1'){
      giunto = 0;
    }
    if (key == '2'){
      giunto = 1;
    }
    if (key == '3'){
      giunto = 2;
    }
    if (key == '4'){
      giunto = 3;
    }
    if (key == '5'){
      giunto = 4;
    }
    
    if(keyCode == LEFT){
     segno = -1;
     muovi();
   }
   if(keyCode == RIGHT){
     segno = 1;
     muovi();
   }
  }
  
  drawMyRobot();
  popMatrix();
  
  //didascalie
  textSize(18);
  fill(#FFFFFF); 
  
  //giunto selezionato
  text("giunto = ",20, 85);
  text(giunto + 1, 135, 85);
  
  //posizione giunto 1
  text("theta1 = ", 20, 115);
  text(q_schermo[0]*180/PI, 128, 115);
  
  //posizione giunto 2
  text("d2 = ", 20, 145);
  text(q[1], 128, 145);
  
  //posizione giunto 3
  text("theta3 = ", 20, 175);
  text(q_schermo[2]*180/PI, 128, 175);
  
  //posizione giunto 4
  text("theta4 = ", 20, 205);
  text(q_schermo[3]*180/PI, 128, 205);
  
  //posizione giunto 5
  text("theta5 = ", 20, 235);
  text(q_schermo[4]*180/PI, 128, 235);
  
  //calcolo coordinate del link5 rispetto alla terna di base
  X_5 = (-sin(q[3])*cos(q[2])-cos(q[3])*sin(q[2]))*cos(q[0])*175 + 120*cos(q[2])*cos(q[0]) - (200+q[1])*sin(q[0]);
  Y_5 = 175*(-sin(q[3])*sin(q[0])*cos(q[2])-cos(q[3])*sin(q[0])*sin(q[2]))+(200+q[1])*cos(q[0])+120*sin(q[0])*cos(q[2]);
  Z_5 = 175*(-cos(q[3])*cos(q[2])+ sin(q[3])*sin(q[2])) - 120*sin(q[2])+35;
  
  //scrivo a schermo le coordinate appena ottenute
  fill(#FEFF00); //giallo
  text("Orientamento della pinza rispetto alla terna di base", 20, 300);
  text("X_5 = ", 20, 330);
  text(X_5, 100, 330);
  text("Y_5 = ", 20, 360);
  text(Y_5, 100, 360);
  text("Z_5 = ", 20, 390);
  text(Z_5, 100, 390);
  
  //calcolo versori della mano rispetto alla terna di base
  //versore e_X5:
  X_x5 = cos(q[0])*cos(q[4])*(cos(q[3])*cos(q[2])-sin(q[3])*sin(q[2])) + sin(q[0])*sin(q[4]); //componente x
  X_y5 = cos(q[4])*(cos(q[3])*sin(q[0])*cos(q[2])-sin(q[3])*sin(q[0])*sin(q[2])) - cos(q[0])*sin(q[4]); //componente y
  X_z5 = cos(q[4])*(-sin(q[3])*cos(q[2])-cos(q[3])*sin(q[2])); //componente z
  
  //versore e_Y5
  Y_x5 = cos(q[0])*(-sin(q[4]))*(cos(q[3])*cos(q[2])-sin(q[3])*sin(q[2])) + sin(q[0])*cos(q[4]); //componente x
  Y_y5 = -sin(q[4])*(cos(q[3])*sin(q[0])*cos(q[2])-sin(q[3])*sin(q[0])*sin(q[2])) - cos(q[0])*cos(q[4]); //componente y
  Y_z5 = -sin(q[4])*(-sin(q[3])*cos(q[2])-cos(q[3])*sin(q[2])); //componente z
  
  //versore e_Z5
  Z_x5 = (-sin(q[3])*cos(q[2])-cos(q[3])*sin(q[2]))*cos(q[0]); //componente x
  Z_y5 = -sin(q[3])*sin(q[0])*cos(q[2])-cos(q[3])*sin(q[0])*sin(q[2]); //componente y
  Z_z5 = -cos(q[3])*cos(q[2])+sin(q[3])*sin(q[2]); //componente z
  
  
  //riporto le componenti dei versori a schermo
  text("Componenti dei versori della mano", 20, 500);
  text("e_X5 =  ", 20, 530);
  text(X_x5, 100, 530);
  text(X_y5, 190, 530);
  text(X_z5, 300, 530);
  
  text("e_Y5 = ", 20, 560);
  text(Y_x5, 100, 560);
  text(Y_y5, 190, 560);
  text(Y_z5, 300, 560);
  
  text("e_Z5 = ", 20, 590);
  text(Z_x5, 100, 590);
  text(Z_y5, 190, 590);
  text(Z_z5, 300, 590);
  
  //posizione vista
  fill(#FFFFFF);
  text("coordinata y vista = ",20,55); 
  text(eyeY,260,55);
}

void drawMyRobot(){
  
  translate(xBase, yBase);
  
  //disegno gli assi di riferimento del link0, posizionati nel suo centro
  stroke(#FEFF00);  //giallo
  strokeWeight(3);
  textSize(15);
  fill(#FEFF00);
  //line(x1, y1, z1, x2, y2, z2)
  line(0,d0y/2,0,0,d0y/2,100);//asse x0 uscente dallo schermo
  text("x0", -30, 30, 130);
  line(0,d0y/2,0,160,d0y/2,0); //asse y0
  text("y0", 150, 20, 25);
  line(0,d0y/2,0,0,-100,0); //asse z0
  text("z0", 5, -100);
  
  
  //disegno il link0 del robot
  fill(#0D2EFC); //blu
  stroke(#5977ED); //azzurro
  drawCylinder(d0x, d0x, d0y, 64);
  rotateY(q[0]);  //permette la rotazione

  //disegno il link1 
  rotateY(-PI/2);
  translate(0, -d1y/2, 0);
  stroke(#5977ED);
  box(d1x, d1y, d1z); 
  translate(0,0,-q[1]);
  
  //disegno il link2
  translate(0, 0, -d2z/2);
  box(d2x, d2y, d2z);
  translate(0, 0, -d2z/2);
  noStroke();
  fill(#FEFF00);
  sphere(d2x*sqrt(2)/2);
  rotateZ(q[2]);

  //disegno il link3
  rotateZ(PI/2);
  stroke(#5977ED);
  fill(#0D2EFC);
  translate(0, -d3y/2, 0);
  box(d3x, d3y, d3z);
  translate(0, -d3y/2, 0);
  noStroke();
  fill(#FEFF00);
  sphere(d2x*sqrt(2)/2);
  rotateZ(q[3]);
  
  //disegno il link4
  stroke(#5977ED);
  fill(#0D2EFC);
  translate(d4x/2, 0, 0);
  box(d4x, d4y, d4z);
  rotateX(-q[4]);
  
  //disegno il link5
  translate(d4x/2, 0, 0);
  stroke(#FFD603);
  fill(#FEFF00);
  box(d5x, d5y, d5z);
  
  //Pinza
  pushMatrix(); // Memorizzo il sistema attuale
  translate(d5x/2+d6x/2+posPinza, 0, d5z/2-d6z/2);  //coordinate z per avere la pinza aperta = -(d5z-d6z)/2
  box(d6x,d6y,d6z); // Disegno il primo elemento della pinza
  popMatrix();  // Ritorno al sistema di riferimento memorizzato
  translate(d5x/2+d6x/2+posPinza,0, (-d5z+d6z)/2);  //coordinate z per avere la pinza aperta = d5z/2-d6z/2
  box(d6x,d6y,d6z); // Disegno il secondo elemento della pinza

  //disegno assi riferimento del link5
  stroke(#0D2EFC);
  strokeWeight(3);
  textSize(15);
  fill(#FEFF00);
  //line(x1, y1, z1, x2, y2, z2)
  line(0,0,d5z/2-d6z/2,100,0,d5z/2-d6z/2);
  line(0,0,d5z/2-d6z/2,0,0,100+d5z/2-d6z/2);
  line(0,0,d5z/2-d6z/2,0,-100,d5z/2-d6z/2);
  text("x5", 0,-100,d5z/2-d6z/2);
  text("y5", 0,10,100+d5z/2-d6z/2);
  text("z5", 100,0,d5z/2-d6z/2); 

}


void  muovi(){
  //non so quanto sia utile questo if
  //if(q[giunto]*180/PI>=360 || q[giunto]*180/PI<=-360){
  //  q[giunto]=0;
  //}
  
  //se l'angolo di giunto è compreso tra -180 e 180 gradi, allora posso scrivere il suo valore così com'è
  if(q[giunto]*180/PI >= -180 || q[giunto]*180/PI <= 180){
    q_schermo[giunto] = q[giunto];
  }
  //se l'angolo di giunto è minore di -180, allora 360+angolo
  if(q[giunto]*180/PI < -180){
    q_schermo[giunto] = 2*PI + q[giunto];
  }
  //se l'angolo di giunto è maggiore di 180, allora -360+angolo
  if(q[giunto]*180/PI > 180){
    q_schermo[giunto] = -2*PI + q[giunto];
  }
  
  
  if (giunto == 0){
    q[giunto] += segno*0.02;
  }
  if (giunto == 1){
    //if(segno*q[giunto]-d1x/3 < 0){
    //    q[giunto] += segno*0.2;
    //  }
    q[1] += segno*1;
    if (q[1]>=75 || q[1]<=-75){
      q[1] = segno*75;
    }
  }
  if (giunto == 2){
    q[giunto] += segno*0.02;
  }
  if (giunto == 3){
    if(keyCode == RIGHT && q[giunto]<PI/4){
     q[giunto] += segno*0.02;
    }
    if(keyCode == LEFT && q[giunto]>-215*PI/180){
      q[giunto] += segno*0.02;
    }
    
  }
  if (giunto == 4){
       q[giunto] += segno*0.02;
    }
  }




//funzione che si occupa di disegnare coni e cilindri. In questo caso si chiama drawCylinder perchè non verranno mai disegnati dei coni.  
void drawCylinder(float topRadius, float bottomRadius, float tall, int sides) {
  float angle = 0;
  float angleIncrement = TWO_PI / sides;
  beginShape(QUAD_STRIP);
  for (int i = 0; i < sides + 1; ++i) {
    vertex(topRadius*cos(angle), 0, topRadius*sin(angle));
    vertex(bottomRadius*cos(angle), tall, bottomRadius*sin(angle));
    angle += angleIncrement;
  }
  endShape();
  
  // If it is not a cone, draw the circular top cap
  if (topRadius != 0) {
    angle = 0;
    beginShape(TRIANGLE_FAN);
    
    // Center point
    vertex(0, 0, 0);
    for (int i = 0; i < sides + 1; i++) {
      vertex(topRadius * cos(angle), 0, topRadius * sin(angle));
      angle += angleIncrement;
    }
    endShape();
  }

  // If it is not a cone, draw the circular bottom cap
  if (bottomRadius != 0) {
    angle = 0;
    beginShape(TRIANGLE_FAN);

    // Center point
    vertex(0, tall, 0);
    for (int i = 0; i < sides + 1; i++) {
      vertex(bottomRadius * cos(angle), tall, bottomRadius * sin(angle));
      angle += angleIncrement;
    }
    endShape();
  }
}
