sqlIZSLER<- "SELECT
  dbo.Conferimenti.Numero,
  dbo_Anag_Referenti_Prop.Ragione_Sociale,
  dbo_Anag_Referenti_Prop.Indirizzo,
  dbo.Anag_Specie.Descrizione,
  dbo.Anag_Materiali.Descrizione,
  dbo.Anag_Comuni.Descrizione ,
  dbo.Conferimenti.Ind_Luogo_Prelievo,
  dbo.Anag_Prove.Descrizione,
  dbo.Risultati_Analisi_Descrittivi.Osservazioni,
  dbo_Anag_Tipo_Dett_Diagnostica.Descrizione,
  dbo_Anag_Dettagli_Diagnostica.Dettaglio,
  dbo.Risultati_Analisi_Dettagli.Testo_Dettaglio,
  dbo_Anag_Referenti_DestRdP.Indirizzo,
  dbo_Anag_Referenti_DestRdP.Ragione_Sociale,
  dbo_Anag_Comuni_DestRDP.CAP
FROM
{ oj dbo.Anag_Referenti  dbo_Anag_Referenti_Prop RIGHT OUTER JOIN dbo.Conferimenti ON ( dbo_Anag_Referenti_Prop.Codice=dbo.Conferimenti.Proprietario )
   INNER JOIN dbo.Anag_Comuni ON ( dbo.Anag_Comuni.Codice=dbo.Conferimenti.Luogo_Prelievo )
   LEFT OUTER JOIN dbo.Esami_Aggregati ON ( dbo.Conferimenti.Anno=dbo.Esami_Aggregati.Anno_Conferimento and dbo.Conferimenti.Numero=dbo.Esami_Aggregati.Numero_Conferimento )
   LEFT OUTER JOIN dbo.Nomenclatore_MP ON ( dbo.Esami_Aggregati.Nomenclatore=dbo.Nomenclatore_MP.Codice )
   LEFT OUTER JOIN dbo.Nomenclatore_Settori ON ( dbo.Nomenclatore_MP.Nomenclatore_Settore=dbo.Nomenclatore_Settori.Codice )
   LEFT OUTER JOIN dbo.Nomenclatore ON ( dbo.Nomenclatore_Settori.Codice_Nomenclatore=dbo.Nomenclatore.Chiave )
   LEFT OUTER JOIN dbo.Anag_Prove ON ( dbo.Nomenclatore.Codice_Prova=dbo.Anag_Prove.Codice )
   LEFT OUTER JOIN dbo.Anag_Gruppo_Prove ON ( dbo.Nomenclatore.Codice_Gruppo=dbo.Anag_Gruppo_Prove.Codice )
   INNER JOIN dbo.Indice_Campioni_Esaminati ON ( dbo.Esami_Aggregati.Anno_Conferimento=dbo.Indice_Campioni_Esaminati.Anno_Conferimento and dbo.Esami_Aggregati.Numero_Conferimento=dbo.Indice_Campioni_Esaminati.Numero_Conferimento and dbo.Esami_Aggregati.Codice=dbo.Indice_Campioni_Esaminati.Codice )
   LEFT OUTER JOIN dbo.Risultati_Analisi_Dettagli ON ( dbo.Indice_Campioni_Esaminati.Anno_Conferimento=dbo.Risultati_Analisi_Dettagli.Anno_Conferimento and dbo.Indice_Campioni_Esaminati.Numero_Conferimento=dbo.Risultati_Analisi_Dettagli.Numero_Conferimento and dbo.Indice_Campioni_Esaminati.Numero_Campione=dbo.Risultati_Analisi_Dettagli.Numero_Campione and dbo.Indice_Campioni_Esaminati.Codice=dbo.Risultati_Analisi_Dettagli.Codice_Programmazione )
   LEFT OUTER JOIN dbo.Anag_Dettagli  dbo_Anag_Dettagli_Diagnostica ON ( dbo.Risultati_Analisi_Dettagli.Codice_Dettaglio=dbo_Anag_Dettagli_Diagnostica.Codice )
   LEFT OUTER JOIN dbo.Anag_Tipo_Dett  dbo_Anag_Tipo_Dett_Diagnostica ON ( dbo.Risultati_Analisi_Dettagli.Tipo_Dettaglio=dbo_Anag_Tipo_Dett_Diagnostica.Codice )
   LEFT OUTER JOIN dbo.Risultati_Analisi_Descrittivi ON ( dbo.Risultati_Analisi_Descrittivi.Anno_Conferimento=dbo.Esami_Aggregati.Anno_Conferimento and dbo.Risultati_Analisi_Descrittivi.Numero_Conferimento=dbo.Esami_Aggregati.Numero_Conferimento and dbo.Risultati_Analisi_Descrittivi.Codice=dbo.Esami_Aggregati.Codice )
   INNER JOIN dbo.Anag_Referenti  dbo_Anag_Referenti_DestRdP ON ( dbo.Conferimenti.Dest_Rapporto_Prova=dbo_Anag_Referenti_DestRdP.Codice )
   LEFT OUTER JOIN dbo.Anag_Comuni  dbo_Anag_Comuni_DestRDP ON ( dbo_Anag_Comuni_DestRDP.Codice=dbo_Anag_Referenti_DestRdP.Comune )
   INNER JOIN dbo.Laboratori_Reparto  dbo_Laboratori_Reparto_ConfAcc ON ( dbo.Conferimenti.RepLab_Conferente=dbo_Laboratori_Reparto_ConfAcc.Chiave )
   INNER JOIN dbo.Anag_Reparti  dbo_Anag_Reparti_ConfAcc ON ( dbo_Laboratori_Reparto_ConfAcc.Reparto=dbo_Anag_Reparti_ConfAcc.Codice )
   LEFT OUTER JOIN dbo.Anag_Materiali ON ( dbo.Anag_Materiali.Codice=dbo.Conferimenti.Codice_Materiale )
   LEFT OUTER JOIN dbo.Anag_Specie ON ( dbo.Anag_Specie.Codice=dbo.Conferimenti.Codice_Specie )
   LEFT OUTER JOIN dbo.Anag_Gruppo_Specie ON ( dbo.Anag_Specie.Cod_Darc1=dbo.Anag_Gruppo_Specie.Codice )
  }
WHERE
  dbo.Esami_Aggregati.Esame_Altro_Ente = 0
  AND  dbo.Esami_Aggregati.Esame_Altro_Ente = 0
  AND  (
  dbo_Anag_Reparti_ConfAcc.Descrizione  =  'Sede Territoriale di Bologna'
  AND  dbo.Anag_Gruppo_Specie.Descrizione  =  'CANE'
  AND  dbo.Anag_Comuni.Provincia  =  'BO'
  AND  {fn year(dbo.Conferimenti.Data_Prelievo)}  >=  2019
  AND  {fn year(dbo.Conferimenti.Data_Prelievo)}  <  2024
  AND  dbo.Anag_Gruppo_Prove.Descrizione  =  'Esame Istologico'
  )
"