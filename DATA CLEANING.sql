-- Data cleaning

use data_analysis_project;
select * from layoffs;

-- 1. remove duplicate
-- 2.standardize the data
-- 3. NULL VALUE
-- 4. REMOVE ANY COLUMNS is null 

-- COPY THE RAW DATA TO ANOTHER TABLE

create table layoffs_stagging
like layoffs;

select * from layoffs_stagging;


INSERT layoffs_stagging
select * from layoffs;

select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_stagging;

WITH duplicate_cte as (
select *,row_number()over(partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_stagging
)
select * from duplicate_cte where row_num>1;


CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_stagging2
select *,row_number()over(partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_stagging;

delete from layoffs_stagging2 where row_num >1;
select * from layoffs_stagging2;

-- STANDARDIZING data

select distinct(company)
from layoffs_stagging2;

update layoffs_stagging2
set company=trim(company);


select *
from layoffs_stagging2
where industry like 'Crypto%';

update layoffs_stagging2
set industry='Crypto'
where industry like 'Crypto%';

select distinct(country) from layoffs_stagging2;
update layoffs_stagging2
set country=trim(trailing '.' from country)
where country like 'United States%';

select `date`, STR_TO_DATE(`date`,'%m/%d/%Y')
from layoffs_stagging2;

update layoffs_stagging2
set `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_stagging2
modify column `date` DATE;

select * 
from layoffs_stagging2
where industry is null or industry='';


select t1.industry,t2.industry From layoffs_stagging2 t1
join layoffs_stagging t2
on t1.company=t2.company where (t1.industry is null or t1.industry='')
AND t2.industry is not null;

update layoffs_stagging2
set industry=Null
where industry= '' ;
select industry from layoffs_stagging2;

select * from layoffs_stagging2 where company='Airbnb';

update layoffs_stagging2 t1
join layoffs_stagging2 t2
on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null
and t2.industry is not null;

select * from layoffs_stagging2
where company like 'Bally%';

delete from layoffs_stagging2
where total_laid_off is NULL and percentage_laid_off;

select * from layoffs_stagging2

alter table layoffs_stagging2
drop column row_num;

