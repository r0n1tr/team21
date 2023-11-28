// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vdata_mem__Syms.h"


void Vdata_mem___024root__trace_chg_sub_0(Vdata_mem___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vdata_mem___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdata_mem___024root__trace_chg_top_0\n"); );
    // Init
    Vdata_mem___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vdata_mem___024root*>(voidSelf);
    Vdata_mem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vdata_mem___024root__trace_chg_sub_0((&vlSymsp->TOP), bufp);
}

void Vdata_mem___024root__trace_chg_sub_0(Vdata_mem___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vdata_mem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdata_mem___024root__trace_chg_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    bufp->chgBit(oldp+0,(vlSelf->clk));
    bufp->chgBit(oldp+1,(vlSelf->WE));
    bufp->chgCData(oldp+2,(vlSelf->WD),8);
    bufp->chgCData(oldp+3,(vlSelf->A),8);
    bufp->chgCData(oldp+4,(vlSelf->RD),8);
}

void Vdata_mem___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdata_mem___024root__trace_cleanup\n"); );
    // Init
    Vdata_mem___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vdata_mem___024root*>(voidSelf);
    Vdata_mem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VlUnpacked<CData/*0:0*/, 1> __Vm_traceActivity;
    // Body
    vlSymsp->__Vm_activity = false;
    __Vm_traceActivity[0U] = 0U;
}
