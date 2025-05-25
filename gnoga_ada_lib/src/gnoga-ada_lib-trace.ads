with GNAT.Source_Info;
with Gnoga.Gui.Base;

package Gnoga.Ada_Lib.Trace is

   procedure Dump (
      Object                     : in     Gnoga.Gui.Base.Base_Type;
      From                       : in     String := GNAT.Source_Info.Source_Location);

   procedure Dump (
      Condition                  : in     Boolean;
      Object                     : in     Gnoga.Gui.Base.Base_Type;
      From                       : in     String := GNAT.Source_Info.Source_Location);

end Gnoga.Ada_Lib.Trace;
