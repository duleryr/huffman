-- introduit le type enumere des comparaisons.

package Comparaisons is

   type Comparaison is (EQ, INF, SUP) ;

   function Compare(X,Y: Integer) return Comparaison ;
   -- comparaison pour l'ordre "<=" sur les Integer.

   function Compare(X,Y: Character) return Comparaison ;
   -- comparaison pour l'ordre "<=" sur les Character.

   function Compare(S1,S2: String) return Comparaison ;
   -- comparaison pour l'ordre "<=" sur les String.

end Comparaisons ;
