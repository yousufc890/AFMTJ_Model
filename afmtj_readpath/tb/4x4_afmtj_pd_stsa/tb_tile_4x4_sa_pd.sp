* tb02_tile_4x4_sa_pd.sp — 4×4 AFMTJ tile with PD (EQ/BASE) + STSA

.option post list method=gear reltol=1e-3 abstol=1e-12 vntol=1e-6
.temp 25

.include "../../../MTJ_model.inc"
.include "../../lib/PD_read.inc"
.include "../../lib/PD_read_eq.inc"
.include "../../lib/SA_STSA.inc"
.include "../../lib/ref_ladder.inc"

* ===== Global params =====
.param VDD=0.9
.param VREAD=0.15
.param RLOAD=2k
.param CBIT_EXT=200f
.param CDEC_EXT=50f
.param RLEAK=1e12
.param TPRE=0.60n
.param TREAD=0.60n

* ---- SA sweep parameters ----
.param SA_GAIN=1e6
.param SA_GDRV=5e-4
.param SA_CINT=15f
.param SA_COUT=2f
.step param SA_GAIN list 1e5 1e6 1e7
.step param TREAD list 0.5n 1n 2n

VDD_SRC vdd_src 0 DC VDD
RVS     vdd_src vdd 1m

* Make Vbias slightly non-ideal to observe droop and energy
.param R_VBIAS_SRC=1
Vbias_src vread_src 0 DC VREAD
Rvb       vread_src vbias R_VBIAS_SRC

* ===== AFMTJ cell =====
.subckt AFMTJ_CELL bit_in bit_out 0 INI=1
XMTJ bit_in 0 MTJ lx='45n' ly='45n' lz='0.3n' Ms0='600' P0='0.8' alpha='0.01' Tmp0='358' RA0='5' MA='1' ini=INI Kp='1.08e7' J_AF='5e-3'
.ends AFMTJ_CELL

* ===== 4x4 instances =====
* Row 1
XAFMTJ_R1_C1 ve_R1_C1 nc_R1_C1 0 AFMTJ_CELL INI=1
XAFMTJ_R1_C2 ve_R1_C2 nc_R1_C2 0 AFMTJ_CELL INI=1
XAFMTJ_R1_C3 ve_R1_C3 nc_R1_C3 0 AFMTJ_CELL INI=1
XAFMTJ_R1_C4 ve_R1_C4 nc_R1_C4 0 AFMTJ_CELL INI=1
* Row 2
XAFMTJ_R2_C1 ve_R2_C1 nc_R2_C1 0 AFMTJ_CELL INI=1
XAFMTJ_R2_C2 ve_R2_C2 nc_R2_C2 0 AFMTJ_CELL INI=1
XAFMTJ_R2_C3 ve_R2_C3 nc_R2_C3 0 AFMTJ_CELL INI=1
XAFMTJ_R2_C4 ve_R2_C4 nc_R2_C4 0 AFMTJ_CELL INI=1
* Row 3
XAFMTJ_R3_C1 ve_R3_C1 nc_R3_C1 0 AFMTJ_CELL INI=1
XAFMTJ_R3_C2 ve_R3_C2 nc_R3_C2 0 AFMTJ_CELL INI=1
XAFMTJ_R3_C3 ve_R3_C3 nc_R3_C3 0 AFMTJ_CELL INI=1
XAFMTJ_R3_C4 ve_R3_C4 nc_R3_C4 0 AFMTJ_CELL INI=1
* Row 4
XAFMTJ_R4_C1 ve_R4_C1 nc_R4_C1 0 AFMTJ_CELL INI=1
XAFMTJ_R4_C2 ve_R4_C2 nc_R4_C2 0 AFMTJ_CELL INI=1
XAFMTJ_R4_C3 ve_R4_C3 nc_R4_C3 0 AFMTJ_CELL INI=1
XAFMTJ_R4_C4 ve_R4_C4 nc_R4_C4 0 AFMTJ_CELL INI=1

* ===== Column loads (vbias -> ve nodes) =====
R_R1C1 vbias ve_R1_C1 RLOAD
R_R1C2 vbias ve_R1_C2 RLOAD
R_R1C3 vbias ve_R1_C3 RLOAD
R_R1C4 vbias ve_R1_C4 RLOAD
R_R2C1 vbias ve_R2_C1 RLOAD
R_R2C2 vbias ve_R2_C2 RLOAD
R_R2C3 vbias ve_R2_C3 RLOAD
R_R2C4 vbias ve_R2_C4 RLOAD
R_R3C1 vbias ve_R3_C1 RLOAD
R_R3C2 vbias ve_R3_C2 RLOAD
R_R3C3 vbias ve_R3_C3 RLOAD
R_R3C4 vbias ve_R3_C4 RLOAD
R_R4C1 vbias ve_R4_C1 RLOAD
R_R4C2 vbias ve_R4_C2 RLOAD
R_R4C3 vbias ve_R4_C3 RLOAD
R_R4C4 vbias ve_R4_C4 RLOAD

