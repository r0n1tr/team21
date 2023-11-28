// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdata_mem.h for the primary calling header

#include "verilated.h"

#include "Vdata_mem___024root.h"

VL_INLINE_OPT void Vdata_mem___024root___sequent__TOP__0(Vdata_mem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdata_mem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdata_mem___024root___sequent__TOP__0\n"); );
    // Init
    CData/*7:0*/ __Vdlyvdim0__data_mem__DOT__data_memory__v0;
    CData/*7:0*/ __Vdlyvval__data_mem__DOT__data_memory__v0;
    CData/*0:0*/ __Vdlyvset__data_mem__DOT__data_memory__v0;
    // Body
    __Vdlyvset__data_mem__DOT__data_memory__v0 = 0U;
    if (vlSelf->WE) {
        __Vdlyvval__data_mem__DOT__data_memory__v0 
            = vlSelf->WD;
        __Vdlyvset__data_mem__DOT__data_memory__v0 = 1U;
        __Vdlyvdim0__data_mem__DOT__data_memory__v0 
            = vlSelf->A;
    }
    if (__Vdlyvset__data_mem__DOT__data_memory__v0) {
        vlSelf->data_mem__DOT__data_memory[__Vdlyvdim0__data_mem__DOT__data_memory__v0] 
            = __Vdlyvval__data_mem__DOT__data_memory__v0;
    }
}

VL_INLINE_OPT void Vdata_mem___024root___combo__TOP__0(Vdata_mem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdata_mem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdata_mem___024root___combo__TOP__0\n"); );
    // Body
    vlSelf->RD = vlSelf->data_mem__DOT__data_memory
        [vlSelf->A];
}

void Vdata_mem___024root___eval(Vdata_mem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdata_mem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdata_mem___024root___eval\n"); );
    // Body
    if (((IData)(vlSelf->clk) & (~ (IData)(vlSelf->__Vclklast__TOP__clk)))) {
        Vdata_mem___024root___sequent__TOP__0(vlSelf);
    }
    Vdata_mem___024root___combo__TOP__0(vlSelf);
    // Final
    vlSelf->__Vclklast__TOP__clk = vlSelf->clk;
}

#ifdef VL_DEBUG
void Vdata_mem___024root___eval_debug_assertions(Vdata_mem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdata_mem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdata_mem___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->WE & 0xfeU))) {
        Verilated::overWidthError("WE");}
}
#endif  // VL_DEBUG
