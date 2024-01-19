# Feeding-Experiment supplentary data and scripts

An overview of the data, scripts, and results can be consulted at the following address

<center>https://renin-project.github.io/Feeding-Experiment/</center>

## Directory contents

### Data

#### Sample metadata

- [`metadata.csv`](Data/Faeces/metadata.csv) : Description of the samples
    + `sample_id` : unique sample identifier
    + `Animal_ID` : animal identifier (one letter code)
    + `Sample_number` : ordered numerical id of the sample
    + `Date` : sample collection data
    + `Sample_time` : sample collection time
    + `times_from_birch` : Ellapsed time since the providing of the birch
    + `Fed_biomass` : Amount of lichen provided before this sample was collected

#### The curated data sets

The curated data sets (see the filtering repports below)
are stored into the `Data/Faeces` directory

They are all coma separated values files (.csv)

- For the `Euka02` marker
  + [`FE.Eukaryota.samples.motus.csv`](Data/Faeces/FE.Eukaryota.samples.motus.csv)   : the MOTU descriptions table
  + [`FE.Eukaryota.samples.samples.csv`](Data/Faeces/FE.Eukaryota.samples.samples.csv) : the sample descriptions table
  + [`FE.Eukaryota.samples.reads.csv`](Data/Faeces/FE.Eukaryota.samples.reads.csv)   : the MOTUs x sample contengency table
- For the `Sper01` marker
  + [`FE.Spermatophyta.samples.motus.csv`](Data/Faeces/FE.Spermatophyta.samples.motus.csv)   : the MOTU descriptions table
  + [`FE.Spermatophyta.samples.samples.csv`](Data/Faeces/FE.Spermatophyta.samples.samples.csv) : the sample descriptions table
  + [`FE.Spermatophyta.samples.reads.csv`](Data/Faeces/FE.Spermatophyta.samplesreads.csv)   : the MOTUs x sample contengency table

#### Raw data

The complete raw data are too large to be placed on GitHub, and cannot be easily deposited on the SRA servers because many samples are multiplexed in each sequencing library. Files containing the most possible raw data were produced from the raw sequencing files and uploaded to the GitHub server. They consist of three fasta files annotated following the *OBITools* format. The three steps of processing that allowed their construction are : 

- The initial forward and reverse files were assembled by `illuminapairedends`
- The resulting file was dereplicated using `obiuniq`
- The sequences appearing only once in the whole experiment (singletons) were discarded using `obigrep`.
  
The three *almost* raw data sequence files compressed by bzip2 are stored in the directory corresponding to each marker:

- `chlo01.no_singleton.fasta.bz`
- `chlo02.no_singleton.fasta.bz`
- `euka03.no_singleton.fasta.bz`

Raw data statistics are available for each markers.

- `chlo01`
  + `chlo01.length.stat` : stats on the amplicon lenght
  + `chlo01.max_per_sample.stat` : stats on the maximum occurrence of a MOTUs in a PCR
- chlo02
  + `chlo02.length.stat` : stats on the amplicon lenght
  + `chlo02.max_per_sample.stat` : stats on the maximum occurrence of a MOTUs in a PCR
- euka03
  + `euka03.length.stat` : stats on the amplicon lenght
  + `euka03.max_per_sample.stat` : stats on the maximum occurrence of a MOTUs in a PCR

### Data analysis

#### Preprocessing of the raw data by OBITools

`obitools_processing.sh` resumes the obitools commands used to process to raw fastq files
to a preliminary MOTU table per PCR.

#### Filtering of the raw data 

Resumes the filtering of the preliminary MOTU table per PCR produced
by obitools to build the MOTU table used for ecological analysis

A RMarkdown resumes the filtering for each marker

- `SPER01_Filtering.Rmd`
- `EUKA02_Filtering.Rmd`

And the corresponding HTML files (the ones to look over)

- [`SPER01_Filtering.html`](SPER01_Filtering.html)
- [`EUKA02_Filtering.html`](EUKA02_Filtering.html)

The gererated curated data tables are stored in the
directory [`Data/Faeces`](Data/Faeces)