* External BL caps and leakage per cell
C_R1C1 ve_R1_C1 0 CBIT_EXT
C_R1C2 ve_R1_C2 0 CBIT_EXT
C_R1C3 ve_R1_C3 0 CBIT_EXT
C_R1C4 ve_R1_C4 0 CBIT_EXT
C_R2C1 ve_R2_C1 0 CBIT_EXT
C_R2C2 ve_R2_C2 0 CBIT_EXT
C_R2C3 ve_R2_C3 0 CBIT_EXT
C_R2C4 ve_R2_C4 0 CBIT_EXT
C_R3C1 ve_R3_C1 0 CBIT_EXT
C_R3C2 ve_R3_C2 0 CBIT_EXT
C_R3C3 ve_R3_C3 0 CBIT_EXT
C_R3C4 ve_R3_C4 0 CBIT_EXT
C_R4C1 ve_R4_C1 0 CBIT_EXT
C_R4C2 ve_R4_C2 0 CBIT_EXT
C_R4C3 ve_R4_C3 0 CBIT_EXT
C_R4C4 ve_R4_C4 0 CBIT_EXT

Cd_R1C1 ve_R1_C1 0 CDEC_EXT
Cd_R1C2 ve_R1_C2 0 CDEC_EXT
Cd_R1C3 ve_R1_C3 0 CDEC_EXT
Cd_R1C4 ve_R1_C4 0 CDEC_EXT
Cd_R2C1 ve_R2_C1 0 CDEC_EXT
Cd_R2C2 ve_R2_C2 0 CDEC_EXT
Cd_R2C3 ve_R2_C3 0 CDEC_EXT
Cd_R2C4 ve_R2_C4 0 CDEC_EXT
Cd_R3C1 ve_R3_C1 0 CDEC_EXT
Cd_R3C2 ve_R3_C2 0 CDEC_EXT
Cd_R3C3 ve_R3_C3 0 CDEC_EXT
Cd_R3C4 ve_R3_C4 0 CDEC_EXT
Cd_R4C1 ve_R4_C1 0 CDEC_EXT
Cd_R4C2 ve_R4_C2 0 CDEC_EXT
Cd_R4C3 ve_R4_C3 0 CDEC_EXT
Cd_R4C4 ve_R4_C4 0 CDEC_EXT

Rlk_R1C1 ve_R1_C1 0 RLEAK
Rlk_R1C2 ve_R1_C2 0 RLEAK
Rlk_R1C3 ve_R1_C3 0 RLEAK
Rlk_R1C4 ve_R1_C4 0 RLEAK
Rlk_R2C1 ve_R2_C1 0 RLEAK
Rlk_R2C2 ve_R2_C2 0 RLEAK
Rlk_R2C3 ve_R2_C3 0 RLEAK
Rlk_R2C4 ve_R2_C4 0 RLEAK
Rlk_R3C1 ve_R3_C1 0 RLEAK
Rlk_R3C2 ve_R3_C2 0 RLEAK
Rlk_R3C3 ve_R3_C3 0 RLEAK
Rlk_R3C4 ve_R3_C4 0 RLEAK
Rlk_R4C1 ve_R4_C1 0 RLEAK
Rlk_R4C2 ve_R4_C2 0 RLEAK
Rlk_R4C3 ve_R4_C3 0 RLEAK
Rlk_R4C4 ve_R4_C4 0 RLEAK

* ===== VMID reference via ladder =====
.param RP=5.0098k
.param RAP=13.5272k
.param VMID='0.5*( VREAD*(RP)/(RLOAD+RP) + VREAD*(RAP)/(RLOAD+RAP) )'
Vvref vref 0 DC VMID
XREF  vref mid vtap1 vtap2 vtap3 0 REF_LADDER DmV=0

