#Activate Enviornment

export PATH=/N/u/millesaa/Carbonate/miniconda3/envs/variants/bin:$PATH


library(bcftools)

###########
# mpileup #
###########

# BCF is BAM file version and VCF is SAM file equivalent 
# Goal: Differentiate PCR sequencing Error from true SNVs
# Ou outputs uncompressed bcf Ob outputs compressed bcf

bcftools mpileup \
	-Ou -f genome_assembly.fa \
	-o HT29.pileup.bcf HT29_sort.bam
	
########	
# call #
########

bcftools call \
	-m -v -Ou \
	-o HT29.call.bcf HT29.pileup.bcf


# View call vcf file
# bcftools view HT29.call.bcf | less


# Grab every line that doesn't start with # (headers) and count = total number of called variants
bcftools view HT29.call.bcf | grep -v '^#' | wc -l 


########
# Norm #
########

# Tidy's up the indels in VCF file

bcftools norm \
	-Ou -f genome_assembly.fa\
	-d all\
	-o HT29.norm.bcf HT29.call.bcf

##########
# Filter #
##########

# This step can be highly modified
# Excluding variants with a quality less than 40 or a depth of 10 (at least 10 reads mapping to that region)

bcftools filter \
	-Ob \
	-e 'QUAL<40 || DP<10'
	-o HT29.variants.bcf HT29.norm.bcf

# Grab every line that doesn't start with # (headers) and count = total number of called variants - filtered variants
bcftools view HT29.variants.bcf | grep -v '^#' | wc -l 
	
