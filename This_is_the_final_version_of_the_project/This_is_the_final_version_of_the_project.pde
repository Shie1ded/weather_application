import controlP5.*; //<>//
import javax.swing.JOptionPane;

void setup() {
  background(175);
  size(1700, 1000);
}

boolean firstTime = true;

void draw() {
  if (!gametime) {
    if (firstTime) createbuttons();
    TemperatureData[] data = createArray(359);
    populateArray(data);
    graphMode(data);
  } else GameRedirect();
}

//////////////////////////////////////////////////////////////
//  
//            Functions
//

TemperatureData[] createArray(int dataPoints) {
  TemperatureData[] data = new TemperatureData [dataPoints];
  return data;
}

void populateArray(TemperatureData[] data) {
  fillEmptyTemperatureData(data);
  fillDate(data); 
  fillMaxTemperature(data);
  fillMinTemperature(data);
  fillSnowFall(data);
}

void graphMode(TemperatureData[] data) {
  if (tbar) if (refresh) drawbar(data);
  if (tscatter) if (refresh) scatterDraw(data);
  if (tpie) if (refresh) drawPie(data);
  if (tline) if (refresh) drawLine(data);
  if (data_info) displayDataInfo(data);
}

void drawbar(TemperatureData[] data) {
  background(175);
  refresh = !refresh;
  drawLines();
  drawTemperatureScale();
  if (tmaxtemp) barChartMaxTemperature(data);
  if (tmintemp) barChartMinTemperature(data);
  if (tsnowfall) barSnowfall(data);
  drawYearScale();
}

void scatterDraw(TemperatureData[] data) {
  background(175);
  refresh = !refresh;
  drawLines();
  drawTemperatureScale();
  if (tmaxtemp) scatterPlotMaxTemperature(data);
  if (tmintemp) scatterPlotMinTemperature(data);
  if (tsnowfall) barSnowfall(data);
  drawYearScale();
}

void drawPie(TemperatureData[] data) {
  background(175);
  refresh = !refresh;
  if (tmaxtemp||tmintemp) {
    drawLegend();
    drawPieGraph(data);
    drawPiePercents(data);
  } else blankPie();
}

void drawLine (TemperatureData[] data) {
  background(175);
  refresh = !refresh;
  drawLines();
  drawTemperatureScale();
  if (tmaxtemp) lineChartMaxTemperature(data);
  if (tmintemp) lineChartMinTemperature(data);
  if (tsnowfall) barSnowfall (data);
  drawYearScale();
}

void displayDataInfo(TemperatureData[] data) {
  String x = getDataMessage(data);
  JOptionPane.showMessageDialog(frame, x, "Instructions", JOptionPane.OK_OPTION);
  data_info = !data_info;
}

////////////////////////////////////////////////////////////////////////
//  
//            Populate Array Functions
//

void fillEmptyTemperatureData(TemperatureData[] data) {
  for (int i = 0; i<data.length; i++) {
    data[i] = new TemperatureData();
  }
}

void fillDate(TemperatureData[] data) {
  fillMonth(data);
  fillYear(data);
}

void fillMonth(TemperatureData[] data) {
  int month = 1;
  for (int i = 0; i<data.length; i++) {
    data[i].date.month = month;
    month++;
    if (month == 13) month = 1;
  }
}

void fillYear(TemperatureData[] data) {
  int year = 1990;
  for (int i = 0; i<data.length; i++) {
    data[i].date.year = year;
    if ((i+1)%12==0) year++;
  }
}

void fillMaxTemperature(TemperatureData[] data) {
  for (int i = 0; i<data.length; i++)
    data[i].maxTemperature = getMaxTemperature(i);
}

void fillMinTemperature(TemperatureData[] data) {
  for (int i = 0; i<data.length; i++)
    data[i].minTemperature = getMinTemperature(i);
}

void fillSnowFall(TemperatureData[] data) {
  for (int i = 0; i<data.length; i++)
    data[i].snowFall = getSnowFall(i);
}

void drawSnowFallPoints(TemperatureData[] data) {
  float movement = 0;
  for (int i=0; i<data.length; i++) {
    fill(255);
    if (monthFilter(data, i)) {
      circle(105 + movement, 700+data[i].snowFall*-15, 7.15);
      if (i!=0&&monthFilter(data, i-1)) {
        stroke(255);
        line(105+(movement-4.15), 700+data[i-1].snowFall*-15, 105 + movement, 700+data[i].snowFall*-15);
        stroke(0);
      }
    }
    movement += 4.15;
  }
}

////////////////////////////////////////////////////////////
//  
//            Draw Line Functions
//

void drawLines() {
  line(100, 700, 1600, 700);
  line(100, 200, 100, 1000);
}

void drawTemperatureScale() {
  for (int i = 0; i<9; i++) {
    fill(255);
    textSize(20);
    int x = -15 + 5*i;
    text(x, 55, (930 -75*i));
  }
}

void drawbarScale() {
  line(1605, 200, 1605, 950);
  for (int i = 0; i<9; i++) {
    fill(255);
    textSize(20);
    int x = -15 + 5*i;
    text(x, 1610, (930 -75*i));
  }
}

void barSnowfall(TemperatureData[] data) {
  drawbarScale();
  drawSnowFallPoints(data);
}

void drawYearScale() {
  fill(255);
  for (int i = 0; i<30; i++) {
    textSize(15);
    int x = 1990 + i;
    text(x, 110 + 50*i, 680);
  }
}

//////////////////////////////////////////////////////////////
//
//            Bar graph
//

void barChartMaxTemperature(TemperatureData[] data) {
  float movement = 0;
  for (int i=0; i<data.length; i++) {
    fill(255, 0, 0);
    if (monthFilter(data, i)) {
      rect(105 + movement, 700, 4.15, data[i].maxTemperature*-15);
    }
    movement += 4.15;
  }
}

void barChartMinTemperature(TemperatureData[] data) {
  float movement = 0;
  for (int i=0; i<data.length; i++) {
    fill(0, 0, 255);
    if (monthFilter(data, i)) {
      rect(105 + movement, 700, 4.15, data[i].minTemperature*-15);
    }
    fill(255, 0, 0);
    if (monthFilter(data, i) && tmaxtemp && data[i].maxTemperature < 0) {
      rect(105 + movement, 700, 4.15, data[i].maxTemperature*-15);
    }
    movement += 4.15;
  }
}

/////////////////////////////////////////////////////////////
//
//            Scatter Plot
//

