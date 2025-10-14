* PD_read.inc — Precharge front-end
* Pins: bit vbias ren pc vss
.SUBCKT PD_READ bit vbias ren pc vss
.PARAM Ron=0.5 Roff=1e9 Vt=0.5 K=40 CBIT=0 CDEC=0 RCLAMP=0 GTAIL=0

* Smooth ON factor for pc (0..1)
Eon on 0 VALUE=' 1/(1 + exp( -K*( v(pc,vss) - Vt ) )) '

* Precharge conductance: ON→1/Ron, OFF→1/Roff
Gpre bit vbias VALUE=' ( v(on)*(1/Ron) + (1 - v(on))*(1/Roff) ) * v(bit,vbias) '

* Bitline/storage
Cbit  bit vss CBIT
Cdec  bit vss CDEC
Rcl   bit vss ' (RCLAMP>0) ? RCLAMP : 1e15 '

* Optional tail gm, active when ren≈1
Gtail bit vss VALUE=' GTAIL * v(ren,vss) * v(bit,vss) '

.ENDS PD_READ
