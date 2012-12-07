---------------------------------------------------------------------------------------------------------
--- File Name: pEventDetection.adb

--- Title: EventDetection for GSLV-D3

--- Last modified: 23-11-2007

--- Version number: GD3_SE_1.2
---------------------------------------------------------------------------------------------------------

with OBCLIB; use OBCLIB;
with pSeqmain;
with pCommandProcess;

package body pEventDetection is

   ---------------------------------------------------------------------------------------------------------

    --Main module in pEventDetection, called by rSEQ
   --Calls the RTD/ Reference Event Detection modules
   procedure rEventController is
   begin
      if Emergencyflg = pSeqmain.NotSet and then EmergencyflgX = pSeqmain.NotSet then  -- normal sequencing
         rEventLookOut;
         rEventLookOutX;
         rEventSet;
      elsif Emergencyflg = pSeqmain.Set and then EmergencyflgX = pSeqmain.Set then  -- emergency sequencing
         rEmergencyEvent;
         rEmergencyEventX;
         rEmgEventSet;
      else
         pCommandProcess.rSetSeqerror(10);   --error set in case of Emergencyflg / EmergencyflgX corruption
      end if;
   end  rEventController;
   ---------------------------------------------------------------------------------------------------------

   --RTD/ Reference Event Detection module: stream1
   procedure rEventLookOut is
   begin
   if Current_Event < MaxEventVal then
      if EventList(Due_Event).Trigger_type = 0 then
         rTTReferenceEvent;
      elsif pSeqmain.RealTimeCnt >= EventTimes(EventList(Due_Event).Referred_Event) +
                              unsigned_32(EventList(Due_Event).Window_out) then
            EventDetectedflg := pSeqmain.Set;   --RTD detected at window out

      elsif pSeqmain.RealTimeCnt >= EventTimes(EventList(Due_Event).Referred_Event) +
                              unsigned_32(EventList(Due_Event).Window_in)  then   --window in checking
           case EventList(Due_Event).Trigger_type is
               when 16#0001# => rTTLMP;
               when 16#0002# => rTTAccln;
               when 16#0003# => rTTGuidflg;
               when 16#0004# => rTTGuidflg;
                                if EventDetectedflg = pSeqmain.NotSet then
                                   rTTAccln;
                                end if;
               when 16#0005# => rTTPrevEventOffset;
               when others => pCommandProcess.rSetSeqerror(3);
           end case;
           if EventDetectedflg = pSeqmain.NotSet then
              rEventSync;      --Event Synchronisation carried out for RTD events
           end if;
      end if;--Window check
   end if;--Current_Event check
   end rEventLookOut;
   ---------------------------------------------------------------------------------------------------------   

   --RTD/ Reference Event Detection module: stream2  
   procedure rEventLookOutX is
   begin
      if Current_EventC > MaxEventValC then
         if EventListX(Due_EventX).Trigger_typeC = 16#FFFF# then
            rTTReferenceEventX;
         elsif   pSeqmain.RealTimeCntC <= EventTimesBar(EventListX(Due_EventX).Referred_Event) -
                              unsigned_32(EventListX(Due_EventX).Window_out) then
            EventDetectedflgX := pSeqmain.Set;   --RTD detected at window out

         elsif pSeqmain.RealTimeCntC <= EventTimesBar(EventListX(Due_EventX).Referred_Event) -
                              unsigned_32(EventListX(Due_EventX).Window_in) then   --window in checking
           case EventListX(Due_EventX).Trigger_typeC is
               when 16#FFFE# => rTTLMPX;
               when 16#FFFD# => rTTAcclnX;
               when 16#FFFC# => rTTGuidflgX;
               when 16#FFFB# => rTTGuidflgX;
                                if EventDetectedflgX = pSeqmain.NotSet then
                                   rTTAcclnX;
                                end if;
               when 16#FFFA# => rTTPrevEventOffsetX;
               when others => pCommandProcess.rSetSeqerror(3);
           end case;
           if EventDetectedflgX = pSeqmain.NotSet then
              rEventSyncX;      --Event Synchronisation carried out for RTD events
           end if;
         end if;--Window check
      end if;--Current_Event check
   end rEventLookOutX;

   --------------------------------------------------------------------------------------------------------

   --Module for detecting LMP based RTD: stream1
   procedure rTTLMP is
   begin
      if pSeqmain.LMPflg = pSeqmain.Set then
         EventDetectedflg := pSeqmain.Set;
      end if;
   end  rTTLMP;
   --------------------------------------------------------------------------------------------------------

   --Module for detecting LMP based RTD: stream2
   procedure rTTLMPX is
   begin
      if pSeqmain.LMPflgX = pSeqmain.Set then
         EventDetectedflgX := pSeqmain.Set;
      end if;
   end  rTTLMPX;
   ---------------------------------------------------------------------------------------------------------

   --Module for detecting Acceleration based RTD: stream1
   procedure rTTAccln is
   begin
      if  pSeqmain.Accln_Failflg = pSeqmain.NotSet then --no accln failure
         if pSeqmain.Linkerrflg = pSeqmain.NotSet and then  --no link error
	      pSeqmain.Acceleration <= EventList(Due_Event).Accln_RefVal then
               Accln_count1 := Accln_count1 +1 ;
               if Accln_count1 = 3 then
                  EventDetectedflg := pSeqmain.Set;
               end if ;
	   else
	      Accln_count1 := 0 ;
	   end if ;       --Linkerrflg check end
      elsif pSeqmain.Accln_Failflg = pSeqmain.Set then --accln failure
            Accln_count1 := 0 ;
         if pSeqmain.OtherChainHealth= pSeqmain.Set and then --other chain not healthy
            pSeqmain.RealTimeCnt>= EventTimes(EventList(Due_Event).Referred_Event) +
                          unsigned_32(EventList(Due_Event).Offset_time)  then
                 EventDetectedflg := pSeqmain.Set;
	   end if; --OtherChainHealth check end
      end if;    --Accln_Failflg check end
   end rTTAccln;

   --------------------------------------------------------------------------------------------------------------------------------

   --Module for detecting Acceleration based RTD: stream2
   procedure rTTAcclnX is
   begin
      if  pSeqmain.Accln_FailflgX = pSeqmain.NotSet then --no accln failure
         if pSeqmain.LinkerrflgX = pSeqmain.NotSet and then  --no link error
	      pSeqmain.Acceleration <= EventListX(Due_EventX).Accln_RefVal then
	         Accln_count2 := Accln_count2 +1 ;
               if Accln_count2 = 3 then
                 EventDetectedflgX := pSeqmain.Set;
               end if ;
         else
            Accln_count2 := 0 ;
         end if; --LinkerrflgX check end
      elsif pSeqmain.Accln_FailflgX = pSeqmain.Set then --accln failure
         Accln_count2 := 0 ;
         if pSeqmain.OtherChainHealthX= pSeqmain.Set and then --other chain not healthy
            pSeqmain.RealTimeCntC<= EventTimesBar(EventListX(Due_EventX).Referred_Event) -
                          unsigned_32(EventListX(Due_EventX).Offset_time)then
                 EventDetectedflgX := pSeqmain.Set;
	   end if; --OtherChainHealthX check end
      end if;    --Accln_FailflgX check end
   end rTTAcclnX;
   --------------------------------------------------------------------------------------------------------------------------------

   --Module for detecting Guidance based RTD: stream1
   procedure rTTGuidflg is
   begin
       if pSeqmain.Guid_Seqflg = EventList(Due_Event).Guid_RefVal then
	   if  pSeqmain.Salvageflg=pSeqmain.NotSet then  -- no salvage error
 	      EventDetectedflg := pSeqmain.Set;
         elsif  pSeqmain.Salvageflg=pSeqmain.Set and then pSeqmain.OtherChainHealth=pSeqmain.Set then
                                                -- salvage error, other chain not healthy
               EventDetectedflg := pSeqmain.Set;
         end if; -- Salvageflg check end         
       end if;   --Guid_Seqflg check end
   end rTTGuidflg;
   ---------------------------------------------------------------------------------------------------------

   --Module for detecting Guidance based RTD: stream2
   procedure rTTGuidflgX is
   begin
       if pSeqmain.Guid_SeqflgC = EventListX(Due_EventX).Guid_RefValC then
	   if  pSeqmain.SalvageflgX=pSeqmain.NotSet then --no salvage error
 	      EventDetectedflgX := pSeqmain.Set;
         elsif  pSeqmain.SalvageflgX=pSeqmain.Set and then pSeqmain.OtherChainHealthX=pSeqmain.Set then
                                                 -- salvage error, other chain not healthy
               EventDetectedflgX := pSeqmain.Set;
         end if; -- SalvageflgX check end         
       end if;   --Guid_SeqflgX check end
   end rTTGuidflgX;
   ---------------------------------------------------------------------------------------------------------

   --Module for detecting RTD based on fixed offset from previous Event: stream1
   procedure rTTPrevEventOffset is
   begin
      if pSeqmain.RealTimeCnt>=EventTimes(Current_Event)+
                              unsigned_32(EventList(Due_Event).Offset_time) then
         EventDetectedflg := pSeqmain.Set;
      end if;
   end rTTPrevEventOffset;
   ---------------------------------------------------------------------------------------------------------

   --Module for detecting RTD based on fixed offset from previous Event: stream2
   procedure rTTPrevEventOffsetX is
   begin
      if pSeqmain.RealTimeCntC <=EventTimesBar(16#FFFF#-Current_EventC)-
                              unsigned_32(EventListX(Due_EventX).Offset_time) then
         EventDetectedflgX := pSeqmain.Set;
      end if;
   end rTTPrevEventOffsetX;
   ---------------------------------------------------------------------------------------------------------

   --Module for detecting Reference Event: stream1
   procedure rTTReferenceEvent is
   begin
      if pSeqmain.RealTimeCnt >= EventTimes(EventList(Due_Event).Referred_Event)+
                        unsigned_32(EventList(Due_Event).Offset_time) then
         EventDetectedflg := pSeqmain.Set;
      else
         rEventSync;   --Reference Event Synchronisation
      end if ;
   end rTTReferenceEvent;
   ---------------------------------------------------------------------------------------------------------

   --Module for detecting Reference Event: stream2
   procedure rTTReferenceEventX is
   begin
      if pSeqmain.RealTimeCntC <= EventTimesBar(EventListX(Due_EventX).Referred_Event) -
                          unsigned_32(EventListX(Due_EventX).Offset_time)then
         EventDetectedflgX := pSeqmain.Set;
      else
         rEventSyncX;   --Reference Event Synchronisation
      end if ;
   end rTTReferenceEventX;
   ---------------------------------------------------------------------------------------------------------

   --Module for detecting Emergency Event: stream1
   procedure rEmergencyEvent is
   begin
   if Current_Event < MaxEmgEventVal then
      if pSeqmain.RealTimeCnt >= EmgEventTimes(EmgEventList(Due_Event).Referred_Event)+
                        unsigned_32(EmgEventList(Due_Event).Offset_time) then
         EventDetectedflg := pSeqmain.Set;
      end if ;-- RealTimeCnt	
   end if;
   end rEmergencyEvent;
   ---------------------------------------------------------------------------------------------------------

   --Module for detecting Emergency Event: stream2
   procedure rEmergencyEventX is
   begin
   if Current_EventC > MaxEmgEventValC then
      if pSeqmain.RealTimeCntC <= EmgEventTimesBar(EmgEventListX(Due_EventX).Referred_Event) -
                        unsigned_32(EmgEventListX(Due_EventX).Offset_time) then
         EventDetectedflgX := pSeqmain.Set;
      end if ;-- RealTimeCnt	
   end if;
   end rEmergencyEventX;
   ---------------------------------------------------------------------------------------------------------

   --Event Synchronisation Module: stream1
   procedure rEventSync is
   begin
   if pSeqmain.OtherChainHealth = pSeqmain.NotSet and then pSeqmain.Input_Event <= MaxEventVal then
      if pSeqmain.Input_Event  - Current_Event = 1 or else pSeqmain.Input_Event  - Current_Event = 2 then
         EventDetectedflg := pSeqmain.Set;
      end if;
   end if ;
   end rEventSync;
   ---------------------------------------------------------------------------------------------------------

   --Event Synchronisation Module: stream2
   procedure rEventSyncX is
   begin
   if pSeqmain.OtherChainHealthX = pSeqmain.NotSet and then pSeqmain.Input_EventC >= MaxEventValC then
      if Current_EventC - pSeqmain.Input_EventC = 1 or else Current_EventC - pSeqmain.Input_EventC = 2 then
         EventDetectedflgX := pSeqmain.Set;
      end if;
   end if;
   end rEventSyncX;
   ---------------------------------------------------------------------------------------------------------

   --When event detected information comes from stream1 and stream2, this module updates all
   --relevant variables to point to next event.
   procedure rEventSet is
   begin
   if EventDetectedflg = pSeqmain.Set and then EventDetectedflgX = pSeqmain.Set then
      EventDetectedflg := pSeqmain.NotSet;
      EventDetectedflgX := pSeqmain.NotSet;
      EventTimes(Due_Event):= pSeqmain.RealTimeCnt;
      EventTimesBar(Due_EventX):= pSeqmain.RealTimeCntC;
      EventTime:=pSeqmain.RealTimeCnt;
      Current_Event := Due_Event;
      Current_EventC := 16#FFFF#-Due_EventX;
      Output_Event:= Current_Event;   --to pass to other NGCP
      Output_EventC:=Current_EventC;  -- " 
      Due_Event:= Due_Event + 1;
      Due_EventX:= Due_EventX + 1;
      pCommandProcess.rDetectSpillOver;

      pCommandProcess.Offset_timer := 0;
      pCommandProcess.Offset_timerC:=16#FFFF#;
      -- sequencing table pointers updated to point to new event's first command
      pCommandProcess.Tab_ptr1:=pCommandProcess.Tab_ptr1 + pCommandProcess.Num_cmd;
      pCommandProcess.Tab_ptr2:=pCommandProcess.Tab_ptr2 + 16#FFFF# - pCommandProcess.Num_cmdC;
      --Num_cmd updated with new event's Num_cmd
      pCommandProcess.Num_cmd := pCommandProcess.EventNum_cmd(Current_Event);
      pCommandProcess.Num_cmdC := pCommandProcess.EventNum_cmdC(16#FFFF#-Current_eventC);
      Accln_count1:=0;
      Accln_count2:= 0 ;

   elsif EventDetectedflg /= EventDetectedflgX then
      pCommandProcess.rSetSeqerror(4);      --error set if stream1 and stream2 disagree
   end if;
  end rEventSet;
------------------------------------------------------------------------------------------------

   --When emergency event detected information comes from stream1 and stream2, this module updates all
   --relevant variables to point to next emergency event.
   procedure rEmgEventSet is
   begin
   if EventDetectedflg = pSeqmain.Set and then EventDetectedflgX = pSeqmain.Set then
      EventDetectedflg := pSeqmain.NotSet;
      EventDetectedflgX := pSeqmain.NotSet;

      EmgEventTimes(Due_Event):= pSeqmain.RealTimeCnt;
      EmgEventTimesBar(Due_EventX):= pSeqmain.RealTimeCntC;
      EventTime:=pSeqmain.RealTimeCnt;
      Current_Event := Due_Event;
      Current_EventC := 16#FFFF# - Due_EventX;
      Output_Event:= Current_Event;
      Output_EventC:=Current_EventC;
      Due_Event:= Due_Event + 1;
      Due_EventX:= Due_EventX + 1;
      pCommandProcess.rDetectSpillOver;

      pCommandProcess.Offset_timer := 0;
      pCommandProcess.Offset_timerC:=16#FFFF#;
      -- sequencing table pointers updated to point to new emergency event's first command
      pCommandProcess.Tab_ptr1:=pCommandProcess.Tab_ptr1 + pCommandProcess.Num_cmd;
      pCommandProcess.Tab_ptr2:=pCommandProcess.Tab_ptr2 + 16#FFFF# - pCommandProcess.Num_cmdC;
      --Num_cmd updated with new emergency event's Num_cmd
      pCommandProcess.Num_cmd := pCommandProcess.EmgEventNum_cmd(Current_Event);
      pCommandProcess.Num_cmdC := pCommandProcess.EmgEventNum_cmdC(16#FFFF#-Current_EventC);

   elsif EventDetectedflg /= EventDetectedflgX then
     pCommandProcess.rSetSeqerror(4);   --error set if stream1 and stream2 disagree
   end if;
  end rEmgEventSet;
------------------------------------------------------------------------------------------------

   --This module performs the cryo stage engine performance check during identified window. stream1
   --If acceleration threshold is crossed, then EnginePerfOKflg is set indicating that engine is OK.
   procedure rEnginePerfCheck is
   begin
      if pCommandProcess.SeqInternalflg = 16#11# or else pCommandProcess.SeqInternalflg = 16#22# then
         Linkerr3cycles (Linkerrindex) := pSeqmain.Linkerrflg;
                              --Linkerrflg status stored to check Linkerrflg status in last 3 minor cycles
         Linkerrindex := Linkerrindex + 1;
         if Linkerrindex > 3 then
            Linkerrindex := 1;
         end if;

         if pSeqmain.Linkerrflg = pSeqmain.NotSet and then pSeqmain.Accln_Failflg = pSeqmain.NotSet and then
            EnginePerfOKflg = pSeqmain.NotSet and then
            pSeqmain.Acceleration >= Accln_emergval then
               PerfCheckCnt := PerfCheckCnt + 1;
               if PerfCheckCnt = 3 then
                  EnginePerfOKflg := pSeqmain.Set;
                  PerfCheckCnt := 0;
               end if;
         else
            PerfCheckCnt := 0;
         end if;
      end if;
      if pCommandProcess.SeqInternalflg = 16#22# then
         pCommandProcess.SeqInternalflg := 0;
         if EnginePerfOKflg = pSeqmain.NotSet and then pSeqmain.Accln_Failflg = pSeqmain.NotSet and then
            Linkerr3cycles (1) = pSeqmain.NotSet and then Linkerr3cycles (2) = pSeqmain.NotSet and then
            Linkerr3cycles (3) = pSeqmain.NotSet then
            Emergencyflg := pSeqmain.Set; --Emergency shut down         
            PerfCheckCnt := 0;
         end if;
      end if;
   end rEnginePerfCheck;
------------------------------------------------------------------------------------------------

   --This module performs the cryo stage engine performance check during identified window. stream2
   --If acceleration threshold is crossed, then EnginePerfOKflg is set indicating that engine is OK.
   procedure rEnginePerfCheckX is
   begin
      if pCommandProcess.SeqInternalflgC = 16#FFEE# or else pCommandProcess.SeqInternalflgC = 16#FFDD# then
         Linkerr3cyclesX (XLinkerrindex) := pSeqmain.LinkerrflgX;
                              --Linkerrflg status stored to check Linkerrflg status in last 3 minor cycles         
         XLinkerrindex := XLinkerrindex + 1;
         if XLinkerrindex > 3 then
            XLinkerrindex := 1;
         end if;

         if pSeqmain.LinkerrflgX = pSeqmain.NotSet and then pSeqmain.Accln_FailflgX = pSeqmain.NotSet and then
            EnginePerfOKflgX = pSeqmain.NotSet and then
            pSeqmain.Acceleration >= Accln_emergvalX then
               PerfCheckCntX := PerfCheckCntX + 1;
               if PerfCheckCntX = 3 then
                  EnginePerfOKflgX := pSeqmain.Set;
                  PerfCheckCntX := 0;
               end if;
         else
            PerfCheckCntX := 0;
         end if;
      end if;

      if pCommandProcess.SeqInternalflgC = 16#FFDD# then
         pCommandProcess.SeqInternalflgC := 16#FFFF#;
         if EnginePerfOKflgX = pSeqmain.NotSet and then pSeqmain.Accln_FailflgX = pSeqmain.NotSet and then
            Linkerr3cyclesX (1) = pSeqmain.NotSet and then Linkerr3cyclesX (2) = pSeqmain.NotSet and then
            Linkerr3cyclesX (3) = pSeqmain.NotSet then
            EmergencyflgX := pSeqmain.Set; --Emergency shut down         
            PerfCheckCntX := 0;
         end if;
      end if;

      if Emergencyflg = pSeqmain.Set and then EmergencyflgX = pSeqmain.Set then
                                    --if Emergencyflg indicates Engine Performance failure in stream1 and stream2
                                    -- then variables updated to detect first emergency event, Te
         EmgEventTimes(1):= pSeqmain.RealTimeCnt;
         EmgEventTimesBar(1):= pSeqmain.RealTimeCntC;
         EventTime:=pSeqmain.RealTimeCnt;
         Current_Event := 1;
         Current_EventC := 16#FFFE#;
         Output_Event:= Current_Event;
         Output_EventC:=Current_EventC;
         Due_Event := 2;
         Due_EventX := 2;
         pCommandProcess.Spill1Num_cmd := 0; pCommandProcess.Spill1Num_cmdC := 16#FFFF#;
         pCommandProcess.Spill2Num_cmd := 0; pCommandProcess.Spill2Num_cmdC := 16#FFFF#;

         pCommandProcess.Offset_timer := 0;
         pCommandProcess.Offset_timerC := 16#FFFF#;
         pCommandProcess.Tab_ptr1:= pCommandProcess.Emergencycmdstart; --points to the first emergency command
         pCommandProcess.Tab_ptr2:= pCommandProcess.Emergencycmdstart; -- "
         pCommandProcess.Num_cmd := pCommandProcess.EmgEventNum_cmd(1);
         pCommandProcess.Num_cmdC := pCommandProcess.EmgEventNum_cmdC(1);

--         pCommandProcess.rTableProcess(pCommandProcess.Num_cmd,pCommandProcess.Tab_ptr1,pCommandProcess.Offset_timer);
         pCommandProcess.Offset_timer := pCommandProcess.Offset_timer + 1;

--         pCommandProcess.rComplTableProcess(pCommandProcess.Num_cmdC,pCommandProcess.Tab_ptr2,pCommandProcess.Offset_timerC);
         pCommandProcess.Offset_timerC := pCommandProcess.Offset_timerC - 1;

      elsif Emergencyflg /= EmergencyflgX then
         pCommandprocess.rSetSeqerror(10);   --error set if stream1 and stream2 disagree
         Emergencyflg := pSeqmain.NotSet;
         EmergencyflgX := pSeqmain.NotSet;
      end if;
   end rEnginePerfCheckX;
------------------------------------------------------------------------------------------------

   --This module is called by REX at flight reset to check the integrity of EventList and EventListX
   procedure rEventListIntegrity is
   Index:unsigned_16;
   EventList_copy:tEventEntry;
   EventListX_copy:tEventEntryX;
   EmgEventList_copy:tEmgEventEntry;
   EmgEventListX_copy:tEmgEventEntry;
   begin
   Index := 1;
   if MaxEventVal + MaxEventValC /= 16#FFFF# or else
      MaxEmgEventVal + MaxEmgEventValC /= 16#FFFF# then
      pCommandProcess.rSetSeqerror(2);
   end if;
   while Index <= MaxEventVal loop
      EventList_copy:=EventList(Index);
      EventListX_copy:=EventListX(Index);
      if (EventList_copy.Referred_Event) /= (EventListX_copy.Referred_Event)  or else
         (EventList_copy.Offset_time) /= (EventListX_copy.Offset_time)  or else
         (EventList_copy.Trigger_type) + (EventListX_copy.Trigger_typeC) /= 16#FFFF# or else
         (EventList_copy.Window_in) /= (EventListX_copy.Window_in) or else
         (EventList_copy.Window_out) /= (EventListX_copy.Window_out) or else
         (EventList_copy.Guid_Refval) + (EventListX_copy.Guid_RefvalC) /= 16#FFFF# or else
         (EventList_copy.Accln_Refval) /= (EventListX_copy.Accln_Refval) then
            pCommandProcess.rSetSeqerror(2);
      end if;
      if Index <= MaxEmgEventVal then
         EmgEventList_copy:=EmgEventList(Index);
         EmgEventListX_copy:=EmgEventListX(Index);
         if (EmgEventList_copy.Referred_Event) /= (EmgEventListX_copy.Referred_Event) or else
            (EmgEventList_copy.Offset_time) /= (EmgEventListX_copy.Offset_time) then
               pCommandProcess.rSetSeqerror(2);
         end if;
      end if;
      Index:=Index + 1;
   end loop;
   end rEventListIntegrity;
------------------------------------------------------------------------------------------------

   --This module is called by REX to carry out flight reset initialisation of variables in pEventDetection
   procedure rEventDetectionInit is
   begin
      EventDetectedflg:=pSeqmain.NotSet;
      EventDetectedflgX:=pSeqmain.NotSet;
      Accln_count1:=0;
      Accln_count2:=0;
      Current_Event:=0;
      Current_EventC:=16#FFFF#;
      Due_Event:=1;
      Due_EventX:=1;
      for i in tEventTimes'range loop
         EventTimes(i) := 0;
         EventTimesBar(i) := 16#FFFFFFFF#;
      end loop;
      for i in tEmgEventTimes'range loop
         EmgEventTimes(i) := 0;
         EmgEventTimesBar(i) := 16#FFFFFFFF#;
      end loop;
      PerfCheckCnt:=0;
      PerfCheckCntX:=0;
      EnginePerfOKflg:=pSeqmain.NotSet;
      EnginePerfOKflgX:=pSeqmain.NotSet;
      Emergencyflg := pSeqmain.NotSet;
      EmergencyflgX := pSeqmain.NotSet;

      Linkerrindex:=1;
      XLinkerrindex:=1;

      for i in tLinkerr3cycles'range loop
         Linkerr3cycles(i) := pSeqmain.NotSet;
         Linkerr3cyclesX(i) := pSeqmain.NotSet;
      end loop;

      Output_Event:=0;
      Output_EventC:=16#FFFF#;
      EventTime:=0;
   end rEventDetectionInit;

end  pEventDetection;