void scatterPlotMaxTemperature(TemperatureData[] data) {
  float movement = 0;
  for (int i=0; i<data.length; i++) {
    fill(255, 0, 0);
    if (monthFilter(data, i)) {
      circle(105 + movement, 700+data[i].maxTemperature*-15, 7.15);
    }
    movement += 4.15;
  }
}

void scatterPlotMinTemperature(TemperatureData[] data) {
  float movement = 0;
  for (int i=0; i<data.length; i++) {
    fill(0, 0, 255);
    if (monthFilter(data, i)) {
      circle(105 + movement, 700+data[i].minTemperature*-15, 7.15);
    }
    movement += 4.15;
  }
}

Boolean monthFilter(TemperatureData[] data, int x) {
  if (!tjan && data[x].date.month%12 == 1) return false;
  if (!tfeb && data[x].date.month%12 == 2) return false;
  if (!tmar) if (data[x].date.month%12 == 3) return false;
  if (!tapr) if (data[x].date.month%12 == 4) return false;
  if (!tmay) if (data[x].date.month%12 == 5) return false;
  if (!tjun) if (data[x].date.month%12 == 6) return false;
  if (!tjul) if (data[x].date.month%12 == 7) return false;
  if (!taug) if (data[x].date.month%12 == 8) return false;
  if (!tsep) if (data[x].date.month%12 == 9) return false;
  if (!toct) if (data[x].date.month%12 == 10) return false;
  if (!tnov) if (data[x].date.month%12 == 11) return false;
  if (!tdec) if (data[x].date.month%12 == 0) return false;

  if (!t1990 && data[x].date.year == 1990) return false;
  if (!t1991 && data[x].date.year == 1991) return false;
  if (!t1992 && data[x].date.year == 1992) return false;
  if (!t1993 && data[x].date.year == 1993) return false;
  if (!t1994 && data[x].date.year == 1994) return false;
  if (!t1995 && data[x].date.year == 1995) return false;
  if (!t1996 && data[x].date.year == 1996) return false;
  if (!t1997 && data[x].date.year == 1997) return false;
  if (!t1998 && data[x].date.year == 1998) return false;
  if (!t1999 && data[x].date.year == 1999) return false;
  if (!t2000 && data[x].date.year == 2000) return false;
  if (!t2001 && data[x].date.year == 2001) return false;
  if (!t2002 && data[x].date.year == 2002) return false;
  if (!t2003 && data[x].date.year == 2003) return false;
  if (!t2004 && data[x].date.year == 2004) return false;
  if (!t2005 && data[x].date.year == 2005) return false;
  if (!t2006 && data[x].date.year == 2006) return false;
  if (!t2007 && data[x].date.year == 2007) return false;
  if (!t2008 && data[x].date.year == 2008) return false;
  if (!t2009 && data[x].date.year == 2009) return false;
  if (!t2010 && data[x].date.year == 2010) return false;
  if (!t2011 && data[x].date.year == 2011) return false;
  if (!t2012 && data[x].date.year == 2012) return false;
  if (!t2013 && data[x].date.year == 2013) return false;
  if (!t2014 && data[x].date.year == 2014) return false;
  if (!t2015 && data[x].date.year == 2015) return false;
  if (!t2016 && data[x].date.year == 2016) return false;
  if (!t2017 && data[x].date.year == 2017) return false;
  if (!t2018 && data[x].date.year == 2018) return false;
  if (!t2019 && data[x].date.year == 2019) return false;
  return true;
}


///////////////////////////////////////////////////
//  
//            Draw PieChart Functions
//

void drawLegend() {
  fill(200);
  rect(1290, 220, 230, 630);
  fill(0);
  textSize(50);
  text("Legend", 1315, 280);
  line(1315, 290, 1492, 290);
  textSize(30);
  for (int i = 0; i<9; i++) {
    if (i<6) fill(255-40*i, 0, 0);
    else fill(0, 0, 0+100*(i-5));
    //square(1150, 400+60*i, 20);
    int x = 20;
    String y;
    if (i==8) y = "-" + str(15) + "+";
    else y = str(x-5*i) + "-" + str(x-5*(i-1));
    y += "ºC";
    text(y, 1340, 340 + 60*i);
  }
}

void drawPiePercents(TemperatureData[] data) {
  drawPiePercentTable();
  drawPiePercentTableValues(data);
}

void drawPiePercentTable() {
  fill(200);
  rect(1060, 220, 230, 630);
  fill(0);
  textSize(50);
  line(1085, 290, 1262, 290);
  text("Percent", 1085, 280);
  for (int i = 0; i<9; i++) {
    if (i<6) fill(255-40*i, 0, 0);
    else fill(0, 0, 0+100*(i-5));
    square(1080, 320+60*i, 20);
  }
}

void drawPiePercentTableValues(TemperatureData[] data) {
  textSize(30);
  for (int i = 1; i<10; i++) {
    if (i<6) fill(255-40*i, 0, 0);
    else fill(0, 0, 0+100*(i-5));
    text(piePercentValues(data, i), 1110, 280+60*i);
  }
}
void drawPieGraph(TemperatureData[] data) {
  float starting_position = 0;
  for (int i = 0; i<10; i++) {
    if (i<6) fill(255-40*i, 0, 0);
    else fill(0, 0, 0+100*(i-6)); //set the colour
    float final_position = finalPosition(data, starting_position, i);
    arc(400, 600, 500, 500, starting_position, final_position);
    starting_position = final_position; //make the old final position the new starting position
  }
}

String alpha = "ck y";
String piePercentValues(TemperatureData[] data, int x) {
  int in_range = valuesBetweenRange(data, x);
  int total_values = totalValues(data);
  float percent = (float) (in_range)/total_values * 100;
  return  nf(percent, 0, 2);
}

float finalPosition(TemperatureData[] data, float starting_position, int x) {
  int in_range = valuesBetweenRange(data, x);
  int total_values = totalValues(data);
  float final_position = starting_position + 2*PI *(float) in_range/total_values;
  return final_position;
}

int valuesBetweenRange(TemperatureData[] data, int x) {
  int high_temp_range = 25-5*(x-1);
  int low_temp_range = 25-5*x;
  int in_range = 0;
  for (int i = 0; i<data.length; i++) {
    if (tmaxtemp&&monthFilter(data, i)) 
      if (data[i].maxTemperature <= high_temp_range && data[i].maxTemperature > low_temp_range) in_range++;
    if (tmintemp&&monthFilter(data, i))
      if (data[i].minTemperature <= high_temp_range && data[i].minTemperature > low_temp_range) in_range++;
  }
  return in_range;
}

