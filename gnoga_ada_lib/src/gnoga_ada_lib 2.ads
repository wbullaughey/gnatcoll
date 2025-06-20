with Ada.Exceptions;
with Ada_Lib.Options;
with GNAT.Source_Info;
with Gnoga.Gui.Window;
with Gnoga.Types;

package GNOGA_Ada_Lib is

   procedure Clear_Connection_Data
   with Pre => Has_Connection_Data;

   function Has_Connection_Data (
      From                       : in     String := GNAT.Source_Info.Source_Location
   ) return Boolean;

   procedure Report_Exception (
      Window                     : in out Gnoga.Gui.Window.Window_Type'class;
      Fault                      : in     Ada.Exceptions.Exception_Occurrence;
      Message                    : in     String;
      Where                      : in     String := GNAT.Source_Info.Source_Location);

   type Connection_Data_Type is new Standard.Gnoga.Types.Connection_Data_Type with
                                    record
         Main_Window             : Standard.Gnoga.Gui.Window.
                                    Pointer_To_Window_Class := Null;
         Options                 : Standard.Ada_Lib.Options.Interface_Options_Class_Access := Null;
      end record;

   type Connection_Data_Access is access all Connection_Data_Type;
   type Connection_Data_Class_Access is access all Connection_Data_Type'class;

   function Get_Connection_Data (
      From                       : in     String := GNAT.Source_Info.Source_Location
   ) return Connection_Data_Class_Access
   with Pre => Has_Connection_Data (From);

   procedure Set_Connection_Data (
      Connection_Data            : in     Connection_Data_Class_Access;
      From                       : in     String := GNAT.Source_Info.Source_Location
   ) with Pre => Connection_Data /= Null and then
                 not Has_Connection_Data,
          Post => Has_Connection_Data;

   procedure Set_Main_Window (
      Connection_Data         : in out Connection_Data_Type;
      Main_Window             : in     Standard.Gnoga.Gui.Window.
                                          Pointer_To_Window_Class);
   Debug                         : Boolean := False;

--private

-- Trace                         : Boolean := False;

end GNOGA_Ada_Lib;
