with Ada.Exceptions;
with Ada_Lib.Options;
with Gnoga.Gui.Window;
with GNAT.Source_Info;
with Gnoga.Types;

package Gnoga_Ada_Lib is

   type Connection_Data_Type is new Gnoga.Types.Connection_Data_Type with
                                    record
         Main_Window : Gnoga.Gui.Window.Pointer_To_Window_Class := Null;
         Options     : Ada_Lib.Options.Interface_Options_Class_Access := Null;
      end record;

   type Connection_Data_Access is access all Connection_Data_Type;
   type Connection_Data_Class_Access is access all Connection_Data_Type'class;

   procedure Clear_Connection_Data;

   function Get_Connection_Data (
      From           : in     String := GNAT.Source_Info.Source_Location
   ) return Connection_Data_Class_Access;

   function Has_Connection_Data (
      From           : in     String := GNAT.Source_Info.Source_Location
   ) return Boolean;

   procedure Report_Exception (
      Window         : in out Gnoga.Gui.Window.Window_Type'class;
      Fault          : in     Ada.Exceptions.Exception_Occurrence;
      Message        : in     String;
      Where          : in     String := GNAT.Source_Info.Source_Location);

   procedure Set_Connection_Data (
      Connection_Data   : in     Connection_Data_Class_Access;
      From              : in     String := GNAT.Source_Info.Source_Location);

   procedure Set_Main_Window (
      Connection_Data         : in out Connection_Data_Type;
      Main_Window             : in     Gnoga.Gui.Window.
                                          Pointer_To_Window_Class);
end Gnoga_Ada_Lib;
