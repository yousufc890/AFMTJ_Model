* tb_pd_pe_only.sp — PD_READ_PE unit test (precharge + pre-emphasis)

.option post list method=gear reltol=1e-3 abstol=1e-12 vntol=1e-6
.temp 25
.include "../../lib/PD_read.inc"
.include "../../lib/PD_read_pe.inc"

.param VREAD=0.15
.param CBIT=200f
.param CDEC=50f
.param RLEAK=1e12
.param PE_BOOST=0.2
.param TBOOST=40p

Vvb vbias 0 DC VREAD

Vpdis pdis 0 PULSE(1 0 0 5p 5p 0.58n 10n)
Gdis  bit  0 VALUE='(v(pdis)>0.5 ? 0.002 : 0)*v(bit,0)'

Vpc  pc 0 PWL( 0 0  0.58n 0  0.60n 0  0.60n+20p 1  0.93n 1  0.93n+20p 0  2.00n 0 )
Vren ren 0 0

* pre-emphasis window using the same peq pin
Vpeq peq 0 PULSE(0 1 0.60n 5p 5p TBOOST 10n)

* PD with pre-emphasis; same external BL caps approach
XPD bit vbias ren pc peq 0 PD_READ_PE CBIT=0 CDEC=0 PE_BOOST=PE_BOOST Ron=20 Vt=0.70 K=40

Cbl  bit 0 CBIT
Cdec bit 0 CDEC
Rlk  bit 0 RLEAK

.tran 0.5p 2.2n uic

* Measures: first crossing anywhere, then delta to pc rise
.measure tran t_pc_rise WHEN v(pc)=0.5 RISE=1
.measure tran t90_any WHEN v(bit)='0.90*VREAD' CROSS=1
.measure tran t95_any WHEN v(bit)='0.95*VREAD' CROSS=1
.measure tran t_settle90 PARAM='t90_any - t_pc_rise'
.measure tran t_settle95 PARAM='t95_any - t_pc_rise'

.measure tran E_vbias INTEG -VREAD*I(Vvb) FROM=0.60n TO=0.94n
.measure tran Vbit_pre  FIND v(bit) AT=0.93n
.measure tran Vbit_hold FIND v(bit) AT=1.50n
.measure tran Vbit_droop PARAM='Vbit_pre - Vbit_hold'
