package body Comparaisons is

   generic
      type T is (<>) ;
   function GenCompare(X,Y: T) return Comparaison ;

   function GenCompare(X,Y: T) return Comparaison is
   begin
      if X=Y then
         return EQ ;
      elsif X<Y then
         return INF ;
      else
         return SUP ;
      end if ;
   end ;

   function IntCompare is new GenCompare(Integer) ;
   function Compare(X,Y:Integer) return Comparaison renames IntCompare ;

   function CharCompare is new GenCompare(Character) ;
   function Compare(X,Y:Character) return Comparaison renames CharCompare ;

   function Compare(S1,S2: String) return Comparaison is
      I1,I2: Integer ;
   begin
      I1:=S1'First ;
      I2:=S2'First ;
      if I1 > S1'Last then
         if I2 > S2'Last then
            return EQ ;
         else
            return INF ;
         end if ;
      elsif I2 > S2'Last then
         return SUP ;
      end if ;
      loop
         -- invariant:
         --   I1 <= S1'Last et I2 <= S2'Last
         --   et les chaines coincident jusque I1-1/I2-1.
         if S1(I1) > S2(I2) then
            return SUP ;
         elsif S1(I1) < S2(I2) then
            return INF ;
         elsif I1=S1'Last then
            if I2=S2'Last then
               return EQ ;
            else
               return INF ;
            end if ;
         elsif I2=S2'Last then
            return SUP ;
         else
            I1:=I1+1 ;
            I2:=I2+1 ;
         end if ;
      end loop ;
   end ;

end Comparaisons ;
