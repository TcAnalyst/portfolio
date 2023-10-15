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

select * from cost_of_living_us;

-- DATA CLEANING -------------------------------------

-- to change the name of the column state to state code-
alter table cost_of_living_us
change column states states text;

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

-- DATA EXPLORATIONG ----------

-- number of samples 
select count(case_id)
from cost_of_living_us;

-- counties that are metro city
select distinct county as MetroCityCounties, state
from cost_of_living_us
where ismetro='true'
order by state asc;

select count(distinct county) isMetroCounty_Count
from cost_of_living_us
where ismetro='true';

-- lowest cost of housing in every county
select  state, county, max(housing_cost)
from cost_of_living_us
group by state, county, housing_cost
order by housing_cost asc;

-- lowest cost of feeding in every county
select  state, county, max(food_cost)
from cost_of_living_us
group by state, county, food_cost
order by food_cost asc;

-- lowest cost of transportation in every county
select  state, county, max(transportation_cost)
from cost_of_living_us
group by state, county, transportation_cost
order by transportation_cost asc;

-- lowest cost of health care in every county
select  state, county, max(healthcare_cost)
from cost_of_living_us
group by state, county, healthcare_cost
order by healthcare_cost asc;

-- lowest taxes in every county
select  state, county, max(taxes)
from cost_of_living_us
group by state, county, taxes
order by taxes asc;

-- number of individuals(parents and children) accounted for in each state
select state ,sum(no_of_parents) as TotalNumberOfParents,sum(no_of_children) as TotalNumberOfChildren , sum(no_of_children + no_of_parents) Total
from cost_of_living_us
group by state
order by 3 desc;

-- total number of individual in the survey
select sum(Total) TotalIndividual
from (select state ,sum(no_of_parents) as TotalNumberOfParents,sum(no_of_children) as TotalNumberOfChildren , sum(no_of_children + no_of_parents) Total
from cost_of_living_us
group by state) TT;

-- money after expenses & percentage of money spent
select county, median_family_income, total_cost, (median_family_income - total_cost) AfterExpenses, (total_cost/median_family_income)*100 as ExpensesPercent
from cost_of_living_us
group by county, median_family_income, total_cost;

-- number of families spending more than the avg income
select count(AfterExpenses) OverSpendingFamilies
from (select county, median_family_income, total_cost, (median_family_income - total_cost) AfterExpenses, (total_cost/median_family_income)*100 as ExpensesPercent
from cost_of_living_us
group by county, median_family_income, total_cost) ms
where total_cost > median_family_income;

-- counties affordable for a family of 4 0r more
SELECT distinct county, state
FROM cost_of_living_us
where (no_of_children + no_of_parents)>=4 and total_cost < median_family_income;

SELECT count(distinct county)
FROM cost_of_living_us
where (no_of_children + no_of_parents)>4 and total_cost < median_family_income;

-- counties recommended for families with over 2 children
select county, total_cost, median_family_income
FROM cost_of_living_us
where no_of_children>=3 and total_cost < median_family_income;

-- counties recommended for families of all sizes
select distinct county
FROM cost_of_living_us
where total_cost < median_family_income and (no_of_children + no_of_parents)=6;

