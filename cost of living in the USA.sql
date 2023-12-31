-- creating the table to receive dataset
create table cost_of_living_us
(case_id int,
state varchar(10),
isMetro varchar(10),
county varchar(50),
family_member varchar(10),
housing_cost int,
food_cost int,
transportation_cost int,
healthcare_cost int,
other_cost int,
childcare_cost int,
taxes int,
total_cost int,
median_family_income int
);

-- importing the dataset into sql
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cost_of_living_us.csv'
into table cost_of_living_us
fields terminated by ','
enclosed by'"'
lines terminated by '\n'
ignore 1 rows;

select * from cost_of_living_us;

-- DATA CLEANING --------------------

-- checking for duplicate rows ---
SELECT case_id,state_code,county,housing_cost,food_cost,transportation_cost,healthcare_cost,other_cost,childcare_cost,taxes,total_cost, COUNT(*)
FROM cost_of_living_us
group by case_id,state_code,county,housing_cost,food_cost,transportation_cost,healthcare_cost,other_cost,childcare_cost,taxes,total_cost
HAVING COUNT(*) > 1;

-- to change the name of the column state to state code-
alter table cost_of_living_us
change column state state_code text;

-- to get all state code in order to create the name of states--
select distinct state_code from cost_of_living_us;

-- to create a new column for name of states--
alter table cost_of_living_us
add column state varchar(50);

-- trimming the joining column to avoid returning 0 rows affected when updating the new column
update state_code_et_name
set state_code_et_name.state_code= trim(state_code_et_name.state_code);

-- to insert the state names into the created column
update cost_of_living_us col
inner join state_code_et_name stc
on col.state_code= stc.state_code
set col.state=stc.state;

-- creating new columns for children and parent counts
alter table cost_of_living_us
add column no_of_parents int, add column no_of_children int;

-- to split the family_member column into the parents and children column
update cost_of_living_us
set no_of_parents= substr(family_member,1,1),
no_of_children= substr(family_member,3,1);

-- deleting the family_member column
alter table cost_of_living_us
drop column family_member;

-- to trim the children and parents column
update cost_of_living_us
set no_of_children = trim(no_of_children),
no_of_parents = trim(no_of_parents) ;


-- DATA EXPLORATIONG ----------

-- how many counties are in the sample? 
select count(distinct concat(county,' ',state_code) )
from cost_of_living_us;

-- what counties are metro city?
select distinct concat(county,' ',state_code) as MetroCityCounties, state
from cost_of_living_us
where ismetro='true'
order by state asc;

select count(distinct concat(county,' ',state_code) ) MetroCityCounties_Count
from cost_of_living_us
where ismetro='true';

-- what are the top 5 counties with the highest average income?
select distinct concat(county,' ',state_code) counties, state , max(median_family_income) HighestAvgIncome
from cost_of_living_us
group by counties, state
order by HighestAvgIncome desc
limit 5;

-- what are the top 5 most expensive counties?
select distinct concat(county,' ',state_code) counties, state , max(total_cost) TotalCost
from cost_of_living_us
group by counties, state
order by TotalCost desc
limit 5;

-- what are the top 5 least expensive counties?
select distinct concat(county,' ',state_code) counties, state , min(total_cost) TotalCost
from cost_of_living_us
group by counties, state
order by TotalCost asc
limit 5;

-- what are the top 5 counties with least cost of housing?
select distinct concat(county,' ',state_code) counties,state, min(housing_cost) as HousingCost
from cost_of_living_us
group by counties,state
order by HousingCost asc
limit 5;

-- what are the top 5 counties with least cost of feeding?
select  concat(county,' ',state_code) counties,state, min(food_cost) as FeedingCost
from cost_of_living_us
group by counties,state
order by FeedingCost asc
limit 5;

-- what are the top 5 counties with least cost of transportation?
select distinct concat(county,' ',state_code) counties, state, min(transportation_cost) as TransportationCost
from cost_of_living_us
group by counties, state
order by TransportationCost asc
limit 5;

-- what are the top 5 counties with least cost of healthcare?
select distinct concat(county,' ',state_code) counties,state, min(healthcare_cost) as HealthCareCost
from cost_of_living_us
group by counties, state
order by HealthCareCost asc
limit 5;

-- what are the top 5 counties with the lowest taxes?
select distinct concat(county,' ',state_code) counties ,state, min(taxes) as Taxes
from cost_of_living_us
group by counties, state
order by taxes asc
limit 5;

