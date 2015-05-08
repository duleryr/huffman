with Ada.Text_IO;
use Ada.Text_IO;

package body File_Priorite is

   function Nouvelle_File(Taille: Positive) return File is
      F: File;
   begin
      F := new File_Interne(Taille); 
      return F;
   end Nouvelle_File;

   procedure Insertion(F: in out File; P: Priorite; D: Donnee) is
      i : Integer;
      Mem : Cellule;
   begin
      F.Last := F.Last + 1;
      F.Tas(F.Last) := (D,P);
      i := F.last;
      while (i>1) and Compare(F.Tas(i).Prio,F.Tas(i/2).Prio) = INF loop
	 Mem := F.Tas(i);
	 F.Tas(i) := F.tas(i/2);
	 F.Tas(i/2) := Mem;
      end loop;

   end Insertion;

   procedure Meilleur(F: in File; P: out Priorite; D: out Donnee; Statut: out Boolean) is
   begin
      if F.Last = 0 then
	 Statut := False;
      else
	 D := F.Tas(1).Data;
	 P := F.Tas(1).Prio;
	 Statut := True;
      end if;
   end;

   procedure Suppression(F: in out File) is
      i,j : Integer;
   begin
      F.Tas(1) := F.Tas(F.Last);
      i := 1;
      while i < (F.Last/2) loop
	 if 2*i = F.Last or Compare(F.Tas(2*i).Prio,F.Tas(2*i+1).Prio) = INF then
	    j := 2*i;
	 else
	    j := 2*i+1;
	 end if;
	 if Compare(F.Tas(i).Prio,F.Tas(j).Prio) = SUP then
	    declare
	       Mem : Cellule := F.Tas(i);
	    begin
	       F.Tas(i) := F.Tas(j);
	       F.Tas(j) := Mem;
	    end;
	 else
	    return;
	 end if;
      end loop;
   end;
end File_Priorite;
