* tb_sa_stsa.sp — smoke test for SA_STSA only
.option post list method=gear reltol=1e-3 abstol=1e-12 vntol=1e-6
.temp 25
.include "../../lib/SA_STSA.inc"

.param VDD=0.9  VREF=0.15
.param T0=0.5n  TRF=20p  TWIN=2n
.param T1='T0+TRF'
.param T2='T1+TWIN'
.param TSTOP='T2+0.5n'

* mirror the caps at TB so we can use them in .measure
.param CINT_TB=1f  COUT_TB=1f  GDRV_TB=5e-3  GAIN_TB=1e6

Vdd   vdd  0 'VDD'
Vref  vref 0 'VREF'
Vren  ren  0 PWL( 0 0   'T1' 0   'T1+TRF' 1   'T2' 1   'T2+TRF' 0 )

* +10 mV during aperture → should trip high and hold
.param DELTA=10m
Vin in 0 PWL( 0 'VREF'
+ 'T1'        'VREF'
+ 'T1+0.2n'   'VREF+DELTA' )

* DUT: pass caps/drive from TB so we can use them in measures
XSA in vref ren vdd 0 out SA_STSA GAIN='GAIN_TB' GDRV='1e-7' CINT='1f' COUT='1f'

.ic v(XSA.nint)=0
.tran 1p 'TSTOP'

.measure tran t_cross WHEN v(out)='0.55*VDD' FROM='T1' TO='T2' CROSS=1

.measure tran out_final FIND v(out) AT='T2+0.2n'

.measure tran vout_pre  FIND v(out)  AT='T1-0.05n'
.measure tran vout_post FIND v(out)  AT='T2+0.10n'
.measure tran vnint_pre  FIND v(XSA.nint) AT='T1-0.05n'
.measure tran vnint_post FIND v(XSA.nint) AT='T2+0.10n'

.measure tran E_sa_cap PARAM=' 0.5*COUT_TB*(vout_post**2 - vout_pre**2) + 0.5*CINT_TB*(vnint_post**2 - vnint_pre**2) '

* Optional waveform debug
*.print tran v(in) v(vref) v(ren) v(out)

* Alternate: -10 mV → should NOT trip (should stay ~0 V)
.alter
.param DELTA=-10m
Vin in 0 PWL( 0 'VREF+5m'
+ 'T1'        'VREF+5m'
+ 'T1+0.2n'   'VREF+DELTA' )
