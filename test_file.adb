with Comparaisons, File_Priorite, Ada.Text_IO, Ada.Integer_Text_IO;
use Comparaisons, Ada.Text_IO, Ada.Integer_Text_IO;


procedure test_file is

	package Ma_File is new File_Priorite(Natural, Compare, Natural);
	use Ma_File;

	F: File;

	C: Boolean;
	E, P1: Natural;

begin

	F := Nouvelle_File(10);
	Insertion(F, 10, 10);
	Insertion(F, 11, 11);
	Insertion(F, 8, 8);
	Insertion(F, 3, 3);
	Insertion(F, 7, 7);
	Insertion(F, 15, 15);
	C := true;
	while C loop
		Meilleur(F, P1, E, C);
		if C then
			Put(E);
			New_line;
			Suppression(F);
		end if;
	end loop;
end test_file;
