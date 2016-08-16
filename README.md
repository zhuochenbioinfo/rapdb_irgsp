# rapdb_irgsp
Modify the format of rap-db Nipponbare genome annotation to fit the IRGSP genome.

The rap-db Nipponbare annotation and IRGSP Nipponbare annotation share almost the same genome since 2013. The difference between the two genomes is the name format of the chromosomes.
The rap-db gene annotation files are split into locus.gff, transcripts.gff and transcripts_exon.gff. It is quite unconvinience to use in some situations. 
So here I merge the three gff files of rap-db gene annotation and make them fit the Nipponbare genome of IRGSP.
