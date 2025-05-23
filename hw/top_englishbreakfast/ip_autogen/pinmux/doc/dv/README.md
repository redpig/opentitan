# PINMUX DV document

* **DV**:
  * TODO: Add a UVM testbench to reuse auto-generated common tests for TLUL and alerts.

* **FPV**:
  * Verify all the PINMUX outputs by writing assumptions and assertions with a FPV based testbench
  * Verify TileLink device protocol compliance with a FPV based testbench

* [Design & verification stage](../../../../../README.md)
  * [HW development stages](../../../../../../doc/project_governance/development_stages.md)
* [FPV dashboard](https://reports.opentitan.org/hw/top_englishbreakfast/formal/summary.html)

For detailed information on PINMUX design features, please see the
[PINMUX design specification](../../README.md).

PINMUX FPV testbench has been constructed based on the [formal architecture](../../../../../formal/README.md).

![Block diagram](fpv.svg)

* The `../fpv/tb/pinmux_bind.sv` binds the `tlul_assert` [assertions](../../../../../ip/tlul/doc/TlulProtocolChecker.md) with pinmux to ensure TileLink interface protocol compliance.
* The `../fpv/tb/pinmux_bind.sv` also binds the `pinmux_csr_assert_fpv` to assert the TileLink writes and reads correctly.

* The `../fpv/tb/pinmux_bind_fpv.sv` binds module `pinmux_assert_fpv` with the pinmux RTL.
The assertion file ensures all pinmux's outputs are verified based on the [testplan](#testplan).

In the pinmux design, it includes usbdev logic because it operates on an always-on domain.
Pinmux FPV assertions will only cover the connectivities between usbdev IOs and pinmux IOs.
All functional checks will be implemented in the usbdev testbench.

Due to the large number of peripheral, muxed, dedicated IOs, and wakeup causes, symbolic variables are used to reduce the number of repeated assertions code.
In the pinmux_assert_fpv module, we declared four symbolic variables (`mio_sel_i`, `periph_sel_i`, `dio_sel_i`, `wkup_sel_i`) to represent the index for muxed IOs, peripheral IOs, dedicated IOs, and wakeup causes.
Detailed explanation is listed in the [Symbolic Variables](../../../../../formal/README.md#symbolic-variables) section.

[Testplan](../../data/pinmux_fpv_testplan.hjson)