int totalValues(TemperatureData[] data) {
  int total_values = 0;
  for (int i = 0; i<data.length; i++) {
    if (tmaxtemp&&monthFilter(data, i)) total_values++;
    if (tmintemp&&monthFilter(data, i)) total_values++;
  }
  return total_values;
}

boolean ifs = true;
void blankPie() {
  fill(0);
  textSize(75);
  text("Please Select \nTemperature", 850, 550);

  if (ifs) {
    fill(255, 0, 234);
    circle(400, 600, 500);
    textSize(75);
    fill(250, 0, 230);
    text("Fu" + alpha + "ou", 200, 600);
    ifs = !ifs;
  } else if (!ifs) {
    fill(47, 255, 0);
    textSize(75);
    fill(48, 255, 0);
    text("Fu" + alpha + "ou", 200, 600);
    circle(400, 600, 500);
    ifs = !ifs;
  }
  refresh = !refresh;
  frameRate(20);
}
///////////////////////////////////////////////////
//  
//            Draw Linechart Functions
//

void lineChartMaxTemperature(TemperatureData[] data) {
  float movement = 0;
  for (int i=0; i<data.length; i++) {
    fill(255, 0, 0);
    if (monthFilter(data, i)) {
      circle(105 + movement, 700+data[i].maxTemperature*-15, 7.15);
      if (i!=0&&monthFilter(data, i-1)) {
        stroke(255, 0, 0);
        line(105+(movement-4.15), 700+data[i-1].maxTemperature*-15, 105 + movement, 700+data[i].maxTemperature*-15);
        stroke(0);
      }
    }
    movement += 4.15;
  }
}


void lineChartMinTemperature(TemperatureData[] data) {
  float movement = 0;
  for (int i=0; i<data.length; i++) {
    fill(0, 0, 255);
    if (monthFilter(data, i)) {
      circle(105 + movement, 700+data[i].minTemperature*-15, 7.15);
      if (i!=0&&monthFilter(data, i-1)) {
        stroke(0, 0, 255);
        line(105+(movement-4.15), 700+data[i-1].minTemperature*-15, 105 + movement, 700+data[i].minTemperature*-15);
        stroke(0);
      }
    }
    movement += 4.15;
  }
}

/////////////////////////////////////////////////// 
//
//            Classes
//

class date {
  int month;
  int year;

  date() {
    month = 0;
    year = 0;
  }

  date(int x, int y) {
    month = x;
    year = y;
  }
}

class TemperatureData {
  date date;
  float maxTemperature;
  float minTemperature;
  float snowFall;

  TemperatureData () {
    date = new date();
    maxTemperature = 0;
    minTemperature = 0;
    snowFall = 0;
  }

  TemperatureData(date a, float x, float y, float z) {
    date = a;
    maxTemperature = x;
    minTemperature = y;
    snowFall = z;
  }
}

////////////////////////////////////////////////////////////
//  
//            Data Tables
//

float getMaxTemperature(int x) {
  float [] maxTemperature = {
    -3.77, -0.58, 3.02, 10.59, 16.37, 20.62, 23.36, 22.65, 17.29, 12.71, 2.99, -2.12, 
    -3.59, -0.46, 3.27, 10.59, 16.38, 20.63, 23.21, 22.7, 17.39, 12.61, 2.95, -2.32, 
    -3.79, -0.29, 3.19, 10.74, 16.34, 20.39, 23.2, 22.68, 17.53, 12.56, 2.97, -2.01, 
    -3.56, -0.01, 3.54, 10.72, 16.37, 20.36, 23.09, 22.62, 17.42, 12.43, 2.85, -2.28, 
    -3.58, -0.13, 3.49, 10.72, 16.44, 20.29, 22.93, 22.47, 17.24, 12.33, 2.87, -2.08, 
    -3.68, -0.59, 3.8, 10.8, 16.48, 20.28, 22.92, 22.48, 17.46, 12.17, 2.93, -1.66, 
    -3.52, -0.49, 4.04, 10.81, 16.5, 20.35, 22.85, 22.39, 17.75, 11.99, 2.93, -1.7, 
    -3.44, -0.43, 3.83, 10.95, 16.33, 20.42, 22.9, 22.55, 17.56, 11.95, 2.81, -1.91, 
    -3.44, -0.38, 3.97, 11.09, 16.38, 20.42, 22.86, 22.47, 17.45, 11.87, 2.8, -1.77, 
    -3.52, -0.36, 3.71, 11.23, 16.51, 20.4, 22.9, 22.68, 17.54, 11.95, 2.71, -1.57, 
    -2.92, 0.01, 3.86, 11.15, 16.44, 20.34, 22.86, 22.61, 17.55, 12.09, 2.7, -1.42, 
    -2.77, -0.12, 3.97, 11.27, 16.4, 20.21, 22.85, 22.53, 17.57, 12.11, 2.82, -1.35, 
    -2.37, -0.28, 4.18, 11.26, 16.42, 20.16, 22.88, 22.5, 17.75, 12.08, 2.91, -1.17, 
    -2.04, 0.11, 3.81, 11.14, 16.26, 20.14, 23.08, 22.4, 17.89, 12.01, 3.08, -0.86, 
    -2.01, 0.1, 3.65, 11.17, 16.13, 20.13, 23.12, 22.51, 17.91, 12.1, 3.31, -0.79, 
    -2, 0.15, 3.93, 11.21, 16.18, 20, 23.12, 22.57, 17.86, 11.92, 3.37, -0.86, 
    -2.01, 0.48, 4.16, 11.47, 16.3, 19.94, 23.05, 22.57, 17.72, 11.99, 3.46, -0.81, 
    -1.86, 0.46, 4.08, 11.47, 16.27, 20.02, 23.11, 22.61, 17.68, 11.93, 3.21, -0.74, 
    -1.71, 0.1, 4.17, 11.21, 16.29, 19.93, 23.26, 22.68, 17.78, 11.96, 3.33, -0.54, 
    -1.42, 0.35, 4.26, 11.19, 16.35, 19.87, 23.25, 22.74, 17.83, 11.94, 3.54, -0.61, 
    -1.15, 0.67, 4.1, 11.27, 16.44, 19.83, 23.18, 22.7, 17.9, 11.69, 3.62, -0.9, 
    -0.93, 0.73, 4.38, 11.14, 16.27, 19.83, 23.15, 22.76, 17.79, 11.67, 3.41, -0.85, 
    -1.25, 0.5, 4.02, 10.94, 16.25, 19.83, 23.21, 22.67, 17.86, 11.7, 3.25, -0.63, 
    -0.83, 0.74, 4.23, 11.05, 16.27, 19.8, 23.28, 22.75, 18.01, 11.5, 3.22, -0.85, 
    -0.91, 0.75, 4.23, 10.93, 16.32, 19.79, 23.24, 22.68, 18.15, 11.45, 3.18, -0.6, 
    -0.88, 0.28, 4.01, 10.87, 16.32, 19.74, 23.24, 22.58, 18.29, 11.7, 3.17, -0.33, 
    -0.84, 0.4, 4.16, 10.96, 16.27, 19.79, 23.22, 22.67, 18.44, 11.83, 3.57, -0.43, 
    -1.01, 0.74, 4.19, 11.12, 16.27, 19.82, 23.29, 22.61, 18.63, 11.61, 3.83, -0.8, 
    -1.24, 0.48, 4.16, 10.96, 16.27, 19.76, 23.45, 22.83, 18.56, 11.52, 3.59, -0.95, 
    -1.15, 0.18, 3.93, 10.73, 16.33, 19.72, 23.5, 22.93, 18.38, 11.39, 3.59          };
  return maxTemperature[x];
}