* ===== SA per cell (in vref ren vdd vss out) =====
XSA_R1C1 ve_R1_C1 mid ren vdd 0 out_R1C1 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R1C2 ve_R1_C2 mid ren vdd 0 out_R1C2 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R1C3 ve_R1_C3 mid ren vdd 0 out_R1C3 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R1C4 ve_R1_C4 mid ren vdd 0 out_R1C4 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R2C1 ve_R2_C1 mid ren vdd 0 out_R2C1 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R2C2 ve_R2_C2 mid ren vdd 0 out_R2C2 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R2C3 ve_R2_C3 mid ren vdd 0 out_R2C3 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R2C4 ve_R2_C4 mid ren vdd 0 out_R2C4 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R3C1 ve_R3_C1 mid ren vdd 0 out_R3C1 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R3C2 ve_R3_C2 mid ren vdd 0 out_R3C2 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R3C3 ve_R3_C3 mid ren vdd 0 out_R3C3 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R3C4 ve_R3_C4 mid ren vdd 0 out_R3C4 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R4C1 ve_R4_C1 mid ren vdd 0 out_R4C1 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R4C2 ve_R4_C2 mid ren vdd 0 out_R4C2 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R4C3 ve_R4_C3 mid ren vdd 0 out_R4C3 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT
XSA_R4C4 ve_R4_C4 mid ren vdd 0 out_R4C4 SA_STSA GAIN=SA_GAIN GDRV=SA_GDRV CINT=SA_CINT COUT=SA_COUT

* increase SA output caps for cleaner E_vdd accounting
.param CDD_SA=5f

* Tiny dynamic path to VDD for SA outputs (so E_vdd > 0)
Cdd_R1C1 out_R1C1 vdd CDD_SA
Cdd_R1C2 out_R1C2 vdd CDD_SA
Cdd_R1C3 out_R1C3 vdd CDD_SA
Cdd_R1C4 out_R1C4 vdd CDD_SA
Cdd_R2C1 out_R2C1 vdd CDD_SA
Cdd_R2C2 out_R2C2 vdd CDD_SA
Cdd_R2C3 out_R2C3 vdd CDD_SA
Cdd_R2C4 out_R2C4 vdd CDD_SA
Cdd_R3C1 out_R3C1 vdd CDD_SA
Cdd_R3C2 out_R3C2 vdd CDD_SA
Cdd_R3C3 out_R3C3 vdd CDD_SA
Cdd_R3C4 out_R3C4 vdd CDD_SA
Cdd_R4C1 out_R4C1 vdd CDD_SA
Cdd_R4C2 out_R4C2 vdd CDD_SA
Cdd_R4C3 out_R4C3 vdd CDD_SA
Cdd_R4C4 out_R4C4 vdd CDD_SA

* ===== Row analog sums (resistive) =====
.param RSUM=1k RPULL=1k
* Row 1
Rsum_R1_1 row1 out_R1C1 RSUM
Rsum_R1_2 row1 out_R1C2 RSUM
Rsum_R1_3 row1 out_R1C3 RSUM
Rsum_R1_4 row1 out_R1C4 RSUM
Rpull_R1  row1 0       RPULL
* Row 2
Rsum_R2_1 row2 out_R2C1 RSUM
Rsum_R2_2 row2 out_R2C2 RSUM
Rsum_R2_3 row2 out_R2C3 RSUM
Rsum_R2_4 row2 out_R2C4 RSUM
Rpull_R2  row2 0       RPULL
* Row 3
Rsum_R3_1 row3 out_R3C1 RSUM
Rsum_R3_2 row3 out_R3C2 RSUM
Rsum_R3_3 row3 out_R3C3 RSUM
Rsum_R3_4 row3 out_R3C4 RSUM
Rpull_R3  row3 0       RPULL
* Row 4
Rsum_R4_1 row4 out_R4C1 RSUM
Rsum_R4_2 row4 out_R4C2 RSUM
Rsum_R4_3 row4 out_R4C3 RSUM
Rsum_R4_4 row4 out_R4C4 RSUM
Rpull_R4  row4 0       RPULL

* Row thresholds for 1..4 matches (same formulation)
.param VROW1='VDD*(1*RSUM)/(1*RSUM + RPULL)'
.param VROW2='VDD*(2*RSUM)/(2*RSUM + RPULL)'
.param VROW3='VDD*(3*RSUM)/(3*RSUM + RPULL)'
.param VROW4='VDD*(4*RSUM)/(4*RSUM + RPULL)'
.param V4='VROW4'

* ===== Timing controls =====
.param TEQ=20p GEQ=0.01
.param TPRE_EQ='TPRE-TEQ'

* Equalize (Turbo only uses it; BASE PD ignores)
Vpeq peq 0 PULSE(0 1 TPRE_EQ 5p 5p TEQ 10n)

