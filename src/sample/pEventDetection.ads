---------------------------------------------------------------------------------------------------------
--- File Name: pEventDetection.ads

--- Title: EventDetection for GSLV-D3

--- Last modified: 15-11-2007

--- Version number: GD3_SE_1.1
---------------------------------------------------------------------------------------------------------

with OBCLIB; use OBCLIB;

package pEventDetection is



   ------------
   --  Brought from package body part
   Current_Event,Current_EventC:unsigned_16;
   EventDetectedflg, EventDetectedflgX: unsigned_16;
   Due_Event,Due_EventX: unsigned_16;

   ------------



   -- Output variables
   Output_Event,Output_EventC:unsigned_16;
   Emergencyflg,EmergencyflgX: unsigned_16;
   EventTime:unsigned_32;

   --------------------------------------------------------------------------------------------------------

   --Checkout init variables
   MaxEventVal : unsigned_16:=10;
   MaxEventValC : unsigned_16:=16#FFFF#-10;
   MaxEmgEventVal: unsigned_16:=2;
   MaxEmgEventValC: unsigned_16:=16#FFFF#-2;


   ---------------------------------------------------------------------------------------------------------

-- flight reset init variables 
   Accln_count1, Accln_count2: unsigned_16;
   type tEventTimes is array (unsigned_16 range 0..20) of unsigned_32;
   EventTimes,EventTimesBar: tEventTimes;
   type tEmgEventTimes is array (unsigned_16 range 0..5) of unsigned_32;
   EmgEventTimes,EmgEventTimesBar: tEmgEventTimes;

   PerfCheckCnt,PerfCheckCntX: unsigned_16;
   EnginePerfOKflg,EnginePerfOKflgX: unsigned_16;
   Linkerrindex,XLinkerrindex: short_integer;
   type tLinkerr3cycles is array (short_integer range 1..3) of unsigned_16;
   Linkerr3cycles,Linkerr3cyclesX: tLinkerr3cycles;
---------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

   -- checkout init variables
   type tEventEntry is
      record
          Trigger_type        : unsigned_16;
          Referred_Event      : unsigned_16;
          Window_in           : unsigned_16;
          Window_out          : unsigned_16;
          Offset_time         : unsigned_16;
          Guid_RefVal         : unsigned_16;
          Accln_RefVal        : float32;
      end record;
   type tEventList is array  (unsigned_16 range 1..20) of tEventEntry;

   type tEventEntryX is
      record
          Trigger_typeC       : unsigned_16;
          Referred_event      : unsigned_16;
          Window_in           : unsigned_16;
          Window_out          : unsigned_16;
          Offset_time         : unsigned_16;
          Guid_RefValC        : unsigned_16;
          Accln_RefVal        : float32;
      end record;
   type tEventListX is array  (unsigned_16 range 1..20) of tEventEntryX;


