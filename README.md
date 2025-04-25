# portrait-assessment

To set up and connect to a PostgreSQL database using Docker, I first made sure that Docker and Docker Compose were installed on my system. Then I created a folder as healthcare on my desktop and put all the files from
the repository there.
Then, I created a docker-compose.yml file to define the PostgreSQL service. This docker-compose.yml was given in the repository and I saved it with .yml extension.
After saving the file, I ran the command docker-compose up -d on powershell to start the container. It gave me an error there as i was not inside the directory. I took help from chatGPT to correct it.

Once the service was up and running, the database became accessible at localhost:5432, with the database name set to healthcare, and the default username and password both set to postgres.

Once the connection was made I use DBeaver GUI  to connect to my PostgreSQL database. I created the new connection in it and filled the connection details and I got connected with database.

I installed the dependencies from requirement.txt file and then I loaded the csv files by using python load_data.py command on powershell. 

Once  this  was completed, I was successfully able to connect and load data in Dbeaver.

Patient-level transformations.sql contains the Age group and patient type data  transformation code. For creating the age bucket, as some ages are null of patients so I have taken the average of the ages and replaced the null values with that and then created the age buckets.










