param buszDb;
set Buszok :=1..buszDb;
set Szerelok;
param napDb;
set Napok :=1..napDb;

param ellenorzes {Buszok}; #hany naponta kell a buszokat ellenorizni
param kIdo {Buszok,Szerelok}; #karbantartasi idok szerelok szerint oraban megadva
#1-12ig a buszok regi ikarusok es a szerelo1 gyorsabban meg tudja oket javitani, mig 13-25ig uj credok es a szerelo2 tudja oket gyorsabban megjavitani
param beosztas {Napok}, symbolic, in Szerelok; #melyik nap ki dolgozik

param munkaora;
param oraber {Szerelok};
param buszszukseglet {Napok};

var ell {Napok,Buszok}, binary; #naponta milyen buszokat ellenorzok
var garazs {Napok,Buszok},binary; #nap vegen garazsban van-e vagy nem
var uzemkepes {Napok,Buszok},binary; #uzemkepes-e egy busz egy nap ->nem ellenorzik es nincs a garazsban

s.t. kezdetbenMindenBuszUzemkepes {b in Buszok} : uzemkepes[1,b]=1;

s.t. uzemkepesBeallitasa {n in Napok,b in Buszok: n>ellenorzes[b]} :
sum{nm in Napok : nm>=n-ellenorzes[b] && nm<=n} ell[nm,b]>=uzemkepes[n,b];

s.t. aktualisAllapot {n in Napok, b in Buszok} : garazs[n,b]+uzemkepes[n,b]+ell[n,b]=1;

s.t. aMunkaIdotNeLepjukTul{n in Napok} :
sum{b in Buszok} ell[n,b]*kIdo[b,beosztas[n]]<=munkaora;

s.t. mennyiBuszraVanSzuksegAznap{n in Napok} :
sum{b in Buszok} uzemkepes[n,b]>=buszszukseglet[n];

minimize koltseg : sum{n in Napok,b in Buszok} ell[n,b]*kIdo[b,beosztas[n]]*oraber[beosztas[n]];

solve;
for{n in Napok}
{
	printf"\n%d. nap :\n\tEllenorizve:",n;
	for{b in Buszok : ell[n,b]=1}
	{
		printf" %d",b;
	}
	printf"\n\tUzemkepes:";
	for{b in Buszok : uzemkepes[n,b]=1}
	{
		printf" %d",b;
	}
	printf"\n\tGarazsban maradt:";
	for{b in Buszok : garazs[n,b]=1}
	{
		printf" %d",b;
	}
}
end;
