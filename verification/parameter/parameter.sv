////////////////////////////////////////////////////////////////////////////////
//
// Filename : parameter.sv
// Author : Asmara Rauf
// Creation Date : 11/13/2024
//
// Description
// ===========
// This module contain parameters that is used in various SPI components and environment.
//
// ///////////////////////////////////////////////////////////////////////////////


parameter logic [2:0] SPR  = 0;
parameter logic [2:0] SPPR = 0;
parameter int DATA_WIDTH = 8;

parameter real BAUD_RATE  = 50000; //20 MHz
parameter real BAUD_DIVISOR = (SPPR+1) * (2**(SPR+1)); //2
