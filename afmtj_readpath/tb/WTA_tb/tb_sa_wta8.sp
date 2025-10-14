* tb_sa_wta8.sp — smoke test for SA_WTA8
.option post list method=gear reltol=1e-3 abstol=1e-12 vntol=1e-6
.temp 25
.include "../../lib/SA_WTA.inc"

.param VDD=0.9  VREF=0.15
.param T0=0.5n  TRF=20p  TWIN=2n
.param T1='T0+TRF'
.param T2='T1+TWIN'
.param TSTOP='T2+0.5n'

* expose caps/drive for energy measure
.param CINT_TB=20f  COUT_TB=1f  GDRV_TB=1e-6  GAIN_TB=8e5

Vdd   vdd  0 'VDD'
Vref  vref 0 'VREF'
Vren  ren  0 PWL( 0 0   'T1' 0   'T1+TRF' 1   'T2' 1   'T2+TRF' 0 )

.param DEL=15m

* Single PWL per input: start near VREF, then step at aperture start.
* Make in3 the “winner”.
Vin1 in1 0 PWL( 0 'VREF-5m', 'T1' 'VREF-0.6*DEL', 'T1+0.2n' 'VREF-0.6*DEL' )
Vin2 in2 0 PWL( 0 'VREF-5m', 'T1' 'VREF-0.6*DEL', 'T1+0.2n' 'VREF-0.6*DEL' )
Vin3 in3 0 PWL( 0 'VREF-5m', 'T1' 'VREF+1.0*DEL', 'T1+0.2n' 'VREF+1.0*DEL' )  * winner
Vin4 in4 0 PWL( 0 'VREF-5m', 'T1' 'VREF-0.6*DEL', 'T1+0.2n' 'VREF-0.6*DEL' )
Vin5 in5 0 PWL( 0 'VREF-5m', 'T1' 'VREF-0.6*DEL', 'T1+0.2n' 'VREF-0.6*DEL' )
Vin6 in6 0 PWL( 0 'VREF-5m', 'T1' 'VREF-0.6*DEL', 'T1+0.2n' 'VREF-0.6*DEL' )
Vin7 in7 0 PWL( 0 'VREF-5m', 'T1' 'VREF-0.6*DEL', 'T1+0.2n' 'VREF-0.6*DEL' )
Vin8 in8 0 PWL( 0 'VREF-5m', 'T1' 'VREF-0.6*DEL', 'T1+0.2n' 'VREF-0.6*DEL' )

* DUT
XW in1 in2 in3 in4 in5 in6 in7 in8  vref ren  vdd 0  out SA_WTA8 \
   GDRV='GDRV_TB' CINT='CINT_TB' COUT='COUT_TB' GAIN='GAIN_TB'

.ic v(XW.nint)=0
.tran 1p 'TSTOP'

* timing / result
.measure tran t_cross WHEN v(out)='0.51*VDD' FROM='T1-5p' TO='T2' CROSS=1
.measure tran out_final FIND v(out) AT='T2+0.2n'

* cap-based energy
.measure tran vout_pre   FIND v(out)      AT='T1-0.05n'
.measure tran vout_post  FIND v(out)      AT='T2+0.10n'
.measure tran vnint_pre  FIND v(XW.nint)  AT='T1-0.05n'
.measure tran vnint_post FIND v(XW.nint)  AT='T2+0.10n'
.measure tran E_sa_cap   PARAM=' 0.5*COUT_TB*(vout_post**2 - vout_pre**2) \
                                + 0.5*CINT_TB*(vnint_post**2 - vnint_pre**2) '

* Alternate run: make in6 the winner
.alter
Vin3 in3 0 PWL( 0 'VREF-5m', 'T1' 'VREF-0.6*DEL', 'T1+0.2n' 'VREF-0.6*DEL' )
Vin6 in6 0 PWL( 0 'VREF-5m', 'T1' 'VREF+1.0*DEL', 'T1+0.2n' 'VREF+1.0*DEL' )
