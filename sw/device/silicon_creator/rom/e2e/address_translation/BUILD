# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load(
    "//rules/opentitan:defs.bzl",
    "cw310_params",
    "fpga_params",
    "opentitan_test",
)
load(
    "//rules:const.bzl",
    "CONST",
    "hex",
    "hex_digits",
)
load(
    "//sw/device/silicon_creator/rom/e2e:defs.bzl",
    "MSG_STARTING_ROM_EXT",
    "MSG_TEMPLATE_BFV",
    "SLOTS",
)

package(default_visibility = ["//visibility:public"])

opentitan_test(
    name = "rom_ext_a_flash_a",
    exec_env = {
        "//hw/top_earlgrey:fpga_cw310_rom_ext": None,
        "//hw/top_earlgrey:fpga_cw340_rom_ext": None,
    },
    fpga = fpga_params(
        assemble = "{firmware}@{offset}",
        binaries = {
            "//sw/device/silicon_creator/rom_ext:rom_ext_slot_a": "firmware",
        },
        exit_failure = CONST.SHUTDOWN.PREFIX.BFV,
        exit_success = MSG_STARTING_ROM_EXT,
        offset = SLOTS["a"],
    ),
)

opentitan_test(
    name = "rom_ext_b_flash_b",
    exec_env = {
        "//hw/top_earlgrey:fpga_cw310_rom_ext": None,
        "//hw/top_earlgrey:fpga_cw340_rom_ext": None,
    },
    fpga = fpga_params(
        assemble = "{firmware}@{offset}",
        binaries = {
            "//sw/device/silicon_creator/rom_ext:rom_ext_slot_b": "firmware",
        },
        exit_failure = CONST.SHUTDOWN.PREFIX.BFV,
        exit_success = MSG_STARTING_ROM_EXT,
        offset = SLOTS["b"],
    ),
)

opentitan_test(
    name = "rom_ext_a_flash_b",
    exec_env = {
        "//hw/top_earlgrey:fpga_cw310_rom_ext": None,
        "//hw/top_earlgrey:fpga_cw340_rom_ext": None,
    },
    fpga = fpga_params(
        assemble = "{firmware}@{offset}",
        binaries = {
            "//sw/device/silicon_creator/rom_ext:rom_ext_slot_a": "firmware",
        },
        exit_failure = MSG_STARTING_ROM_EXT,
        exit_success = MSG_TEMPLATE_BFV.format(hex_digits(CONST.BFV.INTERRUPT.STORE_ACCESS)),
        offset = SLOTS["b"],
    ),
)

opentitan_test(
    name = "rom_ext_b_flash_a",
    exec_env = {
        "//hw/top_earlgrey:fpga_cw310_rom_ext": None,
        "//hw/top_earlgrey:fpga_cw340_rom_ext": None,
    },
    fpga = fpga_params(
        assemble = "{firmware}@{offset}",
        binaries = {
            "//sw/device/silicon_creator/rom_ext:rom_ext_slot_b": "firmware",
        },
        exit_failure = MSG_STARTING_ROM_EXT,
        exit_success = MSG_TEMPLATE_BFV.format(hex_digits(CONST.BFV.INTERRUPT.STORE_ACCESS)),
        offset = SLOTS["a"],
    ),
)

opentitan_test(
    name = "rom_ext_v_flash_a",
    exec_env = {
        "//hw/top_earlgrey:fpga_cw310_rom_ext": None,
        "//hw/top_earlgrey:fpga_cw340_rom_ext": None,
    },
    fpga = fpga_params(
        assemble = "{firmware}@{offset}",
        binaries = {
            "//sw/device/silicon_creator/rom_ext:rom_ext_slot_virtual": "firmware",
        },
        exit_failure = CONST.SHUTDOWN.PREFIX.BFV,
        exit_success = MSG_STARTING_ROM_EXT,
        offset = SLOTS["a"],
    ),
)

opentitan_test(
    name = "rom_ext_v_flash_b",
    exec_env = {
        "//hw/top_earlgrey:fpga_cw310_rom_ext": None,
        "//hw/top_earlgrey:fpga_cw340_rom_ext": None,
    },
    fpga = fpga_params(
        assemble = "{firmware}@{offset}",
        binaries = {
            "//sw/device/silicon_creator/rom_ext:rom_ext_slot_virtual": "firmware",
        },
        exit_failure = CONST.SHUTDOWN.PREFIX.BFV,
        exit_success = MSG_STARTING_ROM_EXT,
        offset = SLOTS["b"],
    ),
)

opentitan_test(
    name = "rom_ext_a_flash_a_bad_addr_trans",
    exec_env = {
        "//hw/top_earlgrey:fpga_cw310_rom_ext": None,
        "//hw/top_earlgrey:fpga_cw340_rom_ext": None,
    },
    fpga = fpga_params(
        assemble = "{firmware}@{offset}",
        binaries = {
            "//sw/device/silicon_creator/rom_ext:rom_ext_slot_a_bad_address_translation": "firmware",
        },
        exit_failure = MSG_STARTING_ROM_EXT,
        exit_success = MSG_TEMPLATE_BFV.format(hex_digits(CONST.BFV.INTERRUPT.ILLEGAL_INSTRUCTION)),
        offset = SLOTS["a"],
    ),
)

test_suite(
    name = "address_translation",
    tags = ["manual"],
    tests = [
        "rom_ext_a_flash_a",
        "rom_ext_a_flash_a_bad_addr_trans",
        "rom_ext_a_flash_b",
        "rom_ext_b_flash_a",
        "rom_ext_b_flash_b",
        "rom_ext_v_flash_a",
        "rom_ext_v_flash_b",
    ],
)
