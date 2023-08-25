select *
from foodproject;

-- product only
select distinct(product)
from foodproject;

-- market only
select distinct(market)
from foodproject;

-- product source (state)
select distinct(state)
from foodproject;

-- shows the product and their prices from 2019- aug,2023
select period_date  , product, value, unit,market
from foodproject
where period_date like '%2023%'or'%2022%' or '%2021%' or '%2020%' or '%2019%'
order by period_date desc;

-- shows the product, their higest price and average between jan,2010 and aug,2023
select product,  MAX(CAST(value AS signed)) as MaxPrices,  avg(CAST(value AS signed)) as AvgPrice, unit,period_date
from foodproject
group by product,unit,period_date
order by product;

-- shows the price of gasoline for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%gasoline%' 
order by period_date desc;

-- shows the price of bread for each week since 2008--
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%bread%' 
order by cast(period_date as date) asc ;

-- shows the price of yam for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product = 'yams' 
order by cast(period_date as date) ;

-- shows the price of abuja yam for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product = 'yam abuja' 
order by cast(period_date as date) ;

-- shows the price of rice(milled) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%milled%' 
order by cast(period_date as date) ;

-- shows the price of rice(5% broken) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%broken%' 
order by cast(period_date as date) ;

-- shows the price of cowpea(brown) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%cowpeas (brown)%'
order by cast(period_date as date) ;

-- shows the price of cowpea(white) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%cowpeas (white)%'
order by cast(period_date as date) ;

-- shows the price of garri(white) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%gari (white)%'
order by cast(period_date as date) ;

-- shows the price of garri(yellow) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%gari (yellow)%'
order by cast(period_date as date) ;

-- shows the price of groundnut for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%groundnuts%'
order by cast(period_date as date) ;

-- shows the price of garri(white) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%gari (white)%'
order by cast(period_date as date) ;

-- shows the price of maize(white) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%maize grain (white)%'
order by cast(period_date as date) ;

-- shows the price of maize(yellow) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%maize grain (yellow)%'
order by cast(period_date as date) ;

-- shows the price of millet for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%millet%'
order by cast(period_date as date) ;

-- shows the price of refined paLM oil for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%palm oil%'
order by cast(period_date as date) ;

-- shows the price of sorghum(white) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%sorghum (white)%'
order by cast(period_date as date) ;

-- shows the price of sorghum(brown) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%sorghum (brown)%'
order by cast(period_date as date) ;

-- shows the price of goat(male) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%goat%'
order by cast(period_date as date) ;

-- shows the price of sheep(male) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%sheep%'
order by cast(period_date as date) ;

-- shows the price of cattle(male) for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%cattle%'
order by cast(period_date as date) ;

-- shows the product, their higest price and average for the last 5 years
select product,MAX(CAST(value AS signed)) MaxPrices ,  avg(CAST(value AS signed)) as AvgPrice, unit,period_date
from foodproject
where period_date like '%2023%'or period_date like '%2022%' or period_date like  '%2021%' or period_date like'%2020%' or period_date like'%2019%'
group by product, unit,period_date
order by product ;

-- shows the price of diesel for each week since 2008
select product,cast(value as signed) , unit, period_date
from foodproject
where product like '%diesel%' 
order by cast(period_date as date) ;
