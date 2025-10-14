* SA_MT4.inc — multi-threshold (K=4) gated-integrator + soft encode
* Pins: in vtap1 vtap2 vtap3 vtap4 ren vdd vss out
.SUBCKT SA_MT4 in vtap1 vtap2 vtap3 vtap4 ren vdd vss out
.PARAM GAIN=1e6 VOFF=0 GDRV=2e-6 CINT=10f COUT=1f RLEAK=5e6 VCL=0.4

* --- Comparator bank (0..VDD on each) ---
E1 n1 0 VALUE=' V(vdd)*(0.5+0.5*tanh(GAIN*(v(in)-v(vtap1)-VOFF))) '
E2 n2 0 VALUE=' V(vdd)*(0.5+0.5*tanh(GAIN*(v(in)-v(vtap2)-VOFF))) '
E3 n3 0 VALUE=' V(vdd)*(0.5+0.5*tanh(GAIN*(v(in)-v(vtap3)-VOFF))) '
E4 n4 0 VALUE=' V(vdd)*(0.5+0.5*tanh(GAIN*(v(in)-v(vtap4)-VOFF))) '

* --- Normalized vote ∈ [-0.5..+0.5] ---
.PARAM K=4
Eerr err 0 VALUE=' ( (v(n3)+v(n4)) - (v(n1)+v(n2)) ) / ( 4*V(vdd) ) '

* --- Gated integrator + tiny damping ---
Gint nint vss VALUE=' v(ren)*GDRV*tanh( v(err)/0.25 ) '
Cint nint vss 'CINT'
Rleak nint vss 'RLEAK'
Gcl  nint vss VALUE=' (v(nint)/max(VCL,1e-3))*1e-6 '

* --- Rail map / hold ---
Ebuf out vss VALUE=' v(vdd,vss)*(0.5+0.5*tanh(GAIN*v(nint,vss))) '
Cout out vss 'COUT'
Rout out vss 1e9
.ENDS SA_MT4
