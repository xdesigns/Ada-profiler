------------------------------------------------
-- Driver for the Module rSEQ
------------------------------------------------

with Ada.Text_Io;
use  Ada.Text_Io;

with Obclib;
use  Obclib;

with Ada.Command_Line;
use  Ada.Command_Line;

with Pseqmain;
with Pcommandprocess;
with Peventdetection;

procedure dSeq is


   package U32_Io is new Modular_Io(Unsigned_32);
   use U32_Io;

   package Flt_Io is new Float_Io(Float32);
   use Flt_Io;

   package Int_Io is new Integer_Io(Short_Integer);
   use Int_Io;

   package Bool_Io is new Enumeration_Io(Boolean);
   use Bool_Io;

   package U16_Io is new Modular_Io(Unsigned_16);
   use U16_Io;

   -- Local Variables declaration

   Fri,
   Fwi,
   Fwo    : File_Type;
   Caseid : String (1 .. 8);

   Referredevent        : Unsigned_16;
   Referredeventtime    : Unsigned_32;
   Referredeventtimebar : Unsigned_32;
   Currenteventtime     : Unsigned_32;
   Currenteventtimebar  : Unsigned_32;

begin

   if(Argument_Count /= 3) then
      New_Line;
      Put_Line("Arguments Missing");
      Put("Usage : ");
      Put(Command_Name);
      Put_Line("InputFile1  OutputFile1 OutputFile2");
   else
      Open(Fri,In_File,Argument(1));
      Create(Fwi,Out_File,Argument(2));
      Create(Fwo,Out_File,Argument(3));

      Skip_Line(Fri,1);            -- to skip two line header
      Skip_Line(Fri,1);
      Skip_Line(Fri,1);

      Skip_Line(Fri,1);
      Skip_Line(Fri,1);
      Skip_Line(Fri,1);

      Skip_Line(Fri,1);
      Skip_Line(Fri,1);
      Skip_Line(Fri,1);

      Put(Fwi,"CaseId");
      Put(Fwi,"    ");
      Put(Fwi,"Dueevent");
      Put(Fwi,"    ");
      Put(Fwi,"DueeventX");
      Put(Fwi,"    ");
      Put(Fwi,"InputEvent");
      Put(Fwi,"    ");
      Put(Fwi,"InputEventC");
      Put(Fwi,"    ");
      Put(Fwi,"CurrentEvent");
      Put(Fwi,"    ");
      Put(Fwi,"CurrentEventC");
      Put(Fwi,"    ");
      Put(Fwi,"Referredevent");
      New_Line(Fwi);

      Put(Fwi,"Realtimecnt");
      Put(Fwi,"    ");
      Put(Fwi,"RealtimecntC");
      Put(Fwi,"    ");
      Put(Fwi,"RferredEventtime");
      Put(Fwi,"    ");
      Put(Fwi,"RferredEventtimeBar");
      Put(Fwi,"    ");
      Put(Fwi,"CurrentEventtime");
      Put(Fwi,"    ");
      Put(Fwi,"CurrentEventtimeBar");
      New_Line(Fwi);

      Put(Fwi,"Acceleration");
      Put(Fwi,"    ");
      Put(Fwi,"Acclncount1");
      Put(Fwi,"    ");
      Put(Fwi,"Acclncount2");
      Put(Fwi,"    ");
      Put(Fwi,"AcclnFailflg");
      Put(Fwi,"    ");
      Put(Fwi,"AcclnFailflgx");
      Put(Fwi,"    ");
      Put(Fwi,"Otherchainhealth");
      Put(Fwi,"    ");
      Put(Fwi,"OtherchainhealthX");
      New_Line(Fwi);

      Put(Fwi,"Linkerrflg");
      Put(Fwi,"    ");
      Put(Fwi,"LinkerrflgX");
      Put(Fwi,"    ");
      Put(Fwi,"LMPFlg");
      Put(Fwi,"    ");
      Put(Fwi,"LMPFlgX");
      Put(Fwi,"    ");
      Put(Fwi,"GuidSeqFlg");
      Put(Fwi,"    ");
      Put(Fwi,"GuidSeqFlgC");
      Put(Fwi,"    ");
      Put(Fwi,"SalvageFlg");
      Put(Fwi,"    ");
      Put(Fwi,"SalvageFlgX");
      New_Line(Fwi);

      Put(Fwi,"NumCmd");
      Put(Fwi,"    ");
      Put(Fwi,"NumCmdC");
      Put(Fwi,"    ");
      Put(Fwi,"TabPtr1");
      Put(Fwi,"    ");
      Put(Fwi,"TabPtr2");
      Put(Fwi,"    ");
      Put(Fwi,"OffsetTimer");
      Put(Fwi,"    ");
      Put(Fwi,"OffsetTimerc");
      New_Line(Fwi);

      Put(Fwi,"Spill1NumCmd");
      Put(Fwi,"    ");
      Put(Fwi,"Spill1NumCmdC");
      Put(Fwi,"    ");
      Put(Fwi,"Spill1TabPtr1");
      Put(Fwi,"    ");
      Put(Fwi,"Spill1TabPtr2");
      Put(Fwi,"    ");
      Put(Fwi,"Spill1OffsetTimer");
      Put(Fwi,"    ");
      Put(Fwi,"Spill1OffsetTimerc");
      New_Line(Fwi);

      Put(Fwi,"Spill2NumCmd");
      Put(Fwi,"    ");
      Put(Fwi,"Spill2NumCmdC");
      Put(Fwi,"    ");
      Put(Fwi,"Spill2TabPtr1");
      Put(Fwi,"    ");
      Put(Fwi,"Spill2TabPtr2");
      Put(Fwi,"    ");
      Put(Fwi,"Spill2OffsetTimer");
      Put(Fwi,"    ");
      Put(Fwi,"Spill2OffsetTimerc");
      New_Line(Fwi);

      Put(Fwi,"SeqInternalFlg");
      Put(Fwi,"    ");
      Put(Fwi,"SeqInternalFlgC");
      Put(Fwi,"    ");
      Put(Fwi,"AlgCmd");
      Put(Fwi,"    ");
      Put(Fwi,"AlgCmdC");
      Put(Fwi,"    ");
      Put(Fwi,"Seqerrflg");
      Put(Fwi,"    ");
      Put(Fwi,"TmSeqerrflg");
      New_Line(Fwi);

      Put(Fwo,"CaseId");
      Put(Fwo,"   ");
      Put(Fwo,"EventDetectedFlg");
      Put(Fwo,"   ");
      Put(Fwo,"EventDetectedFlgX");
      Put(Fwo,"   ");
      Put(Fwo,"CurrentEvent");
      Put(Fwo,"   ");
      Put(Fwo,"CurrentEventC");
      Put(Fwo,"   ");
      Put(Fwo,"SeqDAPflg");
      Put(Fwo,"   ");
      Put(Fwo,"SeqDAPflgC");
      Put(Fwo,"   ");
      Put(Fwo,"SeqGuidflg");
      Put(Fwo,"   ");
      Put(Fwo,"SeqGuidflgC");
      New_Line(Fwo);

      Put(Fwo,"CmdBufferGS2word1");
      Put(Fwo,"   ");
      Put(Fwo,"CmdBufferGS2word1C");
      Put(Fwo,"   ");
      Put(Fwo,"CmdBufferGS2word2");
      Put(Fwo,"   ");
      Put(Fwo,"CmdBufferGS2word2C");
      Put(Fwo,"   ");
      Put(Fwo,"CmdBufferEBword1");
      Put(Fwo,"   ");
      Put(Fwo,"CmdBufferEBword1C");
      Put(Fwo,"   ");
      Put(Fwo,"CmdBufferEBword2");
      Put(Fwo,"   ");
      Put(Fwo,"CmdBufferEBword2C");
      Put(Fwo,"   ");
      Put(Fwo,"CmdBufferEBword3");
      Put(Fwo,"   ");
      Put(Fwo,"CmdBufferEBword3C");
      Put(Fwo,"   ");
      Put(Fwo,"CmdBufferEBword4");
      Put(Fwo,"   ");
      Put(Fwo,"CmdBufferEBword4C");
      New_Line(Fwo);
      
      
      
      Put(Fwo,"Num_Cmd");
         Put(Fwo,"    ");
         Put(Fwo,"Num_Cmdc");
         Put(Fwo,"    ");
         Put(Fwo,"Tab_Ptr1");
         Put(Fwo,"    ");
         Put(Fwo,"Tab_Ptr2");
         Put(Fwo,"    ");
         Put(Fwo,"Offset_Timer");
         Put(Fwo,"    ");
         Put(Fwo,"Offset_Timerc");
         New_Line(Fwo);
      
      
      

      Put(Fwo,"SelectGS1GS2");
      Put(Fwo,"   ");
      Put(Fwo,"Cmd_cntr");
      Put(Fwo,"   ");
      Put(Fwo,"Seqerrflg");
      Put(Fwo,"   ");
      Put(Fwo,"TmSeqerrflg");
      New_Line(Fwo);


      while (not(End_Of_File(Fri))) loop

         pSeqmain.rSeqinit;
         pCommandProcess.Cmd_Cntr := 0;

         Get(Fri,Caseid);
         Get(Fri,Peventdetection.Due_Event);
         Get(Fri,Peventdetection.Due_Eventx);
         Get(Fri,Pseqmain.Input_Event);
         Get(Fri,Pseqmain.Input_Eventc);
         Get(Fri,Peventdetection.Current_Event);
         Get(Fri,Peventdetection.Current_Eventc);
         Get(Fri,Referredevent);

         Get(Fri,Pseqmain.Realtimecnt);
         Get(Fri,Pseqmain.Realtimecntc);
         Get(Fri,Referredeventtime);
         Get(Fri,Referredeventtimebar);
         Get(Fri,Currenteventtime);
         Get(Fri,Currenteventtimebar);

         Get(Fri,Pseqmain.Acceleration);
         Get(Fri,Peventdetection.Accln_Count1);
         Get(Fri,Peventdetection.Accln_Count2);
         Get(Fri,Pseqmain.Accln_Failflg);
         Get(Fri,Pseqmain.Accln_Failflgx);
         Get(Fri,Pseqmain.Otherchainhealth);
         Get(Fri,Pseqmain.Otherchainhealthx);

         Get(Fri,Pseqmain.Linkerrflg);
         Get(Fri,Pseqmain.Linkerrflgx);
         Get(Fri,Pseqmain.Lmpflg);
         Get(Fri,Pseqmain.Lmpflgx);
         Get(Fri,Pseqmain.Guid_Seqflg);
         Get(Fri,Pseqmain.Guid_Seqflgc);
         Get(Fri,Pseqmain.Salvageflg);
         Get(Fri,Pseqmain.Salvageflgx);

         Get(Fri,Pcommandprocess.Num_Cmd);
         Get(Fri,Pcommandprocess.Num_Cmdc);
         Get(Fri,Pcommandprocess.Tab_Ptr1);
         Get(Fri,Pcommandprocess.Tab_Ptr2);
         Get(Fri,Pcommandprocess.Offset_Timer);
         Get(Fri,Pcommandprocess.Offset_Timerc);

         Get(Fri,Pcommandprocess.Spill1num_Cmd);
         Get(Fri,Pcommandprocess.Spill1num_Cmdc);
         Get(Fri,Pcommandprocess.Spill1tab_Ptr1);
         Get(Fri,Pcommandprocess.Spill1tab_Ptr2);
         Get(Fri,Pcommandprocess.Spill1offset_Timer);
         Get(Fri,Pcommandprocess.Spill1offset_Timerc);

         Get(Fri,Pcommandprocess.Spill2num_Cmd);
         Get(Fri,Pcommandprocess.Spill2num_Cmdc);
         Get(Fri,Pcommandprocess.Spill2tab_Ptr1);
         Get(Fri,Pcommandprocess.Spill2tab_Ptr2);
         Get(Fri,Pcommandprocess.Spill2offset_Timer);
         Get(Fri,Pcommandprocess.Spill2offset_Timerc);

         Get(Fri,Pcommandprocess.Seqinternalflg);
         Get(Fri,Pcommandprocess.Seqinternalflgc);
         Get(Fri,Pseqmain.Algcmd);
         Get(Fri,Pseqmain.Algcmdc);
         Get(Fri,Pcommandprocess.Seqerrflg);
         Get(Fri,Pcommandprocess.Tmseqerrflg);


         Put(Fwi,Caseid);
         Put(Fwi,"    ");
         Put(Fwi,Peventdetection.Due_Event,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Peventdetection.Due_Eventx,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Input_Event,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Input_Eventc,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Peventdetection.Current_Event,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Peventdetection.Current_Eventc,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Referredevent,16);
         New_Line(Fwi);

         Put(Fwi,Pseqmain.Realtimecnt,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Realtimecntc,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Referredeventtime,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Referredeventtimebar,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Currenteventtime,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Currenteventtimebar,0,16);
         New_Line(Fwi);


         Put(Fwi,Pseqmain.Acceleration,0,10);
         Put(Fwi,"    ");
         Put(Fwi,Peventdetection.Accln_Count1,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Peventdetection.Accln_Count2,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Accln_Failflg,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Accln_Failflgx,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Otherchainhealth,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Otherchainhealthx,0,16);
         New_Line(Fwi);


         Put(Fwi,Pseqmain.Linkerrflg,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Linkerrflgx,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Lmpflg,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Lmpflgx,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Guid_Seqflg,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Guid_Seqflgc,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Salvageflg,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Salvageflgx,0,16);
         New_Line(Fwi);

         Put(Fwi,Pcommandprocess.Num_Cmd,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Num_Cmdc,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Tab_Ptr1,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Tab_Ptr2,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Offset_Timer,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Offset_Timerc,0,16);
         New_Line(Fwi);


         Put(Fwi,Pcommandprocess.Spill1num_Cmd,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Spill1num_Cmdc,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Spill1tab_Ptr1,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Spill1tab_Ptr2,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Spill1offset_Timer,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Spill1offset_Timerc,0,16);
         New_Line(Fwi);


         Put(Fwi,Pcommandprocess.Spill2num_Cmd,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Spill2num_Cmdc,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Spill2tab_Ptr1,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Spill2tab_Ptr2,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Spill2offset_Timer,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Spill2offset_Timerc,0,16);
         New_Line(Fwi);




         Put(Fwi,Pcommandprocess.Num_Cmd,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Num_Cmdc,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Tab_Ptr1,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Tab_Ptr2,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Offset_Timer,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Offset_Timerc,0,16);
         New_Line(Fwi);
         
         
         


         Put(Fwi,Pcommandprocess.Seqinternalflg,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Seqinternalflgc,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Algcmd,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pseqmain.Algcmdc,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Seqerrflg,0,16);
         Put(Fwi,"    ");
         Put(Fwi,Pcommandprocess.Tmseqerrflg,0,16);
         New_Line(Fwi);

         Peventdetection.Eventtimes(Peventdetection.Current_Event) := Currenteventtime;
         Peventdetection.Eventtimesbar(16#FFFF#-Peventdetection.Current_EventC) := Currenteventtimebar;
         Peventdetection.Eventtimes(Referredevent) := Referredeventtime;
         Peventdetection.Eventtimesbar(Referredevent) := Referredeventtimebar;

         pSeqmain.rSEQ;

         Put(Fwo,Caseid);
         Put(Fwo,"    ");
         Put(Fwo,Peventdetection.Eventdetectedflg,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Peventdetection.Eventdetectedflgx,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Peventdetection.Current_Event,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Peventdetection.Current_Eventc,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Seqdapflg,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Seqdapflgc,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Seqguidflg,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Seqguidflgc,0,16);
         New_Line(Fwo);

         Put(Fwo,Pcommandprocess.Cmdbuffergs2word1,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Cmdbuffergs2word1c,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Cmdbuffergs2word2,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Cmdbuffergs2word2c,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Cmdbufferebword1,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Cmdbufferebword1c,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Cmdbufferebword2,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Cmdbufferebword2c,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Cmdbufferebword3,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Cmdbufferebword3c,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Cmdbufferebword4,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Cmdbufferebword4c,0,16);
         New_Line(Fwo);


         Put(Fwo,Pcommandprocess.Num_Cmd,0,16);
         Put(Fwo,"    ");
         Put(Fwo,Pcommandprocess.Num_Cmdc,0,16);
         Put(Fwo,"    ");
         Put(Fwo,Pcommandprocess.Tab_Ptr1,0,16);
         Put(Fwo,"    ");
         Put(Fwo,Pcommandprocess.Tab_Ptr2,0,16);
         Put(Fwo,"    ");
         Put(Fwo,Pcommandprocess.Offset_Timer,0,16);
         Put(Fwo,"    ");
         Put(Fwo,Pcommandprocess.Offset_Timerc,0,16);
         New_Line(Fwo);

         Put(Fwo,Pcommandprocess.Selectgs1gs2,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Cmd_Cntr,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Seqerrflg,0,16);
         Put(Fwo,"   ");
         Put(Fwo,Pcommandprocess.Tmseqerrflg,0,16);
         New_Line(Fwo);

      end loop;

      Close(Fri);
      Close(Fwi);
      Close(Fwo);

   end if;

end Dseq;