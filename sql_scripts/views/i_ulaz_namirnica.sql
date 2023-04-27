CREATE OR REPLACE VIEW v_i_ulaz_namirnica (
   id,
   datum,
   id_mt,
   kolicina,
   user_dodavanja,
   datum_dodavanja,
   user_izmjene,
   datum_izmjene,
   id_namirnice,
   sifra_namirnice,
   naziv_namirnice)
AS
SELECT un.id,
       un.datum,
       un.id_mt,
       un.kolicina,
       un.user_dodavanja,
       un.datum_dodavanja,
       un.user_izmjene,
       un.datum_izmjene,
       un.id_namirnice,
       nam.sifra,
       nam.naziv
  FROM i_ulaz_namirnica un,
       m_namirnice      nam
 WHERE un.id_namirnice = nam.id
/