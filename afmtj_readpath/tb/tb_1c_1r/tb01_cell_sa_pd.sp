* tb01_cell_sa_pd.sp — 1-cell AFMTJ + PD + STSA integration

.option post list method=gear reltol=1e-3 abstol=1e-12 vntol=1e-6
.temp 25

.include "../../../MTJ_model.inc"
.include "../../lib/PD_read.inc"
.include "../../lib/PD_read_eq.inc"
.include "../../lib/SA_STSA.inc"
.include "../../lib/ref_ladder.inc"

.param VDD=0.9
.param VREAD=0.15
.param RLOAD=2k
.param CBIT_EXT=200f
.param CDEC_EXT=50f
.param RLEAK=1e12
.param TPRE=0.60n
.param TREAD=0.6n

Vdd   vdd   0  VDD
Vvb   vbias 0  VREAD

* === AFMTJ ===
.subckt AFMTJ_CELL bit_in bit_out 0 INI=1
XMTJ bit_in 0 MTJ lx='45n' ly='45n' lz='0.3n' Ms0='600' P0='0.8' alpha='0.01' Tmp0='358' RA0='5' MA='1' ini=INI Kp='1.08e7' J_AF='5e-3'
.ends AFMTJ_CELL
X1 ve1 nc1 0 AFMTJ_CELL INI=1

* Sense divider to vbias
Rbl1 vbias ve1 RLOAD

* External BL network
Cbl  ve1 0 CBIT_EXT
Cdec ve1 0 CDEC_EXT
Rlk  ve1 0 RLEAK

* === SA reference (VMID via ladder) ===
.param RP=5.0098k
.param RAP=13.5272k
.param VMID='0.5*( VREAD*(RP)/(RLOAD+RP) + VREAD*(RAP)/(RLOAD+RAP) )'
Vvref vref 0 DC VMID
XREF  vref mid vtap1 vtap2 vtap3 0 REF_LADDER DmV=0

* === STSA (in vref ren vdd vss out) ===
.param GAIN=1e6 VOFF=0
XSA ve1 mid ren vdd 0 sa_out SA_STSA GAIN=1e6 GDRV=5e-4 CINT=15f COUT=2f

* Tiny output cap to give VDD a current path (so E_vdd > 0)
Cdd sa_out vdd 5f

* === PD timing ===
.param TEQ=40p GEQ=0.02
Vpeq peq 0 PULSE(0 1 'TPRE-TEQ' 5p 5p TEQ 10n)
Vpc  pc  0 PWL( 0 0  0.58n 0  0.60n 0  0.60n+20p 1  0.93n 1  0.93n+20p 0  2.00n 0 )

* SA aperture
Vren ren 0 PULSE(0 1 TPRE 5p 5p TREAD 10n)

* ====== RUN #1: Turbo (EQ) ======
XPD ve1 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40

.tran 0.5p 2.2n uic

* Latch time (delta from TPRE)
.measure tran t55_any WHEN v(sa_out)='0.55*VDD' CROSS=1
.measure tran t90_any WHEN v(sa_out)='0.90*VDD' CROSS=1
.measure tran t_sa_latch PARAM='t90_any - TPRE'
.measure tran t_slew_55_90 PARAM='t90_any - t55_any'

.measure tran E_vdd   INTEG -P(Vdd)  FROM=TPRE TO='TPRE+TREAD'
.measure tran E_vbias INTEG -P(Vvb)  FROM=TPRE TO='TPRE+TREAD'
.measure tran E_read  PARAM='E_vdd + E_vbias'

.alter
* ====== RUN #2: Guard (BASE PD) ======
* Drop equalize pin; keep exact same timing
* (Comment out Vpeq if you prefer; it’s unused by PD_READ)
XPD ve1 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40

.tran 0.5p 2.2n uic

.measure tran t55_any WHEN v(sa_out)='0.55*VDD' CROSS=1
.measure tran t90_any WHEN v(sa_out)='0.90*VDD' CROSS=1
.measure tran t_sa_latch PARAM='t90_any - TPRE'
.measure tran t_slew_55_90 PARAM='t90_any - t55_any'

.measure tran E_vdd   INTEG -P(Vdd)  FROM=TPRE TO='TPRE+TREAD'
.measure tran E_vbias INTEG -P(Vvb)  FROM=TPRE TO='TPRE+TREAD'
.measure tran E_read  PARAM='E_vdd + E_vbias'

.end
