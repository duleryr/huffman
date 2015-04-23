with Ada.Text_IO;
use Ada.Text_IO;

with GNAT.Debug_Pools;
with System.Storage_Elements;
with System.Storage_Pools;

use System.Storage_Elements;
use System.Storage_Pools;

package body Algo1Pools is

   procedure Allocate
     (Pool                     : in out Algo1Pool;
      Storage_Address          : out Address;
      Size_In_Storage_Elements : in  Storage_Count;
      Alignment                : in  Storage_Count) is
   begin
      GNAT.Debug_Pools.Allocate(Pool.DP,Storage_Address,Size_In_Storage_Elements,Alignment) ;
      if Pool.TailleNom/=0 then
         Put_Line("### Pool " & Pool.NomPool(1..Pool.TailleNom) & ": alloc " &
                  To_Integer(Storage_Address)'Img) ;
      end if ;
      -- ici pour corriger un bug de GNAT,
      -- on teste si l'adresse retournee peut etre dereferencee...
      GNAT.Debug_Pools.Dereference(Pool.DP,Storage_Address,Size_In_Storage_Elements,Alignment) ;
      Pool.NbAlloc := Pool.NbAlloc + 1 ;
   exception
      when GNAT.DEBUG_POOLS.ACCESSING_NOT_ALLOCATED_STORAGE
        | GNAT.DEBUG_POOLS.ACCESSING_DEALLOCATED_STORAGE => raise Storage_Error ;
      when others =>
         Put_Line("Erreur inattendue. Merci de la transmettre à Sylvain.Boulme@imag.fr") ;
         raise ;
   end ;

   procedure Deallocate
     (Pool                     : in out Algo1Pool;
      Storage_Address          : in Address;
      Size_In_Storage_Elements : in Storage_Count;
      Alignment                : in Storage_Count) is
   begin
      Pool.NbDealloc := Pool.NbDealloc + 1 ;
      if Pool.TailleNom/=0 then
         Put_Line("### Pool " & Pool.NomPool(1..Pool.TailleNom) & ": dealloc " &
                  To_Integer(Storage_Address)'Img) ;
      end if ;
      GNAT.Debug_Pools.Deallocate(Pool.DP,Storage_Address,Size_In_Storage_Elements,Alignment) ;
   end ;

   procedure Dereference
     (Pool                     : in out Algo1Pool;
      Storage_Address          : in System.Address;
      Size_In_Storage_Elements : in Storage_Count;
      Alignment                : in Storage_Count) is
   begin
      if Pool.TailleNom/=0 then
         Put_Line("### Pool " & Pool.NomPool(1..Pool.TailleNom) & ": acces " &
                  To_Integer(Storage_Address)'Img) ;
      end if ;
      GNAT.Debug_Pools.Dereference(Pool.DP,Storage_Address,Size_In_Storage_Elements,Alignment) ;
   end ;

   function Storage_Size (Pool : Algo1Pool)  return Storage_Count is
   begin
      return GNAT.Debug_Pools.Storage_Size(Pool.DP) ;
   end ;

   procedure Trace(Pool: in out Algo1Pool; NomPool: String) is
   begin
      Pool.TailleNom := Integer'Min(Pool.NomPool'Length,NomPool'Length) ;
      Pool.NomPool(1..Pool.TailleNom) := NomPool(NomPool'First..NomPool'First+Pool.TailleNom-1) ;
      if Pool.TailleNom/=0 then
         Put_Line("### Pool " & Pool.NomPool(1..Pool.TailleNom) & ": demarrage des traces") ;
      else
         raise Constraint_Error ;
      end if ;
   end ;

   NumPool: Natural := 0 ;

   procedure Trace(Pool: in out Algo1Pool) is
   begin
      Trace(Pool,NumPool'Img) ;
      NumPool := NumPool + 1 ;
   end ;

   procedure Untrace(Pool: in out Algo1Pool) is
   begin
      if Pool.TailleNom/=0 then
         Put_Line("### Pool " & Pool.NomPool(1..Pool.TailleNom) & ": arret des traces") ;
      end if ;
      Pool.TailleNom := 0 ;
   end ;

   --procedure Info is new GNAT.Debug_Pools.Print_Info(Put_Line);

   procedure Print_Info(Pool: Algo1Pool) is
   begin
      if Pool.TailleNom/=0 then
         Put_Line("### Pool " & Pool.NomPool(1..Pool.TailleNom) & ": en trace") ;
      end if ;
      Put_Line("### Occupation memoire (en nombre de cellules) ###") ;
      Put_Line("Nb Total Alloc: " & Natural'Image(NbTotalAlloc(Pool))) ;
      Put_Line("Nb Cour Alloc: " & Natural'Image(NbCourAlloc(Pool))) ;
      -- Info(Pool.DP) ;
      Put_Line("###") ;
   end ;

   function NbTotalAlloc(Pool: Algo1Pool) return Natural is
   begin
      return Pool.NbAlloc ;
   end ;

   function NbTotalDealloc(Pool: Algo1Pool) return Natural is
   begin
      return Pool.NbDealloc ;
   end ;

   function NbCourAlloc(Pool: Algo1Pool) return Natural is
   begin
      return Pool.NbAlloc - Pool.NbDealloc ;
   end ;



end Algo1Pools ;
