############################################
# 20170918 SSJ
# SKT_GCDM Project
# Insert Sample Genomic Data into SQL by R
############################################


##################
# NGS Data Import
##################
dataFolder<-"C:/Users/ssj/Google 드라이브/SK과제_20170911_backup"
library(xlsx)



## Variant Information
variant <- read.xlsx(file.path(dataFolder, "F17-01385-FP_variant.xlsx"), 1)
View(variant)

## Clinical Information
ClinicalData <- read.xlsx(file.path(dataFolder, "NGS clinical data 20170823.xlsx"), 1, encoding='UTF-8')
View(ClinicalData)



## 1. Creat "Sequencing" Data Frame

sequencing <- data.frame(sequencing_id = 1:24,
                         person_id = ClinicalData$등록번호, 
                         collecting_date = strptime(ClinicalData$collecting.date,"%Y%m%d"),
                         collecting_datetime = 
                           paste(strptime(ClinicalData$collecting.date,"%Y%m%d"), '00:00:00.000'),
                         specimen_id = 0,
                         procedure_id = 0,
                         note_id = 0,
                         device_concept_id = 0, 
                         device_source_value = 'Illumina_MiSeq',
                         library_preparation_concept_id = 0,
                         library_preparation_source_value = 'SureSelectXT_ReagentKit_HSQ96',
                         target_capture_concept_id = 0,
                         target_capture_source_value = 'Amplicon/Probe_capture',
                         read_type_concept_id = 0,
                         read_type_source_value = 'Paired-ends',
                         read_length = '100 bp', 
                         alignment_tools_concept_id = 0,
                         alignment_tools_source_value = 'BWA_v0.7.15',
                         variant_calling_tools_concept_id = 0,
                         variant_calling_tools_source_value = 'Vardict/Lumpy/CNVkit',
                         annotation_tools_concept_id = 0,
                         annotation_tools_source_value = 'SnpEff_v4.3',
                         annotation_databases_concept_id = 0,
                         annotation_databases_source_value = 'gnomAD/dbNSFP/ClinVar/COSMIC/dbSNP',
                         chromosome_coordinate_concept_id = 0,
                         type_of_sample_concept_id = 0,
                         type_of_sample_source_value = 'Tissue',
                         source_class_concept_id = 0,
                         source_class_source_value = 'Germline/Somatic/Fetal',
                         tumor_purity = ClinicalData$종양비율....,
                         reference_genome = ClinicalData$reference.genome,
                         pathologic_diagnosis_concept_id = 0,
                         pathologic_diagnosis_source_value = ClinicalData$조직진단,
                         staging_T = ClinicalData$T.stage,
                         staging_N = ClinicalData$N.stage,
                         staging_M = ClinicalData$M.stage,
                         stage_reference = 'SR'
)

head(sequencing)
View(sequencing)

write.xlsx(sequencing, 'C:/Users/ssj/Desktop/SKT_GCDM/GCDM_20170918_SSJ/sequencing.xlsx')








## 2. Creat "variant_occurrence" Data Frame

variant_occurrence <- data.frame(variant_occurrence_id = '1',
                                 person_id = 0,
                                 sequencing_id = 0,
                                 chrID = variant$chrID,
                                 position = variant$pos,
                                 quality_score = variant$qual,
                                 genotype = variant$genotype,
                                 gene_symbol_concept_id = 0,
                                 gene_symbol_source_value = variant$genesymbol,
                                 exon_num = variant$exon_num,
                                 hgvs_nomenclature = variant$hgvs_c,
                                 hgvs_p = variant$hgvs_p,
                                 variant_type_concept_id = 0,
                                 variant_type_source_value = variant$variant_type,
                                 read_depth = variant$dp,
                                 allele_frequency = variant$af,
                                 allele_frequency_reference = '-')
  
head(variant_occurrence)
View(variant_occurrence)

write.xlsx(variant_occurrence, 'C:/Users/ssj/Desktop/SKT_GCDM/GCDM_20170918_SSJ/variant_occurrence.xlsx')

  
  