float getMinTemperature(int x) {
  float [] minTemperature = {
    -15.84, -12.24, -8.57, -2.43, 2.98, 7.32, 9.48, 8.5, 3.69, -1.07, -9.02, -14.16, 
    -15.71, -12.26, -8.42, -2.43, 2.98, 7.35, 9.47, 8.56, 3.77, -1.18, -9.02, -14.35, 
    -15.9, -12.09, -8.52, -2.39, 2.94, 7.28, 9.43, 8.59, 3.87, -1.28, -8.99, -14.06, 
    -15.67, -11.89, -8.27, -2.38, 2.96, 7.32, 9.45, 8.56, 3.85, -1.31, -9.05, -14.27, 
    -15.66, -12.06, -8.25, -2.34, 3.05, 7.3, 9.38, 8.5, 3.74, -1.39, -9.01, -14.04, 
    -15.77, -12.5, -7.98, -2.27, 3.05, 7.27, 9.39, 8.57, 3.82, -1.46, -9.03, -13.7, 
    -15.63, -12.41, -7.87, -2.29, 3.08, 7.31, 9.37, 8.46, 3.99, -1.57, -8.98, -13.76, 
    -15.56, -12.36, -8.02, -2.15, 3.02, 7.34, 9.37, 8.5, 3.92, -1.59, -8.98, -13.99, 
    -15.61, -12.25, -7.91, -2.13, 3.05, 7.42, 9.38, 8.48, 3.91, -1.59, -9.01, -13.78, 
    -15.66, -12.17, -8.05, -2, 3.2, 7.46, 9.47, 8.57, 3.95, -1.53, -9, -13.6, 
    -15.14, -11.84, -7.97, -2.07, 3.16, 7.43, 9.46, 8.64, 3.92, -1.42, -9, -13.51, 
    -15.03, -11.96, -7.84, -2.04, 3.15, 7.33, 9.4, 8.65, 3.95, -1.4, -8.9, -13.39, 
    -14.62, -12.2, -7.72, -2.06, 3.16, 7.31, 9.43, 8.57, 4.03, -1.41, -8.86, -13.2, 
    -14.34, -11.92, -8.03, -2.1, 3.07, 7.28, 9.51, 8.49, 4.12, -1.39, -8.76, -12.87, 
    -14.32, -11.9, -8.21, -2.06, 3.03, 7.3, 9.53, 8.55, 4.13, -1.32, -8.56, -12.78, 
    -14.15, -11.87, -7.99, -2.05, 3.04, 7.29, 9.58, 8.62, 4.16, -1.41, -8.44, -12.86, 
    -14.19, -11.58, -7.81, -1.9, 3.09, 7.34, 9.53, 8.6, 4.14, -1.39, -8.31, -12.76, 
    -14.04, -11.65, -7.81, -1.86, 3.08, 7.47, 9.58, 8.54, 4.11, -1.37, -8.48, -12.69, 
    -13.91, -11.98, -7.7, -1.9, 3.08, 7.48, 9.7, 8.57, 4.1, -1.33, -8.38, -12.5, 
    -13.72, -11.81, -7.65, -2.01, 3.15, 7.49, 9.72, 8.63, 4.07, -1.34, -8.12, -12.57, 
    -13.49, -11.5, -7.77, -1.95, 3.2, 7.51, 9.79, 8.68, 4.09, -1.43, -8.03, -12.78, 
    -13.21, -11.42, -7.53, -2.03, 3.12, 7.49, 9.82, 8.79, 4.1, -1.41, -8.23, -12.74, 
    -13.41, -11.62, -7.72, -2.08, 3.11, 7.55, 9.85, 8.79, 4.17, -1.37, -8.33, -12.55, 
    -12.93, -11.44, -7.56, -1.93, 3.17, 7.57, 9.94, 8.87, 4.23, -1.42, -8.2, -12.73, 
    -12.92, -11.41, -7.59, -2, 3.24, 7.57, 9.97, 8.89, 4.38, -1.39, -8.24, -12.46, 
    -12.92, -11.81, -7.71, -2.01, 3.27, 7.57, 10.04, 8.94, 4.52, -1.2, -8.21, -12.13, 
    -12.81, -11.68, -7.63, -2.05, 3.21, 7.7, 10.06, 9.03, 4.62, -1.11, -7.84, -12.22, 
    -12.95, -11.35, -7.62, -1.92, 3.19, 7.72, 10.14, 9.08, 4.7, -1.2, -7.57, -12.45, 
    -13.08, -11.45, -7.67, -1.94, 3.24, 7.71, 10.2, 9.16, 4.68, -1.19, -7.71, -12.58, 
    -13.02, -11.7, -7.85, -2.03, 3.3, 7.67, 10.23, 9.2, 4.63, -1.24, -7.71          };
  return minTemperature[x];
}

