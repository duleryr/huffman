with Ada.Text_IO, Comparaisons, File_Priorite;
use Ada.Text_IO, Comparaisons;

package body Arbre_Huffman is

	package Ma_File is new File_Priorite(Natural, Compare, Arbre);
	use Ma_File;

	type TabFils is array(ChiffreBinaire) of Arbre ;

	type Noeud(EstFeuille: Boolean) is record
		case EstFeuille is
			when True => Char : Character;
			when False =>
				Fils: TabFils;
				-- on a: Fils(0) /= null and Fils(1) /= null
		end case ;
	end record;

	procedure Affiche_Arbre(A: Arbre) is
	begin
		null; -- TODO
	end Affiche_Arbre;

	--algo principal : calcul l'arbre a partir des frequences
	function Calcul_Arbre(Frequences : in Tableau_Ascii) return Arbre is
		A : Arbre;
	begin
		return A; -- TODO
	end Calcul_Arbre;

	function Calcul_Dictionnaire(A : Arbre) return Dico is
		D : Dico;
	begin
		-- TODO
		return D;
	end;

	procedure Decodage_Code(Reste : in out Code;
		Arbre_Huffman : Arbre;
		Caractere : out Character) is

		Position_Courante : Arbre;
		Tmp,R : Natural;
		Nouveau_Reste : Code;
	begin
		Position_Courante := Arbre_Huffman;
		while not Position_Courante.EstFeuille loop
			if Reste = null then
				--chargement de l'octet suivant du fichier
				Reste := new TabBits(1..8);
				Caractere := Octet_Suivant;
				Tmp := Character'Pos(Caractere);
				for I in Reste'Range loop
					R := Tmp mod 2;
					Reste(Reste'Last + Reste'First - I) := R;
					Tmp := Tmp / 2;
				end loop;
			end if;
			Position_Courante := Position_Courante.Fils(Reste(1)) ;
			if Reste'Last = 1 then
				Liberer(Reste);
				Reste := null;
			else
				-- TODO : modifier cette procedure
				-- pour eviter de faire a chaque iteration
				-- une allocation + 1 liberation
				Nouveau_Reste := new TabBits(1..(Reste'Last - 1));
				for I in Nouveau_Reste'Range loop
					Nouveau_Reste(I) := Reste(I+1);
				end loop;
				Liberer(Reste);
				Reste := Nouveau_Reste;
			end if;
		end loop;
		Caractere := Position_Courante.Char;
	end;

end;
