-- Exploratory Data analysis
 
use data_analysis_project;
select * from layoffs_stagging2;

select company,sum(total_laid_off)
from layoffs_stagging2
group by company order by 2 desc;

select min(`date`),max(`date`) from 
layoffs_stagging2;

select industry,sum(total_laid_off)
from layoffs_stagging2
group by industry order by 2 desc;

select country,sum(total_laid_off)
from layoffs_stagging2
group by country order by 2 desc;

select year(`date`),sum(total_laid_off)
from layoffs_stagging2 group by year(`date`) order by sum(total_laid_off) desc;
 
select stage,sum(total_laid_off) from layoffs_stagging2
group by stage order by 2 desc;

select substring(`date`,1,7) as `Month`,sum(total_laid_off)
from layoffs_stagging2
where  substring(`date`,1,7) is not null
group by `Month` order by 1 asc;

with Rolling_total as
(
select substring(`date`,1,7) as `Month`,sum(total_laid_off) as total_off
from layoffs_stagging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc
)
select `Month`,total_off,sum(total_off) over(order by `Month`) as rollinng_total
from Rolling_total; 

select company,year(`date`),sum(total_laid_off)
from layoffs_stagging2
group by company,year(`date`)
order by 3 desc;

with Company_year(company,years,total_laid_off) as
( 
select company,year(`date`),sum(total_laid_off)
from layoffs_stagging2
group by company,year(`date`)
), 
company_year_ranks as
(select *,dense_rank() over(partition by years order by total_laid_off desc) as ranking
from Company_year
where years is not null)
select * from company_year_ranks
where ranking <=5;