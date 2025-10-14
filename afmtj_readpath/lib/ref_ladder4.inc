* ref_ladder4.inc — four threshold taps around vref
* Pins: vref vtap1 vtap2 vtap3 vtap4 vss
.SUBCKT REF_LADDER4 vref vtap1 vtap2 vtap3 vtap4 vss
.PARAM DEL=20m RATIO=0.5
E1 vtap1 0 VALUE='v(vref) - DEL'
E2 vtap2 0 VALUE='v(vref) - RATIO*DEL'
E3 vtap3 0 VALUE='v(vref) + RATIO*DEL'
E4 vtap4 0 VALUE='v(vref) + DEL'
.ENDS REF_LADDER4
