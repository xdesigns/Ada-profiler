---------------------------------------------------------------------------------------------------------
--- File Name: pSEQMAIN.adb

--- Title: SEQMAIN for GSLV-D3

--- Last modified: 23-11-2007

--- Version number: GD3_SE_1.2
---------------------------------------------------------------------------------------------------------

with pEventDetection;
with pCommandProcess;

package body pSEQMAIN is

   procedure rSeqOutputCopy is
   begin
      SeqDAPflg:= pCommandProcess.SeqDAPflg;
      SeqDAPflgC:= pCommandProcess.SeqDAPflgC;
      SeqGuidflg:= pCommandProcess.SeqGuidflg;
      SeqGuidflgC:= pCommandProcess.SeqGuidflgC;
      SeqREXflg:= pCommandProcess.SeqREXflg;
      SeqREXflgC:= pCommandProcess.SeqREXflgC;
      SeqNavflg:= pCommandProcess.SeqNavflg;
      SeqNavflgC:= pCommandProcess.SeqNavflgC;
      SeqCoastNavflg:= pCommandProcess.SeqCoastNavflg;
      SeqCoastNavflgC:= pCommandProcess.SeqCoastNavflgC;
      SeqCUSCEflg:= pCommandProcess.SeqCUSCEflg;
      SeqCUSCEflgC:= pCommandProcess.SeqCUSCEflgC;
      AlgASeqCmd:= pCommandProcess.AlgASeqCmd;
      AlgASeqCmdC:= pCommandProcess.AlgASeqCmdC;
      AlgCSeqCmd:= pCommandProcess.AlgCSeqCmd;
      AlgCSeqCmdC:= pCommandProcess.AlgCSeqCmdC;
      AlgKSeqCmd:= pCommandProcess.AlgKSeqCmd;
      AlgKSeqCmdC:= pCommandProcess.AlgKSeqCmdC;
      CmdBufferGS2word1:= pCommandProcess.CmdBufferGS2word1;
      CmdBufferGS2word1C:= pCommandProcess.CmdBufferGS2word1C;
      CmdBufferGS2word2:= pCommandProcess.CmdBufferGS2word2;
      CmdBufferGS2word2C:= pCommandProcess.CmdBufferGS2word2C;
      CmdBufferEBword1:= pCommandProcess.CmdBufferEBword1;
      CmdBufferEBword1C:= pCommandProcess.CmdBufferEBword1C;
      CmdBufferEBword2:= pCommandProcess.CmdBufferEBword2;
      CmdBufferEBword2C:= pCommandProcess.CmdBufferEBword2C;
      CmdBufferEBword3:= pCommandProcess.CmdBufferEBword3;
      CmdBufferEBword3C:= pCommandProcess.CmdBufferEBword3C;
      CmdBufferEBword4:= pCommandProcess.CmdBufferEBword4;
      CmdBufferEBword4C:= pCommandProcess.CmdBufferEBword4C;

      SelectGS1GS2:=pCommandProcess.SelectGS1GS2;
      SelectGS1GS2X:=pCommandProcess.SelectGS1GS2X;
      Seqerrflg:=pCommandProcess.Seqerrflg;
      TmSeqerrflg:=pCommandProcess.TmSeqerrflg;
      Cmd_cntr:=pCommandProcess.Cmd_cntr;
      Output_Event:= pEventDetection.Output_Event;
      Output_EventC:= pEventDetection.Output_EventC;
      Emergencyflg := pEventDetection.Emergencyflg;
      EventTime := pEventDetection.EventTime;
   end rSeqOutputCopy;
   ----------------------------------------------------------------------------------------------

   procedure rSEQINIT is
   begin
      pEventDetection.rEventDetectionInit;
      pCommandProcess.rCommandProcessInit;

      pEventDetection.rEventListIntegrity;   --one time integrity check for EventList and EventListX
      pCommandprocess.rSeqCmdIntegrity;      --one time integrity check for SeqCmdTable and SeqCmdBarTable
      rSeqOutputCopy;
   end rSEQINIT;
   ----------------------------------------------------------------------------------------------

   procedure rSEQ is
   begin
      pCommandProcess.Seqerrflg := NotSet; -- non sticky
      pEventDetection.rEventController;
      if pCommandProcess.Seqerrflg = NotSet then
         pCommandProcess.rCmdController;
      end if;
      if pCommandProcess.Seqerrflg = NotSet then
         rSeqOutputCopy;                     --outputs copied in no error condition
      else
         Seqerrflg:=pCommandProcess.Seqerrflg;
         TmSeqerrflg:=pCommandProcess.TmSeqerrflg;
      end if;
   end rSEQ;
   ----------------------------------------------------------------------------------------------

   --This module is called by REX once in a major cycle for telemetry
   --transfers cmd time, cmd type, cmd num of executed commands  
   procedure rRexRead_MjTelBuf is
   begin
     pCommandProcess.rRead_MjTelBuf;
     Seqtmbuf:= pCommandProcess.Seqtmbuf;
     SeqtmbufA:= pCommandProcess.SeqtmbufA; --commands corresponding to Algcmd
   end rRexRead_MjTelBuf;
   ----------------------------------------------------------------------------------------------
end pSEQMAIN;