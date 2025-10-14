* SA_STSA.inc — single-threshold dynamic latch SA (sample-and-hold)
* Pins: in vref ren vdd vss out
.SUBCKT SA_STSA in vref ren vdd vss out
* defaults (can be overridden from the instance)
.PARAM GAIN=1e6 VOFF=0 GDRV=5e-3 CINT=2f COUT=1f

* Integration is gated by ren: when ren=0, nint stops moving
Gint  vss nint  VALUE=' v(ren)*GDRV*( v(in)-v(vref)-VOFF ) '

Cint  nint vss CINT
Rleak nint vss 1e9

* Latching buffer maps stored nint → rails and “holds” after ren low
Ebuf  out  vss VALUE=' v(vdd,vss)*( 0.5 + 0.5*tanh( GAIN*v(nint,vss) ) ) '
Cout  out  vss COUT
Rout  out  vss 1e9

.ENDS SA_STSA
