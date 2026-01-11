************************************************************************************
************************************************************************************
** Title:  MTJ_write.sp
** Authors: For AFMTJ Yousuf Choudhary, HW Accelerator Research @ UofA for MTJ Base Model Jongyeon Kim, VLSI Research Lab @ UMN
** Emails:  ychoudhary@arizona.edu, kimx2889@umn.edu
************************************************************************************
** This run file simulates the dynamic motion of  AFMTJ.
** # Instruction for simulation
** 1. Set the AFMTJ dimensions and material parameters.
** 2. Select anisotropy(IMA/PMA) and initial state of free layer(P/AP).
** 3. Adjust bias voltage for Read/Write operation.
** ex. APtoP switching: positive voltage @ ini='1'
**     PtoAP switching: negative voltage @ ini='0'  
**     Also adjust voltage sign (- for ini=0) based on switching type
************************************************************************************
** # Description of parameters
** lx,ly,lz: width, length, and thickness of free layer
** tox: MgO thickness
** Ms0:saturation magnetizaion at 0K
** P0: polarization factor at 0K 
** alpha: damping factor
** temp: temperature
** MA: magnetic anisotropy (MA=0:In-plane,MA=1:Perpendicular)
**     also sets magnetization in pinned layer, MA=0:[0,1,0],MA=1:[0,0,1]
** ini: initial state of free layer (ini=0:Parallel,ini=1:Anti-parallel)
** Kp: Crystal perpendicular anisotropy constant
************************************************************************************

.include 'MTJ_model.inc'

*** Options ************************************************************************
.option post=2 method=gear runlvl=6 reltol=1e-3 abstol=1e-12 vntol=1e-6 trtol=1
.save

*** Voltage biasing to MTJ *********************************************************
.param vmtj='0.5'
V1 1 0 'vmtj'
XMTJ1 1 0 MTJ lx='45n' ly='45n' lz='0.3n' Ms0='600' P0='0.62' alpha='0.02' Tmp0='358' RA0='5' MA='1' ini='1' Kp='1.08e7' J_AF='8e-2'

*** Analysis ***********************************************************************
.param pw='10n' 
.tran 1p pw START=1.0e-18 uic

* Print magnetization
*.print tran v(XMTJ1.XLLG.Mz) v(XMTJ1.XLLG.Mz2)
.print tran v(XMTJ1.XRA.rmtj)

.meas tsw0 when v(XMTJ1.XLLG.Mz)='0'
.meas iwr find i(XMTJ1.ve1) at 1ns
.meas thermal_stability find v(XMTJ1.XLLG.thste) at 1ns

.measure tran m1_switch_time \
    TRIG v(XMTJ1.XLLG.Mz) VAL=-0.5 RISE=1 \
    TARG v(XMTJ1.XLLG.Mz) VAL=0.5 RISE=1

.measure tran m2_switch_time \
    TRIG v(XMTJ1.XLLG.Mz2) VAL=0.5 FALL=1 \
    TARG v(XMTJ1.XLLG.Mz2) VAL=-0.5 FALL=1

* Write time in (MTJ) measured by observing the time it takes
* to switch between its high and low resistance states.
.measure tran resistence_based_write_time \
    TRIG v(XMTJ1.XRA.rmtj) VAL=3.3k FALL=1 \
    TARG v(XMTJ1.XRA.rmtj) VAL=2.5k FALL=1

.end
