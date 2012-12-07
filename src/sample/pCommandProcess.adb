---------------------------------------------------------------------------------------------------------
--- File Name: pCommandProcess.adb

--- Title: CommandProcess for GSLV-D3

--- Last modified: 23-11-2007

--- Version number: GD3_SE_1.2
---------------------------------------------------------------------------------------------------------
with OBCLIB; use OBCLIB;
with pSeqmain;
with pEventDetection;

package body pCommandProcess is



--   Spill1Offset_timer,Spill1Offset_timerC: unsigned_16;
--   Spill2Offset_timer,Spill2Offset_timerC :unsigned_16;
--   Spill1Tab_ptr1,Spill1Tab_ptr2 : unsigned_16;
--   Spill2Tab_ptr1,Spill2Tab_ptr2 : unsigned_16;

   type tCmdPatternArray is array (short_integer range 0 .. 15) of unsigned_16;
   ORCmdPatternArray: constant tCmdPatternArray := (16#0001#,16#0002#,16#0004#,16#0008#,
                                                    16#0010#,16#0020#,16#0040#,16#0080#,
                                                    16#0100#,16#0200#,16#0400#,16#0800#,
                                                    16#1000#,16#2000#,16#4000#,16#8000#);
   ANDCmdPatternArray: constant tCmdPatternArray := (16#FFFE#,16#FFFD#,16#FFFB#,16#FFF7#,
                                                     16#FFEF#,16#FFDF#,16#FFBF#,16#FF7F#,
                                                     16#FEFF#,16#FDFF#,16#FBFF#,16#F7FF#,
                                                     16#EFFF#,16#DFFF#,16#BFFF#,16#7FFF#);
   Algcmd186Open: constant :=16#0100#;
   Algcmd186Close: constant :=16#0001#;
   Algcmd187Open: constant :=16#0400#;
   Algcmd187Close: constant :=16#0004#;
   Algcmd500Close: constant :=16#1000#;

--   tTelBufferRange: constant := 40;
--   type tTelBuffer is array (short_integer range 1..tTelBufferRange) of tTelBuf;
--   SeqTelBuffer, AlgTelBuffer: tTelBuffer;

   --------------------------------------------------------------------------------------------------------

   --checkout init

-------------------------------------------------------------------------------------------------------------------


--   procedure rClearEPVCmd;
--   procedure rClearEPVCmdBar;
--   procedure rLoad_MjTelBuf (TelBuffer: in out tTelBuffer; BufWrite_Ptr: in out short_integer;
--                            BufRead_Ptr: in short_integer; CmdType,CmdNum: in unsigned_16);



   ------------------------------------------------------------------------------------------------------------

   --This module is called by rSEQ to carry out the Command Table Processing
   --This module is called by rSEQ to carry out the Command Table Processing
   procedure rCmdController is
   begin
      if Num_cmd/= 0 then
         rTableProcess(Num_cmd,Tab_ptr1,Offset_timer);
         Offset_timer := Offset_timer + 1;
      end if;
      if Num_cmdC/= 16#FFFF# then
         rComplTableProcess(Num_cmdC,Tab_ptr2,Offset_timerC);
         Offset_timerC := Offset_timerC - 1;
      end if;

      if Spill1Num_cmd /= 0 then            -- table processing for first spillover
         rTableProcess(Spill1Num_cmd,Spill1Tab_ptr1,Spill1Offset_timer);
         Spill1Offset_timer := Spill1Offset_timer + 1;
      end if;
      if Spill1Num_cmdC /= 16#FFFF# then   -- table processing for first spillover
         rComplTableProcess(Spill1Num_cmdC,Spill1Tab_ptr2,Spill1Offset_timerC);
         Spill1Offset_timerC := Spill1Offset_timerC - 1;
      end if;

      if Spill2Num_cmd /= 0 then         -- table processing for second spillover
         rTableProcess(Spill2Num_cmd,Spill2Tab_ptr1,Spill2Offset_timer);
         Spill2Offset_timer := Spill2Offset_timer + 1;
      end if;
      if Spill2Num_cmdC /= 16#FFFF# then   -- table processing for second spillover
         rComplTableProcess(Spill2Num_cmdC,Spill2Tab_ptr2,Spill2Offset_timerC);
         Spill2Offset_timerC := Spill2Offset_timerC - 1;
      end if;

      if SeqInternalflg /= 0 then
         pEventDetection.rEnginePerfCheck;
      end if;
      if SeqInternalflgC /= 16#FFFF# then
         pEventDetection.rEnginePerfCheckX;
      end if;

      rClearEPVCmd;
      rClearEPVCmdBar;

      if (pSeqmain.Algcmd /= 0) then
         rAlgCmdProcess;
      end if;

      if (pSeqmain.AlgcmdC /= 16#FFFF#) then
         rAlgCmdBarProcess;
      end if;

      rOutputCheck;

   end rCmdController;
   -----------------------------------------------------------------------------------------------------------

   --This Module performs Command Table Processing with SeqCmdTable: stream1
   --Sets the Software flags, calls module to set/ clear the Hardware commands
   procedure rTableProcess (Numcmd,Tabptr1: in out unsigned_16; Offsettimer :in unsigned_16) is
   Cmdtable_copy:tCmdData;
   begin
   while Numcmd /=0 loop
      Cmdtable_copy:=SeqCmdTable(Tabptr1);

      if Offsettimer >= Cmdtable_copy.Cmd_time then

        case Cmdtable_copy.Cmd_type is

           when 16#01#| 16#03# =>
               rHwCmdProcess(Cmdtable_copy.Cmd_type,Cmdtable_copy.Cmd_num);

           when 16#02#| 16#04# =>
               rHwCmdClear(Cmdtable_copy.Cmd_type,Cmdtable_copy.Cmd_num);

           when 16#05# =>
               SeqDAPflg := Cmdtable_copy.Cmd_num;

           when 16#06# =>
               SeqGuidflg := Cmdtable_copy.Cmd_num;

           when 16#07# =>
               SeqNavflg := Cmdtable_copy.Cmd_num;

           when 16#08# =>
               SeqCoastNavflg := Cmdtable_copy.Cmd_num;

           when 16#09# =>
               SeqREXflg := Cmdtable_copy.Cmd_num;

           when 16#0A# =>
               SeqCUSCEflg := Cmdtable_copy.Cmd_num;

           when 16#0B# =>
               SeqInternalflg := Cmdtable_copy.Cmd_num;

           when 16#0C# =>
               AlgASeqCmd := Cmdtable_copy.Cmd_num;

           when 16#0D# =>
               AlgCSeqCmd := Cmdtable_copy.Cmd_num;

           when 16#0E# =>
               AlgKSeqCmd := Cmdtable_copy.Cmd_num;

           when others =>
              rSetSeqerror(5);
        end case;

        rLoad_MjTelBuf(SeqtelBuffer,SeqBufWrite_Ptr,SeqBufRead_Ptr,Cmdtable_copy.Cmd_type,Cmdtable_copy.Cmd_num);
                                                              -- telemetry of executed commands
        Cmd_cntr := Cmd_cntr + 1;

        Numcmd := Numcmd - 1;
        Tabptr1 := Tabptr1 + 1;

      else
         exit;
      end if;
   end loop;

   end rTableProcess;
   -------------------------------------------------------------------------------------------------------

   --This Module performs Command Table Processing with SeqCmdBarTable: stream2
   --Sets the Software flag complements, calls module to set/ clear the Hardware command complement
   procedure rComplTableProcess (NumcmdC,Tabptr2: in out unsigned_16; OffsettimerC :in unsigned_16) is
   Cmdbartable_copy:tCmdBarData;
   begin
   while NumcmdC /=16#FFFF# loop
      Cmdbartable_copy:=SeqCmdBarTable(Tabptr2);

      if OffsettimerC <= Cmdbartable_copy.Cmd_timeC then

        case Cmdbartable_copy.Cmd_typeC is

           when 16#FFFE#| 16#FFFC# =>
              rHwCmdBarProcess(Cmdbartable_copy.Cmd_typeC,Cmdbartable_copy.Cmd_numC);

           when 16#FFFD#| 16#FFFB# =>
              rHwCmdBarClear(Cmdbartable_copy.Cmd_typeC,Cmdbartable_copy.Cmd_numC);

           when 16#FFFA# =>
              SeqDAPflgC:= Cmdbartable_copy.Cmd_numC;

           when 16#FFF9# =>
              SeqGuidflgC:= Cmdbartable_copy.Cmd_numC;

           when 16#FFF8# =>
              SeqNavflgC:= Cmdbartable_copy.Cmd_numC;

           when 16#FFF7# =>
              SeqCoastNavflgC := Cmdbartable_copy.Cmd_numC;

           when 16#FFF6# =>
              SeqREXflgC:= Cmdbartable_copy.Cmd_numC;

           when 16#FFF5#=>
              SeqCUSCEflgC:= Cmdbartable_copy.Cmd_numC;

           when 16#FFF4# =>
              SeqInternalflgC:= Cmdbartable_copy.Cmd_numC;

           when 16#FFF3# =>
              AlgASeqCmdC:= Cmdbartable_copy.Cmd_numC;

           when 16#FFF2# =>
              AlgCSeqCmdC:= Cmdbartable_copy.Cmd_numC;

           when 16#FFF1# =>
              AlgKSeqCmdC:= Cmdbartable_copy.Cmd_numC;

           when others =>
              rSetSeqerror(5);
         end case;

         NumcmdC := NumcmdC + 1;
         Tabptr2 := Tabptr2 + 1;

      else
         exit;
     end if;
   end loop;
   end rComplTableProcess;
   -------------------------------------------------------------------------------------------------------

   --This module identifies the hardware command word and the bit position in the hardware 
   --command word to be set based on command type and command number: stream1
   procedure rHwCmdProcess(Cmdtype,Cmdnum: in unsigned_16) is
   Selectbit,Selectword:short_integer;
   begin
      Selectword := (U16TOS16(Cmdnum) - 1)/16 + 1;
      Selectbit := (U16TOS16(Cmdnum) -1) rem 16;

      case Cmdtype is

         when 16#1# =>

            case Selectword is
               when 1 => SelectGS1GS2 := Selectword;
                         CmdBufferGS2word1 := Bit_OR (CmdBufferGS2word1,ORCmdPatternArray(Selectbit));
               when 2 => SelectGS1GS2 := Selectword;
                         CmdBufferGS2word2 := Bit_OR (CmdBufferGS2word2,ORCmdPatternArray(Selectbit));
               when others => rSetSeqerror(6);
            end case;

         when 16#3# =>

            case Selectword is
               when 1 => CmdBufferEBword1 := Bit_OR (CmdBufferEBword1,ORCmdPatternArray(Selectbit));
               when 2 => CmdBufferEBword2 := Bit_OR (CmdBufferEBword2,ORCmdPatternArray(Selectbit));
               when 3 => CmdBufferEBword3 := Bit_OR (CmdBufferEBword3,ORCmdPatternArray(Selectbit));
               when 4 => CmdBufferEBword4 := Bit_OR (CmdBufferEBword4,ORCmdPatternArray(Selectbit));
               when others => rSetSeqerror(6);
            end case;

         when others => null;
      end case;
   end rHwCmdProcess;
   ---------------------------------------------------------------------------------------------------------

   --This module identifies the hardware command word complement and the bit position in the hardware 
   --command word complement to be cleared,based on command type complement and command number complement: stream2
   procedure rHwCmdBarProcess(CmdtypeC,CmdnumC: in unsigned_16)is
   Selectbit,Selectword: short_integer;
   begin
      Selectword := (U16TOS16(16#FFFF#-CmdnumC) - 1)/16 + 1;
      Selectbit := (U16TOS16(16#FFFF#-CmdnumC) -1) rem 16;

      case CmdtypeC is

         when 16#FFFE# =>
            case Selectword is
               when 1 => SelectGS1GS2X:=Selectword;
                         CmdBufferGS2word1C := Bit_AND(CmdBufferGS2word1C,ANDCmdPatternArray(Selectbit));
               when 2 => SelectGS1GS2X:=Selectword;
                         CmdBufferGS2word2C := Bit_AND(CmdBufferGS2word2C,ANDCmdPatternArray(Selectbit));
               when others => rSetSeqerror(6);
            end case;

         when 16#FFFC# =>
            case Selectword is
               when 1 => CmdBufferEBword1C := Bit_AND(CmdBufferEBword1C,ANDCmdPatternArray(Selectbit));
               when 2 => CmdBufferEBword2C := Bit_AND(CmdBufferEBword2C,ANDCmdPatternArray(Selectbit));
               when 3 => CmdBufferEBword3C := Bit_AND(CmdBufferEBword3C,ANDCmdPatternArray(Selectbit));
               when 4 => CmdBufferEBword4C := Bit_AND(CmdBufferEBword4C,ANDCmdPatternArray(Selectbit));
               when others => rSetSeqerror(6);
            end case;

         when others => null;
      end case;
   end rHwCmdBarProcess;
   ---------------------------------------------------------------------------------------------------------

   --This module is called to clear a hardware command
   --This module identifies the hardware command word and the bit position in the hardware 
   --command word to be cleared, based on command type and command number: stream1
   procedure rHwCmdClear(Cmdtype,Cmdnum: in unsigned_16) is
   Selectbit,Selectword: short_integer;
   begin
      Selectword := (U16TOS16(Cmdnum) - 1)/16 + 1;
      Selectbit := (U16TOS16(Cmdnum) -1) rem 16;

      case Cmdtype is
         when 16#2# =>
            case Selectword is
               when 1 => SelectGS1GS2 := Selectword;
                         CmdBufferGS2word1 := Bit_AND(CmdBufferGS2word1,ANDCmdPatternArray(Selectbit));
               when 2 => SelectGS1GS2 := Selectword;
                         CmdBufferGS2word2 := Bit_AND(CmdBufferGS2word2,ANDCmdPatternArray(Selectbit));
               when others => rSetSeqerror(6);
            end case;

         when 16#4# =>
            case Selectword is
               when 1 => CmdBufferEBword1 := Bit_AND(CmdBufferEBword1,ANDCmdPatternArray(Selectbit));
               when 2 => CmdBufferEBword2 := Bit_AND(CmdBufferEBword2,ANDCmdPatternArray(Selectbit));
               when 3 => CmdBufferEBword3 := Bit_AND(CmdBufferEBword3,ANDCmdPatternArray(Selectbit));
               when 4 => CmdBufferEBword4 := Bit_AND(CmdBufferEBword4,ANDCmdPatternArray(Selectbit));
               when others => rSetSeqerror(6);
            end case;

         when others => null;
      end case;
   end rHwCmdClear;
---------------------------------------------------------------------------------------------------------

   --This module is called to clear a hardware command :stream2
   --This module identifies the hardware command word complement and the bit position in the hardware 
   --command word complement, based on command type complement and command number complement: stream2
   procedure rHwCmdBarClear(CmdtypeC,CmdnumC: in unsigned_16) is
   Selectbit,Selectword: short_integer;
   begin
   Selectword := (U16TOS16(16#FFFF#-CmdnumC) - 1)/16 + 1;
   Selectbit := (U16TOS16(16#FFFF#-CmdnumC) -1) rem 16;

      case CmdtypeC is
         when 16#FFFD# =>
            case Selectword is
               when 1 => SelectGS1GS2X := Selectword;
                         CmdbufferGS2word1C := Bit_OR (CmdBufferGS2word1C,ORCmdPatternArray(Selectbit));
               when 2 => SelectGS1GS2X := Selectword;
                         CmdbufferGS2word2C := Bit_OR (CmdBufferGS2word2C,ORCmdPatternArray(Selectbit));
               when others => rSetSeqerror(6);
            end case;

         when 16#FFFB# =>
            case Selectword is
               when 1 => CmdbufferEBword1C := Bit_OR (CmdBufferEBword1C,ORCmdPatternArray(Selectbit));
               when 2 => CmdbufferEBword2C := Bit_OR (CmdBufferEBword2C,ORCmdPatternArray(Selectbit));
               when 3 => CmdbufferEBword3C := Bit_OR (CmdBufferEBword3C,ORCmdPatternArray(Selectbit));
               when 4 => CmdbufferEBword4C := Bit_OR (CmdBufferEBword4C,ORCmdPatternArray(Selectbit));
               when others => rSetSeqerror(6);
            end case;

         when others => null;
      end case;
   end rHwCmdBarClear;
---------------------------------------------------------------------------------------------------------

   --This module processes the Algcmd from Cryo Pneumo Algorithm. Stream1
   --Sets corresponding bit of CmdBufferEB.
   procedure rAlgCmdProcess is
   begin
     if Bit_AND(pSeqmain.Algcmd, Algcmd186Open)= Algcmd186Open then
         CmdBufferEBword4 := Bit_OR (CmdBufferEBword4,16#0004#);      --driver no. 51
         CmdBufferEBword4 := Bit_AND(CmdBufferEBword4,16#FFF7#);      --clearing the complementary driver (52)
         EPV186OpenCntr1:=10;
         rLoad_MjTelBuf(AlgTelBuffer,AlgBufWrite_Ptr,AlgBufRead_Ptr,3,51);
      end if;

      if Bit_AND(pSeqmain.Algcmd, Algcmd186Close) = Algcmd186Close then
         CmdBufferEBword4 := Bit_OR (CmdBufferEBword4,16#0008#);      --driver no. 52
         CmdBufferEBword4 := Bit_AND(CmdBufferEBword4,16#FFFB#);      --clearing the complementary driver (51)
         EPV186CloseCntr1:=10;
         rLoad_MjTelBuf(AlgTelBuffer,AlgBufWrite_Ptr,AlgBufRead_Ptr,3,52);
      end if;

      if Bit_AND(pSeqmain.Algcmd, Algcmd187Open) = Algcmd187Open  then
         CmdBufferEBword4 := Bit_OR (CmdBufferEBword4,16#0040#);      --driver no. 55
         CmdBufferEBword4 := Bit_AND(CmdBufferEBword4,16#FF7F#);      --clearing the complementary driver (56)
         EPV187OpenCntr1:=10;
         rLoad_MjTelBuf(AlgTelBuffer,AlgBufWrite_Ptr,AlgBufRead_Ptr,3,55);
      end if;

      if Bit_AND(pSeqmain.Algcmd, Algcmd187Close) = Algcmd187Close then
         CmdBufferEBword4 := Bit_OR (CmdBufferEBword4,16#0080#);      --driver no. 56
         CmdBufferEBword4 := Bit_AND(CmdBufferEBword4,16#FFBF#);      --clearing the complementary driver (55)
         EPV187CloseCntr1:=10;
         rLoad_MjTelBuf(AlgTelBuffer,AlgBufWrite_Ptr,AlgBufRead_Ptr,3,56);
      end if;

      if Bit_AND(pSeqmain.Algcmd, Algcmd500Close)= Algcmd500Close then
         CmdBufferEBword2 := Bit_OR (CmdBufferEBword2,16#8000#);      --driver no. 32
         EPV500CloseCntr1:=10;
         rLoad_MjTelBuf(AlgTelBuffer,AlgBufWrite_Ptr,AlgBufRead_Ptr,3,32);
      end if;
   end rAlgCmdProcess;
   ---------------------------------------------------------------------------------------------------------

   --This module clears the command corresponding to Algcmd after 10 minor cycles: stream1
   procedure rClearEPVCmd is
   begin
   if EPV186OpenCntr1 /= 0 then
      EPV186OpenCntr1:=EPV186OpenCntr1 -1;
      if EPV186OpenCntr1 = 0 then
         CmdBufferEBword4 := Bit_AND(CmdBufferEBword4,16#FFFB#);
      end if;
   end if;

   if EPV186CloseCntr1 /= 0 then
      EPV186CloseCntr1:=EPV186CloseCntr1 -1;
      if EPV186CloseCntr1 = 0 then
         CmdBufferEBword4 := Bit_AND(CmdBufferEBword4,16#FFF7#);
      end if;
   end if;

   if EPV187OpenCntr1 /= 0 then
      EPV187OpenCntr1:=EPV187OpenCntr1 -1;
      if EPV187OpenCntr1 = 0 then
         CmdBufferEBword4 := Bit_AND(CmdBufferEBword4,16#FFBF#);
      end if;
   end if;

   if EPV187CloseCntr1 /= 0 then
      EPV187CloseCntr1:=EPV187CloseCntr1 -1;
      if EPV187CloseCntr1 = 0 then
         CmdBufferEBword4 := Bit_AND(CmdBufferEBword4,16#FF7F#);
      end if;
   end if;

   if EPV500CloseCntr1 /= 0 then
      EPV500CloseCntr1:=EPV500CloseCntr1 -1;
      if EPV500CloseCntr1 = 0 then
         CmdBufferEBword2 := Bit_AND(CmdBufferEBword2,16#7FFF#);
      end if;
   end if;
   end rClearEPVCmd;
   ---------------------------------------------------------------------------------------------------------

   --This module processes the AlgcmdC from Cryo Pneumo Algorithm. Stream2
   --Clears corresponding bit of CmdBufferEBwordC.
   procedure rAlgCmdBarProcess is
   AlgcmdInt: unsigned_16;
   begin
      AlgcmdInt := 16#FFFF#-pSeqmain.AlgcmdC;
      if Bit_AND(AlgcmdInt, Algcmd186Open)= Algcmd186Open then
         CmdBufferEBword4C := Bit_AND(CmdBufferEBword4C,16#FFFB#);      --driver no. 51
         CmdBufferEBword4C := Bit_OR (CmdBufferEBword4C,16#0008#);      --removal of complementary driver command (52)
         EPV186OpenCntr2:=10;
      end if;

      if Bit_AND(AlgcmdInt, Algcmd186Close) = Algcmd186Close then
         CmdBufferEBword4C := Bit_AND(CmdBufferEBword4C,16#FFF7#);      --driver no. 52
         CmdBufferEBword4C := Bit_OR (CmdBufferEBword4C,16#0004#);      --removal of complementary driver command (51)
         EPV186CloseCntr2:=10;
      end if;

      if Bit_AND(AlgcmdInt, Algcmd187Open) = Algcmd187Open   then
         CmdBufferEBword4C := Bit_AND(CmdBufferEBword4C,16#FFBF#);      --driver no. 55
         CmdBufferEBword4C := Bit_OR (CmdBufferEBword4C,16#0080#);      --removal of complementary driver command (56)
         EPV187OpenCntr2:=10;
      end if;

      if Bit_AND(AlgcmdInt, Algcmd187Close) = Algcmd187Close then
         CmdBufferEBword4C := Bit_AND(CmdBufferEBword4C,16#FF7F#);      --driver no. 56      
         CmdBufferEBword4C := Bit_OR (CmdBufferEBword4C,16#0040#);      --removal of complementary driver command (55)
         EPV187CloseCntr2:=10;
      end if;

      if Bit_AND(AlgcmdInt, Algcmd500Close)= Algcmd500Close then
         CmdBufferEBword2C := Bit_AND(CmdBufferEBword2C,16#7FFF#);      --driver no. 32
         EPV500CloseCntr2:=10;
      end if;

   end rAlgCmdBarProcess;
   ---------------------------------------------------------------------------------------------------------

   --This module clears the command (sets bit in CmdBufferEBwordC) corresponding to Algcmd after 10 minor cycles
   procedure rClearEPVCmdBar is
   begin
   if EPV186OpenCntr2 /= 0  then
      EPV186OpenCntr2:=EPV186OpenCntr2 -1;
      if EPV186OpenCntr2 = 0 then
         CmdBufferEBword4C := Bit_OR (CmdBufferEBword4C,16#0004#);
      end if;
   end if;

   if EPV186CloseCntr2 /= 0 then
      EPV186CloseCntr2:=EPV186CloseCntr2 -1;
      if EPV186CloseCntr2 = 0 then
         CmdBufferEBword4C := Bit_OR (CmdBufferEBword4C,16#0008#);
      end if;
   end if;

   if EPV187OpenCntr2 /= 0 then
      EPV187OpenCntr2:=EPV187OpenCntr2 -1;
      if EPV187OpenCntr2 = 0 then
         CmdBufferEBword4C := Bit_OR (CmdBufferEBword4C,16#0040#);
      end if;
   end if;

   if EPV187CloseCntr2 /= 0 then
      EPV187CloseCntr2:=EPV187CloseCntr2 -1;
      if EPV187CloseCntr2 = 0 then
         CmdBufferEBword4C := Bit_OR (CmdBufferEBword4C,16#0080#);
      end if;
   end if;

   if EPV500CloseCntr2 /= 0 then
      EPV500CloseCntr2:=EPV500CloseCntr2 -1;
      if EPV500CloseCntr2 = 0 then
         CmdBufferEBword2C := Bit_OR (CmdBufferEBword2C,16#8000#);
      end if;
   end if;
   end rClearEPVCmdBar;
   ---------------------------------------------------------------------------------------------------------

   --This module checks the data integrity of the sequencing software outputs
   procedure rOutputCheck is
   begin
   if CmdBufferGS2word1 + CmdBufferGS2word1C /= 16#FFFF# or else
      CmdBufferGS2word2 + CmdBufferGS2word2C /= 16#FFFF# or else
      CmdBufferEBword1 + CmdBufferEBword1C /= 16#FFFF# or else
      CmdBufferEBword2 + CmdBufferEBword2C /= 16#FFFF# or else
      CmdBufferEBword3 + CmdBufferEBword3C /= 16#FFFF# or else
      CmdBufferEBword4 + CmdBufferEBword4C /= 16#FFFF# or else
      SelectGS1GS2 /= SelectGS1GS2X then
         rSetSeqerror(8);
   end if;
   if SeqDAPflg + SeqDAPflgC /= 16#FFFF# or else
      SeqGuidflg + SeqGuidflgC /= 16#FFFF# or else
      SeqREXflg + SeqREXflgC /= 16#FFFF# or else
      SeqNavflg + SeqNavflgC /= 16#FFFF# or else
      SeqCoastNavflg + SeqCoastNavflgC /= 16#FFFF# or else
      SeqCUSCEflg + SeqCUSCEflgC/= 16#FFFF# or else
      AlgASeqCmd + AlgASeqCmdC /= 16#FFFF# or else
      AlgCSeqCmd + AlgCSeqCmdC/= 16#FFFF# or else
      AlgKSeqCmd + AlgKSeqCmdC /= 16#FFFF# then
         rSetSeqerror(9);
   end if;
   end rOutputCheck;
---------------------------------------------------------------------------------------------------------

   --This module checks for spill over. On spill over, it stores the Num_cmd, Table pointer and offset timer
   procedure rDetectSpillOver is
   begin
   if Num_cmd /= 0 then
      if Spill1Num_cmd = 0 then      --first spill over
         Spill1Num_cmd := Num_cmd;
         Spill1Tab_ptr1 := Tab_ptr1;
         Spill1Offset_timer:= Offset_timer;
      elsif Spill2Num_cmd = 0 then   --second spill over
         Spill2Num_cmd := Num_cmd;
         Spill2Tab_ptr1 := Tab_ptr1;
         Spill2Offset_timer:= Offset_timer;
      else
         rSetSeqerror(7);   --error set if more than 2 spill overs
      end if;
   end if;

   if Num_cmdC /= 16#FFFF# then
      if Spill1Num_cmdC = 16#FFFF# then      --first spill over
         Spill1Num_cmdC := Num_cmdC;
         Spill1Tab_ptr2 := Tab_ptr2;
         Spill1Offset_timerC:= Offset_timerC;
      elsif Spill2Num_cmdC = 16#FFFF# then   --second spill over
         Spill2Num_cmdC := Num_cmdC;
         Spill2Tab_ptr2 := Tab_ptr2;
         Spill2Offset_timerC:= Offset_timerC;
      else
         rSetSeqerror(7);   --error set if more than 2 spill overs
      end if;
   end if;

   end rDetectSpillOver;
   ---------------------------------------------------------------------------------------------------------

   -- Called by REX at flight reset
   -- This module checks the integrity of SeqCmdTable and SeqCmdBarTable 
   procedure rSeqCmdIntegrity is
   Index:unsigned_16;
   Cmdtable_copy:tCmdData;
   Cmdbartable_copy:tCmdBarData;
   begin
   Index := 1;
   rEvntNumCmdIntegrity;
   while Index <= Normalcmdend loop
      Cmdtable_copy:=SeqCmdTable(Index);
      Cmdbartable_copy:=SeqCmdBarTable(Index);
      if (Cmdtable_copy.Cmd_time) + (Cmdbartable_copy.Cmd_timeC) /= 16#FFFF# or else
         (Cmdtable_copy.Cmd_type) + (Cmdbartable_copy.Cmd_typeC) /= 16#FFFF# or else
         (Cmdtable_copy.Cmd_num) + (Cmdbartable_copy.Cmd_numC) /= 16#FFFF# then
          rSetSeqerror(0);
      end if;
      Index := Index +1;
   end loop;

   Index :=  Emergencycmdstart;
   while Index<= Emergencycmdend loop
      Cmdtable_copy:=SeqCmdTable(Index);
      Cmdbartable_copy:=SeqCmdBarTable(Index);
      if (Cmdtable_copy.Cmd_time) + (Cmdbartable_copy.Cmd_timeC) /= 16#FFFF# or else
         (Cmdtable_copy.Cmd_type) + (Cmdbartable_copy.Cmd_typeC) /= 16#FFFF# or else
         (Cmdtable_copy.Cmd_num) + (Cmdbartable_copy.Cmd_numC) /= 16#FFFF# then
          rSetSeqerror(0);
      end if;
      Index := Index +1;
   end loop;
   end rSeqCmdIntegrity;
   ---------------------------------------------------------------------------------------------------------

   --This module checks the data integrity of EventNum_cmd and EmgEventNum_cmd
   procedure rEvntNumCmdIntegrity is
   Index:unsigned_16;
   begin
      Index:= 1;
      while Index <= pEventDetection.MaxEventVal loop
         if EventNum_cmd(Index) + EventNum_cmdC (Index) /= 16#FFFF#  then
            rSetSeqerror(1);
         end if;
         if Index <= pEventDetection.MaxEmgEventVal then
           if EmgEventNum_cmd(Index) + EmgEventNum_cmdC (Index) /= 16#FFFF# then
               rSetSeqerror(1);
            end if;
         end if;
         Index := Index + 1;
      end loop;
   end rEvntNumCmdIntegrity;
   ---------------------------------------------------------------------------------------------------------

   --This module puts the Cmd time, cmd type, cmd number of executed sequencing commands in the 
   --circular telemetry buffer: SeqTelbuffer/ AlgTelbuffer
  procedure rLoad_MjTelBuf (TelBuffer: in out tTelBuffer; BufWrite_Ptr: in out short_integer;
                           BufRead_Ptr: in short_integer; CmdType,CmdNum: in unsigned_16) is
   BufWrite_PtrNext:short_integer;
   begin
      BufWrite_PtrNext := BufWrite_Ptr + 1;
      if BufWrite_PtrNext > tTelBufferRange then
         BufWrite_PtrNext := 1;
      end if;
      if BufWrite_PtrNext /= BufRead_Ptr then
         TelBuffer(BufWrite_Ptr).CmdTime := pSeqmain.RealTimeCnt;
         TelBuffer(BufWrite_Ptr).CmdType := CmdType;
         TelBuffer(BufWrite_Ptr).CmdNum := CmdNum;
         BufWrite_Ptr := BufWrite_PtrNext;
      else
         TmSeqerrflg := Bit_OR (TmSeqerrflg,16#0800#);
      end if;
   end rLoad_MjTelBuf;
   ---------------------------------------------------------------------------------------------------------

   --This module is called by rREXRead_MjTelBuf for telemetry purpose.  The unread entry of the circular 
   --telemetry buffer: SeqTelbuffer/ AlgTelbuffer is copied into Seqtmbuf/ Seqtmbufa.
   procedure rRead_MjTelBuf is
   begin
   if SeqBufRead_Ptr /= SeqBufWrite_Ptr then
      Seqtmbuf := SeqTelBuffer(SeqBufRead_Ptr);
      SeqBufRead_Ptr := SeqBufRead_Ptr + 1;
      if SeqBufread_Ptr > tTelBufferRange then
         SeqBufRead_Ptr := 1;
      end if;
   end if;
   if AlgBufRead_Ptr /= AlgBufWrite_Ptr then
      SeqtmbufA := AlgTelBuffer(AlgBufRead_Ptr);
      AlgBufRead_Ptr := AlgBufRead_Ptr + 1;
      if AlgBufRead_Ptr > tTelBufferRange then
         AlgBufRead_Ptr := 1;
      end if;
   end if;
   end rRead_MjTelBuf;

   ---------------------------------------------------------------------------------------------------------

   --This module is called when an error is encountered in Sequencing software.  It sets the Seqerrflg
   --and a bit in Tmseqerrflg for telemetry.  REX will set switch flag if Seqerrflg is set.
   procedure rSetSeqerror (Bitnum: in short_integer) is
   begin
   Seqerrflg := pSeqmain.Set;
   TmSeqerrflg := Bit_OR(TmSeqerrflg,ORCmdPatternArray(Bitnum));
   end rSetSeqerror;
   ---------------------------------------------------------------------------------------------------------

   --This module is called by REX to carry out flight reset initialisation of variables in pCommandProcess
   procedure rCommandProcessInit is
   begin
      Seqtmbuf.CmdTime:=0;
      Seqtmbuf.CmdType:=0;
      Seqtmbuf.CmdNum:=0;
      SeqBufWrite_Ptr:=1;
      SeqBufRead_Ptr:=1;

      SeqtmbufA.CmdTime:=0;
      SeqtmbufA.CmdType:=0;
      SeqtmbufA.CmdNum:=0;
      AlgBufWrite_Ptr:=1;
      AlgBufRead_Ptr:=1;

      Offset_timer :=0;
      Offset_timerC:= 16#FFFF#;
      Num_cmd:=0; Num_cmdC:=16#FFFF#;
      Spill1Num_cmd:=0; Spill2Num_cmd:=0;
      Spill1Num_cmdC:=16#FFFF#; Spill2Num_cmdC:=16#FFFF#;
      Tab_ptr1:=1; Tab_ptr2:=1;

      EPV186OpenCntr1:=0;
      EPV186OpenCntr2:=0;
      EPV186CloseCntr1:=0;
      EPV186CloseCntr2:=0;
      EPV187OpenCntr1:=0;
      EPV187OpenCntr2:=0;
      EPV187CloseCntr1:=0;
      EPV187CloseCntr2:=0;
      EPV500CloseCntr1:=0;
      EPV500CloseCntr2:=0;

      SeqDAPflg:=0;
      SeqGuidflg:=0;
      SeqNavflg:=pSeqmain.Set; --to enable acceleration LB check from flight reset
      SeqCoastNavflg:=pSeqmain.NotSet;
      SeqREXflg:=0;
      SeqCUSCEflg:=0;
      SeqInternalflg:=0;
      AlgASeqCmd := 0;
      AlgCSeqCmd := 0;
      AlgKSeqCmd := 0;
      SeqDAPflgC:=16#FFFF#;
      SeqGuidflgC:=16#FFFF#;
      SeqNavflgC:=pSeqmain.NotSet;
      SeqCoastNavflgC:=pSeqmain.Set;
      SeqREXflgC:=16#FFFF#;
      SeqCUSCEflgC := 16#FFFF#;
      SeqInternalflgC:=16#FFFF#;
      AlgASeqCmdC := 16#FFFF#;
      AlgCSeqCmdC := 16#FFFF#;
      AlgKSeqCmdC := 16#FFFF#;
      CmdbufferGS2word1:= 16#0020#; CmdbufferGS2word1C:=16#FFFF#-16#0020#; --to put on SPS-GS2 driver no. 6 at flight reset
      CmdbufferGS2word2:=0; CmdbufferGS2word2C:=16#FFFF#;
      CmdBufferEBword1:= 0; CmdBufferEBword2:= 0; CmdBufferEBword3 := 0; CmdBufferEBword4:= 0;
      CmdBufferEBword1C:=16#FFFF#; CmdBufferEBword2C:=16#FFFF#; CmdBufferEBword3C:=16#FFFF#; CmdBufferEBword4C:=16#FFFF#;
      Seqerrflg:=pSeqmain.NotSet;
      TmSeqerrflg:=0;
      Cmd_cntr:=0;
      SelectGS1GS2:=1;
      SelectGS1GS2X:=1;
   end rCommandProcessInit;

end pCommandProcess;