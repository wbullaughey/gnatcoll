with GNOGA_Options;
with Ada_Lib.Trace; use Ada_Lib.Trace;

package body GNOGA_Ada_Lib is

   Debug                         : Boolean renames GNOGA_Options.GNOGA_Ada_Lib_Debug;
   Program_Connection_Data       : Connection_Data_Class_Access := Null;

   ---------------------------------------------------------------
   procedure Clear_Connection_Data is
   ---------------------------------------------------------------

   begin
      Log_Here (Debug);
      Program_Connection_Data := Null;
   end Clear_Connection_Data;

   ---------------------------------------------------------------
   function Get_Connection_Data (
      From                       : in     String := GNAT.Source_Info.Source_Location
   ) return Connection_Data_Class_Access is
   ---------------------------------------------------------------

   begin
      Log_Here (Debug, "Connection_Data from " & From & " " &
         Tag_Name (Program_Connection_Data.all'tag) & " " &
         Image (Program_Connection_Data.all'address));
      return Program_Connection_Data;
   end Get_Connection_Data;

   ---------------------------------------------------------------
   function Has_Connection_Data (
      From                       : in     String := GNAT.Source_Info.Source_Location
   ) return Boolean is
   ---------------------------------------------------------------

      Result                     : constant Boolean :=
                                    Program_Connection_Data /= Null;
   begin
      Log_Here (Debug, "result " & Result'img & " " & (if Result then
            Tag_Name (Program_Connection_Data.all'tag)
         else
            "") &
         " from " & From);
      return Result;
   end Has_Connection_Data;

   ----------------------------------------------------------------
   procedure Report_Exception (
      Window                     : in out Gnoga.Gui.Window.Window_Type'class;
      Fault                      : in     Ada.Exceptions.Exception_Occurrence;
      Message                    : in     String;
      Where                      : in     String := GNAT.Source_Info.Source_Location) is
   ----------------------------------------------------------------

      Error_Message              : constant String :=
                                    Ada.Exceptions.Exception_Message (Fault) &
                                    ". " & Message & (if Debug then
                                          " raised at " & Where
                                       else
                                          "");
   begin
      Window.Alert (Error_Message);
   end Report_Exception;

   ---------------------------------------------------------------
   procedure Set_Connection_Data (
      Connection_Data            : in     Connection_Data_Class_Access;
      From                       : in     String := GNAT.Source_Info.Source_Location) is
   ---------------------------------------------------------------

   begin
      Log_In (Debug, "Connection_Data " &
         Tag_Name (Connection_Data.all'tag) & " " &
         Image (Connection_Data.all'address) & " from " & From);
      Program_Connection_Data := Connection_Data;
      Log_Out (Debug);
   end Set_Connection_Data;

   ---------------------------------------------------------------
   procedure Set_Main_Window (
      Connection_Data         : in out Connection_Data_Type;
      Main_Window             : in     Standard.Gnoga.Gui.Window.
                                          Pointer_To_Window_Class) is
   ---------------------------------------------------------------

   begin
      Connection_Data.Main_Window := Main_Window;
   end Set_Main_Window;
   ---------------------------------------------------------------

begin
--debug := True;
   Standard.Ada_Lib.Trace.Log_Here (Debug);

end GNOGA_Ada_Lib;


