---------------------------------------------------------------------------------------------------------
--- File Name: pSEQMAIN.ads

--- Title: SEQMAIN for GSLV-D3

--- Last modified: 23-11-2007 

--- Version number: GD3_SE_1.1
---------------------------------------------------------------------------------------------------------

with OBCLIB; use OBCLIB;
with pCommandProcess;

package pSEQMAIN is
   Set: constant:= 16#AAAA#;
   NotSet: constant:= 16#5555#;
   -- input variables
   RealTimeCnt: unsigned_32;
   RealTimeCntC: unsigned_32;
   Input_Event: unsigned_16;
   Input_EventC: unsigned_16;
   LMPflg,LMPflgX: unsigned_16;
   Linkerrflg,LinkerrflgX: unsigned_16;       --16#5555#/no link error, 16#AAAA#/link error
   Accln_Failflg,Accln_FailflgX:unsigned_16;     --16#5555#/no accln failure, 16#AAAA#/accln failure
   Acceleration: float32;
   OtherChainHealth,OtherChainHealthX:unsigned_16;  --16#5555#/Other chain healthy, 16#AAAA#/Other chain not healthy
   Guid_Seqflg: unsigned_16;
   Guid_SeqflgC: unsigned_16;
   Salvageflg,SalvageflgX:unsigned_16;        --16#5555#/no salvage error, 16#AAAA#/salvage error
   Algcmd: unsigned_16;
   AlgcmdC: unsigned_16;

   -- output variables
   SeqDAPflg, SeqGuidflg,SeqREXflg, SeqNavflg, SeqCoastNavflg, SeqCUSCEflg: unsigned_16;
   SeqDAPflgC, SeqGuidflgC,SeqREXflgC,SeqNavflgC, SeqCoastNavflgC, SeqCUSCEflgC: unsigned_16;
   AlgASeqCmd,AlgCSeqCmd,AlgKSeqCmd: unsigned_16;
   AlgASeqCmdC,AlgCSeqCmdC,AlgKSeqCmdC: unsigned_16;
   CmdBufferGS2word1,CmdBufferGS2word2: unsigned_16;
   CmdBufferGS2word1C,CmdBufferGS2word2C: unsigned_16;
   CmdBufferEBword1,CmdBufferEBword2,CmdBufferEBword3,CmdBufferEBword4:unsigned_16;
   CmdBufferEBword1C,CmdBufferEBword2C,CmdBufferEBword3C,CmdBufferEBword4C:unsigned_16;
   SelectGS1GS2,SelectGS1GS2X:short_integer;
   Seqerrflg: unsigned_16;
   pragma EXPORT(asm,Seqerrflg,"Seqerrflg");
   TmSeqerrflg:unsigned_16;
   Cmd_cntr:short_integer;
   Seqtmbuf: pCommandProcess.tTelBuf;
   SeqtmbufA: pCommandProcess.tTelBuf;
   Output_Event,Output_EventC: unsigned_16;
   Emergencyflg: unsigned_16;
   EventTime:unsigned_32;

   procedure rSEQINIT;
   pragma EXPORT(asm,rSEQINIT, "rSEQINIT");

   procedure rSEQ;
   procedure rSeqOutputCopy;

   procedure  rRexRead_MjTelBuf;

end pSEQMAIN;