float getSnowFall(int x) {
  float [] snowFall = {
    18.28, 15.57, 18.29, 20.56, 9.77, 0.27, 0, 0, 6.43, 11.59, 15.47, 19.29, 
    18.02, 14.86, 18.57, 20.38, 10.19, 0.27, 0, 0, 6.43, 11.49, 15.98, 18.99, 
    18.09, 13.9, 19.18, 19.25, 9.85, 0.27, 0, 0, 6.36, 10.71, 16.25, 18.49, 
    17.69, 13.58, 19.06, 19.14, 9.95, 0.27, 0, 0.03, 6.39, 10.79, 17.38, 18.81, 
    16.63, 13.8, 19.3, 18.71, 9.3, 0.27, 0, 0.03, 6.39, 10.93, 17.13, 18.3, 
    17.15, 14.17, 19.14, 18.53, 9.13, 0.27, 0, 0.03, 6.19, 10.83, 17, 17.38, 
    16.7, 13.69, 18.65, 18.83, 9.23, 0.27, 0, 0.03, 5.36, 10.99, 16.83, 17.75, 
    17.42, 13.56, 20.02, 17.32, 10.13, 0.27, 0, 0.03, 5.65, 11.15, 16.42, 18.28, 
    17.52, 13.29, 20.14, 16.29, 10.57, 0.1, 0, 0.03, 5.7, 11.36, 16.32, 17.77, 
    17.55, 13.56, 21.61, 15.93, 10.37, 0.1, 0, 0.03, 4.98, 10.92, 16.5, 17.43, 
    17.52, 12.86, 21.57, 15.92, 10.55, 0.01, 0, 0.03, 5.03, 10.2, 16.68, 17.43, 
    17.52, 13.32, 21.64, 15.35, 10.35, 0.01, 0, 0.03, 4.76, 9.85, 16.35, 17.53, 
    16.51, 13.39, 21.13, 16.02, 10.31, 0.01, 0, 0.03, 4.61, 9.56, 17.16, 16.6, 
    16.12, 12.75, 21.77, 16.04, 11.19, 0.01, 0, 0.03, 3.49, 9.5, 17.33, 15.53, 
    16.5, 13.09, 21.95, 17.34, 12.13, 0.01, 0, 0.03, 3.87, 9.94, 16.85, 15.07, 
    16.09, 13.09, 21.43, 17.41, 12.47, 0.01, 0, 0.03, 3.78, 10.13, 16.67, 15.52, 
    16.19, 12.76, 20.87, 16.87, 11.78, 0.01, 0, 0.03, 3.85, 9.75, 16.65, 14.02, 
    16.28, 13.28, 20.93, 16.75, 11.81, 0, 0, 0.03, 3.85, 9.95, 16.63, 13.71, 
    15.71, 14.64, 21.7, 17.97, 12.03, 0, 0, 0.03, 3.85, 9.98, 16.68, 13.38, 
    15.1, 14.55, 22.03, 18.95, 12.33, 0, 0, 0.03, 3.85, 9.95, 16.62, 14.54, 
    15.21, 14.93, 23.18, 18.25, 11.69, 0.13, 0, 0.03, 3.85, 10.35, 16.54, 15.07, 
    15.14, 14.47, 22.33, 18.8, 12.46, 0.13, 0, 0.03, 3.86, 10, 16.61, 14.9, 
    15.94, 14.92, 22.8, 20.67, 10.63, 0.13, 0, 0.03, 3.86, 9.49, 16.81, 15.28, 
    15.22, 14.98, 22.17, 21.03, 10.19, 0.13, 0, 0.03, 3.62, 10.21, 17.16, 15.48, 
    15.68, 14.89, 22.17, 20.52, 10.13, 0.13, 0, 0.03, 3.41, 10.32, 17.61, 16.48, 
    16.02, 15.02, 22.67, 20.94, 10.39, 0.13, 0, 0.03, 3.67, 9.73, 18.81, 16.32, 
    16.95, 14.78, 22.73, 20.34, 10.56, 0.13, 0, 0.03, 3.21, 9.45, 18.54, 16.59, 
    17.42, 14.17, 22.57, 19.91, 9.45, 0.13, 0, 0.03, 2.94, 9.74, 18.16, 17.4, 
    17.79, 15.18, 22.26, 19.85, 9.45, 0.13, 0, 0.03, 2.94, 9.77, 18.87, 18.26, 
    17.91, 16.34, 22.85, 20.65, 9.44, 0.13, 0, 0.03, 2.72, 11.19, 19.67          };
  return snowFall[x];
}

//  
//            Buttons
//

ControlP5 bjan, bfeb, bmar, bapr, bmay, bjun, bjul, baug, bsep, boct, bnov, bdec, 
  bmaxtemp, bmintemp, bsnowfall, bbar, bscatter, bpie, binstructions, bdatainfo, bline, byear, breset;

boolean tjan = false, tfeb = false, tmar = false, tapr = false, tmay = false, tjun = false, 
  tjul = false, taug = false, tsep = false, toct = false, tnov = false, tdec = false, 
  tmaxtemp = false, tmintemp = false, tsnowfall = true, tbar = false, tscatter = true, 
  tpie = true, tline = true, refresh = true;

boolean t1990 = true, t1991 = true, t1992 = true, t1993 = true, t1994 = true, t1995 = true, t1996 = true, t1997 = true, 
  t1998 = true, t1999 = true, t2000 = true, t2001 = true, t2002 = true, t2003 = true, t2004 = true, t2005 = true, 
  t2006 = true, t2007 = true, t2008 = true, t2009 = true, t2010 = true, t2011 = true, t2012 = true, t2013 = true, 
  t2014 = true, t2015 = true, t2016 = true, t2017 = true, t2018 = true, t2019 = true; 

void createbuttons() {
  ControlFont cf1 = new ControlFont(createFont("Times", 14));
  ControlFont cf2 = new ControlFont(createFont("Times", 13));

  breset = new ControlP5(this);
  breset.addButton("Reset").setValue(0).setPosition(400, 150).setSize(300, 50).setColorBackground(color(120)).setFont(cf1);


  byear = new ControlP5(this);
  byear.addButton("Year_Search").setValue(0).setPosition(800, 0).setSize(600, 50).setColorBackground(color(120)).setFont(cf1);

  bpie = new ControlP5(this);
  bpie.addButton("Piechart").setValue(0).setPosition(100, 150).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bline = new ControlP5(this);
  bline.addButton("Linechart").setValue(0).setPosition(200, 150).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bscatter = new ControlP5(this);
  bscatter.addButton("scatterPlot").setValue(0).setPosition(200, 100).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf2);

  bbar = new ControlP5(this);
  bbar.addButton("barChart").setValue(0).setPosition(100, 100).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bmaxtemp = new ControlP5(this);
  bmaxtemp.addButton("MaxTemp").setValue(0).setPosition(400, 100).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bmintemp = new ControlP5(this);
  bmintemp.addButton("MinTemp").setValue(0).setPosition(500, 100).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bsnowfall = new ControlP5(this);
  bsnowfall.addButton("Snowfall").setValue(0).setPosition(600, 100).setSize(100, 50).setColorBackground(color(0)).setFont(cf1);

  bjan = new ControlP5(this);
  bjan.addButton("January").setValue(0).setPosition(800, 100).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bfeb = new ControlP5(this);
  bfeb.addButton("February").setValue(0).setPosition(900, 100).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bmar = new ControlP5(this);
  bmar.addButton("March").setValue(0).setPosition(1000, 100).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bapr = new ControlP5(this);
  bapr.addButton("April").setValue(0).setPosition(1100, 100).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bmay = new ControlP5(this);
  bmay.addButton("May").setValue(0).setPosition(1200, 100).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bjun = new ControlP5(this);
  bjun.addButton("June").setValue(0).setPosition(1300, 100).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bjul = new ControlP5(this);
  bjul.addButton("July").setValue(0).setPosition(800, 150).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  baug = new ControlP5(this);
  baug.addButton("August").setValue(0).setPosition(900, 150).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bsep = new ControlP5(this);
  bsep.addButton("September").setValue(0).setPosition(1000, 150).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  boct = new ControlP5(this);
  boct.addButton("October").setValue(0).setPosition(1100, 150).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bnov = new ControlP5(this);
  bnov.addButton("November").setValue(0).setPosition(1200, 150).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  bdec = new ControlP5(this);
  bdec.addButton("December").setValue(0).setPosition(1300, 150).setSize(100, 50).setColorBackground(color(10, 20, 450)).setFont(cf1);

  binstructions = new ControlP5(this);
  binstructions.addButton("Instructions").setValue(0).setPosition(100, 0).setSize(200, 50).setColorBackground(color(120)).setFont(cf1);
  l();

  bdatainfo = new ControlP5(this);
  bdatainfo.addButton("Data_Info").setValue(0).setPosition(400, 0).setSize(300, 50).setColorBackground(color(120)).setFont(cf1);

  firstTime = false;
}

