with Ada.Unchecked_Deallocation;

package Arbre_Huffman is
	--stockage des frequences
	type Tableau_Ascii is array(Character) of Natural;
	--un bit
	subtype ChiffreBinaire is Integer range 0..1 ;
	--arbre
	type Arbre is private;

	function Calcul_Arbre(Frequences : in Tableau_Ascii) return Arbre;
	procedure Affiche_Arbre(A: Arbre);

	--un code binaire
	type TabBits is array(Positive range <>) of ChiffreBinaire ;
	type Code is access TabBits;
	procedure Liberer is new Ada.Unchecked_Deallocation(TabBits, Code);

	--dictionnaire des codes
	type Dico is array(Character) of Code;
	--stocke le code de chaque caractere
	function Calcul_Dictionnaire(A : Arbre) return Dico;

	generic
		with function Octet_Suivant return Character;
		--decodage_code prend un reste d'octet non decode
		--un arbre
		--et calcule le caractere correspondant
		--il peut recuperer des octets supplementaires si besoin a l'aide de la fonction 'octet_suivant'
		--remplace l'ancien reste par le nouveau
		procedure Decodage_Code(Reste : in out Code;
			Arbre_Huffman : Arbre;
			Caractere : out Character);
private
	type Noeud;
	type Arbre is access Noeud;
end;
