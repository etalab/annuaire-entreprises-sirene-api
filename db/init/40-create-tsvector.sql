\c sirene sirene;

ALTER TABLE siren ADD COLUMN tsv tsvector;

/*UPDATE siren SET tsv = to_tsvector(coalesce(denominationunitelegale,''));*/
UPDATE siren SET tsv = setweight(to_tsvector(coalesce(denominationunitelegale,'')), 'A') || setweight(to_tsvector(coalesce(nomunitelegale,'')), 'B') || setweight(to_tsvector(coalesce(prenom1unitelegale,'')), 'C');

CREATE INDEX siren_tsv ON siren USING gin(tsv);