public void scatterPlot() {
  if (tscatter) {
    bscatter.setColorBackground(color(10, 20, 450));
    bbar.setColorBackground(color(10));
    bpie.setColorBackground(color(10));
    bline.setColorBackground(color(10));
    tbar = !tscatter;
    tpie = !tscatter;
    tline = !tscatter;
  } else {
    bscatter.setColorBackground(color(10, 20, 450));
    bbar.setColorBackground(color(10));
    bpie.setColorBackground(color(10));
    bline.setColorBackground(color(10));
    tbar = tscatter;
    tpie = tscatter;
    tline = tscatter;
    tscatter = !tscatter;
  }
  refresh = !refresh;
}

public void Piechart() {
  if (tpie) {
    bpie.setColorBackground(color(10, 20, 450));
    bbar.setColorBackground(color(10));
    bscatter.setColorBackground(color(10));
    bline.setColorBackground(color(10));
    tbar = !tpie;
    tscatter = !tpie;
    tline = !tpie;
  } else {
    bpie.setColorBackground(color(10, 20, 450));
    bbar.setColorBackground(color(10));
    bscatter.setColorBackground(color(10));
    bline.setColorBackground(color(10));
    tbar = tpie;
    tscatter = tpie;
    tline = tpie;
    tpie = !tpie;
  }
  refresh = !refresh;
}

public void barChart() {
  if (tbar) {
    bbar.setColorBackground(color(10, 20, 450));
    bscatter.setColorBackground(color(10));
    bpie.setColorBackground(color(10));
    bline.setColorBackground(color(10));
    tscatter = !tbar;
    tpie = !tbar;
    tline = !tbar;
  } else {
    bbar.setColorBackground(color(10, 20, 450));
    bscatter.setColorBackground(color(10));
    bpie.setColorBackground(color(10));
    bline.setColorBackground(color(10));
    tscatter = tbar;
    tpie = tbar;
    tline = tbar;
    tbar = !tbar;
  }
  refresh = !refresh;
}

public void Linechart() {
  if (tline) {
    bline.setColorBackground(color(10, 20, 450));
    bscatter.setColorBackground(color(10));
    bpie.setColorBackground(color(10));
    bbar.setColorBackground(color(10));
    tscatter = !tline;
    tpie = !tline;
    tbar = !tline;
  } else {
    bline.setColorBackground(color(10, 20, 450));
    bscatter.setColorBackground(color(10));
    bpie.setColorBackground(color(10));
    bbar.setColorBackground(color(10));
    tscatter = tline;
    tpie = tline;
    tbar = tline;
    tline = !tline;
  }
  refresh = !refresh;
}

public void MaxTemp() {
  if (tmaxtemp) {
    bmaxtemp.setColorBackground(color(10));
    tmaxtemp = !tmaxtemp;
  } else {
    bmaxtemp.setColorBackground(color(10, 20, 450));
    tmaxtemp = !tmaxtemp;
  }
  refresh = !refresh;
}

public void MinTemp() {
  if (tmintemp) {
    bmintemp.setColorBackground(color(10));
    tmintemp = !tmintemp;
  } else {
    bmintemp.setColorBackground(color(10, 20, 450));
    tmintemp = !tmintemp;
  }
  refresh = !refresh;
}

public void Snowfall() {
  if (tsnowfall) {
    bsnowfall.setColorBackground(color(10));
    tsnowfall = !tsnowfall;
  } else {
    bsnowfall.setColorBackground(color(10, 20, 450));
    tsnowfall = !tsnowfall;
  }
  refresh = !refresh;
}

public void January() {
  if (tjan) {
    bjan.setColorBackground(color(10));
    tjan = !tjan;
  } else {
    bjan.setColorBackground(color(10, 20, 450));
    tjan = !tjan;
  }
  refresh = !refresh;
}

public void February() {
  if (tfeb) {
    bfeb.setColorBackground(color(10));
    tfeb = !tfeb;
  } else {
    bfeb.setColorBackground(color(10, 20, 450));
    tfeb = !tfeb;
  }
  refresh = !refresh;
}

public void March() {
  if (tmar) {
    bmar.setColorBackground(color(10));
    tmar = !tmar;
  } else {
    bmar.setColorBackground(color(10, 20, 450));
    tmar = !tmar;
  }
  refresh = !refresh;
}

public void April() {
  if (tapr) {
    bapr.setColorBackground(color(10));
    tapr = !tapr;
  } else {
    bapr.setColorBackground(color(10, 20, 450));
    tapr = !tapr;
  }
  refresh = !refresh;
}

public void May() {
  if (tmay) {
    bmay.setColorBackground(color(10));
    tmay = !tmay;
  } else {
    bmay.setColorBackground(color(10, 20, 450));
    tmay = !tmay;
  }
  refresh = !refresh;
}

public void June() {
  if (tjun) {
    bjun.setColorBackground(color(10));
    tjun = !tjun;
  } else {
    bjun.setColorBackground(color(10, 20, 450));
    tjun = !tjun;
  }
  refresh = !refresh;
}

public void July() {
  if (tjul) {
    bjul.setColorBackground(color(10));
    tjul = !tjul;
  } else {
    bjul.setColorBackground(color(10, 20, 450));
    tjul = !tjul;
  }
  refresh = !refresh;
}

public void August() {
  if (taug) {
    baug.setColorBackground(color(10));
    taug = !taug;
  } else {
    baug.setColorBackground(color(10, 20, 450));
    taug = !taug;
  }
  refresh = !refresh;
}

public void September() {
  if (tsep) {
    bsep.setColorBackground(color(10));
    tsep = !tsep;
  } else {
    bsep.setColorBackground(color(10, 20, 450));
    tsep = !tsep;
  }
  refresh = !refresh;
}

public void October() {
  if (toct) {
    boct.setColorBackground(color(10));
    toct = !toct;
  } else {
    boct.setColorBackground(color(10, 20, 450));
    toct = !toct;
  }
  refresh = !refresh;
}

public void November() {
  if (tnov) {
    bnov.setColorBackground(color(10));
    tnov = !tnov;
  } else {
    bnov.setColorBackground(color(10, 20, 450));
    tnov = !tnov;
  }
  refresh = !refresh;
}

public void December() {
  if (tdec) {
    bdec.setColorBackground(color(10));
    tdec = !tdec;
  } else {
    bdec.setColorBackground(color(10, 20, 450));
    tdec = !tdec;
  }
  refresh = !refresh;
}

void Instructions() {
  l();
  JOptionPane.showMessageDialog(frame, "The graphs are toggle buttons. \n\nClick on any button to deselect it.", "Instructions", JOptionPane.OK_OPTION);
}


boolean data_info = true;
void Data_Info() {
  data_info = !data_info;
}

String getDataMessage(TemperatureData[] data) {
  String x = "";
  if (tmaxtemp) x+= "The average maximum temperature for selected region is " + temp_avg(data, true, false) + "ºC\n";
  if (tmintemp) x+= "The average minimum temperature for selected region is " + temp_avg(data, false, true) + "ºC\n";
  x+= "The highest temperature for selected region is " + temp_high(data) + "ºC in " + temp_high_month(data) + ", " + temp_high_year(data) + "\n";
  x+= "The lowest temperature for selected region is " + temp_low(data) + "ºC in " + temp_low_month(data) + ", " + temp_low_year(data) + "\n";
  if (tmintemp&&tmaxtemp) x+= "The total average temperature for selected region is " + temp_avg(data, true, true) + "ºC";
  return x;
}
void l() {
  for (int i=0; i<100; i++)println(" ");
}

String temp_avg(TemperatureData[] data, boolean max, boolean min) {
  float result = 0;
  float counter = 0;
  for (int i=0; i<data.length; i++) {
    if (monthFilter(data, i)) {
      if (max&&min) {
        result += data[i].maxTemperature + data[i].minTemperature;
        counter++;
      } else if (max) result += data[i].maxTemperature;
      else if (min) result += data[i].minTemperature;
      counter++;
    }
  }
  float x = result/counter;
  return nfc(x, 2);
}

float temp_high(TemperatureData[] data) {
  float x = -100;
  for (int i=0; i<data.length; i++) {
    if (monthFilter(data, i)) {
      if (tmaxtemp) if (data[i].maxTemperature>x) x = data[i].maxTemperature;
      if (tmintemp) if (data[i].minTemperature>x) x = data[i].minTemperature;
    }
  }
  if (x==-100) x = 0;
  return x;
}

String temp_high_month(TemperatureData[] data) {
  float x = -100;
  int month = 0;
  for (int i=0; i<data.length; i++) {
    if (monthFilter(data, i)) {
      if (tmaxtemp) if (data[i].maxTemperature>x) {
        x = data[i].maxTemperature;
        month = data[i].date.month;
      }
      if (tmintemp) if (data[i].minTemperature>x) {
        x = data[i].minTemperature;
        month = data[i].date.month;
      }
    }
  }
  String answer = getMonth(month);
  return answer;
}

int temp_high_year(TemperatureData[] data) {
  float x = -100;
  int year = 0;
  for (int i=0; i<data.length; i++) {
    if (monthFilter(data, i)) {
      if (tmaxtemp) if (data[i].maxTemperature>x) {
        x = data[i].maxTemperature;
        year = data[i].date.year;
      }
      if (tmintemp) if (data[i].minTemperature>x) {
        x = data[i].minTemperature;
        year = data[i].date.year;
      }
    }
  }
  return year;
}

float temp_low(TemperatureData[] data) {
  float x = 100;
  for (int i=0; i<data.length; i++) {
    if (monthFilter(data, i)) {
      if (tmaxtemp) if (data[i].maxTemperature<x) x = data[i].maxTemperature;
      if (tmintemp) if (data[i].minTemperature<x) x = data[i].minTemperature;
    }
  }
  if (x==100) x=0;
  return x;
}

String temp_low_month(TemperatureData[] data) {
  float x = 100;
  int month = 0;
  for (int i=0; i<data.length; i++) {
    if (monthFilter(data, i)) {
      if (tmaxtemp) if (data[i].maxTemperature<x) {
        x = data[i].maxTemperature;
        month = data[i].date.month;
      }
      if (tmintemp) if (data[i].minTemperature<x) {
        x = data[i].minTemperature;
        month = data[i].date.month;
      }
    }
  }
  String answer = getMonth(month);
  return answer;
}

int temp_low_year(TemperatureData[] data) {
  float x = 100;
  int year = 0;
  for (int i=0; i<data.length; i++) {
    if (monthFilter(data, i)) {
      if (tmaxtemp) if (data[i].maxTemperature<x) {
        x = data[i].maxTemperature;
        year = data[i].date.year;
      }
      if (tmintemp) if (data[i].minTemperature<x) {
        x = data[i].minTemperature;
        year = data[i].date.year;
      }
    }
  }
  return year;
}

String getMonth(int x) {
  if (x==1) return "January";
  else if (x==2) return "February";
  else if (x==3) return "March";
  else if (x==4) return "April";
  else if (x==5) return "May";
  else if (x==6) return "June";
  else if (x==7) return "July";
  else if (x==8) return "August";
  else if (x==9) return "September";
  else if (x==10) return "October";
  else if (x==11) return "November";
  else if (x==12) return "December";
  else return "Invalid";
}

public void Year_Search () {
  if (!firstTime) YearSearch();
}

