* tb_sa_mt2.sp — smoke test for SA_MT2
.option post list method=gear reltol=1e-3 abstol=1e-12 vntol=1e-6
.temp 25
.include "../../../lib/SA_MT2.inc"

.param VDD=0.9 VREF=0.15
.param T0=0.5n TRF=20p TWIN=3n
.param T1='T0+TRF'  T2='T1+TWIN'  TSTOP='T2+0.5n'
.param CINT_TB=10f COUT_TB=1f GDRV_TB=2e-6 GAIN_TB=1e6  DEL=20m

Vdd  vdd 0 'VDD'
Vren ren 0 PWL( 0 0   'T1' 0   'T1+TRF' 1   'T2' 1   'T2+TRF' 0 )

* two taps around VREF
Vt1 vtap1 0 'VREF-DEL'
Vt2 vtap2 0 'VREF+DEL'

* input slightly above mid → expect HIGH
Vin in 0 PWL( 0 'VREF'  'T1' 'VREF'  'T1+0.2n' 'VREF+0.6*DEL' )

XMT2 in vtap1 vtap2 ren vdd 0 out SA_MT2 \
  GAIN='GAIN_TB' GDRV='GDRV_TB' CINT='CINT_TB' COUT='COUT_TB'

.ic v(XMT2.nint)=0
.tran 1p 'TSTOP'

.measure tran t_cross90 \
  TRIG v(ren) VAL=0.5 RISE=1 \
  TARG v(out) VAL='0.9*VDD'  RISE=1 FROM='T1'

.measure tran out_final  FIND v(out) AT='T2+0.2n'
.measure tran vout_pre   FIND v(out)      AT='T1-0.05n'
.measure tran vout_post  FIND v(out)      AT='T2+0.10n'
.measure tran vnint_pre  FIND v(XMT2.nint) AT='T1-0.05n'
.measure tran vnint_post FIND v(XMT2.nint) AT='T2+0.10n'
.measure tran E_sa_cap PARAM='0.5*COUT_TB*(vout_post**2 - vout_pre**2) \
                             +0.5*CINT_TB*(vnint_post**2 - vnint_pre**2)'

* alternate: below mid → expect LOW
.alter
Vin in 0 PWL( 0 'VREF'  'T1' 'VREF'  'T1+0.2n' 'VREF-0.6*DEL' )
