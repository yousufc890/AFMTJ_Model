* ref_ladder.inc — generates mid and k-1 extra taps
* Pins: vref mid vtap1 vtap2 vtap3 vss
.SUBCKT REF_LADDER vref mid vtap1 vtap2 vtap3 vss
.PARAM DmV=0
E0 mid   0 VALUE='v(vref)'
E1 vtap1 0 VALUE='v(vref) + DmV'
E2 vtap2 0 VALUE='v(vref)'
E3 vtap3 0 VALUE='v(vref) - DmV'
.ENDS REF_LADDER
