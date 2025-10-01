# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    # Load 0x3C synchronously, then enable counting and outputs
    dut.uio_in.value = 0x3C          # load_data
    dut.ui_in.value  = 0b00000010    # load=1
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value  = 0b00000000    # load=0
    await ClockCycles(dut.clk, 1)

    # enable counting (ui_in[0]) and output enable (ui_in[2])
    dut.ui_in.value  = 0b00000101    # en=1, oe=1
    await ClockCycles(dut.clk, 1)
    v0 = int(dut.uo_out.value)       # should be 0x3C after load
    assert v0 == 0x3C, f"expected 0x3C after load, got 0x{v0:02X}"

    await ClockCycles(dut.clk, 1)
    v1 = int(dut.uo_out.value)
    assert v1 == ((v0 + 1) & 0xFF), f"expected +1 increment: got 0x{v1:02X} from 0x{v0:02X}"

    await ClockCycles(dut.clk, 1)
    v2 = int(dut.uo_out.value)
    assert v2 == ((v1 + 1) & 0xFF), f"expected +1 increment: got 0x{v2:02X} from 0x{v1:02X}"

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    # (Counter example: after disabling oe, uo_out should be 0x00 in our wrapper.)
    dut.ui_in.value = 0b00000001     # en=1, oe=0
    await ClockCycles(dut.clk, 1)
    assert int(dut.uo_out.value) == 0x00, "uo_out should be 0 when oe=0"

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
