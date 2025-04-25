# portrait-assessment

To set up and connect to a PostgreSQL database using Docker, I first made sure that Docker and Docker Compose were installed on my system. Then I created a folder as healthcare on my desktop and put all the files from the repository there.
Then, I created a docker-compose.yml file to define the PostgreSQL service. This docker-compose.yml was given in the repository.

After saving the file, I ran the command docker-compose up -d on powershell to start the container.

Once the service was up and running, the database became accessible at localhost:5432, with the database name set to healthcare, and the default username and password both set to postgres.

Once the connection was made I use DBeaver GUI  to connect to my PostgreSQL database. I created the new connection in it and filled the connection details and I got connected with database.

I installed the dependencies from requirement.txt file and then I loaded the csv files by using python load_data.py command on powershell and then I started with my data analysis on DBeaver. Once  this  was completed, I was successfully able to connect and load data in Dbeaver. This is how you can run the sql code.

Files:
**Patient-level transformations.sql** contains the Age group and patient type data  transformation code. 

**Appointment-level transformations.sql** contains the data transforation for patient_id and their latest date of visit and the number of days since their last visit.

**Prescription-level transformations.sql** is the file where the data transformation has been done to take out medication category for medication name and then to check for each patient if it is a first time or a repeat dose. 

The other sql code files are there on which I have taken out the analysis and answered abount the business insights. The result is present in the code files only along with the conclusion that was derived after writing the sql code. 

In the patients.csv file, there were some null ages present for the patient which is not possible. In order to tackle this, I have taken the average age of the patients and replaced the null values with that. 

AI tool was also used at times at the time of setting up the ETL pipeline and taking out some functions on postgress like 
to_char and 
(EXTRACT(YEAR FROM AGE(current_date, registration_date)) * 12 +
        EXTRACT(MONTH FROM AGE(current_date, registration_date))) AS total_months 
  and corr(). 

These functions were taken as reference from the AI tool for doing the data analysis.

In the data analysis part there was a question which asked to  bifurcate medication_name into categories, so I had to use AI to understand about nature of medicines and under which category it should fall. Based on this assumption, I have used case when statements and put the medication under suitable categories and then further did the data analysis on it. You may find this in the **age_group vs category vs max_prescriptions.sql file**.

This dataset was highly engaging, and I genuinely enjoyed working through the assessment.














