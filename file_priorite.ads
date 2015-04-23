-- paquetage file de priorite

with Comparaisons;
use Comparaisons;

generic

        type Priorite is private;
        with function Compare(C1, C2: Priorite) return Comparaison;

        type Donnee is private;

package File_Priorite is

        type File is private;

		--cree une file pouvant contenir au plus 'Taille' elements
        function Nouvelle_File(Taille: Positive) return File;
		--insere un element de la priorite donnee
        procedure Insertion(F: in out File; P: Priorite; D: Donnee);
		--recupere l'element de meilleure priorite ; met le statut a Faux si la file est vide
		--le laisse dans la file
        procedure Meilleur(F: in File; P: out Priorite; D: out Donnee; Statut: out Boolean);
		--supprime l'element de meilleure priorite
        procedure Suppression(F: in out File);

private
        type File_Interne;
        type File is access File_Interne;
end;