* Precharge control (pc) — finite slopes
Vpc  pc 0 PWL( 0 0  'TPRE-20p' 0  'TPRE' 0  'TPRE+20p' 1  'TPRE+350p' 1  'TPRE+370p' 0  'TPRE+1.0n' 0 )

* SA aperture gate
Vren ren 0 PULSE(0 1 TPRE 5p 5p TREAD 10n)

* ====== RUN #1: Turbo (PD = EQ) ======
XPD_R1C1 ve_R1_C1 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R1C2 ve_R1_C2 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R1C3 ve_R1_C3 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R1C4 ve_R1_C4 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R2C1 ve_R2_C1 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R2C2 ve_R2_C2 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R2C3 ve_R2_C3 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R2C4 ve_R2_C4 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R3C1 ve_R3_C1 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R3C2 ve_R3_C2 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R3C3 ve_R3_C3 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R3C4 ve_R3_C4 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R4C1 ve_R4_C1 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R4C2 ve_R4_C2 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R4C3 ve_R4_C3 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40
XPD_R4C4 ve_R4_C4 vbias ren pc peq 0 PD_READ_EQ CBIT=0 CDEC=0 GEQ=GEQ Ron=20 Vt=0.70 K=40

.tran 0.5p 1.2n uic

* ===== Measures (Turbo) =====
.measure tran t_row1_abs WHEN v(row1)=V4 CROSS=1 FROM=TPRE
.measure tran t_row2_abs WHEN v(row2)=V4 CROSS=1 FROM=TPRE
.measure tran t_row3_abs WHEN v(row3)=V4 CROSS=1 FROM=TPRE
.measure tran t_row4_abs WHEN v(row4)=V4 CROSS=1 FROM=TPRE
.measure tran t_resolve_row1 PARAM='t_row1_abs - TPRE'
.measure tran t_resolve_row2 PARAM='t_row2_abs - TPRE'
.measure tran t_resolve_row3 PARAM='t_row3_abs - TPRE'
.measure tran t_resolve_row4 PARAM='t_row4_abs - TPRE'

.measure tran E_vdd   INTEG P(RVS) FROM=TPRE TO='TPRE+TREAD'
.measure tran E_vbias INTEG P(Rvb) FROM=TPRE TO='TPRE+TREAD'
.measure tran E_read  PARAM='E_vdd + E_vbias'
.measure tran Vbias_min MIN v(vbias) FROM=TPRE TO='TPRE+TREAD'

.alter
* ====== RUN #2: Guard (PD = BASE) ======
XPD_R1C1 ve_R1_C1 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R1C2 ve_R1_C2 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R1C3 ve_R1_C3 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R1C4 ve_R1_C4 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R2C1 ve_R2_C1 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R2C2 ve_R2_C2 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R2C3 ve_R2_C3 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R2C4 ve_R2_C4 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R3C1 ve_R3_C1 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R3C2 ve_R3_C2 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R3C3 ve_R3_C3 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R3C4 ve_R3_C4 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R4C1 ve_R4_C1 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R4C2 ve_R4_C2 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R4C3 ve_R4_C3 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40
XPD_R4C4 ve_R4_C4 vbias ren pc 0 PD_READ CBIT=0 CDEC=0 Ron=20 Vt=0.70 K=40

.tran 0.5p 1.2n uic

* ===== Measures (Guard) =====
.measure tran t_row1_abs WHEN v(row1)=V4 CROSS=1 FROM=TPRE
.measure tran t_row2_abs WHEN v(row2)=V4 CROSS=1 FROM=TPRE
.measure tran t_row3_abs WHEN v(row3)=V4 CROSS=1 FROM=TPRE
.measure tran t_row4_abs WHEN v(row4)=V4 CROSS=1 FROM=TPRE
.measure tran t_resolve_row1 PARAM='t_row1_abs - TPRE'
.measure tran t_resolve_row2 PARAM='t_row2_abs - TPRE'
.measure tran t_resolve_row3 PARAM='t_row3_abs - TPRE'
.measure tran t_resolve_row4 PARAM='t_row4_abs - TPRE'

.measure tran E_vdd   INTEG P(RVS) FROM=TPRE TO='TPRE+TREAD'
.measure tran E_vbias INTEG P(Rvb) FROM=TPRE TO='TPRE+TREAD'
.measure tran E_read  PARAM='E_vdd + E_vbias'
.measure tran Vbias_min MIN v(vbias) FROM=TPRE TO='TPRE+TREAD'

.end
