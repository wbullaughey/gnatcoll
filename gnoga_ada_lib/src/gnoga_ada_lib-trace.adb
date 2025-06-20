with Ada.Text_IO; use Ada.Text_IO;

package body GNOGA_Ada_Lib.Trace is

   -------------------------------------------------------------------
   procedure Dump (
      Object                     : in     Gnoga.Gui.Base.Base_Type;
      From                       : in     String := GNAT.Source_Info.Source_Location) is
   -------------------------------------------------------------------

   begin
      Put_Line ("Dump called from " & From);
      Put_Line ("Dynamic:        " & Object.Dynamic'Img);
      Put_Line ("Unique_ID:      " & Object.Unique_ID'Img);
      Put_Line ("Connection_ID:  " & Object.Connection_ID'Img);
      Put_Line ("Valid:          " & Object.Valid'Img);
      Put_Line ("ID:             " & Object.ID);
      Put_Line ("ID_Type:        " & Object.ID_Type'Img);
   end Dump;

   -------------------------------------------------------------------
   procedure Dump (
      Condition                  : in     Boolean;
      Object                     : in     Gnoga.Gui.Base.Base_Type;
      From                       : in     String := GNAT.Source_Info.Source_Location) is
   -------------------------------------------------------------------

   begin
      if Condition then
         Dump (Object, From);
      end if;
   end Dump;

end GNOGA_Ada_Lib.Trace;
