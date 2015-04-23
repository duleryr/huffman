with GNAT.Debug_Pools;
with System.Storage_Elements;
with System.Checked_Pools;

use System ;
use System.Storage_Elements;

package Algo1Pools is

   -- un "pool" est le nom Ada pour désigner un "tas".
   type Algo1Pool is new System.Checked_Pools.Checked_Pool with private ;

   ---------
   -- procedures et fonctions pour evaluer le cout en memoire
   -- des programmes.
   procedure Print_Info(Pool: Algo1Pool) ;

   function NbTotalAlloc(Pool: Algo1Pool) return Natural ;

   function NbTotalDealloc(Pool: Algo1Pool) return Natural ;

   function NbCourAlloc(Pool: Algo1Pool) return Natural ;

   ---------
   -- procedures pour aider au débogage en traçant les accès au pool.

   procedure Trace(Pool: in out Algo1Pool; NomPool: String) ;
   -- requiert NomPool'Length > 0
   -- trace les prochains accès au Pool avec en donnant un nom "NomPool"

   procedure Trace(Pool: in out Algo1Pool) ;
   -- trace les prochains accès au Pool avec un nom par defaut.

   procedure Untrace(Pool: in out Algo1Pool) ;
   -- arret des traces.


   ------------
   -- procedures et fonctions necessaires pour la gestion du pool.
   procedure Allocate
     (Pool                     : in out Algo1Pool;
      Storage_Address          : out Address;
      Size_In_Storage_Elements : in  Storage_Count;
      Alignment                : in  Storage_Count) ;

   procedure Deallocate
     (Pool                     : in out Algo1Pool;
      Storage_Address          : in Address;
      Size_In_Storage_Elements : in Storage_Count;
      Alignment                : in Storage_Count) ;

   function Storage_Size (Pool : Algo1Pool)  return Storage_Count ;

   procedure Dereference
     (Pool                     : in out Algo1Pool;
      Storage_Address          : in System.Address;
      Size_In_Storage_Elements : in Storage_Count;
      Alignment                : in Storage_Count);

private

   type Algo1Pool is new System.Checked_Pools.Checked_Pool with
      record
         NbAlloc, NbDealloc: Natural := 0 ;
         DP: GNAT.Debug_Pools.Debug_Pool ;
         NomPool: String(1..10) ;
         TailleNom: Natural := 0 ;
      end record ;

end Algo1Pools ;
