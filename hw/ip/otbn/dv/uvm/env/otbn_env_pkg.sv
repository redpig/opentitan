// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package otbn_env_pkg;
  // dep packages
  import uvm_pkg::*;
  import top_pkg::*;
  import dv_utils_pkg::*;
  import csr_utils_pkg::*;
  import dv_lib_pkg::*;
  import dv_base_reg_pkg::*;
  import tl_agent_pkg::*;
  import cip_base_pkg::*;
  import push_pull_agent_pkg::*;
  import otbn_model_agent_pkg::*;
  import otbn_memutil_pkg::*;
  import sram_ctrl_bkdr_util_pkg::sram_ctrl_bkdr_util;
  import prim_util_pkg::vbits;
  import prim_mubi_pkg::*;
  import key_sideload_agent_pkg::*;
  import sec_cm_pkg::*;

  // autogenerated RAL model
  import otbn_reg_pkg::*;
  import otbn_ral_pkg::*;

  import otbn_pkg::WLEN, otbn_pkg::ExtWLEN, otbn_pkg::BaseIntgWidth, otbn_pkg::BaseWordsPerWLEN;
  import otbn_pkg::flags_t;

  import otbn_pkg::status_e;

  import bus_params_pkg::BUS_AW, bus_params_pkg::BUS_DW, bus_params_pkg::BUS_DBW;
  import top_pkg::TL_AIW;

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // Imports for the functions defined in otbn_test_helpers.cc. There are documentation comments
  // explaining what the functions do there.
  import "DPI-C" function chandle OtbnTestHelperMake(string path);
  import "DPI-C" function void OtbnTestHelperFree(chandle helper);
  import "DPI-C" function int OtbnTestHelperCountFilesInDir(chandle helper);
  import "DPI-C" function string OtbnTestHelperGetFilePath(chandle helper, int index);

  // parameters
  parameter uint NUM_ALERTS = otbn_reg_pkg::NumAlerts;
  parameter string LIST_OF_ALERTS[NUM_ALERTS] = {"fatal", "recov"};
  parameter uint NUM_EDN = 2;

  // Number of bits in the otp_ctrl_pkg::otbn_otp_key_rsp_t struct:
  parameter int KEY_RSP_DATA_SIZE = $bits(otp_ctrl_pkg::otbn_otp_key_rsp_t);

  // typedefs
  typedef virtual otbn_ssctrl_if   ssctrl_vif;
  typedef virtual otbn_escalate_if escalate_vif;
  typedef logic [TL_AIW-1:0]       tl_source_t;
  typedef key_sideload_agent#(keymgr_pkg::otbn_key_req_t) otbn_sideload_agent;
  typedef key_sideload_agent_cfg#(keymgr_pkg::otbn_key_req_t) otbn_sideload_agent_cfg;

  typedef push_pull_agent#(.DeviceDataWidth(KEY_RSP_DATA_SIZE)) otp_key_agent;
  typedef push_pull_agent_cfg#(.DeviceDataWidth(KEY_RSP_DATA_SIZE)) otp_key_agent_cfg;
  typedef virtual push_pull_if#(.DeviceDataWidth(KEY_RSP_DATA_SIZE)) otp_key_vif;

  // Expected data for a pending read (see exp_read_values in otbn_scoreboard.sv)
  typedef struct packed {
    bit                upd;
    logic              chk;
    logic [BUS_DW-1:0] val;
  } otbn_exp_read_data_t;

  // Used for coverage in otbn_env_cov.sv (where we need to convert strings giving mnemonics and CSR
  // names to a packed integral type)
  parameter int unsigned MNEM_STR_LEN = 16;
  typedef bit [MNEM_STR_LEN*8-1:0] mnem_str_t;

  parameter int unsigned CSR_STR_LEN = 20;
  typedef bit [CSR_STR_LEN*8-1:0] csr_str_t;

  // A very simple wrapper around a word that has been loaded from the input binary and needs
  // storing to OTBN's IMEM or DMEM.
  typedef struct packed {
    // Is this destined for IMEM?
    bit           for_imem;
    // The (word) offset within the destination memory
    bit [21:0]    offset;
    // The data to be loaded
    bit [31:0]    data;

  } otbn_loaded_word;

  // The mapping from EDN agent indices to RND / URND connections
  typedef enum {
    RndEdnIdx,
    UrndEdnIdx
  } edn_idx_e;

  typedef enum {
    StackEmpty,
    StackPartial,
    StackFull
  } stack_fullness_e;

  typedef struct packed {
    logic pop_a;
    logic pop_b;
    logic push;
  } call_stack_flags_t;

  typedef enum {
    OperationalStateIdle,
    OperationalStateBusy,
    OperationalStateLocked
  } operational_state_e;

  function automatic operational_state_e get_operational_state(status_e status);
    unique case (status)
      otbn_pkg::StatusBusyExecute,
      otbn_pkg::StatusBusySecWipeDmem,
      otbn_pkg::StatusBusySecWipeImem,
      otbn_pkg::StatusBusySecWipeInt:
        return OperationalStateBusy;

      otbn_pkg::StatusLocked:
        return OperationalStateLocked;

      otbn_pkg::StatusIdle:
        return OperationalStateIdle;
      default: ;
    endcase
  endfunction

  typedef enum {
    AccessSoftwareRead,
    AccessSoftwareWrite
  } access_e;

  // Forward declaration to allow the config to hold a scoreboard handle.
  typedef class otbn_scoreboard;

  localparam int unsigned ImemSizeByte = int'(otbn_reg_pkg::OTBN_IMEM_SIZE);
  localparam int unsigned DmemSizeByte =
    int'(otbn_reg_pkg::OTBN_DMEM_SIZE) + otbn_pkg::DmemScratchSizeByte;

  parameter int unsigned ImemIndexWidth = vbits(ImemSizeByte / 4);
  parameter int unsigned DmemIndexWidth = vbits(DmemSizeByte / 32);

  // package sources
  `include "otbn_env_cfg.sv"
  `include "otbn_trace_item.sv"
  `include "otbn_env_cov.sv"
  `include "otbn_trace_monitor.sv"
  `include "otbn_virtual_sequencer.sv"
  `include "otbn_scoreboard.sv"
  `include "otbn_env.sv"

  `include "otbn_vseq_list.sv"

endpackage
