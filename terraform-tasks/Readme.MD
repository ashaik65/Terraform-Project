Before that on that machine install mysql client libarires

sudo apt install mysql-client-core-8.0 

To connect RDS instnace from private EC2 Instance follow this command

mysql -h my-rds-instance.cdzf1maza99o.us-east-1.rds.amazonaws.com -P 3306 -u admin -p