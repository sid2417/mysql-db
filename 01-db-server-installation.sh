#!/bin/bash/

#sudo access #colors # logfile # timestamp
#DB server installation

USERID=$(id -u)
TIME_STAMP=$(date +%F-%H-%M-%S)
SRCIPT_NAME=$(echo "$0" | cut -d "." -f1)
LOG_FILE=/tmp/$SRCIPT_NAME/$TIME_STAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


if [ $USERID -ne 0 ]
then
    echo -e "$R Please Provide Super User Access $N"
    exit 1
else
    echo -e "$G You Already Have sudo Access $N"
fi

VALIDATE ()
{
    if [ $1 -ne 0 ]
then 
    echo -e "$2 ... $R FAILED $N"
    exit 1
 else
    echo -e "$2 ... $G SUCCESS $N"
fi

}

dnf install mysql-server -y &>>LOG_FILE
VALIDATE $? "MySql Server Installation"

systemctl enable mysqld &>>LOG_FILE
VALIDATE $? "Enabling MySql server"

systemctl start mysqld &>>LOG_FILE
VALIDATE $? "Starting MySql server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>LOG_FILE
VALIDATE $? "Password Setup for MySql server"


echo -e "$G DB MySql Server Installation was going smoothly..Thankyou $N"