-- what is the number of individuals(parents and children) accounted for,by state?
select state ,sum(no_of_parents) as TotalNumberOfParents,sum(no_of_children) as TotalNumberOfChildren , sum(no_of_children + no_of_parents) Total
from cost_of_living_us
group by state
order by 3 desc;

-- what is the total number of individual in the survey?
select sum(Total) TotalIndividual
from (select state ,sum(no_of_parents) as TotalNumberOfParents,sum(no_of_children) as TotalNumberOfChildren , sum(no_of_children + no_of_parents) Total
from cost_of_living_us
group by state) TT;

-- money after expenses & percentage of money spent
select county, median_family_income, total_cost, (median_family_income - total_cost) AfterExpenses, (total_cost/median_family_income)*100 as ExpensesPercent
from cost_of_living_us
group by county, median_family_income, total_cost;

-- what counties spend 70% or below of their income?
select distinct concat(county,' ',state_code) counties, sum(total_cost) CostOfLiving, sum(median_family_income) TotalFamiliesIncome, sum(total_cost)/sum(median_family_income)*100 PercentExpenses
from cost_of_living_us
where (total_cost)/(median_family_income)*100  <= 70
group by counties
order by TotalFamiliesIncome desc;

select count(counties)
from
(select distinct concat(county,' ',state_code) counties, sum(total_cost) CostOfLiving, sum(median_family_income) TotalFamiliesIncome, sum(total_cost)/sum(median_family_income)*100 PercentExpenses
from cost_of_living_us
where (total_cost)/(median_family_income)*100  <= 70
group by counties
order by TotalFamiliesIncome desc) Above70Percent;


-- what counties spend above their income?
select distinct concat(county,' ',state_code) counties, sum(total_cost) CostOfLiving, sum(median_family_income) TotalFamiliesIncome, sum(total_cost)/sum(median_family_income)*100 PercentExpenses
from cost_of_living_us
where (total_cost)/(median_family_income)*100  >=100
group by counties
order by TotalFamiliesIncome desc;

select count(counties)
from
(select distinct concat(county,' ',state_code) counties, sum(total_cost) CostOfLiving, sum(median_family_income) TotalFamiliesIncome, sum(total_cost)/sum(median_family_income)*100 PercentExpenses
from cost_of_living_us
where (total_cost)/(median_family_income)*100  >= 100
group by counties
order by TotalFamiliesIncome desc) Above70Percent;

-- what is the number of families spending more than their avg income?
select count(AfterExpenses) OverSpendingFamilies
from (select county, median_family_income, total_cost, (median_family_income - total_cost) AfterExpenses, (total_cost/median_family_income)*100 as ExpensesPercent
from cost_of_living_us
group by county, median_family_income, total_cost) ms
where total_cost > median_family_income;

-- how many families budget are below the federal poverty line(FPL)?
-- (The 2023 FPL for a single person residing in the 48 contiguous states or Washington, D.C. is $14,580)
select  count(case_id)
from cost_of_living_us
where median_family_income < (no_of_children+no_of_parents)*14580 ;

-- what counties are affordable for a family of 4 0r more?
SELECT distinct concat(county,' ',state_code) counties, state
FROM cost_of_living_us
where (no_of_children + no_of_parents)>=4 and total_cost < median_family_income;

SELECT count(distinct concat(county,' ',state_code) )
FROM cost_of_living_us
where (no_of_children + no_of_parents)>4 and total_cost < median_family_income;

-- what counties are recommended for families with over 2 children?
select county, total_cost, median_family_income
FROM cost_of_living_us
where no_of_children>=3 and total_cost < median_family_income;

-- what counties are recommended for families of upto 6?
select county
FROM cost_of_living_us
where total_cost < median_family_income and (no_of_children + no_of_parents)=6;

-- what counties are most recommended for families of upto 6 and intends to save 10% or more of their income?
select county, median_family_income, total_cost, median_family_income-total_cost as savings, 0.1*median_family_income 10_PercentOfIncome
FROM cost_of_living_us
where  median_family_income-total_cost >= 0.1*median_family_income and (no_of_children + no_of_parents)=6
order by 10_PercentOfIncome desc;

-- what counties are most recommended for families of upto 6 and intends to save 20% or more of their income?
select distinct county, median_family_income, total_cost, median_family_income-total_cost as savings, 0.2*median_family_income 20_PercentOfIncome
FROM cost_of_living_us
where  median_family_income-total_cost >= 0.2*median_family_income and (no_of_children + no_of_parents)=6
order by 20_PercentOfIncome desc;
