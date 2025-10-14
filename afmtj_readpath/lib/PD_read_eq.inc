* PD_read_eq.inc — Precharge + short equalize (BL↔VBIAS) before sense
* Pins: bit vbias ren pc peq vss
.SUBCKT PD_READ_EQ bit vbias ren pc peq vss
.PARAM Ron=0.5 Roff=1e9 Vt=0.5 K=40 CBIT=0 CDEC=0 RCLAMP=0 GTAIL=0
.PARAM GEQ=0.01   * equalize conductance (S), e.g., 10 mS
.PARAM VTH_EQ=0.5 * peq threshold (V)

* Core precharge front-end
XCORE bit vbias ren pc vss PD_READ Ron=Ron Roff=Roff Vt=Vt K=K CBIT=CBIT CDEC=CDEC RCLAMP=RCLAMP GTAIL=GTAIL

* Equalize path only during peq window
Geq bit vbias VALUE=' ( v(peq,vss)>VTH_EQ ? GEQ : 0 ) * v(bit,vbias) '

.ENDS PD_READ_EQ
