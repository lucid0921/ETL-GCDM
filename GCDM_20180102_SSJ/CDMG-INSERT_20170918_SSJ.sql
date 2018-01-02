---------------------------------------
-- GCDM-INSERT_20170918_SSJ
---------------------------------------

----------------------
-- sequencing table
----------------------
INSERT INTO
dbo.sequencing (
	[sequencing_id]
      ,[person_id]
	  ,[order_date]
	  ,[order_code]
      ,[biomaterial_collecting_date]
      ,[biomaterial_collecting_datetime]
      ,[specimen_id]
      ,[procedure_id]
      ,[note_id]
      ,[device_concept_id]
      ,[device_source_value]
      ,[library_preparation_concept_id]
      ,[library_preparation_source_value]
      ,[target_capture_concept_id]
      ,[target_capture_source_value]
      ,[read_type_concept_id]
      ,[read_type_source_value]
      ,[read_length]
      ,[alignment_tools_concept_id]
      ,[alignment_tools_source_value]
      ,[variant_calling_tools_concept_id]
      ,[variant_calling_tools_source_value]
      ,[annotation_tools_concept_id]
      ,[annotation_tools_source_value]
      ,[annotation_databases_concept_id]
      ,[annotation_databases_source_value]
	  ,[chromosome_coordinate_concept_id]
	  ,[specimen_type_concept_id]
      ,[specimen_type_source_value]
      ,[source_class_concept_id]
      ,[source_class_source_value]
      ,[tumor_purity]
      ,[reference_genome]
      ,[pathologic_diagnosis_concept_id]
      ,[pathologic_diagnosis_source_value]
      ,[staging_T]
      ,[staging_N]
      ,[staging_M]
      ,[stage_reference]
	  ,[collecting_date])
values (0,0,'2017-09-18','2017-09-18',0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0);



----------------------------
-- variant_annotation table
----------------------------
SET IDENTITY_INSERT dbo.variant_annotation ON

INSERT INTO 
dbo.variant_annotation (
	[variant_annotation_id]
      ,[sequencing_id]
      ,[variant_occurrence_id]
      ,[annotation_concept_id]
      ,[annotation_source_value]
      ,[value_as_concept_id]
      ,[value_as_string]
      ,[value_as_number])
values  (0,0,0,0,0,0,0,0);

SET IDENTITY_INSERT dbo.variant_annotation OFF



----------------------------
-- variant_occurence table
----------------------------
SET IDENTITY_INSERT dbo.variant_occurrence ON

INSERT INTO
dbo.variant_occurrence	(
	[variant_occurrence_id]
      ,[person_id]
      ,[sequencing_id]
      ,[chrID]
      ,[position]
      ,[quality_score]
      ,[genotype]
      ,[gene_symbol_concept_id]
      ,[gene_symbol_source_value]
      ,[exon_num]
      ,[hgvs_nomenclature]
      ,[hgvs_p]
      ,[variant_type_concept_id]
      ,[variant_type_source_value]
      ,[read_depth]
      ,[allele_frequency]
      ,[allele_frequency_reference])
values (0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0)

SET IDENTITY_INSERT dbo.variant_occurrence OFF
		