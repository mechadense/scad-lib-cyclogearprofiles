# scad-lib-cyclogearprofiles

A minimal OpenSCAD library to generate 2D profiles of cycloidical gears.  
Some demo functions are included in the file "lib-cyclogearprofiles-demo.scad".  

# Details:

usage:
put this library in one of the standard locations:
http://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries
e.g. Linux: $HOME/.local/share/OpenSCAD/libraries

**include \<lib-cyclogearprofiles.scad\>** or  
**include \<scad-lib-cyclogearprofiles/lib-cyclogearprofiles.scad\>** depending on location  
(there is no geometry generating top level code in this library file) 

To get a crosssection of the desired gear invoke:  
**cyclogearprofile(rtooth,nteeth,vpt,verbouse);**  
parameters:  
rtooth ... radius of gear teeth  
nteeth ... number of gear teeth  
vtp ... optional parameter -- vertices per tooth -- if left 0 (this is default) OpenSCADs resolution parameters $fa $fs or $fn will be applied.  
verbouse ... optional parameter -- If this is set bigger than zero then info about that gear will be reported under the choosen number.  

To get a cross section of a rack invoke:  
**cyclorackprofile(trackmin,rtooth,nteeth,teethshift0,vpt=0)**  
trackmin ... thickness of rack at the thinnest points  
rtooth ... "radius" of gear teeth  
nteeth ... numbers of teeth of rack (smallest allowed unit is a quater of a full tooth cycle)  
teethshift0 ... at which quater to begin with the first tooth sensible are valued from the list: {-0.75,-0.5,0,+0.5,+0.75} all others have same effect  
vpt ...same as for cyclogearprofile  


## Alignment helper functions:  

There are two helper functions to align gears. One for normal meshing an one for the case that one gear has the teeth inside (a concave gear) such that both gears turn in the same direction.  
**alpha2(n1,n2,alpha1,beta12) // for normal meshing**  
**alpha2inroll(n1,n2,alpha1,beta12) // for gears rolling inside concave gears**  
parameters:  
_1 ... gear in origin; _2 ... meshed gear  
beta12 ... angle at which gear2's origin is located relative the origin of gear1  
nX ... number of teeth of gear X  
alphaX ... rotation angle of gear X around its own origin  

## Extrusion helper functions:

If you want to make herringbone gears use this helper function.  
**twistextrudegear(rtooth,nteeth,slant,nteethtwist) your_modified_cyclogearprofile(...);**  
The generated extrusion height (for nteethtwist=1) can be obtained with this helper function:  
**extrudeheight1tooth(r,n,slantangle)**  
To twist over the angle of multiple teeth use nteethtwist bigger than one and multiply nteethtwist to the return value of extrudeheight1tooth.  


## Further notes:  
* The rolling radius of a cycloidical gear is two times the tooth number times the tooth radius. A helper function can be used to make code more self explanatory:  
**rollingradius(rtooth,nteeth)**  
* for cycloidical gears to mesh they need equal tooth radius  
* I'd recommend to make herringbone gears instead of straight ones since staight cycloidical gears have varying axial force due to an oscillating attack angle which can lead to bad vibrations under load.
