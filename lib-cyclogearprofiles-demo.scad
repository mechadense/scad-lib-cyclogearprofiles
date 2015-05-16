include <lib-cyclogearprofiles.scad>

// activate animation with 30fps & ~100steps
// comment out unnecessary previews to speed up animation


translate([-300,0,0]) demo_cycloherringbone();
translate([0,-200,0]) demo_risechain();
translate([0,300,0]) demo_simpleMeshOfTwoGears();
translate([0,0,0]) demo_inroll();
translate([500,400,0]) demo_rack();

// combining demo_inroll & cyclorerringbone
// progressing cavity pumps (PCP pumps) can be made

// ##################################################


module demo_rack(r=5,n2=6)
{
  color("red")
  // animate rack translation of one gear rolling circle circumference
  translate([0,-$t*2*3.141592653*rollingradius(r,n2),0])
  cyclorackprofile(trackmin=40,rtooth=r,nteeth=6.75,teethshift0=0.75,
                   vpt=24);

 translate([-rollingradius(r,n2),0,0])
 //rotate(alpha2(n1,n2,alpha1,beta12),[0,0,1])
  rotate(-360/(n2*4)-$t*360,[0,0,1]) // animate one rotation
    cyclogearprofile(r,n2,24,0);//2
}

module demo_cycloherringbone(rtooth=5,nteeth=13,slant=45)
{
  color("pink") rotate(+360*$t,[0,0,1])
  { upside(); scale([1,1,-1]) upside(); }
  module upside()
  { 
    twistextrudegear(rtooth,nteeth,slant=45,nteethtwist=1)
      cyclogearprofile(rtooth,nteeth,24);
  }
}

module demo_simpleMeshOfTwoGears(r=5,n1=15,n2=7)
{
  // just a random animation showcasing alignment to work
  alpha1 = 360*$t; beta12 = 180*$t; // 30;

  centerdistance = rollingradius(r,n1)+rollingradius(r,n2); // 2*r*(n1+n2);
  dx = centerdistance*cos(beta12);
  dy = centerdistance*sin(beta12);

  color("orange")
  rotate(alpha1,[0,0,1])
    cyclogearprofile(r,n1,24,0);//1
  translate([dx,dy,0])
  rotate(alpha2(n1,n2,alpha1,beta12),[0,0,1])
    cyclogearprofile(r,n2,24,0);//2
}

// one gear rolling inside another just one tooth bigger
// this forms closed pockets
// twist extruded this would make a PCP pump - beyond the scope of this library
module demo_inroll(r=5,n1=6,t=15)
{
  clr = 0.3; // not used here
  n2 = n1-1; // special case

  beta12 = 180*$t*0; // 180*$t;
  alpha1 = 360*$t;

  centerdistance2 = rollingradius(r,n1)-rollingradius(r,n2); // r*(+2*n1b-2*n2b);
  dx2 = centerdistance2*cos(beta12);
  dy2 = centerdistance2*sin(beta12);

  color("grey")
  rotate(alpha1,[0,0,1])
    difference()
    {
      offset(delta = t)
        cyclogearprofile(r,n1,24);
      //offset(delta = +clr/2)
        cyclogearprofile(r,n1,24);
    }
  color("magenta")
  translate([dx2,dy2,0])
  rotate(+1*alpha2inroll(n1,n2,alpha1,beta12),[0,0,1])
    difference()
    {
      //offset(delta = -clr/2)
        cyclogearprofile(r,n2,24);
      offset(delta = -t)
        cyclogearprofile(r,n2,24);
    }
}

// a little more elaborate
// uses recursion to mesh a chain of gears wit incrementing tooth number
module demo_risechain(s=8,ngears=8)
{

  function recurseangle(n) = (n<=1) ? 0 : alpha2(n-1,n,recurseangle(n-1),0);
  function diamsum(i) = (i<=1) ? s : 4*s*(i-1/2)+diamsum(i-1); // why?

  // rotations of meshing gears go in alternating directions
  function paritysign(i) = sign(i%2-1/2);
  $fa=2;$fs=0.2;
  speedup = 10; //1;

  for(i=[1:ngears])
  {
    echo("gear No:",i," angle:",recurseangle(i)," total shift:",diamsum(i));
    color([0.4,0.6,i/ngears])
    translate([diamsum(i),0,0])
    rotate(recurseangle(i),[0,0,1])
    rotate(speedup*360*$t/i*paritysign(i),[0,0,1])
    cyclogearprofile(s,i);
  }
}