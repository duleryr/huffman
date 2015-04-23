with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Streams.Stream_IO, Arbre_Huffman;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Streams.Stream_IO, Arbre_Huffman;

procedure Huffman is

	Fichier_Invalide : exception;
	--calcul des frequences d'apparition des lettre dans un fichier
	procedure Lecture_Frequences(Nom_Fichier: in String ;
		Frequences : out Tableau_Ascii ;
		Taille : out Natural) is

		Fichier: Ada.Streams.Stream_IO.File_Type;
		Acces : Stream_Access;
		Char: Character;
	begin
		for I in Frequences'range loop
			Frequences(I) := 0;
		end loop;

		Open(Fichier, In_File, Nom_Fichier);
		Acces := Stream (Fichier);
		Taille := 0;

		while not End_Of_File(Fichier) loop
			Char := Character'input(Acces);
			Taille := Taille + 1;
			Frequences(Char) := Frequences(Char) + 1;
		end loop;
		Close(Fichier);
	end Lecture_Frequences;

	--affichage pour info et verifications
	--affiche pour chaque caractere du fichier le nombre de fois qu'il apparait
	procedure Affiche_Frequences(Frequences: Tableau_Ascii) is
	begin
		for I in Frequences'range loop
			if Frequences(I) > 0 then
				Put("le caractère '");
				Put(I);
				Put("' apparait ");
				Put(Frequences(I));
				Put(" fois");
				New_Line;
			end if;
		end loop;
	end Affiche_Frequences;

	--recupere le prochain caractere a ecrire dans le fichier compresse
	procedure Recuperation_Caractere(Reste : in out Code;
		Entree : Ada.Streams.Stream_IO.File_Type ;
		Acces : in out Stream_Access ;
		Caractere_Sortie : out Character ;
		D : Dico) is

		Compte : Natural; --combien de bits on a reussi a generer
		Nouveau_Reste : Code; --les bits encore inutilises apres generation du caractere
		Caractere_Entree : Character; --le prochain caractere lu dans le fichier non compresse
	begin
		-- on recupere les 8 premiers octets du code
		-- si il n'y en a pas assez, on lit un nouveau code a partir
		-- du fichier d'entree
		Compte := 0;
		Caractere_Sortie := Character'Val(0);
		while Compte /= 8 loop
			if (Reste = null) then
				--lecture d'un nouveau code a partir du fichier
				if (End_Of_File(Entree)) then
					--a la fin du fichier, il est necessaire de rajouter quelques zero
					Reste := new TabBits(1..(8-Compte));
					for I in Reste'Range loop
						Reste(I) := 0;
					end loop;
				else
					Caractere_Entree := Character'Input(Acces);
					--attention, il faut faire une copie de l'original
					--afin de pouvoir liberer la memoire plus tard
					Reste := D(Caractere_Entree);
					Nouveau_Reste := new TabBits(Reste'Range);
					For I in Reste'Range loop
						Nouveau_Reste(I) := Reste(I);
					end loop;
					Reste := Nouveau_Reste;
				end if;
			end if;
			for I in Reste'Range loop
				Caractere_Sortie := Character'Val(Character'Pos(Caractere_Sortie) * 2 + Reste(I));
				Compte := Compte + 1;
				if Compte = 8 then
					--mise a jour du reste
					if (Reste'Last - I) > 0 then
						Nouveau_Reste := new TabBits(1..(Reste'Last - I));
						for J in Nouveau_Reste'Range loop
							Nouveau_Reste(J) := Reste(I+J);
						end loop;
						Liberer(Reste);
						Reste := Nouveau_Reste;
					else
						Liberer(Reste);
						Reste := null;
					end if;
					return;
				end if;
			end loop;
			Liberer(Reste);
			Reste := null;
		end loop;

	end Recuperation_Caractere;


	procedure Compression(Fichier_Entree, Fichier_Sortie: String) is
		Arbre_Huffman : Arbre;
		Frequences : Tableau_Ascii;
		Taille : Positive;
		Entree, Sortie: Ada.Streams.Stream_IO.File_Type;
		EAcces, SAcces : Stream_Access;
		Reste : Code;
		Caractere_Sortie : Character;
		D : Dico;
	begin
		Lecture_Frequences(Fichier_Entree, Frequences, Taille);
		Affiche_Frequences(Frequences);
		Arbre_Huffman := Calcul_Arbre(Frequences);
		Affiche_Arbre(Arbre_Huffman);
		D := Calcul_Dictionnaire(Arbre_Huffman);
		Create(Sortie, Out_File, Fichier_Sortie);
		SAcces := Stream( Sortie );
		Natural'Output(Sacces, Taille);
		Tableau_Ascii'Output(Sacces,Frequences) ;
		Open(Entree, In_File, Fichier_Entree);
		EAcces := Stream(Entree);
		Reste := null;
		while (not End_Of_File(Entree)) or Reste /= null loop
			Recuperation_Caractere(Reste, Entree, EAcces, Caractere_Sortie, D);
			Character'Output(SAcces, Caractere_Sortie);
		end loop;
		Close(Entree);
		Close(Sortie);
	end Compression;

	procedure Decompression(Fichier_Entree: String; Fichier_Sortie: String) is
		Arbre_Huffman: Arbre;
		Taille, Octets_Ecrits: Natural;
		Caractere: Character;
		Entree, Sortie: Ada.Streams.Stream_IO.File_Type;
		Reste : Code;
		EAcces, SAcces : Stream_Access;

		function Lecture_Octet_Compresse return Character is
		begin
			return Character'Input(EAcces);
		end;

		procedure Caractere_Suivant is new Decodage_Code(Lecture_Octet_Compresse);

	begin
		Open(Entree, In_File, Fichier_Entree);
		EAcces := Stream( Entree );
		Taille := Natural'Input(EAcces);
		Arbre_Huffman := Calcul_Arbre(Tableau_Ascii'Input(EAcces)) ;
		Create(Sortie, Out_File, Fichier_Sortie);
		SAcces := Stream (Sortie);
		Reste := null;
		Octets_Ecrits := 0;
		while(Octets_Ecrits < Taille) loop
			Caractere_Suivant(Reste, Arbre_Huffman, Caractere);
			Octets_Ecrits := Octets_Ecrits + 1;
			Character'Output(SAcces, Caractere);
		end loop;
		Close(Entree);
		Close(Sortie);
		if (Octets_Ecrits /= Taille) then
			Put(Standard_Error, "Fichier Invalide");
			raise Fichier_Invalide;
		end if;
	end Decompression;

begin

	if (Argument_Count /= 3) then
		Put_Line("utilisation:");
		Put_Line("  compression : ./huffman -c fichier.txt fichier.txt.huff");
		Put_Line("  decompression : ./huffman -d fichier.txt.huff fichier.txt");
		Set_Exit_Status(Failure);
		return;
	end if;

	if (Argument(1) = "-c") then
		Compression(Argument(2), Argument(3));
	else
		Decompression(Argument(2), Argument(3));
	end if;

	Set_Exit_Status(Success);

end Huffman;
