* SA_WTA8.inc — 8-way winner-take-all (softmax-ish via average score)
* Pins: in1 in2 in3 in4 in5 in6 in7 in8  vref ren  vdd vss  out
.SUBCKT SA_WTA8 in1 in2 in3 in4 in5 in6 in7 in8  vref ren  vdd vss  out
* Defaults — override at instantiation if desired
.PARAM GAIN=8e5  GDRV=1e-6  CINT=20f  COUT=1f

* --- Per-input “score” vs reference (bounded ±1) ---
E1 n1 0 VALUE='tanh(GAIN*(v(in1)-v(vref)))'
E2 n2 0 VALUE='tanh(GAIN*(v(in2)-v(vref)))'
E3 n3 0 VALUE='tanh(GAIN*(v(in3)-v(vref)))'
E4 n4 0 VALUE='tanh(GAIN*(v(in4)-v(vref)))'
E5 n5 0 VALUE='tanh(GAIN*(v(in5)-v(vref)))'
E6 n6 0 VALUE='tanh(GAIN*(v(in6)-v(vref)))'
E7 n7 0 VALUE='tanh(GAIN*(v(in7)-v(vref)))'
E8 n8 0 VALUE='tanh(GAIN*(v(in8)-v(vref)))'

* --- Soft “max”: average score (≈ positive if a clear winner exists) ---
Eavg navg 0 VALUE='(v(n1)+v(n2)+v(n3)+v(n4)+v(n5)+v(n6)+v(n7)+v(n8))/8'

* --- Gated integrator (aperture controlled by ren) ---
Gint  nint vss VALUE=' v(ren)*GDRV * v(navg) '
Cint  nint vss 'CINT'
Rleak nint vss 1e9

* --- Rail mapper + hold (same style as STSA) ---
Ebuf  out  vss VALUE=' v(vdd,vss)*(0.5 + 0.5*tanh( 1e6 * v(nint,vss) )) '
Cout  out  vss 'COUT'
Rout  out  vss 1e9

.ENDS SA_WTA8