void YearSearch() {
  String input = JOptionPane.showInputDialog("Year Filter. Type 'Help' for assistance.");
  input = input.toLowerCase();
  if (input.equals("help")) HelpFunction();
  else if (input.equals(gameInitiateCode)) gametime = true;
  else {
    int [] years = getYears(input); 
    if (years.length==0) JOptionPane.showMessageDialog(frame, "Invalid", "Error", JOptionPane.OK_OPTION);
    else filterYears(years);
    refresh = !refresh;
  }
}

void HelpFunction() {
  JOptionPane.showMessageDialog(frame, "Type any year to select it. \n\nType '-' to choose a range, and commas to separate values.", "Search Help", JOptionPane.OK_OPTION);
  YearSearch();
}

int [] getYears (String input1) {
  int [] output = new int [0];
  String var = "";
  String input = "";

  for (int i = 0; i<input1.length(); i++) {
    char x = input1.charAt(i);
    if (x == '-' || (x>=48 && x<=57))
      input += x;
  }
  for (int i = 0; i<input.length(); i++) {
    char x = input.charAt(i);
    if (x == '-') {
      int [] temp = valuesInRange(input, i);
      output = concat(output, temp);
      i+=4;
      var = "";
    } else var += input.charAt(i);
    if (var.length() == 4) {
      output = append(output, Integer.parseInt(var));
      var = "";
    }
  }


  int [] output2 = new int [0];
  for (int i = 0; i<output.length; i++) {
    if (output[i] >= 1990 && output[i] <=2019) output2 = append(output2, output[i]);
  }
  return output2;
}

int [] valuesInRange(String input, int x) {
  String lower_boundary = "";
  for (int i = 0; i<4; i++) {
    lower_boundary += input.charAt(x-4+i);
  }
  int lowerboundary = Integer.parseInt(lower_boundary);
  String upper_boundary = "";
  for (int i = 1; i<5; i++) {
    upper_boundary += input.charAt(x+i);
  }
  int upperboundary = Integer.parseInt(upper_boundary);

  if (lowerboundary > upperboundary) {
    int temp = lowerboundary;
    lowerboundary = upperboundary;
    upperboundary = temp;
  }
  int [] output = new int [0];

  for (int i = lowerboundary; lowerboundary<=upperboundary; lowerboundary++) {
    output = append(output, lowerboundary);
  }
  return output;
}

void filterYears(int [] array) {
  doReset();
  for (int i = 0; i<array.length; i++) {
    int x = array[i];
    if (x == 1990) t1990 = false;
    if (x == 1991) t1991 = false;
    if (x == 1992) t1992 = false;
    if (x == 1993) t1993 = false;
    if (x == 1994) t1994 = false;
    if (x == 1995) t1995 = false;
    if (x == 1996) t1996 = false;
    if (x == 1997) t1997 = false;
    if (x == 1998) t1998 = false;
    if (x == 1999) t1999 = false;
    if (x == 2000) t2000 = false;
    if (x == 2001) t2001 = false;
    if (x == 2002) t2002 = false;
    if (x == 2003) t2003 = false;
    if (x == 2004) t2004 = false;
    if (x == 2005) t2005 = false;
    if (x == 2006) t2006 = false;
    if (x == 2007) t2007 = false;
    if (x == 2008) t2008 = false;
    if (x == 2009) t2009 = false;
    if (x == 2010) t2010 = false;
    if (x == 2011) t2011 = false;
    if (x == 2012) t2012 = false;
    if (x == 2013) t2013 = false;
    if (x == 2014) t2014 = false;
    if (x == 2015) t2015 = false;
    if (x == 2016) t2016 = false;
    if (x == 2017) t2017 = false;
    if (x == 2018) t2018 = false;
    if (x == 2019) t2019 = false;
  }
  t1990 = !t1990;
  t1991 = !t1991;
  t1992 = !t1992;
  t1993 = !t1993;
  t1994 = !t1994;
  t1995 = !t1995;
  t1996 = !t1996;
  t1997 = !t1997;
  t1998 = !t1998;
  t1999 = !t1999;
  t2000 = !t2000;
  t2001 = !t2001;
  t2002 = !t2002;
  t2003 = !t2003;
  t2004 = !t2004;
  t2005 = !t2005;
  t2006 = !t2006;
  t2007 = !t2007;
  t2008 = !t2008;
  t2009 = !t2009;
  t2010 = !t2010;
  t2011 = !t2011;
  t2012 = !t2012;
  t2013 = !t2013;
  t2014 = !t2014;
  t2015 = !t2015;
  t2016 = !t2016;
  t2017 = !t2017;
  t2018 = !t2018;
  t2019 = !t2019;
}

public void Reset() {
  if (!firstTime) {
    doReset();
    doReset2();
  }
}

void doReset() {
  t1990 = true; 
  t1991 = true; 
  t1992 = true; 
  t1993 = true; 
  t1994 = true; 
  t1995 = true; 
  t1996 = true; 
  t1997 = true; 
  t1998 = true; 
  t1999 = true; 
  t2000 = true; 
  t2001 = true; 
  t2002 = true; 
  t2003 = true; 
  t2004 = true; 
  t2005 = true; 
  t2006 = true; 
  t2007 = true; 
  t2008 = true; 
  t2009 = true; 
  t2010 = true; 
  t2011 = true; 
  t2012 = true; 
  t2013 = true; 
  t2014 = true; 
  t2015 = true; 
  t2016 = true; 
  t2017 = true; 
  t2018 = true; 
  t2019 = true;
}

void doReset2() {
  tjan = true;
  tfeb = true;
  tmar = true;
  tapr = true;
  tmay = true;
  tjun = true;
  tjul = true;
  taug = true;
  tsep = true;
  toct = true;
  tnov = true;
  tdec = true;
  tmaxtemp = true;
  tmintemp = true;
  tsnowfall = false;
  bjan.setColorBackground(color(10, 20, 450));
  bfeb.setColorBackground(color(10, 20, 450));
  bmar.setColorBackground(color(10, 20, 450));
  bapr.setColorBackground(color(10, 20, 450));
  bmay.setColorBackground(color(10, 20, 450));
  bjun.setColorBackground(color(10, 20, 450));
  bjul.setColorBackground(color(10, 20, 450));
  baug.setColorBackground(color(10, 20, 450));
  bsep.setColorBackground(color(10, 20, 450));
  boct.setColorBackground(color(10, 20, 450));
  bnov.setColorBackground(color(10, 20, 450));
  bdec.setColorBackground(color(10, 20, 450));
  bmaxtemp.setColorBackground(color(10, 20, 450));
  bmintemp.setColorBackground(color(10, 20, 450));
  bsnowfall.setColorBackground(color(10));
  refresh = !refresh;
}
