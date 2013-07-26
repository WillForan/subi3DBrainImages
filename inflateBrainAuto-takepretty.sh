#!/usr/bin/env bash 
#
function DriveAFNI {
   plugout_drive -quit -com "$@" >/dev/null 2>&1
   sleep 1;
}
diffBetweenSurfaces=8

echo "* did you open suma and afni??"
echo "    t1image=mni_icbm152_t1_tal_nlin_asym_09c_brain.nii"
echo "    specFile=$HOME/standard/suma_mni/N27_both.spec"
echo "    suma -niml -spec \$specFile -sv \$t1image"
echo "    afni -niml -yesplugouts -com \"SET_UNDERLAY \$t1image\"'"
echo "* did you clusterize?"
echo "* are they talking?"
echo "* is the right inflated brain displayed?"
echo "* is the recorder started? " 
read

# want 12 colors
DriveAFNI "SET_PBAR_NUMBER 12"

# right inflated brain right afer startup
#DriveSuma -com  viewer_cont -key:r:10 period


#### for each BRIK/HEAD
#for image in INFLATE/*HEAD; do
for image in takeaprettypictureforme/*HEAD; do
 
 # get the name afni cares about
 # and set it as the overlay
 image=$(basename $image .HEAD)
 DriveAFNI "SET_OVERLAY $image"
 
 pwd
 echo $image
 echo "did i load the right guy?"
 #read 
 # set underlay, overlay, and threshold subbricks
 # -1 means don't change/ingore
 # depends on file we are looking at
 #if [[ $image =~ ^TD_|^ASD_ ]]; then
 #   DriveAFNI "SET_SUBBRICKS -1 4 5"
 #   echo "set value/thres to 4,5"
 #else # T_ or A_
 #   DriveAFNI "SET_SUBBRICKS -1 0 1"
 #fi
 DriveAFNI "SET_FUNC_RANGE A.0.5"

 pval=1
 # go through two pvals
 #for pval in 02 1; do
 #for pval in 05; do
      #echo $pval

      #DriveAFNI "SET_THRESHNEW .$pval *p"
      for direction in left right; do

         echo $direction

         # switch to other hemisphere inflated brain
         [ $direction == "left" ] && DriveSuma -com  viewer_cont -key:r:$diffBetweenSurfaces comma 

         DriveSuma -com  viewer_cont \
                   -key ctrl+${direction} \
                   #-key:r:1 $direction 
                   #-key:r:2 down \

         DriveSuma -com recorder_cont \
                   -save_as "${image%+tlrc}_${direction}_${pval}_dorsal.jpg" 

         DriveSuma -com  viewer_cont \
                   -key ctrl+${direction} \
                   #-key:r:2 down 

         #DriveSuma -com recorder_cont \
         #          -save_as "${image%+tlrc}_${direction}_${pval}_dorsal_2.jpg" 

         ### now medial view, opposite direction
         altdir="left"
         updir="up"
         [ $direction == "left" ] && altdir="right" && updir="up"

         DriveSuma -com  viewer_cont \
                   -key ctrl+${altdir} \
                   #-key:r:2 $updir \
                   #-key:r:1 $altdir

         #DriveSuma -com recorder_cont \
         #          -save_as "${image%+tlrc}_${altdir}_${pval}_dorsal_medial.jpg" 

         sleep 1;
         DriveSuma -com  viewer_cont \
                   -key ctrl+${altdir} \
                   #-key:r:1 $updir

         DriveSuma -com recorder_cont \
                   -save_as "${image%+tlrc}_${altdir}_${pval}_dorsal_medial.jpg" 


         [ $direction == "left" ] && DriveSuma -com  viewer_cont -key:r:$diffBetweenSurfaces period
      done
 #done

done