EventList: tEventList :=(1=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#5dd#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	2=>
		(Trigger_type => 16#1#,
		Referred_Event=> 16#1#,
		Window_in=> 16#14#,
		Window_out=> 16#fffe#,
		Offset_time=> 16#0#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	3=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#2#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#1194#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	4=>
		(Trigger_type => 16#2#,
		Referred_Event=> 16#2#,
		Window_in=> 16#1af4#,
		Window_out=> 16#1de2#,
		Offset_time=> 16#1cc2#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 16.000000),
	5=>
		(Trigger_type => 16#3#,
		Referred_Event=> 16#4#,
		Window_in=> 16#170c#,
		Window_out=> 16#1ac2#,
		Offset_time=> 16#0#,
		Guid_Refval=> 16#11#,
		Accln_RefVal=> 0.000000),
	6=>
		(Trigger_type => 16#4#,
		Referred_Event=> 16#5#,
		Window_in=> 16#0#,
		Window_out=> 16#271#,
		Offset_time=> 16#271#,
		Guid_Refval=> 16#22#,
		Accln_RefVal=> 17.000000),
	7=>
		(Trigger_type => 16#5#,
		Referred_Event=> 16#5#,
		Window_in=> 16#252#,
		Window_out=> 16#31a#,
		Offset_time=> 16#aa#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	8=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#7#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#37#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	9=>
		(Trigger_type => 16#4#,
		Referred_Event=> 16#8#,
		Window_in=> 16#8692#,
		Window_out=> 16#9c72#,
		Offset_time=> 16#9c72#,
		Guid_Refval=> 16#33#,
		Accln_RefVal=> 10.520000),
	10=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#9#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#2ee#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	11=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	12=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	13=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	14=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	15=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	16=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	17=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	18=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	19=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000),
	20=>
		(Trigger_type => 16#0#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_Refval=> 16#0#,
		Accln_RefVal=> 0.000000));
-------------------------------------------------------------------------------------------------------------------------------

 EventListX: tEventListX :=(1=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#5dd#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	2=>
		(Trigger_typeC => 16#fffe#,
		Referred_Event=> 16#1#,
		Window_in=> 16#14#,
		Window_out=> 16#fffe#,
		Offset_time=> 16#0#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	3=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#2#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#1194#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	4=>
		(Trigger_typeC => 16#fffd#,
		Referred_Event=> 16#2#,
		Window_in=> 16#1af4#,
		Window_out=> 16#1de2#,
		Offset_time=> 16#1cc2#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 16.000000),
	5=>
		(Trigger_typeC => 16#fffc#,
		Referred_Event=> 16#4#,
		Window_in=> 16#170c#,
		Window_out=> 16#1ac2#,
		Offset_time=> 16#0#,
		Guid_RefvalC=> 16#ffee#,
		Accln_RefVal=> 0.000000),
	6=>
		(Trigger_typeC => 16#fffb#,
		Referred_Event=> 16#5#,
		Window_in=> 16#0#,
		Window_out=> 16#271#,
		Offset_time=> 16#271#,
		Guid_RefvalC=> 16#ffdd#,
		Accln_RefVal=> 17.000000),
	7=>
		(Trigger_typeC => 16#fffa#,
		Referred_Event=> 16#5#,
		Window_in=> 16#252#,
		Window_out=> 16#31a#,
		Offset_time=> 16#aa#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	8=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#7#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#37#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	9=>
		(Trigger_typeC => 16#fffb#,
		Referred_Event=> 16#8#,
		Window_in=> 16#8692#,
		Window_out=> 16#9c72#,
		Offset_time=> 16#9c72#,
		Guid_RefvalC=> 16#ffcc#,
		Accln_RefVal=> 10.520000),
	10=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#9#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#2ee#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	11=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	12=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	13=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	14=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	15=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	16=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	17=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	18=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	19=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000),
	20=>
		(Trigger_typeC => 16#ffff#,
		Referred_Event=> 16#0#,
		Window_in=> 16#0#,
		Window_out=> 16#0#,
		Offset_time=> 16#0#,
		Guid_RefvalC=> 16#ffff#,
		Accln_RefVal=> 0.000000));
-------------------------------------------------------------------------------------------------------------------------------

   type tEmgEventEntry is
      record
         Referred_Event      : unsigned_16;
         Offset_time         : unsigned_16;
      end record;

   type tEmgEventList is array (unsigned_16 range 1..5) of tEmgEventEntry;-- checkout init

   EmgEventList: tEmgEventList:=(1=>
		(Referred_Event=> 16#0#,
		Offset_time=> 16#0#),
	2=>
		(Referred_Event=> 16#1#,
		Offset_time=> 16#2ee#),
	3=>
		(Referred_Event=> 16#0#,
		Offset_time=> 16#0#),
	4=>
		(Referred_Event=> 16#0#,
		Offset_time=> 16#0#),
	5=>
		(Referred_Event=> 16#0#,
		Offset_time=> 16#0#));


EmgEventListX: tEmgEventList:=(1=>
		(Referred_Event=> 16#0#,
		Offset_time=> 16#0#),
	2=>
		(Referred_Event=> 16#1#,
		Offset_time=> 16#2ee#),
	3=>
		(Referred_Event=> 16#0#,
		Offset_time=> 16#0#),
	4=>
		(Referred_Event=> 16#0#,
		Offset_time=> 16#0#),
	5=>
		(Referred_Event=> 16#0#,
		Offset_time=> 16#0#));


   Accln_emergval: float32:=2.786;-- checkout init
   Accln_emergvalX: float32:=2.786;
-------------------------------------------------------------------------------------------------
   procedure rEventLookOut;
   procedure rEventLookOutX;

   procedure rTTLMP;
   procedure rTTLMPX;

   procedure rTTAccln;
   procedure rTTAcclnX;

   procedure rTTGuidflg;
   procedure rTTGuidflgX;

   procedure rTTPrevEventOffset;
   procedure rTTPrevEventOffsetX;

   procedure rTTReferenceEvent;
   procedure rTTReferenceEventX;

   procedure rEventSet;
   procedure rEmgEventSet;
   procedure rEmergencyEvent;
   procedure rEmergencyEventX;

   -------------------------------------------------------------------------------
   -------------------------------------------------------------------------------
   -------------------------------------------------------------------------------


   procedure rEventController;
   procedure rEventListIntegrity;
   procedure rEventDetectionInit;
   procedure rEnginePerfCheck;
   procedure rEnginePerfCheckX;

   -------------------------------
   -- Brought from package body part
   procedure rEventSync;
   procedure rEventSyncX;

   -------------------------------



end  pEventDetection;