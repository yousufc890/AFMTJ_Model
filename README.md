**AFMTJ SPICE Model**

This repository contains a SPICE-level antiferromagnetic magnetic tunnel junction (AFMTJ) model, extending the University of Minnesota (UMN) MTJ framework to support dual-sublattice antiferromagnetic dynamics.

The model captures LLG-based magnetization dynamics, spin-transfer torque (STT), inter-sublattice exchange coupling, temperature effects, and resistance evolution, enabling transient simulations of AFMTJ write operations.

File Overview
AFMTJ_Model/
```
├── mtj_write.sp       # Main simulation netlist (run this)
├── MTJ_model.inc      # Top-level AFMTJ device model
├── LLG_solver.inc     # Dual-sublattice LLG solver
├── Resistor.inc       # MTJ resistance and TMR model
├── HeatDF.inc         # Joule heating & thermal diffusion
```

**How to Run the Simulation**

The main simulation netlist is mtj_write.sp.

Run transient simulation:

`hspice mtj_write.sp`

This executes a write operation on an AFMTJ cell using a voltage bias applied across the MTJ.

**Example Netlist (Excerpt)**

From `mtj_write.sp`:

```
.param vmtj='0.5'
V1 1 0 'vmtj'

XMTJ1 1 0 MTJ \
  lx='45n' ly='45n' lz='0.3n' \
  Ms0='600' P0='0.62' alpha='0.02' \
  Tmp0='358' RA0='5' MA='1' ini='1' \
  Kp='1.08e7' J_AF='8e-2'

.tran 1p 10n uic
```

**Key Parameters:**

- vmtj — write voltage
- ini — initial magnetic state (0 = Parallel, 1 = Anti-parallel)
- J_AF — inter-sublattice exchange coupling strength

**Expected Outputs**

After simulation, HSPICE generates scalar measurement outputs in `MTJ_write.mt0`

**Base Results (Default Parameters)**

Running the unmodified netlist produces output similar to:

```
tsw0             iwr              thermal_stability m1_switch_time
m2_switch_time   resistence_based_write_time temper          alter#
8.920e-10        2.024e-04        111.2937         5.774e-11
5.774e-11        5.530e-11         25.0000        1
```

**Meaning of Results**
- tsw0 — time when Mz crosses zero (s)
- iwr — write current measured at 1 ns (A)
- thermal_stability — thermal stability factor
- m1_switch_time — switching time of sublattice 1 (s)
- m2_switch_time — switching time of sublattice 2 (s)
- resistence_based_write_time — write time extracted from resistance transition (s)
- temper — simulation temperature
- alter# — HSPICE alter index (1 = default run)

Exact numerical values may vary slightly with simulator version and tolerances, but a correct run should generate this file and demonstrate AFMTJ switching behavior.

**Model Description**
**Dual-Sublattice Dynamics**

The AFMTJ free layer is modeled using two dynamically coupled magnetization vectors, evolved via modified Landau–Lifshitz–Gilbert (LLG) equations.

**Exchange Coupling**

Inter-sublattice exchange coupling is implemented via:
- Mutual exchange-field injection between sublattices
- Explicit exchange torque terms proportional to J_AF

This enables antiferromagnetic alignment and strong dynamic feedback.

**Thermal Effects**
- Joule heating is modeled in HeatDF.inc
- Temperature dynamically affects saturation magnetization, polarization, and thermal stability

**Simulator Notes**
- Tested with HSPICE (PrimeSim)
- Uses Gear integration (method=gear) for numerical stability

**Attribution**
- AFMTJ extensions: Yousuf Choudhary, University of Arizona
- Base MTJ framework: Jongyeon Kim, VLSI Research Lab, University of Minnesota
