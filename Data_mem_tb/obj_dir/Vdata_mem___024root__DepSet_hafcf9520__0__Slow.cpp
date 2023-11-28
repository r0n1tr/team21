// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdata_mem.h for the primary calling header

#include "verilated.h"

#include "Vdata_mem___024root.h"

VL_ATTR_COLD void Vdata_mem___024root___initial__TOP__0(Vdata_mem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdata_mem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdata_mem___024root___initial__TOP__0\n"); );
    // Init
    VlWide<4>/*127:0*/ __Vtemp_h0c98dd5b__0;
    // Body
    VL_WRITEF("Loading ram...\n");
    __Vtemp_h0c98dd5b__0[0U] = 0x2e6d656dU;
    __Vtemp_h0c98dd5b__0[1U] = 0x72726179U;
    __Vtemp_h0c98dd5b__0[2U] = 0x616d5f61U;
    __Vtemp_h0c98dd5b__0[3U] = 0x72U;
    VL_READMEM_N(true, 8, 256, 0, VL_CVT_PACK_STR_NW(4, __Vtemp_h0c98dd5b__0)
                 ,  &(vlSelf->data_mem__DOT__data_memory)
                 , 0, ~0ULL);
}

VL_ATTR_COLD void Vdata_mem___024root___eval_initial(Vdata_mem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdata_mem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdata_mem___024root___eval_initial\n"); );
    // Body
    Vdata_mem___024root___initial__TOP__0(vlSelf);
    vlSelf->__Vclklast__TOP__clk = vlSelf->clk;
}

void Vdata_mem___024root___combo__TOP__0(Vdata_mem___024root* vlSelf);

VL_ATTR_COLD void Vdata_mem___024root___eval_settle(Vdata_mem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdata_mem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdata_mem___024root___eval_settle\n"); );
    // Body
    Vdata_mem___024root___combo__TOP__0(vlSelf);
}

VL_ATTR_COLD void Vdata_mem___024root___final(Vdata_mem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdata_mem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdata_mem___024root___final\n"); );
}

VL_ATTR_COLD void Vdata_mem___024root___ctor_var_reset(Vdata_mem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdata_mem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdata_mem___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->WE = VL_RAND_RESET_I(1);
    vlSelf->WD = VL_RAND_RESET_I(8);
    vlSelf->A = VL_RAND_RESET_I(8);
    vlSelf->RD = VL_RAND_RESET_I(8);
    for (int __Vi0=0; __Vi0<256; ++__Vi0) {
        vlSelf->data_mem__DOT__data_memory[__Vi0] = VL_RAND_RESET_I(8);
    }
}
