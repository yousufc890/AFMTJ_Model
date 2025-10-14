* tb_sa_mt3.sp — smoke test for SA_MT3
.option post list method=gear reltol=1e-3 abstol=1e-12 vntol=1e-6
.temp 25
.include "../../../lib/SA_MT3.inc"

.param VDD=0.9  VREF=0.15
.param T0=0.5n  TRF=20p  TWIN=3n
.param T1='T0+TRF'
.param T2='T1+TWIN'
.param TSTOP='T2+0.5n'
.param CINT_TB=10f COUT_TB=1f GDRV_TB=2e-6 GAIN_TB=1e6

Vdd   vdd  0 'VDD'
Vren  ren  0 PWL( 0 0   'T1' 0   'T1+TRF' 1   'T2' 1   'T2+TRF' 0 )

* 3 reference taps around VREF
.param DEL=20m
Vtap1 vtap1 0 'VREF-DEL'
Vtap2 vtap2 0 'VREF'
Vtap3 vtap3 0 'VREF+DEL'

* Drive input slightly above the middle tap during aperture → expect HIGH
Vin in 0 PWL( 0 'VREF'
+ 'T1'        'VREF'
+ 'T1+0.2n'   'VREF+0.7*DEL' )

* DUT
XMT in vtap1 vtap2 vtap3 ren vdd 0 out SA_MT3 \
   GAIN='GAIN_TB' GDRV='GDRV_TB' CINT='CINT_TB' COUT='COUT_TB'

.ic v(XMT.nint)=0
.tran 1p 'TSTOP'

* Timing & “energy via caps” (dependent sources draw ~no VDD current)
.measure tran t_cross90 \
  TRIG v(ren) VAL=0.5 RISE=1 \
  TARG v(out) VAL='0.9*VDD'  RISE=1 FROM='T1'

.measure tran out_final FIND v(out) AT='T2+0.2n'

.measure tran vout_pre   FIND v(out)       AT='T1-0.05n'
.measure tran vout_post  FIND v(out)       AT='T2+0.10n'
.measure tran vnint_pre  FIND v(XMT.nint)  AT='T1-0.05n'
.measure tran vnint_post FIND v(XMT.nint)  AT='T2+0.10n'
.measure tran E_sa_cap PARAM=' 0.5*COUT_TB*(vout_post**2 - vout_pre**2) \
                             + 0.5*CINT_TB*(vnint_post**2 - vnint_pre**2) '

* Alternate: input below middle tap → expect LOW
.alter
Vin in 0 PWL( 0 'VREF'  'T1' 'VREF'  'T1+0.2n' 'VREF-0.7*DEL' )
