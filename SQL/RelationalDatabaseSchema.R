#install.packages("RSQLite")
library(RSQLite)


# open a connection to SQLite and create the RegistrationDB database
db <- dbConnect(SQLite(), dbname="RegistrationDB.sqlite")

# In SQLite foreign key constraints are disabled by default, so they must be enabled for
# each database connection separately by turning pragma foreign_keys=on
dbSendQuery(conn = db, "pragma foreign_keys=on;")

# Create StudentDF, a data frame of students and their information
studentID <- c(12654, 13887, 17625, 18574, 19876)
last_name <- c("Green", "Smith", "King", "Smith", "Smith")
first_name <- c("Linda", "John", "Steven", "James", "Alison")
gender <- c("Female", "Male", "Male", "Male", "Female")
first_enrolled <- c(2010, 2010, 2011, 2011, 2010)
city <- c("Auckland", "Christchurch", "Christchurch", "Christchurch", "Auckland")
degree <- c("Science", "Arts", "Arts", "Science", "Commmerce")
StudentDF <- data.frame(studentID, last_name, first_name, gender, first_enrolled, city, degree)
StudentDF

# Create the Student table, specifying studentID as the PRIMARY KEY
# Since we are specifying a primary ID, there is no need for autoincremented rowid that is
# automatically added by SQLite. Add WITHOUT ROWID to the end of the CREATE TABLE statement.
dbSendQuery(conn = db,  "CREATE TABLE Student (
            studentID INTEGER PRIMARY KEY,
            last_name TEXT,
            first_name TEXT,
            gender TEXT,
            first_enrolled INTEGER,
            city TEXT,
            degree TEXT)
            WITHOUT ROWID")

# insert the StudentDF data frame into the Student table in the RegistrationDB database
# make sure you set row.names=FALSE or else you will get an extra column
dbWriteTable(conn = db, name = "Student", value = StudentDF, row.names=FALSE, append = TRUE)

# check that the Student table was added correctly
dbListTables(db)
dbReadTable(db, "Student")




# Create CourseDF, a data frame of the courses and the examiner
courseID <- c("COMP101", "COMP102", "COMP205", "COMP303")
examiner <- c(1001, 1018, "", 1018)
CourseDF <- data.frame(courseID, examiner)

# Create Course Table, where the courseID is the primary key.
# Add the WITHOUT ROWID statement.
dbSendQuery(conn = db,  "CREATE TABLE Course (
            courseID TEXT PRIMARY KEY,
            examiner INTEGER)
            WITHOUT ROWID")
# insert CourseDF data into Course Table
dbWriteTable(conn = db, name = "Course", value = CourseDF, row.names=FALSE, append=TRUE)

# check that the Course table was added correctly
dbListTables(db)
dbReadTable(db, "Course")




#Create EnrollmentDF, a data frame of student enrollment
studentID <- c(17625, 13887, 19876, 17625, 13887, 17625, 18574)
course <- c(rep("COMP101",3), rep("COMP102", 4))
year <- c(2010, 2010, 2011, 2010, 2011, 2011, 2011)
grade <- c("A", "B", "B", "E", "A", "C", "B")
EnrollmentDF <- data.frame(studentID, course, year, grade)

# Create the Enrollment table, specifying studentID and course as foreign keys.
# In this table there is no column that can be used as a primary ID, so we will have to
# use and autoincremented ROWID as the primary key. Since SQLite does this automatically,
# we don't have to add any extra statements. Just make sure that you DO NOT include the
# WITHOUT ROWID optimization in the CREATE TABLE statement.
dbSendQuery(conn = db,  "CREATE TABLE Enrollment (
            studentID INTEGER,
            course TEXT,
            year INTEGER,
            grade TEXT,
            FOREIGN KEY(studentID) REFERENCES Student(studentID)
            FOREIGN KEY(course) REFERENCES Course(courseID))")

# insert EnrollmentDF data into the Enrollment table.
dbWriteTable(conn = db, name = "Enrollment", value = EnrollmentDF, row.names=FALSE, append=TRUE)

# Check that Enrollment table was added properly
dbListTables(db)
dbReadTable(db, "Enrollment")

## A Note about the ROWIDs.
# We enabled the WITHOUT ROWID optimization for the Student and the Course tables since
# both of these tables had columns that could be intuitively used as a unique identifier
# for information in that table. For the Student table the primary key is the studentID,
# and for the Course table the primary key is the courseID. Since the Enrollment table did
# not have such a column, we used the ROWID as the primary key.
#
# The following two queries demonstrate that the Enrollment table has a ROWID as the
# primary key, wheras the Student and Course tables do not.
dbGetQuery(db, "SELECT ROWID, * FROM Enrollment WHERE grade = 'A'")
dbGetQuery(db, "SELECT ROWID, * FROM Student WHERE last_name = 'Smith'") #return error
dbGetQuery(db, "SELECT ROWID, * FROM Course WHERE courseID = 'COMP101'") # returns error



dbDisconnect(db)

