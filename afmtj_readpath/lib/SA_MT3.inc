* SA_MT3.inc — multi-threshold (K=3) gated-integrator + soft encode (stable)
* Pins: in vtap1 vtap2 vtap3 ren vdd vss out
.SUBCKT SA_MT3 in vtap1 vtap2 vtap3 ren vdd vss out
.PARAM GAIN=1e6 VOFF=0 GDRV=1e-6 CINT=10f COUT=1f RLEAK=1e6  VCL=0.4

* --- Comparator bank (0..VDD on each) ---
E1 n1 0 VALUE=' V(vdd)*(0.5+0.5*tanh(GAIN*(v(in)-v(vtap1)-VOFF))) '
E2 n2 0 VALUE=' V(vdd)*(0.5+0.5*tanh(GAIN*(v(in)-v(vtap2)-VOFF))) '
E3 n3 0 VALUE=' V(vdd)*(0.5+0.5*tanh(GAIN*(v(in)-v(vtap3)-VOFF))) '

* --- Normalized vote error in [-0.5..+0.5], center at 0 ---
.param K=3
Eerr err 0 VALUE=' ( (v(n1)+v(n2)+v(n3)) / (K*V(vdd)) ) - 0.5 '

* --- Gated integrator, with soft limit ---
.param GDRV=1e-8  CINT=50f  VCL=0.4
Gint vss nint VALUE=' v(ren)*GDRV*tanh( v(err)/0.25 ) '
Cint  nint vss 'CINT'
Rleak nint vss 5e6
Gcl   nint vss VALUE=' (v(nint)/max(VCL,1e-3))*1e-6 '   * tiny damping

* --- Rail mapping/hold (same style as STSA) ---
.param GAIN=1e6  COUT=1f
Ebuf  out  vss VALUE=' v(vdd,vss)*(0.5+0.5*tanh(GAIN*v(nint,vss))) '
Cout  out  vss 'COUT'
Rout  out  vss 1e9

.ENDS SA_MT3