## 3. Creat "variant_annotation" Data Frame

variant_annotation <- data.frame(variant_annotation_id = 1:219,
                                 person_id = 0,
                                 sequencing_id = 0,
                                 variant_occurrence_id = 0,
                                 annotation_concept_id = 0,
                                 annotation_source_value = c('rsID, variant_function, variant_function_impact, 
                                 feature_type, transcriptID, transcript_type, cdna, cds, aa, distance, lof, 
                                 SIFT, MutationTaster, PolyPhen2'),
                                 value_as_concept_id = 0,
                                 value_as_string = c('rs11121691, synonymous_variant, LOW, 
                                                     transcript, NM_004958.3, protein_coding'),
                                 value_as_number =  0 )

head(variant_annotation)
View(variant_annotation)

write.xlsx(variant_annotation, 'C:/Users/ssj/Desktop/SKT_GCDM/GCDM_20170918_SSJ/variant_annotation.xlsx')








#####################################################################

## Insert Table into SQL

library(SqlRender)
library(DatabaseConnector)


connection <- connect(createConnectionDetails(dbms="sql server",
                                            server="128.1.99.53",
                                            schema="SSJ.dbo",
                                            user="sjshin",
                                            password="@jou1234"))



cdmDatabaseSchema <- "SSJ.dbo"
targettab <- "sequencing"
connection<-connect(connectionDetails)

sql <- "SELECT * FROM @cdmDatabaseSchema.@targettab"
sql <- renderSql(sql,
                 cdmDatabaseSchema=cdmDatabaseSchema,
                 targettab=targettab)$sql
sql <- translateSql(sql,
                    targetDialect=connectionDetails$dbms)$sql
sequencing_table<- querySql(connection, sql)



sqlSave(connection, outputframe, tablename = "sequencing_sqlSave", rownames=FALSE, append = TRUE)

library(RODBC)
specificDB= odbcConnect(dsn ='SSJ',uid = 'sjshin', pwd = '@jou1234')
sqlSave(specificDB, sequencing, "sequencing_bysqlSave", safer=FALSE, append=TRUE)


# 1. sequencing table
sql <- translateSql("SELECT * FROM SSJ.dbo.sequencing", 
                    targetDialect=connectionDetails$dbms)$sql

sequencing_table <- querySql(connection, sql)
colnames(sequencing_table)
head(sequencing_table)

head(sequencing)
View(sequencing)


library(sqldf)

sqldf("INSERT INTO sequencing (sequencing_id, person_id, 
                                        collecting_date, collecting_datetime, 
                                        
                                        specimen_id, procedure_id, note_id, 
                                        device_concept_id, device_source_value,
                                        library_preparation_concept_id, library_preparation_source_value,
                                        
                                        target_capture_concept_id, target_capture_source_value,
                                        read_type_concept_id, read_type_source_value, read_length,
                                        
                                        alignment_tools_concept_id, alignment_tools_source_value,
                                        variant_calling_tools_concept_id, variant_calling_tools_source_value,
                                        
                                        annotation_tools_concept_id, annotation_tools_source_value,
                                        annotation_databases_concept_id, annotation_databases_source_value,
                                        
                                        chromosome_coordinate_concept_id, 
                                        
                                        type_of_sample_concept_id, type_of_sample_source_value, 
                                        source_class_concept_id, source_class_source_value, 
                                        
                                        tumor_purity, reference_genome,
                                        pathologic_diagnosis_concept_id, pathologic_diagnosis_source_value,
                                        
                                        staging_T, staging_N, staging_M, stage_reference)
          
                        VALUES (1:24, ClinicalData$등록번호, 
                               strptime(ClinicalData$collecting.date, '%Y%m%d'),
                               paste(strptime(ClinicalData$collecting.date,'%Y%m%d'), '00:00:00.000'), 
                               
                               0, 0, 0, 
                               0, Illumina_MiSeq, 
                               0, SureSelectXT_ReagentKit_HSQ96,
                               
                               0, Amplicon/Probe_capture, 
                               0, Paired-ends, 100 bp, 
                               
                               0, BWA_v0.7.15,
                               0, Vardict/Lumpy/CNVkit,
                               
                               0, SnpEff_v4.3,
                               0, gnomAD/dbNSFP/ClinVar/COSMIC/dbSNP,
                               
                               0,
                               
                               0, Tissue,
                               0, Germline/Somatic/Fetal,
                               
                               ClinicalData$종양비율...., ClinicalData$reference.genome,
                               0, ClinicalData$조직진단,
                               
                               ClinicalData$T.stage, ClinicalData$N.stage, ClinicalData$M.stage, 0)")

querySql (connection, 'INSERT INTO sequencing (sequencing_id, person_id, 
                                        collecting_date, collecting_datetime, 
                                        
                                        specimen_id, procedure_id, note_id, 
                                        device_concept_id, device_source_value,
                                        library_preparation_concept_id, library_preparation_source_value,
                                        
                                        target_capture_concept_id, target_capture_source_value,
                                        read_type_concept_id, read_type_source_value, read_length,
                                        
                                        alignment_tools_concept_id, alignment_tools_source_value,
                                        variant_calling_tools_concept_id, variant_calling_tools_source_value,
                                        
                                        annotation_tools_concept_id, annotation_tools_source_value,
                                        annotation_databases_concept_id, annotation_databases_source_value,
                                        
                                        chromosome_coordinate_concept_id, 
                                        
                                        type_of_sample_concept_id, type_of_sample_source_value, 
                                        source_class_concept_id, source_class_source_value, 
                                        
                                        tumor_purity, reference_genome,
                                        pathologic_diagnosis_concept_id, pathologic_diagnosis_source_value,
                                        
                                        staging_T, staging_N, staging_M, stage_reference)
          
                        VALUES (c(1:24), ClinicalData$등록번호, 
                               strptime(ClinicalData$collecting.date,"%Y%m%d"),
                               paste(strptime(ClinicalData$collecting.date,"%Y%m%d"), 00:00:00.000), 
                               
                               0, 0, 0, 
                               0, Illumina_MiSeq, 
                               0, SureSelectXT_ReagentKit_HSQ96,
                               
                               0, Amplicon/Probe_capture, 
                               0, Paired-ends, 100 bp, 
                               
                               0, BWA_v0.7.15,
                               0, Vardict/Lumpy/CNVkit,
                               
                               0, SnpEff_v4.3,
                               0, gnomAD/dbNSFP/ClinVar/COSMIC/dbSNP,
                               
                               0,
                               
                               0, Tissue,
                               0, Germline/Somatic/Fetal,
                               
                               ClinicalData$종양비율...., ClinicalData$reference.genome,
                               0, ClinicalData$조직진단,
                               
                               ClinicalData$T.stage, ClinicalData$N.stage, ClinicalData$M.stage, 0)')  
                              
                                                                                                 
                                                                                                                                                                 
                                                                                                 
                 

                                

  








# 2. variant_occurrence table
sql <- translateSql("SELECT * FROM SSJ.dbo.variant_occurrence", 
                    targetDialect=connectionDetails$dbms)$sql

variant_occurrence_table <- querySql(connection, sql)
head(variant_occurrence_table)





# 3. variant_annotation table
sql <- translateSql("SELECT * FROM SSJ.dbo.variant_annotation", 
                    targetDialect=connectionDetails$dbms)$sql

variant_annotation_table <- querySql(connection, sql)
head(variant_annotation_table)





#executeSql(connection, sql)






#####################################################################

install.packages('sqldf')
library(sqldf)
set.seed(42)

df1 = data.frame(id=1:10, class=rep(c('case', 'ctrl'), 5))
df2 = data.frame(id=1:10, cov=round(runif(10)*10, 1))

sqldf('SELECT * from df1 join df2 on df1.id=df2.id')


library(RODBC)
con <- odbcDriverConnect()











