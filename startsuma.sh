imgdir=INFLATE/103/
[ -n "$1" ] && imgdir=$1
export specFile=/home/foranw/standard/suma_mni/N27_both.spec
export t1image=mni_icbm152_t1_tal_nlin_asym_09c_brain.nii
suma -niml -spec $specFile -sv $t1image &
afni -niml -yesplugouts -com "SET_UNDERLAY $t1image" -dset $t1image $imgdir/*HEAD &
sleep 30

DriveSuma -com  viewer_cont \
     -key ctrl+left\
     -key F3 \
     -key F6 \
     -key:r:7 period \
     -key:r:3 z   \
     -key:r:3 t
