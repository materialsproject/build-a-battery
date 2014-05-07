build-a-battery
===============

interactive battery demo built on meteor
http://build-a-battery.meteor.com/


# Setting up the mongo database

1.  Run `meteor mongo`
2.  In a new terminal window, run `mongorestore -h 127.0.0.1:3001` . Note that '127.0.0.1:3001' would be whatever host is displayed after running `meteor mongo`.
3.  In the mongo shell initialized in step 1, run `db.copyDatabase( "mg_core_dev", "meteor" )`
