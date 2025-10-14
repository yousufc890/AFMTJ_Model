* PD_read_pe.inc — Precharge with short pre-emphasis on pc for faster slew
* Pins: bit vbias ren pc peq vss
.SUBCKT PD_READ_PE bit vbias ren pc peq vss
.PARAM Ron=0.5 Roff=1e9 Vt=0.5 K=40 CBIT=0 CDEC=0 RCLAMP=0 GTAIL=0
.PARAM PE_BOOST=0.2  * extra volts added to pc during peq window
.PARAM VTH_PE=0.5    * peq threshold (V)

* Effective pc with brief boost while peq is high
Epc_eff pc_eff 0 VALUE=' v(pc) + ( v(peq)>VTH_PE ? PE_BOOST : 0 ) '

* Core precharge front-end
XCORE bit vbias ren pc_eff vss PD_READ Ron=Ron Roff=Roff Vt=Vt K=K CBIT=CBIT CDEC=CDEC RCLAMP=RCLAMP GTAIL=GTAIL

.ENDS PD_READ_